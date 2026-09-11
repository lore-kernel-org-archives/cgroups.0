Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C125245D935;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789127110; cv=none; b=dO2pz44TWtvn1YaWu7ynTlXzxPx60R+GRWsURlHfeEYSZT2bwUjF2G2KHWtye1WkLCr2kH5FCGAaC3nUYNp0X5sYJPssWiHik/3s51rF4joSbLE2pC+DJ/QbtlWm1Zg9lyS3wEyy4r3XIns5ftPmupvIGcxLCWZuJV8I26+QhA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789127110; c=relaxed/simple;
	bh=DfCUe025uIKtclHTHshGr+EQA5lUG9lK0Ak1YmmZ3yI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CoFHHBWQbzzPxTYOrQJTygC/i1YWNWax8ByctUgnDWTgGoeV0bvppa/oCTd3GCku7rhRcl8IxDisXi9ND8CEK5hJ1BZGsvZgsl5/NiT1ZkhbmZW9PcYkogwZ45QiPFInKbYa4qomFxByfg9qnt2Mb0px33yG8C2rJRtVRoMjHPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vOeFyNE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vOeFyNE/"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DFC5C2BCF5;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=DfCUe025uIKtclHTHshGr+EQA5lUG9lK0Ak1YmmZ3yI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=vOeFyNE/3umDOaMHwnBTe60c1eORoeQLfYq3cHxJ23YmqK8+9U0Muzn1hBttfepC8
	 GEH76gKvFKT8E5c400ONJ0hz6ts4cN5/4sId9CPz8aB3fyLesZEupyTuto1qkmr4a+
	 QhO3QgiJcgDmMarn04/hGOyq4FA0eru2AesyXQkk3juIfjC6KUypHc3HS387xSyta0
	 C964ATFvyLCcJ9zyAYK4WPOzrc7EqZNKubhZskLgXh3bI69+4/GzdIr8Vp4DJS8l/3
	 n27kh3pW2rOstGNo+V7b1icVPAUhjA6Fvxx6xPj5B/0ZXzVwOV2xIs+MjJ5bYrMibx
	 WcR3AGXjOdzsA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A10FC88E58;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:13 +0800
Subject: [PATCH RFC v2 10/15] mm/damon: convert to LRU refs based
 operations
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-10-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=1029;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=bcXldTPRhQXaWP3mxZJ2ezjk1cc+Ox0W+LQc8aNOz8c=;
 b=do1F4divk/7w2Elskq/IjnlxGlD0GvPCpGcO1NxNx128hC5/j7AU69z6BO05EBV0r14XpdFLF
 hEo32isNyfKBA1akJ+lhRl/ob9TCe+kfwahhgsT2XTfHRCJu2kj/T8I
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

damon_pa_pageout() cleared PG_referenced directly, which under MGLRU
may corrupts the folio's refs count in later commits. That flag is now
bit 0 of the count (LRU_REFS_FLAGS).

Reset the count instead under MGLRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/damon/paddr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 79195026b903..38d3ff7019e3 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -280,7 +280,14 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		folio_clear_referenced(folio);
+		/*
+		 * DAMON only gets here for regions it measured as cold,
+		 * so the hotness can be, and better be dropped.
+		 */
+		if (lru_gen_enabled())
+			folio_set_lru_refs(folio, 0);
+		else
+			folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
 		if (!folio_isolate_lru(folio))
 			goto put_folio;

-- 
2.55.0


