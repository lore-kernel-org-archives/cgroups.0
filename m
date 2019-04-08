From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/7] sched: refactor tg_set_cfs_bandwidth()
Date: Mon, 8 Apr 2019 14:45:33 -0700
Message-ID: <20190408214539.2705660-2-songliubraving@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=L+rJS0SgXG+W7FCDQpKsebmkzZCRJJh5uOQMvLo7MzE=;
 b=gNd+cUPSgQXxXIhjvJseHkOL7XwB5XP+q3C9UVkwAkjEBv/UCphHt9nsq1/z40TIh1z2
 qSW7TovkGlfR6rMDTsyYno3vwc8WxOjE0KB4u3yMzLm50Ck3MbK4Ib5QPm5kzXRRhDo+
 mPao9/eHbGukPrYnRtlaw1H6CfF2ZlkBPVg= 
In-Reply-To: <20190408214539.2705660-1-songliubraving@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de, morten.rasmussen@arm.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>

This patch factors tg_switch_cfs_runtime() out of tg_set_cfs_bandwidth(),
so that next patches can extend tg_switch_cfs_runtime() to support the new
target_idle_pct value.

This patch doesn't have any functionality changes.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/sched/core.c | 71 +++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ead464a0f2e5..b8f220860dc7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6578,39 +6578,12 @@ const u64 min_cfs_quota_period = 1 * NSEC_PER_MSEC; /* 1ms */
 
 static int __cfs_schedulable(struct task_group *tg, u64 period, u64 runtime);
 
-static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
+/* need get_online_cpus() and hold cfs_constraints_mutex */
+static void tg_switch_cfs_runtime(struct task_group *tg, u64 period, u64 quota)
 {
-	int i, ret = 0, runtime_enabled, runtime_was_enabled;
 	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
-
-	if (tg == &root_task_group)
-		return -EINVAL;
-
-	/*
-	 * Ensure we have at some amount of bandwidth every period.  This is
-	 * to prevent reaching a state of large arrears when throttled via
-	 * entity_tick() resulting in prolonged exit starvation.
-	 */
-	if (quota < min_cfs_quota_period || period < min_cfs_quota_period)
-		return -EINVAL;
-
-	/*
-	 * Likewise, bound things on the otherside by preventing insane quota
-	 * periods.  This also allows us to normalize in computing quota
-	 * feasibility.
-	 */
-	if (period > max_cfs_quota_period)
-		return -EINVAL;
-
-	/*
-	 * Prevent race between setting of cfs_rq->runtime_enabled and
-	 * unthrottle_offline_cfs_rqs().
-	 */
-	get_online_cpus();
-	mutex_lock(&cfs_constraints_mutex);
-	ret = __cfs_schedulable(tg, period, quota);
-	if (ret)
-		goto out_unlock;
+	int runtime_enabled, runtime_was_enabled;
+	int i;
 
 	runtime_enabled = quota != RUNTIME_INF;
 	runtime_was_enabled = cfs_b->quota != RUNTIME_INF;
@@ -6647,7 +6620,41 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 	}
 	if (runtime_was_enabled && !runtime_enabled)
 		cfs_bandwidth_usage_dec();
-out_unlock:
+}
+
+static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
+{
+	int ret = 0;
+
+	if (tg == &root_task_group)
+		return -EINVAL;
+
+	/*
+	 * Ensure we have at some amount of bandwidth every period.  This is
+	 * to prevent reaching a state of large arrears when throttled via
+	 * entity_tick() resulting in prolonged exit starvation.
+	 */
+	if (quota < min_cfs_quota_period || period < min_cfs_quota_period)
+		return -EINVAL;
+
+	/*
+	 * Likewise, bound things on the otherside by preventing insane quota
+	 * periods.  This also allows us to normalize in computing quota
+	 * feasibility.
+	 */
+	if (period > max_cfs_quota_period)
+		return -EINVAL;
+
+	/*
+	 * Prevent race between setting of cfs_rq->runtime_enabled and
+	 * unthrottle_offline_cfs_rqs().
+	 */
+	get_online_cpus();
+	mutex_lock(&cfs_constraints_mutex);
+	ret = __cfs_schedulable(tg, period, quota);
+	if (!ret)
+		tg_switch_cfs_runtime(tg, period, quota);
+
 	mutex_unlock(&cfs_constraints_mutex);
 	put_online_cpus();
 
-- 
2.17.1

