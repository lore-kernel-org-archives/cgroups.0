Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119384;
	b=AfepgOscYW5VN+Xk9y1Rc9QGPEH74pn2W5t0JEXPaC9RUIHf3e9+Ac+wjiYUQ1HmKtN3
	 OmJfZ7KjehazfD8RH5/7FMc9zOBtX1gyennQZmZ4ao2EeAWVCEt1fgRuLUQf7FaRwubLD
	 zcP7f6fJ/Sm9zXeNdE8VBx519DCa1RblJJbHfEwh7y6lTBbs2JhuVemU2u2Vh7traZuWY
	 OleTMMVkbinJhfORp/YUZO27fLDehtz2LJ3Msn3bpJ11xfLZgNmnPpS7mYfq/NMvhlIoe
	 j8yq/bKHFQdrly9GJ2wlShBtpe52Y5s3VMK/waqafwKfglwSOXwbr7v+2lcLRS8Obig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119384;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=RJEUqH4qMriwMMJtAI/+HT3h3R27F39qGOZSBdMYbuE=;
	b=Ywr8fIF8bX2v5AEkU8xuZpzLNBK8UT3Q5qt9LY5WpKIs/zVTLzlE3/PTRN63s81wVPmL
	 B/5VXhlSU9VuXm9WBdJzPdjmL0m7FBJnIW3WW5x1rzDZe6yAQCfIabXHwtjpIdgsEbviF
	 ActCogfXkFPQN79on5TXTIbFUk2YrG+WHxa1rWC1BzsBGHlaAnsDBqPBYzoScjoxUAAll
	 u9J4yJqiJ+JyFvYsI/V5kU68pr18xNL2TFEI+eICYa/v/iJXmq9ObtHEI3xipqcp3wOPL
	 YZ9ZgCC/SgDDAxRdU0cRcag/IOTSBALCIyfdaMg5Fq512Uvl4E3zwHWcKDjEBXIO7GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iHhGgy3d;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BA4606A324;
	Thu, 19 Nov 2026 20:16:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2BA4606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iHhGgy3d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119377;
	bh=RJEUqH4qMriwMMJtAI/+HT3h3R27F39qGOZSBdMYbuE=;
	h=From:To:Cc:Subject:Date:From;
	b=iHhGgy3d4lRMN9V8QbR0XBgSyd8VVIbLvs+1gCbqHAPyRhxOfRENvvLb7mCNf7ZX9
	 lnfk2s/T1SEqri1gbRDDE/JrBo3SMPIil8OCb5J7Q4dqhedC2u9yoiGu1GbW9aXw62
	 DTUIzA3WJS8TT8drWYrMvcBL7Y2h91ISb7aJYhwwHpEC560hWFBpjjyud7Kd4kTyvK
	 D2sZA6YZof56lXKNT/c4x891V9AV2j6QR90DRipwiZzJbaAnkb8ho7jglEUOTIH8Km
	 UfMroUt0MyzDguit/D2g1VRthAElE9VoOeVwz0Nku/LsUyQrKPVbQG2HCihqmyQbWL
	 JN/qk6J0VeRkw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVT3gPVzTd9;
	Thu, 19 Nov 2026 15:16:17 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v8 00/33] sched/deadline: bandwidth accounting fixes and selftests
Date: Thu, 19 Nov 2026 15:15:39 -0500
Message-Id: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
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

This is v8 of this series. As Juri proposed, its first 14 patches now
form their own series [1]. That series also takes the 0-lag overflow
fix posted alone [3]. It adds deadline_switch_test, and the cases of
deadline_bw_test that pass with its fixes. This series applies on top
of it, and holds the rest of v7.

This series fixes 26 bugs of SCHED_DEADLINE. Most of them are in its
bandwidth accounting. As Juri asked, the patches come in groups, one
per theme. Each group ends with the cases of deadline_bw_test that test
its fixes. The fixes carry Cc: stable. The test patches do not.

One of the bugs takes the kernel down (patch 13). Two let an owner in
the rtmutex chain walk keep a donor that can exit. The owner would then
read freed memory (patches 20 and 21). These two also close the known
limit that patch 11 of the first series describes. One leaves a task
that never runs again (patch 24). Most of the others leave total_bw of
a root domain, or this_bw of a runqueue, wrong. The root domain then
admits deadline tasks beyond its capacity, or refuses every one.

