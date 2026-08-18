Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9998D331A5B;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787031504; cv=none; b=qkkv0vExO1zszz1HKbojIXxLaBSlX9WQCHOJk9Unmspreq2DA0YKl+e6jC3YIMDjW3ECFSuJpQws13xDzKm01T8pu9gNyYaEc2iIjwCaXEAC/oKxRmz+IKDQeSr7yGGyz5XyFdS/4GxnRKm7/VHBAn0X/FJkyo99OvKZDwOaa4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787031504; c=relaxed/simple;
	bh=/Dap8HX+JALspR15co61JO/ZEe5sgXMBY1Lvt6lrf0U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qWIs7ELeGzwfPx1rBqZPn/Ag5hZcZYc9OWxOHMOJoGvDStiHvPhvqjvLdFlSHLS+QxZGt3NVMLiQn4LsEsZh7Ezg9yw7czA7c00C93JkmugtTXgFuLGjqoc9V0fnBAY83J6ETxx+TF73T8BhZybmrhcCc3MBYdZVlJqIGoApuVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KpA3xO6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KpA3xO6c"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41221C2BCFD;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787031504;
	bh=/Dap8HX+JALspR15co61JO/ZEe5sgXMBY1Lvt6lrf0U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KpA3xO6c41IaXbmqmCFFQNGgoiKoADBI9iIN5v1UtOj5mM5iCtENnL3NuKy0jae6Y
	 saGmVezGKNIRYu8komaX1eDr3C+spdAJdi1wB6tPXleDN8/7T++ZqESkDbPfmhxYuI
	 Cvk4cqMjQuRFLZjUHLHHWHfUWGXHRka/450fgn2lPYrZCMSNGaXWmxd/gieSKlnhFG
	 9N+cxxdoUt9gHa38bAozYxLZRWsDp0JirwdS5lk1u73wU9CUy9IP3HKh1y1g/W3NCK
	 M7Bc01TLYjpmzv/bWS4ZONcjF/ZmpCnl9/bf/VsWH6VDXHgoPn9FL5tnT/6nm9ZeaN
	 ZQPFwMA/qgt9A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8CCC5DF82;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 18 Aug 2026 13:38:05 +0800
Subject: [PATCH 3/7] mm/migrate: copy the referenced state via
 folio_migrate_refs()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-mglru-flags-cleanup-v1-3-8dbbdac0d28c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787031500; l=2602;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MnXqCrD+kNnVgk+e93wC9DHznJeWbyePZC5TTqXqepo=;
 b=11ce+XvCl2hD19O2/CuCgrvBrmVTUm6nz/9U0YfjPuhZy1wZ8IJb0amYtFNhwztQfIB/4LtWh
 dx0NKZPYnYMBdFtD1f5AZ3c3/MzE+JFMBVWgnVPkcoVz/2/dB4v2kvE
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

folio_migrate_flags() copies PG_referenced separately, while
folio_migrate_refs() copies the rest of the reference state. Make
folio_migrate_refs() copy the complete state, i.e., PG_referenced plus
the MGLRU refs counter, in both LRU implementations, and drop the
open-coded copy so the reference state is transferred in one place.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 16 +++++++++++++---
 mm/migrate.c              |  4 ++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 93bf3fa221f8..df62daaa2ee7 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -366,11 +366,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
+/**
+ * folio_migrate_refs - copy the reference state to a new folio
+ * @new: the destination folio
+ * @old: the source folio
+ *
+ * Transfer the reference state to @new during migration: the MGLRU
+ * refs count, including PG_referenced, or just PG_referenced for the
+ * active/inactive LRU.
+ */
 static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
-	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
-
-	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
+	BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 #else /* !CONFIG_LRU_GEN */
 
@@ -401,6 +409,8 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
+	if (folio_test_referenced(old))
+		folio_set_referenced(new);
 }
 #endif /* CONFIG_LRU_GEN */
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..82307332711f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -776,8 +776,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 {
 	int cpupid;
 
-	if (folio_test_referenced(folio))
-		folio_set_referenced(newfolio);
 	if (folio_test_uptodate(folio))
 		folio_mark_uptodate(newfolio);
 	if (folio_test_clear_active(folio)) {
@@ -807,7 +805,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	if (folio_test_idle(folio))
 		folio_set_idle(newfolio);
 
+	/* Copy the reference state, including PG_referenced */
 	folio_migrate_refs(newfolio, folio);
+
 	/*
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.

-- 
2.55.0


