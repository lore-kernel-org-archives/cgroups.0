Received: from mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D17D424649
	for <cgroups@vger.kernel.org>; Sat,  3 Oct 2026 12:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791031283; cv=none; b=FJtOyrdNTgt0uRtzBvb1P/SY1R2ndvYWNpU8FqD+7XSDVwS8sRze4uevhu+ygvn7tAT32jkNZjY0ah5W+1taJCVRd14xc3MTCYBxwGgCwQexzonySC/jayrw1Ez6Ry7O+TAyz2AMt4VK0x439Ri5qKXdCM8GthRjf3oBPqIUfAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791031283; c=relaxed/simple;
	bh=D7DYPHSvIRNLonN7vEWYGn45w79K7/kBAHPEGcGCUlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHSEJHPrzPt/qUhYeoumxcNcxXFHS3hWVSJdTMugJ+ej/9aYR2WOdf9ainnCtyq7iwt6Pu2xYXDSNv2OTN27ndCE7Gom6gSPgPdAZd9R0MVarEte54S04qgRLriR58+/y2ourc970NFEefETp31b9NfO906gzk6epJCH5PfBBbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UjkfPxZT; arc=none smtp.client-ip=95.215.58.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UjkfPxZT"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=D7DYPHSvIRNLonN7vEWYGn45w79K7/kBAHPEGcGCUlY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791031277; v=1; x=1791636077;
 b=UjkfPxZTc3bKdSWK9gfsIsKGxo5A/dczOrlmEAjAgX7RZJh/XIQtweKPg8qMiBa4stOWFrM/
 dixnCk0mst3WrMqnacXp1IolrXCOmeY6X7QcR7YWJZz5MyGBO8TS6gQ7/I980yjuals1NN8iSlu
 J2ZUGgVO2LJQdZAiXx0h4IEQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8c66eb5da0bffaca;
	Sat, 03 Oct 2026 12:41:17 +0000
X-Mizu-Trace-ID: 8c66eb5da0bffaca
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
	eddyz87@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn,
	ameryhung@gmail.com,
	alexei.starovoitov@gmail.com
Subject: [RFC PATCH v10 1/4] blk-iocost: add BPF struct_ops cost model support
Date: Sat,  3 Oct 2026 20:40:42 +0800
Message-ID: <20261003124045.1289305-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261003124045.1289305-1-cui.tao@linux.dev>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iocost prices IO with a linear model derived from a handful of
device parameters.  The model is reasonable for common device classes,
but the real cost of an IO depends on device internals the linear
formula cannot capture (write amplification, GC, compression, cache
behavior), and the right formula is device specific.  This lets a BPF
program take over pricing for a device, so the formula can be adapted
to the device and updated without rebuilding the kernel.

An iocost_model_ops struct_ops is attached to one device: the target
device is set in the dev member from userspace before load and .reg
attaches the model to it, creating the ioc if needed, like an
io.cost.model write does, and switching the device to the model under
the same queue freeze and quiesce those writes go through.
io.cost.model selects between the attached model and the builtin one:
"model=bpf" switches to the attached model, "model=linear" back to
the builtin coefficients; neither detaches the struct_ops, and only
.unreg or device removal does.  Enabling and disabling the controller
stays with io.cost.qos.

While the BPF model is the one in use, it prices every charged IO:
calc_cost() is called from the IO submission path with RCU read lock
held, receives the bio itself and returns the cost in vtime units,
clamped to one second of device time per IO.  IOs which are never
charged, root cgroup IOs and IOs while the controller is disabled,
do not reach it.  The struct_ops also carries the transfer cost
coefficients, vtime per page for reads and writes, which the
completion-time request sizing of READ and WRITE requests uses, so
the latency tracking and vrate adjustment follow the model's
pricing for those requests.

The cgroup callbacks are bound to the iocg policy lifetime, one
(cgroup, device) pair per invocation: iocg_init() is delivered on
attach to every cgroup which already has a blkg on the device and to
each one appearing afterwards, iocg_free() on detach to every cgroup
still existing then, and at policy deactivation time for the rest, so
init and free pair up, except for a blkg whose radix_tree_insert()
failed inside blkg_create(): it had iocg_init() delivered but never
reaches the blkg list, so the detach walk misses it and iocg_free()
may not be delivered.  The attach and detach paths walk the
blkg list under blkcg_mutex and queue_lock, which is what blkg
creation and destruction synchronize on; device removal only clears
the attachment, as the policy deactivation which precedes it has
already delivered the remaining iocg_free() calls.

