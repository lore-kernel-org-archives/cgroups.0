Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB1F519905
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789754571; cv=none; b=XMev4MJYLl2JxucQF2CM9tOBMpCYTLZN+4lnwoHYdhWg3biCj0yv7hfDD2PEMx782ODFaP6qdmfkjStJ0Tg7kj8UJoovxmfoYQLFwds6+9gqSxmxwhQW/W9nhsUqQZnOK92BcDY8MFT9Y2cTwH010cSSS+CdwL+n8jgQeD4XWNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789754571; c=relaxed/simple;
	bh=hTXAM+oFcps6nmIiD1HqMSxqPU9Lt5lnKtD8HOxM4Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPeZKZNM6CIqVrTHfk8OblU62aJ9bUNywGDwate5q9dTwBrQmGiKmxc7gDQgKS3GI8SKlcSRHHW+lbHKH1Ur0Yi0OwGII6p31ma2GFRA1A4lqQm60d29+pz9Lkd3UPfp8q/WNjK7fPZjTHmlI6c3ZdyYYM7uA06mPdfxSx38Dzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P2Du8ByJ; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P2Du8ByJ"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-80638c24bedso851258a34.0
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 11:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754566; x=1790359366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=szbh+CjqxPqdhW//FC3nMgY8saM/5ZX/IiWyhRbMQJs=;
        b=P2Du8ByJDDIR4WlTkQttlnKGu2XZu6qcpFoXf366uSg/J7hhiHG4NFhLLZPQLmRQEe
         s5FOT1VHEE1EHGkrxJoavAYV2B+scCYp0iXh4AEjlD4pK8lWXiwnRjIPa2Y+U57GI24t
         LwY5ORg7o+taVRU0Kd143+u6YLgkpIt4+fp4iFJsihytsC0GM/9f2Xp97cu5VXZicgRH
         rSe+5xmsSDSOXUXy4OMNlPWpub1L4AjYmaM495b0eGrHg4I7R2WE0HbBY5TA6jiZQn2e
         tqSe0LdqqwIcGe5G2OuUX/xU3niRV38I12GnLtOmRLJ88fgTnscHPlh5yBXp4zgsU0eB
         3Ixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754566; x=1790359366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=szbh+CjqxPqdhW//FC3nMgY8saM/5ZX/IiWyhRbMQJs=;
        b=oRPsv4DIRfcMDVSbTpKjTzzVRPiKriEtqdGRqPPV5rrrJdhIWDrHmfguGC8BVtQFdB
         6C/WnhuDZSf/2cp2AwP7eH0xqStIjUjpyegNWtQ7Ams76ANLVpS0yOAIufN33LSCpsrt
         lDxAzTLEJyd3Q1wWWtSjnmEgqJToULJau2+BU1YUwjiRY6Fr6+rpJgQfZezSQqGcwWvL
         r9CFDZxyTYuV21AM1gcSZt+jHTWfATejkz1t9ZuHoMfpIakc263gs0QrgNtS1bOdxxC+
         2lBPSsvdJIMtiiN21P8VfyVzYJtTmsXFqmAxRxfMOMBAH/0zO0F1CyMsyGbf6EbsQokm
         YwNA==
X-Forwarded-Encrypted: i=1; AKwUvBzU3vRDZAXTZ4rWvsC6qMVBFfdKebNP4olxfdnmGSgD9uNfBM9HGDZOKlcM48TrmRro3lHjQmLK@vger.kernel.org
X-Gm-Message-State: AFuF++kF1HBIovCpyAyx2pKxJ0axqd7AXyJnSwH73sEt+2QkYDK2jtes
	yYjgP5ZsfeqAKJcv6WeeqJMD7FEp43vhZxS16570b6vrGI6dp0nmqUIQ
X-Gm-Gg: AYBFou2aEgyoNdllNWfNcLWEr58afz524COyCcFx7Rh+3IdgSbMlTcAuGBRZnq3R4me
	qQSQIZHRfm+2HNck1kDl95uFdmNTXi5ATzx+7T32N9ijqGdCuDIXrtLemlvk5Gu0JCVB5zKgEuz
	aMWCIH1Q83LHfCYydblqtFc/UjuSPdJRtzUSFjMH2nylMfv2IqzAnQtpwUDRYpcZDI8oNYIZzw8
	mRjRdYUlovArXCrfqvx55ZgeZMsltMQ0qLCKPM0hqDBehdj7tQG0a6BfNIbuGlQrQmS462pcxh0
	A0NM91a918PM/ZPgfJHkVNJJk9ELR7yTbYnTd3pbN5f5d3UMedp/JkUx3BxDFKSfjmVWMT0ut6t
	g0xQCQZk9BEWQypu23HAZXzDXOaKicjusg0ir/T3KUQYqC8A2Cv7z60Z1hNF8JrBrew+uP32ggC
	ZqeB1p3qQTgParFg81U6HezpLJ6baL1hKV+wH7hzdaolggbMhMf64/v65RGGjCYPax/z16B15ym
	Sm+IhanuWL0v3EmIKpJLQ==
