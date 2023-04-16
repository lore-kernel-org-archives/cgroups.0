From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 5/7] mm: thp: split huge page to any lower order
 pages.
Date: Sun, 16 Apr 2023 12:25:37 -0700 (PDT)
Message-ID: <26723f25-609a-fe9c-a41a-e692634d892@google.com>
References: <20230403201839.4097845-1-zi.yan@sent.com> <20230403201839.4097845-6-zi.yan@sent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681673140; x=1684265140;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MaaXUmWYMUrm34mHy8xc1MH5y2IuXmSQmwypNMLJjoU=;
        b=1vkT+hAAWPKcBqQRjg5UlEuk7b/6YGv9MDW7ocM6tyOydCQ8m188DAXZgYCjKYgskz
         l2WmKzdeIvIpplhACjFYmHbx53zO0q+HQwzxe5p5dKYP/zmwWfGPKSW0Q6ocK17IlorQ
         1REaf9+uusXPEJOfHMzNR92oZiPCgN9+CpKgjJiggkmT1hrE0wOb4HuizMvt/FoHbDu4
         Fh2t5T36T1jcZkgepypMcH846gV0XmKgrwg7pWOvbDi70FzRnFDqg+rD/t6DVFm4hbEO
         s4xbCAgP8S4lH5NxtnThScJmZrax+zspeTnS9Sdsb2y0uWGlWTFSmrYV93/N2wFbgS+V
         0+NQ==
In-Reply-To: <20230403201839.4097845-6-zi.yan-vRdzynncJC4@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, =?ISO-8859-15?Q?Michal_Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 3 Apr 2023, Zi Yan wrote:

> From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> 
> To split a THP to any lower order pages, we need to reform THPs on
> subpages at given order and add page refcount based on the new page
> order. Also we need to reinitialize page_deferred_list after removing
> the page from the split_queue, otherwise a subsequent split will see
> list corruption when checking the page_deferred_list again.
> 
> It has many uses, like minimizing the number of pages after
> truncating a huge pagecache page. For anonymous THPs, we can only split
> them to order-0 like before until we add support for any size anonymous
> THPs.
> 
> Signed-off-by: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> ---
...
> @@ -2754,14 +2798,18 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
>  			if (folio_test_swapbacked(folio)) {
>  				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
>  							-nr);
> -			} else {
> +			} else if (!new_order) {
> +				/*
> +				 * Decrease THP stats only if split to normal
> +				 * pages
> +				 */
>  				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
>  							-nr);
>  				filemap_nr_thps_dec(mapping);
>  			}
>  		}

This part is wrong.  The problem I've had is /proc/sys/vm/stat_refresh 
warning of negative nr_shmem_hugepages (which then gets shown as 0 in
vmstat or meminfo, even though there actually are shmem hugepages).

At first I thought that the fix needed (which I'm running with) is:

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2797,17 +2797,16 @@ int split_huge_page_to_list_to_order(str
 			int nr = folio_nr_pages(folio);
 
 			xas_split(&xas, folio, folio_order(folio));
-			if (folio_test_swapbacked(folio)) {
-				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
-							-nr);
-			} else if (!new_order) {
-				/*
-				 * Decrease THP stats only if split to normal
-				 * pages
-				 */
-				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
-							-nr);
-				filemap_nr_thps_dec(mapping);
+			if (folio_test_pmd_mappable(folio) &&
+			    new_order < HPAGE_PMD_ORDER) {
+				if (folio_test_swapbacked(folio)) {
+					__lruvec_stat_mod_folio(folio,
+							NR_SHMEM_THPS, -nr);
+				} else {
+					__lruvec_stat_mod_folio(folio,
+							NR_FILE_THPS, -nr);
+					filemap_nr_thps_dec(mapping);
+				}
 			}
 		}
 
because elsewhere the maintenance of NR_SHMEM_THPS or NR_FILE_THPS
is rightly careful to be dependent on folio_test_pmd_mappable() (and,
so far as I know, we shall not be seeing folios of order higher than
HPAGE_PMD_ORDER yet in mm/huge_memory.c - those would need more thought).

But it may be more complicated than that, given that patch 7/7 appears
(I haven't tried) to allow splitting to other orders on a file opened
for reading - that might be a bug.

The complication here is that we now have four kinds of large folio
in mm/huge_memory.c, and the rules are a bit different for each.

Anonymous THPs: okay, I think I've seen you exclude those with -EINVAL
at a higher level (and they wouldn't be getting into this "if (mapping) {"
block anyway).

Shmem (swapbacked) THPs: we are only allocating shmem in 0-order or
HPAGE_PMD_ORDER at present.  I can imagine that in a few months or a
year-or-so's time, we shall want to follow Matthew's folio readahead,
and generalize to other orders in shmem; but right now I'd really
prefer not to have truncation or debugfs introducing the surprise
of other orders there.  Maybe there's little that needs to be fixed,
only the THP_SWPOUT and THP_SWPOUT_FALLBACK statistics have come to
mind so far (would need to be limited to folio_test_pmd_mappable());
though I've no idea how well intermediate orders will work with or
against THP swapout.

CONFIG_READ_ONLY_THP_FOR_FS=y file THPs: those need special care,
and their filemap_nr_thps_dec(mapping) above may not be good enough.
So long as it's working as intended, it does exclude the possibility
of truncation splitting here; but if you allow splitting via debugfs
to reach them, then the accounting needs to be changed - for them,
any order higher than 0 has to be counted in nr_thps - so splitting
one HPAGE_PMD_ORDER THP into multiple large folios will need to add
to that count, not decrement it.  Otherwise, a filesystem unprepared
for large folios or compound pages is in danger of meeting them by
surprise.  Better just disable that possibility, along with shmem.

mapping_large_folio_support() file THPs: this category is the one
you're really trying to address with this series, they can already
come in various orders, and it's fair for truncation to make a
different choice of orders - but is what it's doing worth doing?
I'll say more on 6/7.

Hugh
