From: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH] mm/memcontrol.c: use list_{first,next}_entry
Date: Thu,  3 Dec 2015 22:16:55 +0800
Message-ID: <9e62e3006561653fcbf0c49cf0b9c2b653a8ed0e.1449152124.git.geliangtang@163.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id; bh=GbHYB397YoI7oKq1Dx
	OVMp4QvI2r0ApCvK+ZbQoLbdM=; b=j2t6GmldPV5lzlyXcHr33+Gw5wnvS0zosg
	aeBBSyo1uD9ROzCbQHhtH3+uSrVeUDcwiN1229VXI3rTRciHkyrn4lBZVYz0MFAh
	IxiPRuljGn2xMkhsvK46/jHvm2ILtTMaKICcpMAJy2SI+vQmy5Z6dlZmOZoqmiWR
	sNI/z0oto=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

To make the intention clearer, use list_{first,next}_entry instead
of list_entry.

Signed-off-by: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
---
 mm/memcontrol.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 79a29d5..a6301ea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5395,16 +5395,12 @@ static void uncharge_list(struct list_head *page_list)
 	unsigned long nr_file = 0;
 	unsigned long nr_huge = 0;
 	unsigned long pgpgout = 0;
-	struct list_head *next;
 	struct page *page;
 
-	next = page_list->next;
+	page = list_first_entry(page_list, struct page, lru);
 	do {
 		unsigned int nr_pages = 1;
 
-		page = list_entry(next, struct page, lru);
-		next = page->lru.next;
-
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 		VM_BUG_ON_PAGE(page_count(page), page);
 
@@ -5440,7 +5436,8 @@ static void uncharge_list(struct list_head *page_list)
 		page->mem_cgroup = NULL;
 
 		pgpgout++;
-	} while (next != page_list);
+	} while (!list_is_last(&page->lru, page_list) &&
+		 (page = list_next_entry(page, lru)));
 
 	if (memcg)
 		uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
-- 
2.5.0

