Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF0A4432FE
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134067; cv=none; b=XYyoxSaNpGCF7zVQ9HyUd0IXOCFXEbtxHpUx4jSKa90GEbRu+Mt+Y5hpfht/ez96zgO7U7Db6Eqd23heynM85HTNOtv951QdGRXyRbL+Ly4qfmYcaopBJRkRo/vmKu//kPFCYWOLhGWq3IQr/40n5fKpInD8bxCWhhif063Q6xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134067; c=relaxed/simple;
	bh=w0aiWvuXLSFHMY0mV8BwfkcBTVFPsPvUsMB0BenoBF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6eec3ip4EewaNYA4CEhV1pFXPK4DKtBODCPItin5q0oNzJbqkpNBu6NrmKB4AY+7lKOdZAxVK9tnrixEd0Bzfo0sX3G2PA/CoJiDwscGkXn9RbEVneJDnINlPkep9kEiUMDuq5QPaZ9M+PfHgUut1960oX07PmKka6+uhrcnWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MuyuqUWP; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MuyuqUWP"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-4af81963f35so1491085b6e.0
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134065; x=1786738865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Veey7tCntVTCDMITmGRXBJciLEPyIkZpuk6PEQ2O088=;
        b=MuyuqUWP4oGSy3+zAazXy+q9CKwIC8LyAcpu0V/19RRT7ZAO+a9DOcZdhKYJoMsJER
         E6c5I4wixJe9Qt3DN5tFVUbUsOKVK6lrMZZuJVC0y9jSFF10a67O4q++e0/PjSJRc68U
         gOl4zF3W2TP2/Hez2yhA7b4ONvH7z86Nq2YWICmD58S07rcHePfL+eKExDcJacXnKNag
         ESYAFNjaJ9wS0XCap1lcckAsKCcS7cXeDx7mVZoy3h8G3DWyw0yktS8acie9rWR3U7Y2
         uTwTNBnvg+jdSNWhhq7+H5eOtBGFrn/7x3omHIoGh8XiB7frBr9JAEx0wZpCXEHDYEGL
         1zaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134065; x=1786738865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Veey7tCntVTCDMITmGRXBJciLEPyIkZpuk6PEQ2O088=;
        b=G2uNI6coIfjpPEXsIY2Xonsausk9oB499JFmsnhe+79zGjrVCMuGB1exYLig15Oamg
         N6t3VJbd0PER8Johum02m2rFv/KRzRDO1xw2jbJw4DpxPQx8Waxj7qIVEE52LO/Tjx9L
         ubKxP0aQRTMh4YAXQZMg9JMzGH6gmrCYjiNekxCDJv1RjQTAwyamJNmT/qOONC8/41Dq
         13GN7QpvP1i52QlurzHQM2xhuBolcb81C86TFgqFYXssmeL+Hvx0BMW/OZROCIwigHgf
         Gsd8UMofe6Ipl+lx8b6eNPx5kV9FOYxkJSX/G2/NsJQZjj0w7hDudeH22hT4Z7He5Tj1
         tXtA==
X-Forwarded-Encrypted: i=1; AHgh+Rr8bG6pXz9d3ynv5EP6sFyrAYGLxROpbx25ZESVlH4Oa1sDIUd21Dzoy4kahSAGPOE5fC9zWBOv@vger.kernel.org
X-Gm-Message-State: AOJu0YxP7IGcb0dZAIkgmBsTSTAM1wVaxWn4mrXZjJNKu6RThOcSSBcd
	50vg9XBm+MgkL/w71ADOrKw+Q4V+ssAlZJ5tGfZgDUx9gIoZBw2nqnel
