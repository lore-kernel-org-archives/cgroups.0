Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA7D3D45D4
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 09:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540288; cv=none; b=EakqpuVIsPaJhb2U0yKt67QnApGkdBiYWAvrsYsQhwI876iuth5sAQQTfY/RuD/Motb7/i+UQDmVoIDe5v0QVQKS0iIu0d1cDwwJZIh9UlBZ+M6+/u6NQ8kpHwIFIJd6ub+koEiEc5LE6wuxfEOJ3n/jjbSGa7om3xEHKHBCv6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540288; c=relaxed/simple;
	bh=CwcS1rpDH9/zVMo1p/kk3iMOwfOYQpuysnAULIMw0Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uutA7340YlBrIb/BRLsmylzeBl9/woW68uc+leT8Yrq0jryKk5Nee5Ytbbajd1nIMdeccD4vIjVjvuA7ZH3LGhpRbe+9inHtlhfnQvvtBq+mAKtJYp+BcDzoNpWE3m/XArUtxj0tKEC/Dyva4fcfdkXAhLRdYF1FhuzucBJe+6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oFe+Y33Q; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oFe+Y33Q"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784540284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iu062VwjFJmKb1NYwQO4WuL9MAqm4vzNE/XIfYy4xek=;
	b=oFe+Y33QSRXyYWUXCA7Oc6uCw1WlmHDohQcWnNoGA/iV2IJN243vtB/Lo49nx5vTumTfBr
	Kov2ZXHu5FsqFC6x6+865QYbCOfWTDW8x/bHBE3SfSq3jZAlgHJHvx4GmKZPSgoC8jDa6i
	8O6GTMeyN6qOZJga5dBgG/R9B6gLbn4=
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
Subject: [PATCH 4/4] block/kyber-iosched: flush per-cpu latency buckets over possible CPUs
Date: Mon, 20 Jul 2026 17:37:26 +0800
Message-ID: <20260720093726.28965-5-cui.tao@linux.dev>
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

kyber_timer_fn() sums the per-cpu latency histograms with
for_each_online_cpu().  A CPU that goes offline mid-interval leaves its
bucket un-flushed; the samples are lost from the current decision and
re-appear (stale) when the CPU is onlined again.

Fixes: 6e25cb01ea20 ("kyber: implement improved heuristics")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/kyber-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index 971818bcdc9d..2ee552ab8135 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -275,7 +275,7 @@ static void kyber_timer_fn(struct timer_list *t)
 	bool bad = false;
 
 	/* Sum all of the per-cpu latency histograms. */
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct kyber_cpu_latency *cpu_latency;
 
 		cpu_latency = per_cpu_ptr(kqd->cpu_latency, cpu);
-- 
2.43.0

