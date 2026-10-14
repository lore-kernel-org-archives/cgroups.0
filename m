Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BDF42E41D
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 11:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791977953; cv=none; b=MXzdy714PI/l3sDsm6mzE6rPzYFitWW4jES00VQnyqeB+jUl0Rl9SBYAm06z7IV9GE9K1niQ8fm/27v8Rf2q3JHtjQd9wsb/noAtfc5lJscvpgJZYXqAyRcBFCsKVToS+bMCfO2qosubAQzoewoCs0Z/y8VwD0C9ohms6n10DpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791977953; c=relaxed/simple;
	bh=v66k7iNvhOgZZTT++OurcOdJPuTUGSAEJGHO2y8M3rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kb4ZwJ6qqw7Y5d0FRvgpHWec+HL59l8y78WtXNHCRHtpSHaEEejozw0egLeFGO69bcGkUhnIUekCG6VEj2dfvEpmkgH8LWQvCc4pTyZFha3Jofr0ABRF+3aOclmcqBDDMJUg22Znl5REQCKgoSOdqtIXBgJAh6PZlK07iENrUrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZFbDqiVr; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZFbDqiVr"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1af482519so13445785e9.1
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 04:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791977950; x=1792582750; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QUzFoE445IVWsVK4aBCZAsC064TGifdEV4i8h8KnmvQ=;
        b=ZFbDqiVrdoFOhF7+lehlmI4rhXfwZnXs86x4qAFaCL95+wm7mW6JJ2q9Eg8w/DM8he
         DGi3Z4NLRvoD9okbad5c5b/88pXgKEdbyL2/4zlF3ASv+k55lC68Iq6fWGO+MlxcM4Co
         n5UnlP+DEAr5rG03aTgPNflUp4EChUo3MVLwnVIXpYv62fJqowAzy8JPWen51uGVweVZ
         TtnHiVMG7stT9/IrsyKv5Cd4MCZtVyJ80Rx0HFi+EkVrooG+YXql1YIvVIblsLxqPRZc
         wpqBzGcrC1r8CJ73drJoTKdrAvtq9Kr2nLT3pEhdxwzKKkToF0WWJnLd98FYrNqXidlq
         9hCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791977950; x=1792582750;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QUzFoE445IVWsVK4aBCZAsC064TGifdEV4i8h8KnmvQ=;
        b=C1jYhDD6kJ/Aa52hXsb6mTFydNiZcjvrjti4Da1HfY6pOlV8Qvr/021ckRzSc23S99
         WkMEt1wgI3qPMm4n2uI6WwkV4MmW/kkP7+PJ8j0OPd288ooxjzj0LHvsvymAu66sxFtr
         NtncHLPb6TXRFmDIWSkUJu/odK4XMwpG6ADhvhM1R0rxT3Ik3op8T49XSZAFkJ6RFFe2
         EwFCH7a/CatQTmMsyzXCeoJ2PTcZBo/WH18p5o4YlqpDZ5glIQRtVKLMXmFghjDAWUuj
         XqJIU6nADaxM0y5C7GZOgxXdySOLtggD8MPgVzLIvLwM9FpgSuxXvCfGFq/tJYPLgUw+
         svVA==
X-Forwarded-Encrypted: i=1; AKwUvBy2K5LA+J2KdNsGGq7bBbpNTi3Iza/2loKj1cfNibISHfn5PUOnPorQBniY62dKEjZxTzMHlHFE@vger.kernel.org
X-Gm-Message-State: AFq9FYKHzZNmJyaY1vHy2z5nWoWNqxNpAIfIZbGQbXTqsO/uJf+2fiFD
	az5RJ35BVaypne7xTc8l/DNT884tx4U2mS/Q7pb697cD2xZ3+tqrhD4y1f1CS5NzGog=
X-Gm-Gg: AYBFou1paG82JJ5Z3iullWBBhyQHqU5RMY4ajQ/nx6Y/L4/CFp89rnJjcyUcSOW48fl
	57iQZa/oj+ySoM/2dIWYYDypYLML8EicHvHNzX+y/Q8xvIm/CEYfF1eYk7la53VPn8J1T21CU19
	5qqqDcdcT1WDeDT7a6NbKYv2yDsXLMoqCMI5D+JTeA+ekJcEDp0KMlaM+cowbAsSkZtdpfxyvsu
	dincStz1Z9XB9jSLhG/GOFFdOUyzWCTweTcT3afWPGLdy+8MCvDIq1M9H/8712Ku0nP7S/Qdxm8
	GvRdWEsm63jmyALucEMtGEfdoVdDnkTqjUNEeYSSbWyvCBsIushcTaaxOQqz+EMe/dBAloKQcM0
	G0LA+PLhksfbpkjD4bVLy9FqixYgphRKTxRpm3bTCJjaEw4O9NMkLTm23S7C1rbS4K9Yh0xmdz+
	dBRioiDrgLW4OT7QpTjTgarVFcvU4EzoF9Sf4rH8aAviavZtKFmMX6MCLABDtDO2eNWGZFrGp25
	+tMAGHivIOR
X-Received: by 2002:a05:600c:46ca:b0:4a1:7a1e:6910 with SMTP id 5b1f17b1804b1-4a18e48363amr313361525e9.4.1791977949379;
        Wed, 14 Oct 2026 04:39:09 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18be97d1esm688508455e9.8.2026.10.14.04.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:39:07 -0700 (PDT)
Date: Wed, 14 Oct 2026 13:39:06 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Message-ID: <as9p2uFqCQprwdnI@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-5-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-5-shakeel.butt@linux.dev>

On Sat 10-10-26 14:09:56, Shakeel Butt wrote:
> Kernel threads and remote chargers use high_work when memory.high is
> exceeded. Their allocations during reclaim can also charge memory,
> for example when zswap stores a page.
> 
> Without a check, the high_work worker can queue itself from its own
> reclaim. The pending bit is cleared before high_work runs, so each run
> can queue another run.

What does that mean really? Does this delays the actual run?
 
> Skip memory.high enforcement for charges from task context with
> PF_MEMALLOC set when they would use high_work. This covers kernel
> threads and remote charges. The memory is still charged. Interrupt
> charges keep their current path.
> 
> In a VM with incompressible zswap data, the worker queued itself 163 times
> without this check.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

The patch itself looks OK. I am wondering whether we can unify the check
with the existing one which forces the allocation through in main
charging path.

> ---
>  mm/memcontrol.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3456960cbe68..d1e022e6572f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2708,6 +2708,14 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
>  		!current->mm || !mm_match_cgroup(current->mm, memcg);
>  
> +	/*
> +	 * Reclaim can charge memory, for example when zswap stores a page.
> +	 * Don't queue high_work from a reclaiming task, or the
> +	 * high_work worker could keep queuing itself.
> +	 */
> +	if (in_task() && use_worker && (current->flags & PF_MEMALLOC))
> +		return;
> +
>  	/*
>  	 * If the hierarchy is above the normal consumption range, schedule
>  	 * reclaim on returning to userland.  We can perform reclaim here
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
