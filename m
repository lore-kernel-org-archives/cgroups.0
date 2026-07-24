Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035C7421225;
	Fri, 24 Jul 2026 10:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784888550; cv=none; b=PHsIhFEOa5Ng9Af7cd9ox7dNT6Yn/16gzfjTs8xdNz/IrMIZtyqF8RPtwdH0nB01C1ZqhWaIdORietAAUiRZ1nTbSTWNqIfTVECaU/DF0yOr5D6Yg2cSjx6MxCSSHTGWmwrhWfg+oBo5mGohCKC+J+PoRVqcCUhJLdEwzVVri+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784888550; c=relaxed/simple;
	bh=/+KXbZekc5UbaTBcheDnVkRBaG4/vOnZf9NF38A7KtM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OvzSymrxl89SvzsBYIxuAp5iKDXRLhYp3cO+IQuMPJzVkt+kXpe1rmmIxeGelQ2NEylbyhz/At63brab+FTkSHmw4/fI2Mt/Z4MEdEK6SMZwvodCpScdpx8TdBu1+LkqngSt4XscwgqMmYSkTyaknDOsmSF2Q+UlSzCAAJr/EnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8df32b80874911f1aa26b74ffac11d73-20260724
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
X-CID-O-INFO: VERSION:1.3.12,REQID:ca28ebf6-4ac8-4710-9c6f-641dfadb5cea,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:ca28ebf6-4ac8-4710-9c6f-641dfadb5cea,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:c05e151b9ad6fa92eec01b15aaa3eee4,BulkI
	D:26072418222138KVY5RV,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8df32b80874911f1aa26b74ffac11d73-20260724
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 197663231; Fri, 24 Jul 2026 18:22:20 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: tj@kernel.org,
	skhan@linuxfoundation.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	corbet@lwn.net
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH v2] Docs/admin-guide/cgroup-v1/memory: document memsw limit constraints
Date: Fri, 24 Jul 2026 18:21:48 +0800
Message-Id: <20260724102148.268505-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260723124354.9472-1-sunshaojie@kylinos.cn>
References: <20260723124354.9472-1-sunshaojie@kylinos.cn>
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

Add a note explaining:
  - memory.limit_in_bytes must be configured with a smaller value
    before setting memory.memsw.limit_in_bytes, otherwise -EINVAL
    is returned.
  - The kernel enforces memory.limit_in_bytes <=
    memory.memsw.limit_in_bytes on every write.  When adjusting both
    limits together, set memsw first when increasing and memory
    first when decreasing.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
v1 -> v2:
  - Correct the ordering guidance: set memsw first when increasing
    limits, set memory first when decreasing limits (spotted by
    Sashiko AI review).
  - Use the ``.. note::`` RST directive instead of plain "Note:".
---

 Documentation/admin-guide/cgroup-v1/memory.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 7db63c002922..c52269693fb0 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -262,6 +262,17 @@ In this case, setting memsw.limit_in_bytes=3G will prevent bad use of swap.
 By using the memsw limit, you can avoid system OOM which can be caused by swap
 shortage.
 
+.. note::
+   - Since memsw is the sum of memory and swap, the kernel enforces the
+     invariant ``memory.limit_in_bytes <= memory.memsw.limit_in_bytes`` on
+     every write, so ``memory.limit_in_bytes`` must be configured with a
+     smaller value before setting ``memory.memsw.limit_in_bytes``.
+     Violating this relation will result in ``-EINVAL``.
+   - When adjusting both limits together, the order matters:
+        - To increase limits, set ``memory.memsw.limit_in_bytes`` first.
+        - To decrease limits, set ``memory.limit_in_bytes`` first.
+     This ensures the intermediate state does not violate the invariant.
+
 2.4.1 why 'memory+swap' rather than swap
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.25.1

