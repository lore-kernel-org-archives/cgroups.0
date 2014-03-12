From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 3/8] mm: memcg: inline mem_cgroup_charge_common()
Date: Tue, 11 Mar 2014 21:28:29 -0400
Message-ID: <1394587714-6966-4-git-send-email-hannes@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=0nJ65GouNb2MGEVR6od5+wBwLs7gBsUfNygMIjU1jg0=;
	b=hvPow6LjX1CMqEenf3n7OpBruq6gTcYplwEjUITQjgixMLmdnGpBYSSFfCNvOeh0JYzobvS8oT44xZ4swqEhJr/2/QPu0APkTrgkFrCJkeWXU0tFRWa/RTQrC0DRLLw6JNpGGLuu1oqZePJaSDYFz0QpFaqrDvrlIFyfYVwhq/g=;
In-Reply-To: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

mem_cgroup_charge_common() is used by both cache and anon pages, but
most of its body only applies to anon pages and the remainder is not
worth having in a separate function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5abdfab957ad..cfdb9c385d8d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3919,20 +3919,21 @@ out:
 	return ret;
 }
 
-/*
- * Charge the memory controller for page usage.
- * Return
- * 0 if the charge was successful
- * < 0 if the cgroup is over its limit
- */
-static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
-				gfp_t gfp_mask, enum charge_type ctype)
+int mem_cgroup_newpage_charge(struct page *page,
+			      struct mm_struct *mm, gfp_t gfp_mask)
 {
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
 	bool oom = true;
 	int ret;
 
+	if (mem_cgroup_disabled())
+		return 0;
+
+	VM_BUG_ON_PAGE(page_mapped(page), page);
+	VM_BUG_ON_PAGE(page->mapping && !PageAnon(page), page);
+	VM_BUG_ON(!mm);
+
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
@@ -3946,22 +3947,11 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
 	if (ret == -ENOMEM)
 		return ret;
-	__mem_cgroup_commit_charge(memcg, page, nr_pages, ctype, false);
+	__mem_cgroup_commit_charge(memcg, page, nr_pages,
+				   MEM_CGROUP_CHARGE_TYPE_ANON, false);
 	return 0;
 }
 
-int mem_cgroup_newpage_charge(struct page *page,
-			      struct mm_struct *mm, gfp_t gfp_mask)
-{
-	if (mem_cgroup_disabled())
-		return 0;
-	VM_BUG_ON_PAGE(page_mapped(page), page);
-	VM_BUG_ON_PAGE(page->mapping && !PageAnon(page), page);
-	VM_BUG_ON(!mm);
-	return mem_cgroup_charge_common(page, mm, gfp_mask,
-					MEM_CGROUP_CHARGE_TYPE_ANON);
-}
-
 /*
  * While swap-in, try_charge -> commit or cancel, the page is locked.
  * And when try_charge() successfully returns, one refcnt to memcg without
@@ -4079,9 +4069,11 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 	if (PageCompound(page))
 		return 0;
 
-	if (!PageSwapCache(page))
-		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
-	else { /* page is swapcache/shmem */
+	if (!PageSwapCache(page)) {
+		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
+		if (ret != -ENOMEM)
+			__mem_cgroup_commit_charge(memcg, page, 1, type, false);
+	} else { /* page is swapcache/shmem */
 		ret = __mem_cgroup_try_charge_swapin(mm, page,
 						     gfp_mask, &memcg);
 		if (!ret)
-- 
1.9.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
