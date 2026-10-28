Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793198172;
	b=rclxy2tU7o/Hst7XLWMOXtNeJk3xyX9lFZGArCkMsalDXnRedo8GUhP/VyN58V+NmN0h
	 pFo0KLNaZznPtCYV9aMs8zQeBcQcI7w0+Cxa1UcKYmYMlkAWF0+C9GdKDyb+jcrrim91C
	 xwIVoqk/FzNC5WNQ931Bf/bYt54u4GMNNsNhZVKR5Yq33Jquxex58Ttcos2rIN/oas30Q
	 CTpkrwbnXk2mPyg3c6QVtqv72WDXI7azpc6ZxJQt7w0I+I3GXC+RpPOQGniNlHsxywUiJ
	 yfiLXk1DdOLu3R8e59TBW41nHwsvPPNVpJi1Gg06+oWnlSV98ZczgzoktyL7STVIR5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793198172;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ylmg5lCVmWx3NxPwfufEG1L3aDDL/kudf9v2k+Q6c90=;
	b=ASkUt0/kOGlDCr7A5HV0vwdQ4b8Lt8pPwOxYQtZJYpwz67NkmeyOx4zaUF13n1db7B4y
	 qsTN1HoapOcB/xQn2kZr52k19AA6koCmaETYDNmYbOEY+5fWMEJvdI9DgeuX+ZzAlM+y8
	 V0yzxqT8339Obk8qIWYc1U8FDfjVktCI7wMcQaYFofNPq9tQzKCMX+1a43Pi1gntRu58T
	 2U5l1WI9QwTb6IICSmBR+LxM+zpTPPfzK+fcm9VzLlXD+0I8s8P4qPAxTOC1v2g4lHucq
	 ZwupdW0M5P/jEiiQuCd58+iZ7hbS53GWj9GYxhdGw1pYDDyuWkpENs0PiywlsJUg5Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lF+j2Ykd;
	arc=none smtp.remote-ip=95.215.58.172
Received: from mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118D3606A31C
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 14:36:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 118D3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lF+j2Ykd
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YeXzskRdXPHsICW5UdxrJbyxPrYTDBGzQp+T323v5zA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793198167; v=1; x=1793802967;
 b=lF+j2YkdK4/8djWW+Zn7utpIX/9FBhywcfgCi10my77SnnOtdyTn9S8tHbufEjuYSCbQSDbG
 ACUGI/32oW6LkaDX5RBAF5TkoVBZxDTg9cHk+a2OLziwReY4QyVo8ynbfP12FaIhjTUPx/v49T0
 uOTTR8jczLmqixsR4SB1+Umw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2cdbc2d0c847d73d;
	Wed, 28 Oct 2026 14:36:07 +0000
X-Mizu-Trace-ID: 2cdbc2d0c847d73d
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
Subject: [PATCH 2/5] blk-iocost: add BPF struct_ops cost model support
Date: Wed, 28 Oct 2026 22:35:31 +0800
Message-ID: <20261028143534.135968-3-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261028143534.135968-1-cui.tao@linux.dev>
References: <20261028143534.135968-1-cui.tao@linux.dev>
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
device specific.  This lets a BPF program take over pricing for a
device so that the model can be adapted to it without rebuilding
the kernel.

Attaching an iocost_model_ops struct_ops binds the model to one
device: the target is set in the dev member from userspace, .reg
creates the ioc if needed like an io.cost.model write and switches
the device to the model with the queue frozen before rq_qos_mutex
like an io.cost.qos write.  The attachment records the owning link
in the ioc and holds a reference on the map; detach verifies the
attachment under rq_qos_mutex and device removal ejects the model,
so a stale link cannot tear down a newer attachment.  io.cost.model
selects between the attached and builtin models without detaching
the struct_ops; only .unreg or device removal detaches.

While in use, the BPF model prices every charged IO: calc_cost()
is called from the submission path with the bio and returns the
cost in vtime units, clamped to one second of device time per IO.
The struct_ops also carries the transfer coefficients used by the
completion-time request sizing, so latency tracking and vrate
adjustment follow the model's pricing.  Models without calc_cost
or with zero or out-of-range transfer coefficients are rejected
at registration.

