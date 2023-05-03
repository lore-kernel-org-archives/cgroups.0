From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [Intel-gfx] [RFC PATCH 2/4] drm/cgroup: Add memory accounting to
 DRM cgroup
Date: Wed, 3 May 2023 16:31:19 +0100
Message-ID: <c9d1e666-50e9-d66a-d751-f4ec39fcb7bb@linux.intel.com>
References: <20230503083500.645848-1-maarten.lankhorst@linux.intel.com>
 <20230503083500.645848-3-maarten.lankhorst@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683127976; x=1714663976;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BN2BK+oeCHCUZaZ4NEBc8WA1+u9GPhP/CnBYczQWvAI=;
  b=XQLXPjkTO8zlJT9r/t/whLrxO3kC0WUWg1pSJEvRxxWFI3ST15iHW66P
   zZo3LrPqlQ5hanOPHTeWF/KOLr5vC+EcxFp6xN+J4eYJXQiu9Z0Cp2q30
   RNh5rYWLcou1tp9dAYm0FjFm/Nkbr21dqoi7AAaPmWc1y1ybBA3G9kV34
   UVSmp6+38bjiAncL6GlBd2Ef51WedZ2QoEMNkT3h5t277fj2b/leBTwwB
   syR1VKN+qpCbzWYzUFrhf6Y3PXXvEygJonDeQ1vDMwuRjFpleET/5kl2c
   07rDDQ4CfMoTOS8iHulBAVgecpqHw1lpeSG17waTp9CpXl9PGHr0zbNSD
   Q==;
Content-Language: en-US
In-Reply-To: <20230503083500.645848-3-maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-xe-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


On 03/05/2023 09:34, Maarten Lankhorst wrote:
> Based roughly on the rdma and misc cgroup controllers, with a lot of
> the accounting code borrowed from rdma.
>=20
> The interface is simple:
> - populate drmcgroup_device->regions[..] name and size for each active
>    region.
> - Call drm(m)cg_register_device()
> - Use drmcg_try_charge to check if you can allocate a chunk of memory,
>    use drmcg_uncharge when freeing it. This may return an error code,
>    or -EAGAIN when the cgroup limit is reached.
>=20
> The ttm code transforms -EAGAIN back to -ENOSPC since it has specific
> logic for -ENOSPC, and returning -EAGAIN to userspace causes drmIoctl
> to restart infinitely.
>=20
> This API allows you to limit stuff with cgroups.
> You can see the supported cards in /sys/fs/cgroup/drm.capacity
> You need to echo +drm to cgroup.subtree_control, and then you can
> partition memory.
>=20
> In each cgroup subdir:
> drm.max shows the current limits of the cgroup.
> drm.current the current amount of allocated memory used by this cgroup.
> drm.events shows the amount of time max memory was reached.

Events is not in the patch?

