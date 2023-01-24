From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 06/19] RDMA/usnic: convert to use vm_account
Date: Tue, 24 Jan 2023 10:41:28 -0400
Message-ID: <Y8/uGL+TA7ow4Zmu@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <03ed2d166826cd7055810c66a175e20fa2153c52.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywtsCLu+RvrSzqntvW+kqIVqxdEncdFU1vtcnEF3TRQ=;
 b=czhv9+m+4tZFRqqvaTO9pz+tjvg/KrN/fxDdGq/COZrao6LzGW2f6kNi3Ak17UuprxKwLj9C74ru1Chj+d2E1ee/UYYUQv2bd9svCQsM6nV+8YPyCc4hLGJ7Cu8/wVk4GU5TT7y3x4Wf+yHO6nKjbLqVRNQAkiDzqmXvT4j3qh6tcLFrBvJRAta8ejhSQ98rqBUsUSu0MAZWcxC60OcA819P0hUNuzZsFGCSUUV4/jMV6c55PNKj01/Fa7cMMuBDty8Qv7mhfYdOSyM8+B5jAJF2UjMy1e2vDUrJr4yG6/W5bmYbYuS3RFfDmvARB74U9RlsFPnXWmV7mA+vZhsRYw==
Content-Disposition: inline
In-Reply-To: <03ed2d166826cd7055810c66a175e20fa2153c52.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 24, 2023 at 04:42:35PM +1100, Alistair Popple wrote:
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
> index c301b3b..250276e 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> @@ -89,8 +89,6 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
>  	struct page **page_list;
>  	struct scatterlist *sg;
>  	struct usnic_uiom_chunk *chunk;
> -	unsigned long locked;
> -	unsigned long lock_limit;
>  	unsigned long cur_base;
>  	unsigned long npages;
>  	int ret;
> @@ -123,10 +121,8 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
>  	uiomr->owning_mm = mm = current->mm;
>  	mmap_read_lock(mm);
>  
> -	locked = atomic64_add_return(npages, &current->mm->pinned_vm);
> -	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> -
> -	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
> +	vm_account_init_current(&uiomr->vm_account);
> +	if (vm_account_pinned(&uiomr->vm_account, npages)) {
>  		ret = -ENOMEM;
>  		goto out;
>  	}

Is this error handling right? This driver tried to avoid the race by
using atomic64_add_return() but it means that the out label undoes the add:


> @@ -178,7 +174,8 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
>  out:
>  	if (ret < 0) {
>  		usnic_uiom_put_pages(chunk_list, 0);
> -		atomic64_sub(npages, &current->mm->pinned_vm);

Here

> +		vm_unaccount_pinned(&uiomr->vm_account, npages);
> +		vm_account_release(&uiomr->vm_account);

But with the new API we shouldn't call vm_unaccount_pinned() if
vm_account_pinned() doesn't succeed?

Jason
