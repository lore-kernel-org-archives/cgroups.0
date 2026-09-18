Received: from mail-oa2-f37.google.com (mail-oa2-f37.google.com [74.125.231.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E2951DAFC
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789754591; cv=none; b=ASbeMQiKOFoKqwkFrb6HFsAnTEp8Q79oY7tAqi6cl/ULotd9HnlJ8kGGLOaj9RvnYDSvxXpKLCxY99wVmlZ0j27wich2NrsJEIjQbvBcJMAIXAngJgGcnjX9QM23p6iHrzskr/Q2tY1IMReCfvzSTMeYc77UDtmySfVgxGfKQaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789754591; c=relaxed/simple;
	bh=1ru2Zp5ILl53osMtDD38RHdLyI5pG1nL61SzFYE36Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4wzCtWFzAPTwJO/9ABD//YbPo7xfE0InzC+VCJeuw0qRG5VGBNmrbTqE62AJGx98UtNeZ1RyPUxu+Wfyf2OAD7GU1wws53XTgeYFq8CtNGBwJMSwZvAtoXkk7gwuB4ZFOEqkS7bnRMXuqER99lo8hsKh4ZXIln25npQOACRv28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pgDk5Rvd; arc=none smtp.client-ip=74.125.231.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pgDk5Rvd"
Received: by mail-oa2-f37.google.com with SMTP id 586e51a60fabf-46accbdfc39so1198231fac.3
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 11:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754582; x=1790359382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eMvS9UEOG0U7dnKspyTQkECTAwb3ShdMHwYlkFC5G4c=;
        b=pgDk5Rvdhn2zbZE5GFZHOH+rzBX3UBNEnmEVQuJ5stiMrtL6JGlXn7OSYSwyXpeGTB
         Vu3c5/nF/rOq5vUe1tTINKCXwYqpyODexEnE3SPddXdKOwN28lF6/mKnbh62QRopNzZV
         XUQF2JgIF1DGXUf8fwnNzXhoJmzrh2pMPRvc08KR12S5HuwWeYqiEq+zdFIyO7xcw+8R
         cZ2T4WaXyynPjAdsxcjk7nQzlSPCk2qdzGD9TFTscYFXs90Bob6C56qfCjalxhnRpKHL
         e3v6cAwqKm2XHLmRQ7qvXWXKmhMRhOV10e94YlhkDiGV9BoKpVaHPYHLUAfrOo4p+53W
         pY7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754582; x=1790359382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eMvS9UEOG0U7dnKspyTQkECTAwb3ShdMHwYlkFC5G4c=;
        b=U4nUbT9LKpAxv+3Q17lbvWr8vABA/rrl+refODJr1gViUvZ2m15j3aXwHr+Gv8tA0T
         ZurTCIHgJJXN30JpB/f+Qx/bELbCs4mj6Exwmhs0X61BPaEWdno1aBb6r53fi7P+KQmg
         0jXpScCSRFYUPd69Ej3W0DBUAcInf8UivVhi5AnnbT0N2T/vNdC2TprBOl0VgJi6Dbb7
         e2d7LZyifaEX1qZsEiJrd2/n2sVb9fN6wz94fWcghOOIag1rlFdjtvq0vbyEf1rOLI2S
         2by944lojNvyK6U15oQxc4nTBYhz8oBRfvTw/Wqtr4qzgQQE64RdSLO8d1qgQP2MKb08
         EGQQ==
X-Forwarded-Encrypted: i=1; AKwUvBxGACH2U2Kv7ix5gBFdNBBdhTq3ulWl2mQnEARiUUXsGAfENKeEVKxBZ99bIuRL2LmrGKmhHRiu@vger.kernel.org
X-Gm-Message-State: AFuF++mQLrTd7NGooYOj2GuZvl3X2yysJ+92ZmzmRSrvXqGWKKEPvJDU
	VM6DYJpi9UVi7ekpqh8Q+QKC7upW/e5Urtij4TO5eh4ngkE816S2VGA/
X-Gm-Gg: AYBFou0RU4yvTL9t0EovRlDQzdvVU4emATGitYJeOA9ql2IR14wbloroP5THymcyted
	cemG3zhGzV/oJ6mvf7HmGqkcNCtgMCqIExlf0k7S+z8ayLE5K63Z06QK8VOqjmprfzk4yhuE2u+
	NlPPqLQMIceibahnJrDFkfDez2JLMPdKReAjLq0L4JIFaJFleSYyVcFaX2d4M1pLuOa7okW6pOi
	qtbqk4irLRzOcWmyoCPoKBB7+2HnAOpCxg8t1navP+mnaaFUdTITW9hP0UX+DXRFXFrseMpyHh4
	PBNART/kKlCH5/f3hWdH0Ulc21gr03itKXWQJtcLXb8G6m5mulM5ETtlrSsWWuCObzcwnq56sFN
	BY93pgrOnpxux4OOz8XRyP8GiINF6bBUs2q3j1rErA1n5gPE5GNd5kSXCBMmKlyWkpdibEQI24p
	Pvznt8bXu9QbAvecvhwg5C2gyWInWfubanZiH6gQTjvdm+z4LW3wWLxSrAr/HOIig1+qqNaC5m0
	uplLVzHBMCYHAxN78e5bQ==
X-Received: by 2002:a05:6871:3865:b0:41b:e633:baf4 with SMTP id 586e51a60fabf-486e4bc49dfmr4029647fac.3.1789754581881;
        Fri, 18 Sep 2026 11:03:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4873922d1besm1668863fac.6.2026.09.18.11.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:03:01 -0700 (PDT)
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
Subject: [RFC PATCH v5 11/11] mm, swap: back vswap clusters with a VM_SPARSE array
Date: Fri, 18 Sep 2026 11:02:41 -0700
Message-ID: <20260918180241.3424851-12-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vswap keeps its cluster_info in an xarray of individually allocated
clusters. Replace it with the VM_SPARSE vmalloc array Baoquan He
designed for xswap: one reservation at init, mapped a page of clusters
at a time as the device grows. That drops the per-cluster allocation and
the xarray nodes, and it simplifies access, because the index gives the
address. A lookup becomes arithmetic instead of an xa_load() that can
return NULL, and no cluster needs an RCU grace period to be freed, so
the NULL arm goes away in every caller along with the index and rcu_head
fields, the kfree_rcu(), CLUSTER_FLAG_DEAD and __vswap_cluster_lock().
Only the grow side is ported; there is no shrink.

That leaves swap_cluster_info_dynamic wrapping swap_cluster_info for a
single pointer, so move the virtual table into swap_cluster_info and
delete the wrapper. Both cluster arrays then have the same element type
and merge into si->cluster_info, which restores cluster_index() to
upstream's subtraction and leaves __swap_offset_to_cluster() a plain
array index. A vswap cluster ends up smaller, having lost the index and
rcu_head; a physical cluster grows by the one pointer it never uses.

A cluster is no longer destroyed when it empties. There is nothing left
to free, since it is now an element of a fixed array, so it goes onto
si->free_clusters like a physical device's cluster and waits to be
reused.

Its virtual table is still freed, and that is the bulk of it:
SWAPFILE_CLUSTER pointers, a full page at the usual layout, against a
few dozen bytes for the cluster itself. An emptied cluster gives back
almost all of what it held; only the mapping stays.

Most of this is Baoquan's code, adapted to vswap's existing cluster
layer rather than to a new device type, so I am keeping his attributions
from the original posting.

Co-developed-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Link: https://lore.kernel.org/all/20260916101929.149106-1-hebaoquan@kylinos.cn/
---
 include/linux/swap.h |   5 +-
 mm/swap.h            |  61 +-------
 mm/swap_state.c      |  19 +--
 mm/swap_table.h      |   9 --
 mm/swapfile.c        | 353 ++++++++++++++++++++++++++++---------------
 mm/vswap.h           |  96 +++++-------
 6 files changed, 280 insertions(+), 263 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index cd22db50b44c..dffdec14c407 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -164,6 +164,7 @@ static inline void mm_account_reclaimed_pages(unsigned long pages)
 
 struct address_space;
 struct sysinfo;
+struct vm_struct;
 struct zone;
 
 /*
@@ -271,7 +272,9 @@ struct swap_info_struct {
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
 	const struct swap_ops *ops;
-	struct xarray cluster_info_pool; /* Xarray for vswap dynamic cluster info */
+	struct vm_struct *cluster_info_area; /* Vswap cluster array reservation */
+	unsigned int nr_mapped_clusters; /* Mapped prefix of cluster_info */
+	struct mutex cluster_grow_lock;	/* Serialize growth of the array */
 };
 
 static inline bool swap_is_vswap(struct swap_info_struct *si)
diff --git a/mm/swap.h b/mm/swap.h
index df323d5e8da8..83015ff5f390 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -64,16 +64,10 @@ struct swap_cluster_info {
 #if !SWAP_TABLE_HAS_ZEROFLAG
 	unsigned long *zero_bitmap;
 #endif
+	atomic_long_t *virtual_table;	/* Backing pointers, vswap clusters only */
 	struct list_head list;
 };
 
-struct swap_cluster_info_dynamic {
-	struct swap_cluster_info ci;
-	unsigned int index;		/* for cluster_index() */
-	struct rcu_head rcu;
-	atomic_long_t *virtual_table;	/* Backing pointers for vswap slots */
-};
-
 /* All on-list cluster must have a non-zero flag. */
 enum swap_cluster_flags {
 	CLUSTER_FLAG_NONE = 0, /* For temporary off-list cluster */
@@ -84,7 +78,6 @@ enum swap_cluster_flags {
 	CLUSTER_FLAG_USABLE = CLUSTER_FLAG_FRAG,
 	CLUSTER_FLAG_FULL,
 	CLUSTER_FLAG_DISCARD,
-	CLUSTER_FLAG_DEAD,	/* Vswap dynamic cluster pending kfree_rcu */
 	CLUSTER_FLAG_MAX,
 };
 
@@ -127,17 +120,6 @@ static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
 	return __swap_type_to_info(swp_type(entry));
 }
 
-/**
- * __swap_offset_to_cluster - look up the cluster holding a swap offset
- * @si: the swap device
- * @offset: the swap entry offset
- *
- * Context: A vswap cluster is freed by kfree_rcu(). Callers must hold the
- * RCU read lock, or know the cluster is pinned by an in-use entry.
- *
- * Return: the cluster, or NULL if @si is a vswap device with no cluster
- * allocated at @offset.
- */
 static inline struct swap_cluster_info *__swap_offset_to_cluster(
 		struct swap_info_struct *si, pgoff_t offset)
 {
@@ -145,13 +127,8 @@ static inline struct swap_cluster_info *__swap_offset_to_cluster(
 
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 	VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));
-
-	if (swap_is_vswap(si)) {
-		struct swap_cluster_info_dynamic *ci_dyn;
-
-		ci_dyn = xa_load(&si->cluster_info_pool, cluster_idx);
-		return ci_dyn ? &ci_dyn->ci : NULL;
-	}
+	VM_WARN_ON_ONCE(swap_is_vswap(si) &&
+			cluster_idx >= READ_ONCE(si->nr_mapped_clusters));
 
 	return &si->cluster_info[cluster_idx];
 }
