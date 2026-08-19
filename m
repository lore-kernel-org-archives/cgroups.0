Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9445338736F;
	Wed, 19 Aug 2026 07:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787125038; cv=none; b=lPGtJVK15AUyDouTkEYndm8nVcSMDup7McDDlYvbTp0dxjpRUmtYLCXPIOlaVbB7kOov6ZhqWbiLdDHiIk+omBFfkGKx5nQlukAI7OLsCQ8h7UbLJsMl+pi5nQp3d8ghzXTc4mqX3Dl7WiqubiDM7SWnOPpimO12l0Jo8/lgnM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787125038; c=relaxed/simple;
	bh=FZi+cpGhQ6FrxVlpJBfzb4QK+XLcQ0ptZcmdTMv+aZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=itJ7MPocL3qQeFWKWRHmrFJ1cA0MQ3QMv+Wdb0rTD9CnbmhQKxNAcAYzobYwm/ispMI29G0chHmNXMciwg5Nzi4ZYL5ExHxfiRLN4oR9we/0jvY7Rt1EcMIRfScWvkgsJ+OOeaoFtOneZC7rGU7svtgwZXR8Oqs2Goj9+ly/OGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gu9M2uqP; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gu9M2uqP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BAI9skatQtcwLFtDH7I+qCURbQQ9w1c+9LkqWD63J+U=; b=Gu9M2uqPZhUknsY1Ba1aAq00z7
	x9/dKEeNJcu/BHZte5hqp0bgYY/8Y/rBBueIqeVQNqqyPYDMZfvdyQaPhCRTH+wYXbL+V3K7Uixtv
	uDNkmazmVj2pSH1VUgCaHrhFe6yrMt8CsrH9/jtFQRkcOxYkHlCwUAKk7YHMIXqj+qKkZDAVfQGfq
	EkH0GtSATv6FFj6a3EYi/4IwPj8AdP0jZsljHhPkR9ovDrnpzePw5vytm56Ueq863Bq7ZBnOryYvE
	7MP0p3lH0U0wVbku5QUzwtBXxyDXiJwe+ZQMCi4NV9GV4Jprz5ybx3HNCzfY6zAr2jJHUEdjxPZoy
	1YtqxOrg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwar4-0000000DIzD-1nBF;
	Wed, 19 Aug 2026 07:36:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5599630030F; Wed, 19 Aug 2026 09:36:57 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:36:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jake S <j@metarealtyinc.ca>, Waiman Long <longman@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [BUG] sched/fair: divide error in __calc_prop_weight() from the
 enqueue path (flat-hierarchy series)
Message-ID: <20260819073657.GE1247881@noisy.programming.kicks-ass.net>
References: <20260818231333.1441757-1-j@metarealtyinc.ca>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818231333.1441757-1-j@metarealtyinc.ca>

