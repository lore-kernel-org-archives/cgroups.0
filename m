From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH RFC 3/3] drm/ttm: support memcg for ttm_tt
Date: Mon, 13 Jan 2020 16:55:47 +0100
Message-ID: <f2075f28-94a2-1206-ba58-a3a6a32393f3@amd.com>
References: <20200113153543.24957-1-qiang.yu@amd.com>
 <20200113153543.24957-4-qiang.yu@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLPWq8D42ESuKs+vGGWa65Rbhv86/dt79zfyvRTSz6Y=;
 b=lU/7LporyIr+LV/4mc8vwc6UYm2obwCekeBfq0J1o8VeQOPhwLwzb2uohu/zDpe51pyViWdKTxvaNfyYv8mtQAkFn048INPOvG3Xg9hJB9B1nRHRf26U9hFBaNrlNsG9K0Cn17plHc0pDU4FnmWcr219TRtLT+UicsXJ780meeY=
In-Reply-To: <20200113153543.24957-4-qiang.yu-5C7GfCeVMHo@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Qiang Yu <qiang.yu-5C7GfCeVMHo@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Huang Rui <ray.huang-5C7GfCeVMHo@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Kenny Ho <kenny.ho-5C7GfCeVMHo@public.gmane.org>

Am 13.01.20 um 16:35 schrieb Qiang Yu:
> Charge TTM allocated system memory to memory cgroup which will
> limit the memory usage of a group of processes.

NAK to the whole approach. This belongs into the GEM or driver layer, 
but not into TTM.

> The memory is always charged to the control group of task which
> create this buffer object and when it's created. For example,
> when a buffer is created by process A and exported to process B,
> then process B populate this buffer, the memory is still charged
> to process A's memcg; if a buffer is created by process A when in
> memcg B, then A is moved to memcg C and populate this buffer, it
> will charge memcg B.

This is actually the most common use case for graphics application where 
the X server allocates most of the backing store.

So we need a better handling than just accounting the memory to whoever 
allocated it first.

Regards,
Christian.

