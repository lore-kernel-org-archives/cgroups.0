Received: from mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B09331EBA
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 02:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788834135; cv=none; b=oZhaj+FdmYyHg2z3f4qLHKjjp5CNrmT/BKb8FOtMYuuA2sM/cpmpbTOZgMTdtzeR5TAua1+NylIc8n3QyJ235lsB9fFe3f760n0gNO3TeNVeOgocTU4sjyNb/LPcHEcZIVPThugVvlCLrsBWAiyeJvsePfDZa8JpUZjBBV2vJQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788834135; c=relaxed/simple;
	bh=XrfCJ2yq4Pel9YDmeRVtPrl/rhKP6Bf09p5x0cJBln4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3x2hHMzSQgGWNNhQvyvgplPX47bO46SwuA6OveG4x+aDgt/cqes1fi/LLfEgPlrliRHtJm4yJpYdh9etO6eIDtLcyY74Be/tXkCWhx2g7XguyAWobh73qhV913I2FPOhF9MFb2KkYQ8iWQubmcJLadLakoHovufv3tYiTSzfNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rvFoY7Xj; arc=none smtp.client-ip=91.218.175.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rvFoY7Xj"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XrfCJ2yq4Pel9YDmeRVtPrl/rhKP6Bf09p5x0cJBln4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788834131; v=1; x=1789438931;
 b=rvFoY7XjjTX4cgUSRMNFB0hMFaDhvCOc8rgdEQdzBfxUyMwJc9AAm8Cot25J1iyfmU+m+sB5
 G6QFYdrQUPZNZ899dO9MdHJssFo0G7+E5kE+z8apyfMQcQwnmFyDBG+BtW9GLC2A2IxNOETc5LK
 /9T1vqWOWmeyd/Z5XFz94PoA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6af8ed773968ad58;
	Tue, 08 Sep 2026 02:22:11 +0000
X-Mizu-Trace-ID: 6af8ed773968ad58
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 3/4] blk-iocost: account zone append completions in latency stats
Date: Tue,  8 Sep 2026 10:21:34 +0800
Message-ID: <20260908022135.1429281-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908022135.1429281-1-cui.tao@linux.dev>
References: <20260908022135.1429281-1-cui.tao@linux.dev>
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

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index d7860ec1ad49..1bf622e39ce4 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2606,6 +2606,7 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 	case REQ_OP_READ:
 		*costp = pages * ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		*costp = pages * ioc->params.lcoefs[LCOEF_WPAGE];
 		break;
@@ -2876,6 +2877,7 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 		pidx = QOS_RLAT;
 		rw = READ;
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		pidx = QOS_WLAT;
 		rw = WRITE;
-- 
2.43.0

