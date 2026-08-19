Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34138449980
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 09:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787133009; cv=none; b=d97dt7522C01jKfduhJHpz0j9Lp0Ap5Y6L/2TbMtEDq/xJEnd4VnQJ8OMSnPk/yWFHnViV5PFA2cWLDbk/DGLmm0qIWwqfXAFzs7N4GchOiTwSBIQy3zbe6KDK4p1NoVifmojg08iJhMYHcNsVVykxbTwJnR9ys5YRKNQfuWpRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787133009; c=relaxed/simple;
	bh=1b/Yl6Y7FDSwEL77k5S+vqplOJr8Ak2L3B9YMJNAeks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=txNqTCzorRMxvGhEVA3t6OIg+gqIxctkKgQA5KcWho6ikiGc6WLrVD3B/gTwaQm1GoWpR1bOh3se9KtDNVdT7dAkT4EyVl37KRQ5LAHAdtdgHwbSOH0rr6bfciD+7x/9RJRlnT/n7mAyYGp2T4K2fvUSCvVau/QvJU9qiKd2J2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gnfeJS4X; arc=none smtp.client-ip=95.215.58.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gnfeJS4X"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1b/Yl6Y7FDSwEL77k5S+vqplOJr8Ak2L3B9YMJNAeks=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787133005; v=1; x=1787737805;
 b=gnfeJS4XtDN65sIBd/rr1SkEe4vj4WF+uJOjkM3bbaMM1xQVyBICBuxUgC+4jnceh4pSlRzi
 k74ezn8NVa6VuK74kPD1NABegpXdYf8MVuu6+lcsomaoNBsk6IEZoMfhpgHACV9Lb9EgqZaNuE3
 YQr6Ns3TRa+VPQ3FKc1lTaCQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [192.168.110.242] (223.70.160.239)
	by smtp.migadu.com with ESMTPS id ed1c7218c08d4291;
	Wed, 19 Aug 2026 09:50:04 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <465d2716-d023-4858-bec6-b688540cafeb@linux.dev>
Date: Wed, 19 Aug 2026 17:49:56 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] sched/fair: divide error in __calc_prop_weight() from the
 enqueue path (flat-hierarchy series)
