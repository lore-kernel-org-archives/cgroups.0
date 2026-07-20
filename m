Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792D341DEC8
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784554715; cv=none; b=Xxv0JqGsU0NV+gMXcSCk5RKJJaD+lNdNpYR1UNVNYsaagroGiAYrXCeZRqeZ4B+4g/4vlELEXa1W2LMdVlyemCRqYAa1zGhVO9ef3AyGPmO5scnFI0/Pxy4Typtu5QPsnxWpV5v08MacBjMcvLScVJdBBerwAdDYeylPyo0WUyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784554715; c=relaxed/simple;
	bh=rAWYy+XgM2+PVqAjj1+13LrrgPiy6gU2vIF5sbQoFCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fOREpGUKbZD0YLS9iCLPtyO3k3/x7Fx7ibCPevFz6sKtkY9krlUgDJ0ymFFIpdPyJLSoZtcMbzB4q/bqfrGdJPgacsNdd0qISvVelSBTxKnDWxaN19kWVwgyb8RNRRWkLtG2YPFNswCSmSsugHa1JHBlugmtKeQhFWSM+JRj6bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vvyJPX6h; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vvyJPX6h"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784554711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rekiApd+TL8VgL26SdAjVH6XkN7/9eFi2Fixg55/ce0=;
	b=vvyJPX6hV1CKDyBx8ByeJnoL/+C//e5ZFhhCwstNbcd8vJWMFTtuCSWTRq0tS6T/z2YwFO
	vwH2QfCIy6tbpQd5dGEXoxRvCcbq7+wfdv2E3OTOu2phuSpHosGDNwM5VifttLSmt93xck
	GUoj1kJ7ihS9lK5bQvGILpoqDmCu/Vw=
From: Tao Cui <cui.tao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Omar Sandoval <osandov@fb.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] block/blk-stat: fix mean loss when re-summing aggregated stats
Date: Mon, 20 Jul 2026 21:38:12 +0800
Message-ID: <20260720133813.45150-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

blk_rq_stat_sum() folds src into dst but only advances dst->mean and
dst->nr_samples, leaving dst->batch untouched.  The mean is computed
from src->batch (the raw per-cpu sum), so a stat that has already been
through one sum carries batch=0; if that aggregated stat is then used
as the src of another sum, its samples add nothing to the new mean.

iolatency hits exactly that: iolatency_check_latencies() first sums the
per-cpu stats into a local stat, then sums that local stat into
iolat->cur_stat.  After the first sum the local stat has batch=0, so
every later window drives cur_stat->mean toward zero.  On non-SSD
devices it stays at 0, making the latency_sum_ok(&cur_stat) check that
gates scaling up always true -- the scale-up hysteresis is effectively
defeated.  SSD devices use the percentile path and are unaffected.

Keep dst->batch in sync across sums so an aggregated stat can be reused
as a src.  blk_rq_stat.batch is internal to blk_rq_stat_init/_add/_sum
(no other reader in the tree), so the wbt and blk-mq consumers, which
only read ->mean/->min/->nr_samples, behave as before.

Fixes: 34dbad5d26e2 ("blk-stat: convert to callback-based statistics reporting")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---
 block/blk-stat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-stat.c b/block/blk-stat.c
index de126e1ea5ac..4d4781350083 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -36,6 +36,7 @@ void blk_rq_stat_sum(struct blk_rq_stat *dst, struct blk_rq_stat *src)
 	dst->mean = div_u64(src->batch + dst->mean * dst->nr_samples,
 				dst->nr_samples + src->nr_samples);
 
+	dst->batch += src->batch;
 	dst->nr_samples += src->nr_samples;
 }
 
--
2.43.0
