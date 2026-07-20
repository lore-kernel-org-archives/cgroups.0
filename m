Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4447F3D4117
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 09:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540270; cv=none; b=MN7hS9x/VlcjB7FDqOIekoHLmacSuVTVhjd9LjVBC8rHj7ekLClQmyWP0S8MAZFhUXs1XIqaqXOAGbh4ySvNNNQ762ABq9+cByf9e0l3S+m4LSKLhhXy1uBZXPep+cfiyXAlgROdtUM5cN9V4DarM8TUEB4P4JcIHvlEAdfPFWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540270; c=relaxed/simple;
	bh=HHHR2fCkjaL7OZ4yudrjiMX2vqSjKQ3OEyHXi0EHKog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYwriQ27VVqOlK2Hpv8ni4df+2tc3kKFSkfG5sugAOlwtATQFjiSBWEfIuIHu0HNxlwpepCXca8PtTRVhCkzQB7QXOYczhqjPRNHC09h4Kkvs6yOYjSMNrcZeH5Qv57fbU19/dmZbZ8ixAycG/fGQ+GGC1MYz6hsZNrNwyhhKig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OnToIPNA; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OnToIPNA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784540266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/PquVwhdyrMNc13NQQZsLRGO9rX2J1W8dm5bTzHHsNo=;
	b=OnToIPNAngCHRLWHE3PNKSwylR/6+6y/D46OdAv1WSyjg/oTl0xf+tHLT+6x7/M721DZ92
	6aOD0M4pX0VA1pK8dWMBrfiXsiuiZ+5xtU7Sy1MP1MUrAsZLDnHzK3YMGFVF+/12Drbp+Y
	WlsaObqhBL2h1eb8PeqpB61Ion17HDA=
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
Subject: [PATCH 1/4] block/blk-stat: drain per-cpu callback stats over possible CPUs
Date: Mon, 20 Jul 2026 17:37:23 +0800
Message-ID: <20260720093726.28965-2-cui.tao@linux.dev>
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

blk_stat_timer_fn() sums and resets a callback's per-cpu buckets using
for_each_online_cpu().  A CPU that goes offline with pending samples is
skipped, so its samples are neither accumulated into the window nor
cleared; they sit in the bucket until the CPU comes back online, at
which point the stale values are flushed into whatever window is then
running.

This silently corrupts the latency picture that consumers (notably
writeback throttling via wbt, and blk-mq latency tracking) base
decisions on around CPU hotplug: under-counting while the CPU is
offline, then a burst of stale data on re-online.

Fixes: 34dbad5d26e2 ("blk-stat: convert to callback-based statistics reporting")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-stat.c b/block/blk-stat.c
index de126e1ea5ac..d57c2fc6bf06 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -83,7 +83,7 @@ static void blk_stat_timer_fn(struct timer_list *t)
 	for (bucket = 0; bucket < cb->buckets; bucket++)
 		blk_rq_stat_init(&cb->stat[bucket]);
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct blk_rq_stat *cpu_stat;
 
 		cpu_stat = per_cpu_ptr(cb->cpu_stat, cpu);
-- 
2.43.0

