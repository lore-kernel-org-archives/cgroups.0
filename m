Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794896817;
	b=Bllg2+j+9jem6s248yUjivQHf6otqenlQYK6AXlFy6o4HKRtzdZ2NTrdyTfst5vQxmcA
	 1IezwaNnMM58B1F0gBaH59PUcrz0WwJU3X4pcXhw6bXiTX+UkJpbXSSRptG+Ny/RpO0jM
	 RLMdgFoyZz/iH4liiAuueEOdNbtKHza4WgBSzOB3ur9cuHnbtmPPr5n7PYD3/mvL8L4aJ
	 kzZ9Cyv/frUPHsvfOIVWhjJiBjODlOCbV8FwDBIy7sVq1rApcUOsBkY9koctxbo8WX4JR
	 CVdAvGHILtaE8QVMAtNLtaZ2naSksL5nEK2jPiuMZO26esg1nCE8XF0xKR0N9cbBaeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794896817;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zHwZTRyJcBmNm9HrK6+bkhzSPesMy8LyuWBdlQWUWI0=;
	b=ws0wB4RT5wW8ApmtwgTVknAbDOwrRcMeZYfT62/VjagxHkPiI69ML/b7mUm6ObTQba+8
	 s4pSCtWdCUhDf5QHIaZbp/Glr/iASsXxf+vCZQoH6u6z295EjlgGcjiWqx1Vgwxbbs5eJ
	 ApvVPZESUguhIKSPkoPysBK/+GE/wT5jSZ+1JUUhqJ0+20O+9IpdczIsX2qWDB/niUP01
	 +b5fjXFNHWCGf6zHEc0iEbvqcGpAQmrMhDTlS9sNjNPTx3Tnl+zd/3uzZHLaPrZ2btlwl
	 E+OhxVGCKE0yTfd1xp3Tm1fPAcJ64JrW8JJb6T75vDaYi5bmUsiy7/iWCnH1WFWCAnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6AC606A31C;
	Tue, 17 Nov 2026 06:26:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E6AC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: dc784252e24f11f19a56ed5b684f684d-20261117
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_LOWREP
	SA_EXISTED, SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:1d7932d1-1a0d-41c8-954b-034d9213316c,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:1d7932d1-1a0d-41c8-954b-034d9213316c,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:b662959fe0d3c8d2f6a5fe0e09797485,BulkI
	D:261117141047PSRW0JV4,BulkQuantity:1,SF:17|19|38|66|78|102|127|153|865|89
	8,TC:nil,Content:0|15|50|99,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dc784252e24f11f19a56ed5b684f684d-20261117
X-User: yumiao@kylinos.cn
Received: from kylinos.cn [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <yumiao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2132674618; Tue, 17 Nov 2026 14:26:45 +0800
From: Yu Miao <yumiao@kylinos.cn>
To: cgroups@vger.kernel.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: jiayuan.chen@shopee.com,
	nphamcs@gmail.com,
	Yu Miao <yumiao@kylinos.cn>
Subject: [PATCH] Docs/admin-guide/cgroup-v2: add missing npn tags to zswap stats
Date: Tue, 17 Nov 2026 14:26:20 +0800
Message-ID: <20261117062620.346767-1-yumiao@kylinos.cn>
X-Mailer: git-send-email 2.43.0
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

The zswap, zswapped and zswap_incomp entries never show up in
memory.numa_stat, so add the 'npn' tag to all three.  Also move
zswap_incomp, currently listed between the zswpwb and thp_fault_alloc
counters, next to the zswap and zswapped entries it belongs with.

Signed-off-by: Yu Miao <yumiao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..3f698f109d89 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1608,12 +1608,18 @@ The following nested keys are defined.
 		Amount of cached filesystem data that is swap-backed,
 		such as tmpfs, shm segments, shared anonymous mmap()s
 
-	  zswap
+	  zswap (npn)
 		Amount of memory consumed by the zswap compression backend.
 
-	  zswapped
+	  zswapped (npn)
 		Amount of application memory swapped out to zswap.
 
+	  zswap_incomp (npn)
+		Amount of memory used by incompressible pages currently
+		stored in zswap without compression. These pages could not
+		be compressed to a size smaller than PAGE_SIZE, so they are
+		stored as-is.
+
 	  file_mapped
 		Amount of cached filesystem data mapped with mmap(). Note
 		that some kernel configurations might account complete
@@ -1765,11 +1771,6 @@ The following nested keys are defined.
 	  zswpwb
 		Number of pages written from zswap to swap.
 
-	  zswap_incomp
-		Amount of memory used by incompressible pages currently stored in zswap
-		without compression. These pages could not be compressed to
-		a size smaller than PAGE_SIZE, so they are stored as-is.
-
 	  thp_fault_alloc (npn)
 		Number of transparent hugepages which were allocated to satisfy
 		a page fault. This counter is not present when CONFIG_TRANSPARENT_HUGEPAGE
-- 
2.43.0

