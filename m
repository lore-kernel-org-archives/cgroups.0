From: Tejun Heo <tj@kernel.org>
Subject: [PATCH wq/for-4.16 2/2] workqueue: allow WQ_MEM_RECLAIM on early
 init workqueues
Date: Mon, 8 Jan 2018 05:47:52 -0800
Message-ID: <20180108134752.GO3668920@devbig577.frc2.facebook.com>
References: <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
 <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
 <20180102174408.GM7829@linux.vnet.ibm.com>
 <20180102180119.GA1355@linux.vnet.ibm.com>
 <20180108122823.GL3668920@devbig577.frc2.facebook.com>
 <20180108134720.GN3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MFhgT3k76oj6O0R5Pp7kqyDrGqoUemYm2xyFOaZyW88=;
        b=ttDyCGifk6HrnsdArA/mkM6CFKAXH5LUiN9kXUctFM+VFLGr2G5aktu4BN0jMR/d0i
         2I6/pPs91vW1DLPUaa68+EFynkN/6iXhdAekJLlxNQJd6dLL7+RCMlWksabKa3/vXnJJ
         +vlBZaOtKRCZwGF5eHlMt65ZmEOygU34X9Pw7pFE9IeITnHoArZD6uHJTTNwGt8e5MeU
         wTX0ho+B07UZm1ZaJIGQLQiRSJgSnJX1WWrd4wwH01l3+wObG272bLDYcnCwjGRUjx0+
         AlZm6TUBLc/lQr9xMgHIsgTIaJGRVVWTOpBIjpGr0A1BCIDnmaWMYbL02lygPkUPr2Xr
         iLyg==
Content-Disposition: inline
In-Reply-To: <20180108134720.GN3668920@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Prateek Sood <prsood@codeaurora.org>, Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

From 40c17f75dfa9ec163478efd3f7443fd6af9992c9 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 8 Jan 2018 05:38:37 -0800

Workqueues can be created early during boot before workqueue subsystem
in fully online - work items are queued waiting for later full
initialization.  However, early init wasn't supported for
WQ_MEM_RECLAIM workqueues causing unnecessary annoyances for a subset
of users.  Expand early init support to include WQ_MEM_RECLAIM
workqueues.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/workqueue.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5baac7c..c86cc1e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4032,7 +4032,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	if (alloc_and_link_pwqs(wq) < 0)
 		goto err_free_wq;
 
-	if (init_rescuer(wq) < 0)
+	if (wq_online && init_rescuer(wq) < 0)
 		goto err_destroy;
 
 	if ((wq->flags & WQ_SYSFS) && workqueue_sysfs_register(wq))
@@ -5639,6 +5639,8 @@ int __init workqueue_init(void)
 	 * archs such as power and arm64.  As per-cpu pools created
 	 * previously could be missing node hint and unbound pools NUMA
 	 * affinity, fix them up.
+	 *
+	 * Also, while iterating workqueues, create rescuers if requested.
 	 */
 	wq_numa_init();
 
@@ -5650,8 +5652,12 @@ int __init workqueue_init(void)
 		}
 	}
 
-	list_for_each_entry(wq, &workqueues, list)
+	list_for_each_entry(wq, &workqueues, list) {
 		wq_update_unbound_numa(wq, smp_processor_id(), true);
+		WARN(init_rescuer(wq),
+		     "workqueue: failed to create early rescuer for %s",
+		     wq->name);
+	}
 
 	mutex_unlock(&wq_pool_mutex);
 
-- 
2.9.5

