Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037117;
	b=Kk4uqCNdJKXRsaPXaVZ4gea7ZvdqfWqlFosPikOP5x+m6I33QBQyHbZXUyMrD7VvT6Y0
	 JweICOpU+cn8hp26Gg/GT6DfRAmIXu6fWZbCwJSYsQi40miAm/asV1tO/KHIcJ2gE4lQY
	 c52JVCdl32QaWv5c8gEokeRsFKqy4U04lFTHNxrhqDJGapk4bYlD0jTcZ7tyZlxYDoHTv
	 GkxsTGQO9fg/9CV0U3KmBs2rAmbfWQmL4m6/wzWK0kBoWjDs2dpncHJgsgUzGpVlFUor8
	 PeRYQjliwPBaRmwJu8neRvBwd6IsKaBp2+mbGKpKOOvgVkbvbfWx5wlS64z6XHymbnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037117;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=1c4oMGAMDjeBFxoF5KoOGmeppvcwxY25kiCt8MctDjg=;
	b=CNhPtvqkduLA0LRqSutovU7mTLG0dWnGteEQpo+3PLHLKWShaMj5qeGG6f6mqMON7QJA
	 09lX/0wg4PQXMUk1iAWIjIU06hwnpuGLtCdC/aV46FnNvGffZ7rmP4M2ZCLnWSEq0C0KI
	 m9euA5SefZAbWD64X3xdHUZYiQFxg+EhEfTUI69b/92Sruex2FP0lS79WbXJoBS/IVzyE
	 PyIjgZtyCWG1IR2NlYPuRD9Xr9OWzvKlDzwc92lrJ1jbJCAszArGy46tNL3FC4QKSgccO
	 LJlOdtp0QnB56semWe91Jw/VlXLEbwk1wg1N/4M2Ds1aaWHYc6JNn/clu7JM4Yr1MTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=CZXM+7+q;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9ACC606A331;
	Wed, 18 Nov 2026 21:25:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9ACC606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=CZXM+7+q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795037115;
	bh=1c4oMGAMDjeBFxoF5KoOGmeppvcwxY25kiCt8MctDjg=;
	h=From:To:Cc:Subject:Date:From;
	b=CZXM+7+qX4utkTfKOVokib13Fyn+HRgqq4vCOZjsQ7W81GlAtWxdoqCNGLZ9aKzKQ
	 nJGPBt3P/IolpWnZ0oJs32ilY670MrCbC+1TNPc8M8RDGJ0Fsb/sfssSuUQzo44ArZ
	 3/dvmWjsH/KjBgAc3yP2ppXEyzrP81aBSFlwxb7UcLjz2jxGswBJVO8ORiACtmfxfC
	 z+93fYY0+/ATARI+OeXWjexbl925NOiEiIzD8Nq5yAZCy63RwoPzS4HpXRXj8zHjWb
	 hu8RMEGjqNaT8F3nESZwx6tsI/YlY9PVVZpQeTEyTlKTpabgpE/eTabVQC+pCnS05F
	 sFs6daQBCZyTw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVF4W3PvfzS3p;
	Wed, 18 Nov 2026 16:25:15 -0500 (EST)
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
Subject: [PATCH v2 00/16] sched/deadline: first bandwidth accounting fixes and selftests
Date: Wed, 18 Nov 2026 16:24:56 -0500
Message-Id: <cover.1795037078.git.mathieu.desnoyers@efficios.com>
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

This series fixes 13 bugs of SCHED_DEADLINE. Then it shows the deadline
bandwidth of each runqueue in sched_debug, and adds two selftests. The
fixes come first, so that stable can take patches 1 to 13.

Two of the bugs take the kernel down: a division by zero (patch 4), and
an owner's CPU that locks up (patch 8). One leaves cpuset_mutex locked
(patch 6). One leaves a task that never runs again (patch 7). Most of
the others leave total_bw of a root domain, or this_bw of a runqueue,
wrong. The root domain then admits deadline tasks beyond its capacity,
or refuses every one.

These are the first 14 patches of "sched/deadline: bandwidth accounting
fixes and selftests" v7 [1], as Juri proposed [2]. Their v7 numbers are
1-8, 10, 13, 14, 16, 20 and 37. The rest of v7 will follow as v8 of that
series, on top of this one.

