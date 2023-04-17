From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 5/7] mm: thp: split huge page to any lower order pages.
Date: Mon, 17 Apr 2023 10:49:37 -0400
Message-ID: <1EFDB083-B8A4-4CFD-B541-14E3E7D2673A@nvidia.com>
References: <20230403201839.4097845-1-zi.yan@sent.com>
 <20230403201839.4097845-6-zi.yan@sent.com>
 <26723f25-609a-fe9c-a41a-e692634d892@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_E27FE2B1-7DD0-4834-8A18-60CDA8705A11_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5aRtImfkoQ1djdihoVfF3Oi5BalMHo8UpAtjiBqKHs=;
 b=gYg3JW9szwW/aX1NZo2Iqb63pToWpvalrGDrd2guf20OAbC5NG5RjLFRzXJev01UYrfjIrOopSnqejBjycpR/jRBq53OICswo5Kd3heht1tbjhwT4v0dzVNhViwge/Hh1t+ecX22NQYfypmGsbE8JSnUdYBGRKCW+aFz2yMFm9b0ij4nHGyBtb3QxFFQisU5onkryegaqtMmmuNIAKDYERucaAxcmlMz3tBCBjx0IXKrEInUkcylihueMmlBS1D+vB5gf1CkeVetMjXArGE6NNFQy2cqba3xcRgReRjYoEEnXKj9aze9cuJsHOs+MIK6DvIOw/DagCFhqPDYtg5M7g==
In-Reply-To: <26723f25-609a-fe9c-a41a-e692634d892-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--=_MailMate_E27FE2B1-7DD0-4834-8A18-60CDA8705A11_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On 16 Apr 2023, at 15:25, Hugh Dickins wrote:

> On Mon, 3 Apr 2023, Zi Yan wrote:
>
>> From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>
>> To split a THP to any lower order pages, we need to reform THPs on
>> subpages at given order and add page refcount based on the new page
>> order. Also we need to reinitialize page_deferred_list after removing
>> the page from the split_queue, otherwise a subsequent split will see
>> list corruption when checking the page_deferred_list again.
>>
>> It has many uses, like minimizing the number of pages after
>> truncating a huge pagecache page. For anonymous THPs, we can only spli=
t
>> them to order-0 like before until we add support for any size anonymou=
s
>> THPs.
>>
>> Signed-off-by: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> ---
> ...
>> @@ -2754,14 +2798,18 @@ int split_huge_page_to_list(struct page *page,=
 struct list_head *list)
>>  			if (folio_test_swapbacked(folio)) {
>>  				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
>>  							-nr);
>> -			} else {
>> +			} else if (!new_order) {
>> +				/*
>> +				 * Decrease THP stats only if split to normal
>> +				 * pages
>> +				 */
>>  				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
>>  							-nr);
>>  				filemap_nr_thps_dec(mapping);
>>  			}
>>  		}
>
> This part is wrong.  The problem I've had is /proc/sys/vm/stat_refresh
> warning of negative nr_shmem_hugepages (which then gets shown as 0 in
> vmstat or meminfo, even though there actually are shmem hugepages).
>
> At first I thought that the fix needed (which I'm running with) is:
>
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2797,17 +2797,16 @@ int split_huge_page_to_list_to_order(str
>  			int nr =3D folio_nr_pages(folio);
>
>  			xas_split(&xas, folio, folio_order(folio));
> -			if (folio_test_swapbacked(folio)) {
> -				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
> -							-nr);
> -			} else if (!new_order) {
> -				/*
> -				 * Decrease THP stats only if split to normal
> -				 * pages
> -				 */
> -				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
> -							-nr);
> -				filemap_nr_thps_dec(mapping);
> +			if (folio_test_pmd_mappable(folio) &&
> +			    new_order < HPAGE_PMD_ORDER) {
> +				if (folio_test_swapbacked(folio)) {
> +					__lruvec_stat_mod_folio(folio,
> +							NR_SHMEM_THPS, -nr);
> +				} else {
> +					__lruvec_stat_mod_folio(folio,
> +							NR_FILE_THPS, -nr);
> +					filemap_nr_thps_dec(mapping);
> +				}
>  			}
>  		}
>
> because elsewhere the maintenance of NR_SHMEM_THPS or NR_FILE_THPS
> is rightly careful to be dependent on folio_test_pmd_mappable() (and,
> so far as I know, we shall not be seeing folios of order higher than
> HPAGE_PMD_ORDER yet in mm/huge_memory.c - those would need more thought=
).
>
> But it may be more complicated than that, given that patch 7/7 appears
> (I haven't tried) to allow splitting to other orders on a file opened
> for reading - that might be a bug.
>
> The complication here is that we now have four kinds of large folio
> in mm/huge_memory.c, and the rules are a bit different for each.
>
> Anonymous THPs: okay, I think I've seen you exclude those with -EINVAL
> at a higher level (and they wouldn't be getting into this "if (mapping)=
 {"
> block anyway).
>
> Shmem (swapbacked) THPs: we are only allocating shmem in 0-order or
> HPAGE_PMD_ORDER at present.  I can imagine that in a few months or a
> year-or-so's time, we shall want to follow Matthew's folio readahead,
> and generalize to other orders in shmem; but right now I'd really
> prefer not to have truncation or debugfs introducing the surprise
> of other orders there.  Maybe there's little that needs to be fixed,
> only the THP_SWPOUT and THP_SWPOUT_FALLBACK statistics have come to
> mind so far (would need to be limited to folio_test_pmd_mappable());
> though I've no idea how well intermediate orders will work with or
> against THP swapout.
>
> CONFIG_READ_ONLY_THP_FOR_FS=3Dy file THPs: those need special care,
> and their filemap_nr_thps_dec(mapping) above may not be good enough.
> So long as it's working as intended, it does exclude the possibility
> of truncation splitting here; but if you allow splitting via debugfs
> to reach them, then the accounting needs to be changed - for them,
> any order higher than 0 has to be counted in nr_thps - so splitting
> one HPAGE_PMD_ORDER THP into multiple large folios will need to add
> to that count, not decrement it.  Otherwise, a filesystem unprepared
> for large folios or compound pages is in danger of meeting them by
> surprise.  Better just disable that possibility, along with shmem.

OK. I will disable for these two cases. I will come back to them
once I figure the details out.

>
> mapping_large_folio_support() file THPs: this category is the one
> you're really trying to address with this series, they can already
> come in various orders, and it's fair for truncation to make a
> different choice of orders - but is what it's doing worth doing?
> I'll say more on 6/7.
>
> Hugh

--=_MailMate_E27FE2B1-7DD0-4834-8A18-60CDA8705A11_=--
