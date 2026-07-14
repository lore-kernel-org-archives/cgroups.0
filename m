Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B1F380FF5
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 10:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784025049; cv=none; b=mIJUKq42cgT7ibjxnArFWGJgQ3eD0gP6BhdmAIf1FziVMFzRgNlMbPULxCMF0La6D0LZ2lCHhvCV6RooR78bFG1hA1X92JpN8AcYeilDKjBZSMoDL6lgJZOjCswCZ2nuBEGtqHfmqaNJ3LAelnYrd+2KS3vaNILqQQ+nMm6hz/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784025049; c=relaxed/simple;
	bh=puc9YALtWziqYkBJbt5VOrrHc69KiWlEH9pttLkhJhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKJU53YB+qMr5uEb+3iLZaxgy2T6oTYpLL6iXVX1aWm/5UcHJzmudUQqBj/kcut+hXtwgtZQVpQQ9P2dJjjVBe8/YIiyisVKvR5h3RQPpKTIh4/4RtGU80cay/fJFPGHeA6vVAus+c8jT7oqMEbk9L1Z1yB+kfuSEilriTaT6Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cbG7teos; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cbG7teos"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784025046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f8dzd6NP/vphjF8glzA850rGTiei5MmL1QvD+Zjdb/s=;
	b=cbG7teos1hPq/2TFO72otOkBg17nt399lz2/mE6osxSraceZHUh1d7yLZZRUFEjaqtrX7b
	sVjO7JvS5KAmQgirArF47Foy4N26Mc2kIkegqc0l7B1h3xM99YnmyfhnX6ZXdX8XvjDv4y
	ngLNarmPlRPfU9FjbLZTJrGv8IjrJPE=
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk,
	tj@kernel.org,
	josef@toxicpanda.com
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 2/2] blk-throttle: factor out limit field printing in tg_prfill_limit()
Date: Tue, 14 Jul 2026 18:30:28 +0800
Message-ID: <20260714103028.1334831-3-cui.tao@linux.dev>
In-Reply-To: <20260714103028.1334831-1-cui.tao@linux.dev>
References: <20260714103028.1334831-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

The four rbps/wbps/riops/wiops blocks in tg_prfill_limit() are identical
apart from the key string and whether the limit is 64- or 32-bit. Factor
them into tg_prfill_limit_field() and drop the bps_dft / iops_dft alias
locals in favor of U64_MAX / UINT_MAX directly.

The io.max seq_file output is byte-for-byte unchanged.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-throttle.c | 48 ++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index f37911abefdd..8f4563acbc16 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1489,47 +1489,37 @@ static struct cftype throtl_legacy_files[] = {
 	{ }	/* terminate */
 };
 
+static void tg_prfill_limit_field(struct seq_file *sf, const char *key,
+				  u64 val, bool is_uint)
+{
+	u64 dflt = is_uint ? UINT_MAX : U64_MAX;
+
+	if (val == dflt)
+		seq_printf(sf, " %s=max", key);
+	else if (is_uint)
+		seq_printf(sf, " %s=%u", key, (unsigned int)val);
+	else
+		seq_printf(sf, " %s=%llu", key, val);
+}
+
 static u64 tg_prfill_limit(struct seq_file *sf, struct blkg_policy_data *pd,
 			 int off)
 {
 	struct throtl_grp *tg = pd_to_tg(pd);
 	const char *dname = blkg_dev_name(pd->blkg);
-	u64 bps_dft;
-	unsigned int iops_dft;
 
 	if (!dname)
 		return 0;
 
-	bps_dft = U64_MAX;
-	iops_dft = UINT_MAX;
-
-	if (tg->bps[READ] == bps_dft &&
-	    tg->bps[WRITE] == bps_dft &&
-	    tg->iops[READ] == iops_dft &&
-	    tg->iops[WRITE] == iops_dft)
+	if (tg->bps[READ] == U64_MAX && tg->bps[WRITE] == U64_MAX &&
+	    tg->iops[READ] == UINT_MAX && tg->iops[WRITE] == UINT_MAX)
 		return 0;
 
 	seq_printf(sf, "%s", dname);
-	if (tg->bps[READ] == U64_MAX)
-		seq_printf(sf, " rbps=max");
-	else
-		seq_printf(sf, " rbps=%llu", tg->bps[READ]);
-
-	if (tg->bps[WRITE] == U64_MAX)
-		seq_printf(sf, " wbps=max");
-	else
-		seq_printf(sf, " wbps=%llu", tg->bps[WRITE]);
-
-	if (tg->iops[READ] == UINT_MAX)
-		seq_printf(sf, " riops=max");
-	else
-		seq_printf(sf, " riops=%u", tg->iops[READ]);
-
-	if (tg->iops[WRITE] == UINT_MAX)
-		seq_printf(sf, " wiops=max");
-	else
-		seq_printf(sf, " wiops=%u", tg->iops[WRITE]);
-
+	tg_prfill_limit_field(sf, "rbps",  tg->bps[READ],  false);
+	tg_prfill_limit_field(sf, "wbps",  tg->bps[WRITE], false);
+	tg_prfill_limit_field(sf, "riops", tg->iops[READ], true);
+	tg_prfill_limit_field(sf, "wiops", tg->iops[WRITE], true);
 	seq_printf(sf, "\n");
 	return 0;
 }
-- 
2.43.0