Juri, your fix 1/4 that Ingo dropped from sched/urgent is patch 3. The
other three are in the first series.

The groups
==========

The rebuild of the root domains' accounting (1-6):
 1  Keep the bandwidth of departing tasks across a root domain rebuild.
 2  Rebuild the root domains' accounting from the task list.
 3  Record the root domain that holds a task's bandwidth.
 4  Leave out of a rebuild a dying task that released its bandwidth.
 5  Add deadline_rebuild_test.
 6  Add the 7 cases of deadline_bw_test for this group.

cpuset attach (7-12):
 7  Move a task's bandwidth only where an attach made room for it.
 8  Wait for an attach before rebuilding the sched domains.
 9  Make a policy or affinity change of a deadline task wait for a
    cpuset attach in progress.
 10 Give back the bandwidth an attach did not move.
 11 Reserve an attach's bandwidth in the root domain each task moves to.
 12 Add the 22 cases of deadline_bw_test for this group.

The root domain of a task, with partitions and isolcpus=domain (13-18):
 13 Make a rebuild count a task in the root domain it runs in.
 14 Move a task's bandwidth to the root domain it runs in.
 15 Pick a CPU for a task in the root domain that counts its
    bandwidth, when that root domain has one.
 16 Refuse to take offline the last CPU a task has in the root domain
    that counts its bandwidth. Also refuse an offline that moves a
    deadline task of a child partition to another root domain.
 17 Refuse a cpuset change that leaves a deadline task no CPU in the
    root domain that counts its bandwidth.
 18 Add the 24 cases of deadline_bw_test for this group.

extra_bw (19):
 19 Count only the active CPUs when a change of total_bw is spread over
    extra_bw, at an offline migration and at a rebuild.

The rtmutex chain walk (20-22):
 20 Continue the chain walk when the deadline donor of a waiter
    changes, so that no owner keeps a donor that can exit.
 21 Continue the chain walk when the top pi waiter of an owner moves to
    another lock. The next owner then gets the new priority or donor.
 22 Add the 2 cases of deadline_bw_test for this group.

Deadline boosts (23-28):
 23 Start a new period at a deboost in the class, if the boost
    refilled the task's runtime from its donor.
 24 Replenish a throttled task that a waiter boosts while it sleeps, so
    that it runs again.
 25 Count in this_bw the bandwidth a boosted task is given.
 26 Give a deadline to a task that enters the class while it waits on
    an rt_mutex.
 27 Start a new period at a deboost out of the class, if the boost
    refilled the task's runtime from its donor. Its bandwidth is then
    released at once.
 28 Add the 7 cases of deadline_bw_test for this group.

Parameter changes (29-33):
 29 Cancel the replenishment timer with the parameters.
 30 Cap the runtime left of a constrained task at dl_runtime when its
    parameters change.
 31 Check the runtime left of a task that comes back to the class
    runnable, as a wakeup does.
 32 Check the runtime left of a runnable task whose parameters change.
 33 Add the 6 cases of deadline_bw_test for this group.

Patches 3 to 17 go together. 3 records the root domain that counts a
task's bandwidth. The fixes from 4 to 14 fix the rebuild, attach and
migration paths that the record exposes. 15 to 17 keep a task in the
root domain that counts it, as long as that root domain has a CPU for
it. Patch 19 changes code that these fixes rework, so it comes after
them. Patch 25 completes "sched/deadline: Fix this_bw when a task is
changed during a remote wakeup", of the first series.

Peter, patches 20 and 21 change the rtmutex chain walk. In 20, a waiter
records its deadline donor with its sort keys. 21 removes a test that
stopped the walk too early. The step before can move the top pi waiter
of an owner to another lock. The owner then changed, but the walk
stopped at it. The test dates from the rtmutex core, and the early stop
hits RT priorities too.

