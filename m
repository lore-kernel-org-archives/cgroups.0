Received: from out203-205-221-191.mail.qq.com (out203-205-221-191.mail.qq.com [203.205.221.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D023AEF21;
	Tue, 29 Sep 2026 07:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790668706; cv=none; b=C6FnASqRpf452oHecJk72PYId+klb0+5A+XMy3hDs5XdeMIqSzGxeM7SGGiygXfMXTxURAkwb1PIX6sHSIB/MQpWESq43puPCrZWtgh5Aw5smZTys0Sy1JkDN5A9xbGtsD77ixiv8gLnMlcJdvDukBCnbfBA8uz3lKF+mDxaXt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790668706; c=relaxed/simple;
	bh=yTlgp6sNOw18Oz9D4AOe0puOTZjnC62TgEXLpb7a3uM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=b97g9H7puI2rNQEBrTxq9xiixmgCeCQe/U63li0wiW/9jFb9YKWXqqeUBx55CkbYekes872CWJ/78ZIE6t0LJyJBBaPJ7a1vQ3bbBCGx0y4XBYR952dKSs6n1lAeq0HIGJpS/REG7Pn4Aa6HvL0KFBTdW7QSGu09Cn9aQthf690=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=vzY4+W+j; arc=none smtp.client-ip=203.205.221.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="vzY4+W+j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790668700; bh=Xn8817W6WZLyNDDxORqo2E02dJXTlQdjYOBndTvvTdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzY4+W+j0HJiw08znqCBt9L6bhsXWgqG2MjkXVnY7x76CfD/3JsNm6345NCy85zVp
	 JX1MjTzkyf5VMUOYBt82E48GlfwnhWJKj6ZgLnzyIXU6Dxlz1nPDYOs4nV9DwXuAfC
	 A4bWil807IwaE8KSjDIXCvHZPwsI8g4DWN/mVcKI=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-XMAILINFO: OKoAQJjbfIk1tS+VZ1Rs+qY2zD5c7hIYdSuTS57fjOuC/B6lyqjsCvapPW9fDk
	 dXTwRVvj9p0GKpbvLQuC4sPMQNN/nV0TAob12/MrDX4ip5k7EU4hibGHS2ayUZlhlptwPRyDzj7LX
	 QNZzIDqFJad0lGyoi4CJGzI8e4gdSkyJuXGQAVS9MJl4NRpfsWPoFOHnGjGdDIy36jb2GQ4KAMZ8g
	 pBmfNv1tAGDx3OnorbtwDryii0h7oWSsrX1plTVEjFLoHRbGdXJnCEu5Lyj1LgcMQFPhIXkVlQnmZ
	 xPpfRYh8MPQ/gzkhqR6Ji/yVWT4idxgV2/G+L4pr9Xi5btbrAof4+Suyq0vY0u+pe9Cnu/ioYfCN0
	 SIDkA8JfwEV/uGTU1fq4CyzdPTdBBiHQCIIo/L0Xn0JA4pnqpFhLwK7dAJAVMa5I+u4pJXKhijmte
	 YkATrHLZb8SQkqrGM4rTEalbPNz7uz8WUZg0viFvBiOXg1Jb13qqw5jTsD3BMAOGJ118FgiIyjHog
	 NPqLxUtef8aDm5pyjWNOrmOL3cVVfDoGtnhc6+yFe20peDsWy59kCpV16dBfc0tvSz/oz/7HYAjJE
	 2Vx/2Rbcvh+nW/arGq4pC4JCI+1wjwKfSgwOrIAAT8nxO3JPOC41luc+puAtIWr4f8SgqlMwcHSCs
	 QnYagjR4+Y/lg92t5qz1PplIJIWY807tyA7l6MLj6+3I6AOyNN1RpzmiRh6sCiEukXca4MkeW8ux9
	 ULWlYS2BaVRRs3zCY8PRqdU7a9yo8SGeSLknFXUm0HAByDQjfJxmhyE8vm2XEUaY6W9wUMFl1pWwd
	 +LeaUKheAxgY1cB8EkgbSmZ9nuzsa13fILqHnPzGnLzlMCcKgiX996guwsAOWROIuKMYFx69xs1HI
	 LsRhhbCIZGAwaN4M1VgRyQngVudye6HB62MQYLtAtvkmiPW5A4d8OayIsprQ9niVKfXKZe39gMOVu
	 GlDd3wFp5DPD7ARKY2F8NwHDMjNb/bwTODVbcfKppRY8VH6MEpEoAaaGg4iXkHi/uiqQXXQK1jyBe
	 D33aLmvjJ5UDIdIHS1fIHG6/ACQnEoYho/60f89lwQs8Y6mAUjpLHAY6BfwIsW9/jaLiX9OWyBLgA
	 ErpBcunslAucUpHndggUafq6eKjkmdpNB51ne7PPZ1w4wyhtehCjP/ke6WM4nRpBWezuryFMZ6Z0r
	 L3e1BQiWiXz
Received: from lzk-B860M-AORUS-PRO-WIFI7 ([2409:8a28:a83:5ba1:514f:5353:e14b:594e])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id E8B0DEDA; Tue, 29 Sep 2026 15:58:11 +0800
X-QQ-mid: xmsmtpt1790668691tyx2ud429
Message-ID: <tencent_9C2F003FC5A7E19CB8ED71B63FAB29D41309@qq.com>
From: Zongkun Lei <leizongkun@qq.com>
To: linux-mm@kvack.org
Cc: Zongkun Lei <leizongkun@qq.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Hugh Dickins <hughd@google.com>,
	Peter Xu <peterx@redhat.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH 1/6] mm/swap: introduce folio_swap_entry() and convert all folio->swap readers
Date: Tue, 29 Sep 2026 15:58:07 +0800
X-OQ-MSGID: <4b4ab491e15fc75cdfac8d32a78c4a048529ff01.1790663399.git.leizongkun@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790663399.git.leizongkun@qq.com>
References: <cover.1790663399.git.leizongkun@qq.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hugetlb folios keep their per-folio flags in folio->private, which
shares a union with folio->swap.  While such a folio sits in the swap
cache, the low bits of folio->swap.val can therefore carry flag bits
rather than zeroes - with HVO enabled, HPG_vmemmap_optimized (bit 4)
is set on virtually every hugetlb folio.  Any naked read of
folio->swap on a swap-cached hugetlb folio would hand a corrupted
swap entry to the swap table, zswap, the memcg accounting or the I/O
paths.

Swap entries are always allocated aligned to the folio size, so
rounding the raw value down to folio_nr_pages() recovers the real
entry.  Wrap that in folio_swap_entry() and convert every reader of
folio->swap in the tree to use it.  For all non-hugetlb folios the
low bits are always zero (order-0 folios trivially, large folios
because the alignment leaves them clear), so the helper is an
identity transform and this patch changes no behaviour on any
existing path; reviewing it only requires auditing the helper itself
plus the single invariant "swap entries are folio-size aligned".

The write side keeps raw access deliberately:
__swap_cache_do_add_folio() now preserves the low flag bits when
installing the entry, and __swap_cache_do_del_folio() clears the
entry while keeping the flags, rounding the passed entry down so an
unaligned value can never leak into the swap table.

This is preparation for swap support of hugetlb folios; hugetlb
folios too small for all HPAGEFLAG bits to fit below the swap offset
will be kept out of the swap cache by the feature's size gate.

Signed-off-by: Zongkun Lei <leizongkun@qq.com>
---
 include/linux/swap.h | 22 +++++++++++++++++++++-
 mm/huge_memory.c     |  2 +-
 mm/memcontrol-v1.c   |  4 ++--
 mm/memcontrol.c      |  2 +-
 mm/memory.c          |  2 +-
 mm/page_io.c         | 18 +++++++++---------
 mm/shmem.c           |  6 +++---
 mm/swap.h            |  8 +++++---
 mm/swap_state.c      | 15 ++++++++++-----
 mm/swapfile.c        | 14 ++++++++------
 mm/userfaultfd.c     |  2 +-
 mm/util.c            |  2 +-
 mm/vmscan.c          |  4 ++--
 mm/zswap.c           |  4 ++--
 14 files changed, 67 insertions(+), 38 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5658a1634b85..677081238811 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -278,10 +278,30 @@ struct swap_info_struct {
 	const struct swap_ops *ops;
 };
 
+/**
+ * folio_swap_entry - Get the swap entry recorded in a swap cache folio.
+ * @folio: The folio, must be in the swap cache.
+ *
+ * Hugetlb folios keep their per-folio flags in folio->private, which aliases
+ * folio->swap, so the low bits of folio->swap.val may carry flag bits while
+ * the folio is swap cached.  Swap entries are always aligned to the folio
+ * size, so rounding down recovers the entry.  Hugetlb folios too small for
+ * all flag bits to fit below the swap offset never enter the swap cache;
+ * see hugetlb_folio_swap_supported().
+ *
+ * For all other folios the low bits are always zero, so this is an identity
+ * transform; always use it instead of reading folio->swap directly.
+ */
+static inline swp_entry_t folio_swap_entry(const struct folio *folio)
+{
+	return (swp_entry_t) { .val = round_down(folio->swap.val,
+						 folio_nr_pages(folio)) };
+}
+
 static inline swp_entry_t page_swap_entry(struct page *page)
 {
 	struct folio *folio = page_folio(page);
-	swp_entry_t entry = folio->swap;
+	swp_entry_t entry = folio_swap_entry(folio);
 
 	entry.val += folio_page_idx(folio, page);
 	return entry;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54494c3fa983..18824e298cff 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3760,7 +3760,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
 
 		if (folio_test_swapcache(folio))
-			new_folio->swap.val = folio->swap.val + i;
+			new_folio->swap.val = folio_swap_entry(folio).val + i;
 
 		/* Page flags must be visible before we make the page non-compound. */
 		smp_wmb();
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index bf2c7d53b01b..2186523f3f0e 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -299,7 +299,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
+	__swap_cgroup_set(ci, swp_cluster_offset(folio_swap_entry(folio)), nr_entries,
 			  mem_cgroup_private_id(swap_memcg));
 
 	folio_unqueue_deferred_split(folio);
@@ -369,7 +369,7 @@ void memcg1_swapin(struct folio *folio)
 	 */
 	nr_pages = folio_nr_pages(folio);
 	ci = swap_cluster_get_and_lock(folio);
-	id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
+	id = __swap_cgroup_clear(ci, swp_cluster_offset(folio_swap_entry(folio)),
 				 nr_pages);
 	swap_cluster_unlock(ci);
 	mem_cgroup_uncharge_swap(id, nr_pages);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 256b68ffca70..0ae9e3176479 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5781,7 +5781,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
 	ci = swap_cluster_get_and_lock(folio);
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
+	__swap_cgroup_set(ci, swp_cluster_offset(folio_swap_entry(folio)), nr_pages,
 			  mem_cgroup_private_id(memcg));
 	swap_cluster_unlock(ci);
 
diff --git a/mm/memory.c b/mm/memory.c
index bc14cae3c49d..4dcc8d73e3ee 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5056,7 +5056,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		address = folio_start;
 		ptep = folio_ptep;
 		nr_pages = nr;
-		entry = folio->swap;
+		entry = folio_swap_entry(folio);
 		page = &folio->page;
 	}
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 1da4ff484f09..e1ec577d5759 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -160,7 +160,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
 	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
 	int nr_pages = folio_nr_pages(folio);
 	struct swap_cluster_info *ci;
-	swp_entry_t entry = folio->swap;
+	swp_entry_t entry = folio_swap_entry(folio);
 	unsigned int i;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
@@ -183,7 +183,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
 static void swap_zeromap_folio_clear(struct folio *folio)
 {
 	struct swap_cluster_info *ci;
-	swp_entry_t entry = folio->swap;
+	swp_entry_t entry = folio_swap_entry(folio);
 	unsigned int i;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
@@ -321,7 +321,7 @@ int sio_pool_init(void)
 static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
 		int rw)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio_swap_entry(folio));
 	struct bio_vec *last_bv = &ctx->sio->bvecs[ctx->sio->nr_bvecs - 1];
 	struct folio *prev_folio = bvec_folio(last_bv);
 	size_t prev_folio_size = folio_size(prev_folio);
