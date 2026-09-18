Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DEC51CF61
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789754583; cv=none; b=ixfn4hpkgw3dsMjHcL+5KmxGe0m9tpV3vAaKUBVlLDtkVHImSb49h1qQm+nDPmIiORm0t5ckyEmqLaQyQMVs1WzHDbyEOEa2zhDzsaiHA4WwL945aAadPZNA1Y2P8qJH3zltFsoyhAWl8aiDhEWcTPK5rUDMjQnQuBYW3MGbvRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789754583; c=relaxed/simple;
	bh=WKTpSp0xD3gasRqakvuWowl65qpZ319TiioffPYIquc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmrj3Tc5fuLu0W18nujWdm0OQcFLNpvK+UPPtavaJW/3x5pTy3LeWh0OVXv5YZnRIo3xRv4Y5xD/gpURk64m18NHpwoozWU8+Vweae0qDNNXbjMRZtLb6/guk4iA7ZdT9P1hKZM/s72IhkNDRXwlbZZ6yT/gmOyhzJTH8fnJRbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EyXvcV5o; arc=none smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EyXvcV5o"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4b37a2ffee6so449093b6e.2
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 11:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754577; x=1790359377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Psu72RUYq22I6IhK7xLj3nCdKxN5UQ7y0NifhPwjoWA=;
        b=EyXvcV5oabkk/fO1oXwQeyzt0XsAQiezJI1iunwokswGDtpVm7Su/aK6ec1/RZ88YQ
         OjnHtKfxALSbZMb5pHILDLgfW7rs/5GLoORDJr5P9qt/S1QGBT2vTd1o1tS0wb5Z7mkn
         jMhY7qy5hUcHQR7NbZ0aMUQupclrRjf4ZrZGxjbpYAbWRZ5Ddkm6ap6aib0xTK3zvqt5
         NhxLM9ywTnIJIFXk2ge3NDwYdXunRFuig6SVP47w9va1Xis53mm6KDksSXhSDD2NgDQQ
         2kIYwPhu1SmAyMvFVnHf3t4Pl8ttF/Opw4tEXh9NLFthRdUm+A+KK6iP4M9oByF+UozQ
         qAZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754577; x=1790359377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Psu72RUYq22I6IhK7xLj3nCdKxN5UQ7y0NifhPwjoWA=;
        b=t+FBobJbLySgx4XS2/5zo9ztWgyDQ8/ccoRZ+Z5vwNkffVRPPsFBpVtZHtmMXL/Mc6
         xMxfNM9qAH/yifj9WhiPKdBYR1v7NWbKLovxI/BWMOksjOY8eagQ/ScjZ0RbN6ZNTTCT
         CEBmRcHKIIMrU9qpNhM194rdalHmeHFAARsFlAbr4+gSBpc9ded/1Fw+6ACNKF4P60VN
         t28U4Wx1NMAU7ovJQOTbdYtx8285rVhVc+YB9jKKCxyCmbssI5tp1iG/R1Y1i1Fd9eL+
         EEzSnutuJlhAtVK+DKQqOT84sWDMtqH4djKQZepSWO6Z7/S0THNsOiVFykfY5kkAfjbo
         Xsgw==
X-Forwarded-Encrypted: i=1; AKwUvBxInq6Ue0OyKGTR/KvhXZccZ5SZecoeYjhQjr3Mf5nNQV/KkAH7niBlMVPz3LB1vWEy0ZEHSiN7@vger.kernel.org
X-Gm-Message-State: AFuF++nzS7lP5jg0cXLpOOVtHEcv8kp7ac8OXs7PMMb7fozVBTnu23vG
	4Sw+6aBazF7pKneDQRpWifRHAYzb8WBAKEZCuVuWgeF4nrFiVOWBwE+8
