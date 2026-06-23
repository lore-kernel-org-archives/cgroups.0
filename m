Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05C63CD8A9
	for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 08:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782203201; cv=none; b=DjPKC7GRK5287ZQrHtfjmWiBmbwilz7RG3oQFYki07RQl2J3Zf8oI8M1oU0lT90rORy+e2Y3/JgqUNLktyiOHhDlYax8EQMjqG8+RsrYSZlhaY2Szv89BdBEOMHZT3MaCaXDBsZ2hnetH3wOVShyOpOr5+CLGQKNXqnQcBBdq24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782203201; c=relaxed/simple;
	bh=DOmX24PEKani/oOGx/OlEmaxEsBp6omZ1P+77j5jSQk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pMN+I3Y9zeRKSIPQKgxdDWeJy+FDaZOa3UDmjxpaSVDGD85+cc32iK3NfvPm86HOTx2XuxMVwD5wd0vwElie4yvQ7NrQNzAZyDOCGkCH0pordRCexS10qhW3Dd1KzKSE2BYZ2dzKKn2fsTVeIoNM+FfWS8RAD1JpKk8wlueFDHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qAj/Ud+n; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qAj/Ud+n"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782203198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oZr4ekvOsJTTwgNBriNjKAByh2c4c4R0Fz9QNeRo4Ks=;
	b=qAj/Ud+nweTMsayeeGUcxTOl0Kd5xdG2F15Ph3kKhdRPkp9KTXHmWUWyYVT6ibeLAtdBwH
	aQiMS0x/SOUQKdnSWcWz2ark48GolN0gHgUKcRVw24V12pwXjTI19Smge3CCT7pHCOPOEB
	sYcVM28un3tnYL0NTemL7GspwRGpqzU=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
Date: Tue, 23 Jun 2026 16:26:14 +0800
Message-Id: <20260623082614.81621-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

A patch filename was accidentally inserted into the comment describing
the nr_bytes field of struct obj_stock_pcp. Remove it.

No functional change.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..3eedfc4e84a0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2039,7 +2039,7 @@ struct obj_stock_pcp {
 	/*
 	 * On rare archs with 256KiB base page size (hexagon and powerpc 44x)
 	 * keep nr_bytes to unsigned int as uint16_t cannot represent the full
-e patches/memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch	 * sub-page remainder. Such archs are not cacheline optimization target.
+	 * sub-page remainder. Such archs are not cacheline optimization targets.
 	 */
 	unsigned int nr_bytes[NR_OBJ_STOCK];
 #else
-- 
2.25.1

