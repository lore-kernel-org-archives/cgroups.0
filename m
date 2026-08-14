Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D9A3672A0;
	Fri, 14 Aug 2026 10:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786701645; cv=none; b=oW+UayllbWxv6QCz2z7i1C79lwzbKnYV6gvfAWt0KkV7WQ2FkBmVuoIDjeH388BFs5tJl4okcrmSoOSbFHpBO50D0WJfUbD1HwawmSI6Qxp/dLgV/mQk60UwxL2kFgIJq+w3jH2IMdiuHGChhKhFEuy6beFBpu/U2NnFJsY2dak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786701645; c=relaxed/simple;
	bh=61BfVamzKHgQdUYSAiqfAhDqJTjNb5s8eUQKFu8E5P4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HYhmVNo6zGkt4mT6lK/a9zb0fJe66zBCmZQlaKjRei/xtzQlTSs4FoY1WniayCSYoVbOYkMSN3naBLEntZ9dFfEB676MPq3IiTtW/ZQRk77Ng8BlXNHLR7nEY0KwXDlE5dX1M8i7ZJ7kK2xlN74Y0k6i3jvZ2bh3nZ52/Nv8X8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: f76a112c97c611f1aa26b74ffac11d73-20260814
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN
	HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS
	HR_TO_CHARSET, HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6facda73-7d98-427a-8386-a3930e161c6f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:6facda73-7d98-427a-8386-a3930e161c6f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:56aa920ffbc03c0e04e54e80fc69931a,BulkI
	D:260814180027EH7NOZMQ,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f76a112c97c611f1aa26b74ffac11d73-20260814
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 619974505; Fri, 14 Aug 2026 18:00:23 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH v2] selftests/cgroup: remove redundant chown in test_cgcore_lesser_ns_open
Date: Fri, 14 Aug 2026 18:00:02 +0800
Message-Id: <20260814100002.1007394-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260813090914.690350-1-sunshaojie@kylinos.cn>
References: <20260813090914.690350-1-sunshaojie@kylinos.cn>
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

Remove the redundant chown calls and the now unused test_euid and
cg_test_a_procs variables.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
Changes in v2:
- Remove the now unused cg_test_a_procs variable, as suggested by
  sashiko-bot.

 tools/testing/selftests/cgroup/test_core.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 88ca832d4fc1..5501be9912c0 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -795,10 +795,9 @@ static int lesser_ns_open_thread_fn(void *arg)
 static int test_cgcore_lesser_ns_open(const char *root)
 {
 	static char stack[65536];
-	const uid_t test_euid = 65534;	/* usually nobody, any !root is fine */
 	int ret = KSFT_FAIL;
 	char *cg_test_a = NULL, *cg_test_b = NULL;
-	char *cg_test_a_procs = NULL, *cg_test_b_procs = NULL;
+	char *cg_test_b_procs = NULL;
 	int cg_test_b_procs_fd = -1;
 	struct lesser_ns_open_thread_arg targ = { .fd = -1 };
 	pid_t pid;
@@ -813,10 +812,9 @@ static int test_cgcore_lesser_ns_open(const char *root)
 	if (!cg_test_a || !cg_test_b)
 		goto cleanup;
 
-	cg_test_a_procs = cg_name(cg_test_a, "cgroup.procs");
 	cg_test_b_procs = cg_name(cg_test_b, "cgroup.procs");
 
-	if (!cg_test_a_procs || !cg_test_b_procs)
+	if (!cg_test_b_procs)
 		goto cleanup;
 
 	if (cg_create(cg_test_a) || cg_create(cg_test_b))
@@ -825,10 +823,6 @@ static int test_cgcore_lesser_ns_open(const char *root)
 	if (cg_enter_current(cg_test_b))
 		goto cleanup;
 
-	if (chown(cg_test_a_procs, test_euid, -1) ||
-	    chown(cg_test_b_procs, test_euid, -1))
-		goto cleanup;
-
 	targ.path = cg_test_b_procs;
 	pid = clone(lesser_ns_open_thread_fn, stack + sizeof(stack),
 		    CLONE_NEWCGROUP | CLONE_FILES | CLONE_VM | SIGCHLD,
@@ -863,7 +857,6 @@ static int test_cgcore_lesser_ns_open(const char *root)
 	if (cg_test_a)
 		cg_destroy(cg_test_a);
 	free(cg_test_b_procs);
-	free(cg_test_a_procs);
 	free(cg_test_b);
 	free(cg_test_a);
 	return ret;
-- 
2.25.1

