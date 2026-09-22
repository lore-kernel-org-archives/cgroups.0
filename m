Received: from mta0.migadu.com (out-214.mta0.migadu.com [91.218.175.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA9C3F074A
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 04:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790051965; cv=none; b=GuHvY4/puMXO/EgC9QrspUy9JlGGr5G6UsnSlWQt/SgegA4DpaolfsAUjim6NoPXKKReoiYojlvkxiySs+XGcm94csU1PpjF2fuH5RWwobylRvu1Rc1/sB1Kon99LpvA4BRs20UO/XbPSnGv91zkb799OIE+g/Pa5DYEJfuozUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790051965; c=relaxed/simple;
	bh=0VtSHkdHTfcdVbTtSFL1fJxXQTywihOSl1/4YTdOgnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWla7hg0V3C+oWYWmSXHnV0BMI6BXdARR4U5m35L59iHcDrDX0laDtBKYMVMF5j3pF2/xEqEhVTEnuv1Al6wbGh6/fbJBObUteVHGq+iBHyMSLR2V5wjq++WjLwjL/+20CJZDdW5xKR6P82zVvevFr5boSRNJsNsigVcy88DCs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X5TWm0W9; arc=none smtp.client-ip=91.218.175.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X5TWm0W9"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0VtSHkdHTfcdVbTtSFL1fJxXQTywihOSl1/4YTdOgnU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790051957; v=1; x=1790656757;
 b=X5TWm0W9cm2cRdCgsHaaxsVUdBV+Cc42rS9fr0t2ofsZzvcGtubZ+t1waETf6OALmWkTmqMx
 ryzjLaMjooXJIHNj5rBgZdLfraVEYvSD5ls4e5Nq3ZFxroxqR4lPiRLoUe3jN/dgV2GOPO9LNpt
 07tu6+0TJxwTf6HQgtYMA5nc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d74de2a8690f9189;
	Tue, 22 Sep 2026 04:39:17 +0000
X-Mizu-Trace-ID: d74de2a8690f9189
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	hch@infradead.org
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH v4 1/4] blk-iocost: add flush cost support with the flushiops model parameter
Date: Tue, 22 Sep 2026 12:38:53 +0800
Message-ID: <20260922043856.2020116-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922043856.2020116-1-cui.tao@linux.dev>
References: <20260922043856.2020116-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

The builtin linear cost model defines coefficients only for READ and
WRITE, so the flush component of IOs is priced at zero: standalone
flushes (the dataless REQ_OP_WRITE | REQ_PREFLUSH bios from
blkdev_issue_flush()) and the pre-flush the block layer issues ahead of
data-bearing REQ_PREFLUSH bios are both free.  A cgroup limited to 1%
weight could issue an unbounded number of flushes without being
throttled: an fsync loop produced ~510k flushes in 12s with
cost.usage staying at zero, monopolizing the device while iocost
reported no activity.  On ext4, a write+fsync workload showed the same
gap: the write component was charged but the flush component was not.

A flush is not like a write and the write coefficients say nothing
about what it costs, so instead of pricing it off them, add a flushiops
entry to io.cost.model, following the existing iops parameters: it sets
the rate at which flushes are charged, LCOEF_FLUSH =
VTIME_PER_SEC / flushiops.  The linear model cannot express how the
cost of a flush depends on the preceding writes, so this is a
per-request policy charge: a user-tunable knob rather than a hardware
property.  A bio with REQ_PREFLUSH is charged one flush on top of its
data cost, and a bio with REQ_FUA one more flush on devices without
native FUA support.  Zero (the default and the builtin profiles) means
no charge, so nothing changes until the parameter is configured.

Also skip the iocg->cursor update for dataless bios: they only reach it
once priced, and their bi_sector is not a data position, so setting
the cursor from it would misclassify the following IOs.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  7 +++++++
 block/blk-iocost.c                      | 27 +++++++++++++++++++++----
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8d2603751c51..231c39d1a11a 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2131,6 +2131,7 @@ IO Interface Files
 	  [r|w]bps	The maximum sequential IO throughput
 	  [r|w]seqiops	The maximum 4k sequential IOs per second
 	  [r|w]randiops	The maximum 4k random IOs per second
+	  flushiops	The maximum flushes per second
 	  =============	========================================
 
 	From the above, the builtin linear model determines the base
@@ -2138,6 +2139,12 @@ IO Interface Files
 	for the IO size.  While simple, this model can cover most
 	common device classes acceptably.
 
+	"flushiops" determines the cost of a cache flush: a write with
+	a preceding cache flush is charged one flush on top of its data
+	cost, and a FUA write one more flush on devices without native
+	FUA support.  It is zero in the builtin profiles, so flushes
+	stay free until it is configured.
+
 	The IO cost model isn't expected to be accurate in absolute
 	sense and is scaled to the device behavior dynamically.
 
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2745bffcd5ee..546458246cf9 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -353,6 +353,7 @@ enum {
 	I_LCOEF_WBPS,
 	I_LCOEF_WSEQIOPS,
 	I_LCOEF_WRANDIOPS,
+	I_LCOEF_FLUSHIOPS,
 	NR_I_LCOEFS,
 };
 
@@ -363,6 +364,7 @@ enum {
 	LCOEF_WPAGE,
 	LCOEF_WSEQIO,
 	LCOEF_WRANDIO,
+	LCOEF_FLUSH,
 	NR_LCOEFS,
 };
 
@@ -883,6 +885,9 @@ static void ioc_refresh_lcoefs(struct ioc *ioc)
 		    &c[LCOEF_RPAGE], &c[LCOEF_RSEQIO], &c[LCOEF_RRANDIO]);
 	calc_lcoefs(u[I_LCOEF_WBPS], u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS],
 		    &c[LCOEF_WPAGE], &c[LCOEF_WSEQIO], &c[LCOEF_WRANDIO]);
