Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592083D6682
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 09:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540282; cv=none; b=FsQNYiODDngWJxAQg3wUWJd49HATjr4/8kyeUAQYkrL4AgZUKWbdKb391+/Gfi80IYkzpa5K5Ev1plpfwDtw6fjbOpH37jGd8FplvoVJ/l2K1DfpBlnPAbbX288e2sTmManvy17NcbP6QMb7DYjKnScH5DNrS6vZO9X5Ezv1AQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540282; c=relaxed/simple;
	bh=lRK9/1L4NjYyQwus96ziJ6sziwXOvt9QhqWN+ul9A8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uz1VCXBKHvrckypTHpSB0HoTYKOwcrpaSL9gclD/H9SWptAMYH6wsL00xW9CdR3c6/jHf5i1E0Vb7axUBQTqR2mTS/BCjytWAECRMK81xZI2SUGm4IVdS3IJAU1mJ90W5BKG2WMh0hZvTq1ycY8Ziq0aH3Z7eVlk7Yg12Co+czs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wIMEz7HT; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wIMEz7HT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784540279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XYcX65iGs0S1tfl7tVIHoz6s0aK6dAZv4VVFdKfUgcM=;
	b=wIMEz7HTeFD0sssquAStjhvKa3/ZwUSxtYL3nTUnU/SyHeaxzcHiD/0rAr69jgtn+sm4xR
	xazaZtHKmaRr8+Ox81ciVztNpxgfAMA2eNGhwNIMi+oA2RerzLt/VOrCCdpTb3HAh1mpOD
	BoyRkYwgMaDPmSZTMych53Bgdcq1mzU=
From: Tao Cui <cui.tao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Omar Sandoval <osandov@fb.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Yu Kuai <yukuai@fygo.io>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH 3/4] block/blk-iocost: collect per-cpu latency stats over possible CPUs
Date: Mon, 20 Jul 2026 17:37:25 +0800
Message-ID: <20260720093726.28965-4-cui.tao@linux.dev>
In-Reply-To: <20260720093726.28965-1-cui.tao@linux.dev>
References: <20260720093726.28965-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

ioc_lat_stat() walks ioc->pcpu_stat with for_each_online_cpu() to
compute missed-ppm and rq_wait deltas.  An offlined CPU is skipped, so
its delta is dropped from the period and its last_* watermark is not
advanced; on re-online the next collection sees a delta spanning the
whole offline interval, corrupting the latency/vrate picture.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 8b2aeba2e1e3..b60625613e09 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1592,7 +1592,7 @@ static void ioc_lat_stat(struct ioc *ioc, u32 *missed_ppm_ar, u32 *rq_wait_pct_p
 	u64 rq_wait_ns = 0;
 	int cpu, rw;
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct ioc_pcpu_stat *stat = per_cpu_ptr(ioc->pcpu_stat, cpu);
 		u64 this_rq_wait_ns;
 
-- 
2.43.0

