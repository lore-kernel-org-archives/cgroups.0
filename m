Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770266;
	b=OQKFHdCenCu1HV9U6fOv1LAxPU+ltqFSHwr3sqb4KzZkpImrzJDFFOOsRIEZEOp7m6uu
	 s/8PGVKuZWNZ70fkdob17OfiqVce+Qt8HphPXCJOPmmCC/FequFTEiLRN+8LygxNtNDvs
	 //eBh+G643k616Pn3cgJJ2aVyFv2e/jv/EanFZ8H7Db5hJRkRrA0sZMTx6Ay2oi3UmBMb
	 Os54cd/eHBqoXLN7NXa9p6RzhZKpoTx9imU9Zq8HIywkOo2OVKRvMCCgLRwJLxIhvyXKZ
	 ZiRGjhpqWCnJBGldBBxtigcclt5NAio3mLma9UGxf67DpARWKoNMTmdDa0qLNxB0JaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770266;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Cl+0jXGFWVsq2Q/pJnbTR+X0LiDZPA8pH1tuLmYf+54=;
	b=18ba8otQFdONyvmeha4hVbdIHDo65OSQaSJMPH+dULxVVilbxU/D1Qp+8F7jKgWt9T/D
	 lOm17Un+n2/8GVlZYB5cwGSjCXKtXgKIXYJqxfw1Ga4hhmDL5VPulW5HCghfDow8EfpJl
	 MHtCUMm1v+xr03pDSaw29frmt6PMSfoWmebSEcWx2o5nQcsOqPfQoKmYyIh7Kd6gIwny6
	 uhPzqqc8Kbme0K/RDNQ18mqLZWoNDHqBtB3q+PrC1heZ0m+95XWJxG7ZFsvUXs8ghT0aV
	 SgPoN4Gx5YbNZ6bgAkuRVtU6llmY3vKgMbkmaDfBXdYSIGt1UMSi+WfQX1mOCqH1kDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93727606A334;
	Fri, 27 Nov 2026 09:04:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93727606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 840e4c98ea4111f19a56ed5b684f684d-20261127
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:5fe1450d-d965-41cb-bdc2-3ec61e54416d,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:5fe1450d-d965-41cb-bdc2-3ec61e54416d,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:8db16c2b2a8aed48d356be515fd4f0f8,BulkI
	D:261127170418Q51N47MI,BulkQuantity:0,SF:17|19|38|66|78|102|127|153|850|86
	5|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 840e4c98ea4111f19a56ed5b684f684d-20261127
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.104.39.167)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 841913415; Fri, 27 Nov 2026 17:04:13 +0800
From: Zhe Liu <liuzhe1@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	Zhe Liu <liuzhe1@kylinos.cn>
Subject: [PATCH] blk-iolatency: remove stale latency samples when a group goes offline
Date: Fri, 27 Nov 2026 17:03:58 +0800
Message-Id: <20261127090358.749096-1-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
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

Each iolatency group tracks its last contribution to the parent's
nr_samples so that subsequent latency checks can replace it. However,
this contribution is not removed when the group goes offline.

Repeatedly creating and removing cgroups can therefore inflate the
sample threshold used by check_scale_change(), causing active groups
to incorrectly skip queue-depth reductions and weakening latency
protection for their peers.

Remove the group's contribution from the parent's nr_samples and clear
its own nr_samples under the parent's child_lat.lock in
iolatency_pd_offline().

Recheck min_lat_nsec under the same lock in iolatency_check_latencies()
to prevent an in-flight bio completion from adding samples back after
the offline cleanup.

Tested on next-20261126 in an x86_64 QEMU guest with
cgroup v2 and null_blk.

After 10 cycles in each run of creating a child cgroup with a latency
target, issuing direct reads and removing it, the unpatched parent
retained 973 and 814 stale samples in two runs. With the patch, the
parent's sample count matched the surviving child's contribution
after every removal.

In a scale-down test, a competing sibling contributed 11 samples
while the protected group missed its target. Without the patch, the
parent had 880 samples, the threshold was 44 and the sibling remained
at depth=max. With the patch, the parent had 128 samples, the threshold
was 6 and the sibling's depth dropped to 32.

Removing a child with an in-flight read also left no stale samples
after I/O completion with the patch. The completion observed a
cleared latency target in this test.

Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---

 block/blk-iolatency.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index a3bd153c67be..44e5015d2295 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -547,6 +547,10 @@ static void iolatency_check_latencies(struct iolatency_grp *iolat, u64 now)
 	/* Somebody beat us to the punch, just bail. */
 	spin_lock_irqsave(&lat_info->lock, flags);
 
+	/* An in-flight bio may complete after the group went offline. */
+	if (!iolat->min_lat_nsec)
+		goto out;
+
 	latency_stat_sum(iolat, &iolat->cur_stat, &stat);
 	lat_info->nr_samples -= iolat->nr_samples;
 	lat_info->nr_samples += latency_stat_samples(iolat, &iolat->cur_stat);
@@ -1028,9 +1032,18 @@ static void iolatency_pd_offline(struct blkg_policy_data *pd)
 {
 	struct iolatency_grp *iolat = pd_to_lat(pd);
 	struct blkcg_gq *blkg = lat_to_blkg(iolat);
+	struct iolatency_grp *parent = blkg_to_lat(blkg->parent);
+	unsigned long flags;
 
 	iolatency_set_min_lat_nsec(blkg, 0);
 	iolatency_clear_scaling(blkg);
+
+	if (parent) {
+		spin_lock_irqsave(&parent->child_lat.lock, flags);
+		parent->child_lat.nr_samples -= iolat->nr_samples;
+		iolat->nr_samples = 0;
+		spin_unlock_irqrestore(&parent->child_lat.lock, flags);
+	}
 }
 
 static void iolat_release(struct rcu_head *rcu)

base-commit: a9c48428cbd8d96b26f92631d0db6f8519c5fcc5
