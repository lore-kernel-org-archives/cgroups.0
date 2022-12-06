From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 2/3] mm: rmap: remove lock_page_memcg()
Date: Tue,  6 Dec 2022 18:13:40 +0100
Message-ID: <20221206171340.139790-3-hannes@cmpxchg.org>
References: <20221206171340.139790-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10IT05+HKhb7xyirRRNdh88kI/5idGFXpcCcjOl6q8w=;
        b=uhHfurOuRNSHba5bcgYmHYTUiA0/YQOE6uTGKT8Nlcmry8Tts8/UpjfQ4dm10Rm3yF
         uwkMG3xtgqkmQ2FFsCCiTFe2q2QL5Ml99J3lDmyTYSbiu/vlsJJTOzc/rc6Ry1jRSKvY
         iqu4J98q8ZTNmGg26MTPVifMLjCyjIlyOmcx4ifNd5Tr368zq5meHCenw/bXIzm6w1FA
         fCnOb5UmPsn1+RqvMqwZKgSO2IcO8MmnYWogG426iZHQQb4cILJz/fSHqpNipzX9kxdN
         XCSKZBMRd1s3w6KC1U9lxsD54O3g3JBbdyxhjnR4Y8JhslpAg4hiNFX9CYv8+rpKR3at
         wjKQ==
In-Reply-To: <20221206171340.139790-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The previous patch made sure charge moving only touches pages for
which page_mapped() is stable. lock_page_memcg() is no longer needed.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/rmap.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index b616870a09be..32e48b1c5847 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1222,9 +1222,6 @@ void page_add_anon_rmap(struct page *page,
 	bool compound = flags & RMAP_COMPOUND;
 	bool first = true;
 
-	if (unlikely(PageKsm(page)))
-		lock_page_memcg(page);
-
 	/* Is page being mapped by PTE? Is this its first map to be added? */
 	if (likely(!compound)) {
 		first = atomic_inc_and_test(&page->_mapcount);
@@ -1262,15 +1259,14 @@ void page_add_anon_rmap(struct page *page,
 	if (nr)
 		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 
-	if (unlikely(PageKsm(page)))
-		unlock_page_memcg(page);
-
-	/* address might be in next vma when migration races vma_adjust */
-	else if (first)
-		__page_set_anon_rmap(page, vma, address,
-				     !!(flags & RMAP_EXCLUSIVE));
-	else
-		__page_check_anon_rmap(page, vma, address);
+	if (likely(!PageKsm(page))) {
+		/* address might be in next vma when migration races vma_adjust */
+		if (first)
+			__page_set_anon_rmap(page, vma, address,
+					     !!(flags & RMAP_EXCLUSIVE));
+		else
+			__page_check_anon_rmap(page, vma, address);
+	}
 
 	mlock_vma_page(page, vma, compound);
 }
@@ -1329,7 +1325,6 @@ void page_add_file_rmap(struct page *page,
 	bool first;
 
 	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
-	lock_page_memcg(page);
 
 	/* Is page being mapped by PTE? Is this its first map to be added? */
 	if (likely(!compound)) {
@@ -1365,7 +1360,6 @@ void page_add_file_rmap(struct page *page,
 			NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED, nr_pmdmapped);
 	if (nr)
 		__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
-	unlock_page_memcg(page);
 
 	mlock_vma_page(page, vma, compound);
 }
@@ -1394,8 +1388,6 @@ void page_remove_rmap(struct page *page,
 		return;
 	}
 
-	lock_page_memcg(page);
-
 	/* Is page being unmapped by PTE? Is this its last map to be removed? */
 	if (likely(!compound)) {
 		last = atomic_add_negative(-1, &page->_mapcount);
@@ -1451,8 +1443,6 @@ void page_remove_rmap(struct page *page,
 	 * and remember that it's only reliable while mapped.
 	 */
 
-	unlock_page_memcg(page);
-
 	munlock_vma_page(page, vma, compound);
 }
 
-- 
2.38.1

