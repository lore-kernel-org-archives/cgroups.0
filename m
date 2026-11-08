Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164058;
	b=VsvUTfnly46b3oA2XXDJMAhBM54m+gM9PbjI2ej3wDyDePDAC7HbPHFWAQ6LS634cDad
	 4x1rYMdD6YCEyKjmq2PpRhSdbWAkZD1tgiXQVJz/StG7ddGNtfKX/XL7dP7sj2wzom2uQ
	 sEoIyjDmLue/2pYx0/cjxjcFea6drh7PXEWyBm5WDK/oLxWiwy7A7tic2syv2N1w7llHu
	 uNZEv02O4Fn9Aw7aRUfTw1rO8WEPjpjPsbAdyL1q5/VJdAKMItmrWWBDx2g4tru4K0Gft
	 luG2wni3mU7TgKvZhIrfm2r5g1CfJgLmk+nvORAWC5GDVRMFsmwh5bxubR63c9BMx4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164058;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=3tBpFQw4GEKcQNeJPyl6iyTPtRnzVPcblQDX8hrd+oQ=;
	b=OG/hi0MzvjlVFCsKuoXmqtVBNE7nSQVkHLAjRZWD6NAt6Hhf/n86J7K6A/FpAvBI1ykf
	 u0JD/QpspeO+3OCmAlrQ2NQSK+jYIToQbZsxDtN8dSCYTo4ZvF9EEaRleIphaTGcbmLuG
	 Uds8sDjULFr8zZ5j2E5Z1K3Qbqrf2INIy8hemVFplMoIuVk3DK/z+HWiSCPNyYMCgOsck
	 Htuqr/PXgKWqhN6lTfyFcX37IeV4fDQagVD0z5/hK5LT5D5z7nX/WWXQGHFJ6RGjNu7jI
	 WZm9ADZrRw0A878uVyYBX+6OdkiarUJNHR6Tb8n4ml0SSXWArD6oDkpD0YBunwCwYvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=j22dGqTV;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A65D606A320;
	Sun,  8 Nov 2026 18:54:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A65D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=j22dGqTV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164056;
	bh=3tBpFQw4GEKcQNeJPyl6iyTPtRnzVPcblQDX8hrd+oQ=;
	h=From:To:Cc:Subject:Date:From;
	b=j22dGqTV4xZeSZH029WYZXfPZS6Qv1gynGeRsw4fZPgV9rRYDm5B6T2GRszWzvYqp
	 jIrqz8TJQ7CB7bx6qA/k2jt0/duLvyin55lwquQQoPHASdjdbmUTZH4GZ2tiLtNIZI
	 BiMGpF2qZ30rnOjIMRG13TKFNYupi/7pfi5TqYGCTlyy2cWaM2If5v12dGDV+tko+B
	 n8NaK4n6mO76M42uKqWhxC/wFuG3xMvWpQMuseHl3r7IRBcdfYy9iPTuarlzn5A0bw
	 jlJq6RZ0NNdqixwG9mRFJObKsVq6Ky61j40+8EOagy3ue0Luw1T1AJNnl4CR2Urkkb
	 JlEhR4HLuNXLw==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2Bw1g2fzMkB;
	Sun, 08 Nov 2026 13:54:16 -0500 (EST)
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
Subject: [PATCH v5 00/29] sched/deadline: bandwidth accounting fixes and selftests
Date: Sun,  8 Nov 2026 13:53:37 -0500
Message-Id: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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

This series fixes 25 bugs of SCHED_DEADLINE. Most of them are in its
bandwidth accounting. Then it shows the deadline bandwidth of each
runqueue in sched_debug, and adds three selftests. The fixes come first,
as you asked, so that stable can take patches 1 to 25.

Three of the bugs take the kernel down (patches 5, 8 and 22). Two leave
cpuset_mutex unusable (1 and 6). Most of the others leave total_bw of a
root domain, or this_bw of a runqueue, wrong. The root domain then
admits deadline tasks beyond its capacity, or refuses every one.

The series applies on top of v2 of "locking/rtmutex: priority
inheritance fixes and tests", posted for Peter and Thomas. Patch 8 needs
its patch 3.

Patch 1 is Andrea Parri's, reviewed by Waiman, Kayra and Juri. I carry
it because patches 6 and 15 build on it. Take it by whichever route you
prefer.

Juri, Ingo dropped your four fixes from sched/urgent after the first
one crashed Marek Szyprowski's hotplug test. They are here:
- 1/4 is patch 16. It does not use the task's mask, which can have no
  active CPU during hotplug.
- 2/4 is patch 11, without its double release. It does not carry your
  Signed-off-by, which is yours to add back.
- 3/4 is patch 2.
- 4/4 is patch 12, extended.
Marek found v2 fixed on the board that crashed.

