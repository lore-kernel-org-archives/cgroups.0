Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2EF43DEA1
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 08:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548815; cv=none; b=L9VbOEzUQ07LlnUfSswQYaFkyw2YaBXBlgt5BUtVYY5H8DJnS65V2V+GLlvZxssVpu99sbvprUTadPrbhqFcAFW4m7TwEOumppcHsUGVe04Ty8vakcFJMB8lFRoZDKyk+H2lgdxh6NNYCG+YCpHqolhxrmdX8BrF1oygwxEb450=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548815; c=relaxed/simple;
	bh=loa/g3I+Yv/9naA0zXCKsZcRV0ZjLJKQ5OTetC/5DVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZI5owhNq2PatizMOOiim735NSxwHBJAQ7qJHP562J9fugI0XK5KvH63OEFkJgVyj1QJFTqBjuvP4wTxCx5aF5liVAyXyxDFCl5ZZDDIlr0VD0doREI4MfwbqwADtCggiyNJnU50WGBudlpBXJnRi7JZcou8lEDBeJ0+jZvkv44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BuiPTh5I; arc=none smtp.client-ip=91.218.175.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BuiPTh5I"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=loa/g3I+Yv/9naA0zXCKsZcRV0ZjLJKQ5OTetC/5DVw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789548806; v=1; x=1790153606;
 b=BuiPTh5I0jkUZb7q+SDPnksxAfJtDS9QplS6jrlObT9ZRyRG3SWNgjk7aaOIbQHTshtCwWlZ
 m1mxjceUwfDj0lj1PPGgpHoxKwJvofGaytDAwlgnVNojUAMlhGV98mQ5YZ9Ryat2BOMV5Gbqybj
 xpi0ZHb51mLDRn5N5NmGGVes=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id adf49a5116c396e5;
	Wed, 16 Sep 2026 08:53:26 +0000
X-Mizu-Trace-ID: adf49a5116c396e5
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
Subject: [PATCH v2 2/4] blk-iocost: charge zone appends as page-counted sequential writes
Date: Wed, 16 Sep 2026 16:53:02 +0800
Message-ID: <20260916085304.1080271-3-cui.tao@linux.dev>
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
 block/blk-iocost.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 082f26d6e27b6..2e4e9ce2c9359 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2560,6 +2560,17 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
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
@@ -2720,8 +2731,8 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	if (!iocg_activate(iocg, &now))
 		return;
 
-	/* dataless bios have no meaningful position for seq/rand detection */
-	if (bio->bi_iter.bi_size)
+	/* ZA bi_sector is zone start, dataless bios have no write position */
+	if (bio->bi_iter.bi_size && bio_op(bio) != REQ_OP_ZONE_APPEND)
 		iocg->cursor = bio_end_sector(bio);
 	vtime = atomic64_read(&iocg->vtime);
 	cost = adjust_inuse_and_calc_cost(iocg, vtime, abs_cost, &now);
-- 
2.43.0

