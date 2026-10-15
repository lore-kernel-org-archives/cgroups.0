Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D303572664;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792088156; cv=none; b=ByAfIGHJxj5RTm5KjofKCYizUGdFWDO2BxUAMxWWHX0uEPfYFgscommoSBpmXc4z/HS/fDIz9RZQCqK2uC4DMt8p5/z2QisP77siJtwvfo5sP8gTlXzh4guNe/HC150aq3h6iPEMzk4MCHTPWC6j1NLZZGlqLzLaVAi0tnLgDt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792088156; c=relaxed/simple;
	bh=IMIPLnANXxcSiolHkXP5An66gjpZDy2DGAjDFMRr3K0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gjIYCaKmJmelSbDRq+bpHwcHC1WX7RxRSt4dBg/VrGdi0UDfdgPKrjH++bbUG0vKBbcMJfWbQw1uVQTnWsI7rWnjLQLpUZ2WdFIoH+B4Nd1lS1RT0FqqcD1MCTY1xewL4lXyMd3FJZcs6A4Wof7smHA2tTbyHqO17brIqzFTVp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g9bXnKJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g9bXnKJr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD688C2BCFF;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088155;
	bh=IMIPLnANXxcSiolHkXP5An66gjpZDy2DGAjDFMRr3K0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=g9bXnKJrBTQ6Ld6/kpqL1Ajd9NGGt1ufkGztPE8/MeYq6Y7QuILia/Uw05u5r/j4o
	 8b8o7nMWtDmzqBgpfVePSXay61ORbWNthuvoJRsVALw1Orvn7E5gpM+UJD5GBwhzMv
	 08wE1BTkmYHVRtQ5AiT5+E8v1tOt9/TgV3e/ov824ojz86MNf0y1utcklNfTIkKfGS
	 Dq20Hns8fFSd4NTYM/j4uvdIWkwxukrCrNgAXydo6mKfHkbm6xn7UaALuqg4hjuid6
	 dfDSKo8RWsEdVEwv7uJ4Z9n428ZUAtHgWPoF7gc7MsQbih74WXO9F/4joaMGQkbx78
	 3P3r0WGuztjyg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92C9CCA467;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:15:59 +0800
Subject: [PATCH v4 10/17] mm/khugepaged: convert to LRU refs based
 operations for MGLRU
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-10-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
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
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=1305;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=+Tb0hPQRVBeGNFQursundpLJPnEU7iUig7NZAg5dyxU=;
 b=CyGgF3KwdKpDK/OPe5JsFLV9+9m3zkFUvTK3nxJVeinp1EKn/EhM9YluR8cGMSowDmMM9MQFe
 v00Gu8A/iiFBT95X30QnZS7uBlb25LDBy7tmWh/fvzwrgOY4vWuOcKC
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

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ef5cd6fda34f..5332b4c51fec 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -579,7 +579,9 @@ static bool folio_pte_referenced(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
 	/* The folio was referenced previously ... */
-	if (folio_test_young(folio) || folio_test_referenced(folio))
+	if (folio_test_young(folio))
+		return true;
+	if (folio_check_lru_refs(folio))
 		return true;
 	/* ... or the PTE mapping was recently used */
 	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);

-- 
2.56.0


