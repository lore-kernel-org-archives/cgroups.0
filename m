From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v2 4/5] psi: rename psi fields in preparation for psi trigger addition
Date: Thu, 10 Jan 2019 14:07:17 -0800
Message-ID: <20190110220718.261134-5-surenb@google.com>
References: <20190110220718.261134-1-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gvi1iRKLPW3qMsLI6kumJKUVDFg5NUDF94Fa5S4jUjU=;
        b=OdfmzDI9CcL+2VXf5ocSTDNyRd9IHxsxjkC2PxQORGPsj0X7psQuS3Umk7pGcF+y1N
         2erlFLdCgBeLM6sKPD7UtLOkmNwDY3Q8+bYqlRpPzxYaWaUO9Ku8vgf0RYaWAZcgeQDp
         +OycaSHT78G3F5f1FH0QvE8CIaRHZ77mkmp4zAhGBT3h+OnHhOI95bD1lAbzndzCJcN8
         kAYejfjaXIKLAAr8fN6d+3sQPM/sqCNbQm4TKt/fmoxpEaDlXqQnfBs/W76fh5Si1HRb
         2Ywu2dMPM2Aw/LeKx3cXLOODPCznDtA+9g6oDheS4QVxUuvqwreMha9jFWiYakAAlmvd
         BQvA==
In-Reply-To: <20190110220718.261134-1-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, Suren Baghdasaryan <surenb@google.com>

Renaming psi_group structure member fields used for calculating psi
totals and averages for clear distinction between them and trigger-related
fields that will be added next.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/psi_types.h | 15 ++++++++-------
 kernel/sched/psi.c        | 26 ++++++++++++++------------
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index 762c6bb16f3c..47757668bdcb 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -69,20 +69,21 @@ struct psi_group_cpu {
 };
 
 struct psi_group {
-	/* Protects data updated during an aggregation */
-	struct mutex stat_lock;
+	/* Protects data used by the aggregator */
+	struct mutex update_lock;
 
 	/* Per-cpu task state & time tracking */
 	struct psi_group_cpu __percpu *pcpu;
 
-	/* Periodic aggregation state */
-	u64 total_prev[NR_PSI_STATES - 1];
-	u64 last_update;
-	u64 next_update;
 	struct delayed_work clock_work;
 
-	/* Total stall times and sampled pressure averages */
+	/* Total stall times observed */
 	u64 total[NR_PSI_STATES - 1];
+
+	/* Running pressure averages */
+	u64 avg_total[NR_PSI_STATES - 1];
+	u64 avg_last_update;
+	u64 avg_next_update;
 	unsigned long avg[NR_PSI_STATES - 1][3];
 };
 
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 2262d920295f..c366503ba135 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -172,9 +172,9 @@ static void group_init(struct psi_group *group)
 
 	for_each_possible_cpu(cpu)
 		seqcount_init(&per_cpu_ptr(group->pcpu, cpu)->seq);
-	group->next_update = sched_clock() + psi_period;
+	group->avg_next_update = sched_clock() + psi_period;
 	INIT_DELAYED_WORK(&group->clock_work, psi_update_work);
-	mutex_init(&group->stat_lock);
+	mutex_init(&group->update_lock);
 }
 
 void __init psi_init(void)
@@ -277,7 +277,7 @@ static bool update_stats(struct psi_group *group)
 	int cpu;
 	int s;
 
-	mutex_lock(&group->stat_lock);
+	mutex_lock(&group->update_lock);
 
 	/*
 	 * Collect the per-cpu time buckets and average them into a
@@ -318,7 +318,7 @@ static bool update_stats(struct psi_group *group)
 
 	/* avgX= */
 	now = sched_clock();
-	expires = group->next_update;
+	expires = group->avg_next_update;
 	if (now < expires)
 		goto out;
 	if (now - expires > psi_period)
@@ -331,14 +331,14 @@ static bool update_stats(struct psi_group *group)
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
@@ -358,11 +358,11 @@ static bool update_stats(struct psi_group *group)
 		 */
 		if (sample > period)
 			sample = period;
-		group->total_prev[s] += sample;
+		group->avg_total[s] += sample;
 		calc_avgs(group->avg[s], missed_periods, sample, period);
 	}
 out:
-	mutex_unlock(&group->stat_lock);
+	mutex_unlock(&group->update_lock);
 	return nonidle_total;
 }
 
@@ -390,8 +390,10 @@ static void psi_update_work(struct work_struct *work)
 		u64 now;
 
 		now = sched_clock();
-		if (group->next_update > now)
-			delay = nsecs_to_jiffies(group->next_update - now) + 1;
+		if (group->avg_next_update > now) {
+			delay = nsecs_to_jiffies(
+				group->avg_next_update - now) + 1;
+		}
 		schedule_delayed_work(dwork, delay);
 	}
 }
-- 
2.20.1.97.g81188d93c3-goog

