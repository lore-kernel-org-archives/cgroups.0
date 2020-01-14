From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 6/8] hugetlb_cgroup: support noreserve mappings
Date: Mon, 13 Jan 2020 16:48:35 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001131646490.164268@chino.kir.corp.google.com>
References: <20191217231615.164161-1-almasrymina@google.com> <20191217231615.164161-6-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=ANoh8uEOm+gmkt+50LunFAVjJew2LvqnFtto+wxCdzA=;
        b=EIJTvGsSDiqJOKnxxqwUUm7ON/pxRF/Iw9epIVmqhs0PtXyaeT1+6YJNK88D1q3wU1
         PGDDHVr/nHr2tKVTneq/1tZK0Lgua6Y3amEdx12flXktjw43k4MPa8GVdezL24+pJuOB
         4FzXZvW4Rokk8BUUx9dGu8wxYJkh/Cscc1wpUn3PAcCRKDQ8ZK7KEmRUEmcq67E6AJW9
         aU4xYMyBwEKfjvnbLzFzzXt0IJWxZ73lAjk6fdL0NUNBLQEVNSzPoob1CxfbPn9uL+e8
         KwDPS/hMnvImDwr5iR+h0E6Q7jyLiG8ZmM9AK3cSlTrvQMnLWltShhFSnRKb4YdORW3S
         gGeA==
In-Reply-To: <20191217231615.164161-6-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org

On Tue, 17 Dec 2019, Mina Almasry wrote:

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 39eb2fa53a420..3e94f5c2d7cd4 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1367,6 +1367,9 @@ void free_huge_page(struct page *page)
>  	clear_page_huge_active(page);
>  	hugetlb_cgroup_uncharge_page(hstate_index(h), pages_per_huge_page(h),
>  				     page, false);
> +	hugetlb_cgroup_uncharge_page(hstate_index(h), pages_per_huge_page(h),
> +				     page, true);
> +
>  	if (restore_reserve)
>  		h->resv_huge_pages++;
> 
> @@ -2189,10 +2192,19 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
>  			gbl_chg = 1;
>  	}
> 
> +	/* If this allocation is not consuming a reservation, charge it now.
> +	 */
> +	if (map_chg || avoid_reserve || !vma_resv_map(vma)) {

These conditions are checked three times in this function, maybe better 
set a bool on the stack and use it throughout the function to guarantee it 
remains consistent?

bool deferred_reserve = !vma_resv_map(vma) || map_chg || avoid_reserve;

> +		ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h),
> +						   &h_cg, true);
> +		if (ret)
> +			goto out_subpool_put;
> +	}
> +
>  	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg,
>  					   false);
>  	if (ret)
> -		goto out_subpool_put;
> +		goto out_uncharge_cgroup_reservation;
> 
>  	spin_lock(&hugetlb_lock);
>  	/*
> @@ -2216,6 +2228,14 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
>  	}
>  	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page,
>  				     false);
> +	/* If allocation is not consuming a reservation, also store the
> +	 * hugetlb_cgroup pointer on the page.
> +	 */
> +	if (!vma_resv_map(vma) || map_chg || avoid_reserve) {
> +		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg,
> +					     page, true);
> +	}
> +
>  	spin_unlock(&hugetlb_lock);
> 
>  	set_page_private(page, (unsigned long)spool);
> @@ -2241,6 +2261,10 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg,
>  				       false);
> +out_uncharge_cgroup_reservation:
> +	if (map_chg || avoid_reserve || !vma_resv_map(vma))
> +		hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h),
> +					       h_cg, true);
>  out_subpool_put:
>  	if (map_chg || avoid_reserve)
>  		hugepage_subpool_put_pages(spool, 1);
> --
> 2.24.1.735.g03f4e72817-goog
> 
