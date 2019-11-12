From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v2 2/8] mm/lruvec: add irqsave flags into lruvec struct
Date: Tue, 12 Nov 2019 22:06:22 +0800
Message-ID: <1573567588-47048-3-git-send-email-alex.shi@linux.alibaba.com>
References: <1573567588-47048-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1573567588-47048-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: alex.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com
Cc: Vlastimil Babka <vbabka@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, Wei Yang <richard.weiyang@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Arun KS <arunks@codeaurora.org>, Rong Chen <rong.a.chen@intel.com>

We need a flags vaiable to save state when do irqsave action, declare it
here would make code more clear/clean.

Rong Chen <rong.a.chen@intel.com> report the flag variable needs to move
the tail of lruvec struct otherwise it causes 18% regressions of
vm-scalability testing on his machine. Add the flags and lru_lock to
both near struct tail.

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
index 787a42d527a2..da00615baa52 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -305,6 +305,8 @@ struct lruvec {
 	unsigned long			refaults;
 	/* per lruvec lru_lock for memcg */
 	spinlock_t			lru_lock;
+	/* flags for irqsave */
+	unsigned long			flags;
 #ifdef CONFIG_MEMCG
 	struct pglist_data *pgdat;
 #endif
-- 
1.8.3.1

