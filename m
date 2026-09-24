Received: from mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79417429023
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 18:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275679; cv=none; b=RiKSyd65Q9meGYZx/j5q3Cz/nKUaDiYrGB1umCyTSwKWLejUsnhm3+Otvta6ukDA3PKxCeinIAGjP0HrDupmUMYHLN3MBL48ydm8IrF5BiFoEWEwxoJSaNgdbMSw/1wWRhs5DPjAIiS/AzY0uILwc4G/mJT3kr3ZwqxjbsPbS5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275679; c=relaxed/simple;
	bh=PCLpGfGy//n9UKU35pNohFAj9dJU7KEFqV53+5uIk0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pc3CK2cTwZChU47k9YjSMHUOHGS43QNAUzFBRjBy1+4PvXpZaYU+HJ+qXtD0pC5uBCFAP8r4QkzTgjfqsXjjT03PsQV0eem9hbEE5NgR3rho9EqsMeT7CkYGMUFkLSfcmA6UKpI/2w3w3voaFr4varYcKrMSnlNqyhXfyggwEJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mbQdCytu; arc=none smtp.client-ip=91.218.175.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mbQdCytu"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PCLpGfGy//n9UKU35pNohFAj9dJU7KEFqV53+5uIk0w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275661; v=1; x=1790880461;
 b=mbQdCytucYohHkXCoCDfpZaaMDUh3P1wGCpd9SyJEfSVghsL1cc8lWLca6m/zs91j6nDnJD2
 DW/w+/rnaF+CDss0AOXDKlQUwOVTN6nKaHjK2tC22yQ/F5rD1kfC3YOh/uUHYhblDdWslS2e5rj
 vVmSRkMSxkQfLWv7D7vya008=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b5bb50beb49d0e34;
	Thu, 24 Sep 2026 18:47:41 +0000
X-Mizu-Trace-ID: b5bb50beb49d0e34
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
Subject: [RFC PATCH 2/7] cgroup: add set_active_cgroup() to charge CPU time to a cgroup
Date: Thu, 24 Sep 2026 11:47:06 -0700
Message-ID: <20260924184714.912181-3-shakeel.butt@linux.dev>
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

A kernel thread that does work for a cgroup, like memcg reclaim from a
workqueue, has that CPU time charged to its own cgroup, usually root.

Add task_struct::active_cgroup. When set, the task's CPU time goes to
that cgroup instead. set_active_cgroup() sets it and returns the old
value, like set_active_memcg(). It first charges the time used so far to
the old cgroup, so even short work is charged to the right place.

Code under set_active_cgroup() is kernel code, so charge its time as
system time right away. Skip the tick and vtime path for it, which could
charge it late, after the old value is back. Forced idle time from core
scheduling comes through that path too. It is not run time, so charge it
to the active cgroup there.

Only allow callers in the root cgroup, like kworkers. The scheduler still
runs the caller in its own cgroup and takes the time from that cgroup's
cpu.max, and on nohz_full CPUs vtime can post system time from inside the
scope to that cgroup after the old value is back. Warn and do nothing for
other callers.

Warn and clear it if a task exits with it still set.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/cgroup.h | 26 +++++++++++++++++++++++++
 include/linux/sched.h  |  2 ++
 kernel/cgroup/cgroup.c |  4 ++++
 kernel/fork.c          |  4 ++++
 kernel/sched/core.c    | 43 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 79 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7b19ded2578d..761bd0a81c67 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -879,6 +879,8 @@ static inline void cgroup_account_system_time(struct cgroup *cgrp,
 	}
 }
 