Device removal ejects the model completely, and .unreg only detaches
when the link which owns the attachment is closed, so a map
re-attached to a new device through a newer link is not torn down by
an old one.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/Kconfig              |  10 +
 block/Makefile             |   1 +
 block/blk-core.c           |  16 ++
 block/blk-iocost-bpf.c     | 184 +++++++++++++++
 block/blk-iocost.c         | 459 ++++++++++++++++++++++++++++++++++++-
 block/blk.h                |   1 +
 include/linux/blk-iocost.h | 126 ++++++++++
 7 files changed, 789 insertions(+), 8 deletions(-)
 create mode 100644 block/blk-iocost-bpf.c
 create mode 100644 include/linux/blk-iocost.h

diff --git a/block/Kconfig b/block/Kconfig
index 70e4a66d941ff..1cafc1bd0dda3 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -231,4 +231,14 @@ config BLK_ERROR_INJECTION
 
 source "block/Kconfig.iosched"
 
+config BLK_CGROUP_IOCOST_BPF
+	bool "Enable BPF pluggable cost model support for the cost IO controller"
+	depends on BLK_CGROUP_IOCOST && BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF
+	help
+	 Enabling this option registers the "iocost_model_ops" BPF
+	 struct_ops type, which allows a BPF program to fully replace
+	 the builtin linear cost model on the device it is attached
+	 to.  The struct_ops is attached per device, following the
+	 hid_bpf_ops model.
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
diff --git a/block/blk-core.c b/block/blk-core.c
index 13dc70e8f55d9..a902736d381a5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -536,6 +536,22 @@ bool blk_get_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_get_queue);
 
+/**
+ * blk_get_queue_rcu - get a queue reference regardless of the dying flag
+ * @q: the request_queue to reference
+ *
+ * Unlike blk_get_queue(), this succeeds on a dying queue, so a caller
+ * which holds the queue only through RCU (e.g. a detach path which
+ * read the pointer locklessly) can still take a reference and touch
+ * the queue under its own lifetime.  The caller must hold
+ * rcu_read_lock() so the memory is valid.  Fails only when the
+ * refcount already dropped to zero.
+ */
+bool blk_get_queue_rcu(struct request_queue *q)
+{
+	return refcount_inc_not_zero(&q->refs);
+}
+
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 
 static DECLARE_FAULT_ATTR(fail_make_request);
