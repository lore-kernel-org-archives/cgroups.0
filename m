Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794009553;
	b=JanIOEhcKXl9xJg7a/7WiN3HPKPHkrtdq/Ufarxa+LGomzDL0P0KY8xZo9usJYdNT4ae
	 5OEP3lQCecPnkBoRZm0FIgZp2pqjW+dR7epjLe7h95nuGbfVWDLt69eF77+IOcuc4XD+l
	 O4epaUZYaGN+CMIc7rvXOJ8kmOirT6QrVAozF2IbIUWENlldTG0Jh+aByvOXzrKJif/EV
	 sVllIf4QhqCyKEjE8dXBDYyqqRUzyar8DDEk3F+hyMC7NMSAfRKQHntdRh9/a/e25YpX8
	 ZGdo1vEvDw1Q8sjBliAjjOhX4eUMUSvuG0HuJLH205NdDcYxbVA7r8IsA45WVSXf4GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794009553;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=QLxBnr2dWVF7awuaywn040Wg1Wa6I8q0xUXMqEWtl88=;
	b=zuD5oql/y0yIId11MuAhx1b/nElOMquazdffrSCTxdYXYQHY6h+Hy2fmIvayoG+RxV8w
	 DudhjYLyvpvN8VSEMysUFu+kD9H8nveboek1IzqgSieHbNVtsX9Ou1rKmMvHesiQFxd9g
	 oOraea5JT0whY3poxSpjMKc7wUm+oByL82f81PP3PHpi/kbt947c2dQjTG8etUYkTEeKV
	 JaB9ttFvWmNOaat61TfNL7v5tqIHOSX9EKUsgIOaxp+byVpTZK1AJQuj7brcUW0kAKv85
	 NV1pzhZ+BPw+rbLE8vEqhLAL812LEjZpTchld5OKtLgJVSSwgL4WlCyg3+c0rOtUmsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tjmercier.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OMpqWCP3;
	arc=none smtp.remote-ip=209.85.160.70
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82DA606A326
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 23:59:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D82DA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tjmercier.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OMpqWCP3
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-45e6091d8a1so609709fac.1
        for <cgroups@vger.kernel.org>; Fri, 06 Nov 2026 15:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794009552; x=1794614352; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QLxBnr2dWVF7awuaywn040Wg1Wa6I8q0xUXMqEWtl88=;
        b=OMpqWCP3w2TNWkCpaGDqlfhPWO7GAkSXve+GiumCIEy+wpd8n9eBF0ZdfrQjNkuexF
         gRixkS6t0FqUbM2FyUoEePBUWNxCS7oL6wnv48is0SPAG3aDwgoou0I36MZSMari3V7x
         rtRpPyXLBYy2mXYNv3VZuhjEiywNom6v5ZaIhrUPAl4FgYnZT4SZItLe+vkIxhvxkKYM
         CZn/Pghml7RHbdGLmq6P93YVS57kGfAIZiZ7JCuP7rXpdstHK7IxhJ15p6FTSbLHwkjv
         uMFnW9vCglhhTTWakcpZM0gfC7pPCUhMScxetQKFDT7LIkkruatKFs3c4y24gQjktgwL
         nYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794009552; x=1794614352;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QLxBnr2dWVF7awuaywn040Wg1Wa6I8q0xUXMqEWtl88=;
        b=SCLcapMh4g1PT5S9XCsgxHrMfhgPDXZp5sdgXW13Prow0cbh+AfZ4uo2pTSV2B1jb+
         7K+VKax0Ow4CT3IJBCfyaIoEOZ+UZbP1ZQvt3GBz/gSYqu3uI+QtzUFWMVXsQHoNuZOn
         6RCI3P6FLSJwJyDsQS54EXlEGzr+QgpR02W+p6d1/9Vnni+D3UcuG2brDNdLlrL3rmce
         oj11ZAyLKMiVMoeOy3dSZpAIRnk4u+ceQQZn5Ldtt27nEDDtHulK/hNTod4XhF1vHfZG
         BtyyLzUjILgSgVQ0zMFypXUGj/WsSZgL0gE4R2nMBjg0j98iGznDj1vKI2XgcQIIQtOB
         87eA==
