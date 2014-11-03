From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] mm: move page->mem_cgroup bad page handling into generic
 code fix
Date: Mon, 3 Nov 2014 13:27:40 -0500
Message-ID: <20141103182740.GA10816@phnom.home.cmpxchg.org>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
 <1414898156-4741-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1414898156-4741-3-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>, David Miller <davem@davemloft.net>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Remove unneeded !CONFIG_MEMCG memcg bad_page() dummies as well.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e789551d4db0..41ae72b02b55 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -342,19 +342,6 @@ void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 }
 #endif /* CONFIG_MEMCG */
 
-#if !defined(CONFIG_MEMCG) || !defined(CONFIG_DEBUG_VM)
-static inline bool
-mem_cgroup_bad_page_check(struct page *page)
-{
-	return false;
-}
-
-static inline void
-mem_cgroup_print_bad_page(struct page *page)
-{
-}
-#endif
-
 enum {
 	UNDER_LIMIT,
 	SOFT_LIMIT,
-- 
2.1.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
