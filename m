Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2D23C3F69;
	Fri,  7 Aug 2026 09:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093226; cv=none; b=ut7pMFHNqDgms8gsRxsq1LZd/rOBw29AVoW8tQcMUnBju/YyX3+Qc49GwZVCa1bCWMDsn7nGhp9S+ijfuX03zgwmJErw8eQTXlF4ojof50WA67nmzkGEK2JzOMdX3thM52e9EqXfC4ngBfTE4bcMPgnWY83II6p+DI8A23YfmyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093226; c=relaxed/simple;
	bh=82dsZ6kRaODg7zdAxVcu15WghLRuKR+6RVt6coJps6k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e1u3swACLt5lNI50Bu0atS4FJLCxHWFBkHDtS5ox/Me+PNRugBa+Wqe2GrK32qGXArbKsm0pH8WcFnWuFiVjm6HMC8b/KQiiZ7S1Eps0aZaZ+M9Q5nXOZW5O6aVzX8aEJ+tCB54ocJqdYZs0sXyxz3//AWHAmkhzcDGmvp2WDC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 669be126923e11f1aa26b74ffac11d73-20260807
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_CHARSET
	HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_TRUSTED
	SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:9ec9d7a1-7ec0-4b9b-95f6-0415e0d24de4,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:9ec9d7a1-7ec0-4b9b-95f6-0415e0d24de4,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:43a87619490f4a621eeb8c691954b9e5,BulkI
	D:260807170017QTF6X7XK,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 669be126923e11f1aa26b74ffac11d73-20260807
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 837621380; Fri, 07 Aug 2026 17:00:13 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH] cgroup/cpuset: Add test for partition root invalidation returning wrong CPUs
Date: Fri,  7 Aug 2026 16:59:50 +0800
Message-Id: <20260807085950.10960-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test case covering the bug fixed by
commit 345f40166694 ("cgroup/cpuset: Return only actually allocated
CPUs during partition invalidation"). The test verifies that when a
sibling partition root changes its cpuset.cpus to overlap with another
partition root, only actually allocated CPUs (effective_xcpus) are
returned to the parent, not all CPUs in cpus_allowed.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 0d41aa0d343d..a44e92c94081 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -393,6 +393,12 @@ TEST_MATRIX=(
 	"  C0-1:P1   .      .  P1:C2-3  C0-2     .      .      .     0 A1:0-1|XA1:0-1|B1:2-3 A1:P1|B1:P1"
 	"   C0-1     .      .  P1:C2-3  C0-2     .      .      .     0 A1:0-1|B1:2-3 A1:P0|B1:P1"
 
+	# However, a partition root changing its own cpuset.cpus to overlap with
+	# a sibling partition root will invalidate itself. Only actually allocated
+	# CPUs (effective_xcpus) should be returned to the parent, not all CPUs
+	# in cpus_allowed. The root cgroup effective CPUs must remain unchanged.
+	"  C0-1:P1   .      .   C1-2:P1    .      .      .    C0-1    0 A1:0-1 A1:P1|B1:P-1"
+
 	# cpuset.cpus can overlap with sibling cpuset.cpus.exclusive but not subsumed by it
 	"   C0-3     .      .    C4-5     X5     .      .      .     0 A1:0-3|B1:4-5"
 
-- 
2.25.1

