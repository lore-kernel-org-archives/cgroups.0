Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1862024A047;
	Mon, 17 Aug 2026 03:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786936555; cv=none; b=rwnhPWJYpibEdnDWlV/Y9EdS4fUNdwEgUBwp9rUV0CZxV0edwQ1Qt3gPDE19HUlxrNWA6XhFFRv2lvBswn6K94wVTj3OAMRkoRbSiV5bgLJUAYhXgDhheNoTaulAkwU50W0QfUSCf4a4usYjmZkgTsyd5Fl7B5rYVCw4PA9I5DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786936555; c=relaxed/simple;
	bh=KLDRcTmwwDnV0sQO4mLtHw+bF96AJ98+/MQSef1dIlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r0cYDOWHFATMivwi17IsPlMluBGV1JOHDk/a0WkV5rXqEIQNdGGQw3JyTOWRVhVW3Zm/5zctF0g85YX3MySolkA+V313H2oDcXsgMjDgLalnmoH7ItL0ioWPp/iHeEloelUK75qcB9aDR26N22Nve/+xwwTwMzNr8QBgPn90jfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DZL+GvNE; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DZL+GvNE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mP/kw3LMX/NnG5kUH90aD438amd9t1MOlcI7a9rTuLY=; b=DZL+GvNEdhD9zaGDTf3tLSh+AS
	G//kFXPnun4Jx3eSwfguz93Zm3HZcH4+j2cdQ6mJct9apx28h+4EoTsVhg9gX+kjE6+BlmwBAJzqs
	cvgpLvni5tRZZgZv7H/1u5120PX+12EujCPQoebEw7/bTGcu2AbpeUAZwj3UyIY7CI0iVpKkkNasW
	RHrwWduslxmQn3VFO7qMG8pw/bztKxGiYOI7Mfg26C5/NAM2EQAkjVexANHwz7VTIfBrQOfneH/82
	MTOhp+ST1s4CSm7gIiVVvjs/0nNn6HjY+5JdelRmbCOY2mxWf0lcIcKfJobavqtff8G8XKDvQlN9d
	crHsFBDg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wvnp8-00000009PbM-0xVL;
	Mon, 17 Aug 2026 03:15:42 +0000
Date: Mon, 17 Aug 2026 04:15:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhuhui@kylinos.cn, joshua.hahnjy@gmail.com,
	audra@redhat.com, bingfangguo@tencent.com
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
Message-ID: <aoJ83tk7R1x3Jul-@casper.infradead.org>
References: <20260817025917.66233-1-husong@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817025917.66233-1-husong@kylinos.cn>

On Mon, Aug 17, 2026 at 10:59:17AM +0800, Song Hu wrote:
> refill_stock() takes a css reference for each cached memcg slot and
> mem_cgroup_css_offline() relies on drain_all_stock() to release those
> references before the cgroup can finish dying.
> 
> consume_stock() can drive a slot's nr_pages to zero while its cached[]
> pointer stays set.  is_memcg_drain_needed() skips such empty slots, so
> the offlining drain is a no-op for them: the pinned css reference is
> released only if the slot happens to be evicted by later unrelated
> charges on the same CPU, or by CPU hotplug.  The memcg then lingers
> in the dying state indefinitely.  On a CPU with container churn, a
> per-cpu stock can pin up to NR_MEMCG_STOCK (7) zombie memcgs.
> 
> The sibling obj_stock_flush_required() has no such gate: a cached
> objcgs slot is flushed regardless of its byte count.  Drop the
> nr_pages gate from is_memcg_drain_needed() accordingly.  Draining an
> empty slot is a single css_put() and a NULL store, and it happens at
> most once per slot per drain, so the extra work is negligible.
> 
> This is easily reproduced with short-lived cgroups pinned to one CPU:
> 12 charge/exit/rmdir cycles leave nr_dying_subsys_memory at +2, stable
> across later slot displacement.
> 
> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  mm/memcontrol.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..b931ec16bb82 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2291,8 +2291,12 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>  		if (!memcg)
>  			continue;
>  
> -		if (READ_ONCE(stock->nr_pages[i]) &&
> -		    mem_cgroup_is_descendant(memcg, root_memcg)) {
> +		/*
> +		 * An empty slot still pins a css reference which
> +		 * mem_cgroup_css_offline() relies on drain_all_stock()
> +		 * to release.
> +		 */

I don't think the comment adds any value.  It explains why something
_isn't_ there which makes no sense to someone reading the code.

> +		if (mem_cgroup_is_descendant(memcg, root_memcg)) {
>  			flush = true;
>  			break;
>  		}
> -- 
> 2.43.0
> 
> 
