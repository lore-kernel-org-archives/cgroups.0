Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF53476694;
	Thu, 10 Sep 2026 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789047974; cv=none; b=ulCYKxdxY96Z9zrYs/sbptdA0VeTVwAQOoUn6Ag0IttH0EnTAO5WLYUqZWc3uVJWGbQMqxhUGmQOPmVCodzXUQDUGjkjaIukmBqQx6x2CNBGuR6+/G5QBizqDtEtapCjxqqpb9zzXzIoPEO2r71MMvAV/XkfgSU9cjTllq3kYZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789047974; c=relaxed/simple;
	bh=aLhJvQ9k8qzk2iMyo4DyJKSFKCkfx5AOFPLsl1c0hYQ=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=SzYkgqmEfxRUiix3P/VN0qgGaK6bwhMCrMy4jdtmYaxVm3OaLpiypMNoEEmyP9Be0+l84ae7YrWrYpwuFBtDWsGlTs8xXDDJhGp520KIQdgRSPW72FP7QWrqsCV8mmx0xy9KZc62vpcak+vSzeXWcW1siAMcJCUBvtlbfF8ZJtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ER9EkXYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ER9EkXYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0377C1F000FF;
	Thu, 10 Sep 2026 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789047972;
	bh=XhrA7x52Q28B+clYOZzyqnZ/7ktjb9VO453gBmfr6ic=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ER9EkXYVxl08V6Ycr3YzJLZIiGzmrai+9qupP2+/hBwwayJCnW23h+nvT9BpQxPj/
	 XvwMX0rl1GZ0EWp2seGGiZ1eDqSJpfi51MnTkHwzB7nEASTwZMmLPwpcsaAGFVzwoB
	 xp8U9A8lsOdyXG6zZUfgLYwDIXR04O9jMFtIz+1Ueg70nhq3dXe5qamLIdfJqfTaV+
	 xT08yOL9FZK1o/YOWp7KWVNheAmWvTjzTNS7kDp6cjP8ss3MEexuRfmkOV2WfR8woC
	 cZa7bPqzGhxPoZYyFgkp4E/UfyXCJuIgVEMTJlbgZBiAs0I93NA53wnlKiSZAqGCpc
	 QzTOBAN7MfJaw==
Content-Type: multipart/mixed; boundary="===============5058253262843076192=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <e0531130b2eff0eee7bedec1816125c0a2e193beb291a5688290d0efb9318aae@mail.kernel.org>
In-Reply-To: <20260910125817.223354-4-cui.tao@linux.dev>
References: <20260910125817.223354-4-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v2 3/5] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 10 Sep 2026 13:46:11 +0000 (UTC)

--===============5058253262843076192==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
>
> The existing iocost tracepoints are state-change driven: vrate_adj
> fires only when the adjustment logic runs, inuse_* only on surplus
> state transitions, activate/idle only on cgroup state changes.  In a
> steady state none of them fire.  The only other way to observe the
> controller (period length, vrate, busy level, active cgroup count,
> device utilization) is iocost_monitor.py, which reads kernel memory
> through drgn and is not usable in most production environments.
>
> Add iocost_ioc_tick, emitted once per period from the tail of
> ioc_timer_fn() with the overall controller state: period_us, vrate,
> busy_level, active iocg count, usage percentage and running state.
> It fires every period the controller runs, including steady states,
> plus one final tick before the controller goes idle, which makes
> dormancy (e.g. a device saturated entirely by uncharged IO) directly
> visible.
>
> At the default period this is a couple of events per second per
> device; the cost is zero while the static key is off.

Both halves of this last sentence overstate the case.

"a couple of events per second per device": the default period comes from
ioc_refresh_period_us(), and because the autop[] tables leave QOS_RPPM/QOS_WPPM
at 0, multi is always 2, so period_us = 2 * latency target:

  - AUTOP_HDD:      2 * 250000us = 500ms  ->  2 events/s
  - AUTOP_SSD_QD1:  2 *  25000us =  50ms  -> 20 events/s
  - AUTOP_SSD_DFL:  2 *  25000us =  50ms  -> 20 events/s
  - AUTOP_SSD_FAST: 2 *   5000us =  10ms  -> 100 events/s

Only the rotational default matches "a couple per second"; the SSD defaults -
the common case - are 20-100 events/s per device, 10-50x higher.

"the cost is zero while the static key is off": the nr_active++ added at
block/blk-iocost.c:2284 runs unconditionally on every active iocg in every
period, outside the static key. The cost is negligible, but it is not zero,
and the claim as written invites the reader to believe no work was added to
the timer path.

> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 182601ad783f..bccdbd2496d8 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c

[ ... ]

