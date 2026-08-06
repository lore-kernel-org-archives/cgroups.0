Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8804F3B0AF8
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041792; cv=none; b=XMjYYeOPyAJg1VCn7jpziVsMamTXtFCXdIxYRsgxWcTWWZzTvIBvJD3Ty2ecKMS3wBBlGfWn3l3RwL6uxwJ3SLKw6JnVSMWq1XqiinNBINpCswxSLHGsrPfIbdf6zDDCTimnzksHYvb34nZruGQu3kDZS+I0JBN+CCLDvmg9icM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041792; c=relaxed/simple;
	bh=KV+u7lcKkOTUwfrTC0yeM7I9pnsd3IZNHNNfy4poLcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/2ezpgInHTiK3gqj2aCMXzq58IztRnbOB7DmYgmmxnEIRrcDHrcQRs/hZ8GuAbLxdr5QVwqeS9QI5PvSBsETODB7ZUXsI5+WGvB+VCNLh7cyqMR0pvjYj5LMicyJ5nYfaznLKkK2CGW+al6ca4DQPrlk0rASk1d3bMquvs6xTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SyEh1j+p; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SyEh1j+p"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-456d267da8cso1121392fac.2
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 11:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041787; x=1786646587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q8wSea+R53zhaHFEktUy45t+1cs96tBlwwCzw1xF8Mw=;
        b=SyEh1j+pr1oOkGuLexXLR/ufi1SsaZ3r9WpcJblY8SoE/1C7gwxT0zef0sf5EtGL0L
         LvDrPFOmYJAXJ8LdIgTwvpyfp0OHvbko2xlNpAOybWqmOoP28FxXB6X1h9o1jT11I9cN
         RNbigneQ7evz6prJie3lV5w/3x1fVLTmv5RaIkNG7+UbvcuzDw+mPMpKoYYq3WjwpQXM
         RpqZk1Yi/Fm0dq4JJ0GbukLD/rUzz8tDuhRRPKgCncb78H28lawcjsTZPUoNR+CtfVrI
         JphcP3jyuI269ROSXbnRM0Uw7Db4w4ekC1ewlRbh4cSjD19eXHcQEldIbhy7sNA7NHEn
         nfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041787; x=1786646587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q8wSea+R53zhaHFEktUy45t+1cs96tBlwwCzw1xF8Mw=;
        b=KjRgfumsLV/MLhm4GaL5hEdJLKY36S4UNSrU+jyVMa9ge6v0hO8QwChj3aff16Bv2p
         wKhV0PxP+nncdtg+NlzRgLR4QT5JFcB4X//fbpZZywQmAAP8oQjmX8CLXCvtxC5DYM96
         hjGUOIB9JBEvCxaxuavXYsdfFgZtNdq6wj4lm5hDDWNjhnfthxUBNk8SeGMB+SPn9e8f
         nkipPmAh/pkSN+6ouNQ+Wj9a2oBeyRi5duw6EifhH+bso30Pr2jyW86YasQ3MapTqdcS
         4FyemIW/X5IhRgTQgsgt+UesbYm96+1+o0wlYlLc5MR8gTgrnZZSsXz/l/6qGjlrxtnV
         Q49Q==
X-Forwarded-Encrypted: i=1; AHgh+RoSHIW0OLWWUWfavWz3D8bu1bMU9ngXb4iYzC47WmpJ0yXhbL1n/2LqVIrcNIDVknF0YLLx+ih7@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz2FGLJvbM4TWyWKGXhCDXVVwzDHDROhG1fygSRRsKmS63TO63
	fAxTDzFfzQwKdiJVM1Ya9x9+mtJVxxGwCDxCygC4GrNmLwE/GcDPF73X
