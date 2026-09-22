Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B85E3EF643
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 04:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790051974; cv=none; b=nGnAtCg6Bhez+/AtsiXpzb/4cjkxgqX5eQLIzAQWOp3jVbxMZGZJhx2YHQUwcXAggKL/alX7VKvtEqXwAL2wR25f87fsIGCRavvmGcMyM69bxP4+rUjYxvgLt9MtPKcPtaoqiDCfpdCM7jAdKfwqwL4L1VgqtJ2mFjvXzkDxtFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790051974; c=relaxed/simple;
	bh=jkQ9YMPODGMTgKGwx8hfh8F2ew/NT3cs1OijQlA8Ws8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ92jIUCNYAlb1KFOG6Ko9Ms17KeShJWw5JUNSk5LxjdpjwhXZP05BSk/SXNAGpFSPalvH+uFtUvY/V8bdgbRWy1B10I7p3iUVTGSC4pWqV3p+LyJENkdBHrSSZiNn8jgduPaLfSEGBxc5jJjp2cQl7i5SE8oqhCScMPWpi+5VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fegZSm7C; arc=none smtp.client-ip=91.218.175.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fegZSm7C"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jkQ9YMPODGMTgKGwx8hfh8F2ew/NT3cs1OijQlA8Ws8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790051965; v=1; x=1790656765;
 b=fegZSm7CM/hIS0JNr4labss0EtG/uPvtPkHgOCyH/a6KNMth9FN9pzzPYxTf1Zvz5Yeow89D
 J/IVLc4cWet7C+mjqUyG8Jzw1kRvRWkJeq5gn3aO6llBKoazecYK53183WRosbFGJF1juxCnf9C
 lGsUNfyMMKJNQThw93yXc/sE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1f5cc8b9c7f2cd4b;
	Tue, 22 Sep 2026 04:39:25 +0000
X-Mizu-Trace-ID: 1f5cc8b9c7f2cd4b
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
	cuitao@kylinos.cn,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 3/4] blk-iocost: account zone append completions in latency stats
Date: Tue, 22 Sep 2026 12:38:55 +0800
Message-ID: <20260922043856.2020116-4-cui.tao@linux.dev>
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

ioc_rqos_done() only accounts READ and WRITE completions, so zone
append completions are excluded from the latency window: the vrate
feedback loop cannot see ZA-induced latency, leaving it unable to
respond to device saturation caused by zone appends.  Similarly,
calc_size_vtime_cost_builtin() does not classify zone append as a
write operation.

Charging (the cost model) and feedback (the latency window) are
separate mechanisms, so this is not covered by the previous patch
that prices zone appends.

Treat zone append as WRITE for both latency accounting and cost
classification.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 6b262ccb6b32..9ca58cfbce86 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2601,6 +2601,7 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 	case REQ_OP_READ:
 		*costp = pages * ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		*costp = pages * ioc->params.lcoefs[LCOEF_WPAGE];
 		break;
@@ -2871,6 +2872,7 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 		pidx = QOS_RLAT;
 		rw = READ;
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		pidx = QOS_WLAT;
 		rw = WRITE;
-- 
2.43.0

