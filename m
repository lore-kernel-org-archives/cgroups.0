Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972913ACF10;
	Fri, 24 Jul 2026 10:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784888765; cv=none; b=cr3j+91iXvtKyNfu3M2/D19vEVX0YLKBZSddFT69XVrSE0/Br0h0z8ApHVXNfBrLuKYCEfla6E3ZS5kv8mBn4KSkbxvPYDnwd4g/Xnu9pJQp8IO+0FgT7gpsqf+EzzqISrggK/wQ/l9LkVat8XOc6DwF5vRHpAUMxydAXfqgdlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784888765; c=relaxed/simple;
	bh=22cB3O3ZCEGFjJr7ULZaHoFh3wLz+qZeSXcl9oN/0LI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QAhcP8uwCiIMCU/7gv46CgcU4+d4fxl3t6VqETywdENPpvo6rRjwXBHbbdxJDmq+HrPwsK7GuU78x9Sm53lLrLGJAsZqWXFQUHxxiFvs1z/zeY+1ujcsZEOsR0iCwIirIPMfs33wtV8V+D3NIJo9raYZwz+gdbgi6aICR7uh4Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0d4399d8874a11f1aa26b74ffac11d73-20260724
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:a57fc3df-b1ef-484c-9a4f-339eee21f165,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:a57fc3df-b1ef-484c-9a4f-339eee21f165,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:545ba8ab6979f2a9ac6337e2f8038a54,BulkI
	D:26072418255754PFTS93,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0d4399d8874a11f1aa26b74ffac11d73-20260724
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1987956803; Fri, 24 Jul 2026 18:25:54 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: tj@kernel.org,
	skhan@linuxfoundation.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	corbet@lwn.net
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH] Docs/admin-guide/cgroup-v2: document hierarchical cpu.max throttling behavior
Date: Fri, 24 Jul 2026 18:25:00 +0800
Message-Id: <20260724102500.276525-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In a multi-level cgroup hierarchy, each level with cpu.max configured
maintains independent bandwidth accounting.  Unlike other Limits-type
controllers such as memory.max and io.max--where only the most
restrictive limit along the hierarchy applies--cpu.max enforces limits
at each level independently.  A process can thus be throttled
simultaneously by multiple levels, and the resulting throttling may
reflect the combined effect of all of them rather than any single
level's limit alone.

This behavior is already documented in the CFS bandwidth control
documentation (sched-bwc.rst) but was not mentioned in the cgroup-v2
interface description, which has led to confusion about unexpected
throttling statistics when cpu.max is configured at multiple levels.

Add a note to the cpu.max interface documentation in cgroup-v2.rst to
clarify the hierarchical enforcement semantics, and add a label to
sched-bwc.rst so that it can be cross-referenced.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 14 ++++++++++++++
 Documentation/scheduler/sched-bwc.rst   |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 14b8c571c0d1..3572d3e7f688 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1204,6 +1204,20 @@ will be referred to. All time durations are in microseconds.
 
 	This file affects only processes under the fair-class scheduler.
 
+	In a multi-level hierarchy, each level with cpu.max configured
+	maintains independent bandwidth accounting with its own period
+	timer.  The cgroup's own quota and ancestor quotas are enforced
+	independently rather than being mutually exclusive: when
+	multiple levels along the path have cpu.max set, a process is
+	subject to all of them simultaneously, and the resulting
+	throttling may reflect the combined effect of multiple levels
+	rather than any single level's limit alone (this differs from
+	other Limits-type controllers such as memory.max and io.max,
+	where the most restrictive limit along the hierarchy is
+	applied).  See :ref:`Documentation/scheduler/sched-bwc.rst
+	<sched-bwc>` for a description of the underlying CFS bandwidth
+	control mechanism and the hierarchical throttling behavior.
+
   cpu.max.burst
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "0".
diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
index e881a945c188..97c58739d8cf 100644
--- a/Documentation/scheduler/sched-bwc.rst
+++ b/Documentation/scheduler/sched-bwc.rst
@@ -2,6 +2,8 @@
 CFS Bandwidth Control
 =====================
 
+.. _sched-bwc:
+
 .. note::
    This document only discusses CPU bandwidth control for SCHED_NORMAL.
    The SCHED_RT case is covered in Documentation/scheduler/sched-rt-group.rst
-- 
2.25.1

