Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1542770809;
	Thu, 20 Aug 2026 03:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787196796; cv=none; b=Ii5tKQGPJCGEorZu1xMBK3RVlDYlTpqkDxuK6rl5IlNAaRlOy14JuDSSIM+Z7aLHS+EnsavyvwZIlz64PfTafMmcFg8IQbjfX/I6yoJwZv/b4b0xF6iCsMeUUpkXUczFwx4dO5d6J50bJV8wnh9jmD+i8cS+zyeq1qS/BxYeZss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787196796; c=relaxed/simple;
	bh=xXPbDT7vGs6wueK/VwC1fBhsuNWbYEm1hQ9WeruVY0c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mffgqUp/J6yXQi8cxnSh3DX56of3IyUbA0m8O8dp4+vvKOd7rMUkZ1DT/tQTFoHoTia1tQr7CuOrkCQnniTPZ4f4sXNGS7AxkEjTJKyuhwNzOHHHkYfrv8B6FAnKW2Jl5qCL/0OGvOyEdkv0dCWp6UtFE5l3ozvowNc+RAky/pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d7146c589c4711f19a56ed5b684f684d-20260820
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
X-CID-O-INFO: VERSION:1.3.19,REQID:a4c6142c-1760-4e78-9667-016fa83a293a,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:a4c6142c-1760-4e78-9667-016fa83a293a,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:b5620d622c810dd47606d8ed7488c307,BulkI
	D:2608201128202I10ZPYF,BulkQuantity:1,SF:17|19|38|66|78|81|82|102|127|136|
	850|865|898,TC:nil,Content:0|15|50,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d7146c589c4711f19a56ed5b684f684d-20260820
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2037768217; Thu, 20 Aug 2026 11:32:59 +0800
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
Subject: [PATCH 2/2] Documentation: describe burst reset on quota changes
Date: Thu, 20 Aug 2026 11:32:18 +0800
Message-Id: <20260820033218.214259-3-liuzhe1@kylinos.cn>
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

Document that an incompatible burst is reset when a finite quota is
written through the cgroup v1 or cgroup v2 CPU bandwidth interface, while
compatible bursts and unlimited quota updates preserve the existing value.

Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst |  5 ++++-
 Documentation/scheduler/sched-bwc.rst   | 14 ++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index aed195a71cbf..9f5e43d96476 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1200,7 +1200,10 @@ will be referred to. All time durations are in microseconds.
 
 	which indicates that the group may consume up to $MAX in each
 	$PERIOD duration.  "max" for $MAX indicates no limit.  If only
-	one number is written, $MAX is updated.
+	one number is written, $MAX is updated.  When a finite $MAX is
+	written, an existing cpu.max.burst value which is incompatible
+	with the new limit is reset to zero.  Writing "max" leaves the
+	burst value unchanged.
 
 	This file affects only processes under the fair-class scheduler.
 
diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
index e881a945c188..79bd5f254e50 100644
--- a/Documentation/scheduler/sched-bwc.rst
+++ b/Documentation/scheduler/sched-bwc.rst
@@ -90,14 +90,16 @@ bandwidth restriction in place, such a group is described as an unconstrained
 bandwidth group. This represents the traditional work-conserving behavior for
 CFS.
 
-Writing any (valid) positive value(s) no smaller than cpu.cfs_burst_us will
-enact the specified bandwidth limit. The minimum quota allowed for the quota or
-period is 1ms. There is also an upper bound on the period length of 1s.
-Additional restrictions exist when bandwidth limits are used in a hierarchical
-fashion, these are explained in more detail below.
+Writing any valid positive value will enact the specified bandwidth limit. If
+the existing cpu.cfs_burst_us value is incompatible with the new quota, it is
+reset to zero. The minimum quota allowed for the quota or period is 1ms. There
+is also an upper bound on the period length of 1s. Additional restrictions
+exist when bandwidth limits are used in a hierarchical fashion, these are
+explained in more detail below.
 
 Writing any negative value to cpu.cfs_quota_us will remove the bandwidth limit
-and return the group to an unconstrained state once more.
+and return the group to an unconstrained state once more. The existing
+cpu.cfs_burst_us value remains unchanged.
 
 A value of 0 for cpu.cfs_burst_us indicates that the group can not accumulate
 any unused bandwidth. It makes the traditional bandwidth control behavior for
-- 
2.25.1

