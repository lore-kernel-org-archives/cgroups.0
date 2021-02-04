From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] mm: memcontrol: replace the loop with a list_for_each_entry()
Date: Thu,  4 Feb 2021 18:53:20 +0800
Message-ID: <20210204105320.46072-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bomnKjBCXlMUt7cumGwFSxIt2tLEfiNfG1uDxtiHzHo=;
        b=meRFeoFABKNahcTD5pEZi9cJb0xVYtEo0jR+vAzCdEludgjz8sf1Qlv2/xeRPDfibp
         /MMKS0gDIAcIwS+spfwSSxSYmiHHlYLXKz78sdAEln7aHWvn0QsCJNlPvKVOmygR7EfF
         nSWXTdN5o2V9xWtAhYeJgMlGZE86yc7er/RVSRnjuvKWa6RjgUQXsVKFyMLzh72oLILh
         ZefaeRzKTsudfYwco8W1CE1Vr2eIFb+VxUGIitkSeo2UM5YS+/bx7Xwr9TH4t1EkX+rc
         uS0RLOQkFJ07jRmOC12Y7X8c6oWiSWepD2xx1ceyRtqiYop3Hqiqt9lcpsOK7wc4pLM+
         sZlw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The rule of list walk has gone since:

 commit a9d5adeeb4b2 ("mm/memcontrol: allow to uncharge page without using page->lru field")

So remove the strange comment and replace the loop with a
list_for_each_entry().

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/memcontrol.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6c7f1ea3955e..43341bd7ea1c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6891,24 +6891,11 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 static void uncharge_list(struct list_head *page_list)
 {
 	struct uncharge_gather ug;
-	struct list_head *next;
+	struct page *page;
 
 	uncharge_gather_clear(&ug);
-
-	/*
-	 * Note that the list can be a single page->lru; hence the
-	 * do-while loop instead of a simple list_for_each_entry().
-	 */
-	next = page_list->next;
-	do {
-		struct page *page;
-
-		page = list_entry(next, struct page, lru);
-		next = page->lru.next;
-
+	list_for_each_entry(page, page_list, lru)
 		uncharge_page(page, &ug);
-	} while (next != page_list);
-
 	uncharge_batch(&ug);
 }
 
-- 
2.11.0

