Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795035826;
	b=cvILL7xMNHWuH+uO4Akoea1mArZ0Am/2DKbXXAIHicuQQFxAKv7NQhs/cT5Q2qPLNgqO
	 OEM6NxJL+fLKgg4SXf6lHeS/dRxCkPBbPJOD6uwQvLSI5dh4I34rGK3nXiwp0dXy/nGn3
	 z2kOXmkL5AN4WCWs0FculZVbcDDdYPt9Ay7+NipB/xqPI1ABKZV+nYSbLw10z/vVY5lDP
	 goq51ltwZOEr3vAM2aeJr02bqIAQ1wxWSFupMaCL8YZOvHXpghyF2wnzBJuRtVd6jmB5H
	 Vj4LuJiyMLf5SXGmZuUjyJzHOgBwbNjd68xjkNmdkhX6bCEX5Zsu3n/Q3Tz3hViDUZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035826;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Rn/XVV3lJb0TjTij3sIrE+aEoTpSeaOajKlzbk7waNE=;
	b=nyxPdnC7cjs+xm9HLdTV2LPQ14KDLLkroEWg5vaBmXXXTcpGWXfyoodQ2P5SadVckpCy
	 TsLqV1myTM0kvDYpfhh7PyFZZ7Oh9cYrYhxx1kK8d8iYfXe0PA2ty8ptAhmjabRJOVDFC
	 gg99r21TVuWQmBYHhOqL8LQQZ+h/6l+CzsYWpus6r5iwpgF+1kh4R3AZLgO2CONOOcDaX
	 Oas+G1IJVM3j7xzOpUhXVlgIGle3HhcqHUBfrQPTdVvfOURQO4AZO5SIQGVu7GjoqxJur
	 DZi4ZxvrnjTByEoTLq1j4D2UTWXCNPMXhY/5bkOoYuZ00hfYI7WbnXcx0H+IjMFWHxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNFiylac;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB3F606A337;
	Wed, 18 Nov 2026 21:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNFiylac
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035826;
	b=kAyAj9/z9S/tvn/7BDj7BaFbfqFE0Q+yZfVthcSaASNv9gRE7oVCw8uV/2snc0IcCxUc
	 5z4jH7Xi5THxKX1qmGQljO6CQLZ14kfURe9h2rG8c9Re2J2f6o4Jl9S98IaTFeFm9Hl8s
	 nFlrCgxQ6lwC/whBX3YoX3M4GU0S5S3BvzzHt4Kr4ZGIvmd6H8h8KHY3QXp+PC4vh+ZKK
	 tY8/bidpQHl/ZklAK3s1jwoVT7o/xXkX9nAVw+Dt4eWfphaVf+8PKbkiQ/eblW5Cx2FJQ
	 gAJfXYI8eFAu5cCdEbdMF8PsHADls+x83oWGmmj4sUJfolISt8sXmCeOoqxfJZfJ71A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035826;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Rn/XVV3lJb0TjTij3sIrE+aEoTpSeaOajKlzbk7waNE=;
	b=VDrZaYbNNIx5DFYtpkwfkKGSNAkiHoi3ei0oYIVJZifr7tOnAPpzNVqdSGaSnEaBZwDZ
	 dKGE/7AthiLX74VEHsP5s2xkZjniqdPyGEpznTbM5Dy34Q8xeQ4NeAuVej1JxKy2BaHb6
	 0c84TxC1ZNH8xaDkfqdJ6bTQA0RaHpBVnxuOWRojfBDhXhwnp+eFtFfR4nw37fbI4WZ1b
	 OLGEC8u6FTXefAk6t/Ek1zTTx02QKufC8XTo67BX/d3J75AgdDs4eQoiwkrrUqPyu+z5r
	 fm3F7BBFIRLvV1SRz76/nQSOz4DV7WKdkoY/elE8DsfgGdps5bJuaNsu4B2yBmIqYuw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BFE6E1F000D2;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035826;
	bh=Rn/XVV3lJb0TjTij3sIrE+aEoTpSeaOajKlzbk7waNE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=hNFiylacSDkpUO63Z7zELJ42BPJJG6YKdeQb2U+m20Y47uham6njZowSJNic2f+hE
	 PdDwQfVkBxwJDHHNG4i9tL9jYuWjLU1krdGIa0VY5DQaVgA2RVrbh0Rvk234L5+upA
	 M/oa0DWUs8hnFgIaIwVQesv0NjBhj12X8+2zui7EUrhV0+oVdiCO5e087ZJ3lqa74b
	 Od+rPd/bgctjHbe4K9JtXV1ioNIioxqeYR0cXb0Ahg2sqEVeW1G3KBtKumdDiD/nKK
	 OBPF34uvE4dyAVgCJidL1eMZndzNK388I534WFEPpHwsWq/cv3iXamsypaqET7jDGC
	 gmKkOydZVt4fA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 44A1D4AF8C;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:34 +0800
Subject: [PATCH v5 02/17] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
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
Message-Id: <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035819; l=1182;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=G0nnA5K3vgx6DnvgX5PBKRNHiMmd0ZDMM0I+7unVnUs=;
 b=Or384oTYmhezGr12VgUCqXcg3RIjHRi1VIREbML7u8xdTtJvzi8P8v1XYtrkZ/MyxcN22pjLV
 ZU7Emfb4fcGBc4PgU9uzX0rG1VNuzCTFopsvPnTDBNOyD35qOIS9jAr
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

To enable moving file pages in folio_mark_accessed directly and lazily
for MGLRU, allow updating the LRU statistic atomically without holding a
lock. It may cause temporary counter underflow, which should be fine as
the counter is eventually consistent and only serves as an estimate.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 2395ca8ee305..2edb9beef6d3 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -47,12 +47,11 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
 	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
-	__mod_zone_page_state(&pgdat->node_zones[zid],
-				NR_ZONE_LRU_BASE + lru, nr_pages);
+	mod_zone_page_state(&pgdat->node_zones[zid],
+			    NR_ZONE_LRU_BASE + lru, nr_pages);
 }
 
 static __always_inline void update_lru_size(struct lruvec *lruvec,

-- 
2.56.1


