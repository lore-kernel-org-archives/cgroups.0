Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792562622;
	b=VKIqVnS/vpkLOx7v1Qd5vueehT7nElYuIMAqiw6RawMmj5GCDrS6t7aQwAolyCO7jYt7
	 8E5OgVOM9ooWxqzVf5kbRXws6hBe8R1t0pZDua/Ul9wpJvFaFmvELaD3KQwu+p4yCjK+6
	 qr/YAycfYAcpBvecWNeFCFH/hOAIdavtfkfwJCEcSaDFNldwcCbwtHjREMjYbD+qxZwN+
	 lOjOxKSVBYn8g0Kx5vEt9gRi5YnrjSvtzedLSYITNgOwfJRo4Gtpr6XKnZKiWhC5eV7nr
	 iRa1RRLojRDGAHlXFHwilAzPxtST7j8A0spAqp8dnwnhyonu/J5fa5jO1Mqn0pQZ8hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792562622;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z/zwuuOOwiYZZkXUcxGFALiDdyzWbhJoYq3nZXtIDVE=;
	b=zp4pyLMqs+l38A9Zq6kQ7nO1KothHamE2+Zes6clGw8OiCzzQbqJ/Q+2s4jCEZfrR13i
	 Dp/Aa4WVdUrX4WEeIKtW9YYqNhZjd8khn//S6284R8/cYISf4baCtAcD+TZxXpbXTYoqi
	 tXYZxt2kcszy/hoLbUxkAnY7lhSOClfaf1Vmutu+cGL6DESba2vbDy8Yu/AqVjsjP6x/K
	 MZS74pNRixPmjKboJlM59YdsO2HaRF+c8oJsOiINETYiRe5PSCK7sVE8j5aPMP8BbbqDn
	 ZRdxol3pgTwqHDsusPi29M/Dx0cO17w8NtJ1R8f37HNdHKS3gP7ln2WC2F3yz6MAJig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=s5bjFcSV;
	arc=none smtp.remote-ip=74.125.224.48
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB68606A33B
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 06:03:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AB68606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=s5bjFcSV
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-675617e81f9so268576d50.3
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 23:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562620; x=1793167420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z/zwuuOOwiYZZkXUcxGFALiDdyzWbhJoYq3nZXtIDVE=;
        b=s5bjFcSVS2oTB0Wjkcpvyh2O6atKVRne0JKBM2/QhwSwRQ+/TTHSofDE3oHsD7qZVA
         bqCB0586132Qt3PJa4+7GqRGO8hyBiJR1U0fPX1LUJLDqE/AT/Zfp03QRCtZuVxN1zk5
         BbjcOcWQ+qzrURkr8HUQKAxPWkfQGEhSVm4J79isrf7It/HJBpXydq+sIhfyM2p140SX
         lXkTRZVqw8kKkvimUMjwWWpj7UN9ax0Ech1NGFITvWAr6mhph1C6FVcON/j+2KyVoU8G
         9gFoMhfInFSvMPuEbw4mRSHwQoaRGuUFR1K/AcCcE6qF9nFgeo+4Gcr+KNyH3kZoIwue
         jk7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562620; x=1793167420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z/zwuuOOwiYZZkXUcxGFALiDdyzWbhJoYq3nZXtIDVE=;
        b=T43GqUztF9lYKynlezpYsPjc/jH72vD6ny2LzVAWoWtDkphNbmz5pHsrqdeRAl75Qu
         F9vtlR/h2G0oKAL+6X2C7qhq+Fnv63DeAiK2pjN37njRjHXKv5EwgAL3CPtLGnRUSiwK
         37dzLK5Cw9G4DW9w5xNqeOOiZNj1n0YxoBYloM+0tS7y6nmvCZ6+OeH2Ld+1EAh+4LMs
         ZTDav1ouCLacULCKNUGpSJvPyyaP0aC8Xd2YudIpqLD+Qk44UQehc1/cmswP7HuPWYT2
         6D00ThWNtRUwsXnPr4tnuq6SY7x+k58DSZW+CxFmXYUX7knollOF3XD230maieGKdcUi
         7Odw==
