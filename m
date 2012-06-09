From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH -V8 02/16] hugetlb: don't use ERR_PTR with VM_FAULT*
 values
Date: Sat, 9 Jun 2012 07:10:11 -0400
Message-ID: <20120609111010.GA16034@localhost.localdomain>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339232401-14392-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Wjn3OX0M3jYUIfbRSjicwKgfIpm/yXH6/MPZBetJPx0=;
        b=cx48I7FQU4FrTGcUqx5ohA0SS4tC/fL8n5d3006wNbNoRroAuLbOBpboYubbRwiJM0
         LSNqYkAc0fUuwjwrLTYWIL0+xeyF9mLNasbm6miDKJrVZLWVRKxJLbwHECsyEc7tVOJz
         yz9AjvfHZrvqBm/kcng0O1DGbkPmT8SbmZZ6NkduYYB19RkYH0bx5l5CE+QorwfhBoDt
         No8KAuTanpaV70Y0OfdicTrqD0BzkkxjV0x9BAJJd08m5T5upgyLlqvYaCR3mtQi+L62
         J0+kXO5upI0wp/GUayJ2Zjz+/lPjvUZGUJEjP3KuxRD+jh6yCJSuo4uhhxJHWhhwDjyY
         RLJA==
Content-Disposition: inline
In-Reply-To: <1339232401-14392-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Sat, Jun 09, 2012 at 02:29:47PM +0530, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> The current use of VM_FAULT_* codes with ERR_PTR requires us to ensure
> VM_FAULT_* values will not exceed MAX_ERRNO value. Decouple the
> VM_FAULT_* values from MAX_ERRNO.

I see you using the -ENOMEM|-ENOSPC, but I don't see any reference in the
code to MAX_ERRNO? Can you provide a comment explaining in a tad little
bit about the interaction of MAX_ERRNO and VM_FAULT?

> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  mm/hugetlb.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c868309..34a7e23 100644
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
> @@ -2496,6 +2496,7 @@ retry_avoidcopy:
>  	new_page = alloc_huge_page(vma, address, outside_reserve);
>  
>  	if (IS_ERR(new_page)) {
> +		long err = PTR_ERR(new_page);
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
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
