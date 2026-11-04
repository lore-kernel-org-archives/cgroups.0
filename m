Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805148;
	b=Og14s+Co5Lj8AfLek/eBU7jpUEEA7uIk+mDNfnnXe/SaJ+zI47vcWevFk9/4iUeFo2gs
	 vz8gHTbZCN2j/Xly+JbpI58uwUzis4MZBSaBK8gLPdZ7Gzi9m1M/ceqStyc5Feo6gZj1O
	 aVbE3e/Ti5SNnxrvaYYIWTkBn6HAExtFG3rcCk4h22ZGhWUEiqB9AcIokznaltVdh6T8Y
	 Jea5iqPQvYM0EXsR3UllXvrdPu9FhkaXYBeMRp/mZyrc2lvHccCfBmOAyVZ/+LMqo6MVj
	 5Pl8MpLJaauUwaEH4r877BNQ6/0LId2fhculS4UzQo3ESApGptTHq77qlfmBJ1uJpVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805148;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=1WifN4Li6a8D9FqduVQsQB+fC0xh/CftAMYCyNFReVc=;
	b=NwVgfDaYHuVpQVVGA4ZexGshSH5RgWngLjLCb09LoABzAAKYLmjI5eRV+TQ5MBbPTOVu
	 FvJkgRzVa7+i4Y8UMfsocTLLIqb3Ev+O7B8U8VZgeC0FBxLqJnzY92Jd48xLGgjODu8wQ
	 VlziPs3Hg+3eAC8ZwZM3QYbm8OEIIZSFHnuQQZzvTZZPF7wxPxD2eUnykYAYQdY0DAtZv
	 aR8pEuxt1BaYjuMdwZq+6A3blDyXDNqthUmq99+GuEkmNKVBC/FnJ+rGb49M7GWdlVxk6
	 nPJrcNHpVie7UpxisMvHTAV/rRt1V6dU+7cXnBX1/Ls4yCt5OBS4Fr1L9JB9VgEOtYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=TDotd4ZQ;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D99606A32F;
	Wed,  4 Nov 2026 15:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12D99606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=TDotd4ZQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793805139;
	bh=1WifN4Li6a8D9FqduVQsQB+fC0xh/CftAMYCyNFReVc=;
	h=From:To:Cc:Subject:Date:From;
	b=TDotd4ZQ6tUxwkNKJO/8ahIw2C5IYKguciLPdQGq6YWkVVwLPgON5auaPlcy5mXtV
	 phvx7v9MRFoFIYjp96ZE28x3kdBKyVMWpYsl5YMn1nIKvAkj1doR2CnB0rTws1Vwp6
	 u8HtXp5PXvERe82vFAOv0lbQ2bpNVrZt9Yrzm24gQzq/JTwVAUMwFyLiYICMDLpz9b
	 abS3x7OrnIeMDKVHd1hMCoeXUiUy28UkcspZnm8/miQmX4+JbdpULRsk9ok9ogFa3u
	 b/JoB7KuCF7COl6ZPxSrWyVVNQENqSkSgVG4TkmfANL3PBaYwW1tqDiafVula2gvHt
	 8wBibaFqR6hHA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKTSg5TDczJqv;
	Wed, 04 Nov 2026 10:12:19 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Claudio Scordino <claudio@evidence.eu.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH 00/12] sched/deadline: bandwidth accounting fixes and selftests
Date: Wed,  4 Nov 2026 10:10:21 -0500
Message-Id: <cover.1793804635.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Juri,

Please find in this series eight fixes to SCHED_DEADLINE bandwidth
accounting, on top of your four in sched/urgent, with the selftests that
catch them.

One word before the details: I am at home with the concepts behind
SCHED_DEADLINE, but not with its implementation, and these patches were
written with an LLM assistant under my review ("How this was developed"
below). So I am asking those who know this code for a careful reading of
the fixes themselves. Each of them has a reproducer and was measured in
VMs, which says that the symptom goes away, not that the fix is the one
you would have written.

Two take the kernel down: a divide by zero in __dl_sub(), reachable from
a debugfs write to a fair server while its CPU goes offline or comes
online, and a BUG() when a deadline task's affinity has no active CPU
left, which priority inheritance and CPU hotplug reach on a default
kernel. The other six leave a root domain's total_bw, or a runqueue's
this_bw, holding what its tasks do not: the root domain then admits
deadline tasks beyond the capacity of its CPUs, or refuses every one of
them and refuses to offline its last CPU, and on the runqueue side the
kernel warns of the underflow.

They came out of a cgroup feature under development whose selftests hung
and flaked where the accounting drifts. Each fix has a reproducer: five
fail a case of the selftests here, one needs a kernel built without
cpusets, and the two that crash have standalone reproducers I can post.

The fixes
=========

 1  sched_setattr() with SCHED_FLAG_KEEP_PARAMS from SCHED_OTHER to
    SCHED_DEADLINE fails after reserving bandwidth that nothing gives
    back.
 2  __dl_sub() and __dl_add() divide a change of total_bw by the number
    of active CPUs of the root domain, which is 0 while a CPU passes
    through the default one.
 3  dl_task_root_domain_cpu() BUG()s when a deadline task's mask has no
    active CPU, as a boosted mutex owner's does when its CPU goes
    offline.
 4  a throttled task switched out of SCHED_DEADLINE and back before its
    0-lag time is left throttled with nothing to replenish it: it never
    runs again, and a fatal signal cannot make it run.
 5  a sleeper leaving the class releases bandwidth the root domain no
    longer holds, or never held.
 7  a rebuild of the root domains' accounting (any cpuset partition
    change, CPU hotplug) forgets the bandwidth of the tasks that left
    the class, or died, before their 0-lag time: the inactive timer then
    removes it a second time, or from a root domain that never had it.
 9  a task whose wakeup is left to the target CPU has its bandwidth on
    no runqueue while task_cpu() already names the destination: a
    parameter change meanwhile takes it off a runqueue that never held
    it, and this_bw underflows there for good.
 11 dl_rebuild_rd_accounting() is a stub without CONFIG_CPUSETS, so such
    a kernel loses the bandwidth of every deadline task at the first
    hotplug.

