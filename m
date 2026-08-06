Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEFA3AFCF0
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041791; cv=none; b=SI8HXUXOyl7ANuljlNu8+C/3dy4lFzJ49dXd+5tNTziAQK1FMANyWmmKImjfcHbIDZTAC7KEyuvGQs4gQtToLUCuloGHIkf+nYMRm0VCASKBkrz0idN0wTGHk8/6EMchaOn7YpnhLm0P7I8Jn4xvIUygxYOT9xOb0voDta2qVR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041791; c=relaxed/simple;
	bh=nwodC1vLGvhsbb6BdnopoPES0nNfkVSIPRTTmoidO1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEpr3894uHgmoNfOAO7xWAcdMrI4+jBw+bxnpgZ2zPIn9X1qu+/8yxZFdVB9tvvT3UL/rz4iZUzzvVNDxb7QU1JK4tCfDbRaVDoNn/+dpErc86NUtdM0PmGAo9MHg6m4IzVlH98IPiGBXoA5aU9OcP2CR0ly1bYv/0MIKNxAFwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nTtBhumL; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nTtBhumL"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6acc2a10023so938585eaf.0
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 11:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041786; x=1786646586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2jkqf0E4cj9fQT5qd3L4w2YuapP3ELsmfSVpofHj8EA=;
        b=nTtBhumLC00+UmchPylMz1nXnNQePLZBmfJ+i5rKmGt9w/hOxLxDByF9rFK2l9mDxc
         gsIg7IOZ64jcu6osqWnuAt65RgLoMvMd3C0jTeintObP78j8tDvb7kBdZMUR9P6LQPAe
         QHlU/8/4EjDsEFnvGmGFXyEcO1d2XOyOagfEcK6pSq6+L88/5JBuqswtLU1QF6gSXAdT
         CeZLF7YqrHJNWl/MT/KhzjF6dxOA6S8Hz/Yzcl8zuRV1pnh/KPCY1cW3csI7m4SVS9T4
         nLTcqEcS2p2YVEsT5BuU+tInTvw3R4JOmBchEhg4WOR4YEqjElSsyTnrJ99zQ3ZbhvpB
         j9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041786; x=1786646586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2jkqf0E4cj9fQT5qd3L4w2YuapP3ELsmfSVpofHj8EA=;
        b=XJkGcCunvkdp+QYo1zlYU8cvWsGGrYcXVa5tLudK1lAXTPHd221vcztTXj2CAxTrDM
         gjDqDdLNKQnFvkHcXpXkS9TZlRxuARAC5n5rZfT98aNjz+titnAXRqZOm6Xte9Zy7ReD
         ZM6aYp4A4fMkigrqt+8ZjsTZ+8TBlipuC+TpauuFWAW774zqJeY/hOF5k6GYuEC6qT4e
         FpK9zXf//ID7n+4iLzNVjui1tZlJc829lGeH7nE/3uiROxJHXw5xcd3N0Ggb2rcpEsOo
         uDWI5ZPv3eNHBIC3qK4pj8IoDXDzU3mLnOinfQ5hVPUCQtvVSY7VjJ2uSGmHioQVow+j
         mkxA==
X-Forwarded-Encrypted: i=1; AHgh+RreiLDE2AgpOo1X7ts0fbQ4ApqwE58gElEZp50J9ThZ8lhVkJH9CZFm0u8e2KwSMkG7bMFnCZUc@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8pOUa9CP3WJbSpSc0Q11lejucbme0dexAX+teh8KM0v0WJ8KJ
	zDGds0PiUVMQ5IR5xpi1Y/jfSXGsBt9V+pe8cjTimrjZR6g9++bXdy7W
X-Gm-Gg: AR+sD12NGhQLwisXNiXGx5oDfKf9Z2PV3p22nt3c2vq+c5ZTyYPx3Aka5reP3ee/8aH
	EsOwO7n2PU7TFZLDSBaky9XmjP24X2t01pYtc2LKM72EQYwqKLXHLWNvBwZhjwHgYHQIETG3Xe+
	WhD7FInQLT6Z2ivU8xLPOaT4WZgJZOEV3Ri+ugcvucCH+Fzq9jDHA3px5Het/mNwDzNXj5E6CEw
	qivjoOhF9QgqkpfkfqIVfvaZ+fFsx4yr8+UciWlbL0MipGvYhw6Bevz7Hega5eY3+hcFbwL7uKu
	8dUpdGQarHx+TS+L3yRkYeLRxD42oEZMdiNkBu0sIVlcQlClDUJB10MK55Wof+eiAuzJAJui2zL
	LuOom/HCK/4UavZ9XYk2ESZNB55IZjlN/Ef62awykXz121tCuQKI6lNBKswhs3iOBRu67EGlGmG
	BIVQ0xgmc5qP1x8gZVKDVJ279VmlD5Uy0u5DoEAAYfEIBmQ8PBK4kDQRXnIHO+jfsyTFvYIGC6I
	YdGSCTeYoc=
