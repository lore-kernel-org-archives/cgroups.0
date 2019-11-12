From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v2 1/8] mm/lru: add per lruvec lock for memcg
Date: Tue, 12 Nov 2019 22:06:21 +0800
Message-ID: <1573567588-47048-2-git-send-email-alex.shi@linux.alibaba.com>
References: <1573567588-47048-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1573567588-47048-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: alex.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com
Cc: Vlastimil Babka <vbabka@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, Wei Yang <richard.weiyang@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Arun KS <arunks@codeaurora.org>

Currently memcg still use per node pgdat->lru_lock to guard its lruvec.
That causes some lru_lock contention in a high container density system.

If we can use per lruvec lock, that could relief much of the lru_lock
contention.

The later patches will replace the pgdat->lru_lock with lruvec->lru_lock
and show the performance benefit by benchmarks.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Hugh Dickins <hughd@google.com>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/mmzone.h | 2 ++
 mm/mmzone.c            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index bda20282746b..787a42d527a2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -303,6 +303,8 @@ struct lruvec {
 	atomic_long_t			inactive_age;
 	/* Refaults at the time of last reclaim cycle */
 	unsigned long			refaults;
+	/* per lruvec lru_lock for memcg */
+	spinlock_t			lru_lock;
 #ifdef CONFIG_MEMCG
 	struct pglist_data *pgdat;
 #endif
diff --git a/mm/mmzone.c b/mm/mmzone.c
index 4686fdc23bb9..3750a90ed4a0 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -91,6 +91,7 @@ void lruvec_init(struct lruvec *lruvec)
 	enum lru_list lru;
 
 	memset(lruvec, 0, sizeof(struct lruvec));
+	spin_lock_init(&lruvec->lru_lock);
 
 	for_each_lru(lru)
 		INIT_LIST_HEAD(&lruvec->lists[lru]);
-- 
1.8.3.1

