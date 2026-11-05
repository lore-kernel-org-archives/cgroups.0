Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907262;
	b=WzgU/WsGd8Bu8QlSngtkF9MHswuryZUUMFLWXSGSXRTgSe6m+oCAkrULOWFCoHGXUjWE
	 dOZD5eBph5gGoG9MyGIoMDUDrd2o2fbn6XZwHA1PwANXjHUE15y9+DTX5zkeVc2HwqQJI
	 gJ+jTFANHSiN1ZNlXHtMwMjeottP6FCTGc7Fb/HCcD2DqzTnLNMLrS7POdQoykbSe0raO
	 M6pGymUg7MCP2alp424NYGE35wzSRCmwoxAXK7fOjcnQwQThEx5Gs8xv5UJH0UII0HO1Y
	 Ct/V2sTUaMZ4WVMea+sPoUS9bzuXqzEvgaNPwSsnPOo4lOzzQFbxOf2bD5UCv62BWww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907262;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ALQVmpGmJYy91vPXOvpxuLKcHkl5/CqXJpjQeRJCP6o=;
	b=eZxEjusHr1gyhbT+a6plTG032RfbX1yCO1JEMSbJoc9iSFonw8oqsdQ5ifzbAcQ7hW4X
	 gPWM1eObsr2DV6iCaCdxFPRpYz47kIkzPrTU8fYZjUisZ9kWpBrI1Ly+v7yTqm0W2BIvg
	 iTGh6HhRXVFr3ZaQn6y8RCvNWDPIkFYLgIZGloPH0zS42A8KMnoukMSoyeBoKHk96FAS7
	 /9UgWGKbTgbk3TqBOVj2gdvMO4SExrHxsErFDsNn0Eh+MCZZn1nGl5Wc8romJGZGN3ijl
	 szGtR7yNmWxNSmdJ3b5Uda1TlVGdcZ5pr1wAiIZGIQTJdj3tYCjjsFezwitRiMd2rbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=v9taVX8K;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10747606B04E;
	Thu,  5 Nov 2026 19:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10747606B04E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=v9taVX8K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907248;
	bh=ALQVmpGmJYy91vPXOvpxuLKcHkl5/CqXJpjQeRJCP6o=;
	h=From:To:Cc:Subject:Date:From;
	b=v9taVX8KOk8gS/3WvNy4cug4v8JKAWJLkzykLVb/eBVG9OfMHfNxKnFYXx0C6aEyO
	 FJm5CpfUmdNeXlmyvIlToz9u+J0z/7fTYgtiRWouMmOKQ9ZPvUA8Ykd+Jav0jEYZf4
	 OiLHhgmeKns3vWe+fXBHwl+o3ZzU6CdnCGmiJ/9HxOWJDGPMqZOP+ExmlRFo8Dh5FE
	 drUT8eEDethL5Zn83OtPW1F8DeJaqDrFHHp0od9RwXvLbo2sXCGJ+PleAhhV97o9I7
	 Hjb64jgHoU+CuhmFp8e1C4z8Rlm8Z7hU171WF8yq5ElVFyTf1ZxaPKcplAYQYII8Lk
	 +rfH0WYJ3V93g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDJ65zjzLvm;
	Thu, 05 Nov 2026 14:34:08 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	parri.andrea@gmail.com,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v3 00/24] sched/deadline: bandwidth accounting fixes and selftests
Date: Thu,  5 Nov 2026 14:33:35 -0500
Message-Id: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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

Hi Ingo, Juri,

Please find in this series twenty fixes to SCHED_DEADLINE bandwidth
accounting on v7.4-rc1, followed by the sched_debug output of a
runqueue's deadline bandwidth and the three selftests that catch the
fixes: twenty-four patches, the fixes first, as you asked, so that
stable can take patches 1 to 20 and stop.

Patch 1 is Andrea Parri's fix of the cpuset_mutex double unlock, posted
on Nov 2 and reviewed by Waiman, Kayra and Juri, carried here unchanged
with its tags because patch 13 builds on it; v2's patch 19 was the same
fix. Take it from whichever route you prefer.

