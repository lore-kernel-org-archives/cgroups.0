Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAD5489875
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 15:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671973; cv=none; b=Nksk1nPHc8ozWhdYkAeoCBsext1nN2UKkhcKD34HOZE7qljOqwb4fnTH50doJ41w2jixCTMeryh9j2R5AiTmel3QWGH3Cic5OVrEaUpwyHs8Hcx6rZ8DHZFm22OkLn0GEGF2P0YKN7qR4R7afXuI20JTu3G4M8+Rznfgs343tTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671973; c=relaxed/simple;
	bh=a6xHskWFZwEmiH7h36JGISBtn5MXdYRqgyS+ZK0oruw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AB3BpBxmQPls2ZGJ0KZKH/850e1dvf6CgjGpmEnPe8ZD2WFRHfiE2ccJcscsy3CuNVH7fHNUnY3sAC0wu0aMlkPSQLJNUdq8mnHrkvy0gJdZTxeGEeANUSMKIZ6+rrIGmMRZp5VFN4vC6jdMSbLUrDxnniR5n4zUEr8H7dRl0zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cThW4RsJ; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cThW4RsJ"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-448b0ff4a57so6741336fac.2
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 08:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671964; x=1788276764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M4r8emXyXW5noklgLMUJWgd3OAUbwbCYwVs/Zcel7s4=;
        b=cThW4RsJEyvcHw/TShwR2eG4oAxQ+G+7/tzH4knCgRVyDmf9ifcmmIG3x4RS0132cp
         2R5tiZd3VxXrI2woPCY+7rxQGY+a9os71YhY3FCq07Vq+yqMiQ5R58vxG1V+YjA00KNc
         97myoWLd+LmlMvVrkK2W28oVxIsCDWE9GUMkdYjhY81QHmjYoIWid+uNJJx6kPCCptcy
         WQadqJ/6wGE0DhmKxG8iWL3NynJxJ8IvMevKLYwOfHs7W4V2RbuBNyP5/iWu/0wXgpJ7
         DHk4jg3rikLMjgUCgfToVSTd/0hlnU4uXbHmS9GA0GX7sh0Zqv3NkMJ5De83S9oT9ZUo
         s30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671964; x=1788276764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M4r8emXyXW5noklgLMUJWgd3OAUbwbCYwVs/Zcel7s4=;
        b=KVEvTWGU/WU26o2lpgCMoZUAnUB5Nsp0oCvKmR7tteV9QxCG7kjAnm5V+DsrdgH05C
         YQ0JIStQCG98R9FusYJ8NXpffQa4IRCYcMMlUpTwH1F/FglWdII9ZdSyJM5Q6VGNG4ng
         l6kL5rnynX1VlndmX+AoZ/YPiFPvXeGuo3zYBvXDBeltOx3PflWA2QfJy7XxL3PvwLEF
         vS234693n7MOdEjLwBOAZ9gHB2Sc/5CpCwzaV972+lZFgelEZQsn4XRS7tI8gOj0No4O
         bm+EP78bFQOG2tTFsICXHqzuyij9mehbXif0WnCvcHXT3TxpcEVyH+WPzZXVdsU4jWMn
         m6UQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp6C3s4eqpdFBMsJ5FgMB6VtlcGlDfzsPyG2S5GbdFxearjadOemSA+SiLicuPEsxKx2Ts6d4U4@vger.kernel.org
X-Gm-Message-State: AFuF++kjXhEsoqnJ0PemkXk71JUXNS/VoAYsMY3OfTdTOLBvXsePZRxS
	V7cbgCl5aZYG4/TEPbJP59sJbck0m5MCHtmHTuJMSG8CP6HqaAAK9IbO
X-Gm-Gg: AR+sD10UpEwMPWggPpJ/NaEORRsIji1AVklm6VXDOuuoDzMrGrgQFim40yMEFP0OaVC
	h0erQnq1Y8kWeacgpVa0HciahOLbabmj/uP52sTRkGijC0lrSlZ3P3f7nMtVHb16rUh9GnJ+AiV
	fmmGbyrlP6SwTnNKl3p185XCTTsWowUjgFWD1Lt6lIhchxLHD3f/vL+mnNZe6FQN8UbCTQIL5vM
	tVx3J/JW5Vc5jyYqNUKPArMdZxl2UnWJZKmjjq28BbsPEKevI9BG7Ffw8QbZGjLwWvvlow7Vd+c
	aYSJh7ne5xSDqxz/0BmdMeFC72sjDamgsrlkXUVWFUVpK2QNAofJuB7hsbQqRGd7O3y05c+yq+/
	kKqGuySr6/KKaEXZ1c9qgmbLTUFiiWpehNFzW+87wu9nhU/GJJvW5g6ZGCuKsCNiVH6EqTd6kP8
	TsgzaD1crDEVD0aYTR3dwg3EJwZCC3VQA8ul7Q5DPuVVZT5W3y46dD3REhYWE42MFzTjmmsFT8J
	XVlAvO0LjQ=
