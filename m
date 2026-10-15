Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD76521207;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792088156; cv=none; b=JbosNwTh33CTXO2DNf7gu3CWDQZueddt4GjRdfmhSrfuOdXJqXZzt1KqzTthORUz+2IkaxozSy5DlUeTKMs+5cZ5QbEWC7MNJgatOudp3N9rq3TCN364+/DRPXJIZ2lPGKyFuxREOR53UlewHhtDb2PSzANquCMxALU3HmieGJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792088156; c=relaxed/simple;
	bh=bRT9KZu8UqdKr2cNHa1Z0K3O61FAuTcx+Pq/huomZeM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fUZFB5iQUsFYNT184uZmNfUHKOYPkxXirVW9GuPn9v9a5x1+FkhaDbWB8fKeygO/NdN9oEKJKAl6OINlqm1WOGlCrYFjeRqMUD7ta9MpmmcjM4Ik8qXw3R/D1QXJIGw5q0/cOJmWT7H8t1Z8pJmkBBuUVUvHwEPUqmxYipLrY0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJzwFHOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJzwFHOT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A1F9C2BCF5;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088156;
	bh=bRT9KZu8UqdKr2cNHa1Z0K3O61FAuTcx+Pq/huomZeM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tJzwFHOT8zBTg8zoFzjOk6Du5AKu/DQQxp4Xq+H0Z9puNGp3isAAG1RYSWsxSZ1Ka
	 /dzmlU8W6x0kQrq5VkrdB/5ZOzEJTPU8LrKOpLVDZ80ZQI+UeYvFDxtswRKxF3SuX6
	 0d0E8ljHQrZvSZPs+dvXnPDjpoEgm+c1x4R43Tb1ayi/6CDnEf2ZGRKRIJ+wXj0eAt
	 D5JvB38Epn6iRspp61XpShT8/Fh1DpOiMDD5+I0kHXi3t+wwuginwYrsGAW6sFOR8b
	 YrejTtStE6doR81Nln2DNTr5WRlqzO8kgl4I7+75inzfeg5/etYlvNlqfawOk6GUqg
	 MD6brIBrPFJqA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BB7CCA467;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:16:03 +0800
Subject: [PATCH v4 14/17] mm/mglru: reparent folios from all generations
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-14-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
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
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=1313;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=pdKvbjCwV47KGicri13lBUDrCkRk2q0xdMVXETA4zbM=;
 b=k/ubaRAqYgu0d5sqic7HAzaAbUulfQUwwP8R/2btRLVmVV9Nfb3namLyzH80c0wrc7heLL/QW
 ogSO2eylyVUAj7poqU5bzgEc3/spqODjrIxSkgSteeV3MFWumHGgPBC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

A lockless promotion racing with aging can reuse a generation index,
see folio_inc_lru_refs().  The retry repairs the folio flags, but
sort_folio() may have already moved the folio to the list of a
generation outside the [min_seq, max_seq] window.

__lru_gen_reparent_memcg() only splices the lists inside the child's
window, so such a folio would be left on a list of the dying memcg.
Splice the lists and move the counters of all MAX_NR_GENS generations
instead.  Those outside the window are empty in the common case.

Assisted-by: LLM
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 617f69c1d9f9..a9c224377234 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4936,7 +4936,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 	child_lrugen = &child_lruvec->lrugen;
 	parent_lrugen = &parent_lruvec->lrugen;
 
-	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
+	/* Lockless promotion may leave folios outside the child's window */
+	for (i = 0; i < MAX_NR_GENS; i++) {
 		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
 		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 

-- 
2.56.0


