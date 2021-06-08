From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v8 8/8] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Date: Tue, 8 Jun 2021 15:37:19 -0700
Message-ID: <YL/xH+DBAYWM6eXK@carbon.dhcp.thefacebook.com>
References: <20210608013123.1088882-1-guro@fb.com>
 <20210608013123.1088882-9-guro@fb.com>
 <YL+WC5beBH/N0ddz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Dv5K3FCh4Nz9BS19ove+HX0OGpQWhODHlhR95WzQE0E=;
 b=BYEhbg5sqmxZDloEBAgGOU9FG9Vs0oQwpf7+gz221WAPskOG/rn7xID7IUc39MZDAMuD
 o1gtNf6iHuZEYoJjLSCiNw2LlP+QDh4gZGiDkzr7X881ZpGSc+nS226jZf3Pqt6zB+ol
 +Dn4skC1XiJBDdIvJsELIg0th5v0NdmDZU0= 
Content-Disposition: inline
In-Reply-To: <YL+WC5beBH/N0ddz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 08, 2021 at 04:08:43PM +0000, Dennis Zhou wrote:
> Hello,
> 
> On Mon, Jun 07, 2021 at 06:31:23PM -0700, Roman Gushchin wrote:
> > Asynchronously try to release dying cgwbs by switching attached inodes
> > to the nearest living ancestor wb. It helps to get rid of per-cgroup
> > writeback structures themselves and of pinned memory and block cgroups,
> > which are significantly larger structures (mostly due to large per-cpu
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
> > Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Acked-by: Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  fs/fs-writeback.c                | 102 ++++++++++++++++++++++++++++---
> >  include/linux/backing-dev-defs.h |   1 +
> >  include/linux/writeback.h        |   1 +
> >  mm/backing-dev.c                 |  67 +++++++++++++++++++-
> >  4 files changed, 159 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 737ac27adb77..96eb6e6cdbc2 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -225,6 +225,12 @@ void wb_wait_for_completion(struct wb_completion *done)
> >  					/* one round can affect upto 5 slots */
> >  #define WB_FRN_MAX_IN_FLIGHT	1024	/* don't queue too many concurrently */
> >  
> > +/*
> > + * Maximum inodes per isw.  A specific value has been chosen to make
> > + * struct inode_switch_wbs_context fit into 1024 bytes kmalloc.
> > + */
> > +#define WB_MAX_INODES_PER_ISW	115
> > +
> >  static atomic_t isw_nr_in_flight = ATOMIC_INIT(0);
> >  static struct workqueue_struct *isw_wq;
> >  
> > @@ -503,6 +509,24 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
> >  	atomic_dec(&isw_nr_in_flight);
> >  }
> >  
> > +static bool inode_prepare_wbs_switch(struct inode *inode,
> > +				     struct bdi_writeback *new_wb)
> > +{
> > +	/* while holding I_WB_SWITCH, no one else can update the association */
> > +	spin_lock(&inode->i_lock);
> > +	if (!(inode->i_sb->s_flags & SB_ACTIVE) ||
> > +	    inode->i_state & (I_WB_SWITCH | I_FREEING | I_WILL_FREE) ||
> > +	    inode_to_wb(inode) == new_wb) {
> > +		spin_unlock(&inode->i_lock);
> > +		return false;
> > +	}
> > +	inode->i_state |= I_WB_SWITCH;
> > +	__iget(inode);
> > +	spin_unlock(&inode->i_lock);
> > +
> > +	return true;
> > +}
> > +
> >  /**
> >   * inode_switch_wbs - change the wb association of an inode
> >   * @inode: target inode
> > @@ -540,17 +564,8 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
> >  	if (!isw->new_wb)
> >  		goto out_free;
> >  
> > -	/* while holding I_WB_SWITCH, no one else can update the association */
> > -	spin_lock(&inode->i_lock);
> > -	if (!(inode->i_sb->s_flags & SB_ACTIVE) ||
> > -	    inode->i_state & (I_WB_SWITCH | I_FREEING | I_WILL_FREE) ||
> > -	    inode_to_wb(inode) == isw->new_wb) {
> > -		spin_unlock(&inode->i_lock);
> > +	if (!inode_prepare_wbs_switch(inode, isw->new_wb))
> >  		goto out_free;
> > -	}
> > -	inode->i_state |= I_WB_SWITCH;
> > -	__iget(inode);
> > -	spin_unlock(&inode->i_lock);
> >  
> >  	isw->inodes[0] = inode;
> >  
> > @@ -571,6 +586,73 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
> >  	kfree(isw);
> >  }
> >  
> > +/**
> > + * cleanup_offline_cgwb - detach associated inodes
> > + * @wb: target wb
> > + *
> > + * Switch all inodes attached to @wb to a nearest living ancestor's wb in order
> > + * to eventually release the dying @wb.  Returns %true if not all inodes were
> > + * switched and the function has to be restarted.
> > + */
> > +bool cleanup_offline_cgwb(struct bdi_writeback *wb)
> > +{
> > +	struct cgroup_subsys_state *memcg_css;
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
> > +	atomic_inc(&isw_nr_in_flight);
> > +
> > +	for (memcg_css = wb->memcg_css->parent; memcg_css;
> > +	     memcg_css = memcg_css->parent) {
> > +		isw->new_wb = wb_get_lookup(wb->bdi, memcg_css);
> 
> Should this be wb_get_create()? I suspect intermediate cgroups wouldn't
> have cgwb's due to the no internal process constraint. cgwb's aren't
> like blkcgs where they pin the parent and maintain the tree hierarchy.

Yes, it's a good point. I'll change to wb_get_create() and send v9 soon.

Thank you!