X-Received: by 2002:a05:6871:809:b0:44a:f310:407c with SMTP id 586e51a60fabf-4644a96fc52mr7150416fac.15.1787671963827;
        Tue, 25 Aug 2026 08:32:43 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:55::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-46383539b74sm7349640fac.14.2026.08.25.08.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:43 -0700 (PDT)
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
Subject: [PATCH v4 02/11] mm, swap: support zswap and zero-filled swap pages as vswap backends
Date: Tue, 25 Aug 2026 08:32:28 -0700
Message-ID: <20260825153238.2695446-3-nphamcs@gmail.com>
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

Build the virtual swap layer on top of the swap-table infrastructure.
Virtual swap entries decouple PTE swap entries from physical backing,
allowing pages to be compressed by zswap (or detected as zero-filled)
without pre-allocating a physical swap slot.

This patch only supports zswap and zero-page backends. If zswap_store
fails, the page stays dirty in the swap cache. Physical disk backing
arrives in later patches.

Zswap writeback of vswap-backed entries is also disabled: they have no
physical slot to write back to yet, so the zswap shrinker (both the
dynamic count path and the pool-full worker path) is skipped while
vswap is enabled. Physical backing and real writeback come in later
patches.

THP swapin is disabled for vswap entries for now.

vswap_alloc() only routes a swapout through vswap when vswap is
enabled, either by CONFIG_VSWAP_DEFAULT_ON or by "vswap=on" on the
kernel command line. It also declines the folio when zswap is off, or
when the folio's cgroup is already over its zswap limit. In both cases
writeout would have to find a physical slot anyway, so the indirection
would buy nothing.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/zswap.h |   3 +
 mm/memcontrol.c       |   8 ++
 mm/memory.c           |  11 ++-
 mm/page_io.c          |  12 ++-
 mm/shmem.c            |   4 +-
 mm/swap.h             |   1 +
 mm/swap_state.c       |   8 ++
 mm/swapfile.c         | 178 ++++++++++++++++++++++++++++++++++++++--
 mm/vmscan.c           |   9 +-
 mm/vswap.h            | 185 ++++++++++++++++++++++++++++++++++++++++++
 mm/zswap.c            |  65 ++++++++++++---
 11 files changed, 458 insertions(+), 26 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..4b4f211f3301 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -6,6 +6,7 @@
 #include <linux/mm_types.h>
 
 struct lruvec;
+struct zswap_entry;
 
 extern atomic_long_t zswap_stored_pages;
 
@@ -28,6 +29,7 @@ unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
 int zswap_load(struct folio *folio);
 void zswap_invalidate(swp_entry_t swp);
+void zswap_entry_free(struct zswap_entry *entry);
 int zswap_swapon(int type, unsigned long nr_pages);
 void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
@@ -50,6 +52,7 @@ static inline int zswap_load(struct folio *folio)
 }
 
 static inline void zswap_invalidate(swp_entry_t swp) {}
