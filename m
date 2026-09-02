Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7453EFD22;
	Wed,  2 Sep 2026 10:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788344360; cv=none; b=TfcdZOowoWidT/KK4MAY/1MgdWD4C530gIvvQDGrZmmb72xvptm0GIlo9TChQDRoYP8nL6wUIzx8/QO4T0EH0HC2qMDc7O+Eet7RAF0NSXwZJzsCKJ6fiAhxIMB0uEZVfQiFK6cEpm0hGJhDM+rFHMpRQU0wwjBCro/KzaPtTXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788344360; c=relaxed/simple;
	bh=0uXLbFCjKkSc5bdGWkdSocxRnPS4EEyfA57szxibfjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fJAhchA7mqQB93U+np7pQt/xZYsHWra7iCFc79g8tyWIvhPSEfKjGpHeluS/kLPnj5W3zT138nDqJLus0gQ6cE1dszA20zxz6wMVJYJrwPyVRWDX+esTia0AyesMbceKtMbcA/DhNg+mjtjTodVe1SRlCe2fD3i5D0NZvsxt124=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b9ed5c00a6b711f19a56ed5b684f684d-20260902
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:9ebfbd50-ea65-42a1-a090-8e18eb9596ca,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:9ebfbd50-ea65-42a1-a090-8e18eb9596ca,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:c79026a429cb39097d0fb0fc4418a6ac,BulkI
	D:260902181910FXD04WUY,BulkQuantity:0,SF:10|38|66|78|102|127|865|898,TC:ni
	l,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b9ed5c00a6b711f19a56ed5b684f684d-20260902
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1710416012; Wed, 02 Sep 2026 18:19:05 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	mkoutny@suse.com
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH] cgroup: namespace: replace BUG_ON() in copy_cgroup_ns() with WARN_ON_ONCE()
Date: Wed,  2 Sep 2026 18:18:56 +0800
Message-ID: <20260902101856.225493-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

copy_cgroup_ns() uses BUG_ON() to guard against a NULL old_ns. The
condition cannot currently be triggered by any caller, and the sole
caller, create_new_namespaces(), already checks the return value with
IS_ERR() and unwinds correctly.

Replace the BUG_ON() with WARN_ON_ONCE() and return -EINVAL instead,
consistent with the policy of not killing the whole machine for a
recoverable programming error.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 kernel/cgroup/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
index ea4ee13936be..13930955c254 100644
--- a/kernel/cgroup/namespace.c
+++ b/kernel/cgroup/namespace.c
@@ -53,7 +53,8 @@ struct cgroup_namespace *copy_cgroup_ns(u64 flags,
 	struct ucounts *ucounts;
 	struct css_set *cset;
 
-	BUG_ON(!old_ns);
+	if (WARN_ON_ONCE(!old_ns))
+		return ERR_PTR(-EINVAL);
 
 	if (!(flags & CLONE_NEWCGROUP)) {
 		get_cgroup_ns(old_ns);
-- 
2.50.1

