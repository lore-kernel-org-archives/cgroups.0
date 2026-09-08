Received: from mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425E931E838
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 02:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788834124; cv=none; b=mt/f7r3D8u64pqgOZTj6+cDsaleZVEjcUvcuk4GSd45h4N5HaXd2hbe+wAcB20AVDjxolRS5eRw0T+0P7jPEJLAHrku3YthXE5aKj5k9dCZOoam6m7QQa8Cewh0//ZXfhCAm+QBRkgl0pXpaZy+7Pt2zBpxpWd4WZUoGN8zGBQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788834124; c=relaxed/simple;
	bh=pWO4RZatUqrPA6r4dQjv9yyaw0w7zdsYNSyi6AjSt+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZqTY+1V4iXLRLuZYjhuLx8TKh+SY6cgpvR5tc7h52fpyP95F7t7vNTEJbd+7n6IA9dLEIbm94slcW/DBxipnUL3oFEABt1/SFjAmBvHva27lSS8nD9AX11F8JgXU+8q7kMhn43C8B3LyXp3urKnupML/WlkZXpRzvQ2TJyaDA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TVskdhzf; arc=none smtp.client-ip=95.215.58.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TVskdhzf"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pWO4RZatUqrPA6r4dQjv9yyaw0w7zdsYNSyi6AjSt+Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788834119; v=1; x=1789438919;
 b=TVskdhzfKQrLKD4J0X68ckG0Ci8e8tkt1ywDoKHXxUsd0ikdoYapKy6fAh1pcEcVgrCOSiU7
 TdP9NT7yHinDx5YpseE8jtK24IYjjuH9xmXykWeZvbjnnzYZ94NaH9fMnCPj41104dn9dFZKAEl
 jeddX1z8Nx9kzMaQPIg+iMao=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 25ba49c4d1d890a5;
	Tue, 08 Sep 2026 02:21:59 +0000
X-Mizu-Trace-ID: 25ba49c4d1d890a5
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
Subject: [PATCH 1/4] blk-iocost: charge flushes as pageless random writes
Date: Tue,  8 Sep 2026 10:21:32 +0800
Message-ID: <20260908022135.1429281-2-cui.tao@linux.dev>
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

Standalone flushes issued by blkdev_issue_flush() are represented as
dataless REQ_OP_WRITE | REQ_PREFLUSH bios, which
calc_vtime_cost_builtin() prices at zero.  The flush component of
flush-heavy workloads such as database commits, journal flushes, and
metadata sync is thus neither charged nor throttled: a cgroup at 1% weight
can issue ~510k flushes per 12s, monopolizing the device while iocost
reports zero usage.

Price them as pageless random writes (LCOEF_WRANDIO), which provides
an approximation of the device time consumed by a flush.  For
profiles where WRANDIO clamps to zero (ssd_dfl / ssd_fast), use a
one-page floor (LCOEF_WPAGE).  After this patch, the same 1%-weight
cgroup is limited to 24 flushes per 12s; on ext4, write+fsync
workloads are correctly accounted through the journal layer (~2.2us
per flush on the ssd_fast profile).

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2745bffcd5ee..abc512532ed9 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2533,8 +2533,8 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 	u64 seek_pages = 0;
 	u64 cost = 0;
 
-	/* Can't calculate cost for empty bio */
-	if (!bio->bi_iter.bi_size)
+	/* Dataless WRITE|REQ_PREFLUSH (standalone flush) is priced below */
+	if (!bio->bi_iter.bi_size && !(bio->bi_opf & REQ_PREFLUSH))
 		goto out;
 
 	switch (bio_op(bio)) {
@@ -2544,6 +2544,15 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 		coef_page	= ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
 	case REQ_OP_WRITE:
+		if (!bio->bi_iter.bi_size) {
+			/*
+			 * dataless WRITE|REQ_PREFLUSH: standalone flush;
+			 * at least one page so fast profiles still charge
+			 */
+			cost = max(ioc->params.lcoefs[LCOEF_WRANDIO],
+				   ioc->params.lcoefs[LCOEF_WPAGE]);
+			goto out;
+		}
 		coef_seqio	= ioc->params.lcoefs[LCOEF_WSEQIO];
 		coef_randio	= ioc->params.lcoefs[LCOEF_WRANDIO];
 		coef_page	= ioc->params.lcoefs[LCOEF_WPAGE];
-- 
2.43.0