X-Gm-Gg: AYBFou0jiXaE8rRLFXsFYMB5ekodcfHnQ1IM+SOqgcndJX4xy1FHl49P9tUj59wVqjU
	13NMtrvL/bg1hK1Wpk7qPqfksNozqrVrtUWgxtVx38D8v4noirv9Ff0R/6taSrR1EuF48wP/eg8
	LYnoeg8OWchh69sUh2QyZ9GYCK/Oiz9/mTZfg92gpb4IwTDGJQfovfcDfulj2LZWMm9Pc5gP45Z
	xQbZHcZVTuWcsEtDx59b1LqEO4Fg9TxPxa6ksGrUe+j+iTN4mI35stmEVHE/Oa6vH1KiUB2MveG
	29siPa+xz0nt1/HIXc/93h1/lhQQsABHOn/0+prdeInDmiJvZ5MsfcuoE9H60/GDakzjObpt89Z
	sOBHTpqt8Znb4RiJNPG1Nm85cwvNs/EDgYUz0Az241L1hl5sj510id8WLLYx2Wt4gi4JJR3rxW5
	9/SH9OEz3QUGkpy6lPsF2CUXZewHUKpF1rME5k+6y2MtvpoyxXewbCqORFQX9W0RG8NJ2mohtK5
	Bk8XOYkKxz76p/Ic67d
X-Received: by 2002:a05:6808:1203:b0:4c2:e1d3:757d with SMTP id 5614622812f47-4ccf8b363d5mr3469594b6e.21.1789754577081;
        Fri, 18 Sep 2026 11:02:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:f::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cd6a148c35sm1936178b6e.13.2026.09.18.11.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:56 -0700 (PDT)
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
Subject: [PATCH v5 08/11] mm, swap: only charge physical swap entries
Date: Fri, 18 Sep 2026 11:02:38 -0700
Message-ID: <20260918180241.3424851-9-nphamcs@gmail.com>
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

Zswap-backed and zero-filled pages occupy no swap space, but were charged
against memcg->swap as though they did.

Charge memcg->swap when a vswap entry acquires physical backing rather
than when it is allocated.

This changes what the counter means and when the charge can fail:

* memory.swap.current counts only on-disk swap usage, not zswap-backed or
  zero-filled pages.
* A cgroup can reclaim its anon memory even with memory.swap.max set to 0,
  provided zswap is allowed for it.
* The charge can fail at writeback rather than at allocation.
  swap_writeout() returns AOP_WRITEPAGE_ACTIVATE and
  zswap_writeback_entry() returns -ENOMEM for a cgroup at its limit.
* The zswap shrinker skips such a cgroup rather than walking its LRUs.

Also refactor the swap memcg operations into separate get, record, charge,
uncharge and put helpers, since recording the owner and charging it no
longer happen at the same time.

Direct-mapped physical swap charging is unchanged. So is cgroup v1 memsw
accounting: the folio's memsw charge is retained across swapout
regardless of backing, and released when the entry is freed.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 .../admin-guide/cgroup-v1/memcg_test.rst      |   2 +-
 Documentation/admin-guide/cgroup-v2.rst       |  46 +++---
 include/linux/memcontrol.h                    |   6 +
 include/linux/swap.h                          |  61 ++++++-
 mm/memcontrol-v1.c                            |  10 +-
 mm/memcontrol.c                               | 152 ++++++++++--------
 mm/swapfile.c                                 | 128 +++++++++++++--
 mm/zswap.c                                    |  29 ++--
 8 files changed, 312 insertions(+), 122 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memcg_test.rst b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
index d9951c319ef5..cd565626c435 100644
--- a/Documentation/admin-guide/cgroup-v1/memcg_test.rst
+++ b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
@@ -43,7 +43,7 @@ Please note that implementation details can be changed.
 	mem_cgroup_uncharge()
 	  Called when a page's refcount goes down to 0.
 
-	mem_cgroup_uncharge_swap()
+	mem_cgroup_swap_uncharge()
 	  Called when swp_entry's refcnt goes down to 0. A charge against swap
 	  disappears.
 
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8d2603751c51..2a1cba7f01ff 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1845,16 +1845,17 @@ The following nested keys are defined.
 	A read-only single value file which exists on non-root
 	cgroups.
 
-	The total amount of swap currently being used by the cgroup
-	and its descendants.
+	The total amount of physical swap currently being used by the
+	cgroup and its descendants.
 
   memory.swap.high
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
 
-	Swap usage throttle limit.  If a cgroup's swap usage exceeds
-	this limit, all its further allocations will be throttled to
-	allow userspace to implement custom out-of-memory procedures.
+	Physical swap usage throttle limit.  If a cgroup's physical
+	swap usage exceeds this limit, all its further allocations will
+	be throttled to allow userspace to implement custom
+	out-of-memory procedures.
 
 	This limit marks a point of no return for the cgroup. It is NOT
 	designed to manage the amount of swapping a workload does
@@ -1867,8 +1868,9 @@ The following nested keys are defined.
   memory.swap.peak
 	A read-write single value file which exists on non-root cgroups.
 