X-Gm-Gg: AR+sD138OCYrRM2w+cJevSM6ZU8JdgzRei+SPMkw5NVUlPWQm34Vu8JhEZFFJ3igmY1
	+4Ggng1GmfLiZYyCFoV41Cb5WVCaOoHVX9B2uf2UEkJSaMeaan/32u0FMuSeO1IyIzHdMfRmZGr
	lKCkp8qDbM+ldXID/O0tQnw8p1xpRmFTXpLu9z4ts5baV2NodzOTs6WVzxWpLaa7mptaJrdiZc/
	s2lYwq9G3GQEFj1ztuvvTvv2IKC48sXhY8m8CwMvcd+OfIXatizaXATctz0VCmqLW0GmHHpsUBf
	6GTcVQeQIjKSHNryY7DWTZxedzuUNDmsWAtQSz8ydkiWQRIZeKzy6r4cLwuqb8lBPCf6jp1TlRN
	6AdWEaxBfop0Nn72gN1HWQkpH3E+CjZN3YZGu1obNW5ojacpx8sBoid5QvVo6vFEIknRU5Nn0Ve
	quUJnbtH7sFNOOz2etVdsMnWuWBcH3xlbnpFqySZ9nZ0QZ4R3jA/wpAR+AczZXgfve96fniloOS
	Z9cr8EM/Z8=
X-Received: by 2002:a4a:edce:0:b0:6aa:d860:afad with SMTP id 006d021491bc7-6ae96ce17c0mr9058138eaf.15.1786041782548;
        Thu, 06 Aug 2026 11:43:02 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:1a::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bc76279sm210527eaf.7.2026.08.06.11.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:02 -0700 (PDT)
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
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v3 04/11] mm, swap: support physical swap as a vswap backend
Date: Thu,  6 Aug 2026 11:42:47 -0700
Message-ID: <20260806184254.3790858-5-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
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

Writeback of zswap-backed vswap entries to physical swap, and reclaim
of physical slots backing cache-only vswap entries, are added in the
following patches.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |   9 ++
 mm/memory.c          |   8 +-
 mm/page_io.c         |  43 ++++--
 mm/swap_state.c      |   6 +-
 mm/swap_table.h      |  55 +++++++
 mm/swapfile.c        | 352 +++++++++++++++++++++++++++++++++++++++----
 mm/vmscan.c          |   2 +-
 mm/vswap.h           | 198 +++++++++++++++++++++++-
 mm/zswap.c           |   2 +-
 9 files changed, 627 insertions(+), 48 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8359134d08cb..2b2bd56afffa 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -391,6 +391,15 @@ extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_entry_sector(swp_entry_t entry);
 
+#ifdef CONFIG_VSWAP
+swp_entry_t folio_realloc_swap(struct folio *folio);
+#else
+static inline swp_entry_t folio_realloc_swap(struct folio *folio)
+{
+	return (swp_entry_t){};
+}
+#endif
+
 /*
  * If there is an existing swap slot reference (swap entry) and the caller
  * guarantees that there is no race modification of it (e.g., PTL
diff --git a/mm/memory.c b/mm/memory.c
index de3573b7c6b1..ba84565605a1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4656,13 +4656,13 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 	 * are fast, and meanwhile, swap cache pinning the slot deferring the
 	 * release of metadata or fragmentation is a more critical issue.
 	 */
-	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+	if (swap_entry_backend_has_flag(si, folio->swap, SWP_SYNCHRONOUS_IO))
 		return true;
 	/*
 	 * Non-swapfile backends cannot be reused for future swapouts.
 	 * Free the swap slot unless backed by contiguous physical swap.
 	 */
-	if (is_vswap_entry(folio->swap))
+	if (!folio_phys_swap_backed(folio))
 		return true;
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
@@ -4968,7 +4968,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		swap_update_readahead(folio, vma, vmf->address);
 	if (!folio) {
 		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		if (swap_entry_backend_has_flag(si, entry, SWP_SYNCHRONOUS_IO))
 			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
 					    thp_swapin_suitable_orders(vmf) | BIT(0),
 					    vmf, NULL, 0);
