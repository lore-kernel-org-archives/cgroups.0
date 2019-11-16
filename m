From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v3 2/7] mm/lruvec: add irqsave flags into lruvec struct
Date: Sat, 16 Nov 2019 11:15:01 +0800
Message-ID: <1573874106-23802-3-git-send-email-alex.shi@linux.alibaba.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: alex.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org
Cc: Vlastimil Babka <vbabka@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, Wei Yang <richard.weiyang@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Arun KS <arunks@codeaurora.org>, Rong Chen <rong.a.chen@intel.com>

We need a irqflags vaiable to save state when do irqsave action, declare
it here would make code more clear/clean.

Rong Chen <rong.a.chen@intel.com> reported the 'irqflags' variable need
move to the tail of lruvec struct otherwise it causes 18% regressions of
vm-scalability testing on his machine. So add the flags and lru_lock to
both near struct tail, even I have no clue of this perf losing.

Originally-from: Hugh Dickins <hughd@google.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
CC: Rong Chen <rong.a.chen@intel.com>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/mmzone.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a13b8a602ee5..9b8b8daf4e03 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -269,6 +269,8 @@ struct lruvec {
 	unsigned long			flags;
 	/* per lruvec lru_lock for memcg */
 	spinlock_t			lru_lock;
+	/* flags for irqsave */
+	unsigned long			irqflags;
 #ifdef CONFIG_MEMCG
 	struct pglist_data *pgdat;
 #endif
-- 
1.8.3.1

