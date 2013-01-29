From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: simplify lock of memcg page stat accounting
Date: Tue, 29 Jan 2013 11:40:03 +0100
Message-ID: <20130129103940.GA29574@dhcp22.suse.cz>
References: <1359198756-3752-1-git-send-email-handai.szj@taobao.com>
 <51071AA1.7000207@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51071AA1.7000207-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Tue 29-01-13 09:41:05, KAMEZAWA Hiroyuki wrote:
> (2013/01/26 20:12), Sha Zhengju wrote:
[...]
> > So in order to make the lock simpler and clearer and also avoid the 'nesting'
> > problem, a choice may be:
> > (CPU-A does "page stat accounting" and CPU-B does "move")
> > 
> >         CPU-A                        CPU-B
> > 
> > move_lock_mem_cgroup()
> > memcg = pc->mem_cgroup
> > TestSetPageDirty(page)
> > move_unlock_mem_cgroup()
> >                               move_lock_mem_cgroup()
> >                               if (PageDirty) {
> >                                    old_memcg->nr_dirty --;
> >                                    new_memcg->nr_dirty ++;
> >                               }
> >                               pc->mem_cgroup = new_memcg
> >                               move_unlock_mem_cgroup()
> > 
> > memcg->nr_dirty ++
> > 
> 
> Hmm. no race with file truncate ?

Shouldn't pte lock protect us in page_{add_file,remove}_rmap?

[...]
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 59b0dca..0d74c48 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1112,13 +1112,25 @@ void page_add_file_rmap(struct page *page)
> >   {
> >   	bool locked;
> >   	unsigned long flags;
> > +	bool ret;
> > +	struct mem_cgroup *memcg = NULL;
> > +	struct cgroup_subsys_state *css = NULL;
> >   
> >   	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
> > -	if (atomic_inc_and_test(&page->_mapcount)) {
> > +	memcg = try_get_mem_cgroup_from_page(page);
> 
> Toooooo heavy ! I can say NACK to this patch only because of this try_get().

Agreed.

> To hold memcg alive, rcu_read_lock() will work (as current code does).
> 
> BTW, does this patch fixes the nested-lock problem ?

Because set_page_drity is called outside of mem_cgroup_{begin,end}_update_page_stat.
That confused me too.
-- 
Michal Hocko
SUSE Labs
