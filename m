Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795096185;
	b=CMe8WWKGGdW48et09lEhzwqNQmHok/tqbwej/SUL5rOxFUMCumzrvuVgJyAeg/hIOQZW
	 rIYagWm5tt3MSfaCOHyM8IbO65wFMfbxE7GspiMZ7AE/9svdTRCnPScBDJmMybJsVxHbl
	 BPgcizV5V7gZFl5MpmQj/3uDiRMJwvKq8US/Uw2Etn7fDXejxqfL3jxJrTHA7n97GihO5
	 /5cES8eiH/DOPMKc0Y5h2VRRDgjXxhrEf/VAB1reiDAoIWdMQZH0EjzEqcv9PTTo1nnkn
	 bczF5pcOWM6LmpjZgxr0TQkd7xym9GYKOJXHj7bMUlDdjdIHRmdwxWDaTCVVZfl+0eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795096185;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=rESOh5vZz5nMn8rzfA3sFSC4j50MI8mLsODo2WxYzJc=;
	b=yIm5QWuIfRiNSbnIxahP3Bo1tRtDxLsMMxkxhyxmoSz8LugEyd/fh9OajsS22k8dyGov
	 bZJZrRdZEZIoZjJdGte6QgR/4fQCV/Sj3H+Wz8NqJu8I69fGRBhuStjQx/ILVPS3P8bEQ
	 7g6jqpEccSxgU8e87zhRSLFYh7CUD77X4Ci5066gm8AiYj06LYW8WI5YwTaf5AsmMMqlr
	 SfLVR32th3O7HDTyn963ZeJjFRBPwOVE9bxXEqSR82UYCC/uiIhayrXOtFgI3VgnvaApY
	 3uw81R5OfCirOdZ/xY7a5PVVShF+b/ChJ2RNDVCin1Ni4Mic/0gj+VWxy0Wa/pDra7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=CWwU1Hxr;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6735606A325;
	Thu, 19 Nov 2026 13:49:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6735606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=CWwU1Hxr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795096183;
	bh=rESOh5vZz5nMn8rzfA3sFSC4j50MI8mLsODo2WxYzJc=;
	h=From:To:Cc:Subject:Date:From;
	b=CWwU1HxrxFaH1hlZJJYd15JpGasAOPJ8MCp7t7khgw1H/Z8a9N1FIjOvcg3wu4FOQ
	 MRpOFv54VAXF4api4IzCAKIdqV2ZzRQ+gfOqPlu733dALcoR0dZbAAtSJzOKHM8ktm
	 jn7AJmeBnQEQcUoS2ga4SuAlIS79FUyLhtWPhZLZkmRUwibXKeJlpi8FhRAk2JpGhr
	 0xcBxNSIrX0ySNWdPAQ8HTj5HGPMFSLk2BZKRNOElJA9Y5ueGnomJrmIvfXAeYkHj6
	 GH8wmeMirgMT0TtErFykFg0uqp8S/OXBFvpIIFsPYfzzvrF2cLWGFFatZDzXEIm52A
	 R6jrzrydbsnUg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVfwR3WlzzSh7;
	Thu, 19 Nov 2026 08:49:43 -0500 (EST)
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
Subject: [PATCH v3 00/17] sched/deadline: first bandwidth accounting fixes and selftests
Date: Thu, 19 Nov 2026 08:49:23 -0500
Message-Id: <cover.1795092090.git.mathieu.desnoyers@efficios.com>
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

This series fixes 14 bugs of SCHED_DEADLINE. Then it shows the deadline
bandwidth of each runqueue in sched_debug, and adds two selftests. The
fixes come first, so that stable can take patches 1 to 14.

Two of the bugs take the kernel down: a division by zero (patch 4), and
an owner's CPU that locks up (patch 8). One leaves cpuset_mutex locked
(patch 6). One leaves a task that never runs again (patch 7). Most of
the others leave total_bw of a root domain, or this_bw of a runqueue,
wrong. The root domain then admits deadline tasks beyond its capacity,
or refuses every one.

