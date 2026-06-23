Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F103B992F
	for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 06:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782196150; cv=none; b=YapcjL9KNsYRl++NR02m/PiSbWG4QbmeqNo6y4SzVG73EexhnRit2H3oTO47FLsahzyaAv21+TBjLLOFQWj7+5mQnge2cSpyvnAkm/f4jyLIgpaG5x+UArDDmZGDqa3tU+qK8a3gPd9c8m/jwLuB1ShI4J5iL33M8FTkUU/xeAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782196150; c=relaxed/simple;
	bh=MZS/taGe7IaOEljQ0w+8HWNKllxDs7Mc9plvee9eo6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWTkffjcDtq+UpiYOyjB9PMAXmWGuyWctkwydMBSq9DPmFHYKFWtHKpg/WHEcgWqFa1WCSZu08MNkejXpu+ECAiD7L3qVUp6ZSDDrJByinITPHJ29LJlkNJhmZYwzjPVntrLz3w5qP+ehVIjyhiOtG5PJ1lEr63fsmI8h6gbF4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dZaxKjMK; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dZaxKjMK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782196146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WM/72UAw0KBUOaije1a6aN5pXM0KrE3wbUIEf3h6Yyg=;
	b=dZaxKjMKNgYWWTx0WH3QATSVO1s6+2fsVaS5w/chhYFgQAzVgviewZFF4Y+az+eHySevwV
	zEo5J0yf5+L5V1Ht6tctbB9MAdOp2wRCr5q684mqBsQeRfEd0KL7IiarKV2vQC/oQT+XU+
	skp0Z/83eorcA+rkihLUFeJFiCtzE8Q=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: yingfu.zhou@shopee.com,
	jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] memcg: bail out proactive reclaim when memcg is dying
Date: Tue, 23 Jun 2026 14:27:56 +0800
Message-ID: <20260623062800.298514-4-jiayuan.chen@linux.dev>
In-Reply-To: <20260623062800.298514-1-jiayuan.chen@linux.dev>
References: <20260623062800.298514-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Proactive reclaim via memory.reclaim can run for a long time - swap I/O
or thrashing again dominating the latency - and delays cgroup removal in
the same way.

Mitigate this by stopping the reclaim once memcg_is_dying().

Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/vmscan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8190c4abec84..1162b7f76655 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7922,6 +7922,9 @@ int user_proactive_reclaim(char *buf,
 		if (memcg) {
 			unsigned int reclaim_options;
 
+			if (memcg_is_dying(memcg))
+				break;
+
 			reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
 					  MEMCG_RECLAIM_PROACTIVE;
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
-- 
2.43.0

