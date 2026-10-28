Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793182809;
	b=pRpra5SVGv+Aa8l1tZFo5RY7L/sdKe9nvjDUKlbDTbSwou5SxyieSejrjfPwBiDxwi7a
	 ih2ASn7lAYl6jo/2TVB2ZpLkLJYqJOtmed9kjRxnF32i4LHUIaE/te51HuUjZ3aGCsntD
	 Jqj8ZFK3EhGPpHcilAEXcNZxfVlwQWNGY01SZLGTxgclWk0tc+gecaH50w5wxraFlRiyH
	 2UERd77LtJX2PX0wWJnSqB5sqt0sCB1WegIzZjY3c5nqykkioNW/pctPLJbS1YYO86za2
	 akz88Yp4xIFIMSoBZ+tQuKslDkYaqA1LliWQJlA+ZiptOfhw0kOcGl4vIF+8nPjZi8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793182809;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=dGZCyoP3FE5bGQl/UeXjVk9zpz6msuuXm/vv60rRm4I=;
	b=uiTyJY5uOojRGClJ1ACLyArvLYnd8bmU/1iP3rtzlIfRWSmZkstewUfnBAcl/SCI8znw
	 Wg1i1auC5EJTjdKZiXuucENfojJAQ6CMgcimX0iaOF7nxa3r5vpOAo5qq3mocei6Xm2XG
	 ueD2iu4sbF1brqX/sbbEvUnBslH3U3RmGwtoAfbNyK7gohXulrWbe2aNJ9uvKCeSnOI6s
	 nDCK+izAt6ueEEvnivgp5A/6xaM6/sWVoPnjovLvKRUnEcLwy5Fbnn6TnuMUnWmcqlDq6
	 YcCXlOLu38coMCKQhlOttlY99wNVAfV77DgNawM1e0qsLvr2f2htd3J+Brhwsw7BG/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dWcHrvte;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF9B606A31A
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 10:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CF9B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dWcHrvte
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so457650a12.3
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 03:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793182807; x=1793787607; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dGZCyoP3FE5bGQl/UeXjVk9zpz6msuuXm/vv60rRm4I=;
        b=dWcHrvteUV6fqSrgLHZGGgWHgv5flB+rwm5mHSPV55q92QuDMbOeetVnwNBDZrJiXz
         Q/TJlnvUtxyUcpneB1ZpJno7rDZCuRphCYnUGsBl5OiyD2hFAumBXV3K6zMly5/vOboq
         Xdq4jXlL0/vkmK3FSWuOSHhrJk6V0asWkaWaaV/3ghFSAzqOIQdzHytGoFfIbIDU7wwk
         Vfhj+8YglSHSZO3uBC9ZC7loDrFuAyJwvc20V32u7W+VOw0x3J0cjyzAAx40KC3KrbAL
         0afdvf6xDeF0jWDS1Ni01N4daYDF/9u4qeSqfBHEz/DwjgMVrUpqt4AvXmNUqSOlmugO
         y+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793182807; x=1793787607;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dGZCyoP3FE5bGQl/UeXjVk9zpz6msuuXm/vv60rRm4I=;
        b=T2Li/ShSuhd/ufmVrheFp4/5NfoDgjCK9jZxErLE1C76r0nIiHVIZjXl6Mle+QjFas
         oXMfxYXtB6GJ0tMMq8wZq/D6WqpExt+YnioTrfbKpB69bJj3Ncz3ZBoiYSz/mNqi2CXH
         FCCsKGJXEk0xDzf2nCCTNaUmw0CBdCXQIQ75CI0t5aweEPqvWOGvD0v1Hc8LjrnGVdZy
         Es9UxXfBX946p/5JaOevgnsFRO9wMjVAarXYw9SS9pmuyeupJ8AKN4ERzwiq4fkb6xiA
         SIY81CsSqepR0JNjskEuQzrJAw1huN1V98QPVANjGTczAPxWql5PGaukYWDaB+EWDIOp
         eepg==
X-Forwarded-Encrypted: i=1; AKwUvBwS4WlNwKXeTgb6ELeZC4SCax/Xm3LnWYF5qdQ8egT262MUE2HhmqqfpTZKvBrMXFos+YIVWOxg@vger.kernel.org
X-Gm-Message-State: AFq9FYIBz+CAw31azBia1jouTrozGpiRiFnZnBPFJoHkgHrftiy8TMsM
	lCc59wdwb4pkRYZkVRYdBPwWxWgJW4w4Tdz0wwSJ7FS7D+gSHXtJ0Sr2
X-Gm-Gg: AYBFou0N9PlP8xh91uR8ENclHXJqMBtLk+jLT5/+FqMr36zOuIcLU92jAN0wI2MvUnu
	sQVOQYUXdTzWf4gAKajJue2nDWGzN92LhvKsVNvkYhF1dnQ3BhzaCUChylCEvYE0qvC3cKLYXjW
	t7dPDsCEr+dngMgSn8yWNS+7+qAGNp5AxeFEPoN6MATEMLmX+T5RpYimZPuVpusQHOgxKY/J5FJ
	lAVIEJ7fJO3d0rHqeykPE0yW1sbHa/WRBl9xH+k6dfgG6AEH/zJIqJjmHgTLrF+uPpt3TP1TcP3
	1x9J8go4lacxQhqtb+vSq0L4hoQIAW/yLW68aDXg8ovz+KfeXwlw1smRgCPFTGEDQKEwp5SPBCc
	e3KYL9S027IItSjjCy/MyIwkJQhzlzDStxWZMus+m9NH8QvXAmjzv1jPZo6yWYigD+Sb85ZVrWi
	1ncidqjGk+VHElux/Lvsft7z/nO3SYurGMEqSX9VIxsbLlpKeGPm8cgCf8/Ln1H59OOMWea9LjY
	EmxuHe/qR8voWULDQqytFxdV+KnOnj08m5KfDgayTaxLibIyfQJhgFOWO96YSfRvEIx/Ldr8So5
	W2Tn/YnY0e99XEdKNSlGhhUP6xiDpc4+iLebMyFr1dzvZUHpjR0+dSnRsLW0LBbwp3GYw52rPsU
	=
