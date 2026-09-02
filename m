Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EEA42E401;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788342660; cv=none; b=sTT6lkoejRfeTt9TN1uUmy2s3TX2GMAGfljUW0IZBiB9tuwr9/q3Zrb6Q0Fp+fm1GwdeDT90YzilsuBUIpJaBwq2u6sVAAXg1hIzIJXFYkj3SIhVAVztN5nxb1SbhhqBDyCZUGNubPpkPYM1e7zcjZXQLL+c6ITrCPhfFDWCFg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788342660; c=relaxed/simple;
	bh=ZFETDp6p9x9uvwIEd+HcIi3/dkthWZDx6+TpdJIY9to=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jD80QVRiI3dw1NHbbb+wlpnpmrf0T3mBEAIuJKsOwoq6nmBJT9H8TmtB/3WVMGMX3aXUB8koMOvcv5Q4oJiVC+ISpfm1XaGG4wWKUduqPJdhdarCuoNr8UDJC/31/ZB/tjxPDVMxaiByQAiep0BK6zZGx7CobSoH82J+D7Z/QwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODwY/Ye6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODwY/Ye6"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0954C2BCFA;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788342660;
	bh=ZFETDp6p9x9uvwIEd+HcIi3/dkthWZDx6+TpdJIY9to=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ODwY/Ye631Rwhf/3uAzAk/Q5xTBhXfzqlhdZP675Mo8LmaAoMUt01xRD265D0dYau
	 5gMaJdSNbFmdYbWRn3I0OiknCFUs7Wv4w0jadRepdCkClmNVWj2MP6OoqbEcbewu4h
	 yKzozgREq4rkHWsf4WQMc/NdoLJ7kTbJrInFe4aSTiokhWvNkr/szwJYrPGH83g2wM
	 45YVqD5+87AbGav0rkRlf+kUsWsm0cQhDHL1RNVfleoRc5BHK6Gzt7AoHCRJRR20AL
	 M7iBBGyxhoQ3+8FFNUFjnTnxE7rFya1V7xhkWtJVfm+W/5NYb4chZ6p6wg2hcXl+CV
	 hzWhBMuugj/BQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF60C624D7;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 02 Sep 2026 17:50:56 +0800
Subject: [PATCH v5 3/6] mm/migrate: copy all referenced state via
 folio_migrate_lru_refs
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-mglru-flags-cleanup-v5-3-9db761d779ef@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788342657; l=3683;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Ox6zaP/QbfpF5dExxI36sjV5rWUkpJpYAOEG95FC1rw=;
 b=FEnfQvBL3/fmg1asiheJX1Ar9Ld/4KCcGnDdckAqj+CLkjyccsIX7u5VcGKPNX6YhMjrv98vM
 Hkt6CXlJifbB7kso51KMQSSbOdxbtfGM4GOe5GnDa2NksnCGAoAPNpT
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

folio_migrate_flags() copies PG_referenced separately from the MGLRU
refs counter, which folio_migrate_refs() transfers. Yet under MGLRU,
PG_referenced and the refs counter bits together describe the
referenced status of a folio.

Consolidate the two: rename folio_migrate_refs() to
folio_migrate_lru_refs() and let it copy the complete referenced
status, i.e., the MGLRU refs count including PG_referenced, or just
PG_referenced for the active/inactive LRU. Drop the open-coded
PG_referenced copy so the referenced status is transferred in one
place. No behavior change is intended: under the active/inactive LRU
the extra bits are unused, so operating on them is a noop.

Transfer the reference state first, before the destination folio is
marked uptodate, so a concurrent lockless reader cannot have its
reference update overwritten by the copy.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 20 +++++++++++++++-----
 mm/migrate.c              |  6 +++---
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 3f4bd5b02b54..047295ae6e8a 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -373,11 +373,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+/**
+ * folio_migrate_lru_refs - copy the reference state to a new folio
+ * @new: the destination folio
+ * @old: the source folio
+ *
+ * Transfer the reference state to @new during migration: the MGLRU
+ * refs count, including PG_referenced, or just PG_referenced for the
+ * active/inactive LRU.
+ */
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
-	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
-
-	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
+	BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 #else /* !CONFIG_LRU_GEN */
 
@@ -406,8 +414,10 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
+	if (folio_test_referenced(old))
+		folio_set_referenced(new);
 }
 #endif /* CONFIG_LRU_GEN */
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..a369d0c95c38 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -776,8 +776,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 {
 	int cpupid;
 
-	if (folio_test_referenced(folio))
-		folio_set_referenced(newfolio);
+	/* Copy the reference state, including PG_referenced */
+	folio_migrate_lru_refs(newfolio, folio);
+
 	if (folio_test_uptodate(folio))
 		folio_mark_uptodate(newfolio);
 	if (folio_test_clear_active(folio)) {
@@ -807,7 +808,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	if (folio_test_idle(folio))
 		folio_set_idle(newfolio);
 
-	folio_migrate_refs(newfolio, folio);
 	/*
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.

-- 
2.55.0


