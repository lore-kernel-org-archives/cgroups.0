From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v1 7/9] workingset: memcg: sleep when flushing stats in workingset_refault()
Date: Tue, 28 Mar 2023 06:16:36 +0000
Message-ID: <20230328061638.203420-8-yosryahmed@google.com>
References: <20230328061638.203420-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679984214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0xrFtgulASYXrMO3GaE6CpeYp9Puj0hiviKaUT94oIg=;
        b=qIxeFfAv7LZhUaMY9U0TvTtrAPX4wRqNbnIeY0Yrn/RnFRGntBTlu0hfuIAsMfAy2n
         1P28EpdkOB3njh6q599A6aRPcbQ+/6Ngp2xMzs6rBLHlr6vd8s4xgEvIn8RMUD6Mze8g
         o6DwJQ//Mohpbdf8YD2EiOxbMyBh8HdrF+/Yzlad7E0D+Fg0j+P6NKtF5T845D/HLRrp
         rP0WF5ztka030C2opL/oGdjy+y9vRWrHiXRiQXH/e0QgpKRtMDaGNueTHyNdIDcH2xFM
         Q3P8IwnLdzShQrK/qG/mnGtQghgE6XGNQRvgt1djyelN/qv5GiJdyRld4l0gXlsYj6Rl
         orEw==
In-Reply-To: <20230328061638.203420-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

In workingset_refault(), we call mem_cgroup_flush_stats_ratelimited()
to flush stats within an RCU read section and with sleeping disallowed.
Move the call to mem_cgroup_flush_stats_ratelimited() above the RCU read
section and allow sleeping to avoid unnecessarily performing a lot of
work without sleeping.

Since workingset_refault() is the only caller of
mem_cgroup_flush_stats_ratelimited(), just make it call the non-atomic
mem_cgroup_flush_stats().

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/memcontrol.c | 12 ++++++------
 mm/workingset.c |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 57e8cbf701f3..0c0e74188e90 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -674,12 +674,6 @@ void mem_cgroup_flush_stats_atomic(void)
 		__mem_cgroup_flush_stats_atomic();
 }
 
-void mem_cgroup_flush_stats_ratelimited(void)
-{
-	if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
-		mem_cgroup_flush_stats_atomic();
-}
-
 /* non-atomic functions, only safe from sleepable contexts */
 static void __mem_cgroup_flush_stats(void)
 {
@@ -695,6 +689,12 @@ void mem_cgroup_flush_stats(void)
 		__mem_cgroup_flush_stats();
 }
 
+void mem_cgroup_flush_stats_ratelimited(void)
+{
+	if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
+		mem_cgroup_flush_stats();
+}
+
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	__mem_cgroup_flush_stats();
diff --git a/mm/workingset.c b/mm/workingset.c
index af862c6738c3..7d7ecc46521c 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -406,6 +406,8 @@ void workingset_refault(struct folio *folio, void *shadow)
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, &workingset);
 	eviction <<= bucket_order;
 
+	/* Flush stats (and potentially sleep) before holding RCU read lock */
+	mem_cgroup_flush_stats_ratelimited();
 	rcu_read_lock();
 	/*
 	 * Look up the memcg associated with the stored ID. It might
@@ -461,8 +463,6 @@ void workingset_refault(struct folio *folio, void *shadow)
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
-
-	mem_cgroup_flush_stats_ratelimited();
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
-- 
2.40.0.348.gf938b09366-goog

