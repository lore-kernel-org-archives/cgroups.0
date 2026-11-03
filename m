Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793708968;
	b=f83XtV2DEmV+Z/nWaCfN5JKjhpZ8ep7ChfbfWXzQdu+1Mpmw8jgscjAie/sLarOCNHex
	 nIQvEOra0uNEVusqhsUCo/QZ363b10EP60XRv5rLbBpciqg/UuwPODni1MPn/UY3ArZRa
	 +Ypj49ZhgKt5nZ3NOGb9oVFouHIgHOLyJ3w/8TIcjNvOIIErr9Ccrfpz/lKB1uP1D5FEf
	 BaCmCExSt+19Hjnip099uNaRS48mRIPgPsR8zsn3QpnumcqxC9vLP1VW2SYN7rbih1KwA
	 8DZPZMRD81bThqJVuifk+Sit8z3gbe38nAjf+s9EAnoRKbI39sOCCxQd4J8fEcEC2lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793708968;
	h=DMARC-Filter:DKIM-Signature:Subject:Message-Id:Cc:In-Reply-To:
	 References:Content-Type:Mime-Version:X-Original-From:Date:X-Mailer:
	 Content-Transfer-Encoding:X-Lms-Return-Path:To:From;
	bh=FP7kG4/RawLD0z06EWd0ekkozMQmyFz/TouOQGf11tc=;
	b=oaEag0FPJbQXFQcdqZEYDMIOm0Q5Ki2bLzIRP7rpXyE7oSi0EjZWRODhgQxW5aUJnZxg
	 3LG1mcp4/NebbVn7yjIOgO1aDnYnrcCeNvYhquRU7HMO1aa4Dtn+CEKVm6P2Wz/3SunbC
	 SomsSBoQXcxnWyMi1ilokQwdrhHPX48s09fVNFk0v/bdETvJh5ojwPFofIE83viMftRZX
	 43TZLH1m0aWlDGxpx3ohe1amsa7UNzSL5yXBNBI1SFLmBD4nR5CQaoCIQld0JO/CMSGjl
	 ZS3CJf+HVEKFAzZjkx26EXN4F2asZS2Ln86BceMCNozbhMj1Q2o+PPCY7/rdvGNuOhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=AIzGQocF;
	arc=none smtp.remote-ip=209.127.231.113
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A96606D813
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 12:29:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5A96606D813
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=AIzGQocF
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793708961; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=FP7kG4/RawLD0z06EWd0ekkozMQmyFz/TouOQGf11tc=;
 b=AIzGQocFfgWdNoTakhQX2iAHKob9UPvw3QMcbq68VyAdWi6E25Tmf6ynmTo3xB6pAmH/25
 rtNA71csOKYn3tQRJ7uAolU5wnZ3/U1LlUyFZt24qucmB0OvVG+MPYdOKnHUTE2xGmpmnt
 5ZcMbwudaRME8thCbSHFkx5XiihwWDK5YUQokCGyGyzFE8kdGJrH+T99OpPk6lhXYGAqUX
 Dj+jd/Ki7nUasP9ODN5pODRvZmlA1jxm3kwVaQ7uvE/6BcVZaw8GxGJtCZO8zk/YBYyURx
 NQ1zsONrrDFO0wbP5aXQP9tFAgI5g2jtCpXGI+ErBsCOo5sCSZt1KroD6xRrpw==
Subject: [PATCH 1/3] mm/mempolicy: factor weighted interleave state helpers
Message-Id: <20261103122816.48037-2-lizhe.67@bytedance.com>
Cc: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <bpf@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20261103122816.48037-1-lizhe.67@bytedance.com>
References: <20261103122816.48037-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Date: Tue,  3 Nov 2026 20:28:14 +0800
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26ae9d39e+cfc037+vger.kernel.org+lizhe.67@bytedance.com>
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <liam@infradead.org>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
From: "Li Zhe" <lizhe.67@bytedance.com>

Weighted interleave updates repeat the same allocation, default table
initialization, table copy and default table setup patterns in the sysfs
and auto-weighting paths.

Factor those pieces into small helpers so later changes can reuse one
state lifecycle for both the global table and cgroup-local override
tables. Keep the existing upstream wi_srcu retirement path unchanged.

No functional change is intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mempolicy.c | 54 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0884c629670d..fb9962302664 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -188,6 +188,30 @@ static void wi_state_retire(struct weighted_interleave_state *state)
 		call_srcu(&wi_srcu, &state->rcu, wi_state_free_rcu);
 }
 
