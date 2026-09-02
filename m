Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685B142D777;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788342660; cv=none; b=ObgHV46L+92AKawY9/Z2afJa1mbkkUuR42SKSJDR4e9dVjwB9p3r1HYier3pzxTih02yojh5C8ypdfrMv/nE83fky4n5u9r8ugnbFInizSE7rDpZiSe0q+qc7jIV7UlnP3wFT0WPMkjDQV+Aa5zVJmUT/QqgGLCiIr82n35IJF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788342660; c=relaxed/simple;
	bh=Mo3+8RFfppINKIARqVbgEULhQ/6q8Q5E73vtDdVsNaQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JQF3e3/2tqhiRFMnhpkDj2z09XUWHYauncTD5WroGAQg0MBHbAttlw6cB6kTL3wAGMX4XjOM9xXRTbZIDUUTdkvplxVPflw+5YAPL9bnP0jvE5/+k2dvgVBhk8j2eY9aMUO7eRlEeBGvLOx75/hj0CxX2tLOsdkP2Gv8r8srdu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjN8Jh71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjN8Jh71"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B516C2BD04;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788342660;
	bh=Mo3+8RFfppINKIARqVbgEULhQ/6q8Q5E73vtDdVsNaQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LjN8Jh71ESTtrz0II1QkWFMR6Ekn10yjUiU5wrtpB83llUdV/2TXESJKlYxXGJbFK
	 BjL/hqJHbUqLQ+xQ7JKPNusWEkPdY3H3tSO0Tripls89K0PunwIWQZJCzgkJ01O9VE
	 MF0jUHlUj8tq8RKt4PsFv4Ve+bB3kLb14TmcN12pef+qAjOXu9J5M6q/6aHQAvub+I
	 wtL7Ub+pGmIsjG3jKL3/mxnsnakHKDJj4Ck/bM7+uPcLyFOxE0xC076uHuPhnmg5Ob
	 +JvXfQKRavAYb/WERikZtdLsVUbzNO0i9U6pMdIidmI4xXF5ULRIzKAX1hAGCvxddi
	 o+jRgTBAC38xg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FB7C61DD6;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 02 Sep 2026 17:50:58 +0800
Subject: [PATCH v5 5/6] mm/mglru: use explicit tier range in
 read_ctrl_pos()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-mglru-flags-cleanup-v5-5-9db761d779ef@tencent.com>
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
In-Reply-To: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788342657; l=3649;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=oVmtU7RtLEHATDqO9A5jftz8sm6P6wAktfihxMqJ5Tw=;
 b=dPPzLe7vps/4tFzAt1JpcbiW7bZLRHQCFNYaCQ4sCRNhFfKoV8rZMZJk4dpFzSA1X0k61uup7
 ZtSlanhdkEYCfpC+U1UuJBSbBsreUiJ79Z2nOzSwDx7LLDmkPwdeE/2
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

read_ctrl_pos() encodes the tier range in a single "tier" parameter
via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
as the end. This is hard to follow, maintain, or extend. Tier values
0..3 select a single tier, while tier == MAX_NR_TIERS selects the
full range.

Replace it with explicit (tier_min, tier_max) parameters using a
closed [tier_min, tier_max] interval, and add LRU_TIER_MIN and
LRU_TIER_MAX for the tier bounds. The call sites now become
self-documenting:

  - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
                    (tier, tier) for each subsequent tier
  - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range

No functional change.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mmzone.h |  2 ++
 mm/vmscan.c            | 18 ++++++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c9ecf370cd9f..9b27cf53bdbc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -492,6 +492,8 @@ enum lruvec_flags {
  * folio->flags, masked by LRU_REFS_MASK.
  */
 #define MAX_NR_TIERS		4U
+#define LRU_TIER_MIN		0U
+#define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
 
 #ifndef __GENERATING_BOUNDS_H
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 96fdfc14f615..714a3f273f49 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3198,8 +3198,8 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
-			  struct ctrl_pos *pos)
+static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
+			  int tier_max, int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3208,7 +3208,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier_min; i <= tier_max; i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
@@ -4809,9 +4809,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
 	 * This value is chosen because any other tier would have at least twice
 	 * as many refaults as the first tier.
 	 */
-	read_ctrl_pos(lruvec, type, 0, 2, &sp);
-	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
-		read_ctrl_pos(lruvec, type, tier, 3, &pv);
+	read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
+	for (tier = LRU_TIER_MIN + 1; tier <= LRU_TIER_MAX; tier++) {
+		read_ctrl_pos(lruvec, type, tier, tier, 3, &pv);
 		if (!positive_ctrl_err(&sp, &pv))
 			break;
 	}
@@ -4832,8 +4832,10 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 	 * Compare the sum of all tiers of anon with that of file to determine
 	 * which type to scan.
 	 */
-	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
-	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
+	read_ctrl_pos(lruvec, LRU_GEN_ANON, LRU_TIER_MIN, LRU_TIER_MAX,
+		      swappiness, &sp);
+	read_ctrl_pos(lruvec, LRU_GEN_FILE, LRU_TIER_MIN, LRU_TIER_MAX,
+		      MAX_SWAPPINESS - swappiness, &pv);
 
 	return positive_ctrl_err(&sp, &pv);
 }

-- 
2.55.0