X-Forwarded-Encrypted: i=1; AKwUvBxVXk0cusqojAkhKkKfemp99F8rVirC19K9zxCfWhrp6DEWwGjT1qud7ORq/1deiNDKi5yHYQFb@vger.kernel.org
X-Gm-Message-State: AFq9FYI4VCfx7+058HcAC5ObaT83bUyiIvWcIyBSIeusODEwyffu4bLR
	FXoW50Ul6CQmgRbq/R7PTLt1XBkcTEAnzZCjKpSn7eMEKlrR6MSIrUiK
X-Gm-Gg: AYBFou36jj8hnVQXSWfTEAuGytmDRmDcjZD6971pI/fVHByzFojlPWrXijQAOVkPCpq
	H6JLxXhubppcxnu90vI9VR0RdUc0Lo6z8MT/fUFYr2GWRjNC3o/AHBCPuoKhj2r2L7+ulYUSi8a
	er99USo5rl2IOuEZCnGHCN6aXkV0qJVmpb3y4LW5fR/AQz8w3qnZmIwXsWzVY3xqKAGgoQ8k1IG
	SEmBsQWGFlsqNHmT+rbHzEZI3+jpYA5PMIfY1vHrDZ2jjosspFSNEHdCNeTF2HN/NMDfPWK4nSZ
	l9mYXkC1ZkfcNbqhT8A32k+oGuE8eZ0yjFfm2C/LM2YHH3w3UPv5BcNJsdQoCa1JHMoDm89nqZW
	KjzTwVs4JLnQ0sJhxvkrUp1P5yi7SdFj47Ep+ihXeiiFA5heZ+/URnjcilXBn+Q75Jll8BIxE8i
	4baT4mRT+EY62Ekhaf+CH0J7pF45TqxkX1f+xc8dkcBPv1K0+BZgp/HwwN78ctopx2EI+YsnenR
	xG8AO3IqZf+m1ymsxOgjEYBvtvskwgottpeE33t333eRoOJlZ+HvGRvH2lpmIaK4qDm2Avt+YkB
	sqGPjEJGEt5XNEGVIe2zh4OIHAmbKYmc5rU31fQbmXczbVEYq3ov73eQrVUT3Lcs
X-Received: by 2002:a05:690e:43d9:b0:679:ba6e:4d87 with SMTP id 956f58d0204a3-67a0e4b6766mr450158d50.31.1792562619926;
        Tue, 20 Oct 2026 23:03:39 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:72::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e501c01sm630625d50.15.2026.10.20.23.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:03:38 -0700 (PDT)
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
	rdunlap@infradead.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 04/12] mm, swap: support physical swap as a vswap backend
Date: Tue, 20 Oct 2026 23:03:15 -0700
Message-ID: <20261021060323.553433-5-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add physical swap as a backend for the virtual swap layer. When zswap
declines a page, the swapout path allocates a physical slot on demand
for swap out.

Each vswap entry's physical slot is tracked via a vswap-tagged
swap_table entry on the physical cluster (an rmap back to the vswap
entry).

swapoff reads each vswap entry back through its rmap slot before freeing
the physical slot. A failed read leaves the folio not uptodate, so drop
it instead of marking it dirty: dirtying would write uninitialised memory
out to swap, and the loss is now reported as SIGBUS on the next fault
rather than silently returning stale data.

If zswap is disabled at the host level, or the folio's cgroup is at its
zswap limit, the folio still gets a physical swap slot, bypassing vswap
and mapping the slot directly into the PTEs. In practice the swapfile
backend is only reached when zswap declines the folio at swap_writeout()
time, most often because the pool is full.