+static inline void zswap_entry_free(struct zswap_entry *entry) {}
 static inline int zswap_swapon(int type, unsigned long nr_pages)
 {
 	return 0;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 11b85f4b6828..8508fc7e2dfd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -65,6 +65,7 @@
 #include "internal.h"
 #include "swap.h"
 #include "swap_table.h"
+#include "vswap.h"
 #include <net/sock.h>
 #include <net/ip.h>
 #include "slab.h"
@@ -5801,6 +5802,13 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
+	/*
+	 * vswap zswap-backed swapout needs no physical slot, so gate anon
+	 * reclaim on the swap.max headroom instead of the physical free count.
+	 */
+	if (vswap_is_enabled() && zswap_is_enabled())
+		nr_swap_pages = PAGE_COUNTER_MAX;
+
 	if (mem_cgroup_disabled() || do_memsw_account())
 		return nr_swap_pages;
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
diff --git a/mm/memory.c b/mm/memory.c
index c54943302553..181a90fa2211 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -89,6 +89,7 @@
 #include "pgalloc-track.h"
 #include "internal.h"
 #include "swap.h"
+#include "vswap.h"
 
 #if defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS) && !defined(CONFIG_COMPILE_TEST)
 #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
@@ -4661,6 +4662,9 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 	 */
 	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
 		return true;
+	/* A vswap entry holds no physical slot, so keeping it saves no IO. */
+	if (is_vswap_entry(folio->swap))
+		return true;
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
 		return true;
@@ -4809,15 +4813,18 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	if (unlikely(userfaultfd_armed(vma)))
 		return 0;
 
+	entry = softleaf_from_pte(vmf->orig_pte);
+
 	/*
 	 * A large swapped out folio could be partially or fully in zswap. We
 	 * lack handling for such cases, so fallback to swapping in order-0
 	 * folio.
+	 *
+	 * THP swapin for vswap is not supported yet either.
 	 */
-	if (!zswap_never_enabled())
+	if (is_vswap_entry(entry) || !zswap_never_enabled())
 		return 0;
 
-	entry = softleaf_from_pte(vmf->orig_pte);
 	/*
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
diff --git a/mm/page_io.c b/mm/page_io.c
index 3d0e78c17090..3bc69c2dbe4d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -161,14 +161,19 @@ static void swap_zeromap_folio_set(struct folio *folio)
 	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
 	int nr_pages = folio_nr_pages(folio);
 	struct swap_cluster_info *ci;
+	unsigned int voff, i;
 	swp_entry_t entry;
-	unsigned int i;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 
 	ci = swap_cluster_get_and_lock(folio);
-	for (i = 0; i < folio_nr_pages(folio); i++) {
+	if (is_vswap_entry(folio->swap)) {
+		/* Free any prior backing (e.g. ZSWAP entry from earlier swapout) */
+		voff = swp_cluster_offset(folio->swap);
+		__vswap_release_backing(ci, voff, nr_pages);
+	}
+	for (i = 0; i < nr_pages; i++) {
 		entry = page_swap_entry(folio_page(folio, i));
 		__swap_table_set_zero(ci, swp_cluster_offset(entry));
 	}
@@ -236,6 +241,9 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	 */
 	swap_zeromap_folio_clear(folio);
 
+	if (is_vswap_entry(folio->swap))
+		folio_release_vswap_backing(folio);
+
 	if (zswap_store(folio)) {
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		goto out_unlock;
diff --git a/mm/shmem.c b/mm/shmem.c
index 599665a3d6e7..d58f30b06255 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -86,6 +86,7 @@ static struct vfsmount *shm_mnt __ro_after_init;
 #include <linux/uaccess.h>
 
 #include "internal.h"
+#include "vswap.h"
 
 #define VM_ACCT(size)    (PAGE_ALIGN(size) >> PAGE_SHIFT)
 
@@ -1618,7 +1619,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
 		goto redirty;
 
-	if (!total_swap_pages)
+	/* vswap doesn't contribute to total_swap_pages */
+	if (!total_swap_pages && !(vswap_is_enabled() && zswap_is_enabled()))
 		goto redirty;
 
 	/*
diff --git a/mm/swap.h b/mm/swap.h
index f18385dc9c6e..1cc9f3f5105e 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -71,6 +71,7 @@ struct swap_cluster_info_dynamic {
 	struct swap_cluster_info ci;
 	unsigned int index;		/* for cluster_index() */
 	struct rcu_head rcu;
+	atomic_long_t *virtual_table;	/* Backing pointers for vswap slots */
 };
 
 /* All on-list cluster must have a non-zero flag. */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index a800abebba38..0385cc50ff93 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -27,6 +27,7 @@
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
+#include "vswap.h"
 
 /* Swap readahead cluster size, as a power of 2 pages. */
 static int page_cluster;
@@ -197,6 +198,13 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	if (nr == 1)
 		return 0;
 
+	/*
+	 * Reject a vswap batch so swap_cache_alloc_folio falls back to
+	 * order 0.
+	 */
+	if (is_vswap_entry(targ_entry))
+		return -EBUSY;
+
 	is_zero = __swap_table_test_zero(ci, ci_off);
 	ci_off = round_down(ci_off, nr);
 	ci_end = ci_off + nr;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ae88b91c92a2..e0b603a247c0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -131,6 +131,18 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+struct percpu_vswap_cluster {
+	unsigned long offset[SWAP_NR_ORDERS];
+	local_lock_t lock;
+};
+
+static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
+	.offset = { [0 ... SWAP_NR_ORDERS - 1] = SWAP_ENTRY_INVALID },
+	.lock = INIT_LOCAL_LOCK(),
+};
+
+static bool vswap_alloc(struct folio *folio);
+
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
 {
@@ -236,7 +248,8 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
-			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio)));
+			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio) &&
+			 !is_vswap_entry(folio->swap)));
 	if (!need_reclaim || !folio_swapcache_freeable(folio))
 		goto out_unlock;
 
