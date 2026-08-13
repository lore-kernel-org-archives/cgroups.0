Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882953B893F;
	Thu, 13 Aug 2026 09:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786612201; cv=none; b=IkdUTUyCxofhP0u+wr4JtOAyLh1bPzwoJwvVERznlIAqobt6NhgLKMUDFWWE/Z3i2NGJtO2gzG1WXktImfcDoEsp7P73qbSUalEYjuaJr0kaY4zNaoogFFM4p8+xrJr2/6h3iJl17fsC7lRZ2ThaGmymhYQVaiU/ur2ObA1kNmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786612201; c=relaxed/simple;
	bh=nUTXvCxOgXf/FBYKi2zPekPbpaeUCcRilIOXspTAmwM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hmMAJemOgLBYEJoLceonBNZ/GeLNALdfWWPhGDOlHBEgqodO5JvYEe9FAvJlXEyMmhJqQ2jP54fNHwjshOA6QweSaPOph+rcPS/b2qMlm0XVfQI+4k8qe9MHhEuSY8rYbOpfh2Coi/0r/lrJYXdgqwnpWoCrUriRGAek7z1v0HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ba84154496f611f1aa26b74ffac11d73-20260813
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_CHARSET
	HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_TRUSTED
	SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:c142f4ca-c165-438e-8df9-f2af5b44b334,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:c142f4ca-c165-438e-8df9-f2af5b44b334,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:71e8a00946f9e40ad7379828b967b691,BulkI
	D:260813170950TQXJIW6H,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ba84154496f611f1aa26b74ffac11d73-20260813
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 418094760; Thu, 13 Aug 2026 17:09:46 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH] selftests/cgroup: remove redundant chown in test_cgcore_lesser_ns_open
Date: Thu, 13 Aug 2026 17:09:14 +0800
Message-Id: <20260813090914.690350-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

test_cgcore_lesser_ns_open runs as root throughout and never changes its
euid, so chowning the two cgroup.procs files to a non-root uid has no
effect on the test.

The ENOENT the test expects comes from the cgroup namespace delegation
check in cgroup_procs_write_permission(): the source and destination
cgroups must both be descendants of the namespace root captured at open
time.  That check does not depend on file ownership.  In addition, the
permission check only examines the common ancestor's cgroup.procs file
(the test root here), which the chown calls do not touch.

Remove the redundant chown calls and the now unused test_euid variable.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 88ca832d4fc1..483e8b063f12 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -795,7 +795,6 @@ static int lesser_ns_open_thread_fn(void *arg)
 static int test_cgcore_lesser_ns_open(const char *root)
 {
 	static char stack[65536];
-	const uid_t test_euid = 65534;	/* usually nobody, any !root is fine */
 	int ret = KSFT_FAIL;
 	char *cg_test_a = NULL, *cg_test_b = NULL;
 	char *cg_test_a_procs = NULL, *cg_test_b_procs = NULL;
@@ -825,10 +824,6 @@ static int test_cgcore_lesser_ns_open(const char *root)
 	if (cg_enter_current(cg_test_b))
 		goto cleanup;
 
-	if (chown(cg_test_a_procs, test_euid, -1) ||
-	    chown(cg_test_b_procs, test_euid, -1))
-		goto cleanup;
-
 	targ.path = cg_test_b_procs;
 	pid = clone(lesser_ns_open_thread_fn, stack + sizeof(stack),
 		    CLONE_NEWCGROUP | CLONE_FILES | CLONE_VM | SIGCHLD,
-- 
2.25.1

