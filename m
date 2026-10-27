Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090077;
	b=1IQd3nMgtRQB8uP4RcScx3rfoq+B0FOlp4ZRSFPbgiWPFr1vJBUeZE/qTE3AW+HmrcM9
	 at2s9N9bQ5BuCy4KF18OM+lziY/41/E4vyZmV9X0yw5f5vSWLkTAIx1rogdnfXha8ZXMO
	 nHQ1Jn1fikSMQMvUjYCH6h3oYFdQTSkVxQZgLQheVCdbR8qOlehLcleiXBpBVHra5445o
	 jzIkSGjfmrrJEEvlHUGdIsoOAPXXnUatNpe8/r2XkKj7y9BDB4uOwg/TVtqiZlvOuthHN
	 UWkU6miOvGKvT/yfoudmavHkQ8/bEyM7ooRRSe3zYIq6x5ZDj6+Qzn+upihkYxY+sIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090077;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UU2IRJHJWcOG1Zl2ASPC5KKLoKp7LnHivsfxFBY8zhU=;
	b=huzZhjnVeOI/U4/S9hQf+O5wOY6cJIYk2omft23zxOWGdIdvsVt/gP97gOdRl9qu6Ffe
	 W6fSuBXdky3/xVXfBACGHwZuqHrdbmeX4CawKxXuWxc/lmIqCYYI+qamEh28tS1uKNhhR
	 ffiZKJjmguDBzzCbUXq0U9aQu3XCVKajkP7b+6WxWmCY4Tx+RhtGF4VHKvXH3K/8o3t9v
	 YVasRyRxOsacly869ClETjhc0O5IDLPbGNaayoNkof11qZKC058CErgDS/vkFqkPGt6SD
	 g+VGI3w/1FmfI6Ld8on5wSVtKnx8SxT20R80Pwyge0XkG9G/9RYh96xlvFjmgd+ijBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0244C606A327;
	Tue, 27 Oct 2026 08:34:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0244C606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 38961f5cd1e111f19a56ed5b684f684d-20261027
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
X-CID-O-INFO: VERSION:1.3.19,REQID:8118a2e7-8bb5-472d-a1c6-44cf4c022dd5,IP:20,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.3.19,REQID:8118a2e7-8bb5-472d-a1c6-44cf4c022dd5,IP:20,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:50c03a1732b74deda5bb4e8310771fb3,BulkI
	D:261027163429LDR9HYVY,BulkQuantity:0,SF:17|19|38|66|78|102|127|850|865|89
	8,TC:nil,Content:0|15|50|99|100|102|153,EDM:-3,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 38961f5cd1e111f19a56ed5b684f684d-20261027
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1638462346; Tue, 27 Oct 2026 16:34:27 +0800
From: Zhe Liu <liuzhe1@kylinos.cn>
To: tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhe Liu <liuzhe1@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] blk-iocost: validate weights before narrowing to u32
Date: Tue, 27 Oct 2026 16:34:10 +0800
Message-Id: <20261027083410.704150-1-liuzhe1@kylinos.cn>
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

ioc_weight_write() parses io.weight into a u32 with sscanf("%u")
and range-checks the result afterwards.  vsscanf() truncates
out-of-range values modulo 2^32 without reporting an error, so the
check only sees the truncated residue: writing "default 4294967297"
(2^32+1) is accepted as weight 1 instead of being rejected with
-EINVAL, leaving the cgroup with the lowest possible weight.  The
per-device override path has the same problem.

Parse into a u64 with %llu in both paths so the range check runs on
the true value.  Out-of-range writes now fail with -EINVAL and leave
the configuration untouched; weights that pass the check still fit
in the u32 fields as before.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org
Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---
 block/blk-iocost.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index a81488c755ca..2ae40138e041 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3170,13 +3170,13 @@ static ssize_t ioc_weight_write(struct kernfs_open_file *of, char *buf,
 	struct blkg_conf_ctx ctx;
 	struct ioc_now now;
 	struct ioc_gq *iocg;
-	u32 v;
+	u64 v;
 	int ret;
 
 	if (!strchr(buf, ':')) {
 		struct blkcg_gq *blkg;
 
-		if (!sscanf(buf, "default %u", &v) && !sscanf(buf, "%u", &v))
+		if (!sscanf(buf, "default %llu", &v) && !sscanf(buf, "%llu", &v))
 			return -EINVAL;
 
 		if (v < CGROUP_WEIGHT_MIN || v > CGROUP_WEIGHT_MAX)
@@ -3216,7 +3216,7 @@ static ssize_t ioc_weight_write(struct kernfs_open_file *of, char *buf,
 	if (!strncmp(ctx.body, "default", 7)) {
 		v = 0;
 	} else {
-		if (!sscanf(ctx.body, "%u", &v))
+		if (!sscanf(ctx.body, "%llu", &v))
 			goto unprep;
 		if (v < CGROUP_WEIGHT_MIN || v > CGROUP_WEIGHT_MAX)
 			goto unprep;
-- 
2.25.1

