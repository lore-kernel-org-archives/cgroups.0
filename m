From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v5 10/11] mm: lru: add VM_BUG_ON_FOLIO to lru maintenance function
Date: Mon, 30 May 2022 15:49:18 +0800
Message-ID: <20220530074919.46352-11-songmuchun@bytedance.com>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c1uSXYTb359GYZYUL38E0tsCvHSowrqKxSPkaS7BCw0=;
        b=Z+vIgsb9cnaEHIul2toSXUm6rrCc47T9Tan81WiyTc8fO5XEV8I1D0ZFf2vl7MhWLH
         kLBQa8mUAWBL97TrBJ4ySat0p7EVMxZ9DfvEJgOWcsN9kO+4aSfWwa6W1telCGw6aHwN
         3CiTzRdDD3omXqegxcAje7SfZfyHu57wPelMG9sAHBaqD980yvgFNENio5LLl8JPnXRH
         N1LgGOA1LxRBixOD66Ngx0ua5As3E1N3oOgQlrtXJlCbziPvms/69m7Usnjz8Gt5hwDO
         U6mY4k2NR0vVq1xWJaoddNfTFC37xhE8DosrvuxlbyNp2gAbhMr3NkLJlYCrIoKN/fnB
         TAug==
In-Reply-To: <20220530074919.46352-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com, longman@redhat.com, Muchun Song <songmuchun@bytedance.com>

We need to make sure that the page is deleted from or added to the
correct lruvec list. So add a VM_WARN_ON_ONCE_FOLIO() to catch
invalid users.  Then the VM_BUG_ON_PAGE() in move_pages_to_lru()
could be removed since add_page_to_lru_list() will check that.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm_inline.h | 6 ++++++
 mm/vmscan.c               | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ac32125745ab..e13e56c7fdbd 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -97,6 +97,8 @@ void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			folio_nr_pages(folio));
 	if (lru != LRU_UNEVICTABLE)
@@ -114,6 +116,8 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			folio_nr_pages(folio));
 	/* This is not expected to be used on LRU_UNEVICTABLE */
@@ -131,6 +135,8 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru != LRU_UNEVICTABLE)
 		list_del(&folio->lru);
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 67f1462b150d..51853d6df7b4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2277,7 +2277,6 @@ static unsigned int move_pages_to_lru(struct list_head *list)
 			continue;
 		}
 
-		VM_BUG_ON_PAGE(!folio_matches_lruvec(folio, lruvec), page);
 		add_page_to_lru_list(page, lruvec);
 		nr_pages = thp_nr_pages(page);
 		nr_moved += nr_pages;
-- 
2.11.0

