Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99013E0C67
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 07:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784273694; cv=none; b=A4kKzVv4q+kmQfqLYSWG8FYrcPn1liTbbjvFegK0WKOxiwTyHHUZltiSTu0UcoElcdlofF4/V6olGwRYjG/2g5Zoo77+QPNsKngOE/HLuyfZQaDvQWyGk9kKESyMiRe6AjYK8j6aVoGq5JaKAa3UPO1Y/bDmRTnF8r4M5bDtg1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784273694; c=relaxed/simple;
	bh=1O+IXvP93QsnmDB8PqUpWiogGfVIwPW4GTxLt8ZihnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HqDc51564o1taA3jvGLT9/NrT3zKDSUObylvwAOhzsa42yLn5BofddlgwpCFzEWg7JRe7aT9ngaI0fFV2HyeApxSad7WkaIAHRoFQ6A+b6Ge0qkogcnRj7+VOWe9hmRW9V9OQRyHfv824l3C20U5pDURQpROgj34i7f3ttCf1Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r61lbZ0X; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r61lbZ0X"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784273679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jz5gdCxdTYoQx8thAzRBdvWMUXnwkLzSp+1+Ty8D73s=;
	b=r61lbZ0XdIH8b/KNPRmCTydABaO+nqeNFvLdMqOeR6HvHTU3dGWXXA5Yy8027way4m5AsF
	hvTSvL+s0d3vk6xK8WmjAzIQd8Nx2qPWOsTWw92GEIgddMaMl7ORliSX3l3l4BYPoRYb8N
	T2hhQs/7z30MLhCaDct0wG4yXeTtgsc=
From: Tao Cui <cui.tao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v2] blk-iolatency: use guard(spinlock_irqsave)() in iolatency_clear_scaling()
Date: Fri, 17 Jul 2026 15:34:21 +0800
Message-ID: <20260717073421.2039722-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

child_lat.lock is acquired with irqsave semantics in both
iolatency_check_latencies() (called from the blkcg_iolatency_done_bio()
softirq path) and blkiolatency_timer_fn() (timer softirq).
iolatency_clear_scaling() instead uses a plain spin_lock(), which only
happens to be safe because both of its callers enter with interrupts
already disabled:

  * iolatency_set_limit() runs under queue_lock via blkg_conf_prep(),
    which returns with the lock held and interrupts disabled;
  * iolatency_pd_offline() runs under queue_lock from blkg_destroy() and
    blkcg_deactivate_policy(), both of which take it with spin_lock_irq().

Take the lock with guard(spinlock_irqsave)() so the locking is
self-contained and consistent with the other two sites, instead of
relying on an undocumented caller precondition. No functional change.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---

Changes in v2:
- use guard(spinlock_irqsave)() (suggested by Leon Hwang)

---
 block/blk-iolatency.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index cef02b6c5fa9..1cc33aa0b669 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -815,12 +815,11 @@ static void iolatency_clear_scaling(struct blkcg_gq *blkg)
 			return;
 
 		lat_info = &iolat->child_lat;
-		spin_lock(&lat_info->lock);
+		guard(spinlock_irqsave)(&lat_info->lock);
 		atomic_set(&lat_info->scale_cookie, DEFAULT_SCALE_COOKIE);
 		lat_info->last_scale_event = 0;
 		lat_info->scale_grp = NULL;
 		lat_info->scale_lat = 0;
-		spin_unlock(&lat_info->lock);
 	}
 }
 
-- 
2.43.0

