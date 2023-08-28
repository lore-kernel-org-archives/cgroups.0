From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v2 2/4] mm: memcg: add a helper for non-unified stats flushing
Date: Mon, 28 Aug 2023 23:33:16 +0000
Message-ID: <20230828233319.340712-3-yosryahmed@google.com>
References: <20230828233319.340712-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693265606; x=1693870406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I5n9hS9q/cqFV2qh34A2AZEA4DGYELaonjfoFoCAI8g=;
        b=sSpYPt7rKW3DtUM15JcLQJplUoRrPMx95M/aXCWUkUGG4gZ450QgwVE4yFUm7CogQH
         zFv9UI4D9YSxvW6bodhDxj3Ik66YmhEKFtQN01JiGkk9R6pRwoVFGBpQEhzaG5mXyhg+
         7vKrj39/+K2fsqeCBVG9cqcEQsLe/O8dA6loSupqE+p8mxgQd1Y/Cch38q9mTgfWAdOU
         Mi/PT8DoWdqlQunEGCPiAM+0xArU4vTZKSIUUhJFt8vF/ApSZdUHhIi/YFoCfVUArao7
         1xkMsp1FV1LDKVh9Dm5/i7gS4Zp0X1DnugiYstil6izVooJ18sBWRLBaLBmogvidXImj
         ZLUA==
In-Reply-To: <20230828233319.340712-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Some contexts flush memcg stats outside of unified flushing, directly
using cgroup_rstat_flush(). Add a helper for non-unified flushing, a
counterpart for do_unified_stats_flush(), and use it in those contexts,
as well as in do_unified_stats_flush() itself.

This abstracts the rstat API and makes it easy to introduce
modifications to either unified or non-unified flushing functions
without changing callers.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/memcontrol.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c6150ea54d48..90f08b35fa77 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -639,6 +639,17 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 	}
 }
 
+/*
+ * do_stats_flush - do a flush of the memory cgroup statistics
+ * @memcg: memory cgroup to flush
+ *
+ * Only flushes the subtree of @memcg, does not skip under any conditions.
+ */
+static void do_stats_flush(struct mem_cgroup *memcg)
+{
+	cgroup_rstat_flush(memcg->css.cgroup);
+}
+
 /*
  * do_unified_stats_flush - do a unified flush of memory cgroup statistics
  *
@@ -656,7 +667,7 @@ static void do_unified_stats_flush(void)
 
 	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
 
-	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
+	do_stats_flush(root_mem_cgroup);
 
 	atomic_set(&stats_flush_threshold, 0);
 	atomic_set(&stats_flush_ongoing, 0);
@@ -7790,7 +7801,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 			break;
 		}
 
-		cgroup_rstat_flush(memcg->css.cgroup);
+		do_stats_flush(memcg);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
 		if (pages < max)
 			continue;
@@ -7855,8 +7866,10 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 static u64 zswap_current_read(struct cgroup_subsys_state *css,
 			      struct cftype *cft)
 {
-	cgroup_rstat_flush(css->cgroup);
-	return memcg_page_state(mem_cgroup_from_css(css), MEMCG_ZSWAP_B);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	do_stats_flush(memcg);
+	return memcg_page_state(memcg, MEMCG_ZSWAP_B);
 }
 
 static int zswap_max_show(struct seq_file *m, void *v)
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