diff --git a/block/blk-iocost-bpf.c b/block/blk-iocost-bpf.c
new file mode 100644
index 0000000000000..56959c5fc3937
--- /dev/null
+++ b/block/blk-iocost-bpf.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * blk-iocost: BPF struct_ops plumbing for pluggable cost models.
+ *
+ * Registers the "iocost_model_ops" struct_ops type.  Attachment is
+ * per-device and follows the hid_bpf_ops model: the target device is
+ * set in the ops from userspace before load, .reg attaches the model
+ * to that device, creating the ioc if needed and switching to the
+ * model under the same queue freeze and quiesce as io.cost.model
+ * writes, and .unreg detaches it; enabling and disabling the
+ * controller stays with io.cost.qos.  The struct_ops core owns the
+ * program lifetime.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf.h>
+#include <linux/blk-iocost.h>
+#include <linux/blk-mq.h>
+#include <linux/mutex.h>
+#include "blk.h"
+
+/* nothing to look up: the core finds the struct by name before calling */
+static int bpf_iocost_model_init(struct btf *btf)
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
+	/* every callback runs under RCU read lock or a spinlock */
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
+	/*
+	 * bdev, q and link are kernel-private and start zeroed; the
+	 * struct_ops core rejects a nonzero userspace value for
+	 * non-function members this callback does not claim.
+	 */
+	case offsetof(struct iocost_model_ops, dev):
+		ops->dev = uops->dev;
+		return 1;
+	case offsetof(struct iocost_model_ops, read_vtime_per_page):
+		ops->read_vtime_per_page = uops->read_vtime_per_page;
+		return 1;
+	case offsetof(struct iocost_model_ops, write_vtime_per_page):
+		ops->write_vtime_per_page = uops->write_vtime_per_page;
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
+ * it on every charged IO, so reject it here.
+ */
+static int bpf_iocost_validate(void *kdata)
+{
+	struct iocost_model_ops *ops = kdata;
+
+	return ops->calc_cost ? 0 : -EINVAL;
+}
+
+static int bpf_iocost_reg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *ops = kdata;
+
+	if (!ops->dev)
+		return -EINVAL;
+
+	return ioc_bpf_attach(ops, link);
+}
+
+static void bpf_iocost_unreg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *ops = kdata;
+	struct request_queue *q;
+
+	/*
+	 * ops->q may already have been cleared by the removal ejection;
+	 * take a queue reference under RCU before entering the queue,
+	 * as the queue may be dying and its memory is only guaranteed
+	 * under rcu_read_lock()
+	 */
+	rcu_read_lock();
+	/* pairs with the smp_store_release() in the attach: a non-NULL
+	 * q guarantees the owning link store is visible */
+	q = smp_load_acquire(&ops->q);
+	if (!q || !blk_get_queue_rcu(q)) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	/*
+	 * detach only if this link still owns the attachment: after a
+	 * device removal the same map may have been attached to a new
+	 * device through another link, and closing the old link must
+	 * not tear that down.  The link is re-checked under
+	 * rq_qos_mutex inside ioc_bpf_detach().
+	 */
+	ioc_bpf_detach(ops, link, q);
+
+	blk_put_queue(q);
+}
+
+static const struct bpf_verifier_ops bpf_iocost_verifier_ops = {
+	.get_func_proto = bpf_iocost_get_func_proto,
+	.is_valid_access = bpf_iocost_is_valid_access,
+};
+
+static u64 bpf_iocost_calc_cost_stub(struct bio *bio, u64 flags)
+{
+	return 0;
+}
+
+static void bpf_iocost_iocg_init_stub(struct blkcg *blkcg,
+				      struct request_queue *q)
+{ }
+static void bpf_iocost_iocg_free_stub(struct blkcg *blkcg,
+				      struct request_queue *q)
+{ }
+
+static struct iocost_model_ops __bpf_ops_iocost_model_ops = {
+	.calc_cost = bpf_iocost_calc_cost_stub,
+	.iocg_init = bpf_iocost_iocg_init_stub,
+	.iocg_free = bpf_iocost_iocg_free_stub,
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
index 2745bffcd5eef..509ae36f99edf 100644
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
+	/* the struct_ops attached to this device, NULL = none */
+	const struct iocost_model_ops	__rcu *attached;
+	/* the cost model in use, NULL = builtin linear model */
+	const struct iocost_model_ops	__rcu *model;
 };
 
 struct iocg_pcpu_stat {
@@ -462,6 +468,8 @@ struct iocg_stat {
 struct ioc_gq {
 	struct blkg_policy_data		pd;
 	struct ioc			*ioc;
+	/* whether the attached model's iocg_init() was delivered */
+	bool				bpf_iocg_inited;
 
 	/*
 	 * A iocg can get its weight from two sources - an explicit
@@ -780,6 +788,33 @@ static void ioc_refresh_period_us(struct ioc *ioc)
 	ioc_refresh_margins(ioc);
 }
 
+/*
+ * The BPF model in use, or NULL when the builtin linear model prices
+ * this device; with !CONFIG_BLK_CGROUP_IOCOST_BPF the field is
+ * always NULL, so callers need no #ifdefs.
+ */
+static const struct iocost_model_ops *ioc_model_in_use(struct ioc *ioc)
+{
+	return rcu_dereference(ioc->model);
+}
+
+/*
+ * The struct_ops attached to this device, or NULL.  While attachment
+ * and model selection are independent, the cgroup callbacks follow
+ * the attachment, not the selection.
+ */
+static const struct iocost_model_ops *ioc_attached_or_null(struct ioc *ioc)
+{
+	return rcu_dereference(ioc->attached);
+}
+
+static const struct iocost_model_ops *
+ioc_model_in_use_locked(struct ioc *ioc)
+{
+	return rcu_dereference_protected(ioc->model,
+					 lockdep_is_held(&ioc->lock));
+}
+
 /*
  *  ioc->rqos.disk isn't initialized when this function is called from
  *  the init path.
@@ -803,8 +838,13 @@ static int ioc_autop_idx(struct ioc *ioc, struct gendisk *disk)
 	if (idx < AUTOP_SSD_DFL)
 		return AUTOP_SSD_DFL;
 
-	/* if user is overriding anything, maintain what was there */
-	if (ioc->user_qos_params || ioc->user_cost_model)
+	/*
+	 * if user is overriding anything, or a BPF model is in use,
+	 * maintain what was there: the builtin coefficients are inert
+	 * then, so stepping the profile is pointless
+	 */
+	if (ioc->user_qos_params || ioc->user_cost_model ||
+	    ioc_model_in_use_locked(ioc))
 		return idx;
 
 	/* step up/down based on the vrate */
@@ -2571,8 +2611,19 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 
 static u64 calc_vtime_cost(struct bio *bio, struct ioc_gq *iocg, bool is_merge)
 {
+	const struct iocost_model_ops *model;
 	u64 cost;
 
+	rcu_read_lock();
+	model = ioc_model_in_use(iocg->ioc);
+	if (model) {
+		cost = model->calc_cost(bio,
+				is_merge ? IOCOST_COST_F_MERGE : 0);
+		rcu_read_unlock();
+		return min(cost, VTIME_PER_SEC);
+	}
+	rcu_read_unlock();
+
 	calc_vtime_cost_builtin(bio, iocg, is_merge, &cost);
 	return cost;
 }
@@ -2594,10 +2645,32 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 	}
 }
 
+/*
+ * Called from the request completion path, where no ioc->lock is
+ * held; the model pointer is read under RCU, matching the bio-side
+ * calc_vtime_cost().
+ */
 static u64 calc_size_vtime_cost(struct request *rq, struct ioc *ioc)
 {
+	const struct iocost_model_ops *model;
 	u64 cost;
 
+	rcu_read_lock();
+	model = ioc_model_in_use(ioc);
+	if (model && (req_op(rq) == REQ_OP_READ ||
+		      req_op(rq) == REQ_OP_WRITE)) {
+		unsigned int pages =
+			blk_rq_stats_sectors(rq) >> IOC_SECT_TO_PAGE_SHIFT;
+		u64 coeff = req_op(rq) == REQ_OP_READ ?
+			model->read_vtime_per_page :
+			model->write_vtime_per_page;
+
+		cost = pages * coeff;
+		rcu_read_unlock();
+		return cost;
+	}
+	rcu_read_unlock();
+
 	calc_size_vtime_cost_builtin(rq, ioc, &cost);
 	return cost;
 }
@@ -2888,6 +2961,51 @@ static void ioc_rqos_queue_depth_changed(struct rq_qos *rqos)
 	spin_unlock_irq(&ioc->lock);
 }
 
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+/*
+ * Eject the model on device removal.  The caller holds rq_qos_mutex
+ * and blkcg_deactivate_policy() has already run, so every existing
+ * blkg got iocg_free() from ioc_pd_free() and no walk is needed.
+ *
+ * bdev is read into a local before ops->q is cleared: once q is
+ * NULL, .unreg returns without taking any lock and the map holding
+ * ops can be freed, so ops must not be touched afterwards.
+ */
+static void ioc_bpf_eject(struct ioc *ioc)
+{
+	struct request_queue *q = ioc->rqos.disk->queue;
+	struct iocost_model_ops *ops;
+	struct block_device *bdev;
+
+	spin_lock_irq(&q->queue_lock);
+	spin_lock(&ioc->lock);
+	ops = (struct iocost_model_ops *)rcu_dereference_protected(
+			ioc->attached, lockdep_is_held(&ioc->lock));
+	if (!ops) {
+		spin_unlock(&ioc->lock);
+		spin_unlock_irq(&q->queue_lock);
+		return;
+	}
+	/*
+	 * ioc->attached and ioc->model are left set: the ioc is freed
+	 * right below, so clearing them buys nothing, and any
+	 * ioc_pd_free() which still runs finds the attachment and
+	 * delivers its iocg_free() through the struct_ops image grace
+	 * period instead of silently losing it.
+	 */
+	bdev = ops->bdev;
+	spin_unlock(&ioc->lock);
+	WRITE_ONCE(ops->link, NULL);
+	ops->bdev = NULL;
+	smp_store_release(&ops->q, NULL);
+	spin_unlock_irq(&q->queue_lock);
+
+	blkdev_put_no_open(bdev);
+}
+#else
+static inline void ioc_bpf_eject(struct ioc *ioc) { }
+#endif
+
 static void ioc_rqos_exit(struct rq_qos *rqos)
 {
 	struct ioc *ioc = rqos_to_ioc(rqos);
@@ -2900,6 +3018,10 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
 
 	timer_shutdown_sync(&ioc->timer);
 	free_percpu(ioc->pcpu_stat);
+
+	/* eject the model on device removal */
+	ioc_bpf_eject(ioc);
+
 	kfree(ioc);
 }
 
