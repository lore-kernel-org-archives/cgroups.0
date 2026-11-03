Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712403;
	b=Vgp3J1OsXC+WnJn6z7QOVl5KA4pQMO4+pNHyZgJ6mhL/q4g6RCBdYWtSIxYSyCWpYzHm
	 2MqJIHQGGqUMElXljBzqD/RWIO8/C1XkkrgPeodxdNVnSwQ1Q+OD+9sYnbml5CeEISjsp
	 xs+BLtUR/bb3vcZI1aV6moNW58YC6L+jG7adI6eFdSS2a0EcomDpyuHz3t7M8V1ZDOwr3
	 BOcBL2h0lZ/Twu0+41XdlmqmWXEBLGKZbT8NTyuaskHzJmc11hkpUKkJQOjew5XqlqYHY
	 EQ7QaElOp2cuRV0tOkuMdVSJP6UsqDiPeYYRkPOq1BVqUC+50BX42Tg/+VFWlk27vVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712403;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4DFPkQ3JkNZCYp/Le8/q+ptZina1JxxOGDaA+nQOeC4=;
	b=CHWpVb1snOV9umQL1AU4ywy4c0BzY9xJbQd7c8/AWq0EvV61QyZMpKWvjEMYtMFfj1MP
	 BBW188W54fxSPmxGgeP/eTP1b8jpBb3Mrjlp8GfET4f9MHXmTAqJHFMnzugqgqmRX33VI
	 6MnPtiyV7irMAx0iEQcfYbk4rzSYKtPJzE5xf0KXFqPSu1lLRPygu6fKwxO6eHwhKgD9w
	 R/TlEWKTDXPqXI0+wXW/pcvBjx9PjnQERbaK4cX6o2VH7SNNPW/4e6zWZOyNJtBA5k0DJ
	 8Qj05dX7C3Wx+LcBMLeNH+i0JLAXjtMJBX5uVU5XVU0nZ1RaVAi33AZjLeYTvThgaow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WE0lGfke;
	arc=none smtp.remote-ip=95.215.58.33
Received: from mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE4C606D836
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 13:26:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCE4C606D836
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WE0lGfke
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=68fd3ec8OxefCRnXrQz99VObscrTgTeEo+J9NzGlb1s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793712400; v=1; x=1794317200;
 b=WE0lGfkeu1x5p6bqEB8az1PPeC8I4122hax26A0KHinM1YL84rgc9WQaj4b/TPkoYnBhxb7O
 ZKiByZPADbB8q/+56DHkJKyGzka4sj4wKCf6i5Q83/iq124DIHVkizWzm/bpwcMczYQNjZVt/u6
 VDrTDZwQvoRi1HY4hflHcfxA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7f63e2ed4e2609b6;
	Tue, 03 Nov 2026 13:26:39 +0000
X-Mizu-Trace-ID: 7f63e2ed4e2609b6
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	alexei.starovoitov@gmail.com
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
	ameryhung@gmail.com
Subject: [RFC PATCH v12 1/4] blk-iocost: add BPF struct_ops cost model support
Date: Tue,  3 Nov 2026 21:26:10 +0800
Message-ID: <20261103132613.1952975-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103132613.1952975-1-cui.tao@linux.dev>
References: <20261103132613.1952975-1-cui.tao@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

iocost prices IO with a linear model derived from a handful of
device parameters.  The real cost of an IO depends on device
internals the formula cannot capture and the right formula is
device specific.  This lets a BPF program take over pricing for
a device so that the model can be adapted to it without
rebuilding the kernel.

