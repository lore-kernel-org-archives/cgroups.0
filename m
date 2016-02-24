From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv6 2/3] IB/core: added support to use rdma cgroup
 controller
Date: Wed, 24 Feb 2016 15:43:16 +0200
Message-ID: <56CDB374.602@mellanox.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
 <1455966006-13774-3-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=g/2NhPC6zDhzUgbo9eIi4e8kw8vwOmh22zHJORAn8OQ=;
 b=uee5b9rEXFPU1M9VjK4M8L7nxVo3l9B1NGmYw2MzlRslbDlsg5qaiOEbhDlp6llojAUv0kojC5m9+lG4XPGq/YwmruAwVJMT2oVSONzq/4borD2qC16LaoFI0tWH6ic1N2coOYYrJ+rMnHTfNYFyAna8lfyrZqToq1ouRpV3bGM=
In-Reply-To: <1455966006-13774-3-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 20/02/2016 13:00, Parav Pandit wrote:
> +/**
> + * ib_device_unregister_rdmacg - unregister with rdma cgroup.
> + * @device: device to unregister.
> + *
> + * Unregister with the rdma cgroup. Should be called after
> + * all the resources are deallocated, and after a stage when any
> + * other resource allocation of user application cannot be done
> + * for this device to avoid any leak in accounting.
> + * HCA drivers should clear resource pool ops after ib stack
> + * unregisters with rdma cgroup.
HCA drivers don't supply their own ops in this version, right?
If so, you can update the comment.

> + */
> +void ib_device_unregister_rdmacg(struct ib_device *device)
> +{
> +	rdmacg_unregister_device(&device->cg_device);
> +}

> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 179e813..c3bd24c 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -352,10 +352,22 @@ int ib_register_device(struct ib_device *device,
>  		goto out;
>  	}
>  
> +#ifdef CONFIG_CGROUP_RDMA
> +	ret = ib_device_register_rdmacg(device);
> +	if (ret) {
> +		printk(KERN_WARNING "Couldn't set up InfiniBand P_Key/GID cache\n");
You should update the error string, and I think checkpatch recommends
using pr_warn().

> +		ib_cache_cleanup_one(device);
> +		goto out;
> +	}
> +#endif
> +
>  	ret = ib_device_register_sysfs(device, port_callback);
>  	if (ret) {
>  		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
>  		       device->name);
> +#ifdef CONFIG_CGROUP_RDMA
> +		ib_device_unregister_rdmacg(device);
> +#endif
>  		ib_cache_cleanup_one(device);
>  		goto out;
>  	}
> @@ -405,6 +417,10 @@ void ib_unregister_device(struct ib_device *device)
>  
>  	mutex_unlock(&device_mutex);
>  
> +#ifdef CONFIG_CGROUP_RDMA
> +	ib_device_unregister_rdmacg(device);
> +#endif
> +
>  	ib_device_unregister_sysfs(device);
>  	ib_cache_cleanup_one(device);
>  
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 1c02dea..7c51e8a 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c

> @@ -1777,6 +1851,12 @@ static int create_qp(struct ib_uverbs_file *file,
>  		  &qp_lock_class);
>  	down_write(&obj->uevent.uobject.mutex);
>  
> +	pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
> +	if (!pd) {
> +		ret = -EINVAL;
> +		goto err_put;
> +	}
> +
I'm not sure I understand why you need to keep the PD here. Why 
don't you use the same ib_device that is used to create the QP? 
The same applies comment also applies to other uverbs commands.

>  	if (cmd->qp_type == IB_QPT_XRC_TGT) {
>  		xrcd = idr_read_xrcd(cmd->pd_handle, file->ucontext,
>  				     &xrcd_uobj);
> @@ -1811,8 +1891,7 @@ static int create_qp(struct ib_uverbs_file *file,
>  
>  		scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
>  		rcq = rcq ?: scq;
> -		pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
> -		if (!pd || !scq) {
> +		if (!scq) {
>  			ret = -EINVAL;
>  			goto err_put;
>  		}
> @@ -1858,6 +1937,11 @@ static int create_qp(struct ib_uverbs_file *file,
>  			goto err_put;
>  		}
>  
> +	ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, pd->device,
> +				   RDMA_VERB_RESOURCE_QP, 1);
> +	if (ret)
> +		goto err_put;
> +
>  	if (cmd->qp_type == IB_QPT_XRC_TGT)
>  		qp = ib_create_qp(pd, &attr);
>  	else
> @@ -1865,7 +1949,7 @@ static int create_qp(struct ib_uverbs_file *file,
>  
>  	if (IS_ERR(qp)) {
>  		ret = PTR_ERR(qp);
> -		goto err_put;
> +		goto err_create;
>  	}
>  
>  	if (cmd->qp_type != IB_QPT_XRC_TGT) {
> @@ -1940,6 +2024,10 @@ err_cb:
>  err_destroy:
>  	ib_destroy_qp(qp);
>  
> +err_create:
> +	ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, device,
> +			   RDMA_VERB_RESOURCE_QP, 1);
> +
>  err_put:
>  	if (xrcd)
>  		put_xrcd_read(xrcd_uobj);

> @@ -3323,6 +3441,11 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
>  	obj->uevent.events_reported = 0;
>  	INIT_LIST_HEAD(&obj->uevent.event_list);
>  
> +	ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, pd->device,
> +				   RDMA_VERB_RESOURCE_SRQ, 1);
> +	if (ret)
> +		goto err_put_cq;
> +
I think you need a new error label to release the PD IDR but not
uncharge.

>  	srq = pd->device->create_srq(pd, &attr, udata);
>  	if (IS_ERR(srq)) {
>  		ret = PTR_ERR(srq);
> @@ -3387,6 +3510,8 @@ err_destroy:
>  	ib_destroy_srq(srq);
>  
>  err_put:
> +	ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, pd->device,
> +			   RDMA_VERB_RESOURCE_SRQ, 1);
>  	put_pd_read(pd);
>  
>  err_put_cq:

Regards,
Haggai
