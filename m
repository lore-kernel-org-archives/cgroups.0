Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C80148A8C8
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 15:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671982; cv=none; b=Syx5sK3iYvxxQ/WqS+yMy0UIbZ/jBRobfcqlCB4bYt8GSh7wxNdHjCdV4s/k3/nqydQKg1ES4w51q48aqUOKRFO6Z2U9cvnL3aCVZTlO5/Hq86uAWZVoiU3BBBY47mlvAhVAJ8MMpY3+/NpuJdBVTg96fcZDJ0BvsGNgLmPfMKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671982; c=relaxed/simple;
	bh=4B5CVeeW+H8xhmPHjOyG0zUr0e2Whn+FP3FajcUNunw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZ/lVSQV4z38vjhuj1mLXIoLA7nVhYruGLeGFzqfUKCgxFdwnrDxE2lonJnftZHUKWhCOuZABcx6UK7H2x3+K4yiTp7eCN+DPP/gkkepf5RzaxOEcrCSb27scx9Lhksv9c/TKEG2nt5tnX0CUUF+Q7ptPg42RZT6vRyMoyrGsV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c2KnE9Es; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c2KnE9Es"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e9eaf04bfaso2577291a34.1
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 08:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671973; x=1788276773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8+Xifm4yMHmmJc4W3PmSLP73v1OoKmGISMUVeCn1vQA=;
        b=c2KnE9Esmn4fhxz7kJ7PPEBvEyDgOv63Q9a7ULtXLhMypQrRUUUz7AableiL9FwXGt
         DGyuT8yIKvyGO3PcP2xtHSEsKux0XNCJKKPlIm1RDGOKpfJLWH8cAdDRKf2QJ3EdrRcM
         svF4NORS84xqmhG35MVQVafsYXshK/Wnh+nwnoFmCRVr17Pb0XmxW2uMLpSiLCsIB79F
         MhZ4ZAGWhwpouSR2JW0e+uE4ti48tg8xVYGi7Qx4M6qQHMcaSjzn9CdEbWdXGU3oA89u
         VtaQkdx+el1xpWu9MrUB0/3WiU+2IyTfXNwfZW5lXjT2xPW8My/S8vefqgtxDADklhS8
         dXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671973; x=1788276773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8+Xifm4yMHmmJc4W3PmSLP73v1OoKmGISMUVeCn1vQA=;
        b=jLKW4HMAiUOi/rf7cp8zAQYROybb2Ohu+HWa9cQ+vpDU8jEFDpnXA7w2NUP5FY11OY
         KSbeeBbiD6twDO7ArGB9z1LtLg/FBqkODhXGgUFsR8ngnr40/IIW9uqJIiRuqusxb50c
         OtPkQCMdx519jkOxWxKT6Nq33ml2nhx3rkyri6LYGaZkF2I8qpzrIcvRzCzXPJHypq92
         amBCdMt7wYp2KqzwOXneXEpOFidVfs77G5pO3MoN5Okk/YLy5Jb8Ii9NRnTR3fvaItAv
         OYuCy8EB3rQaFHoCQxMf6bwnUNaYCH7KOjFvNbWyzNeLxksuBcy40eCFXNhxerTHf3nk
         piiw==
X-Forwarded-Encrypted: i=1; AHgh+RroOT9goq1Jn1v2t5adA+fv/68wVA6mwYVspcJ99tb73kZ2FIehV2TCTjOHjvK3N+ubTHDaZZcf@vger.kernel.org
X-Gm-Message-State: AFuF++mN+WjWOHQnq00q1GF5UBvK56rE9jT4Vl7VA0r6VzFbJ4e3Uxdb
	56G+SpEDKFJXIQmBBsdAg9kTZS6gt514W0mxcursQchX092RpjFC02jw
X-Gm-Gg: AR+sD10Wm9TB49KcLngrLp1C2fYLWomB57Tt2/F1qNG9DrmOQGJNxgJrEzRvHU6F4Jk
	hDEH0s+w4vmJtPcsACzV6xjHxGAqlsRFTjkYnzXxmX+6tWXt/+M6Hq9aakFNIzuEgnHhIhU8RMU
	B4UyvsxLVvcbIJpu42ha1vw4ULXVyCOoRvMHyqe4IGCsxX6jIpM1iBubgzjMiEO0x8eUHuiWKOK
	fjrOJ+esiUr1B8AhYM9FPzm6h5YxBNRie9XtXA2mthWqeuT7fQ7FFOmh2Z98LSoYPS2ohbu4/aY
	WNz7ssBv9kInUFI22OcUom2FCEQpF0EybkPdBRe7rNZN3IyXMiDjqgRBXpnNrgxAwZ2+Dk6UpgG
	ajfvHE8ngHvpdnB8zpDnkfwwXLNrRj0AK9fP9ADoXeABi/vUh/LsNskLXg9KXhg67F9wp4dTse5
	yvNPiyIBcMBT9o6jFqboGb5ilxKkK2hwIysbSfUOIA9UpzRVCLVRyVo8Wz5tcvhE0EfsmO4UY6N
	6TSeGUy5L7QbpTXv0EhXnY=
