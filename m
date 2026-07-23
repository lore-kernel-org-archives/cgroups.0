Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65C5495508;
	Thu, 23 Jul 2026 12:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784810673; cv=none; b=nWwecjGqK3yc4PNOKTUiVxcudTgVFm1MV/kp8CblDFjMFaM7j6k4be32aROD22LskNImzw5Pop/NB6iH/ZUOMdbLqLrncbmfRJJgLO4oERMfXYMWqp+GVnwVPDsFOVq/Iltgv8Dp0REIQAc9FhPM+CJ0+AGgOLN17ACzn0agF6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784810673; c=relaxed/simple;
	bh=y20GbONnNyuKw+7vArbPEka4I+fMxIbOkeCDoMe8B6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e7Gv3Bt7w2Kkl8VplVyoAtnlc5Wq0vRJEMFzU30AZj2kX6CnZ1kxGLbytwegScSHXcfMS6klAM2O+fHxmG3lcL5qjKGgJNVIN1Eoo4iwg/XcFfxLZvlABgWo3duobG8iYC/OvOmhN2XjPJAksCmLLrW/dgDj8G3+xPkPzZ9HLBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3acce276869411f1aa26b74ffac11d73-20260723
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4de26a12-2f8f-4e05-ba31-e51b9de1fb90,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:4de26a12-2f8f-4e05-ba31-e51b9de1fb90,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:e4de632e7be81a5502e9212eb4c09649,BulkI
	D:260723204423LDPBTZJP,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3acce276869411f1aa26b74ffac11d73-20260723
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1538233980; Thu, 23 Jul 2026 20:44:22 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH] Docs/admin-guide/cgroup-v1/memory: document memsw limit constraints
Date: Thu, 23 Jul 2026 20:43:54 +0800
Message-Id: <20260723124354.9472-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel enforces the invariant that memory.max <= memsw.max, and
returns -EINVAL when writing an invalid memsw.limit_in_bytes without
first configuring memory.limit_in_bytes.  However, this constraint
is not documented anywhere, leaving users to discover it only through
-EINVAL errors.

Add a Note section explaining:
  - memory.limit_in_bytes must be set before memsw.limit_in_bytes
  - memory.limit_in_bytes <= memsw.limit_in_bytes must always hold
  - Violations result in -EINVAL

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 7db63c002922..92e74ec28822 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -262,6 +262,15 @@ In this case, setting memsw.limit_in_bytes=3G will prevent bad use of swap.
 By using the memsw limit, you can avoid system OOM which can be caused by swap
 shortage.
 
+Note:
+ - Since memsw is the sum of memory and swap, it must be at least the memory
+   limit.  Therefore, ``memory.limit_in_bytes`` must be set before
+   ``memory.memsw.limit_in_bytes``, and the relation
+   ``memory.limit_in_bytes <= memory.memsw.limit_in_bytes`` must always hold.
+ - If ``memory.memsw.limit_in_bytes`` is set without a properly configured
+   ``memory.limit_in_bytes``, or if the above relation is violated, the write
+   will fail with ``-EINVAL``.
+
 2.4.1 why 'memory+swap' rather than swap
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.25.1

