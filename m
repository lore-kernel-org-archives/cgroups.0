Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1051D37AA91
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 23:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789082831; cv=none; b=jX5ClC1QDU3eXEXSltYjxZsH6H7zXYbwM3+bcr46RhQMHCscgRhlmmN6l37qmecrtPDt/e9n4AMkFgaCxMM6evJtFk4d1jzjs3vOvJ7FN4eyJibU1E/kE9UOZCdrVp9eAwE6XU4mbYwOfkdk6XrlaVj9j4PROCmRgKrSEvkVdHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789082831; c=relaxed/simple;
	bh=K16E+1BGLKpQOPehHZJHKprtskz1nt3DqhsphIdKlEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXuiS/ZTDqt80an5WAvOPrwzIMwwDTS4X5jbfyeUUIG27bjYeHtX8X/dZEjS7PsFUMxM0N4v0eT9LliA6mKebLZ/AMxJWr/+U+OvcKy5ozW8ISA82Zk/oJcCM4eraztLJ120XtJ3JwI/Qtm/3OqgpwLnitnHJgukHAm2/ejEcKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gm4lL3Xl; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gm4lL3Xl"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4af7283bf83so193946b6e.3
        for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 16:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789082828; x=1789687628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7ZJm4fLYdssczw6fzTZ8bmtCwnn2SYTNVGp9LjVOhiU=;
        b=gm4lL3Xlo83v25SWMCz7PA0GTt3HLNwRiwnqEUAXmfZRk0tuGl9j4/YPm7y/+kDtON
         G67rjcw7CzpmUauZfgXnnSM5xaW4EZYExefLgTqmt6cPN6qaRGepnf7diYm3cKIr1puK
         fEJi/RoL4/yFcVZyIh+Fhj0BguovdH4d4LNgkR4On1+rRbVYKcRZzF0jX9EIn5f0aFNk
         vqcEEa2lroZYOFPfBAKugcMYJfZ4rUCQjNGRn/c0AtwayQd/87oieQA78WVGDwdAnI4F
         UY+/t80RcWNdy/Hr+qPD+SZYQJHNJFxA5DAHquwHUdcZPws9yDye3jKOn8kgz5iimYUs
         MzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789082828; x=1789687628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7ZJm4fLYdssczw6fzTZ8bmtCwnn2SYTNVGp9LjVOhiU=;
        b=WYR/McNckB0UYfZWrMRdlmJKd4psQGvGj7F8Cu0yejgErHd55SKmChprbpWMx501y5
         qtq26N8b66iTQ/iKg1e90G2e65fOZVXzFC7RZQo204bUWrZ+UvAJa6L3wwpD6/p7IO+4
         Qtr8K2WMkXOhC5UqNs7wfzenXbEH9yJVORCAs0dSTIswyTxCKfxJ8GhP1YruhRecIc9d
         1QdjxQgWnXXxX3AzE2v2k+V5J/VMk+d1rhI8uEGRg8CTwfmEyzYE8/PU6qxeKmfZIUa/
         V63FfczaiyJe0vgdruRQx+thEiTpSWPTNZeQ4ZkICEppnWETjK66Weyu0/+Ga/8QT4q7
         aGCw==
X-Forwarded-Encrypted: i=1; AKwUvBwBR4t5d8yhHWRG46NGWs+fEMrZda/rH7GcFQixxZCp5cKUiaCroIQocpdfLFAwaKt2MClV3lnb@vger.kernel.org
X-Gm-Message-State: AFuF++n71uQ+brsOE0hcuAKhBR9o19ufcnb6EkPkYzIGO+ot1vvnLTaW
	AGXRLtXzFunZ/p2IcjSQrX1DpsM8aQPm1xthEP5Krqm+CNyorDfYDZUi