X-Forwarded-Encrypted: i=1; AKwUvByxDgKCexLlorUL54Pox9nCRTjbN//2Bu2l2GdScbrsAvxNT0I92u9LTUvDVEusJaaeKRlSSYpa@vger.kernel.org
X-Gm-Message-State: APuU4Z8QDhzRJHEq82r+V1L9ne7A7ngUDKS7eq3TQqT6vWG128idORpI
	SL0U/uJTgEhrNifelvOPlZCbIWwfgr9/Z99wPvGsfT9H8CQq1nlNuREuksAPVN+Dteiobcrj652
	FUNc8UgLXFEYyFAiTww==
X-Received: from iokk25-n1.prod.google.com ([2002:a05:6602:8319:10b0:9c4:de2b:c40f])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1985:b0:55c:8ee:a9c4 with SMTP id 5614622812f47-567e115e036mr3038381b6e.43.1794009551333;
 Fri, 06 Nov 2026 15:59:11 -0800 (PST)
Date: Fri,  6 Nov 2026 15:59:04 -0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106235904.1092712-1-tjmercier@google.com>
Subject: [PATCH] mm: workingset: compare shadow nodes node-wide without kmem accounting
From: "T.J. Mercier" <tjmercier@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "T.J. Mercier" <tjmercier@google.com>, 
	Jaewon Kim <jaewon31.kim@samsung.com>, Jaeseon Sim <jason.sim@samsung.com>, 
	Youngchan Kim <ycshark.kim@samsung.com>, Dmitry Skiba <dskiba@google.com>
Content-Type: text/plain; charset="UTF-8"

count_shadow_nodes() limits the number of xarray nodes holding shadow
entries to 1/8th of the pages that could be using them. For a memcg, it
counts the LRU and slab pages local to that memcg.

With kmem accounting disabled (cgroup.memory=nokmem), shadow nodes are
not charged to any memcg and __list_lru_init() makes the shadow_nodes
list_lru non-memcg-aware, so all shadow nodes of a NUMA node are on a
single list. shrinker_alloc() falls back to a non-memcg-aware shadow
node shrinker, which shrink_slab() only invokes for the root memcg.
count_shadow_nodes() therefore compares every shadow node on the NUMA
node against the pages local to the root memcg.

When most tasks run in child memcgs, the root memcg only holds a small
fraction of all pages, so the shadow node limit derived from the root
memcg page count is far below the number of shadow nodes on the NUMA
node. Since the shrinker has seeks == 0, every root shrink_slab() call
trims about half of the "excess" shadow nodes. Most refault information
is thrown away, so refaults of recently evicted file folios are not
detected. Refaulted folios lose PG_workingset and the workingset_refault
and workingset_restore stats drop.

In testing on devices with kmem accounting disabled, moving tasks from
the root memcg into per-application memcgs dropped workingset_nodes from
~37,000 to ~900 and raised workingset_nodereclaim 4.6x while
pgsteal_file rose by ~12%.

When kmem accounting is disabled, compare the shadow nodes against the
whole NUMA node, as is done without memcg. Behavior with kmem
accounting enabled is unchanged.

Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Tested-by: Jaeseon Sim <jason.sim@samsung.com> # Galaxy A18 LTE
Tested-by: Youngchan Kim <ycshark.kim@samsung.com> # Galaxy S27
Tested-by: Dmitry Skiba <dskiba@google.com> # Pixel 10
Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
 mm/workingset.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..87d5e55dd684 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -682,7 +682,16 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 	 * PAGE_SIZE / xa_nodes / node_entries * 8 / PAGE_SIZE
 	 */
 #ifdef CONFIG_MEMCG
-	if (sc->memcg) {
+	/*
+	 * Without kmem accounting the shadow_nodes list_lru is not
+	 * memcg-aware. So the count above covers the whole NUMA node, and the
+	 * shrinker only runs for the root memcg, whose local pages can be a
+	 * small fraction of the node's when most tasks run in child memcgs.
+	 * Compare the shadow node count against the memcg page count only when
+	 * the shadow_nodes list_lru is memcg-aware. Otherwise use the NUMA node
+	 * page count as is done without memcg.
+	 */
+	if (sc->memcg && shadow_nodes.memcg_aware) {
 		struct lruvec *lruvec;
 		int i;
 
-- 
2.56.0.455.g6c5a503b38-goog

