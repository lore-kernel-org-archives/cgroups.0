Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.245.243.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794309026;
	b=TpoAGflbo+DI9s+2SvgJ+iflc21N2iY4y9x6IL187dVZwUmunerZu5ljnwY0t/8tCgTr
	 mrDAb860oQsmc012KnVHk8bSMIyFp8chsDnNi9AwWsDK/u716hkJ4gmxsAQag9RSMgyXk
	 vdu3d0HoBM5Qg7EidmhPHef13L9emxCeR3L7H7Vpoj/YTRX1utQ1v979wyFSe/B9Y7rf/
	 UG87rtDH9lOZvbMNmktHG1RiDQaVk/mZKbKqgNtpLORrqOmGd2mtU0rJJa3JNycplR5bp
	 CP8AZ+eKTDtGU089SJv3G4XMNQeVHZSr1uCLvhg++SCdbN2IbnRU9z9//o2/+UlUu4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794309026;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=6WsNfX3og5yPdeN1VL0NLoPRqiFNmDQCADR/7+lgmLs=;
	b=rrdDjjc1dqpbDFr6d1RoscBIaAAF7/kEidioSAqtUQpKHpXmD11ayvaVsOenwpUDNVXA
	 eJG2jTiO2zRHQFmQ+zwA+kJ0ltYKzHFnY557v989IgQgsHBXWKOoXLm2UosV0kcnXlsTQ
	 fsQlDLd6L1NqGD61OjitsOj/3pf7a24zjyscOr+JjOLYm9gGeDbFN24ymk0Fid/4kY28k
	 HmcxW8iInrJVsTnxaTS7CYAW5Dnb3SiFfMmnOBON5UbMWykRnHLj4TGl9b8mMVX61C6fa
	 YS5unJWffdbnu7lK7Lgtv7uAxtumLRwsJZNlR/NRe+i10GKzW+fje8sXcDfKE76/osg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=EHhf7lXX;
	arc=none smtp.remote-ip=44.245.243.92
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E691606A32A;
	Tue, 10 Nov 2026 11:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E691606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=EHhf7lXX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794309024; x=1825845024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6WsNfX3og5yPdeN1VL0NLoPRqiFNmDQCADR/7+lgmLs=;
  b=EHhf7lXXbJU3kx+cyhO/01p3TblElCwaVXYlq+Qbk0ZTkKs1Dqt6Ol2F
   EhLRijTUwOLjibr6RZ1gHy1Juz/TsnWpmxOuNioolep5PdqP3f5XSDDA7
   SNkiI3VXOxmYfEdXFkBy/qY98U11hcxw1OTongf0yA/YUqdkbj+FONcKY
   YbL9RCzp3TD/12SltAf8iqnfeB1UpPDZbEF0/BhVxzaBo/+gHmP8TTnil
   B/s24EPMCNvvLfHT5ijMZ7cpq5HB/aj/mBgGcTNg38NIvz2WwhBJ039uo
   RavAq2LJKFvKFVGRy0uHzjFoMAvr6imI9ZGgXLPjPy7gGeKY2Hdd3tHBV
   A==;
X-CSE-ConnectionGUID: 0hGErgCDRQi8saLQRNP+/w==
X-CSE-MsgGUID: HYT1R/jnSPuUYrCn6cYCpw==
X-IronPort-AV: E=Sophos;i="6.27,205,1787011200"; 
   d="scan'208";a="33116789"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 11:10:22 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:20201]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.141:2525] with esmtp (Farcaster)
 id 4f7acfba-77ec-4db8-bacf-74e9156527e6; Tue, 10 Nov 2026 11:10:21 +0000 (UTC)
X-Farcaster-Flow-ID: 4f7acfba-77ec-4db8-bacf-74e9156527e6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 11:10:21 +0000
Received: from dev-dsk-sieberf-metal-1a-7543e84d.eu-west-1.amazon.com
 (172.19.116.227) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 10 Nov 2026
 11:10:16 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <tj@kernel.org>
CC: <bsegall@google.com>, <dietmar.eggemann@arm.com>, <rostedt@goodmis.org>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <kprateek.nayak@amd.com>,
	<hannes@cmpxchg.org>, <mkoutny@suse.com>, <void@manifault.com>,
	<arighi@nvidia.com>, <changwoo@igalia.com>, <skhan@linuxfoundation.org>,
	<corbet@lwn.net>, <rdunlap@infradead.org>, <cgroups@vger.kernel.org>,
	<sched-ext@lists.linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>,
	<hborghor@amazon.de>, <fmubeen@amazon.de>, <dwmw@amazon.co.uk>,
	<karataev@amazon.com>, <sieberf@amazon.com>
Subject: [PATCH v2 4/4] sched_ext: charge BPF scheduler tasks to cpu.max bandwidth
Date: Tue, 10 Nov 2026 13:08:51 +0200
Message-ID: <3977ed2471c6fdc19c672b2dcd13c70f997b9eff.1794303670.git.sieberf@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1794303670.git.sieberf@amazon.com>
References: <cover.1794303670.git.sieberf@amazon.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A BPF scheduler that enforces cpu.max keeps each cgroup's budget
itself, and no runtime moves between it and the fair class. One loaded
after a cpu.max.runtime write starts the cgroup on a fresh quota,
losing the unspent grant.

Conversely, a read reports the fair class's runtime, which refills to
quota + burst meanwhile. On disable, the fair class takes the tasks
back with that full runtime, so a cgroup that used up its budget runs
over its quota until the period accounting catches up.

Under SCX_OPS_SWITCH_PARTIAL, both budgets apply at once: a cgroup with
tasks in both classes runs up to its quota in each, which no handover
at load or unload can fix. Keep one budget, the fair class's, and let
a BPF scheduler opt in to drawing from it with the new
SCX_OPS_CHARGE_CPU_MAX flag.

With SCX_OPS_CHARGE_CPU_MAX, update_curr_scx() charges a task's runtime
to its cgroups' cfs_rqs as a fair task's would, without throttling it.
A task the scheduler stops late leaves its CPU in debt, which the next
periods pay, also once the task has moved; debt past minus a slice
moves to cfs_b, whose next refill pays up to a quota of it. The new
kfunc scx_bpf_task_cpu_max_runtime() returns the runtime left less that
debt, and the scheduler runs the task only while it is positive.
Cgroups whose period timer is stopped are skipped, as only a charge
restarts it.

Both classes then draw from one budget: under SCX_OPS_SWITCH_PARTIAL a
cgroup gets its quota per period however its tasks are split, and
nothing is handed over at load or unload. A task returning to the fair
class leaves its CPU at most a slice in debt; schedulers without the
flag behave as before.

cfs_b->lock is taken at most twice per millisecond of run time per CPU.
The cgroup_runtime selftest covers these cases.