To: Peter Zijlstra <peterz@infradead.org>, Jake S <j@metarealtyinc.ca>,
 Waiman Long <longman@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Tejun Heo <tj@kernel.org>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260818231333.1441757-1-j@metarealtyinc.ca>
 <20260819073657.GE1247881@noisy.programming.kicks-ass.net>
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20260819073657.GE1247881@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/19 15:36, Peter Zijlstra 写道:
> On Tue, Aug 18, 2026 at 07:13:31PM -0400, Jake S wrote:
>> Hi,
>>
>> I hit a divide-by-zero panic in __calc_prop_weight(), reached from
>> enqueue_hierarchy() inside enqueue_task_fair(). This is the *enqueue*
>> path, not the task_tick_fair() variant reported in May and addressed by
>> the se->on_rq guard folded into 85570f10a4c6 -- enqueue_hierarchy() and
>> dequeue_hierarchy() carry no equivalent check.
>>
>> The code is from the tip sched/core flat-hierarchy rework; it is not in
>> Linus' tree. I am running it via a distro kernel (CachyOS) that carries
>> the series, on 7.2-rc7 and 7.2.0.
>>
>> I have separated what I verified from what I am guessing. The last link
>> in the causal chain is unexplained and I am asking about it rather than
>> asserting it.
>>
>> === The oops ===
>>
>>   Oops: divide error: 0000 [#1] SMP NOPTI
>>   CPU: 12 UID: 1000 PID: 312907 Comm: bash
>>   Tainted: G     U   C OE       7.2.0-rc7-2-cachyos-rc #1 PREEMPT(full)
>>   Hardware name: Dell Inc. XPS 16 DA16260/0RMV2Y, BIOS 1.5.1 04/01/2026
>>   RIP: 0010:enqueue_task_fair.llvm.6536700009857788019+0x422/0x950
>>   Code: 0f 84 74 01 00 00 83 bd 68 01 00 00 00 45 0f 4f f4 48 8b 4d 00
>>         4c 89 e8 48 09 c8 48 c1 e8 20 0f 85 53 fd ff ff 44 89 e8 31 d2
>>         <f7> f1 41 89 c5 e9 4f fd ff ff 0f 0b e9 1d fe ff ff 4c 89 e6
>>   RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>>   RDX: 0000000000000000 RSI: fffff46fbf98e680 RDI: fffff46fbf98ffc0
>>   RBP: fffff46fbf98ffc0 R08: ffff8ee25f9b2a80 R09: 0000000000000000
>>   R10: 0000000000000000 R11: 0000000000000110 R12: 0000000000000001
>>   R13: 0000000000000000 R14: 0000000000000001 R15: fffff46fbf9901c0
>>   Call Trace:
>>    <TASK>
>>    enqueue_task+0x8e/0x250
>>    wake_up_new_task+0x148/0x2e0
>>    kernel_clone+0x1c6/0x390
>>    __x64_sys_clone+0xcc/0x100
>>    do_syscall_64+0x147/0x3c0
>>    asm_fred_entrypoint_user+0x41/0x41
>>    </TASK>
>>
>> Machine was idle, lid closed, 11.66 h into the boot. bash forked, the
>> new task was enqueued, div trapped.
>>
>> It is not survivable in practice. panic_on_oops was 0, so the kernel
>> took the first #DE, printed the oops and continued for 476 ms. It then
>> faulted at the same RIP with byte-identical registers and an identical
>> RSP (ffffd46fff53bbb0):
>>
>>   Kernel panic - not syncing: Fatal exception
>>   Shutting down cpus with NMI
>>
>> i.e. the oops-recovery path (kill task -> schedule()) re-entered the
>> same enqueue with the rq lock already held mid-enqueue.
>>
>> === Where it divides (confirmed) ===
>>
>> kernel/sched/fair.c, __calc_prop_weight(), inlined into
>> enqueue_hierarchy() -> enqueue_task_fair():
>>
>> 	weight *= se->load.weight;
>> 	if (parent_entity(se))
>> 		weight /= cfs_rq->load.weight;	/* <-- #DE */
>>
>> RCX = cfs_rq->load.weight = 0. R13 = 0 means se->load.weight was 0 as
>> well, i.e. a group sched_entity carrying zero weight.
> 
> Durr, 0 weight not good, in any scheme. Much of the code strives to
> never let it get below 2 or so.
> 
>> Not a miscompile: this is clang 22.1.8 + ThinLTO, hence the .llvm.<hash>
>> suffix. The 32-bit "div %ecx" against 64-bit C operands is clang's
>> BypassSlowDivision -- the preceding "or %rcx,%rax; shr $32,%rax; jne"
>> is its guard. The 64-bit slow path is present in the same function.
>>
>> === How the weight can reach zero (mechanism, partly inferred) ===
>>
>> __calc_smp_shares() ends:
>>
>> 	return clamp_t(long, shares, MIN_SHARES, shares_max);
>>
>> clamp() yields hi when hi < lo, so shares_max == 0 silently defeats the
>> MIN_SHARES floor and returns 0 -- exactly the case the comment directly
>> above it says must yield MIN_SHARES instead of 0. Note __clamp_once()
>> already carries
> 
> Moo..
> 
>>
>> 	BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...)
>>
>> so lo > hi is considered a bug upstream; it just cannot fire on a
>> runtime-computed shares_max.
>>
>> shares_max arrives from calc_concur_shares() as nr * tg_shares, where
>> nr = min(tg_tasks(tg), tg_cpus(tg)). tg_cpus() returns
>> cpuset_num_cpus(cgrp) unfloored, while its sibling tg_tasks() already
>> floors at 1. That asymmetry is the hole.
>>
>> concur is the live mode here:
>>
>>   $ cat /sys/kernel/debug/sched/cgroup_mode
>>   up smp (concur) max tasks
>>
>> What I could NOT establish: that tg_cpus() actually returned 0, or what
>> would produce an empty effective cpuset. update_cpumasks_hier()
>> substitutes the parent's effective_cpus before storing; on this machine
>> no cgroup has an empty cpuset.cpus.effective and every
>> cpuset.cpus.partition reads "member". Twelve cgroups here have an empty
>> cpuset.cpus and all report effective = 0-15. I suspected a power daemon
>> that rewrites AllowedCPUs on the top-level systemd slices using an
>> empty-then-set idiom, but I could not make that yield an empty effective
>> mask, so I am not claiming it.
>>
>> The missing floor looks like a hole regardless of what trips it, and I
>> would rather ask than guess: is there a path where cpuset_num_cpus() can
>> legitimately return 0, or should tg_cpus() simply floor at 1 the way
>> tg_tasks() does?
> 
> tg_cpus() should probably floor at 1, just to be both symmetric and
> avoid this. But I too was under the impression a cpuset would never have
> an empty set.
> 
> However, now that I think about it, IIRC there is a cpu hotplug (and
> suspect I suppose) case where cpuset-v2 allows a cpuset to become empty
> like this, *however* it would then take the parent cgroup until it would
> find one that is non empty.
> 

This reminded me of a CPU hotplug / suspend issue I ran into recently.

I had a case where the last online HK_TYPE_DOMAIN CPU could be offlined
during regular hotplug because the check in _cpu_down() did not exclude
the outgoing CPU. That left scheduler-domain rebuilds with an empty span
and eventually caused a crash:

https://lore.kernel.org/all/20260811121307.168471-1-guopeng.zhang@linux.dev/

While testing this with domain isolation, I also saw suspend/freeze reach
a state with no active HK_TYPE_DOMAIN CPUs. I later sent an RFC for
handling that case in the scheduler/cpuset paths:

https://lore.kernel.org/all/20260722115238.351821-1-guopeng.zhang@linux.dev/

The reproducer used:

    isolcpus=domain,0,3-31

I have not checked whether this can make cpuset_num_cpus() return 0 in
the path Jake hit, so this may well be unrelated. I just thought it was
worth mentioning since you brought up the hotplug/suspend case.

Thanks,
Guopeng

> Now, cpuset_num_cpus() uses RCU, so perhaps there is a race somewhere.
> Waiman, you know this cpuset stuff beter than me, did I get it wrong?
> 
> Anyway, if you send a patch adding the floow to tg_cpus(), I'll apply
> that just on symmetry grounds. If Waiman spots a fail with the cpuset
> bits we can fix that too.
> 
> Thanks for the excellent report!
> 

