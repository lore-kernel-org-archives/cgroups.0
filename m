Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF2B3955D0
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041781; cv=none; b=I7kDcdpKcK4l4vhW2kpvUWuasvmNbSRSHwKqqf1mUfA6rJssVFBcr/YClceHFRd2mKV9Ax8M7X05uKym4PKWJcOa5CznuzMhRr1KxPrJNMQJPCNfyiqCODDFdOcbSp6+p0MekHg6kCvGHdVifS4usyfLbXdvy14v+FtOgWj4ii0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041781; c=relaxed/simple;
	bh=7WjEpUVtPDvbIdTqUuJtxvkGmoaHNOoPwe8qjG6fx5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVmojPZh0WQ7GgSZhQb3i8RGTjzmH4NLwXvZ4Ro45ovD0WJrJjAkm6X7vRfwmH3gdup2b2Zc8uNIfsQU5oVIWJ3o4e/nHLXU7Nt7NL7QNQ6A32tSVJbEJGwUeJ/QgHWv0P3n10nyDjBJhHLWqDpViYpAK3z6fVEp/3ADRaCOmNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kt3y3RLb; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kt3y3RLb"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6b017a4ce38so564983eaf.0
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 11:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041777; x=1786646577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Z8Rr4fXv8HnfyepjCtSg1DMwHI70e7GbioRfg7aAs4=;
        b=Kt3y3RLbvBvNmovlTqVSsbimUzMjZrzkxC4QFiPgJjBC/6ipMsW8jJvySmZaWgr1RW
         2P+gnh0ngizmEMYzXN29/83srXslR3ZnlJAZJ5GrA9Ehpf2NDlK87pd1f4ScLENa33Ci
         MkYHnOMjFSPBy1V6xgxO5OTDzPoSm+httiYNJtmgoowfibZq24fy8z93LkHlDt5Xz6gU
         hjeoAFLiJOprFQ98vMQfwd+rAu6zph+jF/2/0dNh5gHjez2zb0KL1w1I2RClVVQVlfQP
         rau6w4RO5mKzq0I0OHyktcnpEAFDRTaRZ0pW2AZD+7HnsOTGiKfTHQFz0npB0etdEsdU
         qzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041777; x=1786646577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7Z8Rr4fXv8HnfyepjCtSg1DMwHI70e7GbioRfg7aAs4=;
        b=Ks16bbX9rxNgG7V850Qt2o9kgWgRCY/BwFqocnyPJ7D0PMIaYfIh6Zh3ouzZLjtokT
         va9EgszCA/vsNnEylZ0KYvMQxCz5od413e5V10Pt42nZ2eq9udmb6IWPLX2AkqL3H7Y7
         i7K94REPWbgGlYRIDmed2xKXscv9OnP+gxjo5PilT05n0EJ3QecOyy1rJ8whzpIQA7gi
         dKOHcrUK8OxkQfaNB1bdgLV9vNjWIxaTnEjjbmv3rf9akJn5lD/qN8f0W3RvIrWpIEsk
         mbkuLj46JTgQw55H4aJXVhQDE/bHXsAZ8TjFymCIJvdl0iY6jmyfajiMcgiYZigWAzBQ
         jVnQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr6OmtCjsyFW3TAigviQW+VZtawo3uMo1iYxD/xJM4V0+UYmCLGC9nuA19XsO69b+cZPD6U89SK@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2CGKU1z2z6H8xMyhSLu4Y+EcJjGMShx6wx3RnyhaUpohHl/Qp
	cnf/jI5qD7L0dbaDTad0pJzxTPquhjvtamihCw83oe9Y/hgGFOYmdcEjgU+jLDCp
X-Gm-Gg: AR+sD10ZCt5nAkAZLVH6VNtKIFlS/P6rFZtM8WH5V50pULbWAlmfWSKQZ6hInHjV9a2
	RhT6mozVYITDE+fsft2txBvBZaAcDAnMxOpKv34eXac8uZCOeFTrBi9eg4hhOHZelTF6f6dmPwn
	ks64kn1XjwNIQmN0oxmMlkXG9qMsTKIogwcfiWkaV2f5SaY4bqCPbQH3sKF8giMEHG8KgTjQTM2
	6YGvR3BYQjD6P67jwkHOric2uq8Pu4ddZI+yQqlcyofo1HRh1HRQ1Bmt0F3BftZJxQSkh1/jGsN
	6CE0v1wCHVSmiA+Boy9MZ2s/4/U7isEY7oSlIplXkx1lin7/DMuquke5emvxKhL9lsUrrPFJ1g2
	5yQFwHIUxozA3TM0W1NAH7qOPRNiDYfE0q39y4g4clnNRYA0XwM9ZbRDT6rKQZr+iHDzVBSeiBK
	9rzQa6GnvOhPa3C+RXWKeQeffP2tWdka6Pr2P0vPgz6dXjltTNeyDhetmn6uX28Rs9KP6lryoMf
	eVPvVpDoEi0vXHXw4uiNg==
