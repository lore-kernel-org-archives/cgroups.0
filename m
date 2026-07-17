Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2E83ECBE2
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 12:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784291149; cv=none; b=q5Yz8n2Q35bADeolVGENfrDxX3iqKmk+tucfk5jGBA1dHrUNWq4u1HnEPltxV5pNKDykvuIO2xqBYy5zbgGDVF4vBo6ruT7PFwIh8+cRGzvhhMAOETFu8g4Xhnn/OvRfYZRfBqXpx1nFFs71euv6zPoxgWlIDFPzICsBTCQbulE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784291149; c=relaxed/simple;
	bh=Fjfc8fgQPzeyzhc9k0VdSPjgLCvAlCl42eml0gPXRh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcB6BENVfxH49nD2qMGDmkntJp0Q4ijkWifGlPQqtKqpdDhGAvhkG+VBMs38DkFoyY7mMpVKDNiWQkRJEptRr9DkvP0R/t2SJsFo4KlHWVP/GoNvt+70u+SH7YSoBpHbcBXcf71JCrz+NALd9luXhBS191CBaVHHF1JeNQTiWrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hm7AGdLr; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hm7AGdLr"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ccdce28edeso13521185ad.0
        for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 05:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784291144; x=1784895944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NdpVmifpRBJ5SJh8r5+PpSs+j8VMT6d4fWNM6qfZmYA=;
        b=Hm7AGdLrPtEZ5HxLlbebckgrO8ckUmPIeB7yyD8zfyF+8dFm3xbhyaRYOqBA4tsKLb
         jRRsv+fGE/ocB7HjGXVNP2FXFKFf7FmiEEJ00cLhbnezZZ0H/PmbwWV/b/+jbmBWpacq
         KRMb2wGI89vC/Gj06dXc8VyrbxFeoR4oG8eA4KzRfXBj+rvFpWkw66EYI+fSDY/FknKt
         jv7Cay7t9HyqxyviAafp+6FG4zh3wuU3R7Xv5LSLgwcWwIwOdvCKg26JF8ZNMtxxJ/fd
         fRCgbph8pUWz7pcJeYn+Ew1wZv0caVRLxsrpvA9q1J+HSbKd7tYadBWvvsxa2zlS/2va
         toSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784291144; x=1784895944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NdpVmifpRBJ5SJh8r5+PpSs+j8VMT6d4fWNM6qfZmYA=;
        b=EmRBrlSibCGKBd4GMoSg9yl1jbI1vQSEXVODiL8mlF+ellooaCU/g/hLXdm+QhFX3D
         5gs+hu5+rlWNZjt4o50dYZvSynni7Q2bVRQXYJnWeN1S0Lw6m0XcJ8MsiWODD2XlTTge
         M1gGz7LawgdePpOfHvb8FP5A/D8sAwfsTvdRzHCiKiXA9CSGXPv9dfk3DhCIX+biKObD
         98VnAD/TWbc1CAkUGpcCz79iXqL4x7GaJyrBAdrAS6znUrG/3OWJvXUbep5YI6iHvs/4
         8zQcBIHuRS0WnnPgtMiyKe89y06/Xm4InU1e6Y2PfT3pwTa8fDVClUnENX/PykoHO9TC
         h6TA==
X-Forwarded-Encrypted: i=1; AHgh+RpDCmZXjK/WntKr2OhW3H2m2EVmc4WwXHmOssMJbg3YUlTfvXUN/XrFj1/BDSC8xiS2lKS/rveE@vger.kernel.org
X-Gm-Message-State: AOJu0YzBpJFHwC6XfJyJSZl0PkFhk5XTmPygqMkiFz3u80qSBMfsmdQe
	vrVsnK3Q3KRvI+cEUfsfdfJy249q388DdCj5X1AD40S7p4z2w7av2+CJ
X-Gm-Gg: AfdE7ckoC8XwuGULuoaN+6eVzT541qvv1MceSukdSVlMoSCEy6j9TzOw2dk/m10/M1u
	s9Bs3YyO8tLSDn6B2AzKCTclm+V7gNJg2pEYgR37L6neh2nPrH2L7CNELdgUPuX1feYfmqiww+9
	L9tcju04kA+CNA2spULXZ8nnDFh3faMWjeXZDKdvBi78pqdUne/GNlwSX9LwluzwSiuNkt3d3x/
	g79QXOIl+4Og2U5ipSEmnojrSSnj4NB/hDpBOIg8XNWYaLgKYS7SQ/LyqWOL6TM5g3mKmmsINlS
	CkrGlbjE8hpvyuAGflnoyQjhhb6PNfM/LXkE3g17qQXorSQZQaUdcUgzCKWI7EIxg+ULKfnswBL
	V2iY303Pd9hxnqhOse5+s1vUokzOSg66I33wlL1jyIwA2cBdPlg6aMD3VuHrmQeVRbUVVIt9ih7
	HZSg8lpEgmkpgItb+fs8XRc674fyOKnvmoqL5psFWox00N
