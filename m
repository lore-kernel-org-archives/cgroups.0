Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931B63A963B;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785786443; cv=none; b=dJUN7nuSdQ2AB2/+x8KRVwgIiM84qJUL9yfSExE0h8UrXH6NEMEp8eZYulHBTGxfAuvsYtRbNxlM8UODyWW5Uv8waKGgWJRQx5fDY9TecchFP+bWrJL4SkhAqNYazfTY8ZV9nLr3RrI98lpDjAHyHdAX+uiwU2qX0nf9SlquDtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785786443; c=relaxed/simple;
	bh=1n+hcBYJ2VLCPzu8Xg2KTxM1AQOc1aeNpaYZxBPUvng=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Rrzeq3aKDJeB33M8gF5Rac/YCbzl7Hdmnb0UdE0l8w8JdXkQzblnCcg49H+aY2jmC7JLOkShiqvJLCiGb/9l/AHu8OX1SC4EdpFMxaZi9gwtkCeBMZ0uXk4thsjp7b+NU/L8Qme0E313l9fyFHsRYpZ3xZfpNDHwo/L1bS9Rz94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nRCymV0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRCymV0U"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7248EC2BCF6;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786443;
	bh=1n+hcBYJ2VLCPzu8Xg2KTxM1AQOc1aeNpaYZxBPUvng=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nRCymV0UwDUe8D10YefBzAs8HYuwJOYHOY/54Em4EiZScroS/J3oWbwC7w3BVWN9w
	 QmcSHQm009697qseGapcMPFvqMZLb1jWkBMLrJ6klAp/KUMSrSM+XYMmtMLRnRv+tN
	 D8g0NABxxd7WwkHevK8tpSJG7hiWcBVSvOAHOaUzUTQvkf/yKBHs9VH40ro0kXnNpK
	 w8oGXyVwoIlbrmMMg0DFz6kJeGqDBGbAlpUeUUnDtq2NI1IkIZZdCI1XaceUzOH5cX
	 q4ZtF1eMgPLoyAsMXMBiuvavWyYgsuGymFOU9PuNjLrYrslmV4hKpJU2PUXf03kpGk
	 RreVEaECiQ2Og==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2BFC55196;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:11 +0800
Subject: [PATCH RFC 15/15] mm/madvise: convert to new lru refs API and
 better support for MGLRU
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-15-4d8dad39dad6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=2598;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=IZ9piP3HZQ3l6Pb7dyuhGVIV9UajVhIyv5fRhBDYZ6o=;
 b=Ilfa9kf1jZoKpnpzjRcdb54/uo49AYoBym1Mxkn0Z4Zm9OWDSdCMbgnMvIATbnuQPI2/EEr0d
 PVsDj5Gc3FuCRO92Q5+ThtGtYa277T/0VLQwzHhJJM+3TojEEjijN16
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

For active/inactive LRU, madvise wants evicted folios from active LRU to
be considered for PSI too, so some special handling are added. But MGLRU
doesn't really need this, as it has a different activation logic.

Switch to new helpers and improve the support for MGLRU here.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/madvise.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index abb17760b8b5..f132dd7418f5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -350,6 +350,27 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+/*
+ * We are deactivating a folio for accelerating reclaiming.
+ * VM couldn't reclaim the folio unless we clear PG_young.
+ * As a side effect, it makes confuse idle-page tracking
+ * because they will miss recent referenced history.
+ */
+static void madvise_cold_or_pageout_prep_folio(struct folio *folio)
+{
+	folio_test_clear_young(folio);
+
+	/*
+	 * MGLRU clears all reference flags in folio_deactivate,
+	 * no need to touch it here.
+	 */
+	if (!lru_gen_enabled()) {
+		folio_clear_referenced_by_bit(folio);
+		if (folio_test_active(folio))
+			folio_mark_workingset_by_bit(folio);
+	}
+}
+
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
@@ -424,10 +445,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_mark_workingset_by_bit(folio);
+		madvise_cold_or_pageout_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
@@ -533,16 +551,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			tlb_remove_tlb_entries(tlb, pte, nr, addr);
 		}
 
-		/*
-		 * We are deactivating a folio for accelerating reclaiming.
-		 * VM couldn't reclaim the folio unless we clear PG_young.
-		 * As a side effect, it makes confuse idle-page tracking
-		 * because they will miss recent referenced history.
-		 */
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_mark_workingset_by_bit(folio);
+		madvise_cold_or_pageout_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))

-- 
2.55.0