Attaching an iocost_model_ops struct_ops binds the model to one
device: the target is set in the dev member from userspace and
.reg creates the ioc if needed like an io.cost.model write and
publishes the model with the queue frozen and rq_qos_mutex held
like an io.cost.qos write.  The attachment records the owning
link in the ioc, so a second attach on the same device fails
with -EBUSY, and device removal ejects the model.  Detaching
takes only rq_qos_mutex in a single critical section, and the
map is freed after an RCU grace period so that a calc_cost()
already running can finish.  io.cost.model selects between the
attached and builtin models without detaching the struct_ops;
only .unreg or device removal detaches, and .unreg detaches only
its own attachment so a reused dev_t cannot tear down a newer one.
While a model is selected, the automatic profile stepping of
ctrl=auto is suspended; it resumes when the model is switched off
or detached.

While in use, the BPF model prices every charged IO: calc_cost()
is called from the submission path with the bio and returns the
cost in vtime units, clamped to VTIME_PER_SEC by the caller.
The struct_ops also carries the transfer coefficients used by
the completion-time request sizing, so latency tracking and
vrate adjustment follow the model's pricing.  Models without
calc_cost or with zero or out-of-range transfer coefficients
are rejected at registration.

The kernel keeps no per-cgroup state for the model; models
which need per-cgroup data keep it in their own maps, created
and freed with the cgroups.  Without CONFIG_BLK_CGROUP_IOCOST_BPF
the struct_ops is not built and the builtin model is the only
choice.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/Kconfig      |   4 +
 block/blk-iocost.c | 260 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 259 insertions(+), 5 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 70e4a66d941f..26badf54a477 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -161,6 +161,10 @@ config BLK_CGROUP_IOCOST
 	distributes IO capacity between different groups based on
 	their share of the overall weight distribution.
 
+config BLK_CGROUP_IOCOST_BPF
+	def_bool y
+	depends on BLK_CGROUP_IOCOST && BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF
+
 config BLK_CGROUP_IOPRIO
 	bool "Cgroup I/O controller for assigning an I/O priority class"
 	depends on BLK_CGROUP
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 1c1fe07a96ea..22a3d7eb3b1b 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -34,7 +34,7 @@
  * device time.  If a given IO is estimated to cost 10ms, the device should
  * be able to process ~100 of those IOs in a second.
  *
- * Currently, there's only one builtin cost model - linear.  Each IO is
+ * The builtin cost model is linear. Each IO is
  * classified as sequential or random and given a base cost accordingly.
  * On top of that, a size cost proportional to the length of the IO is
  * added.  While simple, this model captures the operational
@@ -179,8 +179,12 @@
 #include <linux/time64.h>
 #include <linux/parser.h>
 #include <linux/sched/signal.h>
+#include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf.h>
 #include <asm/local.h>
 #include <asm/local64.h>
+#include "blk.h"
 #include "blk-rq-qos.h"
 #include "blk-stat.h"
 #include "blk-wbt.h"
@@ -405,6 +409,27 @@ struct ioc_pcpu_stat {
 	u64				last_rq_wait_ns;
 };
 
