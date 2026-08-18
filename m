Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4049F386571;
	Tue, 18 Aug 2026 02:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787020487; cv=none; b=f1aGGCGe6QEq1ov7Mfng7EJ5a+6DTnXMH8pJHyVY4H1leV+sW1776Pbg//50enAMgdedl+zPl4b9oqCdHj1wc5x1biB2jK/j4HSa/nwO10v5pmZozwLZGGwYTs4Aj0koBij93aqYOYpHc4I1ew+SwPzi37rxyrZeGz3ny/9xnao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787020487; c=relaxed/simple;
	bh=Fi6IZ84vNk5SyzkZB89EIURZUFvLmF/IHJJqT4+Oryc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XOObG+hqWN4ZoNnpVmeatUhGtl5kpikAtNSumNWXh+mOZ7yMzHrN045/F5ziVD7VDs6Rqvj9Kt7xXpTbPbxv/X7VXBSh2qICuwp7cMPx7j/KPus4yM0wLJis32hh4TVhYOIDZcOcX/2UAY1zYy7lSclNsq/zbRcSXwv+QvA98fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5b109f1e9aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:9d834cd3-6321-4510-8ed7-67b80d45ddf3,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.19,REQID:9d834cd3-6321-4510-8ed7-67b80d45ddf3,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:7db8b62,CLOUDID:4a50c9a97d272295d076535a67a14a6c,BulkI
	D:260818103439ADZUEN2N,BulkQuantity:0,SF:10|66|78|81|82|102|123|127|850|86
	5|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5b109f1e9aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1116303998; Tue, 18 Aug 2026 10:34:37 +0800
From: liuqiqi@kylinos.cn
To: linux-mm@kvack.org
Cc: tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [RFC PATCH 3/8] mm/memcontrol: add per-tier page counter infrastructure and lifecycle
Date: Tue, 18 Aug 2026 10:31:16 +0800
Message-Id: <20260818023121.100613-4-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiqi Liu <liuqiqi@kylinos.cn>

Introduce struct memcg_tier_counter, a hierarchical page_counter for
each (memcg, tier) pair. Each counter tracks memory usage on a specific
NUMA memory tier within a cgroup.

The counters are managed under the memcg lifecycle:
  - Lookup: lockless and RCU-protected.
  - Allocation: GFP_KERNEL, during css_alloc and memory tier hotplug.
  - Parent hierarchy: established explicitly at creation time.
  - Destruction: in css_free, alongside the memcg.

During css_alloc, counters are pre-allocated for the tiers of all
currently online nodes, ensuring the charge hot path never needs to
allocate memory.

