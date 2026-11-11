Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.246.1.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794400219;
	b=Fs4VCdCP8nXTE1WpaAHHCtTdstExWiszTmDfoteKIod9dP7cQrAr9Oo8FW5+1eTd/cWW
	 tjvDTztsBYgLHiS1Qu4285HwFzwJvIXxONQqn/lyOabbZbpadA+ADu/peArAr7BhNnxH5
	 0JkigmQRnHPCbgb+1LByWTeJOTQ2+PG68xyzoUogiSgXiemybymZY6tRO5JAMqz9qgU8n
	 lqGpKupP+i75+2XIVIpZtCzPfERETlARaf+ctkyQXOvQAk37cPqc2UXGdX8AzYokGxXK6
	 SlNIZoAaxa1kwbVL2eGAWDXe4mx+JI6q5VMjQ/m2AbhcXzchObclyDlkM6Jm0h61POg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794400219;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=K1UYPdx/Xc6/KSiu38Qvc9yiHiydZx1UHBmxDQieWIw=;
	b=ib8a584yo3lEFcInBpxm2M3hi2kvB2BJNNW9EpHPknp8bLIo85BbZQC6PNRzBz/80aVp
	 UyinsSTAQ0+dDIlxm1ow/JJDN5VKnw3kRWLzbiKJOqEBipjTex3YunW601T2abjg0yVj5
	 M1rdTrx4XQGDIS7MhRnAitXjcbwSbyL0K5a8okPBtg2/IHbZCu1kjYWWXSto/RT2s4Qp1
	 4lNarrf1w6X/5xJlWdku1xrSoTEhLs4Q6GgmtwGOVwnocIfDsWgIRtNlG5HZaIXkwF9x6
	 J82Yy1BJkZOu+CWqzmOWJ6mV9ai0TS5nGu+6rEJwyxgWQtW4fMxMtlW0a6a0Gko7flw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=KkyyS1iQ;
	arc=none smtp.remote-ip=44.246.1.125
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA79606A339;
	Wed, 11 Nov 2026 12:30:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EA79606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=KkyyS1iQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794400218; x=1825936218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K1UYPdx/Xc6/KSiu38Qvc9yiHiydZx1UHBmxDQieWIw=;
  b=KkyyS1iQ+PHYZXCG7FgKJ8oMEjA6YKHKeFs+odS5T7PTaevuKBGI5OXB
   vaJOO3THHJSlvl2miJHGFDfguACRytwpi5jt4kCZEfazKZtJvCsCAGkf4
   newiTTkvswgGCysH1lGGHia42r56sDuX/iRV9d7vEdVSmFS7THw5O8ALB
   BpxWzeQZbD3de1abEM3wxcRG/WZ7G2HFcsTSWxNenS2WUIrTCSuSFuvFv
   gNFiJC3tqWssU1BwiWlrUIH/5PsRM/0Nr34R5bCCP90hEqk6+H/cj6SH2
   ziFZ5Z5Wa130D5hoCSExFSdG8YhEbzK8OzY/1bjYC018uYqFn0A8stZNS
   Q==;
X-CSE-ConnectionGUID: Qvh5YrYFSC6+wYpK8IsNtg==
X-CSE-MsgGUID: 5MaG2cDSROiEk7ZqWTPrvQ==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33718432"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 12:30:16 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:7924]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id 9abd0b3a-7d03-42fd-8905-5c08b17c542a; Wed, 11 Nov 2026 12:30:15 +0000 (UTC)
X-Farcaster-Flow-ID: 9abd0b3a-7d03-42fd-8905-5c08b17c542a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 12:30:15 +0000
Received: from dev-dsk-sieberf-metal-1a-7543e84d.eu-west-1.amazon.com
 (172.19.116.227) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 12:30:11 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>
CC: <tj@kernel.org>, <bsegall@google.com>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <mgorman@suse.de>, <vschneid@redhat.com>,
	<kprateek.nayak@amd.com>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<skhan@linuxfoundation.org>, <corbet@lwn.net>, <rdunlap@infradead.org>,
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nh-open-source@amazon.com>, <hborghor@amazon.de>, <fmubeen@amazon.de>,
	<dwmw@amazon.co.uk>, <sieberf@amazon.com>
