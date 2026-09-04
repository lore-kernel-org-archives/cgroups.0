Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B024343F2;
	Fri,  4 Sep 2026 06:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502861; cv=none; b=VcP5AH33yCVY+ddPbKR+qXzB+b3y8Tg5DQVrTJ9cJvq9S/IgplrnOafCJG8ao8jDzgNwvgjFiDY2++BbltVr1VPusQK34yXZuXDd1JBY4+ocr02b0fDdX9Sr+psZ9StC22sGlgV0qRpB/jUBTIoyGJgysmvHKRzWuB/bsqpWjXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502861; c=relaxed/simple;
	bh=vjjwnZKTmpSoCzEX6B+atdLSf/jTDKGaw79jufSgLB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sX6D+YsQsq+QCcpAchHgKs1ZhmByLGrxybkaN6NPjMvsC/x9ZvnDSfVz8Z5pW/5JgIj/T8KAKQfTx3r5zvrV+3HZhPbtNYtOLZUcrk7QvdzllNdyOSTWnwZbTQmdP9x18K22lRrF8p97DOFdKO+66LQEi/G8CW25W86uWeCycAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c5b99d4ca82811f19a56ed5b684f684d-20260904
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
X-CID-O-INFO: VERSION:1.3.19,REQID:a5f8d2f1-70ff-46d2-936c-5892c1d407d8,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:a5f8d2f1-70ff-46d2-936c-5892c1d407d8,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:0766db24e3ba21c8fadd283d7e52bd08,BulkI
	D:260904140205JEG5SQEN,BulkQuantity:1,SF:17|19|66|78|81|82|102|127|136|850
	|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c5b99d4ca82811f19a56ed5b684f684d-20260904
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1096141703; Fri, 04 Sep 2026 14:20:49 +0800
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
Subject: [PATCH v2 3/3] Documentation: describe CPU quota and burst ordering
Date: Fri,  4 Sep 2026 14:20:13 +0800
Message-Id: <20260904062013.504236-4-liuzhe1@kylinos.cn>
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

Document the independent quota and burst configuration and the runtime
burst clamp.

Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst |  5 ++++-
 Documentation/scheduler/sched-bwc.rst   | 21 ++++++++++++---------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7c2a8ed80071..57253c2c1819 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1229,7 +1229,10 @@ will be referred to. All time durations are in microseconds.
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "0".
 
-	The burst in the range [0, $MAX].
+	The burst in the range [0, $MAX]. The configured value is retained when
+	the quota changes and may be larger than the current quota. During CFS
+	runtime refill, the effective burst is limited to the current quota.
+	The quota and burst files can therefore be written in either order.
 
 	This file affects only processes under the fair-class scheduler.
 
diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
index e881a945c188..08a54ee84da2 100644
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
+Writing any valid quota value will enact the specified bandwidth limit. The
+minimum quota allowed for the quota or period is 1ms. There is also an upper
+bound on the period length of 1s. Additional restrictions exist when bandwidth
+limits are used in a hierarchical fashion, these are explained in more detail
+below.
 
 Writing any negative value to cpu.cfs_quota_us will remove the bandwidth limit
 and return the group to an unconstrained state once more.
 
 A value of 0 for cpu.cfs_burst_us indicates that the group can not accumulate
 any unused bandwidth. It makes the traditional bandwidth control behavior for
-CFS unchanged. Writing any (valid) positive value(s) no larger than
-cpu.cfs_quota_us into cpu.cfs_burst_us will enact the cap on unused bandwidth
-accumulation.
+CFS unchanged. A valid positive value written to cpu.cfs_burst_us is retained
+when the quota changes. If it is larger than the current quota, CFS limits the
+effective burst during runtime refill to the current quota.
+
+The quota and burst files can be updated in either order.
 
 Any updates to a group's bandwidth specification will result in it becoming
 unthrottled if it is in a constrained state.
@@ -243,4 +245,5 @@ Examples
 	# echo 50000 > cpu.cfs_period_us /* period = 50ms */
 	# echo 10000 > cpu.cfs_burst_us /* burst = 10ms */
 
-   Larger buffer setting (no larger than quota) allows greater burst capacity.
+   A larger buffer setting allows greater burst capacity. If the configured
+   burst is larger than the quota, the effective burst is limited to the quota.
-- 
2.25.1
