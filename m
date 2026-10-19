Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9686A55CE8C
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 14:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792419358; cv=none; b=WrTspynKXbZeDzMBsNnkAIL5Jn3XYR7KK8xgwkR93D9mUyYEh5PvomMVCNTLio1FxsDkphORLClk/W7B7omEWpmKF/B7QMbzHlYTc/qU+fV5zOt30KXMdpBI3VE8PPazJz/2bTg0Vi0gYOMByR87v1gKCmA2enWegjnUIiMtwBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792419358; c=relaxed/simple;
	bh=VueBhj8axSR8Drw5sicnUiINUzk6bQ7LlEArehhNTxg=;
	h=Cc:Message-Id:Content-Type:To:Date:Mime-Version:In-Reply-To:From:
	 Subject:References; b=EgD/FQruRmDiuZV/jnlkgh73UHlobRUnQrcNnCiJLpIqq/HIs1UDWHFgrPGVXFvjD5YiAItMDDLN9IKnsga2nmjTgQH02LaN6cJCswEQ75wLyzOgRMi96oL7NBknKmna01TUo7pnCMm1o1jsXWVyCU6RQWX4KrIzNfWCFoQT44E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=LXMceNcC; arc=none smtp.client-ip=209.127.230.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="LXMceNcC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792419352; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=xoreJwIbc9FMkcxPipG4faUYvfDzahKIM5OORCnCFbM=;
 b=LXMceNcCGzigzX0mF22ioTXqfXUYPoQjn3BxLQWgem6phcnaTx9GfHWjJZvEFm++8Fm5Jl
 MriCqpDq8qfaQb6BKsg2+Z17juZm3284EkiJnYjPbzZhRe3hBpWHI/GUPiShsoqK46/BK3
 KpQ3ucBYa0i2cFTyyh177/lnszmPVHVA55pLGUvTQ6FJwnahazFhTv3gJtFQEvaFJbMirO
 jE/ab2HqJOzqa03de9Fz0ujyb0mTXCRfp4Edrc7VXpbXRjHvuYkvGUZSEHySfevdb7RwF2
 bVcO9egQhXusqup2ChkMyP3nZMnpS/OLCWuJvLpdVVAqB1dnXhYc4WyVXcd++g==
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261019141401.11927-3-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26ad62616+274811+vger.kernel.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>
Date: Mon, 19 Oct 2026 22:14:01 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20261019141401.11927-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [RFC 2/2] mm: add tier source selector to memory.reclaim
References: <20261019141401.11927-1-lizhe.67@bytedance.com>

source=nodes:<nodelist> lets userspace apply the existing
memory.reclaim aging pipeline to a specific set of NUMA nodes. Many
tiering controllers reason in terms of memory tiers rather than raw
node lists, and the memory tier core already exposes those tiers as
/sys/devices/virtual/memory_tiering/memory_tierN/nodelist.

Add source=tier:<N> as another typed source selector. The selector
uses the same N as memory_tierN and resolves it to the tier's current
memory-node mask at write time. The resulting mask is then passed to
the same source-scoped reclaim path used by source=nodes:<nodelist>.

This is only a selector convenience. It does not choose demotion
targets, does not introduce a demotion-only or eviction-only goal, and
does not change memory.reclaim completion accounting or reclaim policy.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 22 ++++++++-----
 include/linux/memory-tiers.h            |  6 ++++
 mm/memory-tiers.c                       | 24 ++++++++++++++
 mm/vmscan.c                             | 42 +++++++++++++++++--------
 4 files changed, 73 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index a016575010ba..d6e9b275fcfd 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1467,18 +1467,24 @@ The following nested keys are defined.
 
 	The source key declares where the normal reclaim aging pipeline is
 	applied. It is a typed selector in the form source=<type>:<selector>.
-	Currently only source=nodes:<nodelist> is supported. For example::
+
+	Currently source=nodes:<nodelist> and source=tier:<N> are supported.
+	For example::
 
 	  echo "1G source=nodes:0-1" > memory.reclaim
+	  echo "1G source=tier:4" > memory.reclaim
 
 	This instructs the kernel to apply reclaim pressure to memory of target
