From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v5 2/2] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Date: Thu, 27 May 2021 10:48:59 -0700
Message-ID: <YK/bi1OU7bNgPBab@carbon.DHCP.thefacebook.com>
References: <20210526222557.3118114-1-guro@fb.com>
 <20210526222557.3118114-3-guro@fb.com>
 <20210527112403.GC24486@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kxzoRCMHSho4mWIak2bD8GUqCu6LDO350U90SH60GW4=;
 b=C4kIqJSuBZ2ZFJNS2vj8LqH/uUS2bjBYyvYqw9VzpB9UI3eXhz3DBrYHhb6xqzzSZF9z
 MUlnyhRLAXUi5RWbU04v0zRSlaht/mVOJOYufFvxDVJiEOLFIFvpWjRsezRNDSNbl4cB
 ZoJ3aPR0E2naGKi9mrk9Zl42J0Ec/DM71Fs= 
Content-Disposition: inline
In-Reply-To: <20210527112403.GC24486@quack2.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dennis Zhou <dennis@kernel.org>, Dave Chinner <dchinner@redhat.com>, cgroups@vger.kernel.org

On Thu, May 27, 2021 at 01:24:03PM +0200, Jan Kara wrote:
> On Wed 26-05-21 15:25:57, Roman Gushchin wrote:
> > Asynchronously try to release dying cgwbs by switching clean attached
> > inodes to the bdi's wb. It helps to get rid of per-cgroup writeback
> > structures themselves and of pinned memory and block cgroups, which
> > are way larger structures (mostly due to large per-cpu statistics
> > data). It helps to prevent memory waste and different scalability
> > problems caused by large piles of dying cgroups.
> > 
> > A cgwb cleanup operation can fail due to different reasons (e.g. the
> > cgwb has in-glight/pending io, an attached inode is locked or isn't
> > clean, etc). In this case the next scheduled cleanup will make a new
> > attempt. An attempt is made each time a new cgwb is offlined (in other
> > words a memcg and/or a blkcg is deleted by a user). In the future an
> > additional attempt scheduled by a timer can be implemented.
> > 
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > ---
> >  fs/fs-writeback.c                | 35 ++++++++++++++++++
> >  include/linux/backing-dev-defs.h |  1 +
> >  include/linux/writeback.h        |  1 +
> >  mm/backing-dev.c                 | 61 ++++++++++++++++++++++++++++++--
> >  4 files changed, 96 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 631ef6366293..8fbcd50844f0 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -577,6 +577,41 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
> >  	kfree(isw);
> >  }
> >  
> > +/**
> > + * cleanup_offline_wb - detach associated clean inodes
> > + * @wb: target wb
> > + *
> > + * Switch the inode->i_wb pointer of the attached inodes to the bdi's wb and
> > + * drop the corresponding per-cgroup wb's reference. Skip inodes which are
> > + * dirty, freeing, in the active writeback process or are in any way busy.
> 
> I think the comment doesn't match the function anymore.
> 
> > + */
> > +void cleanup_offline_wb(struct bdi_writeback *wb)
> > +{
> > +	struct inode *inode, *tmp;
> > +
> > +	spin_lock(&wb->list_lock);
> > +restart:
> > +	list_for_each_entry_safe(inode, tmp, &wb->b_attached, i_io_list) {
> > +		if (!spin_trylock(&inode->i_lock))
> > +			continue;
> > +		xa_lock_irq(&inode->i_mapping->i_pages);
> > +		if ((inode->i_state & I_REFERENCED) != I_REFERENCED) {
> 
> Why the I_REFERENCED check here? That's just inode aging bit and I have
> hard time seeing how it would relate to whether inode should switch wbs...

What I tried to say (and failed :) ) was that I_REFERENCED is the only accepted
flag here. So there must be
	if ((inode->i_state | I_REFERENCED) != I_REFERENCED)

Does this look good or I am wrong and there are other flags acceptable here?

> 
> > +			struct bdi_writeback *bdi_wb = &inode_to_bdi(inode)->wb;
> > +
> > +			WARN_ON_ONCE(inode->i_wb != wb);
> > +
> > +			inode->i_wb = bdi_wb;
> > +			list_del_init(&inode->i_io_list);
> > +			wb_put(wb);
> 
> I was kind of hoping you'll use some variant of inode_switch_wbs() here.

My reasoning was that by definition inode_switch_wbs() handles dirty inodes,
while in the cleanup case we can deal only with clean inodes and clean wb's.
Hopefully this can make the whole procedure simpler/cheaper. Also, the number
of simultaneous switches is limited and I don't think cleanups should share
this limit.
However I agree that it would be nice to share at least some code.

> That way we have single function handling all the subtleties of switching
> inode->i_wb of an active inode. Maybe it isn't strictly needed here because
> you detach only from b_attached list and move to bdi_wb so things are
> indeed simpler here. But you definitely miss transferring WB_WRITEBACK stat
> and I'd also like to have a comment here explaining why this cannot race
> with other writeback handling or wb switching in a harmful way.

If we'll check under wb->list_lock that wb has no inodes on any writeback lists
(excluding b_attached), doesn't it mean that WB_WRITEBACK must be 0?

Re racing: my logic here was that we're taking all possible locks before doing
anything and then we check that the inode is entirely clean, so this must be
safe:
	spin_lock(&wb->list_lock);
	spin_trylock(&inode->i_lock);
	xa_lock_irq(&inode->i_mapping->i_pages);
	...

But now I see that the unlocked inode's wb access mechanism
(unlocked_inode_to_wb_begin()/end()) probably requires additional care.
Repeating the mechanism with scheduling the switching of each inode separately
after an rcu grace period looks too slow. Maybe we can mark all inodes at once
and then switch them all at once, all in two steps. I need to think more.
Do you have any ideas/suggestions here?

> 
> > +		}
> > +		xa_unlock_irq(&inode->i_mapping->i_pages);
> > +		spin_unlock(&inode->i_lock);
> > +		if (cond_resched_lock(&wb->list_lock))
> > +			goto restart;
> > +	}
> > +	spin_unlock(&wb->list_lock);
> > +}
> > +
> >  /**
> >   * wbc_attach_and_unlock_inode - associate wbc with target inode and unlock it
> >   * @wbc: writeback_control of interest
> > diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> > index e5dc238ebe4f..07d6b6d6dbdf 100644
> > --- a/include/linux/backing-dev-defs.h
> > +++ b/include/linux/backing-dev-defs.h
> > @@ -155,6 +155,7 @@ struct bdi_writeback {
> >  	struct list_head memcg_node;	/* anchored at memcg->cgwb_list */
> >  	struct list_head blkcg_node;	/* anchored at blkcg->cgwb_list */
> >  	struct list_head b_attached;	/* attached inodes, protected by list_lock */
> > +	struct list_head offline_node;	/* anchored at offline_cgwbs */
> >  
> >  	union {
> >  		struct work_struct release_work;
> > diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> > index 572a13c40c90..922f15fe6ad4 100644
> > --- a/include/linux/writeback.h
> > +++ b/include/linux/writeback.h
> > @@ -222,6 +222,7 @@ void wbc_account_cgroup_owner(struct writeback_control *wbc, struct page *page,
> >  int cgroup_writeback_by_id(u64 bdi_id, int memcg_id, unsigned long nr_pages,
> >  			   enum wb_reason reason, struct wb_completion *done);
> >  void cgroup_writeback_umount(void);
> > +void cleanup_offline_wb(struct bdi_writeback *wb);
> >  
> >  /**
> >   * inode_attach_wb - associate an inode with its wb
> > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > index 54c5dc4b8c24..92a00bcaa504 100644
> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> > @@ -371,12 +371,16 @@ static void wb_exit(struct bdi_writeback *wb)
> >  #include <linux/memcontrol.h>
> >  
> >  /*
> > - * cgwb_lock protects bdi->cgwb_tree, blkcg->cgwb_list, and memcg->cgwb_list.
> > - * bdi->cgwb_tree is also RCU protected.
> > + * cgwb_lock protects bdi->cgwb_tree, blkcg->cgwb_list, offline_cgwbs and
> > + * memcg->cgwb_list.  bdi->cgwb_tree is also RCU protected.
> >   */
> >  static DEFINE_SPINLOCK(cgwb_lock);
> >  static struct workqueue_struct *cgwb_release_wq;
> >  
> > +static LIST_HEAD(offline_cgwbs);
> > +static void cleanup_offline_cgwbs_workfn(struct work_struct *work);
> > +static DECLARE_WORK(cleanup_offline_cgwbs_work, cleanup_offline_cgwbs_workfn);
> > +
> >  static void cgwb_release_workfn(struct work_struct *work)
> >  {
> >  	struct bdi_writeback *wb = container_of(work, struct bdi_writeback,
> > @@ -395,6 +399,7 @@ static void cgwb_release_workfn(struct work_struct *work)
> >  
> >  	fprop_local_destroy_percpu(&wb->memcg_completions);
> >  	percpu_ref_exit(&wb->refcnt);
> > +	WARN_ON(!list_empty(&wb->offline_node));
> 
> Hum, cannot this happen when when wb had originally some attached inodes,
> we added it to offline_cgwbs but then normal inode reclaim cleaned all the
> inodes (and thus all wb refs were dropped) before
> cleanup_offline_cgwbs_workfn() was executed? So either the offline_cgwbs
> list has to hold its own wb ref or we have to remove cgwb from the list
> in cgwb_release_workfn().

Yes, clearly a bug, thanks for catching!

> 
> >  	wb_exit(wb);
> >  	WARN_ON_ONCE(!list_empty(&wb->b_attached));
> >  	kfree_rcu(wb, rcu);
> > @@ -414,6 +419,10 @@ static void cgwb_kill(struct bdi_writeback *wb)
> >  	WARN_ON(!radix_tree_delete(&wb->bdi->cgwb_tree, wb->memcg_css->id));
> >  	list_del(&wb->memcg_node);
> >  	list_del(&wb->blkcg_node);
> > +	if (!list_empty(&wb->b_attached))
> > +		list_add(&wb->offline_node, &offline_cgwbs);
> > +	else
> > +		INIT_LIST_HEAD(&wb->offline_node);
> >  	percpu_ref_kill(&wb->refcnt);
> >  }
> >  
> > @@ -635,6 +644,50 @@ static void cgwb_bdi_unregister(struct backing_dev_info *bdi)
> >  	mutex_unlock(&bdi->cgwb_release_mutex);
> >  }
> >  
> > +/**
> > + * cleanup_offline_cgwbs - try to release dying cgwbs
> > + *
> > + * Try to release dying cgwbs by switching attached inodes to the wb
> > + * belonging to the root memory cgroup. Processed wbs are placed at the
> > + * end of the list to guarantee the forward progress.
> > + *
> > + * Should be called with the acquired cgwb_lock lock, which might
> > + * be released and re-acquired in the process.
> > + */
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
> > +
> > +		if (!percpu_ref_tryget(&wb->refcnt))
> > +			continue;
> > +
> > +		spin_unlock_irq(&cgwb_lock);
> > +		cleanup_offline_wb(wb);
> > +		spin_lock_irq(&cgwb_lock);
> > +
> > +		if (list_empty(&wb->b_attached))
> > +			list_del_init(&wb->offline_node);
> 
> But the cgwb can still have inodes in its dirty lists which will eventually
> move to b_attached. So you can delete cgwb here prematurely, cannot you?

Hm, I thought that in this case wb_has_dirty_io() check above will fail.
But you're right, nothing really protects wb from being re-dirtied after
the check.
At least we need to hold wb->list_lock for wb_has_dirty_io(wb) and
list_empty(&wb->b_attached) checks...

Will fix it.

Thank you, really appreciate your feedback!
