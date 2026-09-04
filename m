Received: from mta0.migadu.com (out-59.mta0.migadu.com [91.218.175.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404783A0E99
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 07:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788506191; cv=none; b=BF9ISC09+8TR9UjQVoMbGcpFiXrY+P+M5aF85ljnMaGpnS+PXE+4jPLW5t1Umhv7Ars/1PEhtIfGn4fBbeZw2UDMMTJU8FBUU7cXddOsAIglbzNM/HUe+Aax+XTpySPuTjMPXB84ZhKydPuRxRDXI1RmLDJ825Udj+QuPNs8GUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788506191; c=relaxed/simple;
	bh=70j3VNummA+NOr6rDjyv8NV5t3/kVuu8aj9V3eAYIq4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lHqcTxZqbOlWgh7xOGLFYBpSE8eVTIJbxbNOPv/T9FeYQsg51dDOFfzmYxPwokKHzoGgSdMTQHAJjkcY0119gunasqRRh7SpRIrwe1lbhsQJIj2yQVMD363r8xYYpvv40CTBHEzKFnu160k3DDtucGwz7oSdAct7tgDSPe5hcrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ujQTjEVG; arc=none smtp.client-ip=91.218.175.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ujQTjEVG"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=70j3VNummA+NOr6rDjyv8NV5t3/kVuu8aj9V3eAYIq4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788506187; v=1; x=1789110987;
 b=ujQTjEVGYweSDyePXqzt++HS18/kggyIHH6uij0xHu2WKioApS6/5EQvOxymmHysghgIJI7v
 X+CNcJEMHPj8zOK5Ivp1DnBI7ScARp9dKS8X/iyG6VYWx84XLJ5NaSsk2OiRlFhhUVK6NM/eb38
 TntZvGmff3lA7yUdgY04H8Lk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e445b23655a253da;
	Fri, 04 Sep 2026 07:16:27 +0000
X-Mizu-Trace-ID: e445b23655a253da
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk,
	Tang Yizhou <tangyeechou@gmail.com>
Cc: tj@kernel.org,
	josef@toxicpanda.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn,
	cui.tao@linux.dev,
	Tang Yizhou <yizhou.tang@shopee.com>
Subject: [PATCH v2] blk-cgroup: show io.stat numbers for discard-only cgroups
Date: Fri,  4 Sep 2026 15:16:19 +0800
Message-ID: <20260904071619.1283221-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

blkcg_print_one_stat() gates the rbytes/wbytes/rios/wios/dbytes/dios
output on

    if (rbytes || wbytes || rios || wios)

which omits the discard counters.  A cgroup that has issued only discards
(zero read and write counters) therefore prints an empty stat line and its
dbytes/dios are never surfaced, even though they are accounted correctly.

The guard predates the addition of discard stats and was never updated;
include dbytes/dios so discard-only cgroups are reported.

Fixes: 636620b66d5d ("blkcg: Track DISCARD statistics and output them in cgroup io.stat")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>

---
Changes in v2:
- Rebase onto current linux-next head (no code change).
- Add the Reviewed-by tag collected on v1 (Tang Yizhou).
- Link to v1: https://lore.kernel.org/r/20260714063302.1153238-1-cui.tao@linux.dev
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 471cfd2347c9..7b48cd1db13d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1160,7 +1160,7 @@ static void blkcg_print_one_stat(struct blkcg_gq *blkg, struct seq_file *s)
 		dios = bis->cur.ios[BLKG_IOSTAT_DISCARD];
 	} while (u64_stats_fetch_retry(&bis->sync, seq));
 
-	if (rbytes || wbytes || rios || wios) {
+	if (rbytes || wbytes || rios || wios || dbytes || dios) {
 		seq_printf(s, "rbytes=%llu wbytes=%llu rios=%llu wios=%llu dbytes=%llu dios=%llu",
 			rbytes, wbytes, rios, wios,
 			dbytes, dios);
-- 
2.43.0

