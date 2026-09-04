Received: from mta0.migadu.com (out-38.mta0.migadu.com [91.218.175.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A39417BF8
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 05:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500289; cv=none; b=P2LiQijRGCKprVM/ApXnHP6cqTPGuKerU/dBIIfh3eVloKjZnwfx7xnUvmJIL1jgOJ54atZjpttAjyocUxkFlDFnI2gPgQ7/Z39IUiZG3nZKvf4ca9DAshYW6U0jMhS+TBus0dHetOsLYpkUIFnBmXP+LV7dQnTj4gVfknqYk0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500289; c=relaxed/simple;
	bh=MU1sHvpqoBfFc0gexyP/TzWUZ7RJEDh2n3zyKs/ESGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HbRA2s8aY433FOVl+xjThHQUIPKvzV3FF0nYiOatP8d1o7A+HkmqoEmeCSoetL9ZEaC9oBr/lt2l0xqxtfgKOjAz1+PWzn06SWoqcydGKfAEX+1K2vaQFIOPpwCt5yR7ad0W1p2xI1bjWWleIlF70SW4n+fn/EMlyArUcwdmbCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J3NZ1Z//; arc=none smtp.client-ip=91.218.175.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J3NZ1Z//"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MU1sHvpqoBfFc0gexyP/TzWUZ7RJEDh2n3zyKs/ESGc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788500285; v=1; x=1789105085;
 b=J3NZ1Z//NzvRkSNn/yNyVZ/wHClKfLgYJc/OAdZ2fU/Mj4eGGreBEbNA1Pjo/9G+/LhBgV0r
 rLni6kxUzFmq16weOPXgyqyu/zqk36OdfNoOwZCg5Xnhuy6Aq2DMEv/dnYLtwEtDk0qKQYsw228
 1P5SOVmLL/x4Uwy5mrMo56sg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3004a30640d02020;
	Fri, 04 Sep 2026 05:38:05 +0000
X-Mizu-Trace-ID: 3004a30640d02020
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk,
	yu kuai <yukuai@fygo.io>,
	Tang Yizhou <tangyeechou@gmail.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	tj@kernel.org,
	yangxiuwei@kylinos.cn,
	cuitao@kylinos.cn,
	cui.tao@linux.dev,
	Tang Yizhou <yizhou.tang@shopee.com>
Subject: [PATCH v2] blk-cgroup: remove unused blk_queue_for_each_rl stub
Date: Fri,  4 Sep 2026 13:37:55 +0800
Message-ID: <20260904053755.1222938-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>

---
Changes in v2:
- Rebase onto current linux-next head (no code change).
- Add the Reviewed-by tags collected on v1 (Yu Kuai, Tang Yizhou).
- Link to v1: https://lore.kernel.org/r/20260717102049.2080768-1-cui.tao@linux.dev
---
 block/blk-cgroup.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index e67c69839129..ceca6647a5e5 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -517,9 +517,6 @@ static inline void blkg_put(struct blkcg_gq *blkg) { }
 static inline void blk_cgroup_bio_start(struct bio *bio) { }
 static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { return true; }
 
-#define blk_queue_for_each_rl(rl, q)	\
-	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)
-
 #endif	/* CONFIG_BLK_CGROUP */
 
 #endif /* _BLK_CGROUP_PRIVATE_H */
-- 
2.43.0