Patch 11 is Juri's, patch 13 is Andrea Parri's. I carry them unchanged.
Sebastian reviewed patch 13. Juri, three of your four fixes that Ingo
dropped from sched/urgent are here:
- 2/4 is patch 10.
- 3/4 is patch 1.
- 4/4 is patch 11.
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
 10 Release the bandwidth of a task that leaves the class asleep.
 11 Reject SCHED_DEADLINE on exited tasks (Juri Lelli).
 12 Keep this_bw right when a task changes during a remote wakeup.
 13 Check the affinity of a deadline task under the runqueue lock, so
    that sched_setaffinity() and sched_setattr() cannot both succeed
    (Andrea Parri).

Patch 14 shows the deadline bandwidth of each runqueue in sched_debug.
Patch 15 adds deadline_switch_test. Patch 16 adds deadline_bw_test, with
the 46 of its 112 cases that pass with these fixes. The other cases
come with their fixes, in the second series.

Known limit
===========

Patch 10 clears the parameters of a task that leaves the class asleep.
On v7.4-rc2, such a task kept them. That hid a bug of the rtmutex chain
walk: an owner can keep as its donor a deadline task that left the
class. Another deadline task then gets too little CPU time. With patch
10, the case pi_chain_top_moves shows this in every run. It passes on
v7.4-rc2. The case is new in the second series, with the two rtmutex
fixes that make it pass with patch 10.

Testing
=======

The 51 cases pass wherever they run, with lockdep and no kernel
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
8 vCPUs, in two runs. Patch 16 lists them. overrun_caught fails in 3
guests. In one, hotplug_server crashed the kernel with the division by
zero that patch 4 fixes. throttled_round_trip and asleep_round_trip of
deadline_switch_test fail too. The sysrq cases did not run there:
sysrq-n leaves cpuset_mutex locked, which patch 6 fixes. In earlier runs
with them, sysrq_normalize failed.

Each of the 14 kernel patches builds alone. The whole series also
builds without CONFIG_CPUSETS, with PREEMPT_RT and with
CONFIG_RT_GROUP_SCHED. The selftests build with no warning.

Not tested: cgroup v1 cpusets, the sched_ext server, and CPUs of
unequal capacity.

How this was developed
======================

An LLM coding assistant wrote these patches, their messages and the
tests, under my direction and review. It did not write patches 11 and
13. I know the concepts behind SCHED_DEADLINE, but not its
implementation well. So I ask those who know this code for a careful
reading of the fixes. A reproducer that stops failing shows that the
symptom goes away. It does not show that the fix is the one you would
have written.

The bugs came from:
- flaky cgroup selftests of a feature I am developing;
- the review of Juri's four fixes, and his review of v5;
- building deadline_bw_test, and reading the code;
- the Sashiko AI reviews of v1 to v7 of the original series, and of v1
  of this one. Each finding was checked against the code first.

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

v1: https://lore.kernel.org/all/cover.1795031605.git.mathieu.desnoyers@efficios.com/

Andrea Parri (1):
  sched/deadline: Check SCHED_DEADLINE affinity under the rq lock

Juri Lelli (1):
  sched/deadline: Reject SCHED_DEADLINE on exited tasks

Mathieu Desnoyers (14):
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
  sched/deadline: Release the bandwidth of a task that leaves the class
    asleep
  sched/deadline: Fix this_bw when a task is changed during a remote
    wakeup
  sched/debug: Show the deadline bandwidth of each runqueue
  selftests/sched: Add a test of SCHED_DEADLINE policy round trips
  selftests/sched: Add a test of SCHED_DEADLINE bandwidth accounting

 include/linux/sched.h                         |    5 +
 kernel/sched/core.c                           |   11 +
 kernel/sched/deadline.c                       |  125 +-
 kernel/sched/debug.c                          |   13 +-
 kernel/sched/sched.h                          |    1 +
 kernel/sched/syscalls.c                       |  103 +-
 tools/testing/selftests/Makefile              |    1 +
 .../selftests/sched/deadline/.gitignore       |    2 +
 .../testing/selftests/sched/deadline/Makefile |    8 +
 tools/testing/selftests/sched/deadline/config |    5 +
 .../sched/deadline/deadline_bw_test.c         | 5246 +++++++++++++++++
 .../sched/deadline/deadline_switch_test.c     | 1115 ++++
 .../testing/selftests/sched/deadline/settings |    1 +
 13 files changed, 6607 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/sched/deadline/.gitignore
 create mode 100644 tools/testing/selftests/sched/deadline/Makefile
 create mode 100644 tools/testing/selftests/sched/deadline/config
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_bw_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_switch_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/settings


base-commit: ec6f6731538e0d45872eb279fdeb477bed152d6f
-- 
2.47.3

