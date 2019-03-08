From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v5 3/7] psi: rename psi fields in preparation for psi trigger addition
Date: Fri,  8 Mar 2019 10:43:07 -0800
Message-ID: <20190308184311.144521-4-surenb@google.com>
References: <20190308184311.144521-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OplnuXRZxId0pdfBC75FwRElAzJw95m6KFBlT8ZCwYA=;
        b=eLdg3v+nnsix/WEq9cIQXxF6rEMUbk6o+EfOnyMexjGolm48oKpVO/ZfgvFBUMzUQq
         +8vWtIHjH805IaHbtRpGR/K6cynyhI1tTZWOu4AycWFX2cseASldHKW47GOWpa8LeseY
         VeXtviVvtYaVHJuAnbU9eXRYGSrsoV6ozdT0HNj3IblQaTeM66Fd9Wi12o4N/exY0QVS
         6DziP/9QOuU3qVfJHxCJzF72/hSeY+YCyVPbHRPmCih1es7yMeURa5KNV84MCIL1FAtd
         pD7ba1BOE6DEusuV/JPafZp0iS2oMlOBLpfZXHW3PNCyQilkVG4SMnpJt8wT7I9epybu
         +2LQ==
In-Reply-To: <20190308184311.144521-1-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, Suren Baghdasaryan <surenb@google.com>

Renaming psi_group structure member fields used for calculating psi totals
and averages for clear distinction between them and trigger-related fields
that will be added next.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/psi_types.h | 14 ++++++-------
 kernel/sched/psi.c        | 41 ++++++++++++++++++++-------------------
 2 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index 762c6bb16f3c..4d1c1f67be18 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -69,17 +69,17 @@ struct psi_group_cpu {
 };
 
 struct psi_group {
-	/* Protects data updated during an aggregation */
-	struct mutex stat_lock;
+	/* Protects data used by the aggregator */
+	struct mutex avgs_lock;
 
 	/* Per-cpu task state & time tracking */
 	struct psi_group_cpu __percpu *pcpu;
 
-	/* Periodic aggregation state */
-	u64 total_prev[NR_PSI_STATES - 1];
-	u64 last_update;
-	u64 next_update;
-	struct delayed_work clock_work;
+	/* Running pressure averages */
+	u64 avg_total[NR_PSI_STATES - 1];
+	u64 avg_last_update;
+	u64 avg_next_update;
+	struct delayed_work avgs_work;
 
 	/* Total stall times and sampled pressure averages */
 	u64 total[NR_PSI_STATES - 1];
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 281702de9772..4fb4d9913bc8 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -165,7 +165,7 @@ static struct psi_group psi_system = {
 	.pcpu = &system_group_pcpu,
 };
 
-static void psi_update_work(struct work_struct *work);
+static void psi_avgs_work(struct work_struct *work);
 
 static void group_init(struct psi_group *group)
 {
@@ -173,9 +173,9 @@ static void group_init(struct psi_group *group)
 
 	for_each_possible_cpu(cpu)
 		seqcount_init(&per_cpu_ptr(group->pcpu, cpu)->seq);
-	group->next_update = sched_clock() + psi_period;
-	INIT_DELAYED_WORK(&group->clock_work, psi_update_work);
-	mutex_init(&group->stat_lock);
+	group->avg_next_update = sched_clock() + psi_period;
+	INIT_DELAYED_WORK(&group->avgs_work, psi_avgs_work);
+	mutex_init(&group->avgs_lock);
 }
 
 void __init psi_init(void)
@@ -278,7 +278,7 @@ static bool update_stats(struct psi_group *group)
 	int cpu;
 	int s;
 
-	mutex_lock(&group->stat_lock);
+	mutex_lock(&group->avgs_lock);
 
 	/*
 	 * Collect the per-cpu time buckets and average them into a
@@ -319,7 +319,7 @@ static bool update_stats(struct psi_group *group)
 
 	/* avgX= */
 	now = sched_clock();
-	expires = group->next_update;
+	expires = group->avg_next_update;
 	if (now < expires)
 		goto out;
 	if (now - expires >= psi_period)
@@ -332,14 +332,14 @@ static bool update_stats(struct psi_group *group)
 	 * But the deltas we sample out of the per-cpu buckets above
 	 * are based on the actual time elapsing between clock ticks.
 	 */
-	group->next_update = expires + ((1 + missed_periods) * psi_period);
-	period = now - (group->last_update + (missed_periods * psi_period));
-	group->last_update = now;
+	group->avg_next_update = expires + ((1 + missed_periods) * psi_period);
+	period = now - (group->avg_last_update + (missed_periods * psi_period));
+	group->avg_last_update = now;
 
 	for (s = 0; s < NR_PSI_STATES - 1; s++) {
 		u32 sample;
 
-		sample = group->total[s] - group->total_prev[s];
+		sample = group->total[s] - group->avg_total[s];
 		/*
 		 * Due to the lockless sampling of the time buckets,
 		 * recorded time deltas can slip into the next period,
@@ -359,22 +359,22 @@ static bool update_stats(struct psi_group *group)
 		 */
 		if (sample > period)
 			sample = period;
-		group->total_prev[s] += sample;
+		group->avg_total[s] += sample;
 		calc_avgs(group->avg[s], missed_periods, sample, period);
 	}
 out:
-	mutex_unlock(&group->stat_lock);
+	mutex_unlock(&group->avgs_lock);
 	return nonidle_total;
 }
 
-static void psi_update_work(struct work_struct *work)
+static void psi_avgs_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct psi_group *group;
 	bool nonidle;
 
 	dwork = to_delayed_work(work);
-	group = container_of(dwork, struct psi_group, clock_work);
+	group = container_of(dwork, struct psi_group, avgs_work);
 
 	/*
 	 * If there is task activity, periodically fold the per-cpu
@@ -391,8 +391,9 @@ static void psi_update_work(struct work_struct *work)
 		u64 now;
 
 		now = sched_clock();
-		if (group->next_update > now)
-			delay = nsecs_to_jiffies(group->next_update - now) + 1;
+		if (group->avg_next_update > now)
+			delay = nsecs_to_jiffies(
+					group->avg_next_update - now) + 1;
 		schedule_delayed_work(dwork, delay);
 	}
 }
@@ -546,13 +547,13 @@ void psi_task_change(struct task_struct *task, int clear, int set)
 	 */
 	if (unlikely((clear & TSK_RUNNING) &&
 		     (task->flags & PF_WQ_WORKER) &&
-		     wq_worker_last_func(task) == psi_update_work))
+		     wq_worker_last_func(task) == psi_avgs_work))
 		wake_clock = false;
 
 	while ((group = iterate_groups(task, &iter))) {
 		psi_group_change(group, cpu, clear, set);
-		if (wake_clock && !delayed_work_pending(&group->clock_work))
-			schedule_delayed_work(&group->clock_work, PSI_FREQ);
+		if (wake_clock && !delayed_work_pending(&group->avgs_work))
+			schedule_delayed_work(&group->avgs_work, PSI_FREQ);
 	}
 }
 
@@ -649,7 +650,7 @@ void psi_cgroup_free(struct cgroup *cgroup)
 	if (static_branch_likely(&psi_disabled))
 		return;
 
-	cancel_delayed_work_sync(&cgroup->psi.clock_work);
+	cancel_delayed_work_sync(&cgroup->psi.avgs_work);
 	free_percpu(cgroup->psi.pcpu);
 }
 
-- 
2.21.0.360.g471c308f928-goog

