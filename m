Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F6E47DF98
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 08:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548822; cv=none; b=B3PCym99W/hkboWhOkF8tbMftaTqWCIJH0BaNEiSVoEn419aPnhDvaUfMZSEcKeZ8dGb+mFTr8G5aRl3SvO1e1JG3ydX1KCA2ZpE1bqNLxMKm56a320pEGvu6V9lFagqejuCj3ElWDwQGcpA6hAFy+QFtw/oVSyhmMURVibLdhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548822; c=relaxed/simple;
	bh=kCLIOKC5wMvDVR07yq/o4W7NDVvGkZvtFSaE4nzjdqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAJjQ9QeBQ8GbyEYB3KYnsifPEZIubJ54BeFRg0WY+PLgpJMLT4FcHofqqvrvQTsPjdbGGcMS7yZYCU8pcfIMVumUqPSgFLnhT7pfbfhGTprAp+NuhJI/nkNeHnb1YmB9UnVHMLVvjDrNAxLPkmxD7mpT3KeCJBb1G5oCRod6W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f/EAGotJ; arc=none smtp.client-ip=91.218.175.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f/EAGotJ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kCLIOKC5wMvDVR07yq/o4W7NDVvGkZvtFSaE4nzjdqU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789548813; v=1; x=1790153613;
 b=f/EAGotJivNnLMAsqHzWgdw5Ifv8zRv5DVXNFDwebnGbRRVADz3IopW1v1v8CT4rMM/YvUz4
 H+kQ9iSvTHDO6U9OKPomSdK8g+8XIGCfrjAVyRqwqFYVk0EtM6iwFA3pKF8o03qtmLGDvqG6NdF
 XncWDJkd2mh5nOvE0i0LGP38=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 918a633a8f8616b2;
	Wed, 16 Sep 2026 08:53:33 +0000
X-Mizu-Trace-ID: 918a633a8f8616b2
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
Subject: [PATCH v2 3/4] blk-iocost: account zone append completions in latency stats
Date: Wed, 16 Sep 2026 16:53:03 +0800
Message-ID: <20260916085304.1080271-4-cui.tao@linux.dev>
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

ioc_rqos_done() only accounts READ and WRITE completions, so zone
append completions are excluded from the latency window: the vrate
feedback loop cannot see ZA-induced latency, leaving it unable to
respond to device saturation caused by zone appends.  Similarly,
calc_size_vtime_cost_builtin() does not classify zone append as a
write operation.

This is not covered by the patch that prices zone appends: charging
goes through the cost model, while the latency window is the feedback
path the vrate controller watches.

Treat zone append as WRITE for both latency accounting and cost
classification.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2e4e9ce2c9359..ef1b7e65455e2 100644
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

