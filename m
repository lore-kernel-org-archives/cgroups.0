Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117DE23ED5E
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 03:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788577540; cv=none; b=bdX2YkpwVotjvEiSbHGXAOgOvi5YdUpSDad1/VSLYL32k7vL5hQQkrpw20hElkC0sxNSWTaz1kTNnuippEgVftWe76WfVaWzjmpSRqvrth/HMY+++NMO0+VtJzagO0FLq23+W/v8qDBrw4rhtFATci7QJB2S7DR0X7MTHqyK9hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788577540; c=relaxed/simple;
	bh=4cZX4eIodO4viC5cG7gCwbR+5LjlqeMBqsKEP1IuJbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uwo/5jw1BsQZ1PndfVT4uuCMK5gKP0fWrfpFkYQfUMEa/2pYMV7P9bgmCgfTBCZnlZ+yQSo40KS7iCdxjORC+A7x/E1SML38uwc11GeiaVvK3t0ngtfbXmRtnnlOk8RpUes5Yb9z0O0haVihzB7BcH2LY2EOHE415/C405P6/3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HStncYxp; arc=none smtp.client-ip=95.215.58.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HStncYxp"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4cZX4eIodO4viC5cG7gCwbR+5LjlqeMBqsKEP1IuJbU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577534; v=1; x=1789182334;
 b=HStncYxpeld1YLlCwl6XNjWg7noZwHELol0QfrhhNhDcwG5Nex6VFG/f5wgHptKm4yBSz6AZ
 xOrBGAxAwmM+M1mT1xfYaKl5sSNo/atEDBARzOgxDpIytIt6+aiZJXUo7UwwIIADrdHeWIoI5jS
 ybgErSBCQ4LHcpEr0Cw3EtqY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f57d9d5b3f90c8ed;
	Sat, 05 Sep 2026 03:05:34 +0000
X-Mizu-Trace-ID: f57d9d5b3f90c8ed
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] memcg: move per-node objcg to the read-mostly fields
Date: Fri,  4 Sep 2026 20:05:17 -0700
Message-ID: <20260905030522.1887837-2-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260905030522.1887837-1-shakeel.butt@linux.dev>
References: <20260905030522.1887837-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

current_obj_cgroup() reads memcg->nodeinfo[nid]->objcg on every
accounted allocation. The field sits at the end of struct
mem_cgroup_per_node, on the same cache line as lru_zone_size[] and
iter. lru_zone_size[] is written on every LRU add and remove, and iter
is written on every reclaim iteration.

Move objcg next to the other read-mostly pointers at the start of the
struct.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f932b1ddda8c..ac575fcc5f1e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -94,6 +94,7 @@ struct mem_cgroup_per_node {
 	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
+	struct obj_cgroup __rcu		*objcg;
 
 	CACHELINE_PADDING(_pad1_);
 
@@ -104,11 +105,9 @@ struct mem_cgroup_per_node {
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
-	 * objcg is wiped out as a part of the objcg repaprenting process.
 	 * orig_objcg preserves a pointer (and a reference) to the original
-	 * objcg until the end of live of memcg.
+	 * objcg until the end of life of memcg.
 	 */
-	struct obj_cgroup __rcu	*objcg;
 	struct obj_cgroup	*orig_objcg;
 	/* list of inherited objcgs, protected by objcg_lock */
 	struct list_head objcg_list;
-- 
2.53.0-Meta

