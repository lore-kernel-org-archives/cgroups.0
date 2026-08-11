Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2435F42B31E
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 10:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786445184; cv=none; b=MC6/ZbbE/Ul4Yv7yp1u4FV8oqfgdrPcg10EiTaGq4llnfvZXwupN3rECIrKaIPWRU4CGKmTNIoOrrkLYjhGrtMl9z+Smuax/ynqaQaDzy/7Y4ttCZqIBn4YuGfqkeukRaX7qvSF0wkcpyRB4wYamwBlsNonVLepIBl1EaddghAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786445184; c=relaxed/simple;
	bh=RMM52g6yWgiC3xCdxeec4zZykkiU18Om/l9at1WxCeI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BV2Fxjkj8Wr8/+4RajuQIbT6nvN9h+tQ5MLZqHc3hIqwRUJ1senNSqU5136dNRNzl/OhlqrUdGt02IIOemzzw/9zQu1oP7owq/OtXqFN+TZU6jlqX56cwdMKtmnPSSZLB3dhmAn/45UkAkUUZgnKhbppzq3rgAbvbblHLFKh/Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1ojY2T0; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1ojY2T0"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cf27856f9cso34232055ad.2
        for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 03:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786445181; x=1787049981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wUiqwdP9ag/JDA0txmMwAR3WZLV/94FRbAJGknqEf7I=;
        b=K1ojY2T0i+WNkk6slXxWN32Z5mEUK+nnvE2wRb8DapgGLR0u1SaDAGhAS6AQdPak6V
         Hc/4bODku+o6fJXKYdrkIqC6JAEVEfDBJIvXfVU77mDi8HxBkGrrdMSVsOvReQ6g5fPZ
         MzCeOADGZT0VFLZEjYhaVJHRSMJBIvbspkfjs73vPTGiyMb6PnvV4UGTflXJksZgcInD
         iAyjPZctMxvpQlFJSuK4nWmHaugOtolJnR7TC6/KdhOP4nl2GLxj+Qy9mjjshcOMNYF7
         PXJPxCtXMaqv3m81YBwz8DdZYkb0EuMBIqZz1ZqpWnfUYN0c5Lz+bVw6+NmodL0f/jsz
         vr4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786445181; x=1787049981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wUiqwdP9ag/JDA0txmMwAR3WZLV/94FRbAJGknqEf7I=;
        b=YHBrmUnXWBm0MtSLHKXXewpMOucRzlnkjbRQkXJjxAcUbaFF2bzgPqcVauwZfjM/fP
         1xvDyJp3oHBAPuTCpgsHmEM3D4utnfs0hL4D5gS3bvxa/YYUVBzXIgDigvxf0Pi+LAm6
         VztRqbkQcAs/N6EiDwJAvkA7V6PkFk5Tja+Ubn5mxbv4pMCAdzXiGuCOgqYm41zoXVqo
         G9mt04mDSTys1Skh0hPfj0deXgBl/8gM6EnVtMlQTq/4JZXfzkVNujmrKlgtBLCCoF3R
         0u3xl99SKbSVxjhxy+cNLRbR8WfZTeax/rHHQDR9lgJR+LC+joV+4e1tTtCFJWVHHNSO
         7euw==
X-Forwarded-Encrypted: i=1; AHgh+RqgyQyInzsH0Lj+Hiq6qR+5tN6x2aRjI1R+tRMD9+BL9DXpAd035o6TxFq0KARUT4cgQHzjdoy/@vger.kernel.org
X-Gm-Message-State: AOJu0YyxiLiMuNMy6i35vLRehrRHtzsBhL8d6JbsEgWr1g0SYCuVou1T
	fExn+0zQxDKsQgaG1kJaEqkD+YrYxKYAedp4GAKviHsbckki62CyDB01