-	cgroup that are currently resident on nodes 0 and 1. Reclaim then
-	follows the normal reclaim path for selected folios. The source
-	selector does not choose a demotion or eviction policy. On tiered
-	memory systems, a source node in a non-terminal tier will usually make
-	progress through demotion when an allowed demotion target exists. A
-	source node in the terminal tier has no demotion target, so successful
-	reclaim progress from that source is eviction.
+	cgroup that are currently resident on the selected source. The nodes
+	form selects nodes directly. The tier form selects the nodes currently
+	in /sys/devices/virtual/memory_tiering/memory_tierN/nodelist, where N
+	is the memory tier id. Reclaim then follows the normal reclaim path
+	for selected folios. The source selector does not choose a demotion or
+	eviction policy. On tiered memory systems, a source node in a
+	non-terminal tier will usually make progress through demotion when an
+	allowed demotion target exists. A source node in the terminal tier has
+	no demotion target, so successful reclaim progress from that source is
+	eviction.
 
 	The source selector is a source constraint only. It does not select or
 	limit demotion targets; those are still chosen by the kernel's memory
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7999c58629ee..71fa51ba317d 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -49,6 +49,7 @@ int mt_calc_adistance(int node, int *adist);
 int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 			     const char *source);
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
+int mt_get_memory_tier_nodemask(int tier, nodemask_t *nodes);
 struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
@@ -142,6 +143,11 @@ static inline int mt_perf_to_adistance(struct access_coordinate *perf, int *adis
 	return -EIO;
 }
 
+static inline int mt_get_memory_tier_nodemask(int tier, nodemask_t *nodes)
+{
+	return -EINVAL;
+}
+
 static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 								struct list_head *memory_types)
 {
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b..75ec73b224a3 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -180,6 +180,30 @@ static ssize_t nodelist_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(nodelist);
 
+int mt_get_memory_tier_nodemask(int tier, nodemask_t *nodes)
+{
+	struct memory_tier *memtier;
+	int ret = -EINVAL;
+
+	if (tier < 0)
+		return -EINVAL;
+
+	mutex_lock(&memory_tier_lock);
+	list_for_each_entry(memtier, &memory_tiers, list) {
+		if (memtier->dev.id != tier)
+			continue;
+
+		*nodes = get_memtier_nodemask(memtier);
+		nodes_and(*nodes, *nodes, node_states[N_MEMORY]);
+		if (!nodes_empty(*nodes))
+			ret = 0;
+		break;
+	}
+	mutex_unlock(&memory_tier_lock);
+
+	return ret;
+}
+
 static struct attribute *memtier_dev_attrs[] = {
 	&dev_attr_nodelist.attr,
 	NULL
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 155d0ef82b48..2abbce265af6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7961,29 +7961,45 @@ static const match_table_t tokens = {
 };
 
 #define MEMORY_RECLAIM_SOURCE_NODES	"nodes:"
+#define MEMORY_RECLAIM_SOURCE_TIER	"tier:"
 
 static int parse_memory_reclaim_source(const char *source,
 				       nodemask_t *source_nodes)
 {
 	const char *nodes;
+	const char *tier;
+	int tier_id;
 
-	if (strncmp(source, MEMORY_RECLAIM_SOURCE_NODES,
-		    strlen(MEMORY_RECLAIM_SOURCE_NODES)))
-		return -EINVAL;
+	if (!strncmp(source, MEMORY_RECLAIM_SOURCE_NODES,
+		     strlen(MEMORY_RECLAIM_SOURCE_NODES))) {
+		nodes = source + strlen(MEMORY_RECLAIM_SOURCE_NODES);
+		if (!*nodes)
+			return -EINVAL;
 
-	nodes = source + strlen(MEMORY_RECLAIM_SOURCE_NODES);
-	if (!*nodes)
-		return -EINVAL;
+		nodes_clear(*source_nodes);
+		if (nodelist_parse(nodes, *source_nodes))
+			return -EINVAL;
 
-	nodes_clear(*source_nodes);
-	if (nodelist_parse(nodes, *source_nodes))
-		return -EINVAL;
+		nodes_and(*source_nodes, *source_nodes, node_states[N_MEMORY]);
+		if (nodes_empty(*source_nodes))
+			return -EINVAL;
 
-	nodes_and(*source_nodes, *source_nodes, node_states[N_MEMORY]);
-	if (nodes_empty(*source_nodes))
-		return -EINVAL;
+		return 0;
+	}
 
-	return 0;
+	if (!strncmp(source, MEMORY_RECLAIM_SOURCE_TIER,
+		     strlen(MEMORY_RECLAIM_SOURCE_TIER))) {
+		tier = source + strlen(MEMORY_RECLAIM_SOURCE_TIER);
+		if (!*tier)
+			return -EINVAL;
+
+		if (kstrtoint(tier, 10, &tier_id))
+			return -EINVAL;
+
+		return mt_get_memory_tier_nodemask(tier_id, source_nodes);
+	}
+
+	return -EINVAL;
 }
 
 int user_proactive_reclaim(char *buf,
-- 
2.20.1