Zswap writeback to physical swap is added in a following patch. Reclaim of
physical slots backing cache-only vswap entries follows it.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c     |  13 +-
 mm/page_io.c    |  40 +++++-
 mm/swap_state.c |   6 +-
 mm/swap_table.h |  42 +++++-
 mm/swapfile.c   | 352 +++++++++++++++++++++++++++++++++++++++++++-----
 mm/vmscan.c     |  21 ++-
 mm/vswap.h      | 198 ++++++++++++++++++++++++++-
 mm/zswap.c      |   2 +-
 8 files changed, 609 insertions(+), 65 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index e9b8855a7f11..9f651d247eef 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4716,8 +4716,11 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 {
 	if (!folio_test_swapcache(folio))
 		return false;
-	/* A vswap entry holds no physical slot, so keeping it saves no IO. */
-	if (is_vswap_entry(folio->swap))
+	/*
+	 * Non-swapfile backends cannot be reused for future swapouts.
+	 * Free the swap slot unless backed by contiguous physical swap.
+	 */
+	if (!folio_phys_swap_backed(folio))
 		return true;
 	/*
 	 * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. Swap
@@ -4725,7 +4728,7 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 	 * are fast, and meanwhile, swap cache pinning the slot deferring the
 	 * release of metadata or fragmentation is a more critical issue.
 	 */
-	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+	if (swap_entry_backend_has_flag(si, folio->swap, SWP_SYNCHRONOUS_IO))
 		return true;
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
@@ -5066,7 +5069,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		swap_update_readahead(folio, vma, vmf->address);
 	if (!folio) {
 		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		if (swap_entry_backend_has_flag(si, entry, SWP_SYNCHRONOUS_IO))
 			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
 					    thp_swapin_suitable_orders(vmf) | BIT(0),
 					    vmf, NULL, 0);
@@ -5230,7 +5233,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			 */
 			exclusive = true;
 		} else if (exclusive && folio_test_writeback(folio) &&
-			  data_race(si->flags & SWP_STABLE_WRITES)) {
+			  swap_entry_backend_has_flag(si, entry, SWP_STABLE_WRITES)) {
 			/*
 			 * This is tricky: not all swap backends support
 			 * concurrent page modifications while under writeback.
diff --git a/mm/page_io.c b/mm/page_io.c
index 61bb5c6e9759..ed8c037e4aa0 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -209,6 +209,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
  */
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
+	swp_entry_t phys = folio->swap;
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
@@ -257,13 +264,21 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	}
 	rcu_read_unlock();
 
