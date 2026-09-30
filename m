Received: from mta1.migadu.com (out-127.mta1.migadu.com [95.215.58.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B673A874C
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 07:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754738; cv=none; b=LHXq1om4Ye4Y/LoreDTA4XpKGMzbKKTCG6G9Hl/PtcZY+M8Xoja1fRShE0Obc1+33Z6CexQjERxCLQj6h0ZQU0ynHR0lZCLMXma7Pz1s6//5nAqoAL3m0TcWiiLhdud3xw+1/1YsUruP4By2JWDaBfnIpGBj5d6K/JQ8UqvDwhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754738; c=relaxed/simple;
	bh=j2fGcK284a0sU93NuohXkaMpHjmDfqFNYexWp0BMveU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQCQUqO8J6fnMZToZdwbkacq/71/mNFDZsRK0fgjSnyEh7GJcdkzCYXY4SSN71qRr5qyKvmBBALXFuVVJiZsZdepugpGbXrJheLIIWU34xxvYiadAgg3swvfh7p5UO6Q/CaQZYk+mkrYa6VySSpzVAW268Ryc66Wnke0Qw5BsbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CmsxoJkS; arc=none smtp.client-ip=95.215.58.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CmsxoJkS"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=j2fGcK284a0sU93NuohXkaMpHjmDfqFNYexWp0BMveU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790754731; v=1; x=1791359531;
 b=CmsxoJkS8NYRLWHUcDvfq6JRsjlkIVws+dKkhpxOcT5YGDpqRv+CN5QUSQ/Qr0WrOnsiCGtb
 c2Q3HuiowZnU90D0tGhNXG6gyv6u52Zs7dz6DOVADgAcM6vZeUlVa+N5d/Ck5hnlmLuRhtN7ENd
 DIY3POWQqcs9itKGGavoQ4iY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 74e10f60cf8b274b;
	Wed, 30 Sep 2026 07:52:11 +0000
X-Mizu-Trace-ID: 74e10f60cf8b274b
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
Subject: [RFC PATCH v8 1/4] blk-iocost: add BPF struct_ops cost model support
Date: Wed, 30 Sep 2026 15:51:51 +0800
Message-ID: <20260930075154.189958-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260930075154.189958-1-cui.tao@linux.dev>
References: <20260930075154.189958-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the iocost_model_ops struct_ops.  Attachment follows the
hid_bpf_ops model: the struct_ops instance is per-device, the target
device is set in the dev member from userspace before load, .reg
attaches the model to that device and switches it away from the
builtin linear model, and .unreg detaches it and restores the builtin
model.  The struct_ops core owns the program lifetime, so there is no
name registry and no bound-state bookkeeping.

calc_cost() receives the bio itself and reads whatever it needs
(operation flags, size, sector, the issuing cgroup through
bi_blkg->blkcg); the merge indicator stays in the separate flags
argument as it is not a property of the bio.  It is called from the
bio charging path, so the model owns pricing for every IO on the
device.  The completion-time request sizing uses the transfer cost
coefficients carried in the struct_ops (vtime per page for reads and
writes) while the model is in use, so the builtin latency tracking
and vrate adjustment follow the model's pricing; letting a model take
over the QoS side is left for a later extension.

The cgroup callbacks are bound to the iocg policy init/free paths,
one (cgroup, device) pair per invocation, matching the builtin
cursor's lifetime, instead of the blkcg css lifecycle, which also
drops the mutex from the cgroup online/offline paths.

calc_cost() runs under RCU read lock; sleepable programs are
rejected in .check_member.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/Kconfig              |  10 +
 block/Makefile             |   1 +
 block/blk-core.c           |  17 ++
 block/blk-iocost-bpf.c     | 220 ++++++++++++++++++++++
 block/blk-iocost.c         | 368 ++++++++++++++++++++++++++++++++++++-
 include/linux/blk-iocost.h | 110 +++++++++++
 6 files changed, 718 insertions(+), 8 deletions(-)
 create mode 100644 block/blk-iocost-bpf.c
 create mode 100644 include/linux/blk-iocost.h

diff --git a/block/Kconfig b/block/Kconfig
index 70e4a66d941f..1cafc1bd0dda 100644
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
index e7bd320e3d69..ee5cebeea006 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o \
 					   blk-crypto-sysfs.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
 obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
+obj-$(CONFIG_BLK_CGROUP_IOCOST_BPF)	+= blk-iocost-bpf.o
diff --git a/block/blk-core.c b/block/blk-core.c
index 13dc70e8f55d..2c789b0d86ff 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -536,6 +536,23 @@ bool blk_get_queue(struct request_queue *q)
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
+EXPORT_SYMBOL(blk_get_queue_rcu);
+
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 
 static DECLARE_FAULT_ATTR(fail_make_request);
diff --git a/block/blk-iocost-bpf.c b/block/blk-iocost-bpf.c
new file mode 100644
index 000000000000..32a5107522b5
--- /dev/null
+++ b/block/blk-iocost-bpf.c
@@ -0,0 +1,220 @@
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
+ * program lifetime.  There is no name registry and no separate
+ * bound-state bookkeeping.
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
+
+struct block_device *blkdev_get_no_open(dev_t dev, bool autoload);
+void blkdev_put_no_open(struct block_device *bdev);
+bool blk_get_queue_rcu(struct request_queue *q);
+void blk_put_queue(struct request_queue *q);
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
+	case offsetof(struct iocost_model_ops, bdev):
+		/*
+		 * kernel-private: the bdev reference held while
+		 * attached; reject a userspace value
+		 */
+		if (uops->bdev)
+			return -EINVAL;
+		ops->bdev = NULL;
+		return 1;
+	case offsetof(struct iocost_model_ops, q):
+		/* kernel-private: the queue of the attached device */
+		if (uops->q)
+			return -EINVAL;
+		ops->q = NULL;
+		return 1;
+	case offsetof(struct iocost_model_ops, dev):
+		/*
+		 * copy it and return 1 to indicate that the member is
+		 * handled here, or the verifier rejects the map if the
+		 * userspace value is nonzero
+		 */
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
+ * it on every bio, so reject it here.
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
+	return ioc_bpf_attach(ops);
+}
+
+static void bpf_iocost_unreg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *ops = kdata;
+	struct block_device *bdev;
+	struct request_queue *q;
+
+	/*
+	 * ops->q may already have been cleared by the removal ejection;
+	 * take a queue reference under RCU before entering the queue,
+	 * as the queue may be dying and its memory is only guaranteed
+	 * under rcu_read_lock()
+	 */
+	rcu_read_lock();
+	q = rcu_dereference(ops->q);
+	if (!q || !blk_get_queue_rcu(q)) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	/*
+	 * take rq_qos_mutex before touching the queue further: the
+	 * removal ejection clears ops->q under it, inside rq_qos_exit()
+	 * and before blk_mq_exit_queue() releases the hardware queues,
+	 * so holding it and seeing a non-NULL ops->q guarantees the
+	 * queue is still safe to freeze.  The freeze and quiesce are
+	 * done inside ioc_bpf_detach(), under the mutex.
+	 */
+	mutex_lock(&q->rq_qos_mutex);
+	if (!ops->q) {
+		/* the removal ejection won the race; nothing to detach */
+		mutex_unlock(&q->rq_qos_mutex);
+		blk_put_queue(q);
+		return;
+	}
+	bdev = ops->bdev;
+	ioc_bpf_detach(ops);
+	mutex_unlock(&q->rq_qos_mutex);
+	blk_put_queue(q);
+
+	/* drop the attach reference when we did the detach */
+	if (bdev)
+		blkdev_put_no_open(bdev);
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
index 2745bffcd5ee..bc83827cced9 100644
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
@@ -445,6 +446,13 @@ struct ioc {
 	int				autop_idx;
 	bool				user_qos_params:1;
 	bool				user_cost_model:1;
+
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	/* the struct_ops attached to this device, NULL = none */
+	const struct iocost_model_ops	__rcu *attached;
+	/* the cost model in use, NULL = builtin linear model */
+	const struct iocost_model_ops	__rcu *model;
+#endif
 };
 
 struct iocg_pcpu_stat {
@@ -780,6 +788,45 @@ static void ioc_refresh_period_us(struct ioc *ioc)
 	ioc_refresh_margins(ioc);
 }
 
+/*
+ * The BPF model in use, or NULL when the builtin linear model prices
+ * this device.  CONFIG_BLK_CGROUP_IOCOST_BPF=n compiles to a constant
+ * NULL so callers need no #ifdefs.
+ */
+static const struct iocost_model_ops *ioc_model_in_use(struct ioc *ioc)
+{
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	return rcu_dereference(ioc->model);
+#else
+	return NULL;
+#endif
+}
+
+/*
+ * The struct_ops attached to this device, or NULL.  While attachment
+ * and model selection are independent, the cgroup callbacks follow
+ * the attachment, not the selection.
+ */
+static const struct iocost_model_ops *ioc_attached_or_null(struct ioc *ioc)
+{
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	return rcu_dereference(ioc->attached);
+#else
+	return NULL;
+#endif
+}
+
+static const struct iocost_model_ops *
+ioc_model_in_use_locked(struct ioc *ioc)
+{
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	return rcu_dereference_protected(ioc->model,
+					 lockdep_is_held(&ioc->lock));
+#else
+	return NULL;
+#endif
+}
+
 /*
  *  ioc->rqos.disk isn't initialized when this function is called from
  *  the init path.
@@ -803,8 +850,13 @@ static int ioc_autop_idx(struct ioc *ioc, struct gendisk *disk)
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
@@ -2571,8 +2623,19 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 
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
@@ -2594,10 +2657,32 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
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
@@ -2900,6 +2985,24 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
 
 	timer_shutdown_sync(&ioc->timer);
 	free_percpu(ioc->pcpu_stat);
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	{
+		struct iocost_model_ops *ops;
+
+		spin_lock_irq(&ioc->lock);
+		ops = (struct iocost_model_ops *)rcu_dereference_protected(
+				ioc->attached, lockdep_is_held(&ioc->lock));
+		rcu_assign_pointer(ioc->attached, NULL);
+		rcu_assign_pointer(ioc->model, NULL);
+		spin_unlock_irq(&ioc->lock);
+
+		/* eject the model completely on device removal */
+		if (ops) {
+			WRITE_ONCE(ops->q, NULL);
+			blkdev_put_no_open(ops->bdev);
+		}
+	}
+#endif
 	kfree(ioc);
 }
 
