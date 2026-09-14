Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F653BFAE0
	for <cgroups@vger.kernel.org>; Mon, 14 Sep 2026 07:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371258; cv=none; b=bKsnGiI0bGNwXeEYtGIrmfITRwyrJ3iWof4pgf4KLlTULJtvJnhciS08cjOaSS8aqoe1r92fYn5KENrGRotoT3xJDdjOldIDHzjCANCk3x1fwfXqupgMZHnRU114oeJM0e3oiGlVuKbOHajK3kSJ7fKxcjoTTkNaafYapf90voI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371258; c=relaxed/simple;
	bh=CDWGrBQRxggQBMOm6jYkUOHuxk1F8d6Y8uyRvdQgN6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPVYfUACRgEX2q6dCYHInV0snUg5qKlRFE9OBqyhOt/bhkYhDR59GiB213KIsYH+OefF4SJRkOyqNfJjpJ8q48YjaSZ75DlGvL1FbUBJ06NmYJ6gLG9G8JX9Y8Jqjof9KBe9pMVs1Tj4PJvMojoYrwoCZrAFDXbKfzEzbhO4ZoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Prakp9Td; arc=none smtp.client-ip=91.218.175.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Prakp9Td"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=CDWGrBQRxggQBMOm6jYkUOHuxk1F8d6Y8uyRvdQgN6I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789371253; v=1; x=1789976053;
 b=Prakp9Td4HQDduWmQahNqiBng/9qzEv3nExOIhfnlred0NKKT3I6yUotFoMi7Ap032aoCie4
 kl5C/Fn2sGlW6agAoK3MLhL3rpzI4NWBxmmfwYSVN9jTfZ9scXA3yTHoJ10ZnFw8NTurmQTZwxP
 +TzLhXVYnaNjSsepV9FB/dQY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9fa83c96f83ce1d4;
	Mon, 14 Sep 2026 07:34:12 +0000
X-Mizu-Trace-ID: 9fa83c96f83ce1d4
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
	cuitao@kylinos.cn
Subject: [RFC PATCH v3 1/5] blk-iocost: add BPF struct_ops cost model support
Date: Mon, 14 Sep 2026 15:33:52 +0800
Message-ID: <20260914073356.791518-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914073356.791518-1-cui.tao@linux.dev>
References: <20260914073356.791518-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Add the iocost_model_ops struct_ops: a bound BPF model fully replaces
the builtin linear model on a device.  calc_cost() receives the full
bio->bi_opf (including REQ_PREFLUSH and REQ_FUA), the IO size, the
start sector (sector_t), the issuing blkcg and the iocost-specific call
metadata (the merge-path indicator), and is called from the bio
charging path, so a model owns pricing for every IO on the device.
The completion-time request sizing used for the latency met/missed
accounting still uses the builtin linear coefficients: blk-mq has
already cleared the request's bio by the time the controller sees the
completion, so there is no issuing cgroup to pass to the model at that
point; extending the model to the sizing path is left as an open
question of this interface.  The builtin cursor is not exposed: a model
is expected to track its own stream state.

The registration and binding model follows the TCP congestion
model registration pattern: registering a struct_ops makes the model
available by its name (char name[16], validated at init_member), while
io.cost.model binds one registered model to a device with
"model=<name>" and unbinds with "model=linear" or "ctrl=auto/user".
Unregistering a model removes it from the registry so it can no longer
be selected by name; devices already using the model continue to do so
until switched back to the builtin model.  References are taken with
bpf_struct_ops_get()/put() on the kdata and released when the
device switches back to the builtin model.

calc_cost() runs under RCU read lock; sleepable programs are rejected
in .check_member.  blkcg_online()/blkcg_offline() callbacks mirroring
the blkcg css lifecycle let models manage per-cgroup state.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/Kconfig              |   9 ++
 block/Makefile             |   1 +
 block/blk-cgroup.c         |   3 +
 block/blk-iocost-bpf.c     | 307 +++++++++++++++++++++++++++++++++++++
 block/blk-iocost.c         | 178 +++++++++++++++++++--
 include/linux/blk-iocost.h |  85 ++++++++++
 6 files changed, 568 insertions(+), 15 deletions(-)
 create mode 100644 block/blk-iocost-bpf.c
 create mode 100644 include/linux/blk-iocost.h

