Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2473A3A6B9D
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 01:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787965484; cv=none; b=IR2I5t+shyg5do0axr3OOB+QUQyvktdZVAn+X8lKg19DFD57iLHe0fR0xZ0Py0XeYoU8OMmMyPU45gntQmdUAm/JXAgQ/wtoEWLWzMcKciXVZHF9n4A04x1YkNwND2n/np/KTh9C4PHAN2CB67A/o0yUQM9KlbtUyVG33x9a18Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787965484; c=relaxed/simple;
	bh=kFVnj/RCyVGdhv/GrLJjxqmvHwAXJnYM9xkltOMPrqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ps6Qt8vJ3CnM2dPuQBLrKSW6isllExIb+3PKJV5ke5N5xjcKryrES2OrNB1IwQnC4ioNrB3RHyZm57ufMS7NuwQdrxfZSh3Xa70qz/F3gWJx7zKsiHaPQ7dEo5hsBVgvNuYUmZyPWAix7g/uN9OQu5YZjJHMNWVd60iNgsLCIfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TTcxGMFW; arc=none smtp.client-ip=91.218.175.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TTcxGMFW"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kFVnj/RCyVGdhv/GrLJjxqmvHwAXJnYM9xkltOMPrqc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787965478; v=1; x=1788570278;
 b=TTcxGMFWoEsBiY1ov6+AULkzfP5/X/1wHWOBMu8dlEFvJ5REThzhY3wALQRrUmkBF1BaAZeH
 4cFaHcLmcV5NtG6hOqpxz4Om++qEdMBzHwwhtSvu/uCiFDCT6m5IDy5YqTU17QlK/H1rxYWSSyC
 1MCLwCoqV6lrgKNGEbY62zvs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 171c61ff73f22124;
	Sat, 29 Aug 2026 01:04:38 +0000
X-Mizu-Trace-ID: 171c61ff73f22124
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 18:04:37 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joe Damato <joe@dama.to>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: raise MEMCG_MAX for charges that fail
 without reclaiming
Message-ID: <apIvUej_7wvcDUjg@linux.dev>
References: <20260827233119.411152-1-joe@dama.to>
 <apDPJzlJ4gS9YUDX@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apDPJzlJ4gS9YUDX@linux.dev>

On Thu, Aug 27, 2026 at 05:13:44PM -0700, Shakeel Butt wrote:
> On Thu, Aug 27, 2026 at 04:31:18PM -0700, Joe Damato wrote:
> > Charges that exceed memory.max and return through the nomem label can
> > raise no event and simply return -ENOMEM.
> > 
> > A non-blocking charge can hit the limit, get rejected, but is not
> > visible in memory.events.
> > 
> > This was noticed in a production setting where bpf_mem_alloc() attempted
> > to refill its per-cpu freelists, which triggered a non-blocking charge
> > while at the limit.
> > 
> > Move the event so that it is raised as soon as the charge is known not
> > to fit.
> > 
> > Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Signed-off-by: Joe Damato <joe@dama.to>
> > ---
> >  mm/memcontrol.c | 15 +++++----------
> >  1 file changed, 5 insertions(+), 10 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1271d390b617..3904fe9a7b2e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2683,6 +2683,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  		goto retry;
> >  	}
> >  
> > +	if (!raised_max_event) {
> > +		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> > +		raised_max_event = true;
> > +	}
> > +
> >  	/*
> >  	 * Prevent unbounded recursion when reclaim operations need to
> >  	 * allocate memory. This might exceed the limits temporarily,
> > @@ -2711,9 +2716,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
> >  		goto nomem;
> >  
> > -	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> > -	raised_max_event = true;
> 
> I just noticed that this will change the current behavior where we keep
> increasing MAX counter while charge request loops through reclaim and retry.
> Though we have not documented that behavior, so not sure if it is worth
> preserving. It does help identify cases where a request keep looping in the
> charge/reclaim/retry path.
> 
> Let's see what others say. Keeping the behavior should not be that hard if we
> decide to keep it. Something like below (untested):
> 

Hi Joe, let's go with the following patch. No need to change the semantics. Also
I think we should Cc stable as getting ENOMEM/allocation-failures without the
corresponding counter i.e. MAX getting increased is clearly a bug and unexpected
to the users and will make debugging/monitoring harder.

> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..6bfa4ad30b24 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2656,10 +2656,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool raised_max_event = false;
>  	unsigned long pflags;
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> +	int ret = 0;
>  
>  retry:
>  	if (consume_stock(memcg, nr_pages))
> -		return 0;
> +		return ret;
>  
>  	if (!allow_spinning)
>  		/* Avoid the refill and flush of the older stock */
> @@ -2770,16 +2771,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 * put the burden of reclaim on regular allocation requests
>  	 * and let these go through as privileged allocations.
>  	 */
> -	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
> -		return -ENOMEM;
> +	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH))) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
>  force:
> -	/*
> -	 * If the allocation has to be enforced, don't forget to raise
> -	 * a MEMCG_MAX event.
> -	 */
> -	if (!raised_max_event)
> -		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -
>  	/*
>  	 * The allocation either can't fail or will lead to more memory
>  	 * being freed very soon.  Allow memory usage go over the limit
> @@ -2789,7 +2785,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (do_memsw_account())
>  		page_counter_charge(&memcg->memsw, nr_pages);
>  
> -	return 0;
> +out:
> +	/*
> +	 * Don't forget to raise a MEMCG_MAX event for forced or rejected requests.
> +	 */
> +	if (!raised_max_event)
> +		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> +
> +	return ret;
>  
>  done_restock:
>  	if (batch > nr_pages)
> @@ -2848,7 +2852,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	    !(current->flags & PF_MEMALLOC) &&
>  	    gfpflags_allow_blocking(gfp_mask))
>  		__mem_cgroup_handle_over_high(gfp_mask);
> -	return 0;
> +	return ret;
>  }
>  
>  static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  
> 