This revision replaces your four fixes of sched/urgent, Juri, which Ingo
dropped after the first of them crashed Marek Szyprowski's hotplug test.
They went four ways. The stale root domain of a cpuset transfer (1/4) is
fixed by patch 14, which records the root domain that counts a task's
bandwidth instead of deriving it from the task's mask, and reports to
Weiheng Qiu's thread; a mask has no active CPU during hotplug, which is
what crashed. The total_bw leak of a task leaving the class asleep (2/4)
is patch 8, reworked with the v2 fix of the double release it caused,
and without your Signed-off-by, which is yours to add back. The
KEEP_PARAMS refusal (3/4) is patch 2, with the v2 fixes of its placement
and of the policy change it let through. The refusal of SCHED_DEADLINE
on exited tasks (4/4) is patch 9, yours, extended to a task of the class
leaving it, which decrements its cpuset's count of deadline tasks a
second time. Marek tested v2 on the board that crashed, and found it
fixed; v3 differs enough that his Tested-by is not on a patch.

One word before the details: I am at home with the concepts behind
SCHED_DEADLINE, but not with its implementation, and these patches were
written with an LLM assistant under my review ("How this was developed"
below). So I am asking those who know this code for a careful reading of
the fixes themselves. Most of them have a reproducer and were measured
in VMs, which says that the symptom goes away, not that the fix is the
one you would have written.

Of the twenty fixes, two take the kernel down: a divide by zero in
__dl_sub(), reachable from a debugfs write to a fair server while its
CPU goes offline or comes online, and a BUG() in the rebuild of the
accounting for a task whose isolated CPUs all went offline. Two leave
cpuset_mutex in a state that no deadline task can be admitted after: a
double unlock, and sysrq-n sleeping under tasklist_lock and keeping the
mutex. Three break the enforcement of a reservation: a throttled task
switched out of the class and back is left throttled with nothing to
replenish it, a task that comes back after its 0-lag time runs on the
deadline and runtime of the reservation it gave back, and a task whose
replenishment timer stays armed from that reservation is replenished at
a time of it. The other thirteen leave a root domain's total_bw, or a
runqueue's this_bw, holding what its tasks do not: the root domain then
admits deadline tasks beyond the capacity of its CPUs, or refuses every
one of them and refuses to offline its last CPU, and on the runqueue
side the kernel warns of the underflow.

