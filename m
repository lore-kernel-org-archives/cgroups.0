Received: from mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3E52BD587
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 02:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788834139; cv=none; b=FbkBjMmlBQvDM7f4Mv6/XSwajbv0SCFSO9pGfq8DbgILsPbzt9sCRXTZsRl/RvbuIDw/Uy1SWbCEOqpTfG+iRB2NQBTqn8+BTZF9Ua2ud4u4GJzXBro0OC5m/LTQ1z1m7hyVUoVooz0ekRxu0YtAytcHZO2Tyytk2xwfQE5HMkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788834139; c=relaxed/simple;
	bh=+7oq5uHuVPJK5uMrOqgMV+yf3ES7m8PcHA7y3Qbu4dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1LoUg5oprgM1pcfML68HXb6zf95LSicxQndzugfWCXfTLFbQW0bhxLISVndh/d0aRoaC6rOFDW+oQbGL3Ug+CWFengFiKQoRV3ubAqe/RvS3HZivxLxy/u7iS82jC1SRZf3PhGlW8yoqZXKVyCKLdaLf9DpwegvlRUOPI0G/d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P/lqw/N7; arc=none smtp.client-ip=95.215.58.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P/lqw/N7"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+7oq5uHuVPJK5uMrOqgMV+yf3ES7m8PcHA7y3Qbu4dE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788834136; v=1; x=1789438936;
 b=P/lqw/N7j0aWooYPjS7rPW+wSoy5Vt9LfK8KFKwKaTvvZmYB0ES1WKc5Wodho95RP+MC4bvD
 f+wep+UfizPMF2G2zC7QRvrnyqiZX8NxtizoLhmmgHW6lPCn7HQzk2ZOWv4zYcCyfzr3jWozgDy
 nmqwqWswS7dta+XPphf5OLQE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a39043acaf6914aa;
	Tue, 08 Sep 2026 02:22:16 +0000
X-Mizu-Trace-ID: a39043acaf6914aa
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
Subject: [PATCH 4/4] blk-iocost: fix stale comment in ioc_rqos_throttle()
Date: Tue,  8 Sep 2026 10:21:35 +0800
Message-ID: <20260908022135.1429281-5-cui.tao@linux.dev>
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

The comment says that priority-inversion IOs are "punted to
@ioc->aux_iocg", but no aux_iocg field ever existed in struct ioc.
The comment was introduced already stale by commit da437b95db83
("blk-iocost: grab ioc->lock for debt handling").  Update it to
describe the current use_debt / iocg->abs_vdebt mechanism.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 1bf622e39ce4..f99c4f5c83fd 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2748,10 +2748,11 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 
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

