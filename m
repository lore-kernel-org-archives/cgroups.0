Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E9248988A
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671978; cv=none; b=q5Tqdcd5WUmqx/y+pd8cVgbN7HBMvv9/0heUh1yqtdo4fb6a/uOfQyxiAToFeQcatjd6hfIH3Kk7eJAam8PaUsnb+tPZON61rm6JlqaOt00dPWjfL7vdnNyfw7akHsLT6XAlUeEa2r7mpjTH5alL6bbLm6PaBarF9tVlMvYbbQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671978; c=relaxed/simple;
	bh=Ir7mgcdvJ+mFq7iklAS0VdxMoNgKMp+NYlmRq0N0Cfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTSmRnl2JXsrhLeEfWusMZrMgF7VrWUhP1ssVmZYbHUcIG5V3L2nVrTPkvTNBerUegb2Wq91WKdlbLZYs4xNwZE2bipRlqe6uwmlXkAKZbeZsU2AqC0rcrroEXOaiTpO8zgzTi6JpSYUwRfRPdRJTZObbpurOgQor7bhxgrrpyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h77wn25U; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h77wn25U"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7ec1e9d3359so4771855a34.0
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 08:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671969; x=1788276769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZiuIUjxHZJqBtUh4LQgpSrUu+vgbaWcl2GsgQdNoZNs=;
        b=h77wn25Umw1Z5ogY9kIsLSkh5I1kjHH9VyAokBCOUj0odIeC8pCmySsrx0aS7RJgOh
         tbR5IT1tWpXKajyEe6u/zK+OkLeNq+TD6pYhMPwJX6dSVb7gl9+bdOUDXFMt0FhUaiAN
         /WmDWSDPpLVImXUBfvnpaqyoKlEWz/GXDYPUTgIBYdXncSgxuq51jL5VKa3KuwhW6jaQ
         NiTYE+iH7yWov3VkfRNUCldivFwc6rkom+K9tWTLxOKgPTEGEp0Nq2pcJNOrQ/pbodf2
         WVj3JFrTczm3AFu/mtMSmK3yw0rbDTn6YUTpyAmlhpmcreWigeAiTqQUtvPXHlXsgzzN
         K1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671969; x=1788276769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZiuIUjxHZJqBtUh4LQgpSrUu+vgbaWcl2GsgQdNoZNs=;
        b=jfJZnJ1Hwb4DElmZlmqiRJQFZti3Jx4Xce1Euietscg/Pqp54zPkNOJ7ZjsRItQeNq
         HjyAgltFxlYyj3Wurp/zbWWftIl5bzyKk8e8FHa7FQjwkOXeubM4yVPcKCUIQTRd9mqh
         Tpo+R7cs0JKVDpUs9IplR6pZBclCduVVJXjPF/T0NySiwkbx85Ems/MJcieP/SzdnwQn
         zUtSqeQIArjbJFwG6ij6HAd9BfmJpt70k4ZfrOVwvuLK2dWOIWEwfh6MMHTNLlFPxMge
         m8I+1jfErj4kFXNR15KOSniEKqqAUm86WDakUfbjicEJYrUQKn8RsVx2SqjBHvcSHg26
         F//Q==
X-Forwarded-Encrypted: i=1; AHgh+RrFb5xGj3lpdPg4tc+6gOb+lPS8RIOXQb6ltYnLf5rIkAODtz98U+0r82AO8bbvdGBcqYMX+K8Z@vger.kernel.org
X-Gm-Message-State: AFuF++nOZ3sAwqIbkZTjbvsVYkznraHedQUPsC/293Vrim+ZzIEWtnxs
	+M77YPsfFPqnNPwHrBErOj7OLauWLoHkrlQTiflgdyniDe3Zma1V6Ke/
X-Gm-Gg: AR+sD13WaA4+Dz25IDSUWzvS4bwvW2OZYq6InQptsRA2mfF7bi/runXifXXFmr0yPk6
	6ipp8SFkEtRjBuMKhJElpkdPSCMphd+WVg/4Cdx72OH0syno0rSusoay+jYt7RZxrjb/jqmb8um
	zFn5f4moMg8yhuJSRum5Le+gjIXHrTdD9+Qf7NCEJbZI9Kq1do1IldJ3R8rivBR57DlYyXHUuQc
	O6sDHNlTX5mFRrhetBiOt2WBD9HPJDZS6oCXVETZxlH2yFAYz5dNL9dq0zvsauvGumzu0tKMGpo
	nMTliOczMPK3BpOWq/TwACznMqbVA5p/Hx8Kz6nTME4knJQPShdUxHWzoTM7VEbk71KGsSwdP66
	HbrjwQqFeoXboPQgrKhhvNIPJSjmENyHnxfaOsJ618CWTaFb+9bqs21FY0iJqPd9tlT9naMkkRA
	rQ4Y1n3K7hNBlG2Xf8IG6NlYiuvAcBCFNpc1007sDLKFKwG3QqbOuwD5IPLji8/QldY4guQ6Euk
	SbB2amAxWg=
X-Received: by 2002:a05:6830:2a03:b0:7e6:8955:c52d with SMTP id 46e09a7af769-7f4613368demr40060364a34.5.1787671968548;
        Tue, 25 Aug 2026 08:32:48 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5b::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fc7fb48sm7732206a34.19.2026.08.25.08.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:47 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v4 04/11] mm, swap: support physical swap as a vswap backend
