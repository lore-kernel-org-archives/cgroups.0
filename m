Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.69
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793010692;
	b=A+kb+D1ruVl4bBR+r7LymZ1562kphS0SOnFxP5TvHkTfwjEmYJsz1xL37FRu+igTBOW5
	 vbnFd63L84rjGVUUf4YwPjZ5eIvGG/pWzkCfdB99FyyqMDPNE0siSIA0xYOrXJp89Shdg
	 fCXv6eY9vbogzIVTI36XPj1omT0m14jBfHq0mWv3MfavmSmxhp/yutcR+aFaGi1vtIG7F
	 oQYS//alq92DEw1PA1PAwHVhmehDgVSrobGZUqhakDrTgxxe5ZqMliNPeoo/le6PQqFpv
	 rWGDkL9hEivzJtdhdcSs9Voh8Up/n14ix5FbDDoP/VjG6+iXVDgyzi8ydF7mz7L8TIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793010692;
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
	bh=fyugMBav7xTQnoOl+Qj+YPtNJnrNVEg3p+9n1nI4itw=;
	b=GihSqrkSHnr+tGl0G+OAqsazyXraakW7rPGq6pSJb9ruA9bnFfdCg1er8vcUXRqjtnrG
	 ylH6j0m0xfe35d9ANEJj4r8YJjbFo72CEA6OYFLxSLgQsDg4ZQH+6bxcu0Nd0+2o1XWzE
	 AyR4RMXt4lAEVe+NE/quYE990I8jFa01e7Q9QwqLDaXonOHRFFDOKvhoIPSCZ2Y4Bnocz
	 YwWPFU7iSoMnys8a3WlEFCIgpQOgJtReS/3g/ac17z8BOB9hHa+0f6bYFBpy4ju8aTPov
	 WwF5CddBKG6UclCAVhvMVPocW3smDIOwrBm8+hS1nFN/W4dnEvd8U/HrvMrNKXCIXJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=EPJO9XZA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.69
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012069.outbound.protection.outlook.com [52.101.48.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC20C606A31B;
	Mon, 26 Oct 2026 10:31:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC20C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=EPJO9XZA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KV3GgOu4E7yFivdr5ZR66b0micNIvtQQ+1sx2n5pmgOAHbD+v8IuU74Lk3iFRI6VWEhRCv6ENv21rmBewp/PmwxRgiB7hu7Rub/JTMeDjDsw8gcBjDf/1+h9zmEgioQj/9e1Hr99E1mOiQxC36QD3olgpPF2QJTvubPGEXgtHyLJXjl8j0//vx7Ga4G4zE3NMwjW3dvzQ0MySMtKamRLikjWt3uaNANd8YU393s31BcByWgF4AOvPmkSww6igoUxuHJStoIpCufTn0EncEDDRO0y9lqgw7JVwBuy9h3iSSuDN1Ki8QjJZOL/1oinZqi2kjcoH+lVmgB3TiJlJRgOuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyugMBav7xTQnoOl+Qj+YPtNJnrNVEg3p+9n1nI4itw=;
 b=l5g3EFoGYGyimDmOgS6EveQ4gsM64HWjXPIbaaw1bWrlVOsOL2jvvR+I90Xa4ruRrz7ZMovPpBhSkLlq4XfNfNe6DGPdRdE2Mu/iqkvqZAMPJRvMbVcN8UUR5Xv9bQCkn5Hl1KgatEBuSA92n3Fam2qBOQxbjmVwKcyHn0yrqOAxeMqjMTkwm/UVaA2AEXJi9w77VHuofl+dTTeYOikvw47qKxzc9mjZyjzCG8nrz7uILioKtchnS4+tN7XDye2RX7c4fJYEsPL+bvk5gT0klsLrVAzZXNy+DXimUDy3KCBfK0U4Ngi1QoOd7b5X09dTtshvJMzAVlI5PE6Ovod9dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyugMBav7xTQnoOl+Qj+YPtNJnrNVEg3p+9n1nI4itw=;
 b=EPJO9XZA0KmUSTE1lQMsf1YrCidS+ucKv8nxCI/JotUMxNW9CXn/99QtV3bMZ7pPb1qN7WXCIc0E8QaTBVcDXn5aRG0iZ9iinVPk9o6vV9fGllYpBuk/uZR46SQmxdZ+vfV4Oc2Qg0/WdVn9RWF8X0s8ryhSAGr8FD+xWaFvh3Q=
Received: from CH0PR13CA0004.namprd13.prod.outlook.com (2603:10b6:610:b1::9)
 by IA0PPFDC28CEE69.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 10:31:27 +0000
Received: from BL6PEPF0006C3E1.namprd02.prod.outlook.com
 (2603:10b6:610:b1:cafe::46) by CH0PR13CA0004.outlook.office365.com
 (2603:10b6:610:b1::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.6 via Frontend Transport; Mon, 26
 Oct 2026 10:31:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3E1.mail.protection.outlook.com (10.167.249.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 10:31:27 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 26 Oct
 2026 05:31:15 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Mon, 26 Oct 2026 10:30:29 +0000
Subject: [PATCH 1/8] mm/vmstat: remove unused folio stat helpers
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
Message-ID: <20261026-unused-sym-v1-1-82ca2dceabe1@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793010663; l=2287;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=DefGTvUpFwbcZk2mR+oumYqwMkGhYq6r8/H27DOF33U=;
 b=5SHt7jFCvyZydEFn9weQyboLS4iJFN6a6gfc7BMbkzBMcSAN/pOdacCAOpCNKkg6GnprW/l2L
 s3llS9gLRtQBEKXCuU6bcifhtw68M4tBLjYjfKXJQU00jZolIykib55
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3E1:EE_|IA0PPFDC28CEE69:EE_
X-MS-Office365-Filtering-Correlation-Id: 4be09906-4d54-4935-4eaf-08df334c4abb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|82310400026|36860700016|261009223027099003|261021123027099003|10067099003|56012099006|18002099003|22082099003|921020|11063799006;
X-Microsoft-Antispam-Message-Info:
	ti1omnjRJ0zSIt/15hBauuogN+6Le3iFhyOVirAr3zM4BuvI5ju614fvRv6gptsy6EocuHHcmFrY0PtVWFef92d61tlpcT5owG1XAQVCPmEmFnDtX2XuQjYb2m8s+X9k0YBsMxpmt1B3FQv2vTyPciNPG8r5k3Lz0lOvF6Lt5Z8icJhVbJd/O6QyqVwH8OVDTKDsSfZf6qIoRBZmO0nSgMn7iVFOVGcaCuRBbLrvZiSdhHClBURlgKFcL2rTESQ34fA/vH37gOYlLSoBT99p7r8MEjupfXQWYV6I8Zf1HhlzMa0jrPl3ODI0DydnYB4kwUgziPL+p6mdNeHdiZmdauQRjtSSBy0MvcMetJ047kKnyB27d+wzNaFqxnNjRQYeIZwUUbN00LBh8GS4J6llQJ7E+O5qt1mphYNvMXLmwaT6JESjXiQfJEFyvMDH80/FH4Yg5iRKJpGzbFJq7ih+UerqDEHd/Jv5KFRGsCT48Xr0qQxeMhnsriZU9hUFvMFBDL+x00/CTZmCB7bEefjF5JMPWWvGhGws91/2qvIp4naT/lxCSBh6vyE8xBJAyKiDpaLiB4jxtytHEJxdrdD6SvJ25kqyxw9boAS3Rap4YjEF/8HTjA3yziBV5T5+T50v/d2CjsLIz8SauTdWflEuEdEJtlLXo6C9K7YOoKV/+O29k/W/LQxaoj43OjYNqguw1Pp6vt7s0jGn9wRq4hsKxzC+RGaSgJHfib7Myxg+Dq8B7sPTQxyPhI0s3UaFas7e
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(261009223027099003)(261021123027099003)(10067099003)(56012099006)(18002099003)(22082099003)(921020)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WyRlMVee1i0Yc2z+ZFugOkxhAS9bSSjGqlRk5drM2cMmDO9gxCEfmhp7tSaJV3fNNxKHFwmE80rKRUKBe+RIWzHLMcTmekW+cV/mGcuzMs4gjd2ADtXyqkXZx+ZSoulwmVWyNUKCua1lQkA5PgpAE59UU4RKSZHnEi+h+zBR2vgmfzoWAp7cAkEamG3AgtgLEksAvxcBoqY/cDcKkc1gJRhqzW89JOIgxL1JQyTUtLFWv3Gcwl5rbGbV/ozgkceC9TypcPyJdvAVwdryHs+JfhKhQqD0IC5x+krsOrPcgZlvGpyGlrvG7UzwhUOpFz50vlU0+S0XkzHizKBW8J5W4YvFPJSRcdfenYITpTNR5U3Sl/wk1ZiKqFl6pa0qPffpEWinpo8T8xxxZFlITvEZB9ThCJCxIW1AlKARzRkNZetn0UW8AIoWDqpbvsrwjHjK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 10:31:27.3797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be09906-4d54-4935-4eaf-08df334c4abb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3E1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFDC28CEE69

__zone_stat_add_folio(), __zone_stat_sub_folio(), zone_stat_add_folio(),
zone_stat_sub_folio(), __node_stat_add_folio() and __node_stat_sub_folio()
have no callers.  The last zone_stat_sub_folio() user was removed in
commit f1ee018baee9 ("mm: use __page_cache_release() in folios_put()").

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/vmstat.h | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 5b31d8e7ae40..953d8ef65400 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -425,54 +425,18 @@ static inline void __zone_stat_mod_folio(struct folio *folio,
 	__mod_zone_page_state(folio_zone(folio), item, nr);
 }
 
-static inline void __zone_stat_add_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	__mod_zone_page_state(folio_zone(folio), item, folio_nr_pages(folio));
-}
-
-static inline void __zone_stat_sub_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	__mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
-}
-
 static inline void zone_stat_mod_folio(struct folio *folio,
 		enum zone_stat_item item, long nr)
 {
 	mod_zone_page_state(folio_zone(folio), item, nr);
 }
 
-static inline void zone_stat_add_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	mod_zone_page_state(folio_zone(folio), item, folio_nr_pages(folio));
-}
-
-static inline void zone_stat_sub_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
-}
-
 static inline void __node_stat_mod_folio(struct folio *folio,
 		enum node_stat_item item, long nr)
 {
 	__mod_node_page_state(folio_pgdat(folio), item, nr);
 }
 
-static inline void __node_stat_add_folio(struct folio *folio,
-		enum node_stat_item item)
-{
-	__mod_node_page_state(folio_pgdat(folio), item, folio_nr_pages(folio));
-}
-
-static inline void __node_stat_sub_folio(struct folio *folio,
-		enum node_stat_item item)
-{
-	__mod_node_page_state(folio_pgdat(folio), item, -folio_nr_pages(folio));
-}
-
 static inline void node_stat_mod_folio(struct folio *folio,
 		enum node_stat_item item, long nr)
 {

-- 
2.53.0