> Signed-off-by: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/C=
A@public.gmane.org>
> ---
>   Documentation/admin-guide/cgroup-v2.rst |  46 ++
>   Documentation/gpu/drm-compute.rst       |  54 +++
>   include/linux/cgroup_drm.h              |  81 ++++
>   kernel/cgroup/drm.c                     | 539 +++++++++++++++++++++++-
>   4 files changed, 699 insertions(+), 21 deletions(-)
>   create mode 100644 Documentation/gpu/drm-compute.rst
>=20
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admi=
n-guide/cgroup-v2.rst
> index f67c0829350b..b858d99cb2ef 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2374,6 +2374,52 @@ RDMA Interface Files
>   	  mlx4_0 hca_handle=3D1 hca_object=3D20
>   	  ocrdma1 hca_handle=3D1 hca_object=3D23
>  =20
> +DRM
> +----
> +
> +The "drm" controller regulates the distribution and accounting of
> +DRM resources.
> +
> +DRM Interface Files
> +~~~~~~~~~~~~~~~~~~~~
> +
> +  drm.max
> +	A readwrite nested-keyed file that exists for all the cgroups
> +	except root that describes current configured resource limit
> +	for a DRM device.
> +
> +	Lines are keyed by device name and are not ordered.
> +	Each line contains space separated resource name and its configured
> +	limit that can be distributed.
> +
> +	The following nested keys are defined.
> +
> +	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +	  region.* 	Maximum amount of bytes that allocatable in this region
> +	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +	An example for xe follows::
> +
> +	  0000:03:00.0 region.vram0=3D1073741824 region.stolen=3Dmax
> +
> +  drm.capacity
> +	A read-only file that describes maximum region capacity.
> +	It only exists on the root cgroup. Not all memory can be
> +	allocated by cgroups, as the kernel reserves some for
> +	internal use.
> +
> +	An example for xe follows::
> +
> +	  0000:03:00.0 region.vram0=3D8514437120 region.stolen=3D67108864
> +
> +  drm.current
> +	A read-only file that describes current resource usage.
> +	It exists for all the cgroup except root.
> +
> +	An example for xe follows::
> +
> +	  0000:03:00.0 region.vram0=3D12550144 region.stolen=3D8650752
> +
>   HugeTLB
>   -------
>  =20
> diff --git a/Documentation/gpu/drm-compute.rst b/Documentation/gpu/drm-co=
mpute.rst
> new file mode 100644
> index 000000000000..116270976ef7
> --- /dev/null
> +++ b/Documentation/gpu/drm-compute.rst
> @@ -0,0 +1,54 @@
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Long running workloads and compute
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Long running workloads (compute) are workloads that will not complete in=
 10
> +seconds. (The time let the user wait before he reaches for the power but=
ton).
> +This means that other techniques need to be used to manage those workloa=
ds,
> +that cannot use fences.
> +
> +Some hardware may schedule compute jobs, and have no way to pre-empt the=
m, or
> +have their memory swapped out from them. Or they simply want their workl=
oad
> +not to be preempted or swapped out at all.
> +
> +This means that it differs from what is described in driver-api/dma-buf.=
rst.
> +
> +As with normal compute jobs, dma-fence may not be used at all. In this c=
ase,
> +not even to force preemption. The driver with is simply forced to unmap =
a BO
> +from the long compute job's address space on unbind immediately, not even
> +waiting for the workload to complete. Effectively this terminates the wo=
rkload
> +when there is no hardware support to recover.
> +
> +Since this is undesirable, there need to be mitigations to prevent a wor=
kload
> +from being terminated. There are several possible approach, all with the=
ir
> +advantages and drawbacks.
> +
> +The first approach you will likely try is to pin all buffers used by com=
pute.
> +This guarantees that the job will run uninterrupted, but also allows a v=
ery
> +denial of service attack by pinning as much memory as possible, hogging =
the
> +all GPU memory, and possibly a huge chunk of CPU memory.
> +
> +A second approach that will work slightly better on its own is adding an=
 option
> +not to evict when creating a new job (any kind). If all of userspace opt=
s in
> +to this flag, it would prevent cooperating userspace from forced termina=
ting
> +older compute jobs to start a new one.
> +
> +If job preemption and recoverable pagefaults are not available, those ar=
e the
> +only approaches possible. So even with those, you want a separate way of
> +controlling resources. The standard kernel way of doing so is cgroups.
> +
> +This creates a third option, using cgroups to prevent eviction. Both GPU=
 and
> +driver-allocated CPU memory would be accounted to the correct cgroup, and
> +eviction would be made cgroup aware. This allows the GPU to be partition=
ed
> +into cgroups, that will allow jobs to run next to each other without
> +interference.

The 3rd approach is only valid if used strictly with device local=20
memory, right? Because as soon as system memory backed buffers are used=20
this approach cannot guarantee no eviction can be triggered.