X-Received: by 2002:a9d:7085:0:b0:802:9f53:3a66 with SMTP id 46e09a7af769-80c4bd14aedmr4916798a34.6.1789754566141;
        Fri, 18 Sep 2026 11:02:46 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8107dd8bd19sm170602a34.8.2026.09.18.11.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:45 -0700 (PDT)
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
Subject: [PATCH v5 02/11] mm, swap: support zswap and zero-filled swap pages as vswap backends
Date: Fri, 18 Sep 2026 11:02:32 -0700
Message-ID: <20260918180241.3424851-3-nphamcs@gmail.com>
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

Anon reclaim gating needs a matching change: a vswap zswap-backed
swapout consumes no physical slot, so the physical free count no longer
tells reclaim whether anon is reclaimable. Add mem_cgroup_can_swap(),
which answers that question and gates on the swap.max headroom instead
when vswap and zswap are both on. Its callers only ever compared
mem_cgroup_get_nr_swap_pages() against a threshold, so that function
keeps its meaning and its physical free count.

The OVERCOMMIT_GUESS heuristic gates a single allocation on
totalram_pages() + total_swap_pages. Vswap deliberately contributes to
neither, so on a host with no swapfile the bound collapses to RAM alone
and allocations that vswap could absorb are refused. Compression swap is
backed by memory rather than by a device, so reference the bound to RAM:
add 2 * totalram_pages() when vswap and zswap are both on, for a 3x RAM
ceiling plus whatever physical swap exists.

mem_cgroup_can_vswap() is added alongside, so the !CONFIG_MEMCG stub of
mem_cgroup_can_swap() gets the same carve-out as the real one. Without
it, get_nr_swap_pages() reads 0 under vswap and MGLRU concludes anon can
never be swapped.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h  |  13 +++
 include/linux/zswap.h |   4 +
 mm/memcontrol.c       |  29 +++++++
 mm/memory.c           |  11 ++-
 mm/page_io.c          |  12 ++-
 mm/shmem.c            |   4 +-
 mm/swap.h             |   1 +
 mm/swap_state.c       |   8 ++
 mm/swapfile.c         | 187 ++++++++++++++++++++++++++++++++++++++++--
 mm/util.c             |  13 ++-
 mm/vmscan.c           |  18 ++--
 mm/vswap.h            | 185 +++++++++++++++++++++++++++++++++++++++++
 mm/workingset.c       |   2 +-
 mm/zswap.c            |  68 ++++++++++++---
 14 files changed, 521 insertions(+), 34 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0b341301d8fa..abf658f7861f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -367,6 +367,8 @@ extern void __meminit kswapd_stop(int nid);
 bool current_is_kswapd(void);
 
 #ifdef CONFIG_SWAP
+bool mem_cgroup_can_vswap(struct mem_cgroup *memcg);
+
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
 int generic_swapfile_activate(struct swap_info_struct *, struct file *,
@@ -440,6 +442,11 @@ static inline void put_swap_device(struct swap_info_struct *si)
 }
 
 #else /* CONFIG_SWAP */
