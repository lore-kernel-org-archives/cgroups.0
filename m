Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E0346D2B4;
	Fri, 11 Sep 2026 11:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789127111; cv=none; b=G+lBMy2w5lNukpq/Mz+SRU4CPESP8qRNqaUV5HhUyI8cmmMee/rURd3oTot058NBbh12bg9KLgFSwLHsQgM4NgKKkSGaojRLFIgvP0jwkevjeCLWNgf8YjAZzB0k/COKIkyKhNgmpxZpErau0/Wd3qOQP1ZNPwR8eYnVaFxK8Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789127111; c=relaxed/simple;
	bh=YOdph5nvch12sC6JwUaX69NGEgkBUDjuAafNjhDel6M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z1l44LGPTntPpsrqLSVXdteqdG5dUTbV+Dsbly3mDm59XcL68TjOTkiPMkmk1by3cdh9DU0Pr6d7CIqG4qoZD3UmkFdVW2gm2W4cmvdDRYlRdOBD3t//aSrvyB8a/XPuCWYSEGAd7kPS1d+clt6TBs2iZ5BmoQ9yX45wr3EBl7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgTQH7cN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgTQH7cN"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FB03C2BCFB;
	Fri, 11 Sep 2026 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127111;
	bh=YOdph5nvch12sC6JwUaX69NGEgkBUDjuAafNjhDel6M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KgTQH7cN8iTuJl4u0IA/2lv/w1Z0gXR87UFP+dzuTOXgNTWiLNqyHwJpPbcugJrDF
	 rh7BvMcq3e11WIMweukLNVz82ouJdTZXnKAx2NDief49WT8QBRWVVvI59tUXTyae5E
	 iWI4jW3lNm+J/WIQd500oWbKae6uTAMnXjhqSYzSn43/WB63WbBSMRgo+qJax2ekLG
	 1rVQarn1ZSq5Jg6nJb5ynfEZehFeQCYqJ1sG8YtmyR4p89TZGlN/pqIcLyrYputxMD
	 UPj9y/g0b0Q4HKVYtyV64LcUrtDdJhfJfQBCdAEJUytebrLETwQ/e0L8L6WqzwL4WD
	 RnUKgQA/NiN6A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CA5C88E50;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:17 +0800
Subject: [PATCH RFC v2 14/15] mm/khugepaged: check folio referenced state
 via LRU refs under MGLRU
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-14-f26e5cb26da7@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127107; l=1294;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zchwlwZldDLwVx1Yq2g1QvDGVk9gZBPpwZe0aRzvkdA=;
 b=qjywNahDHCQVaV3S4S7QIY5jyXUEqesc5qZ4g+OelXa62URAQOi7WM0+TdW7u7NEhmJ2RiHIZ
 lWk5a8pAJd4CVHK4G3U5Tqb0FMS0S4a4xTvJceWp7JkrGpHEFP/v5Ou
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
count, so folios with a higher refs count no longer have the bit set.
folio_pte_referenced() testing the raw bit misses hot folios at
refs >= 2, under-counting the referenced folios of a candidate range
and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.

Test the refs count directly when MGLRU is enabled, mirroring the
smaps conversion.  The classical LRU keeps the plain bit test.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1deb74cf28af..a3ce6735bc32 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -597,7 +597,9 @@ static bool folio_pte_referenced(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
 	/* The folio was referenced previously ... */
-	if (folio_test_young(folio) || folio_test_referenced(folio))
+	if (folio_test_young(folio))
+		return true;
+	if (lru_gen_enabled() ? folio_lru_refs(folio) : folio_test_referenced(folio))
 		return true;
 	/* ... or the PTE mapping was recently used */
 	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);

-- 
2.55.0


