Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194783ADB8D
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041784; cv=none; b=jfgjCspMJBpK1J+HeIKseUbjDHuQBFvfUq6+IoaSdQNvZ7tTQBDMmLVzdaUkbkw4R+21WWY6wITulAza/VXromcA0/R4HQj8VqltPELqpT4Il1kfy2lgZJ8d3yaJr92zw5Uk6CgIbfn2YnQmUltiQt2UDCcoTzLI2crI4YPS5QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041784; c=relaxed/simple;
	bh=Xlrj4d4m4FjdXOJ7jfpG6cNLD9R9wjDtkY64UqMTSks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKsbK/Sl17ENVhWpF1dlXBpNw4SLQIsf4x6Xih4849sMj9ifT3rTtD+KvNUopLlQ8cg4R/nR7zV2ICUPTrEEB0NQjd4KPUlozCuyXXuezgLa+cOpmAc9rSULZF1pHdn02nKwtpGRIi85tAbefUhFVXE1mM/EDp1orHwQH7ahcds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lzaALNys; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lzaALNys"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6a168dc590cso1625897eaf.0
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 11:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041780; x=1786646580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lo0KJy4ET0eLH/vHkWIDi1pEtJHPb1YP4byd4zqxg8s=;
        b=lzaALNysMar9hC4CZFkQWflgk8UAdMvUc1+eWqLOaYVWdOhCD7u7tq/o61/+YiYkrz
         VBbSbe2wkXHPrwyBiAQWFVRrT62zRu9WgEClgXhbiPeIPVrcQNvlMniyQuKcgZWpKq6e
         emyOmUArdoQxcJjVQYVgGAZ/wCAcxV67gAqWIRc+D/RWO6LIREQ8zsuCYs/at0wgw4jb
         eEXoK0u2L23E9f4iW9U84ePR53SiCKqVogfuh085/8VjDH9Rv7xVz1YMazIevabljr+I
         bBJvIMZwVSDz0t5oSwuQjuiTmbTw6yqFTatYD0+yiKwGQgqdCKYVWljooqWMY1vPS9uw
         a23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041780; x=1786646580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Lo0KJy4ET0eLH/vHkWIDi1pEtJHPb1YP4byd4zqxg8s=;
        b=h3STzWmIf0urSlGx3wpiuidNsApOlCzOcGtRgyuyvZcnHp6QiWxNjNvWAz910XFaPq
         skv/OleSnh/1tprF56IEiDXVEuzzwWpNHEPn7K24NGDIk/hcCRtef3AktWTiOiFHE/eD
         eie2FZyqiQWAoEkbuMJzLiS2RmIF+VBIG22DHYeqMSZdCaYNI6ncquylig0nf1GnmnP3
         8mqIB67JjgOJ0+zYmdj9wvS8FONoWxllkexgeqFKeLgmD3J1lGWMb+OBn7sQnXHxdohv
         lDZSDOSakmB97RM8Ili51Of0iaGcYNOv2+zQHROkcxlUA7VMdP1hJ7D/Byl1Io/J70zn
         mScA==
X-Forwarded-Encrypted: i=1; AHgh+RqIUgX08wnNNyqMd1dEvQ5jtx9z6UuJz4oX27HSnh4QABuUlurCLgeywMwW85lR5USyYUX9u+lm@vger.kernel.org
X-Gm-Message-State: AOJu0YzI8nQtZBJwpHen7uPn/+7VVo6HqSIGzwOO2ZCekpwR5clV/4Mr
	mlCd//OtRLmYyclYYP7MSTn98LSpA5VqpoJyy0RG+4Gl2aj5+XOs70X14wjEGpus
