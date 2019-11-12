From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v2 6/8] mm/lru: remove rcu_read_lock to fix performance regression
Date: Tue, 12 Nov 2019 22:06:26 +0800
Message-ID: <1573567588-47048-7-git-send-email-alex.shi@linux.alibaba.com>
References: <1573567588-47048-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1573567588-47048-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: alex.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>

Intel 0day report there are performance regression on this patchset.
The detailed info points to rcu_read_lock + PROVE_LOCKING which causes
queued_spin_lock_slowpath waiting too long time to get lock.
Remove rcu_read_lock is safe here since we had a spinlock hold.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/memcontrol.h | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2421b720d272..f869897a68f0 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1307,20 +1307,18 @@ static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
 	struct pglist_data *pgdat = page_pgdat(page);
 	struct lruvec *lruvec;
 
-	rcu_read_lock();
+	if (!locked_lruvec)
+		goto lock;
+
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
-	if (locked_lruvec == lruvec) {
-		rcu_read_unlock();
+	if (locked_lruvec == lruvec)
 		return lruvec;
-	}
-	rcu_read_unlock();
 
-	if (locked_lruvec)
-		spin_unlock_irq(&locked_lruvec->lru_lock);
+	spin_unlock_irq(&locked_lruvec->lru_lock);
 
+lock:
 	lruvec = lock_page_lruvec_irq(page, pgdat);
-
 	return lruvec;
 }
 
@@ -1331,21 +1329,18 @@ static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,
 	struct pglist_data *pgdat = page_pgdat(page);
 	struct lruvec *lruvec;
 
-	rcu_read_lock();
+	if (!locked_lruvec)
+		goto lock;
+
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
-	if (locked_lruvec == lruvec) {
-		rcu_read_unlock();
+	if (locked_lruvec == lruvec)
 		return lruvec;
-	}
-	rcu_read_unlock();
 
-	if (locked_lruvec)
-		spin_unlock_irqrestore(&locked_lruvec->lru_lock,
-							locked_lruvec->flags);
+	spin_unlock_irqrestore(&locked_lruvec->lru_lock, locked_lruvec->flags);
 
+lock:
 	lruvec = lock_page_lruvec_irqsave(page, pgdat);
-
 	return lruvec;
 }
 
-- 
1.8.3.1

