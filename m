Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F79470809;
	Thu, 20 Aug 2026 03:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787196786; cv=none; b=YkUs+taj0oJq91CjvTFK8ZCt3xcmyIYHxJ07KKj0ybeQHIc5gFO/B4aa47y//ZzF5uz9mO7CBrMZUVKNJxFQEWgksC+5qSre8RUcXiOjQtfF9My92SWLpnnk0XNTabJVzgozz6uiKYRvbeA4KvtDRASi0szbnEduKckDmEZF9+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787196786; c=relaxed/simple;
	bh=b6xEHBns2c2hU47+bEyfUNzyCSgme87IV29E0szkGK0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WnPB35A0DdiFHN44QrXPW2VrfO27tYA5YKy+QsnbM95GEoDZAVXaKD+cggoUKjpS8+OYpGf8hf70+GPnhokc964+pb4Sj4C/oyqvWQ0MD+Wa7/0Ha1Ddvxwq2yTdDzfVTntNqUNThNFPNIc7Aht/iILfH/FcAVvDgmk5sAjVH40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d01267529c4711f19a56ed5b684f684d-20260820
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_UNTRUSTED, SA_LOWREP, SA_EXISTED, SN_UNTRUSTED, SN_LOWREP
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:80a4db06-be3d-4fff-b291-23855c8709f2,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:80a4db06-be3d-4fff-b291-23855c8709f2,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:bad166d6e8049b68bc7707a859358c7d,BulkI
	D:260820112741HN9KR0P5,BulkQuantity:2,SF:17|19|38|66|78|102|127|136|850|86
	5|898,TC:nil,Content:0|15|50,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d01267529c4711f19a56ed5b684f684d-20260820
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2074723568; Thu, 20 Aug 2026 11:32:47 +0800
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
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhe Liu <liuzhe1@kylinos.cn>
Subject: [PATCH 0/2] sched/fair: Reset incompatible burst on quota change
Date: Thu, 20 Aug 2026 11:32:16 +0800
Message-Id: <20260820033218.214259-1-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A burst configured while a cgroup has unlimited CPU bandwidth can prevent
a later finite quota from being installed.  On cgroup v2, for instance:

  # echo 100000000 > cpu.max.burst
  # echo "50000 100000" > cpu.max
  sh: write error: Invalid argument

The quota stays unlimited because tg_set_bandwidth() validates the existing
burst against the new quota, and the only recovery is for userspace to know
that it must clear the burst before retrying the quota update.  cgroup v1 has
the same problem through cpu.cfs_quota_us.

Patch 1 resets the existing burst to zero when a valid finite quota is written
that the burst is incompatible with, while preserving it when it remains
compatible or when the new quota is unlimited.  This lets a quota update take
effect regardless of the order in which userspace writes the two files, and
still allows a burst to be staged before bandwidth control is enabled.  A
cgroup v2 selftest is added for the behavior.

Patch 2 documents the reset behavior in the cgroup v1 and v2 CPU bandwidth
documentation.

Zhe Liu (2):
  sched/fair: Reset incompatible burst on quota change
  Documentation: describe burst reset on quota changes

 Documentation/admin-guide/cgroup-v2.rst   |  5 +-
 Documentation/scheduler/sched-bwc.rst     | 14 ++---
 kernel/sched/core.c                       | 17 ++++++-
 tools/testing/selftests/cgroup/test_cpu.c | 62 +++++++++++++++++++++++
 4 files changed, 90 insertions(+), 8 deletions(-)

-- 
2.25.1