-	The max swap usage recorded for the cgroup and its descendants since
-	the creation of the cgroup or the most recent reset for that FD.
+	The max physical swap usage recorded for the cgroup and its
+	descendants since the creation of the cgroup or the most recent
+	reset for that FD.
 
 	A write of any non-empty string to this file resets it to the
 	current memory usage for subsequent reads through the same
@@ -1878,8 +1880,9 @@ The following nested keys are defined.
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
 
-	Swap usage hard limit.  If a cgroup's swap usage reaches this
-	limit, anonymous memory of the cgroup will not be swapped out.
+	Physical swap usage hard limit.  If a cgroup's physical swap
+	usage reaches this limit, anonymous memory of the cgroup will
+	not be swapped out to a physical swap device.
 
   memory.swap.events
 	A read-only flat-keyed file which exists on non-root cgroups.
@@ -1888,22 +1891,23 @@ The following nested keys are defined.
 	modified event.
 
 	  high
-		The number of times the cgroup's swap usage was over
-		the high threshold.
+		The number of times the cgroup's physical swap usage
+		was over the high threshold.
 
 	  max
-		The number of times the cgroup's swap usage was about
-		to go over the max boundary and swap allocation
-		failed.
+		The number of times the cgroup's physical swap usage
+		was about to go over the max boundary and physical
+		swap allocation failed.
 
 	  fail
-		The number of times swap allocation failed either
-		because of running out of swap system-wide or max
-		limit.
-
-	When reduced under the current usage, the existing swap
-	entries are reclaimed gradually and the swap usage may stay
-	higher than the limit for an extended period of time.  This
+		The number of times physical swap allocation failed
+		either because of running out of physical swap
+		system-wide or max limit.
+
+	When reduced under the current usage, the existing physical
+	swap entries are reclaimed gradually and the physical swap
+	usage may stay higher than the limit for an extended period of
+	time.  This
 	reduces the impact on the workload and memory management.
 
   memory.zswap.current
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7a..4add06affefa 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1933,6 +1933,7 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
+bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
@@ -1941,6 +1942,11 @@ static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
 	return true;
 }
+
+static inline bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush)
+{
+	return true;
+}
 static inline void obj_cgroup_charge_zswap(struct obj_cgroup *objcg,
 					   size_t size)
 {
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5ab050b2457c..cd22db50b44c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -527,20 +527,49 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio);
-static inline int mem_cgroup_try_charge_swap(struct folio *folio)
+struct mem_cgroup *__mem_cgroup_swap_get(struct folio *folio);
+static inline struct mem_cgroup *mem_cgroup_swap_get(struct folio *folio)
+{
+	if (mem_cgroup_disabled())
+		return NULL;
+	return __mem_cgroup_swap_get(folio);
+}
+
+int __mem_cgroup_swap_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
+static inline int mem_cgroup_swap_charge(struct mem_cgroup *memcg,
+					 unsigned int nr_pages)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio);
+	return __mem_cgroup_swap_charge(memcg, nr_pages);
 }
 
-extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages);
-static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
+void __mem_cgroup_swap_record(struct folio *folio, struct mem_cgroup *memcg);
+static inline void mem_cgroup_swap_record(struct folio *folio,
+					  struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
 		return;
-	__mem_cgroup_uncharge_swap(id, nr_pages);
+	__mem_cgroup_swap_record(folio, memcg);
+}
+
+void __mem_cgroup_swap_uncharge(struct mem_cgroup *memcg,
+				unsigned int nr_pages);
+static inline void mem_cgroup_swap_uncharge(struct mem_cgroup *memcg,
+					    unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_swap_uncharge(memcg, nr_pages);
+}
+
+void __mem_cgroup_swap_put(struct mem_cgroup *memcg, unsigned int nr_pages);
+static inline void mem_cgroup_swap_put(struct mem_cgroup *memcg,
+				       unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_swap_put(memcg, nr_pages);
 }
 
 long mem_cgroup_get_folio_swap_margin(struct folio *folio);
@@ -548,16 +577,32 @@ extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 bool mem_cgroup_can_swap(struct mem_cgroup *memcg, long nr_pages);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
-static inline int mem_cgroup_try_charge_swap(struct folio *folio)
+static inline struct mem_cgroup *mem_cgroup_swap_get(struct folio *folio)
+{
+	return NULL;
+}
+
+static inline int mem_cgroup_swap_charge(struct mem_cgroup *memcg,
+					 unsigned int nr_pages)
 {
 	return 0;
 }
 
