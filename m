Received: from mta1.migadu.com (out-72.mta1.migadu.com [95.215.58.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838393AEB2D
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 07:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974426; cv=none; b=eA3E+KqK5gN/7OfQPa+y0lvz69AbcbEfUdGGddiLP2F0V9VZcz/5drxnhHeQM6nh7a1FDthSghFiP6izelNcwcozwcjfzylzGjug9K39YPaLIDQadaFJNxb3Q/9BR2mc5Gnjv9KGOZ8m9xTQ22t5YbHZXukVnag20cG6+P//LE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974426; c=relaxed/simple;
	bh=P/yCX0dnYM3gWr3ZFgRoRyEBmvke2naC9owtFoJ45zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KP2fwm6nFI3ILDk3bAZsrxskc2Y+s7ZpaSdGqTPWsjjbcvXT1pv6qbZGnjFXnPebSA99CUFmCe3eb4bPDKtM5f/uruni/sH1D6eC0j26Rn78n5R+VXcaNcMD6rmVDExNN2iXdYIuf0MPA/bG98pP4TaIpeh+zOPyeayoq/UO9ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fMYQKYLp; arc=none smtp.client-ip=95.215.58.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fMYQKYLp"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=P/yCX0dnYM3gWr3ZFgRoRyEBmvke2naC9owtFoJ45zE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789974422; v=1; x=1790579222;
 b=fMYQKYLpjl/c4Xo3IXfhaHQrM+E68NgEk6PDAyOr4u81BIi5mga7X3y01IKNEd9d9yrYNLxT
 9ALIQEVE6RMmp5/06esVLjt0MWhNHVW0aRWVZLeMOLmf8kbimNakHikYSdDaDCbbzbTrIPJzgz6
 ijjW5D8hp88useNC0rwJrmFM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 53a3e59b4fe32a04;
	Mon, 21 Sep 2026 07:07:02 +0000
X-Mizu-Trace-ID: 53a3e59b4fe32a04
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk,
	kbusch@kernel.org,
	tj@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	yukuai@fygo.io
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [RFC PATCH 1/1] block: charge passthrough requests to the submitter's cgroup
Date: Mon, 21 Sep 2026 15:06:47 +0800
Message-ID: <20260921070647.1928289-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921070647.1928289-1-cui.tao@linux.dev>
References: <20260921070647.1928289-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Passthrough requests (SG_IO, bsg, nvme passthrough ioctls and uring
commands) are dispatched via blk_execute_rq{,_nowait}() without ever
passing through submit_bio(), so the bio mapped by blk_rq_map_user()
carries no blkcg association: the transferred bytes never show up in
cgroup io.stat, and every rq_qos policy on the queue (iocost,
iolatency, wbt) is bypassed, as is blk-throttle, which hooks
submit_bio_noacct() directly rather than going through rq_qos.

A quick demonstration on a scsi_debug device with iocost enabled and
vrate pinned to its 1% floor: a direct fio writer was throttled ~10x
while the same cgroup issuing sg_dd writes ran at full device speed
with zero io.stat accounting.

Associate the mapped bio with the submitter's blkcg at dispatch time
and run the regular bio accounting (blk_cgroup_bio_start()) and
rq_qos throttle paths with it.  DRV_IN/DRV_OUT commands are mapped to
READ/WRITE so io.stat classifies their bytes normally; request
completion already pairs with the throttle through bio_endio() ->
rq_qos_done_bio().

The charge is gated by opcode (READ/WRITE/DRV_IN/DRV_OUT) and to
queues that already have a gendisk: commands issued during device
probing (SCSI INQUIRY etc.) have no gendisk yet and stay exempt,
following the same probe-exemption reasoning as the passthrough
iostats support.

RFC notes:
 - validated on linux-next with scsi_debug + sg_dd (SG_IO) and qemu
   emulated nvme + a NVME_IOCTL_IO64_CMD loop: in both cases the
   transferred bytes are fully accounted (wbytes/wios) in the issuing
   cgroup, and the issuing task is observed waiting on the iocost
   waitqueue with vrate clamped;
 - iolatency gains the same coverage for free, and so does wbt:
   passthrough writes now pass through wbt_wait() like bio-path
   writes, a behavior change worth calling out even though wbt
   targets buffered writeback and direct passthrough rarely hits it;
   blk-throttle does not: it hooks
   submit_bio_noacct() directly and is not an rq_qos policy, so
   io.max stays unenforced for passthrough (measured).  Its
   queue-and-resubmit throttling model would also need a synchronous
   variant for request-bound bios;
 - nvme uring commands share the same blk_execute_rq_nowait()
   dispatch as the validated ioctl path;
 - the charge runs in the submitter's context and may sleep in
   rq_qos throttling; all data-op callers found run in sleepable
   context, but this deserves reviewer attention.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-mq.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a26a11c73ee3..2dd59f6df321 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -10,6 +10,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include "blk-cgroup.h"
 #include <linux/blk-integrity.h>
 #include <linux/kmemleak.h>
 #include <linux/mm.h>
@@ -1400,6 +1401,73 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 	plug->rq_count++;
 }
 
+/*
+ * Passthrough bios are mapped directly onto requests via
+ * blk_rq_map_user() and never pass through submit_bio(), so they carry
+ * no blkcg association and are invisible to cgroup io.stat and to every
+ * rq_qos policy (iocost, blk-throttle, iolatency).  Charge the ones that
+ * carry data to the submitter's blkcg at dispatch time and run the
+ * regular bio accounting and rq_qos throttle paths with the associated
+ * bio.
+ *
+ * Gated by opcode (READ/WRITE/DRV_IN/DRV_OUT, the latter two mapped
+ * to READ/WRITE for io.stat classification) and to queues that
+ * already have a gendisk: commands issued during device probing (SCSI
+ * INQUIRY and friends) have no gendisk yet and stay exempt.  The
+ * request bios may carry a stale ->bi_blkg from the mempool; the
+ * association helper drops the old reference and re-associates.
+ */
+static void blk_mq_pt_charge(struct request *rq)
+{
+	struct bio *bio = rq->bio;
+	enum req_op op = req_op(rq);
+
+	if (!bio || !rq->q->disk)
+		return;
+
+	switch (op) {
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
+	case REQ_OP_DRV_IN:
+	case REQ_OP_DRV_OUT:
+		break;
+	default:
+		return;
+	}
+	if (op == REQ_OP_DRV_IN)
+		op = REQ_OP_READ;
+	else if (op == REQ_OP_DRV_OUT)
+		op = REQ_OP_WRITE;
+
+	if (!bio->bi_bdev)
+		bio->bi_bdev = rq->q->disk->part0;
+	bio->bi_opf &= ~REQ_OP_MASK;
+	bio->bi_opf |= op;
+#ifdef CONFIG_BLK_CGROUP
+	/*
+	 * Issued from kthreads the css is root and the charge is a
+	 * no-op through the root exemptions; data-op issuers that
+	 * matter run in the submitter's task context.
+	 */
+	{
+		struct cgroup_subsys_state *css;
+
+		rcu_read_lock();
+		css = task_css(current, io_cgrp_id);
+		bio_associate_blkg_from_css(bio, css);
+		rcu_read_unlock();
+	}
+#endif
+	blk_cgroup_bio_start(bio);
+
+	/*
+	 * The rq_qos throttle path may sleep on the waitqueues like any
+	 * bio submitter; all callers found (ioctl / uring_cmd submit,
+	 * target and error handling kthreads) run in sleepable context.
+	 */
+	rq_qos_throttle(rq->q, bio);
+}
+
 /**
  * blk_execute_rq_nowait - insert a request to I/O scheduler for execution
  * @rq:		request to insert
@@ -1412,6 +1480,7 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
  * Note:
  *    This function will invoke @done directly if the queue is dead.
  */
+
 void blk_execute_rq_nowait(struct request *rq, bool at_head)
 {
 	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
@@ -1419,6 +1488,7 @@ void blk_execute_rq_nowait(struct request *rq, bool at_head)
 	WARN_ON(irqs_disabled());
 	WARN_ON(!blk_rq_is_passthrough(rq));
 
+	blk_mq_pt_charge(rq);
 	blk_account_io_start(rq);
 
 	if (current->plug && !at_head) {
@@ -1484,6 +1554,8 @@ blk_status_t blk_execute_rq(struct request *rq, bool at_head)
 	WARN_ON(irqs_disabled());
 	WARN_ON(!blk_rq_is_passthrough(rq));
 
+	blk_mq_pt_charge(rq);
+
 	rq->end_io_data = &wait;
 	rq->end_io = blk_end_sync_rq;
 
-- 
2.43.0