The fixes, by patch number
==========================

 1  the policy check of __sched_setscheduler() retries without clearing
    the flag that says it holds cpuset_mutex, so the exit path unlocks
    a cpuset_mutex that is someone else's by then (Andrea Parri).
 2  sched_setattr() with SCHED_FLAG_KEEP_PARAMS carries out by half a
    request for another policy or another class: a class change runs
    switched_from_dl() on a task that stays in the class, and a request
    for SCHED_DEADLINE on a task that priority inheritance boosted into
    the class is admitted, reserving bandwidth the task never gets nor
    releases. Refused, before the reservation.
 3  the same flag has the parameters read from the task with no lock
    held: a change of its own that lands in between leaves the request
    stale, and the admission moves total_bw and the runqueue's sums to a
    bandwidth the task does not have. Nothing is to be admitted for
    parameters that are kept.
 4  __dl_sub() and __dl_add() divide a change of total_bw by the number
    of active CPUs of the root domain, which is 0 while a CPU passes
    through the default one; the debugfs write that reaches it is
    refused while the CPU is inactive, as it is once offline.
 5  __sched_setscheduler() takes cpuset_mutex for a deadline policy and
    releases it only with pi set: normalize_rt_tasks() takes it under
    tasklist_lock and keeps it. Taken only with pi, as before v6.5.
 6  a throttled task switched out of SCHED_DEADLINE and back before its
    0-lag time is left throttled with nothing to replenish it: it never
    runs again, and a fatal signal cannot make it run.
 7  __dl_clear_params() leaves the deadline and the runtime of the
    period a task left: back after its 0-lag time and before that
    deadline, it runs on the reservation it gave back.
 8  a task that leaves the class asleep, no inactive timer pending,
    keeps its bandwidth in total_bw for good. Released there, with the
    state of its period; the parameters stay for a boosted owner that
    may still read them.
 9  sched_setattr(SCHED_DEADLINE) on a zombie reserves bandwidth nothing
    releases, and a zombie of the class switched out of it is taken off
    its cpuset's count of deadline tasks a second time, after which a
    rebuild skips the cpuset. Both refused with ESRCH.
 10 a rebuild of the root domains' accounting (any cpuset partition
    change, CPU hotplug) forgets the bandwidth of the tasks that left
    the class, or died, before their 0-lag time: the inactive timer then
    removes it a second time, or from a root domain that never had it.
 11 a task whose wakeup is left to the target CPU has its bandwidth on
    no runqueue while task_cpu() already points at the destination: a
    parameter change meanwhile takes it off a runqueue that never held
    it, and this_bw underflows there for good.
 12 dl_rebuild_rd_accounting() is a stub without CONFIG_CPUSETS, so such
    a kernel loses the bandwidth of every deadline task at the first
    hotplug. A rebuild has nothing to serialize it against admission
    there either, where cpuset_mutex does not exist: a mutex of the
    deadline code's own, held from the attachment of the new root
    domains to the rebuild, as cpuset_mutex is.
 13 the walks of a rebuild can find a task at its last schedule, between
    the release of its bandwidth and the reset of its dl_bw, and count
    in a root domain just cleared a bandwidth nothing releases again.
 14 three answers live side by side to "which root domain counts this
    task's bandwidth": the one of the CPU the task is on (admission, a
    release), the one of the runqueue it is on (a move) and the one of
    its cpuset (a rebuild). They part ways where a sleeping task is
    moved or a CPU goes offline, and the bandwidth is then taken from a
    root domain that never had it. Every site that hands it out records
    a CPU of the root domain that counts it, and every site that takes
    it back or moves it reads that.
 15 a move takes a task's bandwidth off the root domain that counts it
    whenever the new mask leaves that root domain, on the strength of
    room nothing checks was made: a task that became a deadline task
    after cpuset_can_attach() counted them, and sched_setaffinity()
    with admission control off, have the room of no one. total_bw of a
    one-CPU partition root reaches 2^64 - 262144 that way.
 16 a rebuild of the sched domains from the sched_rt_runtime_us sysctl
    or the energy model runs between cpuset_can_attach() and
    cpuset_attach(), where the former's reservation is gone and the
    move goes through on its strength. The rebuild waits for the attach,
    as the writes of a cpuset's files do.
 17 what cpuset_can_attach() set aside for a task that left the class,
    or died, before the attach stays in the destination's total_bw: 200
    moves of a task that flips its policy leave hundreds of thousands
    of units of a CPU behind. The tally of what the attach moved comes
    from the move itself, under the runqueue lock that decides it.
 18 a rebuild of the accounting takes the first active CPU of a task's
    cpuset, which is an isolated one of the default root domain where
    the cpuset holds both, is none for a task whose isolated CPUs all
    went offline, which BUG()s, and is not where
    dl_task_offline_migration() moved a task. It takes the CPU recorded
    with the bandwidth where the cpuset still allows it, and a
    housekeeping CPU of the cpuset's otherwise.
 19 the replenishment timer of a task throttled before the end of its
    period stays armed where the task leaves the class and its
    parameters are cleared at its 0-lag time: back in the class, its
    next throttle does not reprogram that timer, and the replenishment
    comes at the period of the reservation it left.
 20 the runqueue a sleeping task is on counts none of the bandwidth the
    task gains where priority inheritance boosted it into the class:
    this_bw is then short of what running_bw takes at the wake-up,
    which the kernel warns about, and GRUB reclaims from sums that
    disagree.

