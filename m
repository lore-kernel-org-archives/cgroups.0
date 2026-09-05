Received: from mta1.migadu.com (out-122.mta1.migadu.com [95.215.58.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4995B1E7660
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 03:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788577547; cv=none; b=VxQVpj78bQfI8nDJe+AZnCh7uAI2NGlJpArRgIg/61CLRm23tsSEVNBI/NAZM5lEph3lcnk+GvYI/XN39rXs8cTO0sYVY/hDW1KCA6Ny2brNMBI854HhLwfJ0yoLM1TK99h1fNOnTLxps6GgDoc60mb+lruNX41423qWSlmDWHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788577547; c=relaxed/simple;
	bh=OCqMxy89FiBT48toG1bb2lBNxftt+Uy3sG/HpFdPjKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVH9S86hMrTxaDV57V5/S+QGz2EFjIrW5gwCyvMLnlAfQfVWsaggyIu9kxCEM9nmulgHJeRxswtZEYUTMVuc0ldmKPLHIgUGsEF3refOIRhRlbFqX7KUcevSNH5tsQtKvUM525unf8D+ywFyNhH9duoBTiNpQ7zaSBnjaPkL4LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U3DiYY19; arc=none smtp.client-ip=95.215.58.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U3DiYY19"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OCqMxy89FiBT48toG1bb2lBNxftt+Uy3sG/HpFdPjKI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577542; v=1; x=1789182342;
 b=U3DiYY19bAXB6/KVr3LU7yjm1cTAB71T4DUya3mKji9CBTaU+wHDZhh6fCiTJgFrcRgpz3iQ
 QPbSw2vzRdCYsD/EYU+MGXip0NNPj/cK5/A2h1//WpUqJjzGo4MjTI5SnXsWC/Q93PNoAgj1u4Y
 LnZchLA+sOn5hVB+Wh794aZ0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 77fe83e8f7634880;
	Sat, 05 Sep 2026 03:05:41 +0000
X-Mizu-Trace-ID: 77fe83e8f7634880
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
Subject: [PATCH 3/6] memcg: group the write-hot fields of struct mem_cgroup
Date: Fri,  4 Sep 2026 20:05:19 -0700
Message-ID: <20260905030522.1887837-4-shakeel.butt@linux.dev>
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

These fields are written on the charge, reclaim and socket paths:

  socket_pressure       written by reclaim, read on every socket charge
  memory_events         bumped for this memcg and every ancestor, so a
                        busy child dirties the whole chain
  memory_events_local
  vmpressure            written on every reclaim iteration
  private_id_ref        written on every swap charge and uncharge
  kmem_stat
  high_irq_work, high_work

They are spread over the struct today and share cache lines with
read-mostly fields. Put them in one cache line group.

socket_pressure is kept next to memory_events because
mem_cgroup_sk_under_memory_pressure() reads one and bumps the other.

Add memcg_struct_check() so the build fails if a field lands outside
its group.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 59 ++++++++++++++++++++++----------------
 mm/memcontrol.c            | 32 +++++++++++++++++++++
 2 files changed, 66 insertions(+), 25 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46fc99786ebd..32b77ec5ba98 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -185,7 +185,6 @@ struct mem_cgroup {
 
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
 	int private_id;
-	refcount_t private_id_ref;
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
@@ -195,15 +194,45 @@ struct mem_cgroup {
 		struct page_counter memsw;	/* v1 only */
 	};
 
-	/* registered local peak watchers */
-	struct list_head memory_peaks;
-	struct list_head swap_peaks;
-	spinlock_t	 peaks_lock;
+	/* Written on the charge, reclaim and socket paths. */
+	__cacheline_group_begin_aligned(memcg_write_hot);
+	/*
+	 * Hint of reclaim pressure for socket memory management. Note
+	 * that this indicator should NOT be used in legacy cgroup mode
+	 * where socket memory is accounted/charged separately.
+	 */
+	u64			socket_pressure;
+#if BITS_PER_LONG < 64
+	seqlock_t		socket_pressure_seqlock;
+#endif
+	/*
+	 * memory.events is bumped for this memcg and all its ancestors, so a
+	 * busy child dirties every ancestor.
+	 */
+	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
+	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
+
+	/* vmpressure notifications. Written on every reclaim iteration. */
+	struct vmpressure vmpressure;
+
+	/* Written on every swap charge and uncharge. */
+	refcount_t private_id_ref;
 
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	/* MEMCG_KMEM for nmi context */
+	atomic_t		kmem_stat;
+#endif
 	/* Range enforcement for interrupt charges */
 	struct irq_work high_irq_work;
 	struct work_struct high_work;
 
+	__cacheline_group_end_aligned(memcg_write_hot);
+
+	/* registered local peak watchers */
+	struct list_head memory_peaks;
+	struct list_head swap_peaks;
+	spinlock_t	 peaks_lock;
+
 #ifdef CONFIG_ZSWAP
 	unsigned long zswap_max;
 
@@ -214,9 +243,6 @@ struct mem_cgroup {
 	bool zswap_writeback;
 #endif
 
-	/* vmpressure notifications */
-	struct vmpressure vmpressure;
-
 	/*
 	 * Should the OOM killer kill all belonging tasks, had it kill one?
 	 */
@@ -232,23 +258,6 @@ struct mem_cgroup {
 	/* memory.stat */
 	struct memcg_vmstats	*vmstats;
 
-	/* memory.events */
-	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
-	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
-
-#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-	/* MEMCG_KMEM for nmi context */
-	atomic_t		kmem_stat;
-#endif
-	/*
-	 * Hint of reclaim pressure for socket memroy management. Note
-	 * that this indicator should NOT be used in legacy cgroup mode
-	 * where socket memory is accounted/charged separately.
-	 */
-	u64			socket_pressure;
-#if BITS_PER_LONG < 64
-	seqlock_t		socket_pressure_seqlock;
-#endif
 	int kmemcg_id;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c42297ae3b0e..2e209dedeb4f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5726,6 +5726,36 @@ __setup("cgroup.memory=", cgroup_memory);
  * basically everything that doesn't depend on a specific mem_cgroup structure
  * should be initialized from here.
  */
+/*
+ * Fields are grouped by access pattern. Putting a field in the wrong group
+ * breaks the build here.
+ */
+static void __init memcg_struct_check(void)
+{
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      socket_pressure);
+#if BITS_PER_LONG < 64
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      socket_pressure_seqlock);
+#endif
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      memory_events);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      memory_events_local);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      vmpressure);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      private_id_ref);
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      kmem_stat);
+#endif
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      high_irq_work);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      high_work);
+}
+
 int __init mem_cgroup_init(void)
 {
 	unsigned int memcg_size;
@@ -5739,6 +5769,8 @@ int __init mem_cgroup_init(void)
 	 */
 	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S32_MAX / PAGE_SIZE);
 
+	memcg_struct_check();
+
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
-- 
2.53.0-Meta

