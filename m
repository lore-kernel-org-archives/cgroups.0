Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460015;
	b=CI2EXAxEGfzItRfHV89fKyAjlTZDrS+82StNKBV/1yuaK5hIQDmfukSORNGftoLVx9PD
	 33U/EF9sYR1E06sygao7OAauPPF2T5RryfKzIZImKe771N6VBt8NSRXb1HtHan0iVebM+
	 Ovt3ZJsXvt9eSeVsIS9Rp/7kfHubimEAAi5+aAUo9nW50RTVevcfo6kFCVjfglMHj75tQ
	 O/hfGRJxhuLSlDNfQUNktZc4kQGhGgtS8MtvQf/NzJcqQKv57LM2ule9CNt+3E6Gw8i2T
	 HD/v7W83SEl1Pnw+02/rMgStpCqb9/aIkCLvKsUrPPtn2p+/mbXcnESPtwMnVlM/0bw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460015;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=qPY6Gpk1GxeXHfsNbxjcPs+9GQpLxPguF+KSpyU0BSA=;
	b=Mu//PEHc3oSikhMg/PFHD6B+QHeCOQZyTZU4FuDES2tMbSxK5gVVwPbZRfrXnTb9e6vo
	 pV0VFwn4qt891ljM+j6f0IEiVpgNrJXKz+hpccQyXeHlBI14kLLNeEp9crS8wTH0t0jYy
	 oFr2OHuV8KWQUi4lEZ1acmwgRDixgJqRw/FE/91ubRu+uZNl2X7mS1tnRRMZDnxtxXVti
	 CgHCKtbaXCuisrgz13xQvahkwcQcjqvslg47nazMte3tckf2NI4jDKPvBwjVdjwPcf3gd
	 RsLhYBAiASr+S7PYC6mMwFG+oq6Lnmbl4FWIJ6HRd6M7oCH+dnwYWcfcpCunFZLI2rQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oaYagua1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4081606A687;
	Mon, 23 Nov 2026 18:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oaYagua1
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460014;
	b=teJzzcnnBi2t4vXM0jfMZGj2/53zzEi8eChdL8czxgK+GhIgqyyacwWzKF5ncc0jVMHg
	 67XGSQtAdJPQx8nblHQF05rTCJPErvMhjhDu6OzPC6nV8q6V0w8u10dwfnf3kHpzMFHL6
	 hlHBNkdaV/WiIrZxG9ivSHSj51/3Fcx/SM/kzQQWI6dh/VDej01AhRtfc7JfnOAy6yRm8
	 L85afhPm3sApO3wGixOQMzpVCPzQQL+BuGFs48qZ1riYxxvXpqZHccYpgdNOvA9Lf3zSR
	 jKh9kaf/OVUseKP2YH65+2haORO45ajLYpi25f9RMFUKsGK51o/PC6iHSKB6L6/hy2g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460014;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=qPY6Gpk1GxeXHfsNbxjcPs+9GQpLxPguF+KSpyU0BSA=;
	b=yOX3Q+N9ThgmNTXp85EKDTsGXFyBNjSbotncMMmVBNe6u0qGWpr9KX55HdxLIeS9Csco
	 61odxqceje9ez2J5VAQulqViklJNj//c0WatILZYT+qqm/RX2qJNcB8ykz09wa0C50cLk
	 fxcUEtu8aJOyuvf9wD4driOjxq2nJBnByL4VsGY+hLkhCH4CJeDR07DJ1SLMqQ0gqijXu
	 Buk/ke0VR10B9xHfjhT1zs14dUdU7xHimobiRV9m3w9PYXbhKUCmvv3bZEuWdo64XM/Q1
	 7VbgZXCO4RaOIKjtQJ/LThnQsTT7fQv3BzVWabd5EirfAXEGTtxd2XxRarY3TRi97ZA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7E5531F01566;
	Mon, 23 Nov 2026 18:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460014;
	bh=qPY6Gpk1GxeXHfsNbxjcPs+9GQpLxPguF+KSpyU0BSA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=oaYagua1ueuIU09SpzMk7Ekb46Ym2rdWFTkD0tVVNT2lFLW2IdKsG8v+39WgjICpX
	 5oz2wNqu1mKBmCWOxARlrKjBb88GwIO/wGtRe0QrhoyzDlIeOMtegVjPUh+SrHMQDL
	 8BuAplqbtWy4fOHUkwnjFmdKs70sSgKa/H7JtPrQIzB+qx0mbdu7b3DHxLgefw4yi3
	 EqL9CY6CDxvHyYlMerugvfBD6jgVXSxKaVIhw4P2lyVOUr/I8u1uHGfdsD/LPPXsd1
	 2KrEtbd+/UnRSh0jLQma28CEFVvo3fkzVtZ5M+lM9k0hdU+GwnENnyZEGLpMFYGRFK
	 k6aPpj872ajHw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 471CE4C651;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:02 +0800