X-Gm-Gg: AR+sD11GbV4YuYMkJbEbg+k9FQxk9KnJj62Ni4grqP0e6j/+hCrFJ+0sihpsqDz9C/H
	e1O/s5tHqR38TahlK9k5ozFLHOPS4luTLc3tJ/cT8IXMLhTDSnkfKbc/WC3qRh4hs4SqQtFKlih
	zaX7G0BODK3EjfOP9v34mUu4+RCl5B565hbrR6/b1jnlRK4DFGQNqP5A0Du62MkwQnJawKP7Q7r
	MeKuBFNALgHqhxvGVeyRGfDzkCi0le8E0JVZRdD7zJ/BLGbicOk6lAtiTXFB+VPe528r8Q3Z/ir
	d69k232BtxJEMckfkcWGnTYCP9DRFBL34eySlraAiKjmsD0jVpf8faoDc5IGtlPShfCg5H0oU90
	05lk0v3WJxFPF99beEIBIag9NLxI99ZRfY/2KSh1354fJzd/XIPPXIdXf2FhwwFALuDuSD0GR7B
	Y2U4kerEDMTmLAy9z1B8K9+MoxqlzlR2RRSI0uQkiFXMoqdsYjtXafRLCu3oRy+3wRBpenoLSS1
	PBtsi2JxbneCtZheKA=
X-Received: by 2002:a17:90b:534f:b0:38e:e9b:ffa4 with SMTP id 98e67ed59e1d1-392ec3bd18bmr2550783a91.6.1786445181096;
        Tue, 11 Aug 2026 03:46:21 -0700 (PDT)
Received: from PC-4CV533FH0X.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392cfc6fd39sm3363099a91.0.2026.08.11.03.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 03:46:20 -0700 (PDT)
From: shisiyuan <shisiyuan19870131@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	shisiyuan <shisiyuan@lixiang.com>
Subject: [PATCH] sched/psi: add cpu_prio pressure metric for high-priority task stalls
Date: Tue, 11 Aug 2026 18:46:10 +0800
Message-Id: <20260811104610.100617-1-shisiyuan19870131@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: shisiyuan <shisiyuan@lixiang.com>

Introduce a new PSI (Pressure Stall Information) indicator that
measures how much walltime priority-sensitive tasks spend waiting
for CPU, exposed as /proc/pressure/cpu_prio alongside the existing
io/memory/cpu/irq metrics.

A task is considered "high priority" when its static priority is
at or below CONFIG_PSI_TASK_PRIO_THLD (default 118). The scheduler
tracks a dedicated task count and state bit for such tasks,
mirroring the existing CPU SOME/FULL accounting, so CPU contention
affecting latency-sensitive workloads can be observed independently
of overall CPU pressure. Both 'some' and 'full' states are tracked;
'full' is undefined at the system level (always reported as zero),
same as regular CPU pressure, but is meaningful at the cgroup level,
where it reflects the share of time no high-priority task in that
cgroup is able to run.

To keep the metric accurate across priority changes, ENQUEUE_PSI/
DEQUEUE_PSI flags are added and set by set_user_nice(),
sched_setscheduler() and rt_mutex_setprio(), forcing PSI state to
be re-evaluated whenever a task's priority is adjusted rather than
only on enqueue/dequeue.

The priority threshold is exported as a Kconfig knob
(CONFIG_PSI_TASK_PRIO_THLD) so it can be tuned per platform without
touching source code.

Signed-off-by: shisiyuan <shisiyuan@lixiang.com>
---
 Documentation/accounting/psi.rst | 25 ++++++++--
 include/linux/psi_types.h        | 17 ++++++-
 init/Kconfig                     | 18 +++++++
 kernel/cgroup/cgroup.c           | 23 +++++++++
 kernel/sched/core.c              |  2 +-
 kernel/sched/psi.c               | 82 ++++++++++++++++++++++++++++++--
 kernel/sched/sched.h             |  3 ++
 kernel/sched/stats.h             | 12 ++++-
 kernel/sched/syscalls.c          |  4 +-
 9 files changed, 173 insertions(+), 13 deletions(-)

diff --git a/Documentation/accounting/psi.rst b/Documentation/accounting/psi.rst
index d455db3e5..c7ff168b0 100644
--- a/Documentation/accounting/psi.rst
+++ b/Documentation/accounting/psi.rst
@@ -35,7 +35,7 @@ Pressure interface
 ==================
 
 Pressure information for each resource is exported through the
-respective file in /proc/pressure/ -- cpu, memory, and io.
+respective file in /proc/pressure/ -- cpu, cpu_prio, memory, and io.
 
 The format is as such::
 
