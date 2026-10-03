Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA3842E439;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791032118; cv=none; b=T0LQ3QLYg/Dtaej50gqNX6RYOovlZt4sxd3t4TF90yoqwXlHP6/ZqJt/4AnJBLDkXZW3qB/T4UJpftrSBWaMlPH3+QwdF4yVddokDEM9gPmY1NvHvZGfy75NakF8h9STwr2Gg/4dt7kRtjYOssghjOxU6R/tyXrEC/0pXYB00x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791032118; c=relaxed/simple;
	bh=42V+uITw6MjQQMoMxbIrGu4Hi72bHJMAM4ypuL7oh+g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=thwpn4XQM4qdxEXQhZFQTwV8LpfSaLUWFwg3zbNgXkD3QqoPFQcSOeBoMq2vqoIaoBDrO/Gifx/Io2XWgaxZJChU9S/JGa0k6/028m1NSa26XMeoS6qp02YsnNSY9dU7C+axqEfjMtZXiFQv0/yAK4vAMVmAfinwZmoLp5ZreyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BpVRXogh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BpVRXogh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00189C4DDED;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=42V+uITw6MjQQMoMxbIrGu4Hi72bHJMAM4ypuL7oh+g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BpVRXoghll8YHkO1SgwzMF4RNF/SU7MygpBo41PLphbYeexcjudDSicznakCvpyFV
	 JxhiuiXTfHYmnMcZKp2ytja6d2rjl+h4OeFxS5ypV9K7iuNGp3yTC0Ru3XTEFO7Ub8
	 yUTipHY11SMkbIRTwIxEAtQ/B2TPwhA8DDJWdw+PInZ0USuk3cdD+piWIFtgqp/Ku4
	 RDr4UJ6SnIPG4Ljrp31TUC90RzUQlTwntgbstBWhs+fplJ+ZWp4n84+wBO+d0Q5dEu
	 NwGNUcUBOinR55+1c6LBAGz+2iW1h2Wzy6B+MNIZYRmDOq3vAeQhLJYnm1PZd2Y6QU
	 ZPkUnZzs5rb0g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4BDCA5FDD;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:18 +0800
Subject: [PATCH RFC v3 07/17] mm/mglru, gup: mark folios referenced via a
 fast helper
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-7-cbd4546a5bd9@tencent.com>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
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
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=2592;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=5AncpLOwflF4jOn/EOaNo3fTgfYKqH470JIgcu/pOiM=;
 b=9gy9gY62fvvWoGoWLviT7CZaEDj9kkpXZ7nsxmG1oOPz/BlJzQ4bruJBxqe988UFTXxGFfLe0
 8U7hvT4TANnCxbHbM7Xc0bOqxGYXddfxVOZQwf6oA+z4YpmpHTkSlNH
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
classical LRU as before. No counter update, promotion, and guarteens
no other complex operations in following commits.

Convert the gup fast-path sites. No behavior change for classical LRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 25 +++++++++++++++++++++++++
 mm/gup.c                  |  6 +++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 48a945c2cbaf..cb54913aa184 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -439,6 +439,31 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 }
 #endif /* CONFIG_LRU_GEN */
 
+/**
+ * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
+ * @folio: the folio
+ *
+ * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
+ * untouched. For the classical LRU, a plain PG_referenced set.
+ */
+static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
+{
+	unsigned long new_flags, old_flags;
+
+	if (!lru_gen_enabled()) {
+		folio_set_referenced(folio);
+		return;
+	}
+
+	old_flags = READ_ONCE(*folio_flags(folio, 0));
+	do {
+		if (lru_get_refs_flags(old_flags))
+			break;
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, LRU_REFS_REFERENCED);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 8e9ef5ee7498..87a61c67ce2d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2895,7 +2895,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
-		folio_set_referenced(folio);
+		folio_inc_lru_refs_fast(folio);
 		pages[nr_pages] = page;
 		nr_pages++;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
@@ -2964,7 +2964,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 
@@ -3006,7 +3006,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 

-- 
2.55.0


