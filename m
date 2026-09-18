Received: from mta0.migadu.com (out-211.mta0.migadu.com [91.218.175.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8CF371876
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 03:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789701495; cv=none; b=d6/pbXmZvjQhUbfiyS+vqkdwNcCpNXfW3IdlV5utKEJHOleQJmPC4qcMf3+gpa7c6DgdTWNJj2iR9eEh3Obz1BuP2O5p9dGaQUW90ARYo41KsUvRNVH8ev7thsIdY19fR0N9OE3WWmT0lWq86QwcwY8OA+vbdRgtpUPf/5cEOpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789701495; c=relaxed/simple;
	bh=kTRhSr7IgBJbRF0OML7hly4ii11GWfcSHiQutzXx17A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbruvnxB4FzexcwJ4N62yIkkNSbN5+KDcncvLoZpnhAnXKjMFWPwLSb3MpL8qYXlshioPPoXSHBng2sPjbfEai51Cuf0owWcN8YHJ0NRUNLVDDUHmySsUMOPzUnghXKzHEGAB7/nNV/BBCQriVqtkYw5VICAQBP9n8DZ/zIU2fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AfU6q5kn; arc=none smtp.client-ip=91.218.175.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AfU6q5kn"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kTRhSr7IgBJbRF0OML7hly4ii11GWfcSHiQutzXx17A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789701489; v=1; x=1790306289;
 b=AfU6q5knVxfIB9FzZl62B2MRrlat7ZEtj2gogKJjoOngfJFEpmStzx6h5tmW8eEnCDv7Ta4S
 iapCbuVXWsWJYvMgV2VrIBEygEZONlBStjvuTyGmmTZ85YhWzvBuVZV0wuW3MRwC4gdedwbpu1G
 T7dO9Ss+yQTzc0+v8XB8ZjQk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id df278f935da20b53;
	Fri, 18 Sep 2026 03:18:09 +0000
X-Mizu-Trace-ID: df278f935da20b53
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	ameryhung@gmail.com
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	andrii@kernel.org,
	eddyz87@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [RFC PATCH v5 1/5] blk-iocost: add BPF struct_ops cost model support
Date: Fri, 18 Sep 2026 11:17:47 +0800
Message-ID: <20260918031751.1255420-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918031751.1255420-1-cui.tao@linux.dev>
References: <20260918031751.1255420-1-cui.tao@linux.dev>
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
point; extending the model to the sizing path is left open
by this interface.  The builtin cursor is not exposed: a model
is expected to track its own stream state.

The registration and binding model follows the TCP congestion
model registration pattern: registering a struct_ops makes the model
available by its name (char name[IOCOST_MODEL_NAME_LEN], validated at
init_member), while
io.cost.model binds one registered model to a device with
"model=<name>" and unbinds with "model=linear" or "ctrl=auto/user".
Unregistering a model removes it from the registry, but its name
keeps working for io.cost.model writes until the last device unbinds,
so a coefficient-only write on a device using an unregistered model
keeps it bound instead of failing with ENOENT.  The struct_ops core holds a
map reference while the model is registered, so .reg/.unreg take no
extra reference; each device binding takes one with
bpf_struct_ops_get() and releases it when the device switches back to
the builtin model, which keeps the kdata of an unregistered but
still-bound model alive.

calc_cost() runs under RCU read lock; sleepable programs are rejected
in .check_member.  blkcg_online()/blkcg_offline() callbacks mirroring
the blkcg css lifecycle let models manage per-cgroup state; a model
receives these notifications exactly while at least one device has it
bound, not while it is merely registered.

- a model which does not implement calc_cost is rejected at load:
  kvalue is zeroed at map allocation and function members are only
  written when the BPF side provides a prog, so the missing member
  stays NULL and the dispatch would call it on every bio
- the builtin model keeps the reserved name "linear" (model=linear
  unbinds), so a BPF model registering under that name is rejected
- io.cost.model writes preserve the bound model: bpf_model is seeded
  from the currently bound model so a coefficient-only write keeps it
  bound; ctrl=auto/user and model=linear are the explicit ways back
  to the builtin model
- ctrl=bpf is accepted on write (it is what the read path prints),
  so a saved configuration can be restored as-is

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/Kconfig              |   9 ++
 block/Makefile             |   1 +
 block/blk-cgroup.c         |   4 +
 block/blk-iocost-bpf.c     | 321 +++++++++++++++++++++++++++++++++++++
 block/blk-iocost.c         | 204 ++++++++++++++++++++---
 include/linux/blk-iocost.h |  86 ++++++++++
 6 files changed, 607 insertions(+), 18 deletions(-)
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
index b56db1cc6778f..b08ceb94a281b 100644
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
 
@@ -1447,6 +1449,8 @@ static int blkcg_css_online(struct cgroup_subsys_state *css)
 {
 	struct blkcg *parent = blkcg_parent(css_to_blkcg(css));
 
+	iocost_notify_blkcg_online(css_to_blkcg(css));
+
 	/*
 	 * blkcg_pin_online() is used to delay blkcg offline so that blkgs
 	 * don't go offline while cgwbs are still active on them.  Pin the
diff --git a/block/blk-iocost-bpf.c b/block/blk-iocost-bpf.c
new file mode 100644
index 0000000000000..444ca52ed0b08
--- /dev/null
+++ b/block/blk-iocost-bpf.c
@@ -0,0 +1,321 @@
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
+ * One node per registered model.  refcount: 1 while registered
+ * (dropped in .unreg) plus one per bound device (dropped in
+ * iocost_bpf_model_put(), which pairs its bpf_struct_ops_get(), so the
+ * kdata of an unregistered model stays alive while any device is still
+ * bound to it).  The node sits on the lifecycle notify list exactly
+ * while at least one device has the model bound.
+ */
+struct iocost_bpf_model {
+	struct list_head	list;		/* name registry */
+	struct list_head	lifecycle;	/* lifecycle notify list */
+	const struct iocost_model_ops *ops;
+	refcount_t		refs;
+};
+
+/*
+ * Take a name and acquire a binding reference on the model it selects.
+ * The registry is searched first; a model which is unregistered but
+ * still bound to a device remains selectable by name until the last
+ * device unbinds, so a coefficient-only write on such a device keeps
+ * the model bound instead of failing with ENOENT.  The registry lock
+ * is held across the lookup and bpf_struct_ops_get() so the model
+ * cannot be unregistered in between.  Returns the ops or an ERR_PTR.
+ */
+const struct iocost_model_ops *iocost_bpf_model_get(const char *name)
+{
+	struct iocost_bpf_model *m;
+	const struct iocost_model_ops *ops = ERR_PTR(-ENOENT);
+
+	mutex_lock(&iocost_bpf_reg_lock);
+	list_for_each_entry(m, &iocost_bpf_models, list) {
+		if (!strcmp(m->ops->name, name))
+			goto found;
+	}
+	list_for_each_entry(m, &iocost_bpf_lifecycle, lifecycle) {
+		if (!strcmp(m->ops->name, name))
+			goto found;
+	}
+	mutex_unlock(&iocost_bpf_reg_lock);
+	return ops;
+found:
+	if (bpf_struct_ops_get(m->ops)) {
+		refcount_inc(&m->refs);
+		/* first bind: join the notify list */
+		if (refcount_read(&m->refs) == 2 &&
+		    list_empty(&m->lifecycle))
+			list_add(&m->lifecycle, &iocost_bpf_lifecycle);
+		ops = m->ops;
+	}
+	mutex_unlock(&iocost_bpf_reg_lock);
+	return ops;
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
+/*
+ * No iocost-specific helpers; bpf_base_func_proto already covers the
+ * cgroup storage helpers under CONFIG_CGROUPS.
+ */
+static const struct bpf_func_proto *
+bpf_iocost_get_func_proto(enum bpf_func_id func_id,
+			  const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id, prog);
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
+/*
+ * kvalue is zeroed at map allocation and function members are only
+ * written when the BPF side provides a prog, so a model which did
+ * not implement calc_cost leaves it NULL.  The dispatch would call
+ * it on every bio, so reject it here.
+ */
+static int bpf_iocost_validate(void *kdata)
+{
+	struct iocost_model_ops *ops = kdata;
+
+	if (!ops->calc_cost)
+		return -EINVAL;
+	/* "linear" is the builtin model; model=linear unbinds */
+	if (!strcmp(ops->name, "linear"))
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * The struct_ops core holds a reference on the map while the model is
+ * registered, so kdata stays valid until .unreg returns; no extra
+ * reference is needed here.
+ */
+static int bpf_iocost_reg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *ops = kdata;
+	struct iocost_bpf_model *m;
+	int ret = 0;
+
+	m = kzalloc_obj(struct iocost_bpf_model, GFP_KERNEL);
+	if (!m)
+		return -ENOMEM;
+	refcount_set(&m->refs, 1);
+	INIT_LIST_HEAD(&m->lifecycle);
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
+	}
+	mutex_unlock(&iocost_bpf_reg_lock);
+
+	if (ret)
+		kfree(m);
+	return ret;
+}
+
+/*
+ * Unregistering drops the registration reference.  If a device is
+ * still bound, the binding references keep the node (and the kdata,
+ * through their bpf_struct_ops_get()) alive and it keeps receiving
+ * blkcg online/offline notifications; otherwise the node is freed.
+ */
+static void bpf_iocost_unreg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *ops = kdata;
+	struct iocost_bpf_model *m;
+
+	mutex_lock(&iocost_bpf_reg_lock);
+	m = iocost_bpf_model_lookup(ops);
+	if (m) {
+		/*
+		 * keep the linkage queryable so model_put() can tell a
+		 * still-registered node (one ref held by the registry)
+		 * from one kept alive only by device bindings
+		 */
+		list_del_init(&m->list);
+		if (refcount_dec_and_test(&m->refs))
+			kfree(m);
+	}
+	mutex_unlock(&iocost_bpf_reg_lock);
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
+	if (&m->lifecycle != &iocost_bpf_lifecycle) {
+		bool freed = refcount_dec_and_test(&m->refs);
+
+		/*
+		 * leave the notify list with the last binding: refs is
+		 * now zero (node freed) or the registry's single one
+		 */
+		if (freed || (!list_empty(&m->list) &&
+			      refcount_read(&m->refs) == 1))
+			list_del_init(&m->lifecycle);
+		mutex_unlock(&iocost_bpf_reg_lock);
+		bpf_struct_ops_put(ops);
+		if (freed)
+			kfree(m);
+		return;
+	}
+	mutex_unlock(&iocost_bpf_reg_lock);
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
index 2745bffcd5eef..c4e8c8e09bf23 100644
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
@@ -3457,6 +3530,48 @@ static int ioc_cost_model_show(struct seq_file *sf, void *v)
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
+	if (!name[0])
+		return NULL;
+	return iocost_bpf_model_get(name);
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
@@ -3482,6 +3597,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	struct ioc *ioc;
 	u64 u[NR_I_LCOEFS];
 	bool user;
+	char bpf_model[IOCOST_MODEL_NAME_LEN];
 	char *body, *p;
 	int ret;
 
@@ -3512,6 +3628,25 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	spin_lock_irq(&ioc->lock);
 	memcpy(u, ioc->params.i_lcoefs, sizeof(u));
 	user = ioc->user_cost_model;
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	{
+		const struct iocost_model_ops *model =
+			rcu_dereference_protected(ioc->model,
+					lockdep_is_held(&ioc->lock));
+
+		/*
+		 * seed from the bound model so a coefficient-only write
+		 * keeps it bound; ctrl=auto/user and model=linear are
+		 * the explicit ways back to the builtin model
+		 */
+		if (model)
+			strscpy(bpf_model, model->name, sizeof(bpf_model));
+		else
+			bpf_model[0] = '\0';
+	}
+#else
+	bpf_model[0] = '\0';
+#endif
 
 	ret = -EINVAL;
 
@@ -3527,17 +3662,27 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 		switch (match_token(p, cost_ctrl_tokens, args)) {
 		case COST_CTRL:
 			match_strlcpy(buf, &args[0], sizeof(buf));
-			if (!strcmp(buf, "auto"))
+			if (!strcmp(buf, "auto")) {
 				user = false;
-			else if (!strcmp(buf, "user"))
+			} else if (!strcmp(buf, "user")) {
 				user = true;
-			else
+			} else if (!strcmp(buf, "bpf")) {
+				/* readback value; keep the bound model */
+				continue;
+			} else {
 				goto unlock;
+			}
+			/* ctrl=auto/user: explicit return to builtin */
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
 
@@ -3550,19 +3695,42 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
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
 
+	/* resolve the name outside ioc->lock; see ioc_bpf_model_prepare() */
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
+			if (IS_ENABLED(CONFIG_BLK_CGROUP_IOCOST_BPF) && old) {
+				iocost_bpf_model_put(old);
+				/*
+				 * a racing writer may have committed the same
+				 * model after we resolved it; our resolved
+				 * reference is then redundant
+				 */
+				if (old == new)
+					iocost_bpf_model_put(new);
+			}
+		}
+	}
+
 	blk_mq_unquiesce_queue(q);
 	blk_mq_unfreeze_queue(q, memflags);
 
diff --git a/include/linux/blk-iocost.h b/include/linux/blk-iocost.h
new file mode 100644
index 0000000000000..e6dc6772ef5c9
--- /dev/null
+++ b/include/linux/blk-iocost.h
@@ -0,0 +1,86 @@
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
+ * extending the model there is left open by this interface.
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
+ * callbacks mirroring the blkcg css lifecycle: they are delivered
+ * only while at least one device has the model bound, and state
+ * created on online (or lazily on first use) must be released on
+ * offline.
+ *
+ * The registration and binding model follows the TCP congestion
+ * control framework: registering a struct_ops makes the model available
+ * by its name, while io.cost.model binds one registered model to a
+ * device.  Unregistering removes the name from the registry; devices
+ * already bound keep using it until switched back to the builtin
+ * model, and the name remains usable for io.cost.model writes (so a
+ * coefficient-only write keeps such a model bound) until the last
+ * device unbinds.
+ */
+
+/*
+ * iocost-specific call metadata for calc_cost()'s model_flags
+ * argument; everything else, including REQ_PREFLUSH/REQ_FUA, is
+ * already present in the opf argument.  An enum so the value is
+ * exported through BTF and BPF models can use it from vmlinux.h.
+ */
+enum {
+	IOCOST_COST_F_MERGE	= 1 << 0,	/* called from merge path */
+};
+
+struct iocost_model_ops {
+	u64 (*calc_cost)(u64 opf, u64 nbytes, sector_t sector,
+			 struct blkcg *blkcg, u64 model_flags);
+	void (*blkcg_online)(struct blkcg *blkcg);
+	void (*blkcg_offline)(struct blkcg *blkcg);
+
+	/* model name, used to select the model through io.cost.model */
+	char name[IOCOST_MODEL_NAME_LEN];
+};
+
+const struct iocost_model_ops *iocost_bpf_model_get(const char *name);
+void iocost_bpf_model_put(const struct iocost_model_ops *ops);
+void iocost_notify_blkcg_online(struct blkcg *blkcg);
+void iocost_notify_blkcg_offline(struct blkcg *blkcg);
+
+#else	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+
+struct blkcg;
+struct iocost_model_ops;
+
+static inline void iocost_bpf_model_put(const struct iocost_model_ops *ops) { }
+static inline void iocost_notify_blkcg_online(struct blkcg *blkcg) { }
+static inline void iocost_notify_blkcg_offline(struct blkcg *blkcg) { }
+
+#endif	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+#endif	/* _LINUX_BLK_IOCOST_H */
-- 
2.43.0

