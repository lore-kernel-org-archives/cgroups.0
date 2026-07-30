Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E22423783
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 12:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785414231; cv=none; b=Dif8dJhKb2rbQLG3xlgPXgM5vxkrA5oxwMLabTUPGbJj38SAF8X/+G4ZOLpgOXfz79T07bg/BNbqWSTbTCKBpBsscUcTr2pMDUnM1587F4xrG+9iqkpHRedhs172eYqDj5Qe9vND41bFlHPBM1wyKtSMTzZluh6e93wG3xDS1uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785414231; c=relaxed/simple;
	bh=6Nq6xfhSAgQSwLbnXYwURRCiUQDNKGF4BxoQX9MuwgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGYxMPp5XJF4VxypiNoLA0IXVd2BI0KelElq83X8eBOcUu3LA3XM5PnK4E2Ldohy8hrJH9W2DeswGjR5kRmvc35eu6tZUfdtgE0UbeJiULh9b7VrOsE1Io9/oD+6LGG0MTeZlRUwqCpy/Ft4q07/s056OS7NOWoBrO2u3fKnnhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NdNQc6qM; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NdNQc6qM"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c96d7933910so239901a12.0
        for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 05:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414229; x=1786019029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=32qTViblj4WdG3yffSuiPSX88DSQgp+MB+zeQ6Jntjc=;
        b=NdNQc6qMf0i3veTrgyfEtAWJO1wus16voFz9DBRTaW31+KRpasKpunoiZ4Pus+mwsA
         m+dItRHks7ibk0ZDW+9xm9u46efQzy3xFvjLy/QscVbtP0CekdY1Dcq1sg56oCEADjX+
         OP/6/bJrpGOkOn5OGQBxlahblFQO70jDfWIukEZ7Bn65t/N9tLrrjpXRBXQ8WqiVt72B
         bxs/aiUbwfS14gxWQNaOLFXF5SwdsDE1WAUdjhu6ugzH+zjlZalU3g9QNhOYDlFm+fy2
         uE5tuMgrvQr6po6Nuoy9W2onkHP1ghS+Ge62FB9o39CkJ3liuJUO5dPiMkz+gnfAF1fx
         /rAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414229; x=1786019029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=32qTViblj4WdG3yffSuiPSX88DSQgp+MB+zeQ6Jntjc=;
        b=Wzi3BCVySHTJb1Z+0Hrc2dZc3ipkpRig36jm41FJRtySOxb4lvRQC6sOJQnL1015Yg
         z7eC8SxPNJMBY6XdGMohq61o3jy+rE1MycP7+RiSfp6WWz62eyEi2lnldAGa4ogLVGkQ
         5C2qZTo9DeHWfF9PKOd69KZdGcsmA/sLfQxOO6LiIO5+/w5kWdsd/ExPOJ8rRDURPLR9
         KF03qfYqsqaSErV85ceWVkBoUh8F1tENFJ7iuVVoOtAxkC6zWwqLAFTAHGddevrNEAN4
         jVJNh7i7y+3IqwgHE/dHmRCRRxj5acjqUF0U/fAk1/LwjWF+ojGLjhI7zRg+2NJ8I/3Y
         UH6Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp14kpu+1zc89xCnlzkUofk//1iJEZ3OXWZHliFwgmRLQ+5p71zk+vVPnotj06CNP+MZftdSNvE@vger.kernel.org
X-Gm-Message-State: AOJu0YxOdl3NuKtyV9/wRiUA/HK7Y/XS2fN4uLu+j1e3MXNcQpF9TEF4
	VxzmLgINmgWYKZJZVbB23CvKnOkWHAEOIufrThVRulW5Wk6t2rYxyMZr
X-Gm-Gg: AR+sD12BqN85wakru5g2kbQtgSpcj8L4tL2Xg3ftEJM87SKVjVX1gVE6SqvQXJzQOdS
	+REST3UBOwvKlW4LZLhNKxruKyFMh9L6RscqePCmv6l6n5o4Q8zkEZydrg7gM/aiIfyofgWvmXI
	Q6ug9lgqxfW3sbJoLki17YiqwmPPFEZT46k7VYIl0f+MTCddblo20HeE8vtwEyUFKpOigOj+oXF
	pzMO00U2XT7BnGosHdpfJZt7vCfBNkICbGrHRyAlfQWb5pA4lNvoLP5i0kNm5nKmArO0OV9nsrs
	35PT73X3sAaHMZHw7kOKzMqiFQZ8uBjUAfc9FSscwUfzGaj0fqnysZ1V1AijUkoqrNQEZ1RD0pj
	1zHm0TMgeydpFY1kB0GTYU01y7fYA1KDlIfnnjTjTRcr/Zi50JhiOn/19gHVBXBsQOznS4Hx4Dd
	u7yIjJWL7aeP5P73BLovFZh3v2oT/UeTcsUJOplPSINUTHPr2PDnnRdArSApV06fYEeP2R+wwIn
	Z5kE5fyoeFTXHbte97L/6oiizYXHgc04R6A+JTZSw6exwLH6m7k
X-Received: by 2002:a17:90b:4c52:b0:38e:c140:2a0b with SMTP id 98e67ed59e1d1-38f9beb5127mr2980493a91.3.1785414229126;
        Thu, 30 Jul 2026 05:23:49 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b72d243sm995698a91.10.2026.07.30.05.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:23:48 -0700 (PDT)
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
	weixugc@google.com
Subject: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation failures
Date: Thu, 30 Jul 2026 20:23:02 +0800
Message-ID: <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
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