@@ -5133,7 +5133,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			 */
 			exclusive = true;
 		} else if (exclusive && folio_test_writeback(folio) &&
-			  data_race(si->flags & SWP_STABLE_WRITES)) {
+			  swap_entry_backend_has_flag(si, entry, SWP_STABLE_WRITES)) {
 			/*
 			 * This is tricky: not all swap backends support
 			 * concurrent page modifications while under writeback.
diff --git a/mm/page_io.c b/mm/page_io.c
index 5c780bda92bb..605a66a32604 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -208,6 +208,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
  */
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
+	swp_entry_t phys;
 	int ret = 0;
 
 	if (folio_free_swap(folio))
@@ -240,8 +241,14 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
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
@@ -257,12 +264,19 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	rcu_read_unlock();
 
 	/*
-	 * A vswap folio that reaches here could not be stored to a backend
-	 * (zswap) and has no physical slot to write to, so keep it dirty.
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
@@ -474,6 +488,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
+	swp_entry_t phys;
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -498,14 +513,24 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
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
index 9f6377b32911..c61bb3eef62a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -185,6 +185,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return -ENOENT;
 	ci_off = swp_cluster_offset(targ_entry);
 	old_tb = __swap_table_get(ci, ci_off);
+	/* Physical readahead can hit a vswap-backing rmap slot; skip it. */
+	if (swp_tb_is_pointer(old_tb))
+		return -ENOENT;
 	if (swp_tb_is_folio(old_tb))
 		return -EEXIST;
 	if (!__swp_tb_get_count(old_tb))
@@ -209,7 +212,8 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
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
index fd7f0fb9836a..5b0eca07a821 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -4,8 +4,11 @@
 
 #include <linux/rcupdate.h>
 #include <linux/atomic.h>
+#include <linux/swapops.h>
 #include "swap.h"
 
+struct zswap_entry;
+
 /* A typical flat array in each cluster as swap table */
 struct swap_table {
 	atomic_long_t entries[SWAPFILE_CLUSTER];
@@ -368,4 +371,56 @@ static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
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
+#ifdef CONFIG_VSWAP
+extern struct swap_info_struct *vswap_si;
+
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
+#else
+static inline bool swp_tb_is_pointer(unsigned long swp_tb)
+{
+	return false;
+}
+static inline unsigned long swp_entry_to_swp_tb_ptr(swp_entry_t entry)
+{
+	return 0;
+}
+static inline swp_entry_t swp_tb_ptr_to_swp_entry(unsigned long swp_tb)
+{
+	return (swp_entry_t){};
+}
+
+#endif /* CONFIG_VSWAP */
+
 #endif
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b8fdb426514c..0874f57d3124 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -261,7 +261,7 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
 			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio) &&
-			 !is_vswap_entry(folio->swap)));
+			 folio_phys_swap_backed(folio)));
 	if (!need_reclaim || !folio_swapcache_freeable(folio))
 		goto out_unlock;
 
@@ -1013,6 +1013,8 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 {
 	unsigned int order;
 	unsigned long nr_pages;
+	swp_entry_t vswap_entry, v;
+	unsigned int i;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -1032,8 +1034,26 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
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
@@ -1538,12 +1558,14 @@ static bool get_swap_device_info(struct swap_info_struct *si)
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
@@ -1552,25 +1574,28 @@ static bool swap_alloc_fast(struct folio *folio)
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
@@ -1579,12 +1604,12 @@ static void swap_alloc_slow(struct folio *folio)
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
@@ -1602,6 +1627,7 @@ static void swap_alloc_slow(struct folio *folio)
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
+	return (swp_entry_t){};
 }
 
 /*
@@ -1982,13 +2008,12 @@ int folio_alloc_swap(struct folio *folio)
 		}
 	}
 
-	/* Without zswap a vswap entry has nowhere to go on writeout. */
-	if (zswap_is_enabled() && vswap_alloc(folio))
+	if (vswap_alloc(folio))
 		goto done;
 
 again:
 	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(folio))
+	if (!swap_alloc_fast(folio).val)
 		swap_alloc_slow(folio);
 	local_unlock(&percpu_swap_cluster.lock);
 
@@ -2010,6 +2035,11 @@ int folio_alloc_swap(struct folio *folio)
 
 #ifdef CONFIG_VSWAP
 
+static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
+					     struct swap_cluster_info *pci,
+					     unsigned int ci_start,
+					     unsigned int nr_pages);
+
 /**
  * __vswap_release_backing - release the backing of a range of vtable slots
  * @ci: the locked vswap cluster
@@ -2026,8 +2056,12 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
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
@@ -2035,7 +2069,37 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 	for (ci_off = ci_start; ci_off < ci_start + nr; ci_off++) {
 		vt = __vtable_get(ci_dyn, ci_off);
 
+		/*
+		 * Flush batched physical slots when the next entry
+		 * breaks contiguity, changes type/device, or would
+		 * cross a SWAPFILE_CLUSTER boundary (the free helper
+		 * operates on a single cluster).
+		 */
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
@@ -2051,6 +2115,15 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
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
@@ -2080,6 +2153,106 @@ void folio_release_vswap_backing(struct folio *folio)
 	spin_unlock(&ci->lock);
 }
 