@@ -3022,6 +3144,7 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	struct ioc_now now;
 	struct blkcg_gq *tblkg;
 	unsigned long flags;
+	const struct iocost_model_ops *model;
 
 	ioc_now(ioc, &now);
 
@@ -3048,6 +3171,20 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	spin_lock_irqsave(&ioc->lock, flags);
 	weight_updated(iocg, &now);
 	spin_unlock_irqrestore(&ioc->lock, flags);
+
+	/*
+	 * the attached model is RCU-protected: a concurrent detach
+	 * publishes NULL and the struct_ops image survives it by a
+	 * grace period, so the callback is safe inside the read-side
+	 * critical section
+	 */
+	rcu_read_lock();
+	model = ioc_attached_or_null(ioc);
+	if (model && model->iocg_init) {
+		model->iocg_init(blkg->blkcg, ioc->rqos.disk->queue);
+		iocg->bpf_iocg_inited = true;
+	}
+	rcu_read_unlock();
 }
 
 static void iocg_release(struct rcu_head *rcu)
@@ -3066,8 +3203,31 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 	struct blkcg_gq *blkg = pd_to_blkg(pd);
 	struct ioc *ioc = iocg->ioc;
 	unsigned long flags;
+	const struct iocost_model_ops *model;
 
 	if (ioc) {
+		/*
+		 * gate the free on whether init was delivered, so a
+		 * blkg which appeared between the attach walk and its
+		 * own pd_init does not get an unpaired iocg_free().
+		 * The reverse can still happen to a blkg whose
+		 * radix_tree_insert() failed after pd_init delivered
+		 * iocg_init(): it never reaches q->blkg_list, the
+		 * detach walk misses it and the model may be gone by
+		 * the time this runs.  That window requires the GFP_NOWAIT
+		 * radix insert to fail and is documented in the interface
+		 * comment.
+		 */
+		if (iocg->bpf_iocg_inited) {
+			rcu_read_lock();
+			model = ioc_attached_or_null(ioc);
+			if (model && model->iocg_free)
+				model->iocg_free(blkg->blkcg,
+						 ioc->rqos.disk->queue);
+			rcu_read_unlock();
+			iocg->bpf_iocg_inited = false;
+		}
+
 		spin_lock_irqsave(&ioc->lock, flags);
 
 		if (!list_empty(&iocg->active_list)) {
@@ -3433,17 +3593,21 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
 	const char *dname = blkg_dev_name(pd->blkg);
 	struct ioc *ioc = pd_to_iocg(pd)->ioc;
 	u64 *u = ioc->params.i_lcoefs;
+	const struct iocost_model_ops *model;
 
 	if (!dname)
 		return 0;
 
 	spin_lock_irq(&ioc->lock);
-	seq_printf(sf, "%s ctrl=%s model=linear "
+	model = ioc_model_in_use_locked(ioc);
+	seq_printf(sf, "%s ctrl=%s model=%s "
 		   "rbps=%llu rseqiops=%llu rrandiops=%llu "
 		   "wbps=%llu wseqiops=%llu wrandiops=%llu\n",
 		   dname, ioc->user_cost_model ? "user" : "auto",
-		   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS], u[I_LCOEF_RRANDIOPS],
-		   u[I_LCOEF_WBPS], u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS]);
+		   model ? "bpf" : "linear",
+		   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS],
+		   u[I_LCOEF_RRANDIOPS], u[I_LCOEF_WBPS],
+		   u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS]);
 	spin_unlock_irq(&ioc->lock);
 	return 0;
 }