@@ -162,32 +139,6 @@ static inline struct swap_cluster_info *__swap_entry_to_cluster(swp_entry_t entr
 					swp_offset(entry));
 }
 
-static inline struct swap_cluster_info *__vswap_cluster_lock(
-		struct swap_info_struct *si, unsigned long offset, bool irq)
-{
-	struct swap_cluster_info *ci;
-
-	rcu_read_lock();
-	ci = __swap_offset_to_cluster(si, offset);
-	if (ci) {
-		if (irq)
-			spin_lock_irq(&ci->lock);
-		else
-			spin_lock(&ci->lock);
-
-		/* The cluster can be torn down while we wait for the lock. */
-		if (ci->flags == CLUSTER_FLAG_DEAD) {
-			if (irq)
-				spin_unlock_irq(&ci->lock);
-			else
-				spin_unlock(&ci->lock);
-			ci = NULL;
-		}
-	}
-	rcu_read_unlock();
-	return ci;
-}
-
 static __always_inline struct swap_cluster_info *__swap_cluster_lock(
 		struct swap_info_struct *si, unsigned long offset, bool irq)
 {
@@ -205,9 +156,6 @@ static __always_inline struct swap_cluster_info *__swap_cluster_lock(
 	VM_WARN_ON_ONCE(!in_task());
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 
-	if (swap_is_vswap(si))
-		return __vswap_cluster_lock(si, offset, irq);
-
 	ci = __swap_offset_to_cluster(si, offset);
 	if (irq)
 		spin_lock_irq(&ci->lock);
@@ -223,8 +171,7 @@ static __always_inline struct swap_cluster_info *__swap_cluster_lock(
  *
  * Context: The caller must ensure the offset is in the valid range and
  * protect the swap device with reference count or locks.
- * Return: the locked cluster, or NULL if it is gone. Only a vswap device
- * can return NULL, as its clusters are allocated and freed on demand.
+ * Return: The locked cluster.
  */
 static inline struct swap_cluster_info *swap_cluster_lock(
 		struct swap_info_struct *si, unsigned long offset)
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 2107d05ae8d5..627fee08593c 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -165,7 +165,6 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
 	bool is_zero;
-	struct swap_cluster_info_dynamic *ci_dyn;
 	enum vswap_backing_type type;
 	int ret;
 
@@ -201,8 +200,7 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	 * swap_cache_alloc_folio will retry with a smaller order on -EBUSY.
 	 */
 	if (is_vswap_entry(targ_entry)) {
-		ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
-		ret = __vswap_check_backing(ci_dyn, round_down(ci_off, nr),
+		ret = __vswap_check_backing(ci, round_down(ci_off, nr),
 					    nr, &type);
 		if (ret != nr || type == VSWAP_ZSWAP)
 			return -EBUSY;
@@ -451,12 +449,9 @@ static struct folio *__swap_cache_alloc(swp_entry_t targ_entry, gfp_t gfp,
 	entry.val = round_down(targ_entry.val, nr_pages);
 
 	/* Check if the slot and range are available, skip allocation if not */
-	err = -ENOENT;
 	ci = swap_cluster_lock(si, offset);
-	if (ci) {
-		err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL, NULL);
-		swap_cluster_unlock(ci);
-	}
+	err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL, NULL);
+	swap_cluster_unlock(ci);
 	if (unlikely(err))
 		return ERR_PTR(err);
 
@@ -477,13 +472,10 @@ static struct folio *__swap_cache_alloc(swp_entry_t targ_entry, gfp_t gfp,
 		return ERR_PTR(-ENOMEM);
 
 	/* Double check the range is still not in conflict */
-	err = -ENOENT;
 	ci = swap_cluster_lock(si, offset);
-	if (ci)
-		err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow, &memcg_id);
+	err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow, &memcg_id);
 	if (unlikely(err)) {
-		if (ci)
-			swap_cluster_unlock(ci);
+		swap_cluster_unlock(ci);
 		folio_put(folio);
 		return ERR_PTR(err);
 	}
@@ -495,7 +487,6 @@ static struct folio *__swap_cache_alloc(swp_entry_t targ_entry, gfp_t gfp,
 
 	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
 					   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
-		/* The folio pins the cluster */
 		spin_lock(&ci->lock);
 		__swap_cache_do_del_folio(ci, folio, entry, shadow);
 		spin_unlock(&ci->lock);
diff --git a/mm/swap_table.h b/mm/swap_table.h
index 79f06642a553..7d005a943881 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -266,11 +266,6 @@ static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
 	return swp_tb;
 }
 
-/*
- * Resolve @entry's cluster and read its slot, both under RCU. A vswap
- * cluster is allocated on demand and freed by kfree_rcu(), so a caller
- * starting from an entry cannot resolve it beforehand.
- */
 static inline unsigned long swap_table_lookup(swp_entry_t entry)
 {
 	struct swap_cluster_info *ci;
@@ -279,10 +274,6 @@ static inline unsigned long swap_table_lookup(swp_entry_t entry)
 
 	rcu_read_lock();
 	ci = __swap_entry_to_cluster(entry);
-	if (!ci) {
-		rcu_read_unlock();
-		return null_to_swp_tb();
-	}
 	table = rcu_dereference(ci->table);
 	swp_tb = table ? atomic_long_read(&table[swp_cluster_offset(entry)])
 		       : null_to_swp_tb();
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 39d1840b0d36..d529a27fdd89 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -144,6 +144,35 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 };
 
 static atomic_long_t vswap_alloc_reject = ATOMIC_LONG_INIT(0);
+
+/*
+ * Vswap allocates from its own device with a separate percpu cluster cache,
+ * so the allocator has two local locks to pick from.
+ */
+static void swap_percpu_cluster_lock(struct swap_info_struct *si)
+{
+	if (swap_is_vswap(si))
+		local_lock(&percpu_vswap_cluster.lock);
+	else
+		local_lock(&percpu_swap_cluster.lock);
+}
+
+static void swap_percpu_cluster_unlock(struct swap_info_struct *si)
+{
+	if (swap_is_vswap(si))
+		local_unlock(&percpu_vswap_cluster.lock);
+	else
+		local_unlock(&percpu_swap_cluster.lock);
+}
+
+static void swap_percpu_cluster_assert_held(struct swap_info_struct *si)
+{
+	if (swap_is_vswap(si))
+		lockdep_assert_held(&this_cpu_ptr(&percpu_vswap_cluster)->lock);
+	else
+		lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
+}
+
 static void vswap_mark_cache_only(struct swap_cluster_info *ci,
 				  unsigned int ci_off);
 static void vswap_clear_cache_only(struct swap_cluster_info *ci,
@@ -420,8 +449,6 @@ static inline bool cluster_is_usable(struct swap_cluster_info *ci, int order)
 static inline unsigned int cluster_index(struct swap_info_struct *si,
 					 struct swap_cluster_info *ci)
 {
-	if (swap_is_vswap(si))
-		return container_of(ci, struct swap_cluster_info_dynamic, ci)->index;
 	return ci - si->cluster_info;
 }
 
@@ -450,10 +477,14 @@ static void swap_cluster_free_count_table(struct swap_table *table)
 		 swap_cluster_free_table_folio_rcu_cb);
 }
 
-static void swap_cluster_free_table(struct swap_cluster_info *ci)
+static void swap_cluster_free_table(struct swap_info_struct *si,
+				    struct swap_cluster_info *ci)
 {
 	struct swap_table *table;
 
+	if (swap_is_vswap(si))
+		vswap_cluster_free_vtable(ci);
+
 #ifdef CONFIG_MEMCG
 	kfree(ci->memcg_table);
 	ci->memcg_table = NULL;
@@ -515,12 +546,19 @@ static int swap_cluster_alloc_table(struct swap_info_struct *si,
 	VM_WARN_ON_ONCE(ci->zero_bitmap);
 	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
 	if (!ci->zero_bitmap) {
-		swap_cluster_free_table(ci);
+		swap_cluster_free_table(si, ci);
 		swap_cluster_free_count_table(table);
 		return -ENOMEM;
 	}
 #endif
 
+	/* The virtual table shares the swap table's lifetime. */
+	if (swap_is_vswap(si) && vswap_cluster_alloc_vtable(ci, gfp)) {
+		swap_cluster_free_table(si, ci);
+		swap_cluster_free_count_table(table);
+		return -ENOMEM;
+	}
+
 	/*
 	 * Make tables visible to cluster_is_usable() after everything is
 	 * ready.
@@ -571,10 +609,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 	/*
 	 * Only cluster isolation from the allocator does table allocation.
 	 * Swap allocator uses percpu clusters and holds the local lock.
-	 * vswap clusters are destroyed rather than freed to si->free_clusters.
 	 */
-	VM_WARN_ON_ONCE(swap_is_vswap(si));
-	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
+	swap_percpu_cluster_assert_held(si);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
@@ -591,7 +627,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	spin_unlock(&ci->lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
-	local_unlock(&percpu_swap_cluster.lock);
+	swap_percpu_cluster_unlock(si);
 
 	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					       GFP_KERNEL);
@@ -604,7 +640,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	local_lock(&percpu_swap_cluster.lock);
+	swap_percpu_cluster_lock(si);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_lock(&si->global_cluster_lock);
 	spin_lock(&ci->lock);
@@ -652,20 +688,7 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
 	swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, false);
-	swap_cluster_free_table(ci);
-
-	if (swap_is_vswap(si)) {
-		struct swap_cluster_info_dynamic *ci_dyn;
-
-		/* vswap clusters are destroyed, not returned to free_clusters. */
-		ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
-		xa_erase(&si->cluster_info_pool, ci_dyn->index);
-		move_cluster(si, ci, NULL, CLUSTER_FLAG_DEAD);
-		vswap_cluster_free_vtable(ci);
-		kfree_rcu(ci_dyn, rcu);
-		return;
-	}
-
+	swap_cluster_free_table(si, ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
 }
@@ -1202,50 +1225,147 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	return found;
 }
 
-static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
-					struct folio *folio)
+/*
+ * Reserve address space for the vswap cluster array. Nothing is mapped yet,
+ * so this costs address space only, plus an eighth of it in shadow under
+ * CONFIG_KASAN_VMALLOC.
+ */
+static int vswap_reserve_cluster_array(struct swap_info_struct *si,
+				       unsigned long maxpages)
+{
+	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
+
+	mutex_init(&si->cluster_grow_lock);
+	si->cluster_info_area = get_vm_area(nr_clusters *
+					    sizeof(*si->cluster_info),
+					    VM_SPARSE);
+	if (!si->cluster_info_area)
+		return -ENOMEM;
+
+	si->cluster_info = si->cluster_info_area->addr;
+	return 0;
+}
+
+static void vswap_free_cluster_array(struct swap_info_struct *si)
+{
+	unsigned long addr, end;
+	struct page *page;
+
+	if (!si->cluster_info_area)
+		return;
+
+	end = round_up((unsigned long)&si->cluster_info[si->nr_mapped_clusters],
+		       PAGE_SIZE);
+	for (addr = (unsigned long)si->cluster_info; addr < end;
+	     addr += PAGE_SIZE) {
+		page = vmalloc_to_page((void *)addr);
+		vm_area_unmap_pages(si->cluster_info_area, addr,
+				    addr + PAGE_SIZE);
+		__free_page(page);
+	}
+
+	free_vm_area(si->cluster_info_area);
+	si->cluster_info_area = NULL;
+	si->cluster_info = NULL;
+	si->nr_mapped_clusters = 0;
+}
+
+static bool vswap_can_grow(struct swap_info_struct *si)
+{
+	return READ_ONCE(si->nr_mapped_clusters) <
+	       DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER);
+}
+
+/* Clusters added per growth of the vswap cluster array, one page worth. */
+#define VSWAP_GROW_CLUSTERS						\
+	max_t(unsigned long,						\
+	      PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
+
+/*
+ * Map one more page of the vswap cluster array and hand the clusters it
+ * covers to the allocator. The caller must not hold the percpu cluster
+ * lock: vm_area_map_pages() might sleep.
+ *
+ * The mapped prefix only ever grows, so the pages already backing clusters
+ * [0, si->nr_mapped_clusters) are exactly those below the page boundary
+ * above the last one. A grow whose clusters all fall inside an already
+ * mapped page maps nothing.
+ */
+static int vswap_grow_clusters(struct swap_info_struct *si)
 {
-	struct swap_cluster_info_dynamic *ci_dyn;
 	struct swap_cluster_info *ci;
-	unsigned long offset;
+	unsigned int noreclaim_flags;
+	unsigned long start, end;
+	struct page *page;
+	unsigned int i, first, nr;
+	int err = -ENOSPC;
 
+	BUILD_BUG_ON(VSWAP_GROW_CLUSTERS *
+		     sizeof(struct swap_cluster_info) > PAGE_SIZE);
 	VM_WARN_ON(!swap_is_vswap(si));
 
-	ci_dyn = kzalloc_obj(*ci_dyn, GFP_ATOMIC | __GFP_NOWARN);
-	if (!ci_dyn)
-		return SWAP_ENTRY_INVALID;
+	/* Rechecked under the mutex, this only keeps a full device cheap. */
+	if (!vswap_can_grow(si))
+		return -ENOSPC;
 
-	spin_lock_init(&ci_dyn->ci.lock);
-	INIT_LIST_HEAD(&ci_dyn->ci.list);
+	/* Outside the mutex, so this one may still reclaim. */
+	page = alloc_page(__GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL |
+			  __GFP_ZERO);
 
-	if (swap_cluster_alloc_table(si, &ci_dyn->ci,
-				     GFP_ATOMIC | __GFP_NOWARN)) {
-		kfree(ci_dyn);
-		return SWAP_ENTRY_INVALID;
-	}
+	mutex_lock(&si->cluster_grow_lock);
+	first = si->nr_mapped_clusters;
+	nr = min_t(unsigned int, VSWAP_GROW_CLUSTERS,
+		   DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER) - first);
+	if (!nr)
+		goto out;
 
-	if (vswap_cluster_alloc_vtable(ci_dyn, GFP_ATOMIC | __GFP_NOWARN)) {
-		swap_cluster_free_table(&ci_dyn->ci);
-		kfree(ci_dyn);
-		return SWAP_ENTRY_INVALID;
-	}
+	start = round_up((unsigned long)&si->cluster_info[first],
+			 PAGE_SIZE);
+	end = round_up((unsigned long)&si->cluster_info[first + nr],
+		       PAGE_SIZE);
 
-	/* Lock before publishing: xa_alloc makes the cluster findable by offset. */
-	ci = &ci_dyn->ci;
-	spin_lock(&ci->lock);
+	if (start != end) {
+		err = -ENOMEM;
+		if (!page)
+			goto out;
+		/*
+		 * vm_area_map_pages() allocates page tables with
+		 * GFP_PGTABLE_KERNEL, so they carry __GFP_DIRECT_RECLAIM.
+		 * A non-reclaim caller of folio_alloc_swap() would otherwise
+		 * recurse back here and deadlock on the mutex it already
+		 * holds. Callers already under PF_MEMALLOC do not need this,
+		 * swapon does. It grants the page tables reserve access, at
+		 * most three pages per grow.
+		 */
+		noreclaim_flags = memalloc_noreclaim_save();
+		err = vm_area_map_pages(si->cluster_info_area, start, end,
+					&page);
+		memalloc_noreclaim_restore(noreclaim_flags);
+		if (err)
+			goto out;
+		page = NULL;
+	}
 
-	if (xa_alloc(&si->cluster_info_pool, &ci_dyn->index, ci_dyn,
-		     XA_LIMIT(1, DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER) - 1),
-		     GFP_ATOMIC | __GFP_NOWARN)) {
+	/*
+	 * Publish the new clusters before they become reachable by offset.
+	 * A zeroed page leaves them off-list with CLUSTER_FLAG_NONE, which
+	 * is what move_cluster() expects.
+	 */
+	WRITE_ONCE(si->nr_mapped_clusters, first + nr);
+	for (i = first; i < first + nr; i++) {
+		ci = &si->cluster_info[i];
+		spin_lock_init(&ci->lock);
+		INIT_LIST_HEAD(&ci->list);
+		spin_lock(&ci->lock);
+		move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 		spin_unlock(&ci->lock);
-		swap_cluster_free_table(&ci_dyn->ci);
-		vswap_cluster_free_vtable(&ci_dyn->ci);
-		kfree(ci_dyn);
-		return SWAP_ENTRY_INVALID;
 	}
-
-	offset = cluster_offset(si, ci);
-	return alloc_swap_scan_cluster(si, ci, folio, offset, NULL);
+	err = 0;
+out:
+	mutex_unlock(&si->cluster_grow_lock);
+	if (page)
+		__free_page(page);
+	return err;
 }
 
 static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
