Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040A23947AA;
	Mon, 22 Jun 2026 08:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782118624; cv=none; b=m/pQCly2MpRm64uX3oz8XxnUsW6i2/ivzndzmIWj6bCVEbO+5h71+JvVXNkwxRoEWIAJJCj/uByvcnekXVLaY9eRmicfXdB1GtU4/h/g8DxqQ0nEOB3GpbaaNrvWqC0Jyy+ISNFhw6HAIngV3+Slv4hTyLXlrcAfqG0RT5KdwZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782118624; c=relaxed/simple;
	bh=IwiPtCiYJpzdkfUTpsvuA+UxXenUurPbutYjstOfze8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ofjCUY4ZX1+CqhQKCjbZLMg43Usm96NLbd3gXwX8qRX0bMTbut7X6LhHSUKxHFQY46AXNIGB3TBQtG/4gYpwnrZPY9i+QwfugU3w7jkVHaGGh0bzXV0VN2NG3elAmdAWisrGq+kQh2c+CVvsL9fkYBqdC4Mr6hBydIsoNc2gJzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Uss9UXhv; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Uss9UXhv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=WpHPY2uq5XeYoAgK1iV3XUY/BP7dASpo538j4VSIDmk=;
	b=Uss9UXhvkVOd/mwC2BLE8bdJvu8WjpctBFJAEHpuDy+mmS05btRPJe7F+fPonr
	7VI6CMy77NyJ7A6OuEyQBpQDb+cmvLfJvlqNgBq15mr8u+IamAm1HevfQZgoor16
	0fmfVv2mzK55uwG5hCbBXkFbJEMuiMv8oirQ5RaTVZ094=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3V0i5+DhqCisdFA--.60043S2;
	Mon, 22 Jun 2026 16:56:26 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH] block/cgroup: Drop stale -EBUSY retry from blkg_conf_prep()
Date: Mon, 22 Jun 2026 16:56:23 +0800
Message-Id: <20260622085623.520209-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3V0i5+DhqCisdFA--.60043S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Xr1ruFy8ur1rtF1xKr1rWFg_yoW8JryUpF
	47Jry3C3WSg3Z8uanxGF47W3W8Kayvkay5AFZxGa4Ykr1qyryIvF1Yy3Wvyr9YqF9FyF4j
	grWrZryYkr4j9a7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Ud5rsUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRoVpWo4+LooGgAA3J

Since commit 8f4236d9008b ("block: remove QUEUE_FLAG_BYPASS and
->bypass") nothing in the blkcg blkg lookup/creation path
returns -EBUSY anymore. blkg_conf_prep() nevertheless still
retries at fail_exit with msleep(10) and restart_syscall()
— logic added in 2012 when blk_queue_bypass() could
cause blkg lookup/creation to fail with -EBUSY while the queue was
temporarily bypassed during elevator changes.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 block/blk-cgroup.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3093c1c03902..259f2240e7df 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -919,16 +919,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
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

