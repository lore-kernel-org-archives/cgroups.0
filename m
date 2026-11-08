Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794149973;
	b=ZH7ShZICxmkqN4vT05z4eKPcCCIszOHAKkw7RA211SzhV1Se7SazYop/Ig4z5SjOmL7b
	 PIIkjEkj83+wj9KVXKmdB/Bm9ukcCXT2RIDUsLjRZEJ5jJAO5y8DIGaVkZRmWg1lND0x3
	 WjOXd9RPON1wvBXRa6mAjEFRf83NAnP4yWOFsG7qf7AfZwiy9FEarB+nSXFR54DW5k1E6
	 ikK7c6rGn8+uHiLbzJ4OC3eOMmPVI9Rl573g8W1uFVZvBWm6P5Oj6G+faIVcsWdc4745o
	 I8ymiD2qNRDDCEfUBScJP0LD2rHoqukr18s6+srj/UH+1e93910gskTTgl2tTtFVYOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794149973;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=tOMZcnKYokcXkrusu26zGOYaBn65SJppvslPeGvVPfA=;
	b=ZzNfP/jZzTWP+QphIzs+9o/5Ed6JV6Jj15/9mGrAZ7Y6a8UN/Zg5BNvumacOpAm5kgL2
	 eWuIH3O8C8C4otJ1B5A32enxOkbFW8MBkpllUVVw1FLofFPKkiXOoEE04zaI08qB8i3nc
	 l1l7H2sGrLg90zzc1/vXcAMR3Agq6G6naUUW2mM84ceErIHvvQ+wgEhhpmnhf7m9fgQK1
	 2Sd7cT4ZGZOt6rt/xnc6L6Tc/XgG/s1Xh/XdDsawrlzWGnAfA00Qu8YaLWIRRtZCHn970
	 kVApuuZAcNmwRq7yABqN6saIY098JnkFaOUmK3H4ViOvpsMBrlVzAN5zJGO2jw4HFRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=VEakP5om;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924D9606A31C;
	Sun,  8 Nov 2026 14:59:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 924D9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=VEakP5om
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794149971;
	bh=tOMZcnKYokcXkrusu26zGOYaBn65SJppvslPeGvVPfA=;
	h=From:To:Cc:Subject:Date:From;
	b=VEakP5omB2AFUCO3YiwT4CO2u/tutKwsUbv2fbABHsLimXu9kusqVaFNg+VQ78eJH
	 d+6nHIeHsHaIUMjxW0kYLtN0mqpTL8NE7mE707w/Pskgy9AoyJ2v8+rbQWn3c8oppz
	 CMrPrbmkwYSIsBvtDKfWbzgpRTZiiy2nv7Q4PpF7hYg0G77Hiq6LLpyL9sGbn6AzA3
	 P4omBIaJV4EXCmcIPZewRifCoRd/x/GU4QSTD0mQ9p2P0Bo8jrVjv+/RKfcDtFqFFM
	 oR7XIjoW0FmtupU4V+Razrgxa0ohGmefMhshb+Q/h5MPd1E/t/aA09j8yefF0AktvZ
	 ohDq7UOMgznoA==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jMx033QkPzMgr;
	Sun, 08 Nov 2026 09:59:31 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <frederic@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] sched/isolation: suspicious RCU usage with CONFIG_CPUSETS=n
Date: Sun,  8 Nov 2026 09:59:31 -0500
Message-Id: <20261108145931.1532447-1-mathieu.desnoyers@efficios.com>
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

Hi,

With CONFIG_CPUSETS=n and isolcpus=domain, a read of
/proc/sys/kernel/sched_rt_runtime_us gives a "suspicious RCU usage"
lockdep report. A write gives the same report. I first saw it while
testing a SCHED_DEADLINE series [1]. I then reproduced it in a VM on tip
sched/urgent (006991aa8997), without the series. A proposed fix follows
the scissors line.

Trigger
=======

Build with CONFIG_PROVE_RCU=y and CONFIG_CPUSETS=n. Boot 5 CPUs with
isolcpus=domain,1,2. Then:

  cat /proc/sys/kernel/sched_rt_runtime_us

isolcpus=1,2 gives the same report, since the domain flag is the
default. Without isolcpus, there is no report.

