From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v4 4/9] mm/mlock: only change the lru_lock iff page's lruvec is different
Date: Tue, 19 Nov 2019 20:23:18 +0800
Message-ID: <1574166203-151975-5-git-send-email-alex.shi@linux.alibaba.com>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Andrey Ryabinin <aryabinin@virtuozzo.com>, swkhack <swkhack@gmail.com>, "Potyra, Stefan" <Stefan.Potyra@elektrobit.com>, Jason Gunthorpe <jgg@ziepe.ca>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Peng Fan <peng.fan@nxp.com>, Nikolay Borisov <nborisov@suse.com>, Ira Weiny <ira.weiny@intel.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Yafang Shao <laoar.shao@gmail.com>

During the pagevec locking, a new page's lruvec is may same as
previous one. Thus we could save a re-locking, and only
change lock iff lruvec is new.

Function named relock_page_lruvec following Hugh Dickins patch.

The first version of this patch used rcu_read_lock to guard
lruvec assign and comparsion with locked_lruvev in relock_page_lruvec.
But Rong Chen <rong.a.chen@intel.com> report a regression with
PROVE_LOCKING config. The rcu_read locking causes qspinlock waiting to
be locked for too long.

Since we had hold a spinlock, rcu_read locking isn't necessary.

[lkp@intel.com: Fix RCU-related regression reported by LKP robot]
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: swkhack <swkhack@gmail.com>
Cc: "Potyra, Stefan" <Stefan.Potyra@elektrobit.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Nikolay Borisov <nborisov@suse.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/memcontrol.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 mm/mlock.c                 | 16 +++++++++-------
 2 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9538253998a6..19ff453e2822 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1291,6 +1291,50 @@ static inline void dec_lruvec_page_state(struct page *page,
 	mod_lruvec_page_state(page, idx, -1);
 }
 
+/* Don't lock again iff page's lruvec locked */
+static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
+					struct lruvec *locked_lruvec)
+{
+	struct pglist_data *pgdat = page_pgdat(page);
+	struct lruvec *lruvec;
+
+	if (!locked_lruvec)
+		goto lock;
+
+	lruvec = mem_cgroup_page_lruvec(page, pgdat);
+
+	if (locked_lruvec == lruvec)
+		return lruvec;
+
+	spin_unlock_irq(&locked_lruvec->lru_lock);
+
+lock:
+	lruvec = lock_page_lruvec_irq(page, pgdat);
+	return lruvec;
+}
+
+/* Don't lock again iff page's lruvec locked */
+static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,
+			struct lruvec *locked_lruvec, unsigned long *flags)
+{
+	struct pglist_data *pgdat = page_pgdat(page);
+	struct lruvec *lruvec;
+
+	if (!locked_lruvec)
+		goto lock;
+
+	lruvec = mem_cgroup_page_lruvec(page, pgdat);
+
+	if (locked_lruvec == lruvec)
+		return lruvec;
+
+	spin_unlock_irqrestore(&locked_lruvec->lru_lock, *flags);
+
+lock:
+	lruvec = lock_page_lruvec_irqsave(page, pgdat, flags);
+	return lruvec;
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
diff --git a/mm/mlock.c b/mm/mlock.c
index b509b80b8513..8b3a97b62c0a 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -290,6 +290,7 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 {
 	int i;
 	int nr = pagevec_count(pvec);
+	int delta_munlocked = -nr;
 	struct pagevec pvec_putback;
 	struct lruvec *lruvec = NULL;
 	int pgrescued = 0;
@@ -300,20 +301,19 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 	for (i = 0; i < nr; i++) {
 		struct page *page = pvec->pages[i];
 
-		lruvec = lock_page_lruvec_irq(page, page_pgdat(page));
+		lruvec = relock_page_lruvec_irq(page, lruvec);
 
 		if (TestClearPageMlocked(page)) {
 			/*
 			 * We already have pin from follow_page_mask()
 			 * so we can spare the get_page() here.
 			 */
-			if (__munlock_isolate_lru_page(page, lruvec, false)) {
-				__mod_zone_page_state(zone, NR_MLOCK,  -1);
-				spin_unlock_irq(&lruvec->lru_lock);
+			if (__munlock_isolate_lru_page(page, lruvec, false))
 				continue;
-			} else
+			else
 				__munlock_isolation_failed(page);
-		}
+		} else
+			delta_munlocked++;
 
 		/*
 		 * We won't be munlocking this page in the next phase
@@ -323,8 +323,10 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 		 */
 		pagevec_add(&pvec_putback, pvec->pages[i]);
 		pvec->pages[i] = NULL;
-		spin_unlock_irq(&lruvec->lru_lock);
 	}
+	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
+	if (lruvec)
+		spin_unlock_irq(&lruvec->lru_lock);
 
 	/* Now we can release pins of pages that we are not munlocking */
 	pagevec_release(&pvec_putback);
-- 
1.8.3.1

