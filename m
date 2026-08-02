Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80DE3C09F3
	for <cgroups@vger.kernel.org>; Sun,  2 Aug 2026 15:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785683909; cv=none; b=bTFwZU/8wO6aq16W9BpjXRoCQ/z65x5VvK1s23JDVDyQaXTJS5Pm2PziZUW7E9yFdMBQMefzYf1U7mmanalZ9c1+N0JuPvok0mfR3yj596b99SrTjaR8tg4ebgSg78g8iLVtzN6iRaZhWTkWd2Ffk4sP61RYm5mTb/pc4bXaJsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785683909; c=relaxed/simple;
	bh=T36/4Ejjiy5odXG4QB3fu/Kf8rd0KzX7NAGBSokqo2A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XWVtxgHwWcMaInz2hbaxXzlfIOECzhCVId2Z4ZANM3X6gQp8N/b7XzIt3qFWCqIT4HQJCfuXsS9e3psdPux1/IARzi30xH3TysqJtrIGuvbwUpqjScv3GwYtUEGxBINgNNLRliAUTZlrLGJEQtBtDo6KSQKsga22eT7AwidkiAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rg7EgQr5; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rg7EgQr5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785683893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h3rFpk5yukQZkFt2SrOCVUimOAtm8ZF/Q+0Pgr/OyYE=;
	b=rg7EgQr5XndWr9IqCvu+o3O34BdRE/70gcYk+uZP8DTgDP0wL/eDFv3/u9HkhbEFviUOiW
	jtYe2vENjut00n9DvetEj/N7H223NOMpVwFWk+Wc/WGj+h/Tvee8rM2BWs7ACS57xXLdAs
	Yp2jcCVP//W/DlYV8uAqgnz2LcZAtA8=
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	axboe@kernel.dk
Cc: josef@toxicpanda.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] block/blk-iocost: annotate committed flag with READ_ONCE/WRITE_ONCE
Date: Sun,  2 Aug 2026 23:17:55 +0800
Message-ID: <20260802151755.35511-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

The "committed" wait flag is written by iocg_wake_fn() under
waitq.lock and read by ioc_rqos_throttle() without the lock, which
trips KCSAN.  The ordering is already handled by
set_current_state()/wake_up() so the race is harmless.  Use
READ_ONCE()/WRITE_ONCE() to document the intentional lockless access.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 8b2aeba2e1e3..782bbe2d27b3 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1458,7 +1458,7 @@ static int iocg_wake_fn(struct wait_queue_entry *wq_entry, unsigned mode,
 		return -1;
 
 	iocg_commit_bio(ctx->iocg, wait->bio, wait->abs_cost, cost);
-	wait->committed = true;
+	WRITE_ONCE(wait->committed, true);
 
 	/*
 	 * autoremove_wake_function() removes the wait entry only when it
@@ -2763,7 +2763,7 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 
 	while (true) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (wait.committed)
+		if (READ_ONCE(wait.committed))
 			break;
 		io_schedule();
 	}
-- 
2.43.0