@@ -3022,6 +3125,7 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	struct ioc_now now;
 	struct blkcg_gq *tblkg;
 	unsigned long flags;
+	const struct iocost_model_ops *model;
 
 	ioc_now(ioc, &now);
 
@@ -3048,6 +3152,18 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
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
+	if (model && model->iocg_init)
+		model->iocg_init(blkg->blkcg, ioc->rqos.disk->queue);
+	rcu_read_unlock();
 }
 
 static void iocg_release(struct rcu_head *rcu)
@@ -3066,8 +3182,15 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 	struct blkcg_gq *blkg = pd_to_blkg(pd);
 	struct ioc *ioc = iocg->ioc;
 	unsigned long flags;
+	const struct iocost_model_ops *model;
 
 	if (ioc) {
+		rcu_read_lock();
+		model = ioc_attached_or_null(ioc);
+		if (model && model->iocg_free)
+			model->iocg_free(blkg->blkcg, ioc->rqos.disk->queue);
+		rcu_read_unlock();
+
 		spin_lock_irqsave(&ioc->lock, flags);
 
 		if (!list_empty(&iocg->active_list)) {
@@ -3433,17 +3556,21 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
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
@@ -3457,6 +3584,204 @@ static int ioc_cost_model_show(struct seq_file *sf, void *v)
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
+	lockdep_assert_held(&q->blkcg_mutex);
+
+	rcu_read_lock();
+	list_for_each_entry(blkg, &q->blkg_list, q_node) {
+		if (!blkg_to_iocg(blkg))
+			continue;
+		if (init) {
+			if (ops->iocg_init)
+				ops->iocg_init(blkg->blkcg, q);
+		} else {
+			if (ops->iocg_free)
+				ops->iocg_free(blkg->blkcg, q);
+		}
+	}
+	rcu_read_unlock();
+}
+
+int ioc_bpf_attach(struct iocost_model_ops *ops)
+{
+	struct block_device *bdev;
+	struct request_queue *q;
+	struct gendisk *disk;
+	struct ioc *ioc;
+	unsigned int memflags;
+	int ret;
+
+	/* prevent multiple attach of the same struct_ops */
+	if (ops->q)
+		return -EINVAL;
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
+	 * check liveness and create the ioc under rq_qos_mutex, like
+	 * blkg_conf_open_bdev() does; enabling stays with io.cost.qos
+	 *
+	 * the queue reference is held across the unlocked window below:
+	 * the bdev reference does not pin the queue, bdev only holds a
+	 * raw bd_queue pointer, and concurrent device removal may eject
+	 * the model and free the ioc while we are off the mutex, so
+	 * without our own reference the second mutex_lock() would touch
+	 * a freed queue
+	 */
+	mutex_lock(&q->rq_qos_mutex);
+	if (!disk_live(disk) || !blk_get_queue(q)) {
+		mutex_unlock(&q->rq_qos_mutex);
+		ret = -ENODEV;
+		goto put;
+	}
+	ioc = q_to_ioc(q);
+	if (!ioc) {
+		ret = blk_iocost_init(disk);
+		mutex_unlock(&q->rq_qos_mutex);
+		if (ret)
+			goto put_q;
+		ioc = q_to_ioc(q);
+	} else {
+		mutex_unlock(&q->rq_qos_mutex);
+	}
+
+	/*
+	 * ops->bdev is dropped by the removal ejection or by .unreg,
+	 * whichever detaches the model first, similar to hid_bpf's
+	 * per-ops device reference without the struct file and without
+	 * pinning the driver module
+	 */
+
+	/*
+	 * switch the model under the same freeze and quiesce as the
+	 * io.cost.model writes; the freeze does not pin the ioc, so
+	 * rq_qos_mutex has to be held across the switch - ioc_rqos_exit()
+	 * frees the ioc under it
+	 */
+	mutex_lock(&q->rq_qos_mutex);
+	ioc = q_to_ioc(q);
+	if (!ioc) {
+		mutex_unlock(&q->rq_qos_mutex);
+		ret = -ENODEV;
+		goto put_q;
+	}
+	memflags = blk_mq_freeze_queue(q);
+	blk_mq_quiesce_queue(q);
+
+	/*
+	 * hold blkcg_mutex across the publish and the iocg_init() walk:
+	 * ioc_pd_init() runs under it too, so no cgroup can receive
+	 * iocg_init() from both the walk and its own pd_init
+	 */
+	mutex_lock(&q->blkcg_mutex);
+	spin_lock_irq(&ioc->lock);
+	if (rcu_dereference_protected(ioc->attached,
+				      lockdep_is_held(&ioc->lock))) {
+		spin_unlock_irq(&ioc->lock);
+		mutex_unlock(&q->blkcg_mutex);
+		blk_mq_unquiesce_queue(q);
+		blk_mq_unfreeze_queue(q, memflags);
+		mutex_unlock(&q->rq_qos_mutex);
+		ret = -EBUSY;
+		goto put_q;
+	}
+	rcu_assign_pointer(ioc->attached, ops);
+	rcu_assign_pointer(ioc->model, ops);
+	spin_unlock_irq(&ioc->lock);
+
+	ops->bdev = bdev;
+	WRITE_ONCE(ops->q, q);
+
+	/* pair iocg_init() with the cgroups which already exist */
+	ioc_bpf_walk_iocgs(ioc, ops, true);
+	mutex_unlock(&q->blkcg_mutex);
+
+	blk_mq_unquiesce_queue(q);
+	blk_mq_unfreeze_queue(q, memflags);
+	mutex_unlock(&q->rq_qos_mutex);
+	blk_put_queue(q);
+	return 0;
+
+put_q:
+	blk_put_queue(q);
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
+void ioc_bpf_detach(struct iocost_model_ops *ops)
+{
+	struct request_queue *q = ops->q;
+	struct ioc *ioc;
+	unsigned int memflags;
+
+	if (!q)
+		return;
+	ioc = q_to_ioc(q);
+	if (!ioc)
+		return;
+
+	memflags = blk_mq_freeze_queue(q);
+	blk_mq_quiesce_queue(q);
+
+	/*
+	 * hold blkcg_mutex across the clearing and the iocg_free() walk:
+	 * ioc_pd_free() runs under it too, so no cgroup can receive
+	 * iocg_free() from both the walk and its own pd_free
+	 */
+	mutex_lock(&q->blkcg_mutex);
+	spin_lock_irq(&ioc->lock);
+	if (rcu_dereference_protected(ioc->model,
+				      lockdep_is_held(&ioc->lock)) == ops)
+		rcu_assign_pointer(ioc->model, NULL);
+	rcu_assign_pointer(ioc->attached, NULL);
+	spin_unlock_irq(&ioc->lock);
+
+	/* pair iocg_free() with the cgroups which still exist */
+	ioc_bpf_walk_iocgs(ioc, ops, false);
+	mutex_unlock(&q->blkcg_mutex);
+
+	WRITE_ONCE(ops->q, NULL);
+
+	blk_mq_unquiesce_queue(q);
+	blk_mq_unfreeze_queue(q, memflags);
+}
+
+#endif
+
 static const match_table_t cost_ctrl_tokens = {
 	{ COST_CTRL,		"ctrl=%s"	},
 	{ COST_MODEL,		"model=%s"	},
@@ -3484,6 +3809,10 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	bool user;
 	char *body, *p;
 	int ret;
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *new_model = NULL;
+	bool model_write = false;
+#endif
 
 	blkg_conf_init(&ctx, input);
 
@@ -3536,9 +3865,28 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 			continue;
 		case COST_MODEL:
 			match_strlcpy(buf, &args[0], sizeof(buf));
-			if (strcmp(buf, "linear"))
-				goto unlock;
-			continue;
+			if (!strcmp(buf, "linear")) {
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+				/* staged and committed below, so a parse
+				 * error later in the same write leaves
+				 * the model selection untouched */
+				new_model = NULL;
+				model_write = true;
+#endif
+				continue;
+			}
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+			if (!strcmp(buf, "bpf")) {
+				new_model = rcu_dereference_protected(
+						ioc->attached,
+						lockdep_is_held(&ioc->lock));
+				if (!new_model)
+					goto unlock;
+				model_write = true;
+				continue;
+			}
+#endif
+			goto unlock;
 		}
 
 		tok = match_token(p, i_lcoef_tokens, args);
@@ -3556,6 +3904,10 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	} else {
 		ioc->user_cost_model = false;
 	}
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	if (model_write)
+		rcu_assign_pointer(ioc->model, new_model);
+#endif
 	ioc_refresh_params(ioc, true);
 
 	ret = 0;
diff --git a/include/linux/blk-iocost.h b/include/linux/blk-iocost.h
new file mode 100644
index 000000000000..03a0c7dab71f
--- /dev/null
+++ b/include/linux/blk-iocost.h
@@ -0,0 +1,110 @@
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
+ * per page for reads and writes: while the BPF model is in use, the
+ * builtin latency tracking and vrate adjustment use these instead of
+ * the builtin linear coefficients for the completion-time request
+ * sizing, so the whole controller follows the model's pricing.  Letting
+ * a model take over the QoS side entirely (latency tracking, vrate
+ * control) is left for a later extension.
+ *
+ * The cgroup callbacks are bound to the iocg policy lifetime, one
+ * (cgroup, device) pair per invocation: iocg_init() is delivered on
+ * attach to every cgroup which already exists on the device and to
+ * each one appearing afterwards; iocg_free() is delivered on detach to
+ * every cgroup still existing then, and at policy deactivation time
+ * for the rest, so init and free always pair up.  Both callbacks run
+ * inside an RCU read-side critical section and must not sleep.
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
+};
+
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+
+int ioc_bpf_attach(struct iocost_model_ops *ops);
+void ioc_bpf_detach(struct iocost_model_ops *ops);
+
+#else	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+
+static inline int ioc_bpf_attach(struct iocost_model_ops *ops)
+{
+	return -EOPNOTSUPP;
+}
+static inline void ioc_bpf_detach(struct iocost_model_ops *ops) { }
+
+#endif	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+#endif	/* _LINUX_BLK_IOCOST_H */
-- 
2.43.0