@@ -333,7 +333,7 @@ static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
 
 static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio_swap_entry(folio));
 	struct swap_iocb *sio = ctx->sio;
 
 	if (sio && !swap_can_merge(ctx, folio, rw)) {
@@ -432,7 +432,7 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 	 * that an IO error is emitted (e.g. do_swap_page() will sigbus).
 	 * Folio lock stabilizes the cluster and map, so the check is safe.
 	 */
-	if (WARN_ON_ONCE(swap_zeromap_batch(folio->swap, nr_pages,
+	if (WARN_ON_ONCE(swap_zeromap_batch(folio_swap_entry(folio), nr_pages,
 			 &is_zeromap) != nr_pages))
 		return true;
 
@@ -453,7 +453,7 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 
 void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio_swap_entry(folio));
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
@@ -525,7 +525,7 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(folio->swap));
+				   ret, swap_dev_pos(folio_swap_entry(folio)));
 	}
 
 	swap_write_end(sio, failed);
@@ -671,8 +671,8 @@ EXPORT_SYMBOL_GPL(swap_fs_prepare_rw);
 bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
 		size_t prev_folio_size, int rw)
 {
-	return swap_dev_pos(folio->swap) ==
-		swap_dev_pos(prev_folio->swap) + prev_folio_size;
+	return swap_dev_pos(folio_swap_entry(folio)) ==
+		swap_dev_pos(folio_swap_entry(prev_folio)) + prev_folio_size;
 }
 EXPORT_SYMBOL_GPL(swap_fs_can_merge);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index eeb9a78c125a..284d6d5d8b94 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1914,7 +1914,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		}
 
 		folio_dup_swap(folio, NULL);