X-Received: by 2002:a17:903:41c4:b0:2ca:11ee:b002 with SMTP id d9443c01a7336-2cf349faca5mr18400775ad.5.1784291143790;
        Fri, 17 Jul 2026 05:25:43 -0700 (PDT)
Received: from debian.lan ([240e:391:eb4:a240::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347119dfsm9935955ad.56.2026.07.17.05.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 05:25:43 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	baohua@kernel.org,
	zhaonanzhe@xiaomi.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
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
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v3 2/4] mm: distinguish large folio swap allocation failures
Date: Fri, 17 Jul 2026 20:25:12 +0800
Message-ID: <20260717122514.51514-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717122514.51514-1-xueyuan.chen21@gmail.com>
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com>
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

Track the global free swap count around the allocation attempt and let the
memcg swap charge path cap it by the remaining hierarchical swap margin.
Return -E2BIG for large folios when a smaller allocation might still fit,
-ENOSPC when no swap space is available, and -ENOMEM when the failure is
not helped by splitting.

This only refines folio_alloc_swap() return codes. The reclaim caller is
updated separately.

Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/swap.h | 10 ++++++----
 mm/memcontrol.c      | 10 +++++++++-
 mm/swapfile.c        | 21 +++++++++++++++------
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..0695ac56457f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -571,13 +571,14 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
+int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
+				 long *nr_swap_pages);
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-		swp_entry_t entry)
+		swp_entry_t entry, long *nr_swap_pages)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio, entry);
+	return __mem_cgroup_try_charge_swap(folio, entry, nr_swap_pages);
 }
 
 extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
@@ -592,7 +593,8 @@ extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-					     swp_entry_t entry)
+					     swp_entry_t entry,
+					     long *nr_swap_pages)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1e10f493d2a9..7c9e7072fb39 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5472,12 +5472,14 @@ int __init mem_cgroup_init(void)
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
  * @entry: swap entry to charge
+ * @nr_swap_pages: optional swap availability to cap by memcg margin
  *
  * Try to charge @folio's memcg for the swap space at @entry.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
+int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
+				 long *nr_swap_pages)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct page_counter *counter;
@@ -5495,6 +5497,9 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	if (!entry.val) {
+		if (nr_swap_pages && !mem_cgroup_is_root(memcg))
+			*nr_swap_pages = min(*nr_swap_pages,
+					     page_counter_margin(&memcg->swap));
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
 		return 0;
@@ -5509,6 +5514,9 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		mem_cgroup_private_id_put(memcg, nr_pages);
+		if (nr_swap_pages)
+			*nr_swap_pages = min(*nr_swap_pages,
+					     page_counter_margin(counter));
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9174f1eeffb0..53a921ca099a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1690,12 +1690,14 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
  * swap cache.
  *
  * Context: Caller needs to hold the folio lock.
- * Return: Whether the folio was added to the swap cache.
+ * Return: 0 on success, -E2BIG if splitting the folio might allow swapout,
+ * or another negative error code if splitting would not help.
  */
 int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	long nr_swap_pages;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1706,7 +1708,7 @@ int folio_alloc_swap(struct folio *folio)
 		 * the caller should split the folio and try again.
 		 */
 		if (!IS_ENABLED(CONFIG_THP_SWAP))
-			return -EAGAIN;
+			return -E2BIG;
 
 		/*
 		 * Allocation size should never exceed cluster size
@@ -1714,10 +1716,12 @@ int folio_alloc_swap(struct folio *folio)
 		 */
 		if (size > SWAPFILE_CLUSTER) {
 			VM_WARN_ON_ONCE(1);
-			return -EINVAL;
+			return -E2BIG;
 		}
 	}
 
+	nr_swap_pages = get_nr_swap_pages();
+
 again:
 	local_lock(&percpu_swap_cluster.lock);
 	if (!swap_alloc_fast(folio))
@@ -1730,11 +1734,16 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
+						&nr_swap_pages))) {
 		swap_cache_del_folio(folio);
+		return order && nr_swap_pages > 0 ? -E2BIG : -ENOMEM;
+	}
 
-	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+	if (unlikely(!folio_test_swapcache(folio))) {
+		nr_swap_pages = get_nr_swap_pages();
+		return order && nr_swap_pages > 0 ? -E2BIG : -ENOSPC;
+	}
 
 	return 0;
 }
-- 
2.47.3