+
+	c[LCOEF_FLUSH] = u[I_LCOEF_FLUSHIOPS] ?
+		DIV64_U64_ROUND_UP(VTIME_PER_SEC, u[I_LCOEF_FLUSHIOPS]) : 0;
 }
 
 /*
@@ -2533,7 +2538,16 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 	u64 seek_pages = 0;
 	u64 cost = 0;
 
-	/* Can't calculate cost for empty bio */
+	/*
+	 * FUA on a device without native support becomes a post-flush;
+	 * charge it like PREFLUSH from the flush coefficient.
+	 */
+	if (bio->bi_opf & REQ_PREFLUSH)
+		cost += ioc->params.lcoefs[LCOEF_FLUSH];
+	if ((bio->bi_opf & REQ_FUA) && !bdev_fua(bio->bi_bdev))
+		cost += ioc->params.lcoefs[LCOEF_FLUSH];
+
+	/* Can't calculate data cost for empty bio */
 	if (!bio->bi_iter.bi_size)
 		goto out;
 
@@ -2708,7 +2722,9 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	if (!iocg_activate(iocg, &now))
 		return;
 
-	iocg->cursor = bio_end_sector(bio);
+	/* dataless bios have no meaningful position for seq/rand detection */
+	if (bio->bi_iter.bi_size)
+		iocg->cursor = bio_end_sector(bio);
 	vtime = atomic64_read(&iocg->vtime);
 	cost = adjust_inuse_and_calc_cost(iocg, vtime, abs_cost, &now);
 
@@ -3440,10 +3456,12 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
 	spin_lock_irq(&ioc->lock);
 	seq_printf(sf, "%s ctrl=%s model=linear "
 		   "rbps=%llu rseqiops=%llu rrandiops=%llu "
-		   "wbps=%llu wseqiops=%llu wrandiops=%llu\n",
+		   "wbps=%llu wseqiops=%llu wrandiops=%llu "
+		   "flushiops=%llu\n",
 		   dname, ioc->user_cost_model ? "user" : "auto",
 		   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS], u[I_LCOEF_RRANDIOPS],
-		   u[I_LCOEF_WBPS], u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS]);
+		   u[I_LCOEF_WBPS], u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS],
+		   u[I_LCOEF_FLUSHIOPS]);
 	spin_unlock_irq(&ioc->lock);
 	return 0;
 }
@@ -3470,6 +3488,7 @@ static const match_table_t i_lcoef_tokens = {
 	{ I_LCOEF_WBPS,		"wbps=%u"	},
 	{ I_LCOEF_WSEQIOPS,	"wseqiops=%u"	},
 	{ I_LCOEF_WRANDIOPS,	"wrandiops=%u"	},
+	{ I_LCOEF_FLUSHIOPS,	"flushiops=%u"	},
 	{ NR_I_LCOEFS,		NULL		},
 };
 
-- 
2.43.0

