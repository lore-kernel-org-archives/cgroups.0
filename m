Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924667;
	b=cCNOW0tqTlCawVoVFASYk4cuOr7CEBjcpjESoy3eAes4BMPFNbHqlYvpiojrqVwzFRcQ
	 qUDgJDXh9JT9dDh8iRQfZ5CepLFCWV8ozUo46tqaaRCz+KmMR1ZSBgwLE2lCp2Y067iZM
	 uaAeBUqLQN2q7G+0Py/KSJLatzsh+kmdJoY1tVqMZ0VKrSRIUpa8AXZJ/IfdC8CKN8We6
	 Gz8mN91Ga5vYz+skLy/tyDuEMFIpr+NRvmYuRYWcTITXgVHGQQ6Vtbuf68VxHbgM8/nhn
	 AIjmUtDi6LAuZ8OJWgrCEw9ePUA+vBn4Er/7bbHnpE1uGHw2EP8FeJkayxOZUNssIaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924667;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=bI0B5r3XDdC4AbV6ZS6n36Rl66CGNfAm7Zg/gKw33Z0=;
	b=RFtPnxRaWbTy35TXsLPmxXC3LZd6MB16EiB4ujTi9VTlX8JjJT9Ma2FfaEJlyRA8WUWf
	 X17hG/96sUBbnbb7Jc8gVVQl7NvWmEQSQgOzjYETPA9h8NeJP+Z/81v2+kCHiScLyBLQR
	 Mm0X+VnoV7zE128/+nlyTBwv9yJzV2ci/jbAPRmimVQlbInz5koOT3TYrrW5uPOXTUeoi
	 ilAuyL6ynTo73ct9NrHqV6Pjm+iMd8TZQq5ZSEIkY9xYpps1VZVhkNQF8jbuVY6dwW06a
	 cVEKLnQq7apVCkIdq9IK96HBql/4KCzUHkyVDuDIQLrctRyU01ppIylS/hZVTvXRIYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=e9Hu64bJ;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480DA606A88E;
	Tue, 17 Nov 2026 14:11:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 480DA606A88E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=e9Hu64bJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924664;
	bh=bI0B5r3XDdC4AbV6ZS6n36Rl66CGNfAm7Zg/gKw33Z0=;
	h=From:To:Cc:Subject:Date:From;
	b=e9Hu64bJFlLoJIbFDrYMxjoFDUT6n+2aTxpmMUy9Hk8W7rlCfNhBp3+vFypYF1zHM
	 yzzpakujB7oPu6lBziHmbNxV9z4AzX8cNj+P7nWDDmCx/1lz1y7pTGX0u5cRYu8dMR
	 b2EawDhpo5WGD1Xadl7Ppcp+MAEq8Gw9zzcT6mAHddqpaYUCDL2vKYVqxSW48pmKh+
	 B1SNsgtmDVRSg5zlac0kGsUmKTV9F25Tn8g/VXqBtWB2SPvKCucr+GxQR+zS5xqpQx
	 +c7XzfGBYSwHFoHtvM8eJKzoPSADLJuyanXgrP7MFzxpV556zeKCj9/aHM2EksbBji
	 Q1bPVTQ7IhLSw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV00X6ZzRZN;
	Tue, 17 Nov 2026 09:11:04 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
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
Subject: [PATCH v7 00/40] sched/deadline: bandwidth accounting fixes and selftests
Date: Tue, 17 Nov 2026 09:10:21 -0500
Message-Id: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
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

This series fixes 36 bugs of SCHED_DEADLINE. Most of them are in its
bandwidth accounting. Then it shows the deadline bandwidth of each
runqueue in sched_debug, and adds three selftests. The fixes come first,
as you asked, so that stable can take patches 1 to 36.

Three of the bugs take the kernel down (patches 4, 8 and 26). One is a
use after free in the rtmutex chain walk (patch 9). One leaves a task
that never runs again (patch 12). One leaves cpuset_mutex locked (patch
6). Most of the others leave total_bw of a root domain, or this_bw of a
runqueue, wrong. The root domain then admits deadline tasks beyond its
capacity, or refuses every one.

