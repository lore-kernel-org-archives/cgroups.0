Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA693A7F73;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785786443; cv=none; b=GQdqTlol6nRWc90obL2bobvz6YCZmRZ6I+AVGOenCp6YawMaxvAly6chHTa/SzpZc16nH204H6gCbO9sA3nXfbkJcHH+PPpnJUDppbQZ3dGgfWqmRn5PWMUdY8yFkomL0GzT8bcfxupv1ypsoOdpi0t0ws31IiQzlL2+i6f381Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785786443; c=relaxed/simple;
	bh=ozlP16v/HxlVKrcEOAOjQCQyb4sgtwD0X3QHzHntDkc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sbWvVTNLwQOuM3F8BjB9WbMM5eap4/3QSZ+1fXtVlEBV1v16hneD0jU6289q8ua6XGu5HMKqSmAvHrtfaUlZ81xxf00n3uqP4No2FdJ2i4STo7QYIQ7YqazOCcS/jurMyXNaGm2SB9VGZrodli7SVw5mpbaqHEkpD1Rxnvd7S6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GlzGBOqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GlzGBOqy"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A2B7C2BD01;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786443;
	bh=ozlP16v/HxlVKrcEOAOjQCQyb4sgtwD0X3QHzHntDkc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GlzGBOqyDrbpUYrwIhtK2XJ3zvl+rkTFDs9PAIpQWtKeWSEXbz4Syzhc+hM9k4SHc
	 3MHiEprVgCIkXc5yiqHKgW0yb8YXDKugvRJ8hsVm1hwiI3hDjYGdKdC23zYhSK1uPV
	 y55wgrUR3NM8Q/Ue8nH3GE1QyRBdmUJddSBV9GZsmcdklwrwLoVO0mWmrsAqu+FF5a
	 vRpK7fMS/rOrRjB8vm0mnj0xZIuTvXlbCydOLJ2lm9bEj9L3v+mD5as1JeYgL3Xmhv
	 6XKgsb8jwSErBUj/R41/6gaiAR0OenavrSznfQ6Ep4b4gMcfwekSUvgRrL/koQOhNG
	 hQ47cJDYQnGkg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F34C55184;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:08 +0800
Subject: [PATCH RFC 12/15] mm/smap: report workingset folios as referenced
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-12-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=2528;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=w6RlPQJYy1xwfLtM1LXlBT4HMO6wCueMStGvS21qkQ8=;
 b=cic1gW3I0SoP78woxinTEezcXi3rjJJlFplB1hZ3sbyv9AiX0gCSAui2nXMP3uCgUxCTP1R2d
 5cvp+hpla5+BDyG2oQdBDsnw2Dj9Zc4FvGYKcB/svhLvwI4iYWV+la3
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

For MGLRU, switch smap to use the folio refs count API so smap will
report all folio with referenced count >= 1 as "Referenced". Current
smap checking PG_referenced is causing folios to flick between
referenced and not-reference status, because for both MGLRU and
active/inactive LRU, PG_referenced may got cleared on second access.
(Increase of LRU referenced times count for MGLRU, and movig to active
list active/inactive all clears that bit).

After this, we will have a more reliable and useful reading for MGLRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/proc/task_mmu.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 817e3e0f9194..c5c96c523291 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -944,6 +944,22 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 	}
 }
 
+static bool smap_check_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		return folio_is_referenced(folio);
+	else
+		return folio_is_referenced_by_bit(folio);
+}
+
+static void smap_clear_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, 0);
+	else
+		folio_clear_referenced_by_bit(folio);
+}
+
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty, bool locked,
 		bool present)
@@ -970,7 +986,7 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || folio_test_young(folio) || folio_test_referenced(folio))
+	if (young || folio_test_young(folio) || smap_check_folio_referenced(folio))
 		mss->referenced += size;
 
 	/*
@@ -1791,7 +1807,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		smap_clear_folio_referenced(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1820,7 +1836,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		smap_clear_folio_referenced(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();

-- 
2.55.0


