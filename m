From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC 02/17] drm: Track clients per owning process
Date: Thu, 20 Oct 2022 08:40:28 +0200
Message-ID: <77499370-bb0e-7f7e-ac1b-ad14f47578d9@amd.com>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
 <20221019173254.3361334-3-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRjd5gGc5dM0iyvE+7fKZbFCMXIeMKgSXAWDB/qHzew=;
 b=5q4B6jvVBWsBrDUdudIjXVdr4hkFwGQ9v9NZFsY6/VWvFQY3Mk7eTOLy2DE6hHCNiXHcN/TgyQRLmB98norx5cfS+xOvOM18qDka9tHsECTc5QSPSbYtLGcd7N9/fv1PTYUxSYQuA1a/Z/4YvICwASaXArwZw4SnK4DWT7dZTzk=
Content-Language: en-US
In-Reply-To: <20221019173254.3361334-3-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Am 19.10.22 um 19:32 schrieb Tvrtko Ursulin:
> From: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> To enable propagation of settings from the cgroup drm controller to drm we
> need to start tracking which processes own which drm clients.
>
> Implement that by tracking the struct pid pointer of the owning process in
> a new XArray, pointing to a structure containing a list of associated
> struct drm_file pointers.
>
> Clients are added and removed under the filelist mutex and RCU list
> operations are used below it to allow for lockless lookup.

That won't work easily like this. The problem is that file_priv->pid is 
usually not accurate these days:

 From the debugfs clients file:

       systemd-logind   773   0   y    y     0          0
                 Xorg  1639 128   n    n  1000          0
                 Xorg  1639 128   n    n  1000          0
                 Xorg  1639 128   n    n  1000          0
              firefox  2945 128   n    n  1000          0
                 Xorg  1639 128   n    n  1000          0
                 Xorg  1639 128   n    n  1000          0
                 Xorg  1639 128   n    n  1000          0
                 Xorg  1639 128   n    n  1000          0
               chrome 35940 128   n    n  1000          0
               chrome 35940   0   n    y  1000          1
               chrome 35940   0   n    y  1000          2
                 Xorg  1639 128   n    n  1000          0
                 Xorg  1639 128   n    n  1000          0
                 Xorg  1639 128   n    n  1000          0

This is with glxgears and a bunch other OpenGL applications running.

The problem is that for most applications the X/Wayland server is now 
opening the render node. The only exceptions in this case are apps using 
DRI2 (VA-API?).

I always wanted to fix this and actually track who is using the file 
descriptor instead of who opened it, but never had the time to do this.

I think you need to fix this problem first. And BTW: and unsigned long 
doesn't work as PID either with containers.

Regards,
Christian.

