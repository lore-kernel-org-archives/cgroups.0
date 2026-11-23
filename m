Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460025;
	b=bFRNIZkf3/mZlK2NrDuw13FedK9suILwx7WyKeDx3GpdK1dkS0/1tbvyMWRz9IJ2YQWt
	 1hMUTmWXFoQt4aEb1qjyUFzRL55P4HKhfr7x4VBVGdK/LIth9uJowVc00mzTMuCyxaHg2
	 ekpaoU6fszdtm3Fj8bFL8/sBp40MSh6tbqBJWhDXv14QQeMVWzSly6lAYXGd9+B4zdinE
	 kQYl0qToPBcpGc1nY0TsMhezfTPNP4zJcIoqpsuruPuRqgXb97ZBXFPNGNbB4JyZKVcaj
	 FpL6Z5+OUOKG0id5wBZn+zv+BJfc/JzXz9KJrNbUT5YNerc5/9PG3VR6douQgpshx9Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460025;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1JqhXb31mV0qrsAJQ932SZX/2Yz5Qz0UbPnOXo+N5Vo=;
	b=iBWZQQVPxwd8VDhfRijbZd+agcGss1Y6+wDWWtPbYNQDc8jAXfrcn0o7prZaJYqhDxUI
	 1Qpk4jRsE44ngffepGS4VyyPZ96mmVLvNC0nRU9jepzJpII+1wKO9B0fbEMqdvNZgErs/
	 lG3JUdi/BMiWldRVC0k4Tx+qVqlZC1FFQOs26daQdVUz8N7vEzXKlTImX5eOMycek538Q
	 Dpm7aOUl2QuG5CGnRTBAYsOhMTka8MMjYvFkR6EsSFpL/0fwTN+EgkzRLaV/rjtaF57pj
	 WEXGjiHQmlTGATdsCsj25q3DhnT1ovhAOrHdm3VPGWFrNLO35ZxRBzrETuTrWMDxfng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fuMxN0Nc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAF5606A31A;
	Mon, 23 Nov 2026 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fuMxN0Nc
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460025;
	b=j5uEAAqqtJr0P2AIBRVs/qtYduwt8irNX6y71mZhQBM7SZlEgJdiaBeAMyHWVIc1C528
	 JMIKU9fZjFFJCQ7ppnXn1gXrGFZgd6YbvZ84iD5F4F0rtqn7vFcMyYgj4cnU4CcrtmtOe
	 j74DZ+LR8Vp97gQTI9cofXGNnX/Zmrj3jEftHf7x79CznT3xI4nhp//znsL30J6o6s9BQ
	 /S4BJrH9/g+wc0ZJrP1w1aFHEpd1cmWZBhT2VFeYppi5yYJiiF4E4iILMDw2eNTtxCMxM
	 2aRwUmU6neBmaoSl7vrabBA+Evq2RhjctnLOz1EyAkv6PBRum/4ov8tPhN3iwZLp53w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460025;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1JqhXb31mV0qrsAJQ932SZX/2Yz5Qz0UbPnOXo+N5Vo=;
	b=C2wl9MtmjdOUJOxfwa/+jrlEVbvZ+zH1p0w/kEnFvJb062hWsyy+N3FvgV9xVo6MtewZ
	 DVHTx1gxzzlcbwyjr2xMN2zRuf/esUHZdvx27qpOcl7uJfDt5kwP99rJgI8udhsZy2LPP
	 Hzx1Le/5wNHF2LRfSnWJdD6swr94FKkQPeYmf57Mrh73nSYiEk2tfTtWqwqpLyFvhbOj4
	 ICSksh7UncfnffPHOypvmRgNn04yiWQQdYhKQ0lB2zr1BVkJJED3ENmmH/b4Q5H/6KkKy
	 tQBGcIM0RgzNJOY5hKIijFxTgBTlfLkr187NU3h5QNQNj5l5bVLztQo8xpb6bka3yFw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 551F31F01570;
	Mon, 23 Nov 2026 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460025;
	bh=1JqhXb31mV0qrsAJQ932SZX/2Yz5Qz0UbPnOXo+N5Vo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fuMxN0Ncu2Kdljre23hS7DhaUsB/CuBV58EDVjopYlTAxM+kgr46CW5q9C5pU6Lzw
	 8P1b3MrcBdiNQHS5psrZ72DqCvENtiQoMoCCW38wV8rx1BlcFXqhMKX196VetYDjfh
	 YgCBUpfCKuWXchF3NmJIJFMVhfZlhAXJWAEwQAxI/ox/JFLkeC/uHrV2cm//kMHTtB
	 XrLqJ0JP+UbcRsObOoFfV3AldfWva5KpR11HwyoutQup9ytJLQrS28XmsU8DG73uR2
	 3m8ydy9rtjkxJPrXSCiyEiOGpnjOODGpBfEOzDlsozSmu/atTmjx4BbHaOsGcGp6p9
	 QqqJf5JN7wJGw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B9F084C661;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:06 +0800
