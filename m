From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v18 15/32] mm/lru: move lock into lru_note_cost
Date: Mon, 21 Sep 2020 15:03:24 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009211440570.5214@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <1598273705-69124-16-git-send-email-alex.shi@linux.alibaba.com> <alpine.LSU.2.11.2009211434490.5214@eggly.anvils>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=i9wIfsv5rz4rfrgx+xfjmFTxPq64qmLCQPg3J+waEbE=;
        b=DdepaFHP5SGw8u3Jxxrft7G4MFxCoXyObylHPKbacrL+cHB16NaAJhD5pIbYyNVpQd
         Klaaxa9m+XOEu8WCDI2BGJEh9xJjFu6wVMkxYCQs/wHlhajC7H1OK0C8z3pKFLSUutfo
         /O7veoCMTReFJMDGKLzCE0pM1GtuT8DTXG6yGto0omKozwErUb6rkpUMzjHeaV+XrD0t
         iAJga/vtnJp+LqFmK+3cqp4Jaa+9OIekQDdDnAxNz5daBoxRoUmhzN96QuWg4gkx+svY
         3JdEGi8JFhwQzUsY/o2RfnpeJ3ffX8rby7q+sqiHf2n3DKWczyN8EYsw8pxVOvxpV03m
         UyYg==
In-Reply-To: <alpine.LSU.2.11.2009211434490.5214@eggly.anvils>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com

On Mon, 21 Sep 2020, Hugh Dickins wrote:
> On Mon, 24 Aug 2020, Alex Shi wrote:
> 
> > We have to move lru_lock into lru_note_cost, since it cycle up on memcg
> > tree, for future per lruvec lru_lock replace. It's a bit ugly and may
> > cost a bit more locking, but benefit from multiple memcg locking could
> > cover the lost.
> > 
> > Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> 
> Acked-by: Hugh Dickins <hughd@google.com>
> 
> In your lruv19 github tree, you have merged 14/32 into this one: thanks.

Grr, I've only just started, and already missed some of my notes.

I wanted to point out that this patch does introduce an extra unlock+lock
in shrink_inactive_list(), even in a !CONFIG_MEMCG build.  I think you've
done the right thing for now, keeping it simple, and maybe nobody will
notice the extra overhead; but I expect us to replace lru_note_cost()
by lru_note_cost_unlock_irq() later on, expecting the caller to do the
initial lock_irq().

lru_note_cost_page() looks redundant to me, but you're right not to
delete it here, unless Johannes asks you to add that in: that's his
business, and it may be dependent on the XXX at its callsite.

> 
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  mm/swap.c   | 5 +++--
> >  mm/vmscan.c | 4 +---
> >  2 files changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 906255db6006..f80ccd6f3cb4 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -269,7 +269,9 @@ void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages)
> >  {
> >  	do {
> >  		unsigned long lrusize;
> > +		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> >  
> > +		spin_lock_irq(&pgdat->lru_lock);
> >  		/* Record cost event */
> >  		if (file)
> >  			lruvec->file_cost += nr_pages;
> > @@ -293,15 +295,14 @@ void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages)
> >  			lruvec->file_cost /= 2;
> >  			lruvec->anon_cost /= 2;
> >  		}
> > +		spin_unlock_irq(&pgdat->lru_lock);
> >  	} while ((lruvec = parent_lruvec(lruvec)));
> >  }
> >  
> >  void lru_note_cost_page(struct page *page)
> >  {
> > -	spin_lock_irq(&page_pgdat(page)->lru_lock);
> >  	lru_note_cost(mem_cgroup_page_lruvec(page, page_pgdat(page)),
> >  		      page_is_file_lru(page), thp_nr_pages(page));
> > -	spin_unlock_irq(&page_pgdat(page)->lru_lock);
> >  }
> >  
> >  static void __activate_page(struct page *page, struct lruvec *lruvec)
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index ffccb94defaf..7b7b36bd1448 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1971,19 +1971,17 @@ static int current_may_throttle(void)
> >  				&stat, false);
> >  
> >  	spin_lock_irq(&pgdat->lru_lock);
> > -
> >  	move_pages_to_lru(lruvec, &page_list);
> >  
> >  	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
> > -	lru_note_cost(lruvec, file, stat.nr_pageout);
> >  	item = current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
> >  	if (!cgroup_reclaim(sc))
> >  		__count_vm_events(item, nr_reclaimed);
> >  	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
> >  	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
> > -
> >  	spin_unlock_irq(&pgdat->lru_lock);
> >  
> > +	lru_note_cost(lruvec, file, stat.nr_pageout);
> >  	mem_cgroup_uncharge_list(&page_list);
> >  	free_unref_page_list(&page_list);
> >  
> > -- 
> > 1.8.3.1
> > 
> > 
> 
