Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FC22777F3
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 09:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786094280; cv=none; b=dG8DSQc0sWVpSj/JH8tWFu3Sl+SAty+wpY1HX3JI3RaNtCWOUmnWkWPjAJqIzfgLshHtHYJ3ndREwPBWs8/0G6izFHa3AivLb5MYxL1iYKInDYNnEbr2Ii4G1Y/fWb8sghNWopEGImNcEq6y8UyRdQI5K3M56xO951oU1kx6QB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786094280; c=relaxed/simple;
	bh=0jD4KHxVATkkmMsT7BYrQsvJq/oa5s1lcY02ZrRrurk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SKUrfLGf61WI2SCEdkwVInWOvUZ/LlYgRxGVZR0A+jv9PV5EvNRdeJe+dAVQ/pVKiOq7IX2l/VK7k4QuWSuBhx3Sm9KdJJ/QLJI1gZ0sp5Z63iH/+zb/5ee9QyvkBdvKR+czrEd5xawgcQH3KOy4McmYXnju4QlYEe6IN3T0O1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WuwdbVzI; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WuwdbVzI"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-496b7622a83so26355125e9.2
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 02:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786094277; x=1786699077; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nE9EpAT+paxZNLOvuqRoG+/4E3IKgvzJcMoz26cdk1M=;
        b=WuwdbVzIj4jmWAaKuPundeJ0K0xTMNcEvgzr1VDopEvwJ9K6pMjnFl8EMFZqYR4l7o
         cc69/PuZMtykAt6If5nSUZ/Sizeyu05ePJebf16lwOPy/bTOBpPLwdhn7rz2i0P2Nzyo
         fGUy1vVLFwlFDPGADoAL2Mix80VYp/YNbwuSfYTe7X+YEK3fxc4uzeY9BrGZSIcY3c0E
         /RLYIXmCf2Yt9Z+eOfJXxgfF3VMqTm49caf8z/QkyHxRK74q548kmTIaEiU3LG92mi1e
         7fxHZ/DtMJsirK1Sv0MxMWWUjDBs2I9FOJEsH5nIXraj8NggRoAGnwnNOoocFrMjH3ZI
         4M/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786094277; x=1786699077;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nE9EpAT+paxZNLOvuqRoG+/4E3IKgvzJcMoz26cdk1M=;
        b=b5WJFpcVqIIq6pzvhNrSKxVdIur1W5lUt4/dACDta4vSINA3jBPRkxTZ1hvPn8sKXg
         Imig2+y3AaVO06nI/UmgkpNSlmnvVLbkspZiLe1mxzU0nfdWdSKqtsLW6nI3d+fCokTC
         WFpx7GqigX27SiZCoafAcqtBzPGXQExBj9d+qBYAeQimE1pPT07JO98lx1hY0ySWzMiV
         lJUxSZixs0eLBWcf2JBZxOusAzfSx1Z3Ob6g1LNpMYrMGQ467fScOm7VulRMfYg6m+bX
         yi8Oz8kyloWUcoLUVmK68tDiaG+iN/Hxf8kRcKCMrzHY6d4icN1VN0ta+8bJzwM0Qedm
         8vfw==
X-Forwarded-Encrypted: i=1; AHgh+RqlsR9Tf2P+CQDYYEzXUGXbjYFXUsdEmyVCi+F3TRwbW4tMnHYdgtsUI6AXBqyOue6OrHAhhRJu@vger.kernel.org
X-Gm-Message-State: AOJu0YzU9FCGxqwREZPrNFKwhL6QELQXB2D+5NSTBdaH7JGoHf4NC9z9
	Wf31+5c2uQ3WJRLEmF813RSh/4nbxvdbJbfKHvwTdZhzfHXRX8O1lhpsvkPZA/Afeys=
X-Gm-Gg: AR+sD10x3fGpnME5Ub6VJzJ7zvtmiofk95f6Vf38Ia9ruk7+yhSo7aTdYY/6zp1rI84
	cevxFa3Wh/2+D41ikhPXUhizeyj4yZNK/eRd5ocSOae67XSbNagh5MicR/zfLhay1ioFzcj8Zl4
	ru4W58OpwUuROlSp4okDuebERp5L3ddEFJN/JOOwBJfwe5fuG8kQwf7QttSiX/bDZ7NokOwbsd7
	K/xbrmNKC7vGeykaVyWCPdV/otiXLXM4ignZEt9t4U4RXBAY/rSQhGrM1i4byBiP7RJ8UhpSyT0
	i7STnvko0duwShkCOdqQr13Gaa6KxFZ7sYcf2uXJ1Pc0xzUa67Ef8p9jLnHw0kqavAG1uL3xSO6
	2Ri8pWuQsps3d82nWDGcczII9MvSbNB2EmpTUlSVWUfIjG80vfZRl14GxutRx7ALYcpG9+VAubU
	0df8t/ibupNIUeM6oIGkFM7OSnnAPBYabP9qnH2uEalkgJpwOBMR6ZuUcAhNd+/g7zM6VFvlO0+
	Oc=
