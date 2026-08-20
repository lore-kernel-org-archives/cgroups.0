Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1473B0AFB
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 07:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787209583; cv=none; b=lSyb+d3W4PWLxP8K/3Skz0aRTXPWuxTrQ41FP9JALvCVqRcGhwdA6/8ADJa19MTJ73AwaFxV+e5OedYbe7pimm1QKLG8e7kBceBVAw7/jBzMB+sP8RHlrUg/KzRCJPoDArfLxhRP/sDqak4dXldf+//sGXp4/gdsVgH1+cX91VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787209583; c=relaxed/simple;
	bh=YvyJzAKdQooEr8VSbKYEVbBo6GxZ2g3Vl9/TJT+Fzu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kVyaR1h1makEtCEu8KBRmojW9orRHCtJqG1/B6uea6aGG0cdppde1vCNfP9UtyzjOheslnu3BmScmn2Qhm4itGnRV+PHuv5Oex/fgYvAolv62bRBcqCSMnwpRBsxocmcisQfNeCZ3mQfBspniCdrkEfhkAv+pwR+ZZ1Zdra6Ops=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a0UobtDW; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a0UobtDW"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-499acf0fb55so10346705e9.3
        for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 00:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787209580; x=1787814380; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OSJ5BKrVQsiwQ6NExnR9GYYYXRVPl3OFkAnmP+WvLQE=;
        b=a0UobtDWNeBv/jR0DK6sgYrAGKitly/vwGhRvVcym3EG56I6suqaZfREYs45RnOvUo
         MC3JIuvAoW00SFxUg94ZIhJ+KgxiypPk3Hn2eyUq50cZmzxpGOirM0hs/1F7Cm7qNP7Q
         GvmV/VsCpPBrvtwoU6PrYYjRHWfffy206QoU6ITrTHZOdlSRCrJPsPLezwVg4mo3vVM0
         7DwhapFM7+XtfmfSGZ50Rw2mkm+NQGn6jqJXmunArio7YOobA0bsFmUdByHR2F9MwAUV
         fcU1dbzuEKElcIWZIlxtyXspNSkQ4oLVrBXaCjOMLJdwBCNqc6EGEO+ZkDurf7v4i6I1
         3LYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787209580; x=1787814380;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OSJ5BKrVQsiwQ6NExnR9GYYYXRVPl3OFkAnmP+WvLQE=;
        b=eqCHj3H2UFDac36xzfSZQ+0C5M8ZWClSV/vg6WG0npZQZ3noWYF+3wLfovJK2w8XP9
         xmvE4kJzDXNFkp8jM9N3r+ObpqYhbuzN9gwW/5jaYcAEqM4Ao+tQM018XrV+dbwE4cRf
         V5Bm3SNymR57j47jcCQ3Ni1u6Xlu8SVgQbLMAEecqltemcqaFj4eWZWIiWEN60CxVu3Q
         OzQH6F+81omOrqBd5j0SpQ1JFSQxEw0nSGmMzx9LisFhZ+MuwGghbF3OhWUNUJsYIYSw
         wmastLm9iEh0dVodj4iFfEfUTJ1dbwhPLq5jdJ5qi3EBOp01JXXPMtlcm2eM1RL/KKy+
         8whA==
X-Forwarded-Encrypted: i=1; AHgh+RqLKI/43eqjlEu2lJYLeTQIAVcSGsm/Xr4Tz/SQnCcF1D+OyWIgGynuuuNHUqyBLTdY3ERLeVmL@vger.kernel.org
X-Gm-Message-State: AOJu0YzdkR08H6YBFul/vftmwCIXzjqAbEAlwP7Nf3TOK6JlD8bKFERR
	JlxvPMxCf48LPEBQdAb3lXD939otF0raCUPG2oLTEFuWuEkHrtE0d0fYuxhYtuo0Cjk=
X-Gm-Gg: AR+sD12XqU0PaV4G31hBRgJP1R+NDcs4U2L1Ss8b3WIvqZl4HiUr8AscopaBdfCIEia
	RPVwEjiuljMvlb99ZTEq8JwzrQN8APQf+a+VYYeDBu0F4vNz/4lVFp2rhxfPfK89Tq1THjYL4rD
	uXhTC5ZYJkTNJB5ZnR2j9rmiFZYOJ++vbyjMbhq3/3xxeaPLhqPwopjtBhF4/f5ZKbE9JSRVzOa
	wd5+oNWcN7rudX1aXxxsAo+2Z77k+m+yOBeCOmBPCSS3CG6JGno2Rtn6x/nXaYRMxgSa97AQ/E8
	fpRGdCNOrE1Oujj2VeIpNUFkUL4KWdehT6H/UfkK3Lra5mfKiSV6jaIb+iS+KcT+7GiVIMa5NWF
	3HohqG8rY5yGgmTm+bN9WbS0x8m9X0x4zZ7Q2GbVRQVBBDy1KJmstb5ZKUUozTaLve+iJUpZTMn
	gsjUZtxw8ZCbePxwSa1yFW+WQ8fdEZcutPFUl94uaym1D9lsD/ZtBbM3Nx4QwLycwcfvjPsrZve
	y+6BdTNjz44
X-Received: by 2002:a05:600c:6211:b0:499:a760:722f with SMTP id 5b1f17b1804b1-499aa1ba0b7mr188614485e9.13.1787209579825;
        Thu, 20 Aug 2026 00:06:19 -0700 (PDT)
Received: from localhost (109-81-21-108.rct.o2.cz. [109.81.21.108])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499b3c556a3sm10815435e9.3.2026.08.20.00.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 00:06:19 -0700 (PDT)
Date: Thu, 20 Aug 2026 09:06:18 +0200
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
	Joy Chaoyue Xiong <cxiong@meta.com>
Subject: Re: [PATCH v2] memcg: trim the per-cpu charge stock instead of
 draining it
Message-ID: <aoanalsTiGmL69LN@tiehlicka>
References: <20260820012010.2016086-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820012010.2016086-1-shakeel.butt@linux.dev>

On Wed 19-08-26 18:20:10, Shakeel Butt wrote:
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
> batch.
> 
> For now, keep MEMCG_STOCK_HIGH same as MEMCG_CHARGE_BATCH and in
> future we will reevaluate if it makes sense to increase it.
> 
> Reported-by: Joy Chaoyue Xiong <cxiong@meta.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
One minor nit

> ---
> 
> Changes since v1:
> http://lore.kernel.org/20260817234651.666540-1-shakeel.butt@linux.dev
> - Kept the upper limit of memcg stock same as before (Michal)
> 
>  mm/memcontrol.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..58e4d23cf5e0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[...]
> @@ -2254,9 +2264,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  			empty_slot = i;
>  		if (memcg == READ_ONCE(stock->cached[i])) {
>  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> +			if (stock_pages > MEMCG_STOCK_HIGH) {
> +				memcg_uncharge(memcg,
> +					       stock_pages - MEMCG_STOCK_LOW);
> +				stock_pages = MEMCG_STOCK_LOW;

I would find it easier to read to keep the update in sync with
memcg_uncharge, i.e.
				stock_pages = WRITE_ONCE(stock_pages - MEMCG_STOCK_LOW)
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