The fixes
=========

 1  Do not unlock cpuset_mutex twice when __sched_setscheduler()
    retries (Andrea Parri).
 2  Refuse SCHED_FLAG_KEEP_PARAMS requests that would change the policy
    or the class.
 3  Skip admission for parameters that SCHED_FLAG_KEEP_PARAMS keeps.
 4  Let a task boosted by a deadline waiter change its policy.
 5  Do not divide by zero active CPUs of a root domain.
 6  Take cpuset_mutex for a deadline policy change only with pi, so
    that sysrq-n does not leave it locked.
 7  Replenish a throttled task switched out and back, so that it runs
    again.
 8  Take a deadline boost from the waiter's rt_mutex node, so that the
    owner never runs on cleared parameters.
 9  Reset the deadline and the runtime with the parameters.
 10 Reset the waiter's deadline and runtime at a deboost in the class.
 11 Release the bandwidth of a task that leaves the class asleep.
 12 Reject SCHED_DEADLINE on exited tasks (Juri Lelli).
 13 Keep the bandwidth of departing tasks across a root domain rebuild.
 14 Keep this_bw right when a task changes during a remote wakeup.
 15 Rebuild the root domains' accounting from the task list.
 16 Record the root domain that holds a task's bandwidth.
 17 Leave out of a rebuild a dying task that released its bandwidth.
 18 Move a task's bandwidth only where an attach made room for it.
 19 Wait for an attach before rebuilding the sched domains.
 20 Give back the bandwidth an attach did not move.
 21 Reserve an attach's bandwidth in the root domain each task moves to.
 22 Make a rebuild use the CPU recorded with a task's bandwidth.
 23 Move a task's bandwidth when it must leave its CPU.
 24 Cancel the replenishment timer with the parameters.
 25 Count in this_bw the bandwidth a boosted task is given.

Patches 16 to 23 go together. 16 records the root domain that counts a
task's bandwidth. 17 to 23 fix the rebuild, attach and migration paths
that the record exposes. Patch 25 completes patch 14. Patch 26 shows
this_bw in sched_debug. Patches 27 to 29 add 65 cases in
tools/testing/selftests/sched/deadline, as Juri suggested.

Peter and Thomas, patch 8 touches the rt_mutex code. It records the
reservation of a deadline waiter in its rt_mutex node, and takes a
deadline boost from there. struct rt_mutex_waiter grows by 48 bytes.
The other classes keep the waiter's own priority, as since commit
acd58620e415 ("sched/rtmutex: Refactor rt_mutex_setprio()").

Peter, patch 21 also touches __set_cpus_allowed_ptr_locked(). A cpuset
attach can reserve a deadline task's bandwidth in one root domain. If
the CPU picked for the task is in the other one, the patch steers the
task to the reserved CPU.

Testing
=======

The 65 cases pass wherever they run, with lockdep and no kernel
warning, in 21 QEMU guests:
- 8 guests of 8 vCPUs.
- 2 guests each with 4 vCPUs, PREEMPT_RT, proxy execution off, and no
  CONFIG_CPUSETS.
- 5 guests of 5 vCPUs booted with isolcpus=domain,1,2 or
  isolcpus=domain,0,1, 2 of them with PREEMPT_RT.
The six isolcpus cases run only in the last group. There, three cases
that need 4 CPUs that are not isolated skip.

The cases of v4 fail on v7.4-rc1 as patches 27 to 29 list. Each case
added in v5 fails on the series without its fix. Kernels stopped at
single patches confirm the claims of patches 11, 13, 19 and 20. The
series builds at each patch whose code changed in v5.

Patch 8 has no selftest. A debug delay, or a stress test, locks up
v7.4-rc1. The series runs the stress test for 600 seconds. The locking
API, ww_mutex, locktorture and futex selftests pass with and without
PREEMPT_RT.

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
- the review of Juri's four fixes;
- building deadline_bw_test, and reading the code;
- the Sashiko AI reviews of v1 to v4. Each finding was checked against
  the code first.

Changes since v4
================

- New patch 10: a deboost in the class resets the waiter's deadline and
  runtime when the task holds more runtime than its own.
- New patch 21: with isolcpus=domain, a cpuset move reserves a task's
  bandwidth in the root domain the task moves to. Found with the new
  isolcpus test cases.
- New patch 23: a task that must leave its CPU takes its bandwidth and
  its record along.
- Fixes from the Sashiko review of v4:
  - 4: sysrq-n drops the boost of a task that leaves the class.
  - 15: the walk skips a zombie whose bandwidth an earlier rebuild
    dropped.
  - 16: a bandwidth of 0 is admitted on the CPU the task is on.
  - 17: moved after 16. It counts a dead task that has not reached its
    last schedule.
  - 22: the rebuild prefers the CPU the task is on.
- Ten new selftest cases test these fixes. Two cases now check that the
  owner was boosted.
- The commit messages and comments are rewritten to read more easily.
  They use short sentences. They give the design intent of the code
  being fixed, and the impact, with fewer numbers. Patches 1 and 12
  are unchanged.
- The rewrite found details that did not match the code or the test
  logs, and fixed them. Patch 18 claimed a case that patch 20 fixes.
  That case moved to the message of patch 20.
- New subjects for patches 14 and 22.
- Patch 8 cites the rtmutex patch by its new subject, "locking/rtmutex:
  Clone the sort keys in rt_mutex_enqueue_pi()".
