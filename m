Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369803A83A8
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 05:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784267384; cv=none; b=awluXUsXvPoRjz/um+mcO3O7swHTVwBw9c2bh/8WApLNWzPOFyBIu1/W6zV6O17pQjkinrx51PWLmCtatQ/s/FATu6VOUK6hHWR7+Mnl+kV0kBhoKvQCnMzUyX3wemD4E9PVTv5l2vza4/4mRvhdoRcfsSCUN/k7NbbrJH8usqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784267384; c=relaxed/simple;
	bh=JUK8CF3IkvaMiYWabwUlJxaM9l4LXstNcsFvSRXBUxw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QQQ2wJYH1KIG0OWSU2DPfx9aQ/NFoQNmn+/OebTrzNmhzx8kj4C9zKqtnIgFiAoEaqPVkgj85Qckm1/U/OfAHBimWSU2feqN5vOSwSNFilQMMBwlY4lJvpbxPsWxRygqJlfJa/5unQW10fN/p6oL7CjWW4gXFsygm6JtUlxSl2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D06Yv+Uu; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D06Yv+Uu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784267381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IamSRlvsQq/mbxo7HyEIuWQopPv3KIc2Bl832i3c838=;
	b=D06Yv+Uu5VY9hV7tvaBwpWQKJ12satmOhkDj1aTHb559ifBAdnq07aF84iTwqFB0bMvc8L
	0ipa0YH2Lu3BXZvOQLYaoGBB3n7RhcsPmGhTzF+yKCwm9PS5c1tVWG73oYu+HPgPI1lmxj
	aDU0qWAfCemlQ4cE+t9s+WYrNtRjDh0=
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk,
	linux-block@vger.kernel.org
Cc: tj@kernel.org,
	josef@toxicpanda.com,
	yukuai3@huawei.com,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] blk-throttle: remove dead field last_check_time from throtl_grp
Date: Fri, 17 Jul 2026 13:48:55 +0800
Message-ID: <20260717054855.2018578-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

The last_check_time field in throtl_grp was used by the
CONFIG_BLK_DEV_THROTTLING_LOW mechanism (in throtl_upgrade_check() and
the downgrade logic) to timestamp the last upgrade/downgrade check.

Commit bf20ab538c81 ("blk-throttle: remove CONFIG_BLK_DEV_THROTTLING_LOW")
removed all five of its uses in blk-throttle.c and the surrounding LOW
fields (latency_target, last_finish_time, checked_last_finish_time,
avg_idletime, idletime_threshold, bio_cnt, bad_bio_cnt,
bio_cnt_reset_time), but missed the field definition itself.

It has been a dead field since then: zero references in blk-throttle.c
and the whole tree.  Remove it.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-throttle.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 9d7a42c039a1..1b5775771e07 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -120,8 +120,6 @@ struct throtl_grp {
 	int64_t bytes_disp[2];
 	int io_disp[2];
 
-	unsigned long last_check_time;
-
 	/* When did we start a new slice */
 	unsigned long slice_start[2];
 	unsigned long slice_end[2];
-- 
2.43.0

