Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A811C25A655
	for <cgroups@vger.kernel.org>; Tue, 14 Apr 2026 02:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776132598; cv=none; b=b8rcdQMkJYRFSjGEIImH6MxlGyktxzqI2RMWYco7yGPgfipnzP0JfJ4zCZubGI6D7qJ2CXaH5dnBUCeeRRt/j0CE98fIPPdPSXgqaNFWSKt07JDzXcVt1yUfmca2Pek1tJIfmhKhStqGB1N1WdotlP0EqxDDQW+UDDkGYIXTn54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776132598; c=relaxed/simple;
	bh=EJQGbDDzDdino+H+wzFpiGIX28dFonQV9OSxVU2X04s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tzj4zQIwDut6FmuhXulih/283DDL2CpVwtepQQt8Lju90fwCI4Z3Q/uXUL2B53adgQppNJ892N0NPK41w8vUFqjb5OLLyQ1NviKA2V84d4aRDNNWNwNJRUQEAaXaCV0xwVtsXw3nQQTkt9TZY0l5lYzd+KCSq7wpCDgQMOtc4Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 03df8d8637a711f1aa26b74ffac11d73-20260414
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:b052ef2d-135d-49f0-93c7-e34d3a4f540a,IP:10,
	URL:0,TC:0,Content:-5,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:-25
X-CID-INFO: VERSION:1.3.12,REQID:b052ef2d-135d-49f0-93c7-e34d3a4f540a,IP:10,UR
	L:0,TC:0,Content:-5,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:NOTI_GNA5D1EA,AC
	TION:release,TS:-25
X-CID-META: VersionHash:e7bac3a,CLOUDID:866d8817ce58dea65a14802830a852da,BulkI
	D:260414100952WZ7VN0XR,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	898,TC:nil,Content:0|15|50,EDM:2,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 03df8d8637a711f1aa26b74ffac11d73-20260414
X-User: cuitao@kylinos.cn
Received: from ctao-book.. [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <cuitao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1044644135; Tue, 14 Apr 2026 10:09:48 +0800
From: cuitao <cuitao@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org
Cc: cuitao <cuitao@kylinos.cn>
Subject: [PATCH] cgroup/rdma: fix strncmp prefix match in parse_resource()
Date: Tue, 14 Apr 2026 10:09:36 +0800
Message-ID: <20260414020936.306853-1-cuitao@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_resource() used strncmp(value, "max", strlen(value)) to match the
"max" keyword. Since strlen(value) is the comparison length, prefixes
like "ma" or "m" are incorrectly accepted as "max".

Fix by replacing strncmp with strcmp for exact matching and remove the
now unused `len` variable.

Signed-off-by: cuitao <cuitao@kylinos.cn>
---
 kernel/cgroup/rdma.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/rdma.c b/kernel/cgroup/rdma.c
index 09258eebb5c7..81e278348dad 100644
--- a/kernel/cgroup/rdma.c
+++ b/kernel/cgroup/rdma.c
@@ -359,7 +359,6 @@ static int parse_resource(char *c, int *intval)
 {
 	substring_t argstr;
 	char *name, *value = c;
-	size_t len;
 	int ret, i;
 
 	name = strsep(&value, "=");
@@ -370,10 +369,8 @@ static int parse_resource(char *c, int *intval)
 	if (i < 0)
 		return i;
 
-	len = strlen(value);
-
 	argstr.from = value;
-	argstr.to = value + len;
+	argstr.to = value + strlen(value);
 
 	ret = match_int(&argstr, intval);
 	if (ret >= 0) {
@@ -381,7 +378,7 @@ static int parse_resource(char *c, int *intval)
 			return -EINVAL;
 		return i;
 	}
-	if (strncmp(value, RDMACG_MAX_STR, len) == 0) {
+	if (strcmp(value, RDMACG_MAX_STR) == 0) {
 		*intval = S32_MAX;
 		return i;
 	}
-- 
2.43.0

