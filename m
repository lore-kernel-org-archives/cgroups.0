Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D483C3F71
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 10:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787047396; cv=none; b=kYCfXudKjsKVV6Z6+sStNmdfg89vWTJ666A6JF3Ij8uMQ2bLXo8pypd9+LcT9x4io5wRLqggGm+MHfjVIR22SCdCc2HDGbzn5GyGyvnKqtsLpKAWtakZW9ezv4v78dX4PRidajfVPG2gpRRURSNlH7IgegcrPPVNhOreSJowPpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787047396; c=relaxed/simple;
	bh=BvmaXazGKW5MZujZ8tTzbOk2WnfCXozE0UgtGky7/6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cLrVkU62ufiWQvVBAFtvvw0i2t5W/51tKzRKOPbI+uhlCgwVHxA61qQQB9GsMTkp6nEeLN+l1yx0yaAqZ0W/OtvHez04+CGz/2I3BouGW1CMOLAL4vcXwZP2/XMCX3U1Nvq4TMjrhY7NXamh8cmKJ3hxJ/GWvWCmTyaD0sSsGzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L4CqqfzF; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L4CqqfzF"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4998e0916faso24833105e9.2
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 03:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787047389; x=1787652189; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BTSEVb32olrehgQ8+kMO9r1tytqXhQqOIt2PkeskveQ=;
        b=L4CqqfzF20ocJSB8PMQKafWEdTt/NqV6uMingimvrvSCj5QPgdFsP5jHfksPSYSmwy
         +YBXg5naCecliuizrv8nXfsSw2vA9amnJPlVEKI4KzSmqQ7xB/ixie5OvjMwWJdI9yOt
         KBPI4h5K2NU7hUnZXvfI/POFl/U9MFtjUqHNehf3FiBrXzDtT1QeVvBRgy0BKLzj6r0z
         V9NELbLHAs5JCfdoKxgDP4Cfl96B5i2f2sdUMKESImTPcB1cXYjOUb4VCW3Rv9yGGf5C
         fo1/MWCrXhTuZ8Uxnr4AIUOFkLTiEaP93AKzKYcBcCfhCMBEM3Ej9iHPIvKfvi2OS18X
         n5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787047389; x=1787652189;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BTSEVb32olrehgQ8+kMO9r1tytqXhQqOIt2PkeskveQ=;
        b=s/osViJ6jSqihMa0fxveP5zeMrwMYu5nVYvUznDW2azrVp4PImObb62zRseiVr+A2O
         FTUjrt2BrzdvaIRQyiMRHuIF8lmZYegC8nrR/k+P3ilRh42YP5yBRdBlYVe/K2aAoPbO
         MsghzRxgBWHYwYGmfa0jKBaLsvTe9WnhJ7arZszb1jS6YSdOfUIDBun+L1V3/skt4PUE
         UDF9cSUr9zfZOcTXiM+FeauQd4nsRHDYatMOBC+BWkZElJDc1vus8xlnnUfgM3tzJAy6
         9S0mlz0uqfoRawqbtRZC3Ug5+oiZlKaPWWgQQj+Tcu0jM7fZrP3GhYXSa/B4udmYcqc8
         qQbA==
X-Forwarded-Encrypted: i=1; AHgh+RolBWt6LUhSYO9fzCairBhlRjs3km6HPpLG/B+HZx4WDjdoJNoncYQvjn3pFo6iGnAK+K050VcK@vger.kernel.org
X-Gm-Message-State: AOJu0Yyft6AmkxOtB7UgHA/R/dgXuCMeImc8ee7fd9yiSRa8hkmRtvO4
	c4hTM/UTre2bSerPB1kebftcVNbrUp0apDYQwn4XGrYelqwpyaXHKT+KAXKEwm1Vyvw=
X-Gm-Gg: AR+sD12/IcZGMufr1IfDwx71mu8prMRpMWSLH6uu+rtEcliSzEzcvTDrwP/e1JkJa1h
	GrGfb1AfcVqWYtoGvLE1hPSEBIUBqjNquhsS2zx5c199mgWOeDgXnL4DzuGt+D8f57gIi8g+yoz
	ja22zVlZDW4DtwlI6ilwOe6earF/QMCArbR6R5VE1ViUICg2StlCdMDnmlQO1VoCCW/7L+g+KUN
	OKtZkWYiiTYqnSqSpMcEurnzAuP++On/c+IMNmqosPDLqrMGpSAhr1pcaeFpqnMxCDJ4n/pko8G
	IJWvEo7PL+VA26AWzd88it/7Zur7OUGnWr056m1Lg4ltgKzHKw8sLHUm5812oqBVrfJGah7nWeD
	+yOi4ljJbbYYCmzKx+o0mE60jFEyei2e1TLdIgL2ARySk9fAGHtQc76LRwOK6H1eikf79EOlW9Y
	oMrF9QLkhSSfqJQVpTwL7n94UPgIYKCcsfpuGYldLg51uSu282Nt0jRsGl7v54B+a3+BFAO0H3D
	Q==
X-Received: by 2002:a05:600c:1d0e:b0:495:7888:281c with SMTP id 5b1f17b1804b1-499878cd5bcmr458829475e9.0.1787047389481;
        Tue, 18 Aug 2026 03:03:09 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499906aaf1dsm213884115e9.4.2026.08.18.03.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 03:03:09 -0700 (PDT)
