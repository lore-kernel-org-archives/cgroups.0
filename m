From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v4 10/11] mm: lru: add VM_BUG_ON_FOLIO to lru maintenance function
Date: Tue, 24 May 2022 14:05:50 +0800
Message-ID: <20220524060551.80037-11-songmuchun@bytedance.com>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VRT3nBeIYnWORjFGgUrNJZAuxlpJgLGLO13gTpDFHrE=;
        b=8PujjlnVeI6J13WyXz+kTgVIeMvRKAqjfBM0f1CZmy36ow271MYI1koRfaVOmeJavo
         Bs6vuCtvQeR3d/rfyKlU46F2aCsbDIA1I/fsRTvx6nYln1rHXcV/5W0D3ELxK6f1Ecf0
         CgSkMRA+a6v523xf+ZMs8mZOboyjugRwM4p+rSQQVV96/4eqCmeA4bx9GC2Ea4nfhfLA
         e4J7q7p8Sh/wemkRgQ8iepBIjupiT6ANaVxSGo8at6IjIg7l5+4pQW/g2oACvZBzt5nh
         mrC6iOGQTKu9NVxBoj3Ly9LRXo42V7ul8yyjUhEsvxaGZug3w3wgm7U09e2lU3e4CB9F
         HFUw==
In-Reply-To: <20220524060551.80037-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

We need to make sure that the page is deleted from or added to the
correct lruvec list. So add a VM_BUG_ON_FOLIO() to catch invalid
users.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/mm_inline.h | 6 ++++++
 mm/vmscan.c               | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ac32125745ab..30d2393da613 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -97,6 +97,8 @@ void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			folio_nr_pages(folio));
 	if (lru != LRU_UNEVICTABLE)
@@ -114,6 +116,8 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			folio_nr_pages(folio));
 	/* This is not expected to be used on LRU_UNEVICTABLE */
@@ -131,6 +135,8 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru != LRU_UNEVICTABLE)
 		list_del(&folio->lru);
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 761d5e0dd78d..6c9e2eafc8f9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2281,7 +2281,6 @@ static unsigned int move_pages_to_lru(struct list_head *list)
 			continue;
 		}
 
-		VM_BUG_ON_PAGE(!folio_matches_lruvec(folio, lruvec), page);
 		add_page_to_lru_list(page, lruvec);
 		nr_pages = thp_nr_pages(page);
 		nr_moved += nr_pages;
-- 
2.11.0

