Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203140;
	b=0s3w6FU4qi/BUV9YP/K0b77hIl7Olqe2UD2WXkVABL/j8k+LsPt09Ge5k4S5flfjPa/J
	 j/pGmf8YYwjm3X2fY6yOKO0uJTG++TT9uRc0FzJY3/QHp+6fziIcVkYnKJdJDAxL5rlqT
	 PL4un35/DH+g99rV0lIrAt7amzaaa7EPd8y/6MqSYBbvAz4ZJlWColHMWUnQ2v7YjyvnO
	 OkzwlKV0BD5GMak8704CwiuDXW+PpMEAC4p8yxmP8LYrTuwFt61kV2IG+jcpvGD6Q4mKF
	 qjfY7MsYJg6a/bR0t5iHSY6sq+nVDdzbp+Vl+1Uk5Sk02DhaFZ9tHqUtj+ZhovhQMjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203140;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Content-Type:Date:
	 Message-Id:Cc:Subject:From:To:In-Reply-To:References:
	 Content-Transfer-Encoding:MIME-Version;
	bh=xZM+6q50K9EVTq33XWXLbwM2IHgwD8amyn3g+mdBYz0=;
	b=Ja962cgQILLatYXu52GFdHNjzg/0Boa2LV/0QJXxaNpDdaI34KHvI0S1RylkRsBWMh1i
	 WwBNTLmrgJ7JHa3vngMVy8bb9c4b8MCgJPUzeHVf6E1tJ9/rxTSQkzNEnIubLiZqLi557
	 hnE4Bj7sxCCmHFj8RH710EKpL/OBv+WY013isqGCC8wSexP5L1/fil6ZosGv7rlUVjlb+
	 88kISxOr/XLEuL9ApQk1NhhG/1rw6kHmLwB3eMX28uYKEi75tAqEbLGxM41sSrtvLQoeR
	 nl4d/zNBH6LThwNtsV+YU/aTFpzQzSxIS5p3+SMYO37V4ln4A2uHIoEiPaH4M2ftNfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FNS7dRrs;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334EB606A323
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 15:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 334EB606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FNS7dRrs
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a06ca6e8f4so866380b3a.1
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 08:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793203139; x=1793807939; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xZM+6q50K9EVTq33XWXLbwM2IHgwD8amyn3g+mdBYz0=;
        b=FNS7dRrsO7vAoMUGi+/AOQHv8b9N6CXKx4+RBXmu0pMb/G4320m4w/vIZxp4y2h3Po
         Lxmy+vW7bjSjwoXUCgojyI1Rwjhpp0F2gB+xXMXYUgUGVzb8Vr2Eb2jHhzdeUJrnVX3O
         IIiP+DWWw6garY0zXyCEgbNtp3ex3fccPi0e4B4v3DlfI//cDdpphz6rXjadipK+wI6E
         RXaDUlqBsaPhfUmcalX75Fmfl4ElvHbGEvUUIMSe7wRpI321XMCS9Ma0sjXuKjvkW6sl
         rpHHWmhaW2sySP5oSFShvRlijHze5Gc0F6f+yqd3p7ot+iGSchESYtG1bYi6UAeb0GjN
         jrwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793203139; x=1793807939;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xZM+6q50K9EVTq33XWXLbwM2IHgwD8amyn3g+mdBYz0=;
        b=pr94NuIwdrFVNdGQe4pJqSBufrN3FvP8lyljX92Y4Z9f2dljyZ3jAlreafZwcoYME3
         S/I7Q1R98gRTHEQ7NYNnYqlvzOsFWiKq4tAibnIsktmPL7Su6FoF4Uqqh4T/kxHKa0bZ
         KIJyqf9S/cQ2KwRQ//u6PuVOCftVTT945J5lRjqpB1ELo1lrxd3D6aiWdVmR8T9MPNP0
         Xc0iVROyj/PVAxt/mZnBGCoHaLR1R2W4P48/0evpMAr7/OgqpiQxl1Imm+JquvEPNNus
         Bb/2tO3aKzSr8erTGhFkkYfdG7WPTT26LDqZNNUB6Z0aanwtt4JFBVAHRjmCVNgESmZg
         gojQ==
X-Gm-Message-State: AFq9FYK9m4ebVisKkgF8j15VvSjEwCMtfl9RLifi9Tsjry6c0BnO/iTw
	MT36CwNo/LONGvz5dg4qtzShltdIyMMCNNfjq8BZdNNqyylKnJz31wO5
