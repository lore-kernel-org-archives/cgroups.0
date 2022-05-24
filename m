From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v4 02/11] mm: memcontrol: introduce compact_folio_lruvec_lock_irqsave
Date: Tue, 24 May 2022 14:05:42 +0800
Message-ID: <20220524060551.80037-3-songmuchun@bytedance.com>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YQmbzG/x1UDz5U0yQVXExNL9W+QNwv5yyDN0QDopwLM=;
        b=SbFCQ3vJYsGUAEX8nyldT87US7H/Zi6r40ReQrz8S1DFmwuWGEoV2ZsawlDNV2F+b9
         cBbWPLt6WyLG/WEs6j6or7s/bkrS5fhQCtCJYspYV7YbDoGUD1Kpw7Cz19/bYZvOSmvn
         C7kr1O/qam5v/KZxRh4lh9qzOJtWk0NaaM5tm7fJrsj7KBzxuKuwY074AEzpGvXjXhRa
         OSdKGe9kRdi5MZEOyUCYPsJ6eblgDNZpMXrb7JA12Yd9Uc5u620Py3qTO2xYaCVNavdX
         iwklkT8fllKtpNXMNWn4waK8JwI1CM/uTxteV3N+Nq25H+HgDd0owN20+UIAf1N6TPfK
         7S+Q==
In-Reply-To: <20220524060551.80037-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

If we reuse the objcg APIs to charge LRU pages, the folio_memcg()
can be changed when the LRU pages reparented. In this case, we need
to acquire the new lruvec lock.

    lruvec = folio_lruvec(folio);

    // The page is reparented.

    compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);

    // Acquired the wrong lruvec lock and need to retry.

But compact_lock_irqsave() only take lruvec lock as the parameter,
we cannot aware this change. If it can take the page as parameter
to acquire the lruvec lock. When the page memcg is changed, we can
use the folio_memcg() detect whether we need to reacquire the new
lruvec lock. So compact_lock_irqsave() is not suitable for us.
Similar to folio_lruvec_lock_irqsave(), introduce
compact_folio_lruvec_lock_irqsave() to acquire the lruvec lock in
the compaction routine.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/compaction.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index fe915db6149b..817098817302 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -509,6 +509,29 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
 	return true;
 }
 
+static struct lruvec *
+compact_folio_lruvec_lock_irqsave(struct folio *folio, unsigned long *flags,
+				  struct compact_control *cc)
+{
+	struct lruvec *lruvec;
+
+	lruvec = folio_lruvec(folio);
+
+	/* Track if the lock is contended in async mode */
+	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
+		if (spin_trylock_irqsave(&lruvec->lru_lock, *flags))
+			goto out;
+
+		cc->contended = true;
+	}
+
+	spin_lock_irqsave(&lruvec->lru_lock, *flags);
+out:
+	lruvec_memcg_debug(lruvec, folio);
+
+	return lruvec;
+}
+
 /*
  * Compaction requires the taking of some coarse locks that are potentially
  * very heavily contended. The lock should be periodically unlocked to avoid
@@ -844,6 +867,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 	/* Time to isolate some pages for migration */
 	for (; low_pfn < end_pfn; low_pfn++) {
+		struct folio *folio;
 
 		if (skip_on_failure && low_pfn >= next_skip_pfn) {
 			/*
@@ -1065,18 +1089,17 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
 
-		lruvec = folio_lruvec(page_folio(page));
+		folio = page_folio(page);
+		lruvec = folio_lruvec(folio);
 
 		/* If we already hold the lock, we can skip some rechecking */
 		if (lruvec != locked) {
 			if (locked)
 				unlock_page_lruvec_irqrestore(locked, flags);
 
-			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
+			lruvec = compact_folio_lruvec_lock_irqsave(folio, &flags, cc);
 			locked = lruvec;
 
-			lruvec_memcg_debug(lruvec, page_folio(page));
-
 			/* Try get exclusive access under lock */
 			if (!skip_updated) {
 				skip_updated = true;
-- 
2.11.0

