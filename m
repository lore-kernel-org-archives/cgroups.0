From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v6 10/10] mm: revise the comments of mem_cgroup_page_lruvec
Date: Mon, 16 Dec 2019 17:26:26 +0800
Message-ID: <1576488386-32544-11-git-send-email-alex.shi@linux.alibaba.com>
References: <1576488386-32544-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1576488386-32544-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: Alex Shi <alex.shi@linux.alibaba.com>

From: Johannes Weiner <hannes@cmpxchg.org>

Better document the mem_cgroup_page_lruvec() caller requirements.

Suggested-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f8e279487e1d..552de2e7da0e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1202,9 +1202,18 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
  * @page: the page
  * @pgdat: pgdat of the page
  *
- * This function is only safe when following the LRU page isolation
- * and putback protocol: the LRU lock must be held, and the page must
- * either be PageLRU() or the caller must have isolated/allocated it.
+ * NOTE: The returned lruvec is only stable if the calling context has
+ * the page->mem_cgroup pinned! This is accomplished by satisfying one
+ * of the following criteria:
+ *
+ *    a) have the @page locked
+ *    b) have an exclusive reference to @page (e.g. refcount 0)
+ *    c) hold the lru_lock and "own" the PageLRU (meaning either ensure
+ *       it's set, or be the one to hold the page in isolation)
+ *
+ * Otherwise, the page could be freed or moved out of the memcg,
+ * thereby releasing its reference on the memcg and potentially
+ * freeing it and its lruvecs in the process.
  */
 struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
 {
-- 
1.8.3.1

