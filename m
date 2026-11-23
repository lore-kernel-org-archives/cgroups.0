Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460019;
	b=SRu82UGy6C6sHV6z5tiDWuQ56QoXKKGry9NdH8vNfjfUnDWiwsBPqooGQYWxSlWE5IkQ
	 PEDLG0vROFzNVknzitdw2sgjNDDOFHzuAnh10ilOvc/YtbGhmbRHOgW/cAWvBagC2PjAV
	 cZVu2Zu+TiU0tFHtZTfjXOVa8PsV5iFfYZmn7iz39jjO74JdtOaI4G267R/Icbop1sbEc
	 gZNgFt1ngqyezL/ZONnta864Y/Fd/y7GZVEeoaX1O/sJXmq8jBFkJji11XERnIf1+b6TM
	 B2kKQ1NF6+LJFywJg4Ta0Ob7eZSSkYP6A5O2m5jdsnTiDSSxzf8PoNGmnxlrZORbjeg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460019;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Fy4iqtyOKVldxfrRoRe9ktEnWMk4sYM46noWj6UrSRw=;
	b=LB7jSQvqaJP5wv3vBHWuExfpIylGUWVN0T9zHNflK0vEwVnvkQJyW4gHcC+N1EPYOIIX
	 qhFey3AVqDoVCXdXGGZ8u/L+vb3/gz17VJw7dEWJZmw66yx4R2f7bwmvz/ZKG51pV/SeD
	 ZfdIex9i8lJ2d6lmDkNbJasym8Mcfpezt157xe06Udv2odOVVM2WB8i4OshWwnfoShNwA
	 2xC816e6fQ1O6plR7UsvHwyt2WFdku0cmj1f2bkk7vC2qP7lxUD7jVsDbC98ITYt7ZLMG
	 ntGdYvofxH/hBzxOLgYQo2mrzvy29bd8RLy4k2Xg4lUgylEsXkLzE/d4oEBlNlpqFrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WRrWw7sz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7005A606A31A;
	Mon, 23 Nov 2026 18:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WRrWw7sz
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460019;
	b=0iK2ae6mopuJ0IoB/G7zte7NK3gse26Y2WQV7aRpnYAxsxQ8Bv3klxUopVe9N+aSu3OT
	 RvHkBDQiItOoHWGvaiRXhpP+Kp8Z77ie9OAHk1kb7yPPF8o90D822weoqyKBEGSonFWB4
	 DvVflKU403l/OOeEh0DnnOBvhfj2co/AK8XIJxQ4lXGSzE0RXbDsnKK3wmrQYzJLMWHBW
	 jNWpXaZlTKxzh3zXyfc/8yIzy+ZofLbmZaCAIbJDCLugmFxG+I1KuDVyW1Bmo2S5bZMhF
	 hlmMRhd4oliQq7/4kbDuLw4kf5FsIHsnP0nvul2KfmHQDJuoGtGOvoEbynjz1bK1Zxw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460019;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Fy4iqtyOKVldxfrRoRe9ktEnWMk4sYM46noWj6UrSRw=;
	b=2wrCtgCZIF3IDoJcQwOChbxVvGnUV8POxBumXTcyRmJngazLsCgsc6vFiC6bCJAKyB8j
	 ptH6Vh6k4N5/mw1hkPSS4ocdGqHlD61ZP+1ZOECFl6zkVm5M1XS1p6iJs0Mt5aUvHHxpu
	 KC3acsha/NRGM3pJdaJUDq8wX+ukkG5UM61HIWHb1KN4EhXaZh3HqfCjXlRME8OTUvask
	 7r7gbqpmXeR1ThWYv6QeCKOEP4NaD30RZLIS2C56D/+l60LTu7YyyPPFEE9xq3P/jC8NA
	 ChyHuOx3cdTCuEIP9U/o8cOiM3KSo6yewHRTvoBHaoy3xogiWWxdJ7RUBcr21fGtcLQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4CC7E1F000EB;
	Mon, 23 Nov 2026 18:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460019;
	bh=Fy4iqtyOKVldxfrRoRe9ktEnWMk4sYM46noWj6UrSRw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=WRrWw7szzQ5c2Ixg9GNxJwZhVJx+JaZdiNuOtn9joRqVcN8lYkXo1sf4whH5Y11DQ
	 L9LYGyAQd7JXLrF2yOSEhFgit2KGTDFznAq/aB478JnncipmyjEpsoi1GyTM09+Gqb
	 WOy4TFOjBq7l9gxry6yT+GTKkHk82RRUJWGeiWM0IeJoE9gAVbbx8oNP/BCBBDCzPS
	 bW7QmzaVCrnAK2A+TYVDhMAj4OuA2JvASNEf857lnNjeoUTKJKcvvbuEcZR3ip+cIz
	 VuiuBwIVfmz52AVxZ3s7sVvtWuFQct6E2oemC9iFtXNvv5ppl74wdNBO7Jx2J/3F1S
	 fBx3hS0rd0JJg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7F6304C659;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:04 +0800
Subject: [PATCH v6 12/18] mm/damon: convert to LRU refs based operations
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
Message-Id: <20261124-mglru-fg-v6-12-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=1016;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ofT3DkXyC3h7ptCQPZjIa/LhrvPGmBU9+3gfY2rFnss=;
 b=o6eHIETcJuwaJUc97SH5F7SQ/kGVMK/yHu942m9yR9l+9EVkcSYS7fRXRI9yRCIPDg6wTwp7x
 /7/d/ERJJiaCtmPfVXmihoibf7n0JZz3OuQL/SSmum1iHaht3PhdLNZ
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
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
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


