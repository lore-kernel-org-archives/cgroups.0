Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855968;
	b=gP7yPn+UKxye0Bp9qTFSgNZa3XLuv0uDmjZt9q7lfr46oV7PZEk4pMwjnAzV+UumzgGA
	 76QXhEEyH5QPeIssiNITRrIAeuPUmJglx9PhZnC4eSvjCs2kIYqBAUvpjh68SalwXoADc
	 kSg1hILT+XdlFBz/eyjYWI6IWNltUc6eWGRAsJYfseq8bT2Yswv+8wv58jDBrpHkpj0Qt
	 r3AhHQBn39yJHnQlMwgIEJ1P9iJzCM+JvPBiGjo2wsBenQXAl5Cm6Z/kB2y6baWw+9PQf
	 T8zLOGv7hEXwozHoZB+IixmBVJaXH3bCMZkDLNf722YoWljR7lv/nHkVTcFN+nc/IRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855968;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=qfyXIsKI6HhE+jToY5OVdl0dkQkz7BqowWmKXZMUyQM=;
	b=45x5OapLFgzE6uuHY9roUPBcUsFeM/XreSKhnGICYrZyfindk/55dgnfOnyASq0TSQZ4
	 jQR+cMHdW9KxzBXrkMxeUwldvQhfhLlyGeGAxqBk4eaGNY7GnMqp2g+xugh7lcuTGMM2b
	 VHhi1tSCd5chKox12lOOErvTiM4spIkKOzO+xHoYHaWqZeG6YxmCZv09nmsMgZtirUNXN
	 Xbn4JtRWtPxjmqRMilPedCSPIEned4JsO8bzgGQbV3nURXesqDNy0BJq0yfXOTIm+vME/
	 iQlSi4kK8LohgTsxQhyzS9jhIDu0aH2tA2wLRpArId0Q2StjSGs9d/Its3AsQY4Wc5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=TrItEd44;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639CD606A33E;
	Mon, 16 Nov 2026 19:06:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 639CD606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=TrItEd44
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855953;
	bh=qfyXIsKI6HhE+jToY5OVdl0dkQkz7BqowWmKXZMUyQM=;
	h=From:To:Cc:Subject:Date:From;
	b=TrItEd44PP4nVt0Qj308mvR4mh/CWX+I2M3/nw6J353rpUQ05kusZJCc7avrC8Jee
	 eHdvBG64LkiJUFnTHGO6mTs+OIq6W3FfHhhUd270VIKdNLZ0c21R/nBPlJkyva4PX2
	 vmNedqk5u6wbj2bp2apqN3tLjCqMj6MxXzTNcpbHVwuiLip3Wi1vi0q4tmByLUxZdb
	 wXaDR0uTyCq3kxqA3m4ctNJwDbsJdqJjtBs7p502Tpm42NS/ZW27841I6dS2lUMmVv
	 KziaSrBuTMQ2QGfIrVQy7oUlyMuHv+wvLw+ffuHoddbY01ff+mSydpdIp1sRMHuZ/G
	 TXxBAjlxMxHnA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4d3vNLzR9N;
	Mon, 16 Nov 2026 14:05:53 -0500 (EST)
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
Subject: [PATCH v6 00/37] sched/deadline: bandwidth accounting fixes and selftests
Date: Mon, 16 Nov 2026 14:05:12 -0500
Message-Id: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
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

This series fixes 33 bugs of SCHED_DEADLINE. Most of them are in its
bandwidth accounting. Then it shows the deadline bandwidth of each
runqueue in sched_debug, and adds three selftests. The fixes come first,
as you asked, so that stable can take patches 1 to 33.

Three of the bugs take the kernel down (patches 4, 8 and 24). One leaves
cpuset_mutex locked (patch 6). Most of the others leave total_bw of a
root domain, or this_bw of a runqueue, wrong. The root domain then
admits deadline tasks beyond its capacity, or refuses every one.