X-Received: by 2002:a05:6830:6af8:b0:7e9:e313:4fdb with SMTP id 46e09a7af769-7f47639d520mr29228026a34.2.1787671972520;
        Tue, 25 Aug 2026 08:32:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm8021692a34.12.2026.08.25.08.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:52 -0700 (PDT)
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
Subject: [PATCH v4 07/11] mm, swap: reclaim physical slots backing cache-only vswap entries
Date: Tue, 25 Aug 2026 08:32:33 -0700
Message-ID: <20260825153238.2695446-8-nphamcs@gmail.com>
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

When a vswap entry's swap_count drops to 0 while its folio is still in
the swap cache, the entry is cache-only and its physical slot is
redundant. Until now such a slot was only freed when the vswap entry
itself was freed, pinning otherwise reclaimable physical capacity.

Reclaim such slots from the physical reclaim scanner, once swap is more
than half used (vm_swap_full()), to free physical capacity for new
allocations.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swap_table.h |  12 +++--
 mm/swapfile.c   | 115 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/vswap.h      |  31 +++++++++++++
 3 files changed, 154 insertions(+), 4 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 08d2494a8ee6..b614b1989fd9 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -31,7 +31,7 @@ struct swap_memcg_table {
  * NULL:     |---------------- 0 ---------------| - Free slot
  * Shadow:   |SWAP_COUNT|Z|---- SHADOW_VAL ---|1| - Swapped out slot
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
- * Pointer:  |-------- vswap offset --------|100| - vswap rmap
+ * Pointer:  |C|------- vswap offset -------|100| - vswap rmap
  * Bad:      |------------- 1 -------------|1000| - Bad slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
@@ -376,14 +376,18 @@ static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
  * On physical clusters, a Pointer-tagged entry stores the offset of the
  * vswap entry that owns this physical slot (the reverse map). Only the
  * offset is stored; the swap type is implicit (always vswap_si->type,
- * since there is exactly one vswap device).
+ * since there is exactly one vswap device). The top bit is reserved as
+ * a cache-only flag, set when vswap swap_count drops to 0 but the folio
+ * is still in swap cache.
  *
- *   Pointer:  |---- vswap offset ----|100|
+ *   Pointer:  |C|---- vswap offset ----|100|
+ *              C = SWP_RMAP_CACHE_ONLY (bit 63)
  */
 #define SWP_TB_PTR_MARK_BITS	3
 #define SWP_TB_PTR_MARK		0b100UL
 #define SWP_TB_PTR_MARK_MASK	((1UL << SWP_TB_PTR_MARK_BITS) - 1)
-#define SWP_RMAP_ENTRY_MASK	(~SWP_TB_PTR_MARK_MASK)
+#define SWP_RMAP_CACHE_ONLY	(1UL << (BITS_PER_LONG - 1))
+#define SWP_RMAP_ENTRY_MASK	(~(SWP_RMAP_CACHE_ONLY | SWP_TB_PTR_MARK_MASK))
 
 static inline bool swp_tb_is_pointer(unsigned long swp_tb)
 {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 66bcbb112142..6ec439462490 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -142,6 +142,10 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 };
 
 static bool vswap_alloc(struct folio *folio);
+static void vswap_mark_cache_only(struct swap_cluster_info *ci,
+				  unsigned int ci_off);
+static void vswap_clear_cache_only(struct swap_cluster_info *ci,
+				   unsigned int ci_start, int nr);
 
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
@@ -867,6 +871,54 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 	return ret;
 }
 
+/*
+ * Try to reclaim a Pointer-tagged physical slot backing a vswap entry.
+ * The physical cluster lock must NOT be held. Returns the backing folio's
+ * page count, negated if the slots could not be reclaimed, or 0 if the
+ * folio could not be shown to own @offset (i.e. there is a race).
+ */
+static int try_to_reclaim_vswap_backing(struct swap_info_struct *si,
+					unsigned long offset,
+					swp_entry_t vswap_entry)
+{
+	swp_entry_t phys_base;
+	struct folio *folio;
+	unsigned int i;
+	int ret;
+
+	folio = swap_cache_get_folio(vswap_entry);
+	if (!folio)
+		return 0;
+
+	if (!folio_trylock(folio)) {
+		folio_put(folio);
+		return 0;
+	}
+
+	if (!folio_matches_swap_entry(folio, vswap_entry)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return 0;
+	}
+
+	i = vswap_entry.val - folio->swap.val;
+	phys_base = vswap_to_phys(folio->swap);
+	if (!phys_base.val || swp_type(phys_base) != si->type ||
+	    swp_offset(phys_base) + i != offset) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return 0;
+	}
+
+	/* The run is ours: skip it all, whether or not the free succeeds. */
+	ret = folio_nr_pages(folio);
+	if (!folio_free_swap(folio))
+		ret = -ret;
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+}
+
 /*
  * Reclaim drops the ci lock, so the cluster may become unusable (freed or
  * stolen by a lower order). @usable will be set to false if that happens.
@@ -1148,6 +1200,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 	long to_scan = 1;
 	unsigned long offset, end;
 	struct swap_cluster_info *ci;
+	swp_entry_t vswap_entry;
 	unsigned long swp_tb;
 	int nr_reclaim;
 
@@ -1172,6 +1225,19 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 					offset += abs(nr_reclaim);
 					continue;
 				}
+			} else if (swp_tb_is_pointer(swp_tb) &&
+				   (swp_tb & SWP_RMAP_CACHE_ONLY)) {
+				vswap_entry = swp_tb_ptr_to_swp_entry(swp_tb);
+				spin_unlock(&ci->lock);
+				nr_reclaim = try_to_reclaim_vswap_backing(si, offset,
+									  vswap_entry);
+				ci = swap_cluster_lock(si, offset);
+				if (!ci)
+					goto next;
+				if (nr_reclaim) {
+					offset += abs(nr_reclaim);
+					continue;
+				}
 			}
 			offset++;
 		}
@@ -1748,6 +1814,8 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 			}
 			/* count will be 0 after put, slot can be reclaimed */
 			need_reclaim = true;
