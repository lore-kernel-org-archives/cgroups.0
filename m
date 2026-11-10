Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.246.77.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794308982;
	b=QPRrienX0AT1r1eFZtIYsvhtC4EVqyblj60pZXku1zCQFV48mAI1oAuVPcje9Vj96TAp
	 lUuQF5gotqA/3N45M6kDYnQQrstFPCAJpeubkj4oDeSv2XdDDxXrS6ipVnon4urRFsByS
	 CsmRwCDQ8ZKGy0Agf7SgUq4JztSI7iiW1pG29Ibo5dHknt+e+bmAMSrv7wko5woLfW10f
	 CQAtAB5+e3X1mv2LY48gV6ei9Rs5zGlk+0rVedmYLIBtJRKV9hDS9RUg7+ZdTbdrAlQBr
	 15NG2O+dSI3ck+KTjzzbRslQOSxarVjNoKc8Pea0zwz82IhSm3JvCr7SEb6wG+YbvyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794308982;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=srT10sgvyfnqt4jFr2uRXYbuq0AbDIOaXtTGsqLNQn4=;
	b=DD4iD9o9OsWagXmvL9TVQffgKd9TOIGkK1/n9NRHubAaPT3a+Dzfut+GwKEmUv/R2ovu
	 6DWOPZqjKkhzEZAEovg0o8gpUoVwbbsdNK4Ia+ptXrdFRZwbMOOwZ/vrHA1w0uTOYIBo1
	 p3m8C+AKbVLNS8NLKMLWQAs59xBsW+tsOGB7beR5Ho4sb0aO45bPTcACZgCKhHr49l+K/
	 B/fPVkiSdMjXifa8ORxhJ3A7keegAJ0sw5WnUJ40tGLCpFivhaHz3i7SQJoXx1NwxDH1B
	 hp8covcPAyqaQKv8LAVkbONF+fVMo4TC+dTgFCAehhYC4pzrRVVWoUdyfFcBAaJ89dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ZnCIHwwp;
	arc=none smtp.remote-ip=44.246.77.92
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B543606A31C;
	Tue, 10 Nov 2026 11:09:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B543606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ZnCIHwwp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794308982; x=1825844982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=srT10sgvyfnqt4jFr2uRXYbuq0AbDIOaXtTGsqLNQn4=;
  b=ZnCIHwwp7PdMEx03JhbBpdhxp4XO08QOrzWviiLWDP4qXFuujinKr4yw
   3TCpr4YypLDn0Y1ErUqwff7QXRVERAs6GLHcZSGof7dSBUpaFkeo43LT5
   4ZosfKPmUVmZNDVGGfnzbdd7jgafy5nbKQa7TorSsic727lFL5Gzgsx0J
   2OdaY7N3aPiO7e52WnS/8pBZvRu0GGkrzZ8/A1Z/0+Ew76+QF+9EdJOFx
   LPW3NiLDFtB0lxKNz/157hWIXJnCTQ19f+6lCZChlleFETENHqA81ndyQ
   4HBLFpDnXhEi0ockUBIQCtJMmbe7v1EAeC2m4tHypIP3GFX/qbNWZCsHm
   A==;
X-CSE-ConnectionGUID: ++0M3ukhS5i+xXwbs277QQ==
X-CSE-MsgGUID: 6nEbJO6MRuGAB/dBUdyUjw==
X-IronPort-AV: E=Sophos;i="6.27,205,1787011200"; 
   d="scan'208";a="33605056"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 11:09:39 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:3418]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.61:2525] with esmtp (Farcaster)
 id c82859f7-4f74-4ffe-977b-ecbe10b15324; Tue, 10 Nov 2026 11:09:39 +0000 (UTC)
X-Farcaster-Flow-ID: c82859f7-4f74-4ffe-977b-ecbe10b15324
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 11:09:39 +0000
Received: from dev-dsk-sieberf-metal-1a-7543e84d.eu-west-1.amazon.com
 (172.19.116.227) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 10 Nov 2026
 11:09:34 +0000
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
Subject: [PATCH v2 2/4] sched/fair: refill bandwidth for the periods the timer slept through
Date: Tue, 10 Nov 2026 13:08:49 +0200
Message-ID: <681751a52093faada8da25d8dbccc59444c3d251.1794303670.git.sieberf@amazon.com>
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
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

