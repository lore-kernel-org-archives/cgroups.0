From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] mm: memcg: rename stats_flush_threshold to stats_updates_order
Date: Wed, 13 Sep 2023 07:38:45 +0000
Message-ID: <20230913073846.1528938-3-yosryahmed@google.com>
References: <20230913073846.1528938-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694590734; x=1695195534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3zT0hHZy8cis/iWPUQS68SvJSs9nRfkwgZ1RrbYh+5w=;
        b=z8BsSMMkcpxomBbaPryW+olQ3UQVLbWNQ4fOr1/+MTIUMoQH4cQsV+oiqV4atmjOW0
         iedsLMwd2fKtBeVG3fovUWiTkONwJ9bGazl6w+jRxcRGbWl58plni/H6lz1w+ehkYUp/
         9Y2DCfAAA5cvmwu485N+09B1zAZBefpR28YqMqsEyVCNiUqupmfcZtMwJar/oheTRJEb
         J2/3RtWTQdUjBMKHzFjwpWomkyIpvKscHcQk0nkkxRwY/m/b9ATqZw7u1HyN4OZrIDro
         vpRhi6cCZuULcSRNLz5KDJ1TLOPz3GKy0zMEES4ni0bW2WIZYwpIWXQnqprL2MBfhBli
         Gs1A==
In-Reply-To: <20230913073846.1528938-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

stats_flush_threshold is a misnomer. It is not actually a threshold, but
rather a number that represents the amount of updates that we have. It
is counted in multiples of MEMCG_CHARGE_BATCH. When this value reaches
num_online_cpus(), we flush the stats.

Hence, num_online_cpus() is the actual threshold, and
stats_flush_threshold is actually an order of the stats updates
magnitude. Rename stats_flush_threshold to stats_updates_order, and
define a STATS_FLUSH_THRESHOLD constant that resolves to
num_online_cpus().

No functional change intended.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 35a9c013d755..d729870505f1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -589,10 +589,12 @@ static void flush_memcg_stats_dwork(struct work_struct *w);
 static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
-static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
+/* stats_updates_order is in multiples of MEMCG_CHARGE_BATCH */
+static atomic_t stats_updates_order = ATOMIC_INIT(0);
 static u64 flush_last_time;
 
 #define FLUSH_TIME (2UL*HZ)
+#define STATS_FLUSH_THRESHOLD num_online_cpus()
 
 /*
  * Accessors to ensure that preemption is disabled on PREEMPT_RT because it can
@@ -628,13 +630,11 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 	x = __this_cpu_add_return(stats_updates, abs(val));
 	if (x > MEMCG_CHARGE_BATCH) {
 		/*
-		 * If stats_flush_threshold exceeds the threshold
-		 * (>num_online_cpus()), cgroup stats update will be triggered
-		 * in __mem_cgroup_flush_stats(). Increasing this var further
-		 * is redundant and simply adds overhead in atomic update.
+		 * Incrementing stats_updates_order beyond the threshold is
+		 * redundant. Avoid the overhead of the atomic update.
 		 */
-		if (atomic_read(&stats_flush_threshold) <= num_online_cpus())
-			atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
+		if (atomic_read(&stats_updates_order) <= STATS_FLUSH_THRESHOLD)
+			atomic_add(x / MEMCG_CHARGE_BATCH, &stats_updates_order);
 		__this_cpu_write(stats_updates, 0);
 	}
 }
@@ -654,13 +654,13 @@ static void do_flush_stats(void)
 
 	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
 
-	atomic_set(&stats_flush_threshold, 0);
+	atomic_set(&stats_updates_order, 0);
 	atomic_set(&stats_flush_ongoing, 0);
 }
 
 void mem_cgroup_flush_stats(void)
 {
-	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
+	if (atomic_read(&stats_updates_order) > STATS_FLUSH_THRESHOLD)
 		do_flush_stats();
 }
 
@@ -674,8 +674,8 @@ void mem_cgroup_flush_stats_ratelimited(void)
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	/*
-	 * Always flush here so that flushing in latency-sensitive paths is
-	 * as cheap as possible.
+	 * Deliberately ignore stats_updates_order here so that flushing in
+	 * latency-sensitive paths is as cheap as possible.
 	 */
 	do_flush_stats();
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
-- 
2.42.0.283.g2d96d420d3-goog

