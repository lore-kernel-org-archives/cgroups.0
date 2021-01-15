From: wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] tg: add cpu's wait_count of a task group
Date: Fri, 15 Jan 2021 22:30:05 +0800
Message-ID: <20210115143005.7071-1-wu860403@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YbRVLfFTFl245PvcYNPKPfmfRYJ/Oj1+0NVhnOPy8iU=;
        b=Ghj6FPYnkt4QNhyG8f5qpS/3xRNhmYk713fFOsUclYgV8W6X3ODPPvTONsfAE6Ns99
         PWmhEPT+kRkE847fTjGxhm9VGvvIAl/1vKEYQNXtfwI31sGqkhuuAu5egc01RkRYISi8
         ZLCYv1WoFL8s2wB/JYT5lIGi9/VxJRobm/S6qy3vWc0/Bpc44+XpB1Pf0Lkoe1xQonHv
         /VCTtKiOtfuFkxwEjLZDaRg46tG5hqU26y3hTiP/jK5rDQF9IXA65YV/BAgrfWuj7Zi1
         TVdobsmszfGP3oojf0UHV7Dez0UcIw0gqqJUtpfQ175lqtTiIWAUmNaFgS8fME/9YoFK
         0Izg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 398776277-9uewiaClKEY@public.gmane.org
Cc: Liming Wu <wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Liming Wu <wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Now we can rely on PSI to reflect whether there is contention in
the task group, but it cannot reflect the details of the contention.
Through this metric, we can get details of task group contention
 from the dimension of scheduling.
   delta(wait_sum)/delta(wait_count)

Also unified the cpu.stat output of cgroup v1 and v2

Signed-off-by Liming Wu <19092205-t/fWbKJQg0/QT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/core.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e7e453492..e7ff47436 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8139,19 +8139,29 @@ static int cpu_cfs_stat_show(struct seq_file *sf, void *v)
 {
 	struct task_group *tg = css_tg(seq_css(sf));
 	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+	u64 throttled_usec;
 
-	seq_printf(sf, "nr_periods %d\n", cfs_b->nr_periods);
-	seq_printf(sf, "nr_throttled %d\n", cfs_b->nr_throttled);
-	seq_printf(sf, "throttled_time %llu\n", cfs_b->throttled_time);
+	throttled_usec = cfs_b->throttled_time;
+	do_div(throttled_usec, NSEC_PER_USEC);
+
+	seq_printf(sf, "nr_periods %d\n"
+		   "nr_throttled %d\n"
+		   "throttled_usec %llu\n",
+		   cfs_b->nr_periods, cfs_b->nr_throttled,
+		   throttled_usec);
 
 	if (schedstat_enabled() && tg != &root_task_group) {
 		u64 ws = 0;
+		u64 wc = 0;
 		int i;
 
-		for_each_possible_cpu(i)
+		for_each_possible_cpu(i) {
 			ws += schedstat_val(tg->se[i]->statistics.wait_sum);
+			wc += schedstat_val(tg->se[i]->statistics.wait_count);
+		}
 
-		seq_printf(sf, "wait_sum %llu\n", ws);
+		seq_printf(sf, "wait_sum %llu\n"
+			"wait_count %llu\n", ws, wc);
 	}
 
 	return 0;
@@ -8255,6 +8265,19 @@ static int cpu_extra_stat_show(struct seq_file *sf,
 			   "throttled_usec %llu\n",
 			   cfs_b->nr_periods, cfs_b->nr_throttled,
 			   throttled_usec);
+		if (schedstat_enabled() && tg != &root_task_group) {
+			u64 ws = 0;
+			u64 wc = 0;
+			int i;
+
+			for_each_possible_cpu(i) {
+				ws += schedstat_val(tg->se[i]->statistics.wait_sum);
+				wc += schedstat_val(tg->se[i]->statistics.wait_count);
+			}
+
+			seq_printf(sf, "wait_sum %llu\n"
+				"wait_count %llu\n", ws, wc);
+		}
 	}
 #endif
 	return 0;
-- 
2.20.1

