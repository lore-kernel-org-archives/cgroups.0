Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460015;
	b=3wme9w5GLmWya32tSjo4wLa/wKOG21enlPbSGtO9hptgj5h1fQ0RzoTEABfPqDoWWJ4N
	 SkOlcINrZY7v8j+14poTKaNcOnaiyxFAiQgF7L9aJ5y4r8V1z7YyKaxDKVfCaf6p0mnEA
	 ND91Pt/JCi2trnlO1zUJo+ChvvxDPDA08UFXdgaPFBFItw7WaLKJDxIx59J0ZFzFBYyEC
	 wo4AeDdkNUR/TIxKUse+5qDzZlOW375h+6GF9RLai37m91FVS2H3G483PnM92NQHRa/DO
	 Jq+BcvixOevaYy2m9VsV5PDBxyLCguFMBIsyw/jhv0Iwm73IQobu8/N+KSe2/PPgYCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460015;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RNY/s9d03b2O9JkaUTE9InrLkFGqrNIrXDiipCDaU1M=;
	b=ekLeCvvAgAVVb/zj0jFKdMYdPYnFbHNlBq+YM3LSoz0SmmIROM6BVeikHB49SoQup5i9
	 pAs4ceEXDHvwFXHfi7K3MGm0JDhVaczJuMbejK2NhT6Q3455NPXZuILlEsA5/aAZg1IoT
	 pu4almeagZ9udUB54GXcGUnCv3DX9JRc6nIo9vJOezQpu8FN1KRX7wmNPTtybendAJIm3
	 B1nRprPqGY0fVKAbIiN1QhtbD+t0jwp+dEnAU/JeNqjBqTHrwycnx3TBefipH+8jJVg7P
	 smawn4pSXHIV+L1920bmkXjur9cPrW2BPRzE1wCIMUS95TqiOhIG4l3BrbxtXqLcLbw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HeSHWslK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BA9606A684;
	Mon, 23 Nov 2026 18:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HeSHWslK
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460014;
	b=wwCHX3jGEleRCtHJ/Qt4lAQ6yRK9wug5dBCSdGkiXoqZ9LwmzkGQrYrTLOpAPQg5h3q5
	 jA+YydmQyd+4eY7hhL/x0CxJhNDqUMrhheN/GrWWjYZWlclQjpnGooEh9dZHEFw0JepEN
	 wgqiswg+kvg5p1zOJNTB17ETuoClPzuRC0Ki+SHdZebkYT5rsTkoF501AwewWMlmdn3cf
	 g6+Laa+huzGww3OE3OcJsx08Ndhjfgq65vcHTh/FvvWJNY+wUzkany9kGiuBdsfseALE5
	 fsYQ+XpO5LfYurv6m3gx34p5C9fhaXS1Ref9/opZc0vKzUxDY9lPKuMnuVZiBOpFCWg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460014;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RNY/s9d03b2O9JkaUTE9InrLkFGqrNIrXDiipCDaU1M=;
	b=Z2pUHQ5jxUUQTPq5MjqdGNY/W+kd/XZIvqBc0sqM2DjuVM6i2NQja+uaLX/V9NRnYiZP
	 gQwz+YhfbWgNV0XOQTz7KdFnNhx8XUyLKA6ry7gQvx7TiuO8NuAUmqS/DS4nNutzkYpm4
	 7MmL7Wzu2bjSwYBnqFw29N87xom/oZEEcsvf9j2blHqchl1zjReci+DU4+QRxu/zJta3S
	 5gqY8Whj2clZMdyyD3CwXi8F7Q0FpLU7ThGpUlGYe09CFKWA5kmTrPfnLOT8QMgWb73SJ
	 afa3vZ1uq7OE02IrgmgmvEVWDk68WSehBhMauletCkalytgoq2k+kcyEp8sPd1dr1gQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AEDC81F000F0;
	Mon, 23 Nov 2026 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460014;
	bh=RNY/s9d03b2O9JkaUTE9InrLkFGqrNIrXDiipCDaU1M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=HeSHWslKwcNQJrvUXhAfACNEoLxqySJCinZ3W2/1DHdLvX/Yx7DBitsIX+3aehawn
	 9+32yaYqbqTr7y0LDLBJ30MBEqrCMpnWNMN7Ucz4ownA9EoKUQrEg5iZL8wOLeMhHI
	 qgrJWxswwZPk2+NNxjJMkvUAKLpNyR0l7FLsO4GF+wPfrQCchXU1kH8mIrlrXxDr7c
	 pkO4V7MWfJ8exNGtkHsDU3IqpVhT92Y4xSkU/9F+Rlic/LKc97Jew55yiUhQHtbyBU
	 CJtiPiuLuy+RO1jc6IMXJRCxg4vYWH4rtY4iYSxUsYOTg6h9pkRCauV77OnCCRQWCx
	 4graAwGIr+kEw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 28BEF4C64D;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:01 +0800
Subject: [PATCH v6 09/18] mm/mglru: move add/del LRU size accounting out of
 lru_gen_update_size()
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
Message-Id: <20261124-mglru-fg-v6-9-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=3303;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=XjHe+HTYVXiCfy5n6y3gV9Xu+nsGkLXvrSZveSG9Y+A=;
 b=6PcLKWJPkD9Wt9zW/Q9V+XxxJuDjPsiQTYZQZ7sdj63T1Q8ux+NwJLNGLG1Ut3i3fZi9bdzti
 /HiciYRGuqEAXfzhybTHfHBrA7MVjcWL0sl4vcUv4YI6NtgyPflAA1h
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

Pure code shuffle, no behavior change.  lru_gen_update_size() now only
updates the per-generation counters plus the promotion move; the
addition and deletion active/inactive accounting move to
lru_gen_add_folio() and lru_gen_del_folio(), which know the generation
and can apply the active-window test directly.

The unevictable case is untouched: unevictable folios never enter
lru_gen_add_folio() and keep being accounted by lruvec_add_folio() as
before.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 180db43c3a85..b15c3618a1f2 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -322,21 +322,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	if (new_gen >= 0)
 		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
 
-	/* addition */
-	if (old_gen < 0) {
-		if (lru_gen_is_active(lruvec, new_gen))
-			lru += LRU_ACTIVE;
-		__update_lru_size(lruvec, lru, zone, delta);
+	/* return now if not a promotion */
+	if (old_gen < 0 || new_gen < 0)
 		return;
-	}
-
-	/* deletion */
-	if (new_gen < 0) {
-		if (lru_gen_is_active(lruvec, old_gen))
-			lru += LRU_ACTIVE;
-		__update_lru_size(lruvec, lru, zone, -delta);
-		return;
-	}
 
 	/* promotion */
 	if (!lru_gen_is_active(lruvec, old_gen) && lru_gen_is_active(lruvec, new_gen)) {
@@ -391,6 +379,8 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) != MAX_NR_GENS);
@@ -408,6 +398,10 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, delta);
+
 	/* for folio_rotate_reclaimable() */
 	if (reclaiming)
 		list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
@@ -432,6 +426,9 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	unsigned long flags;
 	int gen = folio_lru_gen(folio);
+	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
 
 	if (gen < 0)
 		return false;
@@ -445,6 +442,9 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, -delta);
 	list_del(&folio->lru);
 
 	return true;

-- 
2.56.1