-static inline void mem_cgroup_uncharge_swap(unsigned short id,
+static inline void mem_cgroup_swap_record(struct folio *folio,
+					  struct mem_cgroup *memcg)
+{
+}
+
+static inline void mem_cgroup_swap_uncharge(struct mem_cgroup *memcg,
 					    unsigned int nr_pages)
 {
 }
 
+static inline void mem_cgroup_swap_put(struct mem_cgroup *memcg,
+				       unsigned int nr_pages)
+{
+}
+
 static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
 {
 	return PAGE_COUNTER_MAX;
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index bf2c7d53b01b..3e06a8bdf46e 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -341,6 +341,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 void memcg1_swapin(struct folio *folio)
 {
 	struct swap_cluster_info *ci;
+	struct mem_cgroup *memcg;
 	unsigned long nr_pages;
 	unsigned short id;
 
@@ -372,7 +373,14 @@ void memcg1_swapin(struct folio *folio)
 	id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
 				 nr_pages);
 	swap_cluster_unlock(ci);
-	mem_cgroup_uncharge_swap(id, nr_pages);
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(id);
+	if (memcg) {
+		mem_cgroup_swap_uncharge(memcg, nr_pages);
+		mem_cgroup_swap_put(memcg, nr_pages);
+	}
+	rcu_read_unlock();
 }
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 63d2c9e3dbe1..bba9148b745d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5941,80 +5941,111 @@ int __init mem_cgroup_init(void)
 
 #ifdef CONFIG_SWAP
 /**
- * __mem_cgroup_try_charge_swap - try charging swap space for a folio
+ * __mem_cgroup_swap_get - pin the memcg to account a folio's swap slots to
  * @folio: folio being added to swap
  *
- * Try to charge @folio's memcg for the swap space at folio->swap.
+ * Pins one private ID ref per page of @folio on its memcg, or on its closest
+ * online ancestor if it has been offlined. The caller charges and records
+ * against whichever memcg is returned, so both land on the same one.
  *
- * Returns 0 on success, -ENOMEM on failure.
+ * Return: the pinned memcg, or NULL if there is nothing to account. Drop the
+ * pins with __mem_cgroup_swap_put().
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio)
+struct mem_cgroup *__mem_cgroup_swap_get(struct folio *folio)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
-	struct swap_cluster_info *ci;
-	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
 
 	if (do_memsw_account())
-		return 0;
+		return NULL;
 
 	objcg = folio_objcg(folio);
 	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
 	if (!objcg)
-		return 0;
+		return NULL;
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	if (!folio_test_swapcache(folio)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
-		return 0;
+		return NULL;
 	}
 
 	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
 	/* memcg is pined by memcg ID. */
 	rcu_read_unlock();
 
+	return memcg;
+}
+
+/**
+ * __mem_cgroup_swap_charge - charge physical swap space
+ * @memcg: the mem_cgroup to charge (may be NULL)
+ * @nr_pages: the amount of swap space to charge
+ *
+ * Return: 0 on success, -ENOMEM if memory.swap.max is exceeded.
+ */
+int __mem_cgroup_swap_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	struct page_counter *counter;
+
+	if (do_memsw_account() || !memcg)
+		return 0;
+
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
+	return 0;
+}
+
+/**
+ * __mem_cgroup_swap_record - record the owner of a folio's swap slots
+ * @folio: folio being added to swap
+ * @memcg: the memcg pinned by __mem_cgroup_swap_get()
+ */
+void __mem_cgroup_swap_record(struct folio *folio, struct mem_cgroup *memcg)
+{
+	struct swap_cluster_info *ci;
 
 	ci = swap_cluster_get_and_lock(folio);
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
-			  mem_cgroup_private_id(memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap),
+			  folio_nr_pages(folio), mem_cgroup_private_id(memcg));
 	swap_cluster_unlock(ci);
-
-	return 0;
 }
 
 /**
- * __mem_cgroup_uncharge_swap - uncharge swap space
- * @id: cgroup id to uncharge
+ * __mem_cgroup_swap_uncharge - uncharge physical swap space
+ * @memcg: the mem_cgroup to uncharge (may be NULL)
  * @nr_pages: the amount of swap space to uncharge
  */