>
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>   drivers/gpu/drm/Makefile     |  1 +
>   drivers/gpu/drm/drm_cgroup.c | 60 ++++++++++++++++++++++++++++++++++++
>   drivers/gpu/drm/drm_file.c   | 18 ++++++++---
>   include/drm/drm_clients.h    | 31 +++++++++++++++++++
>   include/drm/drm_file.h       |  4 +++
>   5 files changed, 110 insertions(+), 4 deletions(-)
>   create mode 100644 drivers/gpu/drm/drm_cgroup.c
>   create mode 100644 include/drm/drm_clients.h
>
> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
> index 6e55c47288e4..0719970d17ee 100644
> --- a/drivers/gpu/drm/Makefile
> +++ b/drivers/gpu/drm/Makefile
> @@ -59,6 +59,7 @@ drm-$(CONFIG_DRM_LEGACY) += \
>   	drm_scatter.o \
>   	drm_vm.o
>   drm-$(CONFIG_DRM_LIB_RANDOM) += lib/drm_random.o
> +drm-$(CONFIG_CGROUP_DRM) += drm_cgroup.o
>   drm-$(CONFIG_COMPAT) += drm_ioc32.o
>   drm-$(CONFIG_DRM_PANEL) += drm_panel.o
>   drm-$(CONFIG_OF) += drm_of.o
> diff --git a/drivers/gpu/drm/drm_cgroup.c b/drivers/gpu/drm/drm_cgroup.c
> new file mode 100644
> index 000000000000..a31ff1d593ab
> --- /dev/null
> +++ b/drivers/gpu/drm/drm_cgroup.c
> @@ -0,0 +1,60 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Copyright © 2022 Intel Corporation
> + */
> +
> +#include <drm/drm_drv.h>
> +#include <drm/drm_clients.h>
> +
> +static DEFINE_XARRAY(drm_pid_clients);
> +
> +void drm_clients_close(struct drm_file *file_priv)
> +{
> +	unsigned long pid = (unsigned long)file_priv->pid;
> +	struct drm_device *dev = file_priv->minor->dev;
> +	struct drm_pid_clients *clients;
> +
> +	lockdep_assert_held(&dev->filelist_mutex);
> +
> +	clients = xa_load(&drm_pid_clients, pid);
> +	list_del_rcu(&file_priv->clink);
> +	if (atomic_dec_and_test(&clients->num)) {
> +		xa_erase(&drm_pid_clients, pid);
> +		kfree_rcu(clients, rcu);
> +	}
> +}
> +
> +int drm_clients_open(struct drm_file *file_priv)
> +{
> +	unsigned long pid = (unsigned long)file_priv->pid;
> +	struct drm_device *dev = file_priv->minor->dev;
> +	struct drm_pid_clients *clients;
> +	bool new_client = false;
> +
> +	lockdep_assert_held(&dev->filelist_mutex);
> +
> +	clients = xa_load(&drm_pid_clients, pid);
> +	if (!clients) {
> +		clients = kmalloc(sizeof(*clients), GFP_KERNEL);
> +		if (!clients)
> +			return -ENOMEM;
> +		atomic_set(&clients->num, 0);
> +		INIT_LIST_HEAD(&clients->file_list);
> +		init_rcu_head(&clients->rcu);
> +		new_client = true;
> +	}
> +	atomic_inc(&clients->num);
> +	list_add_tail_rcu(&file_priv->clink, &clients->file_list);
> +	if (new_client) {
> +		void *xret;
> +
> +		xret = xa_store(&drm_pid_clients, pid, clients, GFP_KERNEL);
> +		if (xa_err(xret)) {
> +			list_del_init(&file_priv->clink);
> +			kfree(clients);
> +			return PTR_ERR(clients);
> +		}
> +	}
> +
> +	return 0;
> +}
> diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
> index a8b4d918e9a3..ce58d5c513db 100644
> --- a/drivers/gpu/drm/drm_file.c
> +++ b/drivers/gpu/drm/drm_file.c
> @@ -40,6 +40,7 @@
>   #include <linux/slab.h>
>   
>   #include <drm/drm_client.h>
> +#include <drm/drm_clients.h>
>   #include <drm/drm_drv.h>
>   #include <drm/drm_file.h>
>   #include <drm/drm_print.h>
> @@ -298,6 +299,7 @@ static void drm_close_helper(struct file *filp)
>   
>   	mutex_lock(&dev->filelist_mutex);
>   	list_del(&file_priv->lhead);
> +	drm_clients_close(file_priv);
>   	mutex_unlock(&dev->filelist_mutex);
>   
>   	drm_file_free(file_priv);
> @@ -349,10 +351,8 @@ static int drm_open_helper(struct file *filp, struct drm_minor *minor)
>   
>   	if (drm_is_primary_client(priv)) {
>   		ret = drm_master_open(priv);
> -		if (ret) {
> -			drm_file_free(priv);
> -			return ret;
> -		}
> +		if (ret)
> +			goto err_free;
>   	}
>   
>   	filp->private_data = priv;
> @@ -360,6 +360,9 @@ static int drm_open_helper(struct file *filp, struct drm_minor *minor)
>   	priv->filp = filp;
>   
>   	mutex_lock(&dev->filelist_mutex);
> +	ret = drm_clients_open(priv);
> +	if (ret)
> +		goto err_unlock;
>   	list_add(&priv->lhead, &dev->filelist);
>   	mutex_unlock(&dev->filelist_mutex);
>   
> @@ -387,6 +390,13 @@ static int drm_open_helper(struct file *filp, struct drm_minor *minor)
>   #endif
>   
>   	return 0;
> +
> +err_unlock:
> +	mutex_unlock(&dev->filelist_mutex);
> +err_free:
> +	drm_file_free(priv);
> +
> +	return ret;
>   }
>   
>   /**
> diff --git a/include/drm/drm_clients.h b/include/drm/drm_clients.h
> new file mode 100644
> index 000000000000..4ae553a03d1e
> --- /dev/null
> +++ b/include/drm/drm_clients.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Copyright © 2022 Intel Corporation
> + */
> +
> +#ifndef _DRM_CLIENTS_H_
> +#define _DRM_CLIENTS_H_
> +
> +#include <drm/drm_file.h>
> +
> +struct drm_pid_clients {
> +	atomic_t num;
> +	struct list_head file_list;
> +	struct rcu_head rcu;
> +};
> +
> +#if IS_ENABLED(CONFIG_CGROUP_DRM)
> +void drm_clients_close(struct drm_file *file_priv);
> +int drm_clients_open(struct drm_file *file_priv);
> +#else
> +static inline void drm_clients_close(struct drm_file *file_priv)
> +{
> +}
> +
> +static inline int drm_clients_open(struct drm_file *file_priv)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#endif
> diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
> index d780fd151789..0965eb111f24 100644
> --- a/include/drm/drm_file.h
> +++ b/include/drm/drm_file.h
> @@ -268,6 +268,10 @@ struct drm_file {
>   	/** @minor: &struct drm_minor for this file. */
>   	struct drm_minor *minor;
>   
> +#if IS_ENABLED(CONFIG_CGROUP_DRM)
> +	struct list_head clink;
> +#endif
> +
>   	/**
>   	 * @object_idr:
>   	 *