Signed-off-by: Fernand Sieber <sieberf@amazon.com>
---
 Documentation/admin-guide/cgroup-v2.rst       |   4 +-
 kernel/sched/ext/ext.c                        |  34 +
 kernel/sched/ext/internal.h                   |  24 +-
 kernel/sched/fair.c                           | 122 ++++
 kernel/sched/sched.h                          |  12 +
 tools/sched_ext/include/scx/common.bpf.h      |   1 +
 tools/sched_ext/include/scx/compat.h          |   1 +
 tools/testing/selftests/sched_ext/Makefile    |   1 +
 .../selftests/sched_ext/cgroup_runtime.bpf.c  | 195 ++++++
 .../selftests/sched_ext/cgroup_runtime.c      | 652 ++++++++++++++++++
 tools/testing/selftests/sched_ext/config      |   1 +
 11 files changed, 1045 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/sched_ext/cgroup_runtime.bpf.c
 create mode 100644 tools/testing/selftests/sched_ext/cgroup_runtime.c

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index b77ca6f8ca548..db9fa6e6dbd49 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1258,7 +1258,9 @@ will be referred to. All time durations are in microseconds.
 
 	This file affects only processes under the fair-class scheduler and a BPF
 	scheduler with the ``cgroup_set_runtime`` callback depending on what
-	the callback actually does.
+	the callback actually does. A BPF scheduler with the
+	``SCX_OPS_CHARGE_CPU_MAX`` flag draws what its processes run from
+	the same runtime, so the cgroup's processes in both share it.
 
   cpu.pressure
 	A read-write nested-keyed file.
diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 265a80dd93282..6ffc9ca2c5c9f 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -1625,6 +1625,11 @@ static void expire_task_slice(struct task_struct *p)
 		scx_set_task_slice(p, 0);
 }
 
+static bool scx_task_charges_cpu_max(const struct task_struct *p)
+{
+	return scx_task_sched(p)->ops.flags & SCX_OPS_CHARGE_CPU_MAX;
+}
+
 static void update_curr_scx(struct rq *rq)
 {
 	struct task_struct *donor;
@@ -1650,6 +1655,9 @@ static void update_curr_scx(struct rq *rq)
 	if (unlikely(donor == scx_rescuee(rq)))
 		scx_rescue_charge(rq, delta_exec);
 
+	if (scx_task_charges_cpu_max(donor))
+		cfs_bandwidth_charge_task(rq, donor, delta_exec);
+
 	dl_server_update(&rq->ext_server, delta_exec);
 }
 
@@ -2605,6 +2613,13 @@ static bool dequeue_task_scx(struct rq *rq, struct task_struct *p, int core_deq_
 
 	ops_dequeue(rq, p, deq_flags);
 
+	/* charge what @p ran, then return what @rq holds for its cgroups */
+	if (scx_task_charges_cpu_max(p)) {
+		if (task_current_donor(rq, p))
+			update_curr_scx(rq);
+		cfs_bandwidth_return_task(rq, p);
+	}
+
 	/*
 	 * A current scheduling context which is going off @rq first gets
 	 * dequeued and then stops running. As we want running <-> stopping
@@ -11793,6 +11808,24 @@ __bpf_kfunc s32 scx_bpf_task_cpu(const struct task_struct *p)
 	return task_cpu(p);
 }
 
+/**
+ * scx_bpf_task_cpu_max_runtime - Runtime a task has left under cpu.max
+ * @p: task of interest
+ *
+ * Return the runtime in nsecs that @p's cgroup and its ancestors have left
+ * under their cpu.max quotas for @p on its current CPU, the least over those
+ * with a quota: the cgroup's cpu.max.runtime plus what the CPU holds for
+ * the cgroup, less what it owes. U64_MAX if none limits it. Read without
+ * locks.
+ *
+ * With %SCX_OPS_CHARGE_CPU_MAX, the scheduler should run @p only while this
+ * returns more than 0. The runtime grows when a period refills it.
+ */
+__bpf_kfunc u64 scx_bpf_task_cpu_max_runtime(struct task_struct *p)
+{
+	return cfs_bandwidth_task_runtime(p);
+}
+
 /**
  * scx_bpf_task_cid - cid a task is currently associated with
  * @p: task of interest
@@ -12119,6 +12152,7 @@ BTF_ID_FLAGS(func, scx_bpf_get_online_cpumask, KF_ACQUIRE)
 BTF_ID_FLAGS(func, scx_bpf_put_cpumask, KF_RELEASE)
 BTF_ID_FLAGS(func, scx_bpf_task_running, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_task_cpu, KF_RCU)
+BTF_ID_FLAGS(func, scx_bpf_task_cpu_max_runtime, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_task_cid, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_locked_rq, KF_IMPLICIT_ARGS | KF_RET_NULL)
 BTF_ID_FLAGS(func, scx_bpf_cpu_curr, KF_IMPLICIT_ARGS | KF_RET_NULL | KF_RCU_PROTECTED)
diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index e794507596d6f..e8c0b573d0a43 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -243,6 +243,27 @@ enum scx_ops_flags {
 	 */
 	SCX_OPS_ENQ_BLOCKED		= 1LLU << 10,
 
+	/*
+	 * If set, what the scheduler's tasks run is charged to the cpu.max
+	 * bandwidth of their cgroups, the runtime the fair class keeps and
+	 * cpu.max.runtime reads, as what fair tasks run is. The tasks of a
+	 * cgroup in both classes then share one quota, also with
+	 * %SCX_OPS_SWITCH_PARTIAL, and nothing is handed over when tasks
+	 * switch class.
+	 *
+	 * The kernel never throttles the scheduler's tasks. The scheduler
+	 * enforces the quota by running a task only while
+	 * scx_bpf_task_cpu_max_runtime() returns more than 0. What a task runs
+	 * beyond that is charged: up to a slice (sched_cfs_bandwidth_slice_us)
+	 * per CPU as a debt the cgroup's fair tasks on that CPU pay back, and up
+	 * to a quota more from the cgroup's next period. The scheduler does not
+	 * need ops.cgroup_set_runtime(), as a write of cpu.max.runtime sets that
+	 * runtime.
+	 *
+	 * Without CONFIG_CFS_BANDWIDTH, this flag has no effect.
+	 */
+	SCX_OPS_CHARGE_CPU_MAX		= 1LLU << 11,
+
 	SCX_OPS_ALL_FLAGS		= SCX_OPS_KEEP_BUILTIN_IDLE |
 					  SCX_OPS_ENQ_LAST |
 					  SCX_OPS_ENQ_EXITING |
@@ -253,7 +274,8 @@ enum scx_ops_flags {
 					  SCX_OPS_ALWAYS_ENQ_IMMED |
 					  SCX_OPS_TID_TO_TASK |
 					  SCX_OPS_LAZY_RESCHED |
-					  SCX_OPS_ENQ_BLOCKED,
+					  SCX_OPS_ENQ_BLOCKED |
+					  SCX_OPS_CHARGE_CPU_MAX,
 
 	/* high 8 bits are internal, don't include in SCX_OPS_ALL_FLAGS */
 	__SCX_OPS_INTERNAL_MASK		= 0xffLLU << 56,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bc068b3fa4ed1..9ff239f122bda 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6875,6 +6875,11 @@ void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 	}
 
 	cfs_b->runtime = min(cfs_b->runtime, cfs_b->quota + cfs_b->burst);
+
+	/* pay the debt cfs_bandwidth_charge_task() left */
+	runtime = min(cfs_b->runtime, cfs_b->debt);
+	cfs_b->runtime -= runtime;
+	cfs_b->debt -= runtime;
 	cfs_b->runtime_snap = cfs_b->runtime;
 }
 
@@ -8076,6 +8081,123 @@ bool cfs_task_bw_constrained(struct task_struct *p)
 	return false;
 }
 