X-Gm-Gg: AR+sD13gjsGaC8PIzA2pzbviBOB/zIf1xsJmw6BY93Hx7MILAlW0hJSWzIZUW1XA6Sj
	m7p1IIs2wBIUQj4E9v8B8i5bX8WAXTAUSRUlkoqZ1ErrAwN2Jl0jwfGz4rL1SRsjZtKj2RapDYO
	pr+0fsOwLohD5JMIe7ETG6cPit0IHmj/44JjIMgmrlPGaI7k0wOP5uLqgnP6jEuXmu/Byz+5PQx
	gdGT48idScxNlIEo8+hArJtCX+roYMC84ETq9ieaCpZ1CAmJgTqf+n6ETEenIpl0RA1qg3TNPZA
	QtXqPUhldSBRH1Ki5G1TBW5BeU/uf58qkhq0ejKq07uwRUzBxfknJighUP6EamYtUxMwm2yDJif
	WVeFcghKL1ZXFLtPpSgJ6Rfy8ALaD5QX2BmBjbIcg/3OxhDM2ys1pS+M4vhRCaxN0Qsm9AsYcE2
	BhXMNzG5jEVKWtMNDGUQ6bUDMVYOC2Nhxks9LtzGbr7GjJf6J3CFbUAlljqzTasuE+ebUKgg8Ie
	R90Mw2xoUxnBXatvUA+cg==