Patch 21 gives sched_debug each runqueue's this_bw and running_bw, which
is what makes patch 11's bug visible from userspace, and patches 22 to
24 carry the selftests, 52 cases in three programs, in a directory of
their own, tools/testing/selftests/sched/deadline, as Juri suggested.

Patches 14 to 18 go together: 14 records the root domain that counts a
task's bandwidth, 15 and 17 are the two ways a cgroup attach moves or
strands bandwidth that record then exposes, 16 the rebuild that runs
through an attach, and 18 what a rebuild does with the record. Patch 14
comes after patch 10 because it rests on its list and generation. Patch
20 completes patch 11: where 11 left the bandwidth of a task waking
elsewhere to the enqueue to come, 20 hands it to the runqueue the task
will wake on.

Testing
=======

In 8 QEMU guests of 8 vCPUs, the 52 cases pass on the series, every
time. No case fails on 4 vCPUs either, with PREEMPT_RT, with
CONFIG_SCHED_PROXY_EXEC on and off, or on a kernel built without
CONFIG_CPUSETS, where the cases that want a cpuset partition root skip.
No kernel warning in any run, in 16 guests over those five
configurations, lockdep on in every kernel.

On v7.4-rc1, the same binaries fail ten cases of deadline_bw_test
(pi_former_owner_asleep, params_keep_class_change, params_keep_boosted,
move_asleep, move_non_contending, move_vs_rebuild,
death_zombie_switched, overrun_caught, random_mix and hotplug_departed),
the three of deadline_rebuild_test and the three of
deadline_switch_test, in 4 guests of 4, with kernel warnings in each;
params_waking skips for want of the sched_debug sums.
Built without cpusets, v7.4-rc1 fails hotplug_sleepers,
hotplug_departed and hotplug_server_refused, and skips the two other
hotplug cases for want of room, which patch 12 fixes.

One kernel per patch where a message claims one: the two round trips of
deadline_switch_test pass from patch 8 on, the three cases of
deadline_rebuild_test fail up to patch 9 and pass from patch 10,
move_vs_rebuild fails in 4 guests of 4 at patch 15 and passes at 16,
and the moves of cs_race leave bandwidth behind in 4 guests of 10 up to
patch 16 and in none of 6 at 17.

The eight standalone reproducers of v2 (the divide by zero, the mask
with no active CPU, the KEEP_PARAMS leak, the donor window, the cpuset
move race, the root domain of a departed task, the boosted task's
this_bw and the double unlock) pass on the series in 6 guests of 6. On
v7.4-rc1: the KEEP_PARAMS leak is 419424 -> 838854 of total_bw at one
call, the move race wraps a partition's total_bw to 2^64 - 262144 in
200 moves, the departed task leaves 104857 behind in the root domain it
left (471853 where 366996 is due), the double unlock reports "bad
unlock balance detected!", and the divide by zero oopses on the first
round; the mask with no active CPU is a bug of the dropped fixes, and
v7.4-rc1 survives it.

How this was developed
======================

These patches, their messages and the tests were written by an LLM
coding assistant under my direction and review.

It started from the cgroup selftests of a feature I am developing, which
the assistant also wrote: one of them hung about once in 1350 runs, and
another failed about once in ten. Asking it to root-cause those two
flakes, rather than work around them, gave patches 6 and 10. Reviewing
your four fixes of sched/urgent with it, Juri, gave patches 2 and 8. I
then asked for a selftest of the bandwidth accounting in its own right,
and for one area of coverage at a time: priority inheritance, parameter
changes, cpuset moves, deaths, sched_yield(), runtime overruns, GRUB
reclaiming, the fair servers, CPU hotplug, proxy execution, and a
randomized mix of all of them. That is deadline_bw_test, and building it
turned up patch 11, through the kernel's own this_bw underflow warning
under a parameter-change load, and patch 12, on a build without
cpusets. Patch 4 came from reading the code instead; its reproducer was
written afterwards, and takes an unfixed kernel down on the first round.
Patches 15 and 17 came out of the randomized case failing on its own
terms, which is what I wanted that case for.

