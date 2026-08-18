Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FFE3AB276;
	Tue, 18 Aug 2026 02:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787020496; cv=none; b=AxOon4v+JudG7Qqdi1BPCrLAP5izDkCEPX8wrY3rC0MNdNFxh+pgiULcMFROwteYPE3gzJ9JCVjpYx20v4JcIor6PfUsD9E1/1OcobMlNc1QnUezdvr9vzUQMRs0BxLTJUbUmW6gvvDyk3ybR2rHEplUDanvc4Nfrju3NOOZ72c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787020496; c=relaxed/simple;
	bh=wZV+KewsRgic+CD/5FIL2+TTMw3wSZ8iB6ir94bgiy4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GTlyBhnb93QRBK8bMHErQWLNWUCHp4wPYYZYwGVa4p96gJ9EBlsWAgZqZPBO32Nrg1x1FXgcK+NG6tyDx4htomH7OedrrQgd95aWCspS7ZbKVTybHHuVThD8GFhYl53i+0uprpTdUK3WGblA9PYc8k/clCT3t0wcLjgdvd/0nYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5fe496089aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c7719b35-c094-417e-bc13-1e9966fa1b7d,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.3.19,REQID:c7719b35-c094-417e-bc13-1e9966fa1b7d,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:7db8b62,CLOUDID:73bca6833ccae5fbc10dbdc037161fd1,BulkI
	D:2608181034484JTE4WQJ,BulkQuantity:0,SF:10|66|78|81|82|102|123|127|850|86
	5|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5fe496089aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1068612023; Tue, 18 Aug 2026 10:34:45 +0800
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
Subject: [RFC PATCH 8/8] cgroup: add memory_tiered_limits cgroup mount option
Date: Tue, 18 Aug 2026 10:31:21 +0800
Message-Id: <20260818023121.100613-9-liuqiqi@kylinos.cn>
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

Introduce the memory_tiered_limits cgroup v2 mount option to enable
tier-aware memory control. The option follows the same pattern as
memory_recursiveprot and memory_hugetlb_accounting.

When enabled, per-tier accounting, charging, stock batching, auto-
derivation, and the memory.tier control file are active. When disabled
(default), all tier-specific code is gated at entry points: no counters
are created, no charge/uncharge occurs, and memory.tier remains empty.
This ensures no measurable overhead for systems that do not opt in.

Usage:
  mount -t cgroup2 none /sys/fs/cgroup -o memory_tiered_limits

Because the cgroup2 mount is owned by the init system, early-boot
cgroups are created before userspace can specify mount options. To
cover these boot-time cgroups, mirror the cgroup_favordynmods approach
and add a kernel command-line parameter,
cgroup_memory_tiered_limits=<bool>.
This sets CGRP_ROOT_MEMORY_TIERED_LIMITS on all cgroup2 mounts by
default. The mount option remains available for runtime, per-mount
control.

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 include/linux/cgroup-defs.h |  5 +++++
 include/linux/memcontrol.h  | 12 ++++++++++++
 kernel/cgroup/cgroup.c      | 21 +++++++++++++++++++++
 mm/memcontrol.c             | 22 ++++++++++++++++++----
 4 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index de2cd6238c2a..4324d68dbce9 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -129,6 +129,11 @@ enum {
 	 * Enable legacy local pids.events.
 	 */
 	CGRP_ROOT_PIDS_LOCAL_EVENTS = (1 << 20),
+
+	/*
+	 * Enable tier-aware limits for the memory controller.
+	 */
+	CGRP_ROOT_MEMORY_TIERED_LIMITS = (1 << 21),
 };
 
 /* cftype->flags */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8848bc5eeb24..094b9a839977 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -544,6 +544,18 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
+#ifdef CONFIG_NUMA
+static inline bool mem_cgroup_tiered_limits(void)
+{
+	return cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_TIERED_LIMITS;
+}
+#else
+static inline bool mem_cgroup_tiered_limits(void)
+{
+	return false;
+}
+#endif
+
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 38f8d9df8fbc..da94bcda0859 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -231,6 +231,7 @@ static u32 have_release_callback __read_mostly;
 static u32 have_canfork_callback __read_mostly;
 
 static bool have_favordynmods __ro_after_init = IS_ENABLED(CONFIG_CGROUP_FAVOR_DYNMODS);
