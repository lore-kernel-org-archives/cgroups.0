Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795035839;
	b=dQoraOI+MNvPQXr8uIfw9Pf4t2VQ51vb6v/8jLa4nY0nvzmiDpWPI8d64RmPAuWNFcHm
	 0k9pWHR7Fd3PQv0fodEAyuyYB0MFmUyY3MOl3E65QTtlZAKgaeGx1HLlbtGvwdaRMEt0T
	 KY8UICT6yIdaVz4J8oTIWaAZ05QS3ujBgwtOdTUMCVTVCTXjNowZSBP0Un3mMD1nh6LEd
	 wPQWUxduKzqo+YjXcPYNKcf1/Dsw8R7bgT7/XxhGPrdXT0Azhz23UptV0oyZc/J0IxtQF
	 l+Hf3KavQrXPz+tjr5WEBkKwRvo5YNlGmZEiUkMIyId9ThRNakWxLZ57OkUfTs/yRLQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035839;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ONH2sHHf2Xx9VeVmwI9oduV7d2UyMRNg4DFB5U1VYOc=;
	b=zkn2BKQ0+LiW6XWregVZl6AGxJ3gttLhDawBRhXquQ9/rsebUGB1XCP1WFOdJzjmQFcx
	 ywx0IiE2sjHfgRV2PiG4zaHsM3HAXEBb+VFwL2P0vFTreGYfdPI/8O0jKB8OV4vuHzMPN
	 kO846VfMTcaKj+5fcSGcm8II4heaFwKwI995iKLMAnx0lRbmQgRr7QmaywRpQwHCnPPM9
	 xc2a5qZlAur9FYOFHIdUOZN+Uv0KTcfHgMHMbhjUb8WvKQSI42D3xofzrrQDhekkFNG0D
	 UOrVtuDZczMqVFmmFd0dgWwOUntTpvaKeMnxt9dhA7DPqZB2voIgELrilEML/tdcG8g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBuS+n0h;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1BC60A6F6F;
	Wed, 18 Nov 2026 21:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBuS+n0h
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035839;
	b=R3736D0mTYhnxN3STet4CxlBb1oVB2aQJpAPyllrrEDsPCvms4sLoxyyuwWWmW/XYGxA
	 rHwPZKdG1cELFiOE8WoJR+YyxEbNh/qGlPJCcxCtY6iGFMNlv92VuSbjnrnd9tvWbNaQC
	 elnMh5cFO2oxno+s55040Ifxz8gNhlOm4qCnbh+HVp4y3z3Up8gQQVB1PNBf8pRAZvnSW
	 vqkVJkkokd7grNyRVYp88A8Z8VBlCWnoHzV49CuCTJiGbesuyzybouNWzs0OLE3JnieIT
	 fpGSaVGy6u68FwYYcGvG5qG6M2fnBff8PmPupyUHyaY5hxlpU/95/+TGv1MOJWB+jQA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035839;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ONH2sHHf2Xx9VeVmwI9oduV7d2UyMRNg4DFB5U1VYOc=;
	b=vP3M+8wqPZtdXkm/DC4rWu/Hz5bV9j/u5htAvbgZKmZPTa1viv8j1nuA6BWCvl9Q9VoR
	 KyZHvQ3rLGhJVP/cDwhIJPqqel9/3ysg6hq5v5akm4t3l0FX7yU2qVvmJ9H4imlHL5eeC
	 sY/TNkJEwgiGPCJU7r9Yw7uhLlqFpXQN9DcRX561K7M0tFLpT53YdAERGrrJ24Rip5igP
	 ef4vuDseg3rB6+4e6kZ/AbnE9py5MO7GukLhsQjZC7IGrx50BEXOYZ0xbH5cgd7/KpwTg
	 rdWG/yOvDJfPiKn0r6vJw72MLfNHy61oIMc0DPdSYPleRUs9vbLndFXpYf6TYZ02UAA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EF9BB1F0093B;
	Wed, 18 Nov 2026 21:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035839;
	bh=ONH2sHHf2Xx9VeVmwI9oduV7d2UyMRNg4DFB5U1VYOc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZBuS+n0h4MI5jt8kzRw7TO4Mw4fPt7K7MROObHqk6DM4fWYWNWsxsKl59xyL0LXRN
	 1d5bxjaFKkocr/I1Oxh/5+fpLH38laQLBTKFoaA5Z/4VOw+8uKQxQaPCc8rdlnXBGi
	 jrJ3uNapQu6olKYmDt20M89CKl7nQa0p73lC4OnvdN5jmkUiYCrVhirYXqotM0dfs9
	 HNG5PFoIQWHbYevKaE4DZFaIUdBS6pgd4su0uZI69JOC/HGjQEvBinvDZrwOI1nQbd
	 xvlyAUVRBmylzu5hUSIRRZ8g6VtbG9MD2M+TPhxecOPV76ipx/VQ9EeLLTdE46xnV1
	 c2pnRzwoclX4g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B5FBE4AFC3;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:48 +0800
