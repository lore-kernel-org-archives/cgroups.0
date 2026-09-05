Received: from mta1.migadu.com (out-132.mta1.migadu.com [95.215.58.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D0D345EBB
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 03:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788577553; cv=none; b=AiMfdbWYxixB6Lp0hJbMs2uaEe/WbZUpU0OCckcUwWFgl+TZpIxxYXSx5sCRxeQHnmCMp8/4OG45NhSakjEZIGd3lubdqf0AynKACkz/Ta1b6Q4ZXENfEKkn2ORX+aFQDvvD818D06Qk6l1eXlbJunKtyuPE0602qLqdbjUJI4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788577553; c=relaxed/simple;
	bh=iPlKgRCUUQd3XAlmVdK29edWcfnznhNVidhGTeL5Mag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3vVXr7BRGaYxgC9/4Ptg91V0Qd0DZDZXxt9HS7gMDqu6X4Aqoc+jBfTsxVmNhy4xSFQnQ8ZeOtSoeQOXMr3VvQRlO34D+vpKKLLRgwDWePMgRRi9pzLSuyc0ujittp/5ZCHzRBUyISOFZ1rjhH5gvq/SsYQlW076GJPsIQTHQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ENKTF5V4; arc=none smtp.client-ip=95.215.58.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ENKTF5V4"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iPlKgRCUUQd3XAlmVdK29edWcfnznhNVidhGTeL5Mag=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577546; v=1; x=1789182346;
 b=ENKTF5V4Ne+I80OH/xVQhbReWdLhttoPnvc/x2gc+Pzbi5EyCc44P1WH7g2avzpbF145w617
 N1LDGuz42r1pCSgqb/ES8DhUTZS9df5F2ACZhA4s52SUa//BP9FCW2MFh54hfP6zqSbVVP8/fN7
 UkjVvJPlRGx3P4AxQJ+92Iec=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 460a9f945d6b52a6;
	Sat, 05 Sep 2026 03:05:46 +0000
X-Mizu-Trace-ID: 460a9f945d6b52a6
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
Subject: [PATCH 5/6] memcg: group the read-mostly fields of struct mem_cgroup
Date: Fri,  4 Sep 2026 20:05:21 -0700
Message-ID: <20260905030522.1887837-6-shakeel.butt@linux.dev>
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

These fields are set when the memcg is created and only read after
that:

  vmstats_percpu   read on every stat update
  vmstats
  zswap_max, zswap_writeback
  private_id       read on every eviction and refault
  kmemcg_id        read on every list_lru lookup
  oom_group

Put them in one cache line group at the end of the struct, right
before nodeinfo[]. nodeinfo[] is read-mostly too but it is a flexible
array, so it cannot sit inside a group. The group ends without padding
so the two share a line.

This also drops the ____cacheline_aligned_in_smp on vmstats_percpu
added by commit c1afbd5de131 ("mm/memcontrol: avoid false sharing
between vmstats and events"). That only aligned the start of the
field. cgwb_domain followed it on the same line and is written on
every writeout completion. A group boundary covers both sides.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 62 +++++++++++++++++++++-----------------
 mm/memcontrol.c            | 17 +++++++++++
 2 files changed, 52 insertions(+), 27 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 635929a1f13b..d0f3458f9250 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -183,9 +183,6 @@ struct obj_cgroup {
 struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
-	/* Private memcg ID. Used to ID objects that outlive the cgroup */
-	int private_id;
-
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
 
@@ -259,30 +256,6 @@ struct mem_cgroup {
 #endif
 	__cacheline_group_end_aligned(memcg_cold);
 
-#ifdef CONFIG_ZSWAP
-	unsigned long zswap_max;
-
-	/*
-	 * Prevent pages from this memcg from being written back from zswap to
-	 * swap, and from being swapped out on zswap store failures.
-	 */
-	bool zswap_writeback;
-#endif
-
-	/*
-	 * Should the OOM killer kill all belonging tasks, had it kill one?
-	 */
-	bool oom_group;
-
-	/* memory.stat */
-	struct memcg_vmstats	*vmstats;
-
-	int kmemcg_id;
-
-	/* Keep the hot per-CPU stats pointer away from memory event counters. */
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu
-		____cacheline_aligned_in_smp;
-
 #ifdef CONFIG_MEMCG_V1
 	/* v1 only. Not grouped: v1 is legacy, sorting it is not worth it. */
 
@@ -322,6 +295,41 @@ struct mem_cgroup {
 	int swappiness;
 #endif /* CONFIG_MEMCG_V1 */
 
+	/*
+	 * Set when the memcg is created and cleared when it is offlined.
+	 * Never written on a hot path.
+	 */
+	__cacheline_group_begin_aligned(memcg_read_mostly);
+	/* Read on every stat update */
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
+
+	/* memory.stat */
+	struct memcg_vmstats	*vmstats;
+
+#ifdef CONFIG_ZSWAP
+	unsigned long zswap_max;
+#endif
+
+	/* Private memcg ID. Used to ID objects that outlive the cgroup */
+	int private_id;
+
+	int kmemcg_id;
+
+	/*
+	 * Should the OOM killer kill all belonging tasks, had it kill one?
+	 */
+	bool oom_group;
+
+#ifdef CONFIG_ZSWAP
+	/*
+	 * Prevent pages from this memcg from being written back from zswap to
+	 * swap, and from being swapped out on zswap store failures.
+	 */
+	bool zswap_writeback;
+#endif
+	/* Not padded: nodeinfo[] is read-mostly too, let it share the line. */
+	__cacheline_group_end(memcg_read_mostly);
+
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b2cc82c936ed..4a5a30439a03 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5779,6 +5779,23 @@ static void __init memcg_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
 				      mm_list);
 #endif
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      vmstats_percpu);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      vmstats);
+#ifdef CONFIG_ZSWAP
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      zswap_max);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      zswap_writeback);
+#endif
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      private_id);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      kmemcg_id);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      oom_group);
 }
 
 int __init mem_cgroup_init(void)
-- 
2.53.0-Meta

