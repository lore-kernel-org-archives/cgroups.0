Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.34.181.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794400242;
	b=HqxyvUGqaptoPBlXnLCHF1xojCGUn3Iewd2PxOgsWDyUxRl6mOS2LhP+Qjek5Yl+rwCa
	 KbSdLmrzkwjhhFmz46Epg8Iv8A/YnLAibkYDDJXk2fG6eqgoTWA/bZFr7bG6zdjmPUR1E
	 cZbQDR3xQwe5pgr8b4yGOHcHvx/b+dzoG9IwmsXUIDTAJmfuWy+/yS7oF7Bsm14yrGZw+
	 NVJgtpI7bpVV3a+ClbdQzA20LRyadkUl4PdkJQEfmPG0Wmrs5UvZwkp66esdq8FmfuxVy
	 ddGmhcTfENOX6uSaLhJtDl07JVP+Z9mICBNJqD5r3OC0gVWH3/H9zKw8NQjxS4kSb2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794400242;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=edbGiyGIu5sLlTnWTnPemPa+9AxsJ4JbSP3661/+iQ8=;
	b=QsmnkjknsjWdU6dCZvwlHguiWrwy5J5QQJPvDiIh8483WO3bXdKXCjEKHM0/Yu2raTfo
	 mh4lzCY7L7KTqzrm8H5hig9m/FCT/Wu5WBftxEaouwm70MYWaGG5OTRr6pigEFO2B59WC
	 5Rb6AOHTh8Ty8lX0bK++2X0Qm848JxkNMXGcABIIHz34FotAaSBaiIwDJdtewNygrCJ2e
	 fYa/BRf8c9mDcJdO8XoKw/76YzsBr6243Oq6KH317ZgqGUOfCnixnJOTz4wYPoHKbc86R
	 ykRM7Z1qlzy9Wepn8FIkCNDbk+EB7a67FXjeVa6d+YsxuE0P0uJpj/W7GbZnFWCtYkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=NyxA6yfR;
	arc=none smtp.remote-ip=52.34.181.151
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE7F606A31C;
	Wed, 11 Nov 2026 12:30:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCE7F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=NyxA6yfR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794400236; x=1825936236;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=edbGiyGIu5sLlTnWTnPemPa+9AxsJ4JbSP3661/+iQ8=;
  b=NyxA6yfR414U12Td7neKUCQo+znfTsde4QWIyKg7JzvaYwTIQ+QwJ4tJ
   D+/ZiPKoJu7xQrTn6B22vsZMP0nnNsIi4ZavpkS4xabZolr98xTR9S9SX
   slfc+bgd55iFlz3sHf0Aco/hz4GL8Ini4Xt2yGvTQD8bPxktO7MYfSGQv
   sj+3eLMWrdQg+NfdCxUmJqW7PFaHpPmvdq1dl/DjVOGWjlL6lYSMxeWUY
   S1qg6OMLOiUWISnNpzpSpIiaxKUunui6AVR+ZTi9xVg3THmVSrmG8ZiZH
   fJiECH+pAlJfYv6da0WGaT+shm+9JS3X/t7Z9cZYWfxiLGGyBx7HdCW/d
   A==;
X-CSE-ConnectionGUID: ZraDB6+jQs2FKn3qb9Ow/g==
X-CSE-MsgGUID: M0f2l3YDTLeaz1OxtMVUpg==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33707211"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 12:30:36 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:24115]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id 43de55fc-60cc-47b4-a759-0ce6107898b8; Wed, 11 Nov 2026 12:30:36 +0000 (UTC)
X-Farcaster-Flow-ID: 43de55fc-60cc-47b4-a759-0ce6107898b8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 12:30:35 +0000
Received: from dev-dsk-sieberf-metal-1a-7543e84d.eu-west-1.amazon.com
 (172.19.116.227) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 12:30:31 +0000
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
Subject: [PATCH v3 2/2] sched/fair: refill bandwidth for the periods the timer slept through
Date: Wed, 11 Nov 2026 14:29:49 +0200
Message-ID: <e71eb3a4c38d790114baabc62f9ebe8e2771bb91.1794398404.git.sieberf@amazon.com>
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
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
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
long time unconstrained does not start full. The next period starts from
the change too: a stopped timer's expiry is a boundary of the period the
group had, so leaving it would put the first refill under the new
bandwidth up to one old period away. A cpu.max.runtime write also
refills the periods owed first, so that it replaces them, and only the
periods after the write refill.

cpu.max.runtime reports the runtime the group has now, owed refills
included, without starting the timer.

The idle periods are not added to cpu.stat's nr_periods, which counts the
periods in which the timer ran. A timer that runs late by several
periods still refills only once, unlike a stopped one; this patch leaves
that as it is.

Signed-off-by: Fernand Sieber <sieberf@amazon.com>
---
 Documentation/admin-guide/cgroup-v2.rst   |  17 +-
 Documentation/scheduler/sched-bwc.rst     |   5 +-
 kernel/sched/core.c                       |  12 ++
 kernel/sched/fair.c                       | 100 +++++++++-
 kernel/sched/sched.h                      |   2 +
 tools/testing/selftests/cgroup/test_cpu.c | 231 ++++++++++++++++++++++
 6 files changed, 355 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index eb802f8ba877f..12d40b55f2dbb 100644
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
@@ -1246,11 +1246,12 @@ will be referred to. All time durations are in microseconds.
 
 	The runtime the cgroup has accumulated and not used yet, in
 	microseconds. Each period refills it by $MAX, up to $MAX +
