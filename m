Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7217391E58
	for <cgroups@vger.kernel.org>; Wed, 18 Mar 2026 22:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773873017; cv=none; b=IhOUTThFtt0QD9E9ncIi5T9dqBDb0v+EyrBk2kezjaWSpywMjOalCNtyXsfAc8JW3fQeiB1RRF3pe9Ue3BThVkinOSEsaXkZNBpucaBf1LfgAkO99k5dlW4egxU/S+w7+tXKNeXT9Dq+QfP5B4P2QlFnj7YV//ZDJIkPVXYQKEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773873017; c=relaxed/simple;
	bh=hHQcLctoRQelYvKYdbS3GO9DxCDLvBtop1JDvrMYy7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFb1RiQJutK3dKHZ5QmfWnta3S9riUGWee9XbkbqzcZqxGUEZ7J7DeHZAUVMaLpwAoF0HEu3dtSS5MMvrUEhKWmoVJDRBxhCYXhKtgydjJisss17ws+O48j7XBfpz4Ec01I1Jl2CDwfqrSijpeAm6Ox7AqF07aIfkl7w+b7FCHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mEigueDI; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mEigueDI"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-467161c4b89so52984b6e.3
        for <cgroups@vger.kernel.org>; Wed, 18 Mar 2026 15:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873014; x=1774477814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iXKD+ZPBl4vkSnE6k01eq304ZeGimzAEjHRoiYkG/+4=;
        b=mEigueDIveCiI4Yxal0akhDGOJ9NMAG4lgy7c+zP8vvrs7YatP3vUYvwiLqgSi4ros
         zsAwS7yTe+9mxuvD0HJz5MMCXGWTV6g0Za09VaGBsCBo6XK+cSPxp/WvEWRwwx3JhzL+
         P1XYfbhWFGO3NLDGU+hmza9EQm2G1FgkrCBrC5RXyWT8IthmuausYpmEKC1VSjN1+Ogq
         38claLWk8RoTDILk8ipv5BPYYpI9QdvHmfkp9nItPDKabWBpHwmI2nH2mtbPZT+6D8+L
         32AExsLUtGfbxFnEz48tHUfRSsnLrBe/zJ14YbxMY6qeFS5J131bwglGfBsu33WrrQww
         STog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873014; x=1774477814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iXKD+ZPBl4vkSnE6k01eq304ZeGimzAEjHRoiYkG/+4=;
        b=IWX/RPPpWT4081y1NVBMF8TVEz0l8m/jgt36wdrcnRaNB9TrVnaWLOFbBFzYqQ6upg
         kY9Fe7HrAGdodh3xiPb1XntqTkVb4L7GIYtuf9U+qSBKaOj5DvQQGB0TntAF6Hw+rZ7k
         0aZ8zfZyDd+18kb2TPNhICU5X2Ahzxw9UC3VMnAZD8j4sTTBz5Wj/fyBAu5S78G9xUto
         hPc6c8T7NMYvmOYiFuO/1hx0fWJcrNUfnhHwP/FdkmptQbDVZ5MVcyZu3Xvgz6RNS0Zq
         MHMBmWkaMp62yWzs45aQPodZBMsAYesGlUtzx4O6475sC5OcU7B/2ChgoL6erkLVlJfL
         OoNA==
X-Forwarded-Encrypted: i=1; AJvYcCUFwKvvqAGr6Zcg55rjdhh7eoVOh5OkLP+Jhbi2iYZNBx+AvPSBu46mzEtUcWVh/Z36epwm5pMJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw63zVcDh2IQz6AIwsutaLe9MlaxndPOi0hRz+XDKPGcBneGgBn
	cKRGjl3UlyoXkRm8x+VdxBBf3//qNhlk3cPBIuxguaTvCf+geyXBJkHz
X-Gm-Gg: ATEYQzx34aSu7OP4CpbcE/ASj5bBLIs7/udAYSARB4PxMgwXhKsBv2e73G5GM+vcYGu
	U8gsQtFH8vIl38BT0SmCnZVDhLRzMf/MAETwjpZpLoWh9tcukFWi5/zeWtuuG9D1c4XB4Q72BP6
	capXagXkYCsMeR9vUVRbjXeljYIGYG7cNeeqpPOCdLZBJhQhpaRKCnV18Z4BfvA/RXEy/8dWRTl
	e6lhxLysZcnmDxnCwwaxYVES9QJuln/hmnzTC8/iMC9013Tlmeo6CkmFg2lfNy8VlZy7y8MLg40
	7vinISI6bb3f5CGQLtHCNrL8noJFelmmMoN6PG70bQIz6twZ1C7PdNaIu6JQCRIhIAbtlmuQYQV
	xMfVeSvkLydKeNB7oiIlbEXDeAo6p4EjQKSlAdRH+skKUa5zKVU/su8iHJq3txOwRHrc9mPAQ5y
	kG8Y6HG3xHLbcCiWom1f1B+nlK0+Ac2LC+6/oA412q8tv/
X-Received: by 2002:a05:6808:10cc:b0:467:11f6:917a with SMTP id 5614622812f47-467ba293991mr3007396b6e.38.1773873013609;
        Wed, 18 Mar 2026 15:30:13 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467baa8db48sm2569039b6e.10.2026.03.18.15.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:13 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v4 11/21] zswap: move zswap entry management to the virtual swap descriptor
