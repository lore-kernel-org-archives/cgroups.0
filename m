Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343621;
	b=AXDocvr2/GyBgQTS5OQg9H6te9wvzgAJbBz6EsIN+dfFwX30Ugj3t63fsz1pcb4boOtk
	 ywGyBqAaeFXzcLfKDhVeonLMi9PGjZlbt8FhnWiumnIv3iNNqhD57ObPrPr2NDnSpaCGM
	 vm2WucC3ZyNlKuQ/kIvMHSzJnivR90W7OyFoW96jnmyDUWJvL9ss3K5nhM3SrHHPwdlTP
	 1Y0yC+hhd49AploI3TxG/cnUBbYSrCzcNV2lkfPEMEJ9j0yUJ1nE4VxBpde7IGAxrGuT0
	 7qRPMCuH4o2x6Fp/wjJmiOZrjlVSkStjEaBihWMugKGH9avaVDFYBTs7Liw2xvyLWTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343621;
	h=DMARC-Filter:X-Alimail-AntiSpam:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=c1KUTFXJRG20zAcsRXPCs0ypeU30Jo1z4y8WB1+Vr88=;
	b=LLEsSxnNmGj/9PHDxzF3Qi+xiq3waWkFNDmySxUCDw2kcDcVUlzn7NTO/QURDkzo9z+9
	 baSfAdfYWNVeGKciUT/8bsbc3sZD1d8JWBicV3NSveoheGwvphhoME1zQxqGqLEEI1SLS
	 lJ5WlwO38MAMnOWrR7X/E+fUtveCs4hN1+nbDFX0lUqgfvZPUHRLh/yNeXMp+S7oLdzVV
	 yenMA8Tb0tsAfUPpdO/fMs+xd8gSBQJwjaqBXsaJyZGDGExUCA2z0/hVQSVRNsO3W8GMl
	 3nlhGOY45HWmmsXFViqaRtXbQf/dOxJwLNSQsWMGtBFipXo0sfrOOkmHZQS7r3LqUeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=open-hieco.net;
	spf=pass smtp.mailfrom=open-hieco.net;
	arc=none smtp.remote-ip=115.124.28.219
Received: from out28-219.mail.aliyun.com (out28-219.mail.aliyun.com [115.124.28.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EAB606A31D;
	Fri, 30 Oct 2026 07:00:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9EAB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=open-hieco.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=open-hieco.net
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.08029933|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.045024-0.000431324-0.954545;FP=10141084982285544551|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam011083032240;MF=likunyu@open-hieco.net;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.jstcx3k_1793343611;
Received: from localhost.localdomain(mailfrom:likunyu@open-hieco.net fp:SMTPD_---.jstcx3k_1793343611 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 30 Oct 2026 15:00:15 +0800
From: Li kunyu <likunyu@open-hieco.net>
To: axboe@kernel.dk,
	tj@kernel.org,
	josef@toxicpanda.com
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li kunyu <likunyu@open-hieco.net>
Subject: [PATCH 2/2] block/blk-iolatency: Fix inflight decrement for chained bio sub-bios
Date: Fri, 30 Oct 2026 14:59:45 +0800
Message-ID: <20261030065945.88742-3-likunyu@open-hieco.net>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261030065945.88742-1-likunyu@open-hieco.net>
References: <20261030065945.88742-1-likunyu@open-hieco.net>
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

Implement the blkcg_iolatency_done_split_bio callback in blk-iolatency to
correctly decrement the inflight count when the remaining bio headers
complete, excluding the one for which atomic_dec_and_test(&bio->
__bi_remaining) is true.

Signed-off-by: Li kunyu <likunyu@open-hieco.net>
---
 block/blk-iolatency.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 2caa79a008ad..e1ef3bb10572 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -632,6 +632,47 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	}
 }
 
+static void blkcg_iolatency_done_split_bio(struct rq_qos *rqos, struct bio *bio)
+{
+	struct blkcg_gq *blkg;
+	struct rq_wait *rqw;
+	struct iolatency_grp *iolat;
+	int inflight = 0;
+
+	blkg = bio->bi_blkg;
+	if (!blkg || !bio_flagged(bio, BIO_QOS_THROTTLED) ||
+	    !bio_flagged(bio, BIO_QOS_CHAIN_CHILD))
+		return;
+
+	iolat = blkg_to_lat(bio->bi_blkg);
+	if (!iolat)
+		return;
+
+	if (!iolat->blkiolat->enabled)
+		return;
+
+	while (blkg && blkg->parent) {
+		iolat = blkg_to_lat(blkg);
+		if (!iolat) {
+			blkg = blkg->parent;
+			continue;
+		}
+		rqw = &iolat->rq_wait;
+
+		inflight = atomic_dec_return(&rqw->inflight);
+		WARN_ON_ONCE(inflight < 0);
+
+		/*
+		 * iolat->min_lat_nsec and other window-time equivalents
+		 * are not calculated here; they are calculated only when
+		 * blkcg_iolatency_done_bio() is called at the end of the
+		 * bio header.
+		 */
+		wake_up(&rqw->wait);
+		blkg = blkg->parent;
+	}
+}
+
 static void blkcg_iolatency_exit(struct rq_qos *rqos)
 {
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
@@ -645,6 +686,7 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
 static const struct rq_qos_ops blkcg_iolatency_ops = {
 	.throttle = blkcg_iolatency_throttle,
 	.done_bio = blkcg_iolatency_done_bio,
+	.done_split_bio = blkcg_iolatency_done_split_bio,
 	.exit = blkcg_iolatency_exit,
 };
 
-- 
2.47.3

