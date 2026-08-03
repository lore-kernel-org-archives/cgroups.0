Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4083A71AD;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785786443; cv=none; b=WIsjWki3cDafqIU31VvvJVjMzymmldNwG9gJk26D5zjp2AY+Fu6Nnaal0HWC8L7nSDAoGod/eSHtzrIEvyxFtRXCyJnbQo+kFkSS/ZWq4RBu+p8Rw0aGeQXe/F7nz3W8kx885U0yfg/0Dc1gHoE9tU0dYkVqXWMMKvuXM8UhI60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785786443; c=relaxed/simple;
	bh=cYbOLfejrKyQ9BPd8CMH99ZNpXZ1w9drr+TtG7Ncs1I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CfMSG2O9WrPe4YoXKgQNaE6m5MUkLiaD/AsXz+amp2WHsNw+Nqm8TqXzy/R2f9IOVg1PMgXNxdQCbVc0x4ydbps/OI24dceSdoVkafvGnOR4ITYw0nX4r7A0ipPhJ8UrQ9jkWFz8lzhuZbcm8vnJ7+1CwpyOY/RZ0HgU0DjEXaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DR6NlXu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DR6NlXu1"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBDDAC32782;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786442;
	bh=cYbOLfejrKyQ9BPd8CMH99ZNpXZ1w9drr+TtG7Ncs1I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DR6NlXu1rq5Z+SXhDN9ulerai7GEJwrzpL9Q56W/L9ph2wNEmAl6eYzYKPIeLnBsn
	 NgZAi1VRVCaYS0vFiXM+6nfNaChvZoDUTxS7se3JaKl7wkHXinNHVOBblqePpDMDKF
	 9iz/D1V3MZJeehVkPHTeffNs+iRIP/Zur2ckBO+qxQhZCDHgnXolj2iJ1VES1sIrAp
	 EHRKdgFz1n993debHt7uHf1+Cb/4LSsNfpSSLksax6/8KgV8/mMg3pw+BirsymwJqY
	 qii9NSRFISffUDeKF6BuX/lzEKGvUyejypMd/sxebeJSJXVh4949yokP/lf4MG1NLW
	 PUWum8Y5zcOJg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A426DC55184;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:03 +0800
Subject: [PATCH RFC 07/15] mm/mglru: move refault workingset activation
 into lru_gen_refault
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-7-4d8dad39dad6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=2070;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=1vC+xi9jNiCocZFLKmWvRW3U2STkCUDTFpNlV8n9RbA=;
 b=52vn6IfvHhVTl+P2eITAdJpvk846TJfwLfY88yxmTc88qbpfSMc32svILrESnyC2fHKo7ZD0j
 ZaK57q/2igSCfTqDJ7iXTgDStAVyQJT+CccWDakvux35J5eCy4eOMqP
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

Move the folio_set_active() for refaulted workingset folios from
folio_add_lru() into lru_gen_refault(), where the refault detection
already happens.  No functional change: the ordering and logic are
preserved in all cases, and no other paths reach the removed branch.

This is a preparatory cleanup for MGLRU-FG.
---
 mm/folio.c      | 6 +-----
 mm/workingset.c | 9 ++++-----
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index f90b7f86dbe3..fab00cb02970 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -474,17 +474,13 @@ void folio_add_lru(struct folio *folio)
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
 	/*
-	 * For refaulted workingset folios, set PG_active so they
-	 * can be added to active generations.
 	 * For prefaulted file folios, folio_mark_accessed() sets
 	 * PG_referenced so lru_gen_folio_seq() places them into
 	 * the second oldest generation.
 	 */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
 	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
-		if (folio_test_workingset(folio))
-			folio_set_active(folio);
-		else if (!folio_test_referenced(folio))
+		if (!folio_test_referenced(folio) && !folio_test_workingset(folio))
 			folio_mark_accessed(folio);
 	}
 
diff --git a/mm/workingset.c b/mm/workingset.c
index 7ac2b88c80ae..5438e9390011 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -320,12 +320,11 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
 
 	if (workingset) {
-		/*
-		 * see folio_add_lru(), where folio_set_active() is
-		 * called for workingset folios
-		 */
-		if (lru_gen_in_fault())
+		/* Send refaulted workingset folios to active generations. */
+		if (lru_gen_in_fault()) {
+			folio_set_active(folio);
 			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
+		}
 		folio_set_workingset(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	} else

-- 
2.55.0


