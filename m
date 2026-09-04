Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AC641A766;
	Fri,  4 Sep 2026 06:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502851; cv=none; b=lBoZIgrrbw03Rd9fL6BSMW8ZL/G5kOPh8sj/AAo8iHHORg6GOp0128FErEv89dQQ/FGn8WlNWy7aCFU9aJSERBUOdwQDlP8dzDaiik/p9L+m/TSDyCrrVKX/IvHoUJGAnfyHkrJ6JlQx5HqgbuleZ0zVJca/a/ObTrwVv2S4MPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502851; c=relaxed/simple;
	bh=uUl5TUx1pnfaVQA8lLhnfzeRXvU6dGVODw0tLincpbA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iLY8KCAUdo7OKBtoKxHwBJw7+EQj7I9lQl8uni76yLDfC0x6qyuyaIsLDKp2HQpiledbWwQXuGEYQrSRnLfikZDI25X4eYtIXb1QtFIYDCsMYYtNERAo3u5jBXdC/iG1TQicpXmHCaYPCh8VT/CcX5sJ9MPTQ+G8CiAv4h/TeaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: be051130a82811f19a56ed5b684f684d-20260904
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
X-CID-O-INFO: VERSION:1.3.19,REQID:53ec030e-a809-4b08-b39e-4445004c419f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:53ec030e-a809-4b08-b39e-4445004c419f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:1af869afdf5f6162e8062e8862059f0a,BulkI
	D:260904140114ZJEVG48C,BulkQuantity:2,SF:17|19|66|78|81|82|102|127|136|850
	|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: be051130a82811f19a56ed5b684f684d-20260904
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 42094721; Fri, 04 Sep 2026 14:20:36 +0800
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
Subject: [PATCH v2 0/3] sched/fair: remove quota/burst write-order dependency
Date: Fri,  4 Sep 2026 14:20:10 +0800
Message-Id: <20260904062013.504236-1-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aobnZEh1hfIBhswD@localhost.localdomain>
References: <aobnZEh1hfIBhswD@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CPU bandwidth quota and burst controls currently make the order of
userspace writes significant. A burst configured while quota is unlimited can
prevent a later finite quota from being installed, and increasing quota and
burst in the burst-first order can fail with EINVAL.

This series keeps the configured burst value independent of the current quota
and applies the quota-relative clamp when CFS refills runtime. It also adds a
selftest for both write orders and documents the resulting behavior for cgroup
v1 and cgroup v2.

Changes in v2:
  - apply the clamp at refill time instead of changing the configured burst;
  - retain the value reported by cpu.max.burst and cpu.cfs_burst_us;
  - add write-order selftests and update the CPU bandwidth documentation.

Testing:
  make -C tools/testing/selftests TARGETS=cgroup

Zhe Liu (3):
  sched/fair: Remove the write-order dependency between cpu.max and
    cpu.max.burst
  selftests: cgroup: Test CPU quota and burst write order
  Documentation: describe CPU quota and burst ordering

 Documentation/admin-guide/cgroup-v2.rst   |  5 ++-
 Documentation/scheduler/sched-bwc.rst     | 21 ++++++-----
 kernel/sched/core.c                       |  3 +-
 kernel/sched/fair.c                       |  3 +-
 tools/testing/selftests/cgroup/test_cpu.c | 40 +++++++++++++++++++++++
 5 files changed, 59 insertions(+), 13 deletions(-)

-- 
2.25.1