X-Gm-Gg: AYBFou3TmlTRemaX2oFFPBlblJUQ/KCOwWHWghXlYfN4ucbwUFUv8/2ou/0O1nsERiW
	kOcmiYKHg7+YAOWcBfYl+aGSX3jsWejdB8T9iXLmfQYhOfsOGbGZdtUhYSfqzFAvdQRIzJTyNTS
	p+tL/iVd/W+S6Klo9vZPFn8sPGgqoOKOkC9Knom8jEZCywKM7ac5TYSOnNErBSzrTJznBPaLbIU
	g5m3KslWo2xpSD0vc9e4U88Mqrgl1MtK0a8syM7DRejnZTRV2dYwmElO0uo0145x/ZhtRQIYCiA
	GpQPnlvcAKaA670usQXzDdNN/lvkAdxjWLAbN5ahzX45UxmrRIT59+/8NWkCMD4oX/R388XVnLk
	avlNWyij5dyY5zGN7bjtP7FbR9AcZc8UVLAr3U48vXlDkGgGbwEDhTi4tYkuE8/OCzSuUWY3+H6
	H3aJM7gheRo/kvrYKvCtlBfWncGAyXbpAaBZSyKCf5E9++JUAeGewLe+hse6Vrqr4XnewfpZevY
	aCuiXE3BX25ilOVArFjnA==
X-Received: by 2002:a05:6808:2210:b0:4b9:e5fa:8a1e with SMTP id 5614622812f47-4c31bff4ba2mr1155293b6e.35.1789082827366;
        Thu, 10 Sep 2026 16:27:07 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4c32eb4274dsm661023b6e.1.2026.09.10.16.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 16:27:06 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: chrisl@kernel.org,
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org,
	akpm@linux-foundation.org,
	ryncsn@gmail.com,
	joshua.hahnjy@gmail.com,
	nphamcs@gmail.com
Subject: Re: Path forward for Virtualized Swap?
Date: Thu, 10 Sep 2026 16:27:04 -0700
Message-ID: <20260910232704.3364879-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
References: <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kairui,

To quantify how much we are locking in to the xarray design if we are to go
with it, I tried hacking the vmalloc array to replace the xarray, on top of
my v4 code.

I have not implemented the shrink side yet, and I have not switched from
"swap_cluster_info_dynamic" to an embedded table in the old struct
swap_cluster_info yet, but these are straightforward to extend.

I have done a simple stress test (and also fixed another issue that I
pointed out in my review on Baoquan's code in the process). Nothing has
crashed yet :)

Anyway, it's just a prototype so no need to look too closely, but as you
can see, xarray does not lock us into anything. The xarray's interaction
with swap code is well-abstracted and transparent enough that I don't think
this will be a problem :) We should land xarray version first.

---
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8df74bd2b1e1..0464e9b55413 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -169,7 +169,9 @@ static inline void mm_account_reclaimed_pages(unsigned long pages)
 #ifdef __KERNEL__

 struct address_space;
+struct swap_cluster_info_dynamic;
 struct sysinfo;
+struct vm_struct;
 struct zone;

 /*
@@ -277,7 +279,11 @@ struct swap_info_struct {
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
 	const struct swap_ops *ops;
-	struct xarray cluster_info_pool; /* Xarray for vswap dynamic cluster info */
+	struct vm_struct *cluster_info_area; /* Vswap cluster array reservation */
+	struct swap_cluster_info_dynamic *vswap_cluster_info;
+					/* Vswap cluster array, mapped on demand */
+	unsigned int nr_mapped_clusters; /* Mapped prefix of the array */
+	struct mutex cluster_grow_lock;	/* Serialize growth of the array */
 };

 static inline bool swap_is_vswap(struct swap_info_struct *si)
