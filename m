Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D3038AC65
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 15:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671984; cv=none; b=HnFxG4zFnu4G1OSDT1BkgL3pQhzPO9wDUvQ1+XGevQhJpy/YyUZ+iC7PPIusMC4QQ44JGjEfLKEdYjmExJU6xiIi71YSSqf2zfajomjIJvxxeOau/CmdKroxtPpFsHEp/L5cZMsXNWjEb/jxyWiQHW7ScrfBcQkTYibLivZzLrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671984; c=relaxed/simple;
	bh=OBXKrqbaXwvmCx1KQK9eEvnh7PwXgK4ThqqYLp1zz5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rsw8/10RxD7rilATgFmskeSt7QSKJV6piWjKggEuvAELnweBzHFklbXpl6O9+meffQtwaqyyrUCeEUmUmvoAPxWjQp0PwRyd5JBmBps3peeaIIEksnIo7Wu5WG8Gly8w1XnkP2pzH1u9qyetPFzX/LN/3g4RTm4eUb/JfRo0Z2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XVnVECjM; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XVnVECjM"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7eb6573bd52so4955023a34.3
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 08:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671974; x=1788276774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zlGXhprJFuKNO99yNrTPz5qKVmgEA/flDFbSYzcy7Gk=;
        b=XVnVECjMhN4SbdauoVI+j9MRsd9y2Rep+95kjF/jWSPF0M+WK47XdBviZoPHaIcZiP
         dT+w83p0RqR8tcRn0npsn75xkor19gWKlqGnCjIUHRq3V0RK6zZ3PY1UTfrXNrZfNSYE
         BAuAABHx3Y9uoMk7q7J5KuXgBn4MsQmncCa1KBt1EXKty6mpxq1yLPT3MYWIO2X9w0Gq
         pW6MfEW9gA9KExyg7bRj+mzfy1upIbPbThZnidcKxT/cze+ua54bmVmlppxbGEVHSOQn
         ZMk7sck8nHdrBnbCyhZumf/8prKDrA+VPidUCkHH2N4N/msn7aoAYU+3fDuB2d+zH3EJ
         o+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671974; x=1788276774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zlGXhprJFuKNO99yNrTPz5qKVmgEA/flDFbSYzcy7Gk=;
        b=YxSfvIPsHNnHMfyk2LAfQ7sWMXtHKfWTvL7WKQ9g75Q28+arCy9cd8k90CEJs0vhDr
         QmuLCKUAs36BHgzx8aTq2aRBtnsSLUG+gUCrrwEB8VXKv2jwjfqPW1Po5A0meMm1x8S4
         DcqVCg3/3QlDuJAOviOB3CBWOOr2IyukhS/Fus5TUts9/3dnumNUFSAIkXn+XzkD4SND
         d6zhVI88X3llvf9ZAaHyLNxuAoaf5wx/TiwNOZtBWh3QzM+fI1zHA1oUd9L+fAYTRLEL
         hBAOfHkpLSfeSwW2OLYwZL3BdXtY/9RBEbRacLt/wClnQTabUrUn1c+u6VChPniNC4CC
         V2/Q==
X-Forwarded-Encrypted: i=1; AHgh+RqE6dtxc9DVrlSeRpwHdcP1rWEU5N1R+tarrRA9Kj6zBAAfXjcPz5LjEBj8/FtP03eM1Goe9j1C@vger.kernel.org
X-Gm-Message-State: AFuF++mmor9pUGtWEFxpY0PNWip5j4lOzbtYq34EqaPoX2quhDEWpqJq
	aYl6Oxpn0Em7NEAOKyTE8KAzS8uN2bL9Pfjg0pYMXUAFX0QltS+0jNvY
X-Gm-Gg: AR+sD11pHUbFfLNcEkEOZVPLdx5o0cRyRR+BlP6hYrJzmL3QAwaJ4Hqh0krlV1tCgD+
	0UZp0k7QMpRgGCNmx779Cvyo4E/RZ/fKQApKBNeGeVhdLgi24uX7jZ3H4UKzdH6KtSYqjkZFKly
	pYSh2AyIVJmwe4tQgr/B9s+CtDRroWo95+gHaZVquYaeCfKgamCeGacZsuKiaxwYm29zjBFvNv2
	AHYEmhQDESVxClvrWveJrcHBRxe3LZH62joAIURi1mpGY6oZNIMlEhaLC3u9dfCNrvzIohfLVYt
	NuTI27tu+s8PFANaQHg0TjQzzAZijqfQPNPvjZYUUbOD3fJptUVKUXYlIeEfaIsNVUVFYn96l4i
	2RgznCj7B2OcqtencQGuSD9+5TP8/wFrQwLr42ngbT/sOBjD9JGKx+d3bwr2hbf04GNW9O1mW4z
	UKfGyhVcXWf4WZMqfBqio5EEfT3POfIEVczBHGyaT/1nwDhUls538Hx09S01d9MmgOU+yJvIuSK
	KmpMrCAHg4=
