From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 6/9] hugetlb_cgroup: support noreserve mappings
Date: Tue, 18 Feb 2020 12:57:36 -0800
Message-ID: <ace490c3-03b3-da85-bbdf-00959a71ff2f@oracle.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211213128.73302-6-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BtjGqj+3jNiQRHCMij91pFpkChLnYumQhRXFWLWiTKc=;
 b=knIApa8S39JVJ40ICW9Cl3OBBL1pEfta3YUmcensHG8JUob3YXeVTh1ez5jwgX1DJxuo
 NfRZzI+s6OCctl4tK3wKYdBs9Qg7LK0q+c6gqxLpSou+OAF0vln2dzJfe0XIkiaOqyVY
 UyT1wzT1lyLD2OfL4SEjXPqLla0h7Bu9x03zzlxkI9Sl5juEyNY8ylHykH+CnKGuauJO
 kNp95zuJo+0Ax0cCEwc/bK1nKtxEynhTgSEBxUSnlKJrcW5tHTrk+0AxyDfhrKtYseHC
 pJ6XkBuyBTNXMgOK6PWbMbdKZ/nRwWxszM3ci0gKeV7q70iFFs66ad30d7J+hDSijhzC lw== 
In-Reply-To: <20200211213128.73302-6-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/11/20 1:31 PM, Mina Almasry wrote:
> Support MAP_NORESERVE accounting as part of the new counter.
> 
> For each hugepage allocation, at allocation time we check if there is
> a reservation for this allocation or not. If there is a reservation for
> this allocation, then this allocation was charged at reservation time,
> and we don't re-account it. If there is no reserevation for this
> allocation, we charge the appropriate hugetlb_cgroup.
> 
> The hugetlb_cgroup to uncharge for this allocation is stored in
> page[3].private. We use new APIs added in an earlier patch to set this
> pointer.
> 
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> ---
> 
> Changes in v12:
> - Minor rebase to new interface for readability.
> 
> Changes in v10:
> - Refactored deferred_reserve check.
> 
> ---
>  mm/hugetlb.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a9171c3cbed6b..2d62dd35399db 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1342,6 +1342,8 @@ static void __free_huge_page(struct page *page)
>  	clear_page_huge_active(page);
>  	hugetlb_cgroup_uncharge_page(hstate_index(h),
>  				     pages_per_huge_page(h), page);
> +	hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
> +					  pages_per_huge_page(h), page);
>  	if (restore_reserve)
>  		h->resv_huge_pages++;
> 
> @@ -2175,6 +2177,7 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
>  	long gbl_chg;
>  	int ret, idx;
>  	struct hugetlb_cgroup *h_cg;
> +	bool deferred_reserve;
> 
>  	idx = hstate_index(h);
>  	/*
> @@ -2212,9 +2215,19 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
>  			gbl_chg = 1;
>  	}
> 
> +	/* If this allocation is not consuming a reservation, charge it now.
> +	 */
> +	deferred_reserve = map_chg || avoid_reserve || !vma_resv_map(vma);
> +	if (deferred_reserve) {
> +		ret = hugetlb_cgroup_charge_cgroup_rsvd(
> +			idx, pages_per_huge_page(h), &h_cg);
> +		if (ret)
> +			goto out_subpool_put;
> +	}
> +
>  	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
>  	if (ret)
> -		goto out_subpool_put;
> +		goto out_uncharge_cgroup_reservation;
> 
>  	spin_lock(&hugetlb_lock);
>  	/*
> @@ -2237,6 +2250,14 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
>  		/* Fall through */
>  	}
>  	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
> +	/* If allocation is not consuming a reservation, also store the
> +	 * hugetlb_cgroup pointer on the page.
> +	 */
> +	if (deferred_reserve) {
> +		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
> +						  h_cg, page);
> +	}
> +

This started before your new code, but those two cgroup_commit_charge calls
could/should be done outside the hugetlb_lock.  No need to change as it is
not a big deal.  Those calls only set fields in the page structs.

Reviewed-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Mike Kravetz

>  	spin_unlock(&hugetlb_lock);
> 
>  	set_page_private(page, (unsigned long)spool);
> @@ -2261,6 +2282,10 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
> 
>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
> +out_uncharge_cgroup_reservation:
> +	if (deferred_reserve)
> +		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
> +						    h_cg);
>  out_subpool_put:
>  	if (map_chg || avoid_reserve)
>  		hugepage_subpool_put_pages(spool, 1);
> --
> 2.25.0.225.g125e21ebc7-goog
> 
