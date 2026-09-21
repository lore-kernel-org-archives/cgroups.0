Received: from mta1.migadu.com (out-122.mta1.migadu.com [95.215.58.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA7B335081
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 03:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961744; cv=none; b=BofCLaXIkczB7YLD1NjUOS+uaGV51XShsv0CC5yga1atN14foi6TJa6/acBzayejz71kYGqkKt4+F7dwcdwwXitwfPx5WiAiLw2Hp/8FA7hO9FMtFvMhg58n0WKrFG3DyWJvyKyB+hP1ICPLMFQgBlY63OGR+p2/Podqpu583PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961744; c=relaxed/simple;
	bh=jw+HNZ/h0ecwFOQQg0GRnVDRu6AYuC2p1m3XOQpGwWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XR7pFhCZn0+n5VJxtydyssQfS3wKjzgEyIj5C8SMWcwl4nvmC00pqiEcHhzIrH1UM+FDHh+Y4+sBWj6kfDuzmYXJbKYSWMIgX53NOqT+tV+gYAz9iorkm9+uNDx+rRtizozJNzSHuxXq6Ud+ZaZSFLViha+wSfmQgxy4iOtEtUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NEFRkHck; arc=none smtp.client-ip=95.215.58.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NEFRkHck"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jw+HNZ/h0ecwFOQQg0GRnVDRu6AYuC2p1m3XOQpGwWI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789961740; v=1; x=1790566540;
 b=NEFRkHck4lXNSnugy7+OEPJf2Tyoo/UUCSrsPNfrB40Gof84+u95J0vlWQU4UnZsw5FnNjXP
 jUkugXgC28cfg1TTJcVHWpXH33RUGOetzb3dKsjMhZFqgVjojRV9pUIoVdKXKalO/5IOzhuLuf1
 vuboaOnK44nnrJRhZZDAnefI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0a6b13e55ab07a85;
	Mon, 21 Sep 2026 03:35:40 +0000
X-Mizu-Trace-ID: 0a6b13e55ab07a85
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
Subject: [PATCH v3 2/4] blk-iocost: charge zone appends as writes
Date: Mon, 21 Sep 2026 11:34:51 +0800
Message-ID: <20260921033453.1912971-3-cui.tao@linux.dev>
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

Zone append is a primary write operation for zoned devices; zoned xfs
and btrfs use it for data writes.  It is priced at zero, so the zone
append portion of zoned workloads runs outside the controller: a
1%-weight cgroup issued 16000 appends at zero cost on a zoned null_blk.

Treat REQ_OP_ZONE_APPEND the same as REQ_OP_WRITE so it goes through
the existing seq/rand classification and charging.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 0a0352554dde..7ce68e2c2e1a 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2565,6 +2565,7 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 		coef_randio	= ioc->params.lcoefs[LCOEF_RRANDIO];
 		coef_page	= ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		coef_seqio	= ioc->params.lcoefs[LCOEF_WSEQIO];
 		coef_randio	= ioc->params.lcoefs[LCOEF_WRANDIO];
-- 
2.43.0