X-Received: by 2002:a05:6820:5507:b0:6ac:8e23:3078 with SMTP id 006d021491bc7-6b1591d99b6mr26775658eaf.5.1787671973954;
        Tue, 25 Aug 2026 08:32:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:52::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b17c8328c2sm6742797eaf.4.2026.08.25.08.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:53 -0700 (PDT)
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
Subject: [PATCH v4 08/11] mm, swap: only charge physical swap entries
Date: Tue, 25 Aug 2026 08:32:34 -0700
Message-ID: <20260825153238.2695446-9-nphamcs@gmail.com>
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

Zswap-backed and zero-filled pages occupy no swap space, but were charged
against memcg->swap as though they did.

Charge memcg->swap when a vswap entry acquires physical backing rather
than when it is allocated.

memory.swap.current therefore counts only on-disk swap usage, not
zswap-backed or zero-filled pages. When vswap is enabled, a cgroup can
reclaim its anon memory even with memory.swap.max set to 0, provided
zswap is allowed for it.

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
 include/linux/memcontrol.h                    |   6 +
 include/linux/swap.h                          |  61 +++++++-
 mm/memcontrol-v1.c                            |  10 +-
 mm/memcontrol.c                               | 148 +++++++++++-------
 mm/swapfile.c                                 | 128 +++++++++++++--
 6 files changed, 279 insertions(+), 76 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memcg_test.rst b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
index ebedbc3c3f9c..13b9ae800b72 100644
--- a/Documentation/admin-guide/cgroup-v1/memcg_test.rst
+++ b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
@@ -43,7 +43,7 @@ Please note that implementation details can be changed.
 	mem_cgroup_uncharge()
 	  Called when a page's refcount goes down to 0.
 
-	mem_cgroup_uncharge_swap()
+	mem_cgroup_swap_uncharge()
 	  Called when swp_entry's refcnt goes down to 0. A charge against swap
 	  disappears.
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 215e2e87f42b..4d89a35f49ff 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1905,6 +1905,7 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
+bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
@@ -1913,6 +1914,11 @@ static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
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
index f57f4aeeb822..95386a86d3fd 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -501,35 +501,80 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
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
 
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
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
 static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 05ef55cae4dc..88016c8f22a2 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -690,6 +690,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 void memcg1_swapin(struct folio *folio)
 {
 	struct swap_cluster_info *ci;
+	struct mem_cgroup *memcg;
 	unsigned long nr_pages;
 	unsigned short id;
 
@@ -721,7 +722,14 @@ void memcg1_swapin(struct folio *folio)
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
index 8508fc7e2dfd..6ae0a4191d88 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5722,93 +5722,129 @@ int __init mem_cgroup_init(void)
 
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
 {
-	long nr_swap_pages = get_nr_swap_pages();
+	long nr_swap_pages;
 
 	/*
-	 * vswap zswap-backed swapout needs no physical slot, so gate anon
-	 * reclaim on the swap.max headroom instead of the physical free count.
+	 * vswap charges physical backing, not allocation, so virtual swap is
+	 * unbounded for a zswap-capable memcg and the swap.max walk below
+	 * would starve anon reclaim. swap.max is still enforced when the
+	 * backing is charged.
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
@@ -5980,8 +6016,10 @@ static struct cftype swap_files[] = {
 
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
@@ -5991,36 +6029,38 @@ static struct cftype swap_files[] = {
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
index 6ec439462490..517fa58f8022 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -46,6 +46,7 @@
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
+#include "memcontrol-v1.h"
 #include "swap_table.h"
 #include "vswap.h"
 #include "internal.h"
@@ -2015,6 +2016,7 @@ static swp_entry_t folio_alloc_phys_swap(struct folio *folio)
 int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
+	struct mem_cgroup *memcg;
 	unsigned int size = 1 << order;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -2041,9 +2043,21 @@ int folio_alloc_swap(struct folio *folio)
 	if (!vswap_alloc(folio))
 		folio_alloc_phys_swap(folio);
 
-	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio)))
-		swap_cache_del_folio(folio);
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
+	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
 		return -ENOMEM;
@@ -2101,6 +2115,36 @@ static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
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
@@ -2122,12 +2166,27 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
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
 
 		/* The free helper takes one contiguous run within one cluster. */
 		if (phys_start != phys_end &&
@@ -2146,6 +2205,7 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 
 		switch (vtable_type(vt)) {
 		case VSWAP_SWAPFILE:
+			batch_nr_swapfile++;
 			if (phys_start == phys_end) {
 				phys = vtable_to_phys(vt);
 				phys_start = swp_offset(phys);
@@ -2179,6 +2239,8 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 			phys_start % SWAPFILE_CLUSTER,
 			phys_end - phys_start);
 	}
+
+	vswap_uncharge_cgroup_batch(batch_id, batch_nr, batch_nr_swapfile);
 }
 
 /**
@@ -2265,7 +2327,10 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
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
@@ -2274,18 +2339,37 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
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
@@ -2465,6 +2549,25 @@ static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
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
@@ -2477,10 +2580,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned int batch_off = ci_off;
+	bool is_vswap = swap_is_vswap(si);
 
 	VM_WARN_ON(ci->count < nr_pages);
 
-	if (swap_is_vswap(si))
+	if (is_vswap)
 		__vswap_release_backing(ci, ci_start, nr_pages);
 
 	ci->count -= nr_pages;
@@ -2504,14 +2608,14 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
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
-- 
2.53.0-Meta