X-Received: by 2002:a05:600c:3586:b0:499:49f3:77b1 with SMTP id 5b1f17b1804b1-4994e728283mr284725245e9.3.1786094276825;
        Fri, 07 Aug 2026 02:17:56 -0700 (PDT)
Received: from localhost (109-81-83-166.rct.o2.cz. [109.81.83.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4800215078asm3937193f8f.12.2026.08.07.02.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 02:17:56 -0700 (PDT)
Date: Fri, 7 Aug 2026 11:17:55 +0200
From: Michal Hocko <mhocko@suse.com>
To: Audra Mitchell <audra@redhat.com>
Cc: david@kernel.org, jocolema@redhat.com, raquini@redhat.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anWiw0Zb66jyhzBU@tiehlicka>
References: <20260806182429.1841095-1-audra@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806182429.1841095-1-audra@redhat.com>

On Thu 06-08-26 14:24:28, Audra Mitchell wrote:
> Originally nr_retries was actually nr_oom_retries and we used it to track (and
> limit) the number of times we entered the mem_cgroup_oom path and then attempted
> a retry. The purpose of nr_retries counter changed with the introduction of
> 9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
> charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
> to retry within the desired nr_retries threshold. Later d977aa939fca
> ("mm, memcg: unify reclaim retry limits with page allocator") changed the
> nr_retries counter from 5 to 16.
> 
> As the function has evolved we now have multiple paths that have a goto retry
> path and we have lost the original purpose of the nr_retries counter, allowing
> us to take a goto retry path an unbounded number of times.
> 
> Fix the unbounded retries by nesting the code in a loop and decrementing the
> nr_retries counter correctly.

Are you trying to fix a theoretical problem spotted by the code review
or is there any actual problem that you are trying to fix?

> 
> Signed-off-by: Audra Mitchell <audra@redhat.com>
> ---
>  mm/memcontrol.c | 153 ++++++++++++++++++++++++------------------------
>  1 file changed, 76 insertions(+), 77 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..781bcced5848 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2607,98 +2607,97 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	unsigned long pflags;
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
>  
> -retry:
> -	if (consume_stock(memcg, nr_pages))
> -		return 0;
> +	for (; nr_retries >= 0; nr_retries--) {
>  
> -	if (!allow_spinning)
> -		/* Avoid the refill and flush of the older stock */
> -		batch = nr_pages;
> +		if (consume_stock(memcg, nr_pages))
> +			return 0;
>  
> -	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> -	if (!do_memsw_account() ||
> -	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
> -		if (page_counter_try_charge(&memcg->memory, batch, &counter))
> -			goto done_restock;
> -		if (do_memsw_account())
> -			page_counter_uncharge(&memcg->memsw, batch);
> -		mem_over_limit = mem_cgroup_from_counter(counter, memory);
> -	} else {
> -		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
> -		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
> -	}
> +		if (!allow_spinning)
> +			/* Avoid the refill and flush of the older stock */
> +			batch = nr_pages;
>  
> -	if (batch > nr_pages) {
> -		batch = nr_pages;
> -		goto retry;
> -	}
> +		reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> +		if (!do_memsw_account() ||
> +		    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
> +			if (page_counter_try_charge(&memcg->memory, batch, &counter))
> +				goto done_restock;
> +			if (do_memsw_account())
> +				page_counter_uncharge(&memcg->memsw, batch);
> +			mem_over_limit = mem_cgroup_from_counter(counter, memory);
> +		} else {
> +			mem_over_limit = mem_cgroup_from_counter(counter, memsw);
> +			reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
> +		}
>  
> -	/*
> -	 * Prevent unbounded recursion when reclaim operations need to
> -	 * allocate memory. This might exceed the limits temporarily,
> -	 * but we prefer facilitating memory reclaim and getting back
> -	 * under the limit over triggering OOM kills in these cases.
> -	 */
> -	if (unlikely(current->flags & PF_MEMALLOC))
> -		goto force;
> +		if (batch > nr_pages) {
> +			batch = nr_pages;
> +			continue;
> +		}
>  
> -	if (unlikely(task_in_memcg_oom(current)))
> -		goto nomem;
> +		/*
> +		 * Prevent unbounded recursion when reclaim operations need to
> +		 * allocate memory. This might exceed the limits temporarily,
> +		 * but we prefer facilitating memory reclaim and getting back
> +		 * under the limit over triggering OOM kills in these cases.
> +		 */
> +		if (unlikely(current->flags & PF_MEMALLOC))
> +			goto force;
>  
> -	if (!gfpflags_allow_blocking(gfp_mask))
> -		goto nomem;
> +		if (unlikely(task_in_memcg_oom(current)))
> +			goto nomem;
>  
> -	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -	raised_max_event = true;
> +		if (!gfpflags_allow_blocking(gfp_mask))
> +			goto nomem;
>  
> -	psi_memstall_enter(&pflags);
> -	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> -						    gfp_mask, reclaim_options, NULL);
> -	psi_memstall_leave(&pflags);
> +		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> +		raised_max_event = true;
>  
> -	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
> -		goto retry;
> +		psi_memstall_enter(&pflags);
> +		nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> +						    gfp_mask, reclaim_options, NULL);
> +		psi_memstall_leave(&pflags);
>  
> -	if (!drained) {
> -		drain_all_stock(mem_over_limit);
> -		drained = true;
> -		goto retry;
> -	}
> +		if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
> +			continue;
>  
> -	if (gfp_mask & __GFP_NORETRY)
> -		goto nomem;
> -	/*
> -	 * Even though the limit is exceeded at this point, reclaim
> -	 * may have been able to free some pages.  Retry the charge
> -	 * before killing the task.
> -	 *
> -	 * Only for regular pages, though: huge pages are rather
> -	 * unlikely to succeed so close to the limit, and we fall back
> -	 * to regular pages anyway in case of failure.
> -	 */
> -	if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
> -		goto retry;
> +		if (!drained) {
> +			drain_all_stock(mem_over_limit);
> +			drained = true;
> +			continue;
> +		}
>  
> -	if (nr_retries--)
> -		goto retry;
> +		if (gfp_mask & __GFP_NORETRY)
> +			goto nomem;
> +		/*
> +		 * Even though the limit is exceeded at this point, reclaim
> +		 * may have been able to free some pages.  Retry the charge
> +		 * before killing the task.
> +		 *
> +		 * Only for regular pages, though: huge pages are rather
> +		 * unlikely to succeed so close to the limit, and we fall back
> +		 * to regular pages anyway in case of failure.
> +		 */
> +		if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
> +			continue;
>  
> -	if (gfp_mask & __GFP_RETRY_MAYFAIL)
> -		goto nomem;
> +		if (gfp_mask & __GFP_RETRY_MAYFAIL)
> +			goto nomem;
>  
> -	/* Avoid endless loop for tasks bypassed by the oom killer */
> -	if (passed_oom && task_is_dying())
> -		goto nomem;
> +		/* Avoid endless loop for tasks bypassed by the oom killer */
> +		if (passed_oom && task_is_dying())
> +			goto nomem;
>  
> -	/*
> -	 * keep retrying as long as the memcg oom killer is able to make
> -	 * a forward progress or bypass the charge if the oom killer
> -	 * couldn't make any progress.
> -	 */
> -	if (mem_cgroup_oom(mem_over_limit, gfp_mask,
> -			   get_order(nr_pages * PAGE_SIZE))) {
> -		passed_oom = true;
> -		nr_retries = MAX_RECLAIM_RETRIES;
> -		goto retry;
> +		/*
> +		 * keep retrying as long as the memcg oom killer is able to make
> +		 * a forward progress or bypass the charge if the oom killer
> +		 * couldn't make any progress.
> +		 */
> +		if (mem_cgroup_oom(mem_over_limit, gfp_mask,
> +				   get_order(nr_pages * PAGE_SIZE))) {
> +			passed_oom = true;
> +			nr_retries = MAX_RECLAIM_RETRIES;
> +			continue;
> +		}
>  	}
>  nomem:
>  	/*
> -- 
> 2.52.0
> 

-- 
Michal Hocko
SUSE Labs