@@ -536,7 +549,9 @@ swap_cluster_populate(struct swap_info_struct *si,
 	/*
 	 * Only cluster isolation from the allocator does table allocation.
 	 * Swap allocator uses percpu clusters and holds the local lock.
+	 * vswap clusters are destroyed rather than freed to si->free_clusters.
 	 */
+	VM_WARN_ON_ONCE(swap_is_vswap(si));
 	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		lockdep_assert_held(&si->global_cluster_lock);
@@ -624,6 +639,7 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 		ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
 		xa_erase(&si->cluster_info_pool, ci_dyn->index);
 		move_cluster(si, ci, NULL, CLUSTER_FLAG_DEAD);
+		vswap_cluster_free_vtable(ci);
 		kfree_rcu(ci_dyn, rcu);
 		return;
 	}
@@ -918,7 +934,8 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 		if (swp_tb_is_null(swp_tb))
 			continue;
 		if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(swp_tb)) {
-			if (!vm_swap_full())
+			/* vswap slots are abundant; never reclaim to reuse one */
+			if (swap_is_vswap(si) || !vm_swap_full())
 				return false;
 			*need_reclaim = true;
 			continue;
@@ -1026,6 +1043,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 out:
 	relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
+	if (swap_is_vswap(si)) {
+		this_cpu_write(percpu_vswap_cluster.offset[order], next);
+		return found;
+	}
 	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(percpu_swap_cluster.offset[order], next);
 		this_cpu_write(percpu_swap_cluster.si[order], si);
@@ -1078,6 +1099,12 @@ static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
 		return SWAP_ENTRY_INVALID;
 	}
 
+	if (vswap_cluster_alloc_vtable(ci_dyn, GFP_ATOMIC)) {
+		swap_cluster_free_table(&ci_dyn->ci);
+		kfree(ci_dyn);
+		return SWAP_ENTRY_INVALID;
+	}
+
 	/* Lock before publishing: xa_alloc makes the cluster findable by offset. */
 	ci = &ci_dyn->ci;
 	spin_lock(&ci->lock);
@@ -1087,6 +1114,7 @@ static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
 		     GFP_ATOMIC)) {
 		spin_unlock(&ci->lock);
 		swap_cluster_free_table(&ci_dyn->ci);
+		vswap_cluster_free_vtable(&ci_dyn->ci);
 		kfree(ci_dyn);
 		return SWAP_ENTRY_INVALID;
 	}
@@ -1170,7 +1198,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	 * Swapfile is not block device so unable
 	 * to allocate large entries.
 	 */
-	if (order && !(si->flags & SWP_BLKDEV))
+	if (order && !(si->flags & SWP_BLKDEV) && !swap_is_vswap(si))
 		return 0;
 
 	if (!(si->flags & SWP_SOLIDSTATE)) {
@@ -1223,7 +1251,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	}
 
 	/* Try reclaim full clusters if free and nonfull lists are drained */
-	if (vm_swap_full())
+	if (!swap_is_vswap(si) && vm_swap_full())
 		swap_reclaim_full_clusters(si, false);
 
 	if (order < PMD_ORDER) {
@@ -1384,7 +1412,8 @@ static void swap_range_alloc(struct swap_info_struct *si,
 		if (vm_swap_full())
 			schedule_work(&si->reclaim_work);
 	}
-	atomic_long_sub(nr_entries, &nr_swap_pages);
+	if (!swap_is_vswap(si))
+		atomic_long_sub(nr_entries, &nr_swap_pages);
 }
 
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
@@ -1394,8 +1423,10 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
 	unsigned int i;
 
-	for (i = 0; i < nr_entries; i++)
-		zswap_invalidate(swp_entry(si->type, offset + i));
+	if (!swap_is_vswap(si)) {
+		for (i = 0; i < nr_entries; i++)
+			zswap_invalidate(swp_entry(si->type, offset + i));
+	}
 
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
@@ -1414,7 +1445,8 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	 * only after the above cleanups are done.
 	 */
 	smp_wmb();
-	atomic_long_add(nr_entries, &nr_swap_pages);
+	if (!swap_is_vswap(si))
+		atomic_long_add(nr_entries, &nr_swap_pages);
 	swap_usage_sub(si, nr_entries);
 }
 
@@ -1806,6 +1838,57 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 	return err;
 }
 