These are the first 14 patches of "sched/deadline: bandwidth accounting
fixes and selftests" v7 [1], as Juri proposed [2]. Their v7 numbers are
1-8, 10, 13, 14, 16, 20 and 37. The rest of v7 will follow as v8 of that
series, on top of this one. Patch 10 was posted alone [3]. Juri
asked to carry it here. It comes before patch 11, which adds a caller
of the computation it fixes.

Patch 12 is Juri's, patch 14 is Andrea Parri's. I carry them unchanged.
Sebastian reviewed patch 14. Juri, three of your four fixes that Ingo
dropped from sched/urgent are here:
- 2/4 is patch 11.
- 3/4 is patch 1.
- 4/4 is patch 12.
1/4 stays in the second series.

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
 9  Reset the deadline and the runtime with the parameters.
 10 Compute the 0-lag time on 128 bits, so that a long period does not
    release the bandwidth seconds late.
 11 Release the bandwidth of a task that leaves the class asleep.
 12 Reject SCHED_DEADLINE on exited tasks (Juri Lelli).
 13 Keep this_bw right when a task changes during a remote wakeup.
 14 Check the affinity of a deadline task under the runqueue lock, so
    that sched_setaffinity() and sched_setattr() cannot both succeed
    (Andrea Parri).

Patch 15 shows the deadline bandwidth of each runqueue in sched_debug.
Patch 16 adds deadline_switch_test. Patch 17 adds deadline_bw_test, with
the 45 of its 112 cases that pass with these fixes. The other cases
come with their fixes, in the second series.

Testing
=======

The 50 cases pass wherever they run, with lockdep and no kernel
warning, in 25 QEMU guests:
- 9 guests of 8 vCPUs, one with proxy execution off, and 1 of 4 vCPUs.
- 5 guests with PREEMPT_RT, 4 of 8 vCPUs and 1 of 4.
- 3 guests without CONFIG_CPUSETS, of 4, 4 and 5 vCPUs.
- 4 guests of 5 vCPUs booted with isolcpus=domain,1,2 or
  isolcpus=domain,0,1, 2 of them with PREEMPT_RT.
- 1 guest of 8 vCPUs booted with isolcpus=domain,6,7.
- 2 guests with CONFIG_RT_GROUP_SCHED, of 8 and 4 vCPUs.
move_cancelled runs only in the last group. Without CONFIG_CPUSETS, the
cases that need a cpuset skip. With 3 CPUs that are not isolated,
params_waking skips: it needs 4.

On v7.4-rc2, six cases of deadline_bw_test fail in each of 16 guests of
8 vCPUs, in two runs. Patch 17 lists them. overrun_caught fails in 3
guests. In one, hotplug_server crashed the kernel with the division by
zero that patch 4 fixes. throttled_round_trip and asleep_round_trip of
deadline_switch_test fail too. The sysrq cases did not run there:
sysrq-n leaves cpuset_mutex locked, which patch 6 fixes. In earlier runs
with them, sysrq_normalize failed.

Each of the 15 kernel patches builds alone. The whole series also
builds without CONFIG_CPUSETS, with PREEMPT_RT and with
CONFIG_RT_GROUP_SCHED. The selftests build with no warning.

Juri ran v2 with cgroup v1 cpusets, and with the scx_simple sched_ext
scheduler [4]. With sched_ext, the server cases of deadline_bw_test
failed: they set the fair server, which sched_ext detaches. A change
below makes them use the ext server. It was not tested with sched_ext.
Not tested either: CPUs of unequal capacity.

How this was developed
======================

An LLM coding assistant wrote these patches, their messages and the
tests, under my direction and review. It did not write patches 12 and
14. I know the concepts behind SCHED_DEADLINE, but not its
implementation well. So I ask those who know this code for a careful
reading of the fixes. A reproducer that stops failing shows that the
symptom goes away. It does not show that the fix is the one you would
have written.