Date: Tue, 25 Aug 2026 08:32:30 -0700
Message-ID: <20260825153238.2695446-5-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add physical swap as a backend for the virtual swap layer. When zswap
declines a page, the swapout path allocates a physical slot on demand
for swap out.

Each vswap entry's physical slot is tracked via a pointer-tagged
swap_table entry on the physical cluster (an rmap back to the vswap
entry).

Physical readahead scans a whole offset window and would trip over
these rmap slots, so __swap_cache_add_check() now skips
swp_tb_is_pointer() entries. Nothing is lost: a backing slot is
faulted through its owning vswap entry, never through the physical
offset.

swapoff reads each vswap entry back through its rmap slot before freeing
the physical slot. A failed read leaves the folio not uptodate, so drop
it instead of marking it dirty: dirtying would write uninitialised memory
out to swap, and the loss is now reported as SIGBUS on the next fault
rather than silently returning stale data.

If zswap is disabled at the host level or for the folio's cgroup, the
folio still gets a physical swap slot, bypassing vswap and mapping the
slot directly into the PTEs. In practice the swapfile backend is only
reached when zswap declines the folio at swap_writeout() time, most often
because the pool is full.

The machinery is in place, but its main consumer is not. Zswap writeback
to physical swap is added in a following patch. Reclaim of physical slots
backing cache-only vswap entries follows it.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c     |  13 +-
 mm/page_io.c    |  42 ++++--
 mm/swap_state.c |   6 +-
 mm/swap_table.h |  42 +++++-
 mm/swapfile.c   | 358 +++++++++++++++++++++++++++++++++++++++++++-----
 mm/vmscan.c     |   2 +-
 mm/vswap.h      | 198 +++++++++++++++++++++++++-
 mm/zswap.c      |   2 +-
 8 files changed, 602 insertions(+), 61 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 181a90fa2211..dc4dd72ce73b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4660,10 +4660,13 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 	 * are fast, and meanwhile, swap cache pinning the slot deferring the
 	 * release of metadata or fragmentation is a more critical issue.
 	 */
-	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+	if (swap_entry_backend_has_flag(si, folio->swap, SWP_SYNCHRONOUS_IO))
 		return true;
-	/* A vswap entry holds no physical slot, so keeping it saves no IO. */
-	if (is_vswap_entry(folio->swap))
+	/*
+	 * Non-swapfile backends cannot be reused for future swapouts.
+	 * Free the swap slot unless backed by contiguous physical swap.
+	 */
+	if (!folio_phys_swap_backed(folio))
 		return true;
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
@@ -4970,7 +4973,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		swap_update_readahead(folio, vma, vmf->address);
 	if (!folio) {
 		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		if (swap_entry_backend_has_flag(si, entry, SWP_SYNCHRONOUS_IO))
 			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
 					    thp_swapin_suitable_orders(vmf) | BIT(0),
 					    vmf, NULL, 0);
