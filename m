Received: from mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B75137750
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 03:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961740; cv=none; b=j3Gd6Wnev3Jga1J5w7q2wUK+AVYoa8QGnaLWnKz3mla1NqTT0tFgAGU8yZ+vKc+vooNT6TNGlfLQlp7q+N/dsWyr8xadgoKc1aWIkIdAKtVm3oeWunriQyrfRKg1UBcq+FiYtuvz3/Qv3dO7TUd15v146SuUHxOhOUKWGf1uFUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961740; c=relaxed/simple;
	bh=UPxjJaMy+kywgd+ZqUtAsBcW7lmrQMuEb3whwTHYe3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCFeh7roV/9IqFvDzRpVwwNVDPUkgzxNNg5lJdFq/0bcaGd/NU/HgZokRu2tlQc/VR/vC3CKM3gKvbK8d2klYjuDuUxdTMnF2HFU7kDlKIiGSXqc3k4Zs7OG9UcuJPYmJllCB1LrlB/WWkzRs8Z4WyFQkOXhnlpcRJAPuh6qBWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sXg6E4Pf; arc=none smtp.client-ip=95.215.58.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sXg6E4Pf"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=UPxjJaMy+kywgd+ZqUtAsBcW7lmrQMuEb3whwTHYe3U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789961736; v=1; x=1790566536;
 b=sXg6E4Pf/3UpLcBjBn0sgkOE+86klANARck+kne9Ri1/qweT+fTXbN4ouRJz87ZULoj2AOBh
 ogQreDRutiPZdi8czuypR1HvzocQlF6BOmE5DXhzNdHjJDJ3ciMBHiRLvpD7Au/saljO2VV/RMJ
 cpeQi3/3EVUP6UXZnY04UESk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dff60e5ed33885bc;
	Mon, 21 Sep 2026 03:35:11 +0000
X-Mizu-Trace-ID: dff60e5ed33885bc
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
Subject: [PATCH v3 1/4] blk-iocost: add flush cost support with the flushiops model parameter
Date: Mon, 21 Sep 2026 11:34:50 +0800
Message-ID: <20260921033453.1912971-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921033453.1912971-1-cui.tao@linux.dev>
References: <20260921033453.1912971-1-cui.tao@linux.dev>
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
the rate at which flushes are charged, translated like the other iops
coefficients to LCOEF_FLUSH = VTIME_PER_SEC / flushiops.  The linear
model cannot express how the cost of a flush depends on the preceding
writes, so this is a user-tunable policy knob rather than a hardware
property.  A bio with REQ_PREFLUSH is charged one flush on top of its
data cost, and a bio with REQ_FUA one more flush on devices without
native FUA support, mirroring the
pre-flush and post-flush the block layer issues for them.  Zero (the
default and the builtin profiles) means no charge, so nothing changes
until the parameter is configured.

Also skip the iocg->cursor update for dataless bios: they only reach it
once priced, and their bi_sector is not a data position, so setting
the cursor from it would misclassify the following IOs.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst |  8 ++++++
 block/blk-iocost.c                      | 37 +++++++++++++++++++++----
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8d2603751c51..5a6ba29b7789 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2131,6 +2131,7 @@ IO Interface Files
 	  [r|w]bps	The maximum sequential IO throughput
 	  [r|w]seqiops	The maximum 4k sequential IOs per second
 	  [r|w]randiops	The maximum 4k random IOs per second
+	  flushiops	The rate at which flushes are charged
 	  =============	========================================
 
 	From the above, the builtin linear model determines the base
@@ -2138,6 +2139,13 @@ IO Interface Files
 	for the IO size.  While simple, this model can cover most
 	common device classes acceptably.
 
+	"flushiops" determines the cost of a cache flush: a bio with
+	REQ_PREFLUSH is charged one flush on top of its data cost, and
+	a bio with REQ_FUA is charged one more flush on devices without
+	native FUA support, mirroring the pre-flush and post-flush the
+	block layer issues for them.  It is zero in the builtin
+	profiles, so flushes stay free until it is configured.
+
 	The IO cost model isn't expected to be accurate in absolute
 	sense and is scaled to the device behavior dynamically.
 
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2745bffcd5ee..0a0352554dde 100644
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
@@ -2532,8 +2537,25 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 	u64 pages = max_t(u64, bio_sectors(bio) >> IOC_SECT_TO_PAGE_SHIFT, 1);
 	u64 seek_pages = 0;
 	u64 cost = 0;
+	u64 flush_cost = 0;
+
+	/*
+	 * The flush machine runs a cache flush for REQ_PREFLUSH, either
+	 * standalone (dataless) or ahead of the data, and a post-flush for
+	 * REQ_FUA on devices without native FUA support.  Charge each
+	 * component on top of the data cost using the flush coefficient
+	 * (VTIME_PER_SEC / flushiops; zero when flushiops is unset).  Flush
+	 * bios are never merged.
+	 */
+	if (!is_merge) {
+		if (bio->bi_opf & REQ_PREFLUSH)
+			flush_cost += ioc->params.lcoefs[LCOEF_FLUSH];
+		if ((bio->bi_opf & REQ_FUA) &&
+		    !bdev_fua(bio->bi_bdev))
+			flush_cost += ioc->params.lcoefs[LCOEF_FLUSH];
+	}
 
-	/* Can't calculate cost for empty bio */
+	/* Can't calculate data cost for empty bio */
 	if (!bio->bi_iter.bi_size)
 		goto out;
 
@@ -2566,7 +2588,7 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 	}
 	cost += pages * coef_page;
 out:
-	*costp = cost;
+	*costp = cost + flush_cost;
 }
 
 static u64 calc_vtime_cost(struct bio *bio, struct ioc_gq *iocg, bool is_merge)
@@ -2708,7 +2730,9 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	if (!iocg_activate(iocg, &now))
 		return;
 
-	iocg->cursor = bio_end_sector(bio);
+	/* dataless bios have no meaningful position for seq/rand detection */
+	if (bio->bi_iter.bi_size)
+		iocg->cursor = bio_end_sector(bio);
 	vtime = atomic64_read(&iocg->vtime);
 	cost = adjust_inuse_and_calc_cost(iocg, vtime, abs_cost, &now);
 
@@ -3440,10 +3464,12 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
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
@@ -3470,6 +3496,7 @@ static const match_table_t i_lcoef_tokens = {
 	{ I_LCOEF_WBPS,		"wbps=%u"	},
 	{ I_LCOEF_WSEQIOPS,	"wseqiops=%u"	},
 	{ I_LCOEF_WRANDIOPS,	"wrandiops=%u"	},
+	{ I_LCOEF_FLUSHIOPS,	"flushiops=%u"	},
 	{ NR_I_LCOEFS,		NULL		},
 };
 
-- 
2.43.0

