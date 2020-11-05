From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v20 08/20] mm: page_idle_get_page() does not need lru_lock
Date: Thu, 5 Nov 2020 04:57:02 +0000
Message-ID: <20201105045702.GI17076@casper.infradead.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-9-git-send-email-alex.shi@linux.alibaba.com>
 <20201102144110.GB724984@cmpxchg.org>
 <20201102144927.GN27442@casper.infradead.org>
 <20201102202003.GA740958@cmpxchg.org>
 <b4038b87-cf5a-fcb7-06f4-b98874029615@linux.alibaba.com>
 <20201104174603.GB744831@cmpxchg.org>
 <6eea82d8-e406-06ee-2333-eb6e2f1944e5@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=56c9MV1aCT4xOSMBx0nzDfblxOWC6xg3JuAgCQPVoo0=; b=MtP3X+6N16mNIoQ6VM+zP+mX61
        xZhlLyrMFKBSQTOZqsKgI2SCh4tyCwBipKSKtLPZPw8rs9YxwuiECV/9yS6LDhjuFH/I6yx/YIqh2
        AtQ2CarlmnIs0bwEq890VCWLJakxZsRt/8s3NcD0RPGmUylZaF1L6bKy3RznRg6rB5ufu6PPe5U5d
        Ncq+WO3G3/Sbvn4apMoUtQ2IpG80ZqwDA1iTW+8eJ196udcXf4cOm07Ys1UIw3LqCA/zVJwwRmuw2
        i5B/BI2/zdUb/O22aIeIvtNS/a1NmY4r81q25n70CdNrUNdBVoXybkARM3DiDjAYXFkPUUXTds/+G
        eRC2VJXg==;
Content-Disposition: inline
In-Reply-To: <6eea82d8-e406-06ee-2333-eb6e2f1944e5-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Nov 05, 2020 at 12:52:05PM +0800, Alex Shi wrote:
> @@ -1054,8 +1054,27 @@ static void __page_set_anon_rmap(struct page *page,
>  	if (!exclusive)
>  		anon_vma = anon_vma->root;
>  
> +	/*
> +	 * w/o the WRITE_ONCE here the following scenario may happens due to
> +	 * store reordering.
> +	 *
> +	 *      CPU 0                                          CPU 1
> +	 *
> +	 * do_anonymous_page				page_idle_clear_pte_refs
> +	 *   __page_set_anon_rmap
> +	 *     page->mapping = anon_vma + PAGE_MAPPING_ANON
> +	 *   lru_cache_add_inactive_or_unevictable()
> +	 *     SetPageLRU(page)
> +	 *                                               rmap_walk
> +	 *                                                if PageAnon(page)
> +	 *
> +	 *  The 'SetPageLRU' may reordered before page->mapping setting, and
> +	 *  page->mapping may set with anon_vma, w/o anon bit, then rmap_walk
> +	 *  may goes to rmap_walk_file() for a anon page.
> +	 */
> +
>  	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
> -	page->mapping = (struct address_space *) anon_vma;
> +	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
>  	page->index = linear_page_index(vma, address);
>  }

I don't like these verbose comments with detailed descriptions in
the source code.  They're fine in changelogs, but they clutter the
code, and they get outdated really quickly.  My preference is for
something more brief:

	/*
	 * Prevent page->mapping from pointing to an anon_vma without
	 * the PAGE_MAPPING_ANON bit set.  This could happen if the
	 * compiler stores anon_vma and then adds PAGE_MAPPING_ANON to it.
	 */

