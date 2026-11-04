Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793761980;
	b=K5noLTXAcVuldb2I/TOrhMNFaE6K0Bcv4zCLqck+xxDM2dv6q0pNCUeSBEnlD+Wakoyk
	 nlidMxPOr35qf8yv21wWeGj5mN2g4nPFgbgi1OEhAvQBKDOI5oOez3EH5S5QDjhty+beq
	 xM5Hs1fLq8XgLmoKiQbNkHYKL3MlY0kkkw4Tv3fzIjKbo1C/KHUR+eTqPVe9DmH3YebVW
	 r9/NH0bCdN5fxuLB+XWx8O6eSFHt3+OMGn96mkmikARuVA+zhU4v4AUisOCIE+gbaPMMB
	 YAJDPinOtEBD85OaSYh6D/EaCCc397RNO3/kb0KVJxWw2MwQEXnlrzTo9yudT1BFFVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793761980;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LveW7nDiawWEYIXu5pfVPlNN/304vQfJ88DUg/zm9Lw=;
	b=HNlvTI3XDPvgjOmOmuPWTR96YRMefGTzXwo2HMSj3ndtXVG6OkUBCiirBTEPemCGmqaz
	 Co5PnOiY5KychM/ppqTPzuHkBBsnxP6LVUPdb4/qbIOObG1fsv5uecFdtdLA1XHhipYek
	 3sJppaTuiWaW+YOZJPa6mOfZKNXLXKfbPyomyLBXpNpy7GU9bPrNURdbg+LUYBnwUQoC+
	 qBQFFUoLBsgAz56W0AaCccKtPwJJbg/vMN4q91O3Yc4p+MirvuHO1aINHj5RtPyHpOfUh
	 QciJUAY+j9GCrLQkgjSg/rPyU2id1q/I1y3jQjllqtHuMn4OZ2LKloNv3/wriOIQcLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="doLWrA/N";
	arc=none smtp.remote-ip=91.218.175.243
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2206A606A329
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 03:12:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2206A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=doLWrA/N
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9OEa3fPovPlD+MXI2KeoqPySDCpv+FwfnIb8O3AdQek=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793761978; v=1; x=1794366778;
 b=doLWrA/NIRHhmJJQPBEF9xi9oB4Z6q+zIdHcHgpVILcXpSryYLgtLAq/sQ5fHPKSvP4rqua5
 yKeklQ9P7XrD2ri185Mau/iUYSJ2sd7zRVsKoI0bse29ZMKNV3+IQHx18tTS0HCioyHUhUYV/IR
 pbidK5X/k8TMETKPezDUr5ws=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6043c9df7e23f1de;
	Wed, 04 Nov 2026 03:12:58 +0000
X-Mizu-Trace-ID: 6043c9df7e23f1de
X-Migadu-Flow: FLOW_OUT
Message-ID: <b48c1374-0136-4da8-b696-3f31c052dad4@linux.dev>
Date: Wed, 4 Nov 2026 11:12:44 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com,
 martin.lau@kernel.org, yonghong.song@linux.dev, mason@kernel.org,
 ihor.solodrai@linux.dev
Subject: Re: [RFC PATCH v12 2/4] blk-iocost: add iocost_ioc_tick tracepoint
 for per-period device summary
To: bot+bpf-ci@kernel.org, tj@kernel.org, josef@toxicopanda.com,
 axboe@kernel.dk, alexei.starovoitov@gmail.com
References: <20261103132613.1952975-3-cui.tao@linux.dev>
 <04adc0407868a7876c12e46e0637e13b3bb8f549e6f47a1d0a9bfe29d144e29b@mail.kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <04adc0407868a7876c12e46e0637e13b3bb8f549e6f47a1d0a9bfe29d144e29b@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

在 2026/11/3 22:07, bot+bpf-ci@kernel.org 写道:
>> blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
> 
> TL;DR: In iocost_ioc_tick, the tracepoint call sits outside its enabled()
> check, so a probe attached in between may log a bogus active count of 0, which
> consumers could read as dormancy.
Confirmed. `nr_active` is only consumed by this tracepoint, so there
is no reason for `trace_iocost_ioc_tick()` to sit outside the
`trace_iocost_ioc_tick_enabled()` block. The split was simply an
oversight when the active count was made conditional on the tracepoint
being enabled.
> 
>> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
>> --- a/block/blk-iocost.c
>> +++ b/block/blk-iocost.c
> 
> [ ... ]
> 
>> @@ -2478,6 +2479,22 @@ static void ioc_timer_fn(struct timer_list *timer)
>>  
>>  	ioc->busy_level = clamp(ioc->busy_level, -1000, 1000);
>>  
>> +	/*
>> +	 * busy_level, cur_period, nr_active and usage_us_sum are complete
>> +	 * here. usage is wall time over wall time, summed over iocgs, and
>> +	 * is not capped at 100. vrate and period_us reflect the current
>> +	 * controller state, which an io.cost.qos write may have changed
>> +	 * mid-period. Emit before the refresh and the period transition.
>> +	 */
>> +	if (trace_iocost_ioc_tick_enabled()) {
>> +		struct ioc_gq *active_iocg;
>> +
>> +		list_for_each_entry(active_iocg, &ioc->active_iocgs,
>> +				     active_list)
>> +			nr_active++;
>> +	}
>> +	trace_iocost_ioc_tick(ioc, &now, nr_active, usage_us_sum);
>> +
> 
> Can this record a bogus nr_active of 0?
> 
> trace_iocost_ioc_tick() is called outside the
> trace_iocost_ioc_tick_enabled() block, so the two static key tests are
> independent.  If a probe is attached on another CPU between them, the first
> test sees the key disabled and skips the count, while the tracepoint itself
> then fires with nr_active still 0 even though ioc->active_iocgs is non-empty.
> 
> Documentation/trace/tracepoints.rst says the tracepoint call should always
> be within the block of the if (trace_<tracepoint>_enabled()) check to avoid
> this race.
I'll move `trace_iocost_ioc_tick()` inside the enabled() block in the
next posting.

Thanks,
Tao
> 
> Since the commit message describes active=0 as the marker for the transition
> to dormancy, a consumer could read this spurious record as that transition,
> alongside a non-zero usage value.
> 
> Would moving the trace_iocost_ioc_tick() call inside the enabled block
> work?  Alternatively, nr_active could be counted in the existing
> list_for_each_entry() walk over ioc->active_iocgs earlier in
> ioc_timer_fn().
> 
> 
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md
> 
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/41646836440

