Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1296473C64;
	Fri, 11 Sep 2026 09:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118638; cv=none; b=moqVTnBDMTXAt/mtEUCjgGZkIUq0ja5bfGNHgeptK9ZEp0yVOaTc62GhYfExZoat/ThY47Z05DL3ucL/el5XZH2a0YOVKXMJ0PDdnz2p8tUpPePY9JRJT00R8cabM6Y1KL0HqcSitayivhzjmpdvw50PjJmio5FkO3UW3cW4oII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118638; c=relaxed/simple;
	bh=TwOg2W1Rba3GiaVyt5+z3Hcq3VKX9TYFrET+K6HGuW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LHDfbn9hC6WkcI3yCmwCLfhnlCmjCsDnwqzcyHjHm9d76XJM/ii4tBZkP39lpuH5PaShNlLMurSDowXEk9t0fHjLX+CW73C74Yq4lXdgG0iLIc11T8oKCQjqbdDOyaqPfJIwsKWqUDyDLQO/bAOOOj8agkT+mPcMX/3DTVKi+zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 7db3d4faadc211f19a56ed5b684f684d-20260911
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:57a0b188-c647-48a8-b677-052f93c75c27,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:57a0b188-c647-48a8-b677-052f93c75c27,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:76b9662aae906c85325425ccc1c35306,BulkI
	D:260911163847ZVY704ZU,BulkQuantity:14,SF:17|19|38|66|78|81|82|102|127|136
	|850|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT
	:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_OBB,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7db3d4faadc211f19a56ed5b684f684d-20260911
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2090279726; Fri, 11 Sep 2026 17:23:46 +0800
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
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v3 1/3] sched/fair: remove quota/burst write-order dependency
Date: Fri, 11 Sep 2026 17:22:56 +0800
Message-Id: <20260911092258.660771-2-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911092258.660771-1-liuzhe1@kylinos.cn>
References: <20260911092258.660771-1-liuzhe1@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Burst validation currently depends on the active quota, so the same quota
and burst values may be accepted or rejected depending on the order in
which userspace updates them.

Make burst validation independent of the current quota while preserving,
for finite quotas, the previous maximum configurable burst at
max_bw_runtime_us / 2. Keep the configured burst across quota updates and
cap the effective burst to min(burst, quota) when CFS runtime is refilled.

Fixes: f4183717b370 ("sched/fair: Introduce the burstable CFS controller")
Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
Tested-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
---
 kernel/sched/core.c | 3 +--
 kernel/sched/fair.c | 3 ++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b998ef6b87af..c399f0a59c25 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10181,8 +10181,7 @@ static int tg_set_bandwidth(struct task_group *tg,
 	if (quota_us != RUNTIME_INF && quota_us > max_bw_runtime_us)
 		return -EINVAL;
 
-	if (quota_us != RUNTIME_INF && (burst_us > quota_us ||
-					burst_us + quota_us > max_bw_runtime_us))
+	if (burst_us > max_bw_runtime_us / 2)
 		return -EINVAL;
 
 #ifdef CONFIG_CFS_BANDWIDTH
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ade1eceb39b8..e6f9d9296fd2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6627,7 +6627,8 @@ void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 		cfs_b->nr_burst++;
 	}
 
-	cfs_b->runtime = min(cfs_b->runtime, cfs_b->quota + cfs_b->burst);
+	cfs_b->runtime = min(cfs_b->runtime,
+			     cfs_b->quota + min(cfs_b->burst, cfs_b->quota));
 	cfs_b->runtime_snap = cfs_b->runtime;
 }
 
-- 
2.25.1