The cgroup callbacks pair with the iocg policy lifetime:
iocg_init() is delivered from ioc_pd_online() and, on attach, to
cgroups already online on the device; iocg_free() on detach and at
pd_free(), so each (cgroup, device) pair sees exactly one init and
one free.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 MAINTAINERS            |   1 +
 block/Kconfig          |   4 +
 block/Makefile         |   1 +
 block/blk-iocost-bpf.c | 464 +++++++++++++++++++++++++++++++++++++++++
 block/blk-iocost.c     | 124 ++++++++++-
 block/blk-iocost.h     | 181 +++++++++++++++-
 6 files changed, 763 insertions(+), 12 deletions(-)
 create mode 100644 block/blk-iocost-bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index b3b421ee262e..598a5f65423d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6826,6 +6826,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git
 F:	Documentation/admin-guide/cgroup-v1/blkio-controller.rst
 F:	block/bfq-cgroup.c
 F:	block/blk-cgroup.c
+F:	block/blk-iocost-bpf.c
 F:	block/blk-iocost.c
 F:	block/blk-iocost.h
 F:	block/blk-iolatency.c
diff --git a/block/Kconfig b/block/Kconfig
index 70e4a66d941f..8eaa2a803b61 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -229,6 +229,10 @@ config BLK_ERROR_INJECTION
 
 	  See Documentation/block/error-injection.rst for details.
 
