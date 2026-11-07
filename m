Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015901;
	b=UfjBT3/cOqC7gLEztXcMDd2G4QU4hBZFFFbJrikJyuJBedTMmSDlOiLjqdDNp2vZFDQ2
	 FKya7y2NqA6YvCaHO2pM7cBTjaWOxmnBmvJekbELoGpjpKNzB/UPdvlmtoPlPBX0JUGvK
	 i4ozat1Gl+7/mVSeODADD7P//YD0WssCSTURMgA8Z1jDGv5kFRkVUz/PTV/RNXEKiahlm
	 b24DbXgR34NLQGnIyztVeN/SzG+Qnfwrjrwy67IYUyLjCtE4JNPHGxflVhpxIcHMcopoO
	 +abTanw8yyNyFlaeFKjTuRB6ASibAmpNjg54CIXyFYRi8ojKvG9ERqXMilmGJN6r6vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015901;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=mI+ziSio1iV38A7zAtI/jCX6dpwTqCt4uTFt5k+KiF4=;
	b=hox/bggUiJNm5fQdCJRHjRO/R2i8b0ZiRxhjuyW9VjKlE9Ph4dd4sSWQfYl6juEs9PxP
	 m52/GYtrxYYxOz4y/jv+rZqM/QFtGMyJO+B+x2fCK2vscOagu6p0qc5Flrvjuev7S/isH
	 NzNTt/X0EukqESRQFLinUaJH5eJ/qUl3Gg3t4RIj0iiAXp2DbB7BB4n4wLeT0X4EQk/S9
	 /xP+blyi4Onfqp+7l4UBJds1md5PiCS3tm/zrozvTf5pVROCaHfI0dUH41nbRMDgihWI/
	 Z0bOoXVZezmNZy0n+W7dSULmlRBd2FPDxF1T24nTnsamv6CIhqaZBSq8pfFvZqIG7KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=tRfUw7n+;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD0A606A32D;
	Sat,  7 Nov 2026 01:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FD0A606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=tRfUw7n+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015898;
	bh=mI+ziSio1iV38A7zAtI/jCX6dpwTqCt4uTFt5k+KiF4=;
	h=From:To:Cc:Subject:Date:From;
	b=tRfUw7n+6XDuf6yylkr3yNF5xAVBBYCEy4JWxiq/69kvdx156SFXl6WbIH65D0GLr
	 0lpCQ/uKOQCcwm/FSLROIqIrx0YpB4wCR2scAJrRSoI6nX4EJYi8DexWCf5C9/hLhJ
	 IGp+J0UjHZj08Azedq56y9sDZwzOegxRHCKKiz8CXj/csyTpEObgVYLhky6NkP8hlh
	 xFYlePjc/adQUDgztGE4PeEgjN13324gPy+EBbSeMgzHo/3Rba1lchwfEAP4opnJ/r
	 Sdav4bndSSRq3Z3lpy9pqsK67aRX+hj84ImPM0tI4xKBJ09fx1ii1HUVDfPpxO9FAb
	 BSr2Wj8XyzIew==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPk00B9zLZ3;
	Fri, 06 Nov 2026 20:44:57 -0500 (EST)
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
Subject: [PATCH v4 00/26] sched/deadline: bandwidth accounting fixes and selftests
Date: Fri,  6 Nov 2026 20:44:25 -0500
Message-Id: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
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

This series fixes twenty-two bugs of SCHED_DEADLINE, most of them in its
bandwidth accounting, then adds each runqueue's deadline bandwidth to
sched_debug and three selftests: twenty-six patches on tip sched/urgent,
the fixes first, as you asked, so that stable can take 1 to 22. Three of
the bugs take the kernel down (patches 5, 8 and 20), two leave
cpuset_mutex unusable (1 and 6), and most of the others leave a root
domain's total_bw or a runqueue's this_bw wrong: the root domain then
admits deadline tasks beyond its capacity, or refuses every one.

It applies on top of "locking/rtmutex: priority inheritance fixes and
tests", posted for Peter and Thomas: patch 8 rests on its patch 3. Patch
1 is Andrea Parri's, reviewed by Waiman, Kayra and Juri, carried here
because patches 6 and 14 build on it, now with my Signed-off-by; take it
from whichever route you prefer.

Your four fixes, Juri, which Ingo dropped from sched/urgent after the
first crashed Marek Szyprowski's hotplug test, are patches 16 (1/4,
without the task's mask, which has no active CPU during hotplug), 10
(2/4, without its double release, and without your Signed-off-by, which
is yours to add back), 2 (3/4) and 11 (4/4, extended). Marek found v2
fixed on the board that crashed.