X-Received: by 2002:a05:6820:4b8e:b0:6a1:4a27:cd22 with SMTP id 006d021491bc7-6ae968d0ddbmr9679694eaf.0.1786041777343;
        Thu, 06 Aug 2026 11:42:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:21::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02be475b6sm166741eaf.11.2026.08.06.11.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:42:56 -0700 (PDT)
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
Subject: [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
Date: Thu,  6 Aug 2026 11:42:44 -0700
Message-ID: <20260806184254.3790858-2-nphamcs@gmail.com>
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

Create a 16 TB virtual swap device at boot, along with the dynamic
cluster infrastructure that the rest of the vswap layer is built on.
swap_cluster_info_dynamic keeps per-cluster info in an xarray, so a
device can be sized without a static cluster_info[] array.

Gated by a new CONFIG_VSWAP (depends on SWAP && 64BIT). For now the
vswap device cannot be swapon'd or swapoff'd. It is created
unconditionally at boot when CONFIG_VSWAP=y and lives for the
lifetime of the kernel. The SWP_VSWAP flag and swap_is_vswap()
helper let hot paths skip per-device bookkeeping that doesn't
apply (avail-list management, percpu_ref get/put, hibernation
target lookup, etc.).

This patch is pure scaffolding. It wires the dynamic-cluster
allocator into cluster_alloc_swap_entry (via an SWP_VSWAP branch
that dispatches to alloc_swap_scan_dynamic), but the branch is
not yet reachable because vswap_si is kept off swap_avail_head
and swap_active_head and folio_alloc_swap has no path that calls
into vswap_si directly. Backends (zswap, zero, physical disk)
and the vswap-aware swap-out / swap-in / writeback paths arrive
in subsequent patches.

Suggested-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 MAINTAINERS          |   1 +
 include/linux/swap.h |  16 +++
 mm/Kconfig           |  10 ++
 mm/page_io.c         |  15 +++
 mm/swap.h            |  47 ++++++--
 mm/swap_state.c      |  41 ++++---
 mm/swap_table.h      |   2 +
 mm/swapfile.c        | 270 +++++++++++++++++++++++++++++++++++++++----
 mm/vswap.h           |  31 +++++
 mm/zswap.c           |   6 +
 10 files changed, 396 insertions(+), 43 deletions(-)
 create mode 100644 mm/vswap.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e9c8567308a7..d0da9a29a910 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17248,6 +17248,7 @@ F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
 F:	mm/swapfile.c
+F:	mm/vswap.h
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 45f301d73e2a..a955bd60dd58 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -207,6 +207,7 @@ enum {
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
+	SWP_VSWAP	= (1 << 14),	/* virtual swap device */
 					/* add others here before... */
 };
 
@@ -276,8 +277,21 @@ struct swap_info_struct {
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
 	const struct swap_ops *ops;
+	struct xarray cluster_info_pool; /* Xarray for vswap dynamic cluster info */
 };
 
+#ifdef CONFIG_VSWAP
+static inline bool swap_is_vswap(struct swap_info_struct *si)
+{
+	return si->flags & SWP_VSWAP;
+}
+#else
+static inline bool swap_is_vswap(struct swap_info_struct *si)
+{
+	return false;
+}
+#endif
+
 static inline swp_entry_t page_swap_entry(struct page *page)
 {
 	struct folio *folio = page_folio(page);
@@ -402,6 +416,8 @@ void swap_free_hibernation_slot(swp_entry_t entry);
 
 static inline void put_swap_device(struct swap_info_struct *si)
 {
+	if (swap_is_vswap(si))
+		return;
 	percpu_ref_put(&si->users);
 }
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 331daf7fcfab..32d38b552845 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -19,6 +19,16 @@ menuconfig SWAP
 	  used to provide more virtual memory than the actual RAM present
 	  in your computer.  If unsure say Y.
 
+config VSWAP
+	bool "Virtual swap device"
+	depends on SWAP && 64BIT
+	help
+	  Adds a virtual swap layer that decouples swap entries in page
+	  tables from physical backing storage. Swap entries are allocated
+	  from a virtual swap device and can be backed by zswap, a physical
+	  swapfile, or kept in memory - with the backing changeable at
+	  runtime without invalidating page table entries.
+
 config ZSWAP
 	bool "Compressed cache for swap pages"
 	depends on SWAP
diff --git a/mm/page_io.c b/mm/page_io.c
index e4fa7ffffe8b..fca1718056af 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -27,6 +27,7 @@
 #include <linux/zswap.h>
 #include "swap.h"
 #include "swap_table.h"
+#include "vswap.h"
 
 int generic_swapfile_activate(struct swap_info_struct *sis,
 				struct file *swap_file,
@@ -247,6 +248,15 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	}
 	rcu_read_unlock();
 
+	/*
+	 * A vswap folio that reaches here could not be stored to a backend
+	 * (zswap) and has no physical slot to write to, so keep it dirty.
+	 */
+	if (is_vswap_entry(folio->swap)) {
+		folio_mark_dirty(folio);
+		return AOP_WRITEPAGE_ACTIVATE;
+	}
+
 	__swap_writepage(ctx, folio);
 	return 0;
 out_unlock:
@@ -479,6 +489,11 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	if (zswap_load(folio) != -ENOENT)
 		goto finish;
 
+	if (unlikely(swap_is_vswap(sis))) {
+		folio_unlock(folio);
+		goto finish;
+	}
+
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 	swap_add_folio(ctx, folio, READ);
diff --git a/mm/swap.h b/mm/swap.h
index ec580c713204..b593ad3214ef 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -66,6 +66,12 @@ struct swap_cluster_info {
 	struct list_head list;
 };
 
+struct swap_cluster_info_dynamic {
+	struct swap_cluster_info ci;
+	unsigned int index;		/* for cluster_index() */
+	struct rcu_head rcu;
+};
+
 /* All on-list cluster must have a non-zero flag. */
 enum swap_cluster_flags {
 	CLUSTER_FLAG_NONE = 0, /* For temporary off-list cluster */
@@ -76,6 +82,7 @@ enum swap_cluster_flags {
 	CLUSTER_FLAG_USABLE = CLUSTER_FLAG_FRAG,
 	CLUSTER_FLAG_FULL,
 	CLUSTER_FLAG_DISCARD,
+	CLUSTER_FLAG_DEAD,	/* Vswap dynamic cluster pending kfree_rcu */
 	CLUSTER_FLAG_MAX,
 };
 
@@ -143,9 +150,19 @@ static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
 static inline struct swap_cluster_info *__swap_offset_to_cluster(
 		struct swap_info_struct *si, pgoff_t offset)
 {
+	unsigned int cluster_idx = offset / SWAPFILE_CLUSTER;
+
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 	VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));
-	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
+
+	if (swap_is_vswap(si)) {
+		struct swap_cluster_info_dynamic *ci_dyn;
+
+		ci_dyn = xa_load(&si->cluster_info_pool, cluster_idx);
+		return ci_dyn ? &ci_dyn->ci : NULL;
+	}
+
+	return &si->cluster_info[cluster_idx];
 }
 
 static inline struct swap_cluster_info *__swap_entry_to_cluster(swp_entry_t entry)
@@ -157,7 +174,7 @@ static inline struct swap_cluster_info *__swap_entry_to_cluster(swp_entry_t entr
 static __always_inline struct swap_cluster_info *__swap_cluster_lock(
 		struct swap_info_struct *si, unsigned long offset, bool irq)
 {
-	struct swap_cluster_info *ci = __swap_offset_to_cluster(si, offset);
+	struct swap_cluster_info *ci;
 
 	/*
 	 * Nothing modifies swap cache in an IRQ context. All access to
@@ -170,20 +187,36 @@ static __always_inline struct swap_cluster_info *__swap_cluster_lock(
 	 */
 	VM_WARN_ON_ONCE(!in_task());
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
-	if (irq)
-		spin_lock_irq(&ci->lock);
-	else
-		spin_lock(&ci->lock);
+
+	rcu_read_lock();
+	ci = __swap_offset_to_cluster(si, offset);
+	if (ci) {
+		if (irq)
+			spin_lock_irq(&ci->lock);
+		else
+			spin_lock(&ci->lock);
+
+		if (ci->flags == CLUSTER_FLAG_DEAD) {
+			if (irq)
+				spin_unlock_irq(&ci->lock);
+			else
+				spin_unlock(&ci->lock);
+			ci = NULL;
+		}
+	}
+	rcu_read_unlock();
 	return ci;
 }
 
 /**
  * swap_cluster_lock - Lock and return the swap cluster of given offset.
  * @si: swap device the cluster belongs to.
- * @offset: the swap entry offset, pointing to a valid slot.
+ * @offset: the swap entry offset.
  *
  * Context: The caller must ensure the offset is in the valid range and
  * protect the swap device with reference count or locks.
+ * Return: the locked cluster, or NULL if it is gone. Only a vswap device
+ * can return NULL, as its clusters are allocated and freed on demand.
  */
 static inline struct swap_cluster_info *swap_cluster_lock(
 		struct swap_info_struct *si, unsigned long offset)
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5be825911e64..9e0d71fcdc24 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -95,8 +95,10 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
 	struct folio *folio;
 
 	for (;;) {
+		rcu_read_lock();
 		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
 					swp_cluster_offset(entry));
+		rcu_read_unlock();
 		if (!swp_tb_is_folio(swp_tb))
 			return NULL;
 		folio = swp_tb_to_folio(swp_tb);
@@ -118,8 +120,10 @@ bool swap_cache_has_folio(swp_entry_t entry)
 {
 	unsigned long swp_tb;
 
+	rcu_read_lock();
 	swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
 				swp_cluster_offset(entry));
+	rcu_read_unlock();
 	return swp_tb_is_folio(swp_tb);
 }
 
@@ -135,8 +139,10 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 {
 	unsigned long swp_tb;
 
+	rcu_read_lock();
 	swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
 				swp_cluster_offset(entry));
+	rcu_read_unlock();
 	if (swp_tb_is_shadow(swp_tb))
 		return swp_tb_to_shadow(swp_tb);
 	return NULL;
@@ -405,14 +411,16 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
  * -ENOENT / -EEXIST: Target swap entry is unavailable or cached, the caller
  *                    should abort or try to use the cached folio instead
  */
-static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
-					swp_entry_t targ_entry, gfp_t gfp,
+static struct folio *__swap_cache_alloc(swp_entry_t targ_entry, gfp_t gfp,
 					unsigned int order, struct vm_fault *vmf,
 					struct mempolicy *mpol, pgoff_t ilx)
 {
 	int err;
 	swp_entry_t entry;
 	struct folio *folio;
+	struct swap_cluster_info *ci;
+	struct swap_info_struct *si = __swap_entry_to_info(targ_entry);
+	unsigned long offset = swp_offset(targ_entry);
 	void *shadow = NULL;
 	unsigned short memcg_id;
 	unsigned long address, nr_pages = 1UL << order;
@@ -422,9 +430,12 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	entry.val = round_down(targ_entry.val, nr_pages);
 
 	/* Check if the slot and range are available, skip allocation if not */
-	spin_lock(&ci->lock);
-	err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL, NULL);
-	spin_unlock(&ci->lock);
+	err = -ENOENT;
+	ci = swap_cluster_lock(si, offset);
+	if (ci) {
+		err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL, NULL);
+		swap_cluster_unlock(ci);
+	}
 	if (unlikely(err))
 		return ERR_PTR(err);
 
