Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9422B3515F2;
	Wed,  2 Sep 2026 22:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788388304; cv=none; b=auN6g7rL6gno9mmkrePcI81lGsd3vkCpqAJVVH5Vf4UajVmF7AgfTljA4nmR5kmfuVwsrUPP8YLgQ4DQ1p3jsA6TG8y+wdOekmDBy75gGfbXZBJpnT43D275DOBdfi5MK7225vpaFEEOknhc9Z9d5adGXz2vR1HzGQtiYezcZqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788388304; c=relaxed/simple;
	bh=0dsZV3tbWTFMif3+cPxaurPu392Yzp5Z/QzX/3Dx3kc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YOSANo2Kdpum+rFlNAMCBITefxklo8GYcF1biqtnV+USNlg4Ny0l/tiVTIo1T1PwGkbUVHLHWSJedlhoaBoAe4bML4G+F7dRDUEYW+5N1N4elwQNMzSqCMulVhn3XS3cv6wuY9hCBax1lRm8Mgcy7wkUmrHmLTUiATJ7o1Ye+oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lzs77CH7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lzs77CH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE241F000E9;
	Wed,  2 Sep 2026 22:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788388292;
	bh=FAiwcVZ9zVI1PdFs8RlzggVmFg2ZlUcGQqtrbjs/05o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lzs77CH7ybfoy1r3ORmCEgCcsyCXnS16VnexMVhEvMhklsWlYDubT2GpYFU9hC3gu
	 QVsgVc7hp0WzY23xbRLhZSOtXliv0BG+Ed0SDQzJmmToJxK9xqZXJXIYOFyCOpL+g6
	 BhyqcnFmBFWDcizzcOvTNwN4FpZTgdmRRAonf49CAG8melrgtm1DfWSqVIeT/CcqDi
	 spPHOOstpjKoM7gJc1OmSqn4xzxQmOCkOIfxrRcVgVKSQqdNoB2a89nU65qpVo/yqe
	 4fRMecTAk0BN2NWz6pcWnb1/9PGAi+7MyYNPucmxvSzK6R3JBTr/EZKP9yi3xtnXek
	 2vet/rPVlu39A==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
Cc: axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	cgroups@vger.kernel.org,
	chrisl@kernel.org,
	david@kernel.org,
	devnull+kasong.tencent.com@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	roman.gushchin@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	vbabka@kernel.org,
	weixugc@google.com,
	yuanchu@google.com,
	yuzhao@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH v5 0/6] mm/mglru: clean up folio counters and flag usage
Date: Thu,  3 Sep 2026 06:31:24 +0800
Message-Id: <20260902223124.48962-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260902141153.93b932ba572b1d3375216cc4@linux-foundation.org>
References: <20260902141153.93b932ba572b1d3375216cc4@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, Sep 3, 2026 at 5:11 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 02 Sep 2026 17:50:53 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:
>
> > This is a cleanup series separated out from the MGLRU-FG series [1]. As
> > that series is getting too long in following updates, seperate out the
> > clean up part for easier review and merge.
> >
> > No feature change is intended, except one bugfix. It mostly replaces
> > the open-coded bit operations scattered throughout the MGLRU code with
> > new helpers, with proper kdocs, sanity debug checks, and hardens a few
> > MGLRU functions.
> >
> > A subtle generation counter leak is also found during the refactoring
> > and the fix is included.
> >
> > Also collected review feedbacks on the cleanup part from the posted
> > series.
>
> Thanks.  I hit a non-trivial reject in [2/6] presumably thanks to
> mm.git (mm-new) race conditions (appended).
>
> The patchset comes nicely review by humans, but AI is less happy:
>         https://sashiko.dev/#/patchset/20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com
>
> So please take a look at all that and retry in a few days?

Sorry for the merge conflicts.

I rebased Kairui's series on top of `mm-new`. I guess all we need is to
make patch 2 look like this:

From 01e2013722443f685d47b42e7d9b11aadef58722 Mon Sep 17 00:00:00 2001
From: Kairui Song <kasong@tencent.com>
Date: Wed, 2 Sep 2026 17:50:55 +0800
Subject: [PATCH 2/6] mm/mglru: introduce helpers for manipulating gen and refs
 flags