-void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
+void __mem_cgroup_swap_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-	struct mem_cgroup *memcg;
+	if (!memcg)
+		return;
 
-	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(id);
-	if (memcg) {
-		if (!mem_cgroup_is_root(memcg)) {
-			if (do_memsw_account())
-				page_counter_uncharge(&memcg->memsw, nr_pages);
-			else
-				page_counter_uncharge(&memcg->swap, nr_pages);
-		}
-		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+	if (!mem_cgroup_is_root(memcg)) {
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, nr_pages);
+		else
+			page_counter_uncharge(&memcg->swap, nr_pages);
 	}
-	rcu_read_unlock();
+	mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
+}
+
+/**
+ * __mem_cgroup_swap_put - drop the private ID refs taken for swap slots
+ * @memcg: the pinned mem_cgroup
+ * @nr_pages: number of refs to drop
+ */
+void __mem_cgroup_swap_put(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	mem_cgroup_private_id_put(memcg, nr_pages);
 }
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
@@ -6055,27 +6086,12 @@ long mem_cgroup_get_folio_swap_margin(struct folio *folio)
  * @memcg: the memcg to query
  * @nr_pages: the number of pages the caller wants to swap out
  *
- * A vswap zswap-backed swapout needs no physical slot, so gate on the
- * swap.max headroom rather than the physical free count.
- *
  * Return: true if @memcg can swap out at least @nr_pages more pages.
  */
 bool mem_cgroup_can_swap(struct mem_cgroup *memcg, long nr_pages)
 {
-	long avail;
-
-	if (mem_cgroup_can_vswap(memcg))
-		return true;
-
-	if (!vswap_is_enabled() || !zswap_is_enabled())
-		return mem_cgroup_get_nr_swap_pages(memcg) >= nr_pages;
-
-	avail = PAGE_COUNTER_MAX;
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
-		avail = min_t(long, avail,
-			      READ_ONCE(memcg->swap.max) -
-			      page_counter_read(&memcg->swap));
-	return avail >= nr_pages;
+	return mem_cgroup_can_vswap(memcg) ||
+	       mem_cgroup_get_nr_swap_pages(memcg) >= nr_pages;
 }
 
 bool mem_cgroup_swap_full(struct folio *folio)
