From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 1/2] mm: page-writeback: inline account_page_dirtied() into single caller
Date: Wed, 22 Oct 2014 14:29:27 -0400
Message-ID: <1414002568-21042-2-git-send-email-hannes@cmpxchg.org>
References: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

A follow-up patch would have changed the call signature.  To save the
trouble, just fold it instead.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "3.17" <stable@kernel.org>
---
 include/linux/mm.h  |  1 -
 mm/page-writeback.c | 23 ++++-------------------
 2 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 27eb1bfbe704..b46461116cd2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1235,7 +1235,6 @@ int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
 void account_page_dirtied(struct page *page, struct address_space *mapping);
-void account_page_writeback(struct page *page);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ff24c9d83112..ff6a5b07211e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2116,23 +2116,6 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 EXPORT_SYMBOL(account_page_dirtied);
 
 /*
- * Helper function for set_page_writeback family.
- *
- * The caller must hold mem_cgroup_begin/end_update_page_stat() lock
- * while calling this function.
- * See test_set_page_writeback for example.
- *
- * NOTE: Unlike account_page_dirtied this does not rely on being atomic
- * wrt interrupts.
- */
-void account_page_writeback(struct page *page)
-{
-	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
-	inc_zone_page_state(page, NR_WRITEBACK);
-}
-EXPORT_SYMBOL(account_page_writeback);
-
-/*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
  * its radix tree.
  *
@@ -2410,8 +2393,10 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 	} else {
 		ret = TestSetPageWriteback(page);
 	}
-	if (!ret)
-		account_page_writeback(page);
+	if (!ret) {
+		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
+		inc_zone_page_state(page, NR_WRITEBACK);
+	}
 	mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
 	return ret;
 
-- 
2.1.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
