Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47AC3B3C01
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041795; cv=none; b=rgiTd3YBEBj2m8YOVA/ocWhAXB1GfBkqtfycXKesO5emWqECkEa7Eyi8Yn9BATBLGFJrhqXrYTRFdwwLpBcKyRrxmxwKJdD8WPw2S3H4c9Qg9iTwx+HLqSektz+fSoSGN/t9vszh+AGzJzz6ozUPOZi7KLaOI/Z8Wvs+KQVqSdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041795; c=relaxed/simple;
	bh=ma1FTOVudEGvtBVXKUv0bZv+jA1FRxkPDymfsUFFypA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4kRJ9lR00ihQ4warVjQxigpRzgzxC3IC3f7XaC4vzDqR8c0uKRPqlPO2ejZrKpZ5ARzFyARfGHJeTNdU148hEbxYqujeYeasYHrSbzG57CLzsiSxpZluOLOrAGfMiuPV5Iza7wQIVIBZdRHUS4iZPYVcDUEKr+lIkfW2DU58Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pZibNla9; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pZibNla9"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4af173320f9so1740283b6e.2
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 11:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041790; x=1786646590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nVsuALmW4jG8uLihjQKBr5T9l1kxnVLHlQECAc8aSrQ=;
        b=pZibNla9RSj0XlYHSSuUSrD2Pfe2ZHWlZpqRsEpu2MML+Z/ihVwE2UKCS0koQthNBq
         9lpE2Qxh+vii0JyeCV4xr08TXfEcDLXPEjD0C5SnYQhha4qP1pdLwifmh5GMj8qjz00N
         MHSA+bCqi785ud1/Cic9S1OjjTqEkCwdBRwznjJMhkY6KjCpIPQVQFb9PVDo3Feyuphl
         8byOkkWQP3HwWr1jtH74veKUF0UltQNok2EtBhpsXwK3yRWlk/xKyGbCAIrdNMsAZPCg
         jbVihozwSOIcGQ2xoZcD+D14sinyXYSacSRBFIeLUrk5upvzM+AixC2L1xkW7KqMnIgo
         Jjuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041790; x=1786646590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nVsuALmW4jG8uLihjQKBr5T9l1kxnVLHlQECAc8aSrQ=;
        b=U5LTRfqUYFp/7jurSGHYNvsoj+J4o2/e+svQaXkgHuq2Z0Vkfud4V5KI9MkVfJMJ4Z
         P0arPbgcSmRTdsGnGSVBLg8mQ/SmNrYHqRJA9xZQtti71nt0drEfUE7ynyt/OAz9X76V
         nmR93hhMyHbUqUJ/QcUjaclD07KT/Ze8f96eAYtBujop/Va7pFfkJO8Lg4yLuX5dR1Ur
         XzyjmzRVPqFRTriW8vk5MUPco1m8p8eHSfKiogvkLBBBWpawENillKGyIWKg6FQuXvie
         GTYFvuD1usXNdb+bQ3NW/SXnuJsw3mddEG4zrEgPDWOWgq8gmbKcx8weYkELtrZUvGov
         Uzwg==
X-Forwarded-Encrypted: i=1; AHgh+Rr7ywY7y4HVZG8Hqgc0OmMu/0HixRwKZFeXSKkjin6ddWbpsXQ+SPmYskLosMtMXoM8VkfHgxqs@vger.kernel.org
X-Gm-Message-State: AOJu0Yx49RS4Lx8hUr2jlG9gw7SD1MyavUeJPvRUwnj7J9OU1CiDd+Ch
	MTR54Qtv/n/y0nD2iMnk9K3K7i/fkX1E6F6QV6O2iopqL2pcHwvAMt18
X-Gm-Gg: AR+sD136UmAE8xCAwbhrpJko7UBPv5kF6GCJ4G+Yaf+OnIpN/NkHHkXPYWifoRv5Xzf
	iasFg1ZpEK3ZAYa/Ll0B763GhAj4v33mwRdt3UH9rXdViDQwUPPE1ZBA/Q+TUHyxIL8JW+XFsG8
	tJIyDxu91pjiIFZgK45aN21himIbyZ0w2NjzWt9Fbb2FPdDA5H+xxeJsVgdj6hDEL06VgnELtNd
	axnxtCe7WI8vsqIAZlMzH7RN4dsT7jdqQ5+HaxuZWv7js/ATiDpZZhRfIbkoAfAbUTB3fb/jl/W
	6R4w0LKnTX/Fz6ovJvmYFp4ADORTOz9/BJMzJyEXwn8EbYju/auc/DxB3TFbbLU2H2s9Rz2pLdi
	Ik1oADhEagLQHXeuTGxIDONJ+jWgimfc+aYh2bIsq/eljaJ4Rih6UrOV25bXRDTRP/Uli0RL1iR
	4r4BupnXU7VarYwRQGN0J+OQp3BKoNwkZX9Zf7iydcnVN+EAuE4rgMXiPeTN2ml414FoT4C6Dh2
	PyebnG1mKI=
