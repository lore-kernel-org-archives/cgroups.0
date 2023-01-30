From: Alistair Popple <apopple@nvidia.com>
Subject: Re: [RFC PATCH 10/19] net: skb: Switch to using vm_account
Date: Mon, 30 Jan 2023 22:17:18 +1100
Message-ID: <87pmawz2ma.fsf@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple@nvidia.com>
 <Y8/wWTOOjyfGBrP0@nvidia.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qi0a1JXB1cGcFPTt3q22VNEdnLnaDTHalmup7TcwS7U=;
 b=X+an6WzZ/iO4RB0FQnOau/akl79bJyMymk+3YsWFT1+K/hpUMrD5f+Ad7K90+bFU7nQPCb++Oum/c9VNwmRbJt138IVFBGoDqQzkTi3/X2t12X+9bqD/w8PTM5vSaMSjyVW2ll2QmtTcHymnVOlrhoEGuFbVY2Eu6rAGiXZMASydiXfv3rJOPXkoEgoNoRfO0akLB5Qf5llJzFEVvaxD2oMgCgD9oNLvgvj7GnY0J3HVptIrGPUGXslQLwAuLRU38ijDZaOyK8oLAEocOYma1wx83YJl1kIEhSuWw0TP0d5aUjpOp5DAz7FzCK1r2GX9iR9ITaeRj4vpprjA4qJ3/g==
In-reply-to: <Y8/wWTOOjyfGBrP0@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com


Jason Gunthorpe <jgg@nvidia.com> writes:

> On Tue, Jan 24, 2023 at 04:42:39PM +1100, Alistair Popple wrote:
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index dcd72e6..bc3a868 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -334,6 +334,7 @@ struct sk_filter;
>>    *	@sk_security: used by security modules
>>    *	@sk_mark: generic packet mark
>>    *	@sk_cgrp_data: cgroup data for this cgroup
>> +  *	@sk_vm_account: data for pinned memory accounting
>>    *	@sk_memcg: this socket's memory cgroup association
>>    *	@sk_write_pending: a write to stream socket waits to start
>>    *	@sk_state_change: callback to indicate change in the state of the sock
>> @@ -523,6 +524,7 @@ struct sock {
>>  	void			*sk_security;
>>  #endif
>>  	struct sock_cgroup_data	sk_cgrp_data;
>> +	struct vm_account       sk_vm_account;
>>  	struct mem_cgroup	*sk_memcg;
>>  	void			(*sk_state_change)(struct sock *sk);
>>  	void			(*sk_data_ready)(struct sock *sk);
>
> I'm not sure this makes sense in a sock - each sock can be shared with
> different proceses..

TBH it didn't feel right to me either so was hoping for some
feedback. Will try your suggestion below.

>> diff --git a/net/rds/message.c b/net/rds/message.c
>> index b47e4f0..2138a70 100644
>> --- a/net/rds/message.c
>> +++ b/net/rds/message.c
>> @@ -99,7 +99,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
>>  	struct list_head *head;
>>  	unsigned long flags;
>>  
>> -	mm_unaccount_pinned_pages(&znotif->z_mmp);
>> +	mm_unaccount_pinned_pages(&rs->rs_sk.sk_vm_account, &znotif->z_mmp);
>>  	q = &rs->rs_zcookie_queue;
>>  	spin_lock_irqsave(&q->lock, flags);
>>  	head = &q->zcookie_head;
>> @@ -367,6 +367,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>  	int ret = 0;
>>  	int length = iov_iter_count(from);
>>  	struct rds_msg_zcopy_info *info;
>> +	struct vm_account *vm_account = &rm->m_rs->rs_sk.sk_vm_account;
>>  
>>  	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
>>  
>> @@ -380,7 +381,9 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>  		return -ENOMEM;
>>  	INIT_LIST_HEAD(&info->rs_zcookie_next);
>>  	rm->data.op_mmp_znotifier = &info->znotif;
>> -	if (mm_account_pinned_pages(&rm->data.op_mmp_znotifier->z_mmp,
>> +	vm_account_init(vm_account, current, current_user(), VM_ACCOUNT_USER);
>> +	if (mm_account_pinned_pages(vm_account,
>> +				    &rm->data.op_mmp_znotifier->z_mmp,
>>  				    length)) {
>>  		ret = -ENOMEM;
>>  		goto err;
>> @@ -399,7 +402,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>  			for (i = 0; i < rm->data.op_nents; i++)
>>  				put_page(sg_page(&rm->data.op_sg[i]));
>>  			mmp = &rm->data.op_mmp_znotifier->z_mmp;
>> -			mm_unaccount_pinned_pages(mmp);
>> +			mm_unaccount_pinned_pages(vm_account, mmp);
>>  			ret = -EFAULT;
>>  			goto err;
>>  		}
>
> I wonder if RDS should just not be doing accounting? Usually things
> related to iov_iter are short term and we don't account for them.

Yeah, I couldn't easily figure out why these were accounted for in the
first place either.

> But then I don't really know how RDS works, Santos?
>
> Regardless, maybe the vm_account should be stored in the
> rds_msg_zcopy_info ?

On first glance that looks like a better spot. Thanks for the
idea.

> Jason

