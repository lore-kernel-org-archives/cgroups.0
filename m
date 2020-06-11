From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH alexv12 1/2] mm/compaction: fix isolate_migratepages_block()
 fails
Date: Thu, 11 Jun 2020 15:28:54 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2006111526290.10801@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=yQuXdwOztfCCh1OM0Y/znnoWVtA42w245nppjLu++SM=;
        b=C9efrmYgO5lfHiPabO9leNQkZRsdhlwEQGAWMA52SmmHSpafgnK+/l847DiwWOyBpj
         BAeGvslbj7wElzHda4DwvXS0ku8R79Ov2+bHCOh/Wc5QGdmv0su6wFBq2OfvGk2eaTGq
         u9MFt68ahkxY0WjRh3nuhhBOlrOW1MnYy8G6VghffVY4IdRBNay/7mj7FCjMHKTJv2ht
         GYwLGmvsv2JG78AtNqL4aAn4TX+q6VYmWxN1EECEZxgW8vMb3YpE6BvTsBs1SmWoAXbN
         k7edAcL63vK2Ld9noBiS6oSmq4WzbzSYWD0olZCdndrD21tLhFkspBj4YJEgjnw+feF7
         tXHQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Fix lots of crashes under compaction load: isolate_migratepages_block()
must clean up appropriately when rejecting a page, setting PageLRU again
if it had been cleared; and a put_page() after get_page_unless_zero()
cannot safely be done while holding locked_lruvec - it may turn out to
be the final put_page(), which will take an lruvec lock when PageLRU.

Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
These fixes should be folded into 10/16 and 12/16,
I have not tried to figure out what belongs in which.

 mm/compaction.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- alexv12/mm/compaction.c	2020-06-11 13:24:52.037154793 -0700
+++ hughd/mm/compaction.c	2020-06-11 13:48:10.437046025 -0700
@@ -879,6 +879,7 @@ isolate_migratepages_block(struct compac
 		if (!valid_page && IS_ALIGNED(low_pfn, pageblock_nr_pages)) {
 			if (!cc->ignore_skip_hint && get_pageblock_skip(page)) {
 				low_pfn = end_pfn;
+				page = NULL;
 				goto isolate_abort;
 			}
 			valid_page = page;
@@ -971,10 +972,8 @@ isolate_migratepages_block(struct compac
 			goto isolate_fail;
 
 		/* Try isolate the page */
-		if (!TestClearPageLRU(page)) {
-			put_page(page);
-			goto isolate_fail;
-		}
+		if (!TestClearPageLRU(page))
+			goto isolate_fail_put;
 
 		rcu_read_lock();
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
@@ -1005,7 +1004,8 @@ isolate_migratepages_block(struct compac
 			 */
 			if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
 				low_pfn += compound_nr(page) - 1;
-				goto isolate_fail;
+				SetPageLRU(page);
+				goto isolate_fail_put;
 			}
 		} else
 			rcu_read_unlock();
@@ -1038,6 +1038,15 @@ isolate_success:
 		}
 
 		continue;
+
+isolate_fail_put:
+		/* Avoid potential deadlock in freeing page under lru_lock */
+		if (locked_lruvec) {
+			unlock_page_lruvec_irqrestore(locked_lruvec, flags);
+			locked_lruvec = NULL;
+		}
+		put_page(page);
+
 isolate_fail:
 		if (!skip_on_failure)
 			continue;
@@ -1074,10 +1083,15 @@ isolate_fail:
 	 */
 	if (unlikely(low_pfn > end_pfn))
 		low_pfn = end_pfn;
+	page = NULL;
 
 isolate_abort:
 	if (locked_lruvec)
 		unlock_page_lruvec_irqrestore(locked_lruvec, flags);
+	if (page) {
+		SetPageLRU(page);
+		put_page(page);
+	}
 
 	/*
 	 * Updated the cached scanner pfn once the pageblock has been scanned
