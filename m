Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B99270552;
	Fri, 16 Oct 2026 19:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179961; cv=none; b=p6gBmPv4wgHK0mS+V8Z753tDxag+FRdLGWeY2n93UV8qt6xogC6NJuv8DZzudRKValfoLGKou2kS2ovSkLpVl570bP2ru6mvuvjs1ENn/pZYCUm/1fO8nDNBn9kQGj1DLBiSSJrW7tmfXbUVQC8ZqbRcn9c6RKLr/tbkYGwMMRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179961; c=relaxed/simple;
	bh=DxKtbX+UudkFnUJj810JNJP/mKeLsk8jdvzDIz0fu2E=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=oTYs2VU6TQ6vO4dODJMEVGUAqWJNlcCz1nYs8g9gGljs3y6qaAWz29j+JBRH9eE2mxOF6qy2x8250t616NBl8iWPNjwuPbQUz6dvCDLzx6XwWH4zUnJXceGHPKMFAdIXSk1hTRNTQYsWVovQZrZWqmmt0xLL78+fAv/rd9fbWKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hl21KMTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hl21KMTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2C91F000C5;
	Fri, 16 Oct 2026 19:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179959;
	bh=MjeGM9oEcnDgRdbsAdjLLEiqfKFfsdmxL0qkdGbRoJ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hl21KMTDL4RNfQXKr6L2iIpCeZcVsHaaklp7H95NhewZNPs3Hwgj/hKJlwP+8cwMI
	 zegu9GRM3nMAZTDWDRAmWpPbC+HVbk+NCtrNl7nFEEYTs7tVxo3P/xuOqTWChmdpuV
	 4kfEqv7RAY9hWPq+6QsIJPUOsgUYSCd5XGx+DQy/ovibdzdE36j147ZeH7OMRk7GBD
	 uUyw1h47W/33031mUYqleGzJwo9zbFg0aDek/2df19ZZJqbem5ZLv9pnM4BOLlbZ89
	 jr41wiLLyem3FEuLuy7veKzOs6rwzX3iExEf0iWwrqxFN4pEWyLjaTXAuLpQ5sGcl8
	 fgOpLY5awGYwQ==
Date: Fri, 16 Oct 2026 09:45:58 -1000
Message-ID: <f000e148e875d6f1d2b587215117cedc@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Kunhai Dai <daikunhai@didiglobal.com>
Cc: axboe@kernel.dk, josef@toxicpanda.com, yukuai@fygo.io,
	cgroups@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	Tao Cui <cui.tao@linux.dev>
Subject: Re: [PATCH] blk-iocost: publish hweights as one atomic value
In-Reply-To: <20261015135919.210740-1-daikunhai@didiglobal.com>
References: <20261015135919.210740-1-daikunhai@didiglobal.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Kunhai.

The following is a Claude-generated review.

On Thu, Oct 15, 2026 at 09:59:19AM -0400, Kunhai Dai wrote:
> current_hweight() uses separate plain stores for the cache generation and
> both weights. The compiler can publish the generation before the weights,
> letting an interrupt accept stale weights as current. Multiple refreshers
> can also interleave their stores. Invalid donation budgets may then lead
> to a divide error in transfer_surpluses().

The second one is the main problem and doesn't need the compiler's help.
The issue path refreshes the cache without ioc->lock, so CPUs issuing
for the same iocg refresh it concurrently after each commit_weights().
When one of them computed for the previous generation, its plain stores
can interleave with the other's in program order and leave the current
generation with a stale weight, which then stays until the next commit.
The rereads at out: can also return another refresher's stores, even to
the timer under ioc->lock. So the race isn't specific to a toolchain.
Maybe lead the description with it and its effect: stale hweights used
for the issue cost and the donation decisions, and the divide error?

The packed word fixes both, given that every weight change commits the
generation before ioc->lock is released, which holds for all
__propagate_weights() callers.

> Validated against commit 24a19b953e2a ("Linux 7.3-rc7"):

The description could be a lot shorter: the bug, its effect and the fix.
The validation details and the revision notes fit better below the ---
line.

> +	cache = ((u64)ioc_gen << 32) | ((u64)(hwa - 1) << 16) | (hwi - 1);
> +	atomic64_set(&iocg->hweight_cache, (s64)cache);

The encoding is open-coded in the store, the load, ioc_pd_init(),
iocg_activate(), the tracepoint and the monitor. Maybe pack and unpack
helpers with GENMASK_U64() and FIELD_PREP()/FIELD_GET() above the trace
include? The tracepoint header already calls ioc_name() from
blk-iocost.c, so it can use them too. Using WEIGHT_ONE - 1 as the field
mask also ties the weight scale to the field width.

> +	atomic64_set(&iocg->hweight_cache,
> +		     ((u64)(u32)(atomic_read(&ioc->hweight_gen) - 1) << 32) |
> +		     (u32)atomic64_read(&iocg->hweight_cache));

What are the old weight bits kept for? If it's the iocg_activate
tracepoint, a comment would help. Otherwise, writing just the stale
generation would do.

> -		current_hweight(iocg, &hwa, NULL);
> +		current_hweight(iocg, &hwa, &iocg->hweight_inuse);

This only feeds the inuse_transfer tracepoint further down. Maybe get
the value with current_hweight() there instead of writing the scratch
field from here?

> +		if (iocg->hweight_donating > 1)
> +			iocg->hweight_after_donation =
> +				min(iocg->hweight_after_donation,
> +				    iocg->hweight_donating - 1);

Every case this changes still trips the WARN's donating <= 1 test below
and takes the goto, so it only changes the after= value printed. Is it
needed?

> +			goto out;

As Tao suggested, this would be better as a separate first patch with
Fixes: e08d02aa5fc9 ("blk-iocost: implement Andy's method for donation
weight updates") and Cc: stable, followed by the packed cache with
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost").

On Tao's second point, with two or more over-donors the over_hwa rescale
can floor a small donor's after to zero without any race, and an inner
node with hwa equal to donating then gets a zero hweight_inuse and the
same divide. This comes from arithmetic on a constructed hierarchy and
hasn't been reproduced. If it's reachable, the WARN fires from a
legitimate state. Would it be better to keep the rescaled after at 1 or
more, with the goto as the safety net? The goto alone gives up donation
for the whole period.

Thanks.

-- 
tejun
