Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478FC2E65D;
	Tue, 14 Jul 2026 02:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783995346; cv=none; b=uA9t7lGRN3Fsyz4vTGhD2bTYJv29aBq4xQMBvnL/mZP9Kw0sf8NFBVf79iYfdQFuwGaZ2RncPZtibbp+loj/VOZlgZWOfeDzYnzuoPx0Zuzx0ay+wK6beNfDKot5mxBtVNMqJLS0t4BjmoRrX/xVTXDGcwxvWptafig+6lv+cOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783995346; c=relaxed/simple;
	bh=v5uhv/1qjFqwspDoMpuWCpN77l8nV7wJmt7sO/PhrH8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uTl7vW26J+Ofe3EZhAfjgUwtMvC5jYrM39Jo+t99NbdToXkr5usO5LMr4Hwur8fAvF0Mo+FX1pvm6kir1zmUhRYs+5v0XhwVSdglO01QmTaQ6oSc5+cYVdejbsT7GwJaF2utMMgwE+yPzB1rdJRUahXLX9O6XNv24yaEKb0KNXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: e76a86d67f2911f1aa26b74ffac11d73-20260714
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6a112b9f-3c77-4d5b-83d3-c1d74f8425f0,IP:20,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:45
X-CID-INFO: VERSION:1.3.12,REQID:6a112b9f-3c77-4d5b-83d3-c1d74f8425f0,IP:20,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:45
X-CID-META: VersionHash:e7bac3a,CLOUDID:dd181884e857344a438163946bfe7c5f,BulkI
	D:260714101538M9HF7TXP,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|127|865
	|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e76a86d67f2911f1aa26b74ffac11d73-20260714
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1422662319; Tue, 14 Jul 2026 10:15:37 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 1/2] selftests/cgroup: fix missing TAP output in test_hugetlb_memcg
Date: Tue, 14 Jul 2026 10:15:11 +0800
Message-ID: <20260714021511.1063700-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

main() in test_hugetlb_memcg never calls ksft_print_header(),
ksft_set_plan(), or ksft_finished(), so its output has no TAP plan and is
not valid TAP, unlike the sibling test_memcontrol and test_kmem tests.
Add the header/plan/finished calls following the same pattern.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_hugetlb_memcg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
index b627d84358b1..8c5aced813b6 100644
--- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
+++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
@@ -199,7 +199,10 @@ static int test_hugetlb_memcg(char *root)
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
-	int ret = EXIT_SUCCESS, has_memory_hugetlb_acc;
+	int has_memory_hugetlb_acc;
+
+	ksft_print_header();
+	ksft_set_plan(1);
 
 	has_memory_hugetlb_acc = proc_mount_contains("memory_hugetlb_accounting");
 	if (has_memory_hugetlb_acc < 0)
@@ -211,7 +214,7 @@ int main(int argc, char **argv)
 	if (get_hugepage_size() != 2048) {
 		ksft_print_msg("test_hugetlb_memcg requires 2MB hugepages\n");
 		ksft_test_result_skip("test_hugetlb_memcg\n");
-		return ret;
+		ksft_finished();
 	}
 
 	if (cg_find_unified_root(root, sizeof(root), NULL))
@@ -233,10 +236,9 @@ int main(int argc, char **argv)
 		ksft_test_result_skip("test_hugetlb_memcg\n");
 		break;
 	default:
-		ret = EXIT_FAILURE;
 		ksft_test_result_fail("test_hugetlb_memcg\n");
 		break;
 	}
 
-	return ret;
+	ksft_finished();
 }
-- 
2.43.0

