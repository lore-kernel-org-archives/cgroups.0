Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067281A8F7B;
	Thu, 24 Sep 2026 06:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790230649; cv=none; b=XCpXnR+i2CIym65owHspHGTN/R9ulKh4xgS7EWcqIP7MVp11vWGqv0AAaW2hOwCYFeExwMsH50AJOtlGjgA/B8FBq1rG6pc38XOhYZR1pRCBepVvSQrctVnIvoRyJiNxdwj8zS3lDa5dWK1bE2vDr0iomV15ozr+tgAvsKsLg6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790230649; c=relaxed/simple;
	bh=K5LbEpUdCRyhP6+zeqIs5CQbPD9lIcpv/WtyYozchjw=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=A/ztQIKrhs1byZYpNzEbRYoYnO/9RmU0hi5I8RTxvqdF3KLeZP71VUvfwB3Cd/6OoDuGuWkZxpCaOjvBKwLbcaPD+MiCSjfggeLaAn6nxKyLJkTih3fvYJ1i3bCJlUnvFot6DhQnmNpfqfB0AccW4ISvKPEQheAg68WPmISYTHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ye89XQ0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ye89XQ0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDA91F000FF;
	Thu, 24 Sep 2026 06:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790230647;
	bh=/UnLhQ/lvASg74cIdHap1FuwWyDeDuvmje7+NT56u4s=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Ye89XQ0Ficz8lzEEbIXGnRn0HNZNJwzSDcwr507lgp/n1atcS/vrL2uffUhjaUz9i
	 oqBXkQpoRJZLe7UZkWWJHC4ijRFUPN+U9WsNeuxolB7+vKUftaWo/dSj+sIL0Inuwh
	 O9gRYAppuMPrQCW8votXBJJ1+9IuaBbma2ppNKDcwdXmmadjekViIlxmjTIiXQOBn6
	 wbWoFB4JzzbAucvCja+M0k16eGJuUB1UQRc6pHcD1yJBtfNHCWAA0TuJS1CDODV67l
	 Sk32lsSMWw+5kVhRUP7hwoZ/0HSieYplRrM0qYbWEzZ+eOyQ5cIWNlHFRePWnFV4TD
	 GRJskZu0Ywccw==
Content-Type: multipart/mixed; boundary="===============5180222862375520979=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <0997af18f538770e776a2e2af287ccb144450b5da0108e6bdd0d849aa90353b4@mail.kernel.org>
In-Reply-To: <20260924054549.2271705-4-cui.tao@linux.dev>
References: <20260924054549.2271705-4-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v7 3/4] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,alexei.starovoitov@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 24 Sep 2026 06:17:25 +0000 (UTC)

--===============5180222862375520979==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 21e4f8cbd9f2..a48751b6dbdd 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c

[ ... ]

> diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
> index e772b1bc60d6..32f19861a78f 100644
> --- a/include/trace/events/iocost.h
> +++ b/include/trace/events/iocost.h
> @@ -178,6 +178,51 @@ TRACE_EVENT(iocost_ioc_vrate_adj,
>  	)
>  );
>
> +/*
> + * Periodic per-device summary, emitted once per period from the tail of
> + * ioc_timer_fn().  Unlike the state-change events above, this fires every
> + * period the controller is running, including steady states, and carries
> + * the overall controller state so basic monitoring doesn't require drgn.
> + */
> +TRACE_EVENT(iocost_ioc_tick,
> +
> +	TP_PROTO(struct ioc *ioc, int nr_active, u64 usage_us_sum,
> +		 u32 tick_period_us, u64 tick_vrate,
> +		 int tick_busy, int tick_running, u64 tick_dur),
> +
> +	TP_ARGS(ioc, nr_active, usage_us_sum, tick_period_us, tick_vrate,
> +		tick_busy, tick_running, tick_dur),
> +
> +	TP_STRUCT__entry (
> +		__string(devname, ioc_name(ioc))
> +		__field(u64, cur_period)
> +		__field(u32, period_us)
> +		__field(u64, vrate)
> +		__field(int, busy_level)
> +		__field(int, nr_active)
> +		__field(u32, usage_pct)
> +		__field(int, running)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(devname);
> +		__entry->cur_period = atomic64_read(&ioc->cur_period);
> +		__entry->period_us = tick_period_us;
> +		__entry->vrate = tick_vrate;
> +		__entry->busy_level = tick_busy;

This isn't a bug, but since the ioc pointer is already passed and
cur_period is read from it inside TP_fast_assign, could period_us, vrate
and busy_level also be read from ioc here?

The neighbouring iocost_ioc_vrate_adj event reads ioc->vtime_base_rate
and ioc->busy_level directly from the ioc pointer in its TP_fast_assign.
Reading them directly would make this event's prototype consistent with
that pattern.

> +		__entry->nr_active = nr_active;
> +		__entry->usage_pct = tick_dur ?
> +			div64_u64(usage_us_sum * 100, tick_dur) : 0;
> +		__entry->running = tick_running;
> +	),
> +
> +	TP_printk("[%s] period=%llu:%uus vrate=%llu busy=%d active=%d usage=%u%% running=%d",
> +		__get_str(devname), __entry->cur_period, __entry->period_us,
> +		__entry->vrate, __entry->busy_level, __entry->nr_active,
> +		__entry->usage_pct, __entry->running
> +	)
> +);
> +
>  TRACE_EVENT(iocost_iocg_forgive_debt,
>
>  	TP_PROTO(struct ioc_gq *iocg, const char *path, struct ioc_now *now,


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35962141400
--===============5180222862375520979==--