On Tue, Aug 18, 2026 at 07:13:31PM -0400, Jake S wrote:
> Hi,
> 
> I hit a divide-by-zero panic in __calc_prop_weight(), reached from
> enqueue_hierarchy() inside enqueue_task_fair(). This is the *enqueue*
> path, not the task_tick_fair() variant reported in May and addressed by
> the se->on_rq guard folded into 85570f10a4c6 -- enqueue_hierarchy() and
> dequeue_hierarchy() carry no equivalent check.
> 
> The code is from the tip sched/core flat-hierarchy rework; it is not in
> Linus' tree. I am running it via a distro kernel (CachyOS) that carries
> the series, on 7.2-rc7 and 7.2.0.
> 
> I have separated what I verified from what I am guessing. The last link
> in the causal chain is unexplained and I am asking about it rather than
> asserting it.
> 
> === The oops ===
> 
>   Oops: divide error: 0000 [#1] SMP NOPTI
>   CPU: 12 UID: 1000 PID: 312907 Comm: bash
>   Tainted: G     U   C OE       7.2.0-rc7-2-cachyos-rc #1 PREEMPT(full)
>   Hardware name: Dell Inc. XPS 16 DA16260/0RMV2Y, BIOS 1.5.1 04/01/2026
>   RIP: 0010:enqueue_task_fair.llvm.6536700009857788019+0x422/0x950
>   Code: 0f 84 74 01 00 00 83 bd 68 01 00 00 00 45 0f 4f f4 48 8b 4d 00
>         4c 89 e8 48 09 c8 48 c1 e8 20 0f 85 53 fd ff ff 44 89 e8 31 d2
>         <f7> f1 41 89 c5 e9 4f fd ff ff 0f 0b e9 1d fe ff ff 4c 89 e6
>   RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>   RDX: 0000000000000000 RSI: fffff46fbf98e680 RDI: fffff46fbf98ffc0
>   RBP: fffff46fbf98ffc0 R08: ffff8ee25f9b2a80 R09: 0000000000000000
>   R10: 0000000000000000 R11: 0000000000000110 R12: 0000000000000001
>   R13: 0000000000000000 R14: 0000000000000001 R15: fffff46fbf9901c0
>   Call Trace:
>    <TASK>
>    enqueue_task+0x8e/0x250
>    wake_up_new_task+0x148/0x2e0
>    kernel_clone+0x1c6/0x390
>    __x64_sys_clone+0xcc/0x100
>    do_syscall_64+0x147/0x3c0
>    asm_fred_entrypoint_user+0x41/0x41
>    </TASK>
> 
> Machine was idle, lid closed, 11.66 h into the boot. bash forked, the
> new task was enqueued, div trapped.
> 
> It is not survivable in practice. panic_on_oops was 0, so the kernel
> took the first #DE, printed the oops and continued for 476 ms. It then
> faulted at the same RIP with byte-identical registers and an identical
> RSP (ffffd46fff53bbb0):
> 
>   Kernel panic - not syncing: Fatal exception
>   Shutting down cpus with NMI
> 
> i.e. the oops-recovery path (kill task -> schedule()) re-entered the
> same enqueue with the rq lock already held mid-enqueue.
> 
> === Where it divides (confirmed) ===
> 
> kernel/sched/fair.c, __calc_prop_weight(), inlined into
> enqueue_hierarchy() -> enqueue_task_fair():
> 
> 	weight *= se->load.weight;
> 	if (parent_entity(se))
> 		weight /= cfs_rq->load.weight;	/* <-- #DE */
> 
> RCX = cfs_rq->load.weight = 0. R13 = 0 means se->load.weight was 0 as
> well, i.e. a group sched_entity carrying zero weight.

Durr, 0 weight not good, in any scheme. Much of the code strives to
never let it get below 2 or so.

> Not a miscompile: this is clang 22.1.8 + ThinLTO, hence the .llvm.<hash>
> suffix. The 32-bit "div %ecx" against 64-bit C operands is clang's
> BypassSlowDivision -- the preceding "or %rcx,%rax; shr $32,%rax; jne"
> is its guard. The 64-bit slow path is present in the same function.
> 
> === How the weight can reach zero (mechanism, partly inferred) ===
> 
> __calc_smp_shares() ends:
> 
> 	return clamp_t(long, shares, MIN_SHARES, shares_max);
> 
> clamp() yields hi when hi < lo, so shares_max == 0 silently defeats the
> MIN_SHARES floor and returns 0 -- exactly the case the comment directly
> above it says must yield MIN_SHARES instead of 0. Note __clamp_once()
> already carries

Moo..

> 
> 	BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...)
> 
> so lo > hi is considered a bug upstream; it just cannot fire on a
> runtime-computed shares_max.
> 
> shares_max arrives from calc_concur_shares() as nr * tg_shares, where
> nr = min(tg_tasks(tg), tg_cpus(tg)). tg_cpus() returns
> cpuset_num_cpus(cgrp) unfloored, while its sibling tg_tasks() already
> floors at 1. That asymmetry is the hole.
> 
> concur is the live mode here:
> 
>   $ cat /sys/kernel/debug/sched/cgroup_mode
>   up smp (concur) max tasks
> 
> What I could NOT establish: that tg_cpus() actually returned 0, or what
> would produce an empty effective cpuset. update_cpumasks_hier()
> substitutes the parent's effective_cpus before storing; on this machine
> no cgroup has an empty cpuset.cpus.effective and every
> cpuset.cpus.partition reads "member". Twelve cgroups here have an empty
> cpuset.cpus and all report effective = 0-15. I suspected a power daemon
> that rewrites AllowedCPUs on the top-level systemd slices using an
> empty-then-set idiom, but I could not make that yield an empty effective
> mask, so I am not claiming it.
> 
> The missing floor looks like a hole regardless of what trips it, and I
> would rather ask than guess: is there a path where cpuset_num_cpus() can
> legitimately return 0, or should tg_cpus() simply floor at 1 the way
> tg_tasks() does?

tg_cpus() should probably floor at 1, just to be both symmetric and
avoid this. But I too was under the impression a cpuset would never have
an empty set.

However, now that I think about it, IIRC there is a cpu hotplug (and
suspect I suppose) case where cpuset-v2 allows a cpuset to become empty
like this, *however* it would then take the parent cgroup until it would
find one that is non empty.

Now, cpuset_num_cpus() uses RCU, so perhaps there is a race somewhere.
Waiman, you know this cpuset stuff beter than me, did I get it wrong?

Anyway, if you send a patch adding the floow to tg_cpus(), I'll apply
that just on symmetry grounds. If Waiman spots a fail with the cpuset
bits we can fix that too.

Thanks for the excellent report!
