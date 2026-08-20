Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BE73451C6;
	Thu, 20 Aug 2026 03:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787196788; cv=none; b=Bh7+ATcrQp17UEXbrWkRYKUUW4YSCGKTSjWXP33TGJ71usfTZ71QzmYfKwl+VnEu8LR8G22qoXMRa9AS6XXfo5i9M5Rg5Oacty+1wIT4twCiiHX2yPltlZogudLTUhOqRsqamde1RpV1YuPQ5jlDJfwULTLk0xv01IYC6LKE/so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787196788; c=relaxed/simple;
	bh=3dgkS6ZokPyR/S6yg7PdenWbbws/GlaTVbnIhblcSDY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hti+soaHayNiWeMnbpFDXNqStxCyjsiy9nqhF6XknWdTtieWW6xpmyPneeHpj5tVeP12E88uH2vC7ODhVKMLtzxLhswKOvwlAk8NHsFr81OMBYNFm36wUJnLodN7IIXmpX5YPPq5pCtS0f7xgeC/rZF2c9tatCEufU4PtcTW7yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d4fa4d8e9c4711f19a56ed5b684f684d-20260820
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
X-CID-O-INFO: VERSION:1.3.19,REQID:6e1959b9-1773-4cb2-9bd7-82dc08fa252d,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:6e1959b9-1773-4cb2-9bd7-82dc08fa252d,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:77ebbf93918b82970434607637b987ff,BulkI
	D:260820112741HN9KR0P5,BulkQuantity:3,SF:17|19|38|66|78|81|82|102|127|136|
	850|865|898,TC:nil,Content:0|15|50,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d4fa4d8e9c4711f19a56ed5b684f684d-20260820
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1333806559; Thu, 20 Aug 2026 11:32:55 +0800
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
Subject: [PATCH 1/2] sched/fair: Reset incompatible burst on quota change
Date: Thu, 20 Aug 2026 11:32:17 +0800
Message-Id: <20260820033218.214259-2-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260820033218.214259-1-liuzhe1@kylinos.cn>
References: <20260820033218.214259-1-liuzhe1@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A burst configured while a cgroup has unlimited CPU bandwidth can prevent
a later finite quota from being installed.  For example, on cgroup v2:

  # echo 100000000 > cpu.max.burst
  # echo "50000 100000" > cpu.max
  sh: write error: Invalid argument

The quota remains unlimited because tg_set_bandwidth() validates the
existing burst against the new quota.  Recovering requires userspace to
know that it must clear the burst before retrying the quota update.  The
same problem affects cpu.cfs_quota_us on cgroup v1.

When changing the quota, reset the existing burst to zero if it is
incompatible with a valid finite quota.  Preserve it when it remains
compatible or when the new quota is unlimited.  This lets a quota update
take effect without depending on the order in which userspace writes the
two files.

Rejecting the quota would retain this ordering dependency.  Clamping the
burst would instead silently choose a different nonzero policy on behalf
of userspace.  Resetting it to zero provides the existing no-burst default
while leaving compatible bursts untouched.  Keeping the burst while the
quota is unlimited also allows userspace to stage a burst before enabling
bandwidth control.

Add a cgroup v2 regression test for the quota update behavior.

Fixes: f4183717b370 ("sched/fair: Introduce the burstable CFS controller")
Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---
 kernel/sched/core.c                       | 17 ++++++-
 tools/testing/selftests/cgroup/test_cpu.c | 62 +++++++++++++++++++++++
 2 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2e7cde033a31..324a4d22f8d1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10081,6 +10081,18 @@ static u64 cpu_period_read_u64(struct cgroup_subsys_state *css,
 	return period_us;
 }
 