X-Received: by 2002:a05:6820:290d:b0:6a1:80a7:2c8d with SMTP id 006d021491bc7-6ae97013777mr8599984eaf.32.1786041779594;
        Thu, 06 Aug 2026 11:42:59 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bfa6379sm143949eaf.14.2026.08.06.11.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:42:58 -0700 (PDT)
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
Subject: [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
Date: Thu,  6 Aug 2026 11:42:45 -0700
Message-ID: <20260806184254.3790858-3-nphamcs@gmail.com>
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

Build the virtual swap layer on top of the swap-table infrastructure.
Virtual swap entries decouple PTE swap entries from physical backing,
allowing pages to be compressed by zswap (or detected as zero-filled)
without pre-allocating a physical swap slot.

This patch only supports zswap and zero-page backends. If zswap_store
fails, the page stays dirty in the swap cache. Physical disk backing
arrives in the next patch.

Zswap writeback of vswap-backed entries is also disabled: they have no
physical slot to write back to yet, so the zswap shrinker (both the
dynamic count path and the pool-full worker path) is skipped while
vswap is enabled. Physical backing and real writeback come in later
patches.

THP swapin is disabled for vswap entries for now.

Add a /proc/sys/vm/vswap_enabled sysctl and a CONFIG_VSWAP_DEFAULT_ON
build option so vswap allocation can be enabled and disabled at
runtime, defaulting off unless CONFIG_VSWAP_DEFAULT_ON=y. The knob
only gates vswap_alloc(), so existing virtual entries keep resolving
their backend and drain naturally when it is turned off.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 Documentation/admin-guide/sysctl/vm.rst |  16 ++
 include/linux/zswap.h                   |   3 +
 mm/Kconfig                              |  11 ++
 mm/memcontrol.c                         |   8 +
 mm/memory.c                             |  18 +-
 mm/page_io.c                            |  12 +-
 mm/shmem.c                              |   4 +-
 mm/swap.h                               |   1 +
 mm/swap_state.c                         |   8 +
 mm/swapfile.c                           | 242 ++++++++++++++++++++++--
 mm/vmscan.c                             |  14 +-
 mm/vswap.h                              | 206 +++++++++++++++++++-
 mm/zswap.c                              |  56 ++++--
 13 files changed, 561 insertions(+), 38 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 5b318d17aa4b..50b41f292631 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -74,6 +74,7 @@ Currently, these files are in /proc/sys/vm:
 - user_reserve_kbytes
 - vfs_cache_pressure
 - vfs_cache_pressure_denom
+- vswap_enabled
 - watermark_boost_factor
 - watermark_scale_factor
 - zone_reclaim_mode
@@ -1152,6 +1153,21 @@ vfs_cache_pressure_denom
 Defaults to 100 (minimum allowed value). Requires corresponding
 vfs_cache_pressure setting to take effect.
 
+vswap_enabled
+=============
+
+Controls whether new swapouts are routed through the virtual swap layer
+(only present when the kernel is built with CONFIG_VSWAP). Set to 1 to
+route swapouts through vswap, 0 to send them straight to the physical
+swap device.
+
+The default is 0 unless the kernel was built with
+CONFIG_VSWAP_DEFAULT_ON=y.
+
+Disabling is allocation-only: it only stops new swapouts from using
+vswap. Swap entries already backed by vswap keep being served and drain
+naturally as they are faulted back in or freed.
+
 watermark_boost_factor
 ======================
 
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
diff --git a/mm/Kconfig b/mm/Kconfig
index 32d38b552845..8d147c0483ef 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -29,6 +29,17 @@ config VSWAP
 	  swapfile, or kept in memory - with the backing changeable at
 	  runtime without invalidating page table entries.
 
+config VSWAP_DEFAULT_ON
+	bool "Route swapouts through virtual swap by default"
+	depends on VSWAP
+	default n
+	help
+	  Say Y to route swapouts through the virtual swap layer from
+	  boot.
+
+	  Say N (default) to leave vswap off until it is enabled at
+	  runtime via /proc/sys/vm/vswap_enabled.
+
 config ZSWAP
 	bool "Compressed cache for swap pages"
 	depends on SWAP
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 77582acd8ee5..7a426db06222 100644
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
@@ -5728,6 +5729,13 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
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
index 6ae52e3869b1..de3573b7c6b1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -89,6 +89,7 @@
 #include "pgalloc-track.h"
 #include "internal.h"
 #include "swap.h"
+#include "vswap.h"
 
 #if defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS) && !defined(CONFIG_COMPILE_TEST)
 #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
@@ -4657,6 +4658,12 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 	 */
 	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
 		return true;
+	/*
+	 * Non-swapfile backends cannot be reused for future swapouts.
+	 * Free the swap slot unless backed by contiguous physical swap.
+	 */
+	if (is_vswap_entry(folio->swap))
+		return true;
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
 		return true;
@@ -4805,15 +4812,16 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	if (unlikely(userfaultfd_armed(vma)))
 		return 0;
 
+	entry = softleaf_from_pte(vmf->orig_pte);
+
 	/*
-	 * A large swapped out folio could be partially or fully in zswap. We
-	 * lack handling for such cases, so fallback to swapping in order-0
-	 * folio.
+	 * THP swapin for vswap is not supported yet. Also, a large swapped
+	 * out folio could be partially or fully in zswap, which we lack
+	 * handling for. In both cases, fall back to order-0 swapin.
 	 */
-	if (!zswap_never_enabled())
+	if (is_vswap_entry(entry) || !zswap_never_enabled())
 		return 0;
 
-	entry = softleaf_from_pte(vmf->orig_pte);
 	/*
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
diff --git a/mm/page_io.c b/mm/page_io.c
index fca1718056af..b1894cd014b3 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -160,14 +160,19 @@ static void swap_zeromap_folio_set(struct folio *folio)
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
@@ -235,6 +240,9 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	 */
 	swap_zeromap_folio_clear(folio);
 
+	if (is_vswap_entry(folio->swap))
+		folio_release_vswap_backing(folio);
+
 	if (zswap_store(folio)) {
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		goto out_unlock;
diff --git a/mm/shmem.c b/mm/shmem.c
index 2e4dacdcce11..153ac7433fb0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -85,6 +85,7 @@ static struct vfsmount *shm_mnt __ro_after_init;
 #include <linux/uaccess.h>
 
 #include "internal.h"
+#include "vswap.h"
 
 #define VM_ACCT(size)    (PAGE_ALIGN(size) >> PAGE_SHIFT)
 
@@ -1617,7 +1618,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
 		goto redirty;
 
-	if (!total_swap_pages)
+	/* vswap doesn't contribute to total_swap_pages */
+	if (!total_swap_pages && !(vswap_is_enabled() && zswap_is_enabled()))
 		goto redirty;
 
 	/*
diff --git a/mm/swap.h b/mm/swap.h
index b593ad3214ef..d241e81e967e 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -70,6 +70,7 @@ struct swap_cluster_info_dynamic {
 	struct swap_cluster_info ci;
 	unsigned int index;		/* for cluster_index() */
 	struct rcu_head rcu;
+	atomic_long_t *virtual_table;	/* Backing pointers for vswap slots */
 };
 
 /* All on-list cluster must have a non-zero flag. */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 9e0d71fcdc24..9f6377b32911 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -26,6 +26,7 @@
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
+#include "vswap.h"
 
 /* Swap readahead cluster size, as a power of 2 pages. */
 static int page_cluster;
@@ -196,6 +197,13 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	if (nr == 1)
 		return 0;
 
+	/*
+	 * THP swapin for vswap is not supported yet; reject the batch so
+	 * swap_cache_alloc_folio falls back to order 0.
+	 */
+	if (is_vswap_entry(targ_entry))
+		return -EBUSY;
+
 	is_zero = __swap_table_test_zero(ci, ci_off);
 	ci_off = round_down(ci_off, nr);
 	ci_end = ci_off + nr;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index fea3a8eccbc1..a26cfe5751c8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -23,6 +23,7 @@
 #include <linux/random.h>
 #include <linux/writeback.h>
 #include <linux/proc_fs.h>
+#include <linux/sysctl.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/ksm.h>
@@ -131,6 +132,29 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+#ifdef CONFIG_VSWAP
+static int sysctl_vswap_enabled = IS_ENABLED(CONFIG_VSWAP_DEFAULT_ON);
+
+bool vswap_is_enabled(void)
+{
+	return sysctl_vswap_enabled;
+}
+
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
+#else
+static inline bool vswap_alloc(struct folio *folio) { return false; }
+#endif
+
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
 {
@@ -236,7 +260,8 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
-			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio)));
+			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio) &&
+			 !is_vswap_entry(folio->swap)));
 	if (!need_reclaim || !folio_swapcache_freeable(folio))
 		goto out_unlock;
 
