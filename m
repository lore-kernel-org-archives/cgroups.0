From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: reduce the size of struct memcg 244-fold.
Date: Wed, 23 Jan 2013 16:18:10 -0800
Message-ID: <20130123161810.73e4ca58.akpm@linux-foundation.org>
References: <1358962426-8738-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358962426-8738-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, 23 Jan 2013 21:33:46 +0400
Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

> In order to maintain all the memcg bookkeeping, we need per-node
> descriptors, which will in turn contain a per-zone descriptor.
> 
> Because we want to statically allocate those, this array ends up being
> very big. Part of the reason is that we allocate something large enough
> to hold MAX_NUMNODES, the compile time constant that holds the maximum
> number of nodes we would ever consider.
> 
> However, we can do better in some cases if the firmware help us. This is
> true for modern x86 machines; coincidentally one of the architectures in
> which MAX_NUMNODES tends to be very big.
> 
> By using the firmware-provided maximum number of nodes instead of
> MAX_NUMNODES, we can reduce the memory footprint of struct memcg
> considerably. In the extreme case in which we have only one node, this
> reduces the size of the structure from ~ 64k to ~2k. This is
> particularly important because it means that we will no longer resort to
> the vmalloc area for the struct memcg on defconfigs. We also have enough
> room for an extra node and still be outside vmalloc.
> 
> One also has to keep in mind that with the industry's ability to fit
> more processors in a die as fast as the FED prints money, a nodes = 2
> configuration is already respectably big.

Seems sensible.

> +static inline int memcg_size(void)
> +{
> +	return sizeof(struct mem_cgroup) +
> +		nr_node_ids * sizeof(struct mem_cgroup_per_node);
> +}
> +
>  /* internal only representation about the status of kmem accounting. */
>  enum {
>  	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
> @@ -5894,9 +5904,9 @@ static void free_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
>  static struct mem_cgroup *mem_cgroup_alloc(void)
>  {
>  	struct mem_cgroup *memcg;
> -	int size = sizeof(struct mem_cgroup);
> +	int size = memcg_size();
>  
> -	/* Can be very big if MAX_NUMNODES is very big */
> +	/* Can be very big if nr_node_ids is very big */
>  	if (size < PAGE_SIZE)
>  		memcg = kzalloc(size, GFP_KERNEL);
>  	else
> @@ -5933,7 +5943,7 @@ out_free:
>  static void __mem_cgroup_free(struct mem_cgroup *memcg)
>  {
>  	int node;
> -	int size = sizeof(struct mem_cgroup);
> +	int size = memcg_size();
>  
>  	mem_cgroup_remove_from_trees(memcg);
>  	free_css_id(&mem_cgroup_subsys, &memcg->css);

Really everything here should be using size_t - a minor
cosmetic/readability thing.
