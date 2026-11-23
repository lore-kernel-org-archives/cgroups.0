Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460025;
	b=OpHWn+c94K8hje0+s2IYcD5FxDaUDzy4kfqQl0EhZT6BaiId9Mt+/BxUQi6M9gltftwq
	 mReIz6QxmVrQJv7FD6lZIUOrXKB40/JV7A5dQo+ghNjL8WSalhmmj3l/zgUh53C7Skro5
	 8K2pFkWzqwnyqQ47Jw3q0mpCrcyCeDu5RdlT0dNmoXpNR/+wc9mwGkNQyKFx0pae4zAEp
	 AjVgAwRWhBU3j8A7sSYherOWIrYqWsiGSFgSGslOiGzZbKgl+buR3uMUSkwCA/X/9psAW
	 2YFSkFGNa3PbpLyJLXlR4c01sLtrtvnSbHb7eR8Hc72VVPSEN9KFs7IiHaO3tbO8p1w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460025;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=S0g05G9qZGx4poDmgO7lZ71KlplbuRcjeb30J2se0iw=;
	b=ZRfcf2q1Q+wuI4hCHzWqq9x/PlmTsDFyd5enLrlL7ppKMah7fthjdKHYiigI81VCH+Gb
	 lIqc52sIIfB1ZcWeidn0YoDBy4Reck+g3cPSfVX8TV2QH3uGpRoVDsAu7NZRFU890UPkG
	 LGkHuNzlyjyUqix2NupD5jkpo78IypjEoGHnK7yJpz/+3gMWEx9wtVhR2OkPOuonCZq5g
	 qRrEGGwRTXBU46A+KtZlBVudl+M0TcwBI3s0myatIPafkptNzoYDs/lAeM/w+ndtZdeDC
	 EAIXP/9aRvzQEr5YRA1sOA11xX7KVhvurOIGddxq5/Qf8Kt2t71cD6dqu53VmxauSgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ic4UV9yU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0078606A688;
	Mon, 23 Nov 2026 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ic4UV9yU
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460025;
	b=2hVQywA1agQxG0dEmU0KZ2ymnjnbKFAAGdu6xNGnT4JvVK2oSgi//uIrV4qmLrFmf6zS
	 YEl39KOl4oWkFKot+Yy9J+hXvpA7b3IMpimJSs6CCJZEtpoI2rPuAi5vv35DPGaVjXiFy
	 dtnRDlOKzkKllmwRIUz2PgIWnU5ivSAWgKo8Aab+VnCn9LSNyPzVfe1Huz0lFW/QMLLvY
	 U+caSwIAzGQVcT8LLUnrG7POlz5bRN42uD05PSsoAlo7fKlalzJ0aP1jymgS31JWxZ22A
	 zDaip5eRZuZNGvO/1Ux1YVmlDI1u5+5XJlh70OzDBAgfwXeYIuXmpVoHesLURW72bhQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460025;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=S0g05G9qZGx4poDmgO7lZ71KlplbuRcjeb30J2se0iw=;
	b=f4Gl74scEwgguJWfuT5Rq/VeNez08ryCTsQD/fVwoxIt+ve7T5Nik7xIHKxEouLeZ+pA
	 2lgSUOWs8ngGJAq8MnZKrtweHZEHYstEdFLOTy1VcwdOJdjtqgppqDj8kcsLMAAgOq9Bc
	 9QejczBBMJ9Q4D8kNlojQW4Ua9Iw6NMHERe7qbwJ11UWwMmdkhP0hzZCc3Jcj7mURM1/M
	 Imuk5doQvlU30duGA1LwnaLOKkC4aC3vWZ8VEF/C8b5KjJ6K0OlrGWC92HeDTJVl2QmIk
	 ww19jS+iW+Q77D+dMibTJYXQoZ+w5mIHgEKWlsGLJObO8e+bp8aaV3w1M9h6P2gs+SQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0E59D1F00A3D;
	Mon, 23 Nov 2026 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460025;
	bh=S0g05G9qZGx4poDmgO7lZ71KlplbuRcjeb30J2se0iw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ic4UV9yU19MeLMIiiMuY6S798cUREJRPPSFF4KS0TTw9oD0KaRico3mAsQU2BjTPu
	 LP8bkcWRVM7zsGaQzV9mCay09xkmh2t6/AkhUm/wqvc/OQQhhBjiuw4Jb35rCOeJ5M
	 1xGYJFa0bgtm1gS/hA+02aYR7zJ9mpVxVo4EVdmi1Z2XAj2r6tNBG9xBPJwpUTTl1N
	 1VBqnpvMOa5qstAnO6qfesIxSetuILWmDF6wWDZAew8csQ7yVbQxxBWnpY5/3b0mM+
	 Ky7Q7jwCk+CDVVFpccmj2m299B5jtzTevNvdx3pq7Yr1Tm3OS4mAqZNwlq4RfAPrtf
	 ZFHINYD7H92YQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9B9F14C65D;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:05 +0800
Subject: [PATCH v6 13/18] mm/khugepaged: convert to LRU refs based
 operations for MGLRU
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
Message-Id: <20261124-mglru-fg-v6-13-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=1410;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ylGSrEczLifu/DdmhwMoGhk6njBmtr2EJO7xuMx10kQ=;
 b=pXXLUep3I/vltYX0L1UH0GTTRjdiy0b3iBc9jWcCRdtT3cKw00OaEvGBk3uaweRY+TaoRFVrh
 ZG6rFxHmKKzBv05zdRFuW60YLUnIX7HDic9FG8ptG6NTl5y6QM0dqWa
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
count, so folios with nonzero even refs no longer have the bit set.
folio_pte_referenced() testing the raw bit misses hot folios at
refs 2, 4 or 6, under-counting the referenced folios of a candidate range
and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.

Test the refs count directly when MGLRU is enabled, mirroring the
smaps conversion.  The classical LRU keeps the plain bit test.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2dc4245814df..5e768481ac22 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -579,7 +579,9 @@ static bool folio_pte_referenced(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
 	/* The folio was referenced previously ... */
-	if (folio_test_young(folio) || folio_test_referenced(folio))
+	if (folio_test_young(folio))
+		return true;
+	if (folio_check_lru_refs(folio))
 		return true;
 	/* ... or the PTE mapping was recently used */
 	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);

-- 
2.56.1


