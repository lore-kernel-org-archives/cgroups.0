Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3387446E01C
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 08:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786091370; cv=none; b=fBiRAFKu0xxS+7WdmSzJdn7fZjfxHdRHtK4zllVCaaR924nF+XsnLw3NMP2/nsuXtjZuc28ViC8ARiH2FsxRiGTnTpYv+JkrNBsd8+D8cpDVvIaRH2sFT4xkDgjjzc65gtArZ1Uf7/rFrSlL3YmgX0vv+5UwFdtpxdkJGbWQCgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786091370; c=relaxed/simple;
	bh=bqt9Yz87RU5nN1l0lkue9RQy5n80oAqd3eB6vqo+x58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iK0EAWjH+AAh3W6Tszfle61bIa6IaCiEJ/S6waCBIiEJ17X+JQvXW0pCp39fKFCNLDokWJB9mWR87HjwnOCxrENLTI5Jld244FsUSrbN0J2yPwmIsVImlLimuX46QpfJuBrRcd2adn/jkantQE4JgH0kAkiQFZcCdvyWowMzMHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PwRrNkZx; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PwRrNkZx"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3811f512167so3748338a91.3
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 01:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786091366; x=1786696166; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jSdehXnGw+ibRHaOVjI8Ioi7JL8VFOTG325yque/uGM=;
        b=PwRrNkZxxr7ZAIN4c8mDz5cJgDL4UlHoySvCD8ocecXo19/s1vWiJOzs00q3oqcuws
         1qrr3gmi75RKzZs8GLa30QSUL/4eXH2d0yvJ2PjWl5xW6ndeGLAhAwUqh4PdAwfiavMe
         3OwOHeyh/m1Yr9Gv62Tb7VoXkyqS3eORFN5Hanh+0uPLkzbX5YbC9r1NVI3NMdBpyBDp
         wLyo46Xa0fPT8MrgPvufpOjrywysvw83e3JkLkvziBglrukIRY9pxc5rYe0CM/9TVf1u
         IotZvn6PO+8E1XiU4AiCNxnp7f3AS/0WBOLNM1lR4TuqsP1dw1+T+eD9tRPtZT2+imJN
         fJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786091366; x=1786696166;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jSdehXnGw+ibRHaOVjI8Ioi7JL8VFOTG325yque/uGM=;
        b=RH/L5k6Fbj/sPwNHP7elal07sKVe4xDvM40F3Lyw02rbtiZYTxzhAOmGH5uHg/LYMb
         weW02xRoXkVNLMvOjqpnMsMElMdndKUwb9z4sLwvlIRHRg+iQb4ltrX+uCGFwc7OS5CQ
         ttcSkCGCtk84PnkghTjAVWJI7eBNJNNPZA0p28mAnqy4BQcYpp660gRNDORPnnO8uE1v
         5cxvZX8efWJJ4Kdx3JFqmxr4SAFC0FegdHQyIFyk36XwAFPk4Z2y7/3eYmHl8dAtsalk
         hLavgxbQlsF5koK6QBX08BamtALz8JgtT+OWAKUoQgDV8dOL7odd+t56TV6VU9xSBYc9
         cveg==
X-Forwarded-Encrypted: i=1; AHgh+Rr5XTKUZWE9k2ezyHV7FsPXm24uJtzJKRw916YwjfV6Ie7mVX5tZCjb/Bqsyl8tmnhPlIJ2w3R4@vger.kernel.org
X-Gm-Message-State: AOJu0YxHJ0ZsXhIUcA1I2JNN8xssAX0BHqD7yFByxnomQOe9DDqlBnnh
	jWKmDkquN4ORgLso5MrTNcC4wIGUMpOeJENhsvRnZE6rVAo0PU1Kl4qB
X-Gm-Gg: AR+sD11blyx82g0Bh7xkbXERqOtB326P9uOAEEBgNWNkh3tGahqTeD53PDUuqq1Mve6
	WvSbjVuEWrrIDadEJomWGhQW/s0QtDYcl7jQusUbn3E3uE8jj3e0Y2AjTLQTY/MF9UIwvL0ax48
	UG2/mTqkXc6ySKYVbCz930SsNVC5gt/dOXCZRhlmSIvVehWwtbqQ7kWgNvTrWbvM2DU7ZnveWwB
	oebwSYNJpMfabHX3WAmdT6ML4XCL9BKuPu2XpnzE8ibyM7dprorL+77Hb+/BvAz/rg/U1RsAtLv
	p8dbXS6tDJc+Su3caKmoIh/88PkIxqBadKaLIe+McHSLxlTXZhO9CGk0/e25B6/rejanjRLhpha
	3JdjGEQM5Lp+hwra9as4uKWvHh4aVuiyNWWpkCDouAz4yKuaOGjga4wvJrFy6aZzy7XPNaUvsu7
	aWwgAjPOJN4Sy8BaD+f2AcNMJP2Oc19mX8LVAXnc+T6X6a7MAGJaAGbHMOjAI8dyBH5IZ+CUilO
	ivogTXML+AFjiDMGx6E0tsj34o1itSHkQ==
