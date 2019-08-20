From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH 02/14] lru/memcg: move the lruvec->pgdat sync out lru_lock
Date: Tue, 20 Aug 2019 17:48:25 +0800
Message-ID: <1566294517-86418-3-git-send-email-alex.shi@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Kirill Tkhai <ktkhai@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>

We are going to move lruvec getting out of lru_lock, the only unsafe
part is lruvec->pgdat syncing when memory node hot pluging.

Splitting out the lruvec->pgdat assignment now and will put it in
lruvec lru_lock protection.

No function changes in this patch now.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/memcontrol.h | 24 +++++++++++++++++-------
 mm/memcontrol.c            |  8 +-------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2cd4359cb38c..95b3d9885ab6 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -359,6 +359,17 @@ void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg,
 	return memcg->nodeinfo[nid];
 }
 
+static void sync_lruvec_pgdat(struct lruvec *lruvec, struct pglist_data *pgdat)
+{
+	/*
+	 * Since a node can be onlined after the mem_cgroup was created,
+	 * we have to be prepared to initialize lruvec->pgdat here;
+	 * and if offlined then reonlined, we need to reinitialize it.
+	 */
+	if (!mem_cgroup_disabled() && unlikely(lruvec->pgdat != pgdat))
+		lruvec->pgdat = pgdat;
+}
+
 /**
  * mem_cgroup_lruvec - get the lru list vector for a node or a memcg zone
  * @node: node of the wanted lruvec
@@ -382,13 +393,7 @@ static inline struct lruvec *mem_cgroup_lruvec(struct pglist_data *pgdat,
 	mz = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
 	lruvec = &mz->lruvec;
 out:
-	/*
-	 * Since a node can be onlined after the mem_cgroup was created,
-	 * we have to be prepared to initialize lruvec->pgdat here;
-	 * and if offlined then reonlined, we need to reinitialize it.
-	 */
-	if (unlikely(lruvec->pgdat != pgdat))
-		lruvec->pgdat = pgdat;
+	sync_lruvec_pgdat(lruvec, pgdat);
 	return lruvec;
 }
 
@@ -857,6 +862,11 @@ static inline void mem_cgroup_migrate(struct page *old, struct page *new)
 {
 }
 
+static inline void sync_lruvec_pgdat(struct lruvec *lruvec,
+						struct pglist_data *pgdat)
+{
+}
+
 static inline struct lruvec *mem_cgroup_lruvec(struct pglist_data *pgdat,
 				struct mem_cgroup *memcg)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2792b8ed405f..e8a1b0d95ba8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1257,13 +1257,7 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
 	mz = mem_cgroup_page_nodeinfo(memcg, page);
 	lruvec = &mz->lruvec;
 out:
-	/*
-	 * Since a node can be onlined after the mem_cgroup was created,
-	 * we have to be prepared to initialize lruvec->zone here;
-	 * and if offlined then reonlined, we need to reinitialize it.
-	 */
-	if (unlikely(lruvec->pgdat != pgdat))
-		lruvec->pgdat = pgdat;
+	sync_lruvec_pgdat(lruvec, pgdat);
 	return lruvec;
 }
 
-- 
1.8.3.1

