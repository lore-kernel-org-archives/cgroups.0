Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709153;
	b=P5hINxMGqNrXzCVMkhoQGz+fgHYjAYQMnA6yswhLfLQ0f9kBjXCtn4VR46JV34mbXyJy
	 05E5RD+ll0COd4O+MP+QMSXIao0n6PyX5NNKPpu76I0Tp52RKH/5GixHx6UNVF1FnXWw/
	 rQ8lza46RJyOlwaODsLXCYszkyxl/9rIC0QjyuF4Xw92Ba9Ab5CzSXiqUiC4L27rRD85/
	 oCxjrPPDohMfQ71Pv5EjtsaV2sq/ZYonrF3P3CN9u3bXY/+3MQGRxG9ushCvyqw8GhHv+
	 cOPm3BehPvE6XVnPGaWZvh5Q/WlVRoBAcw5Cw+lSkse9I6x4C2Bsh/1LUcsFbIXHSZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709153;
	h=DMARC-Filter:DKIM-Signature:Content-Type:To:Message-Id:
	 X-Lms-Return-Path:X-Original-From:Content-Transfer-Encoding:From:
	 Subject:Date:Mime-Version:Cc:In-Reply-To:References:X-Mailer;
	bh=x2ncG86rAs9pOnWEtcTfjniv2/ccRbZe8/nBUY3DZLo=;
	b=PSyf6gMqrHbx/XLtHrU8li4SFgbS3dAotTOdrRTxMCFrHAbW+892jMDrqFRVh8NBD1uk
	 mk62LiUM01yyO7XOFhIxEJn5Ln74r++bZo8K2bdqLR0MwEzNXhkrgzWaFt04fbU13eS9J
	 5T6Jf1NbDo+lNQSW9nzwuAglLrKoPHdn8hpN5OFP5oMBujp95MW4YackY4NwA7xU0zR3T
	 zC2nBfrR3RRi/2q0kZwXwE/KJEzKyfB/7DILeFrS8HK/7wpqOAPRO0ahY8PVZniqFj4dk
	 cbaC6R6PhF4fPsMSA5TR9H4+UHQcarN2ROkpS60zB7g+3+DaDud4o/J3qRhEbfkVF2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Y7UZCyZj;
	arc=none smtp.remote-ip=209.127.230.112
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308666085088
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 12:32:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 308666085088
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Y7UZCyZj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793709147; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=x2ncG86rAs9pOnWEtcTfjniv2/ccRbZe8/nBUY3DZLo=;
 b=Y7UZCyZjRyqCvZIhBQOZ+OaQT+8AW2wR11H/WdPbRmW7HHKYsQKuUtiRktBQkBR7cBEUAy
 fs5zO5r1Wf0Hp775TZH17f0cyHfXe1K/v4EHX3uxW/unTk/4EShVzzVs2IT37THbAp1C/n
 QmGAHm4CuOw0LZN25pTooVaNibUcEF2YwRJ+S9ZEPXFDBzK0QtzN2PjLhiok2ANnlYQtYt
 eGmRZ94XZVkgh4wBM3fbYDWkD2ofNQr92wYX4OWgqEE2rUcxqvyrta/mWQSbGLbdYD3kOO
 ubG5ongpAav/ElFiE1oQX0D3A5UO9db2HcH88t76hTFju7IHpzUwjr5gPGFjeg==
Content-Type: text/plain; charset=UTF-8
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <liam@infradead.org>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
Message-Id: <20261103122816.48037-4-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26ae9d459+5a0c5c+vger.kernel.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH 3/3] mm/mempolicy: add BPF kfuncs for cgroup interleave weights
Date: Tue,  3 Nov 2026 20:28:16 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Cc: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <bpf@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20261103122816.48037-1-lizhe.67@bytedance.com>
References: <20261103122816.48037-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2

Expose bpf_wi_set_weight(), bpf_wi_clear_weights(), and
bpf_wi_get_weight() as a BPF syscall control plane for cgroup
weighted-interleave overrides. The kfuncs let a privileged program
update one node weight, remove an override, or read the effective
weight.

