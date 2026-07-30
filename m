Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4CD419310;
	Thu, 30 Jul 2026 13:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785416864; cv=none; b=Grtgp9GrwCdp76OBYHPxoVi96CXMe4FzNYWOdP3GkTlftau/I8qCuYmoHUaJ4JaqIL5FVb8EKLdjZR7H9sbhwGmtaKWEbEs/IfZRmCJlYgWi32y7Y9Yvbxcl49EJ+I5RUk0G5cCm/GafJO6TTfduFjPb9SSQCdcPkiO3W9MZsqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785416864; c=relaxed/simple;
	bh=iI2iVuAgWWW+LXM2DwlZZV17MfsfBsP61WW2fOWo8XY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EL8NyOOD+9+nXERyx69RmkzmGlhG5sR0jJ7qxMJQeDz/7BRXnwnIj85bEQRTAQbv9gazRBtFz1eN6mQ2MQdMFHbiWDS2JI9ZllmRYmZyV857dwQWbt5KxjCNHzEj4VKPGIbDlEAeY0/csQ6VL/VGgxMnst8FUqYR43GcMTCXepQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9e43710c8c1711f1aa26b74ffac11d73-20260730
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
X-CID-O-INFO: VERSION:1.3.12,REQID:7e5adc1a-1d6e-4384-9149-c3ae899ac799,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.12,REQID:7e5adc1a-1d6e-4384-9149-c3ae899ac799,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:e7bac3a,CLOUDID:39c320572c7efb317360af1dc3df1baa,BulkI
	D:260730210734W7YZYM6M,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9e43710c8c1711f1aa26b74ffac11d73-20260730
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 352084493; Thu, 30 Jul 2026 21:07:29 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: mkoutny@suse.com
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org,
	sunshaojie@kylinos.cn,
	tj@kernel.org
Subject: [PATCH v2] selftests/cgroup: add user_usec sanity check in test_cpucg_nice
Date: Thu, 30 Jul 2026 21:07:17 +0800
Message-Id: <20260730130717.1236233-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <amnqUlrPxhTobE1E@localhost.localdomain>
References: <amnqUlrPxhTobE1E@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In test_cpucg_nice, after the child process exits, user_usec is
read from cpu.stat but the value is not checked. Add a sanity check
to ensure user_usec > 0, analogous to test_cpucg_stats(), so that
the test fails early if CPU usage wasn't properly accounted.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
v2: Instead of simply removing the unused user_usec read, add a sanity
    check (if user_usec <= 0, goto cleanup) analogous to test_cpucg_stats(),
    as suggested by Michal.

 tools/testing/selftests/cgroup/test_cpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 7a40d76b9548..5a44705ed3fd 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -291,6 +291,8 @@ static int test_cpucg_nice(const char *root)
 
 		user_usec = cg_read_key_long(cpucg, "cpu.stat", "user_usec");
 		nice_usec = cg_read_key_long(cpucg, "cpu.stat", "nice_usec");
+		if (user_usec <= 0)
+			goto cleanup;
 		if (!values_close_report(nice_usec, expected_nice_usec, 1))
 			goto cleanup;
 
-- 
2.25.1

