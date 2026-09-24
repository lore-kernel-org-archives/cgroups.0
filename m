Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F21A3D566A
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 05:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790228780; cv=none; b=nMY2gnlnaujE7ZAF/r0750LJq39ZrR4c8l1g9fRhlJGdf9rL/JRPdwYfhG2eYf7qkxwuC+f+d514+rGbidZNlKMHzEnjM6tN2XqL/+BQO+oBmBFuA/eAL04ba3/Svk8/cJZmfs/D7jsyaIsam+iM3Ytdh0Gm7qNL/25ftpnP8QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790228780; c=relaxed/simple;
	bh=jJZ/JMXUL7+FEpA6VQwZfBgIi3TGWmFZKvUY2lUA1yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDaRaprW0ab84ZbvpW6ebVZAwgrHtPQrFcTkh1QGS5WboGgn4XVwrhb4QoGmjBb5LCBHrk0QWr/B5SqOWnUfIcA52A2u6onIUBFJCbNQ9F/ssBoahyGFNRok4oP3tzCvLTLP1FMo9l3sINrHndiBz4MFEZ5pQ0t5uCP2xaSjTjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oWl0LEkW; arc=none smtp.client-ip=91.218.175.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oWl0LEkW"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jJZ/JMXUL7+FEpA6VQwZfBgIi3TGWmFZKvUY2lUA1yg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790228775; v=1; x=1790833575;
 b=oWl0LEkW3OCqeyfCEuJNproNJ7Z88wec8ctoJ3avuHu3hhYgYv5LARgDELPJk8841yB0ofDd
 /1IL8JoQZK8fIr6n8mzgQlhvgi7W2lXZm3D33GMGpJbRbkWS0P05BEE3Zg3nmG4xZ9NP2ikUzpP
 0tB9M1tFCqugl44ETHBryVyY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ee25ecbb27016b22;
	Thu, 24 Sep 2026 05:46:15 +0000
X-Mizu-Trace-ID: ee25ecbb27016b22
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
Subject: [RFC PATCH v7 1/4] blk-iocost: add BPF struct_ops cost model support
Date: Thu, 24 Sep 2026 13:45:46 +0800
Message-ID: <20260924054549.2271705-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924054549.2271705-1-cui.tao@linux.dev>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Add the iocost_model_ops struct_ops.  Attachment follows the
hid_bpf_ops model: the struct_ops instance is per-device, the target
device is set in the dev member from userspace before load, .reg
attaches the model to that device and switches it away from the
builtin linear model, and .unreg detaches it and restores the builtin
model.  The struct_ops core owns the program lifetime, so there is no
name registry and no bound-state bookkeeping.

calc_cost() receives the bio itself and reads whatever it needs
from it (operation flags, size, sector, the issuing cgroup); the
merge indicator stays in the separate flags
argument as it is not a property of the bio.  It is called from the
bio charging path, so the model owns pricing for every IO on the
device.  The completion-time request sizing uses the transfer cost
coefficients carried in the struct_ops (vtime per page for reads and
writes) while a model is attached, so the builtin latency tracking
and vrate adjustment follow the model's pricing; letting a model take
over the QoS side is left for a later extension.

Attaching to a partition's device number is rejected: the model
prices the whole queue.  Enabling iocost implicitly through the
attach disables wbt, matching io.cost.qos.

The cgroup callbacks are bound to the iocg policy init/free paths,
one (cgroup, device) pair per invocation, matching the builtin
cursor's lifetime, instead of the blkcg css lifecycle, which also
drops the mutex from the cgroup online/offline paths.