@@ -64,6 +64,25 @@ as well as medium and long term trends. The total absolute stall time
 spikes which wouldn't necessarily make a dent in the time averages,
 or to average trends over custom time frames.
 
+cpu_prio pressure
+-----------------
+
+/proc/pressure/cpu_prio reports CPU pressure experienced specifically
+by high priority tasks, using the same "some"/"full" definitions as
+above but restricted to tasks whose (static) priority is at or below
+CONFIG_PSI_TASK_PRIO_THLD (a Kconfig-tunable threshold, defaulting to
+118). This makes it possible to observe CPU contention affecting
+latency-sensitive workloads independently of, and without being
+diluted by, the overall CPU pressure reported by /proc/pressure/cpu.
+
+Just like regular CPU pressure, cpu_prio "full" is undefined at the
+system level (it is always reported as zero in
+/proc/pressure/cpu_prio), but it is meaningful at the cgroup level,
+where it represents the share of time in which every high-priority
+task in the cgroup is stalled on the CPU, i.e. no high-priority task
+in that cgroup is able to run. See "Cgroup2 interface" below for the
+corresponding cpu_prio.pressure file.
+
 Monitoring for pressure thresholds
 ==================================
 
@@ -181,8 +200,8 @@ Cgroup2 interface
 In a system with a CONFIG_CGROUPS=y kernel and the cgroup2 filesystem
 mounted, pressure stall information is also tracked for tasks grouped
 into cgroups. Each subdirectory in the cgroupfs mountpoint contains
-cpu.pressure, memory.pressure, and io.pressure files; the format is
-the same as the /proc/pressure/ files.
+cpu.pressure, cpu_prio.pressure, memory.pressure, and io.pressure
+files; the format is the same as the /proc/pressure/ files.
 
 Per-cgroup psi monitors can be specified and used the same way as
 system-wide ones.
diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index dd10c2229..b0909a48c 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -15,6 +15,7 @@ enum psi_task_count {
 	NR_IOWAIT,
 	NR_MEMSTALL,
 	NR_RUNNING,
+	NR_HIGH_PRIO_RUNNING,
 	/*
 	 * For IO and CPU stalls the presence of running/oncpu tasks
 	 * in the domain means a partial rather than a full stall.
@@ -25,23 +26,32 @@ enum psi_task_count {
 	 * threads and memstall ones.
 	 */
 	NR_MEMSTALL_RUNNING,
-	NR_PSI_TASK_COUNTS = 4,
+	NR_PSI_TASK_COUNTS = 5,
 };
 
+#ifdef CONFIG_PSI_TASK_PRIO_THLD
+#define PSI_TASK_PRIO_THLD CONFIG_PSI_TASK_PRIO_THLD
+#else
+#define PSI_TASK_PRIO_THLD 118
+#endif
+
 /* Task state bitmasks */
 #define TSK_IOWAIT	(1 << NR_IOWAIT)
 #define TSK_MEMSTALL	(1 << NR_MEMSTALL)
 #define TSK_RUNNING	(1 << NR_RUNNING)
+#define TSK_HIGH_PRIO_RUNNING  (1 << NR_HIGH_PRIO_RUNNING)
 #define TSK_MEMSTALL_RUNNING	(1 << NR_MEMSTALL_RUNNING)
 
 /* Only one task can be scheduled, no corresponding task count */
 #define TSK_ONCPU	(1 << NR_PSI_TASK_COUNTS)
