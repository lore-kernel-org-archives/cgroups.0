From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 3/7] mm: memcontrol: convert NR_FILE_THPS account to
 pages
Date: Fri, 11 Dec 2020 13:57:37 +0000
Message-ID: <20201211135737.GA2443@casper.infradead.org>
References: <20201211041954.79543-1-songmuchun@bytedance.com>
 <20201211041954.79543-4-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZihKsA22Et28L+VhHdtqUTD2BoH0RLZyZlt+xMMF8Ow=; b=IyKYrwls3wfp56Z7qFPwr0ue7Z
        Yprw6UCRdnGLdbOf1Sn2AaFRFwqr2StRLqZvlkEvVobIqWznxgPXiEHRDI3mGGeTILifiKRRq1MN6
        3PSkhZ8HzT9DmE5G6vbGrDHNEYKFYSHkD3szMs/kc0gBWk+BSWcJ14PJgSMisrDtxJ4kUR0GKCMJM
        M7qus/u6xx6J2pqCeasF54kAGlcrhWrYvQiUpoG7e5ZDP1Br6TDVaY9+Gpr8hO/A1VWTpVjPAx3pg
        pT/kxGOx4WV03ILPeHx+lt9XtjjII1g2ZKRTWebPTNtmlM0Jfj2fT85MbiH7YPAblbb7Nrd6bBFyn
        oRjQO0sQ==;
Content-Disposition: inline
In-Reply-To: <20201211041954.79543-4-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, shakeelb@google.com, guro@fb.com, samitolvanen@google.com, feng.tang@intel.com, neilb@suse.de, iamjoonsoo.kim@lge.com, rdunlap@infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Fri, Dec 11, 2020 at 12:19:50PM +0800, Muchun Song wrote:
> +++ b/mm/filemap.c
> @@ -207,7 +207,7 @@ static void unaccount_page_cache_page(struct address_space *mapping,
>  		if (PageTransHuge(page))
>  			__dec_lruvec_page_state(page, NR_SHMEM_THPS);
>  	} else if (PageTransHuge(page)) {
> -		__dec_lruvec_page_state(page, NR_FILE_THPS);
> +		__mod_lruvec_page_state(page, NR_FILE_THPS, -HPAGE_PMD_NR);

+               __mod_lruvec_page_state(page, NR_FILE_THPS, -nr);

> +++ b/mm/huge_memory.c
> @@ -2748,7 +2748,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
>  			if (PageSwapBacked(head))
>  				__dec_lruvec_page_state(head, NR_SHMEM_THPS);
>  			else
> -				__dec_lruvec_page_state(head, NR_FILE_THPS);
> +				__mod_lruvec_page_state(head, NR_FILE_THPS,
> +							-HPAGE_PMD_NR);

+                               __mod_lruvec_page_state(head, NR_FILE_THPS,
+                                               -thp_nr_pages(head));

