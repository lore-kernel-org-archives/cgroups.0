Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622351;
	b=SZYYU99jGAyzZGRafmvIFOI8mWwKi3Gzd2ycvg5jNTTJeMNxKtsrAcoYsQD4rdO6AAjs
	 j6/XTmJfuEbwFn7mRlMq34fUXvZFj0tHxMFDRSiFwNMKcf+2BqepUw24VPmH7wnhDxftG
	 WzSm2I8aTWwcFSa9XPUJ3LvY8HCH5sOcCHnmvErwDTK/CVfaxFux23XbXJqEJidB3kW1s
	 GsPKO7FWoLC6jqvKRb3CAPgBqOjMhM6Ip5EnW5DsLo4LhN6GMVgo9mtH72SqUVvOzrJKL
	 6Jxgra2CuMh9LkovL6hiXMP2hXSxHh3BocbQT2l7vlUDtiSLr86Mw8vDF3tIMyiPemg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622351;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=cP8HlbLPqyhqKuqna0qVGWoiHPYWTx182iscTSCNW3k=;
	b=nkSU7jHhWC4Wx2aipghsx+IFxJ2r+Tk1h8RvmcZUI48qOx5UHca2a/1HU3JiUlxEEMpI
	 mBMv1C/04nL0rl3Ed+QDX7WmCj7QAyJ0Xs7K/b7cw1EXylJUH+o/r0SCNK6bCzfxVYar1
	 S6Dv/EJlE/DpR2XDBZgNo2uy70GG4IeDKd4wq2lfI+7kjyvk6AQi6YTup5DVk5OeYVzj/
	 plXC8+uWufc1GnhRnT9oiSrrAauze1IWhMRxHv0H8IuLCcTpsvDAhhXellLByZPi1M5MP
	 y71D3V249CUEgMa/qy3nxJIlFDyHMeCjRi90kIjddFsC4P1QDYEJkWWY3dFU9Vp39vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730F0606A781;
	Mon,  2 Nov 2026 12:25:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 730F0606A781
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8434b474d6b811f19a56ed5b684f684d-20261102
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:1b6cca05-a92b-449a-a34e-de6d2eda1270,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.19,REQID:1b6cca05-a92b-449a-a34e-de6d2eda1270,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:7db8b62,CLOUDID:65a68b027f359fed935768789d1ab6df,BulkI
	D:261102202544D32HOMG5,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|136|
	153|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8434b474d6b811f19a56ed5b684f684d-20261102
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 322983919; Mon, 02 Nov 2026 20:25:40 +0800
From: Song Hu <husong@kylinos.cn>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: tj@kernel.org,
	tjmercier@google.com,
	ddrokosov@salutedevices.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 1/4] samples/cgroup: fix poll error handling in memcg_event_listener
Date: Mon,  2 Nov 2026 20:25:25 +0800
Message-ID: <20261102122528.1498193-2-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102122528.1498193-1-husong@kylinos.cn>
References: <20261102122528.1498193-1-husong@kylinos.cn>
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

The poll error guard tests "errno != EAGAIN", an error poll() never
reports.  The one benign failure the loop does hit is an interrupted
poll (EINTR) when a signal arrives; with this guard the listener
exits via err() instead of resuming.

Continue on EINTR and only bail out on real errors.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 samples/cgroup/memcg_event_listener.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/samples/cgroup/memcg_event_listener.c b/samples/cgroup/memcg_event_listener.c
index 41425edbd88a..ec7c03fa7887 100644
--- a/samples/cgroup/memcg_event_listener.c
+++ b/samples/cgroup/memcg_event_listener.c
@@ -234,8 +234,11 @@ static void monitor_events(struct memcg_events *events)
 
 	for (;;) {
 		ret = poll(fds, ARRAY_SIZE(fds), -1);
-		if (ret < 0 && errno != EAGAIN)
-			err(EXIT_FAILURE, "Can't poll memcg events (%d)", ret);
+		if (ret < 0) {
+			if (errno == EINTR)
+				continue;
+			err(EXIT_FAILURE, "Can't poll memcg events");
+		}
 
 		if (fds[0].revents & POLLERR)
 			err(EXIT_FAILURE, "Got POLLERR during monitor events");
-- 
2.53.0

