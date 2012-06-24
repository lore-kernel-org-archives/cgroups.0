From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: add MAX_CHARGE_BATCH to limit unnecessary
 charge overhead
Date: Sun, 24 Jun 2012 12:19:48 +0200
Message-ID: <20120624101948.GU27816@cmpxchg.org>
References: <1340504169-5344-1-git-send-email-liwp.linux@gmail.com>
 <20120624094614.GT27816@cmpxchg.org>
 <20120624100812.GA7095@kernel>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120624100812.GA7095@kernel>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun, Jun 24, 2012 at 06:08:26PM +0800, Wanpeng Li wrote:
> On Sun, Jun 24, 2012 at 11:46:14AM +0200, Johannes Weiner wrote:
> >On Sun, Jun 24, 2012 at 10:16:09AM +0800, Wanpeng Li wrote:
> >> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >> 
> >> Since exceeded unused cached charges would add pressure to
> >> mem_cgroup_do_charge, more overhead would burn cpu cycles when
> >> mem_cgroup_do_charge cause page reclaim or even OOM be triggered
> >> just for such exceeded unused cached charges. Add MAX_CHARGE_BATCH
> >> to limit max cached charges.
> >> 
> >> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >>  mm/memcontrol.c |   16 ++++++++++++++++
> >>  1 file changed, 16 insertions(+)
> >> 
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index 0e092eb..1ff317a 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -1954,6 +1954,14 @@ void mem_cgroup_update_page_stat(struct page *page,
> >>   * TODO: maybe necessary to use big numbers in big irons.
> >>   */
> >>  #define CHARGE_BATCH	32U
> >> +
> >> +/*
> >> + * Max size of charge stock. Since exceeded unused cached charges would
> >> + * add pressure to mem_cgroup_do_charge which will cause page reclaim or
> >> + * even oom be triggered.
> >> + */
> >> +#define MAX_CHARGE_BATCH 1024U
> >> +
> >>  struct memcg_stock_pcp {
> >>  	struct mem_cgroup *cached; /* this never be root cgroup */
> >>  	unsigned int nr_pages;
> >> @@ -2250,6 +2258,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> >>  	unsigned int batch = max(CHARGE_BATCH, nr_pages);
> >>  	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
> >>  	struct mem_cgroup *memcg = NULL;
> >> +	struct memcg_stock_pcp *stock;
> >>  	int ret;
> >>  
> >>  	/*
> >> @@ -2320,6 +2329,13 @@ again:
> >>  		rcu_read_unlock();
> >>  	}
> >>  
> >> +	stock = &get_cpu_var(memcg_stock);
> >> +	if (memcg == stock->cached && stock->nr_pages) {
> >> +		if (stock->nr_pages > MAX_CHARGE_BATCH)
> >> +			batch = nr_pages;
> >> +	}
> >> +	put_cpu_var(memcg_stock);
> >
> >The only way excessive stock can build up is if the charging task gets
> >rescheduled, after trying to consume stock a few lines above, to a cpu
> >it was running on when it built up stock in the past.
> >
> >    consume_stock()
> >      memcg != stock->cached:
> >        return false
> >    do_charge()
> >    <reschedule>
> >    refill_stock()
> >      memcg == stock->cached:
> >        stock->nr_pages += nr_pages
> 
> __mem_cgroup_try_charge() {
> 	unsigned int batch = max(CHARGE_BATCH, nr_pages);
> 	[...]
> 	mem_cgroup_do_charge(memcg, gfp_mask, batch, oom_check);
> 	[...]
> 	if(batch > nr_pages)
> 		refill_stock(memcg, batch - nr_pages);
> }
> 
> Consider this scenario, If one task wants to charge nr_pages = 1,
> then batch = max(32,1) = 32, this time 31 excess charges 
> will be charged in mem_cgroup_do_charge and then add to stock by
> refill_stock. Generally there are many tasks in one memory cgroup and 
> maybe charges frequency. In this situation, limit will reach soon, 
> and cause mem_cgroup_reclaim to call try_to_free_mem_cgroup_pages.

But the stock is not a black hole that gets built up for giggles!  The
next time the processes want to charge a page on this cpu, they will
consume it from the stock.  Not add more pages to it.  Look at where
consume_stock() is called.
