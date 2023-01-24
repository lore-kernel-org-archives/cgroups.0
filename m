From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC PATCH 05/19] RMDA/siw: Convert to use vm_account
Date: Tue, 24 Jan 2023 10:37:12 -0400
Message-ID: <Y8/tGIeg5mI9bDOa@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <4f8b1d54ab5d6909c46ba5470065f8326f9fcc62.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwC0Xt8mAoKubuWYL73vUFZNMWCWco00MGWx6+xqe7w=;
 b=F6aRMKcrtYzmchAcCMBpQgCwE4OR+0DTdfFqi5dNV+Tc20lEFcyupldB1sdp9m1scJ8wiSkpvGiWloI/yUoRG6ZwlIYcwd3eo38PC74MxjvGDizEpc93Slro/7TpOc4PkPgdyMEyJ7TTslEvIoGIZVwEff9Pg8iFQgo0E+agijDB2bVsQBEtzLE0mwBna+FCzu0MGE7RlBCdnm7Yq+0wMMLz/NQQm0D/E6vZch5T0NgBBqOR3QfXRBjfCfQXi5wPDRxz+3CQbqPT/mghzWhh3qk3Mg2zrdeEV85mn6TcI4p2Sr/OYtaSe5mpgwfmB78SUGEjGtFkn1KE1LriVDIpqw==
Content-Disposition: inline
In-Reply-To: <4f8b1d54ab5d6909c46ba5470065f8326f9fcc62.1674538665.git-series.apopple@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, Bernard Metzler <bmt@zurich.ibm.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org

On Tue, Jan 24, 2023 at 04:42:34PM +1100, Alistair Popple wrote:

> @@ -385,20 +382,16 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
>  	if (!umem)
>  		return ERR_PTR(-ENOMEM);
>  
> -	mm_s = current->mm;
> -	umem->owning_mm = mm_s;
>  	umem->writable = writable;
>  
> -	mmgrab(mm_s);
> +	vm_account_init_current(&umem->vm_account);
>  
>  	if (writable)
>  		foll_flags |= FOLL_WRITE;
>  
> -	mmap_read_lock(mm_s);
> +	mmap_read_lock(current->mm);
>  
> -	mlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> -
> -	if (num_pages + atomic64_read(&mm_s->pinned_vm) > mlock_limit) {
> +	if (vm_account_pinned(&umem->vm_account, num_pages)) {
>  		rv = -ENOMEM;
>  		goto out_sem_up;
>  	}
> @@ -429,7 +422,6 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
>  				goto out_sem_up;
>  
>  			umem->num_pages += rv;
> -			atomic64_add(rv, &mm_s->pinned_vm);

Also fixes the race bug

Jason
