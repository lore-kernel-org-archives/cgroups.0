Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97B43451DA;
	Thu, 30 Jul 2026 01:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785374031; cv=none; b=s9vIbeSQMZd6Os1Xt0a9TRDSX9AaI0g4xwZ1yDPhe4J346U9Mcs6BkVEl0pqCJ4DW8SgLlFPZ+/wqi++2IiaeND3sus8x5wvrXOc+tOs8ukYk00aTxA4eEAZ3bEkZ+zLJm6tlw4XhuFbG9WlNCXZThDTioDo3KqVzV/AaTgMx8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785374031; c=relaxed/simple;
	bh=GKvXwKnRunki1yk/D0dVmzRqZ3zgNBdiDPRR8jn4j6Y=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=CkkO1DrBMW3Gw6boS37aqs6jzgm0jvFQyPgvOxd143uoumyI2O9x6sXJ3ysemNE8dbUKjjzVd4eZwcpyzmAGTRUPMtCftQjVJ5+1bqV8F/6nozE72uWaA5c/jOuIqSDv6VTduDsyrI/Ycyn7l/zyUezcv6V8mC2HMoGDHnb9H7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pPzXvTG6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pPzXvTG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3C51F000E9;
	Thu, 30 Jul 2026 01:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785374030;
	bh=lEKInAQKzOCXSMv2lRBe8VhnqO6M22pZNQ0AYXxYIyY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pPzXvTG6+b362ZbsjEcde3W2xCG7KopSBKL8+bwuz790ugIjtB/TJOJtTtDvxMLzf
	 7j/LkpPG+eoJ5aBQwNMJHqnaRsIuwJ/x2lQNiUjJTbTwo+ag5Ur3QpGu3w+qBMnoIe
	 QbIwcdRR8su/kUzxlBikPvJeY0GGUfDHEvwG4MDc=
Date: Wed, 29 Jul 2026 18:13:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Suren
 Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, Rik
 van Riel <riel@surriel.com>, Nhat Pham <nphamcs@gmail.com>, Meta kernel
 team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: bypass the reclaim and oom killer for dying
 tasks once oom_reaper is done
Message-Id: <20260729181349.fd41f1a09ec19c9cfb0c412f@linux-foundation.org>
In-Reply-To: <20260729024612.3369005-1-shakeel.butt@linux.dev>
References: <20260729024612.3369005-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Jul 2026 19:46:12 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> At Meta, we are seeing instances where an OOM killed job is stuck in the
> exit path for several hours. In one particular case, the job was stuck
> for more than 8 hours and I had to manually remove the memory.max limits
> to allow the process to exit.

Not seeing the problem here - that sounds like normal kernel behavior ;)

> Reproduced with 20k threads, each parking a robust futex head on
> its own zswapped page, OOM-group-killed while a sibling holds mmap_lock
> for write so the reaper gives up and sets MMF_OOM_SKIP. Tested on
> next-20260728 and baseline show ~90 seconds exit time while with the
> patch the exit time reduced to ~3 seconds.

Very positive.

But it doesn't sound like you're fully confident that the problem is
fully solved?

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2653,6 +2653,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!gfpflags_allow_blocking(gfp_mask))
>  		goto nomem;
>  
> +	/*
> +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> +	 * help but it might fail on mmap_lock contention. If the victim is a
> +	 * large thread group then all exiting threads might compete on oom_lock
> +	 * just to learn that there is nothing really killable anymore. Bail
> +	 * out early and fail the charge to expedite their exit. They are
> +	 * considered fully reclaimed by the oom reaper and they shouldn't
> +	 * contribute further charges.
> +	 */
> +	if (tsk_is_oom_victim(current) &&
> +	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
> +		goto nomem;
> +
>  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
>  	raised_max_event = true;

Should we backport this?