X-Received: by 2002:a05:6808:bc6:b0:496:9b3:486 with SMTP id 5614622812f47-4b13edea938mr2290585b6e.14.1786041789495;
        Thu, 06 Aug 2026 11:43:09 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:24::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4afae75ce1bsm4972147b6e.15.2026.08.06.11.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:08 -0700 (PDT)
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
Subject: [PATCH v3 08/11] mm, swap: only charge physical swap entries
Date: Thu,  6 Aug 2026 11:42:51 -0700
Message-ID: <20260806184254.3790858-9-nphamcs@gmail.com>
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

Charge memcg->swap when a vswap entry acquires physical backing rather
than when it is allocated, so memory.swap.current tracks on-disk swap
usage. Zswap-backed and zero-filled pages occupy no swap space but were
charged as though they did.

memory.swap.current therefore no longer counts them, and a cgroup whose
pages all land in zswap can now reclaim anon memory with memory.swap.max
set to 0.

Direct-mapped physical swap charging is unchanged.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/memcontrol.h |   5 ++
 include/linux/swap.h       |  57 +++++++++++++
 mm/memcontrol.c            | 166 ++++++++++++++++++++++++++++++++-----
 mm/swapfile.c              | 111 +++++++++++++++++++++----
 4 files changed, 303 insertions(+), 36 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e78bc98ab229..0a2f85ac7b6a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1900,6 +1900,7 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
+bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
@@ -1908,6 +1909,10 @@ static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
 	return true;
 }
+static inline bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush)
+{
+	return true;
+}
 static inline void obj_cgroup_charge_zswap(struct obj_cgroup *objcg,
 					   size_t size)
 {
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 2b2bd56afffa..19a703510675 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -523,6 +523,43 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 	return __mem_cgroup_try_charge_swap(folio);
 }
 
+extern void __mem_cgroup_record_swap(struct folio *folio);
+static inline void mem_cgroup_record_swap(struct folio *folio)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_record_swap(folio);
+}
+
+extern int __mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+						 unsigned int nr_pages);
+static inline int mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+						      unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return 0;
+	return __mem_cgroup_charge_backing_phys_swap(memcg, nr_pages);
+}
+
+extern void __mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+						    unsigned int nr_pages);
+static inline void mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+							 unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_uncharge_backing_phys_swap(memcg, nr_pages);
+}
+
+extern void __mem_cgroup_id_put_swap(unsigned short id, unsigned int nr_pages);
+static inline void mem_cgroup_id_put_swap(unsigned short id,
+					  unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_id_put_swap(id, nr_pages);
+}
+
 extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages);
 static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 {
@@ -539,6 +576,26 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 	return 0;
 }
 
+static inline void mem_cgroup_record_swap(struct folio *folio)
+{
+}
+
+static inline int mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+						      unsigned int nr_pages)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+							 unsigned int nr_pages)
+{
+}
+
+static inline void mem_cgroup_id_put_swap(unsigned short id,
+					  unsigned int nr_pages)
+{
+}
+
 static inline void mem_cgroup_uncharge_swap(unsigned short id,
 					    unsigned int nr_pages)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7a426db06222..f6aee32ef542 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -48,6 +48,7 @@
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/swapops.h>
+#include <linux/zswap.h>
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
@@ -5701,6 +5702,116 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	return 0;
 }
 
