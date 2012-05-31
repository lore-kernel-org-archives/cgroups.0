From: Konrad Rzeszutek Wilk <konrad-Gq0aWv8utHQdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -V7 02/14] hugetlbfs: don't use ERR_PTR with VM_FAULT*
 values
Date: Wed, 30 May 2012 20:54:43 -0400
Message-ID: <20120531005442.GD401@localhost.localdomain>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1338388739-22919-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MSyRMSD+8JNCdh1NzfS3pLDIoJuNeO6vPisAVoPh/6w=;
        b=mGkyxDCzgFbTUxeHI4+bSTKUKOL0HelI7BJBFUgwFICuBxxOZvQUgNHy4b5fJQ1cjW
         SDjW9Nsb9lwxuqj4o038FGn9c+WEh/E9DpGLz+digc/ZiKPCZnLwE1QkoKfXc4NddMlB
         Jv4Eq/p9Z70JV4kxfcOMGejm0UY8GUeAgdvJeQEB0DVMhazAWL40JAR9SGadtPE4Yak7
         UAG5ns2vfGZuMvueSYPMHtHS+gJ/F2vBV2PD9Y9t0kCnVr/U9Jmhv6hFK6i1dIMUDDH7
         7XygQEGvnw/MZfEuqDzRBCBtRAIMpm2DDQ9jwHh6QVG1vcbpByFiE0ahHVKvzwas48RW
         LivQ==
Content-Disposition: inline
In-Reply-To: <1338388739-22919-3-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, May 30, 2012 at 08:08:47PM +0530, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> The current use of VM_FAULT_* codes with ERR_PTR requires us to ensure
> VM_FAULT_* values will not exceed MAX_ERRNO value.  Decouple the
> VM_FAULT_* values from MAX_ERRNO.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  mm/hugetlb.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e07d4cd..8ded02d 100644
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

Not enough space? Why not just pass what 'hugepage_subpool_get_pages'
returns?

>  
>  	spin_lock(&hugetlb_lock);
>  	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
> @@ -1136,7 +1136,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
>  		if (!page) {
>  			hugepage_subpool_put_pages(spool, chg);
> -			return ERR_PTR(-VM_FAULT_SIGBUS);
> +			return ERR_PTR(-ENOSPC);

-ENOMEM seems more appropiate?
>  		}
>  	}
>  
> @@ -2496,6 +2496,7 @@ retry_avoidcopy:
>  	new_page = alloc_huge_page(vma, address, outside_reserve);
>  
>  	if (IS_ERR(new_page)) {
> +		int err = PTR_ERR(new_page);
>  		page_cache_release(old_page);
>  
>  		/*
> @@ -2524,7 +2525,10 @@ retry_avoidcopy:
>  
>  		/* Caller expects lock to be held */
>  		spin_lock(&mm->page_table_lock);
> -		return -PTR_ERR(new_page);
> +		if (err == -ENOMEM)
> +			return VM_FAULT_OOM;
> +		else
> +			return VM_FAULT_SIGBUS;

Ah, you are doing it to translate it.
Perhaps you should return -EFAULT for the really bad case
where you need to do OOM and then for all the other cases
return SIGBUS? Or maybe the other way around? ENOSPC doesn't
seem like the right error.

>  	}
>  
>  	/*
> @@ -2642,7 +2646,11 @@ retry:
>  			goto out;
>  		page = alloc_huge_page(vma, address, 0);
>  		if (IS_ERR(page)) {
> -			ret = -PTR_ERR(page);
> +			ret = PTR_ERR(page);
> +			if (ret == -ENOMEM)
> +				ret = VM_FAULT_OOM;
> +			else
> +				ret = VM_FAULT_SIGBUS;
>  			goto out;
>  		}
>  		clear_huge_page(page, address, pages_per_huge_page(h));
> -- 
> 1.7.10
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
> 
