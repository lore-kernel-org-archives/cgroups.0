From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH memcg v5] net: set proper memcg for net_init hooks
 allocations
Date: Mon, 30 May 2022 11:57:48 +0300
Message-ID: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
References: <CALvZod5HugCO2G3+Av3pXC6s2sy0zKW_HRaRyhOO9GOOWV1SsQ@mail.gmail.com>
 <0ccfe7a4-c178-0b66-d481-2326c85a8ffb@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject
         :content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=lAZ+j4i7HJwXaSuMT5P/9OWwy3X9DfOqr/MHBEG4KHI=;
        b=aDnPkj6r5ZzjADGCBpBF0k2//QShcfRFpuzPbuPgGZvD1xyq81kSN27OswexYp7b4Y
         +sZn/ScrbzAoL29odFLAPT/8ckwv6U08kqj4rQhfGnq+w/Ci3V3z9WDQQSuOlz2fdTGu
         +Xq9fkeacpiSJPniUbxXbjMJSA//GNTsaKoS3JfWa1O2rtOa7HtZJ3wnbZi/a3S82gDW
         rd2RMVXROO10vULaokSHE2OCkAc3nm9DLdIfU9vG8x7/1sPPvKqqqrzFpLLDbZ2DDT+C
         pEYB3X5lXUGsvCUc3usc7dqIROPrdOvOX8YXV8zE2MbysPBjl/kzIhyBm3cCRN03/5ot
         yfJQ==
Content-Language: en-US
In-Reply-To: <0ccfe7a4-c178-0b66-d481-2326c85a8ffb-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Dear Andrew,
could you please pick up this patch?

Thank you,
	Vasily Averin

On 5/2/22 03:10, Vasily Averin wrote:
> __register_pernet_operations() executes init hook of registered
> pernet_operation structure in all existing net namespaces.
> 
> Typically, these hooks are called by a process associated with
> the specified net namespace, and all __GFP_ACCOUNT marked
> allocation are accounted for corresponding container/memcg.
> 
> However __register_pernet_operations() calls the hooks in the same
> context, and as a result all marked allocations are accounted
> to one memcg for all processed net namespaces.
> 
> This patch adjusts active memcg for each net namespace and helps
> to account memory allocated inside ops_init() into the proper memcg.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> ---
> v5: documented get_mem_cgroup_from_obj() and for mem_cgroup_or_root()
>     functions, asked by Shakeel.
> 
> v4: get_mem_cgroup_from_kmem() renamed to get_mem_cgroup_from_obj(),
>     get_net_memcg() renamed to mem_cgroup_or_root(), suggested by Roman.
> 
> v3: put_net_memcg() replaced by an alreay existing mem_cgroup_put()
>     It checks memcg before accessing it, this is required for
>     __register_pernet_operations() called before memcg initialization.
>     Additionally fixed leading whitespaces in non-memcg_kmem version
>     of mem_cgroup_from_obj().
> 
> v2: introduced get/put_net_memcg(),
>     new functions are moved under CONFIG_MEMCG_KMEM
>     to fix compilation issues reported by Intel's kernel test robot
> 
> v1: introduced get_mem_cgroup_from_kmem(), which takes the refcount
>     for the found memcg, suggested by Shakeel
> ---
>  include/linux/memcontrol.h | 47 +++++++++++++++++++++++++++++++++++++-
>  net/core/net_namespace.c   |  7 ++++++
>  2 files changed, 53 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0abbd685703b..6405f9b8f5a8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1714,6 +1714,42 @@ static inline int memcg_cache_id(struct mem_cgroup *memcg)
>  
>  struct mem_cgroup *mem_cgroup_from_obj(void *p);
>  
> +/**
> + * get_mem_cgroup_from_obj - get a memcg associated with passed kernel object.
> + * @p: pointer to object from which memcg should be extracted. It can be NULL.
> + *
> + * Retrieves the memory group into which the memory of the pointed kernel
> + * object is accounted. If memcg is found, its reference is taken.
> + * If a passed kernel object is uncharged, or if proper memcg cannot be found,
> + * as well as if mem_cgroup is disabled, NULL is returned.
> + *
> + * Return: valid memcg pointer with taken reference or NULL.
> + */
> +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	do {
> +		memcg = mem_cgroup_from_obj(p);
> +	} while (memcg && !css_tryget(&memcg->css));
> +	rcu_read_unlock();
> +	return memcg;
> +}
> +
> +/**
> + * mem_cgroup_or_root - always returns a pointer to a valid memory cgroup.
> + * @memcg: pointer to a valid memory cgroup or NULL.
> + *
> + * If passed argument is not NULL, returns it without any additional checks
> + * and changes. Otherwise, root_mem_cgroup is returned.
> + *
> + * NOTE: root_mem_cgroup can be NULL during early boot.
> + */
> +static inline struct mem_cgroup *mem_cgroup_or_root(struct mem_cgroup *memcg)
> +{
> +	return memcg ? memcg : root_mem_cgroup;
> +}
>  #else
>  static inline bool mem_cgroup_kmem_disabled(void)
>  {
> @@ -1763,9 +1799,18 @@ static inline void memcg_put_cache_ids(void)
>  
>  static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
>  {
> -       return NULL;
> +	return NULL;
>  }
>  
> +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
> +{
> +	return NULL;
> +}
> +
> +static inline struct mem_cgroup *mem_cgroup_or_root(struct mem_cgroup *memcg)
> +{
> +	return NULL;
> +}
>  #endif /* CONFIG_MEMCG_KMEM */
>  
>  #endif /* _LINUX_MEMCONTROL_H */
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index a5b5bb99c644..240f3db77dec 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -26,6 +26,7 @@
>  #include <net/net_namespace.h>
>  #include <net/netns/generic.h>
>  
> +#include <linux/sched/mm.h>
>  /*
>   *	Our network namespace constructor/destructor lists
>   */
> @@ -1147,7 +1148,13 @@ static int __register_pernet_operations(struct list_head *list,
>  		 * setup_net() and cleanup_net() are not possible.
>  		 */
>  		for_each_net(net) {
> +			struct mem_cgroup *old, *memcg;
> +
> +			memcg = mem_cgroup_or_root(get_mem_cgroup_from_obj(net));
> +			old = set_active_memcg(memcg);
>  			error = ops_init(ops, net);
> +			set_active_memcg(old);
> +			mem_cgroup_put(memcg);
>  			if (error)
>  				goto out_undo;
>  			list_add_tail(&net->exit_list, &net_exit_list);