X-Received: by 2002:a17:90b:41:b0:37f:ed7e:7e42 with SMTP id 98e67ed59e1d1-3903c5bd850mr22010506a91.14.1786091366383;
        Fri, 07 Aug 2026 01:29:26 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3925ff23539sm1569505a91.11.2026.08.07.01.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 01:29:25 -0700 (PDT)
Date: Fri, 7 Aug 2026 16:29:17 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	baohua@kernel.org, hannes@cmpxchg.org, youngjun.park@lge.com, 
	baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation
 failures
Message-ID: <anWAZ3T6Sz8bsKSo@KASONG-MC4>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730122304.2496440-3-xueyuan.chen21@gmail.com>

On Thu, Jul 30, 2026 at 08:23:02PM +0800, Xueyuan Chen wrote:
> folio_alloc_swap() reports most allocation failures with a generic
> negative error code. Reclaim cannot tell whether splitting a large folio
> could make progress or whether there is no backing space at all.
> 
> Keep the global free swap count and the remaining hierarchical memcg swap
> margin as separate inputs. The memcg charge path reports only its own
> margin; folio_alloc_swap() combines the two layers when classifying an
> allocation failure.
> 
> Return -E2BIG for large folios when a smaller allocation might still fit,
> -ENOSPC when no global swap space is available, and -ENOMEM when the
> failure is not helped by splitting.
> 
> For early large-folio rejections, check global and memcg swap availability
> instead of returning -E2BIG unconditionally. On a memcg charge failure,
> swap slot allocation has already succeeded, so use the remaining memcg
> margin to decide whether a smaller charge might fit.
> 
> This only refines folio_alloc_swap() return codes. The reclaim callers are
> updated separately.
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Suggested-by: Youngjun Park <youngjun.park@lge.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  include/linux/swap.h | 16 ++++++++++++----
>  mm/memcontrol.c      | 32 +++++++++++++++++++++++++++++++-
>  mm/swapfile.c        | 32 ++++++++++++++++++++++++--------
>  3 files changed, 67 insertions(+), 13 deletions(-)
> 

Hello Xueyuan,

Thanks for the patch!

> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 0544b2ec4c56..7d12058174ae 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -509,12 +509,13 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
>  #endif
>  
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> -int __mem_cgroup_try_charge_swap(struct folio *folio);
> -static inline int mem_cgroup_try_charge_swap(struct folio *folio)
> +int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin);
> +static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> +					     long *swap_margin)

Am I the only one that feel this returning argument is a bit ugly? See below..

> +/**
> + * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
> + * @folio: folio whose memcg margin is queried
> + *
> + * Return: Remaining chargeable pages in the folio's memcg hierarchy.
> + */
> +long mem_cgroup_get_folio_swap_margin(struct folio *folio)
> +{
> +	long swap_margin = PAGE_COUNTER_MAX;
> +	struct mem_cgroup *memcg;
> +	struct obj_cgroup *objcg;
> +
> +	if (mem_cgroup_disabled() || do_memsw_account())
> +		return swap_margin;
> +
> +	objcg = folio_objcg(folio);
> +	if (!objcg)
> +		return swap_margin;
> +
> +	rcu_read_lock();
> +	memcg = obj_cgroup_memcg(objcg);
> +	swap_margin = page_counter_margin(&memcg->swap);
> +	rcu_read_unlock();
> +
> +	return swap_margin;
> +}
> +

Will is be good if we just always check the margin use this helper
on alloc failure? Alloc failure should be a rather cold path I think?

