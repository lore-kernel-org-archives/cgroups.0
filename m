Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306772;
	b=GBmW8zzXPggsb1jIChc9Djc47Ui29BW8CA97/JYkOv0d1COh2ScBij/YlbYohh21dOOM
	 OW29mUzSiA9NdT3axkw9rroCy8kDilvwW5ycm+3+F+/724DhGpWKrC6AfIfM1H5hmYsWw
	 ioavX9pus5S0KO6ftj5I6BcGlEc33p6NbJX3hydL4neJlm2OpfuMlsmHHhTPe+rg5n4IP
	 7e0B75DfzNOdqvXJnXNtldO6yfxCcZRR0a9HHdiWbGkoLqNqXLK9sRom9RGKKkackBOzQ
	 mbDtEJFpCZPZrtOcYKayk/D1iWSmFOV0IT32fBDbUPaqNPjAuq4GwLTjH9JwafqnopA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306772;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=YofW718Ei/kOgJz1IxEpxNDde2F/2qyBvVa7gM8OOgo=;
	b=mejpYJRgOl1QTrV/kmtPd4aK/42/+7QCwDUuOsTjEB3hixZR2p1Zfgjm7le9/ovkZEhK
	 JcZeGaigQVESmd4DErF6Qgw8SyiF0owDqk5blFBKluoxWD8tGrV5ldpm7HxFk9q4WCGeb
	 Gkl0CUzHNZMDvky3v2xYlFL5OBaEDxUyLBKT4m/5EnVKBcb+QP5/VKc9C0dXsoZh4lo8b
	 XC7ECzEXSxLKHOarXHwf2ZQ7oWtj3y4TCQ8NaL8AQ9qRtMG7jRziTKW5dyAmoZ7XrjYB7
	 asJJdjGqHeVQ5mR5dE3r9Rt81YLL7Qtc19eurZQMuZmTtcueIIyy4NnG3AHj4VPPY9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F351606A31C;
	Tue, 10 Nov 2026 10:32:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F351606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0eae7678dcf211f19a56ed5b684f684d-20261110
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
X-CID-O-INFO: VERSION:1.3.19,REQID:0aced988-7dcd-49b1-b93a-07c99ac1a29e,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.19,REQID:0aced988-7dcd-49b1-b93a-07c99ac1a29e,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:7db8b62,CLOUDID:a9fb8514fc75b26edad4bad52e3362e9,BulkI
	D:261110183244XSNP24HZ,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|153|
	850|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0eae7678dcf211f19a56ed5b684f684d-20261110
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1381404826; Tue, 10 Nov 2026 18:32:41 +0800
From: Zhe Liu <liuzhe1@kylinos.cn>
To: axboe@kernel.dk,
	tj@kernel.org,
	josef@toxicpanda.com
Cc: yukuai@fygo.io,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Zhe Liu <liuzhe1@kylinos.cn>
Subject: [PATCH 1/3] blkcg: allow printing rwstat samples without policy data
Date: Tue, 10 Nov 2026 18:31:59 +0800
Message-Id: <20261110103201.762861-2-liuzhe1@kylinos.cn>
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

The existing rwstat formatter takes a blkg_policy_data pointer, although
it only uses it to obtain the associated blkg. This unnecessarily ties
statistics formatting to a policy.

Introduce blkg_print_rwstat() to print rwstat samples directly from a
blkg, allowing cgroup v1 I/O statistics to be reported independently of
the throttle policy.

Keep __blkg_prfill_rwstat() as a wrapper for existing policy users,
including BFQ. The output format and total calculation remain unchanged.

Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---
 block/blk-cgroup-rwstat.c | 18 ++++++++++++------
 block/blk-cgroup-rwstat.h |  2 ++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup-rwstat.c b/block/blk-cgroup-rwstat.c
index 2e9bf081cce2..604d8414dec6 100644
--- a/block/blk-cgroup-rwstat.c
+++ b/block/blk-cgroup-rwstat.c
@@ -26,15 +26,15 @@ void blkg_rwstat_exit(struct blkg_rwstat *rwstat)
 EXPORT_SYMBOL_GPL(blkg_rwstat_exit);
 
 /**
- * __blkg_prfill_rwstat - prfill helper for a blkg_rwstat
+ * blkg_print_rwstat - print a blkg_rwstat sample
  * @sf: seq_file to print to
- * @pd: policy private data of interest
+ * @blkg: block cgroup and queue association
  * @rwstat: rwstat to print
  *
- * Print @rwstat to @sf for the device assocaited with @pd.
+ * Print @rwstat to @sf for the device associated with @blkg.
  */
-u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
-			 const struct blkg_rwstat_sample *rwstat)
+u64 blkg_print_rwstat(struct seq_file *sf, struct blkcg_gq *blkg,
+		      const struct blkg_rwstat_sample *rwstat)
 {
 	static const char *rwstr[] = {
 		[BLKG_RWSTAT_READ]	= "Read",
@@ -43,7 +43,7 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 		[BLKG_RWSTAT_ASYNC]	= "Async",
 		[BLKG_RWSTAT_DISCARD]	= "Discard",
 	};
-	const char *dname = blkg_dev_name(pd->blkg);
+	const char *dname = blkg_dev_name(blkg);
 	u64 v;
 	int i;
 
@@ -60,6 +60,12 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 	seq_printf(sf, "%s Total %llu\n", dname, v);
 	return v;
 }
+
+u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
+			 const struct blkg_rwstat_sample *rwstat)
+{
+	return blkg_print_rwstat(sf, pd->blkg, rwstat);
+}
 EXPORT_SYMBOL_GPL(__blkg_prfill_rwstat);
 
 /**
diff --git a/block/blk-cgroup-rwstat.h b/block/blk-cgroup-rwstat.h
index 703a16fe1404..014ac2a73306 100644
--- a/block/blk-cgroup-rwstat.h
+++ b/block/blk-cgroup-rwstat.h
@@ -41,6 +41,8 @@ static inline u64 blkg_rwstat_read_counter(struct blkg_rwstat *rwstat,
 
 int blkg_rwstat_init(struct blkg_rwstat *rwstat, gfp_t gfp);
 void blkg_rwstat_exit(struct blkg_rwstat *rwstat);
+u64 blkg_print_rwstat(struct seq_file *sf, struct blkcg_gq *blkg,
+		      const struct blkg_rwstat_sample *rwstat);
 u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 			 const struct blkg_rwstat_sample *rwstat);
 u64 blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
-- 
2.25.1