@@ -3457,6 +3621,265 @@ static int ioc_cost_model_show(struct seq_file *sf, void *v)
 	return 0;
 }
 
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+/*
+ * Deliver iocg_init()/iocg_free() to the cgroups which already have a
+ * blkg on the queue, the same q->blkg_list walk the blkcg policy
+ * teardown uses.  The queue is frozen and quiesced and blkcg_mutex
+ * serializes against blkg creation and destruction.  Cgroups without
+ * a blkg on the device yet are not missed: their blkg is created
+ * later and ioc_pd_init()/ioc_pd_free() deliver the callbacks then.
+ */
+static void ioc_bpf_walk_iocgs(struct ioc *ioc,
+			       const struct iocost_model_ops *ops, bool init)
+{
+	struct request_queue *q = ioc->rqos.disk->queue;
+	struct blkcg_gq *blkg;
+
+	/*
+	 * blkg_create() holds blkcg_mutex across ioc_pd_init() and the
+	 * list_add(), and blkg_free_workfn() holds blkcg_mutex across
+	 * pd_free and delays the list deletion until after it, so
+	 * holding blkcg_mutex makes the list stable and delivers each
+	 * callback exactly once; queue_lock additionally guards the
+	 * ioc->attached pointer the callbacks are gated on.
+	 */
+	lockdep_assert_held(&q->blkcg_mutex);
+	lockdep_assert_held(&q->queue_lock);
+
+	/*
+	 * the cgroup callbacks are optional; validate() only requires
+	 * calc_cost.  The flag keeps the pairing per cgroup across
+	 * models: an init is only delivered when the previous model's
+	 * free was, and a free is only delivered to a cgroup which
+	 * received an init, from whichever model delivered it
+	 */
+	if (init) {
+		/* parents first, like blkcg_activate_policy() */
+		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
+			if (blkg_to_iocg(blkg) && ops->iocg_init &&
+			    !blkg_to_iocg(blkg)->bpf_iocg_inited) {
+				ops->iocg_init(blkg->blkcg, q);
+				blkg_to_iocg(blkg)->bpf_iocg_inited = true;
+			}
+		}
+	} else {
+		list_for_each_entry(blkg, &q->blkg_list, q_node) {
+			if (!blkg_to_iocg(blkg) ||
+			    !blkg_to_iocg(blkg)->bpf_iocg_inited)
+				continue;
+			if (ops->iocg_free)
+				ops->iocg_free(blkg->blkcg, q);
+			blkg_to_iocg(blkg)->bpf_iocg_inited = false;
+		}
+	}
+}
+
+int ioc_bpf_attach(struct iocost_model_ops *ops, struct bpf_link *link)
+{
+	struct block_device *bdev;
+	struct request_queue *q;
+	struct gendisk *disk;
+	struct ioc *ioc;
+	unsigned int memflags;
+	int ret;
+
+	bdev = blkdev_get_no_open(new_decode_dev(ops->dev), false);
+	if (!bdev)
+		return -ENODEV;
+	q = bdev->bd_queue;
+	disk = bdev->bd_disk;
+
+	if (bdev_is_partition(bdev)) {
+		ret = -EINVAL;
+		goto put;
+	}
+	if (!queue_is_mq(q)) {
+		ret = -EOPNOTSUPP;
+		goto put;
+	}
+
+	/*
+	 * the freeze is taken before rq_qos_mutex; taking the mutex
+	 * around the freeze instead cycles against the io.cost.qos
+	 * write path, which freezes with the mutex held.  Holding
+	 * rq_qos_mutex from the disk_live() check through the model
+	 * switch keeps the ioc from being freed under us.
+	 */
+	memflags = blk_mq_freeze_queue(q);
+
+	mutex_lock(&q->rq_qos_mutex);
+
+	/*
+	 * one map binds one device at a time: the ops carries a single
+	 * device slot, so a second attach while it is bound elsewhere
+	 * would clobber it.  Re-attaching after a detach or the device
+	 * removal ejection is fine, both clear ops->q, and the
+	 * release/acquire protocol below orders that clearing against
+	 * this check even when the ejection runs on another device's
+	 * mutex.
+	 *
+	 * ops->q is the release flag of the ops state: the detach and
+	 * the ejection write ops->link first and ops->q last with
+	 * smp_store_release(), and this acquire read of a NULL q
+	 * guarantees their link clearing is already visible, so the
+	 * link store below cannot be clobbered by a concurrent ejection
+	 * on another device, which no lock here serializes against.
+	 */
+	if (smp_load_acquire(&ops->q)) {
+		mutex_unlock(&q->rq_qos_mutex);
+		blk_mq_unfreeze_queue(q, memflags);
+		ret = -EBUSY;
+		goto put;
+	}
+
+	if (!disk_live(disk)) {
+		mutex_unlock(&q->rq_qos_mutex);
+		blk_mq_unfreeze_queue(q, memflags);
+		ret = -ENODEV;
+		goto put;
+	}
+	ioc = q_to_ioc(q);
+	if (!ioc) {
+		ret = blk_iocost_init(disk);
+		if (ret) {
+			mutex_unlock(&q->rq_qos_mutex);
+			blk_mq_unfreeze_queue(q, memflags);
+			goto put;
+		}
+		ioc = q_to_ioc(q);
+	}
+
+	blk_mq_quiesce_queue(q);
+
+	mutex_lock(&q->blkcg_mutex);
+	spin_lock_irq(&q->queue_lock);
+
+	/*
+	 * the model pointers are published under ioc->lock, nested in
+	 * queue_lock like ioc_pd_init() does, so the ioc->lock readers
+	 * (the timer's autop check, the io.cost.model staging) stay
+	 * synchronized with the writers
+	 */
+	spin_lock(&ioc->lock);
+
+	if (rcu_dereference_protected(ioc->attached,
+				      lockdep_is_held(&ioc->lock))) {
+		spin_unlock(&ioc->lock);
+		spin_unlock_irq(&q->queue_lock);
+		mutex_unlock(&q->blkcg_mutex);
+		blk_mq_unquiesce_queue(q);
+		blk_mq_unfreeze_queue(q, memflags);
+		mutex_unlock(&q->rq_qos_mutex);
+		ret = -EBUSY;
+		goto put;
+	}
+
+	rcu_assign_pointer(ioc->attached, ops);
+	rcu_assign_pointer(ioc->model, ops);
+	spin_unlock(&ioc->lock);
+
+	ops->bdev = bdev;
+	WRITE_ONCE(ops->link, link);
+	smp_store_release(&ops->q, q);
+
+	/* pair iocg_init() with the cgroups which already exist */
+	ioc_bpf_walk_iocgs(ioc, ops, true);
+
+	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
+
+	blk_mq_unquiesce_queue(q);
+	blk_mq_unfreeze_queue(q, memflags);
+	mutex_unlock(&q->rq_qos_mutex);
+	return 0;
+
+put:
+	blkdev_put_no_open(bdev);
+	return ret;
+}
+
+/*
+ * Detach a model: switch back to the builtin model when the attached
+ * model is in use, clear the attachment, and deliver iocg_free() to
+ * the cgroups which still exist, under the same freeze and quiesce as
+ * the attach.  The caller has already checked ops->q.
+ */
+void ioc_bpf_detach(struct iocost_model_ops *ops, struct bpf_link *link,
+		   struct request_queue *q)
+{
+	struct block_device *bdev;
+	struct ioc *ioc;
+	unsigned int memflags;
+
+	if (!q)
+		return;
+
+	/* eject may clear ops->bdev on a dying queue concurrently */
+	bdev = READ_ONCE(ops->bdev);
+
+	/*
+	 * the freeze is taken before rq_qos_mutex like in the attach;
+	 * the attachment and the link are re-checked under the mutex
+	 * below, as the ejection or a newer attachment through another
+	 * link may have won the race meanwhile
+	 */
+	memflags = blk_mq_freeze_queue(q);
+	blk_mq_quiesce_queue(q);
+
+	mutex_lock(&q->rq_qos_mutex);
+
+	ioc = q_to_ioc(q);
+	if (!ioc) {
+		mutex_unlock(&q->rq_qos_mutex);
+		blk_mq_unquiesce_queue(q);
+		blk_mq_unfreeze_queue(q, memflags);
+		return;
+	}
+
+	mutex_lock(&q->blkcg_mutex);
+	spin_lock_irq(&q->queue_lock);
+
+	spin_lock(&ioc->lock);
+	if (rcu_dereference_protected(ioc->attached,
+				      lockdep_is_held(&ioc->lock)) != ops ||
+	    READ_ONCE(ops->link) != link) {
+		/* the ejection or a newer link won; nothing to detach */
+		spin_unlock(&ioc->lock);
+		spin_unlock_irq(&q->queue_lock);
+		mutex_unlock(&q->blkcg_mutex);
+		mutex_unlock(&q->rq_qos_mutex);
+		blk_mq_unquiesce_queue(q);
+		blk_mq_unfreeze_queue(q, memflags);
+		return;
+	}
+	if (rcu_dereference_protected(ioc->model,
+				      lockdep_is_held(&ioc->lock)) == ops)
+		rcu_assign_pointer(ioc->model, NULL);
+	rcu_assign_pointer(ioc->attached, NULL);
+	spin_unlock(&ioc->lock);
+	WRITE_ONCE(ops->link, NULL);
+	ops->bdev = NULL;
+	smp_store_release(&ops->q, NULL);
+
+	ioc_bpf_walk_iocgs(ioc, ops, false);
+
+	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
+
+	mutex_unlock(&q->rq_qos_mutex);
+
+	blk_mq_unquiesce_queue(q);
+	blk_mq_unfreeze_queue(q, memflags);
+
+	/* drop the attach reference: the detacher owns it */
+	if (bdev)
+		blkdev_put_no_open(bdev);
+}
+
+
+#endif
+
 static const match_table_t cost_ctrl_tokens = {
 	{ COST_CTRL,		"ctrl=%s"	},
 	{ COST_MODEL,		"model=%s"	},
@@ -3484,6 +3907,8 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	bool user;
 	char *body, *p;
 	int ret;
+	const struct iocost_model_ops *new_model = NULL;
+	bool model_write = false;
 
 	blkg_conf_init(&ctx, input);
 
@@ -3536,9 +3961,25 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 			continue;
 		case COST_MODEL:
 			match_strlcpy(buf, &args[0], sizeof(buf));
-			if (strcmp(buf, "linear"))
-				goto unlock;
-			continue;
+			if (!strcmp(buf, "linear")) {
+				/* staged and committed below, so a parse
+				 * error later in the same write leaves
+				 * the model selection untouched
+				 */
+				new_model = NULL;
+				model_write = true;
+				continue;
+			}
+			if (!strcmp(buf, "bpf")) {
+				new_model = rcu_dereference_protected(
+						ioc->attached,
+						lockdep_is_held(&ioc->lock));
+				if (!new_model)
+					goto unlock;
+				model_write = true;
+				continue;
+			}
+			goto unlock;
 		}
 
 		tok = match_token(p, i_lcoef_tokens, args);
