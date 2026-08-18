Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F086381AE7;
	Tue, 18 Aug 2026 02:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787020485; cv=none; b=gtymG3Qo7VWHcE0bxcJ2JWIzLp23qVhxCcIoalM5EfcHxG4inoxw2twOABHlGZjpUP2yy0/ubQKe1NKwAmIfny6HJfTsTkxiRX7Rx6Aiaf10kjn96IFkok4XR/JymmlXzv3IvefwLnVO3mpOYL6rA/9fdzvHhBAuE49fqctuqNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787020485; c=relaxed/simple;
	bh=1Cmxz0hvuyWIYrP1anqw9Nc3wva/rpsfn0tUrjp2ap0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V7EGz5H8/7Uru8NsqzMfMohlAp0p7FAUUMnkaRLYqdHsKd0Tvk/a+jhn3pqftig7uk5tF/ktHtL/GVlveXVslGl6ChnIWAnZNzbLo/abZCcKjTBp15fE/70Hvddmgp3f5LjfmvcCfbxQRx5KgYLoMwy5n4WF/9H5OXPbN22XSjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 57fd964c9aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:dda3b867-f422-49ed-8a52-0e837abbdaae,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.19,REQID:dda3b867-f422-49ed-8a52-0e837abbdaae,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:7db8b62,CLOUDID:e153dadd488029a0bc5a71fc5926de14,BulkI
	D:26081810343628U38SMX,BulkQuantity:0,SF:10|66|78|81|82|102|123|127|850|86
	5|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 57fd964c9aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2111789817; Tue, 18 Aug 2026 10:34:32 +0800
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
Subject: [RFC PATCH 1/8] mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
Date: Tue, 18 Aug 2026 10:31:14 +0800
Message-Id: <20260818023121.100613-2-liuqiqi@kylinos.cn>
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

Add two helpers to bridge NUMA nodes and memory tiers:

  - node_to_tier_id(node):
    Returns the tier ID for a given node, derived from its abstract
    distance (adistance_start >> MEMTIER_CHUNK_BITS).  The lookup is
    lockless and low-cost, safe from any context including the memcg
    charge fast path.  Returns -1 if the node is not associated with
    a memory tier.

  - tier_id_to_nodemask(tier_id, nodes):
    Resolves the nodemask belonging to a given tier.  This operation
    is sleepable (takes the tier mutex) and must not be called from
    contexts that disallow blocking, such as the memcg charge fast
    path.  Suitable for reclaim and other sleepable contexts.

These helpers will be used by subsequent patches to implement per-tier
memcg accounting and reclaim.

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 include/linux/memory-tiers.h | 12 ++++++++
 mm/memory-tiers.c            | 58 ++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7999c58629ee..7277a08b97c9 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -52,6 +52,8 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
 struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
+int node_to_tier_id(int node);
+int tier_id_to_nodemask(int tier_id, nodemask_t *nodes);
 #ifdef CONFIG_NUMA_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -151,5 +153,15 @@ static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 }
+
+static inline int node_to_tier_id(int node)
+{
+	return -1;
+}
+
+static inline int tier_id_to_nodemask(int tier_id, nodemask_t *nodes)
+{
+	return -ENOENT;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b..896d23ac7a01 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -156,6 +156,64 @@ static __always_inline nodemask_t get_memtier_nodemask(struct memory_tier *memti
 	return nodes;
 }
 
+/**
+ * node_to_tier_id() - Get the memory tier id of a node
+ * @node: The node to look up
+ *
+ * Cheap, lockless lookup safe for the memcg charge hot path. The tier id is
+ * the memory tier's device id, i.e. adistance_start >> MEMTIER_CHUNK_BITS.
+ *
+ * Return: the tier id, or -1 if the node has no memory tier.
+ */
+int node_to_tier_id(int node)
+{
+	pg_data_t *pgdat;
+	struct memory_tier *memtier;
+	int tier_id = -1;
+
+	pgdat = NODE_DATA(node);
+	if (!pgdat)
+		return -1;
+
+	rcu_read_lock();
+	memtier = rcu_dereference(pgdat->memtier);
+	if (memtier)
+		tier_id = memtier->dev.id;
+	rcu_read_unlock();
+	return tier_id;
+}
+EXPORT_SYMBOL_GPL(node_to_tier_id);
+
+/**
+ * tier_id_to_nodemask() - Get the set of nodes belonging to a memory tier
+ * @tier_id: The tier id to look up
+ * @nodes: Output nodemask, cleared and filled on success
+ *
+ * Takes the memory tier mutex, so callers must be in a sleepable context.
+ * The memcg charge path calls this only after its gfp-allow-blocking check
+ * (i.e., only when about to reclaim), never on the charge fast path.
+ *
+ * Return: 0 on success, -ENOENT if no tier with the given id exists.
+ */
+int tier_id_to_nodemask(int tier_id, nodemask_t *nodes)
+{
+	struct memory_tier *memtier;
+	int ret = -ENOENT;
+
+	nodes_clear(*nodes);
+	mutex_lock(&memory_tier_lock);
+	list_for_each_entry(memtier, &memory_tiers, list) {
+		if (memtier->dev.id == tier_id) {
+			*nodes = get_memtier_nodemask(memtier);
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&memory_tier_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tier_id_to_nodemask);
+
 static void memory_tier_device_release(struct device *dev)
 {
 	struct memory_tier *tier = to_memory_tier(dev);
-- 
2.43.0