Reviews of v1 and v2 by Sashiko AI, and of the reworks by a second
model, gave the rest, each finding checked against the code before
anything was written; the ones that were already answered by a later
patch of the series were answered, not fixed twice. The assistant got
things wrong on the way as well: one diagnosis of patch 11's bug was
wrong twice over and was settled only by instrumenting a kernel; one
assertion it had put in a test was itself racy and had to go; the first
shape of patch 14 wrote a flag under one lock that the runqueue lock
writes beside, which failed 14 VMs of 16 and is why patch 11 looks as
it does; and the first two shapes of the move_vs_rebuild case measured
the wrong thing and then raced nothing, until the moved process got
enough threads for a rebuild to land between the two cpuset callbacks.

Changes since v2
================

The base is v7.4-rc1, where tip sched/urgent is now, without the four
fixes v2 was built on; what became of each is at the top, and Andrea
Parri's fix is patch 1. Juri's Reviewed-by on v2's patches 1 and 2
carries over to patch 2, which merges the two with his 3/4, and to
patch 3.

From the Sashiko AI review of v2 (17 findings) and Juri's replies, each
checked against the code first:

 - patch 4 refuses the debugfs write of a fair server while its CPU is
   inactive, as Juri asked, rather than let it reach __dl_sub() with no
   CPU to spread the change over; the guard stays for the paths that
   have no write to refuse;
 - patch 5 (new): sysrq-n leaves cpuset_mutex locked for good, found
   from the review of patch 12's lock, and a baseline bug since v6.5;
 - patch 7 (new): the deadline and the runtime of the period a task
   left survive __dl_clear_params(), so a return before that deadline
   runs on the reservation it gave back, which patch 6 made a period
   wide. Juri read it as a bounded overrun to handle separately; the
   fix is two lines, so it is here;
 - patch 8 clears the state of the period with the bandwidth it
   releases, the throttle, the yield, the flags, the deadline and the
   runtime, and keeps the three parameters the donor window needs;
 - patch 9 (Juri's 4/4) also refuses to switch an exited task of the
   class to another policy, which ran switched_from_dl() and took it
   off its cpuset's count of deadline tasks a second time;
 - patch 12 takes its mutex in partition_sched_domains(), from the
   attachment of the new root domains, where dl_rebuild_rd_accounting()
   took it too late for an admission racing it;
 - patch 13 (new): both walks of a rebuild can find a task at its last
   schedule, between its release and the reset of its dl_bw, and leak
   what they count;
 - patch 14 refreshes three comments and gives no record to a boosted
   task with no bandwidth of its own;
 - patch 15 takes SCA_ bit 0x20: Andrea Parri's "sched/deadline: Check
   SCHED_DEADLINE affinity under the rq lock" takes 0x10;
 - patch 16 (new): a rebuild from the sched_rt_runtime_us sysctl or the
   energy model runs through an attach, between cpuset_can_attach() and
   cpuset_attach();
 - patch 18 is reworked around the record: the housekeeping filter of
   v2 lagged a cpuset partition change and stripped the isolated CPUs
   of a task whose affinity also named an offline housekeeping CPU, and
   the early return dropped a task that dl_task_offline_migration() had
   moved. A rebuild now credits the CPU recorded with the bandwidth
   where the cpuset still allows it;
 - patch 19 cancels the replenishment timer where patch 8 releases as
   well;
 - patch 20 tests the flags of the request rather than the entity's
   old ones, so a sugov kthread given a reservation of its own gets it
   counted;
 - v2's patch 5, the fallback for a mask with no active CPU, is gone
   with the fix it fixed; v2's patch 19 is Andrea's, patch 1 here.

Findings answered without a change: a departed task boosted into the
class is counted conservatively across a rebuild and never twice, and
the deboost racing the walk drops its departing bandwidth for the
remaining lag as an inactive CPU does; the parameters a task keeps after
leaving asleep were kept by the baseline on this path too, and what is
left of their effect is a lag warning at the next boost, which a
follow-up should clear once the chain walk is done; the EPERM on a
sleeping task moved to another partition is the baseline's affinity
check; and the server write while the CPU is inactive is what patch 4
refuses.

In the selftests: a directory of their own, sched/deadline, as Juri
suggested, and three cases: death_zombie_switched (patch 9),
move_vs_rebuild (patch 16) and sysrq_normalize (patch 5), the last
gated on DEADLINE_TEST_SYSRQ=1 since it renices every real-time task of
the system.

Based on v7.4-rc1, 6628e7d4c6b2, where tip sched/urgent is now.

Andrea Parri (1):
  sched: Fix cpuset_mutex double unlock in __sched_setscheduler()

Juri Lelli (1):
  sched/deadline: Reject SCHED_DEADLINE on exited tasks

Mathieu Desnoyers (22):
  sched: Refuse SCHED_FLAG_KEEP_PARAMS that would change the policy or
    the class
  sched/deadline: Do not admit bandwidth for parameters that are kept
  sched/deadline: Do not divide by zero active CPUs of a root domain
  sched: Take cpuset_mutex for a deadline policy change only with pi
  sched/deadline: Do not lose a throttled task switched out and back
  sched/deadline: Reset the deadline and the runtime with the parameters
  sched/deadline: Release the bandwidth of a task that leaves the class
    asleep
  sched/deadline: Keep departing bandwidth across a root domain rebuild
  sched/deadline: Do not take a waking task's bandwidth off a runqueue
    it left
  sched/deadline: Rebuild the root domains' accounting without cpusets
    too
  sched/deadline: Leave a dying task out of a rebuild of the accounting
  sched/deadline: Record the root domain holding a task's bandwidth
  sched/deadline: Move a task's bandwidth only where room was made
  cgroup/cpuset: Wait for an attach before rebuilding the sched domains
  cgroup/cpuset: Give back the bandwidth an attach did not move
  sched/deadline: Credit a rebuild to the CPU recorded with the task's
    bandwidth
  sched/deadline: Cancel the replenishment timer with the parameters
  sched/deadline: Count the bandwidth a boosted task is given
  sched/debug: Show the deadline bandwidth of each runqueue
  selftests/sched: Add a test of SCHED_DEADLINE policy round trips
  selftests/sched: Test SCHED_DEADLINE bandwidth across a root domain
    rebuild
  selftests/sched: Add a test of SCHED_DEADLINE bandwidth accounting

 include/linux/cpuset.h                        |    5 -
 include/linux/sched.h                         |   22 +
 include/linux/sched/deadline.h                |   21 +-
 kernel/cgroup/cpuset-internal.h               |    2 +
 kernel/cgroup/cpuset.c                        |   59 +-
 kernel/sched/core.c                           |   19 +
 kernel/sched/deadline.c                       |  644 ++-
 kernel/sched/debug.c                          |    9 +-
 kernel/sched/sched.h                          |    4 +
 kernel/sched/syscalls.c                       |   78 +-
 kernel/sched/topology.c                       |    9 +
 tools/testing/selftests/Makefile              |    1 +
 .../selftests/sched/deadline/.gitignore       |    3 +
 .../testing/selftests/sched/deadline/Makefile |    8 +
 tools/testing/selftests/sched/deadline/config |    5 +
 .../sched/deadline/deadline_bw_test.c         | 3564 +++++++++++++++++
 .../sched/deadline/deadline_rebuild_test.c    |  462 +++
 .../sched/deadline/deadline_switch_test.c     |  425 ++
 .../testing/selftests/sched/deadline/settings |    1 +
 19 files changed, 5218 insertions(+), 123 deletions(-)
 create mode 100644 tools/testing/selftests/sched/deadline/.gitignore
 create mode 100644 tools/testing/selftests/sched/deadline/Makefile
 create mode 100644 tools/testing/selftests/sched/deadline/config
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_bw_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_rebuild_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_switch_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/settings

-- 
2.47.3