@@ -445,10 +456,13 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 		return ERR_PTR(-ENOMEM);
 
 	/* Double check the range is still not in conflict */
-	spin_lock(&ci->lock);
-	err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow, &memcg_id);
+	err = -ENOENT;
+	ci = swap_cluster_lock(si, offset);
+	if (ci)
+		err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow, &memcg_id);
 	if (unlikely(err)) {
-		spin_unlock(&ci->lock);
+		if (ci)
+			swap_cluster_unlock(ci);
 		folio_put(folio);
 		return ERR_PTR(err);
 	}
@@ -456,13 +470,14 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 	__swap_cache_do_add_folio(ci, folio, entry);
-	spin_unlock(&ci->lock);
+	swap_cluster_unlock(ci);
 
 	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
 					   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
-		spin_lock(&ci->lock);
+		/* The folio pins the cluster */
+		ci = swap_cluster_lock(si, offset);
 		__swap_cache_do_del_folio(ci, folio, entry, shadow);
-		spin_unlock(&ci->lock);
+		swap_cluster_unlock(ci);
 		folio_unlock(folio);
 		/* nr_pages refs from swap cache, 1 from allocation */
 		folio_put_refs(folio, nr_pages + 1);
@@ -516,9 +531,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 {
 	int order, err;
 	struct folio *ret;
-	struct swap_cluster_info *ci;
 
-	ci = __swap_entry_to_cluster(targ_entry);
 	order = highest_order(orders);
 
 	/* orders must be non-zero, and must not exceed cluster size. */
@@ -526,7 +539,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 		return ERR_PTR(-EINVAL);
 
 	do {
-		ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
+		ret = __swap_cache_alloc(targ_entry, gfp, order,
 					 vmf, mpol, ilx);
 		if (!IS_ERR(ret))
 			break;
diff --git a/mm/swap_table.h b/mm/swap_table.h
index e6613e62f8d0..fd7f0fb9836a 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -255,6 +255,8 @@ static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
 	unsigned long swp_tb;
 
 	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
+	if (!ci)
+		return SWP_TB_NULL;
 
 	rcu_read_lock();
 	table = rcu_dereference(ci->table);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4d4e3e3059f6..fea3a8eccbc1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,10 +42,12 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/major.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
 #include "swap_table.h"
+#include "vswap.h"
 #include "internal.h"
 #include "swap.h"
 
@@ -401,6 +403,8 @@ static inline bool cluster_is_usable(struct swap_cluster_info *ci, int order)
 static inline unsigned int cluster_index(struct swap_info_struct *si,
 					 struct swap_cluster_info *ci)
 {
+	if (swap_is_vswap(si))
+		return container_of(ci, struct swap_cluster_info_dynamic, ci)->index;
 	return ci - si->cluster_info;
 }
 
@@ -712,6 +716,34 @@ static void swap_users_ref_free(struct percpu_ref *ref)
 	complete(&si->comp);
 }
 
+#ifdef CONFIG_VSWAP
+static void vswap_free_cluster(struct swap_info_struct *si,
+			       struct swap_cluster_info *ci)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	if (ci->flags != CLUSTER_FLAG_NONE) {
+		spin_lock(&si->lock);
+		list_del(&ci->list);
+		spin_unlock(&si->lock);
+	}
+	swap_cluster_free_table(ci);
+	/*
+	 * Ordering vs the RCU cluster lookup: erase from the xarray first
+	 * (new lookups miss it), mark DEAD under the held ci->lock (a lookup
+	 * that already has ci sees DEAD on relock and bails), then kfree_rcu
+	 * so the cluster outlives any reader still in its RCU section.
+	 */
+	xa_erase(&si->cluster_info_pool, ci_dyn->index);
+	ci->flags = CLUSTER_FLAG_DEAD;
+	kfree_rcu(ci_dyn, rcu);
+}
+#else
+static inline void vswap_free_cluster(struct swap_info_struct *si,
+				      struct swap_cluster_info *ci) {}
+#endif
+
 /*
  * Must be called after freeing if ci->count == 0, moves the cluster to free
  * or discard list.
@@ -733,6 +765,11 @@ static void free_cluster(struct swap_info_struct *si, struct swap_cluster_info *
 		return;
 	}
 
+	if (swap_is_vswap(si)) {
+		vswap_free_cluster(si, ci);
+		return;
+	}
+
 	__free_cluster(si, ci);
 }
 
@@ -835,14 +872,21 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
  * stolen by a lower order). @usable will be set to false if that happens.
  */
 static bool cluster_reclaim_range(struct swap_info_struct *si,
-				  struct swap_cluster_info *ci,
+				  struct swap_cluster_info **pcip,
 				  unsigned long start, unsigned int order,
 				  bool *usable)
 {
+	struct swap_cluster_info *ci = *pcip;
 	unsigned int nr_pages = 1 << order;
 	unsigned long offset = start, end = start + nr_pages;
 	unsigned long swp_tb;
 
+	/*
+	 * Take RCU read lock before releasing the cluster lock to keep ci
+	 * alive - for vswap dynamic clusters, ci is freed via kfree_rcu
+	 * and the grace period could otherwise elapse in the window.
+	 */
+	rcu_read_lock();
 	spin_unlock(&ci->lock);
 	do {
 		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
@@ -852,7 +896,15 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 			if (__try_to_reclaim_swap(si, offset, TTRS_ANYWAY) < 0)
 				break;
 	} while (++offset < end);
-	spin_lock(&ci->lock);
+	rcu_read_unlock();
+
+	/* Re-lookup: dynamic cluster may have been freed while lock was dropped */
+	ci = swap_cluster_lock(si, start);
+	*pcip = ci;
+	if (!ci) {
+		*usable = false;
+		return false;
+	}
 
 	/*
 	 * We just dropped ci->lock so cluster could be used by another
@@ -983,7 +1035,8 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
 			continue;
 		if (need_reclaim) {
-			ret = cluster_reclaim_range(si, ci, offset, order, &usable);
+			ret = cluster_reclaim_range(si, &ci, offset, order,
+						    &usable);
 			if (!usable)
 				goto out;
 			if (cluster_is_empty(ci))
@@ -1001,8 +1054,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 		break;
 	}
 out:
-	relocate_cluster(si, ci);
-	swap_cluster_unlock(ci);
+	if (ci) {
+		relocate_cluster(si, ci);
+		swap_cluster_unlock(ci);
+	}
 	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(percpu_swap_cluster.offset[order], next);
 		this_cpu_write(percpu_swap_cluster.si[order], si);
@@ -1034,6 +1089,41 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	return found;
 }
 
+static unsigned int alloc_swap_scan_dynamic(struct swap_info_struct *si,
+					    struct folio *folio)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *ci;
+	unsigned long offset;
+
+	VM_WARN_ON(!swap_is_vswap(si));
+
+	ci_dyn = kzalloc_obj(*ci_dyn, GFP_ATOMIC);
+	if (!ci_dyn)
+		return SWAP_ENTRY_INVALID;
+
+	spin_lock_init(&ci_dyn->ci.lock);
+	INIT_LIST_HEAD(&ci_dyn->ci.list);
+
+	if (swap_cluster_alloc_table(&ci_dyn->ci, GFP_ATOMIC)) {
+		kfree(ci_dyn);
+		return SWAP_ENTRY_INVALID;
+	}
+
+	if (xa_alloc(&si->cluster_info_pool, &ci_dyn->index, ci_dyn,
+		     XA_LIMIT(1, DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER) - 1),
+		     GFP_ATOMIC)) {
+		swap_cluster_free_table(&ci_dyn->ci);
+		kfree(ci_dyn);
+		return SWAP_ENTRY_INVALID;
+	}
+
+	ci = &ci_dyn->ci;
+	spin_lock(&ci->lock);
+	offset = cluster_offset(si, ci);
+	return alloc_swap_scan_cluster(si, ci, folio, offset);
+}
+
 static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 {
 	long to_scan = 1;
@@ -1056,7 +1146,9 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
-				spin_lock(&ci->lock);
+				ci = swap_cluster_lock(si, offset);
+				if (!ci)
+					goto next;
 				if (nr_reclaim) {
 					offset += abs(nr_reclaim);
 					continue;
@@ -1070,6 +1162,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 			relocate_cluster(si, ci);
 
 		swap_cluster_unlock(ci);
+next:
 		if (to_scan <= 0)
 			break;
 
@@ -1146,6 +1239,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 
+	if (swap_is_vswap(si)) {
+		found = alloc_swap_scan_dynamic(si, folio);
+		if (found)
+			goto done;
+	}
+
 	if (!(si->flags & SWP_PAGE_DISCARD)) {
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
@@ -1264,6 +1363,13 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 			goto skip;
 	}
 
+	/*
+	 * Keep vswap off the avail list - it is not allocated from by
+	 * the physical swap allocator (swap_alloc_fast/slow).
+	 */
+	if (swap_is_vswap(si))
+		goto skip;
+
 	plist_add(&si->avail_list, &swap_avail_head);
 
 skip:
@@ -1280,10 +1386,10 @@ static bool swap_usage_add(struct swap_info_struct *si, unsigned int nr_entries)
 	long val = atomic_long_add_return_relaxed(nr_entries, &si->inuse_pages);
 
 	/*
-	 * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
-	 * remove it from the plist.
+	 * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set, remove it
+	 * from the plist. Vswap is never on the avail list, so skip it.
 	 */
-	if (unlikely(val == si->pages)) {
+	if (unlikely(val == si->pages) && !swap_is_vswap(si)) {
 		del_from_avail_list(si, false);
 		return true;
 	}
@@ -1296,10 +1402,10 @@ static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
 	long val = atomic_long_sub_return_relaxed(nr_entries, &si->inuse_pages);
 
 	/*
-	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
-	 * add it to the plist.
+	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set, add it to
+	 * the plist. Vswap is never on the avail list, so skip it.
 	 */
-	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
+	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT) && !swap_is_vswap(si))
 		add_to_avail_list(si, false);
 }
 
