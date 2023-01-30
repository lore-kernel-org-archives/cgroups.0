From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 06/19] RDMA/usnic: convert to use vm_account
Date: Mon, 30 Jan 2023 22:10:39 +1100
Message-ID: <87y1pkz376.fsf@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <03ed2d166826cd7055810c66a175e20fa2153c52.1674538665.git-series.apopple@nvidia.com>
 <Y8/uGL+TA7ow4Zmu@nvidia.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnfClW4dnpNYIts4/oNZ8ZyQfZwzKU3kZcQcXMc3fvU=;
 b=fHD4un/Fav6WXJGyk9xPp9RMCsggDjybx4u31X0ENDkbRD1upa45Prp7KvTXDqvLyUONWZRPfJHooG8ZxljzglbYtQoTOJt4CQfq1m+8UAqmcEYLQ+lrmhRHZyTGUJnO5zoSxYb1BEJl+SqLVpweAtIgqOslj8wJ5e9WQ4ql/LObKRS5Tz3SRAPa3GaZImHxoKcxMFj4kQQVmsOS0bSKUufQRiGiGRYTJDr76FE+PUSibLmFgUTnj0UfDDweqg/5cZz3QWM8E/P5lp7vSpC3mxysxNOWEJ+MJoQMUw+nfMvi2PDc93XQUdzzVqX7nYGeR//V7uOIag/d0nvOFUojYQ==
In-reply-to: <Y8/uGL+TA7ow4Zmu-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> writes:

> On Tue, Jan 24, 2023 at 04:42:35PM +1100, Alistair Popple wrote:
>> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
>> index c301b3b..250276e 100644
>> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
>> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
>> @@ -89,8 +89,6 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
>>  	struct page **page_list;
>>  	struct scatterlist *sg;
>>  	struct usnic_uiom_chunk *chunk;
>> -	unsigned long locked;
>> -	unsigned long lock_limit;
>>  	unsigned long cur_base;
>>  	unsigned long npages;
>>  	int ret;
>> @@ -123,10 +121,8 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
>>  	uiomr->owning_mm = mm = current->mm;
>>  	mmap_read_lock(mm);
>>  
>> -	locked = atomic64_add_return(npages, &current->mm->pinned_vm);
>> -	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>> -
>> -	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
>> +	vm_account_init_current(&uiomr->vm_account);
>> +	if (vm_account_pinned(&uiomr->vm_account, npages)) {
>>  		ret = -ENOMEM;
>>  		goto out;
>>  	}
>
> Is this error handling right? This driver tried to avoid the race by
> using atomic64_add_return() but it means that the out label undoes the add:
>
>
>> @@ -178,7 +174,8 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
>>  out:
>>  	if (ret < 0) {
>>  		usnic_uiom_put_pages(chunk_list, 0);
>> -		atomic64_sub(npages, &current->mm->pinned_vm);
>
> Here
>
>> +		vm_unaccount_pinned(&uiomr->vm_account, npages);
>> +		vm_account_release(&uiomr->vm_account);
>
> But with the new API we shouldn't call vm_unaccount_pinned() if
> vm_account_pinned() doesn't succeed?

Good point. Will add the following fix:

@@ -123,6 +123,7 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 
 	vm_account_init_current(&uiomr->vm_account);
 	if (vm_account_pinned(&uiomr->vm_account, npages)) {
+		npages = 0;
 		ret = -ENOMEM;
 		goto out;
 	}

>
> Jason

