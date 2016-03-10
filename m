From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] mm: memcontrol: clarify the uncharge_list() loop
Date: Thu, 10 Mar 2016 15:50:15 -0500
Message-ID: <1457643015-8828-3-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

uncharge_list() does an unusual list walk because the function can
take regular lists with dedicated list_heads as well as singleton
lists where a single page is passed via the page->lru list node.

This can sometimes lead to confusion as well as suggestions to replace
the loop with a list_for_each_entry(), which wouldn't work.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8614e0d750e5..fa7bf354ae32 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5420,6 +5420,10 @@ static void uncharge_list(struct list_head *page_list)
 	struct list_head *next;
 	struct page *page;
 
+	/*
+	 * Note that the list can be a single page->lru; hence the
+	 * do-while loop instead of a simple list_for_each_entry().
+	 */
 	next = page_list->next;
 	do {
 		unsigned int nr_pages = 1;
-- 
2.7.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