cpu.max.burst lets a group accumulate unused quota up to quota + burst.
But the period timer stops after a period in which the group took no
runtime, and start_cfs_bandwidth() restarts it with hrtimer_forward_now()
and discards the periods that passed. A group that sits idle stops
accumulating, and one that wakes after idling for a long time has only
what it had when the timer stopped.

Count the missed periods instead. While the timer is stopped, its expiry
is the first period boundary it missed, so the overrun at restart is the
number of refills owed. Add quota for each, capped at quota + burst as
__refill_cfs_bandwidth_runtime() caps it.

Without a burst the cap is quota. The timer stops right after a refill
that nothing drew from, so the runtime is at quota then, and groups
without a burst see no change. Groups with a burst do see a change. A
group that has been idle now has up to quota + burst when it runs again.
The documentation of cpu.max.burst, cpu.max.runtime and cpu.cfs_burst_us
says so.

A change of the bandwidth (cpu.max, cpu.max.burst) applies from that
moment, and the group keeps what it earned before it. The periods owed
are first refilled at the bandwidth they were earned under, capped at
its quota + burst, and then the new bandwidth applies, with its own cap.
A group that had no quota earned nothing, so one given a quota after a
long time unconstrained does not start full. A cpu.max.runtime write
also refills the periods owed first, so that it replaces them, and only
the periods after the write refill.

cpu.max.runtime reports the runtime the group has now, owed refills
included, without starting the timer.

The idle periods are not added to cpu.stat's nr_periods, which counts the
periods in which the timer ran. A timer that runs late by several
periods still refills only once, unlike a stopped one; this patch leaves
that as it is.

Signed-off-by: Fernand Sieber <sieberf@amazon.com>
---
 Documentation/admin-guide/cgroup-v2.rst   |  15 +-
 Documentation/scheduler/sched-bwc.rst     |   5 +-
 kernel/sched/core.c                       |   6 +
 kernel/sched/fair.c                       |  79 +++++++++-
 kernel/sched/sched.h                      |   1 +
 tools/testing/selftests/cgroup/test_cpu.c | 183 ++++++++++++++++++++++
 6 files changed, 278 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index c5a02057f0242..2c220e5998639 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1232,9 +1232,9 @@ will be referred to. All time durations are in microseconds.
 	cgroups.  The default is "0".
 
 	The burst. The cgroup can accumulate the runtime it does not
-	use, up to $MAX + cpu.max.burst. The burst may exceed $MAX, as
-	long as $MAX + cpu.max.burst is at most 2^44 - 1 (about 203
-	days).
+	use, up to $MAX + cpu.max.burst, also in the periods in which it
+	does not run. The burst may exceed $MAX, as long as $MAX +
+	cpu.max.burst is at most 2^44 - 1 (about 203 days).
 
 	This file affects only processes under the fair-class scheduler and a BPF
 	scheduler with the ``cgroup_set_bandwidth`` callback depending on what
@@ -1246,10 +1246,11 @@ will be referred to. All time durations are in microseconds.
 
 	The runtime the cgroup has accumulated and not used yet, in
 	microseconds. Each period refills it by $MAX, up to $MAX +
-	cpu.max.burst, and a read returns at most $MAX + cpu.max.burst.
-	A write sets it, up to $MAX + cpu.max.burst, and lets a cgroup
-	that ran out of runtime run again at once. A write fails with
-	EINVAL while $MAX is "max".
+	cpu.max.burst, whether the cgroup runs in it or not. A read
+	returns at most $MAX + cpu.max.burst. A write sets it, up to
+	$MAX + cpu.max.burst, and lets a cgroup that ran out of runtime
+	run again at once. A write fails with EINVAL while $MAX is
+	"max".
 
 	The runtime does not include what the cgroup's CPUs already took
 	from it, at most a slice each (sched_cfs_bandwidth_slice_us).
diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
index c22b3c8c14e29..ccf7434ca73f0 100644
--- a/Documentation/scheduler/sched-bwc.rst
+++ b/Documentation/scheduler/sched-bwc.rst
@@ -103,8 +103,9 @@ A value of 0 for cpu.cfs_burst_us indicates that the group can not accumulate
 any unused bandwidth. It makes the traditional bandwidth control behavior for
 CFS unchanged. Writing any (valid) positive value(s) into cpu.cfs_burst_us
 will enact the cap on unused bandwidth accumulation: the group can accumulate
