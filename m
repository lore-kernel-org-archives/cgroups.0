From: Glauber Costa <glommer@openvz.org>
Subject: [PATCH v7 04/11] sched: adjust exec_clock to use it as cpu usage metric
Date: Wed, 29 May 2013 15:03:15 +0400
Message-ID: <1369825402-31046-5-git-send-email-glommer@openvz.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org, Glauber Costa <glommer@openvz.org>, Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, Lennart Poettering <lennart@poettering.net>, Kay Sievers <kay.sievers@vrfy.org>

exec_clock already provides per-group cpu usage metrics, and can be
reused by cpuacct in case cpu and cpuacct are comounted.

However, it is only provided by tasks in fair class. Doing the same for
rt is easy, and can be done in an already existing hierarchy loop. This
is an improvement over the independent hierarchy walk executed by
cpuacct.

Signed-off-by: Glauber Costa <glommer@openvz.org>
CC: Dave Jones <davej@redhat.com>
CC: Ben Hutchings <ben@decadent.org.uk>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>
CC: Lennart Poettering <lennart@poettering.net>
CC: Kay Sievers <kay.sievers@vrfy.org>
CC: Tejun Heo <tj@kernel.org>
---
 kernel/sched/rt.c    | 1 +
 kernel/sched/sched.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e9f8dcd..4a21045 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -907,6 +907,7 @@ static void update_curr_rt(struct rq *rq)
 
 	for_each_sched_rt_entity(rt_se) {
 		rt_rq = rt_rq_of_se(rt_se);
+		schedstat_add(rt_rq, exec_clock, delta_exec);
 
 		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
 			raw_spin_lock(&rt_rq->rt_runtime_lock);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 765c687..b05dd84 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -254,6 +254,7 @@ struct cfs_rq {
 	unsigned int nr_running, h_nr_running;
 
 	u64 exec_clock;
+	u64 prev_exec_clock;
 	u64 min_vruntime;
 #ifndef CONFIG_64BIT
 	u64 min_vruntime_copy;
@@ -356,6 +357,8 @@ struct rt_rq {
 	struct plist_head pushable_tasks;
 #endif
 	int rt_throttled;
+	u64 exec_clock;
+	u64 prev_exec_clock;
 	u64 rt_time;
 	u64 rt_runtime;
 	/* Nests inside the rq lock: */
-- 
1.8.1.4
