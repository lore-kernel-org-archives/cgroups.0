Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793967870;
	b=fzdP3rjyoopl0yWtklR8lTlU6Uu4eVPuW6U5DokxkKkUu/qgbPzRcniUrwwX22teT+Wp
	 Y37ZACCibDvU/3YSOpFk+/VKL5zytFRZEbOMtzp79z2I9cNSkpfbW8dZ//iN1Mh5dkzkC
	 R6xkouTnmvUCuQqXS7ygDTW5RYM6EnlDmbMW/vH9Fs4K7m1ALZPO3txZazHqNDdoXJ3W1
	 M28eG1f+3Xp9CaH4BBrvP+wbfj7hl9I3hQhSKuPpzNSsfWr+lmmOuiMkohYMxAZ78Decb
	 NBuhELTjhXPx6QJngslRX7egYpvbeiO4RY5KaqzZ6jvwlnSd7fn/rA4C1L6isOy0lMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793967870;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=d/plxLK5/VvSlpWeYYSY5N7ByZ/CkW9BkDchgduiHgY=;
	b=zSh7G7xOIo+h7oW//SDHW+vc87IXeGbYAwI1sk16kRdd/8mJEKYIp3LnQ6URhjvZFsJ/
	 BDYv+3wvhs7LkoYbAzGQfuW3eJaGy1kvpgLl0IX/dGMgV0s8vukGVOxQuM4BY1dmy4bCI
	 dDdpN3mXCJUdXl5A+3Flhnm1sX0/sCG30jT8WCl2L2tsPaAe90xISVWWAhsGLyPba9NZF
	 q0doVrmgQwbICkTXRy38u6eUI6U2D3cABPhgDPNFpqTvjiqE7+MMVLwE5FsLZJgDIgcyS
	 WZuE2n27J9+hGjRwcauWkPeXJRLddxwghgDU8+8hPBUDZL4C2IhXhQsYc4kVSmlRANQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iK9VbvzA;
	arc=none smtp.remote-ip=91.218.175.110
Received: from mta0.migadu.com (out-110.mta0.migadu.com [91.218.175.110])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC859606A332
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 12:24:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC859606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iK9VbvzA
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uhT9LkBEdKLfR+Q6VR5Dy367mKme/l6XlVV59MMHo+M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793967862; v=1; x=1794572662;
 b=iK9VbvzAVIaXSsw72Lzt7EHF7nLCqfiuFqViIr/e2Ek6xcKxi1UP93GqpAS8Ca0MpS/0klOg
 vQ6E2Qw/qhtu7g3dq7iYNOd9NsNEsI8YPYIG9SK8mVcIH4za+KbBn+dluyslV4qvcqHIpukEDCp
 vqVhEk9CSU2Sc75BpZuLSAqo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5c5a1bfc6c9fc38a;
	Fri, 06 Nov 2026 12:24:22 +0000
X-Mizu-Trace-ID: 5c5a1bfc6c9fc38a
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
Subject: [RFC PATCH v13 1/4] blk-iocost: add BPF struct_ops cost model support
Date: Fri,  6 Nov 2026 20:23:53 +0800
Message-ID: <20261106122356.3224638-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106122356.3224638-1-cui.tao@linux.dev>
References: <20261106122356.3224638-1-cui.tao@linux.dev>
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
Acked-by: Alexei Starovoitov <ast@kernel.org>
---
 block/Kconfig      |   4 +
 block/blk-iocost.c | 266 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 266 insertions(+), 4 deletions(-)

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
index 1c1025157d8e..c3d195fe4a89 100644
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
@@ -2979,10 +3039,40 @@ static void ioc_rqos_queue_depth_changed(struct rq_qos *rqos)
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
+	/*
+	 * stepping resumes with the timestamps at their pre-attach
+	 * values, which would immediately satisfy the 10s cooldown;
+	 * start it fresh instead
+	 */
+	ioc->autop_too_fast_at = 0;
+	ioc->autop_too_slow_at = 0;
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
@@ -3534,11 +3624,12 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
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
@@ -3575,6 +3666,7 @@ static const match_table_t i_lcoef_tokens = {
 static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 				    size_t nbytes, loff_t off)
 {
+	const struct iocost_model_ops *model;
 	struct blkg_conf_ctx ctx;
 	struct request_queue *q;
 	unsigned int memflags;
@@ -3611,6 +3703,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	spin_lock_irq(&ioc->lock);
 	memcpy(u, ioc->params.i_lcoefs, sizeof(u));
 	user = ioc->user_cost_model;
+	model = ioc_model(ioc);
 
 	ret = -EINVAL;
 
@@ -3635,7 +3728,11 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
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
@@ -3655,6 +3752,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	} else {
 		ioc->user_cost_model = false;
 	}
+	rcu_assign_pointer(ioc->model, model);
 	ioc_refresh_params(ioc, true);
 
 	ret = 0;
@@ -3702,6 +3800,166 @@ static struct blkcg_policy blkcg_policy_iocost = {
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