+/*
+ * Charge @delta_exec, which @p ran on @rq outside the fair class, to the
+ * bandwidth of its task group and of each ancestor with a quota, as
+ * account_cfs_rq_runtime() charges a fair task. A cfs_rq that runs out takes
+ * another slice from cfs_b, but @p is never throttled: the BPF scheduler that
+ * runs it stops it, and the group's fair tasks are throttled when they run.
+ *
+ * Debt below -slice that cfs_b cannot cover moves to cfs_b, up to a quota,
+ * and the next refill pays it, so that a scheduler which keeps running @p
+ * cannot put the group's fair tasks on @rq in more debt than a slice.
+ */
+void cfs_bandwidth_charge_task(struct rq *rq, struct task_struct *p,
+			       u64 delta_exec)
+{
+	s64 floor = -(s64)sched_cfs_bandwidth_slice();
+	struct task_group *tg;
+
+	lockdep_assert_rq_held(rq);
+
+	if (!cfs_bandwidth_used())
+		return;
+
+	for (tg = task_group(p); tg; tg = tg->parent) {
+		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+		struct cfs_rq *cfs_rq = tg_cfs_rq(tg, cpu_of(rq));
+
+		if (!cfs_rq->runtime_enabled)
+			continue;
+
+		cfs_rq->runtime_remaining -= delta_exec;
+
+		/*
+		 * A throttled cfs_rq gets runtime from distribute_cfs_runtime().
+		 * Without runtime, an active period timer refills it, so skip
+		 * the lock. A stopped one is restarted by the assign.
+		 */
+		if (cfs_rq->runtime_remaining <= 0 && !cfs_rq->throttled &&
+		    (READ_ONCE(cfs_b->runtime) || !READ_ONCE(cfs_b->period_active))) {
+			scoped_guard (raw_spinlock, &cfs_b->lock)
+				__assign_cfs_rq_runtime(cfs_b, cfs_rq,
+							sched_cfs_bandwidth_slice());
+		}
+
+		if (cfs_rq->runtime_remaining < floor) {
+			scoped_guard (raw_spinlock, &cfs_b->lock)
+				cfs_b->debt = min_t(u64, cfs_b->debt + floor -
+						    cfs_rq->runtime_remaining, cfs_b->quota);
+			cfs_rq->runtime_remaining = floor;
+		}
+	}
+}
+
+/*
+ * @p leaves @rq: give the runtime @rq holds for its groups back, less
+ * min_cfs_rq_runtime, as a fair dequeue does when a cfs_rq empties. Pay
+ * what @rq owes from cfs_b, as @p may not run on @rq again.
+ */
+void cfs_bandwidth_return_task(struct rq *rq, struct task_struct *p)
+{
+	struct task_group *tg;
+
+	lockdep_assert_rq_held(rq);
+
+	if (!cfs_bandwidth_used())
+		return;
+
+	for (tg = task_group(p); tg; tg = tg->parent) {
+		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+		struct cfs_rq *cfs_rq = tg_cfs_rq(tg, cpu_of(rq));
+
+		return_cfs_rq_runtime(cfs_rq);
+
+		if (cfs_rq->runtime_enabled && cfs_rq->runtime_remaining < 0 &&
+		    !cfs_rq->throttled && READ_ONCE(cfs_b->runtime)) {
+			scoped_guard (raw_spinlock, &cfs_b->lock)
+				__assign_cfs_rq_runtime(cfs_b, cfs_rq, 0);
+		}
+	}
+}
+
+/*
+ * The runtime @p's groups have left for it on its CPU, without locks: the
+ * least, over the groups with a quota, of what the CPU holds or owes and
+ * cfs_b's runtime. Debt counts up to a quota less 1ns, so that a full period
+ * lets @p run and pay the rest. A group whose period timer is stopped does
+ * not count, as the next charge restarts the timer and refills what it owes.
+ * RUNTIME_INF if no group counts.
+ */
+u64 cfs_bandwidth_task_runtime(struct task_struct *p)
+{
+	u64 runtime = RUNTIME_INF;
+	struct task_group *tg;
+	int cpu = task_cpu(p);
+
+	if (!cfs_bandwidth_used())
+		return runtime;
+
+	guard(rcu)();
+
+	for (tg = task_group(p); tg; tg = tg->parent) {
+		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+		struct cfs_rq *cfs_rq = tg_cfs_rq(tg, cpu);
+		s64 held;
+
+		if (!READ_ONCE(cfs_rq->runtime_enabled) ||
+		    !READ_ONCE(cfs_b->period_active))
+			continue;
+
+		held = max_t(s64, READ_ONCE(cfs_rq->runtime_remaining),
+			     1 - (s64)READ_ONCE(cfs_b->quota));
+		held += READ_ONCE(cfs_b->runtime);
+		runtime = min_t(u64, runtime, max_t(s64, held, 0));
+	}
+
+	return runtime;
+}
+
 #ifdef CONFIG_NO_HZ_FULL
 /* called from pick_next_task_fair() */
 static void sched_fair_update_stop_tick(struct rq *rq, struct task_struct *p)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 676e6371d0265..fd98000ffd744 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -456,6 +456,7 @@ struct cfs_bandwidth {
 	u64			runtime;
 	u64			burst;
 	u64			runtime_snap;
+	u64			debt;
 	s64			hierarchical_quota;
 
 	u8			idle;
@@ -621,6 +622,17 @@ static inline bool cfs_task_bw_constrained(struct task_struct *p) { return false
 
 #endif /* !CONFIG_CGROUP_SCHED */
 
+#ifdef CONFIG_CFS_BANDWIDTH
+void cfs_bandwidth_charge_task(struct rq *rq, struct task_struct *p, u64 delta_exec);
+void cfs_bandwidth_return_task(struct rq *rq, struct task_struct *p);
+u64 cfs_bandwidth_task_runtime(struct task_struct *p);
+#else
+static inline void cfs_bandwidth_charge_task(struct rq *rq, struct task_struct *p,
+					     u64 delta_exec) { }
+static inline void cfs_bandwidth_return_task(struct rq *rq, struct task_struct *p) { }
+static inline u64 cfs_bandwidth_task_runtime(struct task_struct *p) { return RUNTIME_INF; }
+#endif
+
 /*
  * A weight of 0 or 1 can cause arithmetics problems.
  * A weight of a cfs_rq is the sum of weights of which entities
diff --git a/tools/sched_ext/include/scx/common.bpf.h b/tools/sched_ext/include/scx/common.bpf.h
index 6194484d4d9a9..cfb7f1b70665f 100644
--- a/tools/sched_ext/include/scx/common.bpf.h
+++ b/tools/sched_ext/include/scx/common.bpf.h
@@ -98,6 +98,7 @@ s32 scx_bpf_pick_any_cpu_node(const cpumask_t *cpus_allowed, int node, u64 flags
 s32 scx_bpf_pick_any_cpu(const cpumask_t *cpus_allowed, u64 flags) __ksym;
 bool scx_bpf_task_running(const struct task_struct *p) __ksym;
 s32 scx_bpf_task_cpu(const struct task_struct *p) __ksym;
+u64 scx_bpf_task_cpu_max_runtime(struct task_struct *p) __ksym __weak;
 struct rq *scx_bpf_cpu_rq(s32 cpu) __ksym __weak;
 struct rq *scx_bpf_locked_rq(void) __ksym;
 struct task_struct *scx_bpf_cpu_curr(s32 cpu) __ksym __weak;
diff --git a/tools/sched_ext/include/scx/compat.h b/tools/sched_ext/include/scx/compat.h
index 07fb55e63c57c..60b9972f1a5dc 100644
--- a/tools/sched_ext/include/scx/compat.h
+++ b/tools/sched_ext/include/scx/compat.h
@@ -215,6 +215,7 @@ static inline bool __COMPAT_struct_has_field(const char *type, const char *field
 #define SCX_OPS_BUILTIN_IDLE_PER_NODE SCX_OPS_FLAG(SCX_OPS_BUILTIN_IDLE_PER_NODE)
 #define SCX_OPS_ALWAYS_ENQ_IMMED SCX_OPS_FLAG(SCX_OPS_ALWAYS_ENQ_IMMED)
 #define SCX_OPS_ENQ_BLOCKED SCX_OPS_FLAG(SCX_OPS_ENQ_BLOCKED)
+#define SCX_OPS_CHARGE_CPU_MAX SCX_OPS_FLAG(SCX_OPS_CHARGE_CPU_MAX)
 
 #define SCX_PICK_IDLE_FLAG(name) __COMPAT_ENUM_OR_ZERO("scx_pick_idle_cpu_flags", #name)
 
diff --git a/tools/testing/selftests/sched_ext/Makefile b/tools/testing/selftests/sched_ext/Makefile
index c5d3a2eaea7da..4a727b8dc7aab 100644
--- a/tools/testing/selftests/sched_ext/Makefile
+++ b/tools/testing/selftests/sched_ext/Makefile
@@ -165,6 +165,7 @@ all_test_bpfprogs := $(foreach prog,$(wildcard *.bpf.c),$(INCLUDE_DIR)/$(patsubs
 
 auto-test-targets :=			\
 	cgroup_nr_cpus			\
+	cgroup_runtime			\
 	create_dsq			\
 	dequeue				\
 	dequeue_iter			\
diff --git a/tools/testing/selftests/sched_ext/cgroup_runtime.bpf.c b/tools/testing/selftests/sched_ext/cgroup_runtime.bpf.c
new file mode 100644
index 0000000000000..ec98a25d19c29
--- /dev/null
+++ b/tools/testing/selftests/sched_ext/cgroup_runtime.bpf.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A scheduler with SCX_OPS_CHARGE_CPU_MAX, for the cgroup_runtime tests. It
+ * runs a task only while scx_bpf_task_cpu_max_runtime() says it has runtime
+ * left, unless @ignore_runtime is set. A task that has none waits in HELD_DSQ,
+ * and a timer kicks the idle CPUs every millisecond, so that they take it
+ * once a period refills the runtime.
+ *
+ * partial_ops sets SCX_OPS_SWITCH_PARTIAL and full_ops does not. Both pass
+ * the cpu.max and cpu.max.runtime writes of @cgid on to the test.
+ */
+
+#include <scx/common.bpf.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define HELD_DSQ	0
+#define KICK_NS		1000000
+
+UEI_DEFINE(uei);
+
+/* the cgroup under test, set before attaching */
+u64 cgid;
+
+/* run tasks whether or not they have runtime left */
+bool ignore_runtime;
+
+/* tasks held for lack of runtime */
+u64 nr_held;
+
+/* the cpu.max and cpu.max.runtime writes of @cgid */
+u64 nr_set_bw;
+u64 quota_us;
+u64 burst_us;
+u64 nr_set_runtime;
+/* cgroup_set_runtime() calls above the quota + burst last given */
+u64 nr_bad_order;
+
+struct kick_timer {
+	struct bpf_timer timer;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, u32);
+	__type(value, struct kick_timer);
+} kick_timer SEC(".maps");
+
+static bool runnable(struct task_struct *p)
+{
+	return ignore_runtime || scx_bpf_task_cpu_max_runtime(p);
+}
+
+s32 BPF_STRUCT_OPS(cgroup_runtime_select_cpu, struct task_struct *p,
+		   s32 prev_cpu, u64 wake_flags)
+{
+	return prev_cpu;
+}
+
+void BPF_STRUCT_OPS(cgroup_runtime_enqueue, struct task_struct *p,
+		    u64 enq_flags)
+{
+	if (!runnable(p)) {
+		__sync_fetch_and_add(&nr_held, 1);
+		scx_bpf_dsq_insert(p, HELD_DSQ, SCX_SLICE_DFL, enq_flags);
+		return;
+	}
+	/* the last task of a CPU going idle must go to its local DSQ */
+	if (enq_flags & SCX_ENQ_LAST)
+		scx_bpf_dsq_insert(p, SCX_DSQ_LOCAL, SCX_SLICE_DFL, enq_flags);
+	else
+		scx_bpf_dsq_insert(p, SCX_DSQ_GLOBAL, SCX_SLICE_DFL, enq_flags);
+}
+
+void BPF_STRUCT_OPS(cgroup_runtime_dispatch, s32 cpu, struct task_struct *prev)
+{
+	struct task_struct *p = __COMPAT_scx_bpf_dsq_peek(HELD_DSQ);
+
+	if (p && runnable(p))
+		scx_bpf_dsq_move_to_local(HELD_DSQ, 0);
+}
+
+/*
+ * Stop a task that ran out, so that it goes through enqueue again.
+ * SCX_OPS_ENQ_LAST makes that so also when it is alone on its CPU.
+ */
+void BPF_STRUCT_OPS(cgroup_runtime_tick, struct task_struct *p)
+{
+	if (!runnable(p))
+		scx_bpf_task_set_slice(p, 0);
+}
+
+static int kick_timerfn(void *map, int *key, struct bpf_timer *timer)
+{
+	s32 cpu;
+
+	if (scx_bpf_dsq_nr_queued(HELD_DSQ))
+		bpf_for(cpu, 0, scx_bpf_nr_cpu_ids())
+			scx_bpf_kick_cpu(cpu, SCX_KICK_IDLE);
+
+	bpf_timer_start(timer, KICK_NS, 0);
+	return 0;
+}
+
+s32 BPF_STRUCT_OPS_SLEEPABLE(cgroup_runtime_init)
+{
+	struct bpf_timer *timer;
+	u32 key = 0;
+	s32 ret;
+
+	ret = scx_bpf_create_dsq(HELD_DSQ, -1);
+	if (ret)
+		return ret;
+
+	timer = bpf_map_lookup_elem(&kick_timer, &key);
+	if (!timer)
+		return -ESRCH;
+	bpf_timer_init(timer, &kick_timer, CLOCK_MONOTONIC);
+	bpf_timer_set_callback(timer, kick_timerfn);
+	return bpf_timer_start(timer, KICK_NS, 0);
+}
+
+static bool is_target(struct cgroup *cgrp)
+{
+	return cgid && cgrp->kn->id == cgid;
+}
+
+/* sleepable: cpu.max writes call it in process context */
+void BPF_STRUCT_OPS_SLEEPABLE(cgroup_runtime_cgroup_set_bandwidth,
+			      struct cgroup *cgrp, u64 period_us, u64 quota,
+			      u64 burst)
+{
+	if (!is_target(cgrp))
+		return;
+
+	__sync_fetch_and_add(&nr_set_bw, 1);
+	quota_us = quota;
+	burst_us = burst;
+}
+
+void BPF_STRUCT_OPS_SLEEPABLE(cgroup_runtime_cgroup_set_runtime,
+			      struct cgroup *cgrp, u64 runtime_us)
+{
+	if (!is_target(cgrp))
+		return;
+
+	__sync_fetch_and_add(&nr_set_runtime, 1);
+	if (runtime_us > quota_us + burst_us)
+		__sync_fetch_and_add(&nr_bad_order, 1);
+}
+
+s32 BPF_STRUCT_OPS(cgroup_runtime_cgroup_init, struct cgroup *cgrp,
+		   struct scx_cgroup_init_args *args)
+{
+	if (is_target(cgrp)) {
+		quota_us = args->bw_quota_us;
+		burst_us = args->bw_burst_us;
+	}
+	return 0;
+}
+
+void BPF_STRUCT_OPS(cgroup_runtime_exit, struct scx_exit_info *ei)
+{
+	UEI_RECORD(uei, ei);
+}
+
+SCX_OPS_DEFINE(partial_ops,
+	       .select_cpu		= (void *)cgroup_runtime_select_cpu,
+	       .enqueue			= (void *)cgroup_runtime_enqueue,
+	       .dispatch		= (void *)cgroup_runtime_dispatch,
+	       .tick			= (void *)cgroup_runtime_tick,
+	       .init			= (void *)cgroup_runtime_init,
+	       .cgroup_init		= (void *)cgroup_runtime_cgroup_init,
+	       .cgroup_set_bandwidth	= (void *)cgroup_runtime_cgroup_set_bandwidth,
+	       .cgroup_set_runtime	= (void *)cgroup_runtime_cgroup_set_runtime,
+	       .exit			= (void *)cgroup_runtime_exit,
+	       .flags			= SCX_OPS_SWITCH_PARTIAL |
+					  SCX_OPS_ENQ_LAST |
+					  SCX_OPS_CHARGE_CPU_MAX,
+	       .name			= "cgroup_runtime");
+
+SCX_OPS_DEFINE(full_ops,
+	       .select_cpu		= (void *)cgroup_runtime_select_cpu,
+	       .enqueue			= (void *)cgroup_runtime_enqueue,
+	       .dispatch		= (void *)cgroup_runtime_dispatch,
+	       .tick			= (void *)cgroup_runtime_tick,
+	       .init			= (void *)cgroup_runtime_init,
+	       .cgroup_init		= (void *)cgroup_runtime_cgroup_init,
+	       .cgroup_set_bandwidth	= (void *)cgroup_runtime_cgroup_set_bandwidth,
+	       .cgroup_set_runtime	= (void *)cgroup_runtime_cgroup_set_runtime,
+	       .exit			= (void *)cgroup_runtime_exit,
+	       .flags			= SCX_OPS_ENQ_LAST |
+					  SCX_OPS_CHARGE_CPU_MAX,
+	       .name			= "cgroup_runtime_full");
diff --git a/tools/testing/selftests/sched_ext/cgroup_runtime.c b/tools/testing/selftests/sched_ext/cgroup_runtime.c
new file mode 100644
index 0000000000000..86d50a63a6e73
--- /dev/null
+++ b/tools/testing/selftests/sched_ext/cgroup_runtime.c
@@ -0,0 +1,652 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Verify that a BPF scheduler with SCX_OPS_CHARGE_CPU_MAX shares a cgroup's
+ * cpu.max quota with the fair class: what the cgroup's tasks run in both
+ * classes, with and without SCX_OPS_SWITCH_PARTIAL and while tasks switch
+ * class, stays within the quota; nothing is gained or lost when the
+ * scheduler loads and unloads; and a scheduler that ignores
+ * scx_bpf_task_cpu_max_runtime() leaves the fair tasks at most a quota of
+ * debt and a slice per CPU, while one that stops tasks late pays the overrun
+ * back.
+ * Also verify that cpu.max and cpu.max.runtime writes reach the scheduler
+ * in the order the fair class applied them.
+ *
+ * Usage is cpu.stat's usage_usec. A window of n periods may hold n + 1
+ * refills and start or end with up to a quota, and each CPU may hold up to
+ * a slice (sched_cfs_bandwidth_slice_us), so the checks allow that.
+ */
+
+#define _GNU_SOURCE
+#include <bpf/bpf.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/limits.h>
+#include <pthread.h>
+#include <sched.h>
+#include <scx/common.h>
+#include <signal.h>
+#include <stdarg.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/wait.h>
+#include <time.h>
+#include <unistd.h>
+
+#include "cgroup_runtime.bpf.skel.h"
+#include "cgroup_util.h"
+#include "scx_test.h"
+
+#ifndef SCHED_EXT
+#define SCHED_EXT	7
+#endif
+
+#define PERIOD_US	100000LL
+#define QUOTA_US	20000LL
+#define NR_PERIODS	10
+#define NR_BURNERS	2
+
+struct ctx {
+	struct cgroup_runtime *skel;
+	struct bpf_link *link;
+	char root[PATH_MAX];
+	char parent[PATH_MAX];
+	char cg[PATH_MAX];
+	bool parent_created;
+	bool cg_created;
+	pid_t burner[NR_BURNERS];
+	long long slice_us;
+	long long saved_slice_us;
+};
+
+static int join_path(char *dst, size_t dst_size, const char *parent, const char *name)
+{
+	int ret;
+
+	ret = snprintf(dst, dst_size, "%s/%s", parent, name);
+	if (ret < 0 || (size_t)ret >= dst_size)
+		return -ENAMETOOLONG;
+	return 0;
+}
+
+static u64 now_us(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	return ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000;
+}
+
+static u64 cgroup_id(const char *path)
+{
+	union {
+		u64 id;
+		unsigned char bytes[8];
+	} id = {};
+	struct file_handle *handle;
+	int mount_id, ret;
+
+	handle = calloc(1, sizeof(*handle) + sizeof(id));
+	if (!handle)
+		return 0;
+	handle->handle_bytes = sizeof(id);
+	ret = name_to_handle_at(AT_FDCWD, path, handle, &mount_id, 0);
+	if (!ret && handle->handle_bytes == sizeof(id))
+		memcpy(id.bytes, handle->f_handle, sizeof(id));
+	free(handle);
+
+	return ret ? 0 : id.id;
+}
+
+static long long read_runtime(struct ctx *ctx)
+{
+	return cg_read_long(ctx->cg, "cpu.max.runtime");
+}
+
+static long long read_usage(struct ctx *ctx)
+{
+	return cg_read_key_long(ctx->cg, "cpu.stat", "usage_usec");
+}
+
+static int write_str(const char *cgroup, const char *file, const char *fmt, ...)
+{
+	char buf[64];
+	va_list ap;
+
+	va_start(ap, fmt);
+	vsnprintf(buf, sizeof(buf), fmt, ap);
+	va_end(ap);
+	return cg_write(cgroup, file, buf);
+}
+
+static bool controller_enabled(const char *cgroup, const char *file, const char *controller)
+{
+	char buf[4096], *saveptr, *token;
+
+	if (cg_read(cgroup, file, buf, sizeof(buf)))
+		return false;
+	for (token = strtok_r(buf, "\n ", &saveptr); token;
+	     token = strtok_r(NULL, "\n ", &saveptr))
+		if (!strcmp(token, controller))
+			return true;
+	return false;
+}
+
+static int set_policy(pid_t pid, int policy)
+{
+	struct sched_param param = {};
+
+	return sched_setscheduler(pid, policy, &param);
+}
+
+static void stop_burners(struct ctx *ctx)
+{
+	int i;
+
+	for (i = 0; i < NR_BURNERS; i++) {
+		if (ctx->burner[i] <= 0)
+			continue;
+		kill(ctx->burner[i], SIGKILL);
+		waitpid(ctx->burner[i], NULL, 0);
+		ctx->burner[i] = 0;
+	}
+}
+
+/* a task in @ctx->cg that spins on CPU @i + 1 under @policy */
+static int start_burner(struct ctx *ctx, int i, int policy)
+{
+	cpu_set_t set;
+	pid_t pid;
+
+	pid = fork();
+	if (pid < 0)
+		return -errno;
+	if (!pid)
+		for (;;)
+			;
+
+	ctx->burner[i] = pid;
+	CPU_ZERO(&set);
+	CPU_SET((i + 1) % libbpf_num_possible_cpus(), &set);
+	if (sched_setaffinity(pid, sizeof(set), &set) ||
+	    cg_enter(ctx->cg, pid) || set_policy(pid, policy))
+		return -1;
+	return 0;
+}
+
+static void cleanup(void *arg)
+{
+	struct ctx *ctx = arg;
+
+	if (!ctx)
+		return;
+	stop_burners(ctx);
+	bpf_link__destroy(ctx->link);
+	cgroup_runtime__destroy(ctx->skel);
+	if (ctx->saved_slice_us)
+		write_str("/proc/sys/kernel", "sched_cfs_bandwidth_slice_us", "%lld",
+			  ctx->saved_slice_us);
+	if (ctx->cg_created)
+		cg_destroy(ctx->cg);
+	if (ctx->parent_created)
+		cg_destroy(ctx->parent);
+	free(ctx);
+}
+
+/*
+ * Open the skeleton and make parent/cg under the cgroup2 root, with a quota
+ * of @quota us per @period us, a burst of @burst us and a runtime of
+ * @runtime us on cg.
+ */
+static enum scx_test_status setup_ctx(void **ctxp, long long quota,
+				      long long period, long long burst,
+				      long long runtime)
+{
+	struct ctx *ctx;
+	char name[64];
+
+	ctx = calloc(1, sizeof(*ctx));
+	if (!ctx)
+		return SCX_TEST_FAIL;
+	*ctxp = ctx;
+
+	/* SCX_ENUM_INIT() exits if vmlinux BTF can't be loaded: before cgroups */
+	ctx->skel = cgroup_runtime__open();
+	if (!ctx->skel) {
+		SCX_ERR("Failed to open skel");
+		return SCX_TEST_FAIL;
+	}
+	SCX_ENUM_INIT(ctx->skel);
+
+	ctx->slice_us = 5000;
+	if (!access("/proc/sys/kernel/sched_cfs_bandwidth_slice_us", R_OK))
+		ctx->slice_us = cg_read_long("/proc/sys/kernel",
+					     "sched_cfs_bandwidth_slice_us");
+
+	if (cg_find_unified_root(ctx->root, sizeof(ctx->root), NULL))
+		return SCX_TEST_SKIP;
+	if (!controller_enabled(ctx->root, "cgroup.subtree_control", "cpu") &&
+	    cg_write(ctx->root, "cgroup.subtree_control", "+cpu"))
+		return SCX_TEST_SKIP;
+
+	snprintf(name, sizeof(name), "scx_cgroup_runtime_%d", getpid());
+	if (join_path(ctx->parent, sizeof(ctx->parent), ctx->root, name) ||
+	    join_path(ctx->cg, sizeof(ctx->cg), ctx->parent, "cg")) {
+		SCX_ERR("Cgroup path is too long");
+		return SCX_TEST_FAIL;
+	}
+
+	if (cg_create(ctx->parent)) {
+		SCX_ERR("Failed to create %s", ctx->parent);
+		return SCX_TEST_FAIL;
+	}
+	ctx->parent_created = true;
+	if (cg_write(ctx->parent, "cgroup.subtree_control", "+cpu")) {
+		SCX_ERR("Failed to enable cpu in %s", ctx->parent);
+		return SCX_TEST_FAIL;
+	}
+	if (cg_create(ctx->cg)) {
+		SCX_ERR("Failed to create %s", ctx->cg);
+		return SCX_TEST_FAIL;
+	}
+	ctx->cg_created = true;
+
+	if (access(cg_control(ctx->cg, "cpu.max.runtime"), F_OK))
+		return SCX_TEST_SKIP;
+
+	if (write_str(ctx->cg, "cpu.max", "%lld %lld", quota, period) ||
+	    write_str(ctx->cg, "cpu.max.burst", "%lld", burst) ||
+	    write_str(ctx->cg, "cpu.max.runtime", "%lld", runtime)) {
+		SCX_ERR("Failed to configure %s", ctx->cg);
+		return SCX_TEST_FAIL;
+	}
+
+	ctx->skel->bss->cgid = cgroup_id(ctx->cg);
+	if (!ctx->skel->bss->cgid) {
+		SCX_ERR("Failed to read the cgroup ID of %s", ctx->cg);
+		return SCX_TEST_FAIL;
+	}
+	if (libbpf_num_possible_cpus() < NR_BURNERS + 1)
+		return SCX_TEST_SKIP;
+	return SCX_TEST_PASS;
+}
+
+static enum scx_test_status setup_rate(void **ctxp)
+{
+	return setup_ctx(ctxp, QUOTA_US, PERIOD_US, 0, QUOTA_US);
+}
+
+static enum scx_test_status attach_ops(struct ctx *ctx, bool partial)
+{
+	ctx->link = bpf_map__attach_struct_ops(partial ? ctx->skel->maps.partial_ops :
+						       ctx->skel->maps.full_ops);
+	SCX_FAIL_IF(!ctx->link, "Failed to attach scheduler");
+	return SCX_TEST_PASS;
+}
+
+static enum scx_test_status load_ops(struct ctx *ctx, bool partial)
+{
+	bpf_map__set_autoattach(ctx->skel->maps.partial_ops, false);
+	bpf_map__set_autoattach(ctx->skel->maps.full_ops, false);
+	SCX_FAIL_IF(cgroup_runtime__load(ctx->skel), "Failed to load skel");
+	return attach_ops(ctx, partial);
+}
+
+static void detach(struct ctx *ctx)
+{
+	bpf_link__destroy(ctx->link);
+	ctx->link = NULL;
+}
+
+/*
+ * Run two burners in cg under @policy[], the first switching class every
+ * 7 ms if @toggle, and check that cg runs its quota per period, no more and
+ * not much less.
+ */
+static enum scx_test_status run_rate(struct ctx *ctx, bool partial,
+				     const int *policy, bool toggle)
+{
+	long long tol = NR_BURNERS * ctx->slice_us + QUOTA_US;
+	long long used, u0;
+	bool ext = false;
+	u64 end;
+	int i;
+
+	if (load_ops(ctx, partial))
+		return SCX_TEST_FAIL;
+	for (i = 0; i < NR_BURNERS; i++)
+		SCX_EQ(start_burner(ctx, i, policy[i]), 0);
+
+	usleep(3 * PERIOD_US);
+	u0 = read_usage(ctx);
+	end = now_us() + NR_PERIODS * PERIOD_US;
+	while (now_us() < end) {
+		if (toggle) {
+			ext = !ext;
+			SCX_EQ(set_policy(ctx->burner[0], ext ? SCHED_EXT : SCHED_OTHER), 0);
+		}
+		usleep(7000);
+	}
+	used = read_usage(ctx) - u0;
+	stop_burners(ctx);
+
+	printf("ran %lld us in %d periods of quota %lld us, %lu held\n",
+	       used, NR_PERIODS, QUOTA_US, (unsigned long)ctx->skel->bss->nr_held);
+	SCX_GE(used, QUOTA_US * NR_PERIODS - tol);
+	SCX_LE(used, QUOTA_US * NR_PERIODS + tol);
+	SCX_ASSERT_ALIVE(ctx->skel, uei);
+	return SCX_TEST_PASS;
+}
+
+static enum scx_test_status run_full(void *arg)
+{
+	static const int policy[] = { SCHED_OTHER, SCHED_OTHER };
+
+	return run_rate(arg, false, policy, false);
+}
+
+static enum scx_test_status run_partial_ext(void *arg)
+{
+	static const int policy[] = { SCHED_EXT, SCHED_EXT };
+
+	return run_rate(arg, true, policy, false);
+}
+
+static enum scx_test_status run_partial_fair(void *arg)
+{
+	static const int policy[] = { SCHED_OTHER, SCHED_OTHER };
+
+	return run_rate(arg, true, policy, false);
+}
+
+static enum scx_test_status run_partial_mixed(void *arg)
+{
+	static const int policy[] = { SCHED_EXT, SCHED_OTHER };
+
+	return run_rate(arg, true, policy, false);
+}
+
+static enum scx_test_status run_switch(void *arg)
+{
+	static const int policy[] = { SCHED_OTHER, SCHED_EXT };
+
+	return run_rate(arg, true, policy, true);
+}
+
+/*
+ * With a quota of 1 ms per second and a runtime of 3 s, what cg runs while
+ * the scheduler loads, runs and unloads is what its runtime loses, up to a
+ * slice per CPU and the few refills.
+ */
+#define LU_QUOTA_US	1000LL
+#define LU_PERIOD_US	1000000LL
+
+static enum scx_test_status setup_load_unload(void **ctxp)
+{
+	return setup_ctx(ctxp, LU_QUOTA_US, LU_PERIOD_US, 4000000, 3000000);
+}
+
+static enum scx_test_status run_load_unload(void *arg)
+{
+	struct ctx *ctx = arg;
+	long long r0, u0, drawn, used, refills, tol;
+	u64 t0, t1;
+	int i;
+
+	bpf_map__set_autoattach(ctx->skel->maps.partial_ops, false);
+	bpf_map__set_autoattach(ctx->skel->maps.full_ops, false);
+	SCX_FAIL_IF(cgroup_runtime__load(ctx->skel), "Failed to load skel");
+
+	t0 = now_us();
+	r0 = read_runtime(ctx);
+	u0 = read_usage(ctx);
+	for (i = 0; i < NR_BURNERS; i++)
+		SCX_EQ(start_burner(ctx, i, SCHED_OTHER), 0);
+	usleep(100000);
+	if (attach_ops(ctx, false))
+		return SCX_TEST_FAIL;
+	usleep(200000);
+	detach(ctx);
+	usleep(100000);
+	stop_burners(ctx);
+	drawn = r0 - read_runtime(ctx);
+	used = read_usage(ctx) - u0;
+	t1 = now_us();
+
+	refills = LU_QUOTA_US * ((t1 - t0) / LU_PERIOD_US + 2);
+	tol = NR_BURNERS * ctx->slice_us;
+	printf("ran %lld us, runtime down %lld us\n", used, drawn);
+	SCX_GE(used, 300000);
+	SCX_GE(used, drawn - tol);
+	SCX_LE(used, drawn + refills + tol);
+	return SCX_TEST_PASS;
+}
+
+/*
+ * A scheduler that ignores scx_bpf_task_cpu_max_runtime() runs a task far
+ * past the quota. Once the task is back on the fair class, it runs its quota
+ * again, less at most a quota and a slice of debt.
+ */
+static enum scx_test_status run_clamp(void *arg)
+{
+	struct ctx *ctx = arg;
+	long long u0, ignored, used;
+
+	ctx->skel->bss->ignore_runtime = true;
+	if (load_ops(ctx, true))
+		return SCX_TEST_FAIL;
+	SCX_EQ(start_burner(ctx, 0, SCHED_EXT), 0);
+
+	u0 = read_usage(ctx);
+	usleep(5 * PERIOD_US);
+	ignored = read_usage(ctx) - u0;
+
+	SCX_EQ(set_policy(ctx->burner[0], SCHED_OTHER), 0);
+	u0 = read_usage(ctx);
+	usleep(5 * PERIOD_US);
+	used = read_usage(ctx) - u0;
+	stop_burners(ctx);
+
+	printf("ran %lld us ignoring the quota, then %lld us on the fair class\n",
+	       ignored, used);
+	SCX_GE(ignored, 4 * PERIOD_US);
+	SCX_GE(used, 4 * QUOTA_US - 2 * ctx->slice_us);
+	SCX_LE(used, 6 * QUOTA_US + ctx->slice_us);
+	SCX_ASSERT_ALIVE(ctx->skel, uei);
+	return SCX_TEST_PASS;
+}
+
+/*
+ * The scheduler stops a task only at a tick, so each period it overruns a
+ * quota of 2 ms by up to a tick. With a slice of 1 ms, the next tick's
+ * charge takes the CPU past the -slice floor. The debt must still be paid
+ * from the next periods, so over 100 periods cg runs its quota, with the
+ * second burner moving between CPUs 2 and 3 every 7 ms.
+ */
+#define DEBT_QUOTA_US	2000LL
+#define DEBT_PERIOD_US	10000LL
+#define DEBT_PERIODS	100
+
+static enum scx_test_status setup_debt(void **ctxp)
+{
+	enum scx_test_status ret;
+	struct ctx *ctx;
+
+	ret = setup_ctx(ctxp, DEBT_QUOTA_US, DEBT_PERIOD_US, 0, DEBT_QUOTA_US);
+	if (ret != SCX_TEST_PASS)
+		return ret;
+	ctx = *ctxp;
+	if (write_str("/proc/sys/kernel", "sched_cfs_bandwidth_slice_us", "1000"))
+		return SCX_TEST_SKIP;
+	ctx->saved_slice_us = ctx->slice_us;
+	ctx->slice_us = 1000;
+	return SCX_TEST_PASS;
+}
+
+static enum scx_test_status run_debt(void *arg)
+{
+	struct ctx *ctx = arg;
+	long long tol = (NR_BURNERS + 1) * ctx->slice_us + DEBT_QUOTA_US;
+	long long want = DEBT_QUOTA_US * DEBT_PERIODS;
+	long long used, u0;
+	bool moved = false;
+	cpu_set_t set;
+	u64 end;
+	int i;
+
+	if (libbpf_num_possible_cpus() < 4)
+		return SCX_TEST_SKIP;
+	if (load_ops(ctx, true))
+		return SCX_TEST_FAIL;
+	for (i = 0; i < NR_BURNERS; i++)
+		SCX_EQ(start_burner(ctx, i, SCHED_EXT), 0);
+
+	usleep(3 * DEBT_PERIOD_US);
+	u0 = read_usage(ctx);
+	end = now_us() + DEBT_PERIODS * DEBT_PERIOD_US;
+	while (now_us() < end) {
+		moved = !moved;
+		CPU_ZERO(&set);
+		CPU_SET(moved ? 3 : 2, &set);
+		SCX_EQ(sched_setaffinity(ctx->burner[1], sizeof(set), &set), 0);
+		usleep(7000);
+	}
+	used = read_usage(ctx) - u0;
+	stop_burners(ctx);
+
+	printf("ran %lld us in %d periods of quota %lld us\n", used,
+	       DEBT_PERIODS, DEBT_QUOTA_US);
+	SCX_GE(used, want - tol);
+	SCX_LE(used, want + tol);
+	SCX_ASSERT_ALIVE(ctx->skel, uei);
+	return SCX_TEST_PASS;
+}
+
+/*
+ * One thread alternates cpu.max between quotas of 100ms and 10ms, without a
+ * burst, while another writes a runtime of 90ms, which only the first
+ * allows. The scheduler must never get a runtime above the quota it was last
+ * given, and must end with the quota cpu.max has.
+ */
+#define INTERLEAVE_US	2000000ULL
+
+struct interleave {
+	struct ctx *ctx;
+	long nr_ok;
+	long nr_einval;
+	long nr_err;
+};
+
+static void *interleave_quota(void *arg)
+{
+	struct interleave *il = arg;
+	u64 end = now_us() + INTERLEAVE_US;
+	bool high = false;
+
+	while (now_us() < end) {
+		if (write_str(il->ctx->cg, "cpu.max", "%lld %lld",
+			      high ? 100000LL : 10000LL, 1000000LL))
+			il->nr_err++;
+		else
+			il->nr_ok++;
+		high = !high;
+	}
+	return NULL;
+}
+
+static void *interleave_runtime(void *arg)
+{
+	struct interleave *il = arg;
+	u64 end = now_us() + INTERLEAVE_US;
+
+	while (now_us() < end) {
+		int fd = cg_open(il->ctx->cg, "cpu.max.runtime", O_WRONLY);
+
+		if (fd < 0) {
+			il->nr_err++;
+			continue;
+		}
+		if (write(fd, "90000", 5) == 5)
+			il->nr_ok++;
+		else if (errno == EINVAL)
+			il->nr_einval++;
+		else
+			il->nr_err++;
+		close(fd);
+	}
+	return NULL;
+}
+
+static enum scx_test_status setup_interleave(void **ctxp)
+{
+	return setup_ctx(ctxp, 100000, 1000000, 0, 100000);
+}
+
+static enum scx_test_status run_interleave(void *arg)
+{
+	struct ctx *ctx = arg;
+	struct interleave quota = { .ctx = ctx }, runtime = { .ctx = ctx };
+	pthread_t tq, tr;
+	char buf[64];
+
+	if (load_ops(ctx, true))
+		return SCX_TEST_FAIL;
+	SCX_EQ(ctx->skel->bss->quota_us, 100000);
+
+	SCX_EQ(pthread_create(&tq, NULL, interleave_quota, &quota), 0);
+	SCX_EQ(pthread_create(&tr, NULL, interleave_runtime, &runtime), 0);
+	pthread_join(tq, NULL);
+	pthread_join(tr, NULL);
+
+	SCX_EQ(quota.nr_err, 0);
+	SCX_EQ(runtime.nr_err, 0);
+	SCX_GT(runtime.nr_ok, 0);
+	SCX_EQ(ctx->skel->bss->nr_bad_order, 0);
+	SCX_EQ(ctx->skel->bss->nr_set_bw, quota.nr_ok);
+	SCX_EQ(ctx->skel->bss->nr_set_runtime, runtime.nr_ok);
+
+	SCX_EQ(cg_read(ctx->cg, "cpu.max", buf, sizeof(buf)), 0);
+	SCX_EQ(ctx->skel->bss->quota_us, atoll(buf));
+	SCX_EQ(ctx->skel->bss->burst_us, 0);
+
+	printf("cpu.max writes %ld, cpu.max.runtime writes %ld (%ld EINVAL)\n",
+	       quota.nr_ok, runtime.nr_ok, runtime.nr_einval);
+	SCX_ASSERT_ALIVE(ctx->skel, uei);
+	return SCX_TEST_PASS;
+}
+
+#define RUNTIME_TEST(__name, __setup, __desc)				\
+	struct scx_test cgroup_runtime_##__name = {			\
+		.name = "cgroup_runtime_" #__name,			\
+		.description = __desc,					\
+		.setup = __setup,					\
+		.run = run_##__name,					\
+		.cleanup = cleanup,					\
+	}
+
+RUNTIME_TEST(full, setup_rate, "Without partial switch, the BPF scheduler's tasks run their quota");
+RUNTIME_TEST(partial_ext, setup_rate, "SCHED_EXT tasks of a cgroup run its quota");
+RUNTIME_TEST(partial_fair, setup_rate, "Fair tasks of a cgroup run its quota");
+RUNTIME_TEST(partial_mixed, setup_rate, "Fair and SCHED_EXT tasks of a cgroup share its quota");
+RUNTIME_TEST(switch, setup_rate, "A task switching class every 7 ms stays within the quota");
+RUNTIME_TEST(load_unload, setup_load_unload, "Load and unload neither gain nor lose runtime");
+RUNTIME_TEST(clamp, setup_rate, "A scheduler ignoring the quota leaves a bounded debt");
+RUNTIME_TEST(debt, setup_debt, "Debt past a quota is paid in the next periods");
+RUNTIME_TEST(interleave, setup_interleave, "cpu.max writes reach the scheduler in order");
+
+/* REGISTER_SCX_TEST() can be used once per file */
+__attribute__((constructor))
+static void register_cgroup_runtime_tests(void)
+{
+	scx_test_register(&cgroup_runtime_full);
+	scx_test_register(&cgroup_runtime_partial_ext);
+	scx_test_register(&cgroup_runtime_partial_fair);
+	scx_test_register(&cgroup_runtime_partial_mixed);
+	scx_test_register(&cgroup_runtime_switch);
+	scx_test_register(&cgroup_runtime_load_unload);
+	scx_test_register(&cgroup_runtime_clamp);
+	scx_test_register(&cgroup_runtime_debt);
+	scx_test_register(&cgroup_runtime_interleave);
+}
diff --git a/tools/testing/selftests/sched_ext/config b/tools/testing/selftests/sched_ext/config
index 8173f9170ffe8..495b140403a18 100644
--- a/tools/testing/selftests/sched_ext/config
+++ b/tools/testing/selftests/sched_ext/config
@@ -9,3 +9,4 @@ CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_INFO_BTF=y
 CONFIG_EXPERT=y
 CONFIG_SCHED_PROXY_EXEC=y
+CONFIG_CFS_BANDWIDTH=y
-- 
2.47.3




Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07