calc_cost() runs under RCU read lock; sleepable programs are
rejected in .check_member.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/Kconfig              |  10 ++
 block/Makefile             |   1 +
 block/blk-iocost-bpf.c     | 171 +++++++++++++++++++++++
 block/blk-iocost.c         | 275 ++++++++++++++++++++++++++++++++++++-
 include/linux/blk-iocost.h | 103 ++++++++++++++
 5 files changed, 556 insertions(+), 4 deletions(-)
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
diff --git a/block/blk-iocost-bpf.c b/block/blk-iocost-bpf.c
new file mode 100644
index 000000000000..2306c5fd6d8d
--- /dev/null
+++ b/block/blk-iocost-bpf.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * blk-iocost: BPF struct_ops plumbing for pluggable cost models.
+ *
+ * Registers the "iocost_model_ops" struct_ops type.  Attachment is
+ * per-device and follows the hid_bpf_ops model: the target device is
+ * set in the ops from userspace before load, .reg attaches the model
+ * to that device and switches it away from the builtin linear model,
+ * .unreg detaches it and restores the builtin model, and the struct_ops
+ * core owns the program lifetime.  There is no name registry and no
+ * separate bound-state bookkeeping.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf.h>
+#include <linux/blk-iocost.h>
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
+	case offsetof(struct iocost_model_ops, bdev_file):
+		/*
+		 * kernel-private: the open bdev file pinning the queue;
+		 * reject a userspace value instead of copying it
+		 */
+		if (uops->bdev_file)
+			return -EINVAL;
+		ops->bdev_file = NULL;
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
+	ioc_bpf_unreg(kdata);
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
index 2745bffcd5ee..21e4f8cbd9f2 100644
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
+	/* attached BPF cost model, NULL = builtin linear model */
+	const struct iocost_model_ops	__rcu *model;
+#endif
 };
 
 struct iocg_pcpu_stat {
@@ -803,8 +809,16 @@ static int ioc_autop_idx(struct ioc *ioc, struct gendisk *disk)
 	if (idx < AUTOP_SSD_DFL)
 		return AUTOP_SSD_DFL;
 
-	/* if user is overriding anything, maintain what was there */
-	if (ioc->user_qos_params || ioc->user_cost_model)
+	/* if user is overriding anything, maintain what was there; the
+	 * same while a BPF model is attached: the builtin coefficients
+	 * are inert then, so stepping the profile is pointless
+	 */
+	if (ioc->user_qos_params || ioc->user_cost_model
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	    || rcu_dereference_protected(ioc->model,
+					 lockdep_is_held(&ioc->lock))
+#endif
+	   )
 		return idx;
 
 	/* step up/down based on the vrate */
@@ -2572,7 +2586,19 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 static u64 calc_vtime_cost(struct bio *bio, struct ioc_gq *iocg, bool is_merge)
 {
 	u64 cost;
-
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *model;
+
+	rcu_read_lock();
+	model = rcu_dereference(iocg->ioc->model);
+	if (model) {
+		cost = model->calc_cost(bio,
+				is_merge ? IOCOST_COST_F_MERGE : 0);
+		rcu_read_unlock();
+		return min(cost, VTIME_PER_SEC);
+	}
+	rcu_read_unlock();
+#endif
 	calc_vtime_cost_builtin(bio, iocg, is_merge, &cost);
 	return cost;
 }
@@ -2594,10 +2620,41 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 	}
 }
 
+/*
+ * Called from the request completion path, where no ioc->lock is
+ * held; the model pointer is read under RCU, matching the bio-side
+ * calc_vtime_cost().
+ */
 static u64 calc_size_vtime_cost(struct request *rq, struct ioc *ioc)
 {
 	u64 cost;
-
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *model;
+
+	rcu_read_lock();
+	model = rcu_dereference(ioc->model);
+	if (model && (req_op(rq) == REQ_OP_READ ||
+		      req_op(rq) == REQ_OP_WRITE)) {
+		unsigned int pages =
+			blk_rq_stats_sectors(rq) >> IOC_SECT_TO_PAGE_SHIFT;
+		u64 coeff = req_op(rq) == REQ_OP_READ ?
+			model->read_vtime_per_page :
+			model->write_vtime_per_page;
+
+		rcu_read_unlock();
+		/* sub-page IO: nothing to transfer-price */
+		if (!pages)
+			return 0;
+		/* zero transfer cost is a legal model; guard the division */
+		if (!coeff)
+			return 0;
+		/* pages * coeff can wrap and dodge the clamp below */
+		if (coeff > VTIME_PER_SEC || pages > VTIME_PER_SEC / coeff)
+			return VTIME_PER_SEC;
+		return min(pages * coeff, VTIME_PER_SEC);
+	}
+	rcu_read_unlock();
+#endif
 	calc_size_vtime_cost_builtin(rq, ioc, &cost);
 	return cost;
 }
