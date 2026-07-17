Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE0B3F8EAF;
	Fri, 17 Jul 2026 11:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784286415; cv=none; b=pqWPCZ7EG6taEy87SWW2/d1Ab66QFWLTVL1n/2mUbeEzCZIgRUJ9Yz7GQkCBOO3MsHUgGR4w8t61wuDmMK7Z2vjgtE42npvLpGwAHqpOaBBFBbdOj5zgoDepuFpKwhU/phF+ToPjKUXhY7E7bA8IMVHbNBmgjP+Q1dORbOdrP1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784286415; c=relaxed/simple;
	bh=/TB8WjEuukuX//cjK2LA+28Vvqr6GanMXok7rdnyRkI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X0t3TDhzqGOxjTThno58AYApV5Tk6QQO7Ngvh9ZlZeZVErOABWVk6Z5kHNRGe48aSFzdsj0MOAsZks74XZ585IzOi7ZrtTokN4km88vl8H8MPOiKXnsKeoVKHbQqnXTuoMcgOrcN46QnclBeF9A5IjvDwtEnPaCJVCT/bE60czM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 951963f481cf11f1aa26b74ffac11d73-20260717
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_UNTRUSTED, SA_UNFAMILIAR
	SN_UNTRUSTED, SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-UNFAMILIAR: 1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:2db7a86a-1f46-4ada-b4c3-8edeaaa6ac8b,IP:10,
	URL:0,TC:0,Content:0,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:2db7a86a-1f46-4ada-b4c3-8edeaaa6ac8b,IP:10,UR
	L:0,TC:0,Content:0,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:NOTI_GNA5D1EA,ACTI
	ON:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:5d67ef9ef24d9e63716f51296692f532,BulkI
	D:260717190640RFT14K5A,BulkQuantity:0,Recheck:0,SF:16|19|38|66|78|102|127|
	865|898,TC:nil,Content:0|15|50,EDM:2,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_USA
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 951963f481cf11f1aa26b74ffac11d73-20260717
X-User: guojian@kylinos.cn
Received: from ym-pc.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <guojian@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1539793975; Fri, 17 Jul 2026 19:06:38 +0800
From: guojian <guojian@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Jian Guo <guojian@kylinos.cn>
Subject: [PATCH] selftests/cgroup: Remove redundant cg_enter_current() call in test_core
Date: Fri, 17 Jul 2026 19:06:06 +0800
Message-ID: <20260717110606.298368-1-guojian@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jian Guo <guojian@kylinos.cn>

The test_cgcore_no_internal_process_constraint_on_threads test has two
back-to-back cg_enter_current(root) calls in its cleanup path.

A single cg_enter_current() call atomically migrates the entire thread
group to the target cgroup even for multi-threaded processes, and this
test creates no extra threads or child processes that would require a
second migration attempt. The second call is a harmless no-op once the
process is already in the root cgroup, but it is redundant and
inconsistent with the cleanup logic used in all other cgroup core
selftest cases.

Remove the duplicate call to clean up the code. No functional change is
intended.

Signed-off-by: Jian Guo <guojian@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 88ca832d4fc1..8e3f9b391e44 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -426,7 +426,6 @@ static int test_cgcore_no_internal_process_constraint_on_threads(const char *roo
 	ret = KSFT_PASS;
 
 cleanup:
-	cg_enter_current(root);
 	cg_enter_current(root);
 	if (child)
 		cg_destroy(child);
-- 
2.43.0

