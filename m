Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF563EB107
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 05:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785822106; cv=none; b=gayzP0asv44eiycW2yO8TpAEwtYwwps/eXheQFtqM+XyNSFwwZIyQiVP/TEVWQR91ju0S7xWwRRWw0Zw6+AHtqBi+eo7Ws83MtB/7IW4H7xQ1VPx6OFUDPpHU62sRGHlP5/Ht8Hlbkor0I9ns1KDdQNhwe+GL/OneJCxTd5rFyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785822106; c=relaxed/simple;
	bh=9LfKyQfrbGnA2ELgqEBoSZcMckFFI0+09wJSO6E/B9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BxVfPH1ZG1h141AMs7wGlmi+CFhaoxPX/60iSDU54VacDqIvrSrxKTUqQ1fKAsv0GfkKuLlET67rRz3PoDI6JLW2SiTdeoejfZLg2Buo0uNZe6R3ZYXWqAfHItO0SuAqdiisTfaeAzVhdRbuplnPvAS1U7somsl8lc/Roan3p+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HU/+EQi3; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HU/+EQi3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785822100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iNnbESC5ApGqSzB0x27jNNkxmlJXxLOjT5/nbE6X/uk=;
	b=HU/+EQi3HpiA0xdE29JFezOpR4HA7LcB8xPJbkD6rojriNjV12SDGmJVN/dTSHpnnzAf/4
	DhRlIUbMFn6nlhHjvsewDk9U9QSqZrXmzsHtgB26gHK1J9b9As8fDyMEcby9Oipj0OZQW0
	JBnETCVxzLu5h2lWsFhOj4wCkOY/M14=
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	axboe@kernel.dk
Cc: josef@toxicpanda.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v3] block/blk-iocost: annotate ioc_pd_stat reads with data_race()
Date: Tue,  4 Aug 2026 13:41:20 +0800
Message-ID: <20260804054120.161933-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

ioc_pd_stat() reads ioc->enabled, ioc->vtime_base_rate, and
iocg->last_stat without holding ioc->lock, which trips KCSAN since
ioc_adjust_base_vrate() and iocg_flush_stat_upward() write those
fields under ioc->lock.

Commit 35198e323001 fixed the same issue in ioc_qos_prfill() and
ioc_cost_model_prfill() by adding spin_lock_irq(&ioc->lock).  However,
those functions read configuration parameters (qos/model) that need
synchronized reads.  In contrast, ioc_pd_stat() only reads stat
values (vrate, usage) where stale reads are harmless, so data_race()
is more appropriate — it silences the KCSAN warning without adding
lock contention during high-frequency stat reads.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---

Changes in v3:
- Use data_race() instead of spin_lock_irqsave/irqrestore, since
  these are stat values that don't require synchronized reads — the
  goal is just to silence KCSAN, not to guarantee consistency.
  (Tejun Heo)

Changes in v2:
- Use spin_lock_irqsave/irqrestore instead of spin_lock_irq/irq,
  since the caller (blkcg_print_stat) may already have IRQs disabled.

Link: https://lore.kernel.org/all/20260802150913.31977-1-cui.tao@linux.dev/
---
 block/blk-iocost.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 8b2aeba2e1e3..bc47ed034b25 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3093,23 +3093,23 @@ static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
 	struct ioc_gq *iocg = pd_to_iocg(pd);
 	struct ioc *ioc = iocg->ioc;
 
-	if (!ioc->enabled)
+	if (!data_race(ioc->enabled))
 		return;
 
 	if (iocg->level == 0) {
 		unsigned vp10k = DIV64_U64_ROUND_CLOSEST(
-			ioc->vtime_base_rate * 10000,
+			data_race(ioc->vtime_base_rate) * 10000,
 			VTIME_PER_USEC);
 		seq_printf(s, " cost.vrate=%u.%02u", vp10k / 100, vp10k % 100);
 	}
 
-	seq_printf(s, " cost.usage=%llu", iocg->last_stat.usage_us);
+	seq_printf(s, " cost.usage=%llu", data_race(iocg->last_stat.usage_us));
 
 	if (blkcg_debug_stats)
 		seq_printf(s, " cost.wait=%llu cost.indebt=%llu cost.indelay=%llu",
-			iocg->last_stat.wait_us,
-			iocg->last_stat.indebt_us,
-			iocg->last_stat.indelay_us);
+			data_race(iocg->last_stat.wait_us),
+			data_race(iocg->last_stat.indebt_us),
+			data_race(iocg->last_stat.indelay_us));
 }
 
 static u64 ioc_weight_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
-- 
2.43.0

