Received: from mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769342AD37
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 06:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788504881; cv=none; b=jr+ItFQwFmweuhBD4Mpiiwc7xoHjewNKw50Vbeep0GuQovVmc8FJgCRIDW3fnrwDImUmvFHk/+w9nMnTnt0KitOEGB3rFkILMTSxE5KPJO760MdZvOk3UYMt/hljaNmx6PMerFlWt7X8HyrogDHioZiouHv5RnWMcQ60xYlEiXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788504881; c=relaxed/simple;
	bh=l6+ZOUuNv8+XJsv/alaSTFr9NoikR4ZpDcuHcewyguI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mNjskxWG6j/3P+E2w5Z9vMtGLsRK5uFKfFO0XBnR7ZwxnOeLgTpLQO07Uk0V+M9pfSntnjsEhvRKR3+i0GRMjjoUQbbZqHOz8sSdqzRhVa93D7MZfO4paoF4EYd6p/G8aNED97vcrVpDO5uBT+7Hju4QhaoJPQ/BsXEhOsBKJ4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nIlwg9uc; arc=none smtp.client-ip=95.215.58.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nIlwg9uc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=l6+ZOUuNv8+XJsv/alaSTFr9NoikR4ZpDcuHcewyguI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788504876; v=1; x=1789109676;
 b=nIlwg9ucTchwNEzVP2A+VKjH9t+/WjzH1R5+izmXYoFiXbv5ugzOh6wT8Wvwsvt37k6hBWYH
 AUmiHu6vWc+vguuQicA2mctb2Po4yqNpvhRT8G3H3qSQbWYIY0EiYzJEdvuDGfCPw5kbC19dWiM
 rHomT4kxJF7T339+y//4j62w=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 74da6a6d0a4fe423;
	Fri, 04 Sep 2026 06:54:36 +0000
X-Mizu-Trace-ID: 74da6a6d0a4fe423
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>,
	Tang Yizhou <tangyeechou@gmail.com>
Cc: tj@kernel.org,
	josef@toxicpanda.com,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn,
	cui.tao@linux.dev
Subject: [PATCH v3] block/blk-iolatency: fix always-zero cur_stat mean on non-SSD
Date: Fri,  4 Sep 2026 14:54:26 +0800
Message-ID: <20260904065426.1281914-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

iolatency_check_latencies() accumulates the per-window latency stat
into iolat->cur_stat via latency_stat_sum(), which for non-SSD devices
calls blk_rq_stat_sum().  But blk_rq_stat_sum() is contracted on a raw
per-cpu src: it folds src->batch into the new mean.  By the time the
per-window stat reaches cur_stat it is already aggregated, with batch
left at 0.  Each window therefore contributes zero latency to
cur_stat->mean, which on non-SSD devices stays at 0; the
latency_sum_ok(&cur_stat) check that gates scaling up is always true,
so the scale-up hysteresis never engages.  SSD devices use the
percentile path and are unaffected.

Add latency_stat_merge(), which merges two already-aggregated stats by
their reconstructed totals (mean * nr_samples) instead of src->batch,
and use it only for the cur_stat accumulation; the earlier per-cpu sum
keeps latency_stat_sum(), whose src is still raw.

Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---
Changes in v3:
- Rebase onto current linux-next head (no code change).
- Verified with a two-kernel QEMU run (virtio-blk forced rotational,
  cgroup v2 io.latency target set below the achievable latency so the
  scale path runs every window): on the unpatched kernel cur_stat->mean
  stayed 0 across all windows while the per-window mean was 120-250us;
  with this patch cur_stat->mean tracked the per-window mean.

Changes in v2:
- Move the fix from blk-stat.c (blk_rq_stat_sum) into blk-iolatency.c,
  per Tang Yizhou's review: blk_rq_stat_sum() is contracted on a raw
  per-cpu src, so the aggregated-stat merge belongs in the iolatency
  caller, not the shared helper.

v1: https://lore.kernel.org/all/20260720133813.45150-1-cui.tao@linux.dev/
v2: https://lore.kernel.org/all/20260721030312.85655-1-cui.tao@linux.dev/
---
 block/blk-iolatency.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 2caa79a008ad..853608a4f187 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -216,6 +216,31 @@ static inline void latency_stat_sum(struct iolatency_grp *iolat,
 		blk_rq_stat_sum(&sum->rqs, &stat->rqs);
 }
 
+/*
+ * Merge an already-aggregated @stat into @sum by reconstructed totals
+ * (mean * nr_samples); blk_rq_stat_sum() reads src->batch, which is 0
+ * here. The overflow check also rejects the 0 samples case.
+ */
+static inline void latency_stat_merge(struct iolatency_grp *iolat,
+				      struct latency_stat *sum,
+				      struct latency_stat *stat)
+{
+	if (iolat->ssd) {
+		sum->ps.total += stat->ps.total;
+		sum->ps.missed += stat->ps.missed;
+	} else {
+		if (sum->rqs.nr_samples + stat->rqs.nr_samples <=
+		    sum->rqs.nr_samples)
+			return;
+		sum->rqs.mean = div_u64(sum->rqs.mean * sum->rqs.nr_samples +
+					stat->rqs.mean * stat->rqs.nr_samples,
+					sum->rqs.nr_samples + stat->rqs.nr_samples);
+		sum->rqs.min = min(sum->rqs.min, stat->rqs.min);
+		sum->rqs.max = max(sum->rqs.max, stat->rqs.max);
+		sum->rqs.nr_samples += stat->rqs.nr_samples;
+	}
+}
+
 static inline void latency_stat_record_time(struct iolatency_grp *iolat,
 					    u64 req_time)
 {
@@ -547,7 +572,7 @@ static void iolatency_check_latencies(struct iolatency_grp *iolat, u64 now)
 	/* Somebody beat us to the punch, just bail. */
 	spin_lock_irqsave(&lat_info->lock, flags);
 
-	latency_stat_sum(iolat, &iolat->cur_stat, &stat);
+	latency_stat_merge(iolat, &iolat->cur_stat, &stat);
 	lat_info->nr_samples -= iolat->nr_samples;
 	lat_info->nr_samples += latency_stat_samples(iolat, &iolat->cur_stat);
 	iolat->nr_samples = latency_stat_samples(iolat, &iolat->cur_stat);
-- 
2.43.0
