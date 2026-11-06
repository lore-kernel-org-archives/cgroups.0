Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.190
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793959583;
	b=aHavD9eI3eeIDCx+5YElOXiUM/wbghDlNAo1AbkNUGu9ZI9nICl+e6hA2shyT3vyXInw
	 Y+cmY6h6oUn50r6IbCw+JO/uF1c2TucCE9LKQIQAdS/gamvmN5cigu2UKkt+YIWdHOcdp
	 v3U7ffk1lsMIRMk9KUbb25OiSUKNETq85VRuvhpLpWVUJuRMYcjdPK5EA4Tx7i9gbOOM/
	 gGsd3UpnH/2T9Jo9gpGEvkRFymJlv/2B6iwmRJ7FCmKRcThInISzu6vwORJ250FahU8rL
	 D4PFwkA3vA78SWwUismfh/bVnMSDa9LS0qBGetp862eio8YuzQH9Gg2ATJjJNvtovUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793959583;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/9BnZCc3AyeXmUrPueWNphtKIjBY7I8CwK6A+9WhDPY=;
	b=42DpUKUXUZUBjqShVdruoRY5xxBqsOg3UwARRSi1sgfUh1NrpszhhOjV0HC3ABZ/sBQ+
	 3cKEb5x20oAZ52jzqMpOCW5GNTHyxlhmGndjSZtxvHMCKJnb1t3V0sa96fSEh7Fki7Cpj
	 xskl3MgdZVuJ/nDI3WFSYWtgvFwVTeA/YkBFk6Lp18ttBxLFmUBzHDheN6sHpXnYKsWih
	 ojAMmSiDGm1kcOJaRE95nIVxGDohHHoQf/Av/g5QQjtSpJqN3VdSGn019LWVDxcSGVzyP
	 KAO6/9rjvBLvR0iAt2LcmklTrZTpmaCsaUfvQuV2ChQE2DrIZtxOIMnmEfaYvLK0WOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XHqjXr+Q;
	arc=none smtp.remote-ip=95.215.58.190
Received: from mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9CF606A32C
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 10:06:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B9CF606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XHqjXr+Q
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cz8qa6DzkcisB34BFCPw3QEyfCK3GSBqxBmS2t4VIu4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959581; v=1; x=1794564381;
 b=XHqjXr+QHtEpiO2gAWd7JpqDjzsiNAXBluTaL59ZvfPvBL9bfhTMbQn/uEWvVr6RhNb9vCg+
 YoFapqP2M2Vjk9Y6q8a9w4cK415laXIAZom2hEVlMjqeG9U3/xlMhZH5Fdc4CMXsGvPbnZO0Nkp
 3U8gzbdDcF4QG+0uKMvkQTIM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0b034621e7146dc7;
	Fri, 06 Nov 2026 10:06:21 +0000
X-Mizu-Trace-ID: 0b034621e7146dc7
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 4/4] mm/hugetlb: Account NR_HUGETLB at folio state transitions
Date: Fri,  6 Nov 2026 18:05:21 +0800
Message-ID: <20261106100521.30099-5-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261106100521.30099-1-kaitao.cheng@linux.dev>
References: <20261106100521.30099-1-kaitao.cheng@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kaitao Cheng <chengkaitao@kylinos.cn>

NR_HUGETLB updates are spread across allocation entry points and
freeing paths, mixing node accounting with memcg statistics. This
makes the accounting harder to follow and requires compensating
updates when freeing unused surplus folios.

Consolidate node accounting around folio state transitions.
Increment NR_HUGETLB when taking a folio from the free pool or
allocating a fresh surplus or migration folio, and decrement it
when returning the folio to the pool or removing it from use.

Separate memcg statistics into mod_hugetlb_memcg_state(), updating
them after a successful charge and before uncharging. This keeps
node accounting independent of memcg charging and removes redundant
updates from the allocation entry points and surplus cleanup paths.

Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c    | 50 +++++++++++++++++++++++++++----------------------
 mm/memcontrol.c |  6 +-----
 2 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 31a92ed4165a..70a2e55b2895 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1288,6 +1288,8 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    pages_per_huge_page(h));
 		return folio;
 	}
 
@@ -1423,6 +1425,9 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+	} else {
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 	}
 	if (adjust_surplus) {
 		h->surplus_huge_pages--;
@@ -1700,6 +1705,17 @@ struct hstate *size_to_hstate(unsigned long size)
 	return NULL;
 }
 
