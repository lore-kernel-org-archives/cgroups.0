From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 7/9] sched: introduce this_rq_lock_irq()
Date: Wed,  1 Aug 2018 11:19:56 -0400
Message-ID: <20180801151958.32590-8-hannes@cmpxchg.org>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EOH4yuXU61UFUoCxssnGS0E9pmyAjCBzpOCJhmVNCYY=;
        b=YMeIfO7cHaOPiMpMbEL3NOKawxOjbeGFP0k9cxcW/u73CdC8UdEjGti+n/J1hepbbL
         zC9EPQ6M3PsLnBBXu7zrA5qGMcnCgHgagLN5jzI9+SmcImMJ961PzYjpSy45FkXX0JZw
         0eAz+TM8bpe3OY27wnif6jAJ8/W4uBGXYf3fvtSHMoZ0RqTjQt589ELUAgAfzwQ2ojr+
         jkjjPbmQoZ9q0yzFS9xHB+gBuD9Lvz9GjaGpD1GL9Bvs1M/hMOlWdjgmBnGYs5V2O6SN
         YNN1XzVzvzPZx98pl+pkHX8yqqelvVMDJ+ZoYPpNA5PyWTg8YW5QcvjCMws1CkX9fo8r
         xyPQ==
In-Reply-To: <20180801151958.32590-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

do_sched_yield() disables IRQs, looks up this_rq() and locks it. The
next patch is adding another site with the same pattern, so provide a
convenience function for it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/sched/core.c  |  4 +---
 kernel/sched/sched.h | 12 ++++++++++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 211890edf37e..9586a8141f16 100644
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
index b8f038497240..bc798c7cb4d4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1119,6 +1119,18 @@ rq_unlock(struct rq *rq, struct rq_flags *rf)
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

