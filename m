Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.250.56.165
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794568135;
	b=VhwmCfCCx4KW5FoiFvqvR/UeVNku1oKTTo4ExbUcbsciqGHqDbRiWUdTrGRr1VxZG8Tr
	 ePn8tdplGIACDeOKNCEqAaeBzPiKoFEGxHIDsDkw96NCXfc8nnsPse0PFn8kjt/grWa5+
	 dUqfaclcYwwFMm9Z+oR7o37gpvgxU7i5awWXcU03Gwnb69M/QbjJxmQk3DmQhMEovs/np
	 swQ8tkB4lGj7Zr7tBzHEUuoo8fZ4akYgdCM49qzD+extqk69lkOLvFnTyP5c6SL4G1Bqe
	 STzZEsgvw8yrYZPg7WsxoRt+4cyMvdU327goj0AKWh/8yRFdOe7LUJFqPf9qfbXPfqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794568135;
	h=DMARC-Filter:Received:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=H42X3hyJK2xtTQxkZsujMjWKQGvRn9KWtqkTmAVsHHE=;
	b=yXBske4cI8tmJZWWWz+xLOZoBdS5kpSENz94bnPcRt5IJURp2vnwFn5tbnR/luEGA1eI
	 A/TNXSF7dEqj3jkRb11qomSgE2jqXRS56obD3Ls0MY5rM2Kc88RrgnLZMUV7fobvMzcJR
	 /KFo65quXZ/hfOfUfUrjNoPXaoiXAYjnkmqHtJhTcjB9eWfapb1caFE98j14PA8vEKx+3
	 va1Y1ZOT7/cPhhJ9tc/8pEY+hZwFlRQH9vkSap8BygcSielwo6n1jJd/qhXpZryQ9kReu
	 uNttOwT7mU9X2FeeWtXJvqjmhRn4ZcUkpQhhGo14G2JSFWVG+N4/uga5msM37E9qpmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ideco.ru;
	spf=pass smtp.mailfrom=ideco.ru;
	dkim=pass header.d=ideco.ru header.i=@ideco.ru header.a=rsa-sha256 header.s=ics header.b=IzHPYv7r;
	arc=none smtp.remote-ip=51.250.56.165
Received: from smtp.ideco.ru (smtp.ideco.ru [51.250.56.165])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA342606A331;
	Fri, 13 Nov 2026 11:08:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA342606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ideco.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideco.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.a=rsa-sha256 header.s=ics header.b=IzHPYv7r
Received: from [169.254.254.254] (localhost [127.0.0.1])
	by smtp.ideco.ru (Postfix) with ESMTP id 4BB1C26BC3;
	Fri, 13 Nov 2026 16:08:53 +0500 (+05)
Received: from fedora (5cfcd9fa.dynamic.mv.ru [92.252.217.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.ideco.ru (Postfix) with ESMTPSA id 789E026BC0;
	Fri, 13 Nov 2026 16:08:51 +0500 (+05)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.ideco.ru 789E026BC0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ideco.ru; s=ics;
	t=1794568132; bh=H42X3hyJK2xtTQxkZsujMjWKQGvRn9KWtqkTmAVsHHE=;
	h=From:To:Cc:Subject:Date;
	b=IzHPYv7rdTJpdRP/zNj0uJTMW1HSGPWPg4kaTGJf6HuV1ont6JHrXdcBRFEZ36SAY
	 6TTnBf7Tw0D4t79t+Jju+USyTvR+OubCRPm9MokLORCBXCX8Z5sA8qYgMHZQXluCR0
	 k6eQQ9Uy13k8+Y3PfRgdkpv3kQXDHVyeO8x2dpdhp8tj8RtZoxhi+EDLt1aPS/4tQe
	 hH2NQmXJS/X7X7kWoERvYupW97p6pCJE+hz0Nj4YTQVxMOUZAKf5r0KEFDPhBU1Ib4
	 49NDJpKf17fSZwKcN/IXmS9abXgZU9FeEO4IkdcPHwF03hovGXcsuTI/pDUUOZ9/cM
	 /ux2XFH5AtwcA==
From: Alex Kazinsky <a.kazinsky@ideco.ru>
To: Tejun Heo <tj@kernel.org>
Cc: Alex Kazinsky <a.kazinsky@ideco.ru>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: [PATCH] blk-iocost: Fix overflow in donation weight calculation
Date: Fri, 13 Nov 2026 15:08:40 +0400
Message-ID: <20261113110842.4189035-1-a.kazinsky@ideco.ru>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hweight_after_donation() receives usage as u32, clamped to the range
[1, WEIGHT_ONE]. Since WEIGHT_ONE is 1 << 16, multiplying it by usage
equal to WEIGHT_ONE wraps the 32-bit unsigned result to zero before
it is passed to div64_s64().

This makes new_hwi zero, which is then clamped to 1, incorrectly
reducing the cgroup's in-use weight to the minimum.

Cast WEIGHT_ONE to s64 before multiplication to preserve the full
product.

Found by Linux Verification Center (linuxtesting.org) with SVACE static
analysis tool.

Fixes: f1de2439ec43 ("blk-iocost: revamp donation amount determination")
Cc: stable@vger.kernel.org
Signed-off-by: Alex Kazinsky <a.kazinsky@ideco.ru>
---
 block/blk-iocost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 1c1025157d8e..0ffe34bd95b7 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1853,7 +1853,8 @@ static u32 hweight_after_donation(struct ioc_gq *iocg, u32 old_hwi, u32 hwm,
 	delta = div64_s64(WEIGHT_ONE * (now->vnow - vtime),
 			  now->vnow - ioc->period_at_vtime);
 	target = WEIGHT_ONE * MARGIN_TARGET_PCT / 100;
-	new_hwi = div64_s64(WEIGHT_ONE * usage, WEIGHT_ONE - target + delta);
+	new_hwi = div64_s64((s64)WEIGHT_ONE * usage,
+			    WEIGHT_ONE - target + delta);
 
 	return clamp_t(s64, new_hwi, 1, hwm);
 }
-- 
2.56.0