-	cpu.max.burst, and a read returns at most $MAX + cpu.max.burst.
-	A write sets it, up to $MAX + cpu.max.burst, and lets a cgroup
-	that ran out of runtime run again at once. A write fails with
-	EINVAL while $MAX is "max", a read then returns 0, and setting
-	$MAX to "max" drops the runtime the cgroup had.
+	cpu.max.burst, whether the cgroup runs in it or not. A read
+	returns at most $MAX + cpu.max.burst. A write sets it, up to
+	$MAX + cpu.max.burst, and lets a cgroup that ran out of runtime
+	run again at once. A write fails with EINVAL while $MAX is
+	"max", a read then returns 0, and setting $MAX to "max" drops
+	the runtime the cgroup had.
 
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
index e068d81e1fc5f..265088af6a561 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9856,10 +9856,22 @@ static int tg_set_cfs_bandwidth(struct task_group *tg,
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
 
+		/*
+		 * The next period starts from here too, rather than at the
+		 * boundary left over from the old one.
+		 */
+		cfs_bandwidth_reanchor_period(cfs_b);
+
 		/*
 		 * A group without a quota accumulates no runtime, so drop what
 		 * it had rather than report it and add to it once it has a
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8fee8d27faa5a..0a65a8e232c96 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7817,6 +7817,92 @@ static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
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
+/*
+ * Start the next period of a stopped timer from now, as a bandwidth change
+ * does. Its expiry is a boundary of the period the group had; move it one new
+ * period past now, so that cfs_bandwidth_refill_idle_periods() owes nothing
+ * for it when the timer restarts.
+ */
+void cfs_bandwidth_reanchor_period(struct cfs_bandwidth *cfs_b)
+{
+	lockdep_assert_held(&cfs_b->lock);
+
+	if (cfs_b->period_active)
+		return;
+
+	hrtimer_set_expires(&cfs_b->period_timer,
+			    ktime_add(ktime_get(), cfs_b->period));
+}
+
 /*
  * The runtime of @cfs_b, as cpu.max.runtime reads it.
  *
@@ -7829,12 +7915,16 @@ static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
  */
 u64 cfs_bandwidth_get_runtime(struct cfs_bandwidth *cfs_b)
 {
+	u64 runtime;
+
 	guard(raw_spinlock_irq)(&cfs_b->lock);
 
 	if (cfs_b->quota == RUNTIME_INF)
 		return 0;
 
-	return min(cfs_b->runtime, cfs_b->quota + cfs_b->burst);
+	runtime = cfs_bandwidth_refilled(cfs_b, cfs_bandwidth_idle_periods(cfs_b));
+
+	return min(runtime, cfs_b->quota + cfs_b->burst);
 }
 
 /*
@@ -7853,6 +7943,12 @@ int cfs_bandwidth_set_runtime(struct cfs_bandwidth *cfs_b, u64 runtime)
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
@@ -7883,8 +7979,8 @@ void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	if (cfs_b->period_active)
 		return;
 
+	cfs_bandwidth_refill_idle_periods(cfs_b);
 	cfs_b->period_active = 1;
-	hrtimer_forward_now(&cfs_b->period_timer, cfs_b->period);
 	hrtimer_start_expires(&cfs_b->period_timer, HRTIMER_MODE_ABS_PINNED);
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1f60c84e0dc38..a03ac077a8f49 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -580,6 +580,8 @@ extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
 extern void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 u64 cfs_bandwidth_get_runtime(struct cfs_bandwidth *cfs_b);
 int cfs_bandwidth_set_runtime(struct cfs_bandwidth *cfs_b, u64 runtime);
+void cfs_bandwidth_refill_idle_periods(struct cfs_bandwidth *cfs_b);
+void cfs_bandwidth_reanchor_period(struct cfs_bandwidth *cfs_b);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 extern bool cfs_task_bw_constrained(struct task_struct *p);
 
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index b5a9fbcf722f6..2b7c3bf89a1c9 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -1160,6 +1160,233 @@ static int test_cpucg_max_runtime_read_capped(const char *root)
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
+/*
+ * A cpu.max write starts the next period from the write, so the first refill
+ * under a new period comes one new period later, not up to one old period
+ * later.
+ */
+static int test_cpucg_max_idle_refill_period_change(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long runtime_usec;
+	char *cpucg;
+
+	cpucg = cg_name(root, "cpucg_idle_refill_period_test");
+	if (!cpucg)
+		goto cleanup;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	/* 10ms of quota every second, the longest period, and a 1s cap. */
+	if (cg_write(cpucg, "cpu.max", "10000 1000000"))
+		goto cleanup;
+	if (cg_write_numeric(cpucg, "cpu.max.burst", 990000))
+		goto cleanup;
+
+	/* Idle until the period timer stops, then start from nothing. */
+	sleep(2);
+	if (cg_write_numeric(cpucg, "cpu.max.runtime", 0))
+		goto cleanup;
+
+	/* 1ms of quota every 10ms from the write on. */
+	if (cg_write(cpucg, "cpu.max", "1000 10000"))
+		goto cleanup;
+
+	/* 200ms is twenty refills of the new quota, plus the write's own. */
+	usleep(200000);
+	runtime_usec = cg_read_long(cpucg, "cpu.max.runtime");
+	if (runtime_usec < 10000)
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
@@ -1179,6 +1406,10 @@ struct cpucg_test {
 	T(test_cpucg_max_runtime_unthrottle),
 	T(test_cpucg_max_runtime_burst_kept),
 	T(test_cpucg_max_runtime_read_capped),
+	T(test_cpucg_max_idle_refill),
+	T(test_cpucg_max_idle_refill_write),
+	T(test_cpucg_max_idle_refill_runtime_write),
+	T(test_cpucg_max_idle_refill_period_change),
 };
 #undef T
 
-- 
2.47.3




Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07