@@ -537,7 +562,12 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * Only cluster isolation from the allocator does table allocation.
 	 * Swap allocator uses percpu clusters and holds the local lock.
 	 */
-	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
+#ifdef CONFIG_VSWAP
+	if (swap_is_vswap(si))
+		lockdep_assert_held(&this_cpu_ptr(&percpu_vswap_cluster)->lock);
+#endif
+	if (!swap_is_vswap(si))
+		lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
@@ -554,7 +584,12 @@ swap_cluster_populate(struct swap_info_struct *si,
 	spin_unlock(&ci->lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
-	local_unlock(&percpu_swap_cluster.lock);
+#ifdef CONFIG_VSWAP
+	if (swap_is_vswap(si))
+		local_unlock(&percpu_vswap_cluster.lock);
+#endif
+	if (!swap_is_vswap(si))
+		local_unlock(&percpu_swap_cluster.lock);
 
 	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					   GFP_KERNEL);
@@ -567,7 +602,12 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	local_lock(&percpu_swap_cluster.lock);
+#ifdef CONFIG_VSWAP
+	if (swap_is_vswap(si))
+		local_lock(&percpu_vswap_cluster.lock);
+#endif
+	if (!swap_is_vswap(si))
+		local_lock(&percpu_swap_cluster.lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_lock(&si->global_cluster_lock);
 	spin_lock(&ci->lock);
@@ -729,6 +769,7 @@ static void vswap_free_cluster(struct swap_info_struct *si,
 		spin_unlock(&si->lock);
 	}
 	swap_cluster_free_table(ci);
+	vswap_cluster_free_vtable(ci);
 	/*
 	 * Ordering vs the RCU cluster lookup: erase from the xarray first
 	 * (new lookups miss it), mark DEAD under the held ci->lock (a lookup
@@ -765,6 +806,10 @@ static void free_cluster(struct swap_info_struct *si, struct swap_cluster_info *
 		return;
 	}
 
+	/*
+	 * Vswap dynamic clusters need explicit cleanup (xarray erase,
+	 * kfree_rcu, virtual_table free if allocated).
+	 */
 	if (swap_is_vswap(si)) {
 		vswap_free_cluster(si, ci);
 		return;
@@ -947,7 +992,8 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 		if (swp_tb_is_null(swp_tb))
 			continue;
 		if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(swp_tb)) {
-			if (!vm_swap_full())
+			/* vswap slots are unlimited; never reclaim to reuse one */
+			if (swap_is_vswap(si) || !vm_swap_full())
 				return false;
 			*need_reclaim = true;
 			continue;
@@ -1015,7 +1061,8 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 /* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
-					    struct folio *folio, unsigned long offset)
+					    struct folio *folio,
+					    unsigned long offset)
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
@@ -1058,6 +1105,12 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 		relocate_cluster(si, ci);
 		swap_cluster_unlock(ci);
 	}
+#ifdef CONFIG_VSWAP
+	if (swap_is_vswap(si)) {
+		this_cpu_write(percpu_vswap_cluster.offset[order], next);
+		return found;
+	}
+#endif
 	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(percpu_swap_cluster.offset[order], next);
 		this_cpu_write(percpu_swap_cluster.si[order], si);
@@ -1110,10 +1163,17 @@ static unsigned int alloc_swap_scan_dynamic(struct swap_info_struct *si,
 		return SWAP_ENTRY_INVALID;
 	}
 
+	if (vswap_cluster_alloc_vtable(ci_dyn)) {
+		swap_cluster_free_table(&ci_dyn->ci);
+		kfree(ci_dyn);
+		return SWAP_ENTRY_INVALID;
+	}
+
 	if (xa_alloc(&si->cluster_info_pool, &ci_dyn->index, ci_dyn,
 		     XA_LIMIT(1, DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER) - 1),
 		     GFP_ATOMIC)) {
 		swap_cluster_free_table(&ci_dyn->ci);
+		vswap_cluster_free_vtable(&ci_dyn->ci);
 		kfree(ci_dyn);
 		return SWAP_ENTRY_INVALID;
 	}
@@ -1199,7 +1259,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	 * Swapfile is not block device so unable
 	 * to allocate large entries.
 	 */
-	if (order && !(si->flags & SWP_BLKDEV))
+	if (order && !(si->flags & SWP_BLKDEV) && !swap_is_vswap(si))
 		return 0;
 
 	if (!(si->flags & SWP_SOLIDSTATE)) {
@@ -1252,7 +1312,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	}
 
 	/* Try reclaim full clusters if free and nonfull lists are drained */
-	if (vm_swap_full())
+	if (!swap_is_vswap(si) && vm_swap_full())
 		swap_reclaim_full_clusters(si, false);
 
 	if (order < PMD_ORDER) {
@@ -1416,7 +1476,8 @@ static void swap_range_alloc(struct swap_info_struct *si,
 		if (vm_swap_full())
 			schedule_work(&si->reclaim_work);
 	}
-	atomic_long_sub(nr_entries, &nr_swap_pages);
+	if (!swap_is_vswap(si))
+		atomic_long_sub(nr_entries, &nr_swap_pages);
 }
 
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
@@ -1426,8 +1487,10 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
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
@@ -1446,7 +1509,8 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	 * only after the above cleanups are done.
 	 */
 	smp_wmb();
-	atomic_long_add(nr_entries, &nr_swap_pages);
+	if (!swap_is_vswap(si))
+		atomic_long_add(nr_entries, &nr_swap_pages);
 	swap_usage_sub(si, nr_entries);
 }
 
@@ -1838,6 +1902,49 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 	return err;
 }
 
+#ifdef CONFIG_VSWAP
+static bool vswap_alloc(struct folio *folio)
+{
+	unsigned int order = folio_order(folio);
+	struct swap_cluster_info *ci;
+	unsigned long offset;
+
+	if (!sysctl_vswap_enabled)
+		return false;
+
+	/* vswap_init failed: fall back to direct physical swap */
+	if (!vswap_si)
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
+#endif
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1875,12 +1982,17 @@ int folio_alloc_swap(struct folio *folio)
 		}
 	}
 