+static bool vswap_alloc(struct folio *folio)
+{
+	unsigned int order = folio_order(folio);
+	struct swap_cluster_info *ci;
+	struct obj_cgroup *objcg;
+	unsigned long offset;
+	bool may_zswap;
+
+	if (!vswap_is_enabled() || !zswap_is_enabled())
+		return false;
+
+	/*
+	 * If zswap will not take the folio, writeout has to find a physical
+	 * slot anyway. We are just incurring indirection overhead
+	 * unnecessarily.
+	 */
+	objcg = get_obj_cgroup_from_folio(folio);
+	may_zswap = !objcg || obj_cgroup_may_zswap(objcg);
+	if (objcg)
+		obj_cgroup_put(objcg);
+	if (!may_zswap)
+		return false;
+
+	local_lock(&percpu_vswap_cluster.lock);
+	offset = this_cpu_read(percpu_vswap_cluster.offset[order]);
+
+	if (offset != SWAP_ENTRY_INVALID) {
+		ci = swap_cluster_lock(vswap_si, offset);
+		if (ci && cluster_is_usable(ci, order)) {
+			if (cluster_is_empty(ci))
+				offset = cluster_offset(vswap_si, ci);
+			alloc_swap_scan_cluster(vswap_si, ci, folio, offset);
+		} else if (ci) {
+			swap_cluster_unlock(ci);
+		}
+	}
+
+	if (!folio_test_swapcache(folio))
+		cluster_alloc_swap_entry(vswap_si, folio);
+
+	if (folio_test_swapcache(folio)) {
+		/* alloc_swap_scan_cluster updated percpu offset already */
+		local_unlock(&percpu_vswap_cluster.lock);
+		return true;
+	}
+
+	this_cpu_write(percpu_vswap_cluster.offset[order], SWAP_ENTRY_INVALID);
+	local_unlock(&percpu_vswap_cluster.lock);
+	return false;
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1842,12 +1925,16 @@ int folio_alloc_swap(struct folio *folio)
 		}
 	}
 
+	if (vswap_alloc(folio))
+		goto done;
+
 again:
 	local_lock(&percpu_swap_cluster.lock);
 	if (!swap_alloc_fast(folio))
 		swap_alloc_slow(folio);
 	local_unlock(&percpu_swap_cluster.lock);
 
+done:
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
 			goto again;
@@ -1863,6 +1950,73 @@ int folio_alloc_swap(struct folio *folio)
 	return 0;
 }
 
+/**
+ * __vswap_release_backing - release the backing of a range of vtable slots
+ * @ci: the locked vswap cluster
+ * @ci_start: first slot offset within @ci
+ * @nr: number of slots
+ *
+ * Releases the backing of each slot in [@ci_start, @ci_start + @nr).
+ * Clears the zero marks if set.
+ *
+ * Context: caller must hold @ci->lock.
+ */
+void __vswap_release_backing(struct swap_cluster_info *ci,
+			     unsigned int ci_start, unsigned int nr)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	unsigned int ci_off;
+	unsigned long vt;
+
+	lockdep_assert_held(&ci->lock);
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+
+	for (ci_off = ci_start; ci_off < ci_start + nr; ci_off++) {
+		vt = __vtable_get(ci_dyn, ci_off);
+
+		switch (vtable_type(vt)) {
+		case VSWAP_ZSWAP:
+			zswap_entry_free(vtable_to_zswap(vt));
+			break;
+		case VSWAP_NONE:
+			break;
+		default:
+			/* VSWAP_ZERO/VSWAP_FOLIO are return-only, not vtable tags */
+			break;
+		}
+
+		__vtable_set(ci_dyn, ci_off, VSWAP_NONE);
+		/* Zero-backed state lives in swap_table; clear it too. */
+		if (__swap_table_test_zero(ci, ci_off))
+			__swap_table_clear_zero(ci, ci_off);
+	}
+}
+
+/**
+ * folio_release_vswap_backing() - Drop all backing for a folio's vswap entry.
+ * @folio: the folio, occupying a virtual swap entry.
+ *
+ * Release whatever backing the folio's virtual swap slots currently hold and
+ * reset them to empty, so a fresh backing can be installed. Used when a
+ * folio's swap backend is replaced.
+ *
+ * Context: Caller must hold the folio lock; @folio must be in the swap cache
+ * and occupy a virtual swap entry.
+ */
+void folio_release_vswap_backing(struct folio *folio)
+{
+	struct swap_cluster_info *ci;
+	int nr = folio_nr_pages(folio);
+	unsigned int voff;
+
+	ci = __swap_entry_to_cluster(folio->swap);
+	voff = swp_cluster_offset(folio->swap);
+
+	spin_lock(&ci->lock);
+	__vswap_release_backing(ci, voff, nr);
+	spin_unlock(&ci->lock);
+}
+
 /**
  * folio_dup_swap() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
@@ -2003,6 +2157,9 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 
 	VM_WARN_ON(ci->count < nr_pages);
 
+	if (swap_is_vswap(si))
+		__vswap_release_backing(ci, ci_start, nr_pages);
+
 	ci->count -= nr_pages;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
@@ -3159,6 +3316,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si,
 				swap_cluster_free_table(ci);
 			}
 			spin_unlock(&ci->lock);
+			vswap_cluster_free_vtable(ci);
 			kfree(ci_dyn);
 		}
 		xa_destroy(&si->cluster_info_pool);
@@ -3688,6 +3846,10 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		if (err)
 			goto err;
 
+		err = vswap_cluster_alloc_vtable(ci_dyn, GFP_KERNEL);
+		if (err)
+			goto err;
+
 		goto setup_cluster_info;
 	}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c1404a59523d..5cc40db37f6b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -69,6 +69,7 @@
 #include "internal.h"
 #include "page_alloc.h"
 #include "swap.h"
+#include "vswap.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
@@ -353,6 +354,9 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 		 */
 		if (get_nr_swap_pages() > 0)
 			return true;