Patch 18 is Andrea Parri's. I carry it unchanged, with his agreement.
It is reviewed by Sebastian. It adds an affinity flag and a check next
to the code that patch 19 changes. Take it by whichever route you
prefer.

Patch 1 of v5, also Andrea's, is upstream. It is
commit f7141257dd67 ("sched/core: Fix cpuset_mutex double unlock in
__sched_setscheduler()"), and is dropped here.

Juri, Ingo dropped your four fixes from sched/urgent after the first
one crashed Marek Szyprowski's hotplug test. They are here:
- 1/4 is patch 16. It does not use the task's mask, which can have no
  active CPU during hotplug.
- 2/4 is patch 11, without its double release. It does not carry your
  Signed-off-by, which is yours to add back.
- 3/4 is patch 1.
- 4/4 is patch 12, extended.
Marek found v2 fixed on the board that crashed.

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
 8  Do not refill a boost from a runtime of 0, so that the owner's CPU
    no longer locks up.
 9  Reset the deadline and the runtime with the parameters.
 10 Start a new period at a deboost in the class, if the boost
    refilled the task's runtime from its donor.
 11 Release the bandwidth of a task that leaves the class asleep.
 12 Reject SCHED_DEADLINE on exited tasks (Juri Lelli).
 13 Keep the bandwidth of departing tasks across a root domain rebuild.
 14 Keep this_bw right when a task changes during a remote wakeup.
 15 Rebuild the root domains' accounting from the task list.
 16 Record the root domain that holds a task's bandwidth.
 17 Leave out of a rebuild a dying task that released its bandwidth.
 18 Check the affinity of a deadline task under the runqueue lock, so
    that sched_setaffinity() and sched_setattr() cannot both succeed
    (Andrea Parri).
 19 Move a task's bandwidth only where an attach made room for it.
 20 Wait for an attach before rebuilding the sched domains.
 21 Make a policy or affinity change of a deadline task wait for a
    cpuset attach in progress.
 22 Give back the bandwidth an attach did not move.
 23 Reserve an attach's bandwidth in the root domain each task moves to.
 24 Make a rebuild count a task in the root domain it runs in.
 25 Move a task's bandwidth to the root domain it runs in.
 26 Pick a CPU for a task in the root domain that counts its
    bandwidth, when that root domain has one.
 27 Refuse to take offline the last CPU a task has in the root domain
    that counts its bandwidth.
 28 Refuse a cpuset change that leaves a deadline task no CPU in the
    root domain that counts its bandwidth.
 29 Cancel the replenishment timer with the parameters.
 30 Count in this_bw the bandwidth a boosted task is given.
 31 Give a deadline to a task that enters the class while it waits on
    an rt_mutex.
 32 Check the runtime left of a task that comes back to the class
    runnable, as a wakeup does.
 33 Check the runtime left of a runnable task whose parameters change.

Patches 16, 17 and 19 to 28 go together. 16 records the root domain that
counts a task's bandwidth. 17 and 19 to 25 fix the rebuild, attach and
migration paths that the record exposes. 26 to 28 keep a task in the
root domain that counts it, as long as that root domain has a CPU for
it. Patch 30 completes patch 14. Patch 34
shows this_bw in sched_debug. Patches 35 to 37 add 96 cases in
tools/testing/selftests/sched/deadline, as Juri suggested.

Peter, patch 23 also touches __set_cpus_allowed_ptr_locked(). A cpuset
attach can reserve a deadline task's bandwidth in one root domain. If
the CPU picked for the task is in the other one, the patch steers the
task to the reserved CPU. Patch 21 touches __sched_setscheduler() and
sched_setaffinity(). A change of a deadline task waits there for a
cpuset attach in progress. Patch 26 touches select_fallback_rq() and
__set_cpus_allowed_ptr_locked() for deadline tasks.

Waiman, patches 27 and 28 add refusals that only isolcpus="domain" can
trigger. They apply when a change would leave a deadline task no CPU in
the root domain that counts it. A CPU offline or a write to cpuset.cpus
then fails with EBUSY. cpuset makes a partition root invalid, with a
new reason. Nothing is refused with admission control off
(sched_rt_runtime_us set to -1).

Known limits
============

The fixes leave these cases open. The message of each patch named
states its own.

- Patch 13: a task that left the class keeps its bandwidth until its
  0-lag time. A rebuild still drops it earlier if the CPU of the task
  is inactive, or if the task dies during the rebuild.
- Patch 25: a task can run in a root domain that does not count its
  bandwidth. The bandwidth then moves there without a check for room,
  as dl_task_offline_migration() does upstream.
- Patches 26 to 28: a task with no CPU left in the root domain that
  counts it still moves, and its bandwidth with it. With admission
  control on, patches 27 and 28 refuse the CPU offline and the cpuset
  changes that I found to lead there. Nothing is refused during a
  suspend, or with admission control off.
- A cpuset that holds isolated and housekeeping CPUs still admits a
  deadline task. Juri pointed at the XXX in dl_bw_capacity() for this
  in the v5 thread. It is left for later.

Testing
=======

The 96 cases pass wherever they run, with lockdep and no kernel
warning, in 19 QEMU guests:
- 5 guests of 8 vCPUs, one with proxy execution off, and 1 of 4 vCPUs.
- 3 guests with PREEMPT_RT, of 8, 8 and 4 vCPUs.
- 3 guests without CONFIG_CPUSETS, of 4, 4 and 5 vCPUs.
- 4 guests of 5 vCPUs booted with isolcpus=domain,1,2 or
  isolcpus=domain,0,1, 2 of them with PREEMPT_RT.
- 1 guest of 8 vCPUs booted with isolcpus=domain,6,7.
- 2 guests with CONFIG_RT_GROUP_SCHED, of 8 and 4 vCPUs.
The thirteen isolcpus cases run in the fourth group. There, three
cases that need 4 CPUs that are not isolated skip. Four of the thirteen
also run in the fifth group. move_cancelled runs only in the last
group.

On v7.4-rc1, 32 cases of deadline_bw_test fail in 8 guests of 8 vCPUs,
as patch 37 lists. overrun_caught and hotplug_sleeper_switched fail in
7 guests of 8, the others in every guest. The three cases of
deadline_rebuild_test fail there too, and so do throttled_round_trip
and asleep_round_trip of deadline_switch_test. The sysrq cases were not
run on v7.4-rc1: sysrq-n leaves cpuset_mutex locked there, which patch
6 fixes.

Each case added in v5 or v6 for a fix fails without that fix. Each fix
names the cases that test it, and patch 37 lists the rest. There are
three exceptions:
- deboost_blocked_keeps_order passes on v7.4-rc1, and fails on v5.
- return_asleep_new_params passes everywhere. It covers the wakeup
  path that patches 32 and 33 copy.
- deboost_keeps_own_runtime passes with and without the flag of patch
  10. It checks that a task keeps the runtime of its own reservation.

Two of the new cases pass on v7.4-rc1 and add coverage only:
frozen_moved_switched and pi_chain_two_owners. So do the affinity
changes in random_mix.

The three sysrq cases only run with DEADLINE_TEST_SYSRQ=1, which the
19 guests set. move_normalized is one of them.

For patches 11, 13 and 20, a kernel built with the series up to that
patch confirms the claim of its message. Each of the 37 patches builds
alone. The whole series also builds without CONFIG_CPUSETS, with
PREEMPT_RT and with CONFIG_RT_GROUP_SCHED.

Not tested: cgroup v1 cpusets, threaded cgroups (every move is a write
to cgroup.procs), the sched_ext server, and CPUs of unequal capacity.

Patch 8 has no selftest. A 300ms debug delay before
rt_mutex_adjust_pi() locks up the series without patch 8, but not with
it. A stress test switches the waiter in and out of the class. The
series runs it for 600 seconds, with and without PREEMPT_RT.

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
- the Sashiko AI reviews of v1 to v5. Each finding was checked against
  the code first.

Changes since v5
================

- Rebased on tip sched/urgent ec6f6731538e. Patch 1 of v5 is upstream,
  so it is dropped and the patches are renumbered.
- Patch 8 is the smaller fix Juri suggested. replenish_dl_entity()
  reads the inherited parameters once, and does not refill from a
  runtime of 0. The owner runs on until the chain walk deboosts it. The
  series no longer touches the rt_mutex code. So it no longer needs v2
  of "locking/rtmutex: priority inheritance fixes and tests", and
  applies on tip sched/urgent alone. Patches 10 and 11 are rebased on
  the new patch 8.
- Patch 9: the comment of __dl_clear_params() says that it also resets
  the deadline and the runtime.
- Patch 11 calls task_non_contending() for a task that leaves the
  class asleep, as Juri suggested. The code is shorter and does the
  same.
- Patch 10: in v5 the deboost tested the runtime against dl_runtime.
  A task that its donor refilled could pass that test with a runtime
  and a deadline that were not its own. The refill is now recorded in
  a flag, dl_donor_refill. The deboost starts a new period when the
  flag is set, and keeps the runtime and the deadline otherwise. Two
  new cases test this: deboost_after_donor_refill and
  deboost_keeps_own_runtime.
- The Fixes: tags of patch 24 also name 318e18ed22e8. Its
  subject says what the rebuild does: it counts a task in the root
  domain it runs in.
- Patch 16: the second case of its message needs no pin and no change
  of admission control. hotplug_sleeper_switched now checks the
  accounting while the CPU is still offline, and fails without the
  patch. Bringing the CPU back rebuilt the accounting, and hid the
  bandwidth left behind.
- Fixes from the Sashiko review of v5:
  - 10: the deboost starts the new period at once. A task blocked on
    another rt_mutex kept a deadline of 0. Its waiter then went first.
    If the new period ends after the top waiter's deadline, the task is
    boosted again.
  - 16: sched_setaffinity() checks the root domain that counts the
    task. A departing task records the CPU it departs from.
  - 19: an attach that reserved the bandwidth moves it, even if the
    mask does not change.
  - 24: a simpler test of the recorded CPU. The behaviour is the same.
  - 25: the bandwidth also moves at a wakeup with no migration. The test
    compares root domains, not the CPU the task leaves. New subject.
- Patch 13 (13 in v5), from Juri's review:
  - A departed task keeps the CPU recorded when priority inheritance
    boosts it back into the class. In v5, the end of the boost took the
    bandwidth from the root domain the task ran in. Patch 16 hid this
    at the end of the series. The new case pi_departed_moved tests it.
  - Two comments are Juri's: what dl_bw_gen dates, and why a rebuild
    drops the bandwidth of a departed task whose CPU is inactive.
- Patches 15 to 17 (15 to 17 in v5), from Juri's review:
  - 15: the rebuild does not walk the task list when no task holds a
    deadline bandwidth. A new count, dl_nr_bw_tasks, tells it. A suspend
    and a resume run one rebuild for each CPU. In a 64-vCPU guest with
    10000 threads and no deadline task, a rebuild took 0.7 to 1.2 ms
    without the count. It takes 0.03 ms with it. Patch 27 uses the
    count too.
  - 16: set_cpus_allowed_dl() tests dl_bw_gen under dl_departed_lock.
  - 17: the message says that the patch completes patch 15 and needs
    patch 16.
- New patch 18, by Andrea Parri, posted on its own on 2026-11-05. It
  moves the affinity check of a deadline task under the runqueue lock.
  It adds SCA_DL_CHECK as 0x10, so SCA_DL_BW_RESERVED of patch 19 stays
  0x20. Patch 19 is rebased on it. The new case affinity_vs_setattr
  tests it.
- New patch 21, and patches 22 and 23 (20 and 21 in v5), from Juri's
  review. In v5, a task could become a deadline task between
  cpuset_can_attach() and cpuset_attach(). Nothing was reserved for it.
  It could use the room reserved for the other tasks, and their
  bandwidth stayed behind.
  - New patch 21: sched_setattr() and sched_setaffinity() of a deadline
    task wait for an attach in progress. The change then comes before
    the attach, and is part of its reservation, or after it.
    sched_setaffinity() tests the policy with no lock before it decides
    to wait. So the policy is tested again under the runqueue lock. The
    call starts over if a sched_setattr() made the task a deadline task
    meanwhile. The wait is not interruptible.
  - Patch 22 comes after that wait. Only sysrq-n can then take a task
    out of the class between the two halves of an attach. The patch
    gives back the part of the reservation that no task used. The new
    case move_normalized tests it.
  - Patch 23: cpuset_can_attach() records, with each task it counts,
    the CPU the room was reserved on. Juri suggested to track the
    counted tasks. cpuset_attach_task() moves the bandwidth of a task
    only if the task has that record. It moves it to that CPU, and does
    not compute the CPU again. A task that wakes up during the attach
    and runs on another CPU no longer misses its reservation. A wakeup
    needs no wait. During the attach, the root domain the task leaves
    still counts its bandwidth. The destination has room reserved for
    it.
  - Seven new cases test this: move_became_deadline,
    move_became_deadline_no_room, move_affinity_changed,
    move_affinity_became_deadline, move_woken, move_woken_full and
    move_cancelled.
- Six more new cases:
  - move_died and frozen_moved_switched: a thread killed during a
    move, and a task frozen by the cgroup freezer.
  - Four follow reproducers of Juri's sched-deadline-tests:
    stopped_switched_out, hotplug_sleeper_switched,
    hotplug_no_admission_pinned and pi_chain_two_owners.
- random_mix also changes the affinity of its tasks.
- New patches 26 to 28. With isolcpus="domain", a cpuset can hold CPUs
  of two root domains. A deadline task could go from one to the other
  with no cpuset attach. A CPU offline or a cpuset that lost CPUs could
  do it. Patch 25 then moved its bandwidth with no check for room.
  - Patch 26: a CPU of the root domain that counts the task is tried
    first, wherever a CPU is picked for it.
  - Patch 27: a CPU offline fails with EBUSY if it takes the last CPU a
    deadline task has in that root domain.
  - Patch 28: a cpuset change that leaves a deadline task no CPU in
    that root domain is refused. A write to cpuset.cpus fails with
    EBUSY. cpuset makes a partition root invalid.
  - Four new cases test this: hotplug_keeps_root_domain,
    hotplug_last_refused, mask_out_refused (was mask_back_asleep) and
    partition_takes_refused. The three hotplug_fallback cases now fail
    if the task wakes up in the other root domain.
    no_admission_affinity_moves tests patch 25 with admission control
    off.
- Patches 2, 3, 6, 14, 17, 20, 29 and 30 have Juri's Reviewed-by.
  Patches 7 and 9 have his Acked-by.
- Not in this series: the single list of accounted tasks that Juri
  suggested in his review of patch 13 of v5. I tried it. It removes
  dl_bw_gen and the walk of the task list. But the rebuild then runs
  with interrupts disabled for its whole length. In a 64-vCPU guest,
  that was 0.15ms with 1000 deadline tasks and 1.2ms with 10000. Today
  it is less than 0.1ms at a time. I left it out for that reason.
- New patch 31: a task that enters the class while it waits on an
  rt_mutex gets a deadline. Before, its waiter was sorted with a
  deadline of 0, ahead of every real one. Upstream has this bug. The
  triage of the Sashiko review of v5 found it.
- Six new selftest cases test these fixes. They fail on v5.
- Patch 2's comment names the use of SCHED_FLAG_KEEP_PARAMS on a
  deadline task: a change of its utilization clamps (Juri Lelli).
- Patch 5 of v5 is split in two, as Juri asked. 4 removes the division
  by zero. 5 refuses the debugfs write in the hotplug windows. Each has its
  own Fixes: tag.
- Patch 6 has clearer comments on its two policy checks, and an
  unlikely() (Juri Lelli).
- New patches 32 and 33, for the case Juri pointed out in v5. A task
  kept the runtime left from its old parameters when it came back to
  the class runnable. A runnable task that changed its parameters kept
  it too. Both now get the check a wakeup does. Upstream has these
  bugs. Three new cases test them.
- Patch 23's message says what an attach without a reservation does.
- Patch 37 (29 in v5) said that 13 cases fail on v7.4-rc1. That count
  left out two cases added in v5. A new run of the 89 cases gives 32,
  and the message lists them. The message is a third of its length: it
  no longer repeats what each fix says about its own cases.
- v5 reported three upstream problems found with isolcpus=domain. Waiman
  Long answered them; see the v5 cover. The tests avoid them.

Not changed:
- A departed task that priority inheritance boosts back into the class
  is counted once across a rebuild. The rebuild counts it where it
  runs. If the deboost races the rebuild, its bandwidth is dropped
  until its 0-lag time. Nothing is counted twice.
- At a deboost, the 0-lag time of a task comes from the deadline and
  runtime it ran on during the boost, as upstream.
- The EPERM of a sleeping task moved to another partition is the
  baseline's affinity check.
- An attach whose mask keeps a CPU of the task's root domain reserves
  nothing. The task then stays in that root domain.

Based on tip sched/urgent, ec6f6731538e.

v5: https://lore.kernel.org/all/20261108185406.1549770-1-mathieu.desnoyers@efficios.com/
v4: https://lore.kernel.org/all/20261107014451.1487825-1-mathieu.desnoyers@efficios.com/


Andrea Parri (1):
  sched/deadline: Check SCHED_DEADLINE affinity under the rq lock

Juri Lelli (1):
  sched/deadline: Reject SCHED_DEADLINE on exited tasks

Mathieu Desnoyers (35):
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
  sched/deadline: Reset the deadline and the runtime with the parameters
  sched/deadline: Reset the donor's runtime at a deboost in the class
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
  sched/deadline: Check the runtime of a task that comes back runnable
  sched/deadline: Check the runtime of a task whose parameters change
  sched/debug: Show the deadline bandwidth of each runqueue
  selftests/sched: Add a test of SCHED_DEADLINE policy round trips
  selftests/sched: Test SCHED_DEADLINE bandwidth across a root domain
    rebuild
  selftests/sched: Add a test of SCHED_DEADLINE bandwidth accounting

 include/linux/cpuset.h                        |   20 +-
 include/linux/sched.h                         |   43 +
 include/linux/sched/deadline.h                |   38 +-
 kernel/cgroup/cgroup.c                        |    3 -
 kernel/cgroup/cpuset-internal.h               |   15 +-
 kernel/cgroup/cpuset.c                        |  496 +-
 kernel/sched/core.c                           |  124 +-
 kernel/sched/deadline.c                       | 1157 ++-
 kernel/sched/debug.c                          |   12 +-
 kernel/sched/sched.h                          |   20 +
 kernel/sched/syscalls.c                       |  163 +-
 kernel/sched/topology.c                       |    8 +
 tools/testing/selftests/Makefile              |    1 +
 .../selftests/sched/deadline/.gitignore       |    3 +
 .../testing/selftests/sched/deadline/Makefile |    8 +
 tools/testing/selftests/sched/deadline/config |    5 +
 .../sched/deadline/deadline_bw_test.c         | 8101 +++++++++++++++++
 .../sched/deadline/deadline_rebuild_test.c    |  497 +
 .../sched/deadline/deadline_switch_test.c     |  808 ++
 .../testing/selftests/sched/deadline/settings |    1 +
 20 files changed, 11218 insertions(+), 305 deletions(-)
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