diff --git a/mm/swap.h b/mm/swap.h
index 10a7be3c4341..91a641a70426 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -68,8 +68,6 @@ struct swap_cluster_info {

 struct swap_cluster_info_dynamic {
 	struct swap_cluster_info ci;
-	unsigned int index;		/* for cluster_index() */
-	struct rcu_head rcu;
 	atomic_long_t *virtual_table;	/* Backing pointers for vswap slots */
 };

@@ -83,7 +81,6 @@ enum swap_cluster_flags {
 	CLUSTER_FLAG_USABLE = CLUSTER_FLAG_FRAG,
 	CLUSTER_FLAG_FULL,
 	CLUSTER_FLAG_DISCARD,
-	CLUSTER_FLAG_DEAD,	/* Vswap dynamic cluster pending kfree_rcu */
 	CLUSTER_FLAG_MAX,
 };

@@ -148,17 +145,6 @@ static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
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
@@ -168,10 +154,9 @@ static inline struct swap_cluster_info *__swap_offset_to_cluster(
 	VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));

 	if (swap_is_vswap(si)) {
-		struct swap_cluster_info_dynamic *ci_dyn;
-
-		ci_dyn = xa_load(&si->cluster_info_pool, cluster_idx);
-		return ci_dyn ? &ci_dyn->ci : NULL;
+		VM_WARN_ON_ONCE(cluster_idx >=
+				READ_ONCE(si->nr_mapped_clusters));
+		return &si->vswap_cluster_info[cluster_idx].ci;
 	}

 	return &si->cluster_info[cluster_idx];
