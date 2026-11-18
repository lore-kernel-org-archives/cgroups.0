Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795035833;
	b=w8KwbX43Fb+1QIXAccilA5F/a2f8ULL7uVXemXcw8oHdy2HZeUb9bdeESX4oXNqVOlAC
	 EN8xsMBz6023S3XJ6MicL2d2RXZ2gRGeDFZCZ6g0ZPhX7t2/jUvUw/8kUU6FK+WUybrz7
	 unanBsHK9YOg/qlsR85Mrcmq5RB4PSI7hNrvFLu6+i8I8C6k1Xrkpf7hegaHcMHGSonk7
	 LAh9aWdxMnJdlAE0hMS/v73aJ0njSCY0gOPVScJR9EeP+dWNdhKrwMlUqzaFr5FeHIpGu
	 LwyQyWA2/h8Eabd5H210EJGGrMi2CKZBc+hkAfBUQsHXcUd29JwDAiGt2ZBx2ql/EHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035833;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=IzsbJHeLt6AX6DClQU1Tp3h6tzemqX+s4gHhI4j9FYs=;
	b=PxIFAEPJu1B60tZ/SNpL5bYNxAuUg8IyOcJEc2mNmDGKDqYoYky6F7yM6XWyzCtH/GHD
	 Hx0PjveDwfHNHb6qOrRm61syDT3nE0ZuL7PLBY8bz/26bYxl9Vos6ECshnWK20hlGavaI
	 jOn94taSgVaA48r9bWjXaYWsjdH+Rml5LxK43gG0Qw4yp+ZJHJT6P1BBQ6leWXsz/gdH9
	 Q0MJgZl9JETNfVCz9CPPl77cq6DnAbLSHQivrQQhTdElHvhpZcmypsy4Z4ZDyj02sOQdZ
	 cP6TNfz1QbmpajxJge+kxSGVROr1df55vME/gdcKnqKDDhEYj1oj6gq1JtRfiIZsfGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTwF4mZ2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875BA60A2610;
	Wed, 18 Nov 2026 21:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTwF4mZ2
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035833;
	b=oNbAKi3UTwJtvTCNNNX2hav0xajWwZUSFs9itYCQwK/UiBwwUY4Ih3miBh3orwb1DwWl
	 gVAspg1xtiYQcTWY5g5wAEkTYKLzlP6IFqoGqmhsQvd1eEP/MHr4oh/4+9cBmfk+uRfQ0
	 8BOrGZowYYOmTa3bpSV9MYvpIGetBLwedp0ldr2y3vPBvUEdKkHKvPLucadSJrIf3FNji
	 siwIQ265tA7J04vsmM31CITw8ASV5npjwAV4Gk3iHSE6EOEvx+lVBTC92VIV0GJOoUohL
	 VdrQBZgpBT4Du2paLpeZqtZyZ2h3zQD/PP7De4bl7NBbm+Q3eohAai6lb/xbfAytqlQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035833;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=IzsbJHeLt6AX6DClQU1Tp3h6tzemqX+s4gHhI4j9FYs=;
	b=n7fpvFMDDVLswOIjVBcaY/DM80kcropFb0A5ZxUTPrBwKHY0NZ5cpMFeWrZOF2my0r7/
	 i7RZOWZsLBV/XvA0xjFX/J8Q/W4CtgZv0dhVhGDtgVPn/sSVN0MQxjJWDa664tcBdgMCS
	 Hh24Bv+RkVEmfiBXvNMNu/mcf7xIyZHCeWh7zpRc7gugznkHDfQh9KY5I89apOXSditvk
	 GtvffBVOXCqzVKEU6Q5udw9/U5CuJ3PnK6JbPEnuQuMXXVzJkhSpNymH9orzPa/fzoHzU
	 dZqkDxvzK4lsA+objz8XPSjpZpOZL9CeeWpi8tqNXjDmTyA6F3BmBvzfkLboq/KAFpQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F24AC1F000CC;
	Wed, 18 Nov 2026 21:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035833;
	bh=IzsbJHeLt6AX6DClQU1Tp3h6tzemqX+s4gHhI4j9FYs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fTwF4mZ2ntiCM6HOgmmENBnhFJG4Ogpk4lkeCNkSqSS6Jpm8UZXsPzLBfaDqSWuKg
	 jLSshVGFyBF4UpBHrmTOUf39tmQ7SWnqHRlTw1cXrXMaTsuAUMvQugfusd/xg0XF6+
	 U4+5bsKZkZ4dwC/VMtwK+VbBrLDUGuwXxpeScPgIgv4yQyrBKF6UDz+lu2eAFuZygW
	 7w1iu2SdoUq+3IxGlF0JT7/Y6kdoAoI4T9HUr2Iod786SbKYmuoLyHhrKfsUEcMcLR
	 UL+TwgvMwXPLbAf5XctNndKpA9dmJmBk7bWwOtP3okwkBa3N2G1UeoCpgW9ar5utqc
	 ww4btBDWZc+zw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CCE944AFA0;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:39 +0800
