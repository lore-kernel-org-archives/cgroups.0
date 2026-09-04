Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F847358378;
	Fri,  4 Sep 2026 06:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502857; cv=none; b=i2D2uNZFI2Qb7CPh3Wd+soOqysobgPdDDWmEnSpzBcPfmGLT8mucikXJ3lFvu2OzzBjRRfj086i2gDHGXvGU4VNNBlHlDdrLO9nUyhIsS7c4mOFmSFr5S9N+eEfbdcSJCPnrk+OV1gOgac4uks5VCUW62EvfAleDGgdoJVSMzVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502857; c=relaxed/simple;
	bh=OfT3XxWYJYsLyekUE8AYRGRGg/tCiDb56aMjQq9HR74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O90GUS3kzVgz/TjiugMju2bldU/immtqK4xAWUsX6MxxihLFAmJ0DVcsWavE+ODKLZs++jHM6CfnOZq/7h32UDH/Pzv4hE4FTSIUe4+tQw3fUkoKIViY34MpnCO5SoIq+64QVghzTHWCgwOL5Gnn9kWr5MEHyd9tPWE10EapVf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c1f55886a82811f19a56ed5b684f684d-20260904
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
X-CID-O-INFO: VERSION:1.3.19,REQID:9d7a1e0c-694a-456e-9df9-882ad9aeb903,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.19,REQID:9d7a1e0c-694a-456e-9df9-882ad9aeb903,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:7db8b62,CLOUDID:762f98f57e8331037737a825e3a18d9a,BulkI
	D:260904140159BPD4Y87M,BulkQuantity:2,SF:17|19|66|78|81|82|102|127|136|850
	|865|898,TC:nil,Content:0|15|50|99,EDM:5|-100,IP:-2,URL:0,File:nil,RT:nil,
	Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c1f55886a82811f19a56ed5b684f684d-20260904
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 217919923; Fri, 04 Sep 2026 14:20:43 +0800
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
	vschneid@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] sched/fair: Remove the write-order dependency between cpu.max and cpu.max.burst
Date: Fri,  4 Sep 2026 14:20:11 +0800
Message-Id: <20260904062013.504236-2-liuzhe1@kylinos.cn>
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

Keep the configured burst independent of the current quota and cap it
when CFS refills runtime. This allows quota and burst updates in either
order.

Fixes: f4183717b370 ("sched/fair: Introduce the burstable CFS controller")

Cc: stable@vger.kernel.org
Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---
 kernel/sched/core.c | 3 +--
 kernel/sched/fair.c | 3 ++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f78275192036..5269b8cfcf7f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10159,8 +10159,7 @@ static int tg_set_bandwidth(struct task_group *tg,
 	if (quota_us != RUNTIME_INF && quota_us > max_bw_runtime_us)
 		return -EINVAL;
 
-	if (quota_us != RUNTIME_INF && (burst_us > quota_us ||
-					burst_us + quota_us > max_bw_runtime_us))
+	if (burst_us > max_bw_runtime_us)
 		return -EINVAL;
 
 #ifdef CONFIG_CFS_BANDWIDTH
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6d881e530f89..488de18d477e 100644
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