Subject: [PATCH v6 10/18] mm/mglru, gup: mark folios referenced via a fast
 helper
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
Message-Id: <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=5455;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=EDvLpnxrpVD1Kfz+v/3OI17Dk6Yj7fBAiXtjWEmtcfY=;
 b=n7lufqexladK34F/awLOMu/YkEQJxZMmTJft2kkPNiKhixsNSlw2tnT0Eri4RZ4Nl8hmLaSz7
 plNCLhLOSEeDefNIfoeK4sf8RYsnkDXloTqw6+THIDruqVfCyK7ORqH
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
classical LRU as before. No counter update or promotion is needed,
nonzero MGLRU refs are left unchanged.

The classical path is taken for a folio that is off the gen lists while
MGLRU is off, not on lru_gen_enabled() alone: while MGLRU is being
turned off, a folio can still be on a gen list after the static key
flips, and setting PG_referenced there would bump its refs count.

That check uses lru_get_gen_flags(), so move the helper out of the
CONFIG_LRU_GEN block, it is now built with the option off, where
LRU_GEN_WIDTH is 0 and LRU_GEN_MASK is zero. Keep the decoded value in
an int so the subtraction of the offset-by-one encoding cannot fold to
ULONG_MAX before it happens to avoid -Woverflow error with CONFIG_WERROR.

This helper only aims to be fast, it exists so the gup fast path can
stay a fast path. The new helper doesn't account for refs above
LRU_REFS_REFERENCED but that's fine for now as GUP never used that
or anything similar for CLRU either.

Convert the gup fast-path sites. No behavior change for classical LRU,
no regression for MGLRU either. Just prepare for the following changes
by providing a helper that follows the new convention.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 62 +++++++++++++++++++++++++++++++++++------------
 mm/gup.c                  |  6 ++---
 2 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index b15c3618a1f2..13c8b6bce349 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -105,6 +105,22 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
 	return lru;
 }
 
+/**
+ * lru_get_gen_flags - Return the LRU generation number from folio flags.
+ * @flags: folio flags
+ *
+ * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
+ * -1 if the flags indicate the folio is off the list (e.g., isolated).
+ */
+static inline int lru_get_gen_flags(unsigned long flags)
+{
+	int gen = (int)((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
+
+	/* The gen is stored offset by one, so zero means off-list */
+	VM_WARN_ON_ONCE(gen > MAX_NR_GENS);
+	return gen - 1;
+}
+
 #ifdef CONFIG_LRU_GEN
 
 static inline bool lru_gen_switching(void)
@@ -168,22 +184,6 @@ static inline void lru_set_gen_flags(unsigned long *flags, int gen)
 	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
 }
 
-/**
- * lru_get_gen_flags - Return the LRU generation number from folio flags.
- * @flags: folio flags
- *
- * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
- * -1 if the flags indicate the folio is off the list (e.g., isolated).
- */
-static inline int lru_get_gen_flags(unsigned long flags)
-{
-	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
-
-	/* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison */
-	VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
-	return gen;
-}
-
 static inline int folio_lru_gen(const struct folio *folio)
 {
 	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
@@ -483,6 +483,36 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 }
 #endif /* CONFIG_LRU_GEN */
 
+/**
+ * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
+ * @folio: the folio
+ *
+ * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
+ * untouched. For a folio off the gen lists with MGLRU off, a plain
+ * PG_referenced set.
+ */
+static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
+{
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+	unsigned int refs;
+
+	do {
+		refs = lru_get_refs_flags(old_flags);
+		if (lru_get_gen_flags(old_flags) < 0 && !lru_gen_enabled()) {
+			/* For CLRU, just do folio_set_referenced() */
+			if (refs & LRU_REFS_REFERENCED)
+				break;
+			refs |= LRU_REFS_REFERENCED;
+		} else {
+			if (refs)
+				break;
+			refs = LRU_REFS_REFERENCED;
+		}
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, refs);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 7605da0e06d8..da04bebfff43 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2921,7 +2921,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
-		folio_set_referenced(folio);
+		folio_inc_lru_refs_fast(folio);
 		pages[nr_pages] = page;
 		nr_pages++;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
@@ -2990,7 +2990,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 
@@ -3032,7 +3032,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 

-- 
2.56.1