Instead of doing bit ops on folio->flags.f, introduce helpers for
adjusting a folio's refs and generation info, making the code easier
to debug and understand.

No functional change is intended: some combined atomic operations are
split into two, which only creates harmless transient states. There is
no measurable performance impact, and some paths even look slightly
better in the generated assembly.

Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 include/linux/mm_inline.h | 84 +++++++++++++++++++++++++++++++++++----
 include/linux/mmzone.h    |  1 +
 mm/folio.c                | 19 +++++----
 mm/vmscan.c               | 60 ++++++++++++++++------------
 4 files changed, 122 insertions(+), 42 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 621c8653d8f7..3f4bd5b02b54 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -142,10 +142,66 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
 	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
 }
 
-static inline int folio_lru_refs(const struct folio *folio)
+/**
+ * lru_set_gen_flags - Set the LRU generation number to specified folio flags.
+ * @flags: pointer to the folio flags
+ * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
+ */
+static inline void lru_set_gen_flags(unsigned long *flags, int gen)
+{
+	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
+	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS || gen < 0);
+	/* Store gen offset by 1, zero means the folio is off-list. */
+	*flags &= ~LRU_GEN_MASK;
+	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
+}
+
+/**
+ * lru_get_gen_flags - Return the LRU generation number from folio flags.
+ * @flags: folio flags
+ *
+ * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
+ * -1 if the flags indicate the folio is off the list (e.g., isolated).
+ */
+static inline int lru_get_gen_flags(unsigned long flags)
 {
-	unsigned long flags = READ_ONCE(folio->flags.f);
+	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
+	/* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison */
+	VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
+	return gen;
+}
+
+/**
+ * lru_set_refs_flags - Set the LRU referenced count to folio flags.
+ * @flags: pointer to the folio flags
+ * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
+ *
+ * For MGLRU, PG_referenced holds the first ref, and the extra bits hold the
+ * remaining refs. For classical LRU the extra bits are not used, so it can
+ * also be seen as the refs count never exceeds 1. In both cases, refs == 1
+ * means PG_referenced is set and the extra bits are zero, and refs == 0 means
+ * PG_referenced and the extra bits are all unset.
+ */
+static inline void lru_set_refs_flags(unsigned long *flags, unsigned int refs)
+{
+	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
+	BUILD_BUG_ON(LRU_REFS_MAX != (LRU_REFS_MASK >> LRU_REFS_PGOFF) + 1);
+
+	*flags &= ~LRU_REFS_FLAGS;
+	if (!refs)
+		return;
+	*flags |= (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF));
+}
+
+/**
+ * lru_get_refs_flags - Return LRU referenced / access count from folio flags.
+ * @flags: folio flags
+ *
+ * Reads the LRU referenced count set by lru_set_refs_flags().
+ */
+static inline int lru_get_refs_flags(unsigned long flags)
+{
 	if (!(flags & BIT(PG_referenced)))
 		return 0;
 	/*
@@ -155,11 +211,24 @@ static inline int folio_lru_refs(const struct folio *folio)
 	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
 }
 
-static inline int folio_lru_gen(const struct folio *folio)
+static inline int folio_lru_refs(const struct folio *folio)
 {
-	unsigned long flags = READ_ONCE(folio->flags.f);
+	return lru_get_refs_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+}
+
+static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
+{
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+
+	do {
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, refs);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
 
-	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+static inline int folio_lru_gen(const struct folio *folio)
+{
+	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
 }
 
 static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
@@ -270,7 +339,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
-	set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
+	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
 	/* for folio_rotate_reclaimable() */
@@ -295,7 +364,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 	/* for folio_migrate_flags() */
 	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
-	flags = set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
+	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
@@ -339,7 +408,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
-
 }
 #endif /* CONFIG_LRU_GEN */
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 84e237f2c17d..775d6279dfea 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -500,6 +500,7 @@ enum lruvec_flags {
 
 #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
 #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
+#define LRU_REFS_MAX		BIT(LRU_REFS_WIDTH)
 
 /*
  * For folios accessed multiple times through file descriptors,
diff --git a/mm/folio.c b/mm/folio.c
index c02dcea9c03c..fb874fe492b2 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -353,26 +353,28 @@ static void __lru_cache_activate_folio(struct folio *folio)
 
 static void lru_gen_inc_refs(struct folio *folio)
 {
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+	int refs;
 
 	if (folio_test_unevictable(folio))
 		return;
 
 	/* see the comment on LRU_REFS_FLAGS */
-	if (!folio_test_referenced(folio)) {
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+	if (!folio_lru_refs(folio)) {
+		folio_set_lru_refs(folio, 1);
 		return;
 	}
 
 	do {
-		if ((old_flags & LRU_REFS_MASK) == LRU_REFS_MASK) {
+		new_flags = old_flags;
+		refs = lru_get_refs_flags(old_flags);
+		if (refs == LRU_REFS_MAX) {
 			if (!folio_test_workingset(folio))
 				folio_set_workingset(folio);
 			return;
 		}
-
-		new_flags = old_flags + BIT(LRU_REFS_PGOFF);
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_refs_flags(&new_flags, refs + 1);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
 static bool lru_gen_clear_refs(struct folio *folio)
@@ -384,7 +386,8 @@ static bool lru_gen_clear_refs(struct folio *folio)
 	if (gen < 0)
 		return true;
 
-	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
+	folio_set_lru_refs(folio, 0);
+	folio_clear_workingset(folio);
 
 	rcu_read_lock();
 	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bf2786c7247d..71adf4bf5074 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -863,19 +863,22 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
 		/* Activate file-backed executable folios after first usage. */
 		if (is_exec_file_folio(folio, vma_flags)) {
-			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
+			folio_set_workingset(folio);
+			folio_set_lru_refs(folio, 0);
 			return true;
 		}
 
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+		folio_set_lru_refs(folio, 1);
 		return false;
 	}
 
 	/* Promote on second access */
-	if (folio_lru_refs(folio) > 1)
-		set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
-	else
+	if (folio_lru_refs(folio) > 1) {
+		folio_set_workingset(folio);
+		folio_set_lru_refs(folio, 0);
+	} else {
 		folio_mark_accessed(folio);
+	}
 	return true;
 }
 #else
@@ -3291,11 +3294,10 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma_flags)
+static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
 {
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
-
-	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+	int old_gen;
 
 	/*
 	 * See the comment on LRU_REFS_FLAGS, and activate file-backed
@@ -3304,31 +3306,34 @@ static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma
 	 */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio) &&
 	    !is_exec_file_folio(folio, vma_flags)) {
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+		folio_set_lru_refs(folio, 1);
 		return -1;
 	}
 
 	do {
+		old_gen = lru_get_gen_flags(old_flags);
+		new_flags = old_flags;
+
 		/* lru_gen_del_folio() has isolated this page? */
-		if (!(old_flags & LRU_GEN_MASK))
-			return -1;
+		if (old_gen < 0)
+			break;
 
-		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
-		new_flags |= ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_workingset);
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_gen_flags(&new_flags, new_gen);
+		lru_set_refs_flags(&new_flags, 0);
+		new_flags |= BIT(PG_workingset);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
-	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+	return old_gen;
 }
 
 static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 {
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 	int new_gen;
 
-	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
-
 	do {
-		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+		new_gen = lru_get_gen_flags(old_flags);
+
 		/* folio_update_gen() has promoted this page? */
 		if (new_gen >= 0 && new_gen != old_gen) {
 			if (increased)
@@ -3336,11 +3341,12 @@ static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 			return new_gen;
 		}
 
+		new_flags = old_flags;
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
 
-		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
-		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_gen_flags(&new_flags, new_gen);
+		lru_set_refs_flags(&new_flags, 0);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	if (increased)
 		*increased = true;
@@ -4785,7 +4791,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
+		folio_set_lru_refs(folio, 0);
 
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
@@ -5017,8 +5023,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		}
 
 		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
-			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
+		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
+			folio_set_lru_refs(folio, 0);
+			folio_set_active(folio);
+		}
 	}
 
 	move_folios_to_lru(&list);
-- 
2.39.3 (Apple Git-146)


>
> Thanks.