+enum {
+	IOCOST_COST_F_MERGE	= 1 << 0,	/* called from the merge path */
+};
+
+/* bpf cost model of one device */
+struct iocost_model_ops {
+	/* whole disk, in the new_encode_dev() encoding */
+	dev_t dev;
+
+	/* used by the completion path instead of LCOEF_[RW]PAGE */
+	u64 read_vtime_per_page;
+	u64 write_vtime_per_page;
+
+	/*
+	 * Called for every charged bio from the submission path under
+	 * rcu_read_lock(); must not sleep. Returns the cost of the bio
+	 * in vtime units, clamped to VTIME_PER_SEC by the caller.
+	 */
+	u64 (*calc_cost)(struct bio *bio, u64 model_flags);
+};
+
 /* per device */
 struct ioc {
 	struct rq_qos			rqos;
@@ -448,6 +473,12 @@ struct ioc {
 	int				autop_idx;
 	bool				user_qos_params:1;
 	bool				user_cost_model:1;
+
+	/* holds a reference on the struct_ops map, NULL if none is attached */
+	const struct iocost_model_ops	*attached;
+	struct bpf_link			*attached_link;
+	/* either NULL (linear) or ->attached */
+	const struct iocost_model_ops __rcu *model;
 };
 
 struct iocg_pcpu_stat {
@@ -672,6 +703,13 @@ static struct ioc *q_to_ioc(struct request_queue *q)
 	return rqos_to_ioc(rq_qos_id(q, RQ_QOS_COST));
 }
 
+static const struct iocost_model_ops *ioc_model(struct ioc *ioc)
+{
+	if (!IS_ENABLED(CONFIG_BLK_CGROUP_IOCOST_BPF))
+		return NULL;
+	return rcu_dereference_check(ioc->model, lockdep_is_held(&ioc->lock));
+}
+
 static const char __maybe_unused *ioc_name(struct ioc *ioc)
 {
 	struct gendisk *disk = ioc->rqos.disk;
@@ -857,7 +895,7 @@ static int ioc_autop_idx(struct ioc *ioc, struct gendisk *disk)
 		return AUTOP_SSD_DFL;
 
 	/* if user is overriding anything, maintain what was there */
-	if (ioc->user_qos_params || ioc->user_cost_model)
+	if (ioc->user_qos_params || ioc->user_cost_model || ioc_model(ioc))
 		return idx;
 
 	/* step up/down based on the vrate */
@@ -2656,6 +2694,17 @@ static u64 calc_vtime_cost(struct bio *bio, struct ioc_gq *iocg, bool is_merge)
 {
 	u64 cost;
 
+	if (IS_ENABLED(CONFIG_BLK_CGROUP_IOCOST_BPF)) {
+		const struct iocost_model_ops *model;
+
+		guard(rcu)();
+		model = ioc_model(iocg->ioc);
+		if (model) {
+			cost = model->calc_cost(bio, is_merge ? IOCOST_COST_F_MERGE : 0);
+			return min(cost, VTIME_PER_SEC);
+		}
+	}
+
 	calc_vtime_cost_builtin(bio, iocg, is_merge, &cost);
 	return cost;
 }
@@ -2682,6 +2731,17 @@ static u64 calc_size_vtime_cost(struct request *rq, struct ioc *ioc)
 {
 	u64 cost;
 
+	if (IS_ENABLED(CONFIG_BLK_CGROUP_IOCOST_BPF)) {
+		const struct iocost_model_ops *model;
+
+		guard(rcu)();
+		model = ioc_model(ioc);
+		if (model)
+			return (blk_rq_stats_sectors(rq) >> IOC_SECT_TO_PAGE_SHIFT) *
+				(req_op(rq) == REQ_OP_READ ? model->read_vtime_per_page :
+							     model->write_vtime_per_page);
+	}
+
 	calc_size_vtime_cost_builtin(rq, ioc, &cost);
 	return cost;
 }
@@ -2976,10 +3036,33 @@ static void ioc_rqos_queue_depth_changed(struct rq_qos *rqos)
 	spin_unlock_irq(&ioc->lock);
 }
 
+/* Called by .unreg and by device removal, whichever is first. */
+static void ioc_detach_model(struct ioc *ioc)
+{
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	const struct iocost_model_ops *ops = ioc->attached;
+
+	lockdep_assert_held(&ioc->rqos.disk->queue->rq_qos_mutex);
+
+	if (!ops)
+		return;
+
+	spin_lock_irq(&ioc->lock);
+	rcu_assign_pointer(ioc->model, NULL);
+	ioc->attached = NULL;
+	ioc->attached_link = NULL;
+	spin_unlock_irq(&ioc->lock);
+
+	/* calc_cost() can still run. The map is freed after an RCU gp. */
+	bpf_struct_ops_put(ops);
+#endif
+}
+
 static void ioc_rqos_exit(struct rq_qos *rqos)
 {
 	struct ioc *ioc = rqos_to_ioc(rqos);
 
+	ioc_detach_model(ioc);
 	blkcg_deactivate_policy(rqos->disk, &blkcg_policy_iocost);
 
 	spin_lock_irq(&ioc->lock);
@@ -3223,7 +3306,6 @@ static u64 ioc_weight_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
 	return 0;
 }
 
-
 static int ioc_weight_show(struct seq_file *sf, void *v)
 {
 	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
@@ -3531,11 +3613,12 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
 		return 0;
 
 	spin_lock_irq(&ioc->lock);
-	seq_printf(sf, "%s ctrl=%s model=linear "
+	seq_printf(sf, "%s ctrl=%s model=%s "
 		   "rbps=%llu rseqiops=%llu rrandiops=%llu "
 		   "wbps=%llu wseqiops=%llu wrandiops=%llu "
 		   "flushiops=%llu\n",
 		   dname, ioc->user_cost_model ? "user" : "auto",
+		   ioc_model(ioc) ? "bpf" : "linear",
 		   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS], u[I_LCOEF_RRANDIOPS],
 		   u[I_LCOEF_WBPS], u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS],
 		   u[I_LCOEF_FLUSHIOPS]);
@@ -3572,6 +3655,7 @@ static const match_table_t i_lcoef_tokens = {
 static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 				    size_t nbytes, loff_t off)
 {
+	const struct iocost_model_ops *model;
 	struct blkg_conf_ctx ctx;
 	struct request_queue *q;
 	unsigned int memflags;
@@ -3608,6 +3692,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	spin_lock_irq(&ioc->lock);
 	memcpy(u, ioc->params.i_lcoefs, sizeof(u));
 	user = ioc->user_cost_model;
+	model = ioc_model(ioc);
 
 	ret = -EINVAL;
 
@@ -3632,7 +3717,11 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 			continue;
 		case COST_MODEL:
 			match_strlcpy(buf, &args[0], sizeof(buf));
-			if (strcmp(buf, "linear"))
+			if (!strcmp(buf, "linear"))
+				model = NULL;
+			else if (!strcmp(buf, "bpf") && ioc->attached)
+				model = ioc->attached;
+			else
 				goto unlock;
 			continue;
 		}
@@ -3652,6 +3741,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	} else {
 		ioc->user_cost_model = false;
 	}
