Received: from out-178.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411DE403EA5
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 20:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786480379; cv=none; b=Yjt/SVBJww4CDf/ezAwPPpZY+vI13g/aaQL54wfUa+/IQfXwO0/vi1PspAupyoTrLGULGasO+FdCaZwmZRoJnp6UZCE2SHEOB4cr5hJA0Iu3UG0oCq/JTegzvbh8r05nqEhugz0IBSgMi7nWAKvvgNDN/euoxOXJF2+qUQzVt6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786480379; c=relaxed/simple;
	bh=7gVWnR3Zrj0TkNt8a0EdnW9fGTbUaafAV3U3q/Me5tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f27GaAuWGsG0TDHMYz7znbB96tNR/kAI0K0kD6sOUZ1I1BBLMNEANvBNfkWm9od/DKoR5QaVLrM6SOuOnDOwfvLT9kTRMTbj6Z5jTcUPMeCJ02ig4vKi2V9eE3xoPjqKRL5Tu7HNcDcJPAPfksQozoQTJEPlq5AX1lzlKzRSi20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=af9Yzsml; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="af9Yzsml"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CN2l9vWwoY/I0+/xUhc13X8fJjrgmTbCFVIi09J5CeY=;
	b=af9YzsmlUM8QyJokSTb4jl52AGvGhzDmHQV45zQAnc+V3AZGcRml/gBTj66J2r2qxPKzv8
	eN/7vvJORDm58oraWpUHvex7ga5Jyw3DfjmD9HzwJMXBlnKuHfY767ETMMCySch/fkEOPa
	AMO+TEodrg0AxugIsaFVYFIbmwzFnZA=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] memcg: remove mem_cgroup->soft_limit
Date: Tue, 11 Aug 2026 13:32:02 -0700
Message-ID: <20260811203203.3456029-9-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Nothing reads it anymore, so the field and the helper that reset it on
css alloc and css reset can go.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 2 --
 mm/memcontrol-v1.h         | 6 ------
 mm/memcontrol.c            | 2 --
 3 files changed, 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ce24e04967d8..526da1d869ed 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -275,8 +275,6 @@ struct mem_cgroup {
 
 	struct memcg1_events_percpu __percpu *events_percpu;
 
-	unsigned long soft_limit;
-
 	/* protected by memcg_oom_lock */
 	bool oom_lock;
 	int under_oom;
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index fd611e66859a..f48d0e22e615 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -42,11 +42,6 @@ void memcg1_free_events(struct mem_cgroup *memcg);
 
 void memcg1_memcg_init(struct mem_cgroup *memcg);
 
-static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
-{
-	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
-}
-
 struct cgroup_taskset;
 void memcg1_css_offline(struct mem_cgroup *memcg);
 
@@ -97,7 +92,6 @@ static inline bool memcg1_alloc_events(struct mem_cgroup *memcg) { return true;
 static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
 
 static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
-static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
 static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b68f1f16ae54..ba3ef821553d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4222,7 +4222,6 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		return ERR_CAST(memcg);
 
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg1_soft_limit_reset(memcg);
 #ifdef CONFIG_ZSWAP
 	memcg->zswap_max = PAGE_COUNTER_MAX;
 	WRITE_ONCE(memcg->zswap_writeback, true);
@@ -4429,7 +4428,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg1_soft_limit_reset(memcg);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
 }
-- 
2.53.0-Meta