Patch 20 is Andrea Parri's. I carry it unchanged, with his agreement.
It is reviewed by Sebastian. It adds an affinity flag and a check next
to the code that patch 21 changes. Take it by whichever route you
prefer.

Juri, your four fixes that Ingo dropped from sched/urgent are still
here, renumbered:
- 1/4 is patch 18.
- 2/4 is patch 13.
- 3/4 is patch 1.
- 4/4 is patch 14.

The fixes
=========

 1  Refuse SCHED_FLAG_KEEP_PARAMS requests that would change the policy
    or the class.
 2  Skip admission for parameters that SCHED_FLAG_KEEP_PARAMS keeps.
 3  Let a task boosted by a deadline waiter change its policy.
 4  Do not divide by zero active CPUs of a root domain.
 5  Refuse a dl_server debugfs write while the runqueue is offline.
 6  Take cpuset_mutex for a deadline policy change only with pi, so
    that sysrq-n does not leave it locked.
 7  Replenish a throttled task switched out and back, so that it runs
    again.
 8  Do not refill a boost from cleared parameters, so that the owner's
    CPU no longer locks up.
 9  Continue the rtmutex chain walk when the deadline donor of a waiter
    changes, so that no owner keeps a donor that can exit.
 10 Reset the deadline and the runtime with the parameters.
 11 Start a new period at a deboost in the class, if the boost
    refilled the task's runtime from its donor.
 12 Replenish a throttled task that a waiter boosts while it sleeps, so
    that it runs again.
 13 Release the bandwidth of a task that leaves the class asleep.
 14 Reject SCHED_DEADLINE on exited tasks (Juri Lelli).
 15 Keep the bandwidth of departing tasks across a root domain rebuild.
 16 Keep this_bw right when a task changes during a remote wakeup.
 17 Rebuild the root domains' accounting from the task list.
 18 Record the root domain that holds a task's bandwidth.
 19 Leave out of a rebuild a dying task that released its bandwidth.
 20 Check the affinity of a deadline task under the runqueue lock, so
    that sched_setaffinity() and sched_setattr() cannot both succeed
    (Andrea Parri).
 21 Move a task's bandwidth only where an attach made room for it.
 22 Wait for an attach before rebuilding the sched domains.
 23 Make a policy or affinity change of a deadline task wait for a
    cpuset attach in progress.
 24 Give back the bandwidth an attach did not move.
 25 Reserve an attach's bandwidth in the root domain each task moves to.
 26 Make a rebuild count a task in the root domain it runs in.
 27 Move a task's bandwidth to the root domain it runs in.
 28 Pick a CPU for a task in the root domain that counts its
    bandwidth, when that root domain has one.
 29 Refuse to take offline the last CPU a task has in the root domain
    that counts its bandwidth.
 30 Refuse a cpuset change that leaves a deadline task no CPU in the
    root domain that counts its bandwidth.
 31 Cancel the replenishment timer with the parameters.
 32 Count in this_bw the bandwidth a boosted task is given.
 33 Give a deadline to a task that enters the class while it waits on
    an rt_mutex.
 34 Cap the runtime left of a constrained task at dl_runtime when its
    parameters change.
 35 Check the runtime left of a task that comes back to the class
    runnable, as a wakeup does.
 36 Check the runtime left of a runnable task whose parameters change.

Patches 18, 19 and 21 to 30 go together. 18 records the root domain
that counts a task's bandwidth. 19 and 21 to 27 fix the rebuild, attach
and migration paths that the record exposes. 28 to 30 keep a task in
the root domain that counts it, as long as that root domain has a CPU
for it. Patch 32 completes patch 16. Patch 37 shows this_bw in
sched_debug. Patches 38 to 40 add 112 cases in
tools/testing/selftests/sched/deadline, as Juri suggested.

