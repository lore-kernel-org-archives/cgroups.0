From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v7 09/10] mm/lru: add debug checking for page memcg moving
Date: Wed, 25 Dec 2019 17:04:25 +0800
Message-ID: <1577264666-246071-10-git-send-email-alex.shi@linux.alibaba.com>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

This debug patch could give some clues if there are sth out of
consideration.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/compaction.c | 4 ++++
 mm/memcontrol.c | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 8c0a2da217d8..f47820355b66 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -971,6 +971,10 @@ static bool too_many_isolated(pg_data_t *pgdat)
 			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
 			locked_lruvec = lruvec;
 
+#ifdef	CONFIG_MEMCG
+			if (!mem_cgroup_disabled())
+				VM_BUG_ON_PAGE(lruvec_memcg(lruvec) != page->mem_cgroup, page);
+#endif
 			/* Try get exclusive access under lock */
 			if (!skip_updated) {
 				skip_updated = true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1b69e27d1b9f..33bf086faed0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1247,6 +1247,10 @@ struct lruvec *lock_page_lruvec_irq(struct page *page)
 	lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
 	spin_lock_irq(&lruvec->lru_lock);
 
+#ifdef CONFIG_MEMCG
+	if (!mem_cgroup_disabled())
+		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) != page->mem_cgroup, page);
+#endif
 	return lruvec;
 }
 
@@ -1259,6 +1263,10 @@ struct lruvec *lock_page_lruvec_irqsave(struct page *page, unsigned long *flags)
 	lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
 
+#ifdef CONFIG_MEMCG
+	if (!mem_cgroup_disabled())
+		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) != page->mem_cgroup, page);
+#endif
 	return lruvec;
 }
 
-- 
1.8.3.1