diff --git a/block/Kconfig b/block/Kconfig
index 70e4a66d941ff..91e808f86d28d 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -231,4 +231,13 @@ config BLK_ERROR_INJECTION
 
 source "block/Kconfig.iosched"
 
+config BLK_CGROUP_IOCOST_BPF
+	bool "Enable BPF pluggable cost model support for the cost IO controller"
+	depends on BLK_CGROUP_IOCOST && BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF
+	help
+	 Enabling this option registers the "iocost_model_ops" BPF
+	 struct_ops type, which allows a BPF program to fully replace
+	 the builtin linear cost model on a device it is bound to
+	 through io.cost.model.
+
 endif # BLOCK
diff --git a/block/Makefile b/block/Makefile
index e7bd320e3d697..ee5cebeea006f 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o \
 					   blk-crypto-sysfs.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
 obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
+obj-$(CONFIG_BLK_CGROUP_IOCOST_BPF)	+= blk-iocost-bpf.o
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2b5c29434e426..872871045351c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -32,6 +32,7 @@
 #include <linux/part_stat.h>
 #include "blk.h"
 #include "blk-cgroup.h"
+#include <linux/blk-iocost.h>
 #include "blk-ioprio.h"
 #include "blk-throttle.h"
 
@@ -1341,6 +1342,7 @@ void blkcg_unpin_online(struct cgroup_subsys_state *blkcg_css)
  */
 static void blkcg_css_offline(struct cgroup_subsys_state *css)
 {
+	iocost_notify_blkcg_offline(css_to_blkcg(css));
 	/* this prevents anyone from attaching or migrating to this blkcg */
 	wb_blkcg_offline(css);
 
@@ -1445,6 +1447,7 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 
 static int blkcg_css_online(struct cgroup_subsys_state *css)
 {
+	iocost_notify_blkcg_online(css_to_blkcg(css));
 	struct blkcg *parent = blkcg_parent(css_to_blkcg(css));
 
 	/*
diff --git a/block/blk-iocost-bpf.c b/block/blk-iocost-bpf.c
new file mode 100644
index 0000000000000..7ad88600c203a
--- /dev/null
+++ b/block/blk-iocost-bpf.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * blk-iocost: BPF struct_ops plumbing for pluggable cost models.
+ *
+ * Registers the "iocost_model_ops" struct_ops type and maintains the
+ * name registry of registered models.  A registered model is bound to
+ * a device through io.cost.model; see include/linux/blk-iocost.h.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf.h>
+#include <linux/blk-iocost.h>
+
+static DEFINE_MUTEX(iocost_bpf_reg_lock);
+static LIST_HEAD(iocost_bpf_models);
+static LIST_HEAD(iocost_bpf_lifecycle);
+
+/*
+ * The registry holds a bpf_struct_ops_get() reference obtained in .reg;
+ * .unreg drops it, so the kdata of an unregistered model stays alive
+ * while any device is still bound to it.
+ */
+struct iocost_bpf_model {
+	struct list_head	list;		/* name registry */
+	struct list_head	lifecycle;	/* lifecycle notify list */
+	const struct iocost_model_ops *ops;
+	refcount_t		refs;
+};
+
+/*
+ * Look up a registered model by name and acquire a reference on it.
+ * The registry lock is held across lookup and bpf_struct_ops_get() so
+ * the model cannot be unregistered in between.
+ */
+int iocost_bpf_model_get(const char *name,
+			 const struct iocost_model_ops **opsp)
+{
+	struct iocost_bpf_model *m;
+	int ret = -ENOENT;
+
+	mutex_lock(&iocost_bpf_reg_lock);
+	list_for_each_entry(m, &iocost_bpf_models, list) {
+		if (!strcmp(m->ops->name, name)) {
+			if (bpf_struct_ops_get(m->ops)) {
+				refcount_inc(&m->refs);
+				*opsp = m->ops;
+				ret = 0;
+			}
+			break;
+		}
+	}
+	mutex_unlock(&iocost_bpf_reg_lock);
+	return ret;
+}
+
+static struct iocost_bpf_model *
+iocost_bpf_model_lookup(const struct iocost_model_ops *ops)
+{
+	struct iocost_bpf_model *m;
+
+	list_for_each_entry(m, &iocost_bpf_models, list) {
+		if (m->ops == ops)
+			return m;
+	}
+	return NULL;
+}
+
+/*
+ * Lifecycle notifications walk the lifecycle list, which keeps a node
+ * for as long as any device has the model bound, so an unregistered
+ * but still-bound model keeps receiving blkcg online/offline.
+ */
+void iocost_notify_blkcg_online(struct blkcg *blkcg)
+{
+	struct iocost_bpf_model *m;
+
+	guard(mutex)(&iocost_bpf_reg_lock);
+	list_for_each_entry(m, &iocost_bpf_lifecycle, lifecycle) {
+		if (m->ops->blkcg_online)
+			m->ops->blkcg_online(blkcg);
+	}
+}
+
+void iocost_notify_blkcg_offline(struct blkcg *blkcg)
+{
+	struct iocost_bpf_model *m;
+
+	guard(mutex)(&iocost_bpf_reg_lock);
+	list_for_each_entry(m, &iocost_bpf_lifecycle, lifecycle) {
+		if (m->ops->blkcg_offline)
+			m->ops->blkcg_offline(blkcg);
+	}
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
+	switch (func_id) {
+#ifdef CONFIG_CGROUPS
+	case BPF_FUNC_cgrp_storage_get:
+		return &bpf_cgrp_storage_get_proto;
+#endif
+	default:
+		return bpf_base_func_proto(func_id, prog);
+	}
+}
+
+static int bpf_iocost_check_member(const struct btf_type *t,
+				   const struct btf_member *member,
+				   const struct bpf_prog *prog)
+{
+	/* calc_cost() is called with RCU read lock held */
+	if (prog->sleepable)
+		return -EINVAL;
+	return 0;
+}
+
+static int bpf_iocost_init_member(const struct btf_type *t,
+				  const struct btf_member *member,
+				  void *kdata, const void *udata)
+{
+	struct iocost_model_ops *ops = kdata;
+	const struct iocost_model_ops *uops = udata;
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct iocost_model_ops, name):
+		if (bpf_obj_name_cpy(ops->name, uops->name,
+				     sizeof(ops->name)) <= 0)
+			return -EINVAL;
+		return 1;
+	}
+
+	return 0;
+}
+
+static u64 bpf_iocost_calc_cost_stub(u64 opf, u64 nbytes, u64 sector,
+				     struct blkcg *blkcg, u64 model_flags);
+
+/*
+ * kdata is seeded from the CFI stubs, so calc_cost is never NULL; a
+ * model which did not implement it inherits the stub, which prices
+ * every IO at 0.  Compare against the stub to reject it.
+ */
+static int bpf_iocost_validate(void *kdata)
+{
+	struct iocost_model_ops *ops = kdata;
+
+	if (ops->calc_cost == bpf_iocost_calc_cost_stub)
+		return -EINVAL;
+	return 0;
+}
+
+static int bpf_iocost_reg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *ops = kdata;
+	struct iocost_bpf_model *m;
+	int ret = 0;
+
+	if (!bpf_struct_ops_get(ops))
+		return -ENOENT;
+
+	m = kzalloc(sizeof(*m), GFP_KERNEL);
+	if (!m) {
+		bpf_struct_ops_put(ops);
+		return -ENOMEM;
+	}
+	refcount_set(&m->refs, 1);
+
+	mutex_lock(&iocost_bpf_reg_lock);
+	{
+		struct iocost_bpf_model *other;
+
+		list_for_each_entry(other, &iocost_bpf_models, list) {
+			if (!strcmp(other->ops->name, ops->name)) {
+				ret = -EEXIST;
+				break;
+			}
+		}
+	}
+	if (!ret) {
+		m->ops = ops;
+		list_add(&m->list, &iocost_bpf_models);
+		list_add(&m->lifecycle, &iocost_bpf_lifecycle);
+	}
+	mutex_unlock(&iocost_bpf_reg_lock);
+
+	if (ret) {
+		bpf_struct_ops_put(ops);
+		kfree(m);
+	}
+	return ret;
+}
+
+/*
+ * Unregistering drops the registration reference.  When the last
+ * reference is gone (no device bound), the node leaves the lifecycle
+ * list and is freed; otherwise bound devices keep it alive and it
+ * keeps receiving blkcg online/offline notifications.
+ */
+static void bpf_iocost_unreg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *ops = kdata;
+	struct iocost_bpf_model *m;
+
+	mutex_lock(&iocost_bpf_reg_lock);
+	m = iocost_bpf_model_lookup(ops);
+	if (m) {
+		list_del(&m->list);
+		if (refcount_dec_and_test(&m->refs)) {
+			list_del(&m->lifecycle);
+			kfree(m);
+		}
+	}
+	mutex_unlock(&iocost_bpf_reg_lock);
+
+	bpf_struct_ops_put(ops);
+}
+
+void iocost_bpf_model_put(const struct iocost_model_ops *ops)
+{
+	struct iocost_bpf_model *m;
+
+	mutex_lock(&iocost_bpf_reg_lock);
+	list_for_each_entry(m, &iocost_bpf_lifecycle, lifecycle) {
+		if (m->ops == ops)
+			break;
+	}
+	/*
+	 * Exactly one bpf_struct_ops_put() per call, pairing the
+	 * bpf_struct_ops_get() in iocost_bpf_model_get(); the node is
+	 * freed when the last reference goes, whichever side drops it.
+	 */
+	if (&m->lifecycle != &iocost_bpf_lifecycle &&
+	    refcount_dec_and_test(&m->refs)) {
+		list_del(&m->lifecycle);
+		mutex_unlock(&iocost_bpf_reg_lock);
+		kfree(m);
+		bpf_struct_ops_put(ops);
+		return;
+	}
+	mutex_unlock(&iocost_bpf_reg_lock);
+	bpf_struct_ops_put(ops);
+}
+
+static const struct bpf_verifier_ops bpf_iocost_verifier_ops = {
+	.get_func_proto = bpf_iocost_get_func_proto,
+	.is_valid_access = bpf_iocost_is_valid_access,
+};
+
+static u64 bpf_iocost_calc_cost_stub(u64 opf, u64 nbytes, u64 sector,
+				     struct blkcg *blkcg, u64 flags)
+{
+	return 0;
+}
+
+static void bpf_iocost_blkcg_online_stub(struct blkcg *blkcg) { }
+static void bpf_iocost_blkcg_offline_stub(struct blkcg *blkcg) { }
+
+static struct iocost_model_ops __bpf_ops_iocost_model_ops = {
+	.calc_cost = bpf_iocost_calc_cost_stub,
+	.blkcg_online = bpf_iocost_blkcg_online_stub,
+	.blkcg_offline = bpf_iocost_blkcg_offline_stub,
+};
+
+static struct bpf_struct_ops bpf_iocost_model_ops = {
+	.verifier_ops = &bpf_iocost_verifier_ops,
+	.init = bpf_iocost_model_init,
+	.check_member = bpf_iocost_check_member,
+	.init_member = bpf_iocost_init_member,
+	.validate = bpf_iocost_validate,
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
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2745bffcd5eef..3cc21092cf47f 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -177,6 +177,7 @@
 #include <linux/timer.h>
 #include <linux/time64.h>
 #include <linux/parser.h>
+#include <linux/blk-iocost.h>
 #include <linux/sched/signal.h>
 #include <asm/local.h>
 #include <asm/local64.h>
@@ -445,6 +446,11 @@ struct ioc {
 	int				autop_idx;
 	bool				user_qos_params:1;
 	bool				user_cost_model:1;
+
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	/* bound BPF cost model, NULL = builtin linear model */
+	const struct iocost_model_ops	__rcu *model;
+#endif
 };
 
 struct iocg_pcpu_stat {
@@ -2571,10 +2577,28 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 
 static u64 calc_vtime_cost(struct bio *bio, struct ioc_gq *iocg, bool is_merge)
 {
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *model;
 	u64 cost;
 
-	calc_vtime_cost_builtin(bio, iocg, is_merge, &cost);
-	return cost;
+	rcu_read_lock();
+	model = rcu_dereference(iocg->ioc->model);
+	if (model) {
+		cost = model->calc_cost(bio->bi_opf, bio->bi_iter.bi_size,
+					bio->bi_iter.bi_sector,
+					iocg_to_blkg(iocg)->blkcg,
+					is_merge ? IOCOST_COST_F_MERGE : 0);
+		rcu_read_unlock();
+		return min(cost, VTIME_PER_SEC);
+	}
+	rcu_read_unlock();
+#endif
+	{
+		u64 cost;
+
+		calc_vtime_cost_builtin(bio, iocg, is_merge, &cost);
+		return cost;
+	}
 }
 
 static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
@@ -2596,10 +2620,28 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 
 static u64 calc_size_vtime_cost(struct request *rq, struct ioc *ioc)
 {
-	u64 cost;
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *model;
 
-	calc_size_vtime_cost_builtin(rq, ioc, &cost);
-	return cost;
+	rcu_read_lock();
+	model = rcu_dereference(ioc->model);
+	if (model && rq->bio && rq->bio->bi_blkg) {
+		u64 cost;
+
+		cost = model->calc_cost(rq->cmd_flags, blk_rq_bytes(rq),
+					blk_rq_pos(rq),
+					rq->bio->bi_blkg->blkcg, 0);
+		rcu_read_unlock();
+		return min(cost, VTIME_PER_SEC);
+	}
+	rcu_read_unlock();
+#endif
+	{
+		u64 cost;
+
+		calc_size_vtime_cost_builtin(rq, ioc, &cost);
+		return cost;
+	}
 }
 
 enum over_budget_action {
@@ -2900,6 +2942,19 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
 
 	timer_shutdown_sync(&ioc->timer);
 	free_percpu(ioc->pcpu_stat);
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	{
+		const struct iocost_model_ops *model;
+
+		spin_lock_irq(&ioc->lock);
+		model = rcu_dereference_protected(ioc->model,
+					lockdep_is_held(&ioc->lock));
+		rcu_assign_pointer(ioc->model, NULL);
+		spin_unlock_irq(&ioc->lock);
+		if (model)
+			iocost_bpf_model_put(model);
+	}
+#endif
 	kfree(ioc);
 }
 
@@ -3438,12 +3493,30 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
 		return 0;
 
 	spin_lock_irq(&ioc->lock);
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	{
+		const struct iocost_model_ops *model =
+			rcu_dereference_protected(ioc->model,
+					lockdep_is_held(&ioc->lock));
+
+		seq_printf(sf, "%s ctrl=%s model=%s "
+			   "rbps=%llu rseqiops=%llu rrandiops=%llu "
+			   "wbps=%llu wseqiops=%llu wrandiops=%llu\n",
+			   dname, model ? "bpf" :
+				   ioc->user_cost_model ? "user" : "auto",
+			   model ? model->name : "linear",
+			   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS],
+			   u[I_LCOEF_RRANDIOPS], u[I_LCOEF_WBPS],
+			   u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS]);
+	}
+#else
 	seq_printf(sf, "%s ctrl=%s model=linear "
 		   "rbps=%llu rseqiops=%llu rrandiops=%llu "
 		   "wbps=%llu wseqiops=%llu wrandiops=%llu\n",
 		   dname, ioc->user_cost_model ? "user" : "auto",
 		   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS], u[I_LCOEF_RRANDIOPS],
 		   u[I_LCOEF_WBPS], u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS]);