The bugs came from:
- flaky cgroup selftests of a feature I am developing;
- the review of Juri's four fixes, and his review of v5;
- building deadline_bw_test, and reading the code;
- the Sashiko AI reviews of v1 to v7 of the original series, and of v1
  and v2 of this one. Each finding was checked against the code first.

Changes since v2
================

- 10 is new: "sched/deadline: Fix an overflow of the 0-lag time with
  long periods", posted alone before [3].
- 11: the known limit of the v2 cover moves into its message, with the
  impact Juri gave.
- 17, from the Sashiko AI review of v2 and Juri's testing:
  - deboost_new_params_reboost moves to the second series. On this
    series, it passes without the deboost it tests.
  - The flag of the lock shared by the death cases is in shared memory.
    Each case runs in its own child process.
  - server_states skips when P cannot run SCHED_FIFO tasks. This is the
    case with CONFIG_RT_GROUP_SCHED and the cpu controller on.
  - While a sched_ext scheduler runs all fair tasks, the server cases
    use the ext server, and hotplug_server skips.

Changes since v1
================

From the Sashiko AI review of v1, in deadline_bw_test:
- rebuild_record_taken moves to the second series. It tests a fix of
  that series, and fails without it when CPU 0 is isolated.
- move_cancelled runs from the root cgroup. It turns the cpu controller
  off at the end only if it turned it on.
- Its setter thread is joined after a timeout too, and its result is
  atomic.
- The shared lock of the death cases is made consistent and destroyed
  before it is set up again.
- A failed probe fails the case, in hotplug_server, move_refused and
  move_zero_bw.

Based on tip sched/urgent, ec6f6731538e (v7.4-rc2).

[1] https://lore.kernel.org/all/cover.1794922146.git.mathieu.desnoyers@efficios.com/
[2] https://lore.kernel.org/all/av3J3zMfkRplg-N4@jlelli-thinkpadt14gen4.remote.csb/
[3] https://lore.kernel.org/all/cover.1794926626.git.mathieu.desnoyers@efficios.com/
[4] https://lore.kernel.org/all/av7NchMg0wnyzjcd@jlelli-thinkpadt14gen4.remote.csb/

v1: https://lore.kernel.org/all/cover.1795031605.git.mathieu.desnoyers@efficios.com/
v2: https://lore.kernel.org/all/cover.1795037078.git.mathieu.desnoyers@efficios.com/

Andrea Parri (1):
  sched/deadline: Check SCHED_DEADLINE affinity under the rq lock

Juri Lelli (1):
  sched/deadline: Reject SCHED_DEADLINE on exited tasks

Mathieu Desnoyers (15):
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
  sched/deadline: Fix an overflow of the 0-lag time with long periods
  sched/deadline: Release the bandwidth of a task that leaves the class
    asleep
  sched/deadline: Fix this_bw when a task is changed during a remote
    wakeup
  sched/debug: Show the deadline bandwidth of each runqueue
  selftests/sched: Add a test of SCHED_DEADLINE policy round trips
  selftests/sched: Add a test of SCHED_DEADLINE bandwidth accounting

 include/linux/sched.h                         |    5 +
 kernel/sched/core.c                           |   11 +
 kernel/sched/deadline.c                       |  142 +-
 kernel/sched/debug.c                          |   13 +-
 kernel/sched/sched.h                          |    1 +
 kernel/sched/syscalls.c                       |  103 +-
 tools/testing/selftests/Makefile              |    1 +
 .../selftests/sched/deadline/.gitignore       |    2 +
 .../testing/selftests/sched/deadline/Makefile |    8 +
 tools/testing/selftests/sched/deadline/config |    5 +
 .../sched/deadline/deadline_bw_test.c         | 5047 +++++++++++++++++
 .../sched/deadline/deadline_switch_test.c     | 1115 ++++
 .../testing/selftests/sched/deadline/settings |    1 +
 13 files changed, 6422 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/sched/deadline/.gitignore
 create mode 100644 tools/testing/selftests/sched/deadline/Makefile
 create mode 100644 tools/testing/selftests/sched/deadline/config
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_bw_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_switch_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/settings

-- 
2.47.3