X-Received: by 2002:a17:90a:fd92:b0:3a0:d265:3647 with SMTP id 98e67ed59e1d1-3ae57e357e5mr882344a91.8.1793182807428;
        Wed, 28 Oct 2026 03:20:07 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a9a5e73sm2400905a91.10.2026.10.28.03.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 03:20:06 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:19:59 +0800
From: Kairui Song <ryncsn@gmail.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online()
 checks
Message-ID: <auHLzLazLr4iA_Pn@KASONG-MC4>
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-2-tjmercier@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028010611.3929937-2-tjmercier@google.com>

On Tue, Oct 27, 2026 at 06:06:05PM +0800, T.J. Mercier wrote:
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> move LRU size accounting on reparenting instead of copying it"),
> mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> afterwards. A folio that is off the LRU during reparenting looks up its
> lruvec through its objcg, which now points to the parent so it is put
> back on the parent's LRU.
> 
> As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> when !mem_cgroup_online(memcg) is true, making the offlined memcg special
> cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> code. Remove them.
> 
> With the get_nr_to_scan() special case removed, an offlined memcg that
> still has stale effective protection now has
> apply_proportional_protection() applied like get_scan_count() does, so
> the MGLRU and traditional LRU behavior is now the same.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---
>  include/linux/mmzone.h |  8 ++++----
>  mm/vmscan.c            | 28 +++++-----------------------
>  2 files changed, 9 insertions(+), 27 deletions(-)

Nice!

> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 3b96d6c7123b..7f078ff0dd76 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -638,10 +638,10 @@ struct lru_gen_mm_walk {
>   * The events that trigger the above operations are:
>   * 1. The first attempt to reclaim a memcg below low, which triggers
>   *    MEMCG_LRU_TAIL;
> - * 2. The first attempt to reclaim a memcg offlined or below reclaimable size
> - *    threshold, which triggers MEMCG_LRU_TAIL;
> - * 3. The second attempt to reclaim a memcg offlined or below reclaimable size
> - *    threshold, which triggers MEMCG_LRU_YOUNG;
> + * 2. The first attempt to reclaim a memcg below reclaimable size threshold,
> + *    which triggers MEMCG_LRU_TAIL;
> + * 3. The second attempt to reclaim a memcg below reclaimable size threshold,
> + *    which triggers MEMCG_LRU_YOUNG;
>   * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
>   * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
>   * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce8..636152d8c94d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2754,13 +2754,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  		scan = apply_proportional_protection(memcg, sc, lruvec_size);
>  		scan >>= sc->priority;
>  
> -		/*
> -		 * If the cgroup's already been deleted, make sure to
> -		 * scrape out the remaining cache.
> -		 */
> -		if (!scan && !mem_cgroup_online(memcg))
> -			scan = min(lruvec_size, SWAP_CLUSTER_MAX);
> -
>  		switch (scan_balance) {
>  		case SCAN_EQUAL:
>  			/* Scan lists relative to size */
> @@ -2769,14 +2762,8 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  			/*
>  			 * Scan types proportional to swappiness and
>  			 * their relative recent reclaim efficiency.
> -			 * Make sure we don't miss the last page on
> -			 * the offlined memory cgroups because of a
> -			 * round-off error.
>  			 */
> -			scan = mem_cgroup_online(memcg) ?
> -			       div64_u64(scan * fraction[file], denominator) :
> -			       DIV64_U64_ROUND_UP(scan * fraction[file],
> -						  denominator);
> +			scan = div64_u64(scan * fraction[file], denominator);
>  			break;
>  		case SCAN_FILE:
>  		case SCAN_ANON:
> @@ -4355,12 +4342,11 @@ static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
>  {
>  	unsigned long total;
>  	int swappiness = get_swappiness(lruvec, sc);
> -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  
>  	total = lruvec_evictable_size(lruvec, swappiness);
>  
>  	/* whether the size is big enough to be helpful */
> -	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
> +	return total >> sc->priority;
>  }
>  
>  static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc,
> @@ -5199,10 +5185,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
>  
>  	evictable = lruvec_evictable_size(lruvec, swappiness);
>  
> -	/* try to scrape all its memory if this memcg was deleted */
> -	if (!mem_cgroup_online(memcg))
> -		return evictable;
> -
>  	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
>  	nr_to_scan >>= sc->priority;
>  
> @@ -5325,13 +5307,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  
>  	flush_reclaim_state(sc);
>  
> -	if (need_rotate && mem_cgroup_online(memcg))
> +	if (need_rotate)
>  		return MEMCG_LRU_YOUNG;
>  
> -	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
> +	if (lruvec_is_sizable(lruvec, sc))
>  		return 0;
>  
> -	/* one retry if offlined or too small */
> +	/* one retry if too small */
>  	return READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL ?
>  	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
>  }

This part looks much cleaner, thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>
