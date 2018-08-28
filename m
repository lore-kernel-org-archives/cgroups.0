From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 7/9] sched: introduce this_rq_lock_irq()
Date: Tue, 28 Aug 2018 13:22:56 -0400
Message-ID: <20180828172258.3185-8-hannes@cmpxchg.org>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/su2Xrr3lQDX5ALOohq5KkDM3OQAwHC1+exX8OmH6ME=;
        b=i3VAVTElMSCvpvFUYOOStTltjA1/oebEvqEJgK2PA6DvRgVyiCOVmImPqaMHV76+HV
         VddU83sXNka2uP8uLhNarc3C2lzzvrReI+SbDrvTyIXsP1XFvdHCxca7/vPI1SBidGlY
         buQn7ZBYitfoffhdVUWFbLr+vurVJdCSRIuSjGWsRt7YkzUPvXNnKxEuNrJs5pgfggwY
         RrZ91V0TriiZsSKvcbz+7lBp8vJzlG7ATC8Hzb9YU5vFngGZvk7zApkQC2o8nIfrmqQF
         qtOwuR2A4xmDAYtk1lC721AXu4fK7f3FTCAYfodsCKjMhevrxlO/tVrioleIU4YRkO5d
         Luaw==
In-Reply-To: <20180828172258.3185-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

do_sched_yield() disables IRQs, looks up this_rq() and locks it. The
next patch is adding another site with the same pattern, so provide a
convenience function for it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/sched/core.c  |  4 +---
 kernel/sched/sched.h | 12 ++++++++++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fe365c9a08e9..61059e671fc6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4960,9 +4960,7 @@ static void do_sched_yield(void)
 	struct rq_flags rf;
 	struct rq *rq;
 
-	local_irq_disable();
-	rq = this_rq();
-	rq_lock(rq, &rf);
+	rq = this_rq_lock_irq(&rf);
 
 	schedstat_inc(rq->yld_count);
 	current->sched_class->yield_task(rq);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index eb9b1326906c..83db5de1464c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1126,6 +1126,18 @@ rq_unlock(struct rq *rq, struct rq_flags *rf)
 	raw_spin_unlock(&rq->lock);
 }
 
+static inline struct rq *
+this_rq_lock_irq(struct rq_flags *rf)
+	__acquires(rq->lock)
+{
+	struct rq *rq;
+
+	local_irq_disable();
+	rq = this_rq();
+	rq_lock(rq, rf);
+	return rq;
+}
+
 #ifdef CONFIG_NUMA
 enum numa_topology_type {
 	NUMA_DIRECT,
-- 
2.18.0