+		/* vswap doesn't contribute to nr_swap_pages */
+		if (vswap_is_enabled() && zswap_is_enabled())
+			return true;
 	} else {
 		/* Is the memcg below its swap limit? */
 		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
@@ -1524,7 +1528,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (folio_test_swapcache(folio) &&
-		    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
+		    ((mem_cgroup_swap_full(folio) && !is_vswap_entry(folio->swap)) ||
+		     folio_test_mlocked(folio)))
 			folio_free_swap(folio);
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
 		if (!folio_test_mlocked(folio)) {
@@ -2681,7 +2686,7 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
 			       struct scan_control *sc)
 {
 	/* Aging the anon LRU is valuable if swap is present: */
-	if (total_swap_pages > 0)
+	if (total_swap_pages > 0 || (vswap_is_enabled() && zswap_is_enabled()))
 		return true;
 
 	/* Also valuable if anon pages can be demoted: */
diff --git a/mm/vswap.h b/mm/vswap.h
index 16395f357955..5334c77b6b84 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -11,8 +11,22 @@
 #include <linux/swap.h>
 #include "swap.h"
 
+struct zswap_entry;
+
+/*
+ * VSWAP_ZERO and VSWAP_FOLIO are return-only values synthesized from
+ * swap_table state; the rest are stored in the vtable per slot.
+ */
+enum vswap_backing_type {
+	VSWAP_NONE	= 0,
+	VSWAP_ZSWAP	= 1,
+	VSWAP_ZERO,
+	VSWAP_FOLIO,
+};
+
 #ifdef CONFIG_SWAP
 
+#include "swap_table.h"
 DECLARE_STATIC_KEY_FALSE(vswap_key);
 
 /*
@@ -29,6 +43,177 @@ static inline bool is_vswap_entry(swp_entry_t entry)
 	return swap_is_vswap(__swap_entry_to_info(entry));
 }
 
+/*
+ * Virtual table entry encoding for vswap clusters.
+ *
+ * Each entry in ci_dyn->virtual_table stores the backing type and
+ * pointer for a virtual swap slot. Tag in low 3 bits, payload in
+ * upper 61 bits.
+ *
+ *   NONE:   |----- 0000 ------|000|  - no separate backend pointer
+ *   ZSWAP:  |--- zswap_entry* |001|  - compressed in zswap (tag in low bits)
+ *
+ * Pointer payloads (ZSWAP) are stored directly with the tag OR'd into the
+ * low bits (kernel pointers are >= 8-byte aligned, same approach as xarray).
+ *
+ * vtable[i] = NONE does not by itself mean "free". The swap_table entry
+ * and the per-slot zero flag carry the rest of the state. The full
+ * per-slot state table is:
+ *
+ *   vtable[i] | swap_table[i] | zero  | meaning
+ *   ----------+---------------+-------+--------------------------------
+ *   NONE      | NULL          | clear | truly free / unbacked
+ *   NONE      | PFN           | clear | folio cached, no backing
+ *   NONE      | shadow        | clear | evicted, no backing: data lost
+ *   NONE      | *             | set   | zero-backed; cached if PFN set
+ *   ZSWAP     | PFN           | clear | folio cached + zswap entry
+ *   ZSWAP     | shadow / NULL | clear | evicted, only in zswap
+ *
+ * Locking: a slot's vtable entry (the vswap entry's backend) is only
+ * stable while the caller owns and holds the lock on that entry's swap
+ * cache folio. The cluster lock (ci_dyn->ci.lock) only makes an individual
+ * vtable read atomic, and by itself does not give the caller the right to
+ * change the backend. A backend read without the folio lock is
+ * best-effort and must be re-validated under the folio lock before
+ * being acted on.
+ *
+ * Zero-backed slots use the swap_table per-slot zero flag (same as
+ * direct-mapped physical swap), via __swap_table_test_zero() and friends,
+ * which fall back to ci->zero_bitmap where the flag does not fit. Cached
+ * folios are read out of the swap_table PFN entry; there is no separate FOLIO
+ * vtable type because the folio pointer would duplicate that PFN and
+ * would go stale on folio migration / split.
+ */
+
+#define VTABLE_TAG_BITS		3
+#define VTABLE_TAG_MASK		((1UL << VTABLE_TAG_BITS) - 1)
+
+static inline enum vswap_backing_type vtable_type(unsigned long vt)
+{
+	return vt & VTABLE_TAG_MASK;
+}
+
+static inline struct zswap_entry *vtable_to_zswap(unsigned long vt)
+{
+	VM_WARN_ON(vtable_type(vt) != VSWAP_ZSWAP);
+	return (struct zswap_entry *)(vt & ~VTABLE_TAG_MASK);
+}
+
+/* Virtual table accessors */
+
+static inline unsigned long __vtable_get(struct swap_cluster_info_dynamic *ci_dyn,
+					 unsigned int off)
+{
+	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
+	return atomic_long_read(&ci_dyn->virtual_table[off]);
+}
+
+static inline void __vtable_set(struct swap_cluster_info_dynamic *ci_dyn,
+				unsigned int off, unsigned long vt)
+{
+	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
+	atomic_long_set(&ci_dyn->virtual_table[off], vt);
+}
+
+/**
+ * vswap_lock_cluster - look up and lock the vswap cluster for an entry
+ * @entry: the virtual swap entry
+ * @voff: out param, receives @entry's slot offset within the cluster
+ *
+ * Return: the locked vswap cluster, or NULL if @entry has no live cluster.
+ */
+static inline struct swap_cluster_info_dynamic *
+vswap_lock_cluster(swp_entry_t entry, unsigned int *voff)
+{
+	struct swap_cluster_info *ci;
+
+	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
+	if (!ci)
+		return NULL;
+	*voff = swp_cluster_offset(entry);
+	return container_of(ci, struct swap_cluster_info_dynamic, ci);
+}
+
+void __vswap_release_backing(struct swap_cluster_info *ci,
+			     unsigned int ci_start, unsigned int nr);
+
+/**
+ * vswap_zswap_store - record a zswap entry as the backing for a vswap entry.
+ * @entry: the vswap entry
+ * @ze: the zswap entry now holding @entry's compressed data
+ *
+ * Releases @entry's previous backing, and sets the zswap entry @ze as the new
+ * backing.
+ *
+ * Context: takes and drops the vswap cluster lock internally.
+ */
+static inline void vswap_zswap_store(swp_entry_t entry,
+				     struct zswap_entry *ze)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	unsigned int voff;
+
+	ci_dyn = vswap_lock_cluster(entry, &voff);
+	__vswap_release_backing(&ci_dyn->ci, voff, 1);
+	__vtable_set(ci_dyn, voff, (unsigned long)ze | VSWAP_ZSWAP);
+	swap_cluster_unlock(&ci_dyn->ci);
+}
+
+/**
+ * vswap_zswap_load - return the zswap entry backing a vswap entry
+ * @entry: the virtual swap entry
+ *
+ * Context: takes and drops the vswap cluster lock internally.
+ * Return: the backing zswap entry, or NULL if @entry is not zswap-backed.
+ */
+static inline struct zswap_entry *vswap_zswap_load(swp_entry_t entry)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	unsigned int voff;
+	unsigned long vt;
+
+	ci_dyn = vswap_lock_cluster(entry, &voff);
+	if (!ci_dyn)
+		return NULL;
+	vt = __vtable_get(ci_dyn, voff);
+	swap_cluster_unlock(&ci_dyn->ci);
+
+	if (vtable_type(vt) != VSWAP_ZSWAP)
+		return NULL;
+	return vtable_to_zswap(vt);
+}
+
+void folio_release_vswap_backing(struct folio *folio);
+
+static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info_dynamic *ci_dyn,
+					     gfp_t gfp)
+{
+	ci_dyn->virtual_table = kcalloc(SWAPFILE_CLUSTER,
+					sizeof(*ci_dyn->virtual_table), gfp);
+	return ci_dyn->virtual_table ? 0 : -ENOMEM;
+}
+
+static inline void vswap_cluster_free_vtable(struct swap_cluster_info *ci)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	kfree(ci_dyn->virtual_table);
+	ci_dyn->virtual_table = NULL;
+}
+
+#else /* !CONFIG_SWAP */
+
+static inline bool vswap_is_enabled(void)
+{
+	return false;
+}
+
+static inline bool is_vswap_entry(swp_entry_t entry)
+{
+	return false;
+}
+
 #endif /* CONFIG_SWAP */
 
 #endif /* _MM_VSWAP_H */