+/**
+ * folio_release_non_phys_swap_backing() - Drop a folio's non-physical vswap backing.
+ * @folio: the folio, occupying a virtual swap entry.
+ *
+ * Release any ZSWAP or zero-filled backing recorded for @folio's virtual
+ * swap entry, leaving the slots empty so the writeout path can install fresh
+ * physical backing. If the first slot is already VSWAP_SWAPFILE or
+ * VSWAP_NONE, nothing is released: physical backing is kept for reuse.
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
+	if (!ci)
+		return;
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	voff = swp_cluster_offset(folio->swap);
+
+	spin_lock(&ci->lock);
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
+ * allocating a physical slot on demand if it has none. Called from the
+ * writeout path and from zswap writeback to move a vswap entry onto a real
+ * swapfile slot. If @folio is already physically backed, the existing
+ * physical entry is returned unchanged.
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
+	local_lock(&percpu_swap_cluster.lock);
+	phys_entry = swap_alloc_fast(folio);
+	if (!phys_entry.val)
+		phys_entry = swap_alloc_slow(folio);
+	local_unlock(&percpu_swap_cluster.lock);
+
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
+	 * vtable. Releasing the old backing is the caller's job: it may
+	 * still need the slot, or may have released it already.
+	 */
+	for (i = 0; i < nr; i++) {
+		pe.val = phys_entry.val + i;
+		__vtable_set(ci_dyn, voff + i, vtable_mk_phys(pe));
+	}
+	spin_unlock(&ci->lock);
+
+	return phys_entry;
+}
 #endif /* CONFIG_VSWAP */
 
 /**
@@ -2207,6 +2380,63 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
+#ifdef CONFIG_VSWAP
+/*
+ * Clear swap table entries to NULL and reset zero flags.
+ * Does not touch memcg or count - caller handles those.
+ */
+static void __swap_cluster_clear_table(struct swap_cluster_info *ci,
+				       unsigned int ci_start,
+				       unsigned int nr_pages)
+{
+	unsigned int ci_off;
+
+	lockdep_assert_held(&ci->lock);
+	for (ci_off = ci_start; ci_off < ci_start + nr_pages; ci_off++) {
+		__swap_table_set(ci, ci_off, null_to_swp_tb());
+		if (!SWAP_TABLE_HAS_ZEROFLAG)
+			__swap_table_clear_zero(ci, ci_off);
+	}
+}
+#endif
+
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
+#ifdef CONFIG_VSWAP
+/*
+ * Free physical swap slots that were backing vswap entries (Pointer-tagged).
+ */
+static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
+					     struct swap_cluster_info *pci,
+					     unsigned int ci_start,
+					     unsigned int nr_pages)
+{
+	spin_lock_nested(&pci->lock, SINGLE_DEPTH_NESTING);
+	VM_WARN_ON(pci->count < nr_pages);
+	pci->count -= nr_pages;
+	__swap_cluster_clear_table(pci, ci_start, nr_pages);
+	__swap_cluster_finish_free(psi, pci, ci_start, nr_pages);
+	swap_cluster_unlock(pci);
+}
+#endif
+
 /*
  * Free a set of swap slots after their swap count dropped to zero, or will be
  * zero after putting the last ref (saves one __swap_cluster_put_entry call).
@@ -2218,7 +2448,6 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned long old_tb;
 	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
-	unsigned long ci_head = cluster_offset(si, ci);
 	unsigned int batch_off = ci_off;
 
 	VM_WARN_ON(ci->count < nr_pages);
@@ -2256,13 +2485,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
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
@@ -3041,19 +3264,88 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 
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
+	 * is in the swap cache, and transition PHYS to FOLIO. No page table
+	 * walk needed - just free the physical backing.
+	 */
+	i = 0;
+	while (IS_ENABLED(CONFIG_VSWAP) &&
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
+						      GFP_KERNEL, BIT(0), NULL,
+						      mpol, NO_INTERLEAVE_INDEX);
+			if (IS_ERR(folio))
+				continue;
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
+		    swp_offset(phys) + j != i ||
+		    j >= folio_nr_pages(folio)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			continue;
+		}
+
+		folio_wait_writeback(folio);
+		folio_release_vswap_backing(folio);
+		folio_mark_dirty(folio);
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
@@ -3097,6 +3389,14 @@ static int try_to_unuse(unsigned int type)
 
 		entry = swp_entry(type, i);
 