+	/* Without zswap a vswap entry has nowhere to go on writeout. */
+	if (zswap_is_enabled() && vswap_alloc(folio))
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
@@ -1896,6 +2008,80 @@ int folio_alloc_swap(struct folio *folio)
 	return 0;
 }
 
+#ifdef CONFIG_VSWAP
+
+/**
+ * __vswap_release_backing - release the backing of a range of vtable slots
+ * @ci: the locked vswap cluster
+ * @ci_start: first slot offset within @ci
+ * @nr: number of slots
+ *
+ * Releases each slot in [@ci_start, @ci_start + @nr): physical swap slots,
+ * zswap entries, etc. Clears the zero marks if set.
+ *
+ * Context: caller must hold @ci->lock. The entire range must belong to the
+ * same memcg.
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
+	if (!ci)
+		return;
+	voff = swp_cluster_offset(folio->swap);
+
+	spin_lock(&ci->lock);
+	__vswap_release_backing(ci, voff, nr);
+	spin_unlock(&ci->lock);
+}
+
+#endif /* CONFIG_VSWAP */
+
 /**
  * folio_dup_swap() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
@@ -2037,6 +2223,9 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 
 	VM_WARN_ON(ci->count < nr_pages);
 
+	if (swap_is_vswap(si))
+		__vswap_release_backing(ci, ci_start, nr_pages);
+
 	ci->count -= nr_pages;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
@@ -2907,6 +3096,7 @@ static int try_to_unuse(unsigned int type)
 	       (i = find_next_to_unuse(si, i)) != 0) {
 
 		entry = swp_entry(type, i);
+
 		folio = swap_cache_get_folio(entry);
 		if (!folio)
 			continue;
@@ -4134,6 +4324,18 @@ struct swap_info_struct *vswap_si;
 /* vswap does no IO on its own. */
 static const struct swap_ops vswap_ops = { };
 