@@ -1346,6 +1452,10 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 
 static bool get_swap_device_info(struct swap_info_struct *si)
 {
+	/* vswap device is always alive - no ref counting needed */
+	if (swap_is_vswap(si))
+		return true;
+
 	if (!percpu_ref_tryget_live(&si->users))
 		return false;
 	/*
@@ -1381,11 +1491,11 @@ static bool swap_alloc_fast(struct folio *folio)
 		return false;
 
 	ci = swap_cluster_lock(si, offset);
-	if (cluster_is_usable(ci, order)) {
+	if (ci && cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
 		alloc_swap_scan_cluster(si, ci, folio, offset);
-	} else {
+	} else if (ci) {
 		swap_cluster_unlock(ci);
 	}
 
@@ -1507,6 +1617,7 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 	if (!si)
 		return 0;
 
+	/* Entry is in use (being faulted in), so its cluster is alive. */
 	ci = __swap_offset_to_cluster(si, offset);
 	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), gfp);
 
@@ -1742,6 +1853,7 @@ int folio_alloc_swap(struct folio *folio)
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
 
+	VM_WARN_ON_FOLIO(folio_test_swapcache(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
@@ -1904,7 +2016,8 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 put_out:
 	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
-	percpu_ref_put(&si->users);
+	if (!swap_is_vswap(si))
+		percpu_ref_put(&si->users);
 	return NULL;
 }
 
@@ -2036,6 +2149,7 @@ static bool folio_maybe_swapped(struct folio *folio)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
+	/* Folio is locked and in swap cache, so ci->count > 0: cluster is alive. */
 	ci = __swap_entry_to_cluster(entry);
 	ci_off = swp_cluster_offset(entry);
 	ci_end = ci_off + folio_nr_pages(folio);
@@ -2223,6 +2337,9 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		/* vswap has no bdev - never a hibernation target */
+		if (swap_is_vswap(sis))
+			continue;
 
 		if (device == sis->bdev->bd_dev) {
 			struct swap_extent *se = first_se(sis);
@@ -2349,6 +2466,9 @@ int find_first_swap(dev_t *device)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		/* vswap has no bdev - never a hibernation target */
+		if (swap_is_vswap(sis))
+			continue;
 		*device = sis->bdev->bd_dev;
 		spin_unlock(&swap_lock);
 		return type;
@@ -2565,8 +2685,10 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 						&vmf);
 		}
 		if (!folio) {
+			rcu_read_lock();
 			swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
 						swp_cluster_offset(entry));