+		if (IS_ENABLED(CONFIG_VSWAP)) {
+			swp_tb = swap_table_get(
+				__swap_offset_to_cluster(si, i),
+				i % SWAPFILE_CLUSTER);
+			if (swp_tb_is_pointer(swp_tb))
+				continue;
+		}
+
 		folio = swap_cache_get_folio(entry);
 		if (!folio)
 			continue;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 78ec51f53757..f3f9e3993215 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1530,7 +1530,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * space if we are running out.
 		 */
 		if (folio_test_swapcache(folio) &&
-		    ((mem_cgroup_swap_full(folio) && !is_vswap_entry(folio->swap)) ||
+		    ((mem_cgroup_swap_full(folio) && folio_phys_swap_backed(folio)) ||
 		     folio_test_mlocked(folio)))
 			folio_free_swap(folio);
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
diff --git a/mm/vswap.h b/mm/vswap.h
index 6d25e0911fa9..239b47b577d5 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -19,6 +19,7 @@ struct zswap_entry;
 enum vswap_backing_type {
 	VSWAP_NONE	= 0,
 	VSWAP_ZSWAP	= 1,
+	VSWAP_SWAPFILE	= 2,
 	VSWAP_ZERO,
 	VSWAP_FOLIO,
 };
@@ -27,8 +28,6 @@ enum vswap_backing_type {
 
 #include "swap_table.h"
 
-extern struct swap_info_struct *vswap_si;
-
 static inline bool is_vswap_entry(swp_entry_t entry)
 {
 	return swap_is_vswap(__swap_entry_to_info(entry));
@@ -43,11 +42,15 @@ bool vswap_is_enabled(void);
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
@@ -86,6 +89,23 @@ static inline enum vswap_backing_type vtable_type(unsigned long vt)
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
@@ -130,6 +150,33 @@ vswap_lock_cluster(swp_entry_t entry, unsigned int *voff)
 	return ci_dyn;
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
+	spin_unlock(&ci_dyn->ci.lock);
+
+	if (vtable_type(vt) != VSWAP_SWAPFILE)
+		return (swp_entry_t){};
+
+	return vtable_to_phys(vt);
+}
+
 void __vswap_release_backing(struct swap_cluster_info *ci,
 			     unsigned int ci_start, unsigned int nr);
 
@@ -182,6 +229,103 @@ static inline struct zswap_entry *vswap_zswap_load(swp_entry_t entry)
 }
 
 void folio_release_vswap_backing(struct folio *folio);
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
+	spin_unlock(&ci_dyn->ci.lock);
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
 
 static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info_dynamic *ci_dyn)
 {
@@ -209,6 +353,16 @@ static inline bool is_vswap_entry(swp_entry_t entry)
 
 static inline bool vswap_is_enabled(void) { return false; }
 
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
 static inline void __vswap_release_backing(struct swap_cluster_info *ci,
 					   unsigned int ci_start,
 					   unsigned int nr) {}
@@ -222,6 +376,7 @@ static inline struct zswap_entry *vswap_zswap_load(swp_entry_t entry)
 }
 
 static inline void folio_release_vswap_backing(struct folio *folio) {}
+static inline void folio_release_non_phys_swap_backing(struct folio *folio) {}
 
 static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info_dynamic *ci_dyn)
 {
@@ -232,4 +387,35 @@ static inline void vswap_cluster_free_vtable(struct swap_cluster_info *ci) {}
 
 #endif /* CONFIG_VSWAP */
 
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
index 789079c3945b..d0c6ce2aa092 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1579,7 +1579,7 @@ bool zswap_store(struct folio *folio)
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

