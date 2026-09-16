Received: from mta0.migadu.com (out-208.mta0.migadu.com [91.218.175.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECAC481674
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 08:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548828; cv=none; b=UN49xp0bMES/rZ/3AUvcXnPPOPm/FykKN1fk4g484ekC/3gBLtFSuM+1gGGtLtlwvsfc8B/xAVdXAjPnCLwWa92YeIZ+tWilUL0JIwVzWbUs5uGfPSFyMpNqHiLxrjMD3jE3suK2tyr6FXNVA1+fQjb1NuBBD+kZ1DZTcnN54gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548828; c=relaxed/simple;
	bh=L3Cao1O+/S3bUdRzlg80CCgGlmroX8RaAQqh5IyZWk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiZpE1OsBCQswlpMEvUMZ7vYQG8Jawskn3NAMQkSJrswgFlxkuCFXLXQ6EUrgPqTnKSEa1IZxZJoYIlX/iadMGvz1C7Bg6rLx3WZmpvdnhQ4hCXre9tZYEFC0swfZKs8VNTrjOQbothmSKYF9YvXH+M92YIPDvPtzPmW/Ouk2EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dWtWWgCI; arc=none smtp.client-ip=91.218.175.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dWtWWgCI"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=L3Cao1O+/S3bUdRzlg80CCgGlmroX8RaAQqh5IyZWk4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789548816; v=1; x=1790153616;
 b=dWtWWgCINz5BryUE401GIE/naHiNICqAlIjc/7SVlZdrRYs4o/mP/J7lxA0SMvVi2iejLmEI
 pyPAdCB7vPDPebYXJLWnOJyDPDUvJiivN70Y00GsCG2G3dYTU1UlyVFfGBovsX1k7yVCoWvk4S0
 +nZoXr2ioaD9SWH7X2jIvohU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b436a119b2c988d9;
	Wed, 16 Sep 2026 08:53:36 +0000
X-Mizu-Trace-ID: b436a119b2c988d9
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
Subject: [PATCH v2 4/4] blk-iocost: fix stale comment in ioc_rqos_throttle()
Date: Wed, 16 Sep 2026 16:53:04 +0800
Message-ID: <20260916085304.1080271-5-cui.tao@linux.dev>
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
index ef1b7e65455e2..0a0821a080043 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2751,10 +2751,11 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 
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

