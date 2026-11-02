Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.127
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793587806;
	b=F3wSTGKut1SvVRBqASog3H19m0ZbS8LreWHyPhIcjbFxX5cej6j2TO9AaNTv2s3Av3uB
	 JzOS5QnSFqqRN3v9nZ9Efn2IHAShm+wHM0DLtow4kJx86TFIWHzYG7n+Q3/6Y8PDBF5D7
	 Lgb9iqNs7Bg8g80iVAMgPo5eMt6u7g+R30nK6yVorPVutI6HS8mfHXg3jJahsgMXM0yLt
	 fF+zNP8gyUy2wehDPe44wLIazUmKDz5MhJjpTnENUM4urPHrXh7YpJRNwHowcgxbgRNaj
	 z2InsCv/JIwkd9WzNjMkggwhr/6++EdQk2o1SfKos6E59LtwXhaLJ+jdQ96CS0Fy1dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793587806;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PapBgzOyZnAsoQCK2k5mMlWe3Tctg64lj1GVjzYd0Q8=;
	b=HTq3LE5jUr6potmuAcjIl60FOrI3D21aHbCqHDYaJrKiXjiEkVr/g6PjLxVE2/vpVEo5
	 oPWoW8x7vQoeEmkLXCLYJePSOjr6E6e9/Zk89Bh0PqJKemXwjabtk40xGXSevt15fJ8Yk
	 PE0UfarteeA0Hz15yFjA8YmntJBYbROSrM3K+7LQI/7HLy1v76qRy7LySXIZyYRrlXsiy
	 C39ycpuZT+z+LvdJ0bSnuxc9R4XRo5JkowZJq/2N3+BBoICETT07rLG8uTfhzl2aIbVOx
	 H+IR9fhtiAKR//dS53RE75Sc3pp9ZcKUBmelOwjIJSoUGRubGImY9pS3MvQh79ORtBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XhwWY2h6;
	arc=none smtp.remote-ip=95.215.58.127
Received: from mta1.migadu.com (out-127.mta1.migadu.com [95.215.58.127])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2F9606A324
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 02:50:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A2F9606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XhwWY2h6
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Z9acv076wT5xIN3whZ7kKd6coXEQxd0rgX0Tu8Z5SNw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793587803; v=1; x=1794192603;
 b=XhwWY2h6EZh069tDtWt7fl7IYIunrs2S2GMV7s4ubhw/3U8GgOAijA9w1qv7v19pWgXUHh+2
 pG3+KMyGyGpUPBM1N1hl1aK6luXgs3J4ItlwalmsR5X9iDc8/d+BPqjMvcjzW9eNb+va0FsZWNz
 aMzZ2zARxgazGciUyCRBr71A=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id df44cd3dce38ba1a;
	Mon, 02 Nov 2026 02:50:01 +0000
X-Mizu-Trace-ID: df44cd3dce38ba1a
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
Subject: [PATCH v2 3/3] mm/hugetlb: Fix NR_HUGETLB accounting for surplus folios
Date: Mon,  2 Nov 2026 10:49:10 +0800
Message-ID: <20261102024910.31486-4-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102024910.31486-1-kaitao.cheng@linux.dev>
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
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

NR_HUGETLB is incremented in the allocation entry points, but decremented
unconditionally in free_huge_folio(). Surplus folios allocated while
gathering reservations can be freed without passing through those entry
points, leaving an unmatched decrement in the per-node counter.

This happens when reservation gathering fails or allocates more folios
than needed, or when the overcommit recheck rejects a newly allocated
surplus folio. These paths cause nr_hugetlb in /proc/vmstat to underreport
usage.

Move node accounting to the underlying folio state transitions. Increment
NR_HUGETLB when dequeuing a free folio or allocating a fresh surplus or
migration folio, and decrement it when returning the folio to the pool or
removing it from active use. Balance the temporary increment when surplus
folios gathered for reservations are added to the free pool.

Separate memcg statistics from node accounting, updating them after a
successful charge and before uncharging. This keeps node accounting
balanced independently of whether the folio is charged to a memcg.

Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Closes: https://sashiko.dev/#/bug/linux-860a3b8f-0b07-4cd5-a122-aa2288463bee
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c    | 42 +++++++++++++++++++++++++++---------------
 mm/memcontrol.c |  6 +-----
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 931ca3a30773..d1d7e14858d3 100644
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
 
@@ -1416,6 +1418,9 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+	} else {
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 	}
 	if (adjust_surplus) {
 		h->surplus_huge_pages--;
@@ -1693,6 +1698,17 @@ struct hstate *size_to_hstate(unsigned long size)
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
@@ -1740,7 +1756,7 @@ void free_huge_folio(struct folio *folio)
 				     pages_per_huge_page(h), folio);
 	hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					  pages_per_huge_page(h), folio);
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, -pages_per_huge_page(h));
+	mod_hugetlb_memcg_state(folio, -pages_per_huge_page(h));
 	mem_cgroup_uncharge(folio);
 	if (restore_reserve)
 		h->resv_huge_pages++;
@@ -1756,6 +1772,8 @@ void free_huge_folio(struct folio *folio)
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else {
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 		arch_clear_hugetlb_flags(folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2123,6 +2141,9 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	 */
 	account_new_hugetlb_folio(h, folio);
 
+	/* The overcommit recheck below can free this folio. */
+	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, pages_per_huge_page(h));
+
 	/*
 	 * We could have raced with the pool size change.
 	 * Double check that and simply deallocate the new page
@@ -2160,6 +2181,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 
 	spin_lock_irq(&hugetlb_lock);
 	account_new_hugetlb_folio(h, folio);
+	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, pages_per_huge_page(h));
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
@@ -2218,10 +2240,6 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 
 	spin_unlock_irq(&hugetlb_lock);
 
-	if (folio)
-		lruvec_stat_mod_folio(folio, NR_HUGETLB,
-				      folio_nr_pages(folio));
-
 	return folio;
 }
 
@@ -2249,9 +2267,6 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 						    nmask);
 	}
 
-	if (folio)
-		lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
-
 	return folio;
 }
 
@@ -2369,6 +2384,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		if ((--needed) < 0)
 			break;
 		/* Add the page to the hugetlb allocator */
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 		enqueue_hugetlb_folio(h, folio);
 	}
 free:
@@ -2944,13 +2961,6 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 
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
@@ -2965,6 +2975,8 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 		return ERR_PTR(-ENOSPC);
 	}
 
+	mod_hugetlb_memcg_state(folio, nr_pages);
+
 	return folio;
 
  err_uncharge_hugetlb_cgroup:
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..3bfe4b108170 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5417,11 +5417,7 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
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
2.54.0 (Apple Git-157)