Subject: [PATCH v5 16/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
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
Message-Id: <20261119-mglru-fg-v5-16-9eee2fe97a2d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=8035;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=g1GkBdhJvxJt7NdeT6aWl+AFEruhMo1F7vyeEAqTuvc=;
 b=AQEk8zbfMo0ltdb7spakjmZOyW1tsFBfIMyIAUItHbQtMG5kTXs1h0JAVh7XEGTl2bTCcpwWQ
 sHBftlYw9E5B3fer5EamGLHsVWX0l9LV0T0FG80uYEJYKmrvgOogq2V
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

The lruvec spinlock in folio_inc_lru_refs was only taken to keep
concurrent aging from corrupting the size counters.  This is no
longer needed: the per-generation counters are atomic, and the
active/inactive ABI counters are updated per folio and linearized by
the CAS on the folio flags, so concurrent aging can no longer corrupt
them.  The same argument is what lets folio_reset_lru_refs() update
the counters without the lruvec lock.

Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
read lock around the lruvec lookup, and drop the spinlock entirely.

Without the lock, aging can advance max_seq while a promotion is in
flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
flags can return to the value read earlier and the cmpxchg succeeds
with a target gen computed from a stale max_seq.  Recheck max_seq after
a gen-changing cmpxchg: if it moved, account the committed update and
retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
The retry may count the access twice, which is acceptable and avoids
folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
orders the flags read, including the one returned by a failed
cmpxchg(), before the max_seq read.

Also simplify the post-CAS accounting guards: gen is only assigned
non-negative values after the old_gen < 0 early exit, so gen != old_gen
implies gen >= 0, and lru_gen_update_size() needs no explicit guard.
The active/inactive ABI update keeps its gen >= 0 check because an
off-LRU folio has no lruvec to update.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 10 +++++-----
 include/linux/mmzone.h    |  3 ++-
 mm/vmscan.c               | 51 +++++++++++++++++++++++++++++------------------
 3 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 77f514143266..2c6cbd0df686 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -317,10 +317,9 @@ static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int gen)
 	       gen == lru_gen_from_seq(min_seq + 1);
 }
 
-static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *folio,
-				       int old_gen, int new_gen)
+static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
+				       struct folio *folio, int old_gen, int new_gen)
 {
-	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -399,7 +398,7 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	/* use the refs from the atomic snapshot to avoid raced update */
 	refs = lru_get_refs_flags(flags);
 
-	lru_gen_update_size(lruvec, folio, -1, gen);
+	lru_gen_update_size(lruvec, type, folio, -1, gen);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, delta);
@@ -429,6 +428,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	unsigned long flags;
 	unsigned int refs;
 	int gen;
+	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
@@ -452,7 +452,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
 		folio_set_active(folio);
 