Subject: [PATCH v3 1/2] sched/fair: expose cpu.max.runtime to set bandwidth runtime directly
Date: Wed, 11 Nov 2026 14:29:48 +0200
Message-ID: <afb5e8be5822b90e9263db1b63b1274cded8b872.1794398404.git.sieberf@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1794398404.git.sieberf@amazon.com>
References: <cover.1794303670.git.sieberf@amazon.com> <cover.1794398404.git.sieberf@amazon.com>
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

Add cpu.max.runtime, a cgroup v2 file that reads and sets the CFS
bandwidth runtime, cfs_b->runtime, in microseconds. Userspace can then
grant a cgroup runtime beyond its quota. Refills still add only the
quota, capped at quota + burst, so the excess is used up over time and
the group returns to its quota per period.

A write is rejected without a quota or above quota + burst, the most
the group can accumulate. A read is capped at quota + burst so it can
be written back; uncapped slack from __return_cfs_rq_runtime() can
exceed that until the next refill. Runtime the CPUs already took, at
most a slice each, is not included and a write leaves it in place.
Without a quota a read reports 0, and taking a group's quota away
drops the runtime it had, rather than keeping it for the next time
the group is given a quota.

A write distributes the new runtime to throttled cfs_rqs at once, as
the slack timer does, rather than waiting for the unsynchronized
period timer. It also shifts runtime_snap by the change, so cpu.stat
burst accounting neither counts the write nor hides what the group ran
since the last refill.

Also drop the burst <= quota limit and require only quota + burst <=
max_bw_runtime_us (about 203 days), the quota's own limit, so a group
can accumulate many periods of quota. This applies to cgroup v1
cpu.cfs_burst_us too, which shares tg_set_bandwidth().

The file exists with CONFIG_CFS_BANDWIDTH only.

Signed-off-by: Fernand Sieber <sieberf@amazon.com>
---
 Documentation/admin-guide/cgroup-v2.rst   |  23 +-
 Documentation/scheduler/sched-bwc.rst     |  13 +-
 kernel/sched/core.c                       |  44 ++-
 kernel/sched/fair.c                       |  65 ++++
 kernel/sched/sched.h                      |   2 +
 tools/testing/selftests/cgroup/config     |   1 +
 tools/testing/selftests/cgroup/test_cpu.c | 356 ++++++++++++++++++++++
 7 files changed, 495 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2e..eb802f8ba877f 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1231,12 +1231,33 @@ will be referred to. All time durations are in microseconds.
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "0".
 
-	The burst in the range [0, $MAX].
+	The burst. The cgroup can accumulate the runtime it does not
+	use, up to $MAX + cpu.max.burst. The burst may exceed $MAX, as
+	long as $MAX + cpu.max.burst is at most 2^44 - 1 (about 203
+	days).
 
 	This file affects only processes under the fair-class scheduler and a BPF
 	scheduler with the ``cgroup_set_bandwidth`` callback depending on what
 	the callback actually does.
 
+  cpu.max.runtime
+	A read-write single value file which exists on non-root
+	cgroups if the kernel is built with CONFIG_CFS_BANDWIDTH.
+
+	The runtime the cgroup has accumulated and not used yet, in
+	microseconds. Each period refills it by $MAX, up to $MAX +
+	cpu.max.burst, and a read returns at most $MAX + cpu.max.burst.
+	A write sets it, up to $MAX + cpu.max.burst, and lets a cgroup
+	that ran out of runtime run again at once. A write fails with
+	EINVAL while $MAX is "max", a read then returns 0, and setting
+	$MAX to "max" drops the runtime the cgroup had.
+
+	The runtime does not include what the cgroup's CPUs already took
+	from it, at most a slice each (sched_cfs_bandwidth_slice_us).
+	A write leaves that with the CPUs.
+
+	This file affects only processes under the fair-class scheduler.
+
   cpu.pressure
 	A read-write nested-keyed file.
 
diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
index e881a945c1888..c22b3c8c14e29 100644
--- a/Documentation/scheduler/sched-bwc.rst
+++ b/Documentation/scheduler/sched-bwc.rst
@@ -90,8 +90,8 @@ bandwidth restriction in place, such a group is described as an unconstrained
 bandwidth group. This represents the traditional work-conserving behavior for
 CFS.
 
