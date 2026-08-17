Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D392E8DEF;
	Mon, 17 Aug 2026 03:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786935606; cv=none; b=twn9lsWgByJ98uJPHfk5gMsTyXc2ovhn7Yb5BVxMNNgWNE9YzoYTorP41XR9hlucq382KFfWMtDD4RJSoBxfKC1QQPJTwWZk6//IB372UtHdpAGssMPqbmgFnqFkKvseEgR8noTLzXTfMKyugp3fv5TnOTU5pf7gAKEysi3G/vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786935606; c=relaxed/simple;
	bh=gYHoZ9AdYiI4wapYAVvGN+pxpseZPHxhWzyZc+pEzHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CH70ZRGueg9qh8RgCMMmv+5Z5wyDmgYkSYkcW9HlG01jSml3+FCcnm3aJHBbqq/UWBeP1HSzmx/bMtFntQ8OckY23YVSGusOdBwLh8FDUPwbLvHKEWM99z75pRz/UmYbfdBMF8lVBlQUpsHyQY+YShMgMYtMIdDh05eohsgUxfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b951159899e711f19a56ed5b684f684d-20260817
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
X-CID-O-INFO: VERSION:1.3.19,REQID:2d6cb092-b4d7-425c-bba2-8622327e898d,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.19,REQID:2d6cb092-b4d7-425c-bba2-8622327e898d,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:7db8b62,CLOUDID:e7b039aea4d664cd40d109712db20148,BulkI
	D:2608171059588DXYCQ5Y,BulkQuantity:0,SF:17|19|66|78|102|127|865|898,TC:ni
	l,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b951159899e711f19a56ed5b684f684d-20260817
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 581254986; Mon, 17 Aug 2026 10:59:55 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhuhui@kylinos.cn,
	joshua.hahnjy@gmail.com,
	audra@redhat.com,
	bingfangguo@tencent.com,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg offlining
Date: Mon, 17 Aug 2026 10:59:17 +0800
Message-ID: <20260817025917.66233-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

refill_stock() takes a css reference for each cached memcg slot and
mem_cgroup_css_offline() relies on drain_all_stock() to release those
references before the cgroup can finish dying.

consume_stock() can drive a slot's nr_pages to zero while its cached[]
pointer stays set.  is_memcg_drain_needed() skips such empty slots, so
the offlining drain is a no-op for them: the pinned css reference is
released only if the slot happens to be evicted by later unrelated
charges on the same CPU, or by CPU hotplug.  The memcg then lingers
in the dying state indefinitely.  On a CPU with container churn, a
per-cpu stock can pin up to NR_MEMCG_STOCK (7) zombie memcgs.

The sibling obj_stock_flush_required() has no such gate: a cached
objcgs slot is flushed regardless of its byte count.  Drop the
nr_pages gate from is_memcg_drain_needed() accordingly.  Draining an
empty slot is a single css_put() and a NULL store, and it happens at
most once per slot per drain, so the extra work is negligible.

This is easily reproduced with short-lived cgroups pinned to one CPU:
12 charge/exit/rmdir cycles leave nr_dying_subsys_memory at +2, stable
across later slot displacement.

Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 mm/memcontrol.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..b931ec16bb82 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2291,8 +2291,12 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 		if (!memcg)
 			continue;
 
-		if (READ_ONCE(stock->nr_pages[i]) &&
-		    mem_cgroup_is_descendant(memcg, root_memcg)) {
+		/*
+		 * An empty slot still pins a css reference which
+		 * mem_cgroup_css_offline() relies on drain_all_stock()
+		 * to release.
+		 */
+		if (mem_cgroup_is_descendant(memcg, root_memcg)) {
 			flush = true;
 			break;
 		}
-- 
2.43.0

