Received: from mta1.migadu.com (out-136.mta1.migadu.com [95.215.58.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5B035DA55
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 04:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790051969; cv=none; b=G1qZqWTgEkVaFFTz08y6HFR+o0uoO3ZNEW9+NOzmSB5Oiv7lmnFGcYTcQ98B1Na45oDzStyCBuGD96VaqyVwWjPGYi8j8UdVhwtj65iaLPeVAeBAxxeHlfvTvy1GhjxBIjfl7OW4bC83qElw8YtisM777vZBNWcgeguibh1oWus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790051969; c=relaxed/simple;
	bh=MTDgTZY1SVlOE7xli04ykLXBc+uQIoxK/6E0aXN7PRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGHD4I5aV6zviME4yYWxk98qUkB0bftEfzNGVUIUfRC3UoEhEzkwoKDBO5TKRChe2O3FyqLvqOOG9jeGdhQkZos77LOWX7HMVJVEmRVyEVQmq6m8pViQGqYXcEZFxYuDIjldCF7PoaaFlKRBD0kUFpfUtrBdyrkb4HVIb2qrJzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pvJBc6+3; arc=none smtp.client-ip=95.215.58.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pvJBc6+3"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MTDgTZY1SVlOE7xli04ykLXBc+uQIoxK/6E0aXN7PRI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790051961; v=1; x=1790656761;
 b=pvJBc6+3bWH0vSqN8CjKhZ0ykWIP3JGtu85yQOKgNFio2mdbHEGnpXFOGV8Y7zntHm6+8PUf
 z19j4ypirfYtKsfXWQLeg2NmymDZ2FJy7KNva6pOitAkz7QNW9ZmaucQlaIRbHY1/XNYNqiJqnt
 WHcOqJFcmBKq/bePhKmnetpA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f7e9b12a9d775cde;
	Tue, 22 Sep 2026 04:39:20 +0000
X-Mizu-Trace-ID: f7e9b12a9d775cde
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
Subject: [PATCH v4 2/4] blk-iocost: charge zone appends as writes
Date: Tue, 22 Sep 2026 12:38:54 +0800
Message-ID: <20260922043856.2020116-3-cui.tao@linux.dev>
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

Zone append is a primary write operation for zoned devices; zoned xfs
and btrfs use it for data writes.  It is priced at zero, so the zone
append portion of zoned workloads runs outside the controller: a
1%-weight cgroup issued 16000 appends at zero cost on a zoned null_blk.

Treat REQ_OP_ZONE_APPEND the same as REQ_OP_WRITE so it goes through
the existing seq/rand classification and charging.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 546458246cf9..6b262ccb6b32 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2557,6 +2557,7 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 		coef_randio	= ioc->params.lcoefs[LCOEF_RRANDIO];
 		coef_page	= ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		coef_seqio	= ioc->params.lcoefs[LCOEF_WSEQIO];
 		coef_randio	= ioc->params.lcoefs[LCOEF_WRANDIO];
-- 
2.43.0

