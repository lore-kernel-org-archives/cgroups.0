Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8312239E185
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 03:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784603020; cv=none; b=EDx13DofS2c43+XKuUrtYdUizfRRh+QTb0LOdE1Y8l9Z6R8UZmBOUK76OdSZLd5boneyHzBFZdGX6i35ngmp7bWw5aQ6OL6kt7HG4x/h4ODpY5URSNOXh1o2eEaTyDVeLgYXeFvRRhX2zsWSJv5uOjxqh1Yc4TbWkBSYq3dnQLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784603020; c=relaxed/simple;
	bh=qOSOZ+46FwE2YqJqznkiZP3g8UVlp2ZbNJu3xjAOBko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TBpBbekD9064wP8ri5HSnB8IVV2Eaas7pMfdv0uNcMUraBu4QnJl23DnvVpytuMoEHcTmJ3ev8ZhZ5+DmIa9PNqGK0ygColQ1Zw1BhNLa/krrD9RXEzEZW6PHAH7WXu2NXpeuRYipfQK1qY0dTqxZlw7cUR9jXiOLAA3eHeGj00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fyT+o3Tm; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fyT+o3Tm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784603016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xfsN9Kw7wu73FsURTzKZxgbWpkaGaGIV0QcL4oImT5g=;
	b=fyT+o3TmrHxJWty4gJow1C2BpM5TF40lvoe/NWIHK3by/tT0xzzgczAnNRjJXhOqlbMY2L
	WcNFZKu+RYQ+6XYVEoINhEOArbKhdQAnnd31SOazZXfUYJm61gYNDyfKDq4cCKoZ1JUvIZ
	aZ2f9dpthQsU/cxEOf24te0dn2yI6R4=
From: Tao Cui <cui.tao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Tang Yizhou <tangyeechou@gmail.com>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v2] block/blk-iolatency: fix always-zero cur_stat mean on non-SSD
Date: Tue, 21 Jul 2026 11:03:12 +0800
Message-ID: <20260721030312.85655-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

iolatency_check_latencies() accumulates the per-window latency stat
into iolat->cur_stat via latency_stat_sum(), which for non-SSD devices
calls blk_rq_stat_sum().  But blk_rq_stat_sum() is contracted on a raw
per-cpu src -- it folds src->batch into the new mean -- and by the time
the per-window stat reaches cur_stat it is already aggregated, with
batch left at 0.  Each window therefore contributes zero latency to
cur_stat->mean, which on non-SSD devices stays at 0; the
latency_sum_ok(&cur_stat) check that gates scaling up is always true,
so the scale-up hysteresis never engages.  SSD devices use the
percentile path and are unaffected.

Add latency_stat_merge(), which merges two already-aggregated stats by
their reconstructed totals (mean * nr_samples) instead of src->batch,
and use it for the cur_stat accumulation.  The earlier per-cpu sum in
iolatency_check_latencies() still uses latency_stat_sum()/blk_rq_stat_sum(),
whose contract is a raw per-cpu src; only the cur_stat accumulation --
where the src is already aggregated -- switches to latency_stat_merge().

Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---
Changes in v2: move the fix from blk-stat.c (blk_rq_stat_sum) into
blk-iolatency.c, per Tang Yizhou's review -- blk_rq_stat_sum() is contracted on
a raw per-cpu src, so the aggregated-stat merge belongs in the iolatency
caller, not the shared helper.

v1: https://lore.kernel.org/all/20260720133813.45150-1-cui.tao@linux.dev/

 block/blk-iolatency.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index cef02b6c5fa9..24fbd281e4b5 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -216,6 +216,32 @@ static inline void latency_stat_sum(struct iolatency_grp *iolat,
 		blk_rq_stat_sum(&sum->rqs, &stat->rqs);
 }
 
+/*
+ * Like latency_stat_sum(), but @stat is itself already aggregated (i.e.
+ * carries a valid mean), not a raw per-cpu stat. blk_rq_stat_sum() is
+ * contracted on a raw src -- it reads src->batch -- so for the non-SSD
+ * case merge by the reconstructed totals (mean * nr_samples) instead.
+ */
+static inline void latency_stat_merge(struct iolatency_grp *iolat,
+				      struct latency_stat *sum,
+				      struct latency_stat *stat)
+{
+	if (iolat->ssd) {
+		sum->ps.total += stat->ps.total;
+		sum->ps.missed += stat->ps.missed;
+	} else {
+		if (sum->rqs.nr_samples + stat->rqs.nr_samples <=
+		    sum->rqs.nr_samples)
+			return;
+		sum->rqs.mean = div_u64(sum->rqs.mean * sum->rqs.nr_samples +
+					stat->rqs.mean * stat->rqs.nr_samples,
+					sum->rqs.nr_samples + stat->rqs.nr_samples);
+		sum->rqs.min = min(sum->rqs.min, stat->rqs.min);
+		sum->rqs.max = max(sum->rqs.max, stat->rqs.max);
+		sum->rqs.nr_samples += stat->rqs.nr_samples;
+	}
+}
+
 static inline void latency_stat_record_time(struct iolatency_grp *iolat,
 					    u64 req_time)
 {
@@ -547,7 +573,7 @@ static void iolatency_check_latencies(struct iolatency_grp *iolat, u64 now)
 	/* Somebody beat us to the punch, just bail. */
 	spin_lock_irqsave(&lat_info->lock, flags);
 
-	latency_stat_sum(iolat, &iolat->cur_stat, &stat);
+	latency_stat_merge(iolat, &iolat->cur_stat, &stat);
 	lat_info->nr_samples -= iolat->nr_samples;
 	lat_info->nr_samples += latency_stat_samples(iolat, &iolat->cur_stat);
 	iolat->nr_samples = latency_stat_samples(iolat, &iolat->cur_stat);
--
2.43.0