> @@ -2280,6 +2281,8 @@ static void ioc_timer_fn(struct timer_list *timer)
>  		u64 vdone, vtime, usage_us;
>  		u32 hw_active, hw_inuse;
>
> +		nr_active++;
> +
>  		/*
>  		 * Collect unused and wind vtime closer to vnow to prevent
>  		 * iocgs from accumulating a large amount of budget.

[ ... ]

> @@ -2466,6 +2469,8 @@ static void ioc_timer_fn(struct timer_list *timer)
>  		ioc_refresh_vrate(ioc, &now);
>  	}
>
> +	trace_iocost_ioc_tick(ioc, nr_active, usage_us_sum);
> +
>  	spin_unlock_irq(&ioc->lock);
>  }

Is the tracepoint emitted at the right point in the function? It is called
after the period-rollover bookkeeping, so on the one tick the changelog
specifically advertises, the reported state has already been wiped.

The changelog says: "plus one final tick before the controller goes idle,
which makes dormancy (e.g. a device saturated entirely by uncharged IO)
directly visible." That final tick is taken through the else branch at
block/blk-iocost.c:2464-2467, which executes this:

	} else {
		ioc->busy_level = 0;
		ioc->vtime_err = 0;
		ioc->running = IOC_IDLE;
	}

	ioc_refresh_vrate(ioc, &now);

immediately before the trace call. The event therefore always reports busy=0
for the go-idle tick, even though the busy_level computed earlier in this
very period (from rq_wait_pct / missed_ppm, lines 2401-2420) is the
interesting number in the named scenario: a device saturated by uncharged IO
drives rq_wait_pct up, so busy_level was incremented and ioc_adjust_base_vrate()
already slowed vrate down - and none of that is visible in the emitted record,
which reads active=0 usage=0% busy=0 running=0.

Same ordering issue for running: it is set to IOC_IDLE at line 2466 before the
trace, so the field describes the state entered *after* the period rather than
the state the period ran in. Placing the trace_iocost_ioc_tick() call before
the `if (ioc->running != IOC_STOP)` block (or capturing busy_level/running into
locals right after ioc_adjust_base_vrate()) would emit the period's own state.

> diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
> index e772b1bc60d6..2b9ff348a4f5 100644
> --- a/include/trace/events/iocost.h
> +++ b/include/trace/events/iocost.h

[ ... ]

> +/*
> + * Periodic per-device summary, emitted once per period from the tail of
> + * ioc_timer_fn().  Unlike the state-change events above, this fires every
> + * period the controller is running, including steady states, and carries
> + * the overall controller state so basic monitoring doesn't require drgn.
> + */
> +TRACE_EVENT(iocost_ioc_tick,
> +
> +	TP_PROTO(struct ioc *ioc, int nr_active, u64 usage_us_sum),
> +
> +	TP_ARGS(ioc, nr_active, usage_us_sum),
> +
> +	TP_STRUCT__entry (
> +		__string(devname, ioc_name(ioc))
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
> +		__entry->period_us = ioc->period_us;
> +		__entry->vrate = ioc->vtime_base_rate;
> +		__entry->busy_level = ioc->busy_level;
> +		__entry->nr_active = nr_active;
> +		__entry->usage_pct = ioc->period_us ?
> +			div_u64(usage_us_sum * 100, ioc->period_us) : 0;
> +		__entry->running = ioc->running;
> +	),

Does usage_pct normalise against the right divisor? It uses the *nominal*
period length read at the very end of ioc_timer_fn(), which is neither the
interval the usage was accumulated over nor necessarily the period_us that
was in effect during it.

Two concrete problems:

1. Wrong divisor. usage_us_sum is accumulated over the real interval
[ioc->period_at, now.now]. ioc_timer_fn() itself never treats that as equal to
ioc->period_us - the donation loop a few lines above deliberately uses the
measured duration:

    usage_dur = max_t(u64, now.now - ioc->period_at, 1);

and ioc_forgive_debts() (block/blk-iocost.c:2119) does the same for its own
percentage:

    dur = now->now - ioc->dfgv_period_at;
    usage_pct = div64_u64(100 * ioc->dfgv_usage_us_sum, dur);

ioc_start_period() re-arms with a jiffies timer (ioc->timer.expires = jiffies +
usecs_to_jiffies(ioc->period_us)), so a period routinely runs longer than
period_us - which is exactly why the code above measures instead of assuming.
Every microsecond of timer/softirq lateness inflates the reported usage
percentage proportionally, and the consumer cannot correct for it: the
tracepoint is emitted *after* ioc_start_period() has already overwritten
ioc->period_at with now.now, and the event carries neither now.now nor the old
period_at, so the actual duration is unrecoverable from the trace.

2. Stale-vs-new period_us. ioc_refresh_params(ioc, false) runs before the
tracepoint (block/blk-iocost.c:2452) and, when the autop index changes, calls
ioc_refresh_period_us() which rewrites ioc->period_us (e.g. AUTOP_SSD_DFL
50000us -> AUTOP_SSD_FAST 10000us). On such a period the event divides the old
period's usage by the new period length, a 5x error, and also reports the
freshly reset vtime_base_rate (ioc_refresh_params_disk() sets it back to
VTIME_PER_USEC).

Using the measured duration - captured before ioc_start_period() clobbers
ioc->period_at - would make the field mean what the changelog says it means
("device utilization").

Aside on the same line: the `ioc->period_us ?` guard is unreachable.
ioc_refresh_period_us() ends with `period_us = clamp_t(u32, period_us,
MIN_PERIOD, MAX_PERIOD)` (MIN_PERIOD = USEC_PER_MSEC) and runs from
blk_iocost_init()'s ioc_refresh_params_disk(ioc, true, disk) before
timer_setup() at block/blk-iocost.c:3001, so ioc->period_us is never 0 when
ioc_timer_fn() executes.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34481298417
--===============5058253262843076192==--