@@ -183,32 +168,6 @@ static inline struct swap_cluster_info *__swap_entry_to_cluster(swp_entry_t entr
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
@@ -226,9 +185,6 @@ static __always_inline struct swap_cluster_info *__swap_cluster_lock(
 	VM_WARN_ON_ONCE(!in_task());
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */

-	if (swap_is_vswap(si))
-		return __vswap_cluster_lock(si, offset, irq);
-
 	ci = __swap_offset_to_cluster(si, offset);
 	if (irq)
 		spin_lock_irq(&ci->lock);
@@ -244,8 +200,7 @@ static __always_inline struct swap_cluster_info *__swap_cluster_lock(
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
index 479814d19f50..645edcb29b2e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -451,12 +451,9 @@ static struct folio *__swap_cache_alloc(swp_entry_t targ_entry, gfp_t gfp,
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

@@ -477,13 +474,10 @@ static struct folio *__swap_cache_alloc(swp_entry_t targ_entry, gfp_t gfp,
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
@@ -495,7 +489,6 @@ static struct folio *__swap_cache_alloc(swp_entry_t targ_entry, gfp_t gfp,

 	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
 					   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
-		/* The folio pins the cluster */
 		ci = swap_cluster_lock(si, offset);
 		__swap_cache_do_del_folio(ci, folio, entry, shadow);
 		swap_cluster_unlock(ci);
diff --git a/mm/swap_table.h b/mm/swap_table.h
index 034da3546ef0..3bddea7dbe33 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -257,8 +257,6 @@ static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
 	unsigned long swp_tb;

 	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
-	if (!ci)
-		return SWP_TB_NULL;

 	rcu_read_lock();
 	table = rcu_dereference(ci->table);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 96c67dab238e..944eccfd8632 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -134,6 +134,14 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {

 static atomic_long_t vswap_alloc_reject = ATOMIC_LONG_INIT(0);

+/* Virtual swap address space, reserved at init and mapped on demand. */
+#define VSWAP_MAX_SIZE		(8UL * SZ_1T)
+
+/* Clusters added per growth of the vswap cluster array, one page worth. */
+#define VSWAP_GROW_CLUSTERS						\
+	max_t(unsigned long,						\
+	      PAGE_SIZE / sizeof(struct swap_cluster_info_dynamic), 16)
+
 struct percpu_vswap_cluster {
 	unsigned long offset[SWAP_NR_ORDERS];
 	local_lock_t lock;
@@ -144,6 +152,34 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };

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
 static bool vswap_alloc(struct folio *folio);
 static void vswap_mark_cache_only(struct swap_cluster_info *ci,
 				  unsigned int ci_off);
@@ -424,7 +460,8 @@ static inline unsigned int cluster_index(struct swap_info_struct *si,
 					 struct swap_cluster_info *ci)
 {
 	if (swap_is_vswap(si))
-		return container_of(ci, struct swap_cluster_info_dynamic, ci)->index;
+		return container_of(ci, struct swap_cluster_info_dynamic, ci) -
+		       si->vswap_cluster_info;
 	return ci - si->cluster_info;
 }

@@ -442,10 +479,14 @@ static void swap_cluster_free_table_folio_rcu_cb(struct rcu_head *head)
 	folio_put(folio);
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
@@ -505,7 +546,7 @@ static int swap_cluster_alloc_table(struct swap_info_struct *si,
 		VM_WARN_ON_ONCE(ci->memcg_table);
 		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
 		if (!ci->memcg_table) {
-			swap_cluster_free_table(ci);
+			swap_cluster_free_table(si, ci);
 			return -ENOMEM;
 		}
 	}
@@ -515,10 +556,16 @@ static int swap_cluster_alloc_table(struct swap_info_struct *si,
 	VM_WARN_ON_ONCE(ci->zero_bitmap);
 	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
 	if (!ci->zero_bitmap) {
-		swap_cluster_free_table(ci);
+		swap_cluster_free_table(si, ci);
 		return -ENOMEM;
 	}
 #endif
+
+	/* The virtual table shares the swap table's lifetime. */
+	if (swap_is_vswap(si) && vswap_cluster_alloc_vtable(ci, gfp)) {
+		swap_cluster_free_table(si, ci);
+		return -ENOMEM;
+	}
 	return 0;
 }

@@ -564,10 +611,8 @@ swap_cluster_populate(struct swap_info_struct *si,
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
@@ -584,7 +629,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	spin_unlock(&ci->lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
-	local_unlock(&percpu_swap_cluster.lock);
+	swap_percpu_cluster_unlock(si);

 	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					       GFP_KERNEL);
@@ -597,7 +642,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	local_lock(&percpu_swap_cluster.lock);
+	swap_percpu_cluster_lock(si);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_lock(&si->global_cluster_lock);
 	spin_lock(&ci->lock);
@@ -645,20 +690,7 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
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
@@ -1195,49 +1227,142 @@ static unsigned long alloc_swap_scan_list(struct swap_info_struct *si,
 	return found;
 }

-static unsigned long vswap_alloc_cluster(struct swap_info_struct *si,
-					 struct folio *folio)
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
+					    sizeof(*si->vswap_cluster_info),
+					    VM_SPARSE);
+	if (!si->cluster_info_area)
+		return -ENOMEM;
+
+	si->vswap_cluster_info = si->cluster_info_area->addr;
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
+	end = round_up((unsigned long)&si->vswap_cluster_info[si->nr_mapped_clusters],
+		       PAGE_SIZE);
+	for (addr = (unsigned long)si->vswap_cluster_info; addr < end;
+	     addr += PAGE_SIZE) {
+		page = vmalloc_to_page((void *)addr);
+		vm_area_unmap_pages(si->cluster_info_area, addr,
+				    addr + PAGE_SIZE);
+		__free_page(page);
+	}
+
+	free_vm_area(si->cluster_info_area);
+	si->cluster_info_area = NULL;
+	si->vswap_cluster_info = NULL;
+	si->nr_mapped_clusters = 0;
+}
+
+static bool vswap_can_grow(struct swap_info_struct *si)
+{
+	return READ_ONCE(si->nr_mapped_clusters) <
+	       DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER);
+}
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
+		     sizeof(struct swap_cluster_info_dynamic) > PAGE_SIZE);
 	VM_WARN_ON(!swap_is_vswap(si));

-	ci_dyn = kzalloc_obj(*ci_dyn, GFP_ATOMIC);
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

-	if (swap_cluster_alloc_table(si, &ci_dyn->ci, GFP_ATOMIC)) {
-		kfree(ci_dyn);
-		return SWAP_ENTRY_INVALID;
-	}
+	mutex_lock(&si->cluster_grow_lock);
+	first = si->nr_mapped_clusters;
+	nr = min_t(unsigned int, VSWAP_GROW_CLUSTERS,
+		   DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER) - first);
+	if (!nr)
+		goto out;

-	if (vswap_cluster_alloc_vtable(ci_dyn, GFP_ATOMIC)) {
-		swap_cluster_free_table(&ci_dyn->ci);
-		kfree(ci_dyn);
-		return SWAP_ENTRY_INVALID;
-	}
+	start = round_up((unsigned long)&si->vswap_cluster_info[first],
+			 PAGE_SIZE);
+	end = round_up((unsigned long)&si->vswap_cluster_info[first + nr],
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
-		     GFP_ATOMIC)) {
+	/*
+	 * Publish the new clusters before they become reachable by offset.
+	 * A zeroed page leaves them off-list with CLUSTER_FLAG_NONE, which
+	 * is what move_cluster() expects.
+	 */
+	WRITE_ONCE(si->nr_mapped_clusters, first + nr);
+	for (i = first; i < first + nr; i++) {
+		ci = &si->vswap_cluster_info[i].ci;
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
@@ -1264,8 +1389,6 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
 				ci = swap_cluster_lock(si, offset);
-				if (!ci)
-					goto next;
 				if (nr_reclaim) {
 					offset += abs(nr_reclaim);
 					continue;
@@ -1277,8 +1400,6 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 				nr_reclaim = try_to_reclaim_vswap_backing(si, offset,
 									  vswap_entry);
 				ci = swap_cluster_lock(si, offset);
-				if (!ci)
-					goto next;
 				if (nr_reclaim) {
 					offset += abs(nr_reclaim);
 					continue;
@@ -1292,7 +1413,6 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 			relocate_cluster(si, ci);

 		swap_cluster_unlock(ci);
-next:
 		if (to_scan <= 0)
 			break;

@@ -1370,10 +1490,19 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -1625,11 +1754,11 @@ static swp_entry_t swap_alloc_fast(struct folio *folio)
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

@@ -1755,7 +1884,6 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 	if (!si)
 		return 0;

-	/* The source PTE pins the entry, so its cluster is alive. */
 	ci = __swap_offset_to_cluster(si, offset);
 	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), gfp);

@@ -2009,12 +2137,12 @@ static bool vswap_alloc(struct folio *folio)

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
@@ -2755,7 +2883,6 @@ static bool folio_maybe_swapped(struct folio *folio)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);

-	/* Folio is locked and in swap cache, so ci->count > 0: cluster is alive. */
 	ci = __swap_entry_to_cluster(entry);
 	ci_off = swp_cluster_offset(entry);
 	ci_end = ci_off + folio_nr_pages(folio);
@@ -3861,25 +3988,22 @@ static void free_swap_cluster_info(struct swap_info_struct *si,
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
+			ci = &si->vswap_cluster_info[i].ci;
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

@@ -3891,7 +4015,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si,
 		spin_lock(&ci->lock);
 		if (cluster_table_is_alloced(ci)) {
 			swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, true);
-			swap_cluster_free_table(ci);
+			swap_cluster_free_table(si, ci);
 		}
 		spin_unlock(&ci->lock);
 	}
@@ -4373,39 +4497,16 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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
 		goto setup_cluster_info;
 	}

@@ -4463,7 +4564,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	}

 	for (i = 0; i < nr_clusters; i++) {
-		struct swap_cluster_info *ci = &cluster_info[i];
+		ci = &cluster_info[i];

 		if (ci->count) {
 			ci->flags = CLUSTER_FLAG_NONFULL;
@@ -4476,8 +4577,23 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,

 	/* Slot 0 is bad, so cluster 0 never empties. The rest of it is usable. */
 	if (swap_is_vswap(si)) {
-		ci_dyn->ci.flags = CLUSTER_FLAG_NONFULL;
-		list_add_tail(&ci_dyn->ci.list, &si->nonfull_clusters[0]);
+		err = vswap_grow_clusters(si);
+		if (err)
+			goto err;
+
+		ci = &si->vswap_cluster_info->ci;
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
@@ -4886,12 +5002,8 @@ static int __init vswap_init(void)
 		return 0;
 	}

-	/*
-	 * One u32 xarray ID per cluster, so the device cannot be larger
-	 * than UINT_MAX clusters.
-	 */
-	maxpages = min(swapfile_maximum_size,
-		       (unsigned long)UINT_MAX * SWAPFILE_CLUSTER);
+	/* One fixed reservation for the cluster array, so one fixed size. */
+	maxpages = min(swapfile_maximum_size, VSWAP_MAX_SIZE >> PAGE_SHIFT);
 	/*
 	 * SWP_WRITEOK enables slot allocation. SWP_SOLIDSTATE selects
 	 * per-CPU cluster allocation; vswap has no si->global_cluster.
diff --git a/mm/vswap.h b/mm/vswap.h
index c66fa34e2e60..547e4453cf11 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -175,7 +175,7 @@ static inline void __vtable_set(struct swap_cluster_info_dynamic *ci_dyn,
  * @entry: the virtual swap entry
  * @voff: out param, receives @entry's slot offset within the cluster
  *
- * Return: the locked vswap cluster, or NULL if @entry has no live cluster.
+ * Return: the locked vswap cluster.
  */
 static inline struct swap_cluster_info_dynamic *
 vswap_lock_cluster(swp_entry_t entry, unsigned int *voff)
@@ -183,8 +183,6 @@ vswap_lock_cluster(swp_entry_t entry, unsigned int *voff)
 	struct swap_cluster_info *ci;

 	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
-	if (!ci)
-		return NULL;
 	*voff = swp_cluster_offset(entry);
 	return container_of(ci, struct swap_cluster_info_dynamic, ci);
 }
@@ -204,9 +202,6 @@ static inline swp_entry_t vswap_to_phys(swp_entry_t entry)
 	unsigned long vt;

 	ci_dyn = vswap_lock_cluster(entry, &voff);
-	if (!ci_dyn)
-		return (swp_entry_t){};
-
 	vt = __vtable_get(ci_dyn, voff);
 	swap_cluster_unlock(&ci_dyn->ci);

@@ -255,8 +250,6 @@ static inline struct zswap_entry *vswap_zswap_load(swp_entry_t entry)
 	unsigned long vt;

 	ci_dyn = vswap_lock_cluster(entry, &voff);
-	if (!ci_dyn)
-		return NULL;
 	vt = __vtable_get(ci_dyn, voff);
 	swap_cluster_unlock(&ci_dyn->ci);

@@ -336,11 +329,6 @@ static inline int vswap_check_backing(swp_entry_t entry, int nr,
 	int ret;

 	ci_dyn = vswap_lock_cluster(entry, &voff);
-	if (!ci_dyn) {
-		if (typep)
-			*typep = VSWAP_NONE;
-		return 0;
-	}
 	ret = __vswap_check_backing(ci_dyn, voff, nr, typep);
 	swap_cluster_unlock(&ci_dyn->ci);
 	return ret;
@@ -365,9 +353,12 @@ static inline bool folio_phys_swap_backed(struct folio *folio)
 		type == VSWAP_SWAPFILE);
 }

-static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info_dynamic *ci_dyn,
+static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info *ci,
 					     gfp_t gfp)
 {
+	struct swap_cluster_info_dynamic *ci_dyn;
+
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
 	ci_dyn->virtual_table = kcalloc(SWAPFILE_CLUSTER,
 					sizeof(*ci_dyn->virtual_table), gfp);
 	return ci_dyn->virtual_table ? 0 : -ENOMEM;
