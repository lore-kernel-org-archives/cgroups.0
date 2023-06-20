From: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 1/2] sched: don't account throttle time for empty groups
Date: Tue, 20 Jun 2023 11:32:46 -0700
Message-ID: <20230620183247.737942-1-joshdon@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687285981; x=1689877981;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sBPwNjci+mVKgvTGGSvenUmGifZY3Myji5qjgOuCzdY=;
        b=CV163j2PUGaavyM9SvGsrlqZLN2xBHrKdDynwlJOjsbY0BnCYcw8OuXxIYqTcePd/4
         75NNiIVKAORJDQqeVbt8R+SXRThRGQvhEqlcna+1G+zhYFac2tqz+Kx++pU6u41NWRnI
         IzUsvovlGgT4EJdq0PTaZ4Dm0WIXjBtD0wLcnJDoVjgRFlPCmyTU8VsNYLZJDmPqxxCL
         OT/TGrpF+2O7PaMxGBI6yeul6VwI9pwRx5/fUXqA3PQO4hd7oy3cRJyi66jJCV40Dd2x
         EjZ+GR+fkHQuIwCMlkwh6W3+frRhMueAcukods0XG7+nZMO2shq9cUUTv+JNlJgKJmLI
         hdkw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

It is easy for a cfs_rq to become throttled even when it has no enqueued
entities (for example, if we have just put_prev()'d the last runnable
task of the cfs_rq, and the cfs_rq is out of quota).

Avoid accounting this time towards total throttle time, since it
otherwise falsely inflates the stats.

Note that the dequeue path is special, since we normally disallow
migrations when a task is in a throttled hierarchy (see
throttled_lb_pair()).

Signed-off-by: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
v3: fix bug with nested limits
 kernel/sched/fair.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6189d1a45635..72571d48559a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4787,6 +4787,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 }
 
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq);
 
 static inline bool cfs_bandwidth_used(void);
 
@@ -4873,8 +4874,14 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 	if (cfs_rq->nr_running == 1) {
 		check_enqueue_throttle(cfs_rq);
-		if (!throttled_hierarchy(cfs_rq))
+		if (!throttled_hierarchy(cfs_rq)) {
 			list_add_leaf_cfs_rq(cfs_rq);
+		} else {
+#ifdef CONFIG_CFS_BANDWIDTH
+			if (cfs_rq_throttled(cfs_rq) && !cfs_rq->throttled_clock)
+				cfs_rq->throttled_clock = rq_clock(rq_of(cfs_rq));
+#endif
+		}
 	}
 }
 
@@ -5480,7 +5487,9 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	 * throttled-list.  rq->lock protects completion.
 	 */
 	cfs_rq->throttled = 1;
-	cfs_rq->throttled_clock = rq_clock(rq);
+	SCHED_WARN_ON(cfs_rq->throttled_clock);
+	if (cfs_rq->nr_running)
+		cfs_rq->throttled_clock = rq_clock(rq);
 	return true;
 }
 
@@ -5498,7 +5507,10 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	update_rq_clock(rq);
 
 	raw_spin_lock(&cfs_b->lock);
-	cfs_b->throttled_time += rq_clock(rq) - cfs_rq->throttled_clock;
+	if (cfs_rq->throttled_clock) {
+		cfs_b->throttled_time += rq_clock(rq) - cfs_rq->throttled_clock;
+		cfs_rq->throttled_clock = 0;
+	}
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
 
-- 
2.41.0.162.gfafddb0af9-goog

