Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE2A3822B5
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 23:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787094819; cv=none; b=LwOhESDhcuBOo5iP9gnqjJKqgTqUTBBZdOZpG+Roe5qinXaHE8jjUg8tjjH89nbpFkjoggoDzDjsACmY9l2lOJfQn2jQjohvYearvITyrZ5nFa+198yHuE3n54sPZ0wso0iOo9C3HgQB/zyp6JNu3gIUwItayGsfeepvECZJbn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787094819; c=relaxed/simple;
	bh=Z9Eu50ShHl2OI3tTxko3vzesmCGuEj1l3+0dD59k69A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P593IzYLcOLr+KvX+69RbK2FDE8rA81Yd4RW7yfUg8rUY1oXTubPpxut5RmqfMmGBtl4rBZEKnD1BQLhrLLmQp/B8Bxq0rqcRqpFWF3NRacznHanEfVe2McVYLkJhjq4ubjoic5atEvjLH9VCMcGxM9FWcMVE2VSAkpqsNTi8Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=metarealtyinc.ca; spf=pass smtp.mailfrom=metarealtyinc.ca; dkim=pass (2048-bit key) header.d=metarealtyinc-ca.20251104.gappssmtp.com header.i=@metarealtyinc-ca.20251104.gappssmtp.com header.b=sjlfVkoR; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=metarealtyinc.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=metarealtyinc.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=metarealtyinc-ca.20251104.gappssmtp.com header.i=@metarealtyinc-ca.20251104.gappssmtp.com header.b="sjlfVkoR"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c0006ea8eso2926901cf.1
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 16:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metarealtyinc-ca.20251104.gappssmtp.com; s=20251104; t=1787094816; x=1787699616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vx/ffH19CMkCtpTwKLdkpfr/E1yp+dMhBMUbh/gcuCo=;
        b=sjlfVkoRww1ussApim6E+Ex7DOwYGTRIC9ssHYn4rJnApyQWxyP906xFOuoDd74P17
         fTE5Y0dSksxDNjAJTEW7Xc4GJ1quhWUetkAK4hpavghboi6h4NNvJGyiQLoaD7q1oSK8
         zx2KTbzSMMgcPRrnKj7aH88BwVoyizoN/iPGQCSHp1a2F6vX3XDwS8CCgUpl/VnQB7tG
         o/R0d0K5PFrTbGv8i5l4P6RPKMocu7J1gPigssOevmS8NpYeDt1unzTljp8FjKJ04TFN
         uAygFSVJGiUsqtpABqKWAlIPuxnZ0GN73Fmjopzm9OPKnQVBr01IbyHFerKoAmz/sRqc
         JBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787094816; x=1787699616;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vx/ffH19CMkCtpTwKLdkpfr/E1yp+dMhBMUbh/gcuCo=;
        b=boGNOthLpVx3KcWVtgfAgFEQ5mnaJqYadrhGXLb8/PR06qNTyGD38XMkC8GE/ILARJ
         5Gdm6V9CDDHfJjs57k3srDZuQdC66FY27sUhPrgEG8Wfgmlz7XYvv4ne3K/IdWxuL5s1
         3+D6TUw1mDaBYGqau9bGS+QaPiLkPjD6m/6+vRPPGLl/n0C0ZCxeZ4ROYDHFhi3aFJm0
         HUAMHTXXwjVbRnBr3FZfiHC96yCJManUJ5Jj7H6qPLgSfHJhRDChffJCHs9NwNfXzdRi
         S7RzMFOre7S1hGYDVOpIumWrsZlgPp7djD+grmk2xj8myhyzkcACNnWGAz8zMl9j5uH+
         Z5CA==
X-Forwarded-Encrypted: i=1; AHgh+RouQGfEpBx0URd766N022ZJR4BsBFFCEGxxlpTkKIiXTfiQXv9ZqTAHU1LjEzqtu5FMi+GDQNjS@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6z7EJ9LhDmKhzQTO2aD1ArcpTyzgSaSt4KosUuXSCi/2tmT+A
	+oAqxMIjZtgYqROYeD/0MaNUB/HEp6H8JK8L0oTgsvBtUuGkpW7HJfdvpWoCa8SzKY8=