The fixes, by patch number
==========================

 1  a retry in __sched_setscheduler() unlocks a cpuset_mutex it no
    longer holds (Andrea Parri);
 2  SCHED_FLAG_KEEP_PARAMS carries out half of a policy or class change,
    and leaks the bandwidth of a boosted task;
 3  SCHED_FLAG_KEEP_PARAMS admits stale parameters, read without a lock;
 4  a task boosted by a deadline waiter cannot leave for another policy
    (EBUSY);
 5  a debugfs write to a fair server divides by zero active CPUs while
    its CPU goes offline or comes online;
 6  sysrq-n takes cpuset_mutex under tasklist_lock and never releases
    it;
 7  a throttled task switched out and back before its 0-lag time never
    runs again;
 8  the owner boosted by a deadline waiter that leaves the class loops
    forever in replenish_dl_entity(), under the runqueue lock;
 9  a task back in the class runs on the deadline and runtime of the
    period it left, or of the donor that boosted it;
 10 a task that leaves the class asleep keeps its bandwidth in total_bw
    for good;
 11 SCHED_DEADLINE on a zombie reserves bandwidth nothing releases, and
    a zombie switched out of the class is taken off its cpuset's count
    twice;
 12 a rebuild of the accounting forgets the bandwidth of tasks that left
    the class, or died, before their 0-lag time, which is then released
    twice;
 13 a parameter change while a wakeup is in flight underflows the
    this_bw of a runqueue that never held the task's bandwidth;
 14 without cpusets, the first hotplug drops the bandwidth of every
    deadline task; with them, a drifting count has every rebuild drop a
    cpuset's tasks;
 15 a rebuild counts the bandwidth of a task at its last schedule, which
    nothing releases;
 16 admission, moves and rebuilds disagree on the root domain that
    counts a task's bandwidth, and take it from one that never had it;
 17 a cpuset move takes bandwidth off a root domain with no room made
    for it: total_bw of a partition reaches 2^64 - 262144;
 18 a rebuild of the sched domains between cpuset_can_attach() and
    cpuset_attach() drops the attach's reservation;
 19 an attach leaves in the destination's total_bw the reservation of a
    task that left the class, or died, before it;
 20 a rebuild counts a task on the first active CPU of its cpuset: an
    isolated one, none at all (BUG()), or not where
    dl_task_offline_migration() moved it;
 21 a replenishment timer left armed across a class round trip fires at
    the period of the reservation the task left;
 22 sched_setattr(SCHED_DEADLINE) on a boosted task leaves its
    runqueue's this_bw without the task's bandwidth, and a sugov
    kthread's own reservation is never admitted.

Patch 23 shows patch 13's bug from userspace; patches 24 to 26 add 55
cases in tools/testing/selftests/sched/deadline, as Juri suggested.
Patches 16 to 20 go together: 16 records the root domain that counts a
task's bandwidth, and 17 to 20 fix the attach and rebuild paths that the
record exposes. Patch 22 completes patch 13.

Patch 8 touches the rt_mutex code, Peter and Thomas: it records a
deadline waiter's reservation in its rt_mutex node, which grows struct
rt_mutex_waiter by 48 bytes, and takes a deadline boost from there; the
other classes keep the waiter's own priority, as since acd58620e415
("sched/rtmutex: Refactor rt_mutex_setprio()").

Testing
=======

The 55 cases pass every time with no kernel warning in 16 QEMU guests,
lockdep on: 8 of 8 vCPUs, and 2 each of 4 vCPUs, PREEMPT_RT, proxy
execution off and no CONFIG_CPUSETS. v7.4-rc1 fails 19 of them, which
patches 24 to 26 list, and three hotplug cases without cpusets. Kernels
stopped at single patches confirm the claims of patches 10, 12, 18 and
19. Patch 8 has no selftest: a debug delay or a stress test locks
v7.4-rc1 up, and the series runs the stress test for 600 seconds; the
locking API, ww_mutex, locktorture and futex selftests pass, with and
without PREEMPT_RT.

How this was developed
======================

These patches, their messages and the tests were written by an LLM
coding assistant under my direction and review. I am at home with the
concepts behind SCHED_DEADLINE, but not with its implementation, so I am
asking those who know this code for a careful reading of the fixes: a
reproducer that stops failing says that the symptom goes away, not that
the fix is the one you would have written. The bugs came from flaky
cgroup selftests of a feature I am developing, from reviewing Juri's
four fixes, from building deadline_bw_test, from reading the code, and
from the Sashiko AI reviews of v1 to v3, each finding checked against
the code first; the patches changed since v3 also went through a local
Sashiko run before posting.