X-Gm-Gg: AR+sD12CQPUQosMzXTagAYE5dQTzghb4nmwjwqplCtILw+5Sgh5W8oiXJOAMLbUypyL
	EuRlMjjfr65Omp9KqHIlrgYp3hwfN6ejpAQhs0zOq3eDXyDPahDQMq3+1eP/wdt7achb5gy8PMh
	pBB5edp509hkuiVaQ7Bgxst7IdHrTn+Qgga8gXlKE3P8XxFif9kNvRf5nBXzYF/EfioWnX4ob2x
	pUTRGkoNwNhAjwe2ADyPdaCzfrcC0MlKSGjUYUJ5hvWGnDcPuVTQ99Ia9P+QbehS5w9tFs/Kqv8
	qL2hNvs2Bjl76xyYBrSh7dTssul4u/VUCyZGQya8i7tXi/IL/cUVxMANrCgMgbOJZS/J+ArmvRf
	16iETPdsWOVohXFROU8LkFd2WKwT108QphgGewzdj4rURx8WMdslVE9Hdiol2c6Soz0l2JfR9sI
	xPmlPPG9xDGzhxyvUQkt4EaZAd298nj6imY35zxwKo6J2+wwtU32b6XJmgFRpBlcZr5+g5+H2SH
	+LdjCtEnBGzN23Auw==
X-Received: by 2002:a05:6808:150b:b0:496:b7c:274b with SMTP id 5614622812f47-4afae16a91fmr12782189b6e.19.1786134065034;
        Fri, 07 Aug 2026 13:21:05 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:1::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b1af5e4fc0sm422662b6e.11.2026.08.07.13.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:04 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 03/14] mm/memory-tiers: Introduce a mapping from nid to tier_slot
Date: Fri,  7 Aug 2026 13:20:46 -0700
Message-ID: <20260807202059.2620949-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Establishing tiered memcg limits will require an ordering of tiers, as
well as a way to account how much memory is present in each tier.
This will need to be done starting at boot, so that all memory becomes
properly accounted.

However, tiers can come online and offline at runtime due to DAX memory
whose nodes can be hotplugged / hot-unplugged, and these nodes' tiers
are not available at boot.

Therefore, to establish a fixed mapping from nid to tier that isn't
sparse like the tier_ids, introduce a new "tier_slot" which is a dense
index that does not change once a tier comes online.

Also introduce a helper to retrieve the nodemask associated with a tier.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memory-tiers.h | 18 ++++++++
 mm/memory-tiers.c            | 86 +++++++++++++++++++++++++++++++++++-
 2 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7999c58629eeb..0e49645cdd1a9 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -41,6 +41,8 @@ extern struct memory_dev_type *default_dram_type;
 extern nodemask_t default_dram_nodes;
 struct memory_dev_type *alloc_memory_type(int adistance);
 void put_memory_type(struct memory_dev_type *memtype);
+int mt_nr_tier_slots(void);
+int nid_tier_slot(int nid);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
 void clear_node_memory_type(int node, struct memory_dev_type *memtype);
 int register_mt_adistance_algorithm(struct notifier_block *nb);
@@ -52,6 +54,7 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
 struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
+const nodemask_t *mt_tier_nodes(int slot);
 #ifdef CONFIG_NUMA_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -151,5 +154,20 @@ static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 }
+
+static inline int mt_nr_tier_slots(void)
+{
+	return 0;
+}
+
+static inline int nid_tier_slot(int nid)
+{
+	return -1;
+}
+
+static inline const nodemask_t *mt_tier_nodes(int slot)
+{
+	return NULL;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b0..36187c0ea9ded 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -43,6 +43,16 @@ static LIST_HEAD(memory_tiers);
  */
 static LIST_HEAD(default_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
+
+/*
+ * nr_tier_slots and tier_slot_ids are written with memory_tier_lock and
+ * read locklessly. nr_tier_slots is monotonically increasing.
+ */
+static int nr_tier_slots;
+static int tier_slot_ids[MAX_NUMNODES]   = {[0 ... MAX_NUMNODES - 1] = -1,};
+static int node_tier_slots[MAX_NUMNODES] = {[0 ... MAX_NUMNODES - 1] = -1,};
+static nodemask_t tier_nodemasks[MAX_NUMNODES];
+
 struct memory_dev_type *default_dram_type;
 nodemask_t default_dram_nodes __initdata = NODE_MASK_NONE;
 
@@ -273,6 +283,65 @@ static struct memory_tier *__node_get_memory_tier(int node)
 				     lockdep_is_held(&memory_tier_lock));
 }
 
