Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7004F449EB2
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 11:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791976422; cv=none; b=OM8UJlwS5dJUBhc0nRk+DJ/1Sh9HiTJOYkKXh4jf+8IJtg4jHYxiFSZB/bVVNlrpbk4++0ykJicGqBS8k/Z7m8s+2HiS8RLsBvStRbNclonNwc1kumsuxseT/gaXZ8ksXshuPBg06YifKRqaJaSAYFqPQvjTCfVsLcqqPOi/O+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791976422; c=relaxed/simple;
	bh=eFjYtNXcvVYkY04diiIB+AwUoE0aJwOhOqjIMm950cA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fEuEbDmuBxzCagLdtWuGF1iFX+pjM0IHrWfbclGNpyOZjXHk5cH8D4ZbKxe0ICv0AZ4m76E6fUEYEH6WAE097VMsqB36RLYsw02Ugm1/v7wzGt9EIw6M4cQi2LBQtwn79JbDmYJL7AB45ymifQNm8Wym9EQo0Jdtie1Ry7m0cUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GTJZ/cIq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GTJZ/cIq"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a1ad2e2391so12659745e9.0
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 04:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791976419; x=1792581219; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NXlUIURbYu6APktqXqLBKzg8bDGva6jksAa9GUaz5Wg=;
        b=GTJZ/cIqFIoOpw3SsxQt4FpeEnq9yOaAwqRuGvTKEh+tmx9u3RkN3vR5LlUipr5YQ9
         SV3aVOemX6y7BlK4x0o13fiCjHTmgmW5ITjV4sWVCRny36ttCqg93jB4eDI4eoHXYFeo
         Ku4wY8b9H+XqiYihjva6FKyXAIG0sBgRqELl8VfepDHAxSdGGqBp+cEWYUWfL8OhaUTh
         n0MRrO7giut0B0xIIHFHExiIJ6K/G4muQOXri2VQzgERYgzD1DEmvaBD65lHKWye4z69
         +PcLTh76M6M70IE1WHYYZYLbgaSxcpBqyj9vt/ADCNjv50g1em+yo+4O4+LR6kgjLDo+
         rWYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791976419; x=1792581219;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NXlUIURbYu6APktqXqLBKzg8bDGva6jksAa9GUaz5Wg=;
        b=oniiwKi8lKc01+Tt/uNTW+yQ2ZrcSDWzEd5yFqtMoBV8Tl36wTY32XeOZ855MPzdpx
         CPllh/wlnGim/YrGZtTdznZ/Hx9cs0mha8NC4zQyrjpbTBtqJZzl70YMWYj2Ub25MeOt
         /Bu3aGv1tkXkXm/pZ00W5kGSCsbJ5iS+9ayJKPUOCnpz0QJ8OtsF8YQzrFpMvrfBC737
         f97Xt5hdXtW2FQm9VTLSPgQh5Nrm3gF1+USsQQwViTGK97OMiBPHgC4bgdin9iWkECJ5
         BYVI9AGpPgHBjrxLMrd4aXASoJ3h7o7B/dQ1biFtnRhWZtOLpfCI6xZYIymUHSUGmlTL
         cA6Q==
X-Forwarded-Encrypted: i=1; AKwUvBzewovw57q6LIK7gThMt7wZMs5wy3uTPt7v+D61RRMvwsk+F6RCnOj3Cn1c6JjTcicvf2BeoXQq@vger.kernel.org
X-Gm-Message-State: AFq9FYJjMp9rCX+LNdVU7hzx89u5Uba1Krou3RykmvaQzQvRUoCKcr+f
	mR/qVzPhVNrAJxZ4C4YWk0GElkhyPt0msmB3EgaYEvkSuE6ICEVYz81JgYtwktaGi5o=
X-Gm-Gg: AYBFou2CkH5ra+FrFYaO5/j/XAwZR1++g/vdeERFK2U7hmi1co1ROsJVp+sOFribNqU
	uUeZJbt/PolKbgw560y8qJmoZHqFdEMEqT/DYIrC9w9Cw+S7YhxZQBrkE/lnrj+0MOdBkBoub6f
	Of/yClQxRWFmNaMuZvWgr9theoTjUm45iRY1PD8stKv12GK7WSc6mSpciGBBPtJ1t1ihZSJksoW
	e7/fABpTh8bivigwWXhiQddL4rjxo+m+XCgQ5xI5z057qYx/jhVBADqxeDEQqo1C/q3kR8/amTx
	4emQmIyre+LVF+zT3zCTm0m2E2W/f0phrIcqlu5+L5KggH1AiaAKXVDIImZDkCd6mok3dyUNpoI
	wWamq32ni2WXwPBu597qH4mbxs2MWH08Yvc4DTDt6fAZBGYv7GJKBDI8P78gMAuez1xnAF0bL6f
	+06KXKVeHiQWXN8l78JmqmXU8cjNHnlCdD8WIg1Yp1xraZuajvHunOq+jmmFd1t+ZvnmWHPRfZZ
	P/At5J7dMdg
X-Received: by 2002:a05:600c:4ecd:b0:4a1:96cd:2f60 with SMTP id 5b1f17b1804b1-4a19ecf4c20mr181213675e9.3.1791976417794;
        Wed, 14 Oct 2026 04:13:37 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b3615f2esm43732895e9.1.2026.10.14.04.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:13:37 -0700 (PDT)
Date: Wed, 14 Oct 2026 13:13:34 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 1/5] memcg: move memory.high enforcement out of
 try_charge_memcg()
Message-ID: <as9j3rH3qRtFO0-7@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-2-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-2-shakeel.butt@linux.dev>

