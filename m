Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368CE2D3A60
	for <cgroups@vger.kernel.org>; Tue, 14 Apr 2026 01:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776131631; cv=none; b=CEbNDkKXvqMsBwKliVLHVZR2q85u+2F6XqlffCcWUytRUzV5R6OaWbImDdzlV7IgzIhTx4TfjmNO+EH9R8lSRnveumPz15zqSp2mCPADws+bnCc4jzJsoOwGBqJ3PgXTk11IJGetmJNS13kxE/AHtcTeqWjBDWobqkSaa0SXr7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776131631; c=relaxed/simple;
	bh=6NmmvwfI4uCGYW6BbgyL0NRG8hR7BaqFNT/jYIULGL8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eylyJHtm6hyiVESD9BxfGL0wzvUPws0YlOr7nIwn9mbVrMIvfCY4hw6USrFtE9ZPCIGcFEZoKbkGEoWATjZ9qX6utgqUb2rs4Ggh1Bshkoa6u0A7+drDI8bsVgVEZg6XdtTNMgUpFK/4LzKozeqGghlzO1ZYce6xqJSeoBxVuvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c2d31f9437a411f1aa26b74ffac11d73-20260414
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
X-CID-O-INFO: VERSION:1.3.12,REQID:59cb6854-abcd-4850-8323-9a7efd5f1b02,IP:10,
	URL:0,TC:0,Content:0,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-20
X-CID-INFO: VERSION:1.3.12,REQID:59cb6854-abcd-4850-8323-9a7efd5f1b02,IP:10,UR
	L:0,TC:0,Content:0,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:NOTI_GNA5D1EA,ACT
	ION:release,TS:-20
X-CID-META: VersionHash:e7bac3a,CLOUDID:5b8a7b0d69af65bc78db49a572846463,BulkI
	D:260414095342KXU5QIJ4,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	898,TC:nil,Content:0|15|50,EDM:2,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c2d31f9437a411f1aa26b74ffac11d73-20260414
X-User: cuitao@kylinos.cn
Received: from ctao-book.. [(183.242.174.23)] by mailgw.kylinos.cn
	(envelope-from <cuitao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 239643313; Tue, 14 Apr 2026 09:53:40 +0800
From: cuitao <cuitao@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org
Cc: cuitao <cuitao@kylinos.cn>
Subject: [PATCH] cgroup/rdma: fix integer overflow in rdmacg_try_charge()
Date: Tue, 14 Apr 2026 09:53:27 +0800
Message-ID: <20260414015327.306721-1-cuitao@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The expression `rpool->resources[index].usage + 1` is computed in int
arithmetic before being assigned to s64 variable `new`. When usage equals
INT_MAX (the default "max" value), the addition overflows to INT_MIN.
This negative value then passes the `new > max` check incorrectly,
allowing a charge that should be rejected and corrupting usage to
negative.

Fix by casting usage to s64 before the addition so the arithmetic is
done in 64-bit.

Signed-off-by: cuitao <cuitao@kylinos.cn>
---
 kernel/cgroup/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/rdma.c b/kernel/cgroup/rdma.c
index 09258eebb5c7..7d21a0db3cef 100644
--- a/kernel/cgroup/rdma.c
+++ b/kernel/cgroup/rdma.c
@@ -283,7 +283,7 @@ int rdmacg_try_charge(struct rdma_cgroup **rdmacg,
 			ret = PTR_ERR(rpool);
 			goto err;
 		} else {
-			new = rpool->resources[index].usage + 1;
+			new = (s64)rpool->resources[index].usage + 1;
 			if (new > rpool->resources[index].max) {
 				ret = -EAGAIN;
 				goto err;
-- 
2.43.0

