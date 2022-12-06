From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 1/3] mm: memcontrol: skip moving non-present pages that are mapped elsewhere
Date: Tue,  6 Dec 2022 18:13:39 +0100
Message-ID: <20221206171340.139790-2-hannes@cmpxchg.org>
References: <20221206171340.139790-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KduHn+5gyrCZCJ3PZZKBhevPs/yCR7iZhiHXyVA0CdE=;
        b=U1tH6w6XQXpYI+Hv+M2BpssrkbT69EZiZtCJ8KUrJiRcGor3DEDhd1mEQhmYBwNQAL
         9YedqqgQJoMza6N6wOnCopBmkDUVl4TGszL7044J1ET/RB82yJLOSkO3A10sVEkWg8tw
         0z38g0G+6klmx7+DUWF/Lj59zdXgVZZkiBhgPm7HtpP6UoAVuRquXY0sRXXXI3tZin53
         VD8Oobr5c3lkHwIXOQw6vLPebCgDSNO7nkyR39EwRxodTc4l3/xeYHpMD0CAYMriMrd2
         N6OnCJlPli+HAoMxQiW5waMNstoUqDSvHSRvQNN/Uv8NqyA+jeyP7SgUNW7gld1NZOSf
         l4zg==
In-Reply-To: <20221206171340.139790-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

During charge moving, the pte lock and the page lock cover nearly all
cases of stabilizing page_mapped(). The only exception is when we're
looking at a non-present pte and find a page in the page cache or in
the swapcache: if the page is mapped elsewhere, it can become unmapped
outside of our control. For this reason, rmap needs lock_page_memcg().

We don't like cgroup-specific locks in generic MM code - especially in
performance-critical MM code - and for a legacy feature that's
unlikely to have many users left - if any.

So remove the exception. Arguably that's better semantics anyway: the
page is shared, and another process seems to be the more active user.

Once we stop moving such pages, rmap doesn't need lock_page_memcg()
anymore. The next patch will remove it.

Suggested-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 52 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 48c44229cf47..b696354c1b21 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5681,7 +5681,7 @@ static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
  *
- * The caller must make sure the page is not on LRU (isolate_page() is useful.)
+ * The page must be locked and not on the LRU.
  *
  * This function doesn't do "charge" to new cgroup and doesn't do "uncharge"
  * from old cgroup.
@@ -5698,20 +5698,13 @@ static int mem_cgroup_move_account(struct page *page,
 	int nid, ret;
 
 	VM_BUG_ON(from == to);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 	VM_BUG_ON(compound && !folio_test_large(folio));
 
-	/*
-	 * Prevent mem_cgroup_migrate() from looking at
-	 * page's memory cgroup of its source page while we change it.
-	 */
-	ret = -EBUSY;
-	if (!folio_trylock(folio))
-		goto out;
-
 	ret = -EINVAL;
 	if (folio_memcg(folio) != from)
-		goto out_unlock;
+		goto out;
 
 	pgdat = folio_pgdat(folio);
 	from_vec = mem_cgroup_lruvec(from, pgdat);
@@ -5798,8 +5791,6 @@ static int mem_cgroup_move_account(struct page *page,
 	mem_cgroup_charge_statistics(from, -nr_pages);
 	memcg_check_events(from, nid);
 	local_irq_enable();
-out_unlock:
-	folio_unlock(folio);
 out:
 	return ret;
 }
@@ -5848,6 +5839,29 @@ static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 	else if (is_swap_pte(ptent))
 		page = mc_handle_swap_pte(vma, ptent, &ent);
 
+	if (target && page) {
+		if (!trylock_page(page)) {
+			put_page(page);
+			return ret;
+		}
+		/*
+		 * page_mapped() must be stable during the move. This
+		 * pte is locked, so if it's present, the page cannot
+		 * become unmapped. If it isn't, we have only partial
+		 * control over the mapped state: the page lock will
+		 * prevent new faults against pagecache and swapcache,
+		 * so an unmapped page cannot become mapped. However,
+		 * if the page is already mapped elsewhere, it can
+		 * unmap, and there is nothing we can do about it.
+		 * Alas, skip moving the page in this case.
+		 */
+		if (!pte_present(ptent) && page_mapped(page)) {
+			unlock_page(page);
+			put_page(page);
+			return ret;
+		}
+	}
+
 	if (!page && !ent.val)
 		return ret;
 	if (page) {
@@ -5864,8 +5878,11 @@ static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 			if (target)
 				target->page = page;
 		}
-		if (!ret || !target)
+		if (!ret || !target) {
+			if (target)
+				unlock_page(page);
 			put_page(page);
+		}
 	}
 	/*
 	 * There is a swap entry and a page doesn't exist or isn't charged.
@@ -5905,6 +5922,10 @@ static enum mc_target_type get_mctgt_type_thp(struct vm_area_struct *vma,
 		ret = MC_TARGET_PAGE;
 		if (target) {
 			get_page(page);
+			if (!trylock_page(page)) {
+				put_page(page);
+				return MC_TARGET_NONE;
+			}
 			target->page = page;
 		}
 	}
@@ -6143,6 +6164,7 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
 				}
 				putback_lru_page(page);
 			}
+			unlock_page(page);
 			put_page(page);
 		} else if (target_type == MC_TARGET_DEVICE) {
 			page = target.page;
@@ -6151,6 +6173,7 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
 				mc.precharge -= HPAGE_PMD_NR;
 				mc.moved_charge += HPAGE_PMD_NR;
 			}
+			unlock_page(page);
 			put_page(page);
 		}
 		spin_unlock(ptl);
@@ -6193,7 +6216,8 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
 			}
 			if (!device)
 				putback_lru_page(page);
-put:			/* get_mctgt_type() gets the page */
+put:			/* get_mctgt_type() gets & locks the page */
+			unlock_page(page);
 			put_page(page);
 			break;
 		case MC_TARGET_SWAP:
-- 
2.38.1

