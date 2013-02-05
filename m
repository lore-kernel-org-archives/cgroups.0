From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: reduce the size of struct memcg 244-fold.
Date: Tue, 5 Feb 2013 20:04:54 +0100
Message-ID: <20130205190454.GC3959@dhcp22.suse.cz>
References: <1359009996-5350-1-git-send-email-glommer@parallels.com>
 <20130205185324.GB6481@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=PxQg+X1W3Dnwh4f8RNeNVRXsiMqG0FrLMHiSC/VJJKg=;
        b=cgUJZzedE9qc0TbacYEcV+oBOeumFMN3mWHckDRV79e2W8VUuF+NMOs1bB3Z/RMCGO
         qQk00cXIOlbtiac8DnotzbGLDxvS17dhyCsNULwuLsubxe2t1xyOmFCnS8TLQ8LMe8T5
         9B9oqX2FYDdn4qrmgeffyoX/rDORDQ1Yh7+D3wVtrpnstqig9cVjqh/fNw/XveWsiBzS
         HKDVweNdm4Jfblth7MX7e35iAk5PH2rnDexf/JBN0SZRFfIYolKMJpJkfaUDhbdnq4Bd
         HBl6qs/4vd8rgXbt/oRmVSnm1k0s4WFzhwFFD/nGXe0arpVUfNjBu+pT1BPyoJwjI/B8
         8WTQ==
Content-Disposition: inline
In-Reply-To: <20130205185324.GB6481-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue 05-02-13 13:53:24, Johannes Weiner wrote:
[...]
> Subject: [patch] memcg: reduce the size of struct memcg 244-fold morrr fix
> 
> Remove struct mem_cgroup_lru_info.  It only holds the nodeinfo array
> and is actively misleading because there is all kinds of per-node
> stuff in addition to the LRU info in there.  On that note, remove the
> incorrect comment as well.
> 
> Move comment about the nodeinfo[0] array having to be the last field
> in struct mem_cgroup after said array.  Should be more visible when
> attempting to append new members to the struct.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Yes, I like this. The info level is just artificatial and without any
good reason.

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Thanks

> ---
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2382fe9..29cb9e9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -179,10 +179,6 @@ struct mem_cgroup_per_node {
>  	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
>  };
>  
> -struct mem_cgroup_lru_info {
> -	struct mem_cgroup_per_node *nodeinfo[0];
> -};
> -
>  /*
>   * Cgroups above their limits are maintained in a RB-Tree, independent of
>   * their hierarchy representation
> @@ -370,14 +366,8 @@ struct mem_cgroup {
>  	atomic_t	numainfo_events;
>  	atomic_t	numainfo_updating;
>  #endif
> -	/*
> -	 * Per cgroup active and inactive list, similar to the
> -	 * per zone LRU lists.
> -	 *
> -	 * WARNING: This has to be the last element of the struct. Don't
> -	 * add new fields after this point.
> -	 */
> -	struct mem_cgroup_lru_info info;
> +	struct mem_cgroup_per_node *nodeinfo[0];
> +	/* WARNING: nodeinfo has to be the last member in here */
>  };
>  
>  static inline size_t memcg_size(void)
> @@ -718,7 +708,7 @@ static struct mem_cgroup_per_zone *
>  mem_cgroup_zoneinfo(struct mem_cgroup *memcg, int nid, int zid)
>  {
>  	VM_BUG_ON((unsigned)nid >= nr_node_ids);
> -	return &memcg->info.nodeinfo[nid]->zoneinfo[zid];
> +	return &memcg->nodeinfo[nid]->zoneinfo[zid];
>  }
>  
>  struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
> @@ -6093,13 +6083,13 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
>  		mz->on_tree = false;
>  		mz->memcg = memcg;
>  	}
> -	memcg->info.nodeinfo[node] = pn;
> +	memcg->nodeinfo[node] = pn;
>  	return 0;
>  }
>  
>  static void free_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
>  {
> -	kfree(memcg->info.nodeinfo[node]);
> +	kfree(memcg->nodeinfo[node]);
>  }
>  
>  static struct mem_cgroup *mem_cgroup_alloc(void)
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