diff --git a/mm/zswap.c b/mm/zswap.c
index 11643c52ea21..e5a9922b951a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -38,6 +38,7 @@
 #include <linux/zsmalloc.h>
 
 #include "swap.h"
+#include "vswap.h"
 #include "internal.h"
 
 /*********************************
@@ -234,6 +235,25 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 		>> ZSWAP_ADDRESS_SPACE_SHIFT];
 }
 
+static struct zswap_entry *zswap_entry_load(swp_entry_t swp)
+{
+	if (is_vswap_entry(swp))
+		return vswap_zswap_load(swp);
+	return xa_load(swap_zswap_tree(swp), swp_offset(swp));
+}
+
+static struct zswap_entry *zswap_entry_store(swp_entry_t swp,
+					     struct zswap_entry *entry)
+{
+	if (is_vswap_entry(swp)) {
+		vswap_zswap_store(swp, entry);
+		return NULL;
+	}
+
+	return xa_store(swap_zswap_tree(swp), swp_offset(swp), entry,
+			GFP_KERNEL);
+}
+
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
@@ -762,7 +782,7 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
  * Carries out the common pattern of freeing an entry's zsmalloc allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
-static void zswap_entry_free(struct zswap_entry *entry)
+void zswap_entry_free(struct zswap_entry *entry)
 {
 	zswap_lru_del(entry);
 	zs_free(entry->pool->zs_pool, entry->handle);
@@ -1208,6 +1228,9 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
+	if (vswap_is_enabled())
+		return 0;
+
 	/*
 	 * The shrinker resumes swap writeback, which will enter block
 	 * and may enter fs. XXX: Harmonize with vmscan.c __GFP_FS
@@ -1290,6 +1313,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
  * Return: 0 if at least one entry was written back, -EAGAIN if entries
  * were scanned but none could be written back, or -ENOENT if @memcg has
  * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
+ *
+ * Also returns -ENOENT when vswap is enabled.
  */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