Log
===

  =============================
  WARNING: suspicious RCU usage
  7.4.0-rc1-00267-g006991aa8997 #1 Not tainted
  -----------------------------
  kernel/sched/isolation.c:62 suspicious rcu_dereference_check() usage!
  other info that might help us debug this:
  rcu_scheduler_active = 2, debug_locks = 1
  locks held by cat/91: 3, last CPU#3:
   #0: ff1100000613e260 (&pipe->mutex){+.+.}-{4:4}, at: splice_file_to_pipe+0x23/0xd0
   #1: ffffffff8306c930 (cpu_hotplug_lock){++++}-{0:0}, at: sched_rt_handler+0xb5/0xf0
   #2: ffffffff8307aac0 (sched_domains_mutex){+.+.}-{4:4}, at: partition_sched_domains+0x37/0x990
  stack backtrace:
  CPU: 3 UID: 0 PID: 91 Comm: cat Not tainted 7.4.0-rc1-00267-g006991aa8997 #1 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   lockdep_rcu_suspicious.cold+0x4e/0x9f
   housekeeping_cpumask+0xaa/0xb0
   partition_sched_domains+0x8e6/0x990
   sched_rt_handler+0xc3/0xf0
   proc_sys_call_handler+0x1cf/0x250
   copy_splice_read+0x217/0x3b0
   splice_file_to_pipe+0x60/0xd0
   do_sendfile+0x161/0x480
   __x64_sys_sendfile64+0xba/0xd0
   do_syscall_64+0x109/0x5d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

Analysis
========

sched_rt_handler() calls rebuild_sched_domains() after each read or
write of sched_rt_period_us and sched_rt_runtime_us. Without
CONFIG_CPUSETS, rebuild_sched_domains() is this stub in
include/linux/cpuset.h:

	static inline void rebuild_sched_domains(void)
	{
		guard(cpus_read_lock)();
		partition_sched_domains(1, NULL, NULL);
	}

With no doms_new, partition_sched_domains_locked() builds one domain
from the housekeeping mask:

	cpumask_and(doms_new[0], cpu_active_mask,
		    housekeeping_cpumask(HK_TYPE_DOMAIN));

housekeeping_cpumask() reads housekeeping.cpumasks[HK_TYPE_DOMAIN] with
rcu_dereference_all_check(). Its condition is
housekeeping_dereference_check():

	/* Cpuset isn't even writable yet? */
	if (system_state <= SYSTEM_SCHEDULING)
		return true;

	/* CPU hotplug write locked, so cpuset partition can't be overwritten */
	if (IS_ENABLED(CONFIG_HOTPLUG_CPU) && lockdep_is_cpus_write_held())
		return true;

	/* Cpuset lock held, partitions not writable */
	if (IS_ENABLED(CONFIG_CPUSETS) && lockdep_is_cpuset_held())
		return true;

	return false;

The caller holds cpus_read_lock(), not the write lock. It holds no RCU
read lock. The cpuset case is compiled out. So the check fails, and
lockdep warns.

The report is a false positive. Only cpuset calls housekeeping_update().
Without CONFIG_CPUSETS, housekeeping_init() sets the pointer at boot,
and nothing changes it after that. Without isolcpus, the domain flag is
not set. housekeeping_cpumask() then returns cpu_possible_mask without
reading the pointer.