+static inline bool mem_cgroup_can_vswap(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
 static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
 {
 	return NULL;
@@ -538,6 +545,7 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
 
 long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
+bool mem_cgroup_can_swap(struct mem_cgroup *memcg, long nr_pages);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
 static inline int mem_cgroup_try_charge_swap(struct folio *folio)
@@ -560,6 +568,11 @@ static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 	return get_nr_swap_pages();
 }
 
+static inline bool mem_cgroup_can_swap(struct mem_cgroup *memcg, long nr_pages)
+{
+	return mem_cgroup_can_vswap(memcg) || get_nr_swap_pages() >= nr_pages;
+}
+
 static inline bool mem_cgroup_swap_full(struct folio *folio)
 {
 	return vm_swap_full();
diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index df6cafbe95dc..0cc2cc878566 100644
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
 void zswap_invalidate(int type, pgoff_t offset, unsigned long nr_entries);
+void zswap_entry_free(struct zswap_entry *entry);
 int zswap_swapon(int type, unsigned long nr_pages);
 void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
@@ -54,6 +56,8 @@ static inline void zswap_invalidate(int type, pgoff_t offset,
 {
 }
 
+static inline void zswap_entry_free(struct zswap_entry *entry) {}
+
 static inline int zswap_swapon(int type, unsigned long nr_pages)
 {
 	return 0;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 791e536efaeb..63d2c9e3dbe1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -66,6 +66,7 @@
 #include "internal.h"
 #include "swap.h"
 #include "swap_table.h"
+#include "vswap.h"
 #include <net/sock.h>
 #include <net/ip.h>
 #include "slab.h"
@@ -6049,6 +6050,34 @@ long mem_cgroup_get_folio_swap_margin(struct folio *folio)
 	return margin;
 }
 
+/**
+ * mem_cgroup_can_swap - can @memcg swap out at least @nr_pages more pages?
+ * @memcg: the memcg to query
+ * @nr_pages: the number of pages the caller wants to swap out
+ *
+ * A vswap zswap-backed swapout needs no physical slot, so gate on the
+ * swap.max headroom rather than the physical free count.
+ *
+ * Return: true if @memcg can swap out at least @nr_pages more pages.
+ */
+bool mem_cgroup_can_swap(struct mem_cgroup *memcg, long nr_pages)
+{
+	long avail;
+
+	if (mem_cgroup_can_vswap(memcg))
+		return true;
+
+	if (!vswap_is_enabled() || !zswap_is_enabled())
+		return mem_cgroup_get_nr_swap_pages(memcg) >= nr_pages;
+
+	avail = PAGE_COUNTER_MAX;
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
+		avail = min_t(long, avail,
+			      READ_ONCE(memcg->swap.max) -
+			      page_counter_read(&memcg->swap));
+	return avail >= nr_pages;
+}
+
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/memory.c b/mm/memory.c
index 338fce99e711..73ebc59d2b03 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -89,6 +89,7 @@
 #include "pgalloc-track.h"
 #include "internal.h"
 #include "swap.h"
+#include "vswap.h"
 
 #if defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS) && !defined(CONFIG_COMPILE_TEST)
 #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
@@ -4712,6 +4713,9 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 {
 	if (!folio_test_swapcache(folio))
 		return false;
+	/* A vswap entry holds no physical slot, so keeping it saves no IO. */
+	if (is_vswap_entry(folio->swap))
+		return true;
 	/*
 	 * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. Swap
 	 * cache can help save some IO or memory overhead, but these devices
@@ -4868,15 +4872,18 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
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
index 5cd77bd1b12c..2e7fb335eb01 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -162,13 +162,18 @@ static void swap_zeromap_folio_set(struct folio *folio)
 	int nr_pages = folio_nr_pages(folio);
 	struct swap_cluster_info *ci;
 	swp_entry_t entry = folio->swap;
-	unsigned int i;
+	unsigned int voff, i;
 
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
 		__swap_table_set_zero(ci, swp_cluster_offset(entry));
 		entry.val++;
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
index b572c60f2af8..2871a1f618ec 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -86,6 +86,7 @@ static struct vfsmount *shm_mnt __ro_after_init;
 #include <linux/uaccess.h>
 
 #include "internal.h"
+#include "vswap.h"
 
 #define VM_ACCT(size)    (PAGE_ALIGN(size) >> PAGE_SHIFT)
 
@@ -1819,7 +1820,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
 		goto redirty;
 
-	if (!total_swap_pages)
+	/* vswap doesn't contribute to total_swap_pages */
+	if (!total_swap_pages && !(vswap_is_enabled() && zswap_is_enabled()))
 		goto redirty;
 
 	/*
diff --git a/mm/swap.h b/mm/swap.h
index 528a27afb335..81e47dc36a02 100644
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
index 424a0040b4b8..54e4fefdab95 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -27,6 +27,7 @@
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
+#include "vswap.h"
 
 /* Swap readahead cluster size, as a power of 2 pages. */
 static int page_cluster;
@@ -188,6 +189,13 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
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
index edd7bddf7ff9..67a2399cf1ae 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -46,6 +46,7 @@
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
+#include "memcontrol-v1.h"
 #include "swap_table.h"
 #include "vswap.h"
 #include "internal.h"
@@ -131,6 +132,16 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
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
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
 {
@@ -236,7 +247,8 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
-			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio)));
+			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio) &&
+			 !is_vswap_entry(folio->swap)));
 	if (!need_reclaim || !folio_swapcache_freeable(folio))
 		goto out_unlock;
 