X-Received: by 2002:a05:6820:4c14:b0:6ac:a9c6:92c with SMTP id 006d021491bc7-6ae96c8868bmr8744138eaf.10.1786041786572;
        Thu, 06 Aug 2026 11:43:06 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bfa6379sm144245eaf.14.2026.08.06.11.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:06 -0700 (PDT)
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
Subject: [PATCH v3 07/11] mm, swap: reclaim physical slots backing cache-only vswap entries
Date: Thu,  6 Aug 2026 11:42:50 -0700
Message-ID: <20260806184254.3790858-8-nphamcs@gmail.com>
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

A vswap entry backed by a physical slot can become cache-only: its
swap_count drops to 0 while the folio is still in the swap cache, so the
physical slot is redundant and reclaimable. Until now such a slot was
only freed when the vswap entry itself was freed, pinning otherwise
reclaimable physical capacity.

Reclaim such slots from the physical reclaim scanner, once swap is more
than half used (vm_swap_full()), to free physical capacity for new
allocations.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swap_table.h |  11 +++-
 mm/swapfile.c   | 142 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/vswap.h      |  26 +++++++++
 3 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 5b0eca07a821..b50ebcd9e4de 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -377,9 +377,12 @@ static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
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
+ *             C = SWP_RMAP_CACHE_ONLY (bit 63)
  */
 #ifdef CONFIG_VSWAP
 extern struct swap_info_struct *vswap_si;
@@ -387,7 +390,8 @@ extern struct swap_info_struct *vswap_si;
 #define SWP_TB_PTR_MARK_BITS	3
 #define SWP_TB_PTR_MARK		0b100UL
 #define SWP_TB_PTR_MARK_MASK	((1UL << SWP_TB_PTR_MARK_BITS) - 1)
-#define SWP_RMAP_ENTRY_MASK	(~SWP_TB_PTR_MARK_MASK)
+#define SWP_RMAP_CACHE_ONLY	(1UL << (BITS_PER_LONG - 1))
+#define SWP_RMAP_ENTRY_MASK	(~(SWP_RMAP_CACHE_ONLY | SWP_TB_PTR_MARK_MASK))
 
 static inline bool swp_tb_is_pointer(unsigned long swp_tb)
 {
@@ -408,6 +412,7 @@ static inline swp_entry_t swp_tb_ptr_to_swp_entry(unsigned long swp_tb)
 	return swp_entry(vswap_si->type, offset);
 }
 #else
+#define SWP_RMAP_CACHE_ONLY	0UL
 static inline bool swp_tb_is_pointer(unsigned long swp_tb)
 {
 	return false;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0874f57d3124..ab4bb57707e6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -151,8 +151,20 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 };
 
 static bool vswap_alloc(struct folio *folio);
+static void vswap_mark_cache_only(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned int ci_off);
+static void vswap_clear_cache_only(struct swap_info_struct *si,
+				   struct swap_cluster_info *ci,
+				   unsigned int ci_start, int nr);
 #else
 static inline bool vswap_alloc(struct folio *folio) { return false; }
+static inline void vswap_mark_cache_only(struct swap_info_struct *si,
+					 struct swap_cluster_info *ci,
+					 unsigned int ci_off) {}
+static inline void vswap_clear_cache_only(struct swap_info_struct *si,
+					  struct swap_cluster_info *ci,
+					  unsigned int ci_start, int nr) {}
 #endif
 
 /* May return NULL on invalid type, caller must check for NULL return */
@@ -912,6 +924,59 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 	return ret;
 }
 
