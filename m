From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH v4 3/5] sched/core: Streamlining calls to task_rq_unlock()
Date: Wed, 13 Jun 2018 14:17:09 +0200
Message-ID: <20180613121711.5018-4-juri.lelli@redhat.com>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613121711.5018-1-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Calls to task_rq_unlock() are done several times in function
__sched_setscheduler().  This is fine when only the rq lock needs to be
handled but not so much when other locks come into play.

This patch streamlines the release of the rq lock so that only one
location need to be modified when dealing with more than one lock.

No change of functionality is introduced by this patch.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 kernel/sched/core.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d1555185c054..ca788f74259d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4237,8 +4237,8 @@ static int __sched_setscheduler(struct task_struct *p,
 	 * Changing the policy of the stop threads its a very bad idea:
 	 */
 	if (p == rq->stop) {
-		task_rq_unlock(rq, p, &rf);
-		return -EINVAL;
+		retval = -EINVAL;
+		goto unlock;
 	}
 
 	/*
@@ -4254,8 +4254,8 @@ static int __sched_setscheduler(struct task_struct *p,
 			goto change;
 
 		p->sched_reset_on_fork = reset_on_fork;
-		task_rq_unlock(rq, p, &rf);
-		return 0;
+		retval = 0;
+		goto unlock;
 	}
 change:
 
@@ -4268,8 +4268,8 @@ static int __sched_setscheduler(struct task_struct *p,
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
 				task_group(p)->rt_bandwidth.rt_runtime == 0 &&
 				!task_group_is_autogroup(task_group(p))) {
-			task_rq_unlock(rq, p, &rf);
-			return -EPERM;
+			retval = -EPERM;
+			goto unlock;
 		}
 #endif
 #ifdef CONFIG_SMP
@@ -4284,8 +4284,8 @@ static int __sched_setscheduler(struct task_struct *p,
 			 */
 			if (!cpumask_subset(span, &p->cpus_allowed) ||
 			    rq->rd->dl_bw.bw == 0) {
-				task_rq_unlock(rq, p, &rf);
-				return -EPERM;
+				retval = -EPERM;
+				goto unlock;
 			}
 		}
 #endif
@@ -4304,8 +4304,8 @@ static int __sched_setscheduler(struct task_struct *p,
 	 * is available.
 	 */
 	if ((dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
-		task_rq_unlock(rq, p, &rf);
-		return -EBUSY;
+		retval = -EBUSY;
+		goto unlock;
 	}
 
 	p->sched_reset_on_fork = reset_on_fork;
@@ -4361,6 +4361,10 @@ static int __sched_setscheduler(struct task_struct *p,
 	preempt_enable();
 
 	return 0;
+
+unlock:
+	task_rq_unlock(rq, p, &rf);
+	return retval;
 }
 
 static int _sched_setscheduler(struct task_struct *p, int policy,
-- 
2.14.3