@@ -544,7 +556,9 @@ swap_cluster_populate(struct swap_info_struct *si,
 	/*
 	 * Only cluster isolation from the allocator does table allocation.
 	 * Swap allocator uses percpu clusters and holds the local lock.
+	 * vswap clusters are destroyed rather than freed to si->free_clusters.
 	 */
+	VM_WARN_ON_ONCE(swap_is_vswap(si));
 	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		lockdep_assert_held(&si->global_cluster_lock);
@@ -632,6 +646,7 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 		ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
 		xa_erase(&si->cluster_info_pool, ci_dyn->index);
 		move_cluster(si, ci, NULL, CLUSTER_FLAG_DEAD);
+		vswap_cluster_free_vtable(ci);
 		kfree_rcu(ci_dyn, rcu);
 		return;
 	}
@@ -926,7 +941,8 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 		if (swp_tb_is_null(swp_tb))
 			continue;
 		if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(swp_tb)) {
-			if (!vm_swap_full())
+			/* vswap slots are abundant; never reclaim to reuse one */
+			if (swap_is_vswap(si) || !vm_swap_full())
 				return false;
 			*need_reclaim = true;
 			continue;
@@ -1034,6 +1050,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
@@ -1086,6 +1106,12 @@ static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
 		return SWAP_ENTRY_INVALID;
 	}
 
+	if (vswap_cluster_alloc_vtable(ci_dyn, GFP_ATOMIC | __GFP_NOWARN)) {
+		swap_cluster_free_table(&ci_dyn->ci);
+		kfree(ci_dyn);
+		return SWAP_ENTRY_INVALID;
+	}
+
 	/* Lock before publishing: xa_alloc makes the cluster findable by offset. */
 	ci = &ci_dyn->ci;
 	spin_lock(&ci->lock);
@@ -1095,6 +1121,7 @@ static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
 		     GFP_ATOMIC | __GFP_NOWARN)) {
 		spin_unlock(&ci->lock);
 		swap_cluster_free_table(&ci_dyn->ci);
+		vswap_cluster_free_vtable(&ci_dyn->ci);
 		kfree(ci_dyn);
 		return SWAP_ENTRY_INVALID;
 	}
@@ -1178,7 +1205,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	 * Swapfile is not block device so unable
 	 * to allocate large entries.
 	 */
-	if (order && !(si->flags & SWP_BLKDEV))
+	if (order && !(si->flags & SWP_BLKDEV) && !swap_is_vswap(si))
 		return 0;
 
 	if (!(si->flags & SWP_SOLIDSTATE)) {
@@ -1231,7 +1258,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	}
 
 	/* Try reclaim full clusters if free and nonfull lists are drained */
-	if (vm_swap_full())
+	if (!swap_is_vswap(si) && vm_swap_full())
 		swap_reclaim_full_clusters(si, false);
 
 	if (order < PMD_ORDER) {
@@ -1392,7 +1419,8 @@ static void swap_range_alloc(struct swap_info_struct *si,
 		if (vm_swap_full())
 			schedule_work(&si->reclaim_work);
 	}
-	atomic_long_sub(nr_entries, &nr_swap_pages);
+	if (!swap_is_vswap(si))
+		atomic_long_sub(nr_entries, &nr_swap_pages);
 }
 
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
@@ -1401,7 +1429,8 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
 
-	zswap_invalidate(si->type, offset, nr_entries);
+	if (!swap_is_vswap(si))
+		zswap_invalidate(si->type, offset, nr_entries);
 
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
@@ -1420,7 +1449,8 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	 * only after the above cleanups are done.
 	 */
 	smp_wmb();
-	atomic_long_add(nr_entries, &nr_swap_pages);
+	if (!swap_is_vswap(si))
+		atomic_long_add(nr_entries, &nr_swap_pages);
 	swap_usage_sub(si, nr_entries);
 }
 
@@ -1808,6 +1838,68 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 	return err;
 }
 