-up to cpu.cfs_quota_us + cpu.cfs_burst_us. The burst may be larger than the
-quota, as long as their sum is at most 2^44 - 1 microseconds (about 203 days).
+up to cpu.cfs_quota_us + cpu.cfs_burst_us, also over periods in which it does
+not run. The burst may be larger than the quota, as long as their sum is at
+most 2^44 - 1 microseconds (about 203 days).
 
 Any updates to a group's bandwidth specification will result in it becoming
 unthrottled if it is in a constrained state.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 76fcd70ff207a..75a5f5d1b8f54 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9856,6 +9856,12 @@ static int tg_set_cfs_bandwidth(struct task_group *tg,
 		cfs_bandwidth_usage_inc();
 
 	scoped_guard (raw_spinlock_irq, &cfs_b->lock) {
+		/*
+		 * The new bandwidth applies from now on. The group keeps what
+		 * it earned while idle under the old one.
+		 */
+		cfs_bandwidth_refill_idle_periods(cfs_b);
+
 		cfs_b->period = ns_to_ktime(period);
 		cfs_b->quota = quota;
 		cfs_b->burst = burst;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 58e948ed1792f..bc068b3fa4ed1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7813,6 +7813,75 @@ static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	INIT_LIST_HEAD(&cfs_rq->throttled_limbo_list);
 }
 
+/*
+ * Runtime after @periods refills of quota, capped at quota + burst as each
+ * refill in __refill_cfs_bandwidth_runtime() caps it. The runtime can be above
+ * the cap (__return_cfs_rq_runtime() does not cap it), and a refill then cuts
+ * it to the cap.
+ */
+static u64 cfs_bandwidth_refilled(struct cfs_bandwidth *cfs_b, u64 periods)
+{
+	u64 cap = cfs_b->quota + cfs_b->burst;
+	u64 runtime = cfs_b->runtime;
+
+	if (!periods || cfs_b->quota == RUNTIME_INF)
+		return runtime;
+	if (runtime >= cap ||
+	    periods >= div64_u64(cap - runtime, cfs_b->quota) + 1)
+		return cap;
+	return runtime + periods * cfs_b->quota;
+}
+
+/*
+ * The period timer stops after a period in which the group took no runtime
+ * (do_sched_cfs_period_timer()), and start_cfs_bandwidth() restarts it on
+ * the next demand. The periods it slept through refill quota too: unused
+ * quota accumulates up to quota + burst whether or not the group ran. While
+ * the timer is stopped its expiry is the first period boundary it missed,
+ * so the boundaries passed since then are the refills still owed.
+ *
+ * Without burst the cap is quota. The timer stops right after a refill that
+ * nothing drew from, so the runtime is at quota then, and this changes nothing
+ * for groups without a burst.
+ *
+ * This is the overrun that hrtimer_forward_now() returns, without moving the
+ * expiry: one for the expiry itself, plus one for each full period since.
+ */
+static u64 cfs_bandwidth_idle_periods(struct cfs_bandwidth *cfs_b)
+{
+	ktime_t now = ktime_get();
+	s64 delta;
+
+	if (cfs_b->period_active)
+		return 0;
+
+	delta = ktime_to_ns(ktime_sub(now, hrtimer_get_expires(&cfs_b->period_timer)));
+	if (delta < 0)
+		return 0;
+	return div64_u64(delta, ktime_to_ns(cfs_b->period)) + 1;
+}
+
+/*
+ * Refill the periods a stopped timer slept through, at the bandwidth they
+ * were earned under, and move its expiry past them so that they are not
+ * counted again. A change of the bandwidth or a cpu.max.runtime write calls
+ * this first, so that the change applies from then on and the group keeps
+ * what it earned before. A group without a quota earned nothing.
+ */
+void cfs_bandwidth_refill_idle_periods(struct cfs_bandwidth *cfs_b)
+{
+	u64 idle_periods;
+
+	lockdep_assert_held(&cfs_b->lock);
+
+	if (cfs_b->period_active)
+		return;
+
+	idle_periods = hrtimer_forward_now(&cfs_b->period_timer, cfs_b->period);
+	cfs_b->runtime = cfs_bandwidth_refilled(cfs_b, idle_periods);
+	cfs_b->runtime_snap = cfs_b->runtime;
+}
+
 /*
  * The runtime of @cfs_b, as cpu.max.runtime reads it.
  *
@@ -7826,7 +7895,7 @@ u64 cfs_bandwidth_get_runtime(struct cfs_bandwidth *cfs_b)
 
 	guard(raw_spinlock_irq)(&cfs_b->lock);
 
-	runtime = cfs_b->runtime;
+	runtime = cfs_bandwidth_refilled(cfs_b, cfs_bandwidth_idle_periods(cfs_b));
 	if (cfs_b->quota != RUNTIME_INF)
 		runtime = min(runtime, cfs_b->quota + cfs_b->burst);
 
@@ -7849,6 +7918,12 @@ int cfs_bandwidth_set_runtime(struct cfs_bandwidth *cfs_b, u64 runtime)
 		    runtime > cfs_b->quota + cfs_b->burst)
 			return -EINVAL;
 
+		/*
+		 * Refill the periods that passed before the write, so that the
+		 * write replaces them and only the periods after it refill.
+		 */
+		cfs_bandwidth_refill_idle_periods(cfs_b);
+
 		/*
 		 * The next refill counts runtime_snap - runtime as burst usage.
 		 * Move runtime_snap by what the write adds or takes away, so
@@ -7879,8 +7954,8 @@ void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	if (cfs_b->period_active)
 		return;
 
+	cfs_bandwidth_refill_idle_periods(cfs_b);
 	cfs_b->period_active = 1;
-	hrtimer_forward_now(&cfs_b->period_timer, cfs_b->period);
 	hrtimer_start_expires(&cfs_b->period_timer, HRTIMER_MODE_ABS_PINNED);
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1f60c84e0dc38..676e6371d0265 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -580,6 +580,7 @@ extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
 extern void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 u64 cfs_bandwidth_get_runtime(struct cfs_bandwidth *cfs_b);
 int cfs_bandwidth_set_runtime(struct cfs_bandwidth *cfs_b, u64 runtime);
+void cfs_bandwidth_refill_idle_periods(struct cfs_bandwidth *cfs_b);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 extern bool cfs_task_bw_constrained(struct task_struct *p);
 
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 278d7e16eeb2c..04a061da514ce 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -1140,6 +1140,186 @@ static int test_cpucg_max_runtime_read_capped(const char *root)
 	return ret;
 }
 
+/*
+ * A group with a burst keeps earning quota while it is idle, up to
+ * quota + burst, and cpu.max.runtime reads what it has earned. Without a
+ * burst the runtime stays at quota.
+ */
+static int test_cpucg_max_idle_refill(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long quota_usec = 10000;	/* 10ms */
+	long period_usec = 100000;	/* 100ms */
+	long burst_usec = 990000;	/* cap 1s */
+	long runtime_usec;
+	char *cpucg;
+	char buf[64];
+
+	cpucg = cg_name(root, "cpucg_idle_refill_test");
+	if (!cpucg)
+		goto cleanup;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	snprintf(buf, sizeof(buf), "%ld %ld", quota_usec, period_usec);
+	if (cg_write(cpucg, "cpu.max", buf))
+		goto cleanup;
+
+	/* No burst: the runtime stays at quota while idle. */
+	sleep(1);
+	runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+	if (runtime_usec != quota_usec)
+		goto cleanup;
+
+	/* Burst: the write refills once (20ms), then 1s idle earns 10 more. */
+	if (cg_write_numeric(cpucg, "cpu.max.burst", burst_usec))
+		goto cleanup;
+	sleep(1);
+	runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+	if (runtime_usec < 110000 || runtime_usec > 130000)
+		goto cleanup;
+
+	/* Capped at quota + burst. */
+	sleep(10);
+	runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+	if (runtime_usec != quota_usec + burst_usec)
+		goto cleanup;
+
+	/*
+	 * A write sets the runtime from now on: 500ms later, five refills, or
+	 * six if the sleep overruns into the next period.
+	 */
+	if (cg_write_numeric(cpucg, "cpu.max.runtime", 0))
+		goto cleanup;
+	usleep(500000);
+	runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+	if (runtime_usec < 50000 || runtime_usec > 60000)
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
+ * A cpu.max or cpu.max.burst write applies from then on: what a group with
+ * a quota earned while idle is kept, capped at the new quota + burst, and a
+ * group that had no quota has earned nothing while it had none.
+ */
+static int test_cpucg_max_idle_refill_write(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long quota_usec = 10000;	/* 10ms */
+	long period_usec = 100000;	/* 100ms */
+	long runtime_usec;
+	char *cpucg = NULL, *fresh = NULL;
+	char buf[64];
+
+	cpucg = cg_name(root, "cpucg_idle_refill_write_test");
+	fresh = cg_name(root, "cpucg_idle_refill_fresh_test");
+	if (!cpucg || !fresh)
+		goto cleanup;
+
+	if (cg_create(cpucg) || cg_create(fresh))
+		goto cleanup;
+
+	snprintf(buf, sizeof(buf), "%ld %ld", quota_usec, period_usec);
+	if (cg_write(cpucg, "cpu.max", buf))
+		goto cleanup;
+	if (cg_write_numeric(cpucg, "cpu.max.burst", 190000))
+		goto cleanup;
+
+	/* 3s idle fills the group to quota + burst. */
+	sleep(3);
+	runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+	if (runtime_usec != 200000)
+		goto cleanup;
+
+	/* Writing the same cpu.max keeps what the group earned. */
+	if (cg_write(cpucg, "cpu.max", buf))
+		goto cleanup;
+	runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+	if (runtime_usec != 200000)
+		goto cleanup;
+
+	/* A lower burst keeps it too, capped at the new quota + burst. */
+	sleep(2);
+	if (cg_write_numeric(cpucg, "cpu.max.burst", 90000))
+		goto cleanup;
+	runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+	if (runtime_usec != 100000)
+		goto cleanup;
+
+	/* A group given a quota after idling without one starts with a refill. */
+	if (cg_write_numeric(fresh, "cpu.max.burst", 190000))
+		goto cleanup;
+	sleep(2);
+	if (cg_write(fresh, "cpu.max", buf))
+		goto cleanup;
+	runtime_usec = cg_read_long(fresh, "cpu.max.runtime");
+	if (runtime_usec != quota_usec)
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (fresh)
+		cg_destroy(fresh);
+	if (cpucg)
+		cg_destroy(cpucg);
+	free(fresh);
+	free(cpucg);
+	return ret;
+}
+
+/*
+ * A cpu.max.runtime write sets the runtime exactly, and only the periods
+ * after it refill.
+ */
+static int test_cpucg_max_idle_refill_runtime_write(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long runtime_usec;
+	char *cpucg;
+
+	cpucg = cg_name(root, "cpucg_idle_refill_runtime_test");
+	if (!cpucg)
+		goto cleanup;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	if (cg_write(cpucg, "cpu.max", "10000 100000"))
+		goto cleanup;
+	if (cg_write_numeric(cpucg, "cpu.max.burst", 190000))
+		goto cleanup;
+
+	sleep(3);
+	if (cg_write_numeric(cpucg, "cpu.max.runtime", 30000))
+		goto cleanup;
+	/* One refill if a period boundary passes before the read. */
+	runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+	if (runtime_usec != 30000 && runtime_usec != 40000)
+		goto cleanup;
+
+	/* 250ms after the write: two or three refills, by the boundaries. */
+	usleep(250000);
+	runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+	if (runtime_usec < 50000 || runtime_usec > 60000)
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
 #define T(x) { x, #x }
 struct cpucg_test {
 	int (*fn)(const char *root);
@@ -1159,6 +1339,9 @@ struct cpucg_test {
 	T(test_cpucg_max_runtime_unthrottle),
 	T(test_cpucg_max_runtime_burst_kept),
 	T(test_cpucg_max_runtime_read_capped),
+	T(test_cpucg_max_idle_refill),
+	T(test_cpucg_max_idle_refill_write),
+	T(test_cpucg_max_idle_refill_runtime_write),
 };
 #undef T
 
-- 
2.47.3




Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07

