Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA413E4C68
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 10:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784283676; cv=none; b=Y/a/0QHeSgLku/+IELGz0PjgdFt9irWaDc5tuq0Dk93/ytUpbPC408LRJZ9z3N2yNfIC0qqOQBXRSLZ0xBgnMaZ4UU2Zo3jZazJSrhzSF8Yr/DS098DVUwGIr3lvjvhrcQUmQRK//GgKnLWLnBaSloqUHG3cuSQVFzGUs/WzF4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784283676; c=relaxed/simple;
	bh=6fQE9225uLj9UY3sQ00LtfGbDAx5kFGcq1zXiQmf3EA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FllrtrwY5L0eTshdCkw6vSdCNcqCklpdfOq8r7cftV0uS8jQ9JpXwWyukX2nO5q48d3qq7OC86s98Nprm0msABOvbdg95ZMQver2dmUqMboL1qbyO7QD90gLodnnKxfymZ590/ZiyTOHmIawZMa60n3i++++TOaiRQVeVU38kDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=awK1/kzR; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="awK1/kzR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784283661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=u5cdISSO/VLp2AOh9FBBaStiUo4WE7PGb8e0wB4r3GM=;
	b=awK1/kzRC59c45EBkhNRLWxx7njhb79zkrhf5fzbu4Yxj5nmD3DskVwzResbElWE8XVWWw
	Yz8Y+WIad5DVwx+zyCL12DRYDjv6p/+DI9uUf/cHxVG51z16AHguCaBhrWe6CPliAFCgEX
	ww7bhOiC67eu04ra8auuKgSHJKlrCZ8=
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	tj@kernel.org,
	yukuai@kernel.org,
	yangxiuwei@kylinos.cn,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH] blk-cgroup: remove unused blk_queue_for_each_rl stub
Date: Fri, 17 Jul 2026 18:20:49 +0800
Message-ID: <20260717102049.2080768-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

blk_queue_for_each_rl() was added by commit a051661ca6d1 ("blkcg:
implement per-blkg request allocation") to iterate over the root request
list and per-blkg request lists for the legacy (non-blk-mq) request
allocation path.  The request_list code, including q->root_rl from
struct request_queue, was later removed in 2018 by commit db6d99523560
("block: remove request_list code").

The macro definition left behind in the !CONFIG_BLK_CGROUP fallback
branch of the private block/blk-cgroup.h header now references the
removed q->root_rl field, and has no callers in-tree (it would fail to
compile if expanded, so it cannot have any out-of-tree users either).

Remove the dead stub.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-cgroup.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 615390f751aa..6a309d2d3db5 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -500,9 +500,6 @@ static inline void blkg_put(struct blkcg_gq *blkg) { }
 static inline void blk_cgroup_bio_start(struct bio *bio) { }
 static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { return true; }
 
-#define blk_queue_for_each_rl(rl, q)	\
-	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)
-
 #endif	/* CONFIG_BLK_CGROUP */
 
 #endif /* _BLK_CGROUP_PRIVATE_H */
-- 
2.43.0

