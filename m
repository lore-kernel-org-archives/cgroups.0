Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC864B04AF;
	Wed, 19 Aug 2026 10:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787135543; cv=none; b=Tqj3sJ1VDMI6MGDaW/Kc+lRFaXNT7bcILdxnG0A8HIwkavZx6vNcr0ziNouK8V1JRGgC/goWwY1Kl/bcieKEJFL7xMss66ohHSoHz8+xnXPtmS81zNatgp3Ge0B2u9yoD9CznJGbS9W/JO+IgL6CXVKpAtZ97pa+WDQptmqt+CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787135543; c=relaxed/simple;
	bh=QCxamtbTHIFORYR+9Cn+f98+ojG1+kvyRPNj5kqnFbw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RSc3/ZIaeQzLvhphI2IE9RZO05K+DksGqnIVUg/Udn019w57K6DAUeTuJeaEKLgkLENXibVuu1g0GXIqjcech0HFG3slCPmiEoJtWEQvhWfRIhsjzu4GUBG01XvpJLS2z00Ki4HeC4KjtuXbyWD4XPDkdhLWt5tny4Sez3Z2+jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3bde537c9bb911f19a56ed5b684f684d-20260819
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_CHARSET
	HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_TRUSTED
	SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:6c42bdf5-f802-4f37-a153-5270204da864,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.19,REQID:6c42bdf5-f802-4f37-a153-5270204da864,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:7db8b62,CLOUDID:0ca1f2a9af1ec04e02e2b865d3365039,BulkI
	D:260819183213THHT9K5A,BulkQuantity:0,SF:10|38|66|78|102|127|865|898,TC:ni
	l,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:n
	il,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3bde537c9bb911f19a56ed5b684f684d-20260819
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1904920732; Wed, 19 Aug 2026 18:32:10 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH] selftests: cgroup: simplify cpuset subtree permissions test
Date: Wed, 19 Aug 2026 18:31:52 +0800
Message-ID: <20260819103152.767771-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify test_cpuset_perms_subtree by removing unnecessary chown of
cgroup.procs files. The test verifies implicit migration triggered by
enabling/disabling the cpuset controller via cgroup.subtree_control.

Implicit migration is handled internally by the kernel through
cgroup_update_dfl_csses() when subtree_control is modified, and does
not require cgroup.procs write permission. Only cgroup.subtree_control
permission is needed to trigger the controller state change.

Remove the allocation and cleanup of parent_procs and child_procs
variables that are no longer needed.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_cpuset.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset.c b/tools/testing/selftests/cgroup/test_cpuset.c
index c5cf8b56ceb8..b323addcc519 100644
--- a/tools/testing/selftests/cgroup/test_cpuset.c
+++ b/tools/testing/selftests/cgroup/test_cpuset.c
@@ -167,7 +167,7 @@ static int test_cpuset_perms_object_deny(const char *root)
 static int test_cpuset_perms_subtree(const char *root)
 {
 	char *parent = NULL, *child = NULL;
-	char *parent_procs = NULL, *parent_subctl = NULL, *child_procs = NULL;
+	char *parent_subctl = NULL;
 	const uid_t test_euid = TEST_UID;
 	int object_pid = 0;
 	int ret = KSFT_FAIL;
@@ -175,9 +175,6 @@ static int test_cpuset_perms_subtree(const char *root)
 	parent = cg_name(root, "cpuset_test_0");
 	if (!parent)
 		goto cleanup;
-	parent_procs = cg_name(parent, "cgroup.procs");
-	if (!parent_procs)
-		goto cleanup;
 	parent_subctl = cg_name(parent, "cgroup.subtree_control");
 	if (!parent_subctl)
 		goto cleanup;
@@ -187,16 +184,11 @@ static int test_cpuset_perms_subtree(const char *root)
 	child = cg_name(parent, "cpuset_test_1");
 	if (!child)
 		goto cleanup;
-	child_procs = cg_name(child, "cgroup.procs");
-	if (!child_procs)
-		goto cleanup;
 	if (cg_create(child))
 		goto cleanup;
 
-	/* Enable permissions as in a delegated subtree */
-	if (chown(parent_procs, test_euid, -1) ||
-	    chown(parent_subctl, test_euid, -1) ||
-	    chown(child_procs, test_euid, -1))
+	/* Grant minimal subtree_control permission to trigger implicit migration */
+	if (chown(parent_subctl, test_euid, -1))
 		goto cleanup;
 
 	/* Put a privileged child in the subtree and modify controller state
@@ -221,12 +213,10 @@ static int test_cpuset_perms_subtree(const char *root)
 	}
 
 	cg_destroy(child);
-	free(child_procs);
 	free(child);
 
 	cg_destroy(parent);
 	free(parent_subctl);
-	free(parent_procs);
 	free(parent);
 
 	return ret;
-- 
2.50.1