>
> Signed-off-by: Qiang Yu <qiang.yu-5C7GfCeVMHo@public.gmane.org>
> ---
>   drivers/gpu/drm/ttm/ttm_bo.c         | 10 ++++++++++
>   drivers/gpu/drm/ttm/ttm_page_alloc.c | 18 +++++++++++++++++-
>   drivers/gpu/drm/ttm/ttm_tt.c         |  3 +++
>   include/drm/ttm/ttm_bo_api.h         |  5 +++++
>   include/drm/ttm/ttm_tt.h             |  4 ++++
>   5 files changed, 39 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
> index 8d91b0428af1..4e64846ee523 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -42,6 +42,7 @@
>   #include <linux/module.h>
>   #include <linux/atomic.h>
>   #include <linux/dma-resv.h>
> +#include <linux/memcontrol.h>
>   
>   static void ttm_bo_global_kobj_release(struct kobject *kobj);
>   
> @@ -162,6 +163,10 @@ static void ttm_bo_release_list(struct kref *list_kref)
>   	if (!ttm_bo_uses_embedded_gem_object(bo))
>   		dma_resv_fini(&bo->base._resv);
>   	mutex_destroy(&bo->wu_mutex);
> +#ifdef CONFIG_MEMCG
> +	if (bo->memcg)
> +		css_put(&bo->memcg->css);
> +#endif
>   	bo->destroy(bo);
>   	ttm_mem_global_free(&ttm_mem_glob, acc_size);
>   }
> @@ -1330,6 +1335,11 @@ int ttm_bo_init_reserved(struct ttm_bo_device *bdev,
>   	}
>   	atomic_inc(&ttm_bo_glob.bo_count);
>   
> +#ifdef CONFIG_MEMCG
> +	if (bo->type == ttm_bo_type_device)
> +		bo->memcg = mem_cgroup_driver_get_from_current();
> +#endif
> +
>   	/*
>   	 * For ttm_bo_type_device buffers, allocate
>   	 * address space from the device.
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> index b40a4678c296..ecd1831a1d38 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> @@ -42,7 +42,7 @@
>   #include <linux/seq_file.h> /* for seq_printf */
>   #include <linux/slab.h>
>   #include <linux/dma-mapping.h>
> -
> +#include <linux/memcontrol.h>
>   #include <linux/atomic.h>
>   
>   #include <drm/ttm/ttm_bo_driver.h>
> @@ -1045,6 +1045,11 @@ ttm_pool_unpopulate_helper(struct ttm_tt *ttm, unsigned mem_count_update)
>   	ttm_put_pages(ttm->pages, ttm->num_pages, ttm->page_flags,
>   		      ttm->caching_state);
>   	ttm->state = tt_unpopulated;
> +
> +#ifdef CONFIG_MEMCG
> +	if (ttm->memcg)
> +		mem_cgroup_uncharge_drvmem(ttm->memcg, ttm->num_pages);
> +#endif
>   }
>   
>   int ttm_pool_populate(struct ttm_tt *ttm, struct ttm_operation_ctx *ctx)
> @@ -1059,6 +1064,17 @@ int ttm_pool_populate(struct ttm_tt *ttm, struct ttm_operation_ctx *ctx)
>   	if (ttm_check_under_lowerlimit(mem_glob, ttm->num_pages, ctx))
>   		return -ENOMEM;
>   
> +#ifdef CONFIG_MEMCG
> +	if (ttm->memcg) {
> +		gfp_t gfp_flags = GFP_USER;
> +		if (ttm->page_flags & TTM_PAGE_FLAG_NO_RETRY)
> +			gfp_flags |= __GFP_RETRY_MAYFAIL;
> +		ret = mem_cgroup_charge_drvmem(ttm->memcg, gfp_flags, ttm->num_pages);
> +		if (ret)
> +			return ret;
> +	}
> +#endif
> +
>   	ret = ttm_get_pages(ttm->pages, ttm->num_pages, ttm->page_flags,
>   			    ttm->caching_state);
>   	if (unlikely(ret != 0)) {
> diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
> index e0e9b4f69db6..1acb153084e1 100644
> --- a/drivers/gpu/drm/ttm/ttm_tt.c
> +++ b/drivers/gpu/drm/ttm/ttm_tt.c
> @@ -233,6 +233,9 @@ void ttm_tt_init_fields(struct ttm_tt *ttm, struct ttm_buffer_object *bo,
>   	ttm->state = tt_unpopulated;
>   	ttm->swap_storage = NULL;
>   	ttm->sg = bo->sg;
> +#ifdef CONFIG_MEMCG
> +	ttm->memcg = bo->memcg;
> +#endif
>   }
>   
>   int ttm_tt_init(struct ttm_tt *ttm, struct ttm_buffer_object *bo,
> diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
> index 65e399d280f7..95a08e81a73e 100644
> --- a/include/drm/ttm/ttm_bo_api.h
> +++ b/include/drm/ttm/ttm_bo_api.h
> @@ -54,6 +54,8 @@ struct ttm_place;
>   
>   struct ttm_lru_bulk_move;
>   
> +struct mem_cgroup;
> +
>   /**
>    * struct ttm_bus_placement
>    *
> @@ -180,6 +182,9 @@ struct ttm_buffer_object {
>   	void (*destroy) (struct ttm_buffer_object *);
>   	unsigned long num_pages;
>   	size_t acc_size;
> +#ifdef CONFIG_MEMCG
> +	struct mem_cgroup *memcg;
> +#endif
>   
>   	/**
>   	* Members not needing protection.
> diff --git a/include/drm/ttm/ttm_tt.h b/include/drm/ttm/ttm_tt.h
> index c0e928abf592..10fb5a557b95 100644
> --- a/include/drm/ttm/ttm_tt.h
> +++ b/include/drm/ttm/ttm_tt.h
> @@ -33,6 +33,7 @@ struct ttm_tt;
>   struct ttm_mem_reg;
>   struct ttm_buffer_object;
>   struct ttm_operation_ctx;
> +struct mem_cgroup;
>   
>   #define TTM_PAGE_FLAG_WRITE           (1 << 3)
>   #define TTM_PAGE_FLAG_SWAPPED         (1 << 4)
> @@ -116,6 +117,9 @@ struct ttm_tt {
>   		tt_unbound,
>   		tt_unpopulated,
>   	} state;
> +#ifdef CONFIG_MEMCG
> +	struct mem_cgroup *memcg;
> +#endif
>   };
>   
>   /**

