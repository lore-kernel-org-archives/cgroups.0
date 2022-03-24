From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Subject: [RFC PATCH] cgroup: introduce proportional protection on memcg
Date: Thu, 24 Mar 2022 17:22:23 +0800
Message-ID: <1648113743-32622-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, ke wang <ke.wang@unisoc.com>, Zhaoyang Huang <huangzhaoyang@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

current memcg protection via min,low,high asks for an evaluation of
protected entity, which could be hard for some system. Furthermore, the usage
could also be various under different scenarios(imagin keep protecting 50M when
usage change from 100M to 300M), which make the protection less meaning.
So we introduce the proportional protection over memcg's ever highest
usage(watermark) to overcome above constraints.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 include/linux/page_counter.h |  3 +++
 mm/memcontrol.c              | 17 +++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 6795913..7762629 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -27,6 +27,9 @@ struct page_counter {
 	unsigned long watermark;
 	unsigned long failcnt;
 
+	/* proportional protection */
+	unsigned long min_prop;
+	unsigned long low_prop;
 	/*
 	 * 'parent' is placed here to be far from 'usage' to reduce
 	 * cache false sharing, as 'usage' is written mostly while
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 508bcea..937c6ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6616,6 +6616,7 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 	unsigned long usage, parent_usage;
 	struct mem_cgroup *parent;
+	unsigned long memcg_emin, memcg_elow, parent_emin, parent_elow;
 
 	if (mem_cgroup_disabled())
 		return;
@@ -6650,14 +6651,22 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 
 	parent_usage = page_counter_read(&parent->memory);
 
+	/* use proportional protect first and take 1024 as 100% */
+	memcg_emin = READ_ONCE(memcg->memory.min_prop) ?
+		READ_ONCE(memcg->memory.min_prop) * READ_ONCE(memcg->memory.watermark) / 1024 : READ_ONCE(memcg->memory.min);
+	memcg_elow = READ_ONCE(memcg->memory.low_prop) ?
+		READ_ONCE(memcg->memory.low_prop) * READ_ONCE(memcg->memory.watermark) / 1024 : READ_ONCE(memcg->memory.low);
+	parent_emin = READ_ONCE(parent->memory.min_prop) ?
+		READ_ONCE(parent->memory.min_prop) * READ_ONCE(parent->memory.watermark) / 1024 : READ_ONCE(parent->memory.emin);
+	parent_elow = READ_ONCE(parent->memory.low_prop) ?
+		READ_ONCE(parent->memory.low_prop) * READ_ONCE(parent->memory.watermark) / 1024 : READ_ONCE(parent->memory.elow);
+
 	WRITE_ONCE(memcg->memory.emin, effective_protection(usage, parent_usage,
-			READ_ONCE(memcg->memory.min),
-			READ_ONCE(parent->memory.emin),
+			memcg_emin, parent_emin,
 			atomic_long_read(&parent->memory.children_min_usage)));
 
 	WRITE_ONCE(memcg->memory.elow, effective_protection(usage, parent_usage,
-			READ_ONCE(memcg->memory.low),
-			READ_ONCE(parent->memory.elow),
+			memcg_elow, parent_elow,
 			atomic_long_read(&parent->memory.children_low_usage)));
 }
 
-- 
1.9.1