All three kfuncs are sleepable, require CAP_SYS_ADMIN in the initial
user namespace, and accept only cgroup ids from the default cgroup-v2
hierarchy. Updates materialize a complete weight table and publish it
with RCU.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mempolicy.c | 201 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 200 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 751a5e90a4e1..7521542712cb 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -78,6 +78,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/mempolicy.h>
+#include <linux/capability.h>
+#include <linux/bpf.h>
 #include <linux/pagewalk.h>
 #include <linux/highmem.h>
 #include <linux/hugetlb.h>
@@ -103,6 +105,7 @@
 #include <linux/proc_fs.h>
 #include <linux/memory-tiers.h>
 #include <linux/migrate.h>
+#include <linux/module.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/security.h>
@@ -245,7 +248,7 @@ static struct weighted_interleave_state *wi_task_state_rcu(void)
 	return NULL;
 }
 
-void weighted_interleave_cgroup_free(struct cgroup *cgrp)
+static void wi_cgroup_clear_weights(struct cgroup *cgrp)
 {
 	struct weighted_interleave_state *old_wi_state;
 
@@ -260,6 +263,202 @@ void weighted_interleave_cgroup_free(struct cgroup *cgrp)
 
 	wi_state_retire(old_wi_state);
 }
+
+void weighted_interleave_cgroup_free(struct cgroup *cgrp)
+{
+	wi_cgroup_clear_weights(cgrp);
+}
+
+static struct weighted_interleave_state *
+wi_effective_state_cgroup_rcu(struct cgroup *cgrp)
+{
+	struct weighted_interleave_state *state;
+
+	state = wi_cgroup_state_rcu(cgrp);
+	if (state)
+		return state;
+	return rcu_dereference(wi_state);
+}
+
+static void wi_cgroup_set_state(struct cgroup *cgrp,
+				struct weighted_interleave_state *new_wi_state,
+				u32 nid, u8 weight)
+{
+	struct weighted_interleave_state *old_wi_state;
+
+	mutex_lock(&wi_cgroup_lock);
+	old_wi_state = rcu_dereference_protected(cgrp->wi_state,
+						 lockdep_is_held(&wi_cgroup_lock));
+	rcu_read_lock();
+	wi_state_init_from(new_wi_state, wi_effective_state_cgroup_rcu(cgrp));
+	rcu_read_unlock();
+
+	new_wi_state->mode_auto = false;
+	new_wi_state->iw_table[nid] = weight;
+	rcu_assign_pointer(cgrp->wi_state, new_wi_state);
+	if (!old_wi_state)
+		static_branch_inc(&wi_cgroup_weights_set);
+	mutex_unlock(&wi_cgroup_lock);
+
+	wi_state_retire(old_wi_state);
+}
+
+static bool wi_valid_nid(u32 nid)
+{
+	return nid < nr_node_ids && node_state(nid, N_MEMORY);
+}
+
+static int wi_cgroup_get(u64 cgid, struct cgroup **cgrpp)
+{
+	struct cgroup *cgrp;
+
+	cgrp = __cgroup_get_from_id(cgid);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+
+	if (!cgroup_on_dfl(cgrp)) {
+		cgroup_put(cgrp);
+		return -ENOENT;
+	}
+
+	*cgrpp = cgrp;
+	return 0;
+}
+
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_wi_set_weight - Set one weighted-interleave node weight for a cgroup.
+ * @cgid: cgroup id that must name a cgroup in default cgroup-v2 hierarchy
+ * @nid: memory NUMA node id to update
+ * @weight: new weight in range [1, 255]
+ *
+ * The first update creates an explicit override for @cgid by copying the
+ * nearest ancestor override, or the system-wide weighted-interleave weights
+ * if no ancestor has one. Nodes not named by the first update become local
+ * values in that table and do not keep tracking ancestor changes. Later
+ * updates modify the cgroup-local table. The override affects new
+ * MPOL_WEIGHTED_INTERLEAVE allocations made by tasks in the cgroup and
+ * descendants that do not have a nearer override.
+ *
+ * Return: 0 on success, -EINVAL for an invalid node or weight, -ENOENT
+ * when @cgid does not name a cgroup in the default cgroup-v2 hierarchy,
+ * -EPERM for insufficient privilege, or -ENOMEM when the override table
+ * cannot be allocated.
+ */
+__bpf_kfunc int bpf_wi_set_weight(u64 cgid, u32 nid, u32 weight)
+{
+	struct weighted_interleave_state *new_wi_state;
+	struct cgroup *cgrp;
+	int ret;
+
+	if (!wi_valid_nid(nid) || weight == 0 || weight > U8_MAX)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	new_wi_state = wi_state_alloc();
+	if (!new_wi_state)
+		return -ENOMEM;
+
+	ret = wi_cgroup_get(cgid, &cgrp);
+	if (ret) {
+		kfree(new_wi_state);
+		return ret;
+	}
+
+	wi_cgroup_set_state(cgrp, new_wi_state, nid, weight);
+	cgroup_put(cgrp);
+	return 0;
+}
+
+/**
+ * bpf_wi_clear_weights - Remove a cgroup weighted-interleave override.
+ * @cgid: cgroup id that must name a cgroup in default cgroup-v2 hierarchy
+ *
+ * After clearing, the cgroup inherits the nearest ancestor override, or the
+ * system-wide weighted-interleave weights if no ancestor has an override.
+ *
+ * Return: 0 on success, -ENOENT when @cgid does not name a cgroup in
+ * the default cgroup-v2 hierarchy, or -EPERM for insufficient
+ * privilege.
+ */
+__bpf_kfunc int bpf_wi_clear_weights(u64 cgid)
+{
+	struct cgroup *cgrp;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = wi_cgroup_get(cgid, &cgrp);
+	if (ret)
+		return ret;
+
+	wi_cgroup_clear_weights(cgrp);
+	cgroup_put(cgrp);
+	return 0;
+}
+
+/**
+ * bpf_wi_get_weight - Read the effective weighted-interleave node weight.
+ * @cgid: cgroup id that must name a cgroup in default cgroup-v2 hierarchy
+ * @nid: memory NUMA node id to query
+ *
+ * Return: the effective weight, -EINVAL for an invalid node, -ENOENT when
+ * @cgid does not name a cgroup in the default cgroup-v2 hierarchy, or
+ * -EPERM for insufficient privilege.
+ */
+__bpf_kfunc s64 bpf_wi_get_weight(u64 cgid, u32 nid)
+{
+	struct weighted_interleave_state *state;
+	struct cgroup *cgrp;
+	s64 weight;
+	int ret;
+
+	if (!wi_valid_nid(nid))
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = wi_cgroup_get(cgid, &cgrp);
+	if (ret)
+		return ret;
+
+	rcu_read_lock();
+	state = wi_effective_state_cgroup_rcu(cgrp);
+	weight = wi_state_weight(state, nid);
+	rcu_read_unlock();
+
+	cgroup_put(cgrp);
+	return weight;
+}
+
+__bpf_kfunc_end_defs();
+
+__ADDRESSABLE(bpf_wi_set_weight)
+__ADDRESSABLE(bpf_wi_clear_weights)
+__ADDRESSABLE(bpf_wi_get_weight)
+
+BTF_KFUNCS_START(wi_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_wi_set_weight, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_wi_clear_weights, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_wi_get_weight, KF_SLEEPABLE)
+BTF_KFUNCS_END(wi_kfunc_ids)
+
+static const struct btf_kfunc_id_set wi_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set = &wi_kfunc_ids,
+};
+
+static int __init wi_kfunc_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
+					 &wi_kfunc_set);
+}
+late_initcall(wi_kfunc_init);
 #else
 static struct weighted_interleave_state *wi_task_state_rcu(void)
 {
-- 
2.20.1
