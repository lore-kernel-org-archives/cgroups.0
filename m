Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522262D7DC6
	for <cgroups@vger.kernel.org>; Mon,  3 Aug 2026 13:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763409; cv=none; b=pzrF8QLblD+BLphbc3pBYBPfdXa/QcR9stz7zG9jGk/8BqLTZe7cxAHpyNMoQC4s7Z5YSogHSKnnH2uSDWQr5kFyjiXlFSfBYEMeSvTYGbnXc0iNlVr3TX0qC2SJqQUpUQCOvh/BBtV0V4Rrap5QuxV1LT6CVZXO4ny0b4YpUw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763409; c=relaxed/simple;
	bh=4TifdGrM2lPzZZSaB7gyNJ2RjECg/Y5R6GYrmtS7A0o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZIe4Kpi0h5KI5GL8vZg8cWO7wFIaCEJPrGNq8viIStVnEqwGpU4tpE+Vgh4TPAcEr1YlVrehsVT+kgcYcAyDrSxXIpiEQ4XTfCkVES5PuDpJ5UCvflpL0LIPXFmj5buuGHW65uOGbrlV9OEpCSDQGm5ONN6TCq5bsqUpvPM3OtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WsIuXEO5; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WsIuXEO5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785763392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1Z6AyQ2KOZbY7mLbJsWE1530GOZ+DUboBcWO1nWJZ/o=;
	b=WsIuXEO5k0AMCXTJCI6V2UBaOv2m24Mgyf8rSuJK4lzzelE4uDYIJKZemrGPi9iXc/WD39
	xnKYDISUpgxqi7/pMwvZWaHitTBR44Aamr/CYEj5SHr8LNf+Ur+rIYFyCIV3kyEsHdqMPn
	Av5st4fGy3jevAM9HMaYzYBLlaiIaAs=
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	axboe@kernel.dk
Cc: josef@toxicpanda.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v2] block/blk-iocost: read ioc_pd_stat params inside ioc->lock
Date: Mon,  3 Aug 2026 21:22:01 +0800
Message-ID: <20260803132201.135355-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

ioc_pd_stat() reads ioc->enabled, ioc->vtime_base_rate, and
iocg->last_stat without holding ioc->lock, which trips KCSAN since
ioc_adjust_base_vrate() and iocg_flush_stat_upward() write those
fields under ioc->lock.

Commit 35198e323001 ("blk-iocost: read params inside lock in sysfs
apis") fixed the same issue in ioc_qos_prfill() and
ioc_cost_model_prfill(), but ioc_pd_stat() was missed.

Add spin_lock_irqsave/irqrestore(&ioc->lock) around the reads.
Use irqsave/irqrestore instead of the irq variant used by
ioc_qos_prfill() because ioc_pd_stat() is called from
blkcg_print_stat() which already disables IRQs via
guard(spinlock_irq)(&blkcg->lock); an unconditional spin_unlock_irq
would wrongly re-enable them.

Fixes: 35198e323001 ("blk-iocost: read params inside lock in sysfs apis")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---

Changes in v2:
- Use spin_lock_irqsave/irqrestore instead of spin_lock_irq/irq,
  since the caller (blkcg_print_stat) may already have IRQs disabled.
  (Sashiko review)

Link: https://lore.kernel.org/all/20260802150913.31977-1-cui.tao@linux.dev/
---
 block/blk-iocost.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 8b2aeba2e1e3..977fe9ecff69 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3092,9 +3092,12 @@ static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
 	struct ioc *ioc = iocg->ioc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->lock, flags);
 
 	if (!ioc->enabled)
-		return;
+		goto out;
 
 	if (iocg->level == 0) {
 		unsigned vp10k = DIV64_U64_ROUND_CLOSEST(
@@ -3110,6 +3113,8 @@ static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
 			iocg->last_stat.wait_us,
 			iocg->last_stat.indebt_us,
 			iocg->last_stat.indelay_us);
+out:
+	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 
 static u64 ioc_weight_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
-- 
2.43.0

