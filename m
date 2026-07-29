Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7F41C3BF7;
	Wed, 29 Jul 2026 10:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319561; cv=none; b=ir+dkFKeZj9Mz8BFcXEGQ2S43TphqXXsSgNUsBnkVvogKVIQ7CRRdxlCPtBRIZyuMHGJRJbDmfvWxhrBvMHTE+hTYFao0G+1TYQRkHmSPmg7PlMUYbU3wD6xt2J4sg/dMKEKLPk7u4J5nUYvs1d8HWSs8U0omvCjH/QS710GOW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319561; c=relaxed/simple;
	bh=J2iKHqC92XZvJzR98UQAuGDT5DVITDWw1wNLHigLCaw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TqWP/ulDDa0+PVrA0Eg5go+7lP36CMXgWQXn9dVl2MQB2RVdvOEx/NjQb5dlP4cCmzsUm0BQIWRcDyx3ThkAnOwo0zIhogjMQZDSOB0KtBrdchrhnGj5F1819PtPo6/Us2tA6+RolsZZOsIneUTwpG173vunQPH8xxi02/6ykAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 13a5ebf28b3511f1aa26b74ffac11d73-20260729
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
X-CID-O-INFO: VERSION:1.3.12,REQID:f28ff21f-5b99-4a5b-b82f-66730e402871,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:f28ff21f-5b99-4a5b-b82f-66730e402871,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:40900feb8f4fa2fa4b5b0f0a428e46cf,BulkI
	D:260729180552HHW0B8Z1,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 13a5ebf28b3511f1aa26b74ffac11d73-20260729
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 602126362; Wed, 29 Jul 2026 18:05:50 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH 0/2] selftests/cgroup: misc cleanups for test_cpu.c
Date: Wed, 29 Jul 2026 18:04:49 +0800
Message-Id: <20260729100451.689458-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series contains two minor cleanups to the cgroup cpu
controller selftests:

  - Patch 1 removes a redundant user_usec read in test_cpucg_nice
    that is never used after being read.

  - Patch 2 makes test_cpucg_max and test_cpucg_max_nested write
    both quota and period explicitly to cpu.max instead of relying
    on the kernel default period, making the tests self-documenting
    and the remainder calculation genuinely useful. Misleading
    variable names are also cleaned up.

Shaojie Sun (2):
  selftests/cgroup: remove unused user_usec read in test_cpucg_nice
  selftests/cgroup: write explicit period to cpu.max in max tests

 tools/testing/selftests/cgroup/test_cpu.c | 27 ++++++++++++-----------
 1 file changed, 14 insertions(+), 13 deletions(-)

-- 
2.25.1

