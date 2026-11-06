Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793969813;
	b=qL4m+DB8o+V5OIfxlOaXARlkB5J3MiCeSU2BkcSrN7Lr9faOA860OefGFX4eOuBtliVW
	 IL7mBZqst9w6dxdOwoYBlGZOWnX3/ytvJe5RLVfSQNjFe7vb6/SQLS7v8YXN2Jb7Hgtry
	 wqOjmQ4MkONCM6gNsS03OuJXDc1kSihxAvSq8TXoUzUiLgkdvTdi99l2mBOlvEZTOY6pO
	 GyTAimD4zBikZM3egS4rAhJ8GkT/ZADysGvNAkzuYAMgcnOsaTUvpyrjr7zuq3oA4N2zE
	 DvLIeBojT8uz8+OIvPKLao/00IOuLgqrq/UgooamJnXPUt1fJfgetB9GctDL7WNPRaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793969813;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=9VpU3s4yf4A/VkVgs+2HUp63ZM4Ff63clTXzeYeN/bk=;
	b=5dkwEYHyRkpORtc+TqvIP59+KKlr4swH7gar/RmJxbszmKCqGirZ1dzwlZLuug0vcsMW
	 t1kq82citAJ42VA8ZwMzdJGhQ5vbPnaIqMN6Ejg9tFU93t4vgPDIjbFH03UliQf2mWUW7
	 2YUzSUZ+tOy1sIwK1ZpDtrXMx9prXxmu09Cp6UMqFINyKdEi2c17f+jOmYwrUq+7ggbcS
	 CSc6TvCSIK/gADNVfYGgSngSKZWhgyaw8smQ2aPVwShQoxZ8YB+J4PmELNP+mxkEBMMk7
	 sEGExFWjU4RBvcYpC06/yoz1Ws8TnSp+zvszx6qKIKSiPZEUFAgyGBpmUgTZzWDDtEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BH9StoNJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4F1606A329;
	Fri,  6 Nov 2026 12:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BH9StoNJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4BD1F0089F;
	Fri,  6 Nov 2026 12:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793969812;
	bh=9VpU3s4yf4A/VkVgs+2HUp63ZM4Ff63clTXzeYeN/bk=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=BH9StoNJ1xXxrVEEBPM8Ch07tAFIxs8WM0IsZ/48kp7d0BvVgupAJALLQM2mUSbHl
	 nN44VMHOaeqcWlGhLfhRv3FuWioIu/6Rpj32Z8kCvXEOuKI8UsMeeKZkJRZHnDg2BY
	 hmuWPsiXpPMQXwasalzHNfKZb3g5ACNiiYEGCMox4Xu9qcKlk04KaR6YKmL9K4VlmG
	 +KERQwfwcnMm0uvMvngoAmgAstf4cSfptmWM66Y6uP9vFWbJIKDitFxIBO5f1JlBXm
	 q3K78m0FDQ15G233GHkGZVakKQ8VkN89I2iqkkUrUns9+yVonk5Kr3/y3f0j1yD37o
	 NWlt8rAwmRFnA==
Content-Type: multipart/mixed; boundary="===============7202935202910912622=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <ebb6ebc5ddce3089fe912ca2d6e7a0658864c7369d15e1cdb7f203eae6d5a0d0@mail.kernel.org>
In-Reply-To: <20261106122356.3224638-3-cui.tao@linux.dev>
References: <20261106122356.3224638-3-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v13 2/4] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk,alexei.starovoitov@gmail.com
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri,  6 Nov 2026 12:56:51 +0000 (UTC)

--===============7202935202910912622==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary

TL;DR: Commit message only: it restates the code comment instead of giving the
motivation (monitoring without drgn) for the new iocost_ioc_tick tracepoint.
Not a bug.

> blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
>
> Add iocost_ioc_tick, emitted once per period from ioc_timer_fn() with
> the overall controller state: period_us, vrate, busy_level, active iocg
> count and usage percentage.  busy_level, cur_period, nr_active and
> usage_us_sum are complete at the emission point.  usage is wall time
> over wall time, summed over iocgs, and is not capped at 100.  vrate and
> period_us reflect the current controller state, which an io.cost.qos
> write may have changed mid-period.
>
> The event fires every period the controller is running, including
> steady states, plus one final tick before the controller goes idle, so
> the transition to dormancy is directly visible.  The active iocg count
> is only gathered when the tracepoint is enabled.
>
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

this isn't a bug, but the middle of the first paragraph ("busy_level,
cur_period, nr_active and usage_us_sum are complete at the emission point
... which an io.cost.qos write may have changed mid-period") restates the
block comment added above the tracepoint call in ioc_timer_fn() almost word
for word.

The reason for adding the event only appears in the comment in
include/trace/events/iocost.h ("so basic monitoring doesn't require drgn").

Could the changelog say why a per-period summary event is needed, for
example the monitoring-without-drgn motivation, rather than repeating the
code comment?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/42219005018
--===============7202935202910912622==--