Date: Wed, 18 Mar 2026 15:29:42 -0700
Message-ID: <20260318222953.441758-12-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the zswap tree and manage zswap entries directly
through the virtual swap descriptor. This re-partitions the zswap pool
(by virtual swap cluster), which eliminates zswap tree lock contention.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/zswap.h |   6 +++
 mm/vswap.c            | 100 ++++++++++++++++++++++++++++++++++++++++++
 mm/zswap.c            |  40 -----------------
 3 files changed, 106 insertions(+), 40 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 1a04caf283dc8..7eb3ce7e124fc 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -6,6 +6,7 @@
 #include <linux/mm_types.h>
 
 struct lruvec;
+struct zswap_entry;
 
 extern atomic_long_t zswap_stored_pages;
 
@@ -33,6 +34,11 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+void *zswap_entry_store(swp_entry_t swpentry, struct zswap_entry *entry);
+void *zswap_entry_load(swp_entry_t swpentry);
+void *zswap_entry_erase(swp_entry_t swpentry);
+bool zswap_empty(swp_entry_t swpentry);
+
 #else
 
 struct zswap_lruvec_state {};
diff --git a/mm/vswap.c b/mm/vswap.c
index 371dd147bf70d..f2ebd79854572 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -10,6 +10,7 @@
 #include <linux/swapops.h>
 #include <linux/swap_cgroup.h>
 #include <linux/cpuhotplug.h>
+#include <linux/zswap.h>
 #include "swap.h"
 #include "swap_table.h"
 
@@ -37,11 +38,13 @@
  * Swap descriptor - metadata of a swapped out page.
  *
  * @slot: The handle to the physical swap slot backing this page.
+ * @zswap_entry: The zswap entry associated with this swap slot.
  * @swap_cache: The folio in swap cache.
  * @shadow: The shadow entry.
  */
 struct swp_desc {
 	swp_slot_t slot;
+	struct zswap_entry *zswap_entry;
 	union {
 		struct folio *swap_cache;
 		void *shadow;
@@ -238,6 +241,7 @@ static void __vswap_alloc_from_cluster(struct vswap_cluster *cluster, int start)
 	for (i = 0; i < nr; i++) {
 		desc = &cluster->descriptors[start + i];
 		desc->slot.val = 0;
+		desc->zswap_entry = NULL;
 	}
 	cluster->count += nr;
 }
@@ -1009,6 +1013,102 @@ void __swap_cache_replace_folio(struct folio *old, struct folio *new)
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_ZSWAP
+/**
+ * zswap_entry_store - store a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ * @entry: the zswap entry to store
+ *
+ * Stores a zswap entry in the swap descriptor for the given swap entry.
+ * The cluster is locked during the store operation.
+ *
+ * Return: the old zswap entry if one existed, NULL otherwise
+ */
+void *zswap_entry_store(swp_entry_t swpentry, struct zswap_entry *entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *old;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	old = desc->zswap_entry;
+	desc->zswap_entry = entry;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return old;
+}
+
+/**
+ * zswap_entry_load - load a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ *
+ * Loads the zswap entry from the swap descriptor for the given swap entry.
+ *
+ * Return: the zswap entry if one exists, NULL otherwise
+ */
+void *zswap_entry_load(swp_entry_t swpentry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *zswap_entry;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	zswap_entry = desc->zswap_entry;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return zswap_entry;
+}
+
+/**
+ * zswap_entry_erase - erase a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ *
+ * Erases the zswap entry from the swap descriptor for the given swap entry.
+ * The cluster is locked during the erase operation.
+ *
+ * Return: the zswap entry that was erased, NULL if none existed
+ */
+void *zswap_entry_erase(swp_entry_t swpentry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *old;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	old = desc->zswap_entry;
+	desc->zswap_entry = NULL;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return old;
+}
+
+bool zswap_empty(swp_entry_t swpentry)
+{
+	return xa_empty(&vswap_cluster_map);
+}
+#endif /* CONFIG_ZSWAP */
+
 int vswap_init(void)
 {
 	int i;
diff --git a/mm/zswap.c b/mm/zswap.c
index f7313261673ff..72441131f094e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -223,37 +223,6 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
-static DEFINE_XARRAY(zswap_tree);
-
-#define zswap_tree_index(entry)	(entry.val)
-
-static inline void *zswap_entry_store(swp_entry_t swpentry,
-		struct zswap_entry *entry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_store(&zswap_tree, offset, entry, GFP_KERNEL);
-}
-
-static inline void *zswap_entry_load(swp_entry_t swpentry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_load(&zswap_tree, offset);
-}
-
-static inline void *zswap_entry_erase(swp_entry_t swpentry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_erase(&zswap_tree, offset);
-}
-
-static inline bool zswap_empty(swp_entry_t swpentry)
-{
-	return xa_empty(&zswap_tree);
-}
-
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
@@ -1445,13 +1414,6 @@ static bool zswap_store_page(struct page *page,
 		goto compress_failed;
 
 	old = zswap_entry_store(page_swpentry, entry);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
-
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
-	}
 
 	/*
 	 * We may have had an existing entry that became stale when
@@ -1498,8 +1460,6 @@ static bool zswap_store_page(struct page *page,
 
 	return true;
 
-store_failed:
-	zs_free(pool->zs_pool, entry->handle);
 compress_failed:
 	zswap_entry_cache_free(entry);
 	return false;
-- 
2.52.0