>  bool mem_cgroup_swap_full(struct folio *folio)
>  {
>  	struct mem_cgroup *memcg;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 70b90fa9c2a0..ae62c9f9c0f2 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1735,23 +1735,28 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
>   * swap cache.
>   *
>   * Context: Caller needs to hold the folio lock.
> - * Return: Whether the folio was added to the swap cache.
> + * Return: %0 on success, %-E2BIG if splitting the folio might allow swapout,
> + * %-ENOSPC if no global swap space is available, or %-ENOMEM if splitting
> + * would not help.
>   */
>  int folio_alloc_swap(struct folio *folio)
>  {
>  	unsigned int order = folio_order(folio);
>  	unsigned int size = 1 << order;
> +	long swap_margin = PAGE_COUNTER_MAX;
>  
>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>  	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
>  
>  	if (order) {
>  		/*
> -		 * Reject large allocation when THP_SWAP is disabled,
> -		 * the caller should split the folio and try again.
> +		 * Reject large allocation when THP_SWAP is disabled. Check below
> +		 * whether splitting and retrying can make progress.
>  		 */
> -		if (!IS_ENABLED(CONFIG_THP_SWAP))
> -			return -EAGAIN;
> +		if (!IS_ENABLED(CONFIG_THP_SWAP)) {
> +			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
> +			goto failed;
> +		}
>  
>  		/*
>  		 * Allocation size should never exceed cluster size
> @@ -1759,7 +1764,8 @@ int folio_alloc_swap(struct folio *folio)
>  		 */
>  		if (size > SWAPFILE_CLUSTER) {
>  			VM_WARN_ON_ONCE(1);
> -			return -EINVAL;
> +			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
> +			goto failed;
>  		}
>  	}
>  
> @@ -1775,13 +1781,23 @@ int folio_alloc_swap(struct folio *folio)
>  	}
>  
>  	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
> -	if (unlikely(mem_cgroup_try_charge_swap(folio)))
> +	if (unlikely(mem_cgroup_try_charge_swap(folio, &swap_margin))) {
>  		swap_cache_del_folio(folio);
> +		return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
> +	}
>  
>  	if (unlikely(!folio_test_swapcache(folio)))
> -		return -ENOMEM;
> +		goto failed;
>  
>  	return 0;
> +
> +failed:
> +	if (get_nr_swap_pages() <= 0)
> +		return -ENOSPC;
> +	if (swap_margin <= 0)
> +		return -ENOMEM;
> +
> +	return order ? -E2BIG : -ENOMEM;
>  }

How do you think if we apply this on top of this? (Not tested)
Should be no behavior change but outside the existing races, the margin
read moves from charge time to failure classification time, a small
TOCTOU, which the original also has but in a different way.

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7d6216c8b830..dcf01d4c5e1b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -490,13 +490,12 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin);
-static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-					     long *swap_margin)
+int __mem_cgroup_try_charge_swap(struct folio *folio);
+static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio, swap_margin);
+	return __mem_cgroup_try_charge_swap(folio);
 }
 
 extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages);
@@ -511,8 +510,7 @@ long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
-static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-					     long *swap_margin)
+static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b4c65ccf3538..d89054dd96a8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5650,13 +5650,12 @@ int __init mem_cgroup_init(void)
 /**
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
- * @swap_margin: remaining memcg swap margin if allocation or charge fails
  *
  * Try to charge @folio's memcg for the swap space at folio->swap.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)
+int __mem_cgroup_try_charge_swap(struct folio *folio)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct swap_cluster_info *ci;
@@ -5675,7 +5674,6 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	if (!folio_test_swapcache(folio)) {
-		*swap_margin = page_counter_margin(&memcg->swap);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
 		return 0;
@@ -5689,7 +5687,6 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		*swap_margin = page_counter_margin(counter);
 		mem_cgroup_private_id_put(memcg, nr_pages);
 		return -ENOMEM;
 	}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5d8d04576c13..09760985b911 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1756,7 +1756,6 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
-	long swap_margin = PAGE_COUNTER_MAX;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1766,10 +1765,8 @@ int folio_alloc_swap(struct folio *folio)
 		 * Reject large allocation when THP_SWAP is disabled. Check below
 		 * whether splitting and retrying can make progress.
 		 */
-		if (!IS_ENABLED(CONFIG_THP_SWAP)) {
-			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
+		if (!IS_ENABLED(CONFIG_THP_SWAP))
 			goto failed;
-		}
 
 		/*
 		 * Allocation size should never exceed cluster size
@@ -1777,7 +1774,6 @@ int folio_alloc_swap(struct folio *folio)
 		 */
 		if (size > SWAPFILE_CLUSTER) {
 			VM_WARN_ON_ONCE(1);
-			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
 			goto failed;
 		}
 	}
@@ -1794,10 +1790,8 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio, &swap_margin))) {
+	if (unlikely(mem_cgroup_try_charge_swap(folio)))
 		swap_cache_del_folio(folio);
-		return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
-	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
 		goto failed;
@@ -1807,7 +1801,7 @@ int folio_alloc_swap(struct folio *folio)
 failed:
 	if (get_nr_swap_pages() <= 0)
 		return -ENOSPC;
-	if (swap_margin <= 0)
+	if (mem_cgroup_get_folio_swap_margin(folio) <= 0)
 		return -ENOMEM;
 
 	return order ? -E2BIG : -ENOMEM;

