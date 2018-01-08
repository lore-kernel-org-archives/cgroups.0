From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH wq/for-4.16 1/2] workqueue: separate out init_rescuer()
Date: Mon, 8 Jan 2018 05:47:20 -0800
Message-ID: <20180108134720.GN3668920@devbig577.frc2.facebook.com>
References: <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
 <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
 <20180102174408.GM7829@linux.vnet.ibm.com>
 <20180102180119.GA1355@linux.vnet.ibm.com>
 <20180108122823.GL3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iucRPZwT3ih5mU9ebas6KZhkEXhjL2GSaCt1D1MZTrI=;
        b=QPqSqd4B0EVsC8URtMDH94lVtE+bjUcRq1EFRqdUXnvmNexyYQscU1uDn3Np1/JooL
         ONyulrRApJK9Wg1IWYpmgmPBWCjKI8P2ZGCqOoGRfdxiGo27EkuoiMjDCVEbgrpfl6U9
         JOvEKMfoSa45ZPwMSkGR+uB4sOf77+IkCSHCVuX+ljaFk4NlPgKi2wcpGOaVycwxXuxl
         3bcCNrWm22uAUhQvmh2AHK72aIjMcAq2nhu26atoa7jw/aLpu0v3y3p9Zh6dg7URH/Jo
         SZL3a64QqeSDwFtvChp1546rtIa/B31jtjodLCxvtzqAXKkB8A2Q/x1yY7khb40WZRCU
         JRhQ==
Content-Disposition: inline
In-Reply-To: <20180108122823.GL3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

Hello, Paul.

Applied the following two patches to allow early init of
WQ_MEM_RECLAIM workqueues to the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-4.16

The branch won't be rebased and currently only contains these two
patches.  Please feel free to pull and put further RCU changes on top.

Thanks.

------ 8< ------
From 983c751532738b83c4c5b51192ebc6fbfe9330f7 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 8 Jan 2018 05:38:32 -0800

Separate out init_rescuer() from __alloc_workqueue_key() to prepare
for early init support for WQ_MEM_RECLAIM.  This patch doesn't
introduce any functional changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 kernel/workqueue.c | 56 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 43d18cb..5baac7c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3939,6 +3939,37 @@ static int wq_clamp_max_active(int max_active, unsigned int flags,
 	return clamp_val(max_active, 1, lim);
 }
 
+/*
+ * Workqueues which may be used during memory reclaim should have a rescuer
+ * to guarantee forward progress.
+ */
+static int init_rescuer(struct workqueue_struct *wq)
+{
+	struct worker *rescuer;
+	int ret;
+
+	if (!(wq->flags & WQ_MEM_RECLAIM))
+		return 0;
+
+	rescuer = alloc_worker(NUMA_NO_NODE);
+	if (!rescuer)
+		return -ENOMEM;
+
+	rescuer->rescue_wq = wq;
+	rescuer->task = kthread_create(rescuer_thread, rescuer, "%s", wq->name);
+	ret = PTR_ERR_OR_ZERO(rescuer->task);
+	if (ret) {
+		kfree(rescuer);
+		return ret;
+	}
+
+	wq->rescuer = rescuer;
+	kthread_bind_mask(rescuer->task, cpu_possible_mask);
+	wake_up_process(rescuer->task);
+
+	return 0;
+}
+
 struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 					       unsigned int flags,
 					       int max_active,
@@ -4001,29 +4032,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	if (alloc_and_link_pwqs(wq) < 0)
 		goto err_free_wq;
 
-	/*
-	 * Workqueues which may be used during memory reclaim should
-	 * have a rescuer to guarantee forward progress.
-	 */
-	if (flags & WQ_MEM_RECLAIM) {
-		struct worker *rescuer;
-
-		rescuer = alloc_worker(NUMA_NO_NODE);
-		if (!rescuer)
-			goto err_destroy;
-
-		rescuer->rescue_wq = wq;
-		rescuer->task = kthread_create(rescuer_thread, rescuer, "%s",
-					       wq->name);
-		if (IS_ERR(rescuer->task)) {
-			kfree(rescuer);
-			goto err_destroy;
-		}
-
-		wq->rescuer = rescuer;
-		kthread_bind_mask(rescuer->task, cpu_possible_mask);
-		wake_up_process(rescuer->task);
-	}
+	if (init_rescuer(wq) < 0)
+		goto err_destroy;
 
 	if ((wq->flags & WQ_SYSFS) && workqueue_sysfs_register(wq))
 		goto err_destroy;
-- 
2.9.5
