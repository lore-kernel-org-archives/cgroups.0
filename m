Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6225F3AB27B;
	Tue, 18 Aug 2026 02:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787020489; cv=none; b=uWPzgy6ocY9L0kBDnmd9xPxiwSLbgDLtV/vH0qi2ziAm5MYXmbPGTuUz4jK0nFg7vdH+i9WQlJv4NFp5QvcLP8mVjU3zz2O5qqB0qYWJb050UiQ9SYVAGOqpqjn7d79VPtvODc+OgmPMpVSX+xSvTq6fv4ChrmifP15mRygtffQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787020489; c=relaxed/simple;
	bh=HubFyn26i1sXNni/VRbfyoMRgEhOPcP35IRnEcPU5uU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uNk/93nxlCkcUh5JJPOOKsymB/Y7cmU2mAZZSrpZX2NNFexGBjMGjwZgpQtAWsMZLjog55k0hB7So0OcA6TNF0PGX7HXCsd3k8M293a0axJcmo7UPntmy2x09Oc2A3BzEPEgCYvkd0PakuikfKWAQn7stmDIm3f2k1nlDv392sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 599707d69aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:3fff914a-1cc0-4a8a-a1b3-abb84a3bdc0a,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.3.19,REQID:3fff914a-1cc0-4a8a-a1b3-abb84a3bdc0a,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:7db8b62,CLOUDID:2037933290f126fd66af66823effcce8,BulkI
	D:260818103439T0MG27UH,BulkQuantity:0,SF:10|66|78|81|82|102|123|127|850|86
	5|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 599707d69aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 204743495; Tue, 18 Aug 2026 10:34:34 +0800
From: liuqiqi@kylinos.cn
To: linux-mm@kvack.org
Cc: tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [RFC PATCH 2/8] mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
Date: Tue, 18 Aug 2026 10:31:15 +0800
Message-Id: <20260818023121.100613-3-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiqi Liu <liuqiqi@kylinos.cn>

try_to_free_mem_cgroup_pages() reclaims from all nodes of a cgroup.
Refactor it to call a new helper,
try_to_free_mem_cgroup_pages_nodemask(), which constrains scanning to a
caller-supplied nodemask. The existing API is preserved as a wrapper
passing NULL, leaving all current callers unchanged.

The reclaim core already honours sc->nodemask for cgroup reclaim via
shrink_zones(), so this change integrates cleanly.

This is needed for per-tier memory control: reclaim must be scoped to
the nodes of the over-limit tier so that enforcing one tier's limit
does not evict pages from unrelated tiers. The new helper will be used
to enforce both tier.high and tier.max.

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 include/linux/swap.h |  6 ++++++
 mm/vmscan.c          | 26 ++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245ba..6a79d6995082 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -367,6 +367,12 @@ extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  gfp_t gfp_mask,
 						  unsigned int reclaim_options,
 						  int *swappiness);
+extern unsigned long try_to_free_mem_cgroup_pages_nodemask(struct mem_cgroup *memcg,
+					      unsigned long nr_pages,
+					      gfp_t gfp_mask,
+					      unsigned int reclaim_options,
+					      int *swappiness,
+					      nodemask_t *nodemask);
 extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						pg_data_t *pgdat,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..e0602e681d96 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6759,11 +6759,12 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 	return sc.nr_reclaimed;
 }
 
-unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
+unsigned long try_to_free_mem_cgroup_pages_nodemask(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   nodemask_t *nodemask)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
@@ -6779,6 +6780,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.nodemask = nodemask,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
@@ -6799,6 +6801,16 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 
 	return nr_reclaimed;
 }
+
+unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
+					   unsigned long nr_pages,
+					   gfp_t gfp_mask,
+					   unsigned int reclaim_options,
+					   int *swappiness)
+{
+	return try_to_free_mem_cgroup_pages_nodemask(memcg, nr_pages, gfp_mask,
+						      reclaim_options, swappiness, NULL);
+}
 #else
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
@@ -6808,6 +6820,16 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 {
 	return 0;
 }
+
+unsigned long try_to_free_mem_cgroup_pages_nodemask(struct mem_cgroup *memcg,
+					      unsigned long nr_pages,
+					      gfp_t gfp_mask,
+					      unsigned int reclaim_options,
+					      int *swappiness,
+					      nodemask_t *nodemask)
+{
+	return 0;
+}
 #endif
 
 static void kswapd_age_node(struct pglist_data *pgdat, struct scan_control *sc)
-- 
2.43.0

