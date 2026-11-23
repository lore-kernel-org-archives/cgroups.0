Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460003;
	b=DoXnCWZ+fDTLw7dd21piln8GdMqJsSxFDRZRQgdGWcvKkIlbs5fZD18+5Y3GzvEjccNc
	 We+ZFv6uD40TFc8sMxZKAX4kkI8D6mNlTVM8cM/UhwHdbMtUf8USmwThwhn3vqSSe9/Td
	 /5n4lfHPaxqZPqNL2c9sqPNgVKnLPqAXN7KQnWIeCq9mQNTQegxmdrs9suSjszs9aKYMf
	 Ms9slqkav8hzy+b8stVku5GCNggY4Tai/eXoE6hJ0dW9mp8+UeIAHALfM+ay5PAJSZggJ
	 /m+2tZvRFw+3e7ewcjhcOkWetAMytMiGoqI4EcvGbiclaO0ftHMfJoFFzU9hFMj7nYw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460003;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=asmN6q2HefJieUr+/zgw0602de6l9KxgRm2+Pk/d8bI=;
	b=0u9xaINXj7BMmDOxZaojon907Z9/O63gnZt12dYozB/GkDsNyZ4jof5kcZvRPkEtvv/3
	 Oj3t/qiSF4xA2KNRg0clzjjF/gSYQyzEkUK3IdpGk7yvaKFseHtYwV4Mt7/KSv2EWYIOA
	 k5cjefQA/l5HWCg1GPAqHmDZ/kLjIBLYrCbnO5jTBefrHpiWR+bghGoK+X33nDoL9rXnV
	 zs7iJgj9fQ6OSHv7/NogHihPfyix3xXPd3OZBuSWudAutgp4RRAZM4/D1HWFBPoVhaZ2L
	 +adKCjm51azV4brUH4wX6Knne7MHN64Al1QxLH6S2G9SQDp1CB3vzqJgA8H4ocRTh2w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JgmGfS2+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1323E606A31F;
	Mon, 23 Nov 2026 18:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JgmGfS2+
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460002;
	b=wvamGluqC1VJF+/tu+O4Fim+yO1VBV6qnb2hooPY3Xrvy/Nm8O3UkGaoxoAxRlffcx0n
	 r5I6hen65bkL/vHenqFzcfH1Y3kMaWAy1IvxM3iBexXlEFbh2MsKwzoaHzXLKspRsH+6K
	 +3MZjf6Qc08T+RPNQisv8kNo2IHaNWFekGrrtBFmGky5PEpdsSkPABBsQ+OrX5wEdLFVM
	 vdegYK6TMZcqv7QaXJvkNC4ScPjSmszKigKDaAitPjHkenEIIMNLpqh2FiWvGT9J7s0i7
	 Jv7XOvzv/CMive01GJ6bS7HS3Mq6Ml7fUgwuITrAKrQEXZZAVuvt1d3GNEecLNmRKaA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460002;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=asmN6q2HefJieUr+/zgw0602de6l9KxgRm2+Pk/d8bI=;
	b=SklfuEek9Me7pHIuqNTj0K6oHXNa1l65gwXiZK3Q86z9Mv0WVwnrUmBiUjh1Nfqm2FW6
	 UXO3HRIwbTPbZbRqom68VEr4mXCYGbCTZabmjyCefdcX2s3KGhwFQ73NXr1Of8VLi/RSd
	 XUDqBWYjWEDySO2HXrPw9Wm7CThQ3hkRmf0WKbeoQR/PCjTzGtPmu4s3D8NL1RIdFOXL7
	 yKZXx1wshnGxk8aiUWHk4ug0Xry5akq4l2gQTiTzEjoXW/7/jgQ50FMpL7hopHbvJ3jJU
	 3XZUKWZXLvdDIPFOJy54TzLrFY8ZMyGgn6cmnx+w6r5KT3hcvQxLMfQpDDJUCSaLRGg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C1F671F000E6;
	Mon, 23 Nov 2026 18:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460002;
	bh=asmN6q2HefJieUr+/zgw0602de6l9KxgRm2+Pk/d8bI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=JgmGfS2+TQqDRmOj5Q1iss+69zogpQKe+CWz6A5MRLf3GGpR4kKKvRRVFuLkE8OpK
	 q6Odfqwail8d5V10tsAX51wKxSkZMlJTF4KLv6qRlk+BqfMAUM0CNmzAIlHt68AbrH
	 agC4mJOp5dnqK81TjdCwJM4Cz6LRATChy6tdU0nlhhCxnahxWGeIlwR+ZiYK02RqOY
	 MQjxQjUcTLFiBhXWbYa2pCB7UOalqVEzSCGOp7xJLDDbZ8e+vm3LKLgy+jrTCZzt23
	 SOytOR0m2zlF3DsQxL754ECoh/QjUMMYC39fMgIsE89OCI+uOXpFAT465Ss94sgMCx
	 5TEzwggcG+mgQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3A66A4C631;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:52:54 +0800
Subject: [PATCH v6 02/18] mm/memcontrol: allow update of LRU statistic
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
Message-Id: <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=1434;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=uwS4fBCD5iPVACjO21QQfl2NP0AqWyZwBPx9Plu/+9U=;
 b=2pyXTqy8HzStaaOCjTzObU1npNvY6ZTpilr+RXfXelh2BoV3pXDzkQDh7YtNKuBinOgbf7HIr
 Mou6SAdaUjTCLlAY7r+pWaP7/QlkLcjr09/iTRLHgrkUcRHYDfXKH4T
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

Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
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