-	lru_gen_update_size(lruvec, folio, gen, -1);
+	lru_gen_update_size(lruvec, type, folio, gen, -1);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, -delta);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2680e15b6de9..235fb04f8d78 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -540,9 +540,10 @@ enum lruvec_flags {
 #define LRU_TIER_MIN		0U
 #define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
 
-/* Access source flags for folio_inc_lru_refs() */
+/* Flags for folio_inc_lru_refs() */
 #define LRU_REF_MAPPED		0x1U
 #define LRU_REF_EXEC		0x2U
+#define LRU_REF_FORCE		0x4U
 
 #define LRU_REFS_REFERENCED	0x1
 #define LRU_REFS_WORKINGSET	0x2
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 78a1b4de7076..4576a7a369e3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -876,37 +876,35 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
 	long nr_pages = folio_nr_pages(folio);
 	struct lru_gen_folio *lrugen;
 	struct lruvec *lruvec = NULL;
+	bool aged = false;
 
+retry:
 	old_flags = READ_ONCE(*folio_flags(folio, 0));
 	do {
 		new_flags = old_flags;
 		old_gen = lru_get_gen_flags(old_flags);
 		old_refs = lru_get_refs_flags(old_flags);
-		file = folio_flags_is_file_lru(&old_flags);
 		refs = old_refs + 1;
 		gen = old_gen;
+		file = folio_flags_is_file_lru(&old_flags);
 		if (old_gen < 0)
 			goto out;
-		/*
-		 * Lock the lruvec if the folio is on-list. We are already
-		 * doing lazy promotion so in theory we don't need this,
-		 * but for now, concurrent aging would still corrupt the
-		 * size counters.  This is a temporary limitation and
-		 * will be lifted very soon, so the lock here is not a
-		 * performance concern.
-		 */
 		if (!lruvec) {
-			lruvec = lruvec_live_lock_irq(folio_lruvec(folio));
+			lruvec = folio_lruvec_live_get(folio);
 			lrugen = &lruvec->lrugen;
 		}
+		/*
+		 * Read the flags before max_seq, paired with the store of a
+		 * gen, which samples max_seq first.
+		 */
+		smp_rmb();
 		max_seq = READ_ONCE(lrugen->max_seq);
 		max_gen = lru_gen_from_seq(max_seq);
 		if (old_gen == max_gen)
 			goto out;
-
-		if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
-			/* Promote second page table access or executable */
-			if (refs > LRU_REFS_REFERENCED || flags & LRU_REF_EXEC)
+		if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_FORCE)) {
+			if (lru_refs_is_workingset(refs) ||
+			    flags & (LRU_REF_EXEC | LRU_REF_FORCE))
 				gen = max_gen;
 			/* First access only defers eviction of an old generation */
 			else if (lru_gen_is_old(lruvec, file, old_gen))
@@ -931,9 +929,19 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
 			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
-	if (gen != old_gen)
-		lru_gen_update_size(lruvec, folio, old_gen, gen);
-	if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && old_gen >= 0) {
+	if (gen != old_gen) {
+		/*
+		 * Gen-index reuse can fool cmpxchg(). Retry locklessly, accepting
+		 * an extra reference to avoid folio_activate() latency.
+		 */
+		if (unlikely(READ_ONCE(lrugen->max_seq) != max_seq)) {
+			flags = LRU_REF_FORCE;
+			aged = true;
+		}
+		lru_gen_update_size(lruvec, file, folio, old_gen, gen);
+	}
+
+	if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && gen >= 0) {
 		enum lru_list lru = file * LRU_INACTIVE_FILE;
 
 		__update_lru_size(lruvec, lru + lru_refs_is_active(old_refs),
@@ -941,8 +949,12 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
 		__update_lru_size(lruvec, lru + lru_refs_is_active(refs),
 				  folio_zonenum(folio), nr_pages);
 	}
+	if (aged) {
+		aged = false;
+		goto retry;
+	}
 	if (lruvec)
-		lruvec_unlock_irq(lruvec);
+		folio_lruvec_live_put(lruvec);
 }
 
 /*
@@ -3517,12 +3529,13 @@ static int __folio_inc_gen(struct lruvec *lruvec, struct folio *folio,
 /* protect pages selected by the tier PID controller */
 static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, int old_gen)
 {
+	int type = folio_is_file_lru(folio);
 	int new_gen;
 	bool gen_increased;
 
 	new_gen = __folio_inc_gen(lruvec, folio, old_gen, &gen_increased);
 	if (gen_increased)
-		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+		lru_gen_update_size(lruvec, type, folio, old_gen, new_gen);
 
 	return new_gen;
 }

-- 
2.56.1