@@ -1298,6 +1323,9 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
+	if (vswap_is_enabled())
+		return -ENOENT;
+
 	/*
 	 * Skip zombies because their LRUs are reparented and we would be
 	 * reclaiming from the parent instead of the dead memcg.
@@ -1326,6 +1354,13 @@ static void shrink_worker(struct work_struct *w)
 	int ret, failures = 0, attempts = 0;
 	unsigned long thr;
 
+	/*
+	 * When vswap is enabled, zswap entries are almost all vswap backed,
+	 * with no slot to write back to.
+	 */
+	if (vswap_is_enabled())
+		return;
+
 	/* Reclaim down to the accept threshold */
 	thr = zswap_accept_thr_pages();
 
@@ -1428,9 +1463,7 @@ static bool zswap_store_page(struct page *page,
 	if (!zswap_compress(page, entry, pool))
 		goto compress_failed;
 
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
+	old = zswap_entry_store(page_swpentry, entry);
 	if (xa_is_err(old)) {
 		int err = xa_err(old);
 
@@ -1499,7 +1532,7 @@ bool zswap_store(struct folio *folio)
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
 	bool ret = false;
-	long index;
+	long index = 0;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1554,13 +1587,19 @@ bool zswap_store(struct folio *folio)
 	if (!ret && zswap_pool_reached_full)
 		queue_work(shrink_wq, &zswap_shrink_work);
 check_old:
+	if (ret)
+		return ret;
+
 	/*
 	 * If the zswap store fails or zswap is disabled, we must invalidate
 	 * the possibly stale entries which were previously stored at the
 	 * offsets corresponding to each page of the folio. Otherwise,
 	 * writeback could overwrite the new data in the swapfile.
 	 */
-	if (!ret) {
+	if (is_vswap_entry(swp)) {
+		if (index > 0)
+			folio_release_vswap_backing(folio);
+	} else {
 		unsigned type = swp_type(swp);
 		pgoff_t offset = swp_offset(swp);
 		struct zswap_entry *entry;
@@ -1600,8 +1639,7 @@ bool zswap_store(struct folio *folio)
 int zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
-	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
+	struct swap_info_struct *si = __swap_entry_to_info(swp);
 	struct zswap_entry *entry;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
@@ -1620,7 +1658,7 @@ int zswap_load(struct folio *folio)
 		return -EINVAL;
 	}
 
-	entry = xa_load(tree, offset);
+	entry = zswap_entry_load(swp);
 	if (!entry)
 		return -ENOENT;
 
@@ -1643,8 +1681,13 @@ int zswap_load(struct folio *folio)
 	 * compression work.
 	 */
 	folio_mark_dirty(folio);
-	xa_erase(tree, offset);
-	zswap_entry_free(entry);
+
+	if (swap_is_vswap(si)) {
+		folio_release_vswap_backing(folio);
+	} else {
+		xa_erase(swap_zswap_tree(swp), swp_offset(swp));
+		zswap_entry_free(entry);
+	}
 
 	folio_unlock(folio);
 	return 0;
-- 
2.53.0-Meta

