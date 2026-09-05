Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4DF23ED5E
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 03:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788577553; cv=none; b=S63kzhwlHDLt2EKsGDHvIK2PE0HJ6eV9GXgLCAnDhrnLOB1VvxBry+eb0+aEs3om2Th3nN8G4MIbphqZUY5LRNpjSe731Bag2owghRfxxOEfiD/WjVEkQMktP3sVno7h93jSfOpKUtDf1mVxKZ1CDLb8IwGI1fWD4NhRIR9ly3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788577553; c=relaxed/simple;
	bh=DhoeiXFp7UyoSRxvvEzH1+kOUdYsRS2oS9Jn9zavQlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeLLxmYD8ep9CT9ZUa9qlxigUTbbAp+CzaO7Ut9HsZxN1tfe+LLlplafmffbxe3C2GVNpxCciAA7sV2Qdgv8cIZlXC0LZT+LPyZn5npdxgNVHe229crBLj15Xluur04ef/ku4aw02jxCiFkz1/Z2VtXwdvJBHgE9CUO3nsIdicY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Yql80JcS; arc=none smtp.client-ip=91.218.175.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Yql80JcS"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DhoeiXFp7UyoSRxvvEzH1+kOUdYsRS2oS9Jn9zavQlk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577544; v=1; x=1789182344;
 b=Yql80JcSu02o0RCt4JLOLCs8wE+G4nIh0vSz84qwOwMxZ34VFcmPmb3dTFVIdefKdWQl5TnG
 RVj6URvSfwVQf7/hjowyk4xVaFC/aoAvO+JOiHFFjBuZ4T9xDtmt0qygmjUlWm9IOYmrXM0ecxH
 YcoDIQqR1JopgQtbUDFn94d8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2febea93e74d4996;
	Sat, 05 Sep 2026 03:05:44 +0000
X-Mizu-Trace-ID: 2febea93e74d4996
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
Subject: [PATCH 4/6] memcg: group the cold fields of struct mem_cgroup
Date: Fri,  4 Sep 2026 20:05:20 -0700
Message-ID: <20260905030522.1887837-5-shakeel.butt@linux.dev>
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

These fields are only touched by the cgroup control paths:

  memory_peaks, swap_peaks, peaks_lock   memory.peak open/read/release
  events_file, events_local_file,
  swap_events_file                       cgroup_file_notify()
  cgwb_list, cgwb_domain, cgwb_frn       writeback setup and the
                                         foreign dirty slow path
  mm_list                                MGLRU mm list

They sit in the middle of the struct today. The three cgroup_file
members alone are 192 bytes of notify state next to the vmstats
pointer. Put them in one cache line group.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 49 ++++++++++++++++++++++----------------
 mm/memcontrol.c            | 25 +++++++++++++++++++
 2 files changed, 53 insertions(+), 21 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 32b77ec5ba98..635929a1f13b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -228,11 +228,37 @@ struct mem_cgroup {
 
 	__cacheline_group_end_aligned(memcg_write_hot);
 
+	/*
+	 * Off the charge and fault paths.  Not write free: cgwb_domain is
+	 * written on every writeout completion and mm_list on fork, exit and
+	 * MGLRU aging.  They are grouped here so those writes cannot land on
+	 * a line that the fast paths read.
+	 */
+	__cacheline_group_begin_aligned(memcg_cold);
 	/* registered local peak watchers */
 	struct list_head memory_peaks;
 	struct list_head swap_peaks;
 	spinlock_t	 peaks_lock;
 
+	/* memory.events and memory.events.local */
+	struct cgroup_file events_file;
+	struct cgroup_file events_local_file;
+
+	/* handle for "memory.swap.events" */
+	struct cgroup_file swap_events_file;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
+	struct list_head cgwb_list;
+	struct wb_domain cgwb_domain;
+	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
+#endif
+
+#ifdef CONFIG_LRU_GEN_WALKS_MMU
+	/* per-memcg mm_struct list */
+	struct lru_gen_mm_list mm_list;
+#endif
+	__cacheline_group_end_aligned(memcg_cold);
+
 #ifdef CONFIG_ZSWAP
 	unsigned long zswap_max;
 
@@ -248,37 +274,18 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
-	/* memory.events and memory.events.local */
-	struct cgroup_file events_file;
-	struct cgroup_file events_local_file;
-
-	/* handle for "memory.swap.events" */
-	struct cgroup_file swap_events_file;
-
 	/* memory.stat */
 	struct memcg_vmstats	*vmstats;
 
 	int kmemcg_id;
 
-#ifdef CONFIG_CGROUP_WRITEBACK
-	struct list_head cgwb_list;
-#endif
-
 	/* Keep the hot per-CPU stats pointer away from memory event counters. */
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu
 		____cacheline_aligned_in_smp;
 
-#ifdef CONFIG_CGROUP_WRITEBACK
-	struct wb_domain cgwb_domain;
-	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
-#endif
-
-#ifdef CONFIG_LRU_GEN_WALKS_MMU
-	/* per-memcg mm_struct list */
-	struct lru_gen_mm_list mm_list;
-#endif
-
 #ifdef CONFIG_MEMCG_V1
+	/* v1 only. Not grouped: v1 is legacy, sorting it is not worth it. */
+
 	/* Legacy consumer-oriented counters */
 	struct page_counter kmem;		/* v1 only */
 	struct page_counter tcpmem;		/* v1 only */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e209dedeb4f..b2cc82c936ed 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5754,6 +5754,31 @@ static void __init memcg_struct_check(void)
 				      high_irq_work);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
 				      high_work);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      memory_peaks);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      swap_peaks);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      peaks_lock);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      events_file);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      events_local_file);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      swap_events_file);
+#ifdef CONFIG_CGROUP_WRITEBACK
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      cgwb_list);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      cgwb_domain);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      cgwb_frn);
+#endif
+#ifdef CONFIG_LRU_GEN_WALKS_MMU
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      mm_list);
+#endif
 }
 
 int __init mem_cgroup_init(void)
-- 
2.53.0-Meta