@@ -3556,6 +3997,8 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	} else {
 		ioc->user_cost_model = false;
 	}
+	if (model_write)
+		rcu_assign_pointer(ioc->model, new_model);
 	ioc_refresh_params(ioc, true);
 
 	ret = 0;
diff --git a/block/blk.h b/block/blk.h
index 2cc03aa54c532..2ef75df930d6f 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -112,6 +112,7 @@ static inline void blk_wait_io(struct completion *done)
 }
 
 struct block_device *blkdev_get_no_open(dev_t dev, bool autoload);
+bool blk_get_queue_rcu(struct request_queue *q);
 void blkdev_put_no_open(struct block_device *bdev);
 
 bool bvec_try_merge_hw_page(struct request_queue *q, struct bio_vec *bv,
diff --git a/include/linux/blk-iocost.h b/include/linux/blk-iocost.h
new file mode 100644
index 0000000000000..9bcdbdc94a535
--- /dev/null
+++ b/include/linux/blk-iocost.h
@@ -0,0 +1,126 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BLK_IOCOST_H
+#define _LINUX_BLK_IOCOST_H
+
+#include <linux/types.h>
+#include <linux/blk_types.h>
+#include <linux/blkdev.h>
+
+struct bio;
+struct blkcg;
+struct bpf_link;
+struct request_queue;
+
+/*
+ * Pluggable cost model interface for blk-iocost.
+ *
+ * A BPF struct_ops implementation is attached to one device, identified
+ * by the dev member set from userspace before load, following the
+ * hid_bpf_ops model: the struct_ops core owns the lifetime of the
+ * program.  Attaching creates the ioc if needed, like an io.cost.model
+ * write does, switches the device to the BPF model under the same
+ * queue freeze and quiesce, and delivers iocg_init() to the cgroups
+ * which already exist on the device.  Enabling and disabling the
+ * controller stays with io.cost.qos.  While a model is attached,
+ * io.cost.model selects between it and the builtin model: "model=bpf"
+ * switches to the attached model, "model=linear" switches back to the
+ * builtin model, and neither detaches the struct_ops; only detaching
+ * removes the model.  The builtin linear coefficients are kept while
+ * the BPF model is in use and take effect again when switched back.
+ *
+ * While the BPF model is the one in use, it owns pricing for every
+ * charged IO on the device: it prices all operations, including
+ * flushes, from the bio charging path.
+ *
+ * calc_cost() is called from the IO submission path with RCU read lock
+ * held and must not sleep.  It receives the bio itself so the model
+ * can read whatever it needs (operation flags, size, sector, the
+ * issuing cgroup through bio->bi_blkg).  It returns the cost of the
+ * IO in vtime units, where 1 second of device time equals
+ * VTIME_PER_SEC (2^37, available to BPF programs through vmlinux.h).
+ * The returned value is clamped to 1 second of device time per IO.
+ *
+ * The struct_ops also carries the transfer cost coefficients, vtime
+ * per page for reads and writes: while the BPF model is in use,
+ * these replace the builtin linear coefficients in the
+ * completion-time request sizing of READ and WRITE requests.  Letting
+ * a model take over the QoS side entirely (latency tracking, vrate
+ * control) is left for a later extension.
+ *
+ * The cgroup callbacks are bound to the iocg policy lifetime, one
+ * (cgroup, device) pair per invocation: iocg_init() is delivered on
+ * attach to every cgroup which already exists on the device and to
+ * each one appearing afterwards; iocg_free() is delivered on detach to
+ * every cgroup still existing then, and at policy deactivation time
+ * for the rest, so init and free pair up, with one exception: a
+ * blkg whose radix_tree_insert() failed inside blkg_create() has
+ * had iocg_init() delivered but never reaches the blkg list, so
+ * the detach walk misses it and iocg_free() may not be delivered.
+ * Models which keep per-cgroup state should tolerate this, e.g.
+ * by using cgroup storage which is freed with the cgroup.  Both
+ * callbacks are called under the queue lock or the blkcg lock, or
+ * inside an RCU read-side critical section, and must not sleep.
+ */
+
+/*
+ * iocost-specific call metadata for calc_cost()'s model_flags
+ * argument; the merge indicator is not a property of the bio.
+ * An enum so the value is exported through BTF and BPF models can
+ * use it from vmlinux.h.
+ */
+enum {
+	IOCOST_COST_F_MERGE	= 1 << 0,	/* called from merge path */
+};
+
+struct iocost_model_ops {
+	/*
+	 * target device (major:minor), set from userspace before load
+	 * through the struct_ops map's initial value, in the userspace
+	 * dev_t encoding new_decode_dev() accepts
+	 */
+	dev_t dev;
+
+	/* vtime per page, used by the builtin sizing and vrate logic */
+	u64 read_vtime_per_page;
+	u64 write_vtime_per_page;
+
+	u64 (*calc_cost)(struct bio *bio, u64 model_flags);
+	void (*iocg_init)(struct blkcg *blkcg, struct request_queue *q);
+	void (*iocg_free)(struct blkcg *blkcg, struct request_queue *q);
+
+	/* private: */
+
+	/*
+	 * bdev reference held while attached; dropped by the removal
+	 * ejection or .unreg, whichever detaches the model first
+	 */
+	struct block_device	*bdev;
+	/* queue of the attached device, NULL = not attached */
+	struct request_queue	*q;
+	/*
+	 * the link which owns the attachment; .unreg only detaches
+	 * when it matches, so a map re-attached through a newer link
+	 * is not torn down by closing an old one
+	 */
+	struct bpf_link		*link;
+};
+
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+
+int ioc_bpf_attach(struct iocost_model_ops *ops, struct bpf_link *link);
+void ioc_bpf_detach(struct iocost_model_ops *ops,
+			 struct bpf_link *link, struct request_queue *q);
+
+#else	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+
+static inline int ioc_bpf_attach(struct iocost_model_ops *ops,
+				 struct bpf_link *link)
+{
+	return -EOPNOTSUPP;
+}
+static inline void ioc_bpf_detach(struct iocost_model_ops *ops,
+				   struct bpf_link *link,
+				   struct request_queue *q) { }
+
+#endif	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+#endif	/* _LINUX_BLK_IOCOST_H */
-- 
2.43.0