+			rcu_read_unlock();
 			if (swp_tb_get_count(swp_tb) <= 0)
 				continue;
 			return -ENOMEM;
@@ -2712,8 +2834,10 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	 * allocations from this area (while holding swap_lock).
 	 */
 	for (i = prev + 1; i < si->max; i++) {
+		rcu_read_lock();
 		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
 					i % SWAPFILE_CLUSTER);
+		rcu_read_unlock();
 		if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
 			break;
 		if ((i % LATENCY_LIMIT) == 0)
@@ -2952,6 +3076,11 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	struct inode *inode = mapping->host;
 	int ret;
 
+	if (swap_is_vswap(sis)) {
+		*span = 0;
+		return 0;
+	}
+
 	ret = sio_pool_init();
 	if (ret)
 		return ret;
@@ -2977,15 +3106,24 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 
 static void _enable_swap_info(struct swap_info_struct *si)
 {
-	atomic_long_add(si->pages, &nr_swap_pages);
-	total_swap_pages += si->pages;
+	if (!swap_is_vswap(si)) {
+		atomic_long_add(si->pages, &nr_swap_pages);
+		total_swap_pages += si->pages;
+	}
 
 	assert_spin_locked(&swap_lock);
 
-	plist_add(&si->list, &swap_active_head);
+	/*
+	 * Vswap has no backing file and no swapoff support - keep it
+	 * off swap_active_head (used by swapoff filename lookup and
+	 * swap_sync_discard) and swap_avail_head (physical allocator).
+	 */
+	if (!swap_is_vswap(si)) {
+		plist_add(&si->list, &swap_active_head);
 
-	/* Add back to available list */
-	add_to_avail_list(si, true);
+		/* Add back to available list */
+		add_to_avail_list(si, true);
+	}
 }
 
 /*
@@ -3022,6 +3160,8 @@ static void wait_for_allocation(struct swap_info_struct *si)
 	struct swap_cluster_info *ci;
 
 	BUG_ON(si->flags & SWP_WRITEOK);
+	if (swap_is_vswap(si))
+		return;
 
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = swap_cluster_lock(si, offset);
@@ -3528,10 +3668,43 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 				    unsigned long maxpages)
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
-	struct swap_cluster_info *cluster_info;
+	struct swap_cluster_info *cluster_info = NULL;
+	struct swap_cluster_info_dynamic *ci_dyn;
 	int err = -ENOMEM;
 	unsigned long i;
 
+	/* For SWP_VSWAP files, initialize Xarray pool instead of static array */
+	if (swap_is_vswap(si)) {
+		/*
+		 * Pre-allocate cluster 0 and mark slot 0 (header page)
+		 * as bad so the allocator never hands out page offset 0.
+		 */
+		ci_dyn = kzalloc_obj(*ci_dyn, GFP_KERNEL);
+		if (!ci_dyn)
+			goto err;
+		spin_lock_init(&ci_dyn->ci.lock);
+		INIT_LIST_HEAD(&ci_dyn->ci.list);
+
+		nr_clusters = 0;
+		xa_init_flags(&si->cluster_info_pool, XA_FLAGS_ALLOC);
+		err = xa_insert(&si->cluster_info_pool, 0, ci_dyn, GFP_KERNEL);
+		if (err) {
+			kfree(ci_dyn);
+			goto err;
+		}
+
+		err = swap_cluster_setup_bad_slot(si, &ci_dyn->ci, 0, false);
+		if (err) {
+			xa_erase(&si->cluster_info_pool, 0);
+			swap_cluster_free_table(&ci_dyn->ci);
+			kfree(ci_dyn);
+			xa_destroy(&si->cluster_info_pool);
+			goto err;
+		}
+
+		goto setup_cluster_info;
+	}
+
 	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
 	if (!cluster_info)
 		goto err;