Subject: [PATCH v6 14/18] mm/madvise: adapt for LRU refs based operations
 for MGLRU
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-14-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=4328;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=1pDxzB68yPhUBkq/LYDWcJlzcSVuKtrX815nQg6xt3E=;
 b=DOr3YEmRaaDrax55p05BK/Ym73sex2jTTSZET1t+yFv2QVn5WM0QXp/bEkQ6KU//bQ+Wisxn1
 Qig9+X5yGcZBYXczo/YcZy4ddA5fdisR5SnE+N+dG0f464/kaCt983n
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

For the active/inactive LRU, madvise clears PG_referenced so that one more
access is not enough to reactivate a folio, and keeps PG_workingset on a
folio demoted out of the active list so its refault is still accounted as
a workingset refault (PSI).

MGLRU keeps that history in the folio's refs count instead, which now
lives in PG_referenced, PG_workingset and LRU_REFS_MASK, so writing to
those bits directly corrupts the count. The two hints want different
things:

- MADV_COLD resets the count in folio_deactivate(), which also requests
  deactivation.
- MADV_PAGEOUT clears non-workingset refs and caps the rest at
  LRU_REFS_WORKINGSET after isolation, before handing the folio to
  reclaim_pages(). The hint marks the folio as cold, so the
  eviction shadow records the capped count and does not inflate the
  eviction/refault counters of the hot tiers that drive aging, while
  folios at or above the workingset threshold keep their PSI
  classification.

PG_young is cleared for both LRUs as before, so the referenced walk does
not count stale history as a recent access.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/madvise.c | 54 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index a36cfe98dd81..7e562e78d52a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -360,6 +360,42 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+static void madvise_cold_prep_folio(struct folio *folio)
+{
+	/*
+	 * VM couldn't reclaim the folio unless we clear PG_young.
+	 * As a side effect, idle-page tracking loses recent referenced history.
+	 */
+	folio_test_clear_young(folio);
+
+	/*
+	 * For the active/inactive LRU, a folio demoted out of the active
+	 * list should have PG_workingset so its refault is still accounted
+	 * as a workingset refault, and the referenced bit always needs to
+	 * be cleared even for inactive folios. For MGLRU, MADV_COLD clears
+	 * refs in folio_deactivate(); MADV_PAGEOUT handles refs after isolation.
+	 */
+	if (!lru_gen_enabled()) {
+		folio_clear_lru_refs(folio);
+		if (folio_test_active(folio))
+			folio_set_workingset(folio);
+	}
+}
+
+static void madvise_pageout_prep_folio(struct folio *folio)
+{
+	unsigned int refs = folio_lru_refs(folio);
+
+	/*
+	 * For MGLRU, clear refs below LRU_REFS_WORKINGSET and cap
+	 * the rest at it: MADV suggests the folio is cold, so the eviction shadow
+	 * should not record its hotness in the high tier counters, but
+	 * the workingset classification is preserved for PSI.
+	 */
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, refs >= LRU_REFS_WORKINGSET ? LRU_REFS_WORKINGSET : 0);
+}
+
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
@@ -434,12 +470,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+		madvise_cold_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
+				madvise_pageout_prep_folio(folio);
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
 				else
@@ -544,18 +578,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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
-			folio_set_workingset(folio);
+		madvise_cold_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
+				madvise_pageout_prep_folio(folio);
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
 				else

-- 
2.56.1


