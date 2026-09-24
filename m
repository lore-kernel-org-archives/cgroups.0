Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBA54BD0ED
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 18:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275681; cv=none; b=IXWX9MzV+T1cLGlgo5JQB6EjjWUKG8prgFa2kxIyrBTaw5+DzYkcbDGde45kzT6A9+0yUub0rUydeULbb8rImfP4DPJ50vG7TQ+ObYk8K30dVrUU/LJ6YV7HdS8YaF6/yKr2sOVb+netTF7IQ/yhIgun9PDjla5+fu6fcQrrY1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275681; c=relaxed/simple;
	bh=bvsZVhH3fXVvwRMjzbTh1Q0bqUQyRzPT8xCixvm+AS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BM/FL8ditkja11TisdO9LOleV4zMxCmtP6Wg1iNoWlhvDV5HD5g1wQjyUip3laAWgI28Q+OARlX6jRe6IjysFH+mIDqxWbXUjkHtNrcZ9jH5DR8fmUST8vXewjH7J5vHGZxqoELjyc2pFcKO4UxCmXFcCvGJM25Qe081TCZ1Cw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AIwnS3bu; arc=none smtp.client-ip=95.215.58.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AIwnS3bu"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bvsZVhH3fXVvwRMjzbTh1Q0bqUQyRzPT8xCixvm+AS8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275670; v=1; x=1790880470;
 b=AIwnS3bu82n/6i8h81+UuybcqZEvxDzN7ZVnE6jw/vZ85Yfr99LPq3lcClGmhALWsbZyGqVF
 C2z4WFkDopIheipluEuhSDyU0G2o5iiX9cqpVOuB79wTUUBWy+vMkyFSdOqDmj2T+M3Hs2OSD2B
 nVkJSwtECuvECqKlE6NS/W/8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 687bc44cdcacb26c;
	Thu, 24 Sep 2026 18:47:49 +0000
X-Mizu-Trace-ID: 687bc44cdcacb26c
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>,
	kernel-team@meta.com,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/7] sched/fair: add cfs_bandwidth_charge() for kernel work done for a cgroup
Date: Thu, 24 Sep 2026 11:47:08 -0700
Message-ID: <20260924184714.912181-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set_active_cgroup() charges a kernel thread's CPU time to the cgroup it
works for, but only in cpu.stat. The work still does not count against
that cgroup's cpu.max.

Add cfs_bandwidth_charge(). It takes the time out of the cpu.max pool of
the cgroup's task group and of each limited ancestor, the same way the
group's own run time is taken. The work itself is never throttled: it
has already run. Instead the group's own tasks get less time afterwards.

What the pool cannot cover now becomes debt, paid out of the next
refills. The debt is capped at one period's quota, so a burst of work
cannot starve the group for long. Changing cpu.max clears it.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 kernel/sched/core.c  |  1 +
 kernel/sched/fair.c  | 43 +++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |  8 ++++++++
 3 files changed, 52 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b9e288b76da9..a487da494795 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9809,6 +9809,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg,
 		cfs_b->period = ns_to_ktime(period);
 		cfs_b->quota = quota;
 		cfs_b->burst = burst;
+		cfs_b->debt = 0;
 
 		__refill_cfs_bandwidth_runtime(cfs_b);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 69145dda0df5..84250bd5caa2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6626,6 +6626,7 @@ static inline u64 sched_cfs_bandwidth_slice(void)
 void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 {
 	s64 runtime;
+	u64 pay;
 
 	if (unlikely(cfs_b->quota == RUNTIME_INF))
 		return;
@@ -6638,9 +6639,51 @@ void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 	}
 
 	cfs_b->runtime = min(cfs_b->runtime, cfs_b->quota + cfs_b->burst);
+
+	/* Pay back the kernel work charged by cfs_bandwidth_charge(). */
+	pay = min(cfs_b->runtime, cfs_b->debt);
+	cfs_b->runtime -= pay;
+	cfs_b->debt -= pay;
+
 	cfs_b->runtime_snap = cfs_b->runtime;
 }
 
+/*
+ * Kernel work used @delta of CPU time for @cgrp, see set_active_cgroup().
+ * Take it out of the quota of @cgrp's task group and of each ancestor with
+ * a limit, the same way the group's own run time is taken. What the pool
+ * cannot cover now becomes debt, paid out of the next refills. The debt is
+ * capped at one period's quota, so the work cannot starve the group for
+ * long.
+ */
+void cfs_bandwidth_charge(struct cgroup *cgrp, u64 delta)
+{
+	struct task_group *tg;
+
+	if (!cfs_bandwidth_used())
+		return;
+
+	guard(rcu)();
+	tg = css_tg(cgroup_e_css(cgrp, &cpu_cgrp_subsys));
+
+	/* No limit here or above. */
+	if (READ_ONCE(tg->cfs_bandwidth.hierarchical_quota) == RUNTIME_INF)
+		return;
+
+	for (; tg; tg = tg->parent) {
+		struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+		u64 take;
+
+		guard(raw_spinlock_irqsave)(&cfs_b->lock);
+		if (cfs_b->quota == RUNTIME_INF)
+			continue;
+
+		take = min(delta, cfs_b->runtime);
+		cfs_b->runtime -= take;
+		cfs_b->debt = min(cfs_b->debt + delta - take, cfs_b->quota);
+	}
+}
+
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 {
 	return &tg->cfs_bandwidth;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6c3ad70e58b8..2d1adfd7ad37 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -456,6 +456,8 @@ struct cfs_bandwidth {
 	u64			runtime;
 	u64			burst;
 	u64			runtime_snap;
+	/* Kernel work charged by cfs_bandwidth_charge(), not paid yet: */
+	u64			debt;
 	s64			hierarchical_quota;
 
 	u8			idle;
@@ -618,6 +620,12 @@ static inline bool cfs_task_bw_constrained(struct task_struct *p) { return false
 
 #endif /* !CONFIG_CGROUP_SCHED */
 
+#ifdef CONFIG_CFS_BANDWIDTH
+void cfs_bandwidth_charge(struct cgroup *cgrp, u64 delta);
+#else
+static inline void cfs_bandwidth_charge(struct cgroup *cgrp, u64 delta) { }
+#endif
+
 /*
  * A weight of 0 or 1 can cause arithmetics problems.
  * A weight of a cfs_rq is the sum of weights of which entities
-- 
2.53.0-Meta