Peter, patch 9 changes the rtmutex chain walk: a waiter records its
deadline donor with its sort keys. Patch 25 also touches
__set_cpus_allowed_ptr_locked(). A cpuset attach can reserve a deadline
task's bandwidth in one root domain. If the CPU picked for the task is
in the other one, the patch steers the task to the reserved CPU. Patch
23 touches __sched_setscheduler() and sched_setaffinity(). A change of
a deadline task waits there for a cpuset attach in progress. Patch 28
touches select_fallback_rq() and __set_cpus_allowed_ptr_locked() for
deadline tasks.

Waiman, patches 29 and 30 add refusals. They apply when a change would
leave a deadline task no CPU in the root domain that counts it. That
needs a cpuset with CPUs of two root domains: with isolcpus="domain",
or on cgroup v1 with sched_load_balance off. A CPU offline or a write
to cpuset.cpus then fails with EBUSY. cpuset makes a partition root
invalid, with a new reason. Nothing is refused with admission control
off (sched_rt_runtime_us set to -1).

Known limits
============

The fixes leave these cases open. Each patch named below also states
its limit in its message.

- Patch 9: two chain walks can overlap on a chain of three locks or
  more. The owners further down keep the old donor until the first walk
  reaches them.
- Patch 15: a task that left the class keeps its bandwidth until its
  0-lag time. A rebuild still drops it earlier if the CPU of the task
  is inactive, or if the task dies during the rebuild.
- Patch 27: a task can run in a root domain that does not count its
  bandwidth. The bandwidth then moves there without a check for room,
  as dl_task_offline_migration() does upstream.
- Patch 28: a CPU picked while the sched domains are rebuilt has no
  preference for a root domain, as upstream. No bandwidth moves
  meanwhile. But a wakeup can pick its CPU inside the rebuild and be
  queued after it. Its bandwidth can then move to the other root domain
  with no check for room. Push and pull between the two root domains
  during the rebuild are part of the same limit. This was found by
  reading, not reproduced.
- Patches 28 to 30: a task with no CPU left in the root domain that
  counts it still moves, and its bandwidth with it. With admission
  control on, patches 29 and 30 refuse the CPU offline and the cpuset
  changes that I found to lead there. Nothing is refused during a
  suspend, or with admission control off.
- A cpuset that holds isolated and housekeeping CPUs still admits a
  deadline task. Juri pointed at the XXX in dl_bw_capacity() for this
  in the v5 thread. It is left for later.

Found, left for separate patches
================================

The Sashiko review of v6 found two upstream bugs outside the scope of
this series. Both were found by reading. I will post their fixes
separately:
- The 0-lag time in task_non_contending() can overflow with periods of
  a few seconds. The bandwidth would then be released seconds late.
- dl_task_offline_migration() and dl_add_task_root_domain() spread
  extra_bw over the whole span, offline CPUs included. Tasks with
  SCHED_FLAG_RECLAIM would then reclaim a little more than their share,
  until the next rebuild.

Testing
=======

The 112 cases pass wherever they run, with lockdep and no kernel
warning, in 19 QEMU guests:
- 5 guests of 8 vCPUs, one with proxy execution off, and 1 of 4 vCPUs.
- 3 guests with PREEMPT_RT, of 8, 8 and 4 vCPUs.
- 3 guests without CONFIG_CPUSETS, of 4, 4 and 5 vCPUs.
- 4 guests of 5 vCPUs booted with isolcpus=domain,1,2 or
  isolcpus=domain,0,1, 2 of them with PREEMPT_RT.
- 1 guest of 8 vCPUs booted with isolcpus=domain,6,7.
- 2 guests with CONFIG_RT_GROUP_SCHED, of 8 and 4 vCPUs.
The 23 isolcpus cases run in the fourth group. There, the cases that
need 4 CPUs that are not isolated skip. rebuild_waking_keeps also skips
with isolcpus=domain,1,2: it needs the first CPU isolated. Some of the
23 also run in the fifth group. move_cancelled runs only in the last
group.