X-Gm-Gg: AR+sD11Ynbap6DwU4DnlB+wrvn4yzp5YuCvNewj4hSrczTbI9TAxXJyL+ahRWp7uM4f
	keGqkyFY08FTprE/zyFb5jttyBX+waNVD1rdfAPjgY5ZpTkYpfeEey13ZlMTsstZWCSAsA8NRPA
	/h6ms0ZyJWNBqkmkYJ0CE5yD7U8+V2wADbnK5+DEvmx0pPOxoKcpgUWD9XRcxlJrh00LJfsSRgF
	77AJVu5x484dWeXzkJyX+pP82Jz+Joj3AZ5QPayc6WIi6g2iChQSEeNKBptnK1h7CSWV6WUPMex
	3VHQPq/4Q0mzJplKYj0xDbkT1CFqnAHOBHGZSxHBREZNQeSDN3wDB92oMmJOR8Dw+i189HPEVj5
	00TnKcWZ4OncdufWYexkQeMh3i6bDfxI1t4QS8+i/IIRDOaetTLNKFshLROaTxyk0bVFB/YRDvn
	dF4e72ySCfiX6/8WA9QBQmaqVckns2Qf45jdGFgDVAfD9j+84n9tDVgB/dP33+nrxMxKC0wVOIq
	e9LXLb5UdV5wbmB43RB//NohVeu8rClOZUQnbivlsKV+XVO5TGTq9cxUV6ywlJnoQg1fUiduHGz
	8uu81oeK7yblQM2J6lvsiCDJjwXCwRFFBImJdhFqDTa+7rW6mYTMsC8=
X-Received: by 2002:a05:622a:598a:b0:517:9f43:4732 with SMTP id d75a77b69052e-52dd578ca57mr7025291cf.11.1787094816360;
        Tue, 18 Aug 2026 16:13:36 -0700 (PDT)
Received: from jake-laptop ([2607:fea8:e5:500::95b9])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52dd857b260sm89341cf.1.2026.08.18.16.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 16:13:35 -0700 (PDT)
From: Jake S <j@metarealtyinc.ca>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [BUG] sched/fair: divide error in __calc_prop_weight() from the enqueue path (flat-hierarchy series)
Date: Tue, 18 Aug 2026 19:13:31 -0400
Message-ID: <20260818231333.1441757-1-j@metarealtyinc.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I hit a divide-by-zero panic in __calc_prop_weight(), reached from
enqueue_hierarchy() inside enqueue_task_fair(). This is the *enqueue*
path, not the task_tick_fair() variant reported in May and addressed by
the se->on_rq guard folded into 85570f10a4c6 -- enqueue_hierarchy() and
dequeue_hierarchy() carry no equivalent check.

The code is from the tip sched/core flat-hierarchy rework; it is not in
Linus' tree. I am running it via a distro kernel (CachyOS) that carries
the series, on 7.2-rc7 and 7.2.0.

I have separated what I verified from what I am guessing. The last link
in the causal chain is unexplained and I am asking about it rather than
asserting it.

=== The oops ===

  Oops: divide error: 0000 [#1] SMP NOPTI
  CPU: 12 UID: 1000 PID: 312907 Comm: bash
  Tainted: G     U   C OE       7.2.0-rc7-2-cachyos-rc #1 PREEMPT(full)
  Hardware name: Dell Inc. XPS 16 DA16260/0RMV2Y, BIOS 1.5.1 04/01/2026
  RIP: 0010:enqueue_task_fair.llvm.6536700009857788019+0x422/0x950
  Code: 0f 84 74 01 00 00 83 bd 68 01 00 00 00 45 0f 4f f4 48 8b 4d 00
        4c 89 e8 48 09 c8 48 c1 e8 20 0f 85 53 fd ff ff 44 89 e8 31 d2
        <f7> f1 41 89 c5 e9 4f fd ff ff 0f 0b e9 1d fe ff ff 4c 89 e6
  RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: fffff46fbf98e680 RDI: fffff46fbf98ffc0
  RBP: fffff46fbf98ffc0 R08: ffff8ee25f9b2a80 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000110 R12: 0000000000000001
  R13: 0000000000000000 R14: 0000000000000001 R15: fffff46fbf9901c0
  Call Trace:
   <TASK>
   enqueue_task+0x8e/0x250
   wake_up_new_task+0x148/0x2e0
   kernel_clone+0x1c6/0x390
   __x64_sys_clone+0xcc/0x100
   do_syscall_64+0x147/0x3c0
   asm_fred_entrypoint_user+0x41/0x41
   </TASK>

Machine was idle, lid closed, 11.66 h into the boot. bash forked, the
new task was enqueued, div trapped.

It is not survivable in practice. panic_on_oops was 0, so the kernel
took the first #DE, printed the oops and continued for 476 ms. It then
faulted at the same RIP with byte-identical registers and an identical
RSP (ffffd46fff53bbb0):

  Kernel panic - not syncing: Fatal exception
  Shutting down cpus with NMI

i.e. the oops-recovery path (kill task -> schedule()) re-entered the
same enqueue with the rq lock already held mid-enqueue.

=== Where it divides (confirmed) ===

kernel/sched/fair.c, __calc_prop_weight(), inlined into
enqueue_hierarchy() -> enqueue_task_fair():

	weight *= se->load.weight;
	if (parent_entity(se))
		weight /= cfs_rq->load.weight;	/* <-- #DE */

RCX = cfs_rq->load.weight = 0. R13 = 0 means se->load.weight was 0 as
well, i.e. a group sched_entity carrying zero weight.

Not a miscompile: this is clang 22.1.8 + ThinLTO, hence the .llvm.<hash>
suffix. The 32-bit "div %ecx" against 64-bit C operands is clang's
BypassSlowDivision -- the preceding "or %rcx,%rax; shr $32,%rax; jne"
is its guard. The 64-bit slow path is present in the same function.

=== How the weight can reach zero (mechanism, partly inferred) ===

__calc_smp_shares() ends:

	return clamp_t(long, shares, MIN_SHARES, shares_max);

clamp() yields hi when hi < lo, so shares_max == 0 silently defeats the
MIN_SHARES floor and returns 0 -- exactly the case the comment directly
above it says must yield MIN_SHARES instead of 0. Note __clamp_once()
already carries

	BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...)

