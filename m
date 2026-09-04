Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286D732470E;
	Fri,  4 Sep 2026 06:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502858; cv=none; b=U9h5gBLLhfzlp23kiZ7HGrK8l0qwzaHC7JY0NZr/pb+ALQ8FcZ46jkGxPlwcirNjH4//iuWz7K2te6W3CzhIfs+8uJ0VRYnWIzmGnPZxGrY9eCxM0WCDeqoqtiLcNQVJ2Ns1mzlogqU4C7qkxpni7dHw19q0TTSu0j9v+xDKHUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502858; c=relaxed/simple;
	bh=8cokZ4JMx1IsIhMEWSnDbPmYtzKquw85d/Q7EuKjjnU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ByNr+vunxYEr17tL4iyzLi0Zj7deVSHtY3KXZYzG4BjarKQgHGd4D9K7L0MG1f11CMxsloLXFuwJuzQujPX2fgKcdQxD6MHpCPlnHTRQxdvbrR/cVVkKbv2UmmeG1LEtI6w4gWVVmHKy924YR7mJXqVimHdWB2JCNm0H0lOxz0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c3bbb098a82811f19a56ed5b684f684d-20260904
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c792123f-bbc2-46f5-8ba9-af878e796901,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:c792123f-bbc2-46f5-8ba9-af878e796901,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:78b1adb4db2f047bc9bbc583b8220a2c,BulkI
	D:260904140202TY0MLTEZ,BulkQuantity:1,SF:17|19|66|78|81|82|102|127|136|850
	|865|898,TC:nil,Content:0|15|50|99,EDM:5|-100,IP:-2,URL:0,File:nil,RT:nil,
	Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c3bbb098a82811f19a56ed5b684f684d-20260904
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1430395546; Fri, 04 Sep 2026 14:20:46 +0800
From: Zhe Liu <liuzhe1@kylinos.cn>
To: mkoutny@suse.com
Cc: bsegall@google.com,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	dietmar.eggemann@arm.com,
	hannes@cmpxchg.org,
	juri.lelli@redhat.com,
	kprateek.nayak@amd.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	liuzhe1@kylinos.cn,
	mgorman@suse.de,
	mingo@redhat.com,
	peterz@infradead.org,
	rostedt@goodmis.org,
	skhan@linuxfoundation.org,
	tj@kernel.org,
	vincent.guittot@linaro.org,
	vschneid@redhat.com
Subject: [PATCH v2 2/3] selftests: cgroup: Test CPU quota and burst write order
Date: Fri,  4 Sep 2026 14:20:12 +0800
Message-Id: <20260904062013.504236-3-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260904062013.504236-1-liuzhe1@kylinos.cn>
References: <aobnZEh1hfIBhswD@localhost.localdomain>
 <20260904062013.504236-1-liuzhe1@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test that quota and burst can be written in either order without losing
the configured burst value.

Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_cpu.c | 40 +++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index f9f7017d9299..b13c2535afcd 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -733,6 +733,45 @@ static int test_cpucg_max(const char *root)
 	return ret;
 }
 
+static int test_cpucg_max_burst(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *cpucg;
+
+	cpucg = cg_name(root, "cpucg_max_burst");
+	if (!cpucg)
+		return KSFT_FAIL;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	if (cg_write(cpucg, "cpu.max", "max 100000") ||
+	    cg_write(cpucg, "cpu.max.burst", "100000000") ||
+	    cg_write(cpucg, "cpu.max", "50000 100000") ||
+	    cg_read_strcmp(cpucg, "cpu.max.burst", "100000000\n"))
+		goto cleanup;
+
+	if (cg_write(cpucg, "cpu.max.burst", "80000") ||
+	    cg_write(cpucg, "cpu.max", "100000 100000") ||
+	    cg_read_strcmp(cpucg, "cpu.max.burst", "80000\n"))
+		goto cleanup;
+
+	if (cg_write(cpucg, "cpu.max.burst", "0") ||
+	    cg_write(cpucg, "cpu.max", "50000 100000") ||
+	    cg_write(cpucg, "cpu.max", "100000 100000") ||
+	    cg_write(cpucg, "cpu.max.burst", "80000") ||
+	    cg_read_strcmp(cpucg, "cpu.max.burst", "80000\n"))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_destroy(cpucg);
+	free(cpucg);
+
+	return ret;
+}
+
 /*
  * This test verifies that a process inside of a nested cgroup whose parent
  * group has a cpu.max value set, is properly throttled.
@@ -822,6 +861,7 @@ struct cpucg_test {
 	T(test_cpucg_nested_weight_overprovisioned),
 	T(test_cpucg_nested_weight_underprovisioned),
 	T(test_cpucg_max),
+	T(test_cpucg_max_burst),
 	T(test_cpucg_max_nested),
 };
 #undef T
-- 
2.25.1