-Writing any (valid) positive value(s) no smaller than cpu.cfs_burst_us will
-enact the specified bandwidth limit. The minimum quota allowed for the quota or
+Writing any (valid) positive value(s) will enact the specified bandwidth
+limit. The minimum quota allowed for the quota or
 period is 1ms. There is also an upper bound on the period length of 1s.
 Additional restrictions exist when bandwidth limits are used in a hierarchical
 fashion, these are explained in more detail below.
@@ -101,9 +101,10 @@ and return the group to an unconstrained state once more.
 
 A value of 0 for cpu.cfs_burst_us indicates that the group can not accumulate
 any unused bandwidth. It makes the traditional bandwidth control behavior for
-CFS unchanged. Writing any (valid) positive value(s) no larger than
-cpu.cfs_quota_us into cpu.cfs_burst_us will enact the cap on unused bandwidth
-accumulation.
+CFS unchanged. Writing any (valid) positive value(s) into cpu.cfs_burst_us
+will enact the cap on unused bandwidth accumulation: the group can accumulate
+up to cpu.cfs_quota_us + cpu.cfs_burst_us. The burst may be larger than the
+quota, as long as their sum is at most 2^44 - 1 microseconds (about 203 days).
 
 Any updates to a group's bandwidth specification will result in it becoming
 unthrottled if it is in a constrained state.
@@ -243,4 +244,4 @@ Examples
 	# echo 50000 > cpu.cfs_period_us /* period = 50ms */
 	# echo 10000 > cpu.cfs_burst_us /* burst = 10ms */
 
-   Larger buffer setting (no larger than quota) allows greater burst capacity.
+   Larger buffer setting allows greater burst capacity.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 175b52a7ea793..e068d81e1fc5f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9860,6 +9860,16 @@ static int tg_set_cfs_bandwidth(struct task_group *tg,
 		cfs_b->quota = quota;
 		cfs_b->burst = burst;
 
+		/*
+		 * A group without a quota accumulates no runtime, so drop what
+		 * it had rather than report it and add to it once it has a
+		 * quota again.
+		 */
+		if (!runtime_enabled) {
+			cfs_b->runtime = 0;
+			cfs_b->runtime_snap = 0;
+		}
+
 		__refill_cfs_bandwidth_runtime(cfs_b);
 
 		/*
@@ -10131,8 +10141,7 @@ static int tg_set_bandwidth(struct task_group *tg,
 	if (quota_us != RUNTIME_INF && quota_us > max_bw_runtime_us)
 		return -EINVAL;
 
-	if (quota_us != RUNTIME_INF && (burst_us > quota_us ||
-					burst_us + quota_us > max_bw_runtime_us))
+	if (quota_us != RUNTIME_INF && burst_us > max_bw_runtime_us - quota_us)
 		return -EINVAL;
 
 #ifdef CONFIG_CFS_BANDWIDTH
@@ -10193,6 +10202,29 @@ static int cpu_burst_write_u64(struct cgroup_subsys_state *css,
 	tg_bandwidth(tg, &period_us, &quota_us, NULL);
 	return tg_set_bandwidth(tg, period_us, quota_us, burst_us);
 }
+
+#ifdef CONFIG_CFS_BANDWIDTH
+static int cpu_runtime_write_u64(struct cgroup_subsys_state *css,
+				 struct cftype *cftype, u64 runtime_us)
+{
+	struct task_group *tg = css_tg(css);
+
+	if (runtime_us > max_bw_runtime_us)
+		return -EINVAL;
+
+	return cfs_bandwidth_set_runtime(&tg->cfs_bandwidth,
+					 runtime_us * NSEC_PER_USEC);
+}
+
+static u64 cpu_runtime_read_u64(struct cgroup_subsys_state *css,
+				struct cftype *cftype)
+{
+	struct task_group *tg = css_tg(css);
+
+	return div_u64(cfs_bandwidth_get_runtime(&tg->cfs_bandwidth),
+		       NSEC_PER_USEC);
+}
+#endif /* CONFIG_CFS_BANDWIDTH */
 #endif /* CONFIG_GROUP_SCHED_BANDWIDTH */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -10544,7 +10576,15 @@ static struct cftype cpu_files[] = {
 		.read_u64 = cpu_burst_read_u64,
 		.write_u64 = cpu_burst_write_u64,
 	},
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		.name = "max.runtime",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = cpu_runtime_read_u64,
+		.write_u64 = cpu_runtime_write_u64,
+	},
 #endif /* CONFIG_CFS_BANDWIDTH */
