From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v2 7/9] workingset: memcg: sleep when flushing stats in workingset_refault()
Date: Tue, 28 Mar 2023 22:16:42 +0000
Message-ID: <20230328221644.803272-8-yosryahmed@google.com>
References: <20230328221644.803272-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680041823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a7F6fk9fZnPdw9ddOVIzAjBdiTpqd88vdaggqxhF/qs=;
        b=j2h7VlEdeGIL4dqtCRH6krZRXCzlm8zdD/VKFrhl2Ix5hroKwD9u6hjC+9l9HOi6UV
         H1JPSNu1LdgWvdxHE9hg+SM93x1Jht2L9pd8vgLQEuBZlRpZngZUgkiaZwaZa4gCkUC+
         zgspBsM6/B8TFiwy4IbbIfRW24OLGYSFku2vitXovcEwbuAN1td3zyOf9AyMfligZ5Lp
         BhTKdBAPhJ+a7QI4Cj7LZxYyn4A2yXYMpirZryPEzjspDaCYUkIzUrMU1Kd6ErRoShgT
         XFMZOBTc6edK5ZIe1IhscJC8wUQ57Xb89+9zAOCcDb3JVfb8T7SfV7MPXlrp4JguLYCz
         aCRg==
In-Reply-To: <20230328221644.803272-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

In workingset_refault(), we call
mem_cgroup_flush_stats_atomic_ratelimited() to flush stats within an
RCU read section and with sleeping disallowed. Move the call above
the RCU read section and allow sleeping to avoid unnecessarily
performing a lot of work without sleeping.

Since workingset_refault() is the only caller of
mem_cgroup_flush_stats_atomic_ratelimited(), just make it non-atomic,
and rename it to mem_cgroup_flush_stats_ratelimited().

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 4 ++--
 mm/memcontrol.c            | 4 ++--
 mm/workingset.c            | 5 +++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b424ba3ebd09..a4bc3910a2eb 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1038,7 +1038,7 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 
 void mem_cgroup_flush_stats(void);
 void mem_cgroup_flush_stats_atomic(void);
-void mem_cgroup_flush_stats_atomic_ratelimited(void);
+void mem_cgroup_flush_stats_ratelimited(void);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1540,7 +1540,7 @@ static inline void mem_cgroup_flush_stats_atomic(void)
 {
 }
 
-static inline void mem_cgroup_flush_stats_atomic_ratelimited(void)
+static inline void mem_cgroup_flush_stats_ratelimited(void)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2ce3aa10d94..361c0bbf7283 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -673,10 +673,10 @@ void mem_cgroup_flush_stats_atomic(void)
 		do_flush_stats(true);
 }
 
-void mem_cgroup_flush_stats_atomic_ratelimited(void)
+void mem_cgroup_flush_stats_ratelimited(void)
 {
 	if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
-		mem_cgroup_flush_stats_atomic();
+		mem_cgroup_flush_stats();
 }
 
 static void flush_memcg_stats_dwork(struct work_struct *w)
diff --git a/mm/workingset.c b/mm/workingset.c
index dab0c362b9e3..3025beee9b34 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -406,6 +406,9 @@ void workingset_refault(struct folio *folio, void *shadow)
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, &workingset);
 	eviction <<= bucket_order;
 
+	/* Flush stats (and potentially sleep) before holding RCU read lock */
+	mem_cgroup_flush_stats_ratelimited();
+
 	rcu_read_lock();
 	/*
 	 * Look up the memcg associated with the stored ID. It might
@@ -461,8 +464,6 @@ void workingset_refault(struct folio *folio, void *shadow)
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
-
-	mem_cgroup_flush_stats_atomic_ratelimited();
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
-- 
2.40.0.348.gf938b09366-goog

