Received: from mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5C64AD7DC
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 17:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371020; cv=none; b=QNoAGGPAk2VLblo19VVOlqs4DJorHnwhnuC1Ks8DeJ2a3+oJjd1AlqhJ+9JG4lpYyxITMzxO9HVyXTzE1ZWNkp6e0FGkSwTCfht83LyhX569y92r3bLWa/2mTpksjvRquAvEqZ8BwAl5eUo1oIMy58riRItqYnS2UdsmsETult8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371020; c=relaxed/simple;
	bh=4dRS80kpsGVD4l2ygd1KyYake2c32jhgx7HQ68nHlXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgc0TgS4ECbDc9oAroeldDknshyHbPcLHh/fuzW5Grp24NNQnYKaRCOSGRdCmEK7Q9zJ0tKx9jbiWEgcc2SHN5bGmbXJZ1fo5vPc2XVl5YQYlYImdOM/Vjsf+gRZBH3eJf7W7TWl6Zu6lbJqevLFELOSXOozm1z+6dLbobGyqGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UN6z/n1c; arc=none smtp.client-ip=95.215.58.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UN6z/n1c"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4dRS80kpsGVD4l2ygd1KyYake2c32jhgx7HQ68nHlXg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371016; v=1; x=1788975816;
 b=UN6z/n1cHLAg5WD6cn13vdsgGfCAFlp51wmF5wGTPtc2h4fSOQouzU3xsZzUh80+Wh5YzKez
 WrUvYCHCz/aNBPZAQozQyk3k29v+OOdcnwrv31LNdjHPs5QmUS4Kjpb8ojDolKZp38PBJNa5xFm
 /kaj7sQg4DOINw0JE7s/1QoI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6cb6e875af4750b6;
	Wed, 02 Sep 2026 17:43:36 +0000
X-Mizu-Trace-ID: 6cb6e875af4750b6
X-Migadu-Flow: FLOW_OUT
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
	tjmercier@google.com,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/8] memcg: remove mem_cgroup->soft_limit
Date: Wed,  2 Sep 2026 10:43:10 -0700
Message-ID: <20260902174311.1772372-8-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Nothing reads it anymore, so the field and the helper that reset it on
css alloc and css reset can go.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/memcontrol.h | 2 --
 mm/memcontrol-v1.h         | 6 ------
 mm/memcontrol.c            | 2 --
 3 files changed, 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1eababed16f5..c79992643556 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -280,8 +280,6 @@ struct mem_cgroup {
 
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
index 29def0376819..bce3962dba57 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4257,7 +4257,6 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		return ERR_CAST(memcg);
 
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg1_soft_limit_reset(memcg);
 #ifdef CONFIG_ZSWAP
 	memcg->zswap_max = PAGE_COUNTER_MAX;
 	WRITE_ONCE(memcg->zswap_writeback, true);
@@ -4464,7 +4463,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg1_soft_limit_reset(memcg);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
 }
-- 
2.53.0-Meta