-	/* A vswap folio has no physical slot to write to. */
 	if (is_vswap_entry(folio->swap)) {
+		phys = folio_realloc_swap(folio);
+		if (!phys.val) {
+			folio_mark_dirty(folio);
+			return AOP_WRITEPAGE_ACTIVATE;
+		}
+	}
+
+	if (ctx->nofs &&
+	    (__swap_entry_to_info(phys)->ops->flags & SWAP_OPS_F_REQUIRE_NOFS)) {
 		folio_mark_dirty(folio);
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writeout(ctx, folio, folio->swap);
+	__swap_writeout(ctx, folio, phys);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -477,6 +492,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
+	swp_entry_t phys;
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -501,14 +517,24 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
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
index a6bb650f5885..3900975c675f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -186,6 +186,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return -ENOENT;
 	ci_off = swp_cluster_offset(targ_entry);
 	old_tb = __swap_table_get(ci, ci_off);
+	/* Physical readahead can hit a vswap-backing rmap slot; skip it. */
+	if (swp_tb_is_vswap(old_tb))
+		return -ENOENT;
 	if (swp_tb_is_folio(old_tb))
 		return -EEXIST;
 	if (!__swp_tb_get_count(old_tb))
@@ -210,7 +213,8 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	ci_end = ci_off + nr;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		if (unlikely(swp_tb_is_folio(old_tb) ||
+		if (unlikely(swp_tb_is_vswap(old_tb) ||
+			     swp_tb_is_folio(old_tb) ||
 			     !__swp_tb_get_count(old_tb) ||
 			     is_zero != __swap_table_test_zero(ci, ci_off) ||
 			     (memcg_id && *memcg_id != __swap_cgroup_get(ci, ci_off))))
diff --git a/mm/swap_table.h b/mm/swap_table.h
index 3d64d1629882..a5e65ddbd2f8 100644
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
+ * Vswap:    |-------- vswap offset --------|100| - vswap rmap
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
+ * - Vswap: Reverse map from a physical slot to the vswap entry that owns
+ *   it. See the layout below.
  *
  * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
  */
@@ -393,4 +393,38 @@ static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
 }
 #endif
 
+/*
+ * Vswap-tagged swap table entry: rmap for vswap-backing physical slots.
+ *
+ * On physical clusters, a Vswap-tagged entry stores the offset of the
+ * vswap entry that owns this physical slot (the reverse map). Only the
+ * offset is stored; the swap type is implicit (always vswap_si->type,
+ * since there is exactly one vswap device).
+ *
+ *   Vswap:    |---- vswap offset ----|100|
+ */
+#define SWP_TB_VSWAP_MARK_BITS	3
+#define SWP_TB_VSWAP_MARK	0b100UL
+#define SWP_TB_VSWAP_MARK_MASK	((1UL << SWP_TB_VSWAP_MARK_BITS) - 1)
+#define SWP_RMAP_ENTRY_MASK	(~SWP_TB_VSWAP_MARK_MASK)
+
+static inline bool swp_tb_is_vswap(unsigned long swp_tb)
+{
+	return (swp_tb & SWP_TB_VSWAP_MARK_MASK) == SWP_TB_VSWAP_MARK;
+}
+
+static inline unsigned long swp_entry_to_swp_tb_vswap(swp_entry_t entry)
+{
+	return (swp_offset(entry) << SWP_TB_VSWAP_MARK_BITS) | SWP_TB_VSWAP_MARK;
+}
+
+static inline swp_entry_t swp_tb_vswap_to_swp_entry(unsigned long swp_tb)
+{
+	unsigned long offset;
+
+	VM_WARN_ON(!swp_tb_is_vswap(swp_tb));
+	offset = (swp_tb & SWP_RMAP_ENTRY_MASK) >> SWP_TB_VSWAP_MARK_BITS;
+	return swp_entry(vswap_si->type, offset);
+}
+
 #endif
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 69fac2d905a4..be66ac79313c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -57,6 +57,10 @@ static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
 			 enum swap_cluster_flags new_flags);
+static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
+					     struct swap_cluster_info *pci,
+					     unsigned int ci_start,
+					     unsigned int nr_pages);
 
 /*
  * Protects the swap_info array, and the SWP_USED flag. swap_info contains
@@ -247,7 +251,7 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
 			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio) &&
-			 !is_vswap_entry(folio->swap)));
+			 folio_phys_swap_backed(folio)));
 	if (!need_reclaim || !folio_swapcache_freeable(folio))
 		goto out_unlock;
 
@@ -961,6 +965,8 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 {
 	unsigned int order;
 	unsigned long nr_pages;
+	swp_entry_t vswap_entry, v;
+	unsigned int i;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -980,8 +986,26 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
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
+			 * (Vswap-tagged rmap).
+			 */
+			VM_WARN_ON(!is_vswap_entry(folio->swap));
+			vswap_entry = folio->swap;
+			for (i = 0; i < nr_pages; i++) {
+				v = vswap_entry;
+				v.val += i;
+				__swap_table_set(ci, ci_off + i,
+						 swp_entry_to_swp_tb_vswap(v));
+			}
+		} else {
+			__swap_cache_add_folio(ci, folio,
+				swp_entry(si->type,
+					  ci_off + cluster_offset(si, ci)));
+		}
 	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
 		order = 0;
 		nr_pages = 1;