No guest combines isolcpus=domain with a kernel without CONFIG_CPUSETS.
Such a kernel hits a BUG at boot on v7.4-rc2 with isolcpus=domain,0,1.
The BUG is in select_fallback_rq() called from workqueue_init(). I will
report it separately.

On v7.4-rc2, 35 cases of deadline_bw_test fail in 8 guests of 8 vCPUs,
as patch 40 lists. overrun_caught fails in part of the runs. The three
cases of deadline_rebuild_test fail there too, and so do
throttled_round_trip, asleep_round_trip and sysrq_normalize of
deadline_switch_test. tip sched/urgent, the base of this series, gives
the same results.

Each case added for a fix fails without that fix. Each fix names the
cases that test it, and patch 40 lists the rest. There are four
exceptions:
- deboost_blocked_keeps_order passes on v7.4-rc2, and fails on v5.
- return_asleep_new_params passes everywhere. It covers the wakeup
  path that patches 35 and 36 copy.
- deboost_keeps_own_runtime passes with and without the flag of patch
  11. It checks that a task keeps the runtime of its own reservation.
- pi_chain_donor_leaves passes on v7.4-rc2. There, a blocked task that
  leaves SCHED_DEADLINE keeps its parameters. It fails on v6.

sysrq_running_owner passes on v6 too. It locks the guest up once the
early return of patch 8 is disabled. Two cases pass on v7.4-rc2 and add
coverage only: frozen_moved_switched and pi_chain_two_owners. So do the
affinity changes in random_mix.

The three sysrq cases only run with DEADLINE_TEST_SYSRQ=1, which the
19 guests set. move_normalized is one of them.

For patches 13, 15 and 22, a kernel built with the series up to that
patch confirms the claim of its message. Each of the 40 patches builds
alone. The whole series also builds without CONFIG_CPUSETS, with
PREEMPT_RT and with CONFIG_RT_GROUP_SCHED. kernel/sched/ also builds
without CONFIG_RT_MUTEXES, which v6 broke. The cpuset selftest
test_cpuset_prs.sh passes, with and without PREEMPT_RT.

Not tested: cgroup v1 cpusets, threaded cgroups (every move is a write
to cgroup.procs), the sched_ext server, and CPUs of unequal capacity.

How this was developed
======================

An LLM coding assistant wrote these patches, their messages and the
tests, under my direction and review. I know the concepts behind
SCHED_DEADLINE, but not its implementation well. So I ask those who
know this code for a careful reading of the fixes. A reproducer that
stops failing shows that the symptom goes away. It does not show that
the fix is the one you would have written.

The bugs came from:
- flaky cgroup selftests of a feature I am developing;
- the review of Juri's four fixes, and his review of v5;
- building deadline_bw_test, and reading the code;
- the Sashiko AI reviews of v1 to v6. Each finding was checked against
  the code first.

Changes since v6
================

- The base is unchanged: tip sched/urgent ec6f6731538e.
- Fixes from the Sashiko review of v6. Three are new patches, for bugs
  that upstream has:
  - New patch 9: the rtmutex chain walk stopped at a waiter whose keys
    did not change. The owner further down could then keep a donor
    that exits. pi_chain_donor_leaves tests it.
  - New patch 12: a task throttled as it blocked, then boosted while it
    slept, would never be replenished. It would never run again. This
    was found by reading.
  - New patch 34: a constrained task given a shorter dl_deadline could
    keep more runtime than its new dl_runtime.
    change_constrained_new_params and wake_constrained_new_params test
    it.