X-Gm-Gg: AYBFou2dthgFfLJDXYvw7eGgWsUtuPlQx2hQbW1tcjnboYOcSQvDR36ffaZ1UZgR3qB
	q66QbI2XrVtjyBybL3So3vErqtjXL0TrKVir967+/kRM4BlUD+XkJ2pUbhsxyYP2+1uZ1aF2YOs
	dIqXywZAVNgKkjb7STiKmbnWQ7xtHLxuoHMzKLAKnhyj3jVNSOs3bknaQBXr6f7JuKQHSxoC5DD
	yNEJrBpHskcZTbeqAr1hJ3qNA85SdQIg3A/X6TtAAtqQJd4y2iibQCPrkNuRalq5IiRtGH7YBIy
	99p7MIV97Wk/p+9v/V9UTwBl2eMCD37aVcNyckTsIjFtZ8xqJYiOsHR3Juwfeli+dDSDYK8vDuR
	AGYM/WebbMUaj7xOv0hKsspG2KWL4fu26iE+JlvDNWX8BhQf6vEQkUdW4s/HGUjU2QayQK2GXfR
	AtXR6C5KOpsqSd+1u3psSgyxAgaEzDnvCF2zYKbfe6c5IjtzabLP/ltWtO+ILHTLF7i+h2HXgy1
	WUGeNXq6CVsHnwoSv5Ck/9+y73zVy9qSSJxLeN+iFM6kvzdJTSRVxgytfRXOEJ1pwd8SpSLwSSk
	lwWNAXeJNA2W9VqP+PTnDsPX+ZTsrKONhhBjcNQtGyWJ5wLixmOCdXpVDHHICqz0DrnNC6jt1Qm
	eDSgTgKXnMIyCCG5sBYqPMJHKX3lKL1LlKa2mrYyreI7a75NTKISnY6nH
X-Received: by 2002:a05:6a20:488:b0:3e2:83bb:a608 with SMTP id adf61e73a8af0-3e902092342mr2324485637.2.1793203139084;
        Wed, 28 Oct 2026 08:58:59 -0700 (PDT)
Received: from localhost ([153.61.198.247])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5baf4sm1482399b3a.1.2026.10.28.08.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 08:58:58 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 Oct 2026 15:58:57 +0000
Message-Id: <DMGLGKYOLXFA.12EJEMVN58Y5P@gmail.com>
Cc: <cgroups@vger.kernel.org>, <linux-block@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>, <andrii@kernel.org>,
 <eddyz87@gmail.com>, <daniel@iogearbox.net>,
 <linux-kselftest@vger.kernel.org>, <cuitao@kylinos.cn>,
 <ameryhung@gmail.com>
Subject: Re: [RFC PATCH v11 0/5] blk-iocost: BPF struct_ops cost model
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Tao Cui" <cui.tao@linux.dev>, <tj@kernel.org>, <josef@toxicopanda.com>,
 <axboe@kernel.dk>
In-Reply-To: <20261028143534.135968-1-cui.tao@linux.dev>
References: <20261028143534.135968-1-cui.tao@linux.dev>
Content-Transfer-Encoding: 8bit
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Wed, Oct 28, 2026 at 07:35 AM Tao Cui <cui.tao@linux.dev> wrote:
> The cgroup callbacks are bound to the iocg policy lifetime and pair
> up exactly: iocg_init() is delivered from ioc_pd_online(), which
> blkg_create() only calls after the blkg has been inserted into the
> radix tree and the queue's blkg list, and on attach to every cgroup
> which is already online on the device; iocg_free() is delivered at
> detach to the cgroups which still exist then and at pd_free() time
> for the rest, gated per iocg on a delivered flag.  The attach and
> detach walks go over q->blkg_list under q->blkcg_mutex and
> q->queue_lock, the same locking blkg creation and destruction use.

Who needs iocg_init() and iocg_free()?
Both example models keep their state in BPF_MAP_TYPE_CGRP_STORAGE.
The only user of the callbacks is a pair of counters in the selftest.

One struct_ops map is bound to one device. So the cgroup storage of
a model is per (cgroup, device) already.
The blkg holds the blkcg css until blkg_free_workfn(). The storage is
freed with the cgroup or with the map. So it outlives the iocg.

The v11 changelog says that calc_cost() can run before iocg_init().
So a model has to create its state in calc_cost() anyway.
iocg_init() runs under queue_lock and ioc->lock. An allocation there
is not better than in calc_cost().

v8, v9, v10 and v11 all reworked the pairing of these two callbacks.

Lets drop them. A struct_ops can get new members later, when a model
needs them.
I'd like to hear from Tejun whether such a model is planned.

Without the callbacks there is no walk of q->blkg_list:

  what                v11                          without callbacks
  ------------------  ---------------------------  ------------------
  attach takes        freeze, rq_qos_mutex,        freeze,
                      quiesce, blkcg_mutex,        rq_qos_mutex,
                      queue_lock, ioc->lock        ioc->lock
  detach takes        rq_qos_mutex, queue_lock,    rq_qos_mutex,
                      ioc->lock to check, then     ioc->lock
                      freeze and the same again,
                      quiesce, blkcg_mutex,
                      queue_lock, ioc->lock
  state per iocg      bpf_iocg_inited              none
  hooks in            ioc_pd_online(),             none
                      ioc_pd_free()
  teardown            ioc_bpf_detach(),            ioc_detach_model()
                      ioc_bpf_eject()

