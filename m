Received: from mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB1535F184
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 03:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838923; cv=none; b=TezMgWuzIkU3wQHeRFuz1zoamsQESclhFjCWu0ALsVnP1nHEFE/0Gs1kHCMY/tEEU9ND92tgBPgyR868hpppK9nXcgBx2JuYSsyj9EXVHY2SsgeJYtt8BzPUTOLxYIe+6EPWenuU+TCvJAMI9uzAlRZhPqEykGiqVC1q4COGqJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838923; c=relaxed/simple;
	bh=48OIeErQYrhkpbuOIqiS9L91aRSY0G25gCPRWoMJaKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KK/y5zwRFiygw0BDNW0uJPO0dGaWOhZ6YpAvGSZguQw9eJoK2iM97+WJnICYgPWvIEkQVaB+1o5wBFrVbBiZPgYAiW4LLmnZNZPGF5l9KJkyh1KApXcCjr+3hKRn/uHFZpqi81CUEgJ7aeGuaUTp15FU51XwQvOjgTylH7uKeDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RuXkW5bl; arc=none smtp.client-ip=91.218.175.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RuXkW5bl"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=48OIeErQYrhkpbuOIqiS9L91aRSY0G25gCPRWoMJaKs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788838894; v=1; x=1789443694;
 b=RuXkW5blKmehN+uTXPt/ihgz6HiU9E2tc5ERPor0Q3H4ilXRfWlqOus/nDgcC9CLAkLa52eG
 YoKSIqDMWxiSsBUz3MT/dZ/3qdloLrsyJOhDUm8s1s7avJraKjo9a0u0IlL7LKEpf7/E/Lvtj/W
 o6QzjZjSbKbH1+zt6tbG3LRY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id bc731f78d792f31d;
	Tue, 08 Sep 2026 03:41:34 +0000
X-Mizu-Trace-ID: bc731f78d792f31d
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v4 1/4] mm: memcg: redirect stats updates of dying memcgs for all hierarchies
Date: Tue,  8 Sep 2026 11:41:11 +0800
Message-ID: <c1ef4ef6a84cac479e573f4423b734dc8176f7d5.1788837625.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788837625.git.zhuhui@kylinos.cn>
References: <cover.1788837625.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hui Zhu <zhuhui@kylinos.cn>

get_non_dying_memcg_start() redirects the stat updates of a dying memcg to
its closest non-dying ancestor, but only on cgroup v1; on cgroup v2 the
stats keep being accounted to the dying memcg itself.

A later patch in this series restores lruvec_page_state_local() in
count_shadow_nodes() to fix the broken workingset shadow node budget
under MGLRU.  count_shadow_nodes() is the only reader of those
non-hierarchical state_locals on cgroup v2: when a memcg is offlined,
its pages are reparented to the ancestor but their stat updates keep
being accounted to the dying memcg, so count_shadow_nodes() computes a
wrong shadow node budget and workingset thrashing protection is lost.
This is user visible as premature reclaim of hot page cache and
degraded performance under memory pressure.  Apply the redirection to
all hierarchies to fix this.

Offlining is rare, so the added cost on the stat update fast path is
limited to an rcu_read_lock() and a css_is_dying() check; the upward
walk happens only while a memcg is dying.

Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617e..ace9fe2b46084 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -845,20 +845,14 @@ static long memcg_state_val_in_pages(int idx, long val)
 	return val < 0 ? -res : res;
 }
 
-#ifdef CONFIG_MEMCG_V1
 /*
- * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
- * reparenting of non-hierarchical state_locals.
+ * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race
+ * with reparenting of non-hierarchical state_locals.  Offlining a
+ * memcg is rare, so do the redirection for all cgroup hierarchies.
  */
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
-							   bool *rcu_locked)
+static inline struct mem_cgroup *
+get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 {
-	/* Rebinding can cause this value to be changed at runtime */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		*rcu_locked = false;
-		return memcg;
-	}
-
 	rcu_read_lock();
 	*rcu_locked = true;
 
@@ -870,22 +864,8 @@ static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *me
 
 static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
-	if (!rcu_locked)
-		return;
-
 	rcu_read_unlock();
 }
-#else
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
-							   bool *rcu_locked)
-{
-	return memcg;
-}
-
-static inline void get_non_dying_memcg_end(bool rcu_locked)
-{
-}
-#endif
 
 static void __mod_memcg_state(struct mem_cgroup *memcg,
 			      enum memcg_stat_item idx, long val)
-- 
2.43.0

