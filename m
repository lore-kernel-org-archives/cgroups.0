Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B25035E1CC;
	Fri, 11 Sep 2026 09:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118646; cv=none; b=pJn5VIYGVT4H6bJsD2+aWV2Ns5xTvX0WGmejHjP4leZ5TCYeuBjV0oV/N4Pjc9itSqEF0wla94iEKE1XQEG9rtM0DNUPpbz509Y3cjh9vkloemY6HhjBEmrWSYB+dROzW32zO2+UOrNbgM0eNBElD+xi1h3MnYJVnduM1OdAjAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118646; c=relaxed/simple;
	bh=Sfd8ZgRtiG55d4LBdYws7fViMlYKKVBDaZg+zx7RwXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cB0XKxOwg0LQbd9+oxbk7xRezthYWVdrPM4gvk2+hn9KIM58PHXjiFRaRpAV+1Pw5dIfAozun2EHRdcKeQ9uPuRd9brUDHkwr1o3yOyOyUb/4vG/PUnQMHjLJJgU7gVwKtJzFHSlWizouNjP5sU7u0RJcdgyjje7qW2xKGgqMN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 816ca6bcadc211f19a56ed5b684f684d-20260911
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:cd898db3-aa58-4243-9f15-549dc5c5af81,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:cd898db3-aa58-4243-9f15-549dc5c5af81,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:d588ab34e2fae290c15b505d55a92e3c,BulkI
	D:260911163932ELB1A0S5,BulkQuantity:6,SF:17|19|38|66|78|81|82|102|127|136|
	850|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 816ca6bcadc211f19a56ed5b684f684d-20260911
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1964776151; Fri, 11 Sep 2026 17:23:53 +0800
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
Subject: [PATCH v3 3/3] docs: cgroup-v2: document CPU quota and burst ordering
Date: Fri, 11 Sep 2026 17:22:58 +0800
Message-Id: <20260911092258.660771-4-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911092258.660771-1-liuzhe1@kylinos.cn>
References: <20260911092258.660771-1-liuzhe1@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document that quota and burst can be configured in either order, and that
the configured burst is retained across quota changes while its runtime
contribution is capped by the current quota.

Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst |  7 ++++++-
 Documentation/scheduler/sched-bwc.rst   | 22 +++++++++++++---------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 86a2a0099178..e94285d48d0c 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1231,7 +1231,12 @@ will be referred to. All time durations are in microseconds.
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "0".
 
-	The burst in the range [0, $MAX].
+	The burst in microseconds, with a lower bound of 0 and an upper bound
+	independent of the current quota. The configured value is retained
+	when the quota changes and may be larger than the current quota.
+	During CFS runtime refill, the burst contribution is capped at the
+	current quota. The quota and burst files can therefore be written
+	in either order.
 
 	This file affects only processes under the fair-class scheduler and a BPF
 	scheduler with the ``cgroup_set_bandwidth`` callback depending on what
diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
index e881a945c188..19cd08195f6b 100644
--- a/Documentation/scheduler/sched-bwc.rst
+++ b/Documentation/scheduler/sched-bwc.rst
@@ -90,20 +90,22 @@ bandwidth restriction in place, such a group is described as an unconstrained
 bandwidth group. This represents the traditional work-conserving behavior for
 CFS.
 
-Writing any (valid) positive value(s) no smaller than cpu.cfs_burst_us will
-enact the specified bandwidth limit. The minimum quota allowed for the quota or
-period is 1ms. There is also an upper bound on the period length of 1s.
-Additional restrictions exist when bandwidth limits are used in a hierarchical
-fashion, these are explained in more detail below.
+Writing any valid positive quota value will enact the specified bandwidth
+limit. The minimum quota allowed for the quota or period is 1ms. There is
+also an upper bound on the period length of 1s. Additional restrictions
+exist when bandwidth limits are used in a hierarchical fashion, these are
+explained in more detail below.
 
 Writing any negative value to cpu.cfs_quota_us will remove the bandwidth limit
 and return the group to an unconstrained state once more.
 
 A value of 0 for cpu.cfs_burst_us indicates that the group can not accumulate
 any unused bandwidth. It makes the traditional bandwidth control behavior for
-CFS unchanged. Writing any (valid) positive value(s) no larger than
-cpu.cfs_quota_us into cpu.cfs_burst_us will enact the cap on unused bandwidth
-accumulation.
+CFS unchanged. A valid positive value written to cpu.cfs_burst_us is retained
+when the quota changes. If it is larger than the current quota, the burst
+contribution during runtime refill is capped at the current quota.
+
+The quota and burst files can be updated in either order.
 
 Any updates to a group's bandwidth specification will result in it becoming
 unthrottled if it is in a constrained state.
@@ -243,4 +245,6 @@ Examples
 	# echo 50000 > cpu.cfs_period_us /* period = 50ms */
 	# echo 10000 > cpu.cfs_burst_us /* burst = 10ms */
 
-   Larger buffer setting (no larger than quota) allows greater burst capacity.
+   A larger buffer setting allows greater burst capacity. If the configured
+   burst is larger than the quota, the burst contribution is capped at the
+   quota during runtime refill.
-- 
2.25.1

