From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 6/9] sched: sched.h: make rq locking and clock functions available in stats.h
Date: Tue, 28 Aug 2018 13:22:55 -0400
Message-ID: <20180828172258.3185-7-hannes@cmpxchg.org>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YGVWOmKVI0Wip1CfuceBVSe8DJn5GeG7PCv8icT2Z0U=;
        b=AKT3sPmOEbg9Yg5eRaVaKJegsvlZJJBcHWwMpFiJtmIxeN7ansAN3icVfmfy3FahHC
         SD0UmVPp1D0fMVlwf+k2KcuBedR/njVCvvA72cV+0+X8HotOSnV/ckH193eYWk+rBWlN
         ayfwiIlXBVREQ6I34QvF21XoIjIQ6YMwa8MX5sUFGlxVQBtse6wmdVh5t1zdkb4MpaPt
         pdZCwebhjeyRfwcTuJvpb/IhnAiJQ/9JrU2FICmfrXa+m5mfeGfhiN22InLUkytxqk2z
         ZcE/gpyXgChPMTiPnMGUFbk8+IHjLxw0HsvV2qrldDxxq/489CHpZDAyRrqivMJ/oAcO
         Y8Aw==
In-Reply-To: <20180828172258.3185-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

kernel/sched/sched.h includes "stats.h" half-way through the file. The
next patch introduces users of sched.h's rq locking functions and
update_rq_clock() in kernel/sched/stats.h. Move those definitions up
in the file so they are available in stats.h.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/sched/sched.h | 164 +++++++++++++++++++++----------------------
 1 file changed, 82 insertions(+), 82 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c7742dcc136c..eb9b1326906c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -926,6 +926,8 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		raw_cpu_ptr(&runqueues)
 
+extern void update_rq_clock(struct rq *rq);
+
 static inline u64 __rq_clock_broken(struct rq *rq)
 {
 	return READ_ONCE(rq->clock);
@@ -1044,6 +1046,86 @@ static inline void rq_repin_lock(struct rq *rq, struct rq_flags *rf)
 #endif
 }
 
+struct rq *__task_rq_lock(struct task_struct *p, struct rq_flags *rf)
+	__acquires(rq->lock);
+
+struct rq *task_rq_lock(struct task_struct *p, struct rq_flags *rf)
+	__acquires(p->pi_lock)
+	__acquires(rq->lock);
+
+static inline void __task_rq_unlock(struct rq *rq, struct rq_flags *rf)
+	__releases(rq->lock)
+{
+	rq_unpin_lock(rq, rf);
+	raw_spin_unlock(&rq->lock);
+}
+
+static inline void
+task_rq_unlock(struct rq *rq, struct task_struct *p, struct rq_flags *rf)
+	__releases(rq->lock)
+	__releases(p->pi_lock)
+{
+	rq_unpin_lock(rq, rf);
+	raw_spin_unlock(&rq->lock);
+	raw_spin_unlock_irqrestore(&p->pi_lock, rf->flags);
+}
+
+static inline void
+rq_lock_irqsave(struct rq *rq, struct rq_flags *rf)
+	__acquires(rq->lock)
+{
+	raw_spin_lock_irqsave(&rq->lock, rf->flags);
+	rq_pin_lock(rq, rf);
+}
+
+static inline void
+rq_lock_irq(struct rq *rq, struct rq_flags *rf)
+	__acquires(rq->lock)
+{
+	raw_spin_lock_irq(&rq->lock);
+	rq_pin_lock(rq, rf);
+}
+
+static inline void
+rq_lock(struct rq *rq, struct rq_flags *rf)
+	__acquires(rq->lock)
+{
+	raw_spin_lock(&rq->lock);
+	rq_pin_lock(rq, rf);
+}
+
+static inline void
+rq_relock(struct rq *rq, struct rq_flags *rf)
+	__acquires(rq->lock)
+{
+	raw_spin_lock(&rq->lock);
+	rq_repin_lock(rq, rf);
+}
+
+static inline void
+rq_unlock_irqrestore(struct rq *rq, struct rq_flags *rf)
+	__releases(rq->lock)
+{
+	rq_unpin_lock(rq, rf);
+	raw_spin_unlock_irqrestore(&rq->lock, rf->flags);
+}
+
+static inline void
+rq_unlock_irq(struct rq *rq, struct rq_flags *rf)
+	__releases(rq->lock)
+{
+	rq_unpin_lock(rq, rf);
+	raw_spin_unlock_irq(&rq->lock);
+}
+
+static inline void
+rq_unlock(struct rq *rq, struct rq_flags *rf)
+	__releases(rq->lock)
+{
+	rq_unpin_lock(rq, rf);
+	raw_spin_unlock(&rq->lock);
+}
+
 #ifdef CONFIG_NUMA
 enum numa_topology_type {
 	NUMA_DIRECT,
@@ -1683,8 +1765,6 @@ static inline void sub_nr_running(struct rq *rq, unsigned count)
 	sched_update_tick_dependency(rq);
 }
 
-extern void update_rq_clock(struct rq *rq);
-
 extern void activate_task(struct rq *rq, struct task_struct *p, int flags);
 extern void deactivate_task(struct rq *rq, struct task_struct *p, int flags);
 
@@ -1765,86 +1845,6 @@ static inline void sched_rt_avg_update(struct rq *rq, u64 rt_delta) { }
 static inline void sched_avg_update(struct rq *rq) { }
 #endif
 
-struct rq *__task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(rq->lock);
-
-struct rq *task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(p->pi_lock)
-	__acquires(rq->lock);
-
-static inline void __task_rq_unlock(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
-{
-	rq_unpin_lock(rq, rf);
-	raw_spin_unlock(&rq->lock);
-}
-
-static inline void
-task_rq_unlock(struct rq *rq, struct task_struct *p, struct rq_flags *rf)
-	__releases(rq->lock)
-	__releases(p->pi_lock)
-{
-	rq_unpin_lock(rq, rf);
-	raw_spin_unlock(&rq->lock);
-	raw_spin_unlock_irqrestore(&p->pi_lock, rf->flags);
-}
-
-static inline void
-rq_lock_irqsave(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
-{
-	raw_spin_lock_irqsave(&rq->lock, rf->flags);
-	rq_pin_lock(rq, rf);
-}
-
-static inline void
-rq_lock_irq(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
-{
-	raw_spin_lock_irq(&rq->lock);
-	rq_pin_lock(rq, rf);
-}
-
-static inline void
-rq_lock(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
-{
-	raw_spin_lock(&rq->lock);
-	rq_pin_lock(rq, rf);
-}
-
-static inline void
-rq_relock(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
-{
-	raw_spin_lock(&rq->lock);
-	rq_repin_lock(rq, rf);
-}
-
-static inline void
-rq_unlock_irqrestore(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
-{
-	rq_unpin_lock(rq, rf);
-	raw_spin_unlock_irqrestore(&rq->lock, rf->flags);
-}
-
-static inline void
-rq_unlock_irq(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
-{
-	rq_unpin_lock(rq, rf);
-	raw_spin_unlock_irq(&rq->lock);
-}
-
-static inline void
-rq_unlock(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
-{
-	rq_unpin_lock(rq, rf);
-	raw_spin_unlock(&rq->lock);
-}
-
 #ifdef CONFIG_SMP
 #ifdef CONFIG_PREEMPT
 
-- 
2.18.0

