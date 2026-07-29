Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FAC448B83;
	Wed, 29 Jul 2026 10:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319587; cv=none; b=XOiMcuZv3SZlIPvPCgMVdnfXrJOlPaMzEGXmGvP+E4CDmjUlsMbeDfl6iLI0S/yR+vlDJxfa4wD7pmPTkOhOz5SySb0KwzagTD6thwoZnDo3vQFbVPnCVbvGi7Dj+ufv0+STr22UE0S1iu8hi4fPi8EC7qjg4jHlY8cEwiIvtFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319587; c=relaxed/simple;
	bh=gJOgYRCOuA0AbLiDYwRuCXXKC4rjbK3t42Bgo1u8LX8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YOZiWsDyNomadcQEKXgmT+J+DFgKKCY7K9lPCKFAqHhbpRu3O4ZwoXrxmqUzToy+WkHMzz6YpFBsXeV2MfnvOYBNphzqgnPoevUnE0xIACC7BHRfaAo3+BkiM9F7BQK3nDZa0ghmr+jDTHFNZK3vSC161Md0df7DnrsZpexddcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 234a61d28b3511f1aa26b74ffac11d73-20260729
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:314e5a9b-9fc0-42df-ab27-8866f569af55,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:314e5a9b-9fc0-42df-ab27-8866f569af55,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:c655f3887c7eb55f4687e4a54898ab4c,BulkI
	D:260729180619U0GM6UTH,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:1,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 234a61d28b3511f1aa26b74ffac11d73-20260729
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1264336520; Wed, 29 Jul 2026 18:06:16 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH 2/2] selftests/cgroup: write explicit period to cpu.max in max tests
Date: Wed, 29 Jul 2026 18:04:51 +0800
Message-Id: <20260729100451.689458-3-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260729100451.689458-1-sunshaojie@kylinos.cn>
References: <20260729100451.689458-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cpu.max interface accepts "quota period" as two values, but
test_cpucg_max and test_cpucg_max_nested only wrote the quota,
relying on the kernel default period of 100ms. Since the test
duration is exactly divisible by the default period (1s / 100ms
= 10, no remainder), the remainder calculation was effectively
dead code.

Write both values explicitly so that the period can be easily
adjusted for testing purposes and the remainder logic becomes
genuinely useful.

While at it, rename misleading variable names:
  - default_period_usec -> period_usec (no longer relying on a
    kernel default, as it is now explicitly written to cpu.max)
  - quota_buf -> max_param_buf (since the buffer holds both quota
    and period)

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_cpu.c | 26 ++++++++++++-----------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index fe637e1d2fcd..10f9254cd08e 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -646,15 +646,16 @@ static int test_cpucg_max(const char *root)
 {
 	int ret = KSFT_FAIL;
 	long quota_usec = 1000;
-	long default_period_usec = 100000; /* cpu.max's default period */
+	long period_usec = 100000;
 	long duration_seconds = 1;
 
 	long duration_usec = duration_seconds * USEC_PER_SEC;
 	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
 	char *cpucg;
-	char quota_buf[32];
+	char max_param_buf[32];
 
-	snprintf(quota_buf, sizeof(quota_buf), "%ld", quota_usec);
+	snprintf(max_param_buf, sizeof(max_param_buf), "%ld %ld", quota_usec,
+		 period_usec);
 
 	cpucg = cg_name(root, "cpucg_test");
 	if (!cpucg)
@@ -663,7 +664,7 @@ static int test_cpucg_max(const char *root)
 	if (cg_create(cpucg))
 		goto cleanup;
 
-	if (cg_write(cpucg, "cpu.max", quota_buf))
+	if (cg_write(cpucg, "cpu.max", max_param_buf))
 		goto cleanup;
 
 	struct cpu_hog_func_param param = {
@@ -685,8 +686,8 @@ static int test_cpucg_max(const char *root)
 	 * The following calculation applies only since
 	 * the cpu hog is set to run as per wall-clock time
 	 */
-	n_periods = duration_usec / default_period_usec;
-	remainder_usec = duration_usec - n_periods * default_period_usec;
+	n_periods = duration_usec / period_usec;
+	remainder_usec = duration_usec - n_periods * period_usec;
 	expected_usage_usec
 		= n_periods * quota_usec + MIN(remainder_usec, quota_usec);
 
@@ -710,15 +711,16 @@ static int test_cpucg_max_nested(const char *root)
 {
 	int ret = KSFT_FAIL;
 	long quota_usec = 1000;
-	long default_period_usec = 100000; /* cpu.max's default period */
+	long period_usec = 100000;
 	long duration_seconds = 1;
 
 	long duration_usec = duration_seconds * USEC_PER_SEC;
 	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
 	char *parent, *child;
-	char quota_buf[32];
+	char max_param_buf[32];
 
-	snprintf(quota_buf, sizeof(quota_buf), "%ld", quota_usec);
+	snprintf(max_param_buf, sizeof(max_param_buf), "%ld %ld", quota_usec,
+		 period_usec);
 
 	parent = cg_name(root, "cpucg_parent");
 	child = cg_name(parent, "cpucg_child");
@@ -734,7 +736,7 @@ static int test_cpucg_max_nested(const char *root)
 	if (cg_create(child))
 		goto cleanup;
 
-	if (cg_write(parent, "cpu.max", quota_buf))
+	if (cg_write(parent, "cpu.max", max_param_buf))
 		goto cleanup;
 
 	struct cpu_hog_func_param param = {
@@ -756,8 +758,8 @@ static int test_cpucg_max_nested(const char *root)
 	 * The following calculation applies only since
 	 * the cpu hog is set to run as per wall-clock time
 	 */
-	n_periods = duration_usec / default_period_usec;
-	remainder_usec = duration_usec - n_periods * default_period_usec;
+	n_periods = duration_usec / period_usec;
+	remainder_usec = duration_usec - n_periods * period_usec;
 	expected_usage_usec
 		= n_periods * quota_usec + MIN(remainder_usec, quota_usec);
 
-- 
2.25.1