+	rcu_assign_pointer(ioc->model, model);
 	ioc_refresh_params(ioc, true);
 
 	ret = 0;
@@ -3699,6 +3789,166 @@ static struct blkcg_policy blkcg_policy_iocost = {
 	.pd_stat_fn	= ioc_pd_stat,
 };
 
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+static int ioc_bpf_reg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *ops = kdata;
+	struct block_device *bdev;
+	struct request_queue *q;
+	unsigned int memflags;
+	struct ioc *ioc;
+	int ret;
+
+	bdev = blkdev_get_no_open(new_decode_dev(ops->dev), false);
+	if (!bdev)
+		return -ENODEV;
+
+	q = bdev_get_queue(bdev);
+	if (bdev_is_partition(bdev) || !queue_is_mq(q)) {
+		blkdev_put_no_open(bdev);
+		return -EOPNOTSUPP;
+	}
+
+	/* the order of ioc_qos_write() */
+	memflags = blk_mq_freeze_queue(q);
+	mutex_lock(&q->rq_qos_mutex);
+
+	ret = -ENODEV;
+	if (!disk_live(bdev->bd_disk))
+		goto out;
+
+	ioc = q_to_ioc(q);
+	if (!ioc) {
+		ret = blk_iocost_init(bdev->bd_disk);
+		if (ret)
+			goto out;
+		ioc = q_to_ioc(q);
+	}
+
+	ret = -EBUSY;
+	if (ioc->attached || !bpf_struct_ops_get(ops))
+		goto out;
+
+	spin_lock_irq(&ioc->lock);
+	ioc->attached = ops;
+	ioc->attached_link = link;
+	rcu_assign_pointer(ioc->model, ops);
+	spin_unlock_irq(&ioc->lock);
+	ret = 0;
+out:
+	mutex_unlock(&q->rq_qos_mutex);
+	blk_mq_unfreeze_queue(q, memflags);
+	blkdev_put_no_open(bdev);
+	return ret;
+}
+
+static void ioc_bpf_unreg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *ops = kdata;
+	struct block_device *bdev;
+	struct request_queue *q;
+	struct ioc *ioc;
+
+	/* del_gendisk() is in progress or done. ioc_rqos_exit() detaches. */
+	bdev = blkdev_get_no_open(new_decode_dev(ops->dev), false);
+	if (!bdev)
+		return;
+
+	q = bdev_get_queue(bdev);
+	mutex_lock(&q->rq_qos_mutex);
+	ioc = q_to_ioc(q);
+	/* the dev_t can belong to another disk and another model by now */
+	if (ioc && ioc->attached == ops && ioc->attached_link == link)
+		ioc_detach_model(ioc);
+	mutex_unlock(&q->rq_qos_mutex);
+	blkdev_put_no_open(bdev);
+}
+
+static int ioc_bpf_init(struct btf *btf)
+{
+	return 0;
+}
+
+static int ioc_bpf_check_member(const struct btf_type *t,
+				const struct btf_member *member,
+				const struct bpf_prog *prog)
+{
+	return prog->sleepable ? -EINVAL : 0;
+}
+
+static int ioc_bpf_init_member(const struct btf_type *t,
+			       const struct btf_member *member,
+			       void *kdata, const void *udata)
+{
+	const struct iocost_model_ops *uops = udata;
+	struct iocost_model_ops *ops = kdata;
+
+	switch (__btf_member_bit_offset(t, member) / 8) {
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
+	return 0;
+}
+
+static int ioc_bpf_validate(void *kdata)
+{
+	struct iocost_model_ops *ops = kdata;
+
+	/*
+	 * Bound the transfer coefficients so that coefficient * pages
+	 * cannot wrap u64 for any possible request size.
+	 */
+	if (ops->read_vtime_per_page > (VTIME_PER_SEC >> IOC_SECT_TO_PAGE_SHIFT) ||
+	    ops->write_vtime_per_page > (VTIME_PER_SEC >> IOC_SECT_TO_PAGE_SHIFT))
+		return -EINVAL;
+
+	if (!ops->dev || !ops->calc_cost ||
+	    !ops->read_vtime_per_page || !ops->write_vtime_per_page)
+		return -EINVAL;
+	return 0;
+}
+
+static u64 ioc_bpf_calc_cost_stub(struct bio *bio, u64 model_flags)
+{
+	return 0;
+}
+
+static struct iocost_model_ops ioc_bpf_stubs = {
+	.calc_cost	= ioc_bpf_calc_cost_stub,
+};
+
+static const struct bpf_verifier_ops ioc_bpf_verifier_ops = {
+	.get_func_proto		= bpf_base_func_proto,
+	.is_valid_access	= bpf_tracing_btf_ctx_access,
+};
+
+static struct bpf_struct_ops ioc_bpf_struct_ops = {
+	.verifier_ops	= &ioc_bpf_verifier_ops,
+	.init		= ioc_bpf_init,
+	.check_member	= ioc_bpf_check_member,
+	.init_member	= ioc_bpf_init_member,
+	.validate	= ioc_bpf_validate,
+	.reg		= ioc_bpf_reg,
+	.unreg		= ioc_bpf_unreg,
+	.cfi_stubs	= &ioc_bpf_stubs,
+	.name		= "iocost_model_ops",
+	.owner		= THIS_MODULE,
+};
+
+static int __init ioc_bpf_struct_ops_init(void)
+{
+	return register_bpf_struct_ops(&ioc_bpf_struct_ops, iocost_model_ops);
+}
+late_initcall(ioc_bpf_struct_ops_init);
+#endif
+
 static int __init ioc_init(void)
 {
 	return blkcg_policy_register(&blkcg_policy_iocost);
-- 
2.53.0

