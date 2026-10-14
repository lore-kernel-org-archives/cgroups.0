Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5051E4F85D4
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 11:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791977373; cv=none; b=tOf2NkrGZqdDlYePGt5suet3yTPnwjZXP1CeE8/JIVGV3jM2GvaovE2Qb1gmtfb3Dzs17B9qEiqfOU+ejAPY0yF2aEisjhljcqzM4luoWLRybsrmYendias3borFpSEtPAcFAh602Ricd/FDbaYyBaIjgagcEu85nQJZT4cPEyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791977373; c=relaxed/simple;
	bh=YpV3kIY5S6v6UC44zd65beMg+D2qpgiKncmpegZ5KUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fr63s/saigXaeY7M/SvnhekNvBDL9SjmCzsndXIwm1OwyYoW2eYQcSYoS2deAy3aWm70hCYNkGlq+oSgK1VCAfDJ8Q+vWmyEeMKsKEo928uMuiTcWdJCILD6jcRHEzgwgY459NBKu2rK2dAhp7Uf4piT1PW2p73y8IJwEZySfkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ThkaMFa1; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ThkaMFa1"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a022fee0caso37364315e9.1
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 04:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791977369; x=1792582169; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u0ksxRT6rJjcKFpO4Cy8B4p8cW2Dk868nlYmS4mFCYs=;
        b=ThkaMFa13nf5M+QU0CHRkgM3tNj/i2miJhM3gSe+x+d6KxhHMK6UWXngyhc0KSRjxG
         aRTozIZE8qgLYCziPptp6GARLd/kAo3jHOLj0izmkyhWEDCWWCUP2+uQuhoJBspHf6MC
         6T7Hl26Hi0i7qh8kaTffAV/uSmm7244p6lpxXLgu362xM0WIGJJdcJ+OXtp1EfHZRQak
         obNZhVglaLXi/DnWGsDFVjve46K/bE8IVFKaMVLLG1QxhQLlCi5yKS3c6V/FHEEghKxt
         ZthoXExx0Prv+l48+XTAIG6ZOWEI1j9DJqq/hX/5/puCMyGwoOB8fPwv81D3DR7CHiWL
         Jq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791977369; x=1792582169;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u0ksxRT6rJjcKFpO4Cy8B4p8cW2Dk868nlYmS4mFCYs=;
        b=iI7RVABw8PWtNsS3aVGi1Gmqyoo79CIrlIgo4/ZlPrMoH250InJL3xOJHEr49hZZVC
         2EFdF6zn0FRhgyKCvcG5tt0tFuMVdXg963R3boSSfkSRzc2vIbmW+eIWfnT6eXmRmktx
         9GuLJYnlD7c0Q757Zc7NW6+5L6GIuFU77C4ly7d8ZLSyMf2E/hRoSa4zFVXixD+9uzoR
         iWMEjwtDvYgWb5e8bvUBMvKw0GYIen7q4wTQBP9BrFVOOWYiPDy7wquiFY3C8fpAyFCp
         EMiXE3PBvcRWyYxSEZHd4qLd2y/PL9m37FH6N6pqnjx7QEMjsZKu5PgI+oRpaQHRdAHb
         N8Mw==
X-Forwarded-Encrypted: i=1; AKwUvBxkpIcnQtw+xsOHBynVppzPtFYWRo+tz/Ycjjsl9xm16XSs5gc3f/rqiu1PIgIPZqSLVVj4vqnZ@vger.kernel.org
X-Gm-Message-State: AFq9FYKUE4pVOBJh3aH56ONDf5YPFTaKFnoDmBWmaC1DtF/PBMxvNb42
	h5KxUIE7UZkzNrdkQbqHY9+spHEoyTcHxDB5iG+RAX8UyWth/wUZd4r16WJc7P5yWho=
X-Gm-Gg: AYBFou0P2MIcj2CzkYun5b08Z/gxK/8PYkHI0eq908iqsuqD5logoXwleKDKo/d1LUc
	C2W/BGBhCYnpC7yagfcNmgYIS/qayEhc5uM6GagTPMkTkzLebBZwFTj2SYFGN5osWhlns6pvZVY
	l2laKhMIuXdjYKSdRVTdZSD4r+fwtgRvl/N96GP398efwBcWabE9pUk+7DStDNNRq6YTO6xjpUL
	uP2buS8cetFsp7xB+1qYBHNxJVErUpo3pqoQX8JeGXOXxGpuylafiRAwNeJ+fLUtDMcNAUQOAT2
	eyUdEb7dknzAnkHPficqc8QYyWY8BvwoFJqK/N3Y5RKF6sZByBaA8eMJIL5AbF4X/3njRJvLuyL
	mc6znGV6ER623mNzNnJboL4mUjA0iasXuPkPkFQvafRepxOEhAVZULCDUczcTkDrO74EAM764Y0
	b3gJ1+0KrUcVIeWDG/p/CbMDNUYT415ZyMFartI0UeR1jQUiBQunHq8SBNYBeT04zYjSd8kF3sF
	styRaoB5kGo
X-Received: by 2002:a05:600c:4594:b0:49d:1fa8:b266 with SMTP id 5b1f17b1804b1-4a18e4d6ac3mr305650505e9.26.1791977369510;
        Wed, 14 Oct 2026 04:29:29 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf214a1sm499703195e9.7.2026.10.14.04.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:29:28 -0700 (PDT)
Date: Wed, 14 Oct 2026 13:29:26 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 3/5] memcg: use high_work for remote charges
Message-ID: <as9nlkBxzFZSLd5K@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-4-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-4-shakeel.butt@linux.dev>

On Sat 10-10-26 14:09:55, Shakeel Butt wrote:
> Some charges go to a cgroup outside the current mm's cgroup and its
> ancestors. The high handler uses current->mm, so it cannot handle these
> overages. Filesystem notifications and remote page faults can take
> this path.

Hmm, you made me look at other places in the charge path where we are
assuming current->memcg == memcg. We have reclaim recursion and oom
checks. The former makes sense, for the latter it is likely not
harmful.

> Use mm_match_cgroup() before checking the high limits. If it does not
> match, use high_work instead of recording task overage or doing
> synchronous reclaim and throttling. Charges to the same cgroup or an
> ancestor keep their current handling. Tasks without an mm also use the
> worker.
> 
> Like kernel threads, remote chargers skip memory.swap.high throttling
> and its high-event reporting, and a fast allocator can outrun the worker.
> The memory.max and memory.swap.max checks stay the same.

Makes sense.

> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8116fce6ab96..3456960cbe68 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2705,7 +2705,8 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  			       gfp_t gfp_mask)
>  {
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> -	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
> +	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
> +		!current->mm || !mm_match_cgroup(current->mm, memcg);
>  
>  	/*
>  	 * If the hierarchy is above the normal consumption range, schedule
> @@ -2728,6 +2729,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  		 * Don't make an unrelated interrupted task handle this charge.
>  		 * Kernel threads may be working for other tasks, so let a worker
>  		 * reclaim instead.
> +		 * Remote charges need reclaim from their charged hierarchy.
>  		 */
>  		if (use_worker) {
>  			if (mem_high) {
> @@ -2756,7 +2758,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  		}
>  	} while ((memcg = parent_mem_cgroup(memcg)));
>  
> -	/* Interrupts and kernel threads stop here. */
> +	/* Interrupts, kernel threads, and remote chargers stop here. */
>  	if (use_worker)
>  		return;
>  
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
