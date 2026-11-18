Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795035840;
	b=pID8znCh3hiibGF3vdmeu79mDe5U8LGzbdkP8xuSIo0MgWYpa3287ddE1YEISHcNXbos
	 ji7SPDOPIF71TIL53GFVW5PBwefx3+rmoEZbU8PubgDHa2WEGcvh9aUd40oOybrzKu2Hv
	 RSC8Z6QV2/sRiv++hdInuO0nIB5VA/n7KdIxFxlA/Gofd2Chk4HM2e5XzI1U3Etyjx8qD
	 0MUMotaBzjYG3C6Gj+E9kJkrP05t7+XRNv9GnqMKhiAybo/sFDrqD8ZhU7pvddDLMNpYi
	 Lm0142y9qG+A/DUrXbEQe4E/WXH0Q7KQVhA5tUsM6e3YG7WPyW5b9yxkOoacDHHl5Gw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035840;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=umd+xXOtPmpwln7D0djKUtVYi865RTVPW3Jw9yIwv+I=;
	b=WINDglF0frMrbGw9+q1UsVb79ssc4uZxTMhSWcXnCGDDIDJJU+E+ivJJCRW+U0p/wARz
	 PLpKmADsHd4xQzOzuYg73vyDHGTL/CN6J03dL4O5QDoxaFghmX8WTgR1Etq1lyqYoYpHY
	 stzGTdzCoRvXh7vjjWkhkMgD8pIX4utBS5DYWjPn28FkFtjaduCLLfSmC1bIuoN/KwBx4
	 k8Fp3ufnBMjgWYWe6Oz1CozMzlOsZqGMqeiWi1v0IZ8KC5sEJOJwPUpNqQnCz4tliaAt3
	 0buFTqbWX3AdH/s7oMM8hUP+RiBAq8gCfvwtZVRTSY1e1SrT0AQne/CPzC/QAVGJXuA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="IlOt8/qH";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECA0606CB52;
	Wed, 18 Nov 2026 21:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IlOt8/qH
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035840;
	b=dS7pPnfypK8Ei6Tly3N+lQRq0r2FYKWhjS/TM6N1z5OZihg50btIJvatVUn8DY9wTkqv
	 /r2QIGJlfPp8XgrvUiTrCU6GbwCXVj+8vOD+b/wb3Ldy5+wzOt+mUVXhhW74PZJx91uIY
	 ohEFFkqLDM695hKD0nKLVFp7/UfjBeOkSHAiFLGB3MrX+gXyiKMlsF9jnuSkE48hxshlD
	 RxjaeuJq7Rer58cdW1JIjt0uWA1uizqWb1blP1wulRoYtedSaC+Zh/42GOptHaW2m93Mk
	 GppGE5T2psBCS4rDSejHrvjo0M+R4QlOTjZ9BoYMtp0dlGwnJ/imjH+RthCLqQaH2ng==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035840;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=umd+xXOtPmpwln7D0djKUtVYi865RTVPW3Jw9yIwv+I=;
	b=xGagCxkHeY4X/o82V3nUNzvq7oS0Tuqiz+s8B8m5w3FohDr1Gi1/WB5LZXfG1iIw6ieH
	 wvXorFfExJ7uZ/MuTrnJPkDHrkBtFmz5I86eAMaiuP6PN/ct8BDhIzbf/EtTcAE90EnzB
	 EpFgg+eFQIpVqAHKm5PhweLOxelVNPnLPkETjLs/ID8EYIt21e8EaFnMfkc/6nPefCXYA
	 Ys+gI/t4XSe2YIDm+WvvILXh+XohLNZuGnQ5c0v6ubnw+r9hDsJdAO7qMhYuwKjcK88NT
	 QcUeMZsON/iOtrHnaktEtgHd+4GP7jMIxYDZ4pv1boEOuSYDRNIEAzk8uNmmM0s7+eA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5B8071F0093E;
	Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035840;
	bh=umd+xXOtPmpwln7D0djKUtVYi865RTVPW3Jw9yIwv+I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=IlOt8/qHTTE1yeQHLPyAY5nfE4pdbip6wRKgOE/IYC+rL0gbltUUHYzslnMOl6VqI
	 fUJO8CnbKqojy9/pd30BW9lbXoQ1U50g8/Q8rTflFI8sUzzsrlJzsQnJwijSC1HHlv
	 Q9BcdlCrBvXogspV+h8DGCZJkdrkrwFvY8t4doiPwvhkc8qMnNvYsJw+YzqYAkxsMb
	 QAHcMva6lmfTM97CsVnFqAoJWnALX0Q8vmivrTDcetLv28nQObWGruUfvwekAhQBk4
	 kihpEmnxoYzSsAShYCgOb0hg3rwHx/IDp8OfOCTSFRaTo2oHZmWpcvWZiSCAwOTQnE
	 a809bbEHofIig==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3B3B04AFB0;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:43 +0800
Subject: [PATCH v5 11/17] mm/damon: convert to LRU refs based operations
 for MGLRU
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
Message-Id: <20261119-mglru-fg-v5-11-9eee2fe97a2d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=914;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=juJQDvh6WPvm4O7BAbP0QPsVPdfMcO7QrejsQWUOq68=;
 b=4R6elM1NZFwkimFZRIG8TAjoSqNylkU4BwWWediOGKFcIWwn5tKSC/YO+Fj18DbSAz4kMZPeo
 2b4D2jz24raDp7tNJsjjsSvda7DyWgkAgvzBwtc53YRgbzeEiQFCSXC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

damon_pa_pageout() cleared PG_referenced directly, which under MGLRU
corrupts the folio's refs count. That flag is now
bit 0 of the count (LRU_REFS_FLAGS).

Reset the count instead under MGLRU.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/damon/paddr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index e89cb14ee17b..411e1d557ba3 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -279,7 +279,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		folio_clear_referenced(folio);
+		/* The region is cold, better drop the hotness info. */
+		folio_clear_lru_refs(folio);
 		folio_test_clear_young(folio);
 		if (!folio_isolate_lru(folio))
 			goto put_folio;

-- 
2.56.1


