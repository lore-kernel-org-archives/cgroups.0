Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826734;
	b=4b8J49bcn5XuMR+KaqiioJnshbbvfpw81bT9yhLXKfwbL4mcLC7P3qwKi2RxXfLU5AJF
	 bGvjm+S8Dnb5Z8GQha4FMzW280/nk3uZAgV24Eif8r6nOmq305zsQa8xTZdybbb5Bager
	 LLz2wSmMaw5BWGGyDP7MFR0G0tAH1M9Z/ignrVSMAwfWjXhiJaGbEGX5Fdrv/1ocQQZra
	 AIN9JUEd/PgkTOfhMULrOEKbuBa30rxE6m/hOy+kKWg6ieYYQ5s6pFaiKSu5H8PPee+DO
	 gMjE6b9svmrtV0Ek/Vlu1hqDXkd39J/AHhI+YOMPVrytSOBDU7gTOG7yvsl5sYJoV1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826734;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=D54PK3YhAzxx4lADGAR62umvmIgPGnAdPLsdZkOo5ZQ=;
	b=iWV5wnAxBOfPbscgWYyhww0iN9xKYGuX352I7SfY3NPkabxqZKSQVUrnb8N8HslPzobK
	 gjtomB81RPHPVccOg4sLj5Q1HQl21/zyhwvng78x0bsYZZbuCwG8wt5qJDLdCZs+zVrQU
	 IgcNeiAUjfBf1fGT2L+7mXhYEPl4K6EL+NKUneFIYib/8pQtBlmmwohuAD/emmAa+BT1S
	 g/oX7dQ8L6/Vio+g0F/MyHAf8VI2WTv7mzInJlkZPoXjnW7kEwGDM3qEN8KTfqjgOKwNc
	 RrlDcKb7JBi7CPP+/DUWnZfMosD/Y9n5OPlQLQxGwcJDDISys1ivPbYNkt9gyeiqX8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="nBjJiS5/";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB2B60807BB;
	Wed,  4 Nov 2026 21:12:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AB2B60807BB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=nBjJiS5/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826732;
	bh=D54PK3YhAzxx4lADGAR62umvmIgPGnAdPLsdZkOo5ZQ=;
	h=From:To:Cc:Subject:Date:From;
	b=nBjJiS5/jqP8XI4hltW5pvsY9W9YtZTYzSPZwRPXq8mNm/VnQThARvP+LVoJ+kIHj
	 ylp7+ekB6GE4vl/+yEwFoRn6Z2ybXrULu2jzMjCgSUeqSMfJAoKwj9LiD3/lgjYqxw
	 VTSFZlSVWpLFDuGHmaVLq5Vb7cEwfuMIPH299a1Bb3T4fKGVDhzg/UdpyEYkoh4rSx
	 HvNBqRS6Mj/HzFiBSePLuWvY6XB8RIvVdtlu0518nYP16Gbvge7EwxcrxqzmdVN/z8
	 XLwMvCX3+1ghXVLlhrhPhqS16QgO9OwujB1vqYEZ07hXqEznZrM47bjJj861CXLBow
	 We+6iems+5ECg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRw3K2LzLcY;
	Wed, 04 Nov 2026 16:12:12 -0500 (EST)
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
Subject: [PATCH v2 00/21] sched/deadline: bandwidth accounting fixes and selftests
Date: Wed,  4 Nov 2026 16:11:46 -0500
Message-Id: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
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

Please find in this series seventeen fixes to SCHED_DEADLINE bandwidth
accounting, on top of your four in sched/urgent. Twenty-one patches:
the seventeen fixes, three that add the selftests catching them, and
one that shows a runqueue's deadline bandwidth in sched_debug. Nine of
the seventeen are new in v2, from the reviews of v1 and of the patches
those reviews brought; the changes are listed at the end.

One word before the details: I am at home with the concepts behind
SCHED_DEADLINE, but not with its implementation, and these patches were
written with an LLM assistant under my review ("How this was developed"
below). So I am asking those who know this code for a careful reading of
the fixes themselves. Most of them have a reproducer and were measured
in VMs, which says that the symptom goes away, not that the fix is the
one you would have written.

