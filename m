Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207356;
	b=c1ilNYm1Eylp4d5yjQ9dr4Ipl6xQtnLcGDT9UXkltg5+ilZlItN8xP3b0XfiS/q2BFh2
	 Ks0UDp/ki3mvYqthywzzsKJhY4XOuKrgp3uWBcXOFCdAILcF43NpxOqKKDhAPZOJFN4cD
	 GO72TE8Glt2FxEQCehPaaArf+NPucywfygZP1QYuhl4coYZ0qwEAHYjn7mNPDz9lnX566
	 +kqYBixZrCTJdZuRPeIgjDJluKXEINx40qeRKNrIN5wn1eOZ5qE2rKcwfUfHFhvSvd6FK
	 FwEobDt8xf2Cdy5sz22I8TnukUH/I8aZEpBWuiTCJtmV4VF0yE8cZ3ZBJqY/rGjF7lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207356;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=n2p4ubH8pkZNl1bnBdEC5qvd0NQ88u9KuD7B6vTPppA=;
	b=5UehGsIqKt+GDdcQdOId/BphaP/tXfnz53gYUKya2m3eRLZB20uWHqD9ElO4Zgihjabd
	 w1A1x0AAE+29mBTnI2HRIN3qEbAgdq6Zox8p4+8COEqNXUlKAdZdwYsZddr+HbgGI0cK/
	 fVLGrcSPJ5ll7/rtsrrfVHGB3p6ujnCbr40jCnTzQuQpLy7WTYB2iXlC+e3RGY+YT74ob
	 5bfDc9elfhJuwfS+6YLDfHJ7NpGg6xMpbH7/eGHztnsmonN1SCkw5C4UxfN1ZQ0OQCQ0h
	 UV6OHbniAkFmYJjVslV7GYjkbAJxM/JUINYeSDj+cQlIi1mL8VnR8aK2AZymr/du5kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vBbj9r0u;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F3C606A6E1;
	Fri, 20 Nov 2026 20:42:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6F3C606A6E1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vBbj9r0u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207344;
	bh=n2p4ubH8pkZNl1bnBdEC5qvd0NQ88u9KuD7B6vTPppA=;
	h=From:To:Cc:Subject:Date:From;
	b=vBbj9r0u8gu9s+84PMQyIfkTwBZVbXyfTuz1RL/9/VSQlreoTbCWdtWSV9LrM2P9c
	 U8e2m69f//eUBfHoQsJWVNCV5TchoTGVVF2regV3hXZzPlRTVuAMpAmlhmI3jlWsOu
	 Llq7UPgOcq6MFNLOo+OdX9IOztPyuDuSRRWWWQ9YpOFzPrlwqPQ36IeW/8CJx2tUdV
	 UEqRLJWt/FuYn604DqqxHGG7Ya7zSverAdbttDS0/tszYRFW3W8k9JH1ccSJvDEY2a
	 mhBLDBTFPkMKViZI68SMuC/uY3NQ3aLuK5u8G4FFZGEdhzLcfzNWfdQA1cQ0RJO0D7
	 Ce4H4ZwR0idxA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS271DQpzTqT;
	Fri, 20 Nov 2026 15:42:23 -0500 (EST)
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
Subject: [PATCH v10 00/40] sched/deadline: bandwidth accounting fixes and selftests
Date: Fri, 20 Nov 2026 15:41:37 -0500
Message-Id: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
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

This is v10 of this series. It applies on top of the first series [1],
with its updated patch 10 [3]. v10 fixes the findings of the Sashiko AI
review of v9, and the older bugs that v9 left for a follow-up. It adds
six fixes and 14 cases. The changes since v9 are at the end.

