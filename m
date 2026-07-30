Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3CF384238
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 02:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377850; cv=none; b=b3HW6aPkAbOl2zj1OLog+7tV7ehSGLnzFoi1qu1dyLWV0lDWNsW7dFHAe7rKTg+PTLSRbbDedDBFyL0C4BtyVJbVlIOSKVcTr/80C29B5PVa7Xse9uXFmc9JzgbmNAuZ4gfcWN4F57HdKZReHLvzi5VU3YnirxDLi9gu+HAx2uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377850; c=relaxed/simple;
	bh=6Nq6xfhSAgQSwLbnXYwURRCiUQDNKGF4BxoQX9MuwgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMzverdcvM8Mcf9Oz69OxB5NRFQryPccSDfCFLnb0/YlWh88Z8gwYqVy3SF09dh/ZdocSP1f99EVOmNOyFh9FYtvPHif9p0OcnZuU71jerYIvAZh0mKOJe5Ll6gc06oYrYud15At6UPJ6SRqxZkl2ZN9LJmksvjkTkTRCsRZXOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xa1nMn5M; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xa1nMn5M"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84eb53344afso120133b3a.3
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 19:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785377837; x=1785982637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=32qTViblj4WdG3yffSuiPSX88DSQgp+MB+zeQ6Jntjc=;
        b=Xa1nMn5MdISMyyWwvuH6S40B56DZXYcrJGJaGAR+SSdiJCVY+CGqgJsFhEZxOWbHq5
         d661S/VmajT1m/vNqjqChWO7eGHQ5481gQnF/wlGvvorrp1QxHw8MQXDmDB+c8QW4agn
         Wk/Xhqnw/NG/N0W/tUaF8gEzLrKAokSIeyn4ag1/s5H/e4BymJjQM/VZccEak32FBORS
         fmF5qQhuW3L7joNJp5kSZ6Ujs+ptrK4isPm0fOmONJs0zMzdVHlvK61W7g0kleD7lA+c
         p9CAQFB/6Ryj4qVwQ3NHf5/g3p12X3zm3dUJ2p9SBKGg24u4q9Pp+DTDbkjU8/yXGJBe
         V/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377837; x=1785982637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=32qTViblj4WdG3yffSuiPSX88DSQgp+MB+zeQ6Jntjc=;
        b=UzyxBe+CtUDuL7IWnzVmzWRwRl4CbnR5MGu1EJGuEetrAVWWPou/bCwP40pS6frTia
         UaTeSGUV5lQq7gmdsV/tXS04MU9ER/5RzQPElQJoK04MlI1e3zx2H+UeB+dJvtVk6F4l
         xxYjYdoe0bkhfURWvJKCHjRaXR5yIBmqepZ/t42SqgbPA28ZU86iWApjZTw9GTQdhre4
         ZUC0OkCzudjwCn98WVNlroN+BkrYdMFxIQCU3AA+ppQD9TV/4VkG7R1E9nZ/uc1IO2dZ
         ACJDt1yAbf0C7CZF+VibrBxLsoRE4mApjaWK9ebnMHy7JVoTRY2x6UYvmtv3hBGATws/
         4qyw==
X-Forwarded-Encrypted: i=1; AHgh+Rq2+5xPJ19K3pgHhInwOLFNjiWn+aSUCw/tZReB0MyzHn/1n19ZzDb8Yk0G6Qt5ay16rSEhOo5T@vger.kernel.org
X-Gm-Message-State: AOJu0YxcR+R3Ca6Dz/emXNNQ0bo1UaW583W1QXXHl98WVnkIQBzcZ4JZ
	duE0+MyPTzLO75eq2G2VfGbQN0u6OImGFEI5z2Jfl6X3urJCO+fFJQHW
X-Gm-Gg: AR+sD11HlN05K0TbkOmoSSlIo94oZw6VuFTbqZQTSnQAMsu/ny4DmnVJgB7KI5lFm/g
	Df+rp2j6N19NaWa1htojQjuYmnj8p7r+wlwLXYGDAf/dxRMMVJBASG4gltP0xURBcQk7dL5uRPi
	tNujKeF5h07E2dbIHhrG4lYciOYnIna5i/doCluR8wqLAFhbon8NhXm/o9OLFlaSZJCiecxxypq
	W7NyLFcxeMXZcIHpMf8KpujVc7E1Vxr+BMMNLmVBO74Y3ZWRnNw8L90mfgMIObYz+bsRKSBqdK1
	Ry9AgnheG3T03s1xcjy0vtmWWcFea2VK8FkJIABTgWLifrgD5hkZggJFiHq40ypyJXkgb6nXj+E
	PDagmpguoOaXFei3DmsYKkVArSOHL+fkW5mUSOhgWDHBTPD8rEtREnvh8iSKDzZcUbJpz7oXykC
	WDOqbV5XhA5HAj60AxyLyfav5W3PgJeM3BOANyO1pq50wwuaE4XGQCoCNmB73PnCIYz9xVKssmY
	xhXSCWCjFy2oquh66gub3EE/D3aS3HQa0E2YB97HaoxjFqhb6HD
X-Received: by 2002:a05:6a00:4e02:b0:845:cb89:c1a3 with SMTP id d2e1a72fcca58-84ebc1ed5f0mr801314b3a.1.1785377837315;
        Wed, 29 Jul 2026 19:17:17 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23143sm2159628b3a.2.2026.07.29.19.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:17:16 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v4 2/4] mm: distinguish large folio swap allocation failures
