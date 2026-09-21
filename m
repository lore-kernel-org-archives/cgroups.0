Received: from mta1.migadu.com (out-130.mta1.migadu.com [95.215.58.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AAE335081
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 03:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961753; cv=none; b=EIbZbb9/+PHB1Kevb1CZYAQt4tb+o2JX6OJmPKcWtPt22GU+5kQOkhKN2QIrSEMZFQ/B63NHthwPbDR730JUwLLFiwAXCHWHFgqw5OHmqJUz5s36QAR8NsxQmNS3GI7WgxgpXfSkqZJS1OVwBtit/57GzKmDkwM5aZB0Zy7t86M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961753; c=relaxed/simple;
	bh=T90yU4yQzsA33m2pyuxCSgQK5dK6cah7IeuH2VTNOwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLVZhlUv/bC+Td1Pu2wxTd5nVxLnSDFmpW8f3+44FmxYI3gYdXSSI7+eQRA2DTKkar3wIA7rEjBc5PJiyBYYdWgWwWsDTkJOhLQCkt0MKFrjaS047zXk53k3j09MimdtU6u1h2Fe717Pp/FKfgr8l9lamiU0wfOcAd+xsxq3RyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pj8g1oiE; arc=none smtp.client-ip=95.215.58.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pj8g1oiE"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=T90yU4yQzsA33m2pyuxCSgQK5dK6cah7IeuH2VTNOwo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789961744; v=1; x=1790566544;
 b=pj8g1oiE/N4ACKjmeVG+Fm3GzfmDhQvEJGg/rMqI0HugYd14zLRuwZXYKhGn1Q7qN6Sk6Hxm
 qzcBMI3qvohE2c1792gkNK7lOZCwz+6p2aNgcKxf0clqy4bWEPwpGSp4zYeFluicqfAHpFKzYbN
 2cdmKztQkFfGDy4Ie1cMzKyg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5a515e88813954e3;
	Mon, 21 Sep 2026 03:35:44 +0000
X-Mizu-Trace-ID: 5a515e88813954e3
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
Subject: [PATCH v3 3/4] blk-iocost: account zone append completions in latency stats
Date: Mon, 21 Sep 2026 11:34:52 +0800
Message-ID: <20260921033453.1912971-4-cui.tao@linux.dev>
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
---
 block/blk-iocost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 7ce68e2c2e1a..ec10028249fb 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2609,6 +2609,7 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 	case REQ_OP_READ:
 		*costp = pages * ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		*costp = pages * ioc->params.lcoefs[LCOEF_WPAGE];
 		break;
@@ -2879,6 +2880,7 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 		pidx = QOS_RLAT;
 		rw = READ;
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		pidx = QOS_WLAT;
 		rw = WRITE;
-- 
2.43.0

