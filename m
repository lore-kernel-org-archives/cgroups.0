From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v3 4/8] memcg: replace stats_flush_lock with an atomic
Date: Thu, 30 Mar 2023 19:17:57 +0000
Message-ID: <20230330191801.1967435-5-yosryahmed@google.com>
References: <20230330191801.1967435-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680203891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4nnUf1Bi8zb8HMhH9DtFsVEWdtAjMz82Sf34ZimV0fg=;
        b=X2RFp1pZWOYnRsIh7IWjsVsM+KEFc9WJSHxF/6WWA0h+C4aKaj5fmmxIF9JIbSgACd
         wSFJlPVZHSShfit9sIv2gEMkHiLDYI1aj0ZjNxN+KDFEUuJ5hrS0dAiMoZtgG8tE01Qw
         Z6IuI1YwDe0K3jJKl09PQ+88WTXCXmLj3mXjZyc3NpqNvz62t2kYidmfKl22OQzA3sQQ
         EAjXhE1Jh+vHizPfZUZ3LQ+IzSkqjVL6en02vxZp22lS6vBDlsf8gGPBHsHSCXP5Ac15
         JluiS/D70cGu14FmTesFiFf/4cN9gJ7flhGTivB535PauxJnWfGkMyHN0wJ36oB1Mtk7
         YlVQ==
In-Reply-To: <20230330191801.1967435-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>, Michal Hocko <mhocko@suse.com>

As Johannes notes in [1], stats_flush_lock is currently used to:
(a) Protect updated to stats_flush_threshold.
(b) Protect updates to flush_next_time.
(c) Serializes calls to cgroup_rstat_flush() based on those ratelimits.

However:

1. stats_flush_threshold is already an atomic

2. flush_next_time is not atomic. The writer is locked, but the reader
   is lockless. If the reader races with a flush, you could see this:

                                        if (time_after(jiffies, flush_next_time))
        spin_trylock()
        flush_next_time = now + delay
        flush()
        spin_unlock()
                                        spin_trylock()
                                        flush_next_time = now + delay
                                        flush()
                                        spin_unlock()

   which means we already can get flushes at a higher frequency than
   FLUSH_TIME during races. But it isn't really a problem.

   The reader could also see garbled partial updates if the compiler
   decides to split the write, so it needs at least READ_ONCE and
   WRITE_ONCE protection.

3. Serializing cgroup_rstat_flush() calls against the ratelimit
   factors is currently broken because of the race in 2. But the race
   is actually harmless, all we might get is the occasional earlier
   flush. If there is no delta, the flush won't do much. And if there
   is, the flush is justified.

So the lock can be removed all together. However, the lock also served
the purpose of preventing a thundering herd problem for concurrent
flushers, see [2]. Use an atomic instead to serve the purpose of
unifying concurrent flushers.

[1]https://lore.kernel.org/lkml/20230323172732.GE739026@cmpxchg.org/
[2]https://lore.kernel.org/lkml/20210716212137.1391164-2-shakeelb@google.com/

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/memcontrol.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ff39f78f962e..65750f8b8259 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -585,8 +585,8 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
  */
 static void flush_memcg_stats_dwork(struct work_struct *w);
 static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
-static DEFINE_SPINLOCK(stats_flush_lock);
 static DEFINE_PER_CPU(unsigned int, stats_updates);
+static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
 static u64 flush_next_time;
 
@@ -636,15 +636,19 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 
 static void __mem_cgroup_flush_stats(void)
 {
-	unsigned long flag;
-
-	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
+	/*
+	 * We always flush the entire tree, so concurrent flushers can just
+	 * skip. This avoids a thundering herd problem on the rstat global lock
+	 * from memcg flushers (e.g. reclaim, refault, etc).
+	 */
+	if (atomic_read(&stats_flush_ongoing) ||
+	    atomic_xchg(&stats_flush_ongoing, 1))
 		return;
 
-	flush_next_time = jiffies_64 + 2*FLUSH_TIME;
+	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
 	cgroup_rstat_flush_atomic(root_mem_cgroup->css.cgroup);
 	atomic_set(&stats_flush_threshold, 0);
-	spin_unlock_irqrestore(&stats_flush_lock, flag);
+	atomic_set(&stats_flush_ongoing, 0);
 }
 
 void mem_cgroup_flush_stats(void)
@@ -655,7 +659,7 @@ void mem_cgroup_flush_stats(void)
 
 void mem_cgroup_flush_stats_ratelimited(void)
 {
-	if (time_after64(jiffies_64, flush_next_time))
+	if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
 		mem_cgroup_flush_stats();
 }
 
-- 
2.40.0.348.gf938b09366-goog