- Testing with isolcpus=domain found three upstream problems outside
  this series. I reported them separately:
  - An empty sched domain, which leads to a panic at CPU offline:
    https://lore.kernel.org/all/20261108145744.1532128-1-mathieu.desnoyers@efficios.com/
  - A WARNING when isolated partitions take every housekeeping CPU:
    https://lore.kernel.org/all/20261108145754.1532162-1-mathieu.desnoyers@efficios.com/
  - A false "suspicious RCU usage" report without CONFIG_CPUSETS:
    https://lore.kernel.org/all/20261108145931.1532447-1-mathieu.desnoyers@efficios.com/
  For the first two, Waiman answered that cpuset will keep a
  housekeeping CPU in the top cpuset. Guopeng Zhang's series, under
  review, does this:
  https://lore.kernel.org/all/20261105130344.664336-1-guopeng.zhang@linux.dev/
  For the third, I posted the fix as a patch, with Waiman's Reviewed-by:
  https://lore.kernel.org/all/20261108185129.1549419-1-mathieu.desnoyers@efficios.com/

Not changed:
- A departed task that priority inheritance boosts back into the class
  is counted once across a rebuild. The rebuild counts it where it
  runs. If the deboost races the rebuild, its bandwidth is dropped
  until its 0-lag time. Nothing is counted twice.
- At a deboost, the 0-lag time of a task comes from the deadline and
  runtime it ran on during the boost, as upstream.
- The EPERM of a sleeping task moved to another partition is the
  baseline's affinity check.

Based on tip sched/urgent, 006991aa8997, with v2 of "locking/rtmutex:
priority inheritance fixes and tests" applied first:
https://lore.kernel.org/all/20261108141347.1525532-1-mathieu.desnoyers@efficios.com/

v4: https://lore.kernel.org/all/20261107014451.1487825-1-mathieu.desnoyers@efficios.com/

Andrea Parri (1):
  sched: Fix cpuset_mutex double unlock in __sched_setscheduler()

Juri Lelli (1):
  sched/deadline: Reject SCHED_DEADLINE on exited tasks

Mathieu Desnoyers (27):
  sched: Refuse SCHED_FLAG_KEEP_PARAMS that would change the policy or
    the class
  sched/deadline: Do not admit bandwidth for parameters that are kept
  sched: Let a task boosted by a deadline waiter change its policy
  sched/deadline: Do not divide by zero active CPUs of a root domain
  sched: Take cpuset_mutex for a deadline policy change only with pi
  sched/deadline: Do not lose a throttled task switched out and back
  sched/deadline: Take a deadline boost from the waiter's rt_mutex node
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
  cgroup/cpuset: Give back the bandwidth an attach did not move
  cgroup/cpuset: Reserve the bandwidth in the root domain a task moves
    to
  sched/deadline: Make a rebuild use the CPU recorded with a task's
    bandwidth
  sched/deadline: Move a task's bandwidth when it must leave its CPU
  sched/deadline: Cancel the replenishment timer with the parameters
  sched/deadline: Count the bandwidth a boosted task is given
  sched/debug: Show the deadline bandwidth of each runqueue
  selftests/sched: Add a test of SCHED_DEADLINE policy round trips
  selftests/sched: Test SCHED_DEADLINE bandwidth across a root domain
    rebuild
  selftests/sched: Add a test of SCHED_DEADLINE bandwidth accounting

 include/linux/cpuset.h                        |    9 -
 include/linux/sched.h                         |   47 +-
 include/linux/sched/deadline.h                |   54 +-
 include/linux/sched/rt.h                      |   11 -
 kernel/cgroup/cgroup.c                        |    3 -
 kernel/cgroup/cpuset-internal.h               |   14 -
 kernel/cgroup/cpuset.c                        |  274 +-
 kernel/locking/rtmutex.c                      |   34 +-
 kernel/locking/rtmutex_api.c                  |    2 +-
 kernel/locking/rtmutex_common.h               |    5 +
 kernel/sched/core.c                           |  116 +-
 kernel/sched/deadline.c                       |  940 ++-
 kernel/sched/debug.c                          |   12 +-
 kernel/sched/sched.h                          |   26 +-
 kernel/sched/syscalls.c                       |   95 +-
 kernel/sched/topology.c                       |    8 +
 tools/testing/selftests/Makefile              |    1 +
 .../selftests/sched/deadline/.gitignore       |    3 +
 .../testing/selftests/sched/deadline/Makefile |    8 +
 tools/testing/selftests/sched/deadline/config |    5 +
 .../sched/deadline/deadline_bw_test.c         | 5038 +++++++++++++++++
 .../sched/deadline/deadline_rebuild_test.c    |  491 ++
 .../sched/deadline/deadline_switch_test.c     |  721 +++
 .../testing/selftests/sched/deadline/settings |    1 +
 24 files changed, 7563 insertions(+), 355 deletions(-)
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
prerequisite-patch-id: ec1db50b63225bf6d9e37c48e808880c087ed2cd
prerequisite-patch-id: 97db185c1e6a2dc57035ae5ad36cbed6142a1c59
prerequisite-patch-id: 891e1ff948178bf81c62424d4af34e46aeee239c
-- 
2.47.3