+#endif
 	spin_unlock_irq(&ioc->lock);
 	return 0;
 }
@@ -3457,6 +3530,52 @@ static int ioc_cost_model_show(struct seq_file *sf, void *v)
 	return 0;
 }
 
+/*
+ * Resolve the model name and take a reference on the new model before
+ * anything is applied, so a bad name rejects the whole write.  The
+ * registry lookup takes the registration mutex and must stay outside
+ * ioc->lock.  The returned model is per-write state passed back into
+ * ioc_bpf_model_commit(), which performs the pointer swap under
+ * ioc->lock so concurrent writers cannot interleave a half-applied
+ * configuration, and the caller drops the old model's reference
+ * afterwards.
+ */
+static const struct iocost_model_ops *
+ioc_bpf_model_prepare(const char *name)
+{
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *new = NULL;
+	int ret;
+
+	if (!name[0])
+		return NULL;
+	ret = iocost_bpf_model_get(name, &new);
+	return ret ? ERR_PTR(ret) : new;
+#else
+	return name[0] ? ERR_PTR(-ENOENT) : NULL;
+#endif
+}
+
+/*
+ * Swap in the model returned by ioc_bpf_model_prepare().  Called with
+ * ioc->lock held; dropping the old model's reference may sleep, so
+ * the caller does it after releasing the lock.
+ */
+static const struct iocost_model_ops *
+ioc_bpf_model_commit(struct ioc *ioc, const struct iocost_model_ops *new)
+{
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *old;
+
+	old = rcu_dereference_protected(ioc->model,
+					lockdep_is_held(&ioc->lock));
+	rcu_assign_pointer(ioc->model, new);
+	return old;
+#else
+	return NULL;
+#endif
+}
+
 static const match_table_t cost_ctrl_tokens = {
 	{ COST_CTRL,		"ctrl=%s"	},
 	{ COST_MODEL,		"model=%s"	},
@@ -3482,6 +3601,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	struct ioc *ioc;
 	u64 u[NR_I_LCOEFS];
 	bool user;
+	char bpf_model[IOCOST_MODEL_NAME_LEN];
 	char *body, *p;
 	int ret;
 
@@ -3512,6 +3632,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	spin_lock_irq(&ioc->lock);
 	memcpy(u, ioc->params.i_lcoefs, sizeof(u));
 	user = ioc->user_cost_model;
+	bpf_model[0] = '\0';
 
 	ret = -EINVAL;
 
@@ -3533,11 +3654,16 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 				user = true;
 			else
 				goto unlock;
+			bpf_model[0] = '\0';
 			continue;
 		case COST_MODEL:
 			match_strlcpy(buf, &args[0], sizeof(buf));
-			if (strcmp(buf, "linear"))
-				goto unlock;
+			if (!strcmp(buf, "linear")) {
+				/* back to the builtin linear model */
+				bpf_model[0] = '\0';
+				continue;
+			}
+			match_strlcpy(bpf_model, &args[0], sizeof(bpf_model));
 			continue;
 		}
 