Subject: [PATCH v5 07/17] mm/mglru: make folio lru referenced times count a
 generic API
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
Message-Id: <20261119-mglru-fg-v5-7-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
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
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=4693;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=koGM/cEkqmlw+8OmW+1cKVMTHOPOsjOLqgFFy8X/KuU=;
 b=zi/6EnbKEEehIkojCaP08SItBx3AmxZ9iynviSfz0axtK8BbU4T2ebhake7ZZUYYYMxUobit/
 dhlpf518quqDlSdQTWZXqY7Y4QUCWJ5nRk1PPMq8DvUs3x0SaQPIdbl
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

Pure code shuffle, no behavior change.

Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
Without MGLRU the extra bits are never set, so they are inert. Move the
lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
unifying the API for checking folio referenced and workingset status.

folio_migrate_lru_refs() now migrates the complete refs count,
including PG_workingset (bit 1 of the encoding), bitwise identical to
the direct copy dropped from folio_migrate_flags().

lru_set_refs_flags() skips the nonexistent mask bits when
LRU_REFS_WIDTH collapses to 0, preserving the two independent flags for
!CONFIG_LRU_GEN builds.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 55 ++++++++++++++++++++++++-----------------------
 mm/migrate.c              |  2 --
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index f38dad1198fc..180db43c3a85 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -184,6 +184,12 @@ static inline int lru_get_gen_flags(unsigned long flags)
 	return gen;
 }
 
+static inline int folio_lru_gen(const struct folio *folio)
+{
+	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+}
+#endif
+
 /**
  * lru_set_refs_flags - Set the LRU referenced count to folio flags.
  * @flags: pointer to the folio flags
@@ -206,7 +212,8 @@ static inline void lru_set_refs_flags(unsigned long *flags, unsigned int refs)
 		*flags |= BIT(PG_referenced);
 	if (refs & BIT(1))
 		*flags |= BIT(PG_workingset);
-	*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
+	if (LRU_REFS_WIDTH)
+		*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
 }
 
 /**
@@ -252,13 +259,31 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
+#ifdef CONFIG_LRU_GEN
 void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
+#else
+static inline void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
+{
+	/* Should not be called with !CONFIG_LRU_GEN */
+	WARN_ON_ONCE(1);
+}
+#endif
 
-static inline int folio_lru_gen(const struct folio *folio)
+/**
+ * folio_migrate_lru_refs - copy the reference state to a new folio
+ * @new: the destination folio
+ * @old: the source folio
+ *
+ * Transfer the reference state to @new during migration: the MGLRU
+ * refs count, or PG_referenced and PG_workingset (bits 0-1 of the
+ * encoding) for the active/inactive LRU.
+ */
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
-	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 
+#ifdef CONFIG_LRU_GEN
 static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int gen)
 {
 	unsigned long min_seq = READ_ONCE(lruvec->lrugen.min_seq[type]);
@@ -424,20 +449,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 	return true;
 }
-
-/**
- * folio_migrate_lru_refs - copy the reference state to a new folio
- * @new: the destination folio
- * @old: the source folio
- *
- * Transfer the reference state to @new during migration: the MGLRU
- * refs count, including PG_referenced, or just PG_referenced for the
- * active/inactive LRU.
- */
-static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
-{
-	folio_set_lru_refs(new, folio_lru_refs(old));
-}
 #else /* !CONFIG_LRU_GEN */
 
 static inline bool lru_gen_enabled(void)
@@ -470,16 +481,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	return false;
 }
-
-static inline void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
-{
-}
-
-static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
-{
-	if (folio_test_referenced(old))
-		folio_set_referenced(new);
-}
 #endif /* CONFIG_LRU_GEN */
 
 static __always_inline
diff --git a/mm/migrate.c b/mm/migrate.c
index 28a8d7734735..c8c49357df87 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -796,8 +796,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 		folio_set_active(newfolio);
 	} else if (folio_test_clear_unevictable(folio))
 		folio_set_unevictable(newfolio);
-	if (folio_test_workingset(folio))
-		folio_set_workingset(newfolio);
 	if (folio_test_checked(folio))
 		folio_set_checked(newfolio);
 	/*

-- 
2.56.1


