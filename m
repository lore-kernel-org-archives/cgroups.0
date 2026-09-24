Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C704BB5B7
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 18:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275681; cv=none; b=BTA7p13m31g6VEaL00QPI2lg1YIQrdTnaoz9Awp8Kv/9EDz77lhBAo7ZS/3jyAe/vk+G3v6/gC2Y2dKdBDyOm+qVBAiYTizQZCe3YYTRg6UQzS2z3hhBg2hZ51Oaooi/bUSKYD3d1BIhvuMC5OC+5CiWfzGZ/VB51iHRMyz+ABU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275681; c=relaxed/simple;
	bh=fiIPJORvS4gxPp3xcAjHqBOYrPmfNQt6sseBDUijnxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwruyrvV1CUTvbjvojatnn3fjZgkhhBa1IiRa/iXgmzoNDSFuxfqslz74U3fkZfbDd+0dlsCxG4GyhPDI5mQunLUyb17jdItSiosa23278oALcqscOWRzLJ2jlKpU0z1syeZfwH93i9ST/nNYGaSZgiP+ZkJvu4zJpAHxmF9ogc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AY6vKe1X; arc=none smtp.client-ip=91.218.175.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AY6vKe1X"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fiIPJORvS4gxPp3xcAjHqBOYrPmfNQt6sseBDUijnxI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275667; v=1; x=1790880467;
 b=AY6vKe1Xmz4DW0XO0ofRpvtZ91wB4dFj7FYmcajb6TMWFYdJgJTq+V1Xc8iG+sbbztvScxMq
 whPgx0fEIjMBN+n8v4jEVidNiTApBWcfyeEjs6Zkb/H1CVFjL36/09bicfrlC+3IJsgA4wznxld
 rY0TU/3RIKfdZ/oNn4/6laBM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fb43f222c7f5ccb1;
	Thu, 24 Sep 2026 18:47:47 +0000
X-Mizu-Trace-ID: fb43f222c7f5ccb1
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
Subject: [RFC PATCH 3/7] psi: charge pressure to the task's active cgroup
Date: Thu, 24 Sep 2026 11:47:07 -0700
Message-ID: <20260924184714.912181-4-shakeel.butt@linux.dev>
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

When a kernel thread works for a cgroup under set_active_cgroup(), its
stalls, like memory reclaim, should count as that cgroup's pressure.

Make task_psi_group() use the active cgroup. When it changes, move the
task's pressure state from the old groups to the new ones, the same way
cgroup_move_task() does for a real cgroup move.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 kernel/sched/core.c  |  2 +-
 kernel/sched/psi.c   | 22 +++++++++++++++++++++-
 kernel/sched/stats.h | 10 ++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ccb7ee9f2f26..b9e288b76da9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5768,7 +5768,7 @@ struct cgroup *set_active_cgroup(struct cgroup *cgrp)
 	rq->donor->sched_class->update_curr(rq);
 
 	old = p->active_cgroup;
-	p->active_cgroup = cgrp;
+	psi_set_active_cgroup(p, cgrp);
 	task_rq_unlock(rq, p, &rf);
 
 	return old;
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 4e152410653d..7e03be26b8d3 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -886,7 +886,7 @@ static inline struct psi_group *task_psi_group(struct task_struct *task)
 {
 #ifdef CONFIG_CGROUPS
 	if (static_branch_likely(&psi_cgroups_enabled))
-		return cgroup_psi(task_dfl_cgroup(task));
+		return cgroup_psi(task->active_cgroup ?: task_dfl_cgroup(task));
 #endif
 	return &psi_system;
 }
@@ -1213,6 +1213,26 @@ void cgroup_move_task(struct task_struct *task, struct css_set *to)
 	task_rq_unlock(rq, task, &rf);
 }
 
+/*
+ * Set @task's active cgroup and move its pressure state along with it.
+ * The caller holds the task's rq lock.
+ */
+void psi_set_active_cgroup(struct task_struct *task, struct cgroup *cgrp)
+{
+	unsigned int task_flags = task->psi_flags;
+
+	lockdep_assert_rq_held(task_rq(task));
+
+	if (!static_branch_likely(&psi_cgroups_enabled) || !task_flags) {
+		task->active_cgroup = cgrp;
+		return;
+	}
+
+	psi_task_change(task, task_flags, 0);
+	task->active_cgroup = cgrp;
+	psi_task_change(task, 0, task_flags);
+}
+
 void psi_cgroup_restart(struct psi_group *group)
 {
 	int cpu;
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index ebe0a7765f98..60f46b7b598c 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -103,6 +103,9 @@ __schedstats_from_se(struct sched_entity *se)
 void psi_task_change(struct task_struct *task, int clear, int set);
 void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		     bool sleep);
+#ifdef CONFIG_CGROUPS
+void psi_set_active_cgroup(struct task_struct *task, struct cgroup *cgrp);
+#endif
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 void psi_account_irqtime(struct rq *rq, struct task_struct *curr, struct task_struct *prev);
 #else /* !CONFIG_IRQ_TIME_ACCOUNTING: */
@@ -227,6 +230,13 @@ static inline void psi_sched_switch(struct task_struct *prev,
 				    bool sleep) {}
 static inline void psi_account_irqtime(struct rq *rq, struct task_struct *curr,
 				       struct task_struct *prev) {}
+#ifdef CONFIG_CGROUPS
+static inline void psi_set_active_cgroup(struct task_struct *task,
+					 struct cgroup *cgrp)
+{
+	task->active_cgroup = cgrp;
+}
+#endif
 #endif /* !CONFIG_PSI */
 
 #ifdef CONFIG_SCHED_INFO
-- 
2.53.0-Meta

