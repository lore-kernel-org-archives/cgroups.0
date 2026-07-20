Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8403D5647
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 09:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540277; cv=none; b=tPY71QvX1BONS9WmiJTzvJ6heEeVoKNjDP40/BGnfSbmaUznfPTkOmEQsQVndcnht2WImmVpObQ78p1HVlL+f3YwFR9k7ApGl4hHMTsVHV3M7zuw72jQT6GV0xWIlOYgnOa6Q7vOz040EMJZe5hhHEqdVojwy/uqjEzmKL9Rs7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540277; c=relaxed/simple;
	bh=SLoaC+4K/Aj0nLpdx60Po9LvLU4QZwA8uDgtvsM4m94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaPRnlQqsqpSykthyiW2g0PdkixBYOk1d5efPKO4Fw0ExiV53Eg26zN7QqISmnl6sMtogjeEXA5P0R1lLn8P8VZqSyuo8G9hFUCmpH2xUdWuOME7b/mL/C6ZZ9blcRdpKtkiBLcu8HwRmY3sFPyhPDiG4x2kk11YhEibGhDaIRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZmH+rWf5; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZmH+rWf5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784540273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t10s5HeuWcsqSvUkdc4XvpT/zR0qAKN1Grpg4N+I0L4=;
	b=ZmH+rWf5ydqM9qKt5JqfN0DLMMnvdABO0vEbGn1FVRFLkGNTE7ZFGSsnGPGAXofijvZIRx
	jzXtkVxRM22BA2yp0s89ffOvmAyyuVTJXco6pC4nT9C4PXmDyzYqMxFRIvv7e1PQ7tQwh9
	t133sYgURD3M+9bxFxlf5Tu+0HhSUkc=
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
Subject: [PATCH 2/4] block/blk-iolatency: account per-cpu latency stats over possible CPUs
Date: Mon, 20 Jul 2026 17:37:24 +0800
Message-ID: <20260720093726.28965-3-cui.tao@linux.dev>
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

iolatency_check_latencies() and iolatency_ssd_stat() iterate a blkg's
per-cpu latency stats with for_each_online_cpu().  When a CPU that has
accumulated io.latency samples goes offline, its bucket is skipped: the
check loop (which also resets) neither sums nor clears it, and the show
path under-reports.  On re-online the stranded samples are flushed into
a later check window, which can trigger a spurious throttle/scale
adjustment.

Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Fixes: 1fa2840e56f9 ("blk-iolatency: use a percentile approache for ssd's")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iolatency.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 1cc33aa0b669..d6c401d6174c 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -523,7 +523,7 @@ static void iolatency_check_latencies(struct iolatency_grp *iolat, u64 now)
 
 	latency_stat_init(iolat, &stat);
 	preempt_disable();
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct latency_stat *s;
 		s = per_cpu_ptr(iolat->stats, cpu);
 		latency_stat_sum(iolat, &stat, s);
@@ -924,7 +924,7 @@ static void iolatency_ssd_stat(struct iolatency_grp *iolat, struct seq_file *s)
 
 	latency_stat_init(iolat, &stat);
 	preempt_disable();
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct latency_stat *s;
 		s = per_cpu_ptr(iolat->stats, cpu);
 		latency_stat_sum(iolat, &stat, s);
-- 
2.43.0

