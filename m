Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EFD308F32
	for <cgroups@vger.kernel.org>; Sun,  2 Aug 2026 15:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785683078; cv=none; b=iLuVWm5VNU0q6xR2VXmTaKP2FL6XELZw4hnZA4S8G4iMZBtYzgzuKtSDKWlLgyl6Ux1gYazjp9k72nEAuNYKbeqU8v2ZmxpXMArmFAJDZMqO5whFXZBV32/4oyLDt/RVmuwaHv1PDkwcW0c7GnmXRkzyob0D2jQjrGpOPfW6sXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785683078; c=relaxed/simple;
	bh=PNImhYUF+IBH1SnJQQV6VVaaSWz80MXr0dLREmGyW/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c3FBfxGBqDe27xDfvvMRZAUpq+eKv6rixqufivnYwtAesIEunK3IPbhjQcpJHfHXtMrWCemdM53cr0jcHwLPSirQa0p5E+jnh/okENCy/LuVrKb1wWs2gD6jO3Z7xu1UuYH9ETXzt186kTq1m7g5JuC8Sbdsb6jC84g80ThrP+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vvIFGNv/; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vvIFGNv/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785683072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fNqPIMi1h+CgUvqJUxjQG3eAhWqTrsnnu3OCxhWLRis=;
	b=vvIFGNv/cVAe+VIyTugn7OGAVxjLXg1HeQV6m3E03rHSnv1qTae4500/d+FI9SP3S0EUCM
	I2reLsHEfEMEPqMqqvIMH6VBM0ez1fRSvVJGzl5RA77SYCK5mavZivERKUqxCjg4YGqC51
	RD4i8mlCPmlT7nOGIy8+TRcZayMkPzs=
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk
Cc: tj@kernel.org,
	josef@toxicpanda.com,
	yukuai@fygo.io,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] block/blk-cgroup-rwstat: use data_race() for online test
Date: Sun,  2 Aug 2026 23:04:13 +0800
Message-ID: <20260802150413.29789-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

blkg_rwstat_recursive_sum() reads pos_blkg->online without the queue
lock that its doc comment requires, since blkcg_print_blkgs() stopped
holding it in 56cc24f59c14.  Concurrent blkg_create/destroy flips
->online, tripping KCSAN.  The race is harmless (RCU-protected, stale
online only causes minor stat noise).  Use data_race() to annotate
the intentional lockless read.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-cgroup-rwstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup-rwstat.c b/block/blk-cgroup-rwstat.c
index aae910713814..71f74052ae03 100644
--- a/block/blk-cgroup-rwstat.c
+++ b/block/blk-cgroup-rwstat.c
@@ -107,7 +107,7 @@ void blkg_rwstat_recursive_sum(struct blkcg_gq *blkg, struct blkcg_policy *pol,
 	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
 		struct blkg_rwstat *rwstat;
 
-		if (!pos_blkg->online)
+		if (!data_race(pos_blkg->online))
 			continue;
 
 		if (pol) {
-- 
2.43.0

