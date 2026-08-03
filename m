Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7615040801B
	for <cgroups@vger.kernel.org>; Mon,  3 Aug 2026 13:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764489; cv=none; b=cA0xlUZGvJF0zyC1Ef2cnbbP2oLCxbJkyNcDtDbn8/OFFA1ZLuLyJUEMSt+/nPY0XSD6YV23n1NC0ingHjzNkJHvzymI5NVMlrBXu+9ZULlJyBvnFN46cZ5XjwtIhC7FV9GKKV5/vuloxgiG/hevsaXBgoZRTVEr6OLwPc6WSfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764489; c=relaxed/simple;
	bh=0ievkl6OufEmaYsxvAnISbhXXwxA78c1AnDi8dEBEh0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=egLNp1LzOqwgmnNkMpj8S0ZaWfu5uAfw1BR0JKZhWgenKkfzBtqtJH8/XDGeD0Gt4vuqJU7/U1AFwjEj6CrZSjlFWr/9tm2XLjW59hsAOwxcR6E8KNnqb/D0b3u6rTLUOM1JcUJUvcDAY9l2r2djF6dgwNRV2Vs+tqBP3ikKI0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IfPOGCJ5; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IfPOGCJ5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785764475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FD1nmX4bovabO9SQhtw+dyJEIy94pdohczPGKx4uVr4=;
	b=IfPOGCJ5HwqbJoh5wTsEFKHX6OhOPcN3Qq/qImEQlbkx7GsmFFkGY2VFPWjT5cDtQBb2Lo
	vcRDg0UicEmPdUEnCBowUIjx0UBQ01/O8fpB7vWr0dRcgHyQYsiORjLmoYMHiIHtWj8bqm
	l50mTWtFEq6oHUmfikj4FLp990r+xI8=
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk,
	yukuai@fygo.io
Cc: tj@kernel.org,
	josef@toxicpanda.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] block/bfq-cgroup: use data_race() for online test
Date: Mon,  3 Aug 2026 21:41:04 +0800
Message-ID: <20260803134104.138411-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

bfqg_prfill_stat_recursive() and bfq_bio_bfqg() read blkg->online
locklessly, same as blkg_rwstat_recursive_sum().  Annotate with
data_race() to silence KCSAN.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/bfq-cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index e82ff03bda02..ef9d63e8542e 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -610,7 +610,7 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 	struct bfq_group *bfqg;
 
 	while (blkg) {
-		if (!blkg->online) {
+		if (!data_race(blkg->online)) {
 			blkg = blkg->parent;
 			continue;
 		}
@@ -1168,7 +1168,7 @@ static u64 bfqg_prfill_stat_recursive(struct seq_file *sf,
 		struct blkg_policy_data *pd;
 		struct bfq_stat *stat;
 
-		if (!pos_blkg->online)
+		if (!data_race(pos_blkg->online))
 			continue;
 
 		pd = blkg_to_pd(pos_blkg, &blkcg_policy_bfq);
-- 
2.43.0