+config BLK_CGROUP_IOCOST_BPF
+	def_bool y
+	depends on BLK_CGROUP_IOCOST && BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF
+
 source "block/Kconfig.iosched"
 
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
index 000000000000..8ff51c26fb25
--- /dev/null
+++ b/block/blk-iocost-bpf.c
@@ -0,0 +1,464 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * blk-iocost: BPF struct_ops plumbing for pluggable cost models.
+ *
+ * Copyright (C) 2026 KylinSoft Corporation.
+ *
+ * Registers the "iocost_model_ops" struct_ops type. Attachment is per-device:
+ * the target device is set in the ops from userspace before load, .reg
+ * attaches the model to that device, creating the ioc if needed and switching
+ * to the model with the queue frozen before rq_qos_mutex, like io.cost.qos
+ * writes, and .unreg detaches it; enabling and disabling the controller stays
+ * with io.cost.qos. The struct_ops core owns the program lifetime.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf.h>
+#include "blk-iocost.h"
+#include <linux/blk-mq.h>
+#include <linux/mutex.h>
+#include "blk.h"
+
+/*
+/*
+ * Deliver iocg_init()/iocg_free() to the cgroups already online on the
+ * queue: init walks q->blkg_list in reverse so parents receive it first,
+ * like blkcg_activate_policy(); free walks it forward like the blkcg
+ * policy teardown. The queue is frozen and quiesced; queue_lock
+ * serializes against blkg creation and blkcg_mutex against the delayed
+ * list removal in blkg destruction; the callbacks are called with
+ * ioc->lock held, the same lock the attachment updates take.
+ */
+static void ioc_bpf_deliver_iocg_callbacks(struct ioc *ioc,
+					   const struct iocost_model_ops *ops,
+					   bool init)
+{
+	struct request_queue *q = ioc->rqos.disk->queue;
+	struct blkcg_gq *blkg;
+
+	lockdep_assert_held(&q->blkcg_mutex);
+	lockdep_assert_held(&q->queue_lock);
+	lockdep_assert_held(&ioc->lock);
+
+	if (init) {
+		/* parents first, like blkcg_activate_policy() */
+		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
+			struct ioc_gq *iocg = blkg_to_iocg(blkg);
+
+			/*
+			 * A blkg which never went online never reached the
+			 * radix tree, so it must not receive an init either;
+			 * the attach runs under the same queue_lock as
+			 * blkg_create(), so pd->online is stable here. Any
+			 * previous attachment had its delivered flags cleared
+			 * before it went away, so none can still be set here.
+			 */
+			if (!iocg || !iocg->pd.online)
+				continue;
+			if (ops->iocg_init) {
+				ops->iocg_init(blkg->blkcg, q);
+				iocg->bpf_iocg_inited = true;
+			}
+		}
+	} else {
+		list_for_each_entry(blkg, &q->blkg_list, q_node) {
+			struct ioc_gq *iocg = blkg_to_iocg(blkg);
+
+			if (!iocg || !iocg->bpf_iocg_inited)
+				continue;
+			if (ops->iocg_free)
+				ops->iocg_free(blkg->blkcg, q);
+			iocg->bpf_iocg_inited = false;
+		}
+	}
+}
+
+static int ioc_bpf_attach(struct iocost_model_ops *ops, struct bpf_link *link)
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
+		blkdev_put_no_open(bdev);
+		return -EINVAL;
+	}
+	if (!queue_is_mq(q)) {
+		blkdev_put_no_open(bdev);
+		return -EOPNOTSUPP;
+	}
+
+	/*
+	 * The freeze is taken before rq_qos_mutex like ioc_qos_write() does;
+	 * holding the mutex from the disk_live() check through the model
+	 * switch keeps the ioc from being freed under us.
+	 */
+	memflags = blk_mq_freeze_queue(q);
+
+	mutex_lock(&q->rq_qos_mutex);
+
+	if (!disk_live(disk)) {
+		mutex_unlock(&q->rq_qos_mutex);
+		blk_mq_unfreeze_queue(q, memflags);
+		blkdev_put_no_open(bdev);
+		return -ENODEV;
+	}
+	ioc = q_to_ioc(q);
+	if (!ioc) {
+		ret = blk_iocost_init(disk);
+		if (ret) {
+			mutex_unlock(&q->rq_qos_mutex);
+			blk_mq_unfreeze_queue(q, memflags);
+			blkdev_put_no_open(bdev);
+			return ret;
+		}
+		ioc = q_to_ioc(q);
+	}
+
+	blk_mq_quiesce_queue(q);
+
+	/*
+	 * Scope the mutex so the tail bdev put runs with blkcg_mutex
+	 * already released: dropping the last device reference can
+	 * reach disk_release() -> blkcg_exit_disk() ->
+	 * blkg_destroy_all(), which takes q->blkcg_mutex.
+	 */
+	{
+		guard(mutex)(&q->blkcg_mutex);
+		scoped_guard(spinlock_irqsave, &q->queue_lock) {
+			spin_lock(&ioc->lock);
+			ret = ioc_attached_model_locked(ioc) ? -EBUSY : 0;
+			if (!ret) {
+				/*
+				 * Take the map reference before the attachment
+				 * is published: the readers find the ops
+				 * through it. get() cannot fail while .reg
+				 * runs, as the core holds a map reference
+				 * then, but check it anyway; on failure leave
+				 * with no attachment set.
+				 */
+				if (!bpf_struct_ops_get(ops)) {
+					ret = -ENODEV;
+				} else {
+					rcu_assign_pointer(ioc->attached, ops);
+					rcu_assign_pointer(ioc->model, ops);
+					ioc->bpf_link = link;
+
+					/* pair iocg_init() with the cgroups online */
+					ioc_bpf_deliver_iocg_callbacks(ioc, ops,
+								       true);
+				}
+			}
+			spin_unlock(&ioc->lock);
+		}
+	}
+
+	blk_mq_unquiesce_queue(q);
+	blk_mq_unfreeze_queue(q, memflags);
+	mutex_unlock(&q->rq_qos_mutex);
+	blkdev_put_no_open(bdev);
+	return ret;
+}
+
+/*
+ * Detach a model: switch back to the builtin model when the attached model is
+ * in use, clear the attachment and deliver iocg_free() to the cgroups which
+ * still exist, under the same freeze and quiesce as the attach.
+ */
+static void ioc_bpf_detach(struct iocost_model_ops *ops, struct bpf_link *link)
+{
+	struct block_device *bdev;
+	struct request_queue *q;
+	struct ioc *ioc;
+	bool matched;
+	unsigned int memflags;
+
+	/*
+	 * A failed lookup means the device is gone; the removal ejection will
+	 * detach the model and drop the map reference when rq_qos_exit() runs,
+	 * so there is nothing to do here.
+	 */
+	bdev = blkdev_get_no_open(new_decode_dev(ops->dev), false);
+	if (!bdev)
+		return;
+	q = bdev->bd_queue;
+
+	/*
+	 * The attachment is checked under rq_qos_mutex first, so an unmatched
+	 * detach exits without freezing.
+	 */
+	mutex_lock(&q->rq_qos_mutex);
+	spin_lock_irq(&q->queue_lock);
+	ioc = q_to_ioc(q);
+	if (ioc) {
+		spin_lock(&ioc->lock);
+		matched = ioc_attached_model_locked(ioc) == ops &&
+			  ioc->bpf_link == link;
+		spin_unlock(&ioc->lock);
+	} else {
+		matched = false;
+	}
+	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->rq_qos_mutex);
+	if (!matched) {
+		blkdev_put_no_open(bdev);
+		return;
+	}
+
+	/* the freeze is taken before rq_qos_mutex like ioc_qos_write() */
+	memflags = blk_mq_freeze_queue(q);
+
+	mutex_lock(&q->rq_qos_mutex);
+
+	/*
+	 * Re-check under the mutex before quiescing: the freeze itself does
+	 * not touch the tag set, and the removal ejection holds rq_qos_mutex
+	 * before the driver frees the tag set, so the check passing here means
+	 * the tag set is still alive.
+	 */
+	spin_lock_irq(&q->queue_lock);
+	ioc = q_to_ioc(q);
+	if (ioc) {
+		spin_lock(&ioc->lock);
+		matched = ioc_attached_model_locked(ioc) == ops &&
+			  ioc->bpf_link == link;
+		spin_unlock(&ioc->lock);
+	} else {
+		matched = false;
+	}
+	spin_unlock_irq(&q->queue_lock);
+	if (!matched) {
+		mutex_unlock(&q->rq_qos_mutex);
+		blk_mq_unfreeze_queue(q, memflags);
+		blkdev_put_no_open(bdev);
+		return;
+	}
+
+	blk_mq_quiesce_queue(q);
+
+	/*
+	 * Scope the mutex so the tail bdev put runs with blkcg_mutex
+	 * already released: dropping the last device reference can
+	 * reach disk_release() -> blkcg_exit_disk() ->
+	 * blkg_destroy_all(), which takes q->blkcg_mutex.
+	 */
+	{
+		guard(mutex)(&q->blkcg_mutex);
+		scoped_guard(spinlock_irqsave, &q->queue_lock) {
+			spin_lock(&ioc->lock);
+			if (ioc_bpf_model_locked(ioc) == ops)
+				rcu_assign_pointer(ioc->model, NULL);
+			rcu_assign_pointer(ioc->attached, NULL);
+			ioc->bpf_link = NULL;
+
+			ioc_bpf_deliver_iocg_callbacks(ioc, ops, false);
+			spin_unlock(&ioc->lock);
+		}
+	}
+
+	blk_mq_unquiesce_queue(q);
+	blk_mq_unfreeze_queue(q, memflags);
+	mutex_unlock(&q->rq_qos_mutex);
+
+	blkdev_put_no_open(bdev);
+	bpf_struct_ops_put(ops);
+}
+
+/*
+ * Eject the model on device removal. The caller holds rq_qos_mutex and
+ * blkcg_deactivate_policy() has already run, so every existing blkg got
+ * iocg_free() from ioc_pd_free() and no walk is needed. The ioc is freed right
+ * after, so clearing the pointers and dropping the map reference is all that
+ * is left to do.
+ */
+void ioc_bpf_eject(struct ioc *ioc)
+{
+	const struct iocost_model_ops *ops;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->lock, flags);
+	ops = ioc_attached_model_locked(ioc);
+	if (ops) {
+		rcu_assign_pointer(ioc->attached, NULL);
+		if (ioc_bpf_model_locked(ioc) == ops)
+			rcu_assign_pointer(ioc->model, NULL);
+		ioc->bpf_link = NULL;
+	}
+	spin_unlock_irqrestore(&ioc->lock, flags);
+
+	if (ops)
+		bpf_struct_ops_put(ops);
+}
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
+	 * The struct_ops core rejects a nonzero userspace value for
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
+ * A complete model prices every charged IO and carries both transfer
+ * coefficients; a missing calc_cost would be a NULL call from the
+ * submission path and missing coefficients would silently zero the
+ * completion-time sizing (see ioc_rqos_done()), so the model is
+ * rejected before it can be registered. iocg_init() and iocg_free()
+ * must come in pairs too: a model implementing only one of them would
+ * build per-cgroup state that nothing ever tears down.
+ */
+static bool iocost_model_complete(const struct iocost_model_ops *ops)
+{
+	return ops->calc_cost && ops->read_vtime_per_page &&
+	       ops->write_vtime_per_page &&
+	       !!ops->iocg_init == !!ops->iocg_free;
+}
+
+/*
+ * kvalue is zeroed at map allocation and function members are only written
+ * when the BPF side provides a prog, so a model which did not implement
+ * calc_cost leaves it NULL, and missing coefficients read as zero. This is
+ * reached from the map-update path of both map flavors, before the model can
+ * be registered.
+ */
+static int bpf_iocost_validate(void *kdata)
+{
+	struct iocost_model_ops *ops = kdata;
+
+	/*
+	 * Bound the transfer coefficients so that coefficient * pages cannot
+	 * wrap u64 for any possible request size.
+	 */
+	if (ops->read_vtime_per_page > (VTIME_PER_SEC >> IOC_SECT_TO_PAGE_SHIFT) ||
+	    ops->write_vtime_per_page > (VTIME_PER_SEC >> IOC_SECT_TO_PAGE_SHIFT))
+		return -EINVAL;
+
+	return iocost_model_complete(ops) ? 0 : -EINVAL;
+}
+
+static int bpf_iocost_reg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *ops = kdata;
+
+	/* validate() has run by now; only the device is left to check */
+	if (!ops->dev)
+		return -EINVAL;
+
+	return ioc_bpf_attach(ops, link);
+}
+
+static void bpf_iocost_unreg(void *kdata, struct bpf_link *link)
+{
+	struct iocost_model_ops *ops = kdata;
+
+	/* a gone device is handled inside ioc_bpf_detach() */
+	ioc_bpf_detach(ops, link);
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
index 9b610734871f..1e84232e6740 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -395,8 +395,14 @@ static int ioc_autop_idx(struct ioc *ioc, struct gendisk *disk)
 	if (idx < AUTOP_SSD_DFL)
 		return AUTOP_SSD_DFL;
 
-	/* if user is overriding anything, maintain what was there */
-	if (ioc->user_qos_params || ioc->user_cost_model)
+	/*
+	 * If user is overriding anything, or a BPF model is in use, maintain
+	 * what was there: with a BPF model the builtin cost coefficients are
+	 * inert, and stepping the profile would change the builtin parameters
+	 * that apply again after switching back, for no benefit in between.
+	 */
+	if (ioc->user_qos_params || ioc->user_cost_model ||
+	    ioc_bpf_model_locked(ioc))
 		return idx;
 
 	/* step up/down based on the vrate */
@@ -2178,7 +2184,9 @@ static u64 calc_vtime_cost(struct bio *bio, struct ioc_gq *iocg, bool is_merge)
 {
 	u64 cost;
 
-	calc_vtime_cost_builtin(bio, iocg, is_merge, &cost);
+	if (!ioc_model_calc_cost(iocg->ioc, bio, is_merge, &cost))
+		calc_vtime_cost_builtin(bio, iocg, is_merge, &cost);
+
 	return cost;
 }
 
@@ -2200,11 +2208,19 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 	}
 }
 
