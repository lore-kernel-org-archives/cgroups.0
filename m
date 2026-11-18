Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.68
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795007458;
	b=2LIron8S0+Nylz/gSew4vrdMZIGQUDf2gNqPyknKRSUpfXYgZZgfWy530mRAVAnu4y8x
	 eH57kt6Eodjw8YcXIqJm4QqUfw+MKeUrTSuKfa89icuL4V/85D9ztzuovD62FHoERkx5o
	 Me27Et5bF+1ugnVAlJfafcHd11bMP0eAzk9+Fpt8NH79TUQuzraSHgPzoWrNWLs+rdfVL
	 BevQspn5JaKQB/Lh20lkKtmM8hF7o3ul+bZzkvGK+pnD53FaTrpCy7Ke1o/DxAJXmliYB
	 RCTcWZnb/qvTjfATfGq9Ht5yiWecgkBojSn0XKFkjdkDvjHG2b4iOwn2YIPtCprc1Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007458;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+sHTSrHfHlkbrE4lCoHD4ulbEfOJliQM//IgCsfmwCE=;
	b=KgQspT1Sy/MHqI7V7pNtrDfI1+zWbfTG1ae97uUJQu3idtO3hn7SXd6s366UFQ1Oid/p
	 SeC65UzROfBAS8sIZGVH+17U3KUOhZ3PjeFeHGFGOH1nO1YVrEtYbKqSQG0jv76cd95eM
	 czPKmCbj4kkytCSjSmvsPCm1hYNhKVpmw5dq2lXfdftF1YinDewbBqrv7Ec3OrwGQMjKh
	 FludlOyciCKaDxK4h+6PaxnuiWfYt95empBhUKuNvfIKOP6dOAzunsrwkaxUm1HaVoFGE
	 zLofIm3y1l3dIqCP50fRrptnYL+XZE9m7hsqkUHSNuUaiFbNqDVJ8EH/KN6UT1vfONg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Q+vAy3wx;
	arc=none smtp.remote-ip=91.218.175.68
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC25606A32C
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 13:10:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEC25606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Q+vAy3wx
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZDQJZGFlJ68xV8QifYKLUVJdoxIZLxLfSuX3QH6+ICo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795007454; v=1; x=1795612254;
 b=Q+vAy3wx+34uUfcugHR+5FF8tU3sexBcsysHV9B6efp6Pmju8JKoU9NpZyVzyxfEyQdtmD+A
 +aeM3Xk4M9dnif8BZdqFOWg6U302p4p930J3RNRAyX63gqS9+uDETN3YfW6yX6jEmM0OWCVWp9j
 Z1p+B6aXik2iB3JfmNTyJ/wo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 23a3a3682d9161a1;
	Wed, 18 Nov 2026 13:10:54 +0000
X-Mizu-Trace-ID: 23a3a3682d9161a1
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	ast@kernel.org,
	alexei.starovoitov@gmail.com
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	andrii@kernel.org,
	eddyz87@gmail.com,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn,
	ameryhung@gmail.com
Subject: [RFC PATCH v14 1/4] blk-iocost: add BPF struct_ops cost model support
Date: Wed, 18 Nov 2026 21:10:26 +0800
Message-ID: <20261118131029.797007-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118131029.797007-1-cui.tao@linux.dev>
References: <20261118131029.797007-1-cui.tao@linux.dev>
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
device parameters. The real cost of an IO depends on device
internals the formula cannot capture and the right formula is
device specific. This lets a BPF program take over pricing for
a device so that the model can be adapted to it without
rebuilding the kernel.

Attaching an iocost_model_ops struct_ops binds the model to one
device: each device has at most one attached model, and
attaching switches the device's pricing to it while io.cost.qos
keeps controlling whether the device is throttled at all. The
model remains the pricing authority across io.cost.model
writes: "model=linear" and "model=bpf" only select between the
attached model and the builtin one. The model steps down when
the struct_ops link is deleted or the device is removed, at
which point the device reverts to the builtin model. Attaching
does not enable the controller.

Attaching also guarantees that the model cannot go away while it
is pricing: iocost holds its own reference on the model, so
neither deleting the link nor removing the device in the middle
of a removal race can free a model whose prices are still being
applied, and the model is released only after in-flight
calc_cost() calls have finished. Models without calc_cost or
with zero or out-of-range transfer coefficients are rejected
when attached, and the transfer coefficients drive the
completion-time request sizing, so latency tracking and vrate
adjustment follow the model's pricing.

