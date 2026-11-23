Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460031;
	b=rVrensBLlTe0/vk9TJlWfVai9aDAVkYH6eqAGYOvH1vgetj2F+WV+DydK1AJJqBZOCyq
	 UVSIQVejVF001bU54C0tIlw4jtPdb5MltqC/+2UenN+NWWVO4CGxpV9gR92YKu2Lllwbj
	 IVvoMJp0Tp4KHeyW0BHZUB6iO2JJOi8EWnXftpGx5f23A3eHbjTfAd9bkLIIyou8oBMvn
	 kHt2sxxI3eOtJ3p+1ZkzLnLlzLI8onICTLAzE4pU/Tj63/DqopJNq80R91I/ZQuIoXFne
	 nDqqC1ppqLBpsZDo1d49qJcF6dezhhG+UkHs9onp+TnJrWv7edTdJfXJqLRRx1nYtEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460031;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DzT/xUc8ZCEsmES1lvYoTZAcG/yg9FkH/3wyr37nKM0=;
	b=sBevy9e3kPuzKJykRRTGD5aA6q2xepS5DKlH+gdp0woDcFF8ISmWC35ZeIQczxz1ox95
	 gpwjNO6eYzJld8WRvkCaNEiEGlX24OyyL1m8lvKIXCnRmle2yzYECz12j5SQvsPzqlokD
	 x/VYaqAXl3o7YbjbXNR8BtnTWgFjFuso96/2/rFlLEwghDs3mS/zDb9KtwjGDhu/2i2QF
	 3QOnceJuBv/JmWTSHQ2Ho76LUfsb23K84qMTNEMKk5tKqiIYiy6TiCR6+EzHpGc4r6K+n
	 HkkuzHby+bdA8FCT/+QTmdLhuCumAGO2SfQcpaqKnCnpaL0TFvNQ0OSKcSWkMpf0BYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="C/v5q04U";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84604606A33E;
	Mon, 23 Nov 2026 18:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C/v5q04U
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460031;
	b=hVSj1WuV1HleJnZTMJDXKGbaiyL4qR6C5Qh878MX2metAr7Mj4tdHPzMymSXoBzrieTG
	 OonAwXAINeynVNPlKBw0YIcJQnEYaHqtR/80zGWTdIGgpLOxbx/vJTfKwG148yHTQvZY7
	 ZQZOOwFnjhWp89yMscO6Z7qGNLGfvrA5DMdsuYMihK1B0I2TqBbJvbeMKXBtP5so/O0Rn
	 DUsDnGPnz/WWvILUa+EpA4xnG93qqaHcuR942bc9LZiz8SjBTUB4IcRHl6DFY1uGZCOy6
	 +Opvz1Xu9EY9T8DCj+JyQdRBBlZXa+QT0CLy1VreT7zkoVzGg9VzjSwlbvdAVf9NnxA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460031;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DzT/xUc8ZCEsmES1lvYoTZAcG/yg9FkH/3wyr37nKM0=;
	b=b7BFueW5SP6Tg5HWYmKhYrmLQNe9byH19XF+gdqcwpUWqs84q32VRQwuP/xCWl5pwM0V
	 2+trSAfULZBHYwH6UvF8I8xgk+cW56+krjt1AVsqUa0LOjTDWFT6zU0Cmf8GQ83Om1/Ui
	 NgzjrHHjk+cvfsJzw6hPfpf/XqKEYDexLvneFi+XPUQISmK2nCAnG42+W887d8+IqqCMt
	 /gvfqUIGyoycP7RmvBRzt7/66Y3ZDAbgFEXOwW4TUPC1cZg8voFG6MWKm5TpiVr1UN5Dc
	 qokg/zz3EI1JYw8x0qJAYRLTcBUl3bANHbLvSOWlAz+G79/NoP5k1VoI4VaU9o0vYVw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 701EE1F000C4;
	Mon, 23 Nov 2026 18:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460031;
	bh=DzT/xUc8ZCEsmES1lvYoTZAcG/yg9FkH/3wyr37nKM0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=C/v5q04U8/3ug6jVO2zWIZfehF5Nj1RdJsGEvyuCOgL9vJxLHvUijCPkVw864qYzw
	 cRyiAKxrjve1QLZBXM8gn7pbQW67pzuRgrznNOfQGOdXMimEohj7T0DxHu8a3LqmGM
	 ZiQe/LAS6bABw0fppZcsbzm4z39TcQcbRea0yhn866KgUKd5BZzpPh63EBbbCYXIFD
	 Y/qkj+Q1uvXBu7jHbeH20oFGaVqYG+p2u06oOv8y5MAm6yPJyi7DoiraIiWMa5fcRk
	 gzxezQxLXYXIikV5/MVtH6tWOXvc1FAZdmNDTQRwxgfLFllVyW+nOkkjSiuT2ktXKv
	 KdQavuoffQCtA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3ACFA4C671;
	Mon, 23 Nov 2026 18:53:02 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:10 +0800
Subject: [PATCH v6 18/18] mm/mglru: make folio_inc_lru_refs lruvec lockless
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
Message-Id: <20261124-mglru-fg-v6-18-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
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
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=8138;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=98177vt1OglL82gztUX/EbOw0UvOi4GjiFKgTcy/MHo=;
 b=lBjYmotb+ySa2fIWkROeOCyMpcTaqydsJhwBMvXZJ4Uy1RPDLNQjk8vOBroK1JvAny2eG5OzE
 r+CJ+hmVAgqBKWNO6Lw8XYQN07RofDMXRn5buGju896Qbd0+UHf79zD
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

Tested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 10 +++++-----
 include/linux/mmzone.h    |  3 ++-
 mm/vmscan.c               | 51 +++++++++++++++++++++++++++++------------------
 3 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index b0f062e3a190..36b80a2a0e74 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -335,10 +335,9 @@ static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int gen)
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
@@ -417,7 +416,7 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	/* use the refs from the atomic snapshot to avoid raced update */
 	refs = lru_get_refs_flags(flags);
 
-	lru_gen_update_size(lruvec, folio, -1, gen);
+	lru_gen_update_size(lruvec, type, folio, -1, gen);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, delta);
@@ -447,6 +446,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	unsigned long flags;
 	unsigned int refs;
 	int gen;
+	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
@@ -470,7 +470,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
 		folio_set_active(folio);
 
-	lru_gen_update_size(lruvec, folio, gen, -1);
+	lru_gen_update_size(lruvec, type, folio, gen, -1);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, -delta);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 42afb5375c27..14c58bbd1606 100644
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
index ccf3497bd3a4..81797b71228f 100644
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
 
 /**
@@ -3527,12 +3539,13 @@ static int __folio_inc_gen(struct lruvec *lruvec, struct folio *folio,
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


