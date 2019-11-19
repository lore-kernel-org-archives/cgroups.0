From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v4 8/9] mm/lru: likely enhancement
Date: Tue, 19 Nov 2019 20:23:22 +0800
Message-ID: <1574166203-151975-9-git-send-email-alex.shi@linux.alibaba.com>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>

Use likely() to remove speculations according to pagevec usage.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/memcontrol.h | 8 ++++----
 mm/memcontrol.c            | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 19ff453e2822..1787bbc4b059 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1298,12 +1298,12 @@ static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
 	struct pglist_data *pgdat = page_pgdat(page);
 	struct lruvec *lruvec;
 
-	if (!locked_lruvec)
+	if (unlikely(!locked_lruvec))
 		goto lock;
 
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
-	if (locked_lruvec == lruvec)
+	if (likely(locked_lruvec == lruvec))
 		return lruvec;
 
 	spin_unlock_irq(&locked_lruvec->lru_lock);
@@ -1320,12 +1320,12 @@ static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,
 	struct pglist_data *pgdat = page_pgdat(page);
 	struct lruvec *lruvec;
 
-	if (!locked_lruvec)
+	if (unlikely(!locked_lruvec))
 		goto lock;
 
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
-	if (locked_lruvec == lruvec)
+	if (likely(locked_lruvec == lruvec))
 		return lruvec;
 
 	spin_unlock_irqrestore(&locked_lruvec->lru_lock, *flags);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7e6387ad01f0..8c3ba90bdefc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1257,7 +1257,7 @@ struct lruvec *lock_page_lruvec_irq(struct page *page,
 	rcu_read_unlock();
 
 	/* lruvec may changed in commit_charge() */
-	if (lruvec != mem_cgroup_page_lruvec(page, pgdat)) {
+	if (unlikely(lruvec != mem_cgroup_page_lruvec(page, pgdat))) {
 		spin_unlock_irq(&lruvec->lru_lock);
 		goto again;
 	}
@@ -1277,7 +1277,7 @@ struct lruvec *lock_page_lruvec_irqsave(struct page *page,
 	rcu_read_unlock();
 
 	/* lruvec may changed in commit_charge() */
-	if (lruvec != mem_cgroup_page_lruvec(page, pgdat)) {
+	if (unlikely(lruvec != mem_cgroup_page_lruvec(page, pgdat))) {
 		spin_unlock_irqrestore(&lruvec->lru_lock, *flags);
 		goto again;
 	}
-- 
1.8.3.1