+/*
+ * Try to reclaim a Pointer-tagged physical slot backing a vswap entry.
+ * The physical cluster lock must NOT be held. Returns the number of physical
+ * slots reclaimed (the backing folio's page count), or < 0 on failure.
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
+		return -1;
+
+	if (!folio_trylock(folio)) {
+		folio_put(folio);
+		return -1;
+	}
+
+	if (!folio_matches_swap_entry(folio, vswap_entry)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return -1;
+	}
+
+	/*
+	 * Re-validate under folio lock. The folio's first vswap entry is
+	 * folio->swap; the rmap value we just read is folio->swap + i for
+	 * some i in [0, nr_pages). Check the folio's first entry still maps
+	 * to the contiguous physical run that includes our target offset.
+	 */
+	i = vswap_entry.val - folio->swap.val;
+	phys_base = vswap_to_phys(folio->swap);
+	if (!phys_base.val || swp_type(phys_base) != si->type ||
+	    swp_offset(phys_base) + i != offset ||
+	    i >= folio_nr_pages(folio)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return -1;
+	}
+
+	ret = folio_nr_pages(folio);
+	if (!folio_free_swap(folio))
+		ret = -1;
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+}
+
 /*
  * Reclaim drops the ci lock, so the cluster may become unusable (freed or
  * stolen by a lower order). @usable will be set to false if that happens.
@@ -935,6 +1000,16 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 	spin_unlock(&ci->lock);
 	do {
 		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		if (swp_tb_is_pointer(swp_tb)) {
+			rcu_read_unlock();
+			if (!(swp_tb & SWP_RMAP_CACHE_ONLY))
+				goto relock;
+			if (try_to_reclaim_vswap_backing(si, offset,
+							 swp_tb_ptr_to_swp_entry(swp_tb)) < 0)
+				goto relock;
+			rcu_read_lock();
+			continue;
+		}
 		if (swp_tb_get_count(swp_tb))
 			break;
 		if (swp_tb_is_folio(swp_tb))
@@ -942,6 +1017,7 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 				break;
 	} while (++offset < end);
 	rcu_read_unlock();
+relock:
 
 	/* Re-lookup: dynamic cluster may have been freed while lock was dropped */
 	ci = swap_cluster_lock(si, start);
@@ -1209,6 +1285,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 	long to_scan = 1;
 	unsigned long offset, end;
 	struct swap_cluster_info *ci;
+	swp_entry_t vswap_entry;
 	unsigned long swp_tb;
 	int nr_reclaim;
 
@@ -1233,6 +1310,19 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
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
+				if (nr_reclaim > 0) {
+					offset += nr_reclaim;
+					continue;
+				}
 			}
 			offset++;
 		}
@@ -1812,6 +1902,8 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 			}
 			/* count will be 0 after put, slot can be reclaimed */
 			need_reclaim = true;
+			if (swap_is_vswap(si))
+				vswap_mark_cache_only(si, ci, ci_off);
 		}
 		/*
 		 * A count != 1 or cached slot can't be freed. Put its swap
@@ -1918,6 +2010,7 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 			goto failed;
 		}
 	} while (++ci_off < ci_end);
+	vswap_clear_cache_only(si, ci, ci_start, nr);
 	swap_cluster_unlock(ci);
 	return 0;
 failed:
@@ -2034,6 +2127,55 @@ int folio_alloc_swap(struct folio *folio)
 }
 
 #ifdef CONFIG_VSWAP
+static void vswap_mark_cache_only(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
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
+static void vswap_clear_cache_only(struct swap_info_struct *si,
+				   struct swap_cluster_info *ci,
+				   unsigned int ci_start, int nr)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *pci;
+	unsigned long swp_tb, vt;
+	swp_entry_t phys;
+	unsigned int off;
+
+	if (!swap_is_vswap(si))
+		return;
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
 
 static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 					     struct swap_cluster_info *pci,
diff --git a/mm/vswap.h b/mm/vswap.h
index a921620f08be..803e9a3271fe 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -35,6 +35,32 @@ static inline bool is_vswap_entry(swp_entry_t entry)
 
 bool vswap_is_enabled(void);
 
+/*
+ * Rmap cache-only helpers for physical cluster Pointer-tagged entries.
+ * SWP_RMAP_CACHE_ONLY records, inline on the physical swap_table entry,
+ * that the backing vswap entry has swap_count == 0 (swap-cache-only, so
+ * reclaimable). The physical reclaim scanner reads it directly instead of
+ * chasing the rmap into the vswap layer and paying the cluster-lookup
+ * indirection.
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