The kernel keeps no per-cgroup state for the model; models
which need per-cgroup data keep it in their own maps, created
and freed with the cgroups. Without CONFIG_BLK_CGROUP_IOCOST_BPF
the struct_ops is not built and the builtin model is the only
choice.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Alexei Starovoitov <ast@kernel.org>
---
 block/Kconfig      |   4 +
 block/blk-iocost.c | 342 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 342 insertions(+), 4 deletions(-)

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
index 0ffe34bd95b7..8398a406f7d3 100644
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
@@ -405,6 +409,39 @@ struct ioc_pcpu_stat {
 	u64				last_rq_wait_ns;
 };
 
+/*
+ * Flags for iocost_model_ops.calc_cost(), named after the callback
+ * they're passed to so that BPF programs can look them up through BTF.
+ */
+enum iocost_calc_flags {
+	/*
+	 * The bio is being merged into an IO which was already charged
+	 * its base cost. The model should price only the incremental
+	 * cost: the builtin model skips the seek component and charges
+	 * the page cost in this case.
+	 */
+	IOCOST_CALC_MERGE	= 1 << 0,
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
+	 * Called from the submission and merge paths for every charged
+	 * bio (reads, writes, zone appends and flush-flagged bios)
+	 * under rcu_read_lock(), possibly with a scheduler lock held
+	 * on the merge path; must not sleep. Returns the cost of the
+	 * bio in vtime units, clamped to VTIME_PER_SEC by the caller.
+	 */
+	u64 (*calc_cost)(struct bio *bio, u64 calc_flags);
+};
+
 /* per device */
 struct ioc {
 	struct rq_qos			rqos;
@@ -448,6 +485,28 @@ struct ioc {
 	int				autop_idx;
 	bool				user_qos_params:1;
 	bool				user_cost_model:1;
+
+	/*
+	 * Holds a reference on the struct_ops map, NULL if none is
+	 * attached. The reference is what keeps the map alive when the
+	 * link is destroyed after del_gendisk() has unhashed the bdev
+	 * but before rq_qos_exit(); .unreg can't look up the disk in
+	 * that window and returns without detaching, and the link
+	 * drops its reference; iocost's own survives until
+	 * ioc_rqos_exit() detaches the model.
+	 *
+	 * The attached and attached_link fields are protected by
+	 * rq_qos_mutex.
+	 *
+	 * The bpf_model field is written under rq_qos_mutex and
+	 * ioc->lock, and read with either RCU or ioc->lock held; the
+	 * timer and the io.cost.model show paths read it under
+	 * ioc->lock without rq_qos_mutex.
+	 */
+	const struct iocost_model_ops	*attached;
+	struct bpf_link			*attached_link;
+	/* either NULL (linear) or ->attached */
+	const struct iocost_model_ops __rcu *bpf_model;
 };
 
 struct iocg_pcpu_stat {
@@ -672,6 +731,13 @@ static struct ioc *q_to_ioc(struct request_queue *q)
 	return rqos_to_ioc(rq_qos_id(q, RQ_QOS_COST));
 }
 
+static const struct iocost_model_ops *ioc_bpf_model(struct ioc *ioc)
+{
+	if (!IS_ENABLED(CONFIG_BLK_CGROUP_IOCOST_BPF))
+		return NULL;
+	return rcu_dereference_check(ioc->bpf_model, lockdep_is_held(&ioc->lock));
+}
+
 static const char __maybe_unused *ioc_name(struct ioc *ioc)
 {
 	struct gendisk *disk = ioc->rqos.disk;
@@ -857,7 +923,7 @@ static int ioc_autop_idx(struct ioc *ioc, struct gendisk *disk)
 		return AUTOP_SSD_DFL;
 
 	/* if user is overriding anything, maintain what was there */
-	if (ioc->user_qos_params || ioc->user_cost_model)
+	if (ioc->user_qos_params || ioc->user_cost_model || ioc_bpf_model(ioc))
 		return idx;
 
 	/* step up/down based on the vrate */
@@ -2657,6 +2723,41 @@ static u64 calc_vtime_cost(struct bio *bio, struct ioc_gq *iocg, bool is_merge)
 {
 	u64 cost;
 
+	if (IS_ENABLED(CONFIG_BLK_CGROUP_IOCOST_BPF)) {
+		const struct iocost_model_ops *model;
+
+		guard(rcu)();
+		model = ioc_bpf_model(iocg->ioc);
+		if (model) {
+			bool is_flush = (bio->bi_opf & REQ_PREFLUSH) ||
+				((bio->bi_opf & REQ_FUA) &&
+				 !bdev_fua(bio->bi_bdev));
+
+			/*
+			 * Keep the pricing scope the same as the builtin
+			 * model: bios with no data and no flush state, and
+			 * ops other than reads, writes and zone appends,
+			 * cost nothing. Flushes are passed through so that
+			 * the model can price them from the bio flags.
+			 */
+			switch (bio_op(bio)) {
+			case REQ_OP_READ:
+			case REQ_OP_WRITE:
+			case REQ_OP_ZONE_APPEND:
+				if (!bio->bi_iter.bi_size && !is_flush)
+					return 0;
+				break;
+			default:
+				if (!is_flush)
+					return 0;
+				break;
+			}
+
+			cost = model->calc_cost(bio, is_merge ? IOCOST_CALC_MERGE : 0);
+			return min(cost, VTIME_PER_SEC);
+		}
+	}
+
 	calc_vtime_cost_builtin(bio, iocg, is_merge, &cost);
 	return cost;
 }
@@ -2683,6 +2784,27 @@ static u64 calc_size_vtime_cost(struct request *rq, struct ioc *ioc)
 {
 	u64 cost;
 
+	if (IS_ENABLED(CONFIG_BLK_CGROUP_IOCOST_BPF)) {
+		const struct iocost_model_ops *model;
+		unsigned int pages;
+
+		guard(rcu)();
+		model = ioc_bpf_model(ioc);
+		if (model) {
+			/* same op scope as the builtin model */
+			pages = blk_rq_stats_sectors(rq) >> IOC_SECT_TO_PAGE_SHIFT;
+			switch (req_op(rq)) {
+			case REQ_OP_READ:
+				return pages * model->read_vtime_per_page;
+			case REQ_OP_ZONE_APPEND:
+			case REQ_OP_WRITE:
+				return pages * model->write_vtime_per_page;
+			default:
+				return 0;
+			}
+		}
+	}
+
 	calc_size_vtime_cost_builtin(rq, ioc, &cost);
 	return cost;
 }
@@ -2980,10 +3102,33 @@ static void ioc_rqos_queue_depth_changed(struct rq_qos *rqos)
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
+	rcu_assign_pointer(ioc->bpf_model, NULL);
+	spin_unlock_irq(&ioc->lock);
+	ioc->attached = NULL;
+	ioc->attached_link = NULL;
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
@@ -3535,11 +3680,12 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
 		return 0;
 
 	spin_lock_irq(&ioc->lock);
-	seq_printf(sf, "%s ctrl=%s model=linear "
+	seq_printf(sf, "%s ctrl=%s model=%s "
 		   "rbps=%llu rseqiops=%llu rrandiops=%llu "
 		   "wbps=%llu wseqiops=%llu wrandiops=%llu "
 		   "flushiops=%llu\n",
 		   dname, ioc->user_cost_model ? "user" : "auto",
+		   ioc_bpf_model(ioc) ? "bpf" : "linear",
 		   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS], u[I_LCOEF_RRANDIOPS],
 		   u[I_LCOEF_WBPS], u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS],
 		   u[I_LCOEF_FLUSHIOPS]);
@@ -3576,6 +3722,7 @@ static const match_table_t i_lcoef_tokens = {
 static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 				    size_t nbytes, loff_t off)
 {
+	const struct iocost_model_ops *model;
 	struct blkg_conf_ctx ctx;
 	struct request_queue *q;
 	unsigned int memflags;
@@ -3612,6 +3759,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	spin_lock_irq(&ioc->lock);
 	memcpy(u, ioc->params.i_lcoefs, sizeof(u));
 	user = ioc->user_cost_model;
+	model = ioc_bpf_model(ioc);
 
 	ret = -EINVAL;
 
@@ -3636,7 +3784,11 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
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
@@ -3656,6 +3808,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	} else {
 		ioc->user_cost_model = false;
 	}
+	rcu_assign_pointer(ioc->bpf_model, model);
 	ioc_refresh_params(ioc, true);
 
 	ret = 0;
@@ -3703,6 +3856,187 @@ static struct blkcg_policy blkcg_policy_iocost = {
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
+	if (ioc->attached) {
+		ret = -EBUSY;
+		goto out;
+	}
+	/* defensive; the owning map cannot be gone for a live link */
+	if (!bpf_struct_ops_get(ops)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ioc->attached = ops;
+	ioc->attached_link = link;
+
+	spin_lock_irq(&ioc->lock);
+	rcu_assign_pointer(ioc->bpf_model, ops);
+	/*
+	 * Stepping is paused while a BPF model is selected. Drop any
+	 * pending builtin step candidate so it cannot fire against the
+	 * builtin model after a switchback.
+	 */
+	ioc->autop_too_fast_at = 0;
+	ioc->autop_too_slow_at = 0;
+	/*
+	 * Settle the autop state now that stepping is suspended; the
+	 * stale pre-attach profile would otherwise linger until the
+	 * next unrelated refresh event.
+	 */
+	ioc_refresh_params(ioc, true);
+	spin_unlock_irq(&ioc->lock);
+
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