-static u64 calc_size_vtime_cost(struct request *rq, struct ioc *ioc)
+/*
+ * Called from the request completion path for READ and WRITE
+ * requests, where no ioc->lock is held; the model pointer is read
+ * under RCU, matching the bio-side calc_vtime_cost().
+ */
+static u64 calc_size_vtime_cost(struct request *rq, struct ioc *ioc,
+				bool is_read)
 {
 	u64 cost;
 
-	calc_size_vtime_cost_builtin(rq, ioc, &cost);
+	if (!ioc_model_size_cost(ioc, rq, is_read, &cost))
+		calc_size_vtime_cost_builtin(rq, ioc, &cost);
+
 	return cost;
 }
 
@@ -2474,7 +2490,8 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 
 	on_q_ns = blk_time_get_ns() - rq->alloc_time_ns;
 	rq_wait_ns = rq->start_time_ns - rq->alloc_time_ns;
-	size_nsec = div64_u64(calc_size_vtime_cost(rq, ioc), VTIME_PER_NSEC);
+	size_nsec = div64_u64(calc_size_vtime_cost(rq, ioc, pidx == QOS_RLAT),
+			       VTIME_PER_NSEC);
 
 	ccs = get_cpu_ptr(ioc->pcpu_stat);
 
@@ -2510,6 +2527,10 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
 
 	timer_shutdown_sync(&ioc->timer);
 	free_percpu(ioc->pcpu_stat);