Patch 10 is not a fix: sched_debug gains each runqueue's this_bw and
running_bw, which is what makes patch 9's bug visible from userspace.
Patches 6, 8 and 12 are the selftests, 48 cases in three programs.

Testing
=======

In 8 QEMU guests of 8 vCPUs, the 48 cases pass on the series, every
time. No case fails on 4 vCPUs either, with PREEMPT_RT, with
CONFIG_SCHED_PROXY_EXEC on and off, or on a kernel built without
CONFIG_CPUSETS, where the cases that want a cpuset partition root skip.
No kernel warning in any run.

A bisect over the series, one kernel per patch that changes kernel code,
2 guests each and the same test binaries throughout, says what each
patch is worth in the suite:

    base  params_keep_class_change, throttled_round_trip,
          pi_former_owner_asleep, dies_before_rebuild,
          switched_out_before_rebuild, moved_after_switch_out and
          random_mix fail
    +1    params_keep_class_change passes
    +4    throttled_round_trip passes
    +5    pi_former_owner_asleep passes
    +7    the three rebuild cases and random_mix pass

params_waking needs patch 10's sched_debug sums to run at all: on a
kernel with patch 10 and without patch 9 it fails in 6 guests of 6, and
random_mix catches that bug too, in 1 of 3. Patch 11 shows in the five
hotplug cases of a kernel built without cpusets: three fail and two skip
for want of room without it, and the five pass with it. Patches 2 and 3
move nothing in the suite, by design: an unfixed kernel dies, so their
reproducers stand apart.

How this was developed
======================

These patches, their messages and the tests were written by an LLM
coding assistant under my direction and review.

It started from the cgroup selftests of a feature I am developing, which
the assistant also wrote: one of them hung about once in 1350 runs, and
another failed about once in ten. Asking it to root-cause those two
flakes, rather than work around them, gave patches 4 and 7. Reviewing
your four fixes in sched/urgent with it gave patches 1 and 5. I then
asked for a selftest of the bandwidth accounting in its own right, and
for one area of coverage at a time: priority inheritance, parameter
changes, cpuset moves, deaths, sched_yield(), runtime overruns, GRUB
reclaiming, the fair servers, CPU hotplug, proxy execution, and a
randomized mix of all of them. That is deadline_bw_test, and building it
turned up patch 9, through the kernel's own this_bw underflow warning
under a parameter-change load, and patch 11, on a build without
cpusets. Patches 2 and 3 came from reading the code instead; their
reproducers were written afterwards, and each takes an unfixed kernel
down on the first round.

A second model reviewed the series, and its findings are folded in. The
assistant got things wrong on the way as well: one diagnosis of patch
9's bug was wrong twice over and was settled only by instrumenting a
kernel, and one assertion it had put in a test was itself racy and had
to go. The per-patch bisect above exists because I asked whether every
fix had a reproducer of its own.

Based on tip sched/urgent, at commit a2b67e904401 ("sched/deadline:
Reject SCHED_DEADLINE on exited tasks"); patch 5 builds on
commit 41a7968022ca ("sched/deadline: Fix total_bw leak when switching
away from SCHED_DEADLINE while !queued") there.

Mathieu Desnoyers (12):
  sched: Reject SCHED_FLAG_KEEP_PARAMS before reserving deadline
    bandwidth
  sched/deadline: Do not divide by zero active CPUs of a root domain
  sched/deadline: Do not BUG() on a deadline task with no active CPU
    allowed
  sched/deadline: Do not lose a throttled task switched out and back
  sched/deadline: Do not release a departing sleeper's bandwidth twice
  selftests/sched: Add a test of SCHED_DEADLINE policy round trips
  sched/deadline: Keep departing bandwidth across a root domain rebuild
  selftests/sched: Test SCHED_DEADLINE bandwidth across a root domain
    rebuild
  sched/deadline: Do not take a waking task's bandwidth off a runqueue
    it left
  sched/debug: Show the deadline bandwidth of each runqueue
  sched/deadline: Rebuild the root domains' accounting without cpusets
    too
  selftests/sched: Add a test of SCHED_DEADLINE bandwidth accounting

 include/linux/cpuset.h                        |    5 -
 include/linux/sched.h                         |   15 +
 include/linux/sched/deadline.h                |    6 +-
 kernel/cgroup/cpuset.c                        |   11 +-
 kernel/sched/deadline.c                       |  316 +-
 kernel/sched/debug.c                          |    2 +
 kernel/sched/syscalls.c                       |   24 +-
 tools/testing/selftests/sched/.gitignore      |    3 +
 tools/testing/selftests/sched/Makefile        |    1 +
 .../selftests/sched/deadline_bw_test.c        | 3182 +++++++++++++++++
 .../selftests/sched/deadline_rebuild_test.c   |  462 +++
 .../selftests/sched/deadline_switch_test.c    |  332 ++
 12 files changed, 4292 insertions(+), 67 deletions(-)
 create mode 100644 tools/testing/selftests/sched/deadline_bw_test.c
 create mode 100644 tools/testing/selftests/sched/deadline_rebuild_test.c
 create mode 100644 tools/testing/selftests/sched/deadline_switch_test.c

-- 
2.47.3