@@ -2891,6 +2948,9 @@ static void ioc_rqos_queue_depth_changed(struct rq_qos *rqos)
 static void ioc_rqos_exit(struct rq_qos *rqos)
 {
 	struct ioc *ioc = rqos_to_ioc(rqos);
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *model;
+#endif
 
 	blkcg_deactivate_policy(rqos->disk, &blkcg_policy_iocost);
 
@@ -2900,6 +2960,15 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
 
 	timer_shutdown_sync(&ioc->timer);
 	free_percpu(ioc->pcpu_stat);
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	spin_lock_irq(&ioc->lock);
+	model = rcu_dereference_protected(ioc->model,
+				lockdep_is_held(&ioc->lock));
+	rcu_assign_pointer(ioc->model, NULL);
+	spin_unlock_irq(&ioc->lock);
+	if (model)
+		ioc_bpf_detach((struct iocost_model_ops *)model);
+#endif
 	kfree(ioc);
 }
 
@@ -3022,6 +3091,9 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	struct ioc_now now;
 	struct blkcg_gq *tblkg;
 	unsigned long flags;
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *model;
+#endif
 
 	ioc_now(ioc, &now);
 
@@ -3048,6 +3120,19 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	spin_lock_irqsave(&ioc->lock, flags);
 	weight_updated(iocg, &now);
 	spin_unlock_irqrestore(&ioc->lock, flags);
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	/*
+	 * the model pointer and the ops behind it are RCU-protected:
+	 * a concurrent detach publishes NULL and the struct_ops image
+	 * survives it by a grace period, so the callback is safe
+	 * inside the read-side critical section
+	 */
+	rcu_read_lock();
+	model = rcu_dereference(ioc->model);
+	if (model && model->iocg_init)
+		model->iocg_init(blkg->blkcg, ioc->rqos.disk->queue);
+	rcu_read_unlock();
+#endif
 }
 
 static void iocg_release(struct rcu_head *rcu)
