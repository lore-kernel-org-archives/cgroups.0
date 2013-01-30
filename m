From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: simplify lock of memcg page stat accounting
Date: Wed, 30 Jan 2013 10:12:29 +0100
Message-ID: <20130130091229.GA16098@dhcp22.suse.cz>
References: <1359198756-3752-1-git-send-email-handai.szj@taobao.com>
 <51071AA1.7000207@jp.fujitsu.com>
 <CAFj3OHXyWN+zUMAaSEOz2gCP7Bm6v4Zex=Rq=7A9CkHTp3j1UQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFj3OHXyWN+zUMAaSEOz2gCP7Bm6v4Zex=Rq=7A9CkHTp3j1UQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Tue 29-01-13 23:29:35, Sha Zhengju wrote:
> On Tue, Jan 29, 2013 at 8:41 AM, Kamezawa Hiroyuki
> <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> > (2013/01/26 20:12), Sha Zhengju wrote:
> >> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> >>
> >> After removing duplicated information like PCG_*
> >> flags in 'struct page_cgroup'(commit 2ff76f1193), there's a problem
> >> between "move" and "page stat accounting"(only FILE_MAPPED is supported
> >> now but other stats will be added in future):
> >> assume CPU-A does "page stat accounting" and CPU-B does "move"
> >>
> >> CPU-A                        CPU-B
> >> TestSet PG_dirty
> >> (delay)               move_lock_mem_cgroup()
> >>                          if (PageDirty(page)) {
> >>                               old_memcg->nr_dirty --
> >>                               new_memcg->nr_dirty++
> >>                          }
> >>                          pc->mem_cgroup = new_memcg;
> >>                          move_unlock_mem_cgroup()
> >>
> >> move_lock_mem_cgroup()
> >> memcg = pc->mem_cgroup
> >> memcg->nr_dirty++
> >> move_unlock_mem_cgroup()
> >>
> >> while accounting information of new_memcg may be double-counted. So we
> >> use a bigger lock to solve this problem:  (commit: 89c06bd52f)
> >>
> >>        move_lock_mem_cgroup() <-- mem_cgroup_begin_update_page_stat()
> >>        TestSetPageDirty(page)
> >>        update page stats (without any checks)
> >>        move_unlock_mem_cgroup() <-- mem_cgroup_begin_update_page_stat()
> >>
> >>
> >> But this method also has its pros and cons: at present we use two layers
> >> of lock avoidance(memcg_moving and memcg->moving_account) then spinlock
> >> on memcg (see mem_cgroup_begin_update_page_stat()), but the lock granularity
> >> is a little bigger that not only the critical section but also some code
> >> logic is in the range of locking which may be deadlock prone. As dirty
> >> writeack stats are added, it gets into further difficulty with the page
> >> cache radix tree lock and it seems that the lock requires nesting.
> >> (https://lkml.org/lkml/2013/1/2/48)
> >>
> >> So in order to make the lock simpler and clearer and also avoid the 'nesting'
> >> problem, a choice may be:
> >> (CPU-A does "page stat accounting" and CPU-B does "move")
> >>
> >>         CPU-A                        CPU-B
> >>
> >> move_lock_mem_cgroup()
> >> memcg = pc->mem_cgroup
> >> TestSetPageDirty(page)
> >> move_unlock_mem_cgroup()
> >>                               move_lock_mem_cgroup()
> >>                               if (PageDirty) {
> >>                                    old_memcg->nr_dirty --;
> >>                                    new_memcg->nr_dirty ++;
> >>                               }
> >>                               pc->mem_cgroup = new_memcg
> >>                               move_unlock_mem_cgroup()
> >>
> >> memcg->nr_dirty ++
> >>
> >
> > Hmm. no race with file truncate ?
> >
> 
> Do you mean "dirty page accounting" racing with truncate?  Yes, if
> another one do truncate and set page->mapping=NULL just before CPU-A's
> 'memcg->nr_dirty ++', then it'll have no change to correct the figure
> back. So my rough idea now is to have some small changes to
> __set_page_dirty/__set_page_dirty_nobuffers that do SetDirtyPage
> inside ->tree_lock.
> 
> But, in current codes, is there any chance that
> mem_cgroup_move_account() racing with truncate that PageAnon is
> false(since page->mapping is cleared) but later in page_remove_rmap()
> the new memcg stats is over decrement...?

We are not checking page->mapping but rather page_mapped() which
checks page->_mapcount and that is protected from races with
mem_cgroup_move_account by mem_cgroup_begin_update_page_stat locking.
Makes sense?

> Call me silly...but I really get dizzy by those locks now, need to
> have a run to refresh my head... : (

Yeah, that part is funny for a certain reading of the word funny ;)
-- 
Michal Hocko
SUSE Labs
