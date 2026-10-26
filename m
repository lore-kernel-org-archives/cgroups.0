Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793010704;
	b=ERQBJFxx/uJVvlQmdJHNfYL0J2SY3A0lIZzYlUIUUGKQgLOPmwUYsuceVimT57QSK8ud
	 Dx2jq2mlBP4nAeXdRJ1thVqEkyf9Z4TGwCby4UiPDD+7yHcf0Tq5IMAssLeq3XhCmrFMp
	 Y2FKmePeh1GJVryFicIr/bhyK0ct0mOkAuUvD0DrLvciro+vvVWJ5vVdTgODqzk8PAUn9
	 FXYZgIQCf06E+0lHlaFuCKux1RCa8MP/ZIXP8uCFELoQBALi0seeGtzalSF2z+EqZgHiW
	 Mqe8Z9i8yHgV+nmB9vdtUgkSC55N/qOOxZlatam8Bq1eRaLepnvZ2T85lLnWMUmTEEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793010704;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-ID:References:In-Reply-To:To:CC:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=UWtIHgV8oRRs59cjVLpBEKyZq42axVGiiW/nSZnEpVo=;
	b=WJl5hramdL7r9qQk7iZaOV1boUbMqer0sgplUz6v5rgrt+p9LZ5jGLo6i/uH3sFPa07R
	 bkurvACiwfJzRMjmeTzinwmNXX+D1HluUZW1InfAqLtmpbnIIHOpxMJmdO284xuNpdE6r
	 Cn50VX4DArlI5SmgbRIVmRyqoq2TCOLX6XhQ0M7SsV1h9oMeceiFn0TMckQszTEBRi9aG
	 Qlihs2tul9vYY2HCQBjT31pQ9GVyS5QuypImADfz2NeedyyxRGSPeXW5e6zO4Ax9qJ5t1
	 CXzg/1UmxfxinEgE8rOU2BHaPWgQpPXCepn3WcosxFzW453UjsmiA4taXORozZBlmLA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=zLFPITZU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.21
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012021.outbound.protection.outlook.com [40.93.195.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0626606A31A;
	Mon, 26 Oct 2026 10:31:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0626606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=zLFPITZU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N91+Cg0Goh5ltjuBSgJv3r1QSLcXJlCJkFY9UbXi9PlfX7F3zkJcBlYaubE40KOXBMQ0mlFcF5b/ul2d5jm+uYVtgbh2MVivmBpL6b4KRzPB2w8xCri/sAiKG3lUeVlBgCemD3a7wsRr9oyrARxbglzJHozvPq9zubl74s6OHPKJ9C6jQKHz7nSpRIz3wOjoFH++MftPe0XYbU+s8RY+rw+WmKg6Rgz030yFhoA2COg1t3aPtRKS8vFt8pcn0p9EN/0QfxnmTxzAIxd1kh6p9FYceEEJieuufBtj+Us7SDyPPdixR12ImRISdPdyHN6RhLVPhx5xRhjbmqslqB+6hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UWtIHgV8oRRs59cjVLpBEKyZq42axVGiiW/nSZnEpVo=;
 b=gYA4K6JQNXPCpZ8g6z8qrYCPyI6ICttom2XUODERT+vuwyiQQO9FmZZwsXnDUPhV3ZJ2WQXAGBdB8fV6p/PPmgKH8B09f8o7S3sqxdqla/s0t6yKZlMkQRjM40VIFRB/UPDp36mKZgcNU+CDDNU6T18XQBoW2YjdrxKy8xEcT1QozJXZfPNdoTI7n1N3xeud2b+w67SagkwWv7hcD0aijO/hbySmGhw6fz2+kiGA7niqmIhXu6f1MSicoSC33yvC98zwJ0Q1oLuHnSiBbj1wOqCTxtHR7CpMUnpWHnhahx2mTUjaUUPA304C7XqE5XxbQcLJOcZhMR+jiQofjj0VPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWtIHgV8oRRs59cjVLpBEKyZq42axVGiiW/nSZnEpVo=;
 b=zLFPITZU/4GNh4TFlBDN7Fu/RIslJiJICnHsed+1wtv+GHkuY101yMx8GUPDLtbyCqD6C46m+VD6gI4idHNX8DHN2lnJId0rtN3fuzzEvSMXCgXBEsKnG9xCd1gIg13UXqvfXbHsRfPgZn4war9Q8zgstR/ASf6y2QoQW0PN4fU=
Received: from CH0PR13CA0018.namprd13.prod.outlook.com (2603:10b6:610:b1::23)
 by MN0PR12MB6125.namprd12.prod.outlook.com (2603:10b6:208:3c7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 10:31:39 +0000
Received: from BL6PEPF0006C3E1.namprd02.prod.outlook.com
 (2603:10b6:610:b1:cafe::93) by CH0PR13CA0018.outlook.office365.com
 (2603:10b6:610:b1::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.7 via Frontend Transport; Mon, 26
 Oct 2026 10:31:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3E1.mail.protection.outlook.com (10.167.249.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 10:31:39 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 26 Oct
 2026 05:31:27 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Mon, 26 Oct 2026 10:30:30 +0000
Subject: [PATCH 2/8] mm: remove unused folio refcount helpers
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261026-unused-sym-v1-2-82ca2dceabe1@amd.com>
References: <20261026-unused-sym-v1-0-82ca2dceabe1@amd.com>
In-Reply-To: <20261026-unused-sym-v1-0-82ca2dceabe1@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He
	<baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew
 Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Hugh Dickins
	<hughd@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
	<harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang
	<lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>, Kemeng Shi
	<shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Youngjun Park
	<youngjun.park@lge.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Johannes Weiner <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
	"Muchun Song" <muchun.song@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
	SJ Park <sj@kernel.org>, Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky
	<senozhatsky@chromium.org>, Alexander Potapenko <glider@google.com>, "Marco
 Elver" <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Pedro Falcato
	<pfalcato@suse.de>, Bharata B Rao <bharata@amd.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <cgroups@vger.kernel.org>,
	<bpf@vger.kernel.org>, <damon@lists.linux.dev>, <kasan-dev@googlegroups.com>,
	Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793010663; l=2085;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=nwtYqIbL8/V5b7bzA76rWHGJPJ4cfMktwdPFXwAmZsU=;
 b=HuGR1CXwcRCIYVj4ot01O+Dd2qcoWuk86b4aprMQdLX2dMVqQy7LW9Y5zmSkU/vPtZTWFRGtR
 7N+4dtTHBZVD7HubXiofQ4LNk69WwGuF72vuFs+BdWzN+6rE7ffFqZR
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3E1:EE_|MN0PR12MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: d14e641b-4c2d-4fd0-d1fc-08df334c51ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|7416014|376014|1800799024|18002099003|22082099003|921020|56012099006|11063799006|261021123027099003|10067099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	EvOWZUnEBfSaixjhkMSAiUJ/vzBtZb2JWfvusyKn1/m/KVmnx3DgDDqEKX5aWFwUHhCKgupyutGc0/lrFC0bO1QGsAB5qogt0+E/BNdw0hBi/VTRjoLgdbOUoMF7IGw8x42AskRYoSbq9dzbgMH+tQqkeqwXYooP8LJK3w644++7ZCRfZJCppGBBcHuV7sD92PlfI/+fLnXgHtTO7ofUhzc9fT4Bh9iqTcPKFzB9ZbUHrhyvTYz9VHeczx74zSO6rhs6C3Jc8M5x00VK4fgv1x2KAScQ8tzyDxHTkIlEie0uRKcqF0hShu3UO4G6MrHTksAooltnhYWb72TPeJIblraxLOUxsD7ipLiFqCK5rvodvD2B7O9dSc/VFHa+a67VTyhyS3gvWrHUjGlmP4kvk4MItUzXF+UtjBORnNN35g+Vl46DBv8FnyRw/A4ad0r32K5DOCqG1YsSGZRqSfpZFyHfcjELVr6j2tqUKF3TrvM9Unejn7hGaT+/Uaowh9l1O4DGA7ijpkZxoxNKFziRJh/hCXUl/aUskiNLjnEx2CWL+9gcL+Y1hF1O8c9vwoUeJ27kX7KTgRGWoYKQS3jpk/ZQQ28PixuOnp+HWFV72wu7DeOjN5HcLJovbaop/n1bSxst2quh0M+NZCl4bsTKeAzwtwwlior+wnsZI/nfvQVC5rHrcf/U84Y6IYEVOS/IJgTL//5PMufhTXWPyvdBzSrQNNFHdxB/Ez6YM2lvqKM+7e0/SsoPVAuXuJpa3fWN
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(7416014)(376014)(1800799024)(18002099003)(22082099003)(921020)(56012099006)(11063799006)(261021123027099003)(10067099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qraevKmG1gm2VJEGjpdSq4GVAU9j5svjccsI1hEG4hsBl7jHVztl8MeAc5dB0WzaE1mU7X+offE16iXGdaGm3E0DqzKZ8VN6uYuK2+YrgSGyQrCONsb90SsnE1DUz3hpjBXPReBX1/fC2Cs5P0KAfYDZZqTNUBaamFxs/ao4JefWI8CYMCGJJazDRg4UPPTpzN3guCgS4k8RJBhGJv4QN0g6lJh7Whuhs5nZXmN7ByznY8a72ye40WCrjJ+pN0EggvLlabXuq1WtW+APIiKGSjGWikZPG9vTdnHc5HTMynt7mSUQWlSWD2HJZfVOd9WhMGd5Sj9wJYPnZ03Gjv4UnZRCR4P+hyTgQszVfcX0uxJ9vR6fhbXftg2z6JLLrg249JPWGA6pGoYUTzv2DOUGSOhqniuh7b7gNIE8dBUoCaZx/qXMGsmaaDMq8T2t+Fpj
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 10:31:39.1198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d14e641b-4c2d-4fd0-d1fc-08df334c51ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3E1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6125

folio_ref_sub_return(), folio_ref_inc_return(), folio_ref_dec_and_test()
and folio_ref_dec_return() have no callers.  The last
folio_ref_sub_return() user was removed in commit 38607c62b34b
("fs/dax: properly refcount fs dax pages").

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/page_ref.h | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 9f5c75d06f76..6fc20a49fa84 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -157,15 +157,6 @@ static inline void folio_ref_sub(struct folio *folio, int nr)
 	page_ref_sub(&folio->page, nr);
 }
 
-static inline int folio_ref_sub_return(struct folio *folio, int nr)
-{
-	int ret = atomic_sub_return(nr, &folio->_refcount);
-
-	if (page_ref_tracepoint_active(page_ref_mod_and_return))
-		__page_ref_mod_and_return(&folio->page, -nr, ret);
-	return ret;
-}
-
 static inline void page_ref_inc(struct page *page)
 {
 	atomic_inc(&page->_refcount);
@@ -213,11 +204,6 @@ static inline int page_ref_inc_return(struct page *page)
 	return ret;
 }
 
-static inline int folio_ref_inc_return(struct folio *folio)
-{
-	return page_ref_inc_return(&folio->page);
-}
-
 static inline int page_ref_dec_and_test(struct page *page)
 {
 	int ret = atomic_dec_and_test(&page->_refcount);
@@ -227,11 +213,6 @@ static inline int page_ref_dec_and_test(struct page *page)
 	return ret;
 }
 
-static inline int folio_ref_dec_and_test(struct folio *folio)
-{
-	return page_ref_dec_and_test(&folio->page);
-}
-
 static inline int page_ref_dec_return(struct page *page)
 {
 	int ret = atomic_dec_return(&page->_refcount);
@@ -241,11 +222,6 @@ static inline int page_ref_dec_return(struct page *page)
 	return ret;
 }
 
-static inline int folio_ref_dec_return(struct folio *folio)
-{
-	return page_ref_dec_return(&folio->page);
-}
-
 static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 {
 	bool ret = atomic_add_unless(&page->_refcount, nr, 0);

-- 
2.53.0

