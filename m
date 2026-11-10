Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306784;
	b=iKby86NSr+OqXCHSPEPnV75zrh6iUZkTYlRsxZMm9otF69OziQ6iFxwn8hhdwkMuLyh2
	 G8oLQNEWCUdfQnMYO7ozxvNIYm7NmV8kLpWi0gGXw85wcVqpCDOEcTR+dNS0iaTMfchIz
	 UN3KHOPq/TzpsFuZcZab3I58qrUeN1xFn3KduI4I9mCdjk5Xu8gDlRe9jPdB3NihmE0MW
	 fpCK0xN6TT0Xr1goc2p5ybaZUFcdy8Xs98HTI+ARQBzhzGwXEho07sGnb+QvPe5VbcHsM
	 smsvYWkchTDsitRRZZkwW2Cw0OjXCIGgpaANDappshNkMnsgb3amtSZMt+fPSIKFhFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306784;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=1esiKew9Kf5TdFkOZuL2gNQgmtiuW4sLpwZ5+tozEFM=;
	b=efVsMbu0drHDvIEUWheT1rY8+nuCYf7mfO0ay/sLAyRjIuCAuAQ5ekx8CYm3yDy0UouG
	 YYyrOCYmHm0iXoM+ANfpZgz3R/2jbNbSnw9KaRtTEcfF48tAGUAfJZ5NKAPlLoJ5lkLoI
	 IG6IimWzjoCTZnQf++LgAb8/J8Iirzltszv9TC1144SgFtuQXee/v8fzTva23Vf8vxOeN
	 PQLbr4Y4GP2sP6t2x2me3e0sPDnPQLUqGHTEGFRewh87xgTmsa3HIzp7/pc0p27BU6Cm1
	 mjTIL/fFkgsJF/aQx+dl0XRaEuRIREeFOTNe0Vxs8qTloH/dItFjuE2+LqaZrE0mFbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B13606A332;
	Tue, 10 Nov 2026 10:33:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00B13606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 15c8d2bedcf211f19a56ed5b684f684d-20261110
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:1a293c53-9673-4b91-ac18-ef98a3b68ccc,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:1a293c53-9673-4b91-ac18-ef98a3b68ccc,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:25faa09c7e82dc7887a3db5e65bd8bf2,BulkI
	D:261110183256F07CCLLB,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|136|
	153|850|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,
	DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 15c8d2bedcf211f19a56ed5b684f684d-20261110
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 607355249; Tue, 10 Nov 2026 18:32:53 +0800
From: Zhe Liu <liuzhe1@kylinos.cn>
To: axboe@kernel.dk,
	tj@kernel.org,
	josef@toxicpanda.com
Cc: yukuai@fygo.io,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Zhe Liu <liuzhe1@kylinos.cn>
Subject: [PATCH 3/3] blkcg: account cgroup v1 I/O before checking throttle activation
Date: Tue, 10 Nov 2026 18:32:01 +0800
Message-Id: <20261110103201.762861-4-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110103201.762861-1-liuzhe1@kylinos.cn>
References: <20261110103201.762861-1-liuzhe1@kylinos.cn>
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

Commit a3166c51702b ("blk-throttle: delay initialization until
configuration") made throttle policy activation conditional on
configuring a limit. However, blk_should_throtl() returns before
updating the v1 counters when the policy is inactive. A cgroup v1
workload that only monitors I/O therefore gets no accounting until a
limit is configured on the device.

Now that the counters belong to the blkg, move their updates out of
blk_should_throtl() and account immediately before blk_throtl_bio() in
both submit_bio_noacct() and bio_submit_split_bioset(). This records I/O
even when the throttle policy has never been activated.

Keep BIO_CGROUP_ACCT byte deduplication and count each split-remainder
submission as an I/O. Throttle worker dispatch continues to use the
nocheck submission path, avoiding a second accounting update. The
inline hierarchy check skips v1 accounting on cgroup v2.

Fixes: a3166c51702b ("blk-throttle: delay initialization until configuration")
Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---
 block/blk-core.c     | 1 +
 block/blk-merge.c    | 9 ++++++---
 block/blk-throttle.h | 1 -
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8836c7028568..013d806efb43 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -924,6 +924,7 @@ void submit_bio_noacct(struct bio *bio)
 		goto not_supported;
 	}
 
+	blkcg_account_v1_bio(bio);
 	if (blk_throtl_bio(bio))
 		return;
 	submit_bio_noacct_nocheck(bio, false);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 501ddc01c449..8bc996002646 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -131,10 +131,13 @@ struct bio *bio_submit_split_bioset(struct bio *bio, unsigned int split_sectors,
 	trace_block_split(split, bio->bi_iter.bi_sector);
 	WARN_ON_ONCE(bio_zone_write_plugging(bio));
 
-	if (should_fail_bio(bio))
+	if (should_fail_bio(bio)) {
 		bio_io_error(bio);
-	else if (!blk_throtl_bio(bio))
-		submit_bio_noacct_nocheck(bio, true);
+	} else {
+		blkcg_account_v1_bio(bio);
+		if (!blk_throtl_bio(bio))
+			submit_bio_noacct_nocheck(bio, true);
+	}
 
 	return split;
 }
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 02c08daf3dc3..73f0d4bbdc71 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -170,7 +170,6 @@ static inline bool blk_should_throtl(struct bio *bio)
 		return false;
 
 	tg = blkg_to_tg(bio->bi_blkg);
-	blkcg_account_v1_bio(bio);
 
 	/* iops limit is always counted */
 	if (tg->has_rules_iops[rw])
-- 
2.25.1