@@ -1272,8 +1392,6 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
 				ci = swap_cluster_lock(si, offset);
-				if (!ci)
-					goto next;
 				if (nr_reclaim) {
 					offset += abs(nr_reclaim);
 					continue;
@@ -1285,8 +1403,6 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 				nr_reclaim = try_to_reclaim_vswap_backing(si, offset,
 									  vswap_entry);
 				ci = swap_cluster_lock(si, offset);
-				if (!ci)
-					goto next;
 				if (nr_reclaim) {
 					offset += abs(nr_reclaim);
 					continue;
@@ -1300,7 +1416,6 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 			relocate_cluster(si, ci);
 
 		swap_cluster_unlock(ci);
-next:
 		if (to_scan <= 0)
 			break;
 
@@ -1378,10 +1493,19 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 
-	if (swap_is_vswap(si)) {
-		found = vswap_alloc_cluster(si, folio);
-		if (found)
-			goto done;
+	/*
+	 * Grow the vswap cluster array and let the free list scan below pick
+	 * up the new clusters. Growth sleeps, so drop the percpu cluster lock
+	 * across it; the scan does not care which CPU it lands back on. The
+	 * list_empty() test is racy either way: a stale empty costs one page,
+	 * a stale non-empty skips the grow and leaves the caller to the
+	 * fragment and stealing scans below.
+	 */
+	if (swap_is_vswap(si) && list_empty(&si->free_clusters) &&
+	    vswap_can_grow(si)) {
+		local_unlock(&percpu_vswap_cluster.lock);
+		vswap_grow_clusters(si);
+		local_lock(&percpu_vswap_cluster.lock);
 	}
 
 	if (!(si->flags & SWP_PAGE_DISCARD)) {
@@ -1630,11 +1754,11 @@ static swp_entry_t swap_alloc_fast(struct folio *folio)
 		return (swp_entry_t){};
 
 	ci = swap_cluster_lock(si, offset);
-	if (ci && cluster_is_usable(ci, order)) {
+	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
 		found = alloc_swap_scan_cluster(si, ci, folio, offset, NULL);
-	} else if (ci) {
+	} else {
 		swap_cluster_unlock(ci);
 	}
 
@@ -1760,7 +1884,6 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 	if (IS_ERR_OR_NULL(si))
 		return 0;
 
-	/* The source PTE pins the entry, so its cluster is alive. */
 	ci = __swap_offset_to_cluster(si, offset);
 	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), gfp);
 
@@ -2021,12 +2144,12 @@ static bool vswap_alloc(struct folio *folio)
 
 	if (offset != SWAP_ENTRY_INVALID) {
 		ci = swap_cluster_lock(vswap_si, offset);
-		if (ci && cluster_is_usable(ci, order)) {
+		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(vswap_si, ci);
 			alloc_swap_scan_cluster(vswap_si, ci, folio, offset,
 						NULL);
-		} else if (ci) {
+		} else {
 			swap_cluster_unlock(ci);
 		}
 	}
@@ -2138,13 +2261,11 @@ int folio_alloc_swap(struct folio *folio)
 static void vswap_mark_cache_only(struct swap_cluster_info *ci,
 				  unsigned int ci_off)
 {
-	struct swap_cluster_info_dynamic *ci_dyn;
 	struct swap_cluster_info *pci;
 	swp_entry_t phys;
 	unsigned long vt;
 
-	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
-	vt = __vtable_get(ci_dyn, ci_off);
+	vt = __vtable_get(ci, ci_off);
 
 	if (vtable_type(vt) == VSWAP_SWAPFILE) {
 		phys = vtable_to_phys(vt);
@@ -2160,18 +2281,16 @@ static void vswap_mark_cache_only(struct swap_cluster_info *ci,
 static void vswap_clear_cache_only(struct swap_cluster_info *ci,
 				   unsigned int ci_start, int nr)
 {
-	struct swap_cluster_info_dynamic *ci_dyn;
 	struct swap_cluster_info *pci;
 	unsigned long swp_tb, vt;
 	swp_entry_t phys;
 	unsigned int off;
 
-	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
 	for (off = ci_start; off < ci_start + nr; off++) {
 		swp_tb = __swap_table_get(ci, off);
 		if (!swp_tb_is_folio(swp_tb) || swp_tb_get_count(swp_tb) != 1)
 			continue;
-		vt = __vtable_get(ci_dyn, off);
+		vt = __vtable_get(ci, off);
 		if (vtable_type(vt) != VSWAP_SWAPFILE)
 			continue;
 		phys = vtable_to_phys(vt);
@@ -2229,7 +2348,6 @@ static void vswap_uncharge_cgroup_batch(unsigned short memcg_id,
 void __vswap_release_backing(struct swap_cluster_info *ci,
 			     unsigned int ci_start, unsigned int nr)
 {
-	struct swap_cluster_info_dynamic *ci_dyn;
 	struct swap_info_struct *psi;
 	unsigned long phys_off_start = 0, phys_off_end = 0;
 	unsigned int ci_off;
@@ -2239,11 +2357,10 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 	unsigned int batch_nr = 0, batch_nr_swapfile = 0;
 
 	lockdep_assert_held(&ci->lock);
-	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
 	batch_id = __swap_cgroup_get(ci, ci_start);
 
 	for (ci_off = ci_start; ci_off < ci_start + nr; ci_off++) {
-		vt = __vtable_get(ci_dyn, ci_off);
+		vt = __vtable_get(ci, ci_off);
 		cur_id = __swap_cgroup_get(ci, ci_off);
 
 		if (cur_id != batch_id) {
@@ -2290,7 +2407,7 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 			break;
 		}
 
-		__vtable_set(ci_dyn, ci_off, VSWAP_NONE);
+		__vtable_set(ci, ci_off, VSWAP_NONE);
 		/* Zero-backed state lives in swap_table; clear it too. */
 		if (__swap_table_test_zero(ci, ci_off))
 			__swap_table_clear_zero(ci, ci_off);
@@ -2348,14 +2465,12 @@ void folio_release_vswap_backing(struct folio *folio)
 void folio_release_non_phys_swap_backing(struct folio *folio)
 {
 	struct swap_cluster_info *ci;
-	struct swap_cluster_info_dynamic *ci_dyn;
 	int nr = folio_nr_pages(folio);
 	unsigned int voff;
 	unsigned long vt;
 	enum vswap_backing_type type;
 
 	ci = __swap_entry_to_cluster(folio->swap);
-	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
 	voff = swp_cluster_offset(folio->swap);
 
 	spin_lock(&ci->lock);
@@ -2363,7 +2478,7 @@ void folio_release_non_phys_swap_backing(struct folio *folio)
 	 * A folio's slots cannot mix swapfile with other backends, except
 	 * mid-backend-change, which always starts from slot 0.
 	 */
-	vt = __vtable_get(ci_dyn, voff);
+	vt = __vtable_get(ci, voff);
 	type = vtable_type(vt);
 
 	if (type == VSWAP_SWAPFILE || type == VSWAP_NONE) {
@@ -2393,7 +2508,6 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 {
 	swp_entry_t vswap_entry = folio->swap;
 	struct swap_cluster_info *ci;
-	struct swap_cluster_info_dynamic *ci_dyn;
 	struct mem_cgroup *memcg;
 	unsigned int voff;
 	unsigned long vt;
@@ -2408,10 +2522,9 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 
 	voff = swp_cluster_offset(vswap_entry);
 	ci = __swap_entry_to_cluster(vswap_entry);
-	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
 
 	spin_lock(&ci->lock);
-	vt = __vtable_get(ci_dyn, voff);
+	vt = __vtable_get(ci, voff);
 	if (vtable_type(vt) == VSWAP_SWAPFILE) {
 		spin_unlock(&ci->lock);
 		return vtable_to_phys(vt);
@@ -2444,7 +2557,7 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 	 */
 	for (i = 0; i < nr; i++) {
 		pe.val = phys_entry.val + i;
-		__vtable_set(ci_dyn, voff + i, vtable_mk_phys(pe));
+		__vtable_set(ci, voff + i, vtable_mk_phys(pe));
 	}
 	spin_unlock(&ci->lock);
 
@@ -2765,7 +2878,6 @@ static bool folio_maybe_swapped(struct folio *folio)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
-	/* Folio is locked and in swap cache, so ci->count > 0: cluster is alive. */
 	ci = __swap_entry_to_cluster(entry);
 	ci_off = swp_cluster_offset(entry);
 	ci_end = ci_off + folio_nr_pages(folio);
@@ -3881,25 +3993,22 @@ static void free_swap_cluster_info(struct swap_info_struct *si,
 				   struct swap_cluster_info *cluster_info,
 				   unsigned long maxpages)
 {
-	struct swap_cluster_info_dynamic *ci_dyn;
 	struct swap_cluster_info *ci;
-	unsigned long idx;
 	int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 
 	if (swap_is_vswap(si)) {
-		xa_for_each(&si->cluster_info_pool, idx, ci_dyn) {
-			ci = &ci_dyn->ci;
+		nr_clusters = si->nr_mapped_clusters;
+		for (i = 0; i < nr_clusters; i++) {
+			ci = &si->cluster_info[i];
 			spin_lock(&ci->lock);
 			if (cluster_table_is_alloced(ci)) {
 				swap_cluster_assert_empty(ci, 0,
 							  SWAPFILE_CLUSTER, true);
-				swap_cluster_free_table(ci);
+				swap_cluster_free_table(si, ci);
 			}
 			spin_unlock(&ci->lock);
-			vswap_cluster_free_vtable(ci);
-			kfree(ci_dyn);
 		}
-		xa_destroy(&si->cluster_info_pool);
+		vswap_free_cluster_array(si);
 		return;
 	}
 
@@ -3911,7 +4020,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si,
 		spin_lock(&ci->lock);
 		if (cluster_table_is_alloced(ci)) {
 			swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, true);
-			swap_cluster_free_table(ci);
+			swap_cluster_free_table(si, ci);
 		}
 		spin_unlock(&ci->lock);
 	}
@@ -4397,39 +4506,18 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info = NULL;
-	struct swap_cluster_info_dynamic *ci_dyn = NULL;
+	struct swap_cluster_info *ci;
 	int err = -ENOMEM;
 	unsigned long i;
 
-	/* A vswap device uses an xarray pool instead of a static array. */
+	/* A vswap device grows its cluster array on demand. */
 	if (swap_is_vswap(si)) {
 		nr_clusters = 0;
-		xa_init_flags(&si->cluster_info_pool, XA_FLAGS_ALLOC);
-
-		/*
-		 * Pre-allocate cluster 0 and mark slot 0 (header page)
-		 * as bad so the allocator never hands out page offset 0.
-		 */
-		ci_dyn = kzalloc_obj(*ci_dyn, GFP_KERNEL);
-		if (!ci_dyn)
-			goto err;
-		spin_lock_init(&ci_dyn->ci.lock);
-		INIT_LIST_HEAD(&ci_dyn->ci.list);
-
-		err = xa_insert(&si->cluster_info_pool, 0, ci_dyn, GFP_KERNEL);
-		if (err) {
-			kfree(ci_dyn);
-			goto err;
-		}
-
-		err = swap_cluster_setup_bad_slot(si, &ci_dyn->ci, 0, false);
+		err = vswap_reserve_cluster_array(si, maxpages);
 		if (err)
 			goto err;
-
-		err = vswap_cluster_alloc_vtable(ci_dyn, GFP_KERNEL);
-		if (err)
-			goto err;
-
+		/* Reservation owns the array; keep the tail store idempotent. */
+		cluster_info = si->cluster_info;
 		goto setup_cluster_info;
 	}
 
@@ -4487,7 +4575,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	}
 
 	for (i = 0; i < nr_clusters; i++) {
-		struct swap_cluster_info *ci = &cluster_info[i];
+		ci = &cluster_info[i];
 
 		if (ci->count) {
 			ci->flags = CLUSTER_FLAG_NONFULL;
@@ -4500,8 +4588,23 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 
 	/* Slot 0 is bad, so cluster 0 never empties. The rest of it is usable. */
 	if (swap_is_vswap(si)) {
-		ci_dyn->ci.flags = CLUSTER_FLAG_NONFULL;
-		list_add_tail(&ci_dyn->ci.list, &si->nonfull_clusters[0]);
+		err = vswap_grow_clusters(si);
+		if (err)
+			goto err;
+
+		ci = si->cluster_info;
+		spin_lock(&ci->lock);
+		move_cluster(si, ci, NULL, CLUSTER_FLAG_NONE);
+		spin_unlock(&ci->lock);
+
+		err = swap_cluster_setup_bad_slot(si, ci, 0, false);
+		if (err)
+			goto err;
+
+		spin_lock(&ci->lock);
+		move_cluster(si, ci, &si->nonfull_clusters[0],
+			     CLUSTER_FLAG_NONFULL);
+		spin_unlock(&ci->lock);
 	}
 
 	si->cluster_info = cluster_info;
diff --git a/mm/vswap.h b/mm/vswap.h
index b79866d5999c..f8235882f3f0 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -78,7 +78,7 @@ static inline void swap_rmap_clear_cache_only(struct swap_cluster_info *ci,
 /*
  * Virtual table entry encoding for vswap clusters.
  *
- * Each entry in ci_dyn->virtual_table stores the backing type and
+ * Each entry in ci->virtual_table stores the backing type and
  * pointer for a virtual swap slot. Tag in low 3 bits, payload in
  * upper 61 bits.
  *
@@ -109,7 +109,7 @@ static inline void swap_rmap_clear_cache_only(struct swap_cluster_info *ci,
  *
  * Locking: a slot's vtable entry (the vswap entry's backend) is only
  * stable while the caller owns and holds the lock on that entry's swap
- * cache folio. The cluster lock (ci_dyn->ci.lock) only makes an individual
+ * cache folio. The cluster lock (ci->lock) only makes an individual
  * vtable read atomic, and by itself does not give the caller the right to
  * change the backend. A backend read without the folio lock is
  * best-effort and must be re-validated under the folio lock before
@@ -156,18 +156,18 @@ static inline struct zswap_entry *vtable_to_zswap(unsigned long vt)
 
 /* Virtual table accessors */
 
-static inline unsigned long __vtable_get(struct swap_cluster_info_dynamic *ci_dyn,
+static inline unsigned long __vtable_get(struct swap_cluster_info *ci,
 					 unsigned int off)
 {
 	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
-	return atomic_long_read(&ci_dyn->virtual_table[off]);
+	return atomic_long_read(&ci->virtual_table[off]);
 }
 
-static inline void __vtable_set(struct swap_cluster_info_dynamic *ci_dyn,
+static inline void __vtable_set(struct swap_cluster_info *ci,
 				unsigned int off, unsigned long vt)
 {
 	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
-	atomic_long_set(&ci_dyn->virtual_table[off], vt);
+	atomic_long_set(&ci->virtual_table[off], vt);
 }
 
 /**
@@ -175,18 +175,13 @@ static inline void __vtable_set(struct swap_cluster_info_dynamic *ci_dyn,
  * @entry: the virtual swap entry
  * @voff: out param, receives @entry's slot offset within the cluster
  *
- * Return: the locked vswap cluster, or NULL if @entry has no live cluster.
+ * Return: the locked vswap cluster.
  */
-static inline struct swap_cluster_info_dynamic *
+static inline struct swap_cluster_info *
 vswap_lock_cluster(swp_entry_t entry, unsigned int *voff)
 {
-	struct swap_cluster_info *ci;
-
-	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
-	if (!ci)
-		return NULL;
 	*voff = swp_cluster_offset(entry);
-	return container_of(ci, struct swap_cluster_info_dynamic, ci);
+	return swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
 }
 
 /**
@@ -199,16 +194,13 @@ vswap_lock_cluster(swp_entry_t entry, unsigned int *voff)
  */
 static inline swp_entry_t vswap_to_phys(swp_entry_t entry)
 {
-	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *ci;
 	unsigned int voff;
 	unsigned long vt;
 
-	ci_dyn = vswap_lock_cluster(entry, &voff);
-	if (!ci_dyn)
-		return (swp_entry_t){};
-
-	vt = __vtable_get(ci_dyn, voff);
-	swap_cluster_unlock(&ci_dyn->ci);
+	ci = vswap_lock_cluster(entry, &voff);
+	vt = __vtable_get(ci, voff);
+	swap_cluster_unlock(ci);
 
 	if (vtable_type(vt) != VSWAP_SWAPFILE)
 		return (swp_entry_t){};
@@ -232,13 +224,13 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 static inline void vswap_zswap_store(swp_entry_t entry,
 				     struct zswap_entry *ze)
 {
-	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *ci;
 	unsigned int voff;
 
-	ci_dyn = vswap_lock_cluster(entry, &voff);
-	__vswap_release_backing(&ci_dyn->ci, voff, 1);
-	__vtable_set(ci_dyn, voff, (unsigned long)ze | VSWAP_ZSWAP);
-	swap_cluster_unlock(&ci_dyn->ci);
+	ci = vswap_lock_cluster(entry, &voff);
+	__vswap_release_backing(ci, voff, 1);
+	__vtable_set(ci, voff, (unsigned long)ze | VSWAP_ZSWAP);
+	swap_cluster_unlock(ci);
 }
 
 /**
@@ -250,15 +242,13 @@ static inline void vswap_zswap_store(swp_entry_t entry,
  */
 static inline struct zswap_entry *vswap_zswap_load(swp_entry_t entry)
 {
-	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *ci;
 	unsigned int voff;
 	unsigned long vt;
 
-	ci_dyn = vswap_lock_cluster(entry, &voff);
-	if (!ci_dyn)
-		return NULL;
-	vt = __vtable_get(ci_dyn, voff);
-	swap_cluster_unlock(&ci_dyn->ci);
+	ci = vswap_lock_cluster(entry, &voff);
+	vt = __vtable_get(ci, voff);
+	swap_cluster_unlock(ci);
 
 	if (vtable_type(vt) != VSWAP_ZSWAP)
 		return NULL;
@@ -270,7 +260,7 @@ swp_entry_t folio_realloc_swap(struct folio *folio);
 void folio_release_non_phys_swap_backing(struct folio *folio);
 
 /*
- * Walk nr vtable slots starting at voff in ci_dyn. Returns the prefix
+ * Walk nr vtable slots starting at voff in ci. Returns the prefix
  * length of slots sharing one effective backing type. For SWAPFILE,
  * the prefix is also restricted to contiguous offsets in the same
  * swapfile.
@@ -283,9 +273,9 @@ void folio_release_non_phys_swap_backing(struct folio *folio);
  *   vtable=ZSWAP                      -> VSWAP_ZSWAP
  *
  * *typep returns the effective type of slot 0. Caller holds
- * ci_dyn->ci.lock.
+ * ci->lock.
  */
-static inline int __vswap_check_backing(struct swap_cluster_info_dynamic *ci_dyn,
+static inline int __vswap_check_backing(struct swap_cluster_info *ci,
 					unsigned int voff, int nr,
 					enum vswap_backing_type *typep)
 {
@@ -295,13 +285,13 @@ static inline int __vswap_check_backing(struct swap_cluster_info_dynamic *ci_dyn
 	unsigned long vt, swap_tb;
 	int i;
 
-	lockdep_assert_held(&ci_dyn->ci.lock);
+	lockdep_assert_held(&ci->lock);
 
 	for (i = 0; i < nr; i++) {
-		vt = __vtable_get(ci_dyn, voff + i);
+		vt = __vtable_get(ci, voff + i);
 		if (vtable_type(vt) == VSWAP_NONE) {
-			swap_tb = __swap_table_get(&ci_dyn->ci, voff + i);
-			if (__swap_table_test_zero(&ci_dyn->ci, voff + i))
+			swap_tb = __swap_table_get(ci, voff + i);
+			if (__swap_table_test_zero(ci, voff + i))
 				slot_type = VSWAP_ZERO;
 			else if (swp_tb_is_folio(swap_tb))
 				slot_type = VSWAP_FOLIO;
@@ -331,18 +321,13 @@ static inline int __vswap_check_backing(struct swap_cluster_info_dynamic *ci_dyn
 static inline int vswap_check_backing(swp_entry_t entry, int nr,
 				      enum vswap_backing_type *typep)
 {
-	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *ci;
 	unsigned int voff;
 	int ret;
 
-	ci_dyn = vswap_lock_cluster(entry, &voff);
-	if (!ci_dyn) {
-		if (typep)
-			*typep = VSWAP_NONE;
-		return 0;
-	}
-	ret = __vswap_check_backing(ci_dyn, voff, nr, typep);
-	swap_cluster_unlock(&ci_dyn->ci);
+	ci = vswap_lock_cluster(entry, &voff);
+	ret = __vswap_check_backing(ci, voff, nr, typep);
+	swap_cluster_unlock(ci);
 	return ret;
 }
 
@@ -365,21 +350,18 @@ static inline bool folio_phys_swap_backed(struct folio *folio)
 		type == VSWAP_SWAPFILE);
 }
 
-static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info_dynamic *ci_dyn,
+static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info *ci,
 					     gfp_t gfp)
 {
-	ci_dyn->virtual_table = kcalloc(SWAPFILE_CLUSTER,
-					sizeof(*ci_dyn->virtual_table), gfp);
-	return ci_dyn->virtual_table ? 0 : -ENOMEM;
+	ci->virtual_table = kcalloc(SWAPFILE_CLUSTER,
+				    sizeof(*ci->virtual_table), gfp);
+	return ci->virtual_table ? 0 : -ENOMEM;
 }
 
 static inline void vswap_cluster_free_vtable(struct swap_cluster_info *ci)
 {
-	struct swap_cluster_info_dynamic *ci_dyn;
-
-	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
-	kfree(ci_dyn->virtual_table);
-	ci_dyn->virtual_table = NULL;
+	kfree(ci->virtual_table);
+	ci->virtual_table = NULL;
 }
 
 #else /* !CONFIG_SWAP */
-- 
2.53.0-Meta

