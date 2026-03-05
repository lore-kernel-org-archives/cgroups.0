Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670153909BB
	for <cgroups@vger.kernel.org>; Thu,  5 Mar 2026 11:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772711960; cv=none; b=SuHvcR0Xe13fxsBpSvUCyVNbHIU8u1iUb/J+IJe8ccRlvkLD+1BG6jMaCTGlQv9AVwFAbk4d6mECvA7KgdxjP3YZQ7GwxLWIbTHc6G4BChlBoEpfWbRnD1SQdIolUA2xy0uAsRTr2Me5iPt9gouOH+fTNs95OqGQT5uDI/f+stw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772711960; c=relaxed/simple;
	bh=Xqj+0uh8mD2tRbIWDoIhiPzxpjyN4PoCsHgk2HAFqic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGa9HkHCbrYWc7U9ZHKx9i5goNGykHDeCVrmW0hnhKfAkQnBtRqF2naXgZ+UfoxwvO9mcGX9NpebkZZFWcQFZmKZ1mX8+siTZqQFgFsd32tKb2KIAyrp3lUY3WejKxHCxcEDKGXaGfh6i6jCMOaHH7fxiIfXpd/fC6Fn54gLGdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VuMZBFmy; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VuMZBFmy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OkkDq9fYZNwUQylXgNIXOLA+3SHN3gdrMA7iDR/pB7s=;
	b=VuMZBFmyBkVgZzDvr//F8qLgETBTT0LZkc1dSfT2HpZqxQ3K/SW32urwpUT+jwMKE+XfX9
	+nfIk/2lc/8qOweHnZicjhtTr6/x0V5nC6dQN2K42J2ijNJUuZft24ZaWSwbP02ecM7Frd
	PWkv4pGGCJvB9u4BwbqTROdLTPndqlQ=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v6 29/33] mm: memcontrol: refactor mod_memcg_state() and mod_memcg_lruvec_state()
Date: Thu,  5 Mar 2026 19:52:47 +0800
Message-ID: <7f8bd3aacec2270b9453428fc8585cca9f10751e.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Qi Zheng <zhengqi.arch@bytedance.com>

Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
non-hierarchical stats.

Co-developed-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/memcontrol.c | 50 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5929e397c3c31..23b70bd80ddc9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -718,21 +718,12 @@ static int memcg_state_val_in_pages(int idx, int val)
 		return max(val * unit / PAGE_SIZE, 1UL);
 }
 
-/**
- * mod_memcg_state - update cgroup memory statistics
- * @memcg: the memory cgroup
- * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
- * @val: delta to add to the counter, can be negative
- */
-void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
-		       int val)
+static void __mod_memcg_state(struct mem_cgroup *memcg,
+			      enum memcg_stat_item idx, int val)
 {
 	int i = memcg_stats_index(idx);
 	int cpu;
 
-	if (mem_cgroup_disabled())
-		return;
-
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
@@ -746,6 +737,21 @@ void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
 	put_cpu();
 }
 
+/**
+ * mod_memcg_state - update cgroup memory statistics
+ * @memcg: the memory cgroup
+ * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
+ * @val: delta to add to the counter, can be negative
+ */
+void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
+		       int val)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	__mod_memcg_state(memcg, idx, val);
+}
+
 #ifdef CONFIG_MEMCG_V1
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
 unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
@@ -765,21 +771,16 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 }
 #endif
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-				     enum node_stat_item idx,
-				     int val)
+static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+				     enum node_stat_item idx, int val)
 {
-	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg = pn->memcg;
 	int i = memcg_stats_index(idx);
 	int cpu;
 
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = pn->memcg;
-
 	cpu = get_cpu();
 
 	/* Update memcg */
@@ -795,6 +796,17 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 	put_cpu();
 }
 
+static void mod_memcg_lruvec_state(struct lruvec *lruvec,
+				     enum node_stat_item idx,
+				     int val)
+{
+	struct mem_cgroup_per_node *pn;
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+
+	__mod_memcg_lruvec_state(pn, idx, val);
+}
+
 /**
  * mod_lruvec_state - update lruvec memory statistics
  * @lruvec: the lruvec
-- 
2.20.1

