From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v6 5/5] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Date: Thu, 3 Jun 2021 18:36:11 -0700
Message-ID: <YLmDi27fSD4bRbQM@carbon.lan>
References: <20210603005517.1403689-1-guro@fb.com>
 <20210603005517.1403689-6-guro@fb.com>
 <20210603100233.GG23647@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=S1L0ue23Urr+6rn6rGgKO/9RSY4H5BcOTxUoz+3/F4A=;
 b=d3NNls/gIASXFqKhk+fx2Jmx3T+vse5sUCGPPWV2731JjogLiqVxIQMlLz4YXTCqbU/H
 nizg36QInYQrsO5s0PlhYwIIBHojoft6kv1b2sWuFnrL4X/s+gZiC43c8QH1ETEebXAy
 jbQjxEixOO8D97ACDMwnbqfFXoW2Saa2az4= 
Content-Disposition: inline
In-Reply-To: <20210603100233.GG23647-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 03, 2021 at 12:02:33PM +0200, Jan Kara wrote:
> On Wed 02-06-21 17:55:17, Roman Gushchin wrote:
> > Asynchronously try to release dying cgwbs by switching attached inodes
> > to the bdi's wb. It helps to get rid of per-cgroup writeback
> > structures themselves and of pinned memory and block cgroups, which
> > are significantly larger structures (mostly due to large per-cpu
> > statistics data). This prevents memory waste and helps to avoid
> > different scalability problems caused by large piles of dying cgroups.
> > 
> > Reuse the existing mechanism of inode switching used for foreign inode
> > detection. To speed things up batch up to 115 inode switching in a
> > single operation (the maximum number is selected so that the resulting
> > struct inode_switch_wbs_context can fit into 1024 bytes). Because
> > every switching consists of two steps divided by an RCU grace period,
> > it would be too slow without batching. Please note that the whole
> > batch counts as a single operation (when increasing/decreasing
> > isw_nr_in_flight). This allows to keep umounting working (flush the
> > switching queue), however prevents cleanups from consuming the whole
> > switching quota and effectively blocking the frn switching.
> > 
> > A cgwb cleanup operation can fail due to different reasons (e.g. not
> > enough memory, the cgwb has an in-flight/pending io, an attached inode
> > in a wrong state, etc). In this case the next scheduled cleanup will
> > make a new attempt. An attempt is made each time a new cgwb is offlined
> > (in other words a memcg and/or a blkcg is deleted by a user). In the
> > future an additional attempt scheduled by a timer can be implemented.
> > 
> > Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> I think we are getting close :). Some comments are below.

Great! Thank for reviewing the code!

> 
> > ---
> >  fs/fs-writeback.c                | 68 ++++++++++++++++++++++++++++++++
> >  include/linux/backing-dev-defs.h |  1 +
> >  include/linux/writeback.h        |  1 +
> >  mm/backing-dev.c                 | 58 ++++++++++++++++++++++++++-
> >  4 files changed, 126 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 49d7b23a7cfe..e8517ad677eb 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -225,6 +225,8 @@ void wb_wait_for_completion(struct wb_completion *done)
> >  					/* one round can affect upto 5 slots */
> >  #define WB_FRN_MAX_IN_FLIGHT	1024	/* don't queue too many concurrently */
> >  
> > +#define WB_MAX_INODES_PER_ISW	116	/* maximum inodes per isw */
> > +
> 
> Why this number? Please add an explanation here...

Added.

> 
> >  static atomic_t isw_nr_in_flight = ATOMIC_INIT(0);
> >  static struct workqueue_struct *isw_wq;
> >  
> > @@ -552,6 +554,72 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
> >  	kfree(isw);
> >  }
> >  
> > +/**
> > + * cleanup_offline_cgwb - detach associated inodes
> > + * @wb: target wb
> > + *
> > + * Switch all inodes attached to @wb to the bdi's root wb in order to eventually
> > + * release the dying @wb.  Returns %true if not all inodes were switched and
> > + * the function has to be restarted.
> > + */
> > +bool cleanup_offline_cgwb(struct bdi_writeback *wb)
> > +{
> > +	struct inode_switch_wbs_context *isw;
> > +	struct inode *inode;
> > +	int nr;
> > +	bool restart = false;
> > +
> > +	isw = kzalloc(sizeof(*isw) + WB_MAX_INODES_PER_ISW *
> > +		      sizeof(struct inode *), GFP_KERNEL);
> > +	if (!isw)
> > +		return restart;
> > +
> > +	/* no need to call wb_get() here: bdi's root wb is not refcounted */
> > +	isw->new_wb = &wb->bdi->wb;
> > +
> > +	nr = 0;
> > +	spin_lock(&wb->list_lock);
> > +	list_for_each_entry(inode, &wb->b_attached, i_io_list) {
> > +		spin_lock(&inode->i_lock);
> > +		if (!(inode->i_sb->s_flags & SB_ACTIVE) ||
> > +		    inode->i_state & (I_WB_SWITCH | I_FREEING) ||
> > +		    inode_to_wb(inode) == isw->new_wb) {
> > +			spin_unlock(&inode->i_lock);
> > +			continue;
> > +		}
> > +		inode->i_state |= I_WB_SWITCH;
> > +		__iget(inode);
> > +		spin_unlock(&inode->i_lock);
> 
> This hunk is identical with the one in inode_switch_wbs(). Maybe create a
> helper for it like inode_prepare_wb_switch() or something like that. Also
> we need to check for I_WILL_FREE flag as well as I_FREEING (see the code in
> iput_final()) - that's actually a bug in inode_switch_wbs() as well so
> probably a separate fix for that should come earlier in the series.

Good point, added in v7.

> 
> > +
> > +		isw->inodes[nr++] = inode;
> 
> At first it seemed a bit silly to allocate an array of inode pointers when
> we have them in the list. But after some thought I agree that dealing with
> other switching being triggered from other sources in parallel would be
> really difficult so your decision makes sense. Just maybe add an
> explanation in a comment somewhere about this design decision.

Added in v7.

> 
> > +
> > +		if (nr >= WB_MAX_INODES_PER_ISW - 1) {
> > +			restart = true;
> > +			break;
> > +		}
> > +	}
> > +	spin_unlock(&wb->list_lock);
> 
> ...
> 
> > +static void cleanup_offline_cgwbs_workfn(struct work_struct *work)
> > +{
> > +	struct bdi_writeback *wb;
> > +	LIST_HEAD(processed);
> > +
> > +	spin_lock_irq(&cgwb_lock);
> > +
> > +	while (!list_empty(&offline_cgwbs)) {
> > +		wb = list_first_entry(&offline_cgwbs, struct bdi_writeback,
> > +				      offline_node);
> > +		list_move(&wb->offline_node, &processed);
> > +
> > +		if (wb_has_dirty_io(wb))
> > +			continue;
> 
> Maybe explain in a comment why skipping wbs with dirty inodes is fine?
> Because honestly, I'm not sure... I guess the rationale is that inodes
> should get cleaned eventually and if they are getting redirtied, they will
> be switched to another wb anyway?

The main rationale here is that the deletion of a memory/blkcg cgroup by a user
shouldn't affect the io distribution. In other words, the remaining io shouldn't
be performed faster than it could be finished had the cgroup remain existing.
