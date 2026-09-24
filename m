Received: from mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8E94BA1D0
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 18:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275688; cv=none; b=skaija6tgT7VpcVlqtWzHcVBmKwp37+0pPiU3CH6oBLkaJP2aEX21Li51BKRUxOrtfwCQuyF3XDgnatzvwKbiKWMEnLdLeqiNR+jrZRlktONJxETXIj6BeAX5maj5Kxl08N4LMZMGhnC2KTtWJOvXdfe0NMYvwpNb/D4ITyUS+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275688; c=relaxed/simple;
	bh=YPDMx5Cpm0Ky2M5qOc3ie9+dgsk3KEGxwc7kMebFStk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmPzOksMSTq8fJK8Zx8MJyyNfJmWG0ZQ9CT+YOvORZcN1hZjlMErFznosnGPXvvvexNzEQCeZbvLNWklkSKGK+cHd0FjMvq6qswzfJ+2avyrfluKKVk8DVtstC1j8RKCuY/va036ssXuOcRcTCT1XUE0bs7y04c6G3bVB0BESic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hRt6T8GX; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hRt6T8GX"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YPDMx5Cpm0Ky2M5qOc3ie9+dgsk3KEGxwc7kMebFStk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275675; v=1; x=1790880475;
 b=hRt6T8GX88GoHf5QBQK+pSkz/vS596pjl0ZY5HL4IoVLD1gXsNPWE8+Xin3CSM9peiBdJvj1
 B65aPsUnHWs30w5E5gAIRODr+kWUrvbJ9gaAbrxPzFjn7Gx8LnXrMnqoPAcE14G74xU6IWJ3BHT
 D4bL3PTKBTIjkOk0NGppL7H0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 458fdd5e55f5d437;
	Thu, 24 Sep 2026 18:47:55 +0000
X-Mizu-Trace-ID: 458fdd5e55f5d437
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
Subject: [RFC PATCH 5/7] cgroup: take set_active_cgroup() time out of the cgroup's cpu.max
Date: Thu, 24 Sep 2026 11:47:09 -0700
Message-ID: <20260924184714.912181-6-shakeel.butt@linux.dev>
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

Kernel work done under set_active_cgroup() shows up in the cgroup's
cpu.stat, but the cgroup's tasks still get their full cpu.max quota.

Remember the task's run time at each set_active_cgroup(). When the
active cgroup changes, charge the time used under the old one to its
cpu.max quota with cfs_bandwidth_charge(). The caller is in the root
cgroup, which has no cpu.max, so no quota is charged twice.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/sched.h |  2 ++
 kernel/sched/core.c   | 12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 002941f60e88..7ecea9cfa702 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1358,6 +1358,8 @@ struct task_struct {
 	struct list_head		cg_list;
 	/* If set, CPU time is charged here; see set_active_cgroup(): */
 	struct cgroup			*active_cgroup;
+	/* se.sum_exec_runtime at the last set_active_cgroup(): */
+	u64				active_cgroup_start;
 #ifdef CONFIG_PREEMPT_RT
 	struct llist_node		cg_dead_lnode;
 #endif	/* CONFIG_PREEMPT_RT */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a487da494795..91fec6461e4f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5738,8 +5738,9 @@ unsigned long long task_sched_runtime(struct task_struct *p)
  * @cgrp: the cgroup to charge, or NULL for current's own cgroup
  *
  * For kernel code that does work for a cgroup. The time it uses is charged
- * to @cgrp as kernel time. Returns the old value, which the caller restores
- * when done. @cgrp must stay alive until then.
+ * to @cgrp as kernel time, and taken out of @cgrp's cpu.max quota. Returns
+ * the old value, which the caller restores when done. @cgrp must stay alive
+ * until then.
  *
  * Only for callers in the root cgroup, like kworkers. The scheduler still
  * runs the caller in its own cgroup, so from any other cgroup the time would
@@ -5753,6 +5754,7 @@ struct cgroup *set_active_cgroup(struct cgroup *cgrp)
 	struct cgroup *old;
 	struct rq_flags rf;
 	struct rq *rq;
+	u64 used;
 
 	WARN_ON_ONCE(!in_task());
 	WARN_ON_ONCE(cgrp && cgrp->root != &cgrp_dfl_root);
@@ -5768,9 +5770,15 @@ struct cgroup *set_active_cgroup(struct cgroup *cgrp)
 	rq->donor->sched_class->update_curr(rq);
 
 	old = p->active_cgroup;
+	used = p->se.sum_exec_runtime - p->active_cgroup_start;
+	p->active_cgroup_start = p->se.sum_exec_runtime;
 	psi_set_active_cgroup(p, cgrp);
 	task_rq_unlock(rq, p, &rf);
 
+	/* Take that time out of the old cgroup's cpu.max quota as well. */
+	if (old)
+		cfs_bandwidth_charge(old, used);
+
 	return old;
 }
 #endif
-- 
2.53.0-Meta

