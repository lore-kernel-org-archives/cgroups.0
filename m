From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 6/9] sched: sched.h: make rq locking and clock functions available in stats.h
Date: Wed,  1 Aug 2018 11:19:55 -0400
Message-ID: <20180801151958.32590-7-hannes@cmpxchg.org>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NnxyiouhvZnUSydapW5h/V7JQgsuHd8XHvJ9oMKS3Xk=;
        b=kT802V4gaqvbzln+f7fYdlx75z3raFvWWaTBt1Ow9JJu+sYDH8AC31h2MpNN+ybowx
         kWiCmVtbOreLhY2E7Ss/RDFI5q+e71n0rRqALyj7H1GsxqyD90HGeMonuHIcCMH16La9
         d0OcbT8ER8TruLjo/js6yfJNamgONc0l0RaEaNrDbELS7WDGUe56gFohc3Wang2B/ils
         ekHw80UG/aGi4IdbXx4x294G9wbS8PW4DfBlYTJBxpUmYqT5Q3qXQ1Sf6qTCVbJpuAsU
         uqHWEUJLMkuO0nmka52QhW6d+spDzMj6+dbkZD6t/BbBAvDVb4Q9l+tye6zJkb5XxztA
         P9rw==
In-Reply-To: <20180801151958.32590-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

kernel/sched/sched.h includes "stats.h" half-way through the file. The
next patch introduces users of sched.h's rq locking functions and
update_rq_clock() in kernel/sched/stats.h. Move those definitions up
in the file so they are available in stats.h.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/sched/sched.h | 164 +++++++++++++++++++++----------------------
 1 file changed, 82 insertions(+), 82 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cb467c221b15..b8f038497240 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -919,6 +919,8 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		raw_cpu_ptr(&runqueues)
 
+extern void update_rq_clock(struct rq *rq);
+
 static inline u64 __rq_clock_broken(struct rq *rq)
 {
 	return READ_ONCE(rq->clock);
@@ -1037,6 +1039,86 @@ static inline void rq_repin_lock(struct rq *rq, struct rq_flags *rf)
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
@@ -1670,8 +1752,6 @@ static inline void sub_nr_running(struct rq *rq, unsigned count)
 	sched_update_tick_dependency(rq);
 }
 
-extern void update_rq_clock(struct rq *rq);
-
 extern void activate_task(struct rq *rq, struct task_struct *p, int flags);
 extern void deactivate_task(struct rq *rq, struct task_struct *p, int flags);
 
@@ -1752,86 +1832,6 @@ static inline void sched_rt_avg_update(struct rq *rq, u64 rt_delta) { }
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

