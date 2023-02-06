From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 10/19] net: skb: Switch to using vm_account
Date: Mon, 06 Feb 2023 15:36:49 +1100
Message-ID: <878rhbflcs.fsf@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple@nvidia.com>
 <Y8/wWTOOjyfGBrP0@nvidia.com> <87pmawz2ma.fsf@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+4PXpqcCeX1uE8aWt3DfoVSzDIUjmhLieV75BId4Og=;
 b=VVDpLU4oKKHBHxq0kEWsjZacZ+4lj+pc5NNUckwYV53EHuurMOKlHhmUV2eNfd9KbXAmzv9H/MsFpxecL8jIZxtKj/9UmTyyJOcOYBBDvL6wggi9OhcVVnMx0340exVgJXCKA6tbxh0mHMmCTLPfeo/P3IIdRJOvLYFQH+sDtuabkCSe55aqTudDCfmujdeM3k+bCeeaSpC+cBkK/9r4MCSDgRrDU/BbxR5MHJp8+6o5p2B4w9nf1RMlpIcNDwYXBAl0Zcs7t9GE0V9+sj+X4l2pV0GNMkR9YqH7j+nuyPVXK/R0ddc6C55A5/MFH6ZaopYeQgG4Uxpk0+6VhXqc5g==
In-reply-to: <87pmawz2ma.fsf-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org


Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> writes:

> Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> writes:
>
>> On Tue, Jan 24, 2023 at 04:42:39PM +1100, Alistair Popple wrote:
>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>> index dcd72e6..bc3a868 100644
>>> --- a/include/net/sock.h
>>> +++ b/include/net/sock.h
>>> @@ -334,6 +334,7 @@ struct sk_filter;
>>>    *	@sk_security: used by security modules
>>>    *	@sk_mark: generic packet mark
>>>    *	@sk_cgrp_data: cgroup data for this cgroup
>>> +  *	@sk_vm_account: data for pinned memory accounting
>>>    *	@sk_memcg: this socket's memory cgroup association
>>>    *	@sk_write_pending: a write to stream socket waits to start
>>>    *	@sk_state_change: callback to indicate change in the state of the sock
>>> @@ -523,6 +524,7 @@ struct sock {
>>>  	void			*sk_security;
>>>  #endif
>>>  	struct sock_cgroup_data	sk_cgrp_data;
>>> +	struct vm_account       sk_vm_account;
>>>  	struct mem_cgroup	*sk_memcg;
>>>  	void			(*sk_state_change)(struct sock *sk);
>>>  	void			(*sk_data_ready)(struct sock *sk);
>>
>> I'm not sure this makes sense in a sock - each sock can be shared with
>> different proceses..
>
> TBH it didn't feel right to me either so was hoping for some
> feedback. Will try your suggestion below.
>
>>> diff --git a/net/rds/message.c b/net/rds/message.c
>>> index b47e4f0..2138a70 100644
>>> --- a/net/rds/message.c
>>> +++ b/net/rds/message.c
>>> @@ -99,7 +99,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
>>>  	struct list_head *head;
>>>  	unsigned long flags;
>>>  
>>> -	mm_unaccount_pinned_pages(&znotif->z_mmp);
>>> +	mm_unaccount_pinned_pages(&rs->rs_sk.sk_vm_account, &znotif->z_mmp);
>>>  	q = &rs->rs_zcookie_queue;
>>>  	spin_lock_irqsave(&q->lock, flags);
>>>  	head = &q->zcookie_head;
>>> @@ -367,6 +367,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>>  	int ret = 0;
>>>  	int length = iov_iter_count(from);
>>>  	struct rds_msg_zcopy_info *info;
>>> +	struct vm_account *vm_account = &rm->m_rs->rs_sk.sk_vm_account;
>>>  
>>>  	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
>>>  
>>> @@ -380,7 +381,9 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>>  		return -ENOMEM;
>>>  	INIT_LIST_HEAD(&info->rs_zcookie_next);
>>>  	rm->data.op_mmp_znotifier = &info->znotif;
>>> -	if (mm_account_pinned_pages(&rm->data.op_mmp_znotifier->z_mmp,
>>> +	vm_account_init(vm_account, current, current_user(), VM_ACCOUNT_USER);
>>> +	if (mm_account_pinned_pages(vm_account,
>>> +				    &rm->data.op_mmp_znotifier->z_mmp,
>>>  				    length)) {
>>>  		ret = -ENOMEM;
>>>  		goto err;
>>> @@ -399,7 +402,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>>  			for (i = 0; i < rm->data.op_nents; i++)
>>>  				put_page(sg_page(&rm->data.op_sg[i]));
>>>  			mmp = &rm->data.op_mmp_znotifier->z_mmp;
>>> -			mm_unaccount_pinned_pages(mmp);
>>> +			mm_unaccount_pinned_pages(vm_account, mmp);
>>>  			ret = -EFAULT;
>>>  			goto err;
>>>  		}
>>
>> I wonder if RDS should just not be doing accounting? Usually things
>> related to iov_iter are short term and we don't account for them.
>
> Yeah, I couldn't easily figure out why these were accounted for in the
> first place either.
>
>> But then I don't really know how RDS works, Santos?
>>
>> Regardless, maybe the vm_account should be stored in the
>> rds_msg_zcopy_info ?
>
> On first glance that looks like a better spot. Thanks for the
> idea.

That works fine for RDS but not for skbuff. We still need a vm_account
in the struct sock or somewhere else for that. For example in
msg_zerocopy_realloc() we only have a struct ubuf_info_msgzc
available. We can't add a struct vm_account field to that because
ultimately it is stored in struct sk_buff->ck[] which is not large
enough to contain ubuf_info_msgzc + vm_account.

I'm not terribly familiar with kernel networking code though, so happy
to hear other suggestions.

>> Jason

