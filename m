From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: page-writeback: simplify memcg handling in test_clear_page_writeback()
Date: Tue,  9 Feb 2021 16:45:43 -0500
Message-ID: <20210209214543.112655-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EwcA9/MPS0+DC3O3HQWukmve7xuaXcZk9slnXQmx7cE=;
        b=wIT3T2WvKrwC5BKbIvNn7kdMwcTAScbRrfy18Jb8Zhtzgv/tJ/NMmI6yFeXmx+k+zt
         IAMVDHXZ9uks34GmNs68sEqzbBojhsn2RgNG8RCvtrE6RHopwENBg3jbgh3LGG65XQSy
         NPt/yTL38hj2tqZqevSZK70ul/wLkw9hmJljmQgwnVN0Q99ewpN7hr7kmujDldtFzpWZ
         J3W4K3szU4FwoHmBaYJDgsjBKctQ9T/3G7pFtNBuctYp5HkpCtTX4W7eVEV7lzKHiRIs
         I9/OKo/fFDMkIqhPr5e6FzDVIWPZhLcxuAgqgIIuNa2vpkc0rGZEX0eq0P7wzNG8aWVC
         x8iA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Page writeback doesn't hold a page reference, which allows truncate to
free a page the second PageWriteback is cleared. This used to require
special attention in test_clear_page_writeback(), where we had to be
careful not to rely on the unstable page->memcg binding and look up
all the necessary information before clearing the writeback flag.

Since commit 073861ed77b6 ("mm: fix VM_BUG_ON(PageTail) and
BUG_ON(PageWriteback)") test_clear_page_writeback() is called with an
explicit reference on the page, and this dance is no longer needed.

Use unlock_page_memcg() and dec_lruvec_page_stat() directly.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/page-writeback.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eb34d204d4ee..f6c2c3165d4d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2722,12 +2722,9 @@ EXPORT_SYMBOL(clear_page_dirty_for_io);
 int test_clear_page_writeback(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
 	int ret;
 
-	memcg = lock_page_memcg(page);
-	lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+	lock_page_memcg(page);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
@@ -2755,11 +2752,11 @@ int test_clear_page_writeback(struct page *page)
 		ret = TestClearPageWriteback(page);
 	}
 	if (ret) {
-		dec_lruvec_state(lruvec, NR_WRITEBACK);
+		dec_lruvec_page_state(page, NR_WRITEBACK);
 		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		inc_node_page_state(page, NR_WRITTEN);
 	}
-	__unlock_page_memcg(memcg);
+	unlock_page_memcg(page);
 	return ret;
 }
 
-- 
2.30.0

