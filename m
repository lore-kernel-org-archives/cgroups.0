From: Odin Ugedal <odin@uged.al>
Subject: [PATCH 3/3] sched/fair: Fix ascii art by relpacing tabs
Date: Tue, 18 May 2021 14:52:02 +0200
Message-ID: <20210518125202.78658-4-odin@uged.al>
References: <20210518125202.78658-1-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cWKAKWFCOFChPGwAbKymaVFn6SZ1ozwG8tvGIzigvls=;
        b=T4f1OcTND4D2vmi8JrodCfZl8q4Pm5TExZMTTG1Zoxr0hAiQtEtmblc5RhdE04AjQ0
         rJApzDKqbiryagcoQe9DeVMsABy3iXA6PD9KQfZk2sVnoWJ+Eecgxauaeqy+GqMzTuo6
         EO0qyzYY68FZxf6F1RMfexc+NvYh8lAgQ81QCLFCDskgs3MMvFrIyqz5P0aPCbzuwglN
         PJWTk2TfAaSKhT2z/qD3Kp2rIK/317slxAI6Nt9xHIILSOUdyvIvjy9NF4oELjeq42Ox
         n+j/AYmuO9qhzKEtkXpEnFIoQNdDRTUv94zP/zNPz5ynLwPQ4crOOB8PTtKhJNoRIZq8
         A+mg==
In-Reply-To: <20210518125202.78658-1-odin@uged.al>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Odin Ugedal <odin@uged.al>

When using something other than 8 spaces per tab, this ascii art
makes not sense, and the reader might end up wondering what this
advanced equation "is".

Signed-off-by: Odin Ugedal <odin@uged.al>
---
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e7423d658389..c872e38ec32b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3142,7 +3142,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->load.weight
  *   ge->load.weight = -----------------------------               (1)
- *			  \Sum grq->load.weight
+ *                       \Sum grq->load.weight
  *
  * Now, because computing that sum is prohibitively expensive to compute (been
  * there, done that) we approximate it with this average stuff. The average
@@ -3156,7 +3156,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->avg.load_avg
  *   ge->load.weight = ------------------------------              (3)
- *				tg->load_avg
+ *                             tg->load_avg
  *
  * Where: tg->load_avg ~= \Sum grq->avg.load_avg
  *
@@ -3172,7 +3172,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->load.weight
  *   ge->load.weight = ----------------------------- = tg->weight   (4)
- *			    grp->load.weight
+ *                         grp->load.weight
  *
  * That is, the sum collapses because all other CPUs are idle; the UP scenario.
  *
@@ -3191,7 +3191,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->load.weight
  *   ge->load.weight = -----------------------------		   (6)
- *				tg_load_avg'
+ *                             tg_load_avg'
  *
  * Where:
  *
-- 
2.31.1

