Received: from mta1.migadu.com (out-51.mta1.migadu.com [95.215.58.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC4133344A
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 02:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788834128; cv=none; b=l68QEEJQqC11kyEeCAVzeFcp/c8WnLM/cb8S8eK9apBazH+Dd4dvYm6+v5L+iNT/32L9rZdI67or6DurHb8+Zw/IvXDgmP1ujs5CT7Fd2LVjDkxyaTGVS+fQ9zrZMlp/Ke/ersXuqTi+X6qtptnesXPWUt08BQEYBtz8igsKvpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788834128; c=relaxed/simple;
	bh=RlLZG9DF6LMhq752V92mo173s8ccnTQNr43ipFQvvoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIApLnLUlitBIyk7TglBDfEOT6oLCNnXEqxTjNb2p+eJiA313Edf7TvlNfQGJFVcqIMc3CmONmRcqtjwY20aOfo9IKLT+V4YjEY1GDAIrAle8m7IQ2WKpcqOJBFX5G7XDlfghI+MYAnl9G+cAuGY+rHSgN8rp25goF+elhelAJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MoRFccNJ; arc=none smtp.client-ip=95.215.58.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MoRFccNJ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=RlLZG9DF6LMhq752V92mo173s8ccnTQNr43ipFQvvoo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788834124; v=1; x=1789438924;
 b=MoRFccNJtw9FXGRQz2iJn/dFpgWkGqRUnSvMH86oAAG/7sX6gKiw0mPCYH2wTuyiH8NEQSpJ
 wp8kJri79LhY1tJJHWJ46XXIaGZ/XO/moyHnUmsddYMKW5pjMr4AxeN8R45FxKZo2G7oYa1KwcO
 HvgFtH9oDQuArD060ng5N36w=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6471dc207b4861e7;
	Tue, 08 Sep 2026 02:22:04 +0000
X-Mizu-Trace-ID: 6471dc207b4861e7
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
Subject: [PATCH 2/4] blk-iocost: charge zone appends as page-counted sequential writes
Date: Tue,  8 Sep 2026 10:21:33 +0800
Message-ID: <20260908022135.1429281-3-cui.tao@linux.dev>
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

Zone append is a primary write operation for zoned devices; zoned
btrfs and f2fs use it for data writes.  It is priced at zero, so the
zone append portion of zoned workloads runs outside the controller:
a 1%-weight cgroup issued 16000 appends at zero cost on a zoned
null_blk.

A zone append advances the zone write pointer and is therefore
sequential from the device's perspective; the actual sector is only
returned after completion, so the cursor-based seq/rand
classification doesn't apply.  Price it as a page-counted sequential
write.  After this patch, 16000 appends from the same cgroup are
charged 533264 usec (33us per append).

Also skip the cursor update for ZA bios: bi_sector is the zone
start, not the actual write position (which is only returned after
completion).  Setting the cursor from ZA would misclassify subsequent
READ/WRITE bios.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index abc512532ed9..d7860ec1ad49 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2557,6 +2557,17 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 		coef_randio	= ioc->params.lcoefs[LCOEF_WRANDIO];
 		coef_page	= ioc->params.lcoefs[LCOEF_WPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
+		/*
+		 * A zone append advances the zone write pointer and is
+		 * therefore sequential from the device's perspective, so
+		 * the cursor-based classification below doesn't apply.
+		 * Compute the full cost here.
+		 */
+		if (!is_merge)
+			cost += ioc->params.lcoefs[LCOEF_WSEQIO];
+		cost += pages * ioc->params.lcoefs[LCOEF_WPAGE];
+		goto out;
 	default:
 		goto out;
 	}
@@ -2717,7 +2728,9 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	if (!iocg_activate(iocg, &now))
 		return;
 
-	iocg->cursor = bio_end_sector(bio);
+	/* ZA bi_sector is zone start, not the write position */
+	if (bio_op(bio) != REQ_OP_ZONE_APPEND)
+		iocg->cursor = bio_end_sector(bio);
 	vtime = atomic64_read(&iocg->vtime);
 	cost = adjust_inuse_and_calc_cost(iocg, vtime, abs_cost, &now);
 
-- 
2.43.0

