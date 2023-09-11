From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcg: add THP swap out info for anonymous reclaim
Date: Mon, 11 Sep 2023 12:08:24 -0400
Message-ID: <20230911160824.GB103342@cmpxchg.org>
References: <20230909155242.22767-1-vernhao@tencent.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1694448506; x=1695053306; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OpK471urcTKFhaEEiu2Y7Ctk71H7kGAYVejmdBrLuVg=;
        b=qXBzv6zXqpFaPW0WDtiAxbUeFE2eeqfUM0Ioy+Gby2UX3k8jg8ihHdQM8fTTwRSJ3X
         bVXI5M2XAoYmskSSdzLL9ca/823siSnYgN5xe0r3kbXb4OPrE+g2G774G4WYA7hm/3A4
         OlRFVa6jm9bRcFjFDto+Ywe4e/OB97U1PnAeFSaS5eA5SBV0S5eXeui3XQ5cZCPbRz0V
         VALgcZQ9Jd0XdeGgsuTH5cqr+jo5KzR5lvM2lL+baJTkU2kD94fEPbqN/RznDTN8/ewk
         hG/qDobfKa4PLboTR6RvJepKYf//CQrC3XnRR8K+z7dknwHO/QhdBEa+xxXXtksk2EPz
         hyIg==
Content-Disposition: inline
In-Reply-To: <20230909155242.22767-1-vernhao@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Hao <haoxing990@gmail.com>
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Sat, Sep 09, 2023 at 11:52:41PM +0800, Xin Hao wrote:
> At present, we support per-memcg reclaim strategy, however we do not
> know the number of transparent huge pages being reclaimed, as we know
> the transparent huge pages need to be splited before reclaim them, and
> they will bring some performance bottleneck effect. for example, when
> two memcg (A & B) are doing reclaim for anonymous pages at same time,
> and 'A' memcg is reclaiming a large number of transparent huge pages, we
> can better analyze that the performance bottleneck will be caused by 'A'
> memcg.  therefore, in order to better analyze such problems, there add
> THP swap out info for per-memcg.
> 
> Signed-off-by: Xin Hao <vernhao@tencent.com>

That sounds reasonable. A few comments below:

> @@ -4131,6 +4133,10 @@ static const unsigned int memcg1_events[] = {
>  	PGPGOUT,
>  	PGFAULT,
>  	PGMAJFAULT,
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	THP_SWPOUT,
> +	THP_SWPOUT_FALLBACK,
> +#endif
>  };

Cgroup1 is maintenance-only, please drop this hunk.

>  static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
> diff --git a/mm/page_io.c b/mm/page_io.c
> index fe4c21af23f2..008ada2e024a 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -208,8 +208,10 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>  static inline void count_swpout_vm_event(struct folio *folio)
>  {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (unlikely(folio_test_pmd_mappable(folio)))
> +	if (unlikely(folio_test_pmd_mappable(folio))) {
> +		count_memcg_events(folio_memcg(folio), THP_SWPOUT, 1);

count_memcg_folio_events()

>  		count_vm_event(THP_SWPOUT);
> +	}
>  #endif
>  	count_vm_events(PSWPOUT, folio_nr_pages(folio));
>  }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ea57a43ebd6b..29a82b72345a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1928,6 +1928,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  								folio_list))
>  						goto activate_locked;
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +					count_memcg_events(folio_memcg(folio),
> +							   THP_SWPOUT_FALLBACK, 1);

count_memcg_folio_events()