+struct cgroup *set_active_cgroup(struct cgroup *cgrp);
+
 static inline void cgroup_account_cputime(struct task_struct *task,
 					  u64 delta_exec)
 {
@@ -886,6 +888,12 @@ static inline void cgroup_account_cputime(struct task_struct *task,
 
 	cpuacct_charge(task, delta_exec);
 
+	/* Time spent under set_active_cgroup() is all kernel time. */
+	if (task->active_cgroup) {
+		cgroup_account_system_time(task->active_cgroup, delta_exec);
+		return;
+	}
+
 	cgrp = task_dfl_cgroup(task);
 	if (cgroup_parent(cgrp))
 		__cgroup_account_cputime(cgrp, delta_exec);
@@ -899,6 +907,20 @@ static inline void cgroup_account_cputime_field(struct task_struct *task,
 
 	cpuacct_account_field(task, index, delta_exec);
 
+	/*
+	 * cgroup_account_cputime() has charged the run time already. Forced
+	 * idle time from core scheduling is not run time: charge it here.
+	 */
+	if (task->active_cgroup) {
+#ifdef CONFIG_SCHED_CORE
+		if (index == CPUTIME_FORCEIDLE &&
+		    cgroup_parent(task->active_cgroup))
+			__cgroup_account_cputime_field(task->active_cgroup,
+						       index, delta_exec);
+#endif
+		return;
+	}
+
 	cgrp = task_dfl_cgroup(task);
 	if (cgroup_parent(cgrp))
 		__cgroup_account_cputime_field(cgrp, index, delta_exec);
@@ -913,6 +935,10 @@ static inline void cgroup_account_cputime_field(struct task_struct *task,
 						u64 delta_exec) {}
 static inline void cgroup_account_system_time(struct cgroup *cgrp,
 					      u64 delta_exec) {}
+static inline struct cgroup *set_active_cgroup(struct cgroup *cgrp)
+{
+	return NULL;
+}
 
 #endif	/* CONFIG_CGROUPS */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5ce350a616e4..002941f60e88 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1356,6 +1356,8 @@ struct task_struct {
 	struct css_set __rcu		*cgroups;
 	/* cg_list protected by css_set_lock and tsk->alloc_lock: */
 	struct list_head		cg_list;
+	/* If set, CPU time is charged here; see set_active_cgroup(): */
+	struct cgroup			*active_cgroup;
 #ifdef CONFIG_PREEMPT_RT
 	struct llist_node		cg_dead_lnode;
 #endif	/* CONFIG_PREEMPT_RT */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 804318ae160e..f51ed71c122f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -7173,6 +7173,10 @@ void cgroup_task_exit(struct task_struct *tsk)
 	struct cgroup_subsys *ss;
 	int i;
 
+	/* The task forgot to undo set_active_cgroup(). */
+	if (WARN_ON_ONCE(tsk->active_cgroup))
+		set_active_cgroup(NULL);
+
 	/* see cgroup_post_fork() for details */
 	do_each_subsys_mask(ss, i, have_exit_callback) {
 		ss->exit(tsk);
diff --git a/kernel/fork.c b/kernel/fork.c
index 39be51048d77..044a4a5de8ef 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1006,6 +1006,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	tsk->active_memcg = NULL;
 #endif
 
+#ifdef CONFIG_CGROUPS
+	tsk->active_cgroup = NULL;
+#endif
+
 #ifdef CONFIG_X86_BUS_LOCK_DETECT
 	tsk->reported_split_lock = 0;
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 57dad4fc163e..ccb7ee9f2f26 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5732,6 +5732,49 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	return ns;
 }
 
+#ifdef CONFIG_CGROUPS
+/**
+ * set_active_cgroup - charge current's CPU time to another cgroup
+ * @cgrp: the cgroup to charge, or NULL for current's own cgroup
+ *
+ * For kernel code that does work for a cgroup. The time it uses is charged
+ * to @cgrp as kernel time. Returns the old value, which the caller restores
+ * when done. @cgrp must stay alive until then.
+ *
+ * Only for callers in the root cgroup, like kworkers. The scheduler still
+ * runs the caller in its own cgroup, so from any other cgroup the time would
+ * also count against that cgroup's cpu.max, and on nohz_full CPUs some of
+ * it could show up in that cgroup's cpu.stat. It warns and does nothing for
+ * such a caller.
+ */
+struct cgroup *set_active_cgroup(struct cgroup *cgrp)
+{
+	struct task_struct *p = current;
+	struct cgroup *old;
+	struct rq_flags rf;
+	struct rq *rq;
+
+	WARN_ON_ONCE(!in_task());
+	WARN_ON_ONCE(cgrp && cgrp->root != &cgrp_dfl_root);
+
+	scoped_guard(rcu) {
+		if (cgrp && WARN_ON_ONCE(cgroup_parent(task_dfl_cgroup(p))))
+			return p->active_cgroup;
+	}
+
+	rq = task_rq_lock(p, &rf);
+	/* Charge the time used so far to the old cgroup. */
+	update_rq_clock(rq);
+	rq->donor->sched_class->update_curr(rq);
+
+	old = p->active_cgroup;
+	p->active_cgroup = cgrp;
+	task_rq_unlock(rq, p, &rf);
+
+	return old;
+}
+#endif
+
 static u64 cpu_resched_latency(struct rq *rq)
 {
 	int latency_warn_ms = READ_ONCE(sysctl_resched_latency_warn_ms);
-- 
2.53.0-Meta

