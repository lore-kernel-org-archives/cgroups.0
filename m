From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v17 00/21] per memcg lru lock
Date: Tue, 4 Aug 2020 16:36:51 +0800
Message-ID: <7622d74e-5884-4ee5-382d-78d6476db18a@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1595681998-19193-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

From e2918c8fa741442255a2f12659f95dae94fdfe5d Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Date: Sat, 1 Aug 2020 22:49:31 +0800
Subject: [PATCH 3/3] mm/swap.c: optimizing __pagevec_lru_add lru_lock

The current relock will unlock/lock lru_lock with every time lruvec
changes, so it would cause frequency relock if 2 memcgs are reading file
simultaneously.

This patch will record the involved lru_lock and only hold them once in
above scenario. That could reduce the lock contention.

Using per cpu data intead of local stack data to avoid repeatly
INIT_LIST_HEAD action.

[lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org: found a build issue in the original patch, thanks]
Suggested-by: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/swap.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 6 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index d88a6c650a7c..e227fec6983c 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -72,6 +72,27 @@ static DEFINE_PER_CPU(struct lru_pvecs, lru_pvecs) = {
 	.lock = INIT_LOCAL_LOCK(lock),
 };
 
+struct pvlvs {
+	struct list_head lists[PAGEVEC_SIZE];
+	struct lruvec *vecs[PAGEVEC_SIZE];
+};
+static DEFINE_PER_CPU(struct pvlvs, pvlvs);
+
+static int __init pvlvs_init(void) {
+	int i, cpu;
+	struct pvlvs *pvecs;
+
+	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+		if (!cpu_possible(cpu))
+			continue;
+		pvecs = per_cpu_ptr(&pvlvs, cpu);
+		for (i = 0; i < PAGEVEC_SIZE; i++)
+			INIT_LIST_HEAD(&pvecs->lists[i]);
+	}
+	return 0;
+}
+subsys_initcall(pvlvs_init);
+
 /*
  * This path almost never happens for VM activity - pages are normally
  * freed via pagevecs.  But it gets used by networking.
@@ -963,18 +984,42 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec)
  */
 void __pagevec_lru_add(struct pagevec *pvec)
 {
-	int i;
+	int i, j, total = 0;
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
+	struct page *page;
+	struct pvlvs *lvs = this_cpu_ptr(&pvlvs);
 
+	/* Sort the same lruvec pages on a list. */
 	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
+		page = pvec->pages[i];
+		lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+
+		/* Try to find a same lruvec */
+		for (j = 0; j <= total; j++)
+			if (lruvec == lvs->vecs[j])
+				break;
+		/* A new lruvec */
+		if (j > total) {
+			lvs->vecs[total] = lruvec;
+			j = total;
+			total++;
+		}
 
-		lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
-		__pagevec_lru_add_fn(page, lruvec);
+		list_add(&page->lru, &lvs->lists[j]);
 	}
-	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+
+	for (i = 0; i < total; i++) {
+		spin_lock_irqsave(&lvs->vecs[i]->lru_lock, flags);
+		while (!list_empty(&lvs->lists[i])) {
+			page = lru_to_page(&lvs->lists[i]);
+			list_del(&page->lru);
+			__pagevec_lru_add_fn(page, lvs->vecs[i]);
+		}
+		spin_unlock_irqrestore(&lvs->vecs[i]->lru_lock, flags);
+		lvs->vecs[i] = NULL;
+	}
+
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
-- 
1.8.3.1