+/**
+ * __mem_cgroup_record_swap - record memcg for swap without charging
+ * @folio: folio being added to swap
+ *
+ * Pin the memcg private ID ref and record it in the swap cgroup table
+ * without charging memcg->swap; the charge is deferred to physical-backing
+ * allocation (vswap).
+ */
+void __mem_cgroup_record_swap(struct folio *folio)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	struct swap_cluster_info *ci;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	if (do_memsw_account())
+		return;
+
+	objcg = folio_objcg(folio);
+	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
+	if (!objcg)
+		return;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	if (!folio_test_swapcache(folio)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
+	rcu_read_unlock();
+
+	ci = swap_cluster_get_and_lock(folio);
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
+			  mem_cgroup_private_id(memcg));
+	swap_cluster_unlock(ci);
+}
+
+/**
+ * __mem_cgroup_charge_backing_phys_swap - charge memcg->swap
+ * @memcg: the mem_cgroup to charge (may be NULL)
+ * @nr_pages: number of physical swap pages to charge
+ *
+ * Charge the swap counter when a vswap entry gains physical backing. The
+ * private ID ref is already held (pinned by __mem_cgroup_record_swap() at
+ * vswap allocation), so this only moves the counter.
+ *
+ * Return: 0 on success, -ENOMEM on failure.
+ */
+int __mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+					  unsigned int nr_pages)
+{
+	struct page_counter *counter;
+
+	if (do_memsw_account())
+		return 0;
+	if (!memcg)
+		return 0;
+
+	if (!mem_cgroup_is_root(memcg) &&
+	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
+		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+		return -ENOMEM;
+	}
+	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
+	return 0;
+}
+
+/**
+ * __mem_cgroup_uncharge_backing_phys_swap - uncharge memcg->swap counter
+ * @memcg: the mem_cgroup to uncharge (may be NULL)
+ * @nr_pages: number of physical swap pages to uncharge
+ *
+ * Uncharge the swap counter on physical backing release for a vswap entry.
+ * The private ID ref is dropped separately via __mem_cgroup_id_put_swap() when
+ * the vswap entry is freed.
+ */
+void __mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+					     unsigned int nr_pages)
+{
+	if (!memcg)
+		return;
+
+	if (!mem_cgroup_is_root(memcg)) {
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, nr_pages);
+		else
+			page_counter_uncharge(&memcg->swap, nr_pages);
+	}
+	mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
+}
+
+/**
+ * __mem_cgroup_id_put_swap - drop memcg private ID ref without uncharging
+ * @id: cgroup private id
+ * @nr_pages: number of refs to drop
+ */
+void __mem_cgroup_id_put_swap(unsigned short id, unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(id);
+	if (memcg)
+		mem_cgroup_private_id_put(memcg, nr_pages);
+	rcu_read_unlock();
+}
+
 /**
  * __mem_cgroup_uncharge_swap - uncharge swap space
  * @id: cgroup id to uncharge
@@ -5727,15 +5838,21 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
-	long nr_swap_pages = get_nr_swap_pages();
+	long nr_swap_pages;
 
 	/*
-	 * vswap zswap-backed swapout needs no physical slot, so gate anon
-	 * reclaim on the swap.max headroom instead of the physical free count.
+	 * vswap charges only physical backing (folio_realloc_swap), not
+	 * allocation. For a zswap-capable memcg virtual swap is unbounded, so
+	 * the swap.max walk below would underestimate it and starve anon
+	 * reclaim; report unbounded. swap.max is still enforced at
+	 * phys-backing charge time.
 	 */
-	if (vswap_is_enabled() && zswap_is_enabled())
-		nr_swap_pages = PAGE_COUNTER_MAX;
+	if (vswap_is_enabled() && zswap_is_enabled() &&
+	    (mem_cgroup_disabled() || do_memsw_account() ||
+	     mem_cgroup_may_zswap(memcg, false)))
+		return PAGE_COUNTER_MAX;
 
