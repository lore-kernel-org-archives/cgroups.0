From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 10/19] net: skb: Switch to using vm_account
Date: Tue, 24 Jan 2023 10:51:05 -0400
Message-ID: <Y8/wWTOOjyfGBrP0@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdns+ccGmYa5/eT4I1wsgXqZ6qTopVSRHBbDpj6nJQM=;
 b=h2ZwJoCKRqW9GalHC+x195fbxhEnmmCjFQmr6XFBFlXetcYXcYScK1lBHCVKDtmgCuKfI4oIoSq5iBm9tlHW8JhEPRuANn+kbPNcPZt9P4+p3TU7GNe7lxYBL2iDSm9CSPSAWqVYKtiNlG3wFq8knU1bhB0yAdOxOMj/w6vklw7pVMKjrpj9nkYQdlucCAb0oBBB6lwK9+Vd2s9tPWHA6yn5AjWpERdb1krBMwxo8ZLpOwm9rN7xpkwncNPtkdDg97CbbT8284tKf4E6RAYuTjaxIk6YPVa3T7otVc4SENeyYNKf+uMdZgaFt/Dh4RtOc97dhUxs+QUZO1oE4xtLsg==
Content-Disposition: inline
In-Reply-To: <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org

On Tue, Jan 24, 2023 at 04:42:39PM +1100, Alistair Popple wrote:
> diff --git a/include/net/sock.h b/include/net/sock.h
> index dcd72e6..bc3a868 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -334,6 +334,7 @@ struct sk_filter;
>    *	@sk_security: used by security modules
>    *	@sk_mark: generic packet mark
>    *	@sk_cgrp_data: cgroup data for this cgroup
> +  *	@sk_vm_account: data for pinned memory accounting
>    *	@sk_memcg: this socket's memory cgroup association
>    *	@sk_write_pending: a write to stream socket waits to start
>    *	@sk_state_change: callback to indicate change in the state of the sock
> @@ -523,6 +524,7 @@ struct sock {
>  	void			*sk_security;
>  #endif
>  	struct sock_cgroup_data	sk_cgrp_data;
> +	struct vm_account       sk_vm_account;
>  	struct mem_cgroup	*sk_memcg;
>  	void			(*sk_state_change)(struct sock *sk);
>  	void			(*sk_data_ready)(struct sock *sk);

I'm not sure this makes sense in a sock - each sock can be shared with
different proceses..

> diff --git a/net/rds/message.c b/net/rds/message.c
> index b47e4f0..2138a70 100644
> --- a/net/rds/message.c
> +++ b/net/rds/message.c
> @@ -99,7 +99,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
>  	struct list_head *head;
>  	unsigned long flags;
>  
> -	mm_unaccount_pinned_pages(&znotif->z_mmp);
> +	mm_unaccount_pinned_pages(&rs->rs_sk.sk_vm_account, &znotif->z_mmp);
>  	q = &rs->rs_zcookie_queue;
>  	spin_lock_irqsave(&q->lock, flags);
>  	head = &q->zcookie_head;
> @@ -367,6 +367,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>  	int ret = 0;
>  	int length = iov_iter_count(from);
>  	struct rds_msg_zcopy_info *info;
> +	struct vm_account *vm_account = &rm->m_rs->rs_sk.sk_vm_account;
>  
>  	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
>  
> @@ -380,7 +381,9 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>  		return -ENOMEM;
>  	INIT_LIST_HEAD(&info->rs_zcookie_next);
>  	rm->data.op_mmp_znotifier = &info->znotif;
> -	if (mm_account_pinned_pages(&rm->data.op_mmp_znotifier->z_mmp,
> +	vm_account_init(vm_account, current, current_user(), VM_ACCOUNT_USER);
> +	if (mm_account_pinned_pages(vm_account,
> +				    &rm->data.op_mmp_znotifier->z_mmp,
>  				    length)) {
>  		ret = -ENOMEM;
>  		goto err;
> @@ -399,7 +402,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>  			for (i = 0; i < rm->data.op_nents; i++)
>  				put_page(sg_page(&rm->data.op_sg[i]));
>  			mmp = &rm->data.op_mmp_znotifier->z_mmp;
> -			mm_unaccount_pinned_pages(mmp);
> +			mm_unaccount_pinned_pages(vm_account, mmp);
>  			ret = -EFAULT;
>  			goto err;
>  		}

I wonder if RDS should just not be doing accounting? Usually things
related to iov_iter are short term and we don't account for them.

But then I don't really know how RDS works, Santos?

Regardless, maybe the vm_account should be stored in the
rds_msg_zcopy_info ?

Jason
