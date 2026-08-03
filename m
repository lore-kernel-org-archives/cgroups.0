Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840373A9605;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785786443; cv=none; b=DzrzklzSx5UGROq7XsqTuwZv0p1d28eM/f6kc7txgjpfSy7E0J2ipFxWg3pLFPNFDw6joru5b3ZHS4s6md1L7J0GHdi+ghLx4GARN6We0ojmNXdt+kXIT+fjInE0W4+pdHIyh2a5E4pSfJI7SvcFWhQiZAyK9l9vzdWhyIKqD8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785786443; c=relaxed/simple;
	bh=KnWmpT9oaTCGf6Iw2Wd4BLWFdHkuktfOvH/1O23SoQ4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Iu8Pw/1cPENUBGbtYWQieCKY3kvm3qEjokVzbKjPeo3YhGMMitcVRHOivEj00XGWSOqjIu+d3g0hN/sAYBIWtrShQXQXIrlMpnFpFWmDjhPv2kWup5KTjlgoE3oIIIFNJX8PbKn3SYnQHjvNbNjXsCn4b4+zg3kC7sP5MGyk/U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vzi4z2uQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vzi4z2uQ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61217C2BD00;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786443;
	bh=KnWmpT9oaTCGf6Iw2Wd4BLWFdHkuktfOvH/1O23SoQ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Vzi4z2uQBatDLSnAke9C7dGrFDH32+Nw8VbM64cqPyRHnSJVf4sNLTmTo+byjHoq5
	 g12QYA+zrgxjU0zoYbN6Qb6Fi4sPXGLMOEbUq+5jhHxsJUcnSkwyYCuQL5SdqC5Hhe
	 5Z4rKW3CuEoLFUq16XFgTOAB2zR8P4qPV8qnRAeItPxDh6DQj2lvnuWCvdjU/PM3DR
	 +JKumL6fI8LU6o4U8A+sSv9+7GxY8MxBNCewE3p/ojT8q+3CBL2i0+lE3706up+xdC
	 91j1xPPybG2pmacfz4OUkPm/F1jKGvpuKNkCljTxfMgADdcCecFuEFoE7Dnvm02qlJ
	 aBwDsOXWAn9cw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1A9C55822;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:10 +0800
Subject: [PATCH RFC 14/15] mm/khugepaged: consider workingset folios as
 referenced
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-14-4d8dad39dad6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=1957;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HMlEqaXAqytxjGsOSQ1y0vS58P8dpXTZRRV+ITOk0K8=;
 b=hnHXcfL7XYuZF3ifhfyr250b99EXPZETH4Gh62F4nWF3Hz6MzoB9rwDrPS18A+Ns4mOMfBCXI
 K4dGqE5c7HxA0+8DZ2H8QLMV297MA/7uO9Suo8aKeXAAYU/OtiXsZ+E
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

The folio_test_referenced check here is clearly trying to test if the
folio was ever referenced. It was first introduced by commit
8ee53820edfd ("thp: mmu_notifier_test_young") as an supplement of the
young bit check.

Folios are marked as PG_referenced on first access, but following access
will clear their PG_referenced on second access. So checking only the
referenced flag is not accurate enough.

Switch to use the new helper, so we can cover the secondary and following
access from MGLRU side. For non-MGLRU, this will make it return positve
for workingset folios too though, which should be OK.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/khugepaged.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b237f6e7662a..86c9b07dece6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -809,7 +809,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		 */
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
+		     folio_is_referenced(folio) ||
 		     mmu_notifier_test_young(vma->vm_mm, addr)))
 			referenced++;
 	}
@@ -1767,7 +1767,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		 */
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
+		     folio_is_referenced(folio) ||
 		     mmu_notifier_test_young(vma->vm_mm, addr)))
 			referenced++;
 	}
@@ -2752,7 +2752,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		/*
 		 * We probably should check if the folio is referenced
 		 * here, but nobody would transfer pte_young() to
-		 * folio_test_referenced() for us.  And rmap walk here
+		 * folio_is_referenced() for us.  And rmap walk here
 		 * is just too costly...
 		 */
 

-- 
2.55.0