+/*
+ * Virtual swap is unbounded for a zswap-capable memcg: vswap charges the
+ * physical backing, not the allocation, so the swap.max walk would starve
+ * anon reclaim. swap.max is still enforced when the backing is charged.
+ */
+bool mem_cgroup_can_vswap(struct mem_cgroup *memcg)
+{
+	return vswap_is_enabled() && zswap_is_enabled() &&
+	       (mem_cgroup_disabled() || do_memsw_account());
+}
+
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
@@ -1846,12 +1938,16 @@ int folio_alloc_swap(struct folio *folio)
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
@@ -1869,7 +1965,7 @@ int folio_alloc_swap(struct folio *folio)
 	return 0;
 
 failed:
-	if (get_nr_swap_pages() <= 0)
+	if (get_nr_swap_pages() <= 0 && !vswap_is_enabled())
 		return -ENOSPC;
 	if (mem_cgroup_get_folio_swap_margin(folio) <= 0)
 		return -ENOMEM;
@@ -1877,6 +1973,73 @@ int folio_alloc_swap(struct folio *folio)
 	return order ? -E2BIG : -ENOMEM;
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
@@ -2022,6 +2185,9 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 
 	VM_WARN_ON(ci->count < nr_pages);
 
+	if (swap_is_vswap(si))
+		__vswap_release_backing(ci, ci_start, nr_pages);
+
 	ci->count -= nr_pages;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
@@ -3187,6 +3353,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si,
 				swap_cluster_free_table(ci);
 			}
 			spin_unlock(&ci->lock);
+			vswap_cluster_free_vtable(ci);
 			kfree(ci_dyn);
 		}
 		xa_destroy(&si->cluster_info_pool);
@@ -3716,6 +3883,10 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		if (err)
 			goto err;
 
+		err = vswap_cluster_alloc_vtable(ci_dyn, GFP_KERNEL);
+		if (err)
+			goto err;
+
 		goto setup_cluster_info;
 	}
 
diff --git a/mm/util.c b/mm/util.c
index c5ee52aede1e..bde985f242df 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -33,6 +33,7 @@
 
 #include "internal.h"
 #include "swap.h"
+#include "vswap.h"
 
 /**
  * kfree_const - conditionally free memory
@@ -970,7 +971,17 @@ int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin
 		return 0;
 
 	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
-		if (pages > totalram_pages() + total_swap_pages)
+		allowed = totalram_pages() + total_swap_pages;
+		/*
+		 * Vswap is in neither term, so with no swapfile the bound
+		 * would collapse to RAM alone even though zswap can absorb
+		 * more. Compression swap is backed by memory, so budget a 3x
+		 * compression ratio, typical of most workloads. Anything that
+		 * compresses better can use OVERCOMMIT_ALWAYS.
+		 */
+		if (vswap_is_enabled() && zswap_is_enabled())
+			allowed += 2 * totalram_pages();
+		if (pages > allowed)
 			goto error;
 		return 0;
 	}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 836f50814ffa..6cf689817f2e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -69,6 +69,7 @@
 #include "internal.h"
 #include "page_alloc.h"
 #include "swap.h"