+
+	/* eject the model on device removal */
+	ioc_bpf_eject(ioc);
+
 	kfree(ioc);
 }
 
@@ -2522,7 +2543,7 @@ static const struct rq_qos_ops ioc_rqos_ops = {
 	.exit = ioc_rqos_exit,
 };
 
-static int blk_iocost_init(struct gendisk *disk)
+int blk_iocost_init(struct gendisk *disk)
 {
 	struct ioc *ioc;
 	int i, cpu, ret;
@@ -2660,6 +2681,35 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 
+/*
+ * iocg_init() delivery for the attached model. blkg_create() calls this only
+ * after the blkg has been inserted into the radix tree and the queue's blkg
+ * list, so a blkg whose insertion failed is never seen here and the init/free
+ * pairing cannot be broken by a model switch in between; the caller holds
+ * queue_lock, the same lock the attachment updates are serialized with.
+ */
+static void ioc_pd_online(struct blkg_policy_data *pd)
+{
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	struct ioc_gq *iocg = pd_to_iocg(pd);
+	struct blkcg_gq *blkg = pd_to_blkg(pd);
+	struct ioc *ioc = iocg->ioc;
+	const struct iocost_model_ops *model;
+	unsigned long flags;
+
+	if (!ioc)
+		return;
+
+	spin_lock_irqsave(&ioc->lock, flags);
+	model = ioc_attached_model_locked(ioc);
+	if (model && model->iocg_init) {
+		model->iocg_init(blkg->blkcg, ioc->rqos.disk->queue);
+		iocg->bpf_iocg_inited = true;
+	}
+	spin_unlock_irqrestore(&ioc->lock, flags);
+#endif
+}
+
 static void iocg_release(struct rcu_head *rcu)
 {
 	struct blkg_policy_data *pd =
@@ -2680,6 +2730,25 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 	if (ioc) {
 		spin_lock_irqsave(&ioc->lock, flags);
 
+		/*
+		 * Gate the free on the delivered flag: a blkg which never went
+		 * online never received iocg_init(), and bios still holding
+		 * the blkg can be priced between its going offline and this
+		 * free, so iocg_free() follows pd_free() rather than
+		 * pd_offline.
+		 */
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+		if (iocg->bpf_iocg_inited) {
+			const struct iocost_model_ops *amodel =
+				ioc_attached_model_locked(ioc);
+
+			if (amodel && amodel->iocg_free)
+				amodel->iocg_free(blkg->blkcg,
+						  ioc->rqos.disk->queue);
+			iocg->bpf_iocg_inited = false;
+		}
+#endif
+
 		if (!list_empty(&iocg->active_list)) {
 			struct ioc_now now;
 
@@ -3042,16 +3111,19 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
 	const char *dname = blkg_dev_name(pd->blkg);
 	struct ioc *ioc = pd_to_iocg(pd)->ioc;
 	u64 *u = ioc->params.i_lcoefs;
+	const struct iocost_model_ops *model;
 
 	if (!dname)
 		return 0;
 
 	spin_lock_irq(&ioc->lock);
-	seq_printf(sf, "%s ctrl=%s model=linear "
+	model = ioc_bpf_model_locked(ioc);
+	seq_printf(sf, "%s ctrl=%s model=%s "
 		   "rbps=%llu rseqiops=%llu rrandiops=%llu "
 		   "wbps=%llu wseqiops=%llu wrandiops=%llu "
 		   "flushiops=%llu\n",
 		   dname, ioc->user_cost_model ? "user" : "auto",
+		   model ? "bpf" : "linear",
 		   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS], u[I_LCOEF_RRANDIOPS],
 		   u[I_LCOEF_WBPS], u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS],
 		   u[I_LCOEF_FLUSHIOPS]);
@@ -3096,6 +3168,10 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	bool user;
 	char *body, *p;
 	int ret;
+	const struct iocost_model_ops *new_model = NULL;
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	bool model_write = false;
+#endif
 
 	blkg_conf_init(&ctx, input);
 
@@ -3148,9 +3224,30 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 			continue;
 		case COST_MODEL:
 			match_strlcpy(buf, &args[0], sizeof(buf));
-			if (strcmp(buf, "linear"))
-				goto unlock;
-			continue;
+			if (!strcmp(buf, "linear")) {
+				/*
+				 * Staged and committed below, so a parse
+				 * error later in the same write leaves the
+				 * model selection untouched.
+				 */
+				new_model = NULL;
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+				model_write = true;
+#endif
+				continue;
+			}
+			if (!strcmp(buf, "bpf")) {
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+				new_model = rcu_dereference_protected(
+						ioc->attached,
+						lockdep_is_held(&ioc->lock));
+				model_write = true;
+#endif
+				if (!new_model)
+					goto unlock;
+				continue;
+			}
+			goto unlock;
 		}
 
 		tok = match_token(p, i_lcoef_tokens, args);
@@ -3168,6 +3265,10 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	} else {
 		ioc->user_cost_model = false;
 	}
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	if (model_write)
+		rcu_assign_pointer(ioc->model, new_model);
+#endif
 	ioc_refresh_params(ioc, true);
 
 	ret = 0;
@@ -3211,6 +3312,7 @@ struct blkcg_policy blkcg_policy_iocost = {
 	.cpd_free_fn	= ioc_cpd_free,
 	.pd_alloc_fn	= ioc_pd_alloc,
 	.pd_init_fn	= ioc_pd_init,
+	.pd_online_fn	= ioc_pd_online,
 	.pd_free_fn	= ioc_pd_free,
 	.pd_stat_fn	= ioc_pd_stat,
 };
diff --git a/block/blk-iocost.h b/block/blk-iocost.h
index e4e517ef6a0f..6d62b4fd0c54 100644
--- a/block/blk-iocost.h
+++ b/block/blk-iocost.h
@@ -22,6 +22,79 @@
 #include <asm/local64.h>
 #include "blk-rq-qos.h"
 
+struct bpf_link;
+
+/*
+ * Pluggable cost model interface for blk-iocost.
+ *
+ * A BPF struct_ops implementation can take over the cost model of one device.
+ * The device is identified by the dev member, which is set from userspace
+ * before the program is loaded; the struct_ops core owns the program lifetime.
+ * Attaching creates the ioc if needed, like an io.cost.model write, and
+ * switches the device to the BPF model with the queue frozen before
+ * rq_qos_mutex, like an io.cost.qos write, and delivers iocg_init() to the
+ * cgroups which already exist on the device. Enabling and disabling the
+ * controller stays with io.cost.qos.
+ *
+ * While a model is attached, io.cost.model selects between it and the builtin
+ * model: "model=bpf" switches to the attached model and "model=linear" back to
+ * the builtin. Neither detaches the struct_ops; only detaching does. The
+ * builtin linear coefficients are kept while the BPF model is in use and take
+ * effect again when switched back.
+ *
+ * While in use, the BPF model prices every charged IO on the device, including
+ * flushes, from the bio charging path. calc_cost() is called from the IO
+ * submission path with RCU read lock held and must not sleep. It receives the
+ * bio itself so that the model can use what it needs (operation flags, size,
+ * sector, the issuing cgroup through bio->bi_blkg, which is guaranteed
+ * non-NULL) and returns the cost of the IO in vtime units, where 1 second
+ * of device time equals VTIME_PER_SEC (2^37,
+ * available to BPF programs through vmlinux.h). The return value is clamped to
+ * 1 second of device time per IO.
+ *
+ * The struct_ops also carries the transfer cost coefficients, vtime per page
+ * for reads and writes. While the BPF model is in use, they replace the
+ * builtin coefficients in the completion-time request sizing of READ and
+ * WRITE requests, with ZONE_APPEND counted as a write. Taking over the QoS
+ * side (latency tracking, vrate control) is left for later extensions.
+ *
+ * The cgroup callbacks are bound to the iocg policy lifetime, one (cgroup,
+ * device) pair per invocation. iocg_init() is delivered from ioc_pd_online()
+ * and on attach to the cgroups already online on the device; iocg_free() on
+ * detach to the cgroups which still exist then and at pd_free() time for the
+ * rest, so that init and free pair up exactly. iocg_free() is gated on a
+ * per-iocg delivered flag, as bios can still be priced between the blkg going
+ * offline and its free. Both callbacks are called with ioc->lock held and must
+ * not sleep; the delivery points nest inside queue_lock except for iocg_free()
+ * from ioc_pd_free() in blkg_free_workfn().
+ */
+
+/*
+ * Call metadata for calc_cost()'s model_flags; the merge indicator is not a
+ * property of the bio. An enum so that the value is exported through BTF and
+ * usable from vmlinux.h.
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
+	/* vtime per page for the completion-time request sizing */
+	u64 read_vtime_per_page;
+	u64 write_vtime_per_page;
+
+	u64 (*calc_cost)(struct bio *bio, u64 model_flags);
+	void (*iocg_init)(struct blkcg *blkcg, struct request_queue *q);
+	void (*iocg_free)(struct blkcg *blkcg, struct request_queue *q);
+};
+
 enum {
 	MILLION			= 1000000,
 
@@ -260,7 +333,14 @@ struct ioc {
 	int				autop_idx;
 	bool				user_qos_params:1;
 	bool				user_cost_model:1;
-
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	/* the struct_ops attached to this device, NULL = none */
+	const struct iocost_model_ops	__rcu *attached;
+	/* the link which owns the attachment, written with ioc->lock held */
+	struct bpf_link			*bpf_link;
+	/* the cost model in use, NULL = builtin linear model */
+	const struct iocost_model_ops	__rcu *model;
+#endif
 };
 
 struct iocg_pcpu_stat {
@@ -278,6 +358,10 @@ struct iocg_stat {
 struct ioc_gq {
 	struct blkg_policy_data		pd;
 	struct ioc			*ioc;
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	/* whether the attached model's iocg_init() was delivered */
+	bool				bpf_iocg_inited;
+#endif
 
 	/*
 	 * A iocg can get its weight from two sources - an explicit
@@ -433,4 +517,99 @@ static inline struct ioc_cgrp *blkcg_to_iocc(struct blkcg *blkcg)
 			    struct ioc_cgrp, cpd);
 }
 
+/*
+ * The attached struct_ops and the model in use. The writers hold
+ * ioc->lock, the hot path readers are inside rcu_read_lock() and the
+ * map is not freed until after an RCU grace period, the slow readers
+ * hold ioc->lock.
+ */
+static inline const struct iocost_model_ops *
+ioc_attached_model_locked(struct ioc *ioc)
+{
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	return rcu_dereference_protected(ioc->attached,
+					 lockdep_is_held(&ioc->lock));
+#else
+	return NULL;
+#endif
+}
+
+static inline const struct iocost_model_ops *
+ioc_bpf_model_locked(struct ioc *ioc)
+{
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	return rcu_dereference_protected(ioc->model,
+					 lockdep_is_held(&ioc->lock));
+#else
+	return NULL;
+#endif
+}
+
+/*
+ * Price one charged IO with the model in use into *@cost and return
+ * true, or return false when no model is in use and the builtin model
+ * must price it. The model is read under rcu_read_lock(), which the
+ * helper takes and releases itself, and the returned cost is clamped
+ * to one second of device time. calc_cost() may be invoked for a
+ * (cgroup, device) pair before iocg_init() has been delivered for
+ * it; models relying on per-pair state must tolerate that window.
+ */
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+static inline bool ioc_model_calc_cost(struct ioc *ioc, struct bio *bio,
+				       bool is_merge, u64 *cost)
+{
+	const struct iocost_model_ops *model;
+
+	rcu_read_lock();
+	model = rcu_dereference(ioc->model);
+	if (model)
+		*cost = min(model->calc_cost(bio, is_merge ?
+			    IOCOST_COST_F_MERGE : 0), VTIME_PER_SEC);
+	rcu_read_unlock();
+	return model;
+}
+#else	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+static inline bool ioc_model_calc_cost(struct ioc *ioc, struct bio *bio,
+				       bool is_merge, u64 *cost)
+{
+	return false;
+}
+#endif	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+
+/*
+ * The same for the completion-time request sizing: the transfer cost
+ * is the model's vtime per page for the request direction, and the
+ * returned cost is clamped to one second of device time.
+ */
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+static inline bool ioc_model_size_cost(struct ioc *ioc, struct request *rq,
+				       bool is_read, u64 *cost)
+{
+	const struct iocost_model_ops *model;
+
+	rcu_read_lock();
+	model = rcu_dereference(ioc->model);
+	if (model)
+		*cost = min((is_read ? model->read_vtime_per_page :
+			     model->write_vtime_per_page) *
+			    (blk_rq_stats_sectors(rq) >> IOC_SECT_TO_PAGE_SHIFT),
+			    VTIME_PER_SEC);
+	rcu_read_unlock();
+	return model;
+}
+#else	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+static inline bool ioc_model_size_cost(struct ioc *ioc, struct request *rq,
+				       bool is_read, u64 *cost)
+{
+	return false;
+}
+#endif	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+
+int blk_iocost_init(struct gendisk *disk);
+
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+void ioc_bpf_eject(struct ioc *ioc);
+#else	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+static inline void ioc_bpf_eject(struct ioc *ioc) { }
+#endif	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
 #endif	/* _BLK_IOCOST_H */
-- 
2.43.0