Three patches also touch the core scheduler. Patch 9 touches
__sched_setscheduler() and sched_setaffinity(). A change of a deadline
task waits there for a cpuset attach in progress. Patch 11 touches
__set_cpus_allowed_ptr_locked(). A cpuset attach can reserve a deadline
task's bandwidth in one root domain. If the CPU picked for the task is
in the other one, the patch steers the task to the reserved CPU. Patch
15 touches select_fallback_rq() and __set_cpus_allowed_ptr_locked() for
deadline tasks. When select_fallback_rq() widens the mask of a deadline
task, the wider mask can leave its root domain. Patch 15 then gives the
task the CPUs of its root domain instead. At a CPU offline, the cpuset
update that comes next sets the real mask.

Waiman, patches 16 and 17 add refusals. They apply when a change would
leave a deadline task no CPU in the root domain that counts it. That
needs a cpuset with CPUs of two root domains: with isolcpus="domain", or
on cgroup v1 with sched_load_balance off. A CPU offline or a write to
cpuset.cpus then fails with EBUSY. cpuset makes a partition root
invalid, with a new reason. Nothing is refused with admission control
off (sched_rt_runtime_us set to -1). Patch 16 now works out the CPUs a
cpuset gets from the top down, as cgroup v2 does. It also refuses an
offline that makes a child partition invalid, when a deadline task in it
would change root domain.

Known limits
============

The fixes leave these cases open. Each patch named below also states
its limit in its message.

- Patches 20 and 21: when the donor of a chain changes, the owners
  further down keep the old donor until the walk reaches them. The donor
  pointer holds no reference. If the old donor exits first, they would
  read freed memory. Its exit starts no walk when it is not the top
  waiter of its lock. This was found by reading.
- Patch 1: a task that left the class keeps its bandwidth until its
  0-lag time. A rebuild still drops it earlier if the CPU of the task
  is inactive, or if the task dies during the rebuild.
- Patch 14: a task can run in a root domain that does not count its
  bandwidth. The bandwidth then moves there without a check for room,
  as dl_task_offline_migration() does upstream.
- Patch 15: a CPU picked while the sched domains are rebuilt has no
  preference for a root domain, as upstream. No bandwidth moves
  meanwhile, nor before the walk of the task list that follows reaches
  the task. But a wakeup can pick its CPU in that window, and be queued
  after the walk counted the task. Its bandwidth can then move to the
  other root domain with no check for room. Push and pull between the
  two root domains during the rebuild are part of the same limit. This
  was found by reading, not reproduced.
- Patches 15 to 17: a task with no CPU left in the root domain that
  counts it still moves, and its bandwidth with it. With admission
  control on, patches 16 and 17 refuse the CPU offline and the cpuset
  changes that I found to lead there. Nothing is refused during a
  suspend, or with admission control off.
- A cpuset that holds isolated and housekeeping CPUs still admits a
  deadline task. Juri pointed at the XXX in dl_bw_capacity() for this
  in the v5 thread. It is left for later.

Testing
=======

On top of the first series, the 123 cases pass wherever they run.
They ran with lockdep, and logged no kernel warning. The 20 QEMU guests
are of seven kinds:
- 5 guests of 8 vCPUs, one with proxy execution off, and 1 of 4 vCPUs.
- 3 guests with PREEMPT_RT, of 8, 8 and 4 vCPUs.
- 3 guests without CONFIG_CPUSETS, of 4, 4 and 5 vCPUs.
- 4 guests of 5 vCPUs booted with isolcpus=domain,1,2 or
  isolcpus=domain,0,1, 2 of them with PREEMPT_RT.
- 1 guest of 7 vCPUs booted with isolcpus=domain,0,1.
- 1 guest of 8 vCPUs booted with isolcpus=domain,6,7.
- 2 guests with CONFIG_RT_GROUP_SCHED, of 8 and 4 vCPUs.
The 25 isolcpus cases run in the guests of the fourth and fifth kinds.
In the fourth, the cases that need 4 CPUs that are not isolated skip.
rebuild_waking_keeps also skips with isolcpus=domain,1,2: it needs the
first CPU isolated. Some of them also run in the guest of the sixth
kind. move_cancelled runs only in the guests of the last kind.

