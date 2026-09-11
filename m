Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5A82D9484;
	Fri, 11 Sep 2026 09:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118632; cv=none; b=YC3pTKgym6OqcktTngUZA3HBIEJql1tqtxHpUkMew+gRhCbz/F5gSDXTxYcdMOUYFApmZRHUftPwZpDk97La6cE1cWEBRmJOZJld2fZn5DIZnJtQQonZ7YnkKTQE3j/MaqQzdG+TcQD7lCKtnwGVBcBQsFR+xYX5zvGBpfTUfZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118632; c=relaxed/simple;
	bh=KXR6Z8gYi/AiRFAKeYmWCMuM2MYiJg7aMl71chLm240=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MKGBXFapi20UZbMH6t9JdcV1HWUzbdiDUwudo8S1BqqBhjg+9b9u2USM/lRGIX8uT101mtdCn8qyI2C86CHdvKn9irFJ4Pqbefdw2On2nN5w4QHKxcYphjBMB8sHdsZHURdyUSH7ix8OcjzsQYuMo2yjfSQb1FBat15j052eLaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 77e6a02aadc211f19a56ed5b684f684d-20260911
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_FG_IT
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:8eccc99a-96c9-49e9-ac01-a6bf76a7a76f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:8eccc99a-96c9-49e9-ac01-a6bf76a7a76f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:cddfeb7b4b0f3a5732504896e4429164,BulkI
	D:260911163847ZVY704ZU,BulkQuantity:13,SF:17|19|38|66|78|102|127|136|850|8
	65|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:99|1,File:nil,RT:ni
	l,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_OBB,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR,
	TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 77e6a02aadc211f19a56ed5b684f684d-20260911
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 155755385; Fri, 11 Sep 2026 17:23:37 +0800
From: Zhe Liu <liuzhe1@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org
Cc: skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	dtcccc@linux.alibaba.com,
	changhuaixin@linux.alibaba.com,
	shanpeic@linux.alibaba.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Zhe Liu <liuzhe1@kylinos.cn>
Subject: [PATCH v3 0/3] sched/fair: remove quota/burst write-order dependency
Date: Fri, 11 Sep 2026 17:22:55 +0800
Message-Id: <20260911092258.660771-1-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CPU bandwidth quota and burst controls currently make the order of
userspace writes significant. A burst configured while quota is unlimited
can prevent a later finite quota from being installed, and updating the
burst before increasing the quota can fail with -EINVAL.

Remove the write-order dependency by decoupling burst validation from the
current quota. The previous quota-relative checks implicitly limited the
maximum configurable burst to max_bw_runtime_us / 2 for a finite quota,
so retain that limit as an independent upper bound.

Keep the configured burst unchanged across quota updates, and cap the
burst actually available at refill time to min(burst, quota). This allows
cpu.max and cpu.max.burst to be updated in either order without changing
the maximum burst previously allowed for a finite quota.

The series also adds a selftest covering both write orders and documents
the resulting behavior for cgroup v1 and cgroup v2.

---
Changes in v3:
- Use max_bw_runtime_us / 2 as an independent upper bound for burst,
  preserving the maximum burst previously allowed with a finite quota
  while removing its dependency on the current quota.
- Drop Cc: stable@vger.kernel.org from patch 1.
- Update the cpu.max.burst documentation to describe the configured burst
  independently of the current quota and the quota-relative clamp applied
  at runtime refill.

Changes in v2:
- Keep the configured burst independent of quota changes instead of
  adjusting or resetting it when the quota is updated.
- Move the quota-relative restriction to the CFS runtime refill path,
  where the effective burst is capped to the current quota.
- Add selftests covering quota and burst updates in both write orders and
  document the resulting behavior for cgroup v1 and cgroup v2.

v2: https://lore.kernel.org/all/20260904062013.504236-1-liuzhe1@kylinos.cn/
v1: https://lore.kernel.org/all/20260820033218.214259-1-liuzhe1@kylinos.cn/

Zhe Liu (3):
  sched/fair: remove quota/burst write-order dependency
  selftests: cgroup: test CPU quota and burst write order
  docs: cgroup-v2: document CPU quota and burst ordering

 Documentation/admin-guide/cgroup-v2.rst   |  7 +++-
 Documentation/scheduler/sched-bwc.rst     | 22 ++++++++-----
 kernel/sched/core.c                       |  3 +-
 kernel/sched/fair.c                       |  3 +-
 tools/testing/selftests/cgroup/test_cpu.c | 40 +++++++++++++++++++++++
 5 files changed, 62 insertions(+), 13 deletions(-)


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.25.1

