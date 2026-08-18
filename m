Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE2C2BE7A7;
	Tue, 18 Aug 2026 13:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787058148; cv=none; b=MgjbsqTm1ylXJDYEJN2FdOAaoFHndUVPOO73PGWoCRueTSmefVVCtz+oS2GbdQc0oKCz9+YAPJNIsU1tc+YnQT5sjCq1KXjzzX6+mYSdIEivTGvcKKca8qG6oz7AVhVUxeUGrwVYZBzB6EJhM9PgjLJkE0GM5z2XJRuzFWhisik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787058148; c=relaxed/simple;
	bh=8PlVB2Jwf1buwFO76bi8ZJiAj7WsYCR0dz5XZXhimJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Od1WpBU3hYfyjc95mR9GWCZasTxRuvlelbDomVoA+je7jmwrDsY63RJn8ciFFZznWiJqGkIH/n1KTLlReBaNF1lxAHH1XxvhWHSK1wjYKnAy1fs69tbxmeVYWn3MpHvO4RY5ThIVeuiVeZKPXL5DImHljTEnQ083Ngj8jfyzd7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 067491609b0511f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:5b11598d-57da-4644-8347-efbc18028d8d,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:5b11598d-57da-4644-8347-efbc18028d8d,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:9cdabe40f9b50419632787e2e413e574,BulkI
	D:260818210214G3XWLUVL,BulkQuantity:0,SF:17|19|38|66|78|102|127|865|898,TC
	:nil,Content:0|15|50,EDM:5,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 067491609b0511f19a56ed5b684f684d-20260818
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1956968772; Tue, 18 Aug 2026 21:02:11 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org,
	mhocko@suse.com,
	mhocko@kernel.org,
	joshua.hahnjy@gmail.com,
	willy@infradead.org,
	shakeel.butt@linux.dev
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	zhuhui@kylinos.cn,
	audra@redhat.com,
	bingfangguo@tencent.com,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH v2] mm: memcg: release the css reference when a stock slot empties
Date: Tue, 18 Aug 2026 21:01:35 +0800
Message-ID: <20260818130135.154315-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

consume_stock() can drive a stock slot's nr_pages to zero while its
cached[] pointer stays set, so the slot keeps pinning the css
reference that refill_stock() took.  The offlining drain only
flushes slots with cached pages, so the reference is never released
unless the slot happens to be displaced by an unrelated charge or
by CPU hotplug, and the memcg lingers in the dying state - up to
NR_MEMCG_STOCK (7) of them per CPU under container churn.

Keeping the slot populated past the last page only saves a
css_get()/css_put() pair on the next charge of the same memcg, and
costs more than that: the offlining drain has to know about empty
slots, and refill_stock() cannot reuse them either, so a charge
under a different memcg evicts a live batch through the drain_idx
rotation instead.

Drop the reference in consume_stock() when the slot empties.
Empty slots stop existing, so is_memcg_drain_needed() and the drain
path stay as they are, and refill_stock() reuses emptied slots
directly.  The cost is one refcount pair per emptied slot, at most
once per MEMCG_CHARGE_BATCH pages.

Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
Signed-off-by: Song Hu <husong@kylinos.cn>
---

Changes since v1: drop the reference at consume time instead of flushing
empty slots from the offlining drain, as discussed with Michal Hocko and
Joshua Hahn (full-stock drain cost, refill reuse).

v1: https://lore.kernel.org/all/20260817025917.66233-1-husong@kylinos.cn/

 mm/memcontrol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..1271d390b617 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2140,7 +2140,12 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 		stock_pages = READ_ONCE(stock->nr_pages[i]);
 		if (stock_pages >= nr_pages) {
-			WRITE_ONCE(stock->nr_pages[i], stock_pages - nr_pages);
+			stock_pages -= nr_pages;
+			WRITE_ONCE(stock->nr_pages[i], stock_pages);
+			if (!stock_pages) {
+				css_put(&memcg->css);
+				WRITE_ONCE(stock->cached[i], NULL);
+			}
 			ret = true;
 		}
 		break;
-- 
2.43.0