@@ -3550,19 +3676,41 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 		user = true;
 	}
 
-	if (user) {
-		memcpy(ioc->params.i_lcoefs, u, sizeof(u));
-		ioc->user_cost_model = true;
-	} else {
-		ioc->user_cost_model = false;
-	}
-	ioc_refresh_params(ioc, true);
-
 	ret = 0;
 
 unlock:
 	spin_unlock_irq(&ioc->lock);
 
+	/*
+	 * Resolve the model name outside ioc->lock (the registry lookup
+	 * takes a mutex), so a bad name rejects the whole write before
+	 * anything is applied.  The resolved model is this write's own
+	 * state, not per-device state, so concurrent writers cannot
+	 * clobber each other's staged model.  On success, re-take the
+	 * lock to apply the coefficients and swap the model in one go.
+	 */
+	if (!ret) {
+		const struct iocost_model_ops *new, *old;
+
+		new = ioc_bpf_model_prepare(bpf_model);
+		if (IS_ERR(new)) {
+			ret = PTR_ERR(new);
+		} else {
+			spin_lock_irq(&ioc->lock);
+			if (user) {
+				memcpy(ioc->params.i_lcoefs, u, sizeof(u));
+				ioc->user_cost_model = true;
+			} else {
+				ioc->user_cost_model = false;
+			}
+			ioc_refresh_params(ioc, true);
+			old = ioc_bpf_model_commit(ioc, new);
+			spin_unlock_irq(&ioc->lock);
+			if (IS_ENABLED(CONFIG_BLK_CGROUP_IOCOST_BPF) && old)
+				iocost_bpf_model_put(old);
+		}
+	}
+
 	blk_mq_unquiesce_queue(q);
 	blk_mq_unfreeze_queue(q, memflags);
 