-		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
+		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio_swap_entry(folio)));
 
 		BUG_ON(folio_mapped(folio));
 		error = swap_writeout(ctx, folio);
@@ -1929,7 +1929,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		 * it will be appropriate if other reactivate cases are added.
 		 */
 		error = shmem_add_to_page_cache(folio, mapping, index,
-				swp_to_radix_entry(folio->swap),
+				swp_to_radix_entry(folio_swap_entry(folio)),
 				__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
 		/* Swap entry might be erased by racing shmem_free_swap() */
 		if (!error) {
@@ -2293,7 +2293,7 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 {
 	struct swap_cluster_info *ci;
 	struct folio *new, *old = *foliop;
-	swp_entry_t entry = old->swap;
+	swp_entry_t entry = folio_swap_entry(old);
 	int nr_pages = folio_nr_pages(old);
 	int error = 0;
 
diff --git a/mm/swap.h b/mm/swap.h
index 0b5d507739bc..19c260353e08 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -173,10 +173,12 @@ static inline struct swap_cluster_info *swap_cluster_lock(
 static inline struct swap_cluster_info *__swap_cluster_get_and_lock(
 		const struct folio *folio, bool irq)
 {
+	swp_entry_t entry = folio_swap_entry(folio);
+
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
-	return __swap_cluster_lock(__swap_entry_to_info(folio->swap),
-				   swp_offset(folio->swap), irq);
+	return __swap_cluster_lock(__swap_entry_to_info(entry),
+				   swp_offset(entry), irq);
 }
 
 /*
@@ -287,7 +289,7 @@ static inline loff_t swap_dev_pos(swp_entry_t entry)
 static inline bool folio_matches_swap_entry(const struct folio *folio,
 					    swp_entry_t entry)
 {
-	swp_entry_t folio_entry = folio->swap;
+	swp_entry_t folio_entry = folio_swap_entry(folio);
 	long nr_pages = folio_nr_pages(folio);
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 305877e1f4d7..516052efbf62 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -227,7 +227,11 @@ static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
 
 	folio_ref_add(folio, nr_pages);
 	folio_set_swapcache(folio);
-	folio->swap = entry;
+	/*
+	 * Keep the low bits, they may carry hugetlb specific flags that
+	 * share folio->private with folio->swap (see folio_swap_entry()).
+	 */
+	folio->swap.val = entry.val | (folio->swap.val & (nr_pages - 1));
 }
 
 /**
@@ -269,6 +273,7 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
 
+	entry.val = round_down(entry.val, nr_pages);
 	si = __swap_entry_to_info(entry);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
@@ -286,7 +291,7 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
 				 __swp_tb_get_flags(old_tb)));
 	} while (++ci_off < ci_end);
 
-	folio->swap.val = 0;
+	folio->swap.val &= nr_pages - 1;
 	folio_clear_swapcache(folio);
 
 	if (!folio_swapped) {
@@ -336,7 +341,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 void swap_cache_del_folio(struct folio *folio)
 {
 	struct swap_cluster_info *ci;
-	swp_entry_t entry = folio->swap;
+	swp_entry_t entry = folio_swap_entry(folio);
 
 	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
 	__swap_cache_del_folio(ci, folio, entry, NULL);
@@ -362,7 +367,7 @@ void swap_cache_del_folio(struct folio *folio)
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new)
 {
-	swp_entry_t entry = new->swap;
+	swp_entry_t entry = folio_swap_entry(new);
 	unsigned long nr_pages = folio_nr_pages(new);
 	unsigned int ci_off = swp_cluster_offset(entry);
 	unsigned int ci_end = ci_off + nr_pages;
@@ -387,7 +392,7 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	 */
 	if (IS_ENABLED(CONFIG_DEBUG_VM) &&
 	    folio_order(old) != folio_order(new)) {
-		ci_off = swp_cluster_offset(old->swap);
+		ci_off = swp_cluster_offset(folio_swap_entry(old));
 		ci_end = ci_off + folio_nr_pages(old);
 		while (ci_off++ < ci_end)
 			WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 408f6c72fb5a..c01bb490f4fc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -230,7 +230,7 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 		folio_put(folio);
 		goto again;
 	}
-	offset = swp_offset(folio->swap);
+	offset = swp_offset(folio_swap_entry(folio));
 
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
@@ -330,12 +330,14 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
 
 sector_t swap_folio_sector(struct folio *folio)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct swap_info_struct *sis;
 	struct swap_extent *se;
 	sector_t sector;
+	swp_entry_t entry = folio_swap_entry(folio);
 	pgoff_t offset;
 
-	offset = swp_offset(folio->swap);
+	sis = __swap_entry_to_info(entry);
+	offset = swp_offset(entry);
 	se = offset_to_swap_extent(sis, offset);
 	sector = se->start_block + (offset - se->start_page);
 	return sector << (PAGE_SHIFT - 9);
@@ -1803,7 +1805,7 @@ int folio_alloc_swap(struct folio *folio)
  */
 int folio_dup_swap(struct folio *folio, struct page *page)
 {
-	swp_entry_t entry = folio->swap;
+	swp_entry_t entry = folio_swap_entry(folio);
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -1829,7 +1831,7 @@ int folio_dup_swap(struct folio *folio, struct page *page)
  */
 void folio_put_swap(struct folio *folio, struct page *page)
 {
-	swp_entry_t entry = folio->swap;
+	swp_entry_t entry = folio_swap_entry(folio);
 	unsigned long nr_pages = folio_nr_pages(folio);
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 
@@ -2033,7 +2035,7 @@ int swp_swapcount(swp_entry_t entry)
  */
 static bool folio_maybe_swapped(struct folio *folio)
 {
-	swp_entry_t entry = folio->swap;
+	swp_entry_t entry = folio_swap_entry(folio);
 	struct swap_cluster_info *ci;
 	unsigned int ci_off, ci_end;
 	bool ret = false;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 79cc7b546f13..a774877a919a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1383,7 +1383,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	 * not locked.
 	 */
 	if (src_folio && unlikely(!folio_test_swapcache(src_folio) ||
-				  entry.val != src_folio->swap.val))
+				  entry.val != folio_swap_entry(src_folio).val))
 		return -EAGAIN;
 
 	double_pt_lock(dst_ptl, src_ptl);
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d0..1209f85251a3 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -727,7 +727,7 @@ struct address_space *folio_mapping(const struct folio *folio)
 		return NULL;
 
 	if (unlikely(folio_test_swapcache(folio)))
-		return swap_address_space(folio->swap);
+		return swap_address_space(folio_swap_entry(folio));
 
 	mapping = folio->mapping;
 	if ((unsigned long)mapping & FOLIO_MAPPING_FLAGS)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b4c9b8f3dfe9..9a0c8815fb69 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -731,7 +731,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 	}
 
 	if (folio_test_swapcache(folio)) {
-		swp_entry_t swap = folio->swap;
+		swp_entry_t swap = folio_swap_entry(folio);
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
@@ -1049,7 +1049,7 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 	 * a swapfile that requires GFP_NOFS I/O.
 	 */
 	if (folio_test_swapcache(folio) && (gfp_mask & __GFP_IO) &&
-	    !(__swap_entry_to_info(folio->swap)->ops->flags &
+	    !(__swap_entry_to_info(folio_swap_entry(folio))->ops->flags &
 			SWAP_OPS_F_REQUIRE_NOFS))
 		return true;
 	return false;
diff --git a/mm/zswap.c b/mm/zswap.c
index f3ae3c81e48e..6ff2cda52b9e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1475,7 +1475,7 @@ static bool zswap_store_page(struct page *page,
 bool zswap_store(struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
-	swp_entry_t swp = folio->swap;
+	swp_entry_t swp = folio_swap_entry(folio);
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
@@ -1580,7 +1580,7 @@ bool zswap_store(struct folio *folio)
  */
 int zswap_load(struct folio *folio)
 {
-	swp_entry_t swp = folio->swap;
+	swp_entry_t swp = folio_swap_entry(folio);
 	pgoff_t offset = swp_offset(swp);
 	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
-- 
2.53.0