calc_cost() runs under rcu_read_lock(). bpf_map_put() frees a struct_ops
map after an RCU gp. So detach doesn't need to freeze the queue.
The rest fits into blk-iocost.c and patch 1 is not needed.

The diff keeps the map reference, the owning link and the
model=linear/bpf switch. It has no docs, no selftests and no tracepoint.

Something like this (compile tested only):

diff --git a/block/Kconfig b/block/Kconfig
index 70e4a66..26badf5 100644
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
index a81488c..5e65bf4 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -178,8 +178,12 @@
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
@@ -404,6 +408,22 @@ struct ioc_pcpu_stat {
 	u64				last_rq_wait_ns;
 };

+enum {
+	IOCOST_COST_F_MERGE	= 1 << 0,	/* called from the merge path */
+};
+
+/* bpf cost model of one device */
+struct iocost_model_ops {
+	/* whole disk, in the encoding of new_decode_dev() */
+	dev_t dev;
+
+	/* used by the completion path instead of LCOEF_[RW]PAGE */
+	u64 read_vtime_per_page;
+	u64 write_vtime_per_page;
+
+	u64 (*calc_cost)(struct bio *bio, u64 model_flags);
+};
+
 /* per device */
 struct ioc {
 	struct rq_qos			rqos;
@@ -447,6 +467,12 @@ struct ioc {
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
@@ -669,6 +695,13 @@ static struct ioc *q_to_ioc(struct request_queue *q)
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
@@ -806,7 +839,7 @@ static int ioc_autop_idx(struct ioc *ioc, struct gendisk *disk)
 		return AUTOP_SSD_DFL;

 	/* if user is overriding anything, maintain what was there */
-	if (ioc->user_qos_params || ioc->user_cost_model)
+	if (ioc->user_qos_params || ioc->user_cost_model || ioc_model(ioc))
 		return idx;

 	/* step up/down based on the vrate */
@@ -2586,8 +2619,16 @@ out:

 static u64 calc_vtime_cost(struct bio *bio, struct ioc_gq *iocg, bool is_merge)
 {
+	const struct iocost_model_ops *model;
 	u64 cost;

+	guard(rcu)();
+	model = ioc_model(iocg->ioc);
+	if (model) {
+		cost = model->calc_cost(bio, is_merge ? IOCOST_COST_F_MERGE : 0);
+		return min(cost, VTIME_PER_SEC);
+	}
+
 	calc_vtime_cost_builtin(bio, iocg, is_merge, &cost);
 	return cost;
 }
@@ -2612,8 +2653,16 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,

 static u64 calc_size_vtime_cost(struct request *rq, struct ioc *ioc)
 {
+	const struct iocost_model_ops *model;
 	u64 cost;

+	guard(rcu)();
+	model = ioc_model(ioc);
+	if (model)
+		return (blk_rq_stats_sectors(rq) >> IOC_SECT_TO_PAGE_SHIFT) *
+			(req_op(rq) == REQ_OP_READ ? model->read_vtime_per_page :
+						     model->write_vtime_per_page);
+
 	calc_size_vtime_cost_builtin(rq, ioc, &cost);
 	return cost;
 }
@@ -2908,10 +2957,33 @@ static void ioc_rqos_queue_depth_changed(struct rq_qos *rqos)
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
@@ -3458,11 +3530,12 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
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
@@ -3499,6 +3572,7 @@ static const match_table_t i_lcoef_tokens = {
 static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 				    size_t nbytes, loff_t off)
 {
+	const struct iocost_model_ops *model;
 	struct blkg_conf_ctx ctx;
 	struct request_queue *q;
 	unsigned int memflags;
@@ -3535,6 +3609,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	spin_lock_irq(&ioc->lock);
 	memcpy(u, ioc->params.i_lcoefs, sizeof(u));
 	user = ioc->user_cost_model;
+	model = ioc_model(ioc);

 	ret = -EINVAL;

@@ -3559,7 +3634,11 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
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
@@ -3579,6 +3658,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	} else {
 		ioc->user_cost_model = false;
 	}
+	rcu_assign_pointer(ioc->model, model);
 	ioc_refresh_params(ioc, true);

 	ret = 0;
@@ -3626,6 +3706,158 @@ static struct blkcg_policy blkcg_policy_iocost = {
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

>  3/5: selftests with two example models (the full builtin linear
>       HDD formula at double cost, and a multi-stream sequentiality
>       model) plus a runner and the selftest kernel config entries
>  4/5: add an iocost_ioc_tick tracepoint emitting the per-period
>       controller state, so model quality can be evaluated without
>       drgn (existing events are state-change driven and silent in
>       steady state)

Also progs/iocost_model.c in patch 3 has SEC("tp_btf/iocost_ioc_tick").
Patch 4 adds this tracepoint. At patch 3 iocost_model__load() fails.
Swap the two patches.

pw-bot: cr