@@ -5135,7 +5138,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			 */
 			exclusive = true;
 		} else if (exclusive && folio_test_writeback(folio) &&
-			  data_race(si->flags & SWP_STABLE_WRITES)) {
+			  swap_entry_backend_has_flag(si, entry, SWP_STABLE_WRITES)) {
 			/*
 			 * This is tricky: not all swap backends support
 			 * concurrent page modifications while under writeback.
diff --git a/mm/page_io.c b/mm/page_io.c
index a3aaa61d6c79..b36a898358c6 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -209,6 +209,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
  */
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
+	swp_entry_t phys;
 	int ret = 0;
 
 	if (folio_free_swap(folio))
@@ -241,8 +242,14 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	 */
 	swap_zeromap_folio_clear(folio);
 
+	/*
+	 * For vswap: release stale non-swapfile backings (e.g. ZSWAP from a
+	 * previous swapout cycle) so zswap_store or folio_realloc_swap
+	 * starts on clean slots. Contiguous PHYS backing is preserved for
+	 * reuse by folio_realloc_swap.
+	 */
 	if (is_vswap_entry(folio->swap))
-		folio_release_vswap_backing(folio);
+		folio_release_non_phys_swap_backing(folio);
 
 	if (zswap_store(folio)) {
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
@@ -258,11 +265,19 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	rcu_read_unlock();
 
 	/*
-	 * A vswap folio has no physical slot to write to, so keep it dirty.
+	 * A vswap folio with no backend needs a physical slot to write to.
+	 * zswap_store rolled back any partial vtable state on failure, so
+	 * PHYS backing from a prior cycle is still there to reuse. If none
+	 * is free, keep it dirty.
 	 */
 	if (is_vswap_entry(folio->swap)) {
-		folio_mark_dirty(folio);
-		return AOP_WRITEPAGE_ACTIVATE;
+		phys = folio_realloc_swap(folio);
+		if (!phys.val) {
+			folio_mark_dirty(folio);
+			return AOP_WRITEPAGE_ACTIVATE;
+		}
+		__swap_writepage(ctx, folio, phys);
+		return 0;
 	}
 
 	__swap_writepage(ctx, folio, folio->swap);
@@ -473,6 +488,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
+	swp_entry_t phys;
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -497,14 +513,24 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	if (zswap_load(folio) != -ENOENT)
 		goto finish;
 
-	if (unlikely(swap_is_vswap(sis))) {
-		folio_unlock(folio);
-		goto finish;
+	/*
+	 * Resolve the physical slot to read from. A vswap entry keeps
+	 * folio->swap virtual, so map it to its physical backing; a folio with
+	 * no backing has nothing to read.
+	 */
+	if (swap_is_vswap(sis)) {
+		phys = vswap_to_phys(folio->swap);
+		if (!phys.val) {
+			folio_unlock(folio);
+			goto finish;
+		}
+	} else {
+		phys = folio->swap;
 	}
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, folio->swap, READ);
+	swap_add_folio(ctx, folio, phys, READ);
 
 finish:
 	if (workingset) {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 0385cc50ff93..c0441783b8e7 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -186,6 +186,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return -ENOENT;
 	ci_off = swp_cluster_offset(targ_entry);
 	old_tb = __swap_table_get(ci, ci_off);
+	/* Physical readahead can hit a vswap-backing rmap slot; skip it. */
+	if (swp_tb_is_pointer(old_tb))
+		return -ENOENT;
 	if (swp_tb_is_folio(old_tb))
 		return -EEXIST;
 	if (!__swp_tb_get_count(old_tb))
@@ -210,7 +213,8 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	ci_end = ci_off + nr;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		if (unlikely(swp_tb_is_folio(old_tb) ||
+		if (unlikely(swp_tb_is_pointer(old_tb) ||
+			     swp_tb_is_folio(old_tb) ||
 			     !__swp_tb_get_count(old_tb) ||
 			     is_zero != __swap_table_test_zero(ci, ci_off) ||
 			     (memcg_id && *memcg_id != __swap_cgroup_get(ci, ci_off))))
diff --git a/mm/swap_table.h b/mm/swap_table.h
index 868aae6c820f..08d2494a8ee6 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -4,6 +4,7 @@
 
 #include <linux/rcupdate.h>
 #include <linux/atomic.h>
+#include <linux/swapops.h>
 #include "swap.h"
 
 extern struct swap_info_struct *vswap_si;
@@ -30,7 +31,7 @@ struct swap_memcg_table {
  * NULL:     |---------------- 0 ---------------| - Free slot
  * Shadow:   |SWAP_COUNT|Z|---- SHADOW_VAL ---|1| - Swapped out slot
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
- * Pointer:  |----------- Pointer ----------|100| - (Unused)
+ * Pointer:  |-------- vswap offset --------|100| - vswap rmap
  * Bad:      |------------- 1 -------------|1000| - Bad slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
@@ -51,9 +52,8 @@ struct swap_memcg_table {
  * - PFN: Swap slot is in use, and cached. Memcg info is recorded on the page
  *   struct.
  *
- * - Pointer: Unused yet. `0b100` is reserved for potential pointer usage
- *   because only the lower three bits can be used as a marker for 8 bytes
- *   aligned pointers.
+ * - Pointer: Reverse map from a physical slot to the vswap entry that owns
+ *   it. See the layout below.
  *
  * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
  */
@@ -370,4 +370,38 @@ static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
 }
 #endif
 
+/*
+ * Pointer-tagged swap table entry: rmap for vswap-backing physical slots.
+ *
+ * On physical clusters, a Pointer-tagged entry stores the offset of the
+ * vswap entry that owns this physical slot (the reverse map). Only the
+ * offset is stored; the swap type is implicit (always vswap_si->type,
+ * since there is exactly one vswap device).
+ *
+ *   Pointer:  |---- vswap offset ----|100|
+ */
+#define SWP_TB_PTR_MARK_BITS	3
+#define SWP_TB_PTR_MARK		0b100UL
+#define SWP_TB_PTR_MARK_MASK	((1UL << SWP_TB_PTR_MARK_BITS) - 1)
+#define SWP_RMAP_ENTRY_MASK	(~SWP_TB_PTR_MARK_MASK)
+
+static inline bool swp_tb_is_pointer(unsigned long swp_tb)
+{
+	return (swp_tb & SWP_TB_PTR_MARK_MASK) == SWP_TB_PTR_MARK;
+}
+
+static inline unsigned long swp_entry_to_swp_tb_ptr(swp_entry_t entry)
+{
+	return (swp_offset(entry) << SWP_TB_PTR_MARK_BITS) | SWP_TB_PTR_MARK;
+}
+
+static inline swp_entry_t swp_tb_ptr_to_swp_entry(unsigned long swp_tb)
+{
+	unsigned long offset;
+
+	VM_WARN_ON(!swp_tb_is_pointer(swp_tb));
+	offset = (swp_tb & SWP_RMAP_ENTRY_MASK) >> SWP_TB_PTR_MARK_BITS;
+	return swp_entry(vswap_si->type, offset);
+}
+
 #endif
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f5fd01307a67..66bcbb112142 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -249,7 +249,7 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
 			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio) &&
-			 !is_vswap_entry(folio->swap)));
+			 folio_phys_swap_backed(folio)));
 	if (!need_reclaim || !folio_swapcache_freeable(folio))
 		goto out_unlock;
 
@@ -955,6 +955,8 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 {
 	unsigned int order;
 	unsigned long nr_pages;
+	swp_entry_t vswap_entry, v;
+	unsigned int i;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -974,8 +976,26 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 		order = folio_order(folio);
 		nr_pages = 1 << order;
 		swap_cluster_assert_empty(ci, ci_off, nr_pages, false);
-		__swap_cache_add_folio(ci, folio, swp_entry(si->type,
-							    ci_off + cluster_offset(si, ci)));
+		if (folio_test_swapcache(folio)) {
+			/*
+			 * Folio already in the swap cache: we are allocating
+			 * physical backing for its vswap entry. Point each
+			 * physical slot back at its own vswap entry
+			 * (Pointer-tagged rmap).
+			 */
+			VM_WARN_ON(!is_vswap_entry(folio->swap));
+			vswap_entry = folio->swap;
+			for (i = 0; i < nr_pages; i++) {
+				v = vswap_entry;
+				v.val += i;
+				__swap_table_set(ci, ci_off + i,
+						 swp_entry_to_swp_tb_ptr(v));
+			}
+		} else {
+			__swap_cache_add_folio(ci, folio,
+				swp_entry(si->type,
+					  ci_off + cluster_offset(si, ci)));
+		}
 	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
 		order = 0;
 		nr_pages = 1;
@@ -1474,12 +1494,14 @@ static bool get_swap_device_info(struct swap_info_struct *si)
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
  */
-static bool swap_alloc_fast(struct folio *folio)
+static swp_entry_t swap_alloc_fast(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
-	unsigned int offset;
+	unsigned long offset, found = 0;
+
+	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
@@ -1488,25 +1510,28 @@ static bool swap_alloc_fast(struct folio *folio)
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
 	if (!si || !offset || !get_swap_device_info(si))
-		return false;
+		return (swp_entry_t){};
 
 	ci = swap_cluster_lock(si, offset);
 	if (ci && cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
-		alloc_swap_scan_cluster(si, ci, folio, offset);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset);
 	} else if (ci) {
 		swap_cluster_unlock(ci);
 	}
 
 	put_swap_device(si);
-	return folio_test_swapcache(folio);
+	if (found)
+		return swp_entry(si->type, found);
+	return (swp_entry_t){};
 }
 
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(struct folio *folio)
+static swp_entry_t swap_alloc_slow(struct folio *folio)
 {
 	struct swap_info_struct *si, *next;
+	unsigned long found;
 
 	spin_lock(&swap_avail_lock);
 start_over:
@@ -1515,12 +1540,12 @@ static void swap_alloc_slow(struct folio *folio)
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
-			cluster_alloc_swap_entry(si, folio);
+			found = cluster_alloc_swap_entry(si, folio);
 			put_swap_device(si);
-			if (folio_test_swapcache(folio))
-				return;
+			if (found)
+				return swp_entry(si->type, found);
 			if (folio_test_large(folio))
-				return;
+				return (swp_entry_t){};
 		}
 
 		spin_lock(&swap_avail_lock);
@@ -1538,6 +1563,7 @@ static void swap_alloc_slow(struct folio *folio)
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
+	return (swp_entry_t){};
 }
 
 /*
@@ -1889,6 +1915,23 @@ static bool vswap_alloc(struct folio *folio)
 	return false;
 }
 
+static swp_entry_t folio_alloc_phys_swap(struct folio *folio)
+{
+	swp_entry_t entry;
+
+again:
+	local_lock(&percpu_swap_cluster.lock);
+	entry = swap_alloc_fast(folio);
+	if (!entry.val)
+		entry = swap_alloc_slow(folio);
+	local_unlock(&percpu_swap_cluster.lock);
+
+	if (!entry.val && !folio_order(folio) && swap_sync_discard())
+		goto again;
+
+	return entry;
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1925,20 +1968,8 @@ int folio_alloc_swap(struct folio *folio)
 		}
 	}
 
-	if (vswap_alloc(folio))
-		goto done;
-
-again:
-	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(folio))
-		swap_alloc_slow(folio);
-	local_unlock(&percpu_swap_cluster.lock);
-
-done:
-	if (!order && unlikely(!folio_test_swapcache(folio))) {
-		if (swap_sync_discard())
-			goto again;
-	}
+	if (!vswap_alloc(folio))
+		folio_alloc_phys_swap(folio);
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
 	if (unlikely(mem_cgroup_try_charge_swap(folio)))
@@ -1950,6 +1981,11 @@ int folio_alloc_swap(struct folio *folio)
 	return 0;
 }
 
+static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
+					     struct swap_cluster_info *pci,
+					     unsigned int ci_start,
+					     unsigned int nr_pages);
+
 /**
  * __vswap_release_backing - release the backing of a range of vtable slots
  * @ci: the locked vswap cluster
@@ -1965,8 +2001,12 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 			     unsigned int ci_start, unsigned int nr)
 {
 	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_info_struct *psi;
+	unsigned long phys_start = 0, phys_end = 0;
+	unsigned int phys_type = 0;
 	unsigned int ci_off;
 	unsigned long vt;
+	swp_entry_t phys;
 
 	lockdep_assert_held(&ci->lock);
 	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
@@ -1974,7 +2014,32 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 	for (ci_off = ci_start; ci_off < ci_start + nr; ci_off++) {
 		vt = __vtable_get(ci_dyn, ci_off);
 
+		/* The free helper takes one contiguous run within one cluster. */
+		if (phys_start != phys_end &&
+		    (vtable_type(vt) != VSWAP_SWAPFILE ||
+		     swp_type(vtable_to_phys(vt)) != phys_type ||
+		     swp_offset(vtable_to_phys(vt)) != phys_end ||
+		     phys_end % SWAPFILE_CLUSTER == 0)) {
+			psi = __swap_type_to_info(phys_type);
+			__swap_cluster_free_phys_backing(psi,
+				__swap_entry_to_cluster(
+					swp_entry(phys_type, phys_start)),
+				phys_start % SWAPFILE_CLUSTER,
+				phys_end - phys_start);
+			phys_start = phys_end = 0;
+		}
+
 		switch (vtable_type(vt)) {
+		case VSWAP_SWAPFILE:
+			if (phys_start == phys_end) {
+				phys = vtable_to_phys(vt);
+				phys_start = swp_offset(phys);
+				phys_end = phys_start + 1;
+				phys_type = swp_type(phys);
+			} else {
+				phys_end++;
+			}
+			break;
 		case VSWAP_ZSWAP:
 			zswap_entry_free(vtable_to_zswap(vt));
 			break;
@@ -1990,6 +2055,15 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 		if (__swap_table_test_zero(ci, ci_off))
 			__swap_table_clear_zero(ci, ci_off);
 	}
