Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714858;
	b=arAY1KTRd50XfktuZQdseLQ2557RYj/JDSXqaD4edzwmukEYxVlC2piXqO8hbtLCfzE6
	 GgDIr/oHSDRBR0TlFOvK7wh4WRAPuVlc7QSQyYLqc35/mBqqXIURADzWFss4EzzIId2QQ
	 2X/FgnUp1jHVX3l3tFK5NKPbEN1wt59Oqi4KFIwQBhbbzvT/HI+6pO7OfWDGKlQRN7JB1
	 LefqlpQRCPxl6ofjKV7KsKxrZ7kw3HQlBGfDwBUNOGBHGgiOn/FA8UAULcDPttveP+zlj
	 POixUMP4iCEuXV5HT4J3Q2xezki1F+tZZfjKzvow7Er6WD9C+ZxhRcMjaPjAcnbUmzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714858;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=U9bSCqEoQZWI046vsKEKltFAaqusFQFamwPErZIkzhw=;
	b=IIkEQda9+sWodGW4pENAnR7fOIyGYevmhM3nfaq4vmniATe/scNkF2rupblPyAxFRM8Z
	 7vVaLc5OMQXmZ4TGx89shnfydZWvW9HQ+z98oEdM2jMS+NEdgx2dysUDTEmjHhK2ARfqC
	 mJ0Su6hYRjf5ydfmV9C47e4cb7B1yYT4Sg1eJBQzd71iPZoqo+lkteIDuCAezkXxkv2Zj
	 QOFqc3z//wn61ICnvOyGMqtYaMh2FQuu73vQLy3D2QAixLdoR8JrsnA7SY2aLxsbJbuTB
	 2BpO5fYMHONQlibL/mxasWqK4Yj35kJ/W9G0VazCQ2RdH0iXTWBisMZiw64KZzDbb/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LtsOpNfe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F2E606A324;
	Tue,  3 Nov 2026 14:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LtsOpNfe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2091F000C1;
	Tue,  3 Nov 2026 14:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714857;
	bh=U9bSCqEoQZWI046vsKEKltFAaqusFQFamwPErZIkzhw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=LtsOpNfedmofvsuHIt6DsfGek0bq6QITTPDz5lDBmBMqRrGzloBwkBSpa3RwqGvN7
	 bYiombWoF2HGf31FJlUzP9hBdEVn+dq94AMCBNuEevRLj5hcyvregFnTjqAcbgaW1Q
	 wQ+KDd5zuB+pksbXObbQlUA4RRSqHl3t5B9DHGlvH99NoKbxw4r4VL/pnyfuPesXUe
	 vCgxaNgw2zoh5GlCsSfL4rHKnLeB1U4+ogFYOkdOHvbtZo+WI2lEgjvHICAuc0jGVD
	 snv2V9zijCxVGaRpgdRqNyI7oOkvT53L2NLz1BwdL2kiUBDqKHFFxnb4x43UfynvHM
	 w9VwPRJG2Kziw==
Content-Type: multipart/mixed; boundary="===============8626554665073680018=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <04adc0407868a7876c12e46e0637e13b3bb8f549e6f47a1d0a9bfe29d144e29b@mail.kernel.org>
In-Reply-To: <20261103132613.1952975-3-cui.tao@linux.dev>
References: <20261103132613.1952975-3-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v12 2/4] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk,alexei.starovoitov@gmail.com
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue,  3 Nov 2026 14:07:37 +0000 (UTC)

--===============8626554665073680018==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary

TL;DR: In iocost_ioc_tick, the tracepoint call sits outside its enabled()
check, so a probe attached in between may log a bogus active count of 0, which
consumers could read as dormancy.

> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c

[ ... ]

> @@ -2478,6 +2479,22 @@ static void ioc_timer_fn(struct timer_list *timer)
>  
>  	ioc->busy_level = clamp(ioc->busy_level, -1000, 1000);
>  
> +	/*
> +	 * busy_level, cur_period, nr_active and usage_us_sum are complete
> +	 * here. usage is wall time over wall time, summed over iocgs, and
> +	 * is not capped at 100. vrate and period_us reflect the current
> +	 * controller state, which an io.cost.qos write may have changed
> +	 * mid-period. Emit before the refresh and the period transition.
> +	 */
> +	if (trace_iocost_ioc_tick_enabled()) {
> +		struct ioc_gq *active_iocg;
> +
> +		list_for_each_entry(active_iocg, &ioc->active_iocgs,
> +				     active_list)
> +			nr_active++;
> +	}
> +	trace_iocost_ioc_tick(ioc, &now, nr_active, usage_us_sum);
> +

Can this record a bogus nr_active of 0?

trace_iocost_ioc_tick() is called outside the
trace_iocost_ioc_tick_enabled() block, so the two static key tests are
independent.  If a probe is attached on another CPU between them, the first
test sees the key disabled and skips the count, while the tracepoint itself
then fires with nr_active still 0 even though ioc->active_iocgs is non-empty.

Documentation/trace/tracepoints.rst says the tracepoint call should always
be within the block of the if (trace_<tracepoint>_enabled()) check to avoid
this race.

Since the commit message describes active=0 as the marker for the transition
to dormancy, a consumer could read this spurious record as that transition,
alongside a non-zero usage value.

Would moving the trace_iocost_ioc_tick() call inside the enabled block
work?  Alternatively, nr_active could be counted in the existing
list_for_each_entry() walk over ioc->active_iocgs earlier in
ioc_timer_fn().


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/41646836440
--===============8626554665073680018==--