On Sat 10-10-26 14:09:53, Shakeel Butt wrote:
> try_charge_memcg() does a lot. It charges the page counters, reclaims
> when a limit is hit, may call the OOM killer, and at the end it checks
> and enforces memory.high. Move the memory.high part into a new function,
> memcg_enforce_high(), so that try_charge_memcg() is shorter and the
> memory.high code is easier to read and change.
> 
> The code and its comments move as they are. The only difference is that
> the new function gets allow_spinning from gfp_mask itself.
> 
> No functional change.

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol.c | 125 ++++++++++++++++++++++++++----------------------
>  1 file changed, 69 insertions(+), 56 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aad0498a7bd6..20c5dfe1a894 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2696,6 +2696,74 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
>  	css_put(&memcg->css);
>  }
>  
> +/*
> + * Called after @nr_pages were charged to @memcg. If @memcg or one of its
> + * ancestors is over memory.high or memory.swap.high, start reclaim or slow
> + * down the task.
> + */
> +static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
> +			       gfp_t gfp_mask)
> +{
> +	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> +
> +	/*
> +	 * If the hierarchy is above the normal consumption range, schedule
> +	 * reclaim on returning to userland.  We can perform reclaim here
> +	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
> +	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
> +	 * not recorded as it most likely matches current's and won't
> +	 * change in the meantime.  As high limit is checked again before
> +	 * reclaim, the cost of mismatch is negligible.
> +	 */
> +	do {
> +		bool mem_high, swap_high;
> +
> +		mem_high = page_counter_read(&memcg->memory) >
> +			READ_ONCE(memcg->memory.high);
> +		swap_high = page_counter_read(&memcg->swap) >
> +			READ_ONCE(memcg->swap.high);
> +
> +		/* Don't bother a random interrupted task */
> +		if (!in_task()) {
> +			if (mem_high) {
> +				if (allow_spinning)
> +					schedule_work(&memcg->high_work);
> +				else
> +					irq_work_queue(&memcg->high_irq_work);
> +				break;
> +			}
> +			continue;
> +		}
> +
> +		if (mem_high || swap_high) {
> +			/*
> +			 * The allocating tasks in this cgroup will need to do
> +			 * reclaim or be throttled to prevent further growth
> +			 * of the memory or swap footprints.
> +			 *
> +			 * Target some best-effort fairness between the tasks,
> +			 * and distribute reclaim work and delay penalties
> +			 * based on how much each task is actually allocating.
> +			 */
> +			current->memcg_nr_pages_over_high += nr_pages;
> +			set_notify_resume(current);
> +			break;
> +		}
> +	} while ((memcg = parent_mem_cgroup(memcg)));
> +
> +	/*
> +	 * Reclaim is set up above to be called from the userland
> +	 * return path. But also attempt synchronous reclaim to avoid
> +	 * excessive overrun while the task is still inside the
> +	 * kernel. If this is successful, the return path will see it
> +	 * when it rechecks the overage and simply bail out.
> +	 */
> +	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> +	    !(current->flags & PF_MEMALLOC) &&
> +	    gfpflags_allow_blocking(gfp_mask))
> +		__mem_cgroup_handle_over_high(gfp_mask);
> +}
> +
>  static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  			    unsigned int nr_pages)
>  {
> @@ -2853,62 +2921,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (batch > nr_pages)
>  		refill_stock(memcg, batch - nr_pages);
>  
> -	/*
> -	 * If the hierarchy is above the normal consumption range, schedule
> -	 * reclaim on returning to userland.  We can perform reclaim here
> -	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
> -	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
> -	 * not recorded as it most likely matches current's and won't
> -	 * change in the meantime.  As high limit is checked again before
> -	 * reclaim, the cost of mismatch is negligible.
> -	 */
> -	do {
> -		bool mem_high, swap_high;
> -
> -		mem_high = page_counter_read(&memcg->memory) >
> -			READ_ONCE(memcg->memory.high);
> -		swap_high = page_counter_read(&memcg->swap) >
> -			READ_ONCE(memcg->swap.high);
> -
> -		/* Don't bother a random interrupted task */
> -		if (!in_task()) {
> -			if (mem_high) {
> -				if (allow_spinning)
> -					schedule_work(&memcg->high_work);
> -				else
> -					irq_work_queue(&memcg->high_irq_work);
> -				break;
> -			}
> -			continue;
> -		}
> -
> -		if (mem_high || swap_high) {
> -			/*
> -			 * The allocating tasks in this cgroup will need to do
> -			 * reclaim or be throttled to prevent further growth
> -			 * of the memory or swap footprints.
> -			 *
> -			 * Target some best-effort fairness between the tasks,
> -			 * and distribute reclaim work and delay penalties
> -			 * based on how much each task is actually allocating.
> -			 */
> -			current->memcg_nr_pages_over_high += batch;
> -			set_notify_resume(current);
> -			break;
> -		}
> -	} while ((memcg = parent_mem_cgroup(memcg)));
> -
> -	/*
> -	 * Reclaim is set up above to be called from the userland
> -	 * return path. But also attempt synchronous reclaim to avoid
> -	 * excessive overrun while the task is still inside the
> -	 * kernel. If this is successful, the return path will see it
> -	 * when it rechecks the overage and simply bail out.
> -	 */
> -	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> -	    !(current->flags & PF_MEMALLOC) &&
> -	    gfpflags_allow_blocking(gfp_mask))
> -		__mem_cgroup_handle_over_high(gfp_mask);
> +	memcg_enforce_high(memcg, batch, gfp_mask);
>  	return ret;
>  }
>  
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