so lo > hi is considered a bug upstream; it just cannot fire on a
runtime-computed shares_max.

shares_max arrives from calc_concur_shares() as nr * tg_shares, where
nr = min(tg_tasks(tg), tg_cpus(tg)). tg_cpus() returns
cpuset_num_cpus(cgrp) unfloored, while its sibling tg_tasks() already
floors at 1. That asymmetry is the hole.

concur is the live mode here:

  $ cat /sys/kernel/debug/sched/cgroup_mode
  up smp (concur) max tasks

What I could NOT establish: that tg_cpus() actually returned 0, or what
would produce an empty effective cpuset. update_cpumasks_hier()
substitutes the parent's effective_cpus before storing; on this machine
no cgroup has an empty cpuset.cpus.effective and every
cpuset.cpus.partition reads "member". Twelve cgroups here have an empty
cpuset.cpus and all report effective = 0-15. I suspected a power daemon
that rewrites AllowedCPUs on the top-level systemd slices using an
empty-then-set idiom, but I could not make that yield an empty effective
mask, so I am not claiming it.

The missing floor looks like a hole regardless of what trips it, and I
would rather ask than guess: is there a path where cpuset_num_cpus() can
legitimately return 0, or should tg_cpus() simply floor at 1 the way
tg_tasks() does?

=== Proposed guard ===

Running locally on 7.2.0 for the past day. The WARN_ONCE in tg_cpus() is
deliberately diagnostic -- it confirms or refutes the cpuset route the
moment anyone reproduces this.

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ __calc_prop_weight
+	unsigned long div;
+
 	weight *= se->load.weight;
-	if (parent_entity(se))
-		weight /= cfs_rq->load.weight;
-	else
+	if (parent_entity(se)) {
+		div = cfs_rq->load.weight;
+		if (unlikely(!div)) {
+			WARN_ONCE(1, "sched: cfs_rq->load.weight == 0 (se->load.weight=%lu)\n",
+				  se->load.weight);
+			return MIN_SHARES;
+		}
+		weight /= div;
+	} else {
 		weight /= NICE_0_LOAD;
+	}

 	return max(weight, MIN_SHARES);

@@ __calc_smp_shares
-	return clamp_t(long, shares, MIN_SHARES, shares_max);
+	/* clamp() yields hi when hi < lo, defeating the MIN_SHARES floor. */
+	return clamp_t(long, shares, MIN_SHARES,
+		       max_t(long, shares_max, MIN_SHARES));

@@ tg_cpus
+	if (WARN_ONCE(nr < 1, "sched: tg_cpus() == 0, empty cpuset\n"))
+		nr = 1;
 	return nr;

=== Reproducer / caveats ===

Not reliably reproducible: one occurrence in ~11.7 h of idle uptime, and
none since. I have no better trigger than "leave it running".

The kernel is tainted G U C OE -- out-of-tree camera drivers are loaded
on this machine. I cannot categorically exclude memory corruption from
those. Against that: no prior WARNs, no slab or list corruption, no DMAR
faults, no EDAC events, and the two oopses 476 ms apart had byte-identical
register state, which a wild write would not reproduce exactly. I mention
it so nobody wastes time on a report I cannot fully vouch for.

Happy to test patches or run instrumented builds on the affected machine.

Config: CONFIG_FAIR_GROUP_SCHED=y, CONFIG_SCHED_AUTOGROUP=y,
CONFIG_SCHED_CLASS_EXT=y (sched_ext disabled, not in use),
CONFIG_X86_NATIVE_CPU=y, no CONFIG_SCHED_BORE, no SCHED_ALT.
Hardware: Intel Core Ultra X7 358H (Panther Lake), 16 CPUs.

Thanks,
Jake