Three take the kernel down: a divide by zero in __dl_sub(), reachable
from a debugfs write to a fair server while its CPU goes offline or
comes online, a BUG() when a deadline task's affinity has no active CPU
left, which priority inheritance and CPU hotplug reach on a default
kernel, and a BUG() in the rebuild of the accounting for a task whose
isolated CPUs all went offline. One unlocks a cpuset_mutex it does not
hold. Two break the enforcement of a reservation: a throttled task
switched out of the class and back is left throttled with nothing to
replenish it, and a task whose replenishment timer stays armed from the
reservation it left is replenished at a time of that one. The other
eleven leave a root domain's total_bw, or a runqueue's this_bw, holding
what its tasks do not: the root domain then admits deadline tasks beyond
the capacity of its CPUs, or refuses every one of them and refuses to
offline its last CPU, and on the runqueue side the kernel warns of the
underflow.

They came out of a cgroup feature under development whose selftests hung
and flaked where the accounting drifts. Eight of the seventeen fail a
case of the selftests here, one more on a kernel built without cpusets,
five have standalone reproducers I can post, and three have none: patch
3 closes a window a test cannot time, patch 18 wants isolated CPUs
taken offline, and patch 20 a replenishment timed to the wrong period.

The fixes, by patch number
==========================

The four patches that are not fixes are missing from the list: 8, 10
and 14 add the selftests, 12 the sched_debug output.

 1  sched_setattr() with SCHED_FLAG_KEEP_PARAMS from SCHED_OTHER to
    SCHED_DEADLINE fails after reserving bandwidth that nothing gives
    back.
 2  SCHED_FLAG_KEEP_PARAMS keeps the policy as well, so a request that
    asks for another one is carried out by half and succeeds. On a task
    priority inheritance boosted into the deadline class the class does
    not change, so the request is admitted and reserves bandwidth the
    task never gets, nor releases.
 3  the same flag has the parameters read from the task with no lock
    held: a change of its own that lands in between leaves the request
    stale, and the admission moves total_bw and the runqueue's sums to a
    bandwidth the task does not have. Nothing is to be admitted for
    parameters that are kept.
 4  __dl_sub() and __dl_add() divide a change of total_bw by the number
    of active CPUs of the root domain, which is 0 while a CPU passes
    through the default one.
 5  dl_task_root_domain_cpu() BUG()s when a deadline task's mask has no
    active CPU, as a boosted mutex owner's does when its CPU goes
    offline.
 6  a throttled task switched out of SCHED_DEADLINE and back before its
    0-lag time is left throttled with nothing to replenish it: it never
    runs again, and a fatal signal cannot make it run.
 7  a sleeper leaving the class releases bandwidth the root domain no
    longer holds, or never held.
 9  a rebuild of the root domains' accounting (any cpuset partition
    change, CPU hotplug) forgets the bandwidth of the tasks that left
    the class, or died, before their 0-lag time: the inactive timer then
    removes it a second time, or from a root domain that never had it.
 11 a task whose wakeup is left to the target CPU has its bandwidth on
    no runqueue while task_cpu() already points at the destination: a
    parameter change meanwhile takes it off a runqueue that never held
    it, and this_bw underflows there for good.
 13 dl_rebuild_rd_accounting() is a stub without CONFIG_CPUSETS, so such
    a kernel loses the bandwidth of every deadline task at the first
    hotplug. A rebuild has nothing to serialize it against admission
    there either, where cpuset_mutex does not exist.
 15 three answers live side by side to "which root domain counts this
    task's bandwidth": the one of the CPU it is on (admission), the one
    of its cpuset (a rebuild of the accounting) and the one of the first
    active CPU of its own mask (a release, a move). They part ways where
    a CPU goes offline or a sleeping task is moved, and the bandwidth is
    then taken from a root domain that never had it. Every site that
    hands it out records a CPU of the root domain that counts it, and
    every site that takes it back or moves it reads that.
 16 a move takes a task's bandwidth off the root domain that counts it
    whenever the new mask leaves that root domain, on the strength of
    room nothing checks was made: a task that became a deadline task
    after cpuset_can_attach() counted them, and sched_setaffinity()
    with admission control off, have the room of no one. total_bw of a
    one-CPU partition root reaches 2^64 - 576716 that way.
 17 what cpuset_can_attach() set aside for a task that left the class,
    or died, before the attach stays in the destination's total_bw: 200
    moves of a task that flips its policy leave hundreds of thousands
    of units of a CPU behind. The tally of what the attach moved comes
    from the move itself, under the runqueue lock that decides it, so
    that CPU hotplug moving a task meanwhile cannot leave the
    reservation standing for bandwidth that stayed where it was.
 18 a rebuild of the accounting credits the bandwidth of a task that
    can run on housekeeping CPUs to the default root domain where an
    isolated CPU comes first in its mask, and BUG()s for a task whose
    isolated CPUs all went offline.
 19 the policy check of __sched_setscheduler() retries without clearing
    the flag that says it holds cpuset_mutex, so the exit path unlocks
    a cpuset_mutex that is someone else's by then. sched_setparam(),
    and sched_setattr() with SCHED_FLAG_KEEP_POLICY, reach it against a
    task leaving SCHED_DEADLINE.
 20 the replenishment timer of a task throttled before the end of its
    period stays armed where the task leaves the class and its
    parameters are cleared at its 0-lag time: back in the class, its
    next throttle does not reprogram that timer, and the replenishment
    comes at the period of the reservation it left.
 21 the runqueue a sleeping task is on counts none of the bandwidth the
    task gains where priority inheritance boosted it into the class:
    this_bw is then short of what running_bw takes at the wake-up,
    which the kernel warns about, and GRUB reclaims from sums that
    disagree.