@@ -6241,8 +6257,10 @@ static struct cftype swap_files[] = {
 
 #ifdef CONFIG_ZSWAP
 /**
- * obj_cgroup_may_zswap - check if this cgroup can zswap
- * @objcg: the object cgroup
+ * mem_cgroup_may_zswap - check if this cgroup can zswap
+ * @memcg: the memcg to query
+ * @may_flush: force-flush stats for an accurate check (sleeps). Pass false
+ *             from atomic contexts; the check is then best-effort.
  *
  * Check if the hierarchical zswap limit has been reached.
  *
@@ -6252,36 +6270,38 @@ static struct cftype swap_files[] = {
  * spending cycles on compression when there is already no room left
  * or zswap is disabled altogether somewhere in the hierarchy.
  */
-bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
+bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush)
 {
-	struct mem_cgroup *memcg, *original_memcg;
-	bool ret = true;
-
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return true;
 
-	original_memcg = get_mem_cgroup_from_objcg(objcg);
-	for (memcg = original_memcg; !mem_cgroup_is_root(memcg);
-	     memcg = parent_mem_cgroup(memcg)) {
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long max = READ_ONCE(memcg->zswap_max);
 		unsigned long pages;
 
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
index 2efb47b4cc4f..3c3fc3b87b9b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1944,7 +1944,8 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 bool mem_cgroup_can_vswap(struct mem_cgroup *memcg)
 {
 	return vswap_is_enabled() && zswap_is_enabled() &&
-	       (mem_cgroup_disabled() || do_memsw_account());
+	       (mem_cgroup_disabled() || do_memsw_account() ||
+		mem_cgroup_may_zswap(memcg, false));
 }
 
 static bool vswap_alloc(struct folio *folio)
@@ -2030,6 +2031,7 @@ static swp_entry_t folio_alloc_phys_swap(struct folio *folio)
 int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
+	struct mem_cgroup *memcg;
 	unsigned int size = 1 << order;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -2056,10 +2058,20 @@ int folio_alloc_swap(struct folio *folio)
 	if (!vswap_alloc(folio))
 		folio_alloc_phys_swap(folio);
 
-	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
-		swap_cache_del_folio(folio);
-		goto failed;
+	/*
+	 * Need to call this even if allocation failed, for MEMCG_SWAP_FAIL.
+	 * A vswap entry has no physical swap yet, so only record the memcg.
+	 * folio_realloc_swap() charges it once backing is allocated.
+	 */
+	memcg = mem_cgroup_swap_get(folio);
+	if (memcg) {
+		if (!is_vswap_entry(folio->swap) &&
+		    unlikely(mem_cgroup_swap_charge(memcg, size))) {
+			mem_cgroup_swap_put(memcg, size);
+			swap_cache_del_folio(folio);
+		} else {
+			mem_cgroup_swap_record(folio, memcg);
+		}
 	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
@@ -2126,6 +2138,36 @@ static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
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
+	 * v1 (memsw): entries keep their memsw charge across swapout
+	 * regardless of backing, so uncharge all of them. v2: only
+	 * swapfile-backed entries are charged, so uncharge just those.
+	 *
+	 * On v1 the id is written by __memcg1_swapout() as the folio leaves the
+	 * swap cache and cleared by memcg1_swapin() when it comes back, both
+	 * under the cluster lock. Callers still holding a cached folio are
+	 * outside that window and see @memcg_id == 0, so only the free path
+	 * uncharges. On v2 the id is set when swap is allocated, so those
+	 * callers do uncharge, which balances the charge folio_realloc_swap()
+	 * took.
+	 */
+	n = do_memsw_account() ? batch_nr : batch_nr_swapfile;
+	if (!n)
+		return;
+
+	rcu_read_lock();
+	memcg = memcg_id ? mem_cgroup_from_private_id(memcg_id) : NULL;
+	rcu_read_unlock();
+	mem_cgroup_swap_uncharge(memcg, n);
+}
+
 /**
  * __vswap_release_backing - release the backing of a range of vtable slots
  * @ci: the locked vswap cluster
@@ -2146,12 +2188,25 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 	unsigned int ci_off;
 	unsigned long vt;
 	swp_entry_t phys_first = {};
+	unsigned short batch_id, cur_id;
+	unsigned int batch_nr = 0, batch_nr_swapfile = 0;
 
 	lockdep_assert_held(&ci->lock);
 	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	batch_id = __swap_cgroup_get(ci, ci_start);
 
 	for (ci_off = ci_start; ci_off < ci_start + nr; ci_off++) {
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
 
 		/* The free helper takes one contiguous run within one cluster. */
 		if (phys_off_start != phys_off_end &&
@@ -2169,6 +2224,7 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 
 		switch (vtable_type(vt)) {
 		case VSWAP_SWAPFILE:
+			batch_nr_swapfile++;
 			if (phys_off_start == phys_off_end) {
 				phys_first = vtable_to_phys(vt);
 				phys_off_start = swp_offset(phys_first);
@@ -2200,6 +2256,8 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 				phys_off_start % SWAPFILE_CLUSTER,
 				phys_off_end - phys_off_start);
 	}
+
+	vswap_uncharge_cgroup_batch(batch_id, batch_nr, batch_nr_swapfile);
 }
 
 /**
@@ -2289,7 +2347,10 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
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
@@ -2298,18 +2359,37 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
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
 
 	phys_entry = folio_alloc_phys_swap(folio);
 	if (!phys_entry.val)
 		return (swp_entry_t){};
 
-	voff = swp_cluster_offset(vswap_entry);
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	if (!memcg || mem_cgroup_private_id(memcg) != memcg_id)
+		memcg = memcg_id ? mem_cgroup_from_private_id(memcg_id) : NULL;
+	rcu_read_unlock();
+
+	if (mem_cgroup_swap_charge(memcg, nr)) {
+		__swap_cluster_free_phys_backing(__swap_entry_to_info(phys_entry),
+						 __swap_entry_to_cluster(phys_entry),
+						 swp_cluster_offset(phys_entry),
+						 nr);
+		return (swp_entry_t){};
+	}
 
-	ci = __swap_entry_to_cluster(vswap_entry);
-	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
 	spin_lock(&ci->lock);
 	/*
 	 * Install PHYS backing without freeing any prior contents of the
@@ -2494,6 +2574,25 @@ static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 	swap_cluster_unlock(pci);
 }
 
+/*
+ * Release the cgroup accounting of a batch of freed slots. For vswap the
+ * physical swap was already uncharged by __vswap_release_backing(), so only
+ * the ID ref is left to drop.
+ */
+static void memcg_swap_free(unsigned short id, unsigned int nr, bool is_vswap)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(id);
+	if (memcg) {
+		if (!is_vswap)
+			mem_cgroup_swap_uncharge(memcg, nr);
+		mem_cgroup_swap_put(memcg, nr);
+	}
+	rcu_read_unlock();
+}
+
 /*
  * Free a set of swap slots after their swap count dropped to zero, or will be
  * zero after putting the last ref (saves one __swap_cluster_put_entry call).
@@ -2506,10 +2605,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned int batch_off = ci_off;
+	bool is_vswap = swap_is_vswap(si);
 
 	VM_WARN_ON(ci->count < nr_pages);
 
-	if (swap_is_vswap(si))
+	if (is_vswap)
 		__vswap_release_backing(ci, ci_start, nr_pages);
 
 	ci->count -= nr_pages;
@@ -2533,14 +2633,14 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		id_cur = __swap_cgroup_clear(ci, ci_off, 1);
 		if (batch_id != id_cur) {
 			if (batch_id)
-				mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+				memcg_swap_free(batch_id, ci_off - batch_off, is_vswap);
 			batch_id = id_cur;
 			batch_off = ci_off;
 		}
 	} while (++ci_off < ci_end);
 
 	if (batch_id)
-		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+		memcg_swap_free(batch_id, ci_off - batch_off, is_vswap);
 
 	__swap_cluster_finish_free(si, ci, ci_start, nr_pages);
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index 56315298c291..aac09970c4d1 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1130,11 +1130,17 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 **********************************/
 /*
  * vswap zswap entries get a physical slot allocated on demand at writeback
- * time. Skip the shrinker when none is available.
+ * time, and that slot is charged to @memcg. Skip the shrinker when either
+ * the device or the cgroup has no room left. @memcg may be NULL to check
+ * the device alone.
  */
-static bool zswap_writeback_possible(void)
+static bool zswap_writeback_possible(struct mem_cgroup *memcg)
 {
-	return !vswap_is_enabled() || get_nr_swap_pages() > 0;
+	if (!vswap_is_enabled())
+		return true;
+	if (!memcg)
+		return get_nr_swap_pages() > 0;
+	return mem_cgroup_get_nr_swap_pages(memcg) > 0;
 }
 
 /*
@@ -1199,9 +1205,10 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 *
 	 *    Temporary failures, where the same entry should be tried
 	 *    again immediately, almost never happen for this shrinker.
-	 *    We don't do any trylocking; -ENOMEM comes closest,
-	 *    but that's extremely rare and doesn't happen spuriously
-	 *    either. Don't bother distinguishing this case.
+	 *    We don't do any trylocking; -ENOMEM comes closest, but
+	 *    zswap_writeback_possible() keeps the shrinker off cgroups
+	 *    with no physical swap headroom, and it doesn't happen
+	 *    spuriously either. Don't bother distinguishing this case.
 	 */
 	list_move_tail(item, &l->list);
 
@@ -1274,7 +1281,7 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
-	if (!zswap_writeback_possible())
+	if (!zswap_writeback_possible(memcg))
 		return 0;
 
 	/*
@@ -1361,7 +1368,7 @@ static struct shrinker *zswap_alloc_shrinker(void)
  * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
  *
  * Also returns -ENOENT when vswap is enabled and there is no physical
- * swap to write back to.
+ * swap for @memcg to write back to.
  */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
@@ -1370,7 +1377,7 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
-	if (!zswap_writeback_possible())
+	if (!zswap_writeback_possible(memcg))
 		return -ENOENT;
 
 	/*
@@ -1401,7 +1408,7 @@ static void shrink_worker(struct work_struct *w)
 	int ret, failures = 0, attempts = 0;
 	unsigned long thr;
 
-	if (!zswap_writeback_possible())
+	if (!zswap_writeback_possible(NULL))
 		return;
 
 	/* Reclaim down to the accept threshold */
@@ -1482,7 +1489,7 @@ static void shrink_worker(struct work_struct *w)
 			break;
 resched:
 		cond_resched();
-	} while (zswap_total_pages() > thr && zswap_writeback_possible());
+	} while (zswap_total_pages() > thr && zswap_writeback_possible(NULL));
 }
 
 /*********************************
-- 
2.53.0-Meta