+#endif /* CONFIG_GROUP_SCHED_BANDWIDTH */
 #ifdef CONFIG_UCLAMP_TASK_GROUP
 	{
 		.name = "uclamp.min",
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d4cc0caee6265..8fee8d27faa5a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7413,6 +7413,12 @@ static void unthrottle_cfs_rq_async(struct cfs_rq *cfs_rq)
 	__unthrottle_cfs_rq_async(cfs_rq);
 }
 
+/*
+ * Hand the runtime of @cfs_b to its throttled cfs_rqs. The caller must not
+ * migrate, as the cfs_rqs of this CPU are unthrottled from it here. The period
+ * and slack timers run from a timer callback, and cfs_bandwidth_set_runtime()
+ * disables interrupts.
+ */
 static bool distribute_cfs_runtime(struct cfs_bandwidth *cfs_b)
 {
 	bool throttled = false, unthrottle_local = false;
@@ -7811,6 +7817,65 @@ static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	INIT_LIST_HEAD(&cfs_rq->throttled_limbo_list);
 }
 
+/*
+ * The runtime of @cfs_b, as cpu.max.runtime reads it.
+ *
+ * A group without a quota has no runtime: nothing refills it and a write is
+ * rejected, so report 0 as for a group that never had one.
+ *
+ * __return_cfs_rq_runtime() returns slack without capping it, so the runtime
+ * can exceed quota + burst until the next refill caps it. Report it capped,
+ * so that a value read can always be written back.
+ */
+u64 cfs_bandwidth_get_runtime(struct cfs_bandwidth *cfs_b)
+{
+	guard(raw_spinlock_irq)(&cfs_b->lock);
+
+	if (cfs_b->quota == RUNTIME_INF)
+		return 0;
+
+	return min(cfs_b->runtime, cfs_b->quota + cfs_b->burst);
+}
+
+/*
+ * Set the runtime of @cfs_b, as a cpu.max.runtime write does, and hand it to
+ * the throttled cfs_rqs at once rather than at the next period.
+ */
+int cfs_bandwidth_set_runtime(struct cfs_bandwidth *cfs_b, u64 runtime)
+{
+	bool throttled;
+	s64 snap;
+
+	guard(irq)();
+
+	scoped_guard (raw_spinlock, &cfs_b->lock) {
+		if (cfs_b->quota == RUNTIME_INF ||
+		    runtime > cfs_b->quota + cfs_b->burst)
+			return -EINVAL;
+
+		/*
+		 * The next refill counts runtime_snap - runtime as burst usage.
+		 * Move runtime_snap by what the write adds or takes away, so
+		 * that the write itself is not counted as burst usage but what
+		 * the group ran since the last refill still is.
+		 */
+		snap = cfs_b->runtime_snap + runtime - cfs_b->runtime;
+		cfs_b->runtime_snap = max(snap, 0);
+		cfs_b->runtime = runtime;
+
+		throttled = !list_empty(&cfs_b->throttled_cfs_rq) && runtime;
+	}
+
+	/*
+	 * distribute_cfs_runtime() takes the rq locks, so it runs without
+	 * cfs_b->lock and with interrupts disabled, as from the slack timer.
+	 */
+	if (throttled)
+		distribute_cfs_runtime(cfs_b);
+
+	return 0;
+}
+
 void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
 	lockdep_assert_held(&cfs_b->lock);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a4df59c9c9b60..1f60c84e0dc38 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -578,6 +578,8 @@ extern void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b, struct cfs_bandwidth
 
 extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
 extern void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
+u64 cfs_bandwidth_get_runtime(struct cfs_bandwidth *cfs_b);
+int cfs_bandwidth_set_runtime(struct cfs_bandwidth *cfs_b, u64 runtime);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 extern bool cfs_task_bw_constrained(struct task_struct *p);
 
diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3b..aaf5872c71410 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -1,3 +1,4 @@
+CONFIG_CFS_BANDWIDTH=y
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_CGROUP_FREEZER=y
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 3456e3e988c68..b5a9fbcf722f6 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -809,6 +809,357 @@ static int test_cpucg_max_nested(const char *root)
 	return ret;
 }
 
+/* Wait until the period timer of @cgroup starts a new period. */
+static int wait_period_start(const char *cgroup)
+{
+	long nr_periods = cg_read_key_long(cgroup, "cpu.stat", "nr_periods");
+	int i;
+
+	for (i = 0; i < 3000; i++) {
+		usleep(1000);
+		if (cg_read_key_long(cgroup, "cpu.stat", "nr_periods") != nr_periods)
+			return 0;
+	}
+	return -1;
+}
+
+static long long monotonic_ns(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	return ts.tv_sec * 1000000000LL + ts.tv_nsec;
+}
+
+/* For (long)arg seconds, run for 1ms and then sleep for 10ms. */
+static int run_and_sleep(const char *cgroup, void *arg)
+{
+	long long end = monotonic_ns() + (long)arg * 1000000000LL;
+	long long start;
+
+	while ((start = monotonic_ns()) < end) {
+		while (monotonic_ns() - start < 1000000)
+			;
+		usleep(10000);
+	}
+	return 0;
+}
+
+static int test_cpucg_max_runtime(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long quota_usec = 1000;		/* 1ms (minimum) */
+	long period_usec = 100000;	/* 100ms */
+	long burst_usec = 5000000;	/* 5s, so cap = 5001ms */
+	long runtime_usec = 2500000;	/* 2500ms, half of the 5s run */
+	long duration_sec = 5;
+	/* The injected runtime plus the quota refilled each period of the run */
+	long expected_usec = runtime_usec +
+			     duration_sec * USEC_PER_SEC / period_usec * quota_usec;
+	long usage_usec;
+	char *cpucg;
+	char buf[64];
+	int pid;
+
+	cpucg = cg_name(root, "cpucg_runtime_test");
+	if (!cpucg)
+		goto cleanup;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	/* Without a quota there is no runtime to set, and none to read. */
+	if (!cg_write_numeric(cpucg, "cpu.max.runtime", runtime_usec))
+		goto cleanup;
+	if (cg_read_long(cpucg, "cpu.max.runtime") != 0)
+		goto cleanup;
+
+	snprintf(buf, sizeof(buf), "%ld %ld", quota_usec, period_usec);
+	if (cg_write(cpucg, "cpu.max", buf))
+		goto cleanup;
+	if (cg_write_numeric(cpucg, "cpu.max.burst", burst_usec))
+		goto cleanup;
+
+	/* Start burner, let it settle, then inject credits */
+	struct cpu_hog_func_param param = {
+		.nprocs = 1,
+		.ts = { .tv_sec = duration_sec, .tv_nsec = 0 },
+		.clock_type = CPU_HOG_CLOCK_WALL,
+	};
+	pid = cg_run_nowait(cpucg, hog_cpus_timed, (void *)&param);
+	if (pid < 0)
+		goto cleanup;
+
+	usleep(100000);
+	if (cg_write_numeric(cpucg, "cpu.max.runtime", runtime_usec)) {
+		kill(pid, SIGKILL);
+		waitpid(pid, NULL, 0);
+		goto cleanup;
+	}
+
+	waitpid(pid, NULL, 0);
+
+	usage_usec = cg_read_key_long(cpucg, "cpu.stat", "usage_usec");
+	if (usage_usec <= 0)
+		goto cleanup;
+
+	/* At least the injected runtime, at most 5% above the expected usage. */
+	if (usage_usec < runtime_usec ||
+	    usage_usec > expected_usec + expected_usec / 20)
+		goto cleanup;
+
+	/* Taking the quota away drops the runtime rather than storing it. */
+	if (cg_write(cpucg, "cpu.max", "max"))
+		goto cleanup;
+	if (cg_read_long(cpucg, "cpu.max.runtime") != 0)
+		goto cleanup;
+	if (cg_write(cpucg, "cpu.max", buf))
+		goto cleanup;
+	if (cg_read_long(cpucg, "cpu.max.runtime") > quota_usec)
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_destroy(cpucg);
+	free(cpucg);
+	return ret;
+}
+
+/*
+ * A cpu.max.runtime write is not burst usage: writing a runtime below the
+ * current one leaves cpu.stat's nr_bursts and burst_usec where they were.
+ */
+static int test_cpucg_max_runtime_burst_stats(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long nr_bursts, burst_usec;
+	char *cpucg;
+
+	cpucg = cg_name(root, "cpucg_runtime_burst_stats_test");
+	if (!cpucg)
+		goto cleanup;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	/* A long period, so the write lands before the timer's first refill. */
+	if (cg_write(cpucg, "cpu.max", "10000 1000000"))
+		goto cleanup;
+	if (cg_write_numeric(cpucg, "cpu.max.burst", 190000))
+		goto cleanup;
+	if (cg_write_numeric(cpucg, "cpu.max.runtime", 0))
+		goto cleanup;
+
+	/* The idle group refills for a few periods. */
+	sleep(3);
+	nr_bursts = cg_read_key_long(cpucg, "cpu.stat", "nr_bursts");
+	burst_usec = cg_read_key_long(cpucg, "cpu.stat", "burst_usec");
+	if (nr_bursts != 0 || burst_usec != 0)
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_destroy(cpucg);
+	free(cpucg);
+	return ret;
+}
+
+/*
+ * A cpu.max.runtime write hands the runtime to a throttled group at once,
+ * rather than at the next period: with a 1s period, the group runs again
+ * within 100ms of the write, before the next period starts.
+ */
+static int test_cpucg_max_runtime_unthrottle(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long usage_before, usage_after, nr_periods;
+	char *cpucg;
+	int pid;
+
+	cpucg = cg_name(root, "cpucg_runtime_unthrottle_test");
+	if (!cpucg)
+		goto cleanup;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	/* 1ms per 1s period, with room for a runtime of up to 1s. */
+	if (cg_write(cpucg, "cpu.max", "1000 1000000"))
+		goto cleanup;
+	if (cg_write_numeric(cpucg, "cpu.max.burst", 999000))
+		goto cleanup;
+
+	struct cpu_hog_func_param param = {
+		.nprocs = 1,
+		.ts = { .tv_sec = 2, .tv_nsec = 0 },
+		.clock_type = CPU_HOG_CLOCK_WALL,
+	};
+	pid = cg_run_nowait(cpucg, hog_cpus_timed, (void *)&param);
+	if (pid < 0)
+		goto cleanup;
+
+	/*
+	 * The period timer's phase is random: start right after a boundary,
+	 * so that the next one is some 900ms away. The hog uses up its runtime
+	 * and is throttled for the period.
+	 */
+	if (wait_period_start(cpucg))
+		goto cleanup_hog;
+	nr_periods = cg_read_key_long(cpucg, "cpu.stat", "nr_periods");
+	usleep(50000);
+	usage_before = cg_read_key_long(cpucg, "cpu.stat", "usage_usec");
+	if (usage_before < 0 || usage_before > 20000)
+		goto cleanup_hog;
+
+	if (cg_write_numeric(cpucg, "cpu.max.runtime", 500000))
+		goto cleanup_hog;
+
+	/* No period started meanwhile: only the write lets the hog run. */
+	usleep(100000);
+	usage_after = cg_read_key_long(cpucg, "cpu.stat", "usage_usec");
+	if (cg_read_key_long(cpucg, "cpu.stat", "nr_periods") != nr_periods)
+		goto cleanup_hog;
+	if (usage_after - usage_before < 50000)
+		goto cleanup_hog;
+
+	ret = KSFT_PASS;
+
+cleanup_hog:
+	kill(pid, SIGKILL);
+	waitpid(pid, NULL, 0);
+cleanup:
+	cg_destroy(cpucg);
+	free(cpucg);
+	return ret;
+}
+
+/*
+ * What a group ran beyond its quota before a cpu.max.runtime write is still
+ * burst usage: a write of the runtime the group has left does not hide it.
+ */
+static int test_cpucg_max_runtime_burst_kept(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long burst_before, burst_after, runtime_usec;
+	char *cpucg;
+	int pid;
+
+	cpucg = cg_name(root, "cpucg_runtime_burst_kept_test");
+	if (!cpucg)
+		goto cleanup;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	/* 10ms per 1s period, and a runtime of 1s to run on. */
+	if (cg_write(cpucg, "cpu.max", "10000 1000000"))
+		goto cleanup;
+	if (cg_write_numeric(cpucg, "cpu.max.burst", 990000))
+		goto cleanup;
+
+	struct cpu_hog_func_param param = {
+		.nprocs = 1,
+		.ts = { .tv_sec = 10, .tv_nsec = 0 },
+		.clock_type = CPU_HOG_CLOCK_WALL,
+	};
+	pid = cg_run_nowait(cpucg, hog_cpus_timed, (void *)&param);
+	if (pid < 0)
+		goto cleanup;
+
+	/*
+	 * The period timer's phase is random, so grant the runtime only once
+	 * a period has started: the hog spends it all in that one period.
+	 */
+	if (wait_period_start(cpucg)) {
+		kill(pid, SIGKILL);
+		waitpid(pid, NULL, 0);
+		goto cleanup;
+	}
+	if (cg_write_numeric(cpucg, "cpu.max.runtime", 1000000)) {
+		kill(pid, SIGKILL);
+		waitpid(pid, NULL, 0);
+		goto cleanup;
+	}
+	burst_before = cg_read_key_long(cpucg, "cpu.stat", "burst_usec");
+
+	/* Run some 300ms, all in one period, and stop. */
+	usleep(300000);
+	kill(pid, SIGKILL);
+	waitpid(pid, NULL, 0);
+
+	/* Write back what is left: the next refill counts the 300ms run. */
+	runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+	if (cg_write_numeric(cpucg, "cpu.max.runtime", runtime_usec))
+		goto cleanup;
+	sleep(1);
+	burst_after = cg_read_key_long(cpucg, "cpu.stat", "burst_usec");
+	if (burst_before < 0 || burst_after - burst_before < 250000)
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_destroy(cpucg);
+	free(cpucg);
+	return ret;
+}
+
+/*
+ * cpu.max.runtime reads at most quota + burst, so that a value read can be
+ * written back. A cfs_rq that dequeues returns its unused runtime, which can
+ * take the runtime above quota + burst until the next refill caps it: run
+ * tasks that keep doing that, and read and write back the runtime meanwhile.
+ */
+static int test_cpucg_max_runtime_read_capped(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long cap_usec = 100000;		/* quota 100ms, no burst */
+	long long end;
+	long runtime_usec;
+	char *cpucg;
+	int pids[2];
+	int i, n = 0;
+
+	cpucg = cg_name(root, "cpucg_runtime_read_capped_test");
+	if (!cpucg)
+		goto cleanup;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	if (cg_write(cpucg, "cpu.max", "100000 100000"))
+		goto cleanup;
+
+	for (n = 0; n < 2; n++) {
+		pids[n] = cg_run_nowait(cpucg, run_and_sleep, (void *)4L);
+		if (pids[n] < 0)
+			goto cleanup_tasks;
+	}
+
+	end = monotonic_ns() + 3000000000LL;
+	while (monotonic_ns() < end) {
+		runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+		if (runtime_usec < 0 || runtime_usec > cap_usec)
+			goto cleanup_tasks;
+		if (cg_write_numeric(cpucg, "cpu.max.runtime", runtime_usec))
+			goto cleanup_tasks;
+	}
+
+	ret = KSFT_PASS;
+
+cleanup_tasks:
+	for (i = 0; i < n; i++) {
+		kill(pids[i], SIGKILL);
+		waitpid(pids[i], NULL, 0);
+	}
+cleanup:
+	cg_destroy(cpucg);
+	free(cpucg);
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct cpucg_test {
 	int (*fn)(const char *root);
@@ -823,6 +1174,11 @@ struct cpucg_test {
 	T(test_cpucg_nested_weight_underprovisioned),
 	T(test_cpucg_max),
 	T(test_cpucg_max_nested),
+	T(test_cpucg_max_runtime),
+	T(test_cpucg_max_runtime_burst_stats),
+	T(test_cpucg_max_runtime_unthrottle),
+	T(test_cpucg_max_runtime_burst_kept),
+	T(test_cpucg_max_runtime_read_capped),
 };
 #undef T
 
-- 
2.47.3




Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07