+#include "vswap.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
@@ -415,10 +416,12 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 	if (memcg == NULL) {
 		/*
 		 * For non-memcg reclaim, is there space in any swap device?
-		 * And under GFP_NOIO, is there enough swapcached anon to make
-		 * scanning anon worthwhile?
+		 * vswap does not contribute to nr_swap_pages. And under
+		 * GFP_NOIO, is there enough swapcached anon to make scanning
+		 * anon worthwhile?
 		 */
-		if (get_nr_swap_pages() > 0 &&
+		if ((get_nr_swap_pages() > 0 ||
+		     (vswap_is_enabled() && zswap_is_enabled())) &&
 		    !reclaimable_anon_is_low(memcg, nid, sc))
 			return true;
 	} else {
@@ -426,7 +429,7 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 		 * Is the memcg below its swap limit, and under GFP_NOIO does
 		 * it have enough swapcached anon to make scanning worthwhile?
 		 */
-		if (mem_cgroup_get_nr_swap_pages(memcg) > 0 &&
+		if (mem_cgroup_can_swap(memcg, 1) &&
 		    !reclaimable_anon_is_low(memcg, nid, sc))
 			return true;
 	}
@@ -1603,7 +1606,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (folio_test_swapcache(folio) &&
-		    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
+		    ((mem_cgroup_swap_full(folio) && !is_vswap_entry(folio->swap)) ||
+		     folio_test_mlocked(folio)))
 			folio_free_swap(folio);
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
 		if (!folio_test_mlocked(folio)) {
@@ -2760,7 +2764,7 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
 			       struct scan_control *sc)
 {
 	/* Aging the anon LRU is valuable if swap is present: */
-	if (total_swap_pages > 0)
+	if (total_swap_pages > 0 || (vswap_is_enabled() && zswap_is_enabled()))
 		return true;
 
 	/* Also valuable if anon pages can be demoted: */
@@ -2853,7 +2857,7 @@ static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 		return 0;
 
 	if (!can_demote(pgdat->node_id, sc, memcg) &&
-	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
+	    !mem_cgroup_can_swap(memcg, MIN_LRU_BATCH))
 		return 0;
 
 	return swappiness;
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
diff --git a/mm/workingset.c b/mm/workingset.c
index 8412f4840ae3..fe80cd50f3e9 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -523,7 +523,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 		workingset_size += lruvec_page_state(eviction_lruvec,
 						     NR_INACTIVE_FILE);
 	}
-	if (mem_cgroup_get_nr_swap_pages(eviction_memcg) > 0) {
+	if (mem_cgroup_can_swap(eviction_memcg, 1)) {
 		workingset_size += lruvec_page_state(eviction_lruvec,
 						     NR_ACTIVE_ANON);
 		if (file) {
diff --git a/mm/zswap.c b/mm/zswap.c
index 73728b510ff6..3466c80ac188 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -39,6 +39,7 @@
 #include <linux/zsmalloc.h>
 
 #include "swap.h"
+#include "vswap.h"
 #include "internal.h"
 
 /*********************************
@@ -257,6 +258,25 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 	return zswap_tree(swp_type(swp), swp_offset(swp));
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
 
@@ -774,7 +794,7 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
  * Carries out the common pattern of freeing an entry's zsmalloc allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
-static void zswap_entry_free(struct zswap_entry *entry)
+void zswap_entry_free(struct zswap_entry *entry)
 {
 	struct zswap_pool *pool = zswap_entry_pool(entry);
 
@@ -1226,6 +1246,9 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
+	if (vswap_is_enabled())
+		return 0;
+
 	/*
 	 * The shrinker resumes swap writeback, which will enter block
 	 * and may enter fs. XXX: Harmonize with vmscan.c __GFP_FS
@@ -1308,6 +1331,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
  * Return: 0 if at least one entry was written back, -EAGAIN if entries
  * were scanned but none could be written back, or -ENOENT if @memcg has
  * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
+ *
+ * Also returns -ENOENT when vswap is enabled.
  */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
@@ -1316,6 +1341,9 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
+	if (vswap_is_enabled())
+		return -ENOENT;
+
 	/*
 	 * Skip zombies because their LRUs are reparented and we would be
 	 * reclaiming from the parent instead of the dead memcg.
@@ -1344,6 +1372,13 @@ static void shrink_worker(struct work_struct *w)
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
 
@@ -1447,15 +1482,13 @@ static bool zswap_store_page(struct folio *folio, long index,
 		goto compress_failed;
 
 	/*
-	 * Set pool_idx before the xa_store() below publishes the entry, or a
+	 * Set pool_idx before the store below publishes the entry, or a
 	 * concurrent reader could resolve a stale pool_idx left by slab reuse
 	 * to an unrelated live pool.
 	 */
 	entry->pool_idx = pool->idx;
 
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
+	old = zswap_entry_store(page_swpentry, entry);
 	if (xa_is_err(old)) {
 		int err = xa_err(old);
 
@@ -1523,7 +1556,7 @@ bool zswap_store(struct folio *folio)
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
 	bool ret = false;
-	long index;
+	long index = 0;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1576,14 +1609,21 @@ bool zswap_store(struct folio *folio)
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
-	if (!ret)
+	if (is_vswap_entry(swp)) {
+		if (index > 0)
+			folio_release_vswap_backing(folio);
+	} else {
 		zswap_invalidate(swp_type(swp), swp_offset(swp), nr_pages);
+	}
 
 	return ret;
 }
@@ -1634,8 +1674,7 @@ static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
 int zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
-	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
+	struct swap_info_struct *si = __swap_entry_to_info(swp);
 	struct zswap_entry *entry;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
@@ -1659,7 +1698,7 @@ int zswap_load(struct folio *folio)
 		return -ENOENT;
 	}
 
-	entry = xa_load(tree, offset);
+	entry = zswap_entry_load(swp);
 	if (!entry)
 		return -ENOENT;
 
@@ -1682,8 +1721,13 @@ int zswap_load(struct folio *folio)
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