+
+	if (phys_start != phys_end) {
+		psi = __swap_type_to_info(phys_type);
+		__swap_cluster_free_phys_backing(psi,
+			__swap_entry_to_cluster(
+				swp_entry(phys_type, phys_start)),
+			phys_start % SWAPFILE_CLUSTER,
+			phys_end - phys_start);
+	}
 }
 
 /**
@@ -2017,6 +2091,100 @@ void folio_release_vswap_backing(struct folio *folio)
 	spin_unlock(&ci->lock);
 }
 
+/**
+ * folio_release_non_phys_swap_backing() - Drop a folio's non-physical vswap backing.
+ * @folio: the folio, occupying a virtual swap entry.
+ *
+ * Release the zswap backing recorded for @folio's virtual swap entry,
+ * leaving the slots empty so the writeout path can install fresh physical
+ * backing. Does nothing when the entry is already backed by physical
+ * swapfile slots, which are kept for reuse, or when it has no backing
+ * beyond the swap cache folio itself.
+ *
+ * Context: Caller must hold the folio lock; @folio must be in the swap cache
+ * and occupy a virtual swap entry.
+ */
+void folio_release_non_phys_swap_backing(struct folio *folio)
+{
+	struct swap_cluster_info *ci;
+	struct swap_cluster_info_dynamic *ci_dyn;
+	int nr = folio_nr_pages(folio);
+	unsigned int voff;
+	unsigned long vt;
+	enum vswap_backing_type type;
+
+	ci = __swap_entry_to_cluster(folio->swap);
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	voff = swp_cluster_offset(folio->swap);
+
+	spin_lock(&ci->lock);
+	/* A folio's slots cannot mix swapfile with other backends. */
+	vt = __vtable_get(ci_dyn, voff);
+	type = vtable_type(vt);
+
+	if (type == VSWAP_SWAPFILE || type == VSWAP_NONE) {
+		spin_unlock(&ci->lock);
+		return;
+	}
+
+	__vswap_release_backing(ci, voff, nr);
+	spin_unlock(&ci->lock);
+}
+
+/**
+ * folio_realloc_swap() - Back a virtual swap folio with a physical swap slot.
+ * @folio: the folio, occupying a virtual swap entry.
+ *
+ * Ensure @folio's virtual swap entry has physical (swapfile) backing,
+ * allocating a physical slot on demand if it has none. If @folio is
+ * already physically backed, the existing physical entry is returned
+ * unchanged.
+ *
+ * Context: Caller must hold the folio lock; @folio must be in the swap cache
+ * and occupy a virtual swap entry.
+ * Return: The physical swap entry now backing @folio, or an empty entry
+ * (.val == 0) on failure.
+ */
+swp_entry_t folio_realloc_swap(struct folio *folio)
+{
+	swp_entry_t vswap_entry = folio->swap;
+	struct swap_cluster_info *ci;
+	struct swap_cluster_info_dynamic *ci_dyn;
+	unsigned int voff;
+	swp_entry_t phys_entry = {};
+	swp_entry_t pe;
+	int i, nr = folio_nr_pages(folio);
+
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON(!is_vswap_entry(vswap_entry));
+
+	phys_entry = vswap_to_phys(vswap_entry);
+	if (phys_entry.val)
+		return phys_entry;
+
+	phys_entry = folio_alloc_phys_swap(folio);
+	if (!phys_entry.val)
+		return (swp_entry_t){};
+
+	voff = swp_cluster_offset(vswap_entry);
+
+	ci = __swap_entry_to_cluster(vswap_entry);
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	spin_lock(&ci->lock);
+	/*
+	 * Install PHYS backing without freeing any prior contents of the
+	 * vtable. Releasing the old backing is the caller's job.
+	 */
+	for (i = 0; i < nr; i++) {
+		pe.val = phys_entry.val + i;
+		__vtable_set(ci_dyn, voff + i, vtable_mk_phys(pe));
+	}
+	spin_unlock(&ci->lock);
+
+	return phys_entry;
+}
+
 /**
  * folio_dup_swap() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
@@ -2141,6 +2309,47 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
+/*
+ * Common tail for freeing swap slots: device-level accounting
+ * and cluster list management.
+ */
+static void __swap_cluster_finish_free(struct swap_info_struct *si,
+				       struct swap_cluster_info *ci,
+				       unsigned int ci_start,
+				       unsigned int nr_pages)
+{
+	lockdep_assert_held(&ci->lock);
+	swap_range_free(si, cluster_offset(si, ci) + ci_start, nr_pages);
+	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
+
+	if (!ci->count)
+		free_cluster(si, ci);
+	else
+		partial_free_cluster(si, ci);
+}
+
+/*
+ * Free physical swap slots that were backing vswap entries (Pointer-tagged).
+ */
+static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
+					     struct swap_cluster_info *pci,
+					     unsigned int ci_start,
+					     unsigned int nr_pages)
+{
+	unsigned int ci_off;
+
+	spin_lock_nested(&pci->lock, SINGLE_DEPTH_NESTING);
+	VM_WARN_ON(pci->count < nr_pages);
+	pci->count -= nr_pages;
+	for (ci_off = ci_start; ci_off < ci_start + nr_pages; ci_off++) {
+		__swap_table_set(pci, ci_off, null_to_swp_tb());
+		if (!SWAP_TABLE_HAS_ZEROFLAG)
+			__swap_table_clear_zero(pci, ci_off);
+	}
+	__swap_cluster_finish_free(psi, pci, ci_start, nr_pages);
+	swap_cluster_unlock(pci);
+}
+
 /*
  * Free a set of swap slots after their swap count dropped to zero, or will be
  * zero after putting the last ref (saves one __swap_cluster_put_entry call).
@@ -2152,7 +2361,6 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned long old_tb;
 	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
-	unsigned long ci_head = cluster_offset(si, ci);
 	unsigned int batch_off = ci_off;
 
 	VM_WARN_ON(ci->count < nr_pages);
@@ -2190,13 +2398,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	if (batch_id)
 		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
 
-	swap_range_free(si, ci_head + ci_start, nr_pages);
-	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
-
-	if (!ci->count)
-		free_cluster(si, ci);
-	else
-		partial_free_cluster(si, ci);
+	__swap_cluster_finish_free(si, ci, ci_start, nr_pages);
 }
 
 int __swap_count(swp_entry_t entry)
@@ -2982,19 +3184,99 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 
 static int try_to_unuse(unsigned int type)
 {
+	struct mempolicy *mpol = get_task_policy(current);
 	struct mm_struct *prev_mm;
 	struct mm_struct *mm;
 	struct list_head *p;
 	int retval = 0;
 	struct swap_info_struct *si = swap_info[type];
 	struct folio *folio;
-	swp_entry_t entry;
-	unsigned int i;
+	struct swap_io_ctx ctx;
+	swp_entry_t entry, vswap_entry;
+	unsigned long swp_tb;
+	unsigned int i, j;
 
 	if (!swap_usage_in_pages(si))
 		goto success;
 
 retry:
+	/*
+	 * Free vswap-backing slots (Pointer-tagged) first. Walk physical
+	 * clusters, read the vswap entry from the rmap, ensure the data
+	 * is in the swap cache, and transition PHYS to FOLIO. Freeing the
+	 * physical backing is enough, so no page table walk is needed.
+	 */
+	i = 0;
+	while (vswap_is_enabled() &&
+	       swap_usage_in_pages(si) &&
+	       !signal_pending(current) &&
+	       (i = find_next_to_unuse(si, i)) != 0) {
+		swp_entry_t phys;
+
+		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
+					i % SWAPFILE_CLUSTER);
+		if (!swp_tb_is_pointer(swp_tb))
+			continue;
+
+		vswap_entry = swp_tb_ptr_to_swp_entry(swp_tb);
+
+		folio = swap_cache_get_folio(vswap_entry);
+		if (!folio) {
+			folio = swap_cache_alloc_folio(vswap_entry,
+						       GFP_HIGHUSER_MOVABLE,
+						       BIT(0), NULL, mpol,
+						       NO_INTERLEAVE_INDEX);
+			if (IS_ERR(folio)) {
+				if (PTR_ERR(folio) == -ENOMEM)
+					return -ENOMEM;
+				continue;
+			}
+			ctx = (struct swap_io_ctx){};
+			swap_read_folio(&ctx, folio);
+			swap_read_submit(&ctx);
+			folio_lock(folio);
+		} else {
+			folio_lock(folio);
+		}
+
+		if (!folio_matches_swap_entry(folio, vswap_entry)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			continue;
+		}
+
+		/*
+		 * Re-validate under folio lock: rmap holds folio->swap + j
+		 * for some j in [0, nr_pages). Check folio->swap still maps
+		 * to the contiguous physical run that includes our slot i.
+		 */
+		j = vswap_entry.val - folio->swap.val;
+		phys = vswap_to_phys(folio->swap);
+		if (!phys.val || swp_type(phys) != type ||
+		    swp_offset(phys) + j != i) {
+			folio_unlock(folio);
+			folio_put(folio);
+			continue;
+		}
+
+		folio_wait_writeback(folio);
+		folio_release_vswap_backing(folio);
+		/*
+		 * Drop a folio whose read failed rather than dirtying
+		 * uninitialised memory; the next fault finds no backing and
+		 * gets SIGBUS.
+		 */
+		if (unlikely(!folio_test_uptodate(folio)))
+			swap_cache_del_folio(folio);
+		else
+			folio_mark_dirty(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	if (!swap_usage_in_pages(si))
+		goto success;
+
 	retval = shmem_unuse(type);
 	if (retval)
 		return retval;
@@ -3037,6 +3319,8 @@ static int try_to_unuse(unsigned int type)
 	       (i = find_next_to_unuse(si, i)) != 0) {
 
 		entry = swp_entry(type, i);
+
+		/* Pointer-tagged rmap slots have no folio; the pre-pass took them. */
 		folio = swap_cache_get_folio(entry);
 		if (!folio)
 			continue;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5cc40db37f6b..7960cc489ea0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1528,7 +1528,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (folio_test_swapcache(folio) &&
-		    ((mem_cgroup_swap_full(folio) && !is_vswap_entry(folio->swap)) ||
+		    ((mem_cgroup_swap_full(folio) && folio_phys_swap_backed(folio)) ||
 		     folio_test_mlocked(folio)))
 			folio_free_swap(folio);
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
diff --git a/mm/vswap.h b/mm/vswap.h
index 5334c77b6b84..ce35a8381ca0 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -20,6 +20,7 @@ struct zswap_entry;
 enum vswap_backing_type {
 	VSWAP_NONE	= 0,
 	VSWAP_ZSWAP	= 1,
+	VSWAP_SWAPFILE	= 2,
 	VSWAP_ZERO,
 	VSWAP_FOLIO,
 };
@@ -50,11 +51,15 @@ static inline bool is_vswap_entry(swp_entry_t entry)
  * pointer for a virtual swap slot. Tag in low 3 bits, payload in
  * upper 61 bits.
  *
- *   NONE:   |----- 0000 ------|000|  - no separate backend pointer
- *   ZSWAP:  |--- zswap_entry* |001|  - compressed in zswap (tag in low bits)
+ *   NONE:     |----- 0000 ------|000|  - no separate backend pointer
+ *   ZSWAP:    |--- zswap_entry* |001|  - compressed in zswap (tag in low bits)
+ *   SWAPFILE: |- type:5,off:56 -|010|  - on a physical swapfile
  *
- * Pointer payloads (ZSWAP) are stored directly with the tag OR'd into the
- * low bits (kernel pointers are >= 8-byte aligned, same approach as xarray).
+ * SWAPFILE packs swp_type in the top MAX_SWAPFILES_SHIFT bits and swp_offset in
+ * the middle VTABLE_PHYS_OFF_BITS bits, both above the tag, so the type is
+ * not shifted off the word. Pointer payloads (ZSWAP) are stored directly with
+ * the tag OR'd into the low bits (kernel pointers are >= 8-byte aligned, same
+ * approach as xarray).
  *
  * vtable[i] = NONE does not by itself mean "free". The swap_table entry
  * and the per-slot zero flag carry the rest of the state. The full
@@ -68,6 +73,8 @@ static inline bool is_vswap_entry(swp_entry_t entry)
  *   NONE      | *             | set   | zero-backed; cached if PFN set
  *   ZSWAP     | PFN           | clear | folio cached + zswap entry
  *   ZSWAP     | shadow / NULL | clear | evicted, only in zswap
+ *   SWAPFILE  | PFN           | clear | folio cached + physical slot
+ *   SWAPFILE  | shadow / NULL | clear | evicted, only on the swapfile
  *
  * Locking: a slot's vtable entry (the vswap entry's backend) is only
  * stable while the caller owns and holds the lock on that entry's swap