+#define TSK_HIGH_PRIO_ONCPU   (1 << (NR_PSI_TASK_COUNTS + 1))
 
 /* Resources that workloads could be stalled on */
 enum psi_res {
 	PSI_IO,
 	PSI_MEM,
 	PSI_CPU,
+	PSI_CPU_HIGH_PRIO,
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	PSI_IRQ,
 #endif
@@ -61,6 +71,8 @@ enum psi_states {
 	PSI_MEM_FULL,
 	PSI_CPU_SOME,
 	PSI_CPU_FULL,
+	PSI_CPU_HIGH_PRIO_TASK_SOME,
+	PSI_CPU_HIGH_PRIO_TASK_FULL,
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	PSI_IRQ_FULL,
 #endif
@@ -75,6 +87,9 @@ enum psi_states {
 /* Flag whether to re-arm avgs_work, see details in get_recent_times() */
 #define PSI_STATE_RESCHEDULE	(1 << (NR_PSI_STATES + 1))
 
+/* Use one bit in the state mask to track TSK_HIGH_PRIO_ONCPU */
+#define PSI_HIGH_PRIO_ONCPU	(1 << (NR_PSI_STATES + 2))
+
 enum psi_aggregators {
 	PSI_AVGS = 0,
 	PSI_POLL,
diff --git a/init/Kconfig b/init/Kconfig
index 10f2013b5..582c62822 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -760,6 +760,24 @@ config PSI_DEFAULT_DISABLED
 
 	  Say N if unsure.
 
+config PSI_TASK_PRIO_THLD
+	int "Priority threshold for PSI cpu_prio"
+	default 118
+	depends on PSI
+	help
+	  Tasks whose (static) priority value is less than or equal to
+	  this threshold are considered "high priority" for the purpose
+	  of the /proc/pressure/cpu_prio pressure stall metric.
+
+	  This metric tracks how much walltime high priority tasks are
+	  stalled waiting for CPU, which can be used to detect CPU
+	  contention affecting latency-sensitive workloads.
+
+	  The default value corresponds to tasks which are latency-sensitive.
+
+	  If unsure, leave at the default value.
+
+
 endmenu # "CPU/Task time and stats accounting"
 
 config CPU_ISOLATION
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b5b461d44..5ae4378d3 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3989,6 +3989,14 @@ static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
 	return psi_show(seq, psi, PSI_CPU);
 }
 
+static int cgroup_cpu_prio_pressure_show(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	struct psi_group *psi = cgroup_psi(cgrp);
+
+	return psi_show(seq, psi, PSI_CPU_HIGH_PRIO);
+}
+
 static ssize_t pressure_write(struct kernfs_open_file *of, char *buf,
 			      size_t nbytes, enum psi_res res)
 {
@@ -4073,6 +4081,13 @@ static ssize_t cgroup_cpu_pressure_write(struct kernfs_open_file *of,
 	return pressure_write(of, buf, nbytes, PSI_CPU);
 }
 
+static ssize_t cgroup_cpu_prio_pressure_write(struct kernfs_open_file *of,
+					      char *buf, size_t nbytes,
+					      loff_t off)
+{
+	return pressure_write(of, buf, nbytes, PSI_CPU_HIGH_PRIO);
+}
+
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 static int cgroup_irq_pressure_show(struct seq_file *seq, void *v)
 {
@@ -5572,6 +5587,14 @@ static struct cftype cgroup_psi_files[] = {
 		.poll = cgroup_pressure_poll,
 		.release = cgroup_pressure_release,
 	},
+	{
+		.name = "cpu_prio.pressure",
+		.file_offset = offsetof(struct cgroup, psi_files[PSI_CPU_HIGH_PRIO]),
+		.seq_show = cgroup_cpu_prio_pressure_show,
+		.write = cgroup_cpu_prio_pressure_write,
+		.poll = cgroup_pressure_poll,
+		.release = cgroup_pressure_release,
+	},
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	{
 		.name = "irq.pressure",
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 96226707c..1eae2f892 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7627,7 +7627,7 @@ void rt_mutex_post_schedule(void)
 void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 {
 	int prio, oldprio, queue_flag =
-		DEQUEUE_SAVE | DEQUEUE_MOVE | DEQUEUE_NOCLOCK;
+		DEQUEUE_SAVE | DEQUEUE_MOVE | DEQUEUE_NOCLOCK | DEQUEUE_PSI;
 	const struct sched_class *prev_class, *next_class;
 	struct rq_flags rf;
 	struct rq *rq;
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index e2e825dcd..888d966c2 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -243,6 +243,7 @@ void __init psi_init(void)
 static u32 test_states(unsigned int *tasks, u32 state_mask)
 {
 	const bool oncpu = state_mask & PSI_ONCPU;
+	const bool oncpu_high_prio = state_mask & PSI_HIGH_PRIO_ONCPU;
 
 	if (tasks[NR_IOWAIT]) {
 		state_mask |= BIT(PSI_IO_SOME);
@@ -259,6 +260,12 @@ static u32 test_states(unsigned int *tasks, u32 state_mask)
 	if (tasks[NR_RUNNING] > oncpu)
 		state_mask |= BIT(PSI_CPU_SOME);
 
+	if (tasks[NR_HIGH_PRIO_RUNNING] > oncpu_high_prio)
+		state_mask |= BIT(PSI_CPU_HIGH_PRIO_TASK_SOME);
+
+	if (tasks[NR_HIGH_PRIO_RUNNING] && !oncpu_high_prio)
+		state_mask |= BIT(PSI_CPU_HIGH_PRIO_TASK_FULL);
+
 	if (tasks[NR_RUNNING] && !oncpu)
 		state_mask |= BIT(PSI_CPU_FULL);
 
@@ -784,10 +791,16 @@ static void record_times(struct psi_group_cpu *groupc, u64 now)
 		groupc->times[PSI_CPU_SOME] += delta;
 		if (groupc->state_mask & (1 << PSI_CPU_FULL))
 			groupc->times[PSI_CPU_FULL] += delta;
+		if (groupc->state_mask & (1 << PSI_CPU_HIGH_PRIO_TASK_SOME)) {
+			groupc->times[PSI_CPU_HIGH_PRIO_TASK_SOME] += delta;
+			if (groupc->state_mask & (1 << PSI_CPU_HIGH_PRIO_TASK_FULL))
+				groupc->times[PSI_CPU_HIGH_PRIO_TASK_FULL] += delta;
+		}
 	}
 
 	if (groupc->state_mask & (1 << PSI_NONIDLE))
 		groupc->times[PSI_NONIDLE] += delta;
+
 }
 
 #define for_each_group(iter, group) \
@@ -813,11 +826,24 @@ static void psi_group_change(struct psi_group *group, int cpu,
 	if (unlikely(clear & TSK_ONCPU)) {
 		state_mask = 0;
 		clear &= ~TSK_ONCPU;
+		if (unlikely(clear & TSK_HIGH_PRIO_ONCPU))
+			clear &= ~TSK_HIGH_PRIO_ONCPU;
 	} else if (unlikely(set & TSK_ONCPU)) {
 		state_mask = PSI_ONCPU;
 		set &= ~TSK_ONCPU;
+		if (unlikely(set & TSK_HIGH_PRIO_ONCPU)) {
+			state_mask |= PSI_HIGH_PRIO_ONCPU;
+			set &= ~TSK_HIGH_PRIO_ONCPU;
+		}
 	} else {
-		state_mask = groupc->state_mask & PSI_ONCPU;
+		state_mask = groupc->state_mask & (PSI_ONCPU | PSI_HIGH_PRIO_ONCPU);
+		if (unlikely(clear & TSK_HIGH_PRIO_ONCPU)) {
+			state_mask &= ~PSI_HIGH_PRIO_ONCPU;
+			clear &= ~TSK_HIGH_PRIO_ONCPU;
+		} else if (unlikely(set & TSK_HIGH_PRIO_ONCPU)) {
+			state_mask |= PSI_HIGH_PRIO_ONCPU;
+			set &= ~TSK_HIGH_PRIO_ONCPU;
+		}
 	}
 
 	/*
@@ -934,7 +960,12 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 	now = cpu_clock(cpu);
 
 	if (next->pid) {
-		psi_flags_change(next, 0, TSK_ONCPU);
+		int set = TSK_ONCPU;
+
+		if (next->prio <= PSI_TASK_PRIO_THLD)
+			set |= TSK_HIGH_PRIO_ONCPU;
+
+		psi_flags_change(next, 0, set);
 		/*
 		 * Set TSK_ONCPU on @next's cgroups. If @next shares any
 		 * ancestors with @prev, those will already have @prev's
@@ -947,7 +978,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 				common = group;
 				break;
 			}
-			psi_group_change(group, cpu, 0, TSK_ONCPU, now, true);
+			psi_group_change(group, cpu, 0, set, now, true);
 		}
 	}
 
@@ -955,6 +986,9 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		int clear = TSK_ONCPU, set = 0;
 		bool wake_clock = true;
 
+		if (prev->prio <= PSI_TASK_PRIO_THLD)
+			clear |= TSK_HIGH_PRIO_ONCPU;
+
 		/*
 		 * When we're going to sleep, psi_dequeue() lets us
 		 * handle TSK_RUNNING, TSK_MEMSTALL_RUNNING and
@@ -963,6 +997,9 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		 */
 		if (sleep) {
 			clear |= TSK_RUNNING;
+			if (prev->prio <= PSI_TASK_PRIO_THLD)
+				clear |= TSK_HIGH_PRIO_RUNNING;
+
 			if (prev->in_memstall)
 				clear |= TSK_MEMSTALL_RUNNING;
 			if (prev->in_iowait)
@@ -995,6 +1032,16 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		 */
 		if ((prev->psi_flags ^ next->psi_flags) & ~TSK_ONCPU) {
 			clear &= ~TSK_ONCPU;
+			/*
+			 * Both usual and high-prio "ONCPU" bits are handled up to
+			 * the common ancestor already, above that only propagate
+			 * a change in high-prio ONCPU if next differs from prev.
+			 */
+			if (next->prio <= PSI_TASK_PRIO_THLD) {
+				clear &= ~TSK_HIGH_PRIO_ONCPU;
+				if (!(prev->prio <= PSI_TASK_PRIO_THLD))
+					set |= TSK_HIGH_PRIO_ONCPU;
+			}
 			for_each_group(group, common)
 				psi_group_change(group, cpu, clear, set, now, wake_clock);
 		}
@@ -1280,7 +1327,8 @@ int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
 		int w;
 
 		/* CPU FULL is undefined at the system level */
-		if (!(group == &psi_system && res == PSI_CPU && full)) {
+		if (!(group == &psi_system &&
+		      (res == PSI_CPU || res == PSI_CPU_HIGH_PRIO) && full)) {
 			for (w = 0; w < 3; w++)
 				avg[w] = group->avg[res * 2 + full][w];
 			total = div_u64(group->total[PSI_AVGS][res * 2 + full],
@@ -1550,6 +1598,11 @@ static int psi_cpu_show(struct seq_file *m, void *v)
 	return psi_show(m, &psi_system, PSI_CPU);
 }
 
+static int psi_cpu_prio_show(struct seq_file *m, void *v)
+{
+	return psi_show(m, &psi_system, PSI_CPU_HIGH_PRIO);
+}
+
 static int psi_io_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, psi_io_show, NULL);
@@ -1565,6 +1618,11 @@ static int psi_cpu_open(struct inode *inode, struct file *file)
 	return single_open(file, psi_cpu_show, NULL);
 }
 
+static int psi_cpu_prio_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, psi_cpu_prio_show, NULL);
+}
+
 static ssize_t psi_write(struct file *file, const char __user *user_buf,
 			 size_t nbytes, enum psi_res res)
 {
@@ -1638,6 +1696,12 @@ static ssize_t psi_cpu_write(struct file *file, const char __user *user_buf,
 	return psi_write(file, user_buf, nbytes, PSI_CPU);
 }
 
+static ssize_t psi_cpu_prio_write(struct file *file, const char __user *user_buf,
+				  size_t nbytes, loff_t *ppos)
+{
+	return psi_write(file, user_buf, nbytes, PSI_CPU_HIGH_PRIO);
+}
+
 static __poll_t psi_fop_poll(struct file *file, poll_table *wait)
 {
 	struct seq_file *seq = file->private_data;
@@ -1680,6 +1744,15 @@ static const struct proc_ops psi_cpu_proc_ops = {
 	.proc_release	= psi_fop_release,
 };
 
+static const struct proc_ops psi_cpu_prio_proc_ops = {
+	.proc_open	= psi_cpu_prio_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= psi_cpu_prio_write,
+	.proc_poll	= psi_fop_poll,
+	.proc_release	= psi_fop_release,
+};
+
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 static int psi_irq_show(struct seq_file *m, void *v)
 {
@@ -1714,6 +1787,7 @@ static int __init psi_proc_init(void)
 		proc_create("pressure/io", 0666, NULL, &psi_io_proc_ops);
 		proc_create("pressure/memory", 0666, NULL, &psi_memory_proc_ops);
 		proc_create("pressure/cpu", 0666, NULL, &psi_cpu_proc_ops);
+		proc_create("pressure/cpu_prio", 0666, NULL, &psi_cpu_prio_proc_ops);
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 		proc_create("pressure/irq", 0666, NULL, &psi_irq_proc_ops);
 #endif
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 56acf502b..4b6cce3e7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2553,6 +2553,7 @@ extern const u32		sched_prio_to_wmult[40];
 #define DEQUEUE_MIGRATING	0x0010 /* Matches ENQUEUE_MIGRATING */
 #define DEQUEUE_DELAYED		0x0020 /* Matches ENQUEUE_DELAYED */
 #define DEQUEUE_CLASS		0x0040 /* Matches ENQUEUE_CLASS */
+#define DEQUEUE_PSI		0x0080 /* Matches ENQUEUE_PSI */
 
 #define DEQUEUE_SPECIAL		0x00010000
 #define DEQUEUE_THROTTLE	0x00020000
@@ -2565,6 +2566,8 @@ extern const u32		sched_prio_to_wmult[40];
 #define ENQUEUE_MIGRATING	0x0010
 #define ENQUEUE_DELAYED		0x0020
 #define ENQUEUE_CLASS		0x0040
+#define ENQUEUE_PSI		0x0080
+
 
 #define ENQUEUE_HEAD		0x00010000
 #define ENQUEUE_REPLENISH	0x00020000
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index ebe0a7765..66f5cf16d 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -128,7 +128,8 @@ static inline void psi_enqueue(struct task_struct *p, int flags)
 		return;
 
 	/* Same runqueue, nothing changed for psi */
-	if (flags & ENQUEUE_RESTORE)
+	/* If change scheduler or priority (ENQUEUE_PSI), still update psi */
+	if ((flags & ENQUEUE_RESTORE) && !(flags & ENQUEUE_PSI))
 		return;
 
 	/* psi_sched_switch() will handle the flags */
@@ -145,15 +146,21 @@ static inline void psi_enqueue(struct task_struct *p, int flags)
 	} else if (flags & ENQUEUE_MIGRATED) {
 		/* CPU migration of runnable task */
 		set = TSK_RUNNING;
+		if (p->prio <= PSI_TASK_PRIO_THLD)
+			set |= TSK_HIGH_PRIO_RUNNING;
 		if (p->in_memstall)
 			set |= TSK_MEMSTALL | TSK_MEMSTALL_RUNNING;
+
 	} else {
 		/* Wakeup of new or sleeping task */
 		if (p->in_iowait)
 			clear |= TSK_IOWAIT;
 		set = TSK_RUNNING;
+		if (p->prio <= PSI_TASK_PRIO_THLD)
+			set |= TSK_HIGH_PRIO_RUNNING;
 		if (p->in_memstall)
 			set |= TSK_MEMSTALL_RUNNING;
+
 	}
 
 	psi_task_change(p, clear, set);
@@ -165,7 +172,8 @@ static inline void psi_dequeue(struct task_struct *p, int flags)
 		return;
 
 	/* Same runqueue, nothing changed for psi */
-	if (flags & DEQUEUE_SAVE)
+	/* If change scheduler or priority (DEQUEUE_PSI), still update psi */
+	if ((flags & DEQUEUE_SAVE) && !(flags & DEQUEUE_PSI))
 		return;
 
 	/*
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index b215b0ead..5a4cfd0ba 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -85,7 +85,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		return;
 	}
 
-	scoped_guard (sched_change, p, DEQUEUE_SAVE) {
+	scoped_guard (sched_change, p, DEQUEUE_SAVE | DEQUEUE_PSI) {
 		p->static_prio = NICE_TO_PRIO(nice);
 		set_load_weight(p, true);
 		old_prio = p->prio;
@@ -500,7 +500,7 @@ int __sched_setscheduler(struct task_struct *p,
 	struct balance_callback *head;
 	struct rq_flags rf;
 	int reset_on_fork;
-	int queue_flags = DEQUEUE_SAVE | DEQUEUE_MOVE | DEQUEUE_NOCLOCK;
+	int queue_flags = DEQUEUE_SAVE | DEQUEUE_MOVE | DEQUEUE_NOCLOCK | DEQUEUE_PSI;
 	struct rq *rq;
 	bool cpuset_locked = false;
 
-- 
2.34.1