+static u64 tg_burst_on_quota_change(u64 quota_us, u64 burst_us)
+{
+	if (quota_us == RUNTIME_INF || quota_us > max_bw_runtime_us)
+		return burst_us;
+
+	if (burst_us > quota_us ||
+	    burst_us > max_bw_runtime_us - quota_us)
+		return 0;
+
+	return burst_us;
+}
+
 static int tg_set_bandwidth(struct task_group *tg,
 			    u64 period_us, u64 quota_us, u64 burst_us)
 {
@@ -10169,6 +10181,7 @@ static int cpu_quota_write_s64(struct cgroup_subsys_state *css,
 		quota_us = RUNTIME_INF;
 
 	tg_bandwidth(tg, &period_us, NULL, &burst_us);
+	burst_us = tg_burst_on_quota_change(quota_us, burst_us);
 	return tg_set_bandwidth(tg, period_us, quota_us, burst_us);
 }
 
@@ -10492,8 +10505,10 @@ static ssize_t cpu_max_write(struct kernfs_open_file *of,
 
 	tg_bandwidth(tg, &period_us, NULL, &burst_us);
 	ret = cpu_period_quota_parse(buf, &period_us, &quota_us);
-	if (!ret)
+	if (!ret) {
+		burst_us = tg_burst_on_quota_change(quota_us, burst_us);
 		ret = tg_set_bandwidth(tg, period_us, quota_us, burst_us);
+	}
 	return ret ?: nbytes;
 }
 #endif /* CONFIG_CFS_BANDWIDTH */
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 7a40d76b9548..2686dd79941b 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -703,6 +703,67 @@ static int test_cpucg_max(const char *root)
 	return ret;
 }
 
+/*
+ * This test verifies that writing a finite cpu.max resets an incompatible
+ * cpu.max.burst, while preserving a compatible burst.
+ */
+static int test_cpucg_max_burst_reset(const char *root)
+{
+	char *cpucg = NULL;
+	int ret = KSFT_FAIL;
+
+	cpucg = cg_name(root, "cpucg_max_burst_reset_test");
+	if (!cpucg)
+		goto cleanup;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	/* An unconstrained group may retain a burst for later use. */
+	if (cg_write(cpucg, "cpu.max.burst", "100000000"))
+		goto cleanup;
+	if (cg_read_long(cpucg, "cpu.max.burst") != 100000000)
+		goto cleanup;
+
+	/* A finite quota must not be blocked by the incompatible burst. */
+	if (cg_write(cpucg, "cpu.max", "50000 100000"))
+		goto cleanup;
+	if (cg_read_long(cpucg, "cpu.max.burst") != 0)
+		goto cleanup;
+	if (cg_read_strcmp(cpucg, "cpu.max", "50000 100000\n"))
+		goto cleanup;
+
+	/* Keep a burst which remains valid across a quota update. */
+	if (cg_write(cpucg, "cpu.max", "100000 100000"))
+		goto cleanup;
+	if (cg_write(cpucg, "cpu.max.burst", "50000"))
+		goto cleanup;
+	if (cg_write(cpucg, "cpu.max", "75000 100000"))
+		goto cleanup;
+	if (cg_read_long(cpucg, "cpu.max.burst") != 50000)
+		goto cleanup;
+
+	/* An unlimited quota preserves burst until it becomes incompatible. */
+	if (cg_write(cpucg, "cpu.max", "max 100000"))
+		goto cleanup;
+	if (cg_read_long(cpucg, "cpu.max.burst") != 50000)
+		goto cleanup;
+
+	/* Reset the same burst when a later finite quota conflicts. */
+	if (cg_write(cpucg, "cpu.max", "25000 100000"))
+		goto cleanup;
+	if (cg_read_long(cpucg, "cpu.max.burst") != 0)
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
@@ -789,6 +850,7 @@ struct cpucg_test {
 	T(test_cpucg_nested_weight_overprovisioned),
 	T(test_cpucg_nested_weight_underprovisioned),
 	T(test_cpucg_max),
+	T(test_cpucg_max_burst_reset),
 	T(test_cpucg_max_nested),
 };
 #undef T
-- 
2.25.1

