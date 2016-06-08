From: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] mm: memcontrol: remove BUG_ON in uncharge_list
Date: Wed,  8 Jun 2016 15:00:48 +0800
Message-ID: <1465369248-13865-1-git-send-email-roy.qing.li@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

when call uncharge_list, if a page is transparent huge, and not need to
BUG_ON about non-transparent huge, since nobody should be be seeing the
page at this stage and this page cannot be raced with a THP split up

Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4d9a215..d7a56f1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5457,7 +5457,6 @@ static void uncharge_list(struct list_head *page_list)
 
 		if (PageTransHuge(page)) {
 			nr_pages <<= compound_order(page);
-			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 			nr_huge += nr_pages;
 		}
 
-- 
2.1.4
