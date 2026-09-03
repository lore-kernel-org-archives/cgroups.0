Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4834B3E8357;
	Thu,  3 Sep 2026 06:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788418167; cv=none; b=JxebcDXciiaw4oknII3yUletwDiWzfKVBRrrD9SHOsW5CNUuEvDbn+xh4N+cPe5+JMcruk0jYHYwcXgvmbUjgX/GfDzJLjaTpf/t3q4Rj9a3F+ANnxWH3AclO42rKI9l1TGSs/K6qWt3dSw0uKQMmDZgLEFbH08aGSJA02z/qyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788418167; c=relaxed/simple;
	bh=3OM5M7QuU6cV3txn9PLrQq/F9jkAhbAnJpljf/VHO/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riL1G4D+ijW3/GdccKowd7S+TkOFC+XK9d4WGoTpr7PwNMEowIFg3t3F22Gg6ZUDKwkkhXbu/yPYcxdFFiyxCnRmj7WZ92HSISHaiOnUNVbkfsMvoX+BA5GVLWm8T4M7rAHTEIdF8Kew0+vPVhq1xkeHDwPyqGIn0gCh3L0WELs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 91ed52f8a76311f19a56ed5b684f684d-20260903
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN
	HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS
	HR_TO_CHARSET, HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, OB_FP
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:e2c0e359-3e0f-44a8-8220-772083e7a699,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:e2c0e359-3e0f-44a8-8220-772083e7a699,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:dfb0a1b2ded5297fb51d5859d0ad900e,BulkI
	D:260903144917PXU0U8R4,BulkQuantity:0,SF:10|38|66|78|81|82|102|127|865|898
	,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 91ed52f8a76311f19a56ed5b684f684d-20260903
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 292325350; Thu, 03 Sep 2026 14:49:11 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH v2 3/3] fs: namespace: drop BUG_ON() in copy_mnt_ns()
Date: Thu,  3 Sep 2026 14:48:28 +0800
Message-ID: <20260903064828.126643-4-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260903064828.126643-1-sunshaojie@kylinos.cn>
References: <aphwXq5bEQwKhqx2@localhost.localdomain>
 <20260903064828.126643-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sole caller, create_new_namespaces(), always passes a valid mount
namespace pointer from the task's nsproxy. The other copy_*_ns()
helpers, e.g. copy_time_ns() and copy_pid_ns(), don't perform such a
check either. Drop the BUG_ON() for consistency with them.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 fs/namespace.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1ecd96c918b3..0f35c8c14027 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4247,8 +4247,6 @@ struct mnt_namespace *copy_mnt_ns(u64 flags, struct mnt_namespace *ns,
 	struct mount *new;
 	int copy_flags;
 
-	BUG_ON(!ns);
-
 	if (likely(!(flags & CLONE_NEWNS))) {
 		get_mnt_ns(ns);
 		return ns;
-- 
2.50.1