At each test patch, the cases added so far pass in 12 of these guests,
with no kernel warning:
- 3 of 8 vCPUs, one with proxy execution off, and 1 with PREEMPT_RT.
- 2 without CONFIG_CPUSETS.
- 5 booted with isolcpus=domain, one of them with PREEMPT_RT.
- 1 with CONFIG_RT_GROUP_SCHED.

No guest combines isolcpus=domain with a kernel without CONFIG_CPUSETS.
Such a kernel hits a BUG at boot on v7.4-rc2 with isolcpus=domain,0,1
[2].

On v7.4-rc2, the cases that the test patches add fail as they list. The
three cases of deadline_rebuild_test fail there too.

Each case added for a fix fails without that fix. Each fix names the
cases that test it, and the test patches list the rest. These cases are
exceptions:
- deboost_blocked_keeps_order passes on v7.4-rc2, and fails on v5.
- return_asleep_new_params passes everywhere. It covers the wakeup
  path that patches 31 and 32 copy.
- deboost_keeps_own_runtime passes with and without the flag of patch
  23. It checks that a task keeps the runtime of its own reservation.
- pi_chain_donor_leaves passes on v7.4-rc2 and with the first series.
  It fails on v6.
- deboost_new_params_reboost and rebuild_record_taken pass on
  v7.4-rc2. They test bugs of v7 of this series, and fail there.
- hotplug_child_partition_kept tests a refusal that is not needed.
  v7 refuses it too, by reading. On v7.4-rc2, it fails in 2 of 8 runs.

Each of the 33 patches builds alone, on top of the first series. At
each test patch, the series also builds without CONFIG_CPUSETS, with
PREEMPT_RT and with CONFIG_RT_GROUP_SCHED. The selftests build there
with no warning. kernel/sched/ also builds without CONFIG_RT_MUTEXES. The
cpuset selftest test_cpuset_prs.sh passes, with and without PREEMPT_RT.

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
- the Sashiko AI reviews of v1 to v7, and of the first series. Each
  finding was checked against the code first.
- a second LLM read of the fixes proposed for the Sashiko findings. It
  found the gaps fixed in patches 15 and 26.

Changes since v7
================

- The first 14 patches of v7 are in the first series [1]: v7 1-8, 10,
  13, 14, 16, 20 and 37.
- The patches come in groups, one per theme, as Juri asked. Each group
  ends with the cases of deadline_bw_test that test it. The test of v7
  is split along the groups. deadline_rebuild_test comes with the
  rebuild group.
- The messages credit the Sashiko AI review without the number of the
  posting, as Juri suggested.
- New patch 21, from the Sashiko review of v7. The rtmutex chain walk
  stopped at an owner whose top pi waiter had moved to another lock.
  The next owner kept the old priority, or a deadline donor that can
  exit. The test dates from the rtmutex core. pi_chain_top_moves and
  pi_chain_top_moves_rt test it.
- Patch 20 cites pi_chain_top_moves. In v7, it cited
  pi_chain_donor_leaves. On top of the first series, that case passes
  without patch 20. pi_chain_top_moves needs both patches 20 and 21.
- New patch 19: "sched/deadline: Count only active CPUs when spreading
  extra_bw", posted alone before [3].
- New patch 27, from the Sashiko review of the first series. A task
  deboosted out of the class after a refill from its donor got a wrong
  0-lag time. It mixed the donor's runtime and deadline with its own
  parameters. Its bandwidth was then released too early or too late.
  deboost_out_after_donor_refill tests it.