@@ -93,6 +100,23 @@ static inline enum vswap_backing_type vtable_type(unsigned long vt)
 	return vt & VTABLE_TAG_MASK;
 }
 
+/* swp_offset field width in a physical backend slot; layout described above. */
+#define VTABLE_PHYS_OFF_BITS	(BITS_PER_LONG - VTABLE_TAG_BITS - MAX_SWAPFILES_SHIFT)
+
+static inline unsigned long vtable_mk_phys(swp_entry_t entry)
+{
+	VM_WARN_ON_ONCE(swp_offset(entry) >> VTABLE_PHYS_OFF_BITS);
+	return ((unsigned long)swp_type(entry) << (VTABLE_TAG_BITS + VTABLE_PHYS_OFF_BITS)) |
+	       (swp_offset(entry) << VTABLE_TAG_BITS) | VSWAP_SWAPFILE;
+}
+
+static inline swp_entry_t vtable_to_phys(unsigned long vt)
+{
+	VM_WARN_ON(vtable_type(vt) != VSWAP_SWAPFILE);
+	return swp_entry(vt >> (VTABLE_TAG_BITS + VTABLE_PHYS_OFF_BITS),
+			 (vt >> VTABLE_TAG_BITS) & ((1UL << VTABLE_PHYS_OFF_BITS) - 1));
+}
+
 static inline struct zswap_entry *vtable_to_zswap(unsigned long vt)
 {
 	VM_WARN_ON(vtable_type(vt) != VSWAP_ZSWAP);
@@ -134,6 +158,33 @@ vswap_lock_cluster(swp_entry_t entry, unsigned int *voff)
 	return container_of(ci, struct swap_cluster_info_dynamic, ci);
 }
 