This patch only lays the groundwork; the counters are not yet
integrated into charge/uncharge. The actual accounting logic is added
in a subsequent patch.

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 include/linux/memcontrol.h |  11 +++
 mm/memcontrol.c            | 141 +++++++++++++++++++++++++++++++++++++
 2 files changed, 152 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..c0f5929a87bf 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -199,6 +199,14 @@ struct obj_cgroup {
  * statistics based on the statistics developed by Rik Van Riel for clock-pro,
  * to help the administrator determine what knobs to tune.
  */
+
+struct memcg_tier_counter {
+	struct page_counter counter;
+	int tier_id;
+	struct list_head list;
+	struct rcu_head rcu;
+};
+
 struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
@@ -320,6 +328,9 @@ struct mem_cgroup {
 	spinlock_t event_list_lock;
 #endif /* CONFIG_MEMCG_V1 */
 
+	spinlock_t tier_lock;
+	struct list_head tier_counters;
+
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..70efe01bc36f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -28,6 +28,8 @@
 #include <linux/cgroup-defs.h>
 #include <linux/page_counter.h>
 #include <linux/memcontrol.h>
+#include <linux/memory-tiers.h>
+#include <linux/node.h>
 #include <linux/cgroup.h>
 #include <linux/cpuset.h>
 #include <linux/sched/mm.h>
@@ -2360,6 +2362,89 @@ static void high_work_func(struct work_struct *work)
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
 }
 
+/*
+ * Find a tier counter for a given memcg and tier ID.
+ *
+ * Context: Caller must hold either:
+ * - The RCU read lock, for lockless lookup in the fast (charge) path.
+ * - memcg->tier_lock, for modifications in the slow (creation/free) path.
+ */
+static struct memcg_tier_counter *
+memcg_tier_counter_find(struct mem_cgroup *memcg, int tier_id)
+{
+	struct memcg_tier_counter *tc;
+
+	list_for_each_entry_rcu(tc, &memcg->tier_counters, list,
+				lockdep_is_held(&memcg->tier_lock))
+		if (tc->tier_id == tier_id)
+			return tc;
+	return NULL;
+}
+
+static struct page_counter *
+memcg_tier_parent_link(struct mem_cgroup *parent, int tier_id)
+{
+	struct memcg_tier_counter *ptc;
+	struct page_counter *pc;
+
+	if (!parent || mem_cgroup_is_root(parent))
+		return NULL;
+
+	rcu_read_lock();
+	ptc = memcg_tier_counter_find(parent, tier_id);
+	pc = ptc ? &ptc->counter : NULL;
+	rcu_read_unlock();
+	return pc;
+}
+
+static int memcg_tier_counter_create(struct mem_cgroup *memcg,
+				     struct mem_cgroup *parent, int tier_id)
+{
+	struct page_counter *parent_cnt;
+	struct memcg_tier_counter *new;
+
+	/* Fast path (lockless RCU read): already exists -> nothing to do. */
+	rcu_read_lock();
+	if (memcg_tier_counter_find(memcg, tier_id)) {
+		rcu_read_unlock();
+		return 0;
+	}
+	rcu_read_unlock();
+
+	parent_cnt = memcg_tier_parent_link(parent, tier_id);
+
+	new = kzalloc_obj(*new);
+	if (!new)
+		return -ENOMEM;
+
+	new->tier_id = tier_id;
+	page_counter_init(&new->counter, parent_cnt, false);
+	page_counter_set_high(&new->counter, PAGE_COUNTER_MAX);
+	INIT_LIST_HEAD(&new->list);
+
+	spin_lock(&memcg->tier_lock);
+	if (memcg_tier_counter_find(memcg, tier_id)) {
+		spin_unlock(&memcg->tier_lock);
+		kfree(new);
+		return 0;
+	}
+	list_add_tail_rcu(&new->list, &memcg->tier_counters);
+	spin_unlock(&memcg->tier_lock);
+	return 0;
+}
+
+static void memcg_free_tier_counters(struct mem_cgroup *memcg)
+{
+	struct memcg_tier_counter *tc, *tmp;
+
+	spin_lock(&memcg->tier_lock);
+	list_for_each_entry_safe(tc, tmp, &memcg->tier_counters, list) {
+		list_del_rcu(&tc->list);
+		kfree_rcu(tc, rcu);
+	}
+	spin_unlock(&memcg->tier_lock);
+}
+
 /*
  * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
  * enough to still cause a significant slowdown in most cases, while still
@@ -4129,6 +4214,8 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 		goto fail;
 
 	INIT_WORK(&memcg->high_work, high_work_func);
+	spin_lock_init(&memcg->tier_lock);
+	INIT_LIST_HEAD(&memcg->tier_counters);
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->memory_peaks);
 	INIT_LIST_HEAD(&memcg->swap_peaks);
@@ -4178,6 +4265,20 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
+
+		{
+			int nid, tid;
+
+			for_each_online_node(nid) {
+				tid = node_to_tier_id(nid);
+				if (tid != -1 && memcg_tier_counter_create(memcg,
+							mem_cgroup_from_css(parent_css), tid)) {
+					memcg_free_tier_counters(memcg);
+					mem_cgroup_free(memcg);
+					return ERR_PTR(-ENOMEM);
+				}
+			}
+		}
 #ifdef CONFIG_MEMCG_V1
 		memcg->memory.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
@@ -4338,6 +4439,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 
 	vmpressure_cleanup(&memcg->vmpressure);
 	cancel_work_sync(&memcg->high_work);
+	memcg_free_tier_counters(memcg);
 	memcg1_remove_from_trees(memcg);
 	free_shrinker_info(memcg);
 	mem_cgroup_free(memcg);
@@ -5534,6 +5636,41 @@ __setup("cgroup.memory=", cgroup_memory);
  * basically everything that doesn't depend on a specific mem_cgroup structure
  * should be initialized from here.
  */
+#if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_NUMA)
+/*
+ * Below MEMTIER_HOTPLUG_PRI (100): run after memory-tiers has set or
+ * cleared the node's tier association.
+ */
+#define MEMCG_TIER_NODE_PRI		90
+
+/* Memory hotplug callback: a node came online with a potentially new tier
+ * (e.g. CXL hotplug). Ensure every online memcg has a counter for this tier.
+ * Existing tiers hit in the RCU lookup, so this path does not allocate.
+ */
+static int __meminit memcg_tier_hotplug_cb(struct notifier_block *self,
+					    unsigned long action, void *_arg)
+{
+	struct node_notify *nn = _arg;
+	struct mem_cgroup *memcg;
+	int tid;
+
+	if (action != NODE_ADDED_FIRST_MEMORY)
+		return notifier_from_errno(0);
+
+	tid = node_to_tier_id(nn->nid);
+	if (tid < 0)
+		return notifier_from_errno(0);
+
+	for_each_mem_cgroup(memcg) {
+		if (!mem_cgroup_is_root(memcg) &&
+		    memcg_tier_counter_create(memcg, parent_mem_cgroup(memcg), tid))
+			pr_warn_ratelimited("memcg: tier %d counter alloc failed;"
+					     " tier accounting degraded\n", tid);
+	}
+	return notifier_from_errno(0);
+}
+#endif
+
 int __init mem_cgroup_init(void)
 {
 	unsigned int memcg_size;
@@ -5553,6 +5690,10 @@ int __init mem_cgroup_init(void)
 	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
 	WARN_ON(!memcg_wq);
 
+#if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_NUMA)
+	hotplug_node_notifier(memcg_tier_hotplug_cb, MEMCG_TIER_NODE_PRI);
+#endif
+
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
 			  drain_local_memcg_stock);
-- 
2.43.0

