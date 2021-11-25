From: Hao Lee <haolee.swjtu@gmail.com>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Thu, 25 Nov 2021 12:31:33 +0000
Message-ID: <20211125123133.GA7758@haolee.io>
References: <20211124151915.GA6163@haolee.io>
 <YZ5o/VmU59evp65J@dhcp22.suse.cz>
 <CA+PpKPmy-u_BxYMCQOFyz78t2+3uM6nR9mQeX+MPyH6H2tOOHA@mail.gmail.com>
 <YZ8DZHERun6Fej2P@casper.infradead.org>
 <20211125080238.GA7356@haolee.io>
 <YZ9e3pzHKmn5nev0@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3vJ4AJiS+Uz4Qd3lnVk4pTTKYmTdbuasQ4cUoZKQvIQ=;
        b=Xu+EEv4l1NedJw5BXL64XAqWWlEW+/MSfmj9g7G6Zo5xFWXJ2eRFkGv5oFlsx9U+Wg
         KqRRS6rmf+WslAtx1WUQ6U3nZIbpf1q30TtFnx3tbpkTzbxvsE7+XLlIoBz6+msXpYiE
         8igVXVYgiThJ8d08lr5f0YR3tcesMI1VTwiZuutVgOtKTRXPnsWIFuIPUNiuchgTYKNM
         SrcwdwMaVHqrh5+x+hZz3TEtOaKKc3EBaNNNP2RyggJ7iuJo609zaI2CDVcsqq8Y8+oT
         i93AIM64GqPERRKOV8483rEycUDbo2ZtYU7C5txZqDXKswdIGBQ7nhGphB+J1kc/+Vh/
         BEEQ==
Content-Disposition: inline
In-Reply-To: <YZ9e3pzHKmn5nev0@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>, Linux MM <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, vdavydov.dev@gmail.com, Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Thu, Nov 25, 2021 at 11:01:02AM +0100, Michal Hocko wrote:
> On Thu 25-11-21 08:02:38, Hao Lee wrote:
> > On Thu, Nov 25, 2021 at 03:30:44AM +0000, Matthew Wilcox wrote:
> > > On Thu, Nov 25, 2021 at 11:24:02AM +0800, Hao Lee wrote:
> > > > On Thu, Nov 25, 2021 at 12:31 AM Michal Hocko <mhocko@suse.com> wrote:
> > > > > We do batch currently so no single task should be
> > > > > able to monopolize the cpu for too long. Why this is not sufficient?
> > > > 
> > > > uncharge and unref indeed take advantage of the batch process, but
> > > > del_from_lru needs more time to complete. Several tasks will contend
> > > > spinlock in the loop if nr is very large.
> > > 
> > > Is SWAP_CLUSTER_MAX too large?  Or does your architecture's spinlock
> > > implementation need to be fixed?
> > > 
> > 
> > My testing server is x86_64 with 5.16-rc2. The spinlock should be normal.
> > 
> > I think lock_batch is not the point. lock_batch only break spinning time
> > into small parts, but it doesn't reduce spinning time. The thing may get
> > worse if lock_batch is very small.
> > 
> > Here is an example about two tasks contending spinlock. Let's assume each
> > task need a total of 4 seconds in critical section to complete its work.
> > 
> > Example1:
> > 
> > lock_batch = x
> > 
> > task A      taskB
> > hold 4s     wait 4s
> >             hold 4s
> > 
> > total waiting time is 4s.
> 
> 4s holding time is _way_ too long and something that this path should
> never really reach. We are talking about SWAP_CLUSTER_MAX worth of LRU
> pages. Sure there might be a bunch of pages freed that are not on LRU
> but those are only added to a list. So again what is the actual problem?
> 

The measurement unit in my example may not be rigorous and may confuse you.
What I mean is the batch processing can only gives each task fairness to
compete for this spinlock, but it can't reduce the wasted cpu cycles during
spinning waiting, no matter what the batch size is.  No matter what the
lock_batch is set, the following perf report won't change much. Many cpu
cycles are wasted on spinning. Other tasks running on the same cores will be
delayed, which is unacceptable for our latency-critical jobs. I'm trying to
find if it's possible to reduce the delay and the contention , after all,
59.50% is too high. This is why I post the thoughtless `cond_resched()`
approach.

Here is the perf report when executing ./usemem -j 4096 -n 20 10g -s 5

+   59.50%  usemem           [kernel.vmlinux]               [k] native_queued_spin_lock_slowpath
+    4.36%  usemem           [kernel.vmlinux]               [k] check_preemption_disabled
+    4.31%  usemem           [kernel.vmlinux]               [k] free_pcppages_bulk
+    3.11%  usemem           [kernel.vmlinux]               [k] release_pages
+    2.12%  usemem           [kernel.vmlinux]               [k] __mod_memcg_lruvec_state
+    2.02%  usemem           [kernel.vmlinux]               [k] __list_del_entry_valid
+    1.98%  usemem           [kernel.vmlinux]               [k] __mod_node_page_state
+    1.67%  usemem           [kernel.vmlinux]               [k] unmap_page_range
+    1.51%  usemem           [kernel.vmlinux]               [k] __mod_zone_page_state

> 
> > If cond_reched() will break the task fairness, the only way I can think
> > of is doing uncharge and unref if the current task can't get the
> > spinlock. This will reduce the wasted cpu cycles, although the
> > performance gain is still small (about 4%). However, this way will hurt
> > batch processing in uncharge(). Maybe there exist a better way...
> > 
> > diff --git a/mm/swap.c b/mm/swap.c
> > index e8c9dc6d0377..8a947f8d0aaa 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -960,8 +960,16 @@ void release_pages(struct page **pages, int nr)
> >  		if (PageLRU(page)) {
> >  			struct lruvec *prev_lruvec = lruvec;
> >  
> > -			lruvec = folio_lruvec_relock_irqsave(folio, lruvec,
> > +			lruvec = folio_lruvec_tryrelock_irqsave(folio, lruvec,
> >  									&flags);
> > +			if (!lruvec) {
> > +				mem_cgroup_uncharge_list(&pages_to_free);
> > +				free_unref_page_list(&pages_to_free);
> > +				INIT_LIST_HEAD(&pages_to_free);
> > +				lruvec = folio_lruvec_relock_irqsave(folio,
> > +							lruvec, &flags);
> > +			}
> > +
> >  			if (prev_lruvec != lruvec)
> >  				lock_batch = 0;
> 
> Aren't you sacrificing one batching over the other and the net result
> will really depend on particullar workload. This will effectivelly throw
> away any lruvec batching out of window in presence of contention even if
> there are no pages to be freed (or only very few of them).

Agree. This is by no means the right way.

> 
> TBH I really have hard time to see how 32 LRU pages handling in a single
> lock batch can be harmfull.

Yes. This may be the most reasonable way for now. I'm just trying my
best to find a slightly better way to reduce the wasted cpu time.

Thanks.

> Maybe if there are gazillions of non-lru
> pages where holding the lock is clearly pointless but that shouldn't
> really happen most of the time.
> -- 
> Michal Hocko
> SUSE Labs