+/**
+ * vswap_to_phys - resolve a vswap entry's physical swap backing
+ * @entry: the virtual swap entry
+ *
+ * Context: takes and drops the vswap cluster lock internally.
+ * Return: the backing physical swp_entry_t, or the null entry (.val == 0)
+ * when @entry has no physical backing (NONE/ZSWAP/ZERO).
+ */
+static inline swp_entry_t vswap_to_phys(swp_entry_t entry)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	unsigned int voff;
+	unsigned long vt;
+
+	ci_dyn = vswap_lock_cluster(entry, &voff);
+	if (!ci_dyn)
+		return (swp_entry_t){};
+
+	vt = __vtable_get(ci_dyn, voff);
+	swap_cluster_unlock(&ci_dyn->ci);
+
+	if (vtable_type(vt) != VSWAP_SWAPFILE)
+		return (swp_entry_t){};
+
+	return vtable_to_phys(vt);
+}
+
 void __vswap_release_backing(struct swap_cluster_info *ci,
 			     unsigned int ci_start, unsigned int nr);
 
@@ -184,6 +235,104 @@ static inline struct zswap_entry *vswap_zswap_load(swp_entry_t entry)
 }
 
 void folio_release_vswap_backing(struct folio *folio);
+swp_entry_t folio_realloc_swap(struct folio *folio);
+void folio_release_non_phys_swap_backing(struct folio *folio);
+
+/*
+ * Walk nr vtable slots starting at voff in ci_dyn. Returns the prefix
+ * length of slots sharing one effective backing type. For SWAPFILE,
+ * the prefix is also restricted to contiguous offsets in the same
+ * swapfile.
+ *
+ * Effective type per slot:
+ *   vtable=NONE + zero flag set       -> VSWAP_ZERO
+ *   vtable=NONE + swap_table PFN tag  -> VSWAP_FOLIO
+ *   vtable=NONE + neither             -> VSWAP_NONE
+ *   vtable=SWAPFILE                   -> VSWAP_SWAPFILE
+ *   vtable=ZSWAP                      -> VSWAP_ZSWAP
+ *
+ * *typep returns the effective type of slot 0. Caller holds
+ * ci_dyn->ci.lock.
+ */
+static inline int __vswap_check_backing(struct swap_cluster_info_dynamic *ci_dyn,
+					unsigned int voff, int nr,
+					enum vswap_backing_type *typep)
+{
+	enum vswap_backing_type first_type = VSWAP_NONE;
+	enum vswap_backing_type slot_type;
+	swp_entry_t first_phys = {};
+	unsigned long vt, swap_tb;
+	int i;
+
+	lockdep_assert_held(&ci_dyn->ci.lock);
+
+	for (i = 0; i < nr; i++) {
+		vt = __vtable_get(ci_dyn, voff + i);
+		if (vtable_type(vt) == VSWAP_NONE) {
+			swap_tb = __swap_table_get(&ci_dyn->ci, voff + i);
+			if (__swap_table_test_zero(&ci_dyn->ci, voff + i))
+				slot_type = VSWAP_ZERO;
+			else if (swp_tb_is_folio(swap_tb))
+				slot_type = VSWAP_FOLIO;
+			else
+				slot_type = VSWAP_NONE;
+		} else {
+			slot_type = vtable_type(vt);
+		}
+
+		if (!i) {
+			first_type = slot_type;
+			if (first_type == VSWAP_SWAPFILE)
+				first_phys = vtable_to_phys(vt);
+		} else if (slot_type != first_type) {
+			break;
+		} else if (first_type == VSWAP_SWAPFILE &&
+			   vtable_to_phys(vt).val != first_phys.val + i) {
+			break;
+		}
+	}
+
+	if (typep)
+		*typep = first_type;
+	return i;
+}
+
+static inline int vswap_check_backing(swp_entry_t entry, int nr,
+				      enum vswap_backing_type *typep)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	unsigned int voff;
+	int ret;
+
+	ci_dyn = vswap_lock_cluster(entry, &voff);
+	if (!ci_dyn) {
+		if (typep)
+			*typep = VSWAP_NONE;
+		return 0;
+	}
+	ret = __vswap_check_backing(ci_dyn, voff, nr, typep);
+	swap_cluster_unlock(&ci_dyn->ci);
+	return ret;
+}
+
+/**
+ * folio_phys_swap_backed - test whether a folio is backed by a contiguous
+ *                          range of physical swap slots.
+ * @folio: a swap-cache resident folio
+ *
+ * Return: %true if @folio->swap is not a vswap entry, or if these vswap
+ * entries are backed by a contiguous range of physical slots.
+ */
+static inline bool folio_phys_swap_backed(struct folio *folio)
+{
+	swp_entry_t entry = folio->swap;
+	int nr = folio_nr_pages(folio);
+	enum vswap_backing_type type;
+
+	return !is_vswap_entry(entry) ||
+	       (vswap_check_backing(entry, nr, &type) == nr &&
+		type == VSWAP_SWAPFILE);
+}
 
 static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info_dynamic *ci_dyn,
 					     gfp_t gfp)
