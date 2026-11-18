Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795035826;
	b=dKO4/F0k/ON/mK6oFOdNowB3tblWm2PoxMPp/+b/M2Xt5Ri4sIj6vj00uL622xVOts/q
	 kSrRF+QogOx6BIQ9rABq36qhrh+XRw2EADRJxJsG5U/sRZtyNpLeYwYAkFvHA1qmbxo+y
	 scY9ul+JYvKuqTxur3MaxNQcecwPLq/BJc2QqWT845SUmrek4l9rD+ivH6cgrJ/vWAIGr
	 qGojKIfIkjYGR1sCNFgKLxH7/gtEN/KckuwUEUEYWg7goCTowlzepsyZlxoFb7xQAWAoT
	 19kK36q5fp/XimzJiqrF4CQx2sumDGvA7xoUUlLW0Cgv+7wvlOnma3S4iCljy3C09CQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035826;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=Y6mYfGolJS6nXYyvKPDyCfBdq4QUzDPuKkF7vPXmNoQ=;
	b=d+5Q5gJXAmxPMjF0IE8KH+t2U8RI2lBmmzqulDPau+k0m4ts59E1/aunIQg6gV0X8eIC
	 XWsmBQ2KUblwFmPUDaEjFjYj1YZZ5qFmvwpUQ3IuezQGosINGmS1huw+Q4QUtFelO/+ed
	 ggj+k/leGAEhlU3F1lhtE4Omj3i77Z6w6h17vdLqfp3chOoUzD2lzuGNqtp3HhLii5FqG
	 Uc8+lvVJkhdXw/Ez244zeERtdH6daqhI/cs3Mg4WqLvIXhH/dJw3EPD0AOXfdR71znEXC
	 AOT3R37mVjhmBAAByCcHtxcRRcRY6L2UePnyNEQj87TukvXEbvcfZReN2IvF8ZSOCOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nZpgHUGb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D27606A33B;
	Wed, 18 Nov 2026 21:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nZpgHUGb
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035826;
	b=yLxHjO1Btb/uJjk00tUMB3U2gk2+VVsq8sJ+KrQt4ADzCWQspnNMtVYn4M18WT7ytMt5
	 uA8Cl2FnT91aAqA4RkHuz3gFkXiB/CxzxrwH3t43YGkVuvmaLj/xS7QbfWDzgF6wUXTEk
	 aNuyVuoQdDz1yJrd8t7QUDNups120QOMlKDrZUPm+TKT6sEv8HC0ivDZvDoHEPE5sjr9d
	 RWi67uzMmW5O5WnT+n/ZzSvz5k0crfriponTqGZ037zFP90gob++jHW9wSW84wOTRjXtt
	 sU3AczsH/S/mCnNbiO38H+4OlzMNfQNBFARSMkbtpRszIBcfRU1PsKsLEWu02+0gFWA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035826;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=Y6mYfGolJS6nXYyvKPDyCfBdq4QUzDPuKkF7vPXmNoQ=;
	b=K0SNUKghj1TwNLwdTfJ4BBdZb0TB7QKwE0PYs+EStbefC719+7x20c6hqQlOXlMFZCH5
	 APPQdxiRO9VqdoACRsAEvp6kLJz+torXXe0RJ/U0KhuiWek0Kq3QdFXt9XA0900pedTGa
	 00wlZkmM9KKXe6S/B7Xr6RasIr6MY19YRkbTFpRJeNjro6DVdR+fiM7YXXuJH2OBtKbcQ
	 hd5Na4h9c2h9pX3l1rf5jllxZ96yVf3wTkp+34dGv/p719StqCBp95M24W8uvFLHC15s1
	 1nsltViZsEOMwLl2e4dIT1YTMijhfP0QMDoTOeX2x99bkcmZKWbXg1z6RT4GmxIyDbg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A42331F000D0;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035826;
	bh=Y6mYfGolJS6nXYyvKPDyCfBdq4QUzDPuKkF7vPXmNoQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=nZpgHUGb2YZutFzEdxfDMtOoWT1hcEfl3ZduEVBD2FmfGGfD6fkLBWF7txYv3iiFx
	 QMri3jhUFUMManurakID0+LFfREGHX2VywFrQyNknn0tScSB2hf2Qw44p0BazS7sUa
	 N9Uu+I24r3M6mKtyodeXjuBojJEPADGpPWu9hViG1SLVFZ5/z93XhCYN2R1X1He1Sg
	 h/EA4JjBbuVjNtth+uft9NvOyPbbXgSyCHsZIA5VvszswiIzSw+A8eiFZ6KVj19Qrb
	 JNstNslG+La1b//VdeLbrkZdjtxmETvJjbzM+3stFZDtBkydinRsNk9wro++GWCBsH
	 QGXsSjwO96MEA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 210B44AF82;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:33 +0800
Subject: [PATCH v5 01/17] mm/mglru: rename the generation offset in
 lru_gen_folio_seq()
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035819; l=2264;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=YwqZ+e/q+Bs63p0EPa3WlWInx++BICs4SMMeFTRMo0I=;
 b=YvPtmtaQbA6mZdFgjxoUMC6rb+7OWEf9+nliTpL4Bc3GKxUs5kNL45/RuGmCxmFZJQAo4W4WX
 afdUPeF417PBvcgFY+BnlE6WnpX3DQAkM2rk4mvWkE7Pq6SQWm5jzs8
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Ridong Chen <chenridong@xiaomi.com>

lru_gen_folio_seq() computes how many generations below max_seq a folio
should be added to, but stores it in a variable named "gen". Elsewhere in
MGLRU "gen" means an index into lrugen->folios[], i.e. seq % MAX_NR_GENS,
so reusing the name for a relative offset is confusing.

Rename it to "age", which matches what the value means: the newest
generation is age 1, and a larger age is an older generation.

No functional change.

[kasong: dropped the comment table part, the series rewrites it]
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index f6f4bc9a704f..2395ca8ee305 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -302,7 +302,7 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 					      const struct folio *folio,
 					      bool reclaiming)
 {
-	int gen;
+	int age;
 	int type = folio_is_file_lru(folio);
 	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
@@ -319,17 +319,17 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
 	 */
 	if (folio_test_active(folio))
-		gen = MIN_NR_GENS - folio_test_workingset(folio);
+		age = MIN_NR_GENS - folio_test_workingset(folio);
 	else if (reclaiming)
-		gen = MAX_NR_GENS;
+		age = MAX_NR_GENS;
 	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
 		 (folio_test_reclaim(folio) &&
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
-		gen = MIN_NR_GENS;
+		age = MIN_NR_GENS;
 	else
-		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
+		age = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
 
-	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
+	return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
 static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,

-- 
2.56.1


