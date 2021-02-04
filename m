From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 7/7] mm: memcontrol: consolidate lruvec stat flushing
Date: Thu, 4 Feb 2021 13:47:02 -0800
Message-ID: <20210204214702.GA2053809@carbon.dhcp.thefacebook.com>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-8-hannes@cmpxchg.org>
 <20210203022530.GF1812008@carbon.dhcp.thefacebook.com>
 <YBxquyq6XzWlV3Wv@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=b5CsRZlKfhUByhWO6HuSpu54tV6Zf2eXy/IuBs/Ya+k=;
 b=qfdqCP33O4/qTFRQMXSWdxNLjhIc7zfa7ke/Z/qKf8/XIH3Nne4R190lE3YUzoyvs1L2
 cU+odzMkBGcLeyFxHIaKhPO7drhyhyutnK82HSQ9Pow47U3HGyFUVpm+38RDVYyKAM3x
 fThAXpdaYHfqDqPLormCjockUHpsnEojSm4= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5CsRZlKfhUByhWO6HuSpu54tV6Zf2eXy/IuBs/Ya+k=;
 b=Q1wdMx/q9i5pb0fAinX4wdv9jO6sfJ9MCzDK/5B2J6JxhYW3SkRZ9UrvXevrr2GYGCE7FGEUvsBcuJ8t1+32Mr4gzCFZzKNMe01jAku4flfqTqZpnGu8bawacPKWcpH/Ed+F1gL4Mf2DZE5NRGWQ6h6Nd5qhWT1eKmEhw/GD1vc=
Content-Disposition: inline
In-Reply-To: <YBxquyq6XzWlV3Wv-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Feb 04, 2021 at 04:44:27PM -0500, Johannes Weiner wrote:
> On Tue, Feb 02, 2021 at 06:25:30PM -0800, Roman Gushchin wrote:
> > On Tue, Feb 02, 2021 at 01:47:46PM -0500, Johannes Weiner wrote:
> > > There are two functions to flush the per-cpu data of an lruvec into
> > > the rest of the cgroup tree: when the cgroup is being freed, and when
> > > a CPU disappears during hotplug. The difference is whether all CPUs or
> > > just one is being collected, but the rest of the flushing code is the
> > > same. Merge them into one function and share the common code.
> > > 
> > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > ---
> > >  mm/memcontrol.c | 88 +++++++++++++++++++++++--------------------------
> > >  1 file changed, 42 insertions(+), 46 deletions(-)
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index b205b2413186..88e8afc49a46 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2410,39 +2410,56 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
> > >  	mutex_unlock(&percpu_charge_mutex);
> > >  }
> > >  
> > > -static int memcg_hotplug_cpu_dead(unsigned int cpu)
> > > +static void memcg_flush_lruvec_page_state(struct mem_cgroup *memcg, int cpu)
> > >  {
> > > -	struct memcg_stock_pcp *stock;
> > > -	struct mem_cgroup *memcg;
> > > -
> > > -	stock = &per_cpu(memcg_stock, cpu);
> > > -	drain_stock(stock);
> > > +	int nid;
> > >  
> > > -	for_each_mem_cgroup(memcg) {
> > > +	for_each_node(nid) {
> > > +		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
> > > +		unsigned long stat[NR_VM_NODE_STAT_ITEMS] = { 0, };
> >   			      				      ^^^^
> > 							   Same here.
> > 
> > > +		struct batched_lruvec_stat *lstatc;
> > >  		int i;
> > >  
> > > -		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
> > > -			int nid;
> > > -
> > > -			for_each_node(nid) {
> > > -				struct batched_lruvec_stat *lstatc;
> > > -				struct mem_cgroup_per_node *pn;
> > > -				long x;
> > > -
> > > -				pn = memcg->nodeinfo[nid];
> > > +		if (cpu == -1) {
> > > +			int cpui;
> > > +			/*
> > > +			 * The memcg is about to be freed, collect all
> > > +			 * CPUs, no need to zero anything out.
> > > +			 */
> > > +			for_each_online_cpu(cpui) {
> > > +				lstatc = per_cpu_ptr(pn->lruvec_stat_cpu, cpui);
> > > +				for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
> > > +					stat[i] += lstatc->count[i];
> > > +			}
> > > +		} else {
> > > +			/*
> > > +			 * The CPU has gone away, collect and zero out
> > > +			 * its stats, it may come back later.
> > > +			 */
> > > +			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
> > >  				lstatc = per_cpu_ptr(pn->lruvec_stat_cpu, cpu);
> > > -
> > > -				x = lstatc->count[i];
> > > +				stat[i] = lstatc->count[i];
> > >  				lstatc->count[i] = 0;
> > > -
> > > -				if (x) {
> > > -					do {
> > > -						atomic_long_add(x, &pn->lruvec_stat[i]);
> > > -					} while ((pn = parent_nodeinfo(pn, nid)));
> > > -				}
> > >  			}
> > >  		}
> > > +
> > > +		do {
> > > +			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
> > > +				atomic_long_add(stat[i], &pn->lruvec_stat[i]);
> > > +		} while ((pn = parent_nodeinfo(pn, nid)));
> > >  	}
> > > +}
> > > +
> > > +static int memcg_hotplug_cpu_dead(unsigned int cpu)
> > > +{
> > > +	struct memcg_stock_pcp *stock;
> > > +	struct mem_cgroup *memcg;
> > > +
> > > +	stock = &per_cpu(memcg_stock, cpu);
> > > +	drain_stock(stock);
> > > +
> > > +	for_each_mem_cgroup(memcg)
> > > +		memcg_flush_lruvec_page_state(memcg, cpu);
> > >  
> > >  	return 0;
> > >  }
> > > @@ -3636,27 +3653,6 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
> > >  	}
> > >  }
> > >  
> > > -static void memcg_flush_lruvec_page_state(struct mem_cgroup *memcg)
> > > -{
> > > -	int node;
> > > -
> > > -	for_each_node(node) {
> > > -		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
> > > -		unsigned long stat[NR_VM_NODE_STAT_ITEMS] = {0, };
> > > -		struct mem_cgroup_per_node *pi;
> > > -		int cpu, i;
> > > -
> > > -		for_each_online_cpu(cpu)
> > > -			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
> > > -				stat[i] += per_cpu(
> > > -					pn->lruvec_stat_cpu->count[i], cpu);
> > > -
> > > -		for (pi = pn; pi; pi = parent_nodeinfo(pi, node))
> > > -			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
> > > -				atomic_long_add(stat[i], &pi->lruvec_stat[i]);
> > > -	}
> > > -}
> > > -
> > >  #ifdef CONFIG_MEMCG_KMEM
> > >  static int memcg_online_kmem(struct mem_cgroup *memcg)
> > >  {
> > > @@ -5197,7 +5193,7 @@ static void mem_cgroup_free(struct mem_cgroup *memcg)
> > >  	 * Flush percpu lruvec stats to guarantee the value
> > >  	 * correctness on parent's and all ancestor levels.
> > >  	 */
> > > -	memcg_flush_lruvec_page_state(memcg);
> > > +	memcg_flush_lruvec_page_state(memcg, -1);
> > 
> > I wonder if adding "cpu" or "percpu" into the function name will make clearer what -1 means?
> > E.g. memcg_flush_(per)cpu_lruvec_stats(memcg, -1).
> 
> Yes, it's a bit ominous. I changed it to
> 
> 	memcg_flush_lruvec_page_state_cpu(memcg, -1);

Works for me!
But honestly I don't understand what does "page_state" mean in this context.

Thanks!
