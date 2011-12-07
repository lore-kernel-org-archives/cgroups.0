From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC][PATCH] memcg: remove PCG_ACCT_LRU.
Date: Wed, 7 Dec 2011 10:48:00 +0900
Message-ID: <20111207104800.d1851f78.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111202190622.8e0488d6.kamezawa.hiroyu@jp.fujitsu.com>
	<20111202120849.GA1295@cmpxchg.org>
	<20111205095009.b82a9bdf.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1112051552210.3938@sister.anvils>
	<20111206095825.69426eb2.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1112052258510.28015@sister.anvils>
	<20111206192101.8ea75558.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1112061506360.2111@sister.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.00.1112061506360.2111-T/S/X05ZC3jbmfIwyoSfiQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 6 Dec 2011 15:50:33 -0800 (PST)
Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 6 Dec 2011, KAMEZAWA Hiroyuki wrote:
> > On Mon, 5 Dec 2011 23:36:34 -0800 (PST)
> > Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > Hmm, at first glance at the patch, it seems far complicated than
> > I expected
> 
> Right, this is just a rollup of assorted changes,
> yet to be presented properly as an understandable series.
> 
> > and added much checks and hooks to lru path...
> 
> Actually, I think it removes more than it adds; while trying not
> to increase the overhead of lookup_page_cgroup()s and locking.
> 
> > > Okay, here it is: my usual mix of cleanup and functional changes.
> > > There's work by Ying and others in here - will apportion authorship
> > > more fairly when splitting.  If you're looking through it at all,
> > > the place to start would be memcontrol.c's lock_page_lru_irqsave().
> > > 
> > 
> > Thank you. This seems inetersting patch. Hmm...what I think of now is..
> > In most case, pages are newly allocated and charged ,and then, added to LRU.
> > pc->mem_cgroup never changes while pages are on LRU.
> > 
> > I have a fix for corner cases as to do
> > 
> > 	1. lock lru
> > 	2. remove-page-from-lru
> > 	3. overwrite pc->mem_cgroup
> > 	4. add page to lru again
> > 	5. unlock lru
> 
> That is indeed the sequence which __mem_cgroup_commit_charge() follows
> after the patch.
> 
> But it optimizes out the majority of cases when no such lru operations
> are needed (optimizations best presented in a separate patch), while
> being careful about the tricky case when the page is on lru_add_pvecs,
> and may get on to an lru at any moment.
> 
> And since it uses a separate lock for each memcg-zone's set of lrus,
> must take care that both lock and lru in 4 and 5 are different from
> those in 1 and 2.
> 

yes, after per-zone-per-memcg lock, Above sequence should take some care.

With naive solution,

	1. get lruvec-1 from target pc->mem_cgroup
	2. get lruvec-2 from target memcg to be charged.
	3. lock lruvec-x lock
	4. lock lruvec-y lock   (x and y order is determined by css_id ?)
	5. remove from LRU.
	6. overwrite pc->mem_cgroup
	7. add page to lru again
	8. unlock lruvec-y
	9. unlokc lruvec-x

Hm, maybe there are another clever way..


> > 
> > And blindly believe pc->mem_cgroup regardless of PCG_USED bit at LRU handling.
> 
> That's right.  The difficulty comes when Used is cleared while
> the page is off lru, or page removed from lru while Used is clear:
> once lock is dropped, we have no hold on the memcg, and must move
> to root lru lest the old memcg get deleted.
> 
> The old Used + AcctLRU + pc->mem_cgroup puppetry used to achieve that
> quite cleverly; but in distributing zone lru_locks over memcgs, we went
> through a lot of crashes before we understood the subtlety of it; and
> in most places were just fighting the way it shifted underneath us.
> 
> Now mem_cgroup_move_uncharged_to_root() makes the move explicit,
> in just a few places.
> 
> > 
> > Hm, per-zone-per-memcg lru locking is much easier if
> >  - we igonore PCG_USED bit at lru handling
> 
> I may or may not agree with you, depending on what you mean!
> 
Ah, after my patch, 

	mem_cgroup_lru_add(zone, page) {
		pc = lookup_page_cgroup(page);
		memcg = pc->mem_cgroup;
		lruvec = lruvec(memcg, zone)
		update zone stat for memcg
	}
Then, no flag check at handling lru.

> >  - we never overwrite pc->mem_cgroup if the page is on LRU.
> 
> That's not the way I was thinking of it, but I think that's what we're doing.
> 
I do this by a new rule 

"If page may be on LRU at commit_charge, lru_lock should be held and PageLRU
 must be cleared."


> >  - if page may be added to LRU by pagevec etc.. while we overwrite
> >    pc->mem_cgroup, we always take lru_lock. This is our corner case.
> 
> Yes, the tricky case I mention above.
> 
> > 
> > isn't it ? I posted a series of patch. I'm glad if you give me a
> > quick review.
> 
> I haven't glanced yet, will do so after an hour or two.
> 

I think Johannes's chages of removing page_cgroup->lru allows us
various chances of optimization/simplification.

Thanks,
-Kame

 

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