Patch 1 moves the admission check last, where nothing between it and the
change can refuse the request after it reserved; patch 3 makes the leak
it fixes unreachable by a second route, and it keeps a refused request
from changing sched_reset_on_fork. Patch 12 gives sched_debug each
runqueue's this_bw and running_bw, which is what makes patch 11's bug
visible from userspace, and patches 8, 10 and 14 carry the selftests,
49 cases in three programs.

Patches 15 to 18 go together: 15 records the root domain that counts a
task's bandwidth, 16 and 17 are the two ways a cgroup attach moves or
strands bandwidth that record then exposes, and 18 is what a rebuild
does for a task no CPU of its root domain can hold. Patch 15 comes
after patch 9 because it rests on its record and generation; it is also
what makes the fallback of patch 5 moot, so that patch stands on its own
if you would rather take the crash fix alone. Patch 21 completes patch
11: where 11 left the bandwidth of a task waking elsewhere to the
enqueue to come, 21 hands it to the runqueue the task will wake on.

Testing
=======

In 8 QEMU guests of 8 vCPUs, the 49 cases pass on the series, every
time. No case fails on 4 vCPUs either, with PREEMPT_RT, with
CONFIG_SCHED_PROXY_EXEC on and off, or on a kernel built without
CONFIG_CPUSETS, where the cases that want a cpuset partition root skip.
No kernel warning in any run, in 16 guests over those five
configurations.

A bisect over the series, one kernel per patch that changes kernel code,
2 guests each and the same test binaries throughout, says what each
patch is worth in the suite:

    base  params_keep_class_change, params_keep_boosted,
          throttled_round_trip, pi_former_owner_asleep,
          dies_before_rebuild, switched_out_before_rebuild,
          moved_after_switch_out and random_mix fail
    +1    params_keep_class_change passes
    +2    params_keep_boosted passes
    +6    throttled_round_trip passes
    +7    pi_former_owner_asleep passes
    +9    the three rebuild cases and random_mix pass

params_waking needs patch 12's sched_debug sums to run at all: on a
kernel with patch 12 and without patch 11 it fails in 6 guests of 6, and
random_mix catches that bug too, in 1 of 3. Patch 13 shows in the five
hotplug cases of a kernel built without cpusets: three fail and two skip
for want of room without it, and the five pass with it. Patches 3, 4 and
5 move nothing in the suite, by design: patch 3 closes a window a test
cannot time, and an unfixed kernel dies on the other two, so their
reproducers stand apart.

