Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795035832;
	b=1k/W4gIYfat7dpUUM3zm4cqdiZSuKep+98gP+lbqIp3Zshn0xpmZ6grfBsZRVnDPBcUJ
	 EmzwolAoGRK7FwaNxq+zBuzkTIHiPU6Q4DXB9CaJtRP8PpQ5TAsXPg2ZSrNQdPtdIbXHk
	 Jg2wAoujwdj9MU5KO8Ff9wh6/YRNXMqaScVJQInuNhdRQvmftvkMmnsUQ4QeiUSDgAkIy
	 f34d/H4zefaSHeUhcOFC+4UxYRMny3S2eNYmYO/Aa7kymZJXfkXZxcipN8e3XG3us47s3
	 9C6Z7Lf8ZBwNbJvWNjgNPTUjnAgQgvyIg4BUWWzvCox48DobaUUyQ23tuShtjKFDmVg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035832;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=LrlGQLEEtnfHmiKobaFWc1jYAzCVcr+GQMXlFd622xo=;
	b=PdSBBe9XljzFVTH+6LK/McXLh7oZPsQKPxkMG9EJdIdxPSQZiK/I4AK6V9huZXYVIuIF
	 fuYIfPa1m3JAEtKzDajsnGmmTNuuMHctlsSzMmJ1F0qBKaogqyl3aDCSOtwpHufQPmBUj
	 7pJc6y3ld5KTJUho8CASzaw5Wj+Dm+wmQYiaEPAaimXTbPp0v/062IyRMPR+6QIEmIadW
	 9dCZrW+UqZz8IClUiG19TjcUMr9MMRiGuwT6lJWR0jMAp4h0jTEdN69zTr4UyrJmDc7xC
	 XF3/DtNTH0xHqhnVVvIXsaqwgL+TJcBBjJyOVPAJst4cSL/fgZMWnVl2cF5uwLN1nHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RkTRpXIK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD3960A2610;
	Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RkTRpXIK
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035832;
	b=pG5OrW/uBZPXBqseyekgDSkMGdZvx7XGXwugu7CQ4Wa/w8kjaMt2KtS/VGm23QsKmAsF
	 mneILvdN/1Ay6/6lpk+yHCFHWuySGQxPDBrUg47g//YJhsRm6+W44uTHiONwhy/aYmwHG
	 wSP0xPbl8jGbQ/TpgJgrbRGuo4cEApnycE3Yv/Yea2c9WOaZtbIlg2xDvWgwgO44geQWn
	 cF68iCIPcqLyIsyCqotSus5TgaSS9KV1ffQpePFdu8sBJ0rNb18oRZ/D5FM4WfFeMz8xv
	 TNm1HdJOcGM+joGar2fvBaRDsDuFAqWae10gXFUS8ykofZe94LkxsGWOyk4Vxd1Tdyw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035832;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=LrlGQLEEtnfHmiKobaFWc1jYAzCVcr+GQMXlFd622xo=;
	b=N0ftSeoSXn4C5+mKL7toZ8UMA0yBtV7qT18vb2PogSaw7e6lGu79bNmJvhGPk2v9FDXm
	 w2knGF6r8R5eOxyArkrfRxKrE4lx/bGaOGyoGcI0YG3+6IGjj95mde/EMNRkGZNb1pRzZ
	 lz2gT+ClipKkf1S/Fbvo4yHYiO4Cs05bCY2ILzGpMW+OAasuQuxmebTtFA+qIpWTjZiN8
	 bwyQ+6qj5bTfnn16DUX0DygRxOq7wP0Ea2r5YWZ0nIaKarSd87DE0SuWFu4fI7iLoXSH7
	 U+NaINEUXmOFskp80WQ5I8WvUtSMlUvohCzBEY89VZqbyLN8hAkyS5na+p8fBlmaV/g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 45AFB1F0092F;
	Wed, 18 Nov 2026 21:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035832;
	bh=LrlGQLEEtnfHmiKobaFWc1jYAzCVcr+GQMXlFd622xo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=RkTRpXIKFYkatCJ6QCZCJ57rn6+nPncX6VLQlHGkYdM9zmSOoD3h5WoMKZnl04wwH
	 Z9iv9ZrcQv9NZeV5JLmqhc8JViRXXxDU+mAMU7wlN9wcHNtAhtSUXYfQYm7X2GZ0Y4
	 sWkfcQJ63EDfGXWH9y2zoM/lqkMrAcLZJ6ttyJZcoShig6Bg2UR+iUhYGCrjkhVNxw
	 f/s06KPFga7nfmV5RKxd3F6sCuwuBnXfGBhrf6KWRC/7o1QehKpM6o/VzoIaqvKscl
	 OGQtWa8WCJ2gows51Z6AD26c5CQW2fSICSJP4jXfl129jqjTbT7CTWKeC2/B3b9aP2
	 b6Pe6HpFdADJA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0801E4AFA8;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:41 +0800
Subject: [PATCH v5 09/17] mm/mglru, gup: mark folios referenced via a fast
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
Message-Id: <20261119-mglru-fg-v5-9-9eee2fe97a2d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=2914;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=aPuSORUuSGb6n/3Hg5v3XmLoMlSfc/wD/Eg7ayRbx9Q=;
 b=mVjH56jPWf+UzjInxmZy/kp7O4dv1XnzWnKS+bF0j0IGWoAWH0R5LwmaXMcMGUyzWt6KLBOP8
 z48pHs21UafDLh+OKHavVo75L7jSb1isIoBYLuM8ZJ5b8C9AkCuLktY
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
nonzero refs are left unchanged.

This helper only aims to be fast, it exists so the gup fast path can
stay a fast path. The new helper doesn't account refs above
LRU_REFS_REFERENCED but that's fine for now as GUP never used that
or anything similar for CLRU either.

Convert the gup fast-path sites. No behavior change for classical LRU.
There isn't any regression for MGLRU either.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 25 +++++++++++++++++++++++++
 mm/gup.c                  |  6 +++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index b15c3618a1f2..3323a3c7336b 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -483,6 +483,31 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 }
 #endif /* CONFIG_LRU_GEN */
 
+/**
+ * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
+ * @folio: the folio
+ *
+ * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
+ * untouched. For the classical LRU, a plain PG_referenced set.
+ */
+static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
+{
+	unsigned long new_flags, old_flags;
+
+	if (!lru_gen_enabled()) {
+		folio_set_referenced(folio);
+		return;
+	}
+
+	old_flags = READ_ONCE(*folio_flags(folio, 0));
+	do {
+		if (lru_get_refs_flags(old_flags))
+			break;
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, LRU_REFS_REFERENCED);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 2b405cce2ca5..596e62954659 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2911,7 +2911,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
-		folio_set_referenced(folio);
+		folio_inc_lru_refs_fast(folio);
 		pages[nr_pages] = page;
 		nr_pages++;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
@@ -2980,7 +2980,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 
@@ -3022,7 +3022,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 

-- 
2.56.1