- Fixes to v7 patches, from the same review:
  - 9: the restore of the old mask reads the cpuset mask again after
    the wait.
  - 13: with no active CPU in its mask, a task is counted in its
    cpuset. The CPU recorded is kept only if the cpuset holds it. The
    record is read once. It reads the CPUs isolated at boot.
    HK_TYPE_DOMAIN is updated only after the rebuild.
    rebuild_record_taken tests it.
  - 14: once the walk of the task list after a rebuild has counted a
    task, its bandwidth can move again. v7 blocked moves until the end
    of the walk. A task that the walk had counted could then run in the
    other root domain. It stayed counted in the old one until its next
    wakeup.
  - 14: the proxy execution check added in v7 is removed. It also
    skipped ordinary migrations of a task blocked on a mutex. It stays
    in the proxy execution RFC.
  - 15: select_fallback_rq() keeps a deadline task in its root domain
    when it widens the mask. On v7, a deadline task with a period of
    2ms that spun on the CPU going offline left its root domain in
    every test run. hotplug_fallback_running tests it. The offline
    migration of a throttled task moves no bandwidth during a rebuild,
    nor before the walk has counted the task. A sleeping task whose new
    mask keeps its CPU in the root domain wakes up there.
  - 16: the CPUs a nested cpuset gets after an offline are computed from
    the top down. hotplug_nested_refused tests it. A partition root left
    with no CPU of its own takes those of a child partition, as cpuset
    does. The offline is refused if that moves a deadline task to
    another root domain. hotplug_child_partition_kept and
    hotplug_partition_invalid_refused test it. These were found by
    reading, and reproduced before the fix.
  - 26: a blocked task starts a new period only when its donor changes.
    v7 started one at each boost, also with the same donor. Each step
    of a chain walk then changed the deadline. With patch 21, a walk in
    a ww_mutex cycle on PREEMPT_RT would go on until max_lock_depth.
    This was found by reading.
  - 32: the new parameters of a boosted task are checked at its
    deboost, before the test that boosts it again.
    deboost_new_params_reboost tests it.

Not changed:
- sched_setattr() still fails with EPERM for a task moved asleep to
  another partition, or asleep on a CPU that went offline. The task is
  still on a CPU of the old root domain, and the affinity check of
  __sched_setscheduler() reads that one. The check is upstream code,
  and it refuses but never admits wrongly.
- An attach whose mask keeps a CPU of the task's root domain reserves
  nothing. The task then stays in that root domain.
- A write to cpuset.cpus that makes a partition root invalid is not
  refused. A deadline task can then run in a root domain that did not
  admit it, as upstream. A write of "member" does the same and cannot
  fail. The next rebuild counts the task where it runs.

Posted separately, as v7 announced: the report of the boot BUG with
isolcpus=domain and no CPUSETS [2].

Based on the first series [1]. That series is based on
tip sched/urgent, ec6f6731538e (v7.4-rc2).

[1] https://lore.kernel.org/all/cover.1795115075.git.mathieu.desnoyers@efficios.com/
[2] https://lore.kernel.org/lkml/20261117144817.265109-1-mathieu.desnoyers@efficios.com/
[3] https://lore.kernel.org/all/cover.1794926626.git.mathieu.desnoyers@efficios.com/

v7: https://lore.kernel.org/all/cover.1794922146.git.mathieu.desnoyers@efficios.com/
v6: https://lore.kernel.org/all/20261116190549.230119-1-mathieu.desnoyers@efficios.com/
v5: https://lore.kernel.org/all/20261108185406.1549770-1-mathieu.desnoyers@efficios.com/
v4: https://lore.kernel.org/all/20261107014451.1487825-1-mathieu.desnoyers@efficios.com/