+	nr_swap_pages = get_nr_swap_pages();
 	if (mem_cgroup_disabled() || do_memsw_account())
 		return nr_swap_pages;
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
@@ -5907,8 +6024,10 @@ static struct cftype swap_files[] = {
 
 #ifdef CONFIG_ZSWAP
 /**
- * obj_cgroup_may_zswap - check if this cgroup can zswap
- * @objcg: the object cgroup
+ * mem_cgroup_may_zswap - check if this cgroup hierarchy can zswap
+ * @original_memcg: the memcg to query
+ * @may_flush: force-flush stats for an accurate check (sleeps). Pass false
+ *             from atomic contexts; the check is then best-effort.
  *
  * Check if the hierarchical zswap limit has been reached.
  *
@@ -5918,15 +6037,13 @@ static struct cftype swap_files[] = {
  * spending cycles on compression when there is already no room left
  * or zswap is disabled altogether somewhere in the hierarchy.
  */
-bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
+bool mem_cgroup_may_zswap(struct mem_cgroup *original_memcg, bool may_flush)
 {
-	struct mem_cgroup *memcg, *original_memcg;
-	bool ret = true;
+	struct mem_cgroup *memcg;
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return true;
 
-	original_memcg = get_mem_cgroup_from_objcg(objcg);
 	for (memcg = original_memcg; !mem_cgroup_is_root(memcg);
 	     memcg = parent_mem_cgroup(memcg)) {
 		unsigned long max = READ_ONCE(memcg->zswap_max);
@@ -5934,20 +6051,27 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 
 		if (max == PAGE_COUNTER_MAX)
 			continue;
-		if (max == 0) {
-			ret = false;
-			break;
-		}
+		if (max == 0)
+			return false;
 
 		/* Force flush to get accurate stats for charging */
-		__mem_cgroup_flush_stats(memcg, true);
+		if (may_flush)
+			__mem_cgroup_flush_stats(memcg, true);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
-		if (pages < max)
-			continue;
-		ret = false;
-		break;
+		if (pages >= max)
+			return false;
 	}
-	mem_cgroup_put(original_memcg);
+	return true;
+}
+
+bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
+{
+	struct mem_cgroup *memcg;
+	bool ret;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = mem_cgroup_may_zswap(memcg, true);
+	mem_cgroup_put(memcg);
 	return ret;
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ab4bb57707e6..1a2d9d9625fc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -47,6 +47,7 @@
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
+#include "memcontrol-v1.h"
 #include "swap_table.h"
 #include "vswap.h"
 #include "internal.h"
@@ -2116,8 +2117,16 @@ int folio_alloc_swap(struct folio *folio)
 			goto again;
 	}
 
-	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio)))
+	/*
+	 * A vswap entry has no physical swap yet, so only record the memcg;
+	 * folio_realloc_swap() charges once backing is allocated.
+	 *
+	 * Need to call this even if allocation failed, for MEMCG_SWAP_FAIL.
+	 */
+	if (folio_test_swapcache(folio) &&
+	    is_vswap_entry(folio->swap))
+		mem_cgroup_record_swap(folio);
+	else if (unlikely(mem_cgroup_try_charge_swap(folio)))
 		swap_cache_del_folio(folio);
 
 	if (unlikely(!folio_test_swapcache(folio)))
@@ -2182,6 +2191,28 @@ static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 					     unsigned int ci_start,
 					     unsigned int nr_pages);
 
+static void vswap_uncharge_cgroup_batch(unsigned short memcg_id,
+					unsigned int batch_nr,
+					unsigned int batch_nr_swapfile)
+{
+	struct mem_cgroup *memcg;
+	unsigned int n;
+
+	/*
+	 * v1 (memsw): __memcg1_swapout() charges memsw for every swapped-out
+	 * entry regardless of backing, so uncharge all of them. v2: only
+	 * swapfile-backed entries are charged, so uncharge just those.
+	 */
+	n = do_memsw_account() ? batch_nr : batch_nr_swapfile;
+	if (!n)
+		return;
+
+	rcu_read_lock();
+	memcg = memcg_id ? mem_cgroup_from_private_id(memcg_id) : NULL;
+	rcu_read_unlock();
+	mem_cgroup_uncharge_backing_phys_swap(memcg, n);
+}
+
 /**
  * __vswap_release_backing - release the backing of a range of vtable slots
  * @ci: the locked vswap cluster
@@ -2191,8 +2222,7 @@ static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
  * Releases each slot in [@ci_start, @ci_start + @nr): physical swap slots,
  * zswap entries, etc. Clears the zero marks if set.
  *
- * Context: caller must hold @ci->lock. The entire range must belong to the
- * same memcg.
+ * Context: caller must hold @ci->lock.
  */
 void __vswap_release_backing(struct swap_cluster_info *ci,
 			     unsigned int ci_start, unsigned int nr)
@@ -2204,12 +2234,27 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 	unsigned int ci_off;
 	unsigned long vt;
 	swp_entry_t phys;
