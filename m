From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 03/19] drivers/vdpa: Convert vdpa to use the new
 vm_structure
Date: Tue, 24 Jan 2023 10:35:27 -0400
Message-ID: <Y8/sr4SfnuoXxApR@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <f2e4696380f6678527a14e885556cb1bbd314737.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GUHgQxTr7xl07KNqhlFX5ZY6CeT1FVDbvzOWKgAF2hE=;
 b=fkjM3q73RLaTXaxImm1j505ZKO2zK1hvY+cW3vqrgccwtO7Sg4Lo5DBa1KCRjD84JsoGLGFFB5kzr7ArUj0DS8GeZ2JOkmnU/m90sKUIzM3I4jfTjbZLwqIuDXuhBOIaWYE3pWB8kcqpEFe909fB0UUKghZYKzEnR9ObEK2rcT0eeLhORzrRLcUX3eGXohsIdMVrD3N2NCPAJcGTlAlMGwFWnRXL6kciJbbZyafMiwJy5SLLBVOnHFKXB3y47B8rm5KCtd4MHn0TspPj7iaV9bi5ovlbFXOMhyEL09rNQOEhDgbfOUV61wf5N+DRn3OVMp/dkPaDtrTsgxH1S8r9XA==
Content-Disposition: inline
In-Reply-To: <f2e4696380f6678527a14e885556cb1bbd314737.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Tue, Jan 24, 2023 at 04:42:32PM +1100, Alistair Popple wrote:
> @@ -990,8 +989,8 @@ static int vduse_dev_reg_umem(struct vduse_dev *dev,
>  
>  	mmap_read_lock(current->mm);
>  
> -	lock_limit = PFN_DOWN(rlimit(RLIMIT_MEMLOCK));
> -	if (npages + atomic64_read(&current->mm->pinned_vm) > lock_limit)
> +	vm_account_init_current(&umem->vm_account);
> +	if (vm_account_pinned(&umem->vm_account, npages))
>  		goto out;
>  
>  	pinned = pin_user_pages(uaddr, npages, FOLL_LONGTERM | FOLL_WRITE,
> @@ -1006,22 +1005,21 @@ static int vduse_dev_reg_umem(struct vduse_dev *dev,
>  	if (ret)
>  		goto out;
>  
> -	atomic64_add(npages, &current->mm->pinned_vm);

Mention in the commit message that this fixes a bug where vdpa would
race the update of mm->pinned_vm and might go past the limit.

Jason