Changes since v3
================

 - rebased on tip sched/urgent, which took Nickolai Zeldovich's this_bw
   fix for a dying task; patch 12 keeps its dl_task test;
 - new patches 4 (a boosted task may change its policy) and 8 (a
   deadline boost from the waiter's rt_mutex node);
 - 1: my Signed-off-by; 5: rq->online instead of cpu_active(); 6:
   cpuset_mutex decided again under the runqueue lock; 9: the deboost of
   a task with no parameters resets the donor's deadline and runtime;
 - 10: an inactive timer where the 0-lag time is ahead, and the
   parameters cleared with the bandwidth; 14: the rebuild walks the task
   list with cpusets too, without the per-cpuset count, and leaves out
   tasks with no bandwidth;
 - 16: special and boosted tasks with no bandwidth of their own are not
   moved; 18: waits in cpuset_full_lock() too; 20: the task's own mask
   first, and dl_task_offline_migration() counts a task a rebuild left
   out; 22: checks that the bandwidth is counted before a no-op, and
   leaves the runqueue alone when it is kept;
 - deadline_bw_test: boosted_owner_policy, deboost_resets_period and
   deboost_released_resets_period added, three cases fixed to reach the
   state they are named for, CPUs from the online set, error paths that
   join their threads;
 - deadline_switch_test: its children die with the test
   (PR_SET_PDEATHSIG);
 - shorter commit messages.

Not changed: a departed task boosted into the class is counted
conservatively across a rebuild, never twice, and the EPERM of a
sleeping task moved to another partition is the baseline's affinity
check.

Based on tip sched/urgent, 006991aa8997, with "locking/rtmutex: priority
inheritance fixes and tests" applied first:
https://lore.kernel.org/lkml/20261106235931.1478800-1-mathieu.desnoyers@efficios.com

v3: https://lore.kernel.org/all/20261105193359.1450487-1-mathieu.desnoyers@efficios.com/

Andrea Parri (1):
  sched: Fix cpuset_mutex double unlock in __sched_setscheduler()

Juri Lelli (1):
  sched/deadline: Reject SCHED_DEADLINE on exited tasks

Mathieu Desnoyers (24):
  sched: Refuse SCHED_FLAG_KEEP_PARAMS that would change the policy or
    the class
  sched/deadline: Do not admit bandwidth for parameters that are kept
  sched: Let a task boosted by a deadline waiter change its policy
  sched/deadline: Do not divide by zero active CPUs of a root domain
  sched: Take cpuset_mutex for a deadline policy change only with pi
  sched/deadline: Do not lose a throttled task switched out and back
  sched/deadline: Take a deadline boost from the waiter's rt_mutex node
  sched/deadline: Reset the deadline and the runtime with the parameters
  sched/deadline: Release the bandwidth of a task that leaves the class
    asleep
  sched/deadline: Keep departing bandwidth across a root domain rebuild
  sched/deadline: Do not take a waking task's bandwidth off a runqueue
    it left
  sched/deadline: Rebuild the root domains' accounting from the task
    list
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

 include/linux/cpuset.h                        |    9 -
 include/linux/sched.h                         |   47 +-
 include/linux/sched/deadline.h                |   38 +-
 include/linux/sched/rt.h                      |   11 -
 kernel/cgroup/cgroup.c                        |    3 -
 kernel/cgroup/cpuset-internal.h               |    8 +-
 kernel/cgroup/cpuset.c                        |  126 +-
 kernel/locking/rtmutex.c                      |   41 +-
 kernel/locking/rtmutex_api.c                  |    2 +-
 kernel/locking/rtmutex_common.h               |    5 +
 kernel/sched/core.c                           |   88 +-
 kernel/sched/deadline.c                       |  799 +++-
 kernel/sched/debug.c                          |   11 +-
 kernel/sched/sched.h                          |   23 +-
 kernel/sched/syscalls.c                       |   87 +-
 kernel/sched/topology.c                       |    9 +
 tools/testing/selftests/Makefile              |    1 +
 .../selftests/sched/deadline/.gitignore       |    3 +
 .../testing/selftests/sched/deadline/Makefile |    8 +
 tools/testing/selftests/sched/deadline/config |    4 +
 .../sched/deadline/deadline_bw_test.c         | 3902 +++++++++++++++++
 .../sched/deadline/deadline_rebuild_test.c    |  462 ++
 .../sched/deadline/deadline_switch_test.c     |  440 ++
 .../testing/selftests/sched/deadline/settings |    1 +
 24 files changed, 5847 insertions(+), 281 deletions(-)
 create mode 100644 tools/testing/selftests/sched/deadline/.gitignore
 create mode 100644 tools/testing/selftests/sched/deadline/Makefile
 create mode 100644 tools/testing/selftests/sched/deadline/config
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_bw_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_rebuild_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_switch_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/settings


base-commit: 006991aa89974378ee579416dba87adc22cd60fd
prerequisite-patch-id: 382feddeb27d226d8711d23036c8ae0c8629c680
prerequisite-patch-id: 72e83c74aa52fcd32afb2909b071f40c82b0ef10
prerequisite-patch-id: cfd50da1cef9606aafc687658a1ac79f74969703
prerequisite-patch-id: 2e79dc888982d901d6e8b3784790ef71037482a9
prerequisite-patch-id: f7338b3af8aeb24a47d19dff76d7e3180120b9aa
-- 
2.47.3

