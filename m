From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v20 08/20] mm: page_idle_get_page() does not need lru_lock
Date: Thu, 29 Oct 2020 18:44:53 +0800
Message-ID: <1603968305-8026-9-git-send-email-alex.shi@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com
Cc: Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>

From: Hugh Dickins <hughd@google.com>

It is necessary for page_idle_get_page() to recheck PageLRU() after
get_page_unless_zero(), but holding lru_lock around that serves no
useful purpose, and adds to lru_lock contention: delete it.

See https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop for the
discussion that led to lru_lock there; but __page_set_anon_rmap() now
uses WRITE_ONCE(), and I see no other risk in page_idle_clear_pte_refs()
using rmap_walk() (beyond the risk of racing PageAnon->PageKsm, mostly
but not entirely prevented by page_count() check in ksm.c's
write_protect_page(): that risk being shared with page_referenced() and
not helped by lru_lock).

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/page_idle.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/page_idle.c b/mm/page_idle.c
index 057c61df12db..64e5344a992c 100644
--- a/mm/page_idle.c
+++ b/mm/page_idle.c
@@ -32,19 +32,15 @@
 static struct page *page_idle_get_page(unsigned long pfn)
 {
 	struct page *page = pfn_to_online_page(pfn);
-	pg_data_t *pgdat;
 
 	if (!page || !PageLRU(page) ||
 	    !get_page_unless_zero(page))
 		return NULL;
 
-	pgdat = page_pgdat(page);
-	spin_lock_irq(&pgdat->lru_lock);
 	if (unlikely(!PageLRU(page))) {
 		put_page(page);
 		page = NULL;
 	}
-	spin_unlock_irq(&pgdat->lru_lock);
 	return page;
 }
 
-- 
1.8.3.1