@@ -214,6 +363,47 @@ static inline bool is_vswap_entry(swp_entry_t entry)
 	return false;
 }
 
+static inline swp_entry_t vswap_to_phys(swp_entry_t entry)
+{
+	return (swp_entry_t){};
+}
+
+static inline bool folio_phys_swap_backed(struct folio *folio)
+{
+	return true;
+}
+
 #endif /* CONFIG_SWAP */
 
+/*
+ * Test a per-backend swap flag (SWP_SYNCHRONOUS_IO, SWP_STABLE_WRITES, ...)
+ * for @entry. For a vswap entry the property belongs to the current
+ * physical backing rather than vswap_si itself; resolve to the backing
+ * and test there. Returns false for zswap/zero/unbacked vswap entries
+ * as they don't have a backing bdev.
+ */
+static inline bool swap_entry_backend_has_flag(struct swap_info_struct *si,
+					       swp_entry_t entry,
+					       unsigned long flag)
+{
+	struct swap_info_struct *phys_si;
+	swp_entry_t phys;
+	bool has_flag;
+
+	if (!swap_is_vswap(si))
+		return data_race(si->flags & flag);
+
+	phys = vswap_to_phys(entry);
+	if (!phys.val)
+		return false;
+
+	phys_si = get_swap_device(phys);
+	if (!phys_si)
+		return false;
+
+	has_flag = data_race(phys_si->flags & flag);
+	put_swap_device(phys_si);
+	return has_flag;
+}
+
 #endif /* _MM_VSWAP_H */
diff --git a/mm/zswap.c b/mm/zswap.c
index 54506935ceba..9a00ee049cf4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1598,7 +1598,7 @@ bool zswap_store(struct folio *folio)
 	 */
 	if (is_vswap_entry(swp)) {
 		if (index > 0)
-			folio_release_vswap_backing(folio);
+			folio_release_non_phys_swap_backing(folio);
 	} else {
 		unsigned type = swp_type(swp);
 		pgoff_t offset = swp_offset(swp);
-- 
2.53.0-Meta