+static struct weighted_interleave_state *wi_state_alloc(void)
+{
+	struct weighted_interleave_state *state;
+
+	return kzalloc_flex(*state, iw_table, nr_node_ids, GFP_KERNEL);
+}
+
+static void wi_state_init(struct weighted_interleave_state *state)
+{
+	for (int i = 0; i < nr_node_ids; i++)
+		state->iw_table[i] = 1;
+}
+
+#if defined(CONFIG_SYSFS) || defined(CONFIG_BPF_WEIGHTED_INTERLEAVE)
+static void wi_state_init_from(struct weighted_interleave_state *dst,
+			       struct weighted_interleave_state *src)
+{
+	if (src)
+		memcpy(dst->iw_table, src->iw_table, nr_node_ids * sizeof(u8));
+	else
+		wi_state_init(dst);
+}
+#endif
+
 static u8 get_il_weight(int node)
 {
 	struct weighted_interleave_state *state;
@@ -243,22 +267,17 @@ int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
 	unsigned int *old_bw, *new_bw;
 	unsigned int bw_val;
-	int i;
 
 	bw_val = min(coords->read_bandwidth, coords->write_bandwidth);
 	new_bw = kcalloc(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
 	if (!new_bw)
 		return -ENOMEM;
 
-	new_wi_state = kmalloc_flex(*new_wi_state, iw_table, nr_node_ids);
+	new_wi_state = wi_state_alloc();
 	if (!new_wi_state) {
 		kfree(new_bw);
 		return -ENOMEM;
 	}
-	new_wi_state->mode_auto = true;
-	for (i = 0; i < nr_node_ids; i++)
-		new_wi_state->iw_table[i] = 1;
-
 	/*
 	 * Update bandwidth info, even in manual mode. That way, when switching
 	 * to auto mode in the future, iw_table can be overwritten using
@@ -282,6 +301,8 @@ int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 	}
 
 	/* NULL wi_state assumes auto=true; reduce weights and update wi_state*/
+	wi_state_init(new_wi_state);
+	new_wi_state->mode_auto = true;
 	reduce_interleave_weights(new_bw, new_wi_state->iw_table);
 	rcu_assign_pointer(wi_state, new_wi_state);
 
@@ -3672,27 +3693,20 @@ static ssize_t node_store(struct kobject *kobj, struct kobj_attribute *attr,
 	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
 	struct iw_node_attr *node_attr;
 	u8 weight = 0;
-	int i;
 
 	node_attr = container_of(attr, struct iw_node_attr, kobj_attr);
 	if (count == 0 || sysfs_streq(buf, "") ||
 	    kstrtou8(buf, 0, &weight) || weight == 0)
 		return -EINVAL;
 
-	new_wi_state = kzalloc_flex(*new_wi_state, iw_table, nr_node_ids);
+	new_wi_state = wi_state_alloc();
 	if (!new_wi_state)
 		return -ENOMEM;
 
 	mutex_lock(&wi_state_lock);
 	old_wi_state = rcu_dereference_protected(wi_state,
 					lockdep_is_held(&wi_state_lock));
-	if (old_wi_state) {
-		memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
-					nr_node_ids * sizeof(u8));
-	} else {
-		for (i = 0; i < nr_node_ids; i++)
-			new_wi_state->iw_table[i] = 1;
-	}
+	wi_state_init_from(new_wi_state, old_wi_state);
 	new_wi_state->iw_table[node_attr->nid] = weight;
 	new_wi_state->mode_auto = false;
 
@@ -3723,16 +3737,13 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
 	unsigned int *bw;
 	bool input;
-	int i;
 
 	if (kstrtobool(buf, &input))
 		return -EINVAL;
 
-	new_wi_state = kzalloc_flex(*new_wi_state, iw_table, nr_node_ids);
+	new_wi_state = wi_state_alloc();
 	if (!new_wi_state)
 		return -ENOMEM;
-	for (i = 0; i < nr_node_ids; i++)
-		new_wi_state->iw_table[i] = 1;
 
 	mutex_lock(&wi_state_lock);
 	old_wi_state = rcu_dereference_protected(wi_state,
@@ -3745,9 +3756,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 	}
 
 	if (!input) {
-		if (old_wi_state)
-			memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
-						       nr_node_ids * sizeof(u8));
+		wi_state_init_from(new_wi_state, old_wi_state);
 		goto update_wi_state;
 	}
 
@@ -3758,6 +3767,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 		return -ENODEV;
 	}
 
+	wi_state_init(new_wi_state);
 	new_wi_state->mode_auto = true;
 	reduce_interleave_weights(bw, new_wi_state->iw_table);
 
-- 
2.20.1