That bisect covers the fifteen patches it was run over. Patches 16 and
17 came after it, from random_mix failing on a kernel carrying all
fifteen, and the suite passes with them as it did before. Patches 18 to
21 move nothing in it either; 19 and 21 have reproducers of their own,
the one of 19 reported by lockdep in under two seconds, and the one of
21 leaving this_bw of a runqueue at 157285 where 262142 is due.

How this was developed
======================

These patches, their messages and the tests were written by an LLM
coding assistant under my direction and review.

It started from the cgroup selftests of a feature I am developing, which
the assistant also wrote: one of them hung about once in 1350 runs, and
another failed about once in ten. Asking it to root-cause those two
flakes, rather than work around them, gave patches 6 and 9. Reviewing
your four fixes in sched/urgent with it gave patches 1 and 7. I then
asked for a selftest of the bandwidth accounting in its own right, and
for one area of coverage at a time: priority inheritance, parameter
changes, cpuset moves, deaths, sched_yield(), runtime overruns, GRUB
reclaiming, the fair servers, CPU hotplug, proxy execution, and a
randomized mix of all of them. That is deadline_bw_test, and building it
turned up patch 11, through the kernel's own this_bw underflow warning
under a parameter-change load, and patch 13, on a build without
cpusets. Patches 4 and 5 came from reading the code instead; their
reproducers were written afterwards, and each takes an unfixed kernel
down on the first round.

Patches 16 and 17 came out of the randomized case failing on its own
terms, which is what I wanted that case for.

Reviews of v1 and of the rework gave the rest, each one checked against
the code before anything was written; the ones that were already
answered by a later patch of the series were answered, not fixed twice.
The assistant got things wrong on the way as well: one diagnosis of
patch 11's bug was wrong twice over and was settled only by
instrumenting a kernel; one assertion it had put in a test was itself
racy and had to go; and the first shape of patch 15 wrote a flag under
one lock that the runqueue lock writes beside, which failed 14 VMs of
16 and is why patch 11 looks as it does. The per-patch bisect above
exists because I asked whether every fix had a reproducer of its own.

Changes since v1
================