- Fixes to v6 patches, from the same review:
  - 8: the donor's runtime, deadline and period are all tested. A
    negative runtime is reset to 0. An owner with no parameters of its
    own gets a deadline of now.
  - 11: it builds without CONFIG_RT_MUTEXES. fork() does not copy
    dl_donor_refill.
  - 23: after a race with a cpuset update, sched_setaffinity() sets the
    mask a second time. That second change waits for an attach too.
  - 25: the v2 fast path clears the reservation record. The span of the
    default root domain leaves out offline CPUs. move_back_cpu_offline
    tests it.
  - 26: with admission control off, a task put outside its mask by the
    offline fallback is counted where it runs.
  - 27: no bandwidth moves to a CPU that is not active.
  - 28: the offline migration of a throttled task stays in its root
    domain. The span stays known while the recorded CPU goes offline.
    hotplug_spinner_keeps, hotplug_waking_keeps and
    hotplug_isolated_keeps test it.
  - 29: the fallback CPUs follow the affinity set by the user. A dead
    task does not block the offline. hotplug_user_mask_refused and
    hotplug_dead_accepted test it.
  - 30: the new masks are computed from the top down. A scratch mask no
    longer overwrites effective_xcpus. An invalid partition gives no
    CPUs back. A mask that grows within the user affinity is checked.
    Four new cases test it.
  - 33: a new donor of a blocked task with no parameters starts a
    period.
  - 36: a boosted task keeps the mark of its parameter change until an
    enqueue after its deboost. change_boosted_new_params tests it.
- Patches 27 and 28: no bandwidth moves and no span is used while the
  sched domains are rebuilt. A partition root made and removed while a
  task woke up often could move its bandwidth to the isolated root
  domain. rebuild_waking_keeps tests it. With isolcpus=domain,0,1, it
  fails in most runs without the fix.
- Patch 27: proxy execution can migrate a task blocked on a mutex. Its
  bandwidth now stays in the root domain that counts it. This came up
  in the review of the proxy execution RFC.
- The claims made "on v7.4-rc1" were run again on v7.4-rc2 and on tip
  sched/urgent. They all hold, and the messages now say v7.4-rc2.
  Patch 40 lists 35 failing cases, not 32.
- The selftest guards of the hotplug cases are fixed. affinity_vs_setattr
  waits for its target to sleep, so its target no longer overruns.

Not changed:
- A departed task that priority inheritance boosts back into the class
  is counted once across a rebuild. The rebuild counts it where it
  runs. If the deboost races the rebuild, its bandwidth is dropped
  until its 0-lag time. Nothing is counted twice.
- At a deboost, the 0-lag time of a task comes from the deadline and
  runtime it ran on during the boost, as upstream.
- sched_setattr() still fails with EPERM for a task moved asleep to
  another partition. The task is still on a CPU of the old root domain,
  and the affinity check of __sched_setscheduler() reads that one. The
  check is upstream code, and it refuses but never admits wrongly.
- An attach whose mask keeps a CPU of the task's root domain reserves
  nothing. The task then stays in that root domain.
- A write to cpuset.cpus that makes a partition root invalid is not
  refused. A deadline task can then run in a root domain that did not
  admit it, as upstream. CPU hotplug and a write of "member" do the same
  and cannot fail. The next rebuild counts the task where it runs.

Based on tip sched/urgent, ec6f6731538e (v7.4-rc2).

v6: https://lore.kernel.org/all/20261116190549.230119-1-mathieu.desnoyers@efficios.com/
v5: https://lore.kernel.org/all/20261108185406.1549770-1-mathieu.desnoyers@efficios.com/
v4: https://lore.kernel.org/all/20261107014451.1487825-1-mathieu.desnoyers@efficios.com/

Andrea Parri (1):
  sched/deadline: Check SCHED_DEADLINE affinity under the rq lock

Juri Lelli (1):
  sched/deadline: Reject SCHED_DEADLINE on exited tasks