+			if (swap_is_vswap(si))
+				vswap_mark_cache_only(ci, ci_off);
 		}
 		/*
 		 * A count != 1 or cached slot can't be freed. Put its swap
@@ -1854,6 +1922,8 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 			goto failed;
 		}
 	} while (++ci_off < ci_end);
+	if (swap_is_vswap(si))
+		vswap_clear_cache_only(ci, ci_start, nr);
 	swap_cluster_unlock(ci);
 	return 0;
 failed:
@@ -1981,6 +2051,51 @@ int folio_alloc_swap(struct folio *folio)
 	return 0;
 }
 
+static void vswap_mark_cache_only(struct swap_cluster_info *ci,
+				  unsigned int ci_off)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *pci;
+	swp_entry_t phys;
+	unsigned long vt;
+
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	vt = __vtable_get(ci_dyn, ci_off);
+
+	if (vtable_type(vt) == VSWAP_SWAPFILE) {
+		phys = vtable_to_phys(vt);
+		pci = __swap_entry_to_cluster(phys);
+		swap_rmap_mark_cache_only(pci, swp_cluster_offset(phys));
+	}
+}
+
+/*
+ * Clear the cache-only rmap hint for entries re-referenced from count 0 to 1
+ * (no longer reclaimable), so the physical reclaim scanner skips them.
+ */
+static void vswap_clear_cache_only(struct swap_cluster_info *ci,
+				   unsigned int ci_start, int nr)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *pci;
+	unsigned long swp_tb, vt;
+	swp_entry_t phys;
+	unsigned int off;
+
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	for (off = ci_start; off < ci_start + nr; off++) {
+		swp_tb = __swap_table_get(ci, off);
+		if (!swp_tb_is_folio(swp_tb) || swp_tb_get_count(swp_tb) != 1)
+			continue;
+		vt = __vtable_get(ci_dyn, off);
+		if (vtable_type(vt) != VSWAP_SWAPFILE)
+			continue;
+		phys = vtable_to_phys(vt);
+		pci = __swap_entry_to_cluster(phys);
+		swap_rmap_clear_cache_only(pci, swp_cluster_offset(phys));
+	}
+}
+
 static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 					     struct swap_cluster_info *pci,
 					     unsigned int ci_start,
diff --git a/mm/vswap.h b/mm/vswap.h
index ce35a8381ca0..c66fa34e2e60 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -44,6 +44,37 @@ static inline bool is_vswap_entry(swp_entry_t entry)
 	return swap_is_vswap(__swap_entry_to_info(entry));
 }
 
+/*
+ * Rmap cache-only helpers for physical cluster Pointer-tagged entries.
+ * SWP_RMAP_CACHE_ONLY records, inline on the physical swap_table entry,
+ * that the backing vswap entry has swap_count == 0 (swap-cache-only, so
+ * reclaimable). The physical reclaim scanner reads it directly instead of
+ * chasing the rmap into the vswap layer and paying the cluster-lookup
+ * indirection.
+ *
+ * Callers hold the vswap cluster lock, not the physical one. The rmap is
+ * only touched while the vtable holds the slot as SWAPFILE, and that
+ * window is opened and closed under the vswap cluster lock, so the
+ * allocator has finished writing the entry by then.
+ */
+static inline void swap_rmap_mark_cache_only(struct swap_cluster_info *ci,
+					     unsigned int off)
+{
+	atomic_long_t *table;
+
+	table = rcu_dereference_check(ci->table, true);
+	atomic_long_or(SWP_RMAP_CACHE_ONLY, &table[off]);
+}
+
+static inline void swap_rmap_clear_cache_only(struct swap_cluster_info *ci,
+					      unsigned int off)
+{
+	atomic_long_t *table;
+
+	table = rcu_dereference_check(ci->table, true);
+	atomic_long_and(~SWP_RMAP_CACHE_ONLY, &table[off]);
+}
+
 /*
  * Virtual table entry encoding for vswap clusters.
  *
-- 
2.53.0-Meta