This series fixes 32 bugs of SCHED_DEADLINE. Most of them are in its
bandwidth accounting. As Juri asked, the patches come in groups, one
per theme. Each group ends with the cases of deadline_bw_test that test
its fixes. The fixes carry Cc: stable. The test patches do not.
Patch 23 needs commit 8671bad873eb ("sched: Do not call
__put_task_struct() on rt if pi_blocked_on is set") on stable trees
older than v6.17.

One of the bugs takes the kernel down (patch 13). Three let an owner in
the rtmutex chain walk keep a donor that can exit. The owner would then
read freed memory (patches 21 to 23). These also close the known limit
that patch 11 of the first series describes. One leaves a task that
never runs again (patch 26). Most of the others leave total_bw of a
root domain, or this_bw of a runqueue, wrong. The root domain then
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
 12 Add the 24 cases of deadline_bw_test for this group.

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
 18 Add the 28 cases of deadline_bw_test for this group.

extra_bw (19-20):
 19 Count only the active CPUs when a change of total_bw is spread over
    extra_bw, at an offline migration and at a rebuild.
 20 Divide that change on 64 bits: a sum of bandwidths can pass S32_MAX.

The rtmutex chain walk (21-24):
 21 Continue the chain walk when the deadline donor of a waiter
    changes, so that no owner keeps a donor that can exit.
 22 Do not stop the chain walk at an owner whose top waiter changed.
    The next owner then gets the new priority or donor.
 23 Hold a reference on the deadline donor of a boosted task.
 24 Add the 2 cases of deadline_bw_test for this group.

Deadline boosts (25-31):
 25 Start a new period at a deboost in the class, if the boost
    refilled the task's runtime from its donor.
 26 Replenish a throttled task that a waiter boosts while it sleeps, so
    that it runs again.
 27 Count in this_bw the bandwidth a boosted task is given.
 28 Give a deadline to a task that enters the class while it waits on
    an rt_mutex.
 29 Start a new period at a deboost out of the class, if the boost
    refilled the task's runtime from its donor. Its bandwidth is then
    released at once.
 30 Give a new period to a sleeping task that FUTEX_CMP_REQUEUE_PI
    requeues onto an rt_mutex, if its deadline is 0 or has passed.
 31 Add the 10 cases of deadline_bw_test for this group.

Parameter changes (32-39):
 32 Cancel the replenishment timer with the parameters.
 33 Cap the runtime left of a constrained task at dl_runtime when its
    parameters change.
 34 Check the runtime left of a task that comes back to the class
    runnable, as a wakeup does.
 35 Check the runtime left of a task whose parameters change.
 36 Reschedule a running task that its enqueue throttles.
 37 Keep the start of the period across a change of dl_deadline.
 38 Boost an owner that cannot run on its own reservation: one that is
    throttled, or past its deadline and before its next period.
 39 Add the 15 cases of deadline_bw_test for this group.

Patch 40 moves the helpers that the three deadline selftests share to
a header.

Patches 3 to 17 go together. 3 records the root domain that counts a
task's bandwidth. The fixes from 4 to 17 fix the paths that the record
exposes. Patch 19 changes code that these fixes rework, so it comes
after them. Patch 27 completes "sched/deadline: Fix this_bw when a task
is changed during a remote wakeup", of the first series. Patch 38 needs
patches 36 and 37, so it comes after them.

Peter, these patches change the rtmutex code or the PI boost:
- 21: a waiter records its deadline donor with its sort keys.
- 22: two early stops of the chain walk are removed. The early stop
  also hits RT priorities.
- 23: a boosted task holds a reference on its donor. dl_set_donor()
  takes it with tryget_task_struct(), since it reads the donor without
  the waiter's locks.
- 30: task_blocks_on_rt_mutex() refreshes the deadline of a task that
  FUTEX_CMP_REQUEUE_PI requeues.
- 38: rt_mutex_setprio() boosts a deadline owner that cannot run on
  its own reservation.

These patches also touch the core scheduler:
- 3: the affinity check of a deadline task in __sched_setscheduler().
- 9: __sched_setscheduler() and sched_setaffinity() wait for a cpuset
  attach in progress.
- 11: __set_cpus_allowed_ptr_locked() steers a task to the CPU that an
  attach reserved.
- 15: select_fallback_rq() and __set_cpus_allowed_ptr_locked() keep a
  deadline task in its root domain.

Waiman, patches 16 and 17 add refusals. A CPU offline or a cpuset.cpus
write fails with EBUSY if it leaves a deadline task no CPU in the root
domain that counts it. A write that makes a partition root, or makes
it grow, still succeeds. cpuset then makes the partition invalid, with
a new reason. This needs a cpuset with CPUs of two root domains, and
admission control on. Patch 16 also refuses an offline that makes a
child or a sibling partition invalid, when a deadline task in it would
change root domain.

Known limits
============

These cases stay open:
- Patch 1: a task that left the class keeps its bandwidth until its
  0-lag time, unless a rebuild drops it earlier.
- Patch 14: a task can run in a root domain that does not count it.
  Its bandwidth then moves there with no check for room, as at an
  offline migration upstream.
- Patch 15: a wakeup can pick a CPU while the sched domains are
  rebuilt. The task's bandwidth can then move to the other root domain
  with no check for room. This was found by reading.
- Patches 16 and 17 refuse nothing during a suspend, or with admission
  control off. A task left with no CPU in its root domain then moves,
  with its bandwidth.
- Patch 17: a partition that grows can make its child partition valid.
  The parent's tasks were not admitted on the child's CPUs. A rebuild
  accepts the same split today.
- A cpuset with isolated and housekeeping CPUs still admits a deadline
  task: the XXX in dl_bw_capacity() that Juri pointed at in the v5
  thread.
- A waiter of an rt_mutex keeps the deadline it blocked with, as on
  v7.4-rc2. A constrained waiter woken past its deadline is throttled.
  The lock then has no owner to boost for up to dl_period -
  dl_deadline. Juri, should a waiter that gets the lock go on with its
  late job, as a queued task past its deadline does? That changes the
  CBS rules, so I left it out.
- A waiter does not boost an owner that runs out of runtime after the
  waiter blocked. Nor one that wakes up in its constrained gap then.
  The owner stays throttled until its next period, as on v7.4-rc2.

Testing
=======

On top of the first series, the 141 cases pass wherever they run, with
lockdep and no kernel warning. They ran in 20 QEMU guests of 4 to 8
vCPUs:
- with proxy execution on and off.
- with PREEMPT_RT.
- without CONFIG_CPUSETS.
- with CONFIG_RT_GROUP_SCHED.
- booted with isolcpus=domain on CPUs 1-2, 0-1 or 6-7, some with
  PREEMPT_RT.
The 26 cases that need isolated CPUs skip in the guests without
them. No
guest combines isolcpus=domain with a kernel without CONFIG_CPUSETS:
such a kernel hits a BUG at boot on v7.4-rc2 [2].

At each test patch, the cases added so far pass in 12 guests of the
same kinds. Three guests with kmemleak ran the whole series: no leak.

Each fix names the cases that test it. The test patches list the cases
that fail on v7.4-rc2. Three changes have no case:
- patch 20: it needs more than 2048 CPUs of deadline bandwidth.
- patch 23: it needs a chain walk preempted at the right step.
- the change of patch 15 in dl_task_offline_migration(): it needs a
  timer that fires between a CPU going inactive and the cpuset update.

Each of the 40 patches builds alone, on top of the first series. At
each test patch, the series also builds without CONFIG_CPUSETS, with
PREEMPT_RT and with CONFIG_RT_GROUP_SCHED. The selftests build there
with no warning. Each patch also builds with tinyconfig, without
CONFIG_RT_MUTEXES. The cpuset selftest test_cpuset_prs.sh passes, with
and without PREEMPT_RT.

These were not tested:
- cgroup v1 cpusets.
- threaded cgroups: every move is a write to cgroup.procs.
- the sched_ext server.
- CPUs of unequal capacity.

How this was developed
======================

An LLM coding assistant wrote these patches, their messages and the
tests, under my direction and review. I know the concepts behind
SCHED_DEADLINE, but not its implementation well. So I ask those who
know this code for a careful reading of the fixes. A reproducer that
stops failing shows that the symptom goes away. It does not show that
the fix is the one you would have written.

The bugs came from:
- flaky cgroup selftests of a feature I am developing.
- the review of Juri's four fixes, and his review of v5.
- building deadline_bw_test, and reading the code.
- the Sashiko AI reviews of v1 to v9, and of the first series. Each
  finding was checked against the code first.
- second LLM reads of the fixes and of the harder findings. They found
  the gaps fixed in patches 15, 23 and 28. One of them also proposed
  the design of patch 38.
- kmemleak, which found a leaked task_struct in an early version of
  patch 23.

Changes since v9
================

From the Sashiko AI review of v9:
- 16: an offline that makes a sibling partition invalid is refused too.
  The partition left with tasks and no CPU makes its parent take the
  CPUs of a later child. hotplug_sibling_partition_refused tests it.
- 17: the check reads the CPU mask of the task. In a
  migrate_disable() section, cpus_ptr holds one CPU only.
- 22: the second check that stopped the walk early is removed too.
  The subject changed with it.
- 23 (new): a boosted task holds a reference on its donor. A chain walk
  can be preempted, and the donor can exit before it reaches the owner.
- 25: a deboost in the class cancels the inactive timer that the
  donor's refill armed. deboost_in_asleep_after_refill tests it.
- 28: a new donor is detected from the donor that dl_set_donor()
  installed, not from a second read of the waiter's donor.
- 31: in deboost_out_asleep_after_refill, the main thread reads
  total_bw, not the donor. A slow read could move the donor's 0-lag
  time past the check.
- 35: rt_mutex_setprio() deboosts a task with new parameters before it
  compares it with its top waiter. sched_setattr() checks a task blocked
  on an rt_mutex at once, also when it comes back to the class. A task
  asleep on anything else keeps the check for its wakeup.
- 36 (new): a running task throttled at its enqueue is rescheduled.
- 37 (new): the start of a period is kept across a change of
  dl_deadline.
- 38 (new): a waiter boosts an owner that cannot run on its own
  reservation. At the deboost, the owner gets back its own deadline and
  runtime.

From the follow-up list of v9, and older reviews:
- 3: sched_setattr() can make a deadline task of a fair task moved
  asleep to another partition. It admits it in the root domain of an
  active CPU of its new mask. So in move_became_deadline_no_room, a
  change after the move now fails with EBUSY, not EPERM.
- 15: an offline migration keeps a task in its root domain before it
  warns.
- 17: a valid partition recovery is no longer refused with
  PERR_DLTASK.
- 20 (new): the 32-bit cast of a bandwidth sum.
- 30 (new): the deadline of a task requeued onto an rt_mutex.
- 35: a comment in dl_time_to_zerolag() explains the 0-lag time
  between a change of parameters and its check, as Juri asked.
- 40 (new): the shared helpers of the deadline selftests.

Based on the first series [1], with its updated patch 10 [3]. That
series is based on tip sched/urgent, ec6f6731538e (v7.4-rc2).

[1] https://lore.kernel.org/all/cover.1795115075.git.mathieu.desnoyers@efficios.com/
[2] https://lore.kernel.org/lkml/20261117144817.265109-1-mathieu.desnoyers@efficios.com/
[3] https://lore.kernel.org/all/d975f317a4f9f79d2300b68ad76664755459ba36.1795181168.git.mathieu.desnoyers@efficios.com/
v9: https://lore.kernel.org/all/cover.1795181240.git.mathieu.desnoyers@efficios.com/
v8: https://lore.kernel.org/all/cover.1795116790.git.mathieu.desnoyers@efficios.com/
v7: https://lore.kernel.org/all/cover.1794922146.git.mathieu.desnoyers@efficios.com/
v6: https://lore.kernel.org/all/20261116190549.230119-1-mathieu.desnoyers@efficios.com/
v5: https://lore.kernel.org/all/20261108185406.1549770-1-mathieu.desnoyers@efficios.com/
v4: https://lore.kernel.org/all/20261107014451.1487825-1-mathieu.desnoyers@efficios.com/

Mathieu Desnoyers (40):
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
  sched/deadline: Do not truncate a bandwidth to 32 bits in
    __dl_add/sub()
  rtmutex: Continue the chain walk when a waiter's deadline donor
    changes
  rtmutex: Do not stop the chain walk at an owner whose top waiter
    changed
  sched/deadline: Hold a reference on the deadline donor of a boosted
    task
  selftests/sched: Test the rtmutex chain walk in deadline_bw_test
  sched/deadline: Reset the donor's runtime at a deboost in the class
  sched/deadline: Replenish a throttled task boosted while asleep
  sched/deadline: Count the bandwidth a boosted task is given
  sched/deadline: Start a period for a task that enters the class
    blocked
  sched/deadline: Start a period at a deboost out of the class
  sched/deadline: Start a period for a task requeued onto an rt_mutex
  selftests/sched: Test deadline boosts in deadline_bw_test
  sched/deadline: Cancel the replenishment timer with the parameters
  sched/deadline: Cap the runtime left of a constrained task at
    dl_runtime
  sched/deadline: Check the runtime of a task that comes back runnable
  sched/deadline: Check the runtime of a task whose parameters change
  sched/deadline: Reschedule a running task throttled at its enqueue
  sched/deadline: Keep the start of the period across a change of
    dl_deadline
  sched/deadline: Boost an owner that cannot run on its own reservation
  selftests/sched: Test parameter changes in deadline_bw_test
  selftests/sched: Share the helpers of the deadline tests

 include/linux/cpuset.h                        |   28 +-
 include/linux/sched.h                         |   64 +
 include/linux/sched/deadline.h                |   41 +-
 kernel/cgroup/cgroup.c                        |    3 -
 kernel/cgroup/cpuset-internal.h               |   15 +-
 kernel/cgroup/cpuset.c                        |  792 +-
 kernel/locking/rtmutex.c                      |   52 +-
 kernel/locking/rtmutex_api.c                  |    2 +-
 kernel/locking/rtmutex_common.h               |    3 +
 kernel/sched/core.c                           |  164 +-
 kernel/sched/deadline.c                       | 1721 +++-
 kernel/sched/sched.h                          |   81 +
 kernel/sched/syscalls.c                       |  103 +-
 kernel/sched/topology.c                       |   11 +
 .../selftests/sched/deadline/.gitignore       |    1 +
 .../testing/selftests/sched/deadline/Makefile |    5 +-
 .../sched/deadline/deadline_bw_test.c         | 8231 ++++++++++++++++-
 .../sched/deadline/deadline_rebuild_test.c    |  504 +
 .../sched/deadline/deadline_switch_test.c     |   36 +-
 .../selftests/sched/deadline/deadline_util.h  |  106 +
 20 files changed, 11432 insertions(+), 531 deletions(-)
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_rebuild_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_util.h


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
prerequisite-patch-id: b2d75d7b3eebbda11af43b3917b1c99e0cce2725
prerequisite-patch-id: fb69a0665dc38ca9022cc2bd75234a90e2035b7f
prerequisite-patch-id: 7a115ab83ad96ffaf8e833e0eaeb75f859af2e79
prerequisite-patch-id: 8574b50d81a09ec6091e42d65338adcab2986d71
prerequisite-patch-id: 1aa25df96d60d30f549c71fdfba5589cb239928f
prerequisite-patch-id: d38384e0b7d043a3556ee02fb09316a6227038da
prerequisite-patch-id: 83ded04a76ecf973e2b8c6e04ff83c2b7278915a
prerequisite-patch-id: b8f5d9f9146e887050bbd8ad30463fd81cad9411
-- 
2.47.3