+	unsigned short batch_id;
+	unsigned int batch_nr = 0, batch_nr_swapfile = 0;
 
 	lockdep_assert_held(&ci->lock);
 	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	batch_id = __swap_cgroup_get(ci, ci_start);
 
 	for (ci_off = ci_start; ci_off < ci_start + nr; ci_off++) {
+		unsigned short cur_id;
+
 		vt = __vtable_get(ci_dyn, ci_off);
+		cur_id = __swap_cgroup_get(ci, ci_off);
+
+		if (cur_id != batch_id) {
+			vswap_uncharge_cgroup_batch(batch_id, batch_nr,
+						    batch_nr_swapfile);
+			batch_id = cur_id;
+			batch_nr = 0;
+			batch_nr_swapfile = 0;
+		}
+		batch_nr++;
 
 		/*
 		 * Flush batched physical slots when the next entry
@@ -2233,6 +2278,7 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 
 		switch (vtable_type(vt)) {
 		case VSWAP_SWAPFILE:
+			batch_nr_swapfile++;
 			if (phys_start == phys_end) {
 				phys = vtable_to_phys(vt);
 				phys_start = swp_offset(phys);
@@ -2266,6 +2312,8 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 			phys_start % SWAPFILE_CLUSTER,
 			phys_end - phys_start);
 	}
+
+	vswap_uncharge_cgroup_batch(batch_id, batch_nr, batch_nr_swapfile);
 }
 
 /**
@@ -2355,7 +2403,10 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 	swp_entry_t vswap_entry = folio->swap;
 	struct swap_cluster_info *ci;
 	struct swap_cluster_info_dynamic *ci_dyn;
+	struct mem_cgroup *memcg;
 	unsigned int voff;
+	unsigned long vt;
+	unsigned short memcg_id;
 	swp_entry_t phys_entry = {};
 	swp_entry_t pe;
 	int i, nr = folio_nr_pages(folio);
@@ -2364,9 +2415,18 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON(!is_vswap_entry(vswap_entry));
 
-	phys_entry = vswap_to_phys(vswap_entry);
-	if (phys_entry.val)
-		return phys_entry;
+	voff = swp_cluster_offset(vswap_entry);
+	ci = __swap_entry_to_cluster(vswap_entry);
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+
+	spin_lock(&ci->lock);
+	vt = __vtable_get(ci_dyn, voff);
+	if (vtable_type(vt) == VSWAP_SWAPFILE) {
+		spin_unlock(&ci->lock);
+		return vtable_to_phys(vt);
+	}
+	memcg_id = __swap_cgroup_get(ci, voff);
+	spin_unlock(&ci->lock);
 
 	local_lock(&percpu_swap_cluster.lock);
 	phys_entry = swap_alloc_fast(folio);
@@ -2377,10 +2437,20 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 	if (!phys_entry.val)
 		return (swp_entry_t){};
 
-	voff = swp_cluster_offset(vswap_entry);
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	if (!memcg || mem_cgroup_private_id(memcg) != memcg_id)
+		memcg = memcg_id ? mem_cgroup_from_private_id(memcg_id) : NULL;
+	rcu_read_unlock();
+
+	if (mem_cgroup_charge_backing_phys_swap(memcg, nr)) {
+		__swap_cluster_free_phys_backing(
+			__swap_entry_to_info(phys_entry),
+			__swap_entry_to_cluster(phys_entry),
+			swp_cluster_offset(phys_entry), nr);
+		return (swp_entry_t){};
+	}
 
-	ci = __swap_entry_to_cluster(vswap_entry);
-	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
 	spin_lock(&ci->lock);
 	/*
 	 * Install PHYS backing without freeing any prior contents of the
@@ -2591,10 +2661,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned int batch_off = ci_off;
+	bool is_vswap = swap_is_vswap(si);
 
 	VM_WARN_ON(ci->count < nr_pages);
 
-	if (swap_is_vswap(si))
+	if (is_vswap)
 		__vswap_release_backing(ci, ci_start, nr_pages);
 
 	ci->count -= nr_pages;
@@ -2614,18 +2685,28 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		/*
 		 * Uncharge swap slots by memcg in batches. Consecutive
 		 * slots with the same cgroup id are uncharged together.
+		 * For vswap, only drop the ID ref - physical swap was
+		 * already uncharged in __vswap_release_backing above.
 		 */
 		id_cur = __swap_cgroup_clear(ci, ci_off, 1);
 		if (batch_id != id_cur) {
-			if (batch_id)
-				mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+			if (batch_id) {
+				if (is_vswap)
+					mem_cgroup_id_put_swap(batch_id, ci_off - batch_off);
+				else
+					mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+			}
 			batch_id = id_cur;
 			batch_off = ci_off;
 		}
 	} while (++ci_off < ci_end);
 
-	if (batch_id)
-		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+	if (batch_id) {
+		if (is_vswap)
+			mem_cgroup_id_put_swap(batch_id, ci_off - batch_off);
+		else
+			mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+	}
 
 	__swap_cluster_finish_free(si, ci, ci_start, nr_pages);
 }
-- 
2.53.0-Meta

