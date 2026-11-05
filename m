Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882941;
	b=FrCqbYfkE3MIDxkSmSEkU89mdaRI4G3/8xHCq+81qKpjPWcDA7RWVhrvMBOGax3kgP8i
	 AfaijNSVAbfMwh9wyk7+WLJIDqquEFsaHoOJGZ01DCCtJdekb2zZ4xJmIKqyTuRIZhOoK
	 /TIgZsAUlg2ZCna1CPMut+Hqx70+KL3tXNwDbLmGVR8sk+PTY91tuapiEWACctaceh6lG
	 ARQ4nA/nkoxlgA8X9GQzv8HRx0WqDjrfrhXUm9sQMGDX/ZMcNIX1D+plqitxPebZVPsIY
	 5crzIz/HZyp3c3KYI67rJn5PL5c/mOB1YlIdmvtIapjIYDDhaDXSBsd2Iguq3SbHG1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882941;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8lNES7HOAcQtbypia4I77W3fBXnSYdPVadaze0MP+7o=;
	b=ziUBQOmNjyH7WDv+ar5U85aq2DNnrXBPzK8VDyYjxX+Ul09avIi65R/9nH8o5pY4KyOe
	 KZCRthd4Sqbtvu+Dd6AJEBLrfYwA7i+0kXIYLYVzGFh/J7Y2W0UDVnGxzbLgaKOmpAF+M
	 cVZszpWTegBuFNOicVsZgxcJCeoxsbplRMnRoMbLrPkiYS+eyNHPuqFXPsvKF4IJ/K+MP
	 CVvdnvIIKtUfV5+NeT7IjbXhqALS/BaHakM4tfnCV1N1c5MxuSuGX1iVlt94pWtGRNvC/
	 1yYm2Rd/M6d0/G8V1RAza9mb05y9GgbdWA+Fso75LizqiNlU1ZrDAaZLQM0952jmjYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8E4606A328;
	Thu,  5 Nov 2026 12:48:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A8E4606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3ed29f84d91711f19a56ed5b684f684d-20261105
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_CHARSET
	HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:f03f5e37-40c5-467b-b83c-79ae097e5bc3,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.19,REQID:f03f5e37-40c5-467b-b83c-79ae097e5bc3,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:7db8b62,CLOUDID:80bdff4df7e3f81b0ec11ec1ebd4f49a,BulkI
	D:261105204853AFQH8L54,BulkQuantity:0,SF:10|38|66|78|102|127|153|865|898,T
	C:nil,Content:0|15|50|99,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3ed29f84d91711f19a56ed5b684f684d-20261105
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1841114905; Thu, 05 Nov 2026 20:48:48 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH] cgroup: replace BUG_ON()s in compare_css_sets() with WARN_ON_ONCE()
Date: Thu,  5 Nov 2026 20:48:13 +0800
Message-ID: <20261105124813.862460-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
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

compare_css_sets() walks the cgrp_links lists of two css_sets in
lockstep.  Both lists carry exactly one link per hierarchy root, so a
length or ordering mismatch just means the two css_sets are not the same
one, which is what the function already reports with "return false".
The caller keeps walking the hash chain and allocates a new css_set if
nothing matches.

None of these checks is a user-reachable error path; they are invariant
checks on kernel-internal bookkeeping that are expected never to fire,
and each one has a way out.

No functional change for a consistent state.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 kernel/cgroup/cgroup.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a284225f8dc9..81c82d137fa2 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1024,10 +1024,12 @@ static bool compare_css_sets(struct css_set *cset,
 		l2 = l2->next;
 		/* See if we reached the end - both lists are equal length. */
 		if (l1 == &cset->cgrp_links) {
-			BUG_ON(l2 != &old_cset->cgrp_links);
+			if (WARN_ON_ONCE(l2 != &old_cset->cgrp_links))
+				return false;
 			break;
 		} else {
-			BUG_ON(l2 == &old_cset->cgrp_links);
+			if (WARN_ON_ONCE(l2 == &old_cset->cgrp_links))
+				return false;
 		}
 		/* Locate the cgroups associated with these links. */
 		link1 = list_entry(l1, struct cgrp_cset_link, cgrp_link);
@@ -1035,7 +1037,8 @@ static bool compare_css_sets(struct css_set *cset,
 		cgrp1 = link1->cgrp;
 		cgrp2 = link2->cgrp;
 		/* Hierarchies should be linked in the same order. */
-		BUG_ON(cgrp1->root != cgrp2->root);
+		if (WARN_ON_ONCE(cgrp1->root != cgrp2->root))
+			return false;
 
 		/*
 		 * If this hierarchy is the hierarchy of the cgroup
-- 
2.50.1