+static const struct ctl_table vswap_sysctls[] = {
+	{
+		.procname	= "vswap_enabled",
+		.data		= &sysctl_vswap_enabled,
+		.maxlen		= sizeof(sysctl_vswap_enabled),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+};
+
 static int __init vswap_init(void)
 {
 	struct swap_info_struct *si;
@@ -4141,8 +4343,12 @@ static int __init vswap_init(void)
 	int err;
 
 	si = alloc_swap_info();
-	if (IS_ERR(si))
-		return PTR_ERR(si);
+	if (IS_ERR(si)) {
+		pr_warn("vswap: alloc_swap_info failed (%ld); vswap disabled, swapout falls back to direct physical swap\n",
+			PTR_ERR(si));
+		sysctl_vswap_enabled = 0;
+		return 0;
+	}
 
 	maxpages = min(swapfile_maximum_size,
 		       ALIGN_DOWN((unsigned long)UINT_MAX, SWAPFILE_CLUSTER));
@@ -4164,14 +4370,20 @@ static int __init vswap_init(void)
 	mutex_unlock(&swapon_mutex);
 
 	vswap_si = si;
+
+	register_sysctl_init("vm", vswap_sysctls);
+
 	pr_info("vswap: created virtual swap device (%lu pages)\n", maxpages);
 	return 0;
 
 fail:
+	pr_warn("vswap: setup_swap_clusters_info failed (%d); vswap disabled, swapout falls back to direct physical swap\n",
+		err);
+	sysctl_vswap_enabled = 0;
 	spin_lock(&swap_lock);
 	si->flags = 0;
 	spin_unlock(&swap_lock);
-	return err;
+	return 0;
 }
 late_initcall(vswap_init);
 #endif
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 17d2b793cbfc..78ec51f53757 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -68,6 +68,7 @@
 #include "internal.h"
 #include "page_alloc.h"
 #include "swap.h"
+#include "vswap.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
@@ -352,6 +353,9 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 		 */
 		if (get_nr_swap_pages() > 0)
 			return true;
+		/* vswap doesn't contribute to nr_swap_pages */
+		if (vswap_is_enabled() && zswap_is_enabled())
+			return true;
 	} else {
 		/* Is the memcg below its swap limit? */
 		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
@@ -1521,9 +1525,13 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			nr_pages = 1;
 		}
 activate_locked:
-		/* Not a candidate for swapping, so reclaim swap space. */
+		/*
+		 * Not a candidate for swapping, so reclaim physical swap
+		 * space if we are running out.
+		 */
 		if (folio_test_swapcache(folio) &&
-		    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
+		    ((mem_cgroup_swap_full(folio) && !is_vswap_entry(folio->swap)) ||
+		     folio_test_mlocked(folio)))
 			folio_free_swap(folio);
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
 		if (!folio_test_mlocked(folio)) {
@@ -2680,7 +2688,7 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
 			       struct scan_control *sc)
 {
 	/* Aging the anon LRU is valuable if swap is present: */
-	if (total_swap_pages > 0)
+	if (total_swap_pages > 0 || (vswap_is_enabled() && zswap_is_enabled()))
 		return true;
 
 	/* Also valuable if anon pages can be demoted: */
diff --git a/mm/vswap.h b/mm/vswap.h
index 5641692f5be3..6d25e0911fa9 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -10,8 +10,23 @@
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
 #ifdef CONFIG_VSWAP
 
+#include "swap_table.h"
+
 extern struct swap_info_struct *vswap_si;
 
 static inline bool is_vswap_entry(swp_entry_t entry)
@@ -19,13 +34,202 @@ static inline bool is_vswap_entry(swp_entry_t entry)
 	return swap_is_vswap(__swap_entry_to_info(entry));
 }
 
