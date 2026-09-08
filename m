Received: from mta1.migadu.com (out-11.mta1.migadu.com [95.215.58.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68A74D2EDA
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 10:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861759; cv=none; b=V74BZbV+F2Y6lPMKpwRIRHAwoMS+TnYCeEcBvhlyp56XKV/Z2+RWchjIZTFXbHTAAbfjvRYV97jTWCzgbTtM3eJOd057UgFBhKAP2sQbS32VFPyeg6JNZivapmclVPjbHmYFGCimkFgF+Q/V5MJWMyDed52dgPhBCf7uROzL4P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861759; c=relaxed/simple;
	bh=wWqqyXxBeroIFBeIbRhs73ts8SnHGnu+jeiXZcy34Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvL+zcgqNjSzlpcdFq0uoqIogf5b3muPozy8CEB76/x9pJE4hxLlW44AGYPnkqO3l9vQSoqglwL9HECwQX205qVq7EoNvTFeS+n1rYCyH3PaBNyOPkkSRxAFvTZugABlBQ6HAwCNl872eozl6V0KXTqEGW1E+L5r9s8Y3CUZKvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BBPg2zbv; arc=none smtp.client-ip=95.215.58.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BBPg2zbv"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wWqqyXxBeroIFBeIbRhs73ts8SnHGnu+jeiXZcy34Mk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788861755; v=1; x=1789466555;
 b=BBPg2zbvP4e7oWrVOPTSaJmbIJ57mrXJ7/08yRBMg1dCllozSjG5wr7EaDQSRebu/V0N2O4t
 R74RMiTVf9NIjJHjwQx8jDtYl5aUf9nalTsVq3MzlTnSXjfYQzm2RwO9Mu19/BZOcwzF1HmpHYT
 lDw8GtuCiWoaOEYiQaFl3DtM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e2c0af394d354957;
	Tue, 08 Sep 2026 10:02:35 +0000
X-Mizu-Trace-ID: e2c0af394d354957
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	andrii@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [RFC PATCH 3/8] blk-iocost: implement BPF struct_ops registration
Date: Tue,  8 Sep 2026 18:01:38 +0800
Message-ID: <20260908100143.47598-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908100143.47598-1-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Register the iocost_model_ops struct_ops type: at most one model
system-wide (EBUSY otherwise), called under RCU from the submit/merge
path.  Registration and unregistration are serialized with a mutex
because the caller only holds the per-map lock.  Includes the
verifier ops, CFI stubs and late_initcall registration.  A model
returning 0 makes the caller fall back to the builtin formula, which
keeps a partial model from making the IO types it does not handle
free.

The verifier allows the base helper set, so models can use maps for
per-cgroup state keyed by iocg_id.  The model runs in the submit path
under RCU and must not sleep.

No code calls the registered model yet; the dispatch hook follows.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/Makefile         |   1 +
 block/blk-iocost-bpf.c | 152 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 153 insertions(+)
 create mode 100644 block/blk-iocost-bpf.c

diff --git a/block/Makefile b/block/Makefile
index e7bd320e3d697..ee5cebeea006f 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o \
 					   blk-crypto-sysfs.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
 obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
+obj-$(CONFIG_BLK_CGROUP_IOCOST_BPF)	+= blk-iocost-bpf.o
diff --git a/block/blk-iocost-bpf.c b/block/blk-iocost-bpf.c
new file mode 100644
index 0000000000000..0c34f56ded71d
--- /dev/null
+++ b/block/blk-iocost-bpf.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Tao Cui */
+
+/*
+ * blk-iocost: BPF struct_ops plumbing for pluggable cost models.
+ *
+ * Registers the "iocost_model_ops" struct_ops type.  At most one model
+ * can be registered at a time; devices opt in per-queue with
+ * "echo $DEV ctrl=bpf > io.cost.model".  Devices without a registered
+ * model keep using the builtin linear model.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf.h>
+#include <linux/blk-iocost.h>
+
+/* 1s of device time; upper bound on a single IO's chargeable cost */
+#define IOCOST_BPF_MAX_COST	(1ULL << 37)
+
+static struct bpf_struct_ops bpf_iocost_model_ops;
+
+static DEFINE_MUTEX(iocost_bpf_reg_lock);
+static struct iocost_model_ops __rcu *iocost_bpf_model;
+static DEFINE_STATIC_KEY_FALSE(iocost_bpf_key);
+
+bool iocost_bpf_model_registered(void)
+{
+	return static_branch_unlikely(&iocost_bpf_key);
+}
+
+bool iocost_bpf_calc_cost(u64 op, u64 nbytes, u64 sector, u64 cursor,
+			  u64 iocg_id, u64 flags, u64 *costp)
+{
+	const struct iocost_model_ops *ops;
+	u64 cost;
+
+	if (!static_branch_unlikely(&iocost_bpf_key))
+		return false;
+
+	rcu_read_lock();
+	ops = rcu_dereference(iocost_bpf_model);
+	if (!ops) {
+		rcu_read_unlock();
+		return false;
+	}
+	cost = ops->calc_cost(op, nbytes, sector, cursor, iocg_id, flags);
+	rcu_read_unlock();
+
+	if (!cost)
+		return false;
+
+	*costp = min(cost, IOCOST_BPF_MAX_COST);
+	return true;
+}
+
+static int bpf_iocost_model_init(struct btf *btf)
+{
+	s32 type_id;
+
+	type_id = btf_find_by_name_kind(btf, "iocost_model_ops", BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int bpf_iocost_init_member(const struct btf_type *t,
+				  const struct btf_member *member,
+				  void *kdata, const void *udata)
+{
+	return 0;
+}
+
+static bool bpf_iocost_is_valid_access(int off, int size,
+				       enum bpf_access_type type,
+				       const struct bpf_prog *prog,
+				       struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static const struct bpf_func_proto *
+bpf_iocost_get_func_proto(enum bpf_func_id func_id,
+			  const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id, prog);
+}
+
+static const struct bpf_verifier_ops bpf_iocost_verifier_ops = {
+	.get_func_proto = bpf_iocost_get_func_proto,
+	.is_valid_access = bpf_iocost_is_valid_access,
+};
+
+static int bpf_iocost_reg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *new_ops = kdata;
+
+	if (!new_ops->calc_cost)
+		return -EINVAL;
+
+	int ret = 0;
+
+	/* the caller only holds the per-map lock, so serialize here */
+	mutex_lock(&iocost_bpf_reg_lock);
+	if (rcu_access_pointer(iocost_bpf_model))
+		ret = -EBUSY;
+	else {
+		static_branch_inc(&iocost_bpf_key);
+		rcu_assign_pointer(iocost_bpf_model, new_ops);
+	}
+	mutex_unlock(&iocost_bpf_reg_lock);
+	return ret;
+}
+
+static void bpf_iocost_unreg(void *kdata, struct bpf_link *link)
+{
+	mutex_lock(&iocost_bpf_reg_lock);
+	if (rcu_access_pointer(iocost_bpf_model) == kdata) {
+		rcu_assign_pointer(iocost_bpf_model, NULL);
+		static_branch_dec(&iocost_bpf_key);
+	}
+	mutex_unlock(&iocost_bpf_reg_lock);
+}
+
+static u64 bpf_iocost_calc_cost_stub(u64 op, u64 nbytes, u64 sector,
+				     u64 cursor, u64 iocg_id, u64 flags)
+{
+	return 0;
+}
+
+static struct iocost_model_ops __bpf_ops_iocost_model_ops = {
+	.calc_cost = bpf_iocost_calc_cost_stub,
+};
+
+static struct bpf_struct_ops bpf_iocost_model_ops = {
+	.verifier_ops = &bpf_iocost_verifier_ops,
+	.init = bpf_iocost_model_init,
+	.init_member = bpf_iocost_init_member,
+	.reg = bpf_iocost_reg,
+	.unreg = bpf_iocost_unreg,
+	.name = "iocost_model_ops",
+	.cfi_stubs = &__bpf_ops_iocost_model_ops,
+	.owner = THIS_MODULE,
+};
+
+static int __init bpf_iocost_init(void)
+{
+	return register_bpf_struct_ops(&bpf_iocost_model_ops, iocost_model_ops);
+}
+late_initcall(bpf_iocost_init);
-- 
2.43.0

