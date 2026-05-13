Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81753F661F
	for <cgroups@vger.kernel.org>; Wed, 13 May 2026 10:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778669492; cv=none; b=KzdYmYH5Bt0he0N3hSOp3cU9wIdRe2+KlpBx+1oQoMo9Qk4RL+OuoV41K80seCgKzWkkV0g1dOLU6BNUbcCdfIqDLRbGHTw5Q5NA49zlEQv9j7HynR3ETN5NQe9FfQuCR2r05MFPeKJDYDb5vsAcpeaQPERyuyioDXCpXNU2e0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778669492; c=relaxed/simple;
	bh=xCpWneMl4sIVjovAYhMDZmBSMP+X5uwFq2zJMKZXsHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaYFHZmIx3CPmzLW/A5/igogHWNnJe7O8eT8TLnaPpIQ+HaS2yg9c4kUa/jtSGdGY4nZXiJU7bkFxTqfPBSnW4SbJNXaO3tucXJpwjlP85L03yy7nrjGIcg3TlgZGp/GsEDwTK145NgEtCETvy6FqjawNg1mWDrkVBmn/VGGUCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ae3d873c4eb911f1aa26b74ffac11d73-20260513
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d80ad33f-4565-4b9e-af3c-fa28f0951220,IP:20,
	URL:0,TC:0,Content:100,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:115
X-CID-INFO: VERSION:1.3.12,REQID:d80ad33f-4565-4b9e-af3c-fa28f0951220,IP:20,UR
	L:0,TC:0,Content:100,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACT
	ION:quarantine,TS:115
X-CID-META: VersionHash:e7bac3a,CLOUDID:c3e70132d419fc244e44a5f33c212b7d,BulkI
	D:260513185125ZNIFBAP4,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|12
	7|898,TC:nil,Content:3|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ASC,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ae3d873c4eb911f1aa26b74ffac11d73-20260513
X-User: cuitao@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <cuitao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1479432696; Wed, 13 May 2026 18:51:22 +0800
From: Tao Cui <cuitao@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org
Cc: Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v2 4/4] cgroup/rdma: document rdma.peak, rdma.events and rdma.events.local
Date: Wed, 13 May 2026 18:49:56 +0800
Message-ID: <20260513104956.373216-5-cuitao@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513104956.373216-1-cuitao@kylinos.cn>
References: <20260513104956.373216-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add interface file documentation for the new rdma cgroup files to
Documentation/admin-guide/cgroup-v2.rst.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 54 +++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed99..c8763300e827 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2785,6 +2785,60 @@ RDMA Interface Files
 	  mlx4_0 hca_handle=1 hca_object=20
 	  ocrdma1 hca_handle=1 hca_object=23
 
+  rdma.peak
+	A read-only nested-keyed file that exists for all the cgroups
+	except root.  It shows the historical high watermark of
+	resource usage per device since the cgroup was created.
+
+	An example for mlx4 and ocrdma device follows::
+
+	  mlx4_0 hca_handle=1 hca_object=20
+	  ocrdma1 hca_handle=0 hca_object=23
+
+  rdma.events
+	A read-only nested-keyed file which exists on non-root
+	cgroups.  The following nested keys are defined.
+
+	  max
+		The number of times a process in this cgroup or its
+		descendants attempted an RDMA resource allocation that
+		was rejected because a rdma.max limit in the subtree
+		was reached.  This is a hierarchical counter: the event
+		is propagated upward to all ancestor cgroups that
+		already have a resource pool for the device.  A value
+		change in this file generates a file modified event.
+
+	  alloc_fail
+		The number of RDMA resource allocation attempts that
+		originated in this cgroup or its descendants and failed
+		due to a rdma.max limit being reached.  This is a
+		hierarchical counter propagated upward.
+
+	An example for mlx4 device follows::
+
+	  mlx4_0 hca_handle.max=5 hca_handle.alloc_fail=3 hca_object.max=0 hca_object.alloc_fail=0
+
+  rdma.events.local
+	Similar to rdma.events but the fields in the file are local
+	to the cgroup i.e. not hierarchical.  The file modified event
+	generated on this file reflects only the local events.
+
+	The following nested keys are defined.
+
+	  max
+		The number of times a process in this cgroup or its
+		descendants attempted an RDMA resource allocation that
+		was rejected because this cgroup's own rdma.max limit
+		was reached.
+	  alloc_fail
+		The number of RDMA resource allocation attempts
+		originating from this cgroup that failed due to this
+		cgroup's or an ancestor's rdma.max limit.
+
+	An example for mlx4 device follows::
+
+	  mlx4_0 hca_handle.max=5 hca_handle.alloc_fail=0 hca_object.max=0 hca_object.alloc_fail=0
+
 DMEM
 ----
 
-- 
2.43.0

