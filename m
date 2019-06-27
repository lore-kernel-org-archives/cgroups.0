From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] mm, memcontrol: Add memcg_iterate_all()
Date: Thu, 27 Jun 2019 17:07:46 +0200
Message-ID: <20190627150746.GD5303@dhcp22.suse.cz>
References: <20190624174219.25513-1-longman@redhat.com>
 <20190624174219.25513-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190624174219.25513-2-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Andrea Arcangeli <aarcange@redhat.com>

On Mon 24-06-19 13:42:18, Waiman Long wrote:
> Add a memcg_iterate_all() function for iterating all the available
> memory cgroups and call the given callback function for each of the
> memory cgruops.

Why is a trivial wrapper any better than open coded usage of the
iterator?

> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  include/linux/memcontrol.h |  3 +++
>  mm/memcontrol.c            | 13 +++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 1dcb763bb610..0e31418e5a47 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1268,6 +1268,9 @@ static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
>  struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep);
>  void memcg_kmem_put_cache(struct kmem_cache *cachep);
>  
> +extern void memcg_iterate_all(void (*callback)(struct mem_cgroup *memcg,
> +					       void *arg), void *arg);
> +
>  #ifdef CONFIG_MEMCG_KMEM
>  int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
>  void __memcg_kmem_uncharge(struct page *page, int order);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ba9138a4a1de..c1c4706f7696 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -443,6 +443,19 @@ static int memcg_alloc_shrinker_maps(struct mem_cgroup *memcg)
>  static void memcg_free_shrinker_maps(struct mem_cgroup *memcg) { }
>  #endif /* CONFIG_MEMCG_KMEM */
>  
> +/*
> + * Iterate all the memory cgroups and call the given callback function
> + * for each of the memory cgroups.
> + */
> +void memcg_iterate_all(void (*callback)(struct mem_cgroup *memcg, void *arg),
> +		       void *arg)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	for_each_mem_cgroup(memcg)
> +		callback(memcg, arg);
> +}
> +
>  /**
>   * mem_cgroup_css_from_page - css of the memcg associated with a page
>   * @page: page of interest
> -- 
> 2.18.1

-- 
Michal Hocko
SUSE Labs
