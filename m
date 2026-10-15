Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1036956E071;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792088156; cv=none; b=qSLbKwvPtdN1/ryxTm8ZVjbvyfmb+ONKnmJBUEJpRBiwWzRQKWWFOf4Zvtpwmn58tcB1/AxgjQwp8GhM0vpvOMj5dyz3QfZC4U8fFMKjWPM9bmqGkziZCZ5AIQpRSkIRZlRNndqadYBV7n7qut9tvfDkY9+GWxrcOf3MGckYPIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792088156; c=relaxed/simple;
	bh=EtFdBNMl7rTc3+2KnBe5NCt6EPdFW/oy5PCsxQTtGYg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cXdrKifgvAUes2FjPQrDfykuBpnUOvnHnXpLy0L1908X1bcjdn5zv5ff1DjaW6qzB/cMGZ5bhK3pRpfkjQ4V6/BipguGNYkTIixGaBnsVgUBpimd2IkBBSJxKJ/NT4GoVvwdmnoasPmyPkovmhT2WR12xOvxCi4W5E/bcMWrYwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kb391yTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kb391yTr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 780E4C2BD05;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088155;
	bh=EtFdBNMl7rTc3+2KnBe5NCt6EPdFW/oy5PCsxQTtGYg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Kb391yTrlC4wqc+SJNZmT89MRNc9OEN475jtNUimO8h5z4RHUz40UWiwBPKlRYi4b
	 BRcSx6NPvAB8Bhlt5ggeFbJd3xK9L38LUm4G4HTyfSR/w68wtAyoQN2MQGcX8Sx5yM
	 0Tzhe6wjKtfLxIypH+atxvRH+FYhV4bwU5QatUIhLIIkJaFBuwp7kU8xv2syKolgMA
	 nBpz1R42+F81MXByxQdA0syxQg+mRfgQUnPpXHVpWwkEnqKyALvYHQyt07h/myF/Hl
	 GOXL+pwGG/dQ/W4Zt8jnBZAIU2bzt2POm4pm7L3eZA2X6Ex92zDcXWf6+lAPZcJnr6
	 AuYFDuEDuTu0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F7FCCA469;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:15:54 +0800
Subject: [PATCH v4 05/17] mm/mglru: make folio lru referenced times count a
 generic API
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-5-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
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
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=4691;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=pnvvt+TNjTFasMrCaGELLai88pW+DMjr8ivb+8icxYs=;
 b=2pYnsvVBeywNZk/IqxKSwnVGHLJe4YzTLE0xzeBV928nbdHQBo8JVn3nfsIV5SXIAHdB9m5pu
 um1VbmccsnbBUOWooMumSGVyWRDol3yYP5jq8lKdlkvTeYic/0Sa+u4
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

Pure code shuffle, no behavior change.

Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
Without MGLRU the refs bits are never set, so they are inert.  Move the
lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
unifying the API for checking folio referenced and workingset status.

folio_migrate_lru_refs() now migrates the complete refs count,
including PG_workingset (bit 1 of the encoding), bitwise identical to
the direct copy dropped from folio_migrate_flags().

lru_set_refs_flags() skips the nonexistent mask bits when
LRU_REFS_WIDTH collapses to 0, keeping the generic helpers inert for
!CONFIG_LRU_GEN builds.

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 55 ++++++++++++++++++++++++-----------------------
 mm/migrate.c              |  2 --
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 74d1b7a04ca1..cfcbe4a9aa85 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -183,6 +183,12 @@ static inline int lru_get_gen_flags(unsigned long flags)
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
@@ -205,7 +211,8 @@ static inline void lru_set_refs_flags(unsigned long *flags, unsigned int refs)
 		*flags |= BIT(PG_referenced);
 	if (refs & BIT(1))
 		*flags |= BIT(PG_workingset);
-	*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
+	if (LRU_REFS_WIDTH)
+		*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
 }
 
 /**
@@ -240,13 +247,31 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
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
 static inline bool lru_gen_at_tail(struct lruvec *lruvec, int type, int gen)
 {
 	unsigned long min_seq = READ_ONCE(lruvec->lrugen.min_seq[type]);
@@ -401,20 +426,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
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
@@ -441,16 +452,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
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
index 7bdcdb57652f..5eefd8547f70 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -786,8 +786,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 		folio_set_active(newfolio);
 	} else if (folio_test_clear_unevictable(folio))
 		folio_set_unevictable(newfolio);
-	if (folio_test_workingset(folio))
-		folio_set_workingset(newfolio);
 	if (folio_test_checked(folio))
 		folio_set_checked(newfolio);
 	/*

-- 
2.56.0