Mathieu Desnoyers (38):
  sched: Refuse SCHED_FLAG_KEEP_PARAMS that would change the policy or
    the class
  sched/deadline: Do not admit bandwidth for parameters that are kept
  sched: Let a task boosted by a deadline waiter change its policy
  sched/deadline: Do not divide by zero active CPUs of a root domain
  sched/deadline: Refuse dl_server debugfs writes while the rq is
    offline
  sched: Take cpuset_mutex for a deadline policy change only with pi
  sched/deadline: Do not lose a throttled task switched out and back
  sched/deadline: Do not replenish a boost from cleared parameters
  rtmutex: Continue the chain walk when a waiter's deadline donor
    changes
  sched/deadline: Reset the deadline and the runtime with the parameters
  sched/deadline: Reset the donor's runtime at a deboost in the class
  sched/deadline: Replenish a throttled task boosted while asleep
  sched/deadline: Release the bandwidth of a task that leaves the class
    asleep
  sched/deadline: Keep departing bandwidth across a root domain rebuild
  sched/deadline: Fix this_bw when a task is changed during a remote
    wakeup
  sched/deadline: Rebuild the root domains' accounting from the task
    list
  sched/deadline: Record the root domain holding a task's bandwidth
  sched/deadline: Leave a dying task out of a rebuild of the accounting
  sched/deadline: Move a task's bandwidth only where room was made
  cgroup/cpuset: Wait for an attach before rebuilding the sched domains
  sched: Make deadline policy and affinity changes wait for a cpuset
    attach
  cgroup/cpuset: Give back the bandwidth an attach did not move
  cgroup/cpuset: Reserve the bandwidth in the root domain a task moves
    to
  sched/deadline: Make a rebuild count a task in the root domain it runs
    in
  sched/deadline: Move a task's bandwidth to the root domain it runs in
  sched/deadline: Keep a task in the root domain that counts its
    bandwidth
  sched/deadline: Keep the last CPU a task has in its root domain
  cgroup/cpuset: Refuse to take a deadline task out of its root domain
  sched/deadline: Cancel the replenishment timer with the parameters
  sched/deadline: Count the bandwidth a boosted task is given
  sched/deadline: Start a period for a task that enters the class
    blocked
  sched/deadline: Cap the runtime left of a constrained task at
    dl_runtime
  sched/deadline: Check the runtime of a task that comes back runnable
  sched/deadline: Check the runtime of a task whose parameters change
  sched/debug: Show the deadline bandwidth of each runqueue
  selftests/sched: Add a test of SCHED_DEADLINE policy round trips
  selftests/sched: Test SCHED_DEADLINE bandwidth across a root domain
    rebuild
  selftests/sched: Add a test of SCHED_DEADLINE bandwidth accounting

 include/linux/cpuset.h                        |   20 +-
 include/linux/sched.h                         |   43 +
 include/linux/sched/deadline.h                |   39 +-
 kernel/cgroup/cgroup.c                        |    3 -
 kernel/cgroup/cpuset-internal.h               |   15 +-
 kernel/cgroup/cpuset.c                        |  549 +-
 kernel/locking/rtmutex.c                      |   22 +-
 kernel/locking/rtmutex_api.c                  |    2 +-
 kernel/locking/rtmutex_common.h               |    3 +
 kernel/sched/core.c                           |  126 +-
 kernel/sched/deadline.c                       | 1350 ++-
 kernel/sched/debug.c                          |   12 +-
 kernel/sched/sched.h                          |   21 +
 kernel/sched/syscalls.c                       |  177 +-
 kernel/sched/topology.c                       |   11 +
 tools/testing/selftests/Makefile              |    1 +
 .../selftests/sched/deadline/.gitignore       |    3 +
 .../testing/selftests/sched/deadline/Makefile |    8 +
 tools/testing/selftests/sched/deadline/config |    5 +
 .../sched/deadline/deadline_bw_test.c         | 9597 +++++++++++++++++
 .../sched/deadline/deadline_rebuild_test.c    |  497 +
 .../sched/deadline/deadline_switch_test.c     | 1089 ++
 .../testing/selftests/sched/deadline/settings |    1 +
 23 files changed, 13282 insertions(+), 312 deletions(-)
 create mode 100644 tools/testing/selftests/sched/deadline/.gitignore
 create mode 100644 tools/testing/selftests/sched/deadline/Makefile
 create mode 100644 tools/testing/selftests/sched/deadline/config
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_bw_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_rebuild_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_switch_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/settings


base-commit: ec6f6731538e0d45872eb279fdeb477bed152d6f
-- 
2.47.3

