From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -V6 02/14] hugetlbfs: don't use ERR_PTR with VM_FAULT*
 values
Date: Thu, 24 May 2012 14:17:43 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205241417240.24113@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=ueje21vCZ/lbAUplxFSMrx5zkD9fc/psoNwnzUXmT+o=;
        b=mEogLrXbCT6urJN0vU0P4Wu7Qi1LW+9PrVAuqEGLSzAapV3FQ5A7c/NNT6J5oHxnhX
         0FvZ6xF3sguuq35X4u3fGCobzMGdGTlGDhAeb40A0iwBvDoqPZ+E4shRNqILWftbGtMw
         dlI9cNDsidCh88pIbnryyvromTy7GRGeJSXW9ereGMnN7a8gxoeiUG+T3e1K5T+3GVym
         y2zfrx9llVa249z5MQEtvRY+aeyLEDZXIijsoqRJ9zN540wo3S/mdUEytaOTtU5sqXeZ
         VhYMYw/7lKhuzoLskdnrH0VoDKow+jQ0e7a662fkqLRKJpGElw5h4aD8Jt2RjiMnLIge
         a1VQ==
In-Reply-To: <1334573091-18602-3-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 16 Apr 2012, Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Using VM_FAULT_* codes with ERR_PTR will require us to make sure
> VM_FAULT_* values will not exceed MAX_ERRNO value.
> 

Is it worth the extra branches?

> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  mm/hugetlb.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 766eb90..5a472a5 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1123,10 +1123,10 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  	 */
>  	chg = vma_needs_reservation(h, vma, addr);
>  	if (chg < 0)
> -		return ERR_PTR(-VM_FAULT_OOM);
> +		return ERR_PTR(-ENOMEM);
>  	if (chg)
>  		if (hugepage_subpool_get_pages(spool, chg))
> -			return ERR_PTR(-VM_FAULT_SIGBUS);
> +			return ERR_PTR(-ENOSPC);
>  
>  	spin_lock(&hugetlb_lock);
>  	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
> @@ -1136,7 +1136,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
>  		if (!page) {
>  			hugepage_subpool_put_pages(spool, chg);
> -			return ERR_PTR(-VM_FAULT_SIGBUS);
> +			return ERR_PTR(-ENOSPC);
>  		}
>  	}
>  
> @@ -2486,6 +2486,7 @@ retry_avoidcopy:
>  	new_page = alloc_huge_page(vma, address, outside_reserve);
>  
>  	if (IS_ERR(new_page)) {
> +		int err = PTR_ERR(new_page);
>  		page_cache_release(old_page);
>  
>  		/*

PTR_ERR() returns long.