@@ -1477,12 +1501,14 @@ static bool get_swap_device_info(struct swap_info_struct *si)
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
@@ -1491,25 +1517,28 @@ static bool swap_alloc_fast(struct folio *folio)
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
@@ -1518,12 +1547,12 @@ static void swap_alloc_slow(struct folio *folio)
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
@@ -1541,6 +1570,7 @@ static void swap_alloc_slow(struct folio *folio)
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
+	return (swp_entry_t){};
 }
 
 /*
@@ -1897,6 +1927,23 @@ static bool vswap_alloc(struct folio *folio)
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
@@ -1938,20 +1985,8 @@ int folio_alloc_swap(struct folio *folio)
 		}
 	}
 
-	if (may_vswap && vswap_alloc(folio))
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
+	if (!may_vswap || !vswap_alloc(folio))
+		folio_alloc_phys_swap(folio);
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
 	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
@@ -1988,8 +2023,11 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 			     unsigned int ci_start, unsigned int nr)
 {
 	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_info_struct *psi;
+	unsigned long phys_off_start = 0, phys_off_end = 0;
 	unsigned int ci_off;
 	unsigned long vt;
+	swp_entry_t phys_first = {};
 
 	lockdep_assert_held(&ci->lock);
 	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
@@ -1997,7 +2035,30 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 	for (ci_off = ci_start; ci_off < ci_start + nr; ci_off++) {
 		vt = __vtable_get(ci_dyn, ci_off);
 
+		/* The free helper takes one contiguous run within one cluster. */
+		if (phys_off_start != phys_off_end &&
+		    (vtable_type(vt) != VSWAP_SWAPFILE ||
+		     swp_type(vtable_to_phys(vt)) != swp_type(phys_first) ||
+		     swp_offset(vtable_to_phys(vt)) != phys_off_end ||
+		     phys_off_end % SWAPFILE_CLUSTER == 0)) {
+			psi = __swap_entry_to_info(phys_first);
+			__swap_cluster_free_phys_backing(psi,
+					__swap_entry_to_cluster(phys_first),
+					phys_off_start % SWAPFILE_CLUSTER,
+					phys_off_end - phys_off_start);
+			phys_off_start = phys_off_end = 0;
+		}
+
 		switch (vtable_type(vt)) {
+		case VSWAP_SWAPFILE:
+			if (phys_off_start == phys_off_end) {
+				phys_first = vtable_to_phys(vt);
+				phys_off_start = swp_offset(phys_first);
+				phys_off_end = phys_off_start + 1;
+			} else {
+				phys_off_end++;
+			}
+			break;
 		case VSWAP_ZSWAP:
 			zswap_entry_free(vtable_to_zswap(vt));
 			break;
@@ -2013,6 +2074,14 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 		if (__swap_table_test_zero(ci, ci_off))
 			__swap_table_clear_zero(ci, ci_off);
 	}
+
+	if (phys_off_start != phys_off_end) {
+		psi = __swap_entry_to_info(phys_first);
+		__swap_cluster_free_phys_backing(psi,
+				__swap_entry_to_cluster(phys_first),
+				phys_off_start % SWAPFILE_CLUSTER,
+				phys_off_end - phys_off_start);
+	}
 }
 
 /**
@@ -2040,6 +2109,103 @@ void folio_release_vswap_backing(struct folio *folio)
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
+	/*
+	 * A folio's slots cannot mix swapfile with other backends, except
+	 * mid-backend-change, which always starts from slot 0.
+	 */
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
@@ -2169,6 +2335,47 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return ERR_PTR(-EIO);
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
+ * Free physical swap slots that were backing vswap entries (Vswap-tagged).
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
@@ -2180,7 +2387,6 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned long old_tb;
 	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
-	unsigned long ci_head = cluster_offset(si, ci);
 	unsigned int batch_off = ci_off;
 
 	VM_WARN_ON(ci->count < nr_pages);
@@ -2218,13 +2424,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
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
@@ -3087,19 +3287,95 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 
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
+	swp_entry_t entry, vswap_entry, phys;
+	unsigned long swp_tb;
+	unsigned int i, j;
 
 	if (!swap_usage_in_pages(si))
 		goto success;
 
 retry:
+	/*
+	 * Free vswap-backing slots (Vswap-tagged) first. Walk physical
+	 * clusters, read the vswap entry from the rmap, ensure the data
+	 * is in the swap cache, and transition PHYS to FOLIO. Freeing the
+	 * physical backing is enough, so no page table walk is needed.
+	 */
+	i = 0;
+	while (vswap_is_enabled() &&
+	       swap_usage_in_pages(si) &&
+	       !signal_pending(current) &&
+	       (i = find_next_to_unuse(si, i)) != 0) {
+		swp_tb = swap_table_lookup(swp_entry(si->type, i));
+		if (!swp_tb_is_vswap(swp_tb))
+			continue;
+
+		vswap_entry = swp_tb_vswap_to_swp_entry(swp_tb);
+
+		folio = swap_cache_get_folio(vswap_entry);
+		if (!folio) {
+			folio = __swap_cache_alloc_folio(vswap_entry,
+							 GFP_HIGHUSER_MOVABLE,
+							 BIT(0), NULL, mpol,
+							 NO_INTERLEAVE_INDEX);
+			if (IS_ERR(folio)) {
+				if (PTR_ERR(folio) == -ENOMEM)
+					return -ENOMEM;
+				continue;
+			}
+			folio_add_lru(folio);
+			ctx = (struct swap_io_ctx){};
+			swap_read_folio(&ctx, folio);
+			swap_read_submit(&ctx);
+		}
+		folio_lock(folio);
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
@@ -3142,6 +3418,8 @@ static int try_to_unuse(unsigned int type)
 	       (i = find_next_to_unuse(si, i)) != 0) {
 
 		entry = swp_entry(type, i);
+
+		/* Vswap-tagged rmap slots have no folio; the pre-pass took them. */
 		folio = swap_cache_get_folio(entry);
 		if (!folio)
 			continue;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b9c5e92757f3..70044688a7cb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1145,17 +1145,26 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 
 static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 {
+	swp_entry_t entry;
+
 	if (gfp_mask & __GFP_FS)
 		return true;
 	/*
 	 * We can "enter_fs" for swap-cache with only __GFP_IO unless backed by
 	 * a swapfile that requires GFP_NOFS I/O.
 	 */
-	if (folio_test_swapcache(folio) && (gfp_mask & __GFP_IO) &&
-	    !(__swap_entry_to_info(folio->swap)->ops->flags &
-			SWAP_OPS_F_REQUIRE_NOFS))
-		return true;
-	return false;
+	if (!folio_test_swapcache(folio) || !(gfp_mask & __GFP_IO))
+		return false;
+
+	entry = folio->swap;
+	if (is_vswap_entry(entry)) {
+		entry = vswap_to_phys(entry);
+		if (!entry.val)
+			return true;
+	}
+
+	return !(__swap_entry_to_info(entry)->ops->flags &
+		 SWAP_OPS_F_REQUIRE_NOFS);
 }
 
 /*
@@ -1637,7 +1646,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (folio_test_swapcache(folio) &&
-		    ((mem_cgroup_swap_full(folio) && !is_vswap_entry(folio->swap)) ||
+		    ((mem_cgroup_swap_full(folio) && folio_phys_swap_backed(folio)) ||
 		     folio_test_mlocked(folio)))
 			folio_free_swap(folio);
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
diff --git a/mm/vswap.h b/mm/vswap.h
index 5334c77b6b84..6f952b2591d1 100644
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
+	if (IS_ERR_OR_NULL(phys_si))
+		return false;
+
+	has_flag = data_race(phys_si->flags & flag);
+	put_swap_device(phys_si);
+	return has_flag;
+}
+
 #endif /* _MM_VSWAP_H */
diff --git a/mm/zswap.c b/mm/zswap.c
index 73c6b82aa593..24c4e7a73d56 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1685,7 +1685,7 @@ bool zswap_store(struct folio *folio)
 	 */
 	if (is_vswap_entry(swp)) {
 		if (index > 0)
-			folio_release_vswap_backing(folio);
+			folio_release_non_phys_swap_backing(folio);
 	} else {
 		zswap_invalidate(swp_type(swp), swp_offset(swp), nr_pages);
 	}
-- 
2.53.0-Meta

