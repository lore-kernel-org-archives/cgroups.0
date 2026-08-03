Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1FF3A718C;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785786443; cv=none; b=nsmSxaZ78AB9Gg4gI154dJAPbipGTS0V8ZwbMgxf93VS1x3kivcrp979Yd9tGSeZ4shr8K+YG6cYWzBbsu41/m6uCBKgZuSJ3bz0bkiCFTIE3iULaZ0e1yfD0KHlvrKmwmBigc/L9bFYB5W0k65l0/ftO5BWU8BGDvcErOHas20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785786443; c=relaxed/simple;
	bh=HQaTSb9gKEiXAW8L884mD+Mrb/OnWgT7I1M4oD8pA9I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PW6PwrBk8lb0rNxju+8fXxVcqc7zUKYbBY8ALrd5dhgOylxaTfMFea6JNCtUYC2Q5dhgAZetvIXJ+zQduUmH964ji0fMCrgyz5NSIFhev+10F2cFbg2kRjeMGknid1wTSbVBEleNU61ERR2rgxlwKMaayH3HXzagiOJnR5I8s3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jbTvdM4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jbTvdM4k"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4EAAC4AF50;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786442;
	bh=HQaTSb9gKEiXAW8L884mD+Mrb/OnWgT7I1M4oD8pA9I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jbTvdM4kU319OryzxazU0+wim1SrBjWHRGzrjsZ/dE/8RKZ/X/pWewA2SgMACUbRU
	 768yYi9K8pPMEYD+lgTURjA56h4lGz3rhufrxlusn1dEWblp0AJlCmyqqa0jEJLtVz
	 yCipkzFcNfSrEETg7dAvwy0VMAUtAayuIa+9OaV0rGWUQm/P+uTUuMRZSlYR/egXhM
	 oocuydPT8RyO4FtJTpZYTYFHOXpf7m1MloNKOGK9cn07MQuIgPetlA1jku8E7YOQ/Q
	 b+QXd5oV1eZxq79+1X5IAB8QGFoieiVHIvp1OYXaBw+Nz3vKJ/Db5hgSTtQxBfpu15
	 9Pl9ZwmygdQtQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F13EC55843;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:02 +0800
Subject: [PATCH RFC 06/15] mm/mglru: use explicit tier range in
 read_ctrl_pos()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=2788;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=sdC9n1WO6u/L2tFXmmCkir7R9Dni9ihu1pJnxCifFTc=;
 b=xv52kVfAPZlxWefP3f8wGwS9plTRIu50H/DgY4be7zffsSSa+ZutP0PLQZylfBQsByG3RFGPe
 vxKVGP4iz+OCGKU2vFXYDZzUJzjoXQqLB4c3nywiA7e41WfE2Dqkv4H
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

read_ctrl_pos() encodes the tier range in a single "tier" parameter
via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
as the end.  This is hard to follow or maintain or extend. Tier
values 0..3 select a single tier, while tier == MAX_NR_TIERS selects
the full range.

Replace it with explicit (tier_min, tier_max) parameters using a
half-open [tier_min, tier_max) interval, which is the conventional C
idiom.  The call sites become self-documenting:

  - get_tier_idx:   (0, 1) for tier 0, (tier, tier+1) for each tier
  - get_type_to_scan: (0, MAX_NR_TIERS) for the full range

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c2ea92c2b69e..a359d5a1ff41 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3192,8 +3192,8 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
-			  struct ctrl_pos *pos)
+static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
+			  int tier_max, int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3202,7 +3202,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier_min; i < tier_max; i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
@@ -4805,9 +4805,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
 	 * This value is chosen because any other tier would have at least twice
 	 * as many refaults as the first tier.
 	 */
-	read_ctrl_pos(lruvec, type, 0, 2, &sp);
+	read_ctrl_pos(lruvec, type, 0, 1, 2, &sp);
 	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
-		read_ctrl_pos(lruvec, type, tier, 3, &pv);
+		read_ctrl_pos(lruvec, type, tier, tier + 1, 3, &pv);
 		if (!positive_ctrl_err(&sp, &pv))
 			break;
 	}
@@ -4828,8 +4828,8 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 	 * Compare the sum of all tiers of anon with that of file to determine
 	 * which type to scan.
 	 */
-	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
-	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
+	read_ctrl_pos(lruvec, LRU_GEN_ANON, 0, MAX_NR_TIERS, swappiness, &sp);
+	read_ctrl_pos(lruvec, LRU_GEN_FILE, 0, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
 
 	return positive_ctrl_err(&sp, &pv);
 }

-- 
2.55.0


