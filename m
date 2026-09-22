Received: from mta1.migadu.com (out-144.mta1.migadu.com [95.215.58.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E2835DA55
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 04:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790051984; cv=none; b=Hw003uElaFdoQJpDA6SCGi1dwrRmXqdBi7JG7GB7dP2JHVdhzBoEPt01XkeT6uS+EuKYRBgg+kYTOQ/w00n825H5WN3ETJffdIvhNY3wcHJksCGpRZfKbqDOaPJ0NKGJ3mVYJ/JR7rbiiM5GAZB4yOl59vVl3yRAdQkbpFOj0jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790051984; c=relaxed/simple;
	bh=bXbEK/PiziSTn08RAdNdo/eKnwYk983TIRsyonb/wYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sS7Lcpbf3ev/2Rz3Wksm+ZqrgSd2nlxBzNIcynyjxMWueh2Wgv21tw1cumyjOXwp0ahnIOetTK7XMgKQXncAAmGormRd4IJVImSwo9I7M+IpdWNBRrxKW6GyAuOLDRwdcsM5226mEd3tNpO2Ii/oJlv5pVT+pqht4wocFMKII9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U/MCce+c; arc=none smtp.client-ip=95.215.58.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U/MCce+c"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bXbEK/PiziSTn08RAdNdo/eKnwYk983TIRsyonb/wYU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790051974; v=1; x=1790656774;
 b=U/MCce+cvi5fr37Oa/MzgQQoiX8ooYC5HJ+GEXD17Sx07+JtAJQ8K16ra3tkNy4bz36Y6hGN
 WD7Vs3NX89a7+Cbk/On7w96koBsIJyj1rBQcCLeFzen0oapHGzHrNyGIs06gtbyE95oJW0H4LUQ
 mAU8DWwEK22UyhMDR56UYQ1A=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 04fdd75e5b702cb4;
	Tue, 22 Sep 2026 04:39:34 +0000
X-Mizu-Trace-ID: 04fdd75e5b702cb4
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
Subject: [PATCH v4 4/4] blk-iocost: fix stale comment in ioc_rqos_throttle()
Date: Tue, 22 Sep 2026 12:38:56 +0800
Message-ID: <20260922043856.2020116-5-cui.tao@linux.dev>
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

The comment says that priority-inversion IOs are "punted to
@ioc->aux_iocg", but no aux_iocg field ever existed in struct ioc.
The comment was introduced already stale by commit da437b95db83
("blk-iocost: grab ioc->lock for debt handling").  Update it to
describe the current use_debt / iocg->abs_vdebt mechanism.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 9ca58cfbce86..a81488c755ca 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2743,10 +2743,11 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 
 	/*
 	 * We're over budget. This can be handled in two ways. IOs which may
-	 * cause priority inversions are punted to @ioc->aux_iocg and charged as
-	 * debt. Otherwise, the issuer is blocked on @iocg->waitq. Debt handling
-	 * requires @ioc->lock, waitq handling @iocg->waitq.lock. Determine
-	 * whether debt handling is needed and acquire locks accordingly.
+	 * cause priority inversions are issued regardless and charged against
+	 * @iocg->abs_vdebt as debt. Otherwise, the issuer is blocked on
+	 * @iocg->waitq. Debt handling requires @ioc->lock, waitq handling
+	 * @iocg->waitq.lock. Determine whether debt handling is needed and
+	 * acquire locks accordingly.
 	 */
 	use_debt = bio_issue_as_root_blkg(bio) || fatal_signal_pending(current);
 	ioc_locked = use_debt || READ_ONCE(iocg->abs_vdebt);
-- 
2.43.0