+static bool have_memory_tiered_limits __ro_after_init;
 
 /*
  * Write protected by cgroup_mutex and write-lock of cgroup_threadgroup_rwsem,
@@ -1985,6 +1986,7 @@ enum cgroup2_param {
 	Opt_memory_recursiveprot,
 	Opt_memory_hugetlb_accounting,
 	Opt_pids_localevents,
+	Opt_memory_tiered_limits,
 	nr__cgroup2_params
 };
 
@@ -1995,6 +1997,7 @@ static const struct fs_parameter_spec cgroup2_fs_parameters[] = {
 	fsparam_flag("memory_recursiveprot",	Opt_memory_recursiveprot),
 	fsparam_flag("memory_hugetlb_accounting", Opt_memory_hugetlb_accounting),
 	fsparam_flag("pids_localevents",	Opt_pids_localevents),
+	fsparam_flag("memory_tiered_limits",	Opt_memory_tiered_limits),
 	{}
 };
 
@@ -2027,6 +2030,9 @@ static int cgroup2_parse_param(struct fs_context *fc, struct fs_parameter *param
 	case Opt_pids_localevents:
 		ctx->flags |= CGRP_ROOT_PIDS_LOCAL_EVENTS;
 		return 0;
+	case Opt_memory_tiered_limits:
+		ctx->flags |= CGRP_ROOT_MEMORY_TIERED_LIMITS;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -2068,6 +2074,11 @@ static void apply_cgroup_root_flags(unsigned int root_flags)
 			cgrp_dfl_root.flags |= CGRP_ROOT_PIDS_LOCAL_EVENTS;
 		else
 			cgrp_dfl_root.flags &= ~CGRP_ROOT_PIDS_LOCAL_EVENTS;
+
+		if (root_flags & CGRP_ROOT_MEMORY_TIERED_LIMITS)
+			cgrp_dfl_root.flags |= CGRP_ROOT_MEMORY_TIERED_LIMITS;
+		else
+			cgrp_dfl_root.flags &= ~CGRP_ROOT_MEMORY_TIERED_LIMITS;
 	}
 }
 
@@ -2085,6 +2096,8 @@ static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root
 		seq_puts(seq, ",memory_hugetlb_accounting");
 	if (cgrp_dfl_root.flags & CGRP_ROOT_PIDS_LOCAL_EVENTS)
 		seq_puts(seq, ",pids_localevents");
+	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_TIERED_LIMITS)
+		seq_puts(seq, ",memory_tiered_limits");
 	return 0;
 }
 
@@ -2363,6 +2376,8 @@ static int cgroup_init_fs_context(struct fs_context *fc)
 
 	if (have_favordynmods)
 		ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
+	if (have_memory_tiered_limits)
+		ctx->flags |= CGRP_ROOT_MEMORY_TIERED_LIMITS;
 
 	return 0;
 }
@@ -7214,6 +7229,12 @@ static int __init cgroup_favordynmods_setup(char *str)
 }
 __setup("cgroup_favordynmods=", cgroup_favordynmods_setup);
 
+static int __init cgroup_memory_tiered_limits_setup(char *str)
+{
+	return (kstrtobool(str, &have_memory_tiered_limits) == 0);
+}
+__setup("cgroup_memory_tiered_limits=", cgroup_memory_tiered_limits_setup);
+
 /**
  * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
  * @dentry: directory dentry of interest
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f39a702d2301..891051f164ff 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2462,7 +2462,7 @@ static void memcg_charge_tier_id(struct mem_cgroup *memcg, int tier_id,
 {
 	struct memcg_tier_counter *tc;
 
-	if (tier_id < 0)
+	if (!mem_cgroup_tiered_limits() || tier_id < 0)
 		return;
 	rcu_read_lock();
 	tc = memcg_tier_counter_find(memcg, tier_id);
@@ -2476,7 +2476,7 @@ static void memcg_uncharge_tier_id(struct mem_cgroup *memcg, int tier_id,
 {
 	struct memcg_tier_counter *tc;
 
-	if (tier_id < 0)
+	if (!mem_cgroup_tiered_limits() || tier_id < 0)
 		return;
 	rcu_read_lock();
 	tc = memcg_tier_counter_find(memcg, tier_id);
@@ -2581,6 +2581,9 @@ static void tier_update_derived_limits(struct mem_cgroup *memcg)
 	unsigned long total;
 	int i, nr_entries;
 
+	if (!mem_cgroup_tiered_limits())
+		return;
+
 	spin_lock(&tier_cap_lock);
 	total = tier_total_capacity;
 	nr_entries = nr_tier_entries;
@@ -3198,6 +3201,9 @@ static void refill_tier_stock(struct mem_cgroup *memcg, int tier_id,
 	uint8_t pages;
 	int i;
 
+	if (!mem_cgroup_tiered_limits())
+		return;
+
 	/* Too big to cache: direct uncharge, leave the stock untouched. */
 	if (nr_pages > MEMCG_CHARGE_BATCH) {
 		rcu_read_lock();
@@ -3252,7 +3258,7 @@ static int try_charge_memcg_tier(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool drained = false;
 	nodemask_t nodes, *nmp = NULL;
 
-	if (tier_id < 0)
+	if (!mem_cgroup_tiered_limits() || tier_id < 0)
 		return 0;
 
 	rcu_read_lock();
@@ -4736,7 +4742,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 
-		{
+		if (mem_cgroup_tiered_limits()) {
 			int nid, tid;
 
 			for_each_online_node(nid) {
@@ -5459,6 +5465,8 @@ static int memory_tier_show(struct seq_file *m, void *v)
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 	struct memcg_tier_counter *tc;
 
+	if (!mem_cgroup_tiered_limits())
+		return 0;
 	rcu_read_lock();
 	list_for_each_entry_rcu(tc, &memcg->tier_counters, list) {
 		seq_printf(m, "tier%d.current=%llu\n", tc->tier_id,
@@ -5484,6 +5492,9 @@ static ssize_t memory_tier_write(struct kernfs_open_file *of,
 	char knob[8], *p;
 	int tier_id, err;
 
+	if (!mem_cgroup_tiered_limits())
+		return -EOPNOTSUPP;
+
 	buf = strstrip(buf);
 	if (sscanf(buf, "tier%d.%7[^=]", &tier_id, knob) != 2)
 		return -EINVAL;
@@ -6267,6 +6278,9 @@ static int __meminit memcg_tier_hotplug_cb(struct notifier_block *self,
 	struct mem_cgroup *memcg;
 	int tid;
 
+	if (!mem_cgroup_tiered_limits())
+		return notifier_from_errno(0);
+
 	switch (action) {
 	case NODE_ADDED_FIRST_MEMORY:
 		tid = node_to_tier_id(nn->nid);
-- 
2.43.0

