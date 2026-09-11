Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC8545BD7F;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789127110; cv=none; b=EmzHeLvzanLjDr3VXrCoKGyMUw2B0e081nT+RRpWuPdRkaQhOJ1pmRHJUXEMisgqiqNrRF11SJeQZKbG4GeK3joXIwKOsvUlYRZNEEArlQ6n8FhJA78cwB0gN6pRvShLGKp17sPN1ucBIoyYCWefdVk5euFq5UgsowWji8b5O5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789127110; c=relaxed/simple;
	bh=d9QhD7pUxx+qjGulkGZZ65rU0vamSq3hj2DTDFAghUU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=D/DoMTeBx08JP8naw/0YBRO6WmazmKoMCNKRx0DfpA/iSeyfzBmPYLZ3PPZrLfgHMrGXCw1TIsvx6yM/29JkJ6acLvew1z7pz3ylw/oZfPILFLBnQ2DLP2M2QtOgrgwQK5aMwwH43mmPyoP30bylP9tJIP3Ybr5uZQ4nt44AqbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTmK0by5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTmK0by5"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C13DC2BCFB;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=d9QhD7pUxx+qjGulkGZZ65rU0vamSq3hj2DTDFAghUU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KTmK0by5vM4NCxxSA4xlx2RhPCUWk4h0RQPBTtyshSNr6V15lj33xmyJIfCtDl13/
	 v4QYlbQ/OHu/BVuwfH3pNWUi4vGf1MtkRoxmYmN1AXjIJ/Ft7MFHhXT8gzv/6SnOL9
	 UXYujhhypUxnKFQ+z77+s17US0Mb4OWsz/UeQVWCcSIoXQfcGzAxZVJIyyQxpVjJaY
	 bDz+IsMAydtNfkQvCzTIqKcUD0FUGkuPaWHwObNz5cErVmKpBbh7qYjJp74yjLv+ip
	 i0lWI3EcbDZmzoMgig9aGjBD+Ks098/DqIe5pRYysMDb9J6b8PJiBNwa+tSezwox+k
	 /BJm1SYCccVtA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F63C88E4A;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:11 +0800
Subject: [PATCH RFC v2 08/15] mm/smap: convert to LRU refs based operations
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-8-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
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
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=2654;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HXO5gwClyDxia1jxGpm9V9P3/YbOdlVcEqlSn7qAT1k=;
 b=Fdkhhl4v1znpzampw4t/OvUwYvz+mRHHNoOG27pPcgbl+BBiTNjNLJ3mj8LifcHwbvHDT9ZHo
 7FfnH5bZ6ffA38pZL3nPEw5wpbT995npKwBnooE+V6ZedJ7G7+gAXhx
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

After this, we will have a more reliable and useful reading for MGLRU
after the FG change. The behavior is basically identical to what we had
before the series. And there is no behavior change for classical LRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/proc/task_mmu.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e671b4fd8ded..9cc47efbaa51 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -880,6 +880,22 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 	}
 }
 
+static bool smap_check_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		return folio_lru_refs(folio);
+	else
+		return folio_test_referenced(folio);
+}
+
+static void smap_clear_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, 0);
+	else
+		folio_clear_referenced(folio);
+}
+
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty, bool locked,
 		bool present)
@@ -906,7 +922,7 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || folio_test_young(folio) || folio_test_referenced(folio))
+	if (young || folio_test_young(folio) || smap_check_folio_referenced(folio))
 		mss->referenced += size;
 
 	/*
@@ -1709,7 +1725,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		smap_clear_folio_referenced(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1738,7 +1754,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
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


