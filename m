From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v9 20/20] mm/memcg: add debug checking in lock_page_memcg
Date: Mon,  2 Mar 2020 19:00:30 +0800
Message-ID: <1583146830-169516-21-git-send-email-alex.shi@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org

This extra irq disable/enable and BUG_ON checking costs 5% readtwice
performance on a 2 socket * 26 cores * HT box. So put it into
CONFIG_PROVE_LOCKING.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2d71e53ead88..8d7f6336f15c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2026,6 +2026,12 @@ struct mem_cgroup *lock_page_memcg(struct page *page)
 	if (unlikely(!memcg))
 		return NULL;
 
+#ifdef CONFIG_PROVE_LOCKING
+	local_irq_save(flags);
+	might_lock(&memcg->move_lock);
+	local_irq_restore(flags);
+#endif
+
 	if (atomic_read(&memcg->moving_account) <= 0)
 		return memcg;
 
-- 
1.8.3.1