Date: Thu, 30 Jul 2026 10:16:28 +0800
Message-ID: <20260730021630.2235914-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
References: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

folio_alloc_swap() reports most allocation failures with a generic
negative error code. Reclaim cannot tell whether splitting a large folio
could make progress or whether there is no backing space at all.

Keep the global free swap count and the remaining hierarchical memcg swap
margin as separate inputs. The memcg charge path reports only its own
margin; folio_alloc_swap() combines the two layers when classifying an
allocation failure.

Return -E2BIG for large folios when a smaller allocation might still fit,
-ENOSPC when no global swap space is available, and -ENOMEM when the
failure is not helped by splitting.

For early large-folio rejections, check global and memcg swap availability
instead of returning -E2BIG unconditionally. On a memcg charge failure,
swap slot allocation has already succeeded, so use the remaining memcg
margin to decide whether a smaller charge might fit.

This only refines folio_alloc_swap() return codes. The reclaim callers are
updated separately.

Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/swap.h | 16 ++++++++++++----
 mm/memcontrol.c      | 32 +++++++++++++++++++++++++++++++-
 mm/swapfile.c        | 32 ++++++++++++++++++++++++--------
 3 files changed, 67 insertions(+), 13 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0544b2ec4c56..7d12058174ae 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -509,12 +509,13 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio);
-static inline int mem_cgroup_try_charge_swap(struct folio *folio)
+int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin);
+static inline int mem_cgroup_try_charge_swap(struct folio *folio,
+					     long *swap_margin)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio);
+	return __mem_cgroup_try_charge_swap(folio, swap_margin);
 }
 
 extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages);
@@ -525,10 +526,12 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
 	__mem_cgroup_uncharge_swap(id, nr_pages);
 }
 
+long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
-static inline int mem_cgroup_try_charge_swap(struct folio *folio)
+static inline int mem_cgroup_try_charge_swap(struct folio *folio,
+					     long *swap_margin)
 {
 	return 0;
 }
@@ -538,6 +541,11 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id,
 {
 }
 
+static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	return PAGE_COUNTER_MAX;
+}
+
 static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 109c08be91cf..fb0ec439ba2d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5592,12 +5592,13 @@ int __init mem_cgroup_init(void)
 /**
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
+ * @swap_margin: remaining memcg swap margin if allocation or charge fails
  *
  * Try to charge @folio's memcg for the swap space at folio->swap.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio)
+int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct swap_cluster_info *ci;
@@ -5616,6 +5617,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	if (!folio_test_swapcache(folio)) {
+		*swap_margin = page_counter_margin(&memcg->swap);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
 		return 0;
@@ -5629,6 +5631,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+		*swap_margin = page_counter_margin(counter);
 		mem_cgroup_private_id_put(memcg, nr_pages);
 		return -ENOMEM;
 	}
@@ -5676,6 +5679,33 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 	return nr_swap_pages;
 }
 
+/**
+ * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
+ * @folio: folio whose memcg margin is queried
+ *
+ * Return: Remaining chargeable pages in the folio's memcg hierarchy.
+ */
+long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	long swap_margin = PAGE_COUNTER_MAX;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	if (mem_cgroup_disabled() || do_memsw_account())
+		return swap_margin;
+
+	objcg = folio_objcg(folio);
+	if (!objcg)
+		return swap_margin;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	swap_margin = page_counter_margin(&memcg->swap);
+	rcu_read_unlock();
+
+	return swap_margin;
+}
+
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 70b90fa9c2a0..ae62c9f9c0f2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1735,23 +1735,28 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
  * swap cache.
  *
  * Context: Caller needs to hold the folio lock.
- * Return: Whether the folio was added to the swap cache.
+ * Return: %0 on success, %-E2BIG if splitting the folio might allow swapout,
+ * %-ENOSPC if no global swap space is available, or %-ENOMEM if splitting
+ * would not help.
  */
 int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	long swap_margin = PAGE_COUNTER_MAX;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
 	if (order) {
 		/*
-		 * Reject large allocation when THP_SWAP is disabled,
-		 * the caller should split the folio and try again.
+		 * Reject large allocation when THP_SWAP is disabled. Check below
+		 * whether splitting and retrying can make progress.
 		 */
-		if (!IS_ENABLED(CONFIG_THP_SWAP))
-			return -EAGAIN;
+		if (!IS_ENABLED(CONFIG_THP_SWAP)) {
+			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
+			goto failed;
+		}
 
 		/*
 		 * Allocation size should never exceed cluster size
@@ -1759,7 +1764,8 @@ int folio_alloc_swap(struct folio *folio)
 		 */
 		if (size > SWAPFILE_CLUSTER) {
 			VM_WARN_ON_ONCE(1);
-			return -EINVAL;
+			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
+			goto failed;
 		}
 	}
 
@@ -1775,13 +1781,23 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio, &swap_margin))) {
 		swap_cache_del_folio(folio);
+		return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
+	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+		goto failed;
 
 	return 0;
+
+failed:
+	if (get_nr_swap_pages() <= 0)
+		return -ENOSPC;
+	if (swap_margin <= 0)
+		return -ENOMEM;
+
+	return order ? -E2BIG : -ENOMEM;
 }
 
 /**
-- 
2.47.3

