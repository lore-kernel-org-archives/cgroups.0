Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52D0327BEC
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 04:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784261247; cv=none; b=R+Ay83oSu2bWrFNKAJGNmn9fOfvLb4YE5+lhdXzjBL0g+/5awwS1WVbBvMyb6vkBfYS6WioUH4R0Bp3ZF/kMoMcGUCB/xHXdFyYF9RsQK3uqkNLP5uSxEWK4fy3/8W6G3lId9YSE+PLd2Tc2gzULsS7E0gTjBnaYDwiRaFKSv7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784261247; c=relaxed/simple;
	bh=CE2mrwIxUFCp242j0hb1GsQiMWFiRqOGHd4mM3R37Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZPRyOzOgFmdqiZ2oHcmn4uKYBIDMA5acR6U8CoBI6bKIsPwMvZmfVR97cOmEEvy5b5/ct4uZkR+qIbwewRXVxVL/WGBjCmmne7rQ1e/u4iUHC76f2BLr3lU+tHBaCfjqiZC/yrd/ysiTtNyXhQU0lcgFvCbsufjjoZqLvDdFuHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CpkG8NX6; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CpkG8NX6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784261232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SK1L/6dGOgAAA5jjj79H5VPkpf29CnzE1f50qRIaoOk=;
	b=CpkG8NX6+88cAmYCv/jcivqOPTkusXUQKXhgtXwZDz/AbVSSR50rXVr+GlTDlIQt5m+m4J
	4Nu+18O12CthAK8gGaKAQxFMcW3Y+u3IGgJzHVrCNYI+2sfnKQYJI6LYQ57K7/+TTDA7NW
	0cmszYSi/dml3vWw4p5mt86gFFG+gYg=
From: Tao Cui <cui.tao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn,
	cui.tao@linux.dev
Subject: [PATCH] blk-iolatency: use spin_lock_irqsave() in iolatency_clear_scaling()
Date: Fri, 17 Jul 2026 12:06:53 +0800
Message-ID: <20260717040653.1999364-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

child_lat.lock is acquired with spin_lock_irqsave() in both
iolatency_check_latencies() (called from the blkcg_iolatency_done_bio()
softirq path) and blkiolatency_timer_fn() (timer softirq).
iolatency_clear_scaling() instead uses a plain spin_lock(), which only
happens to be safe because both of its callers enter with interrupts
already disabled:

  * iolatency_set_limit() runs under queue_lock via blkg_conf_prep(),
    which returns with the lock held and interrupts disabled;
  * iolatency_pd_offline() runs under queue_lock from blkg_destroy() and
    blkcg_deactivate_policy(), both of which take it with spin_lock_irq().

Take the lock with spin_lock_irqsave()/spin_unlock_irqrestore() so the
locking is self-contained and consistent with the other two sites, instead
of relying on an undocumented caller precondition. No functional change.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iolatency.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index cef02b6c5fa9..68b74258cd95 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -811,16 +811,17 @@ static void iolatency_clear_scaling(struct blkcg_gq *blkg)
 	if (blkg->parent) {
 		struct iolatency_grp *iolat = blkg_to_lat(blkg->parent);
 		struct child_latency_info *lat_info;
+		unsigned long flags;
 		if (!iolat)
 			return;
 
 		lat_info = &iolat->child_lat;
-		spin_lock(&lat_info->lock);
+		spin_lock_irqsave(&lat_info->lock, flags);
 		atomic_set(&lat_info->scale_cookie, DEFAULT_SCALE_COOKIE);
 		lat_info->last_scale_event = 0;
 		lat_info->scale_grp = NULL;
 		lat_info->scale_lat = 0;
-		spin_unlock(&lat_info->lock);
+		spin_unlock_irqrestore(&lat_info->lock, flags);
 	}
 }
 
-- 
2.43.0