+static void mod_hugetlb_memcg_state(struct folio *folio, int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	guard(rcu)();
+	memcg = folio_memcg(folio);
+	if (memcg)
+		mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, folio_pgdat(folio)),
+				       NR_HUGETLB, nr_pages);
+}
+
 void free_huge_folio(struct folio *folio)
 {
 	/*
@@ -1747,7 +1763,7 @@ void free_huge_folio(struct folio *folio)
 				     pages_per_huge_page(h), folio);
 	hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					  pages_per_huge_page(h), folio);
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, -pages_per_huge_page(h));
+	mod_hugetlb_memcg_state(folio, -pages_per_huge_page(h));
 	mem_cgroup_uncharge(folio);
 	if (restore_reserve)
 		h->resv_huge_pages++;
@@ -1763,6 +1779,8 @@ void free_huge_folio(struct folio *folio)
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else {
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 		arch_clear_hugetlb_flags(folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2130,6 +2148,9 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	 */
 	account_new_hugetlb_folio(h, folio);
 
+	/* The overcommit recheck below can free this folio. */
+	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, pages_per_huge_page(h));
+
 	/*
 	 * We could have raced with the pool size change.
 	 * Double check that and simply deallocate the new page
@@ -2140,8 +2161,6 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		folio_set_hugetlb_temporary(folio);
 		spin_unlock_irq(&hugetlb_lock);
-		/* Balance the NR_HUGETLB decrement in free_huge_folio(). */
-		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 		free_huge_folio(folio);
 		return NULL;
 	}
@@ -2169,6 +2188,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 
 	spin_lock_irq(&hugetlb_lock);
 	account_new_hugetlb_folio(h, folio);
+	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, pages_per_huge_page(h));
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
@@ -2227,10 +2247,6 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 
 	spin_unlock_irq(&hugetlb_lock);
 
-	if (folio)
-		lruvec_stat_mod_folio(folio, NR_HUGETLB,
-				      folio_nr_pages(folio));
-
 	return folio;
 }
 
@@ -2258,9 +2274,6 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 						    nmask);
 	}
 
-	if (folio)
-		lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
-
 	return folio;
 }
 
@@ -2378,6 +2391,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		if ((--needed) < 0)
 			break;
 		/* Add the page to the hugetlb allocator */
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 		enqueue_hugetlb_folio(h, folio);
 	}
 free:
@@ -2386,13 +2401,9 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	/*
 	 * Free unnecessary surplus pages to the buddy allocator.
 	 * Pages have no ref count, call free_huge_folio directly.
-	 * These pages were not accounted in NR_HUGETLB, so balance the
-	 * decrement in free_huge_folio().
 	 */
-	list_for_each_entry_safe(folio, tmp, &surplus_list, lru) {
-		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
+	list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
 		free_huge_folio(folio);
-	}
 	spin_lock_irq(&hugetlb_lock);
 
 	return ret;
@@ -2957,13 +2968,6 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 
 	ret = mem_cgroup_charge_hugetlb(folio, mm,
 					gfp | __GFP_RETRY_MAYFAIL);
-	/*
-	 * Unconditionally increment NR_HUGETLB here because if
-	 * mem_cgroup_charge_hugetlb failed, freeing the page will
-	 * decrement NR_HUGETLB.
-	 */
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
-
 	if (ret == -ENOMEM) {
 		folio_put(folio);
 		/*
@@ -2978,6 +2982,8 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 		return ERR_PTR(-ENOSPC);
 	}
 
+	mod_hugetlb_memcg_state(folio, nr_pages);
+
 	return folio;
 
  err_uncharge_hugetlb_cgroup:
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac6c43ea8c5a..e8af131de67e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5440,11 +5440,7 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
 	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
 	int ret = 0;
 
-	/*
-	 * Even memcg does not account for hugetlb, we still want to update
-	 * system-level stats via lruvec_stat_mod_folio. Return 0, and skip
-	 * charging the memcg.
-	 */
+	/* Skip charging unless hugetlb accounting is enabled for cgroup v2. */
 	if (mem_cgroup_disabled() || !memcg_accounts_hugetlb() ||
 		!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		goto out;
-- 
2.53.0

