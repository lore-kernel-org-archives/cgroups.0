Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B94231A07F;
	Tue, 11 Aug 2026 09:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786442372; cv=none; b=dR8BOjMju/OX+e35EtgJKGgacXdSCxEyrUUG00Ftrkbzcm+4j17nT7nEjSJhTyoaN4jufYdwIO8yudhqG6UjIFdXDARYb2BOHVRRbq1qaNlGniUm1zGmbS2eZFNA1lvsWy5165XcEY76z7S116Yky5ePtNIpaM4HN/LLWUlVRdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786442372; c=relaxed/simple;
	bh=zBMV6/qswcZqIojxvtZfvGlIigfVXAaWoAZSQsV0cOE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZYiFG+imnukTuG7vmsPjAs9M983XXWLqah4FxY8U8W2Lz0sKwXHfgBBufOYeMOnURcJAekj0hRnYQTrc8fCzrcmfmMl/SuYT3lUHhEkZwZLlLB8d+Tq16gQCXHsDtq0uldF1dCEQoboj9YPPInT4c3T1t1nWxEUsk3wnwpzwRAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 50c53a5c956b11f1aa26b74ffac11d73-20260811
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5ba865ed-7cf4-4dbd-b61d-440f05fb4337,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:5ba865ed-7cf4-4dbd-b61d-440f05fb4337,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:8f94314cfab10f26a4df059c3eb87df4,BulkI
	D:260811175921MA10VOIB,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk
	:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 50c53a5c956b11f1aa26b74ffac11d73-20260811
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 384864404; Tue, 11 Aug 2026 17:59:17 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: longman@redhat.com
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	mkoutny@suse.com,
	ridong.chen@linux.dev,
	shuah@kernel.org,
	sunshaojie@kylinos.cn,
	tj@kernel.org
Subject: [PATCH v2] cgroup/cpuset: Add test for partition root invalidation returning wrong CPUs
Date: Tue, 11 Aug 2026 17:58:48 +0800
Message-Id: <20260811095848.365138-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <4a8cec73-0b25-424d-9f0a-314e221211fa@redhat.com>
References: <4a8cec73-0b25-424d-9f0a-314e221211fa@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test case to REMOTE_TEST_MATRIX covering the bug fixed by
commit 345f40166694 ("cgroup/cpuset: Return only actually allocated
CPUs during partition invalidation"). The test verifies that when a
sibling partition root changes its cpuset.cpus to overlap with another
partition root, only actually allocated CPUs (effective_xcpus) are
returned to the parent, not all CPUs in cpus_allowed.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 0d41aa0d343d..236cb1b38178 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -502,6 +502,12 @@ REMOTE_TEST_MATRIX=(
 	"  C1-4:P1   .   C1-2:P1  C1-3:P2  .       .  \
 	      .      .      P0     C2-3    .       .     p1:1,4|c11:1|c12:2-3 \
 							 p1:P1|c11:P0|c12:P2 2-3"
+	# Changing a sibling partition's cpuset.cpus to overlap with another
+	# sibling partition should invalidate itself and return only actually
+	# allocated CPUs (effective_xcpus) to the parent.
+	"  C1-4:P1   .   C1-2:P1  C2-4:P2  .       .  \
+	      .      .     .         C1-2  .       .     p1:3-4|c11:1-2|c12:3-4 \
+							 p1:P1|c11:P1|c12:P-2"
 )
 
 #
-- 
2.25.1

