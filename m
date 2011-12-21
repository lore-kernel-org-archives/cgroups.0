From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v2] memcg: return -EINTR at bypassing try_charge().
Date: Wed, 21 Dec 2011 19:08:01 +0900
Message-ID: <20111221190801.5b10e80c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111219165146.4d72f1bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20111221172423.5d036cdd.kamezawa.hiroyu@jp.fujitsu.com>
	<20111221095708.GE3870@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111221095708.GE3870-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, 21 Dec 2011 10:57:08 +0100
Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> On Wed, Dec 21, 2011 at 05:24:23PM +0900, KAMEZAWA Hiroyuki wrote:
> > How about this ?
> > --
> > >From 6076425613f594d442c58a5d463c09f8309236aa Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > Date: Wed, 21 Dec 2011 16:27:25 +0900
> > Subject: [PATCH] memcg: return -EINTR at bypassing try_charge().
> > 
> > This patch is a fix for memcg-simplify-lru-handling-by-new-rule.patch
> > When running testprogram and stop it by Ctrl-C, add_lru/del_lru
> > will find pc->mem_cgroup is NULL and get panic. The reason
> > is bypass code in try_charge().
> > 
> > At try_charge(), it checks the thread is fatal or not as..
> > fatal_signal_pending() or TIF_MEMDIE. In this case, __try_charge()
> > returns 0(success) with setting *ptr as NULL.
> > 
> > Now, lruvec are deteremined by pc->mem_cgroup. So, it's better
> > to reset pc->mem_cgroup as root_mem_cgroup. This patch does
> > following change in try_charge()
> >   1. return -EINTR at bypassing.
> >   2. set *ptr = root_mem_cgroup at bypassing.
> > 
> > By this change, in page fault / radix-tree-insert path,
> > the page will be charged against root_mem_cgroup and the thread's
> > operations will go ahead without trouble. In other path,
> > migration or move_account etc..., -EINTR will stop the operation.
> > (may need some cleanup later..)
> > 
> > After this change, pc->mem_cgroup will have valid pointer if
> > the page is used.
> > 
> > Changelog: v1 -> v2
> >  - returns -EINTR at bypassing.
> >  - change error code handling at callers.
> >  - changed the name of patch.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > ---
> >  mm/memcontrol.c |   53 +++++++++++++++++++++++++++++++++++++++++------------
> >  1 files changed, 41 insertions(+), 12 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 9175097..3c6eb7e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2185,6 +2185,23 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  }
> >  
> >  /*
> > + * __mem_cgroup_try_charge() does
> > + * 1. detect memcg to be charged against from passed *mm and *ptr,
> > + * 2. update res_counter
> > + * 3. call memory reclaim if necessary.
> > + *
> > + * In some special case, if the task is fatal, fatal_signal_pending() or
> > + * TIF_MEMDIE or ->mm is NULL, this functoion returns -EINTR with filling
> > + * *ptr as root_mem_cgroup. There are 2 reasons for this. 1st is that
> > + * fatal threads should quit as soon as possible without any hazards.
> > + * 2nd is that all page should have valid pc->mem_cgroup if it will be
> > + * used.
> > + *
> > + * So, try_charge will return
> > + *  0       ...  at success. filling *ptr with a valid memcg pointer.
> > + *  -ENOMEM ...  charge failure because of resource limits.
> > + *  -EINTR  ...  if thread is fatal. *ptr is filled with root_mem_cgroup.
> > + *
> >   * Unlike exported interface, "oom" parameter is added. if oom==true,
> >   * oom-killer can be invoked.
> >   */
> > @@ -2316,8 +2333,8 @@ nomem:
> >  	*ptr = NULL;
> >  	return -ENOMEM;
> >  bypass:
> > -	*ptr = NULL;
> > -	return 0;
> > +	*ptr = root_mem_cgroup;
> > +	return -EINTR;
> >  }
> 
> What about this case:
> 
> 	/*
> 	 * We always charge the cgroup the mm_struct belongs to.
> 	 * The mm_struct's mem_cgroup changes on task migration if the
> 	 * thread group leader migrates. It's possible that mm is not
> 	 * set, if so charge the init_mm (happens for pagecache usage).
> 	 */
> 	if (!*ptr && !mm)
> 		goto bypass;
> 

IIUC, task->mm is NULL when the task is about to exit.
So, charge to root_mem_cgroup will be enough good.
I'm not sure how 'mm_struct's mem_cgroup changes on.....' cases affect
this path...




> > @@ -2564,7 +2581,7 @@ static int mem_cgroup_move_parent(struct page *page,
> >  {
> >  	struct cgroup *cg = child->css.cgroup;
> >  	struct cgroup *pcg = cg->parent;
> > -	struct mem_cgroup *parent;
> > +	struct mem_cgroup *parent, *ptr;
> >  	unsigned int nr_pages;
> >  	unsigned long uninitialized_var(flags);
> >  	int ret;
> > @@ -2582,8 +2599,8 @@ static int mem_cgroup_move_parent(struct page *page,
> >  	nr_pages = hpage_nr_pages(page);
> >  
> >  	parent = mem_cgroup_from_cont(pcg);
> > -	ret = __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages, &parent, false);
> > -	if (ret || !parent)
> > +	ret = __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages, &ptr, false);
> > +	if (ret)
> >  		goto put_back;
> 
> That doesn't seem right.  That unitilialized ptr is used in
> try_charge(), so this may crash, and it should really charge against
> parent.

Ah, yes. my mistake.



> > @@ -2630,9 +2647,9 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
> >  
> >  	pc = lookup_page_cgroup(page);
> >  	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
> > -	if (ret || !memcg)
> > +	if (ret == -ENOMEM)
> >  		return ret;
> > -
> > +	/* we'll bypass -EINTR case and charge this page to root memcg */
> >  	__mem_cgroup_commit_charge(memcg, page, nr_pages, pc, ctype);
> >  	return 0;
> >  }
> 
> This comment is not very useful.  WHY do we do this?  Maybe just copy
> the comment from try_charge_swapin()?
> 
Hmm, ok. I'll remove this comment.


> > @@ -2703,6 +2720,7 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
> >  		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
> >  	else { /* page is swapcache/shmem */
> >  		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &memcg);
> > +		/* see try_charge_swapi() for -EINTR case */
> >  		if (!ret)
> >  			__mem_cgroup_commit_charge_swapin(page, memcg, type);
> >  	}
> 
> Missing n in the comment.
> 

will remove this, too.


> > @@ -2743,11 +2761,21 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
> >  	*memcgp = memcg;
> >  	ret = __mem_cgroup_try_charge(NULL, mask, 1, memcgp, true);
> >  	css_put(&memcg->css);
> > +	/*
> > +	 * If this thread is fatal, charge against root cgroup and allow
> > +	 * this thread to exit in quick manner. EINTR is not handled
> > +	 * in page fault path. So, just bypass this.
> > +	 */
> > +	if (ret == -EINTR)
> > +		ret = 0;
> >  	return ret;
> >  charge_cur_mm:
> >  	if (unlikely(!mm))
> >  		mm = &init_mm;
> > -	return __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
> > +	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
> > +	if (ret == -EINTR)
> > +		ret = 0;
> > +	return ret;
> >  }
> >  
> >  static void
> 
> > @@ -3633,7 +3662,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
> >  		pc = lookup_page_cgroup(page);
> >  
> >  		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
> > -		if (ret == -ENOMEM)
> > +		if (ret == -ENOMEM || ret == -EINTR)
> >  			break;
> 
> if (ret)
> 

-EBUSY check is below this code.

I'll prepare v3. 

Thanks,
-Kame
