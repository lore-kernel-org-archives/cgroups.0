From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v6 01/11] mm: memcontrol: remove dead code and comments
Date: Tue, 21 Jun 2022 20:56:48 +0800
Message-ID: <20220621125658.64935-2-songmuchun@bytedance.com>
References: <20220621125658.64935-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EillBei8kFa/6bw4XJ6MyIzznZyI10pUVH5tAnTdeuw=;
        b=Jv9GaHJN86Q1C8Y+YpP2HCf9JPFImIvPmz0BU9q0OZd0+4E84aO4jvX7w2JJE8HLii
         xXvy2BsIyrtipyPfO3JiQ1L4gabF6BNM/uSE7D/v4vl5Vc36NMI2yEg+YZ5KSpNsGptU
         HO2lidk6QI25ifAr3ya3fadEcyz9Zbz8Qo1Yg9d9O1CQjjvVGXgpg23fllv4PPkdtuY7
         rKxObA5Q8AuofZlnIdgY5syfjw3uLfKsvjs7i/wXGnHIM/h1h8t1/P4ZXW1c8yFLligG
         siardVDC/TnIZX7H68y5GKiYC9yQyG4FPJP7v8L66B47QZvSC5zmsPVyqmAM4Ajp6REh
         K7Pw==
In-Reply-To: <20220621125658.64935-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org, hannes@cmpxchg.org, longman@redhat.com, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com
Cc: cgroups@vger.kernel.org, duanxiongchun@bytedance.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Muchun Song <songmuchun@bytedance.com>

Since no-hierarchy mode is deprecated after

  commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical mode")

so parent_mem_cgroup() cannot return a NULL except root memcg, however, root
memcg cannot be offline, so it is safe to drop the check of returned value
of parent_mem_cgroup().  Remove those dead code.

The comments in memcg_offline_kmem() above memcg_reparent_list_lrus() are
out of date since

  commit 5abc1e37afa0 ("mm: list_lru: allocate list_lru_one only when needed")

There is no ordering requirement between memcg_reparent_list_lrus() and
memcg_reparent_objcgs(), so remove those outdated comments.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/memcontrol.h |  3 +--
 mm/memcontrol.c            | 12 ------------
 mm/vmscan.c                |  6 +-----
 3 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4d31ce55b1c0..318d8880d62a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -866,8 +866,7 @@ static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
  * parent_mem_cgroup - find the accounting parent of a memcg
  * @memcg: memcg whose parent to find
  *
- * Returns the parent memcg, or NULL if this is the root or the memory
- * controller is in legacy no-hierarchy mode.
+ * Returns the parent memcg, or NULL if this is the root.
  */
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 163492b9efa9..fc706d6fc265 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3684,17 +3684,7 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 		return;
 
 	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
 	memcg_reparent_objcgs(memcg, parent);
-
-	/*
-	 * After we have finished memcg_reparent_objcgs(), all list_lrus
-	 * corresponding to this cgroup are guaranteed to remain empty.
-	 * The ordering is imposed by list_lru_node->lock taken by
-	 * memcg_reparent_list_lrus().
-	 */
 	memcg_reparent_list_lrus(memcg, parent);
 }
 #else
@@ -7195,8 +7185,6 @@ static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
 			break;
 		}
 		memcg = parent_mem_cgroup(memcg);
-		if (!memcg)
-			memcg = root_mem_cgroup;
 	}
 	return memcg;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 88fce64cfa96..b68b0216424d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -409,13 +409,9 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 {
 	int i, nid;
 	long nr;
-	struct mem_cgroup *parent;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	struct shrinker_info *child_info, *parent_info;
 
-	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
 	/* Prevent from concurrent shrinker_info expand */
 	down_read(&shrinker_rwsem);
 	for_each_node(nid) {
-- 
2.11.0

