From: wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH V2] tg: add sched wait_count of a task group
Date: Fri, 22 Jan 2021 04:11:57 +0800
Message-ID: <20210121201157.1933-1-wu860403@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=00EJOlGNqegMy5hWj3ItO3z7nmI6UcSXmhSyNLe26rA=;
        b=Tpb68P6eh9RtW9ZhJwuC5B/7Aj+ZcjD8RwvLQuwoYlLwq/++4HrqNwWBiByaQYuCm0
         5rJ6ffcjoutyckNMCnTx5L+fQNtdqgnu72Ps/43BQHDTXZ4Bh5Fp+vqsw9N5XxlsVs/R
         hAwEet96Bu1G3nmsVE5V4LDFNd988ALXH3K7+A/iVOn7cdZevK2tz7CxhKIGSs/dX206
         6hC9ekk9a+UaZ3Z6ryoi7bzoov1BnqdxC3X5LEIvjQ8JdL57Sf2/EJAKgD1/5zoZddFO
         tuK9zXzQ3TJJ6c9J0P7v6Gl+Nwb/68bNk4nmIBDQX1fJ2yDMBZXYw04MUxSd33dzsnQK
         jddg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, 398776277-9uewiaClKEY@public.gmane.org, Liming Wu <wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Liming Wu <wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Now we can rely on PSI to reflect whether there is contention in
the task group, but it cannot reflect the details of the contention.
Through this metric, we can get avg latency of task group contention
 from the dimension of scheduling.
   delta(wait_usec)/delta(nr_waits)
Also change wait_sum to wait_usec.

Signed-off-by Liming Wu <wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/sched/core.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e7e453492..45e46114e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8146,12 +8146,17 @@ static int cpu_cfs_stat_show(struct seq_file *sf, void *v)
 
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
+		do_div(ws, NSEC_PER_USEC);
+		seq_printf(sf, "wait_usec %llu\n"
+			   "nr_waits %llu\n", ws, wc);
 	}
 
 	return 0;
@@ -8255,6 +8260,20 @@ static int cpu_extra_stat_show(struct seq_file *sf,
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
+			do_div(ws, NSEC_PER_USEC);
+			seq_printf(sf, "wait_usec %llu\n"
+				   "nr_waits %llu\n", ws, wc);
+		}
 	}
 #endif
 	return 0;
-- 
2.20.1

