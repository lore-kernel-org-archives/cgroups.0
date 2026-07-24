Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53367188CC9
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 03:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784863938; cv=none; b=Ld586jzfZpMXolYeUZFQ2NB7MsoJ6aW+CYx0f3vYTPc158M9FUQ8r6ZGHsv5L1mzx6FC/JNVKmTvhn8yips3X0WAelC07yGz9ko+RRO+5z64DhAhdGUcFgrMr2eHkXhBOHVTY66xPsuRuTJvHZbtocWC4AOhhi5Cuu8lOuMrtPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784863938; c=relaxed/simple;
	bh=n4yQS66BDa2FF2VpxJir3Ux10NrRBmWiR/VN6UVKemU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lwtNkzbKwHrubxcJWi0aZznuX8fHQgxA1r0Tf0HKODYO6Y1vHXThh9qkdL/W1c2kGLN+zyK9+qUVej5aZb/hfOQqaLH50B1j55JPW1vl4+XKzJZ8daGPqt6LefEhME8hOnoAMyvweUGOPf9zgxSKFBQBKzj/JyIANISpThU8gcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H7Xj4WFg; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H7Xj4WFg"
Message-ID: <da7f525e-077c-4fc2-99bf-04685b1d8225@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784863934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vJz7+UH1Fz2MbDbCCcGFwiqZ9h8iEUeKp5pLXvubZFQ=;
	b=H7Xj4WFg3XVQ2HVQeDopq5K/8g6Jnhl+OisjXzcj7wbiAiyRNKo0PQCt4o1zg8gOzjdi3+
	utl/Btr/6z1DSHxu82iotWQdzFefduQ6X4HEgyW21M0yNDS5uXIDDOq4bK1jPqjs+jRbQq
	YNtWcXNfgJMFj0Zu4+oQMrHwNmJpS0E=
Date: Fri, 24 Jul 2026 11:32:07 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/24 10:18, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> kernfs serializes file operations only per open file, so separate open
> files can update the same memory.high or memory.max file concurrently.
> Both handlers store the new limit before synchronous reclaim, but
> continue to use the writer's local target in the reclaim loop. If another
> writer raises or removes the limit, the first writer can continue
> reclaiming toward a stale target.
> 
> For memory.max, this can leave the writer looping indefinitely once
> reclaim retries are exhausted. The OOM path sees sufficient margin under
> the current limit and returns true without killing, while the writer
> still compares usage against its stale target and records another OOM
> event.
> 
> Check the current limit at the start of each reclaim iteration and stop
> if it no longer matches the writer's target.
> 

Fix looks correct to me.

Acked-by: Tao Cui <cuitao@kylinos.cn>

Nit: the message lumps both paths together, but only memory.max loops
indefinitely. memory.high has no OOM path, so it just spins
MAX_RECLAIM_RETRIES times and breaks on its own. Worth a line to avoid
conflating the severity.

> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
> Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
> Reproducer:
> 
> Populate a cgroup with anonymous memory and disable swapping. Lower
> memory.max from one open file, then restore it to "max" through another
> open file after the new limit becomes visible.
> 
> Without the patch, the first writer remains blocked and repeatedly
> increments the OOM event counter. With the patch, it returns normally.
> 
>  mm/memcontrol.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8319ad8c5c23..638bdc766616 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4798,6 +4798,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
>  		unsigned long nr_pages = page_counter_read(&memcg->memory);
>  		unsigned long reclaimed;
>  
> +		if (high != READ_ONCE(memcg->memory.high))
> +			break;
> +
>  		if (nr_pages <= high)
>  			break;
>  
> @@ -4853,6 +4856,9 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
>  	for (;;) {
>  		unsigned long nr_pages = page_counter_read(&memcg->memory);
>  
> +		if (max != READ_ONCE(memcg->memory.max))
> +			break;
> +
>  		if (nr_pages <= max)
>  			break;
>  