Date: Tue, 18 Aug 2026 12:03:07 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <joyxiong@yahoo.com>
Subject: Re: [PATCH] memcg: trim the per-cpu charge stock instead of draining
 it
Message-ID: <aoQt2zKsQT-rvjd6@tiehlicka>
References: <20260817234651.666540-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817234651.666540-1-shakeel.butt@linux.dev>

On Mon 17-08-26 16:46:51, Shakeel Butt wrote:
> Joy reported that an application generating a request/response traffic
> pattern spends 44.6% to 57.0% of CPU in the memcg charge/uncharge path
> for a range of message sizes, against 0.27% to 0.71% outside that range.
> Running from the root memcg, where socket memory accounting is skipped,
> recovers the performance.
> 
> Tracing the charge path showed that the application generates a pattern
> where the write syscall charges one page and the read syscall uncharges
> two pages on the same CPU. This hits a corner case in the memcg percpu
> stock code that thrashes the stock continuously.
> 
> In the memcg percpu stock code, MEMCG_CHARGE_BATCH (64) is both the high
> watermark and the emptying target, i.e. on a request to charge one page
> the kernel charges MEMCG_CHARGE_BATCH pages and caches
> (MEMCG_CHARGE_BATCH - 1) of them in the percpu stock. The following
> uncharge of 2 pages takes the cached count to (MEMCG_CHARGE_BATCH + 1),
> and refill_stock() then empties the cache completely. With such a
> pattern the percpu stock becomes completely ineffective.
> 
> Instead of a single boundary point for charges, use the technique the
> page allocator uses for its own percpu caches, which keeps the watermark
> and the emptying target apart: nr_pcp_free() frees between batch and
> high - batch pages, leaving at least pcp->batch on the list. Add a high
> watermark MEMCG_STOCK_HIGH and, once the cached count goes over it,
> return only the pages above MEMCG_STOCK_LOW. The watermarks are
> MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a full
> batch. Peak cached pages per memcg grows from 64 to 96, the same
> high-versus-batch tradeoff the page allocator makes.

The idea is sound. I would just not increase the overall stock size in
the same patch. Fine tuning can be done independently and ideally with
some numbers.
Would it make sense to start with MEMCG_STOCK_HIGH := MEMCG_CHARGE_BATCH 
and  MEMCG_CHARGE_BATCH := MEMCG_CHARGE_BATCH / 2. That would preserve
the maximum stock size while preventing all or nothing behavior which is
indeed suboptimal and pushing charging path to a slower path way too
aggressively.

WDYT?

> Reported-by: Joy Chaoyue Xiong <joyxiong@yahoo.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/memcontrol.c | 31 +++++++++++++++++++++++++------
>  1 file changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..ff7fbcd27422 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2048,6 +2048,21 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
>   * nr_pages in a single cacheline. This may change in future.
>   */
>  #define NR_MEMCG_STOCK 7
> +
> +/*
> + * Watermarks for a charge stock slot, in the spirit of pcp->high and
> + * pcp->batch: MEMCG_STOCK_HIGH is the high watermark at which a slot is
> + * trimmed, and it is trimmed down to MEMCG_STOCK_LOW rather than emptied.
> + *
> + * Using MEMCG_CHARGE_BATCH as both high watermark and emptying target
> + * thrashes: charging one page stocks 63, an uncharge of 2 takes the count
> + * to 65 and empties the slot, and the next charge misses. The watermarks
> + * are MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a
> + * full batch.
> + */
> +#define MEMCG_STOCK_LOW		(MEMCG_CHARGE_BATCH / 2)
> +#define MEMCG_STOCK_HIGH	(MEMCG_STOCK_LOW + MEMCG_CHARGE_BATCH)
> +
>  #define FLUSHING_CACHED_CHARGE	0
>  struct memcg_stock_pcp {
>  	local_trylock_t lock;
> @@ -2223,17 +2238,18 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  {
>  	struct memcg_stock_pcp *stock;
>  	struct mem_cgroup *cached;
> -	uint8_t stock_pages;
> +	unsigned int stock_pages;
>  	bool success = false;
>  	int empty_slot = -1;
>  	int i;
>  
>  	/*
> -	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
> -	 * decide to increase it more than 127 then we will need more careful
> -	 * handling of nr_pages[] in struct memcg_stock_pcp.
> +	 * nr_pages[] is a uint8_t and a slot's count is capped at
> +	 * MEMCG_STOCK_HIGH. Raising MEMCG_CHARGE_BATCH beyond 127 would need
> +	 * more careful handling of nr_pages[] in struct memcg_stock_pcp.
>  	 */
>  	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
> +	BUILD_BUG_ON(MEMCG_STOCK_HIGH > U8_MAX);
>  
>  	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
>  
> @@ -2254,9 +2270,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  			empty_slot = i;
>  		if (memcg == READ_ONCE(stock->cached[i])) {
>  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> +			if (stock_pages > MEMCG_STOCK_HIGH) {
> +				memcg_uncharge(memcg,
> +					       stock_pages - MEMCG_STOCK_LOW);
> +				stock_pages = MEMCG_STOCK_LOW;
> +			}
>  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> -			if (stock_pages > MEMCG_CHARGE_BATCH)
> -				drain_stock(stock, i);
>  			success = true;
>  			break;
>  		}
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
