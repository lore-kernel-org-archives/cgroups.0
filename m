Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF1247ECC1
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 08:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548808; cv=none; b=lGZ7R3SGOuCvWIqDaBt3P3OGmwLoamsjVVHGwNJz9WA/Xw5sJYaYN8Xl9l7NJ7aiDFg8TJsbj6BRmEdsf7dbDREJg8Z+eQhkqwSpxKOp+QhIs+ZBYocSV6C5VlZBZ1tlzNMT+IGFSJlIR+6I1UnAF9zu22NWx29TTr9MgOlKj4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548808; c=relaxed/simple;
	bh=fdL14IAAyspEhi0GV5wFbcG5ftrEbuX893CxOZt28EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+6d9ta4zpVsVApZS/tLZj/MMNRIIwub+g1/JcGbT2/Hl+wlRNhqqgv2CDsV7ZbAtaF6tT28ECpYQbQrQFi1WzjAnnphgQ1q8y3h2zF1sYOy/5r7WvE7Flwa68rEvGkKrIDS/QmTj+coonNovRwkzjE63as397Vy1xBYRWBE9q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rJjskVak; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rJjskVak"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fdL14IAAyspEhi0GV5wFbcG5ftrEbuX893CxOZt28EQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789548799; v=1; x=1790153599;
 b=rJjskVaksFI6BVZw8GRHy8W9KY1hRiz3xucG6/nGugfQeNcWtrDMAYN+SkceJkhxWHyEXYip
 GMZFjXr9+Ynmm3RQRLgUUxoPRfZDW48HbT0EzGhBmOzJs47vurdC4CJlBK5/858PC4xmi7DjTi9
 vPQgqSMfzN3A8UORn5wbwiA8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cb84e947b6f73556;
	Wed, 16 Sep 2026 08:53:19 +0000
X-Mizu-Trace-ID: cb84e947b6f73556
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	hch@infradead.org
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH v2 1/4] blk-iocost: charge flushes as pageless random writes
Date: Wed, 16 Sep 2026 16:53:01 +0800
Message-ID: <20260916085304.1080271-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916085304.1080271-1-cui.tao@linux.dev>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Standalone flushes issued by blkdev_issue_flush() are represented as
dataless REQ_OP_WRITE | REQ_PREFLUSH bios, which
calc_vtime_cost_builtin() prices at zero.  The flush component of
flush-heavy workloads such as database commits, journal flushes, and
metadata sync is thus neither charged nor throttled: a cgroup at 1% weight
can issue ~510k flushes per 12s, monopolizing the device while iocost
reports zero usage.

The same is true for the flush component of data-bearing
REQ_OP_WRITE | REQ_PREFLUSH bios, e.g. journal commit writes: they are
charged for their data only, and the cache flush the flush machine runs
ahead of it is free.

Charge the flush component of any REQ_PREFLUSH bio on top of its data
cost, priced as a pageless random write (LCOEF_WRANDIO), which provides
an approximation of the device time consumed by a flush.  For profiles
where WRANDIO clamps to zero (ssd_dfl / ssd_fast), use a one-page floor
(LCOEF_WPAGE).  A dataless flush bio falls out of the switch with zero
data cost and picks up the same surcharge, so standalone and pre-flush
forms are priced the same way.  After this patch, the same 1%-weight
cgroup is limited to 24 flushes per 12s; on ext4, write+fsync workloads
are correctly accounted through the journal layer (~2.2us per flush on
the ssd_fast profile).

A standalone flush must also not update iocg->cursor: its bi_sector
(usually 0) is not a data position, so setting the cursor from it
would misclassify the following READ/WRITE bios, and a zero cursor
defeats the !iocg->cursor sentinel in calc_vtime_cost_builtin().
Skip the cursor update for dataless bios.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
Changes in v2:
- Skip the iocg->cursor update for dataless flush bios, which would
  otherwise corrupt the seq/rand classification of the following IOs
  (reported in review of v1).
- Charge the flush component of data-bearing REQ_PREFLUSH bios too;
  v1 only priced standalone flushes (reported in review of v1).
---
 block/blk-iocost.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2745bffcd5eef..082f26d6e27b6 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2532,8 +2532,20 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 	u64 pages = max_t(u64, bio_sectors(bio) >> IOC_SECT_TO_PAGE_SHIFT, 1);
 	u64 seek_pages = 0;
 	u64 cost = 0;
+	u64 flush_cost = 0;
 
-	/* Can't calculate cost for empty bio */
+	/*
+	 * A WRITE|REQ_PREFLUSH bio carries a flush component: the flush
+	 * machine runs a cache flush for it, either standalone (dataless)
+	 * or ahead of the data.  Charge the flush on top of the data cost,
+	 * priced as a pageless random write with a one-page floor so fast
+	 * profiles still charge something.  Flush bios are never merged.
+	 */
+	if (!is_merge && (bio->bi_opf & REQ_PREFLUSH))
+		flush_cost = max(ioc->params.lcoefs[LCOEF_WRANDIO],
+				 ioc->params.lcoefs[LCOEF_WPAGE]);
+
+	/* Can't calculate data cost for empty bio */
 	if (!bio->bi_iter.bi_size)
 		goto out;
 
@@ -2566,7 +2578,7 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 	}
 	cost += pages * coef_page;
 out:
-	*costp = cost;
+	*costp = cost + flush_cost;
 }
 
 static u64 calc_vtime_cost(struct bio *bio, struct ioc_gq *iocg, bool is_merge)
@@ -2708,7 +2720,9 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	if (!iocg_activate(iocg, &now))
 		return;
 
-	iocg->cursor = bio_end_sector(bio);
+	/* dataless bios have no meaningful position for seq/rand detection */
+	if (bio->bi_iter.bi_size)
+		iocg->cursor = bio_end_sector(bio);
 	vtime = atomic64_read(&iocg->vtime);
 	cost = adjust_inuse_and_calc_cost(iocg, vtime, abs_cost, &now);
 
-- 
2.43.0