> +
> +The interface to the cgroup would be similar to the current CPU memory
> +interface, with similar semantics for min/low/high/max, if eviction can
> +be made cgroup aware. For now only max is implemented.
> +
> +What should be noted is that each memory region (tiled memory for exampl=
e)
> +should have its own accounting, using $card key0 =3D value0 key1 =3D val=
ue1.
> +
> +The key is set to the regionid set by the driver, for example "tile0".
> +For the value of $card, we use drmGetUnique().
> diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
> index 8ef66a47619f..4f17b1c85f47 100644
> --- a/include/linux/cgroup_drm.h
> +++ b/include/linux/cgroup_drm.h
> @@ -6,4 +6,85 @@
>   #ifndef _CGROUP_DRM_H
>   #define _CGROUP_DRM_H
>  =20
> +#include <linux/types.h>
> +
> +#include <drm/drm_managed.h>
> +
> +struct drm_device;
> +struct drm_file;
> +
> +struct drmcgroup_state;
> +
> +/*
> + * Use 8 as max, because of N^2 lookup when setting things, can be bumpe=
d if needed
> + * Identical to TTM_NUM_MEM_TYPES to allow simplifying that code.
> + */
> +#define DRMCG_MAX_REGIONS 8
> +
> +struct drmcgroup_device {
> +	struct list_head list;
> +	struct list_head pools;
> +
> +	struct {
> +		u64 size;
> +		const char *name;
> +	} regions[DRMCG_MAX_REGIONS];
> +
> +	/* Name describing the card, set by drmcg_register_device */
> +	const char *name;
> +
> +};
> +
> +#if IS_ENABLED(CONFIG_CGROUP_DRM)
> +int drmcg_register_device(struct drm_device *dev,
> +			   struct drmcgroup_device *drm_cg);
> +void drmcg_unregister_device(struct drmcgroup_device *cgdev);
> +int drmcg_try_charge(struct drmcgroup_state **drmcg,
> +		     struct drmcgroup_device *cgdev,
> +		     u32 index, u64 size);
> +void drmcg_uncharge(struct drmcgroup_state *drmcg,
> +		    struct drmcgroup_device *cgdev,
> +		    u32 index, u64 size);
> +#else
> +static inline int
> +drmcg_register_device(struct drm_device *dev,
> +		      struct drm_cgroup *drm_cg)
> +{
> +	return 0;
> +}
> +
> +static inline void drmcg_unregister_device(struct drmcgroup_device *cgde=
v)
> +{
> +}
> +
> +static inline int drmcg_try_charge(struct drmcgroup_state **drmcg,
> +				   struct drmcgroup_device *cgdev,
> +				   u32 index, u64 size)
> +{
> +	*drmcg =3D NULL;
> +	return 0;
> +}
> +
> +static inline void drmcg_uncharge(struct drmcgroup_state *drmcg,
> +				  struct drmcgroup_device *cgdev,
> +				  u32 index, u64 size)
> +{ }
> +#endif
> +
> +static inline void drmmcg_unregister_device(struct drm_device *dev, void=
 *arg)