@@ -3556,6 +3729,10 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
 	if (err)
 		goto err;
+
+	if (!swap_header)
+		goto setup_cluster_info;
+
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 
@@ -3575,6 +3752,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 			goto err;
 	}
 
+setup_cluster_info:
 	INIT_LIST_HEAD(&si->free_clusters);
 	INIT_LIST_HEAD(&si->full_clusters);
 	INIT_LIST_HEAD(&si->discard_clusters);
@@ -3611,7 +3789,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	struct dentry *dentry;
 	int prio;
 	int error;
-	union swap_header *swap_header;
+	union swap_header *swap_header = NULL;
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
@@ -3949,3 +4127,51 @@ static int __init swapfile_init(void)
 	return 0;
 }
 subsys_initcall(swapfile_init);
+
+#ifdef CONFIG_VSWAP
+struct swap_info_struct *vswap_si;
+
+/* vswap does no IO on its own. */
+static const struct swap_ops vswap_ops = { };
+
+static int __init vswap_init(void)
+{
+	struct swap_info_struct *si;
+	unsigned long maxpages;
+	int err;
+
+	si = alloc_swap_info();
+	if (IS_ERR(si))
+		return PTR_ERR(si);
+
+	maxpages = min(swapfile_maximum_size,
+		       ALIGN_DOWN((unsigned long)UINT_MAX, SWAPFILE_CLUSTER));
+	si->flags |= SWP_VSWAP | SWP_SOLIDSTATE | SWP_WRITEOK;
+	si->ops = &vswap_ops;
+	si->bdev = NULL;
+	si->max = maxpages;
+	si->pages = maxpages - 1;
+	si->prio = SHRT_MAX;
+	si->list.prio = -si->prio;
+	si->avail_list.prio = -si->prio;
+
+	err = setup_swap_clusters_info(si, NULL, maxpages);
+	if (err)
+		goto fail;
+
+	mutex_lock(&swapon_mutex);
+	enable_swap_info(si);
+	mutex_unlock(&swapon_mutex);
+
+	vswap_si = si;
+	pr_info("vswap: created virtual swap device (%lu pages)\n", maxpages);
+	return 0;
+
+fail:
+	spin_lock(&swap_lock);
+	si->flags = 0;
+	spin_unlock(&swap_lock);
+	return err;
+}
+late_initcall(vswap_init);
+#endif
diff --git a/mm/vswap.h b/mm/vswap.h
new file mode 100644
index 000000000000..5641692f5be3
--- /dev/null
+++ b/mm/vswap.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Virtual swap space
+ *
+ * Copyright (C) 2026 Nhat Pham
+ */
+#ifndef _MM_VSWAP_H
+#define _MM_VSWAP_H
+
+#include <linux/swap.h>
+#include "swap.h"
+
+#ifdef CONFIG_VSWAP
+
+extern struct swap_info_struct *vswap_si;
+
+static inline bool is_vswap_entry(swp_entry_t entry)
+{
+	return swap_is_vswap(__swap_entry_to_info(entry));
+}
+
+#else
+
+static inline bool is_vswap_entry(swp_entry_t entry)
+{
+	return false;
+}
+
+#endif /* CONFIG_VSWAP */
+
+#endif /* _MM_VSWAP_H */
diff --git a/mm/zswap.c b/mm/zswap.c
index f7c9c89f6449..354bf8bd7482 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1000,6 +1000,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -EEXIST;
 
+	/* Vswap entries have no physical backing to write to. */
+	if (swap_is_vswap(si)) {
+		put_swap_device(si);
+		return -EINVAL;
+	}
+
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
-- 
2.53.0-Meta

