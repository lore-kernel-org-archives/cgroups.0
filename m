Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1B73D1CC1;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787031504; cv=none; b=OHBOEe+Gemol38yQNvoH0aayX0DyFOD+PbER6tAm+SKqJEMEArGGaAeYht8AxcL8CHA36XAQkha4lSuTUnfbQlA6HJZdwK8fQfraaLCuHKdxj1tMSPwmoNddMmWFJJLMpQSHSaJFCeosloLv7iWy6uE7w9jPcRckdWpobNXOLCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787031504; c=relaxed/simple;
	bh=vf7uUbNRQoieyYFfFFIOjDq7Zps04yMwcdb5rXbBTqQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bu9mEd+FQJOgRdo7rUVD7l6ecq0cSiTVDocSOGn410WLsdjokbKMcJCnJ+IKosRQQsA8dV4vgPBX8p/DnK5fXa6NOm+qIlcvDETIRddvAE2e2dfBKVT2GPqu2ijntIKbGB9WRJET2e9gyhOcK70VfsUqvdJZPHNdKWZnCl1hW70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LTGab89Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LTGab89Q"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DC97C2BD04;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787031504;
	bh=vf7uUbNRQoieyYFfFFIOjDq7Zps04yMwcdb5rXbBTqQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LTGab89QxsH+2wOkBE11hQkp5+C3ffibZSkFOVGgVBY/t9R6+5V4buuIn2akRMsBP
	 DbU4oKpvnnxkytOuhdWYLe7dU20+pv55FuTpEpH5YcKmCJs3HBuw2yd33R3EiWNMUH
	 WWicCJLDsSdCrC0DzserL9vFumBLpygQTm6dWtuHcKHnkMBzbxaJiA1oDhidQ/1Jfc
	 EcuXXm21Nl6RRTo8y2EymKXn9PNTOIGlUEBZXZC04C0O7Rh73UWzXN8s48k7Y2eRV1
	 jafAMoFq82epiQ7ItDOT0gw10W4uHFF6GtMs0hhINHVzxUCma9cK8j+HrK2BawiN+A
	 7Zt2GcdKD3Frg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C04C5DF80;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 18 Aug 2026 13:38:09 +0800
Subject: [PATCH 7/7] mm/mglru: improve code readability and harden
 folio_inc_gen
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
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
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787031501; l=1891;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=VAAQ2yiZ5J1ZoI2nmEdgdm+eoSsfABEBNy6fHJoC/Ao=;
 b=vfv8/0vJNXjl4xfANa0zvplr3gsB8l5c6I3ZE3bYCfgQRy1JPhuV/RfkOve+UzP3ZSo3ThysQ
 4bzJd3exJcxDOzcNw7VQ6D4JMMsKi6+5BvFKSfMgZ+wrxOLJtBX/l/a
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

The helper should never be called for an off-list folio, and it always
expects the folio to be in the oldest generation before doing any
cmpxchg. Add a sanity check for the off-list case: if it is ever
violated, bail out and keep the folio flags untouched to minimize the
damage, instead of silently treating the folio as if it were in the
oldest generation and promoting it updating the flags to an unexpected
status.

Also rename the variables to clearly distinguish the folio's current
gen from the oldest gen.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7169cac60869..7e3ae0c6cba3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3308,18 +3308,22 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 {
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	int new_gen, old_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
 	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 
 	do {
-		new_gen = lru_gen_from_flags(old_flags);
+		old_gen = lru_gen_from_flags(old_flags);
+		/* This helper should never be called for off-list folios */
+		VM_WARN_ON_ONCE(old_gen < 0);
+		if (old_gen < 0)
+			return min_gen;
 
 		/* folio_update_gen() has promoted this page? */
-		if (new_gen >= 0 && new_gen != old_gen)
-			return new_gen;
+		if (old_gen != min_gen)
+			return old_gen;
 
 		new_flags = old_flags;
-		new_gen = (old_gen + 1) % MAX_NR_GENS;
+		new_gen = (min_gen + 1) % MAX_NR_GENS;
 		lru_gen_set_flags(&new_flags, new_gen);
 		lru_refs_set_flags(&new_flags, 0);
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));

-- 
2.55.0