Mathieu Desnoyers (33):
  sched/deadline: Keep departing bandwidth across a root domain rebuild
  sched/deadline: Rebuild the root domains' accounting from the task
    list
  sched/deadline: Record the root domain holding a task's bandwidth
  sched/deadline: Leave a dying task out of a rebuild of the accounting
  selftests/sched: Test SCHED_DEADLINE bandwidth across a root domain
    rebuild
  selftests/sched: Test the root domain rebuild in deadline_bw_test
  sched/deadline: Move a task's bandwidth only where room was made
  cgroup/cpuset: Wait for an attach before rebuilding the sched domains
  sched: Make deadline policy and affinity changes wait for a cpuset
    attach
  cgroup/cpuset: Give back the bandwidth an attach did not move
  cgroup/cpuset: Reserve the bandwidth in the root domain a task moves
    to
  selftests/sched: Test cpuset moves in deadline_bw_test
  sched/deadline: Make a rebuild count a task in the root domain it runs
    in
  sched/deadline: Move a task's bandwidth to the root domain it runs in
  sched/deadline: Keep a task in the root domain that counts its
    bandwidth
  sched/deadline: Keep the last CPU a task has in its root domain
  cgroup/cpuset: Refuse to take a deadline task out of its root domain
  selftests/sched: Test the root domain of a task in deadline_bw_test
  sched/deadline: Count only active CPUs when spreading extra_bw
  rtmutex: Continue the chain walk when a waiter's deadline donor
    changes
  rtmutex: Continue the walk when the owner's top waiter changes lock
  selftests/sched: Test the rtmutex chain walk in deadline_bw_test
  sched/deadline: Reset the donor's runtime at a deboost in the class
  sched/deadline: Replenish a throttled task boosted while asleep
  sched/deadline: Count the bandwidth a boosted task is given
  sched/deadline: Start a period for a task that enters the class
    blocked
  sched/deadline: Start a period at a deboost out of the class
  selftests/sched: Test deadline boosts in deadline_bw_test
  sched/deadline: Cancel the replenishment timer with the parameters
  sched/deadline: Cap the runtime left of a constrained task at
    dl_runtime
  sched/deadline: Check the runtime of a task that comes back runnable
  sched/deadline: Check the runtime of a task whose parameters change
  selftests/sched: Test parameter changes in deadline_bw_test

 include/linux/cpuset.h                        |   28 +-
 include/linux/sched.h                         |   38 +
 include/linux/sched/deadline.h                |   39 +-
 kernel/cgroup/cgroup.c                        |    3 -
 kernel/cgroup/cpuset-internal.h               |   15 +-
 kernel/cgroup/cpuset.c                        |  751 +-
 kernel/locking/rtmutex.c                      |   46 +-
 kernel/locking/rtmutex_api.c                  |    2 +-
 kernel/locking/rtmutex_common.h               |    3 +
 kernel/sched/core.c                           |  134 +-
 kernel/sched/deadline.c                       | 1337 +++-
 kernel/sched/sched.h                          |   20 +
 kernel/sched/syscalls.c                       |   87 +-
 kernel/sched/topology.c                       |   11 +
 .../selftests/sched/deadline/.gitignore       |    1 +
 .../testing/selftests/sched/deadline/Makefile |    2 +-
 .../sched/deadline/deadline_bw_test.c         | 6191 ++++++++++++++++-
 .../sched/deadline/deadline_rebuild_test.c    |  497 ++
 18 files changed, 8815 insertions(+), 390 deletions(-)
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_rebuild_test.c


base-commit: ec6f6731538e0d45872eb279fdeb477bed152d6f
prerequisite-patch-id: 5e2478ffdfb7583751bf44bdf87fb930bc23551b
prerequisite-patch-id: d5e5ef986ff2d9bc39a87b56e96a2acbd3158687
prerequisite-patch-id: 99e47f80396008ee2b2576157d37842481ce52d2
prerequisite-patch-id: a10824f98c11a4c902dad55cab3ec03b3dbe2c8a
prerequisite-patch-id: 8959e5a408641b4fa81bc79737cd17d5f1b03389
prerequisite-patch-id: 16acf1d18f01d20310d6db767dfbec2f072e0372
prerequisite-patch-id: e1946bb015a7b14ed4e2cd0421e5e30b0c7afdda
prerequisite-patch-id: 4daf48a89779fbd8c8bc5fc1d7a7d6df9bca2d9d
prerequisite-patch-id: 980d8045f9fe8c3757bb3d82c61d68e321cf74bb
prerequisite-patch-id: 4e79615a88d73e3018b5633b6e5abfc1e5d2c06d
prerequisite-patch-id: fb69a0665dc38ca9022cc2bd75234a90e2035b7f
prerequisite-patch-id: 7a115ab83ad96ffaf8e833e0eaeb75f859af2e79
prerequisite-patch-id: 8574b50d81a09ec6091e42d65338adcab2986d71
prerequisite-patch-id: 1aa25df96d60d30f549c71fdfba5589cb239928f
prerequisite-patch-id: d38384e0b7d043a3556ee02fb09316a6227038da
prerequisite-patch-id: 83ded04a76ecf973e2b8c6e04ff83c2b7278915a
prerequisite-patch-id: b8f5d9f9146e887050bbd8ad30463fd81cad9411
-- 
2.47.3

