Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BC2433BAB;
	Mon, 17 Aug 2026 13:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786972780; cv=none; b=VAwnrh00XFBfo56wsg4y16FyO5Wts0+IUKNJhgXGIxgQQuP5BCulKHihuR4es0AyhNRC9YHYQ/VvkYdOtqk4WnRxDQUZJ/6VhEgtQwGto4jRHUD0+6W0JJeNmF29YKiyKHREQfXfGgRU7a3wr3WZYOaq0djCf9fcwrlc3DwK05k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786972780; c=relaxed/simple;
	bh=NbKSdANK9re5kysU+DITZ2Ia85k6xiGpsASZN25HsIE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uoMIc236OMbY4rytniII2uyl29ovavPBTJ8c7PVgxWJXfw18JMLbBI8amv6vyxQKRMzWW5/sS4cdJIn25FxNhS/lq0p1zqRBdNUMKg41ePyTy9YhyuuusieIdZeSRIfIlYctBdFoLB310SQy3D26XAYEfv6QnywbYr0anhza53w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 45bee9009a3e11f19a56ed5b684f684d-20260817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2f434dd9-bfdd-4195-86b0-60afbde8c5b7,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:2f434dd9-bfdd-4195-86b0-60afbde8c5b7,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:7de0c4b8a1718a804dc096b537f914e3,BulkI
	D:260817211930ROFSYON4,BulkQuantity:0,SF:17|19|66|78|102|127|865|898,TC:ni
	l,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 45bee9009a3e11f19a56ed5b684f684d-20260817
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1285450484; Mon, 17 Aug 2026 21:19:27 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	shakeel.butt@linux.dev,
	yunzhao@cloudflare.com,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
Date: Mon, 17 Aug 2026 21:18:43 +0800
Message-ID: <20260817131843.45121-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

obj_cgroup_may_zswap() runs on every folio swapped out through
zswap.  For each ancestor with a non-max zswap.max, it flushes the
cgroup rstat hierarchy synchronously with force=true, which skips
the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
with zswap.max configured, a container takes the global rstat lock
on every swapped-out folio.

zswap_shrinker_count() had the same pattern and switched to
mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
where the same flush on the shrinker side showed up at 2.88% of
kernel cycles under osq_lock on a 96-core machine.

Measured on a KVM guest with a swap storm under a cgroup with
zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
before the patch and 198,968 times after, while
__mem_cgroup_flush_stats() was entered 281,017 times before and
80,445 times after.  The removed 200,572 flushes match the store
attempt count almost exactly; the remainder comes from other stats
readers in the swap path.

The stats can now be up to one flusher cycle stale, so zswap.max
admission can overshoot for one cycle in a storm; the overshoot is
corrected as soon as the next flush lands and later stores see it,
the same tradeoff the shrinker side made.

Fixes: f4840ccfca25 ("zswap: memcg accounting")
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 mm/memcontrol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..7a8f689055c6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6000,8 +6000,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 			break;
 		}
 
-		/* Force flush to get accurate stats for charging */
-		__mem_cgroup_flush_stats(memcg, true);
+		mem_cgroup_flush_stats_ratelimited(memcg);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
 		if (pages < max)
 			continue;
-- 
2.43.0