@@ -3066,8 +3151,18 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 	struct blkcg_gq *blkg = pd_to_blkg(pd);
 	struct ioc *ioc = iocg->ioc;
 	unsigned long flags;
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *model;
+#endif
 
 	if (ioc) {
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+		rcu_read_lock();
+		model = rcu_dereference(ioc->model);
+		if (model && model->iocg_free)
+			model->iocg_free(blkg->blkcg, ioc->rqos.disk->queue);
+		rcu_read_unlock();
+#endif
 		spin_lock_irqsave(&ioc->lock, flags);
 
 		if (!list_empty(&iocg->active_list)) {
@@ -3433,17 +3528,34 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
 	const char *dname = blkg_dev_name(pd->blkg);
 	struct ioc *ioc = pd_to_iocg(pd)->ioc;
 	u64 *u = ioc->params.i_lcoefs;
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *model;
+#endif
 
 	if (!dname)
 		return 0;
 
 	spin_lock_irq(&ioc->lock);
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	model = rcu_dereference_protected(ioc->model,
+			lockdep_is_held(&ioc->lock));
+
+	seq_printf(sf, "%s ctrl=%s model=%s "
+		   "rbps=%llu rseqiops=%llu rrandiops=%llu "
+		   "wbps=%llu wseqiops=%llu wrandiops=%llu\n",
+		   dname, ioc->user_cost_model ? "user" : "auto",
+		   model ? "bpf" : "linear",
+		   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS],
+		   u[I_LCOEF_RRANDIOPS], u[I_LCOEF_WBPS],
+		   u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS]);
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
@@ -3457,6 +3569,141 @@ static int ioc_cost_model_show(struct seq_file *sf, void *v)
 	return 0;
 }
 
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+/*
+ * Attach a BPF cost model to the device named by ops->dev: resolve the
+ * queue, make sure iocost is on it, and publish the model.  Attaching
+ * switches the device away from the builtin linear model; detaching
+ * restores it.  The struct_ops core holds the program alive for the
+ * whole registered period, so no extra reference is taken on the ops.
+ */
+int ioc_bpf_attach(struct iocost_model_ops *ops)
+{
+	struct block_device *bdev;
+	struct request_queue *q;
+	struct ioc *ioc;
+	const struct iocost_model_ops *old;
+	struct file *bdevf;
+	int ret;
+
+	bdevf = bdev_file_open_by_dev(new_decode_dev(ops->dev),
+				      BLK_OPEN_READ, NULL, NULL);
+	if (IS_ERR(bdevf))
+		return PTR_ERR(bdevf);
+	bdev = file_bdev(bdevf);
+
+	if (bdev_is_partition(bdev)) {
+		fput(bdevf);
+		return -EINVAL;
+	}
+
+	q = bdev->bd_queue;
+	if (!queue_is_mq(q)) {
+		fput(bdevf);
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&q->rq_qos_mutex);
+	ioc = q_to_ioc(q);
+	if (!ioc) {
+		ret = blk_iocost_init(bdev->bd_disk);
+		if (ret) {
+			mutex_unlock(&q->rq_qos_mutex);
+			fput(bdevf);
+			return ret;
+		}
+		ioc = q_to_ioc(q);
+	}
+
+	/*
+	 * Stay under rq_qos_mutex until the model is published:
+	 * ioc_rqos_exit() frees the ioc under this mutex, so holding
+	 * it keeps the ioc alive through the publish below.  The open
+	 * bdev file pins the queue for as long as the model is
+	 * attached; it is released by the .unreg side of the detach.
+	 */
+	spin_lock_irq(&ioc->lock);
+	old = rcu_dereference_protected(ioc->model,
+					lockdep_is_held(&ioc->lock));
+	if (old) {
+		spin_unlock_irq(&ioc->lock);
+		mutex_unlock(&q->rq_qos_mutex);
+		fput(bdevf);
+		return -EBUSY;
+	}
+	if (!ioc->enabled) {
+		/*
+		 * the controller must run for the model to be consulted:
+		 * enable it like io.cost.qos enable=1 does
+		 */
+		blk_stat_enable_accounting(q);
+		blk_queue_flag_set(QUEUE_FLAG_RQ_ALLOC_TIME, q);
+		ioc->enabled = true;
+		ioc_refresh_params(ioc, true);
+	}
+	rcu_assign_pointer(ioc->model, ops);
+	ops->q = q;
+	ops->bdev_file = bdevf;
+	spin_unlock_irq(&ioc->lock);
+	/* match io.cost.qos: running iocost disables wbt */
+	wbt_disable_default(bdev->bd_disk);
+	mutex_unlock(&q->rq_qos_mutex);
+
+	return 0;
+}
+
+/*
+ * Detach a model.  The caller holds q->rq_qos_mutex, which serializes
+ * this against ioc_bpf_attach(), against ioc_rqos_exit() freeing the
+ * ioc, and against a concurrent .unreg, so the ops->q/model clearing
+ * is idempotent.  The bdev file is not released here: it pins the
+ * queue for the .unreg side, which may still be about to lock it.
+ */
+void ioc_bpf_detach(struct iocost_model_ops *ops)
+{
+	struct request_queue *q = ops->q;
+	struct ioc *ioc;
+
+	if (!q)
+		return;
+
+	ioc = q_to_ioc(q);
+	/* pairs with the lockless READ_ONCE() in ioc_bpf_unreg() */
+	WRITE_ONCE(ops->q, NULL);
+
+	if (!ioc)
+		return;
+
+	spin_lock_irq(&ioc->lock);
+	if (rcu_dereference_protected(ioc->model,
+				      lockdep_is_held(&ioc->lock)) == ops)
+		rcu_assign_pointer(ioc->model, NULL);
+	spin_unlock_irq(&ioc->lock);
+}
+
+/*
+ * The .unreg side of the detach: serialize against the queue
+ * teardown, then drop the bdev file pinning the queue.  ops->q is
+ * stable here: only ioc_bpf_detach() clears it, the file pin keeps
+ * the queue alive until it is dropped below, and .unreg runs once.
+ */
+void ioc_bpf_unreg(struct iocost_model_ops *ops)
+{
+	struct request_queue *q = READ_ONCE(ops->q);
+	struct file *bdevf = ops->bdev_file;
+
+	ops->bdev_file = NULL;
+	if (q)
+		mutex_lock(&q->rq_qos_mutex);
+	ioc_bpf_detach(ops);
+	if (q)
+		mutex_unlock(&q->rq_qos_mutex);
+	if (bdevf)
+		fput(bdevf);
+}
+
+#endif
+
 static const match_table_t cost_ctrl_tokens = {
 	{ COST_CTRL,		"ctrl=%s"	},
 	{ COST_MODEL,		"model=%s"	},
@@ -3531,11 +3778,31 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 				user = false;
 			else if (!strcmp(buf, "user"))
 				user = true;
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+			else if (!strcmp(buf, "bpf")) {
+				/*
+				 * readback value while a BPF model is
+				 * attached; attaching is done by loading
+				 * the struct_ops, not through this file
+				 */
+				continue;
+			}
+#endif
 			else
 				goto unlock;
 			continue;
 		case COST_MODEL:
 			match_strlcpy(buf, &args[0], sizeof(buf));
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+			if (!strcmp(buf, "bpf")) {
+				/*
+				 * readback value while a BPF model is
+				 * attached; attaching is done by loading
+				 * the struct_ops, not through this file
+				 */
+				continue;
+			}
+#endif
 			if (strcmp(buf, "linear"))
 				goto unlock;
 			continue;
diff --git a/include/linux/blk-iocost.h b/include/linux/blk-iocost.h
new file mode 100644
index 000000000000..ce120a8d6007
--- /dev/null
+++ b/include/linux/blk-iocost.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BLK_IOCOST_H
+#define _LINUX_BLK_IOCOST_H
+
+#include <linux/types.h>
+#include <linux/blk_types.h>
+#include <linux/blkdev.h>
+
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
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
+ * hid_bpf_ops model: attaching the struct_ops switches the device to
+ * the BPF model, detaching it restores the builtin linear model, and
+ * the struct_ops core owns the lifetime of the program.  The model
+ * then owns pricing for every charged IO on the device: it prices all
+ * operations, including flushes, from the bio charging path.
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
+ * per page for reads and writes: while a model is attached, the
+ * builtin latency tracking and vrate adjustment use these instead of
+ * the builtin linear coefficients for the completion-time request
+ * sizing, so the whole controller follows the model's pricing.  Letting
+ * a model take over the QoS side entirely (latency tracking, vrate
+ * control) is left for a later extension.
+ *
+ * The cgroup callbacks are bound to the iocg policy lifetime, one
+ * (cgroup, device) pair per invocation, matching the builtin cursor:
+ * state created in init (or lazily on first use) must be released in
+ * free.
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
+	 * target device (major:minor), set from userspace before load;
+	 * must stay the first member so userspace can write it through
+	 * the struct_ops map's initial value
+	 */
+	dev_t dev;
+	/* kernel-private: the open bdev file pinning the queue */
+	struct file *bdev_file;
+
+	/* vtime per page, used by the builtin sizing and vrate logic */
+	u64 read_vtime_per_page;
+	u64 write_vtime_per_page;
+
+	u64 (*calc_cost)(struct bio *bio, u64 model_flags);
+	/*
+	 * per-(cgroup, device) lifecycle: both callbacks run inside
+	 * an RCU read-side critical section (see below) and must not
+	 * sleep; IRQs may be enabled or disabled, so per-CPU state
+	 * must not rely on the IRQs-off guarantee.  iocg_init() is
+	 * delivered for
+	 * cgroups which appear on the device while the model is
+	 * attached; cgroups which already exist when the model is
+	 * attached never see an init, so iocg_free() must tolerate
+	 * freeing state it never initialized.  iocg_free() is only
+	 * delivered while the model is attached: detaching does not
+	 * flush state created by iocg_init(), so models must keep
+	 * their per-cgroup state reclaimable by other means
+	 */
+	void (*iocg_init)(struct blkcg *blkcg, struct request_queue *q);
+	void (*iocg_free)(struct blkcg *blkcg, struct request_queue *q);
+
+	/* private: */
+
+	/* queue of the attached device, NULL = not attached */
+	struct request_queue	*q;
+};
+
+int ioc_bpf_attach(struct iocost_model_ops *ops);
+void ioc_bpf_detach(struct iocost_model_ops *ops);
+void ioc_bpf_unreg(struct iocost_model_ops *ops);
+
+#else	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+
+#endif	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+#endif	/* _LINUX_BLK_IOCOST_H */
-- 
2.43.0