Versions:
- The check comes from 03ff73510169 ("cpuset: Update HK_TYPE_DOMAIN
  cpumask from cpuset"), in v7.0. It is the same in tip sched/urgent.
- 666a32836c8f ("sched/topology: Add a cpus_read_lock to
  rebuild_sched_domains()"), in v7.3, fixed another warning on the same
  read path. Before it, the stub held no lock at all. So the check also
  fails from v7.0 to v7.2. This is from reading.

Other callers of rebuild_sched_domains() would warn the same way with
CONFIG_CPUSETS=n. Examples are the x86 sched_itmt_enabled debugfs file
and rebuild_sched_domains_energy(). This is from reading. I did not
run them.

Where to fix
============

The patch adds one case to housekeeping_dereference_check(). It accepts
all readers when CONFIG_CPUSETS is off. This covers every caller of the
stub. With CONFIG_CPUSETS=y, the new case is compiled out.

Another option is an RCU read-side section around the two reads in
partition_sched_domains_locked(). It would fix this path only.

Testing
=======

I ran tip sched/urgent (006991aa8997) in a VM with 5 CPUs. The kernel
had CONFIG_PROVE_RCU=y and CONFIG_CPUSETS=n. Without the patch:
- isolcpus=domain,1,2: one report from a read alone. In another boot,
  one report from a write alone.
- isolcpus=1,2: one report from a read.
- No isolcpus: no report from reads and writes.

With the patch, there is no report:
- isolcpus=domain,1,2: a read alone. In another boot, a write alone.
  In a third boot, reads and writes of sched_rt_runtime_us and
  sched_rt_period_us.
- isolcpus=1,2: reads and writes.
- No isolcpus: reads and writes.

debug_locks was still 1 at the end of each boot. So lockdep was still
checking.

With CONFIG_CPUSETS=y, the patch also builds. A boot with
isolcpus=domain,1,2 and the same reads and writes gives no report. I
did not run other tests.

An open question, from reading only. Since a84097e625f2
("cgroup/cpuset: Call housekeeping_update() without holding
cpus_read_lock"), cpuset calls housekeeping_update() with only
cpuset_top_mutex held. The check accepts the hotplug write lock or
cpuset_mutex. Do these two locks still keep the mask from changing
under a reader? I did not look at a reader that holds only
cpuset_mutex.

The analysis and the patch were written by an LLM coding assistant
under my direction and review.

Thanks,

Mathieu

[1] https://lore.kernel.org/all/20261107014451.1487825-1-mathieu.desnoyers@efficios.com/

-- >8 --
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: sched/isolation: Fix suspicious RCU usage without CONFIG_CPUSETS

Since commit 03ff73510169 ("cpuset: Update HK_TYPE_DOMAIN cpumask from
cpuset"), cpuset can change the HK_TYPE_DOMAIN mask at run time. Readers
use RCU. housekeeping_dereference_check() also accepts readers that hold
a lock which keeps cpuset partitions from changing: the CPU hotplug
write lock or cpuset_mutex. During boot, before cpuset is writable, it
accepts all readers.

Without CONFIG_CPUSETS, nothing changes the mask after boot. But the
check still asks for one of these locks. In that configuration,
rebuild_sched_domains() holds only cpus_read_lock(). It calls
partition_sched_domains(1, NULL, NULL). That reads
housekeeping_cpumask(HK_TYPE_DOMAIN). sched_rt_handler() calls
rebuild_sched_domains() on each read or write of sched_rt_period_us and
sched_rt_runtime_us. So with isolcpus=domain, a read of
/proc/sys/kernel/sched_rt_runtime_us gives:

  WARNING: suspicious RCU usage
  kernel/sched/isolation.c:62 suspicious rcu_dereference_check() usage!
  [...]
  locks held by cat/91: 3, last CPU#3:
   [...]
   #1: (cpu_hotplug_lock){++++}-{0:0}, at: sched_rt_handler+0xb5/0xf0
   #2: (sched_domains_mutex){+.+.}-{4:4}, at: partition_sched_domains+0x37/0x990
  [...]
  Call Trace:
   lockdep_rcu_suspicious.cold+0x4e/0x9f
   housekeeping_cpumask+0xaa/0xb0
   partition_sched_domains+0x8e6/0x990
   sched_rt_handler+0xc3/0xf0
   proc_sys_call_handler+0x1cf/0x250

The report is a false positive. It needs CONFIG_PROVE_RCU and isolcpus=
with the domain flag, which is also the default when no flag is given.
Test runs that check the kernel log for lockdep reports flag it.

Fix this by accepting all readers when CONFIG_CPUSETS is off.

This change was developed with assistance from an LLM.

Fixes: 03ff73510169 ("cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/isolation.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 156025ef81b7..dac9a1735198 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -43,6 +43,10 @@ static bool housekeeping_dereference_check(enum hk_type type)
 		if (system_state <= SYSTEM_SCHEDULING)
 			return true;
 
+		/* No cpuset, so the mask never changes after boot */
+		if (!IS_ENABLED(CONFIG_CPUSETS))
+			return true;
+
 		/* CPU hotplug write locked, so cpuset partition can't be overwritten */
 		if (IS_ENABLED(CONFIG_HOTPLUG_CPU) && lockdep_is_cpus_write_held())
 			return true;
