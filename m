Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9EB35B639
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 13:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784554609; cv=none; b=Ab4yerQe4ZQZVW3A2OgDU28ffzY/Vcbw1Y0usYZg1rdc4kFz8aOSUHroYLFByp7aiwg8fP5SdQV7pAnJTgm6Bv1FWvgld537yS6f92o3X8Lxy44DuajxdgUDrfLH0llcPjZLtnhsMRljd687kMprUiqvZn55AGbLux+vooT9dlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784554609; c=relaxed/simple;
	bh=ppvF1PhbcZNtaImOwYmFV6LgdZ5TJTlsnzu9r3ntL7g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZbhZpWR+3h9PSMkh/e8LU4RSTetEllYy2bZYqR6UCqtj/54Otb24L4G7sLts3HBEv0WlzoYT8naht16byKsw2CRjG9vTbDE5MdJUD7Zziw2kXzT0tTaZ8rOX3Hqhd414Ph4kU1Mc127dJ7M39wLklTVYuqVkp3Glwha8O/KeNYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xvJyWr6H; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xvJyWr6H"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784554594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YLg0m0lAi46hNHFlnjuQ6BIaTsmclN7NwvLRDJ8kZGM=;
	b=xvJyWr6H9znvldVxMjt+m24bWg4GUgV8dqAumcTEXVyj2Y9qEEd0V3YzOrA5XJOZURx2nY
	noBjYyYbcyYu/OIYDLkBxHajnivsCmJ76sMeiUoJvFkQoEAiUCgMale7oQaWZoxeHwPQ5+
	crCrKBA7mf3HbPrH0lNW6TP80LAZUxQ=
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
	Tao Cui <cuitao@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] block/blk-stat: fix use-after-free on callback timer teardown
Date: Mon, 20 Jul 2026 21:36:22 +0800
Message-ID: <20260720133622.44949-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

blk_stat_remove_callback() cancels a callback's timer with
timer_delete_sync(), and its callers free the timer's data right after:
wbt_exit() does blk_stat_remove_callback() then wbt_free(), which
kfree()s struct rq_wb -- the very object the timer callback dereferences
as cb->data.

The blk-stat timer callback invokes the consumer's callback (wb_timer_fn
for WBT), which re-arms the timer via mod_timer() while there is
in-flight IO or an active scale_step.  By the timer API contract,
timer_delete_sync() is only meaningful when the caller guarantees the
timer is not restarted; with no shutdown guard in the callback, the
re-arm can win the race -- the callback re-arms the timer,
timer_delete_sync() returns, the data is freed, and the re-armed timer
later fires and dereferences freed memory.

Use timer_shutdown_sync(), which makes any later mod_timer() a no-op and
guarantees the timer cannot be queued or fire again once it returns.
blk_stat_remove_callback() is the generic teardown path for every
blk-stat callback, so this is safe for all users.

Fixes: 34dbad5d26e2 ("blk-stat: convert to callback-based statistics reporting")
Cc: stable@vger.kernel.org
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-stat.c b/block/blk-stat.c
index d57c2fc6bf06..e7f8a9b0c1d2 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -161,7 +161,7 @@ void blk_stat_remove_callback(struct request_queue *q, struct blk_stat_callback *cb)
 		blk_queue_flag_clear(QUEUE_FLAG_STATS, q);
 	spin_unlock_irqrestore(&q->stats->lock, flags);

-	timer_delete_sync(&cb->timer);
+	timer_shutdown_sync(&cb->timer);
 }

 static void blk_stat_free_callback_rcu(struct rcu_head *head)
--
2.43.0
