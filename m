From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v11 09/15] memcg,list_lru: add per-memcg LRU list
 infrastructure
Date: Mon, 25 Nov 2013 11:56:39 -0500
Message-ID: <20131125165639.GD22729@cmpxchg.org>
References: <cover.1385377616.git.vdavydov@parallels.com>
 <e7f905d1cb6af578b8e6e872da909cfbf85030ad.1385377616.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=p+BWEcXh4w1iUBcHsQl3JXTJKi18Zdgtx6aksJZkOtY=;
	b=Ngtk6dhcBjBey/RTWRjfHaHT8V9MnwOsrwxe2udqoCl36kntQZp66g1szrCsF0um6RTGKuU/VD7UfA6ooJgnBjXk7T7tEV+PfuuxFrr3KRRZtIR41P+I8HlHyTv4eAwtsN3I/dN62AY5A6uZkMQcFNeHzrmqTBybcQJ6b++RBYI=;
Content-Disposition: inline
In-Reply-To: <e7f905d1cb6af578b8e6e872da909cfbf85030ad.1385377616.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Mon, Nov 25, 2013 at 04:07:42PM +0400, Vladimir Davydov wrote:
> FS-shrinkers, which shrink dcaches and icaches, keep dentries and inodes
> in list_lru structures in order to evict least recently used objects.
> With per-memcg kmem shrinking infrastructure introduced, we have to make
> those LRU lists per-memcg in order to allow shrinking FS caches that
> belong to different memory cgroups independently.
> 
> This patch addresses the issue by introducing struct memcg_list_lru.
> This struct aggregates list_lru objects for each kmem-active memcg, and
> keeps it uptodate whenever a memcg is created or destroyed. Its
> interface is very simple: it only allows to get the pointer to the
> appropriate list_lru object from a memcg or a kmem ptr, which should be
> further operated with conventional list_lru methods.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Cc: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> ---
>  include/linux/list_lru.h |   56 ++++++++++
>  mm/memcontrol.c          |  256 ++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 306 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> index 3ce5417..b3b3b86 100644
> --- a/include/linux/list_lru.h
> +++ b/include/linux/list_lru.h
> @@ -10,6 +10,8 @@
>  #include <linux/list.h>
>  #include <linux/nodemask.h>
>  
> +struct mem_cgroup;
> +
>  /* list_lru_walk_cb has to always return one of those */
>  enum lru_status {
>  	LRU_REMOVED,		/* item removed from list */
> @@ -31,6 +33,27 @@ struct list_lru {
>  	nodemask_t		active_nodes;
>  };
>  
> +struct memcg_list_lru {
> +	struct list_lru global_lru;
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +	struct list_lru **memcg_lrus;	/* rcu-protected array of per-memcg
> +					   lrus, indexed by memcg_cache_id() */
> +
> +	struct list_head list;		/* list of all memcg-aware lrus */
> +
> +	/*
> +	 * The memcg_lrus array is rcu protected, so we can only free it after
> +	 * a call to synchronize_rcu(). To avoid multiple calls to
> +	 * synchronize_rcu() when many lrus get updated at the same time, which
> +	 * is a typical scenario, we will store the pointer to the previous
> +	 * version of the array in the old_lrus variable for each lru, and then
> +	 * free them all at once after a single call to synchronize_rcu().
> +	 */
> +	void *old_lrus;
> +#endif
> +};
> +
>  void list_lru_destroy(struct list_lru *lru);
>  int list_lru_init(struct list_lru *lru);
>  
> @@ -128,4 +151,37 @@ list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
>  	}
>  	return isolated;
>  }
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +int memcg_list_lru_init(struct memcg_list_lru *lru);
> +void memcg_list_lru_destroy(struct memcg_list_lru *lru);
> +
> +struct list_lru *
> +mem_cgroup_list_lru(struct memcg_list_lru *lru, struct mem_cgroup *memcg);
> +struct list_lru *
> +mem_cgroup_kmem_list_lru(struct memcg_list_lru *lru, void *ptr);
> +#else
> +static inline int memcg_list_lru_init(struct memcg_list_lru *lru)
> +{
> +	return list_lru_init(&lru->global_lru);
> +}
> +
> +static inline void memcg_list_lru_destroy(struct memcg_list_lru *lru)
> +{
> +	list_lru_destroy(&lru->global_lru);
> +}
> +
> +static inline struct list_lru *
> +mem_cgroup_list_lru(struct memcg_list_lru *lru, struct mem_cgroup *memcg)
> +{
> +	return &lru->global_lru;
> +}
> +
> +static inline struct list_lru *
> +mem_cgroup_kmem_list_lru(struct memcg_list_lru *lru, void *ptr)
> +{
> +	return &lru->global_lru;
> +}
> +#endif /* CONFIG_MEMCG_KMEM */
> +
>  #endif /* _LRU_LIST_H */
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f5d7128..84f1ca3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -55,6 +55,7 @@
>  #include <linux/cpu.h>
>  #include <linux/oom.h>
>  #include <linux/lockdep.h>
> +#include <linux/list_lru.h>
>  #include "internal.h"
>  #include <net/sock.h>
>  #include <net/ip.h>
> @@ -3249,6 +3250,8 @@ void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep)
>  	mutex_unlock(&memcg->slab_caches_mutex);
>  }
>  
> +static int memcg_update_all_lrus(int num_groups);

This name is a red flag.  It does not say what the function does, and
return value and parameter are unexpected.