diff --git a/include/linux/blk-iocost.h b/include/linux/blk-iocost.h
new file mode 100644
index 0000000000000..d4bd2b0c826b3
--- /dev/null
+++ b/include/linux/blk-iocost.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BLK_IOCOST_H
+#define _LINUX_BLK_IOCOST_H
+
+#include <linux/types.h>
+#include <linux/blk_types.h>
+
+#define IOCOST_MODEL_NAME_LEN	16
+
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+
+struct blkcg;
+
+/*
+ * Pluggable cost model interface for blk-iocost.
+ *
+ * A BPF struct_ops implementation registered against "iocost_model_ops"
+ * fully replaces the builtin linear model on the devices it is bound to
+ * through io.cost.model.  The model owns pricing for every IO on a bound
+ * device: it prices all operations, including flushes, and it is called
+ * from the bio charging path.  The completion-time request sizing for
+ * the latency met/missed accounting still uses the builtin coefficients
+ * (the request's bio, and with it the issuing cgroup, is gone by then);
+ * extending the model there is an open question of this interface.
+ *
+ * calc_cost() is called from the IO submission path with RCU read lock
+ * held and must not sleep.  It returns the cost of the IO in vtime
+ * units, where 1 second of device time equals VTIME_PER_SEC (2^37,
+ * available to BPF programs through vmlinux.h).  The returned value is
+ * clamped to 1 second of device time per IO.
+ *
+ * The model is passed the blkcg of the issuing cgroup so it can keep
+ * per-cgroup state.  State keyed by the blkcg alone is shared across
+ * every device the model is bound to, unlike the builtin cursor which
+ * is per (cgroup, device).  blkcg_online()/blkcg_offline() are optional
+ * callbacks mirroring the blkcg css lifecycle: state created on online
+ * (or lazily on first use) must be released on offline.
+ *
+ * The registration and binding model follows the TCP congestion
+ * control framework: registering a struct_ops makes the model available
+ * by its name, while io.cost.model binds one registered model to a
+ * device.  Unregistering removes the name from the registry; devices
+ * already bound keep using it until switched back to the builtin
+ * model.
+ */
+
+/*
+ * iocost-specific call metadata for calc_cost()'s model_flags
+ * argument; everything else, including REQ_PREFLUSH/REQ_FUA, is
+ * already present in the opf argument
+ */
+#define IOCOST_COST_F_MERGE	(1ULL << 0)	/* called from merge path */
+
+struct iocost_model_ops {
+	u64 (*calc_cost)(u64 opf, u64 nbytes, sector_t sector,
+			 struct blkcg *blkcg, u64 model_flags);
+	void (*blkcg_online)(struct blkcg *blkcg);
+	void (*blkcg_offline)(struct blkcg *blkcg);
+
+	/* model name, used to select the model through io.cost.model */
+	char name[16];
+};
+
+int iocost_bpf_model_get(const char *name,
+			 const struct iocost_model_ops **opsp);
+void iocost_bpf_model_put(const struct iocost_model_ops *ops);
+void iocost_notify_blkcg_online(struct blkcg *blkcg);
+void iocost_notify_blkcg_offline(struct blkcg *blkcg);
+
+#else	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+
+struct blkcg;
+struct iocost_model_ops;
+
+static inline int iocost_bpf_model_get(const char *name,
+				       const struct iocost_model_ops **opsp)
+{
+	return -EOPNOTSUPP;
+}
+static inline void iocost_bpf_model_put(const struct iocost_model_ops *ops) { }
+static inline void iocost_notify_blkcg_online(struct blkcg *blkcg) { }
+static inline void iocost_notify_blkcg_offline(struct blkcg *blkcg) { }
+
+#endif	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+#endif	/* _LINUX_BLK_IOCOST_H */
-- 
2.43.0

