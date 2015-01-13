From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 2/3] mm: memcontrol: consolidate memory controller
 initialization
Date: Tue, 13 Jan 2015 15:53:12 +0100
Message-ID: <20150113145312.GH25318@dhcp22.suse.cz>
References: <1420856041-27647-1-git-send-email-hannes@cmpxchg.org>
 <1420856041-27647-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LvO/KLsq8YLIJCY/MzSDVQ5RCMcGsIxtHiXbCBUG4iw=;
        b=l4xP1J9NgdAAshKswBhkw6QBQEjBnuM0tkOChcPmrFzX7fjYXG0z2JkaQoiHECskr+
         YLrGLUUa4oayjNIXB0++xmKroqpA83y16gUf87VAAtqbJA3IBwHuUIOt+DrTtYqCXXxO
         QFQuqsJufUxESxqYuaAijKohdGkI3yX2mLKShbsUifg0Tt9RSRmbOH0qGEqE8ptC15Jj
         9zhYfOnq6mcKek3gya98ZSViClQucmJVhz18X2LJakhP8hN7Xw2O1PoRgMN9wPsGjF56
         hpYvtdNXOhGvea77J8IbWo7fhf3R1Eok49/yDTPp4juN4LqLtkfqXumefYP/Vxj/xKxB
         ScYQ==
Content-Disposition: inline
In-Reply-To: <1420856041-27647-2-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri 09-01-15 21:14:00, Johannes Weiner wrote:
> The initialization code for the per-cpu charge stock and the soft
> limit tree is compact enough to inline it into mem_cgroup_init().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 57 ++++++++++++++++++++++++---------------------------------
>  1 file changed, 24 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aad254b30708..f66bb8f83ac9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2137,17 +2137,6 @@ static void drain_local_stock(struct work_struct *dummy)
>  	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
>  }
>  
> -static void __init memcg_stock_init(void)
> -{
> -	int cpu;
> -
> -	for_each_possible_cpu(cpu) {
> -		struct memcg_stock_pcp *stock =
> -					&per_cpu(memcg_stock, cpu);
> -		INIT_WORK(&stock->work, drain_local_stock);
> -	}
> -}
> -
>  /*
>   * Cache charges(val) to local per_cpu area.
>   * This will be consumed by consume_stock() function, later.
> @@ -4516,26 +4505,6 @@ struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
>  }
>  EXPORT_SYMBOL(parent_mem_cgroup);
>  
> -static void __init mem_cgroup_soft_limit_tree_init(void)
> -{
> -	struct mem_cgroup_tree_per_node *rtpn;
> -	struct mem_cgroup_tree_per_zone *rtpz;
> -	int node, zone;
> -
> -	for_each_node(node) {
> -		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> -		BUG_ON(!rtpn);
> -
> -		soft_limit_tree.rb_tree_per_node[node] = rtpn;
> -
> -		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> -			rtpz = &rtpn->rb_tree_per_zone[zone];
> -			rtpz->rb_root = RB_ROOT;
> -			spin_lock_init(&rtpz->lock);
> -		}
> -	}
> -}
> -
>  static struct cgroup_subsys_state * __ref
>  mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  {
> @@ -5927,10 +5896,32 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>   */
>  static int __init mem_cgroup_init(void)
>  {
> +	int cpu, nid;
> +
>  	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
> +
> +	for_each_possible_cpu(cpu)
> +		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
> +			  drain_local_stock);
> +
> +	for_each_node(nid) {
> +		struct mem_cgroup_tree_per_node *rtpn;
> +		int zone;
> +
> +		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, nid);
> +
> +		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> +			struct mem_cgroup_tree_per_zone *rtpz;
> +
> +			rtpz = &rtpn->rb_tree_per_zone[zone];
> +			rtpz->rb_root = RB_ROOT;
> +			spin_lock_init(&rtpz->lock);
> +		}
> +		soft_limit_tree.rb_tree_per_node[nid] = rtpn;
> +	}
> +
>  	enable_swap_cgroup();
> -	mem_cgroup_soft_limit_tree_init();
> -	memcg_stock_init();
> +
>  	return 0;
>  }
>  subsys_initcall(mem_cgroup_init);
> -- 
> 2.2.0
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