Nine reviews of v1 by Sashiko AI, and one of the patches they brought by
a second model. The new patches, in the order of the series:

 - patches 2 and 3: a bandwidth leak through SCHED_FLAG_KEEP_PARAMS
   that patch 1 does not fix. On a task that priority inheritance
   boosted into the deadline class the class does not change, so the
   request is admitted and reserves bandwidth the kept parameters never
   give to the task: a SCHED_OTHER owner of a PTHREAD_PRIO_INHERIT
   mutex with a slice of 40ms, boosted by a deadline waiter, left 0.4
   of a CPU behind at every call. Patch 2 refuses a KEEP_PARAMS request
   that would change the policy, where only a change of class was
   refused before. That is an ABI change, so say if you would rather
   keep accepting it. New selftest case params_keep_boosted;
 - patch 7 (v1's 5) cleared the parameters of a task leaving the class,
   and that task can be the donor of a priority inheritance boost until
   the chain walk of rt_mutex_adjust_pi(). A replenishment of the
   boosted owner in that window would never leave its loop over a
   dl_period and a dl_runtime of 0, with the runqueue lock held and
   interrupts off. It clears the task's bandwidth alone now, which is
   what the double release needed; shown with a kernel carrying
   mdelay(20) in that window, which warns in replenish_dl_entity() and
   stops with the parameters cleared, and survives without;
 - patch 9 gained a generation counter, so that a release which follows
   a rebuild that dropped the task's bandwidth takes nothing;
 - patch 11 is a different fix from v1's 9: the bit that says a
   runqueue counts a task's bandwidth lives inside add_rq_bw() and
   sub_rq_bw(), which are idempotent now;
 - patch 13 gained dl_accounting_mutex, since without CONFIG_CPUSETS
   nothing serializes a rebuild of the accounting against admission;
 - patch 15 records the root domain that counts a task's bandwidth,
   because the fallback of patch 5 can point at one the last rebuild
   had not credited. A deadline task pinned to a CPU that goes offline,
   with admission control off, leaves its bandwidth behind in the root
   domain it was counted in without it: total_bw 471853 where 366996
   is due, the task's 10% of a CPU;
 - patches 16 and 17, the two ways a cgroup attach moves bandwidth no
   one made room for, or strands what it set aside;
 - patch 18, the rebuild of the accounting against isolated CPUs;
 - patches 19 and 20, two bugs of the baseline that the review of v1
   reported without tying them to a patch of it: the unbalanced
   cpuset_unlock(), which patch 13 would double, and the replenishment
   timer left armed. Patch 19's reproducer is a policy flipper against
   sched_setattr(SCHED_FLAG_KEEP_POLICY), which lockdep reports in
   under two seconds;
 - patch 21, the runqueue side of a task priority inheritance boosted
   into the class.

Also, in the selftest: the fair servers are put back after the 0-lag
times of the randomized mix's workers rather than before, where a
decrease of a server can be refused for want of room, which failed
random_mix about one run in ten; the error handling of every helper it
has; a settings file, since the suite takes longer than the 45 seconds
of the kselftest default; and the hotplug case of a departed task
offlines the CPU it checked it could, rather than the one the task last
ran on.

Two things the reviews turned up that this series does not change:

 - a rebuild drops the bandwidth of a departed task where the CPU
   recorded for it is no longer active, even where its root domain
   lives on. Fixing it means recording the root domain rather than a
   CPU, which root domains being freed and rebuilt does not make cheap.
   The undercount is bounded by the task's 0-lag time, and the
   generation of patch 9 keeps the release out, so nothing underflows;
 - sched_setscheduler() of a task that priority inheritance boosted
   into the deadline class to any policy outside it returns -EBUSY:
   sched_dl_overflow() has no branch for a task of the class with
   another policy, and its caller takes -1 for a refusal. Long-standing,
   and untouched here.

Based on tip sched/urgent, at commit a2b67e904401 ("sched/deadline:
Reject SCHED_DEADLINE on exited tasks"); patch 7 builds on
commit 41a7968022ca ("sched/deadline: Fix total_bw leak when switching
away from SCHED_DEADLINE while !queued") there.

Mathieu Desnoyers (21):
  sched: Reject SCHED_FLAG_KEEP_PARAMS before reserving deadline
    bandwidth
  sched: Refuse SCHED_FLAG_KEEP_PARAMS that would change the policy
  sched/deadline: Do not admit bandwidth for parameters that are kept
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
  sched/deadline: Record the root domain holding a task's bandwidth
  sched/deadline: Move a task's bandwidth only where room was made
  cgroup/cpuset: Give back the bandwidth an attach did not move
  sched/deadline: Credit a rebuild to a CPU that can hold the bandwidth
  sched: Clear cpuset_locked where the policy check retries
  sched/deadline: Cancel the replenishment timer with the parameters
  sched/deadline: Count the bandwidth a boosted task is given

 include/linux/cpuset.h                        |    5 -
 include/linux/sched.h                         |   22 +
 include/linux/sched/deadline.h                |   21 +-
 kernel/cgroup/cpuset-internal.h               |    2 +
 kernel/cgroup/cpuset.c                        |   51 +-
 kernel/sched/core.c                           |   19 +
 kernel/sched/deadline.c                       |  551 ++-
 kernel/sched/debug.c                          |    2 +
 kernel/sched/sched.h                          |    4 +
 kernel/sched/syscalls.c                       |   71 +-
 tools/testing/selftests/sched/.gitignore      |    3 +
 tools/testing/selftests/sched/Makefile        |    1 +
 .../selftests/sched/deadline_bw_test.c        | 3353 +++++++++++++++++
 .../selftests/sched/deadline_rebuild_test.c   |  462 +++
 .../selftests/sched/deadline_switch_test.c    |  332 ++
 tools/testing/selftests/sched/settings        |    1 +
 16 files changed, 4782 insertions(+), 118 deletions(-)
 create mode 100644 tools/testing/selftests/sched/deadline_bw_test.c
 create mode 100644 tools/testing/selftests/sched/deadline_rebuild_test.c
 create mode 100644 tools/testing/selftests/sched/deadline_switch_test.c
 create mode 100644 tools/testing/selftests/sched/settings

-- 
2.47.3