+/* Caller must hold memory_tier_lock */
+static int tier_id_slot(int tier_id)
+{
+	int slot, free_slot = -1;
+
+	for (slot = 0; slot < nr_node_ids; slot++) {
+		if (tier_slot_ids[slot] == tier_id)
+			return slot;
+		if (tier_slot_ids[slot] == -1 && free_slot == -1) {
+			free_slot = slot;
+			tier_slot_ids[slot] = tier_id;
+		}
+	}
+
+	return free_slot;
+}
+
+static void establish_tier_slots(void)
+{
+	int old_nr_tier_slots = mt_nr_tier_slots();
+	int highest_slot = old_nr_tier_slots;
+
+	lockdep_assert_held_once(&memory_tier_lock);
+
+	for (int slot = 0; slot < old_nr_tier_slots; slot++)
+		nodes_clear(tier_nodemasks[slot]);
+
+	for (int nid = 0; nid < nr_node_ids; nid++) {
+		struct memory_tier *memtier = NULL;
+		int slot = -1;
+
+		if (node_state(nid, N_MEMORY))
+			memtier = __node_get_memory_tier(nid);
+		if (memtier) {
+			slot = tier_id_slot(memtier->dev.id);
+			highest_slot = max(highest_slot, slot + 1);
+		}
+
+		WRITE_ONCE(node_tier_slots[nid], slot);
+
+		if (slot != -1)
+			node_set(nid, tier_nodemasks[slot]);
+	}
+	WRITE_ONCE(nr_tier_slots, highest_slot);
+}
+
+int mt_nr_tier_slots(void)
+{
+	return READ_ONCE(nr_tier_slots);
+}
+
+int nid_tier_slot(int nid)
+{
+	if (nid < 0 || nid >= MAX_NUMNODES)
+		return -1;
+
+	return READ_ONCE(node_tier_slots[nid]);
+}
+
 #ifdef CONFIG_NUMA_MIGRATION
 bool node_is_toptier(int node)
 {
@@ -729,6 +798,7 @@ static int __init memory_tier_late_init(void)
 	}
 
 	establish_demotion_targets();
+	establish_tier_slots();
 	put_online_mems();
 
 	return 0;
@@ -878,6 +948,14 @@ int mt_calc_adistance(int node, int *adist)
 }
 EXPORT_SYMBOL_GPL(mt_calc_adistance);
 
+const nodemask_t *mt_tier_nodes(int slot)
+{
+	if (slot < 0)
+		return NULL;
+
+	return &tier_nodemasks[slot];
+}
+
 static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 					      unsigned long action, void *_arg)
 {
@@ -887,15 +965,19 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 	switch (action) {
 	case NODE_REMOVED_LAST_MEMORY:
 		mutex_lock(&memory_tier_lock);
-		if (clear_node_memory_tier(nn->nid))
+		if (clear_node_memory_tier(nn->nid)) {
 			establish_demotion_targets();
+			establish_tier_slots();
+		}
 		mutex_unlock(&memory_tier_lock);
 		break;
 	case NODE_ADDED_FIRST_MEMORY:
 		mutex_lock(&memory_tier_lock);
 		memtier = set_node_memory_tier(nn->nid);
-		if (!IS_ERR(memtier))
+		if (!IS_ERR(memtier)) {
 			establish_demotion_targets();
+			establish_tier_slots();
+		}
 		mutex_unlock(&memory_tier_lock);
 		break;
 	}
-- 
2.53.0-Meta

