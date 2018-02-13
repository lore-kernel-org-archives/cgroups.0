From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH V3 03/10] sched/core: Streamlining calls to task_rq_unlock()
Date: Tue, 13 Feb 2018 13:32:40 -0700
Message-ID: <1518553967-20656-4-git-send-email-mathieu.poirier@linaro.org>
References: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S3I4UClItunArMEru3vMQ88fmU6Nz0gQ2VdpI9jpZQY=;
        b=FEG0+189JD6VN92BeoE8zOln/oYsEsbujAq+wLmMjvwxALcbnp1/LnfILBg+60W9pV
         iK3+6S8YBsEA5OMEi7gnZN7ndczKhp5K0tluAdkwOiO2G/+5/I8OTnBPWD4iYyLEjmri
         2K2QUBOnEdGQT7f60KgJCy1rI+DNkhUkg4bUA=
In-Reply-To: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org
Cc: lizefan@huawei.com, mingo@redhat.com, rostedt@goodmis.org, claudio@evidence.eu.com, bristot@redhat.com, tommaso.cucinotta@santannapisa.it, juri.lelli@redhat.com, luca.abeni@santannapisa.it, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Calls to task_rq_unlock() are done several times in function
__sched_setscheduler().  This is fine when only the rq lock needs to be
handled but not so much when other locks come into play.

This patch streamline the release of the rq lock so that only one location
need to be modified when dealing with more than one lock.

No change of functionality is introduced by this patch.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 kernel/sched/core.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bf724c1952ea..f727c3d0064c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4189,8 +4189,8 @@ static int __sched_setscheduler(struct task_struct *p,
 	 * Changing the policy of the stop threads its a very bad idea:
 	 */
 	if (p == rq->stop) {
-		task_rq_unlock(rq, p, &rf);
-		return -EINVAL;
+		retval = -EINVAL;
+		goto unlock;
 	}
 
 	/*
@@ -4206,8 +4206,8 @@ static int __sched_setscheduler(struct task_struct *p,
 			goto change;
 
 		p->sched_reset_on_fork = reset_on_fork;
-		task_rq_unlock(rq, p, &rf);
-		return 0;
+		retval = 0;
+		goto unlock;
 	}
 change:
 
@@ -4220,8 +4220,8 @@ static int __sched_setscheduler(struct task_struct *p,
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
@@ -4236,8 +4236,8 @@ static int __sched_setscheduler(struct task_struct *p,
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
@@ -4256,8 +4256,8 @@ static int __sched_setscheduler(struct task_struct *p,
 	 * is available.
 	 */
 	if ((dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
-		task_rq_unlock(rq, p, &rf);
-		return -EBUSY;
+		retval = -EBUSY;
+		goto unlock;
 	}
 
 	p->sched_reset_on_fork = reset_on_fork;
@@ -4313,6 +4313,10 @@ static int __sched_setscheduler(struct task_struct *p,
 	preempt_enable();
 
 	return 0;
+
+unlock:
+	task_rq_unlock(rq, p, &rf);
+	return retval;
 }
 
 static int _sched_setscheduler(struct task_struct *p, int policy,
-- 
2.7.4