-#else
+bool vswap_is_enabled(void);
+
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
+ *   NONE      | shadow        | clear | folio evicted, no backing (bug)
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
+ * direct-mapped physical swap), since CONFIG_VSWAP requires 64BIT and
+ * SWAP_TABLE_HAS_ZEROFLAG is always true on 64-bit. Cached folios are
+ * read out of the swap_table PFN entry; there is no separate FOLIO
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
+ * Return: the locked vswap cluster, or NULL if no cluster is found for @entry.
+ */
+static inline struct swap_cluster_info_dynamic *
+vswap_lock_cluster(swp_entry_t entry, unsigned int *voff)
+{
+	struct swap_cluster_info *ci;
+	struct swap_cluster_info_dynamic *ci_dyn;
+
+	ci = __swap_entry_to_cluster(entry);
+	if (!ci)
+		return NULL;
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	*voff = swp_cluster_offset(entry);
+	spin_lock(&ci->lock);
+	return ci_dyn;
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
+	if (!ci_dyn)
+		return;
+	__vswap_release_backing(&ci_dyn->ci, voff, 1);
+	__vtable_set(ci_dyn, voff, (unsigned long)ze | VSWAP_ZSWAP);
+	spin_unlock(&ci_dyn->ci.lock);
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
+	spin_unlock(&ci_dyn->ci.lock);
+
+	if (vtable_type(vt) != VSWAP_ZSWAP)
+		return NULL;
+	return vtable_to_zswap(vt);
+}
+
+void folio_release_vswap_backing(struct folio *folio);
+
+static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info_dynamic *ci_dyn)
+{
+	ci_dyn->virtual_table = kcalloc(SWAPFILE_CLUSTER,
+					sizeof(*ci_dyn->virtual_table),
+					GFP_ATOMIC);
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
+#else /* !CONFIG_VSWAP */
 
 static inline bool is_vswap_entry(swp_entry_t entry)
 {
 	return false;
 }
 
+static inline bool vswap_is_enabled(void) { return false; }
+
+static inline void __vswap_release_backing(struct swap_cluster_info *ci,
+					   unsigned int ci_start,
+					   unsigned int nr) {}
+
+static inline void vswap_zswap_store(swp_entry_t entry,
+				     struct zswap_entry *ze) {}
+
+static inline struct zswap_entry *vswap_zswap_load(swp_entry_t entry)
+{
+	return NULL;
+}
+
+static inline void folio_release_vswap_backing(struct folio *folio) {}
+
+static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info_dynamic *ci_dyn)
+{
+	return 0;
+}
+
+static inline void vswap_cluster_free_vtable(struct swap_cluster_info *ci) {}
+
 #endif /* CONFIG_VSWAP */
 
 #endif /* _MM_VSWAP_H */
diff --git a/mm/zswap.c b/mm/zswap.c
index 354bf8bd7482..e19bde9df722 100644
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
@@ -1290,6 +1313,9 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
+	if (vswap_is_enabled())
+		return -ENOENT;
+
 	/*
 	 * Skip zombies because their LRUs are reparented and we would be
 	 * reclaiming from the parent instead of the dead memcg.
@@ -1418,9 +1444,7 @@ static bool zswap_store_page(struct page *page,
 	if (!zswap_compress(page, entry, pool))
 		goto compress_failed;
 
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
+	old = zswap_entry_store(page_swpentry, entry);
 	if (xa_is_err(old)) {
 		int err = xa_err(old);
 
@@ -1489,7 +1513,7 @@ bool zswap_store(struct folio *folio)
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
 	bool ret = false;
-	long index;
+	long index = 0;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1544,13 +1568,19 @@ bool zswap_store(struct folio *folio)
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
@@ -1590,8 +1620,7 @@ bool zswap_store(struct folio *folio)
 int zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
-	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
+	struct swap_info_struct *si = __swap_entry_to_info(swp);
 	struct zswap_entry *entry;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
@@ -1610,7 +1639,7 @@ int zswap_load(struct folio *folio)
 		return -EINVAL;
 	}
 
-	entry = xa_load(tree, offset);
+	entry = zswap_entry_load(swp);
 	if (!entry)
 		return -ENOENT;
 
@@ -1633,8 +1662,13 @@ int zswap_load(struct folio *folio)
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

