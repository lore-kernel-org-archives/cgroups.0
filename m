Received: from wxsgout04.xfusion.com (wxsgout03.xfusion.com [36.139.52.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306CF5CDF1;
	Sun, 28 Dec 2025 13:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=36.139.52.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766928038; cv=none; b=i/lb9/qzCzH5guYvr3QCM46hz2YAC7eQzpDKMP4yLe2SCUkc+kfERqZl6E63TSquPdJvA3+evdKICJTY2XLyOfHpT+3yVFxgWCJDRNq4yXuWGhkASNuzRXAO+AZfOTT99RK8CWk3kRmNFNGDbP9o6oZC3rSfc7NMW9x8tdoj5KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766928038; c=relaxed/simple;
	bh=w4RNxWHCUqFL/L2DzHQb4YxOGTGp2O/u2ZH/OwjQw4Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qla03OyFNbg72pAMPTu4p9EYF7GxbSTtGItHplHSTic6KGwmRB7D5OxD3t49if2rwpCFT0Xr8bWwID+iGmTLO5HW2SlpaVDZhqNTt8aX2e2TLSgX6js0nj+mRS4bNLyosEAmVuZ+kkES1ywR1RzVMTuJ2IJeDNo83CLa59IWtC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xfusion.com; spf=pass smtp.mailfrom=xfusion.com; arc=none smtp.client-ip=36.139.52.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xfusion.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xfusion.com
Received: from wuxpheds03048.xfusion.com (unknown [10.32.143.30])
	by wxsgout04.xfusion.com (SkyGuard) with ESMTPS id 4dfKK241ZGzBBx5y;
	Sun, 28 Dec 2025 21:03:02 +0800 (CST)
Received: from DESKTOP-Q8I2N5U.xfusion.com (10.82.130.100) by
 wuxpheds03048.xfusion.com (10.32.143.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_RSA_WITH_AES_128_CBC_SHA256) id 15.2.2562.20;
 Sun, 28 Dec 2025 21:04:41 +0800
From: shechenglong <shechenglong@xfusion.com>
To: <yukuai@fnnas.com>, <axboe@kernel.dk>
CC: <cgroups@vger.kernel.org>, <chenjialong@xfusion.com>,
	<josef@toxicpanda.com>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stone.xulei@xfusion.com>, <tj@kernel.org>,
	shechenglong <shechenglong@xfusion.com>
Subject: [PATCH v2 1/1] block,bfq: fix aux stat accumulation destination
Date: Sun, 28 Dec 2025 21:04:26 +0800
Message-ID: <20251228130426.1338-2-shechenglong@xfusion.com>
X-Mailer: git-send-email 2.37.1.windows.1
In-Reply-To: <20251228130426.1338-1-shechenglong@xfusion.com>
References: <71df89fb-1766-40d5-8dd5-5d0c6f49519e@fnnas.com>
 <20251228130426.1338-1-shechenglong@xfusion.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: wuxpheds03045.xfusion.com (10.32.131.99) To
 wuxpheds03048.xfusion.com (10.32.143.30)

Route bfqg_stats_add_aux() time accumulation into the destination
stats object instead of the source, aligning with other stat fields.

Reviewed-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: shechenglong <shechenglong@xfusion.com>
---
 block/bfq-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 9fb9f3533150..6a75fe1c7a5c 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -380,7 +380,7 @@ static void bfqg_stats_add_aux(struct bfqg_stats *to, struct bfqg_stats *from)
 	blkg_rwstat_add_aux(&to->merged, &from->merged);
 	blkg_rwstat_add_aux(&to->service_time, &from->service_time);
 	blkg_rwstat_add_aux(&to->wait_time, &from->wait_time);
-	bfq_stat_add_aux(&from->time, &from->time);
+	bfq_stat_add_aux(&to->time, &from->time);
 	bfq_stat_add_aux(&to->avg_queue_size_sum, &from->avg_queue_size_sum);
 	bfq_stat_add_aux(&to->avg_queue_size_samples,
 			  &from->avg_queue_size_samples);
-- 
2.43.0

