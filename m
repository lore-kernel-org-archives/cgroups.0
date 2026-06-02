Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AF037DE84;
	Tue,  2 Jun 2026 20:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780432629; cv=none; b=dd3O6dnIbaHgl6WB0wYAo9zHRGUHjULpiLceDzcrT0/BfpLsx8/hKapsP5kf/B3HZSgD1fKr6QHWnJw5wp5ierqcszjARvAAeLjFHkkrXsOXnq3lEPqvhH9kpBn/z53pzd3To7kGI0wBHg0B52NFNsKFYQ5auCJglC4ti22IxdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780432629; c=relaxed/simple;
	bh=O1rAUejDHDgfdnLQmGGCPXUd52eBDWEuCSfY1iQbmjc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=B3AfDg1PqT41ixHsTZI5p4GQKraBsN84Tmc9X0kUcJ0OmWVAtt7Hyy538QitK6IozEjGrAamBKpIB63pB/ba+vDOBO6pQWuiGa8IseamIXocywJvT+3JCXWxrP1oS/10ufC3sAmf/9BMnAf2qwN13O53Q/axxQFYQq/wZxtJsSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=syh/dB1E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="syh/dB1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152EB1F00893;
	Tue,  2 Jun 2026 20:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780432627;
	bh=+i6QVlrk9KIwFEZhpsKIC890QBmDvw0SsLedgmaGYs4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=syh/dB1EW+9SWFgHZbUvo/EUL4RkLrCLodacuueVZmydHJsnt91C8Iw4O01J/tcJ1
	 yp+YEy/RYVdEnLv1TC3ckLEQpOKlgNf8WjYIVSlvgaeKES+5ITABh6XGCz5sBgmo1p
	 K7V4uTlNEL7gKItw1AKMDTl5LEmtliP6m7TSpWRg=
Date: Tue, 2 Jun 2026 13:37:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, ljs@kernel.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, david@fromorbit.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, qi.zheng@linux.dev, yosry.ahmed@linux.dev,
 ziy@nvidia.com, liam@infradead.org, usama.arif@linux.dev, kas@kernel.org,
 vbabka@kernel.org, ryncsn@gmail.com, zaslonko@linux.ibm.com,
 gor@linux.ibm.com, wangkefeng.wang@huawei.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 npache@redhat.com, ryan.roberts@arm.com, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Johannes Weiner
 <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when
 queues drain
Message-Id: <20260602133706.d737a82858d1cf89870521b1@linux-foundation.org>
In-Reply-To: <20260602043453.67597-1-lance.yang@linux.dev>
References: <20260602043453.67597-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  2 Jun 2026 12:34:53 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> From: Lance Yang <lance.yang@linux.dev>
> 
> deferred_split_count() returns the raw list_lru count. When the per-memcg,
> per-node list is empty, that count is 0.
> 
> That skips scanning, but it does not tell memcg reclaim that the shrinker
> is empty. shrink_slab_memcg() only clears the memcg shrinker bit when the
> count callback reports SHRINK_EMPTY.
> 
> Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
> cleared once the queue has drained.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/huge_memory.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 72f6caf0fec6..62d598290c3b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4397,7 +4397,10 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  static unsigned long deferred_split_count(struct shrinker *shrink,
>  		struct shrink_control *sc)
>  {
> -	return list_lru_shrink_count(&deferred_split_lru, sc);
> +	unsigned long count;
> +
> +	count = list_lru_shrink_count(&deferred_split_lru, sc);
> +	return count ?: SHRINK_EMPTY;
>  }
>  
>  static bool thp_underused(struct folio *folio)

Should this be handled as a fix against hannes's "mm: switch deferred
split shrinker to list_lru"?
