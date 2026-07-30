Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835BE3D093E;
	Thu, 30 Jul 2026 07:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397366; cv=none; b=lDIJQrJeJ2vEavSZv5kr6mswKDZnznqT3WuhZWm2R/677aJ5NpymVjtuNszQM7LlDDFxWY11utloRaBLE04siljb110wU6KG9HKVJCGpMSsw8gJqMUvs8PNm0PH54QIuoGfvbXeQkKI662z1i3/dK39f2d/Jx9VLFGhSxhNIpFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397366; c=relaxed/simple;
	bh=LfVssSPLu41pmxjNa97dwR6I0RB4AYUgYUHqJ+vGL9E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MS6S3G1FeDAUNRTdYEXdELMMtvRGjZ0SvsWklWA10qIW2JMpUdkq3oprf99yTXQ0cUj3QglTkptVXR+iw1YDmcQ74WbuiZOZVs1yt/iU3lWwqpx7h4o99zOi5OJKJx/xQIszptPfQe9DdctVeRe7zGbKu1MoWyskW61TFnoNas0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ejfYby4V; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ejfYby4V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=KS
	Heja0y0iYQH1F6ijinsPXTJ1F7zsG9HIKqwBvJ5DE=; b=ejfYby4Vh3A1+oRSRM
	4zYcfWkVulW1sSzHV/LBaWdcXf/u1C65EuXIzQykd7gnldvNx3zmBpBS3sTZU6Xi
	vhnBD7AYfPqg0A6ssUw6OtJTOooDHcWrxR+lVLaZhpH9QDC812omV1NNyrvfZqUE
	sUB+2EgRWvHUQGW+8PwqHh6PE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDXZZG9_2pqU6MsMw--.51474S2;
	Thu, 30 Jul 2026 15:39:42 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	cuitao@kylinos.cn,
	yizhou.tang@shopee.com,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v2] block/cgroup: Drop stale -EBUSY retry from blkg_conf_prep()
Date: Thu, 30 Jul 2026 15:39:39 +0800
Message-Id: <20260730073939.1878598-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXZZG9_2pqU6MsMw--.51474S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJr47WrWxKw1UXrWfGF1rJFb_yoW8AF4fpF
	srCayfGFW5KF1DCFsru3W29wn2qa1DXry5JFZxWa4Ykr9Fyrn2vr4vyw1ktrnYvrZF9F4Y
	qrW3ZrZYkr4j9aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UG0PDUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwQBl9Wpq-8ApfQAA36

Drop the unreachable -EBUSY retry in blkg_conf_prep().

Commit e56da7e28796 ("blkcg: don't allow or retain configuration of
missing devices") added an msleep()/restart_syscall() retry for
temporary queue bypass. After commit 8f4236d9008b ("block: remove
QUEUE_FLAG_BYPASS and ->bypass"), nothing returns -EBUSY here
anymore. Remove the dead code and the unused linux/delay.h include.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>
---
Changes in v2:
- Mention e56da7e28796 instead of vague "logic added in 2012"
- Also drop unused #include <linux/delay.h>

v1: https://lore.kernel.org/linux-block/20260622085623.520209-1-yangxiuwei@kylinos.cn/

 block/blk-cgroup.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d9676126c5b5..682faa486354 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -23,7 +23,6 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/slab.h>
-#include <linux/delay.h>
 #include <linux/wait_bit.h>
 #include <linux/atomic.h>
 #include <linux/ctype.h>
@@ -917,16 +916,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	spin_unlock_irq(&q->queue_lock);
 fail_exit:
 	mutex_unlock(&q->blkcg_mutex);
-	/*
-	 * If queue was bypassing, we should retry.  Do so after a
-	 * short msleep().  It isn't strictly necessary but queue
-	 * can be bypassing for some time and it's always nice to
-	 * avoid busy looping.
-	 */
-	if (ret == -EBUSY) {
-		msleep(10);
-		ret = restart_syscall();
-	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blkg_conf_prep);
-- 
2.25.1