> +{
> +	drmcg_unregister_device(arg);
> +}
> +
> +/*
> + * This needs to be done as inline, because cgroup lives in the core
> + * kernel and it cannot call drm calls directly
> + */
> +static inline int drmmcg_register_device(struct drm_device *dev,
> +					 struct drmcgroup_device *cgdev)
> +{
> +	return drmcg_register_device(dev, cgdev) ?:
> +		drmm_add_action_or_reset(dev, drmmcg_unregister_device, cgdev);
> +}
> +
>   #endif	/* _CGROUP_DRM_H */
> diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
> index 02c8eaa633d3..a93d9344fd36 100644
> --- a/kernel/cgroup/drm.c
> +++ b/kernel/cgroup/drm.c
> @@ -1,60 +1,557 @@
> -/* SPDX-License-Identifier: MIT */
> +// SPDX-License-Identifier: GPL-2.0
>   /*
> - * Copyright =C2=A9 2023 Intel Corporation
> + * Copyright 2023 Intel
> + * Partially based on the rdma and misc controllers, which bear the foll=
owing copyrights:
> + *
> + * Copyright 2020 Google LLC
> + * Copyright (C) 2016 Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@=
public.gmane.org>
>    */
>  =20
>   #include <linux/cgroup.h>
>   #include <linux/cgroup_drm.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/parser.h>
>   #include <linux/slab.h>
>  =20
> -struct drm_cgroup_state {

As a side note, it'd be easier to read the diff if you left the name as=20
is, and some other details too, like the static root group (I need to=20
remind myself if/why I needed it, but does it harm you?) and my missed=20
static keywords and needless static struct initialization. I will fix=20
that up in my patch localy. Aynway, that way it would maybe be less=20
churn from one patch to the other in the series.

> +#include <drm/drm_device.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_file.h>
> +#include <drm/drm_managed.h>
> +
> +struct drmcgroup_state {
>   	struct cgroup_subsys_state css;
> +
> +	struct list_head pools;
>   };
>  =20
> -struct drm_root_cgroup_state {
> -	struct drm_cgroup_state drmcs;
> +struct drmcgroup_pool_state {
> +	struct drmcgroup_device *device;
> +	struct drmcgroup_resource {
> +		s64 max, used;
> +	} resources[DRMCG_MAX_REGIONS];
> +
> +	s64 usage_sum;
> +
> +	struct list_head	cg_node;

cg always makes me think cgroup and not css so it is a bit confusing.

Why are two lists needed?

> +	struct list_head	dev_node;
>   };
>  =20
> -static struct drm_root_cgroup_state root_drmcs;
> +static DEFINE_MUTEX(drmcg_mutex);
> +static LIST_HEAD(drmcg_devices);
>  =20
> -static inline struct drm_cgroup_state *
> +static inline struct drmcgroup_state *
>   css_to_drmcs(struct cgroup_subsys_state *css)
>   {
> -	return container_of(css, struct drm_cgroup_state, css);
> +	return container_of(css, struct drmcgroup_state, css);
> +}
> +
> +static inline struct drmcgroup_state *get_current_drmcg(void)
> +{
> +	return css_to_drmcs(task_get_css(current, drm_cgrp_id));
> +}
> +
> +static struct drmcgroup_state *parent_drmcg(struct drmcgroup_state *cg)
> +{
> +	return css_to_drmcs(cg->css.parent);
> +}
> +
> +static void free_cg_pool_locked(struct drmcgroup_pool_state *pool)
> +{
> +	lockdep_assert_held(&drmcg_mutex);
> +
> +	list_del(&pool->cg_node);
> +	list_del(&pool->dev_node);
> +	kfree(pool);
> +}
> +
> +static void
> +set_resource_max(struct drmcgroup_pool_state *pool, int i, u64 new_max)
> +{
> +	pool->resources[i].max =3D new_max;
> +}
> +
> +static void set_all_resource_max_limit(struct drmcgroup_pool_state *rpoo=
l)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < DRMCG_MAX_REGIONS; i++)
> +		set_resource_max(rpool, i, S64_MAX);
> +}
> +
> +static void drmcs_offline(struct cgroup_subsys_state *css)
> +{
> +	struct drmcgroup_state *drmcs =3D css_to_drmcs(css);
> +	struct drmcgroup_pool_state *pool, *next;
> +
> +	mutex_lock(&drmcg_mutex);
> +	list_for_each_entry_safe(pool, next, &drmcs->pools, cg_node) {
> +		if (!pool->usage_sum) {
> +			free_cg_pool_locked(pool);
> +		} else {
> +			/* Reset all regions, last uncharge will remove pool */
> +			set_all_resource_max_limit(pool);
> +		}
> +	}
> +	mutex_unlock(&drmcg_mutex);
>   }
>  =20
>   static void drmcs_free(struct cgroup_subsys_state *css)
>   {
> -	struct drm_cgroup_state *drmcs =3D css_to_drmcs(css);
> +	struct drmcgroup_state *drmcs =3D css_to_drmcs(css);
>  =20
> -	if (drmcs !=3D &root_drmcs.drmcs)
> -		kfree(drmcs);
> +	kfree(drmcs);
>   }
>  =20
>   static struct cgroup_subsys_state *
>   drmcs_alloc(struct cgroup_subsys_state *parent_css)
>   {
> -	struct drm_cgroup_state *drmcs;
> +	struct drmcgroup_state *drmcs =3D kzalloc(sizeof(*drmcs), GFP_KERNEL);
> +	if (!drmcs)
> +		return ERR_PTR(-ENOMEM);
> +
> +	INIT_LIST_HEAD(&drmcs->pools);
> +	return &drmcs->css;
> +}
> +
> +static struct drmcgroup_pool_state *
> +find_cg_pool_locked(struct drmcgroup_state *drmcs, struct drmcgroup_devi=
ce *dev)
> +{
> +	struct drmcgroup_pool_state *pool;
> +
> +	list_for_each_entry(pool, &drmcs->pools, cg_node)
> +		if (pool->device =3D=3D dev)
> +			return pool;
> +
> +	return NULL;
> +}
> +
> +static struct drmcgroup_pool_state *
> +get_cg_pool_locked(struct drmcgroup_state *drmcs, struct drmcgroup_devic=
e *dev)
> +{
> +	struct drmcgroup_pool_state *pool;
> +
> +	pool =3D find_cg_pool_locked(drmcs, dev);
> +	if (pool)
> +		return pool;
> +
> +	pool =3D kzalloc(sizeof(*pool), GFP_KERNEL);
> +	if (!pool)
> +		return ERR_PTR(-ENOMEM);
> +
> +	pool->device =3D dev;
> +	set_all_resource_max_limit(pool);
>  =20
> -	if (!parent_css) {
> -		drmcs =3D &root_drmcs.drmcs;
> -	} else {
> -		drmcs =3D kzalloc(sizeof(*drmcs), GFP_KERNEL);
> -		if (!drmcs)
> -			return ERR_PTR(-ENOMEM);
> +	INIT_LIST_HEAD(&pool->cg_node);
> +	INIT_LIST_HEAD(&pool->dev_node);
> +	list_add_tail(&pool->cg_node, &drmcs->pools);
> +	list_add_tail(&pool->dev_node, &dev->pools);
> +	return pool;
> +}
> +
> +void drmcg_unregister_device(struct drmcgroup_device *cgdev)
> +{
> +	struct drmcgroup_pool_state *pool, *next;
> +
> +	mutex_lock(&drmcg_mutex);
> +	list_del(&cgdev->list);
> +
> +	list_for_each_entry_safe(pool, next, &cgdev->pools, dev_node)
> +		free_cg_pool_locked(pool);
> +	mutex_unlock(&drmcg_mutex);
> +	kfree(cgdev->name);
> +}
> +
> +EXPORT_SYMBOL_GPL(drmcg_unregister_device);
> +
> +int drmcg_register_device(struct drm_device *dev,
> +			  struct drmcgroup_device *cgdev)
> +{
> +	char *name =3D kstrdup(dev->unique, GFP_KERNEL);
> +	if (!name)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&cgdev->pools);
> +	mutex_lock(&drmcg_mutex);
> +	cgdev->name =3D name;
> +	list_add_tail(&cgdev->list, &drmcg_devices);
> +	mutex_unlock(&drmcg_mutex);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(drmcg_register_device);
> +
> +static int drmcg_max_show(struct seq_file *sf, void *v)
> +{
> +	struct drmcgroup_state *drmcs =3D css_to_drmcs(seq_css(sf));
> +	struct drmcgroup_pool_state *pool;
> +
> +	mutex_lock(&drmcg_mutex);
> +	list_for_each_entry(pool, &drmcs->pools, cg_node) {
> +		struct drmcgroup_device *dev =3D pool->device;
> +		int i;
> +
> +		seq_puts(sf, dev->name);
> +
> +		for (i =3D 0; i < DRMCG_MAX_REGIONS; i++) {
> +			if (!dev->regions[i].name)
> +				continue;
> +
> +			if (pool->resources[i].max < S64_MAX)
> +				seq_printf(sf, " region.%s=3D%lld", dev->regions[i].name,
> +					   pool->resources[i].max);
> +			else
> +				seq_printf(sf, " region.%s=3Dmax", dev->regions[i].name);
> +		}
> +
> +		seq_putc(sf, '\n');
>   	}
> +	mutex_unlock(&drmcg_mutex);
>  =20
> -	return &drmcs->css;
> +	return 0;
> +}
> +
> +static struct drmcgroup_device *drmcg_get_device_locked(const char *name)
> +{
> +	struct drmcgroup_device *dev;
> +
> +	lockdep_assert_held(&drmcg_mutex);
> +
> +	list_for_each_entry(dev, &drmcg_devices, list)
> +		if (!strcmp(name, dev->name))
> +			return dev;
> +
> +	return NULL;
> +}
> +
> +static void try_to_free_cg_pool_locked(struct drmcgroup_pool_state *pool)
> +{
> +	struct drmcgroup_device *dev =3D pool->device;
> +	u32 i;
> +
> +	/* Memory charged to this pool */
> +	if (pool->usage_sum)
> +		return;
> +
> +	for (i =3D 0; i < DRMCG_MAX_REGIONS; i++) {
> +		if (!dev->regions[i].name)
> +			continue;
> +
> +		/* Is a specific limit set? */
> +		if (pool->resources[i].max < S64_MAX)
> +			return;
> +	}
> +
> +	/*
> +	 * No user of the pool and all entries are set to defaults;
> +	 * safe to delete this pool.
> +	 */
> +	free_cg_pool_locked(pool);
> +}
> +
> +
> +static void
> +uncharge_cg_locked(struct drmcgroup_state *drmcs,
> +		   struct drmcgroup_device *cgdev,
> +		   u32 index, u64 size)
> +{
> +	struct drmcgroup_pool_state *pool;
> +
> +	pool =3D find_cg_pool_locked(drmcs, cgdev);
> +
> +	if (unlikely(!pool)) {
> +		pr_warn("Invalid device %p or drm cgroup %p\n", cgdev, drmcs);
> +		return;
> +	}
> +
> +	pool->resources[index].used -=3D size;
> +
> +	/*
> +	 * A negative count (or overflow) is invalid,
> +	 * it indicates a bug in the rdma controller.
> +	 */
> +	WARN_ON_ONCE(pool->resources[index].used < 0);
> +	pool->usage_sum--;
> +	try_to_free_cg_pool_locked(pool);
> +}
> +
> +static void drmcg_uncharge_hierarchy(struct drmcgroup_state *drmcs,
> +				     struct drmcgroup_device *cgdev,
> +				     struct drmcgroup_state *stop_cg,
> +				     u32 index, u64 size)
> +{
> +	struct drmcgroup_state *p;
> +
> +	mutex_lock(&drmcg_mutex);
> +
> +	for (p =3D drmcs; p !=3D stop_cg; p =3D parent_drmcg(p))
> +		uncharge_cg_locked(p, cgdev, index, size);
> +
> +	mutex_unlock(&drmcg_mutex);
> +
> +	css_put(&drmcs->css);
> +}
> +
> +void drmcg_uncharge(struct drmcgroup_state *drmcs,
> +		    struct drmcgroup_device *cgdev,
> +		    u32 index,
> +		    u64 size)
> +{
> +	if (index >=3D DRMCG_MAX_REGIONS)
> +		return;
> +
> +	drmcg_uncharge_hierarchy(drmcs, cgdev, NULL, index, size);
> +}
> +EXPORT_SYMBOL_GPL(drmcg_uncharge);
> +
> +int drmcg_try_charge(struct drmcgroup_state **drmcs,
> +		     struct drmcgroup_device *cgdev,
> +		     u32 index,
> +		     u64 size)
> +{
> +	struct drmcgroup_state *cg, *p;
> +	struct drmcgroup_pool_state *pool;
> +	u64 new;
> +	int ret =3D 0;
> +
> +	if (index >=3D DRMCG_MAX_REGIONS)
> +		return -EINVAL;
> +
> +	/*
> +	 * hold on to css, as cgroup can be removed but resource
> +	 * accounting happens on css.
> +	 */
> +	cg =3D get_current_drmcg();

1)

I am not familiar with the Xe flows - charging is at the point of actual=20
backing store allocation?

What about buffer sharing?

Also, given how the css is permanently stored in the caller - you=20
deliberately decided not to deal with task migrations? I am not sure=20
that will work. Or maybe just omitted for RFC v1?

2)

