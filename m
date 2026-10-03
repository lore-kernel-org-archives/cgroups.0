Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5709432BD9;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791032118; cv=none; b=RDe7cMFlzv0S/+MnlP2WkjyFRxGsQCHItaMtWd+7dfVbqCOOV4/ZPTcwm3FPoLhLY7Y4+y0GIVj1U5gcUi9NuZhHaQQUzB8GGkIQdzP87IUBHjVZwEB7HvfYwuOVit32fXNDV9LbTEX1R2WSIDS9xcbcX7PBYmiUIisIlpFVEyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791032118; c=relaxed/simple;
	bh=IJdbSdqfzsSly2joDn3fNhJSn8tjPPt0T36DegRwlxc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DnbQthyagPS0XswDaNO5XO8RcxlHgOdVHD/afH8NYU6KuscfmWoiiTivhe5c4HGKmkv1k/kQ0I1SR4zQGU/GPl95rjFPyp11anve83ox/xj96CuERqxi/Ao9UXuEviXEMzr9hyVmTfE0DHPdKfkR/hcJi0vdXY7dVdzmdEK5WRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJSITcYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJSITcYm"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87A6CC2BCF4;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=IJdbSdqfzsSly2joDn3fNhJSn8tjPPt0T36DegRwlxc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CJSITcYmlzgykRDtHoAMMc9rvneeMX7Im+KmUYQ+KUoIKQdI7buDMt3flwHzciOWs
	 62DN/OYaQA9N1gbFxM5wP/iIEgsK9yyfmU1cDE6g/k7QRBOXUOI/kpz6M+2sYpmrGw
	 7NVlnCURXwXh2nun9VuOVh23cQI5B9zhAZyCIiLM3RMYnjr+iHdt8PrPx2ccSvT7Il
	 mE3WbvcTbgpM8qreHKUxO5+TkqMN5XkJhJ6yOyp82qUVbnM9BtBnQ69ttfongn8SK1
	 ipBXiAO/QfSEeaFlFXrYfc5U1o2/5FjH0nKSczAk8yDy2R8/b2UwYX/43XO3eHu924
	 RZW6HAvC90Njg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF12CA5FEC;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:25 +0800
Subject: [PATCH RFC v3 14/17] mm/mglru: reparent folios from all
 generations
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-14-cbd4546a5bd9@tencent.com>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
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
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=1313;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=SSFKxw+1JpTaEsw62vhOq7gyElbyAMh0m4zwnBqF5GM=;
 b=q/9LD6c8gvmYPxhU9rc4D78+Qn6i7gyt4FS5TgMbJyWibJ6FDwhn5CpOgRWjUSFIXWaya3eLk
 IpKqXPrIu6BBt4SlTOlR8kUzCIcqRDOVwI9FL2gt71dDdlXy/BvzPBn
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
index 9cc06a95d931..1bc8e5056265 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4947,7 +4947,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 	child_lrugen = &child_lruvec->lrugen;
 	parent_lrugen = &parent_lruvec->lrugen;
 
-	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
+	/* Lockless promotion may leave folios outside the child's window */
+	for (i = 0; i < MAX_NR_GENS; i++) {
 		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
 		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 

-- 
2.55.0


