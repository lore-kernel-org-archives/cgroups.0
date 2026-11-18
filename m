Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795007172;
	b=qCElsCyfv4xjYBG9BQLYfnHDyZSYzpL91dXN+6CLBqIxqvIIniMWXfxYAZw19NgGwnV9
	 VvlQFigtF0zwkTrPlwjRRDTy8td755za2dtUYl9V3KwR29sk4iuMy0GR0PVtBTVMgRIEZ
	 uBds2q0tM67LdwkcnNBoFz2RsHiHeajDssFetYR0U4uy1/mlQ3cFs/2uWHRIvxCV40lRx
	 +uHIXvVp0aM6NS6bP5AwFoM3BJ2Zf2L3avo7ZySNvE1he6BC9r2+CxSQeBy44F8D5tJXj
	 v0zapEY4/hHUHuQc3AA+uqh2DnLHn/+ZshK3Elit13rRx8w8XLiInyuyi9k2M/OgHag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007172;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=rKaTjTFeBLCTJ4hjz/H9hyLaFlLhjnai2pRctEyKKYk=;
	b=nQgauPbBV+2wteqcU/VNCENsnI7bw3cfl2T+pbvtEpXCHdQZS/dJE7Cg5GVaCiDS49JF
	 9nDxNPgBNdqdZMRfFIsqTP3VfGgq40gLmNH4eUMfCE0WBGyRLMhal2vi2M7OxAvOhNbOV
	 ANfCWgEMXZLS1dyYGz4vLa1g0U7M1zFoPT/+A+vqpknyNtNxtXExiXkJ1rmF0KJb7sd2u
	 0h3waZifKnd4wlOYSiGAzTWNDY8MxC81hrx5d1be/jE5Bw9ZZ0z+TxGB6UvjrzoKIGrqY
	 5mGzXOITbxXnA5oA1RRaqhKz9goQUoJ1AFw/p3i+6JjpYKLhpctwItUa5uQ3fKqYu9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64446606A332;
	Wed, 18 Nov 2026 13:06:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64446606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: cb91cdbce35011f19a56ed5b684f684d-20261118
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_LOWREP
	SA_EXISTED, SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:eb10f8cb-6cb6-4f11-91a6-58294a490a92,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:eb10f8cb-6cb6-4f11-91a6-58294a490a92,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:34c319f315fd5a0be9fdc1968f548338,BulkI
	D:26111821060005H9O1QJ,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|153|
	865|898,TC:nil,Content:0|15|50|99,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:n
	il,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cb91cdbce35011f19a56ed5b684f684d-20261118
X-User: yumiao@kylinos.cn
Received: from kylinos.cn [(39.156.73.11)] by mailgw.kylinos.cn
	(envelope-from <yumiao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 102452584; Wed, 18 Nov 2026 21:05:57 +0800
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
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	jiayuan.chen@shopee.com,
	nphamcs@gmail.com,
	Yu Miao <yumiao@kylinos.cn>
Subject: [PATCH v2] Docs/admin-guide/cgroup-v2: fix npn tags in memory.stat
Date: Wed, 18 Nov 2026 21:05:37 +0800
Message-ID: <20261118130537.750211-1-yumiao@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117062620.346767-1-yumiao@kylinos.cn>
References: <20261117062620.346767-1-yumiao@kylinos.cn>
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

The zswap, zswapped, zswap_incomp, swpin_zero, swpout_zero, zswpin,
zswpout and zswpwb entries never show up in memory.numa_stat, so add
the 'npn' tag to them.  The pgscan_kswapd, pgscan_direct,
pgscan_khugepaged, pgscan_proactive, pgsteal_kswapd, pgsteal_direct,
pgsteal_khugepaged, pgsteal_proactive and pgrefill entries do show up
in memory.numa_stat since commit e4f4fc7aa8b7 ("mm: move pgscan,
pgsteal, pgrefill to node stats"), so remove their 'npn' tag.
Also move zswap_incomp, currently listed between the zswpwb and
thp_fault_alloc counters, next to the zswap and zswapped entries
it belongs with.

Signed-off-by: Yu Miao <yumiao@kylinos.cn>
---

Changes in v2 (per Tejun's review):
- Add the tag to swpin_zero, swpout_zero, zswpin, zswpout and zswpwb.
- Remove the tag from pgscan_kswapd, pgscan_direct, pgscan_khugepaged,
  pgscan_proactive, pgsteal_kswapd, pgsteal_direct, pgsteal_khugepaged,
  pgsteal_proactive and pgrefill, which have been in memory.numa_stat
  since commit e4f4fc7aa8b7 ("mm: move pgscan, pgsteal, pgrefill to
  node stats").
- Repost via -mm with Andrew Morton and linux-mm@kvack.org cc'ed.

 Documentation/admin-guide/cgroup-v2.rst | 43 +++++++++++++------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..a50ce3c833c0 100644
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
@@ -1702,28 +1708,28 @@ The following nested keys are defined.
 	  pgsteal (npn)
 		Amount of reclaimed pages
 
-	  pgscan_kswapd (npn)
+	  pgscan_kswapd
 		Amount of scanned pages by kswapd (in an inactive LRU list)
 
-	  pgscan_direct (npn)
+	  pgscan_direct
 		Amount of scanned pages directly  (in an inactive LRU list)
 
-	  pgscan_khugepaged (npn)
+	  pgscan_khugepaged
 		Amount of scanned pages by khugepaged  (in an inactive LRU list)
 
-	  pgscan_proactive (npn)
+	  pgscan_proactive
 		Amount of scanned pages proactively (in an inactive LRU list)
 
-	  pgsteal_kswapd (npn)
+	  pgsteal_kswapd
 		Amount of reclaimed pages by kswapd
 
-	  pgsteal_direct (npn)
+	  pgsteal_direct
 		Amount of reclaimed pages directly
 
-	  pgsteal_khugepaged (npn)
+	  pgsteal_khugepaged
 		Amount of reclaimed pages by khugepaged
 
-	  pgsteal_proactive (npn)
+	  pgsteal_proactive
 		Amount of reclaimed pages proactively
 
 	  pgfault (npn)
@@ -1732,7 +1738,7 @@ The following nested keys are defined.
 	  pgmajfault (npn)
 		Number of major page faults incurred
 
-	  pgrefill (npn)
+	  pgrefill
 		Amount of scanned pages (in an active LRU list)
 
 	  pgactivate (npn)
@@ -1747,29 +1753,24 @@ The following nested keys are defined.
 	  pglazyfreed (npn)
 		Amount of reclaimed lazyfree pages
 
-	  swpin_zero
+	  swpin_zero (npn)
 		Number of pages swapped into memory and filled with zero, where I/O
 		was optimized out because the page content was detected to be zero
 		during swapout.
 
-	  swpout_zero
+	  swpout_zero (npn)
 		Number of zero-filled pages swapped out with I/O skipped due to the
 		content being detected as zero.
 
-	  zswpin
+	  zswpin (npn)
 		Number of pages moved in to memory from zswap.
 
-	  zswpout
+	  zswpout (npn)
 		Number of pages moved out of memory to zswap.
 
-	  zswpwb
+	  zswpwb (npn)
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