Buffer objects which Xe can migrate between memory regions will be=20
correctly charge/uncharged as they are moved?

Regards,

Tvrtko

> +
> +	mutex_lock(&drmcg_mutex);
> +	for (p =3D cg; p; p =3D parent_drmcg(p)) {
> +		pool =3D get_cg_pool_locked(p, cgdev);
> +		if (IS_ERR(pool)) {
> +			ret =3D PTR_ERR(pool);
> +			goto err;
> +		} else {
> +			new =3D pool->resources[index].used + size;
> +			if (new > pool->resources[index].max || new > S64_MAX) {
> +				ret =3D -EAGAIN;
> +				goto err;
> +			} else {
> +				pool->resources[index].used =3D new;
> +				pool->usage_sum++;
> +			}
> +		}
> +	}
> +	mutex_unlock(&drmcg_mutex);
> +
> +	*drmcs =3D cg;
> +	return 0;
> +
> +err:
> +	mutex_unlock(&drmcg_mutex);
> +	drmcg_uncharge_hierarchy(cg, cgdev, p, index, size);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(drmcg_try_charge);
> +
> +static s64 parse_resource(char *c, char **retname)
> +{
> +	substring_t argstr;
> +	char *name, *value =3D c;
> +	size_t len;
> +	int ret;
> +	u64 retval;
> +
> +	name =3D strsep(&value, "=3D");
> +	if (!name || !value)
> +		return -EINVAL;
> +
> +	/* Only support region setting for now */
> +	if (strncmp(name, "region.", 7))
> +		return -EINVAL;
> +	else
> +		name +=3D 7;
> +
> +	*retname =3D name;
> +	len =3D strlen(value);
> +
> +	argstr.from =3D value;
> +	argstr.to =3D value + len;
> +
> +	ret =3D match_u64(&argstr, &retval);
> +	if (ret >=3D 0) {
> +		if (retval > S64_MAX)
> +			return -EINVAL;
> +		return retval;
> +	}
> +	if (!strncmp(value, "max", len))
> +		return S64_MAX;
> +
> +	/* Not u64 or max, error */
> +	return -EINVAL;
> +}
> +
> +static int drmcg_parse_limits(char *options,
> +			      u64 *limits, char **enables)
> +{
> +	char *c;
> +	int num_limits =3D 0;
> +
> +	/* parse resource options */
> +	while ((c =3D strsep(&options, " ")) !=3D NULL) {
> +		s64 limit;
> +
> +		if (num_limits >=3D DRMCG_MAX_REGIONS)
> +			return -EINVAL;
> +
> +		limit =3D parse_resource(c, &enables[num_limits]);
> +		if (limit < 0)
> +			return limit;
> +
> +		limits[num_limits++] =3D limit;
> +	}
> +	return num_limits;
> +}
> +
> +static ssize_t drmcg_max_write(struct kernfs_open_file *of,
> +			       char *buf, size_t nbytes, loff_t off)
> +{
> +	struct drmcgroup_state *drmcs =3D css_to_drmcs(of_css(of));
> +	struct drmcgroup_device *dev;
> +	struct drmcgroup_pool_state *pool;
> +	char *options =3D strstrip(buf);
> +	char *dev_name =3D strsep(&options, " ");
> +	u64 limits[DRMCG_MAX_REGIONS];
> +	u64 new_limits[DRMCG_MAX_REGIONS];
> +	char *regions[DRMCG_MAX_REGIONS];
> +	int num_limits, i;
> +	unsigned long set_mask =3D 0;
> +	int err =3D 0;
> +
> +	if (!dev_name)
> +		return -EINVAL;
> +
> +	num_limits =3D drmcg_parse_limits(options, limits, regions);
> +	if (num_limits < 0)
> +		return num_limits;
> +	if (!num_limits)
> +		return -EINVAL;
> +
> +	/*
> +	 * Everything is parsed into key=3Dvalue pairs now, take lock and attem=
pt to update
> +	 * For good measure, set -EINVAL when a key is set twice.
> +	 */
> +	mutex_lock(&drmcg_mutex);
> +
> +	dev =3D drmcg_get_device_locked(dev_name);
> +	if (!dev) {
> +		err =3D -ENODEV;
> +		goto err;
> +	}
> +
> +	pool =3D get_cg_pool_locked(drmcs, dev);
> +	if (IS_ERR(pool)) {
> +		err =3D PTR_ERR(pool);
> +		goto err;
> +	}
> +
> +	/* Lookup region names and set new_limits to the index */
> +	for (i =3D 0; i < num_limits; i++) {
> +		int j;
> +
> +		for (j =3D 0; j < DRMCG_MAX_REGIONS; j++)
> +			if (dev->regions[j].name &&
> +			    !strcmp(regions[i], dev->regions[j].name))
> +				break;
> +
> +		if (j =3D=3D DRMCG_MAX_REGIONS ||
> +		    set_mask & BIT(j)) {
> +			err =3D -EINVAL;
> +			goto err_put;
> +		}
> +
> +		set_mask |=3D BIT(j);
> +		new_limits[j] =3D limits[i];
> +	}
> +
> +	/* And commit */
> +	for_each_set_bit(i, &set_mask, DRMCG_MAX_REGIONS)
> +		set_resource_max(pool, i, new_limits[i]);
> +
> +err_put:
> +	try_to_free_cg_pool_locked(pool);
> +err:
> +	mutex_unlock(&drmcg_mutex);
> +
> +	return err ?: nbytes;
> +}
> +
> +static int drmcg_current_show(struct seq_file *sf, void *v)
> +{
> +	struct drmcgroup_state *drmcs =3D css_to_drmcs(seq_css(sf));
> +	struct drmcgroup_device *dev;
> +
> +	mutex_lock(&drmcg_mutex);
> +	list_for_each_entry(dev, &drmcg_devices, list) {
> +		struct drmcgroup_pool_state *pool =3D find_cg_pool_locked(drmcs, dev);
> +		int i;
> +
> +		seq_puts(sf, dev->name);
> +
> +		for (i =3D 0; i < DRMCG_MAX_REGIONS; i++) {
> +			if (!dev->regions[i].name)
> +				continue;
> +
> +			seq_printf(sf, " region.%s=3D%lld", dev->regions[i].name,
> +				   pool ? pool->resources[i].used : 0ULL);
> +		}
> +
> +		seq_putc(sf, '\n');
> +	}
> +	mutex_unlock(&drmcg_mutex);
> +
> +	return 0;
> +}
> +
> +static int drmcg_capacity_show(struct seq_file *sf, void *v)
> +{
> +	struct drmcgroup_device *dev;
> +	int i;
> +
> +	list_for_each_entry(dev, &drmcg_devices, list) {
> +		seq_puts(sf, dev->name);
> +		for (i =3D 0; i < DRMCG_MAX_REGIONS; i++)
> +			if (dev->regions[i].name)
> +				seq_printf(sf, " region.%s=3D%lld",
> +					   dev->regions[i].name,
> +					   dev->regions[i].size);
> +		seq_putc(sf, '\n');
> +	}
> +	return 0;
>   }
>  =20
> -struct cftype files[] =3D {
> +static struct cftype files[] =3D {
> +	{
> +		.name =3D "max",
> +		.write =3D drmcg_max_write,
> +		.seq_show =3D drmcg_max_show,
> +		.flags =3D CFTYPE_NOT_ON_ROOT,
> +	},
> +	{
> +		.name =3D "current",
> +		.seq_show =3D drmcg_current_show,
> +		.flags =3D CFTYPE_NOT_ON_ROOT,
> +	},
> +	{
> +		.name =3D "capacity",
> +		.seq_show =3D drmcg_capacity_show,
> +		.flags =3D CFTYPE_ONLY_ON_ROOT,
> +	},
>   	{ } /* Zero entry terminates. */
>   };
>  =20
>   struct cgroup_subsys drm_cgrp_subsys =3D {
>   	.css_alloc	=3D drmcs_alloc,
>   	.css_free	=3D drmcs_free,
> -	.early_init	=3D false,
> +	.css_offline	=3D drmcs_offline,
>   	.legacy_cftypes	=3D files,
>   	.dfl_cftypes	=3D files,
>   };
