Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793010776;
	b=4rTSl8MfGJz7TuxBHx3MVp2u2STde1BupwCH01KuAjwABxAexUNHNA46tRON8G821UEA
	 zefbSMYAXt85cBvq9CFr8jwuxv4/Mpt/wzYcPITnZztmjORUohf/o/xoqKE3NKUoC7cBX
	 VysCQjcLiUKfBdQwR4T3Oi+t225Jb0KyNRO1SZl5PDrvM6SYJxlAn7QjQfh3r2kDs+Udb
	 OX8W1ooT7L++McQRrVH3O6CXqj85EOl88WDwhrIfH1mlDwinSEJ/V8bSxnjQsHIcEwyGi
	 UcG+a8KDGqJWRfjjmtyajICc8mnV5oO9s0g7E1FUX5+ZMteYA6qqgmevLs/qwzuQ+gQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793010776;
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
	bh=K48RSWxVXjf4bGBRpdIX/SFHhy2jrUVYvk2CD0oWZik=;
	b=ZK+ag+DsLXsSd25T9spVkK1PWx5hkwkH+/OO87R72pMsjufTMuKrI8r9ntOHGCfN95Vy
	 MNY28j5Q3+pXErtM+PHtpUSu5zaxKKXq6JKIuHqRM25IgAw2N37rJnQo4e+5ALFFrGrr6
	 GtgYBXX3OcSTD1i6/bjBohbzbbQFpO8W8/75LigHoS6+2FbrRq5pB8O/EVfBsc9UVyawC
	 qzGzgxct9A9VD1ARJcXI9W5AOD8TdAwpLWLXQbFkvIFZuhXgf4HHAvSr0akACpC5/its9
	 78ttjR6jiHtvAxCZwWA53rHE0uswJJNJivHJptu/eMhn/yrNr33Uapjsy3Q90NHXrMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ymOMeQXe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.8
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011008.outbound.protection.outlook.com [40.93.194.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728A7606A32C;
	Mon, 26 Oct 2026 10:32:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 728A7606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ymOMeQXe
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T1uYD6AQQVEOj28fRdDhg4oQSKSvqfaE+On6KRXBaaHo9gftDMTxgcouYF65Cpr/3DxM2rTBmEdWoDvWrL0U26/muZsWdt+A7Md/sRR8EjsKrjwxrfDTIDduSVusAlLXE7pR2p/3pjqIe11QBqx5vdGLCv+ArhJQUKqwh5wOdjHCt7Z0J/7qBjAN0snMkYpBuY83fQwVntH/tvXBS4OikJuV8oA7YCX4oyP2/QAKpZGUWLU9yLCwNlIPPi+B9dk6f5mpHeYmr4LbDT+l59vO+kWkqnKZWzE2PAEgf0f5kv20EWozX455NyGw4PN3NuND1/9aEmUrDhSHoDcSFkoVmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K48RSWxVXjf4bGBRpdIX/SFHhy2jrUVYvk2CD0oWZik=;
 b=QxjfEaNGwQhJW67GWF/OJcvG/DA+yyiKLwVuls70iR/RVs5JBSaA78Vrl7HCFYEOX4huvl+qvqzsW1+rWsR21wBK5uPnBOivMWUfPVmFgs9WVEK36TLWiuGink8eHy0PZ7L1Hh/tv0xry2FP88fcywWMBspB5gLqcbhYjKMHYmeepmcbk+aFdfMxpp/dwDeuqtU7feUVPy25+0Z5YnNObsDQ66xuUAiTEfVTkLFJooo/6XgKTeNhcdxANOXS8sEu+FvTJQ2DC3Wg2HJYl6yxYUfQOqQzrp3V1bExBcZjOw1/t+Aav/vSBRFYCISDuxUMajJYe+LnuPit2zIoJYewIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K48RSWxVXjf4bGBRpdIX/SFHhy2jrUVYvk2CD0oWZik=;
 b=ymOMeQXepOByZTMj+9dutznE5kwHvh7Pk3xhWo0hiKwjt/3asGAbNDh055QoitpkfUb2ChAecPsnlvBdF+BuKEt6x7+HPhr3Aat0IMZFKszD5T/WwEK9tl6PqvbeYyIFbXGY5T7rWuXMiZvh+OqbTnfgO7amKBy/OpGUbkS69aU=
Received: from BN1PR13CA0024.namprd13.prod.outlook.com (2603:10b6:408:e2::29)
 by CH3PR12MB7665.namprd12.prod.outlook.com (2603:10b6:610:14a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 10:32:49 +0000
Received: from BL6PEPF0006C3DB.namprd02.prod.outlook.com
 (2603:10b6:408:e2:cafe::13) by BN1PR13CA0024.outlook.office365.com
 (2603:10b6:408:e2::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.7 via Frontend Transport; Mon, 26
 Oct 2026 10:32:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3DB.mail.protection.outlook.com (10.167.249.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 10:32:49 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 26 Oct
 2026 05:32:37 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Mon, 26 Oct 2026 10:30:36 +0000
Subject: [PATCH 8/8] mm: nommu: remove unused heap_stack_gap
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
Message-ID: <20261026-unused-sym-v1-8-82ca2dceabe1@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793010663; l=584;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=ddFOUUq3+2yZUzqYkl1mGXYr6ASv4jHOikmqwb/T8uM=;
 b=1+pgLWuRDQs4MF82tYrHU85Ic0ciGsbUX+A81e84zi9BOimRiU9ayDeVEJSgAtnzqUYQj2x9d
 Qdj32hk8atyDxErgE4OiQauteSXO1BTWonctlilbHLxdPsD+yLQjzzo
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3DB:EE_|CH3PR12MB7665:EE_
X-MS-Office365-Filtering-Correlation-Id: ca67b578-80dd-41d6-c18c-08df334c7b6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|23010399003|376014|1800799024|36860700016|921020|11063799006|56012099006|261021123027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0TstBheUepTYiETAbc2PbfEvfr26gKbAEDfnsbXhkBoOJuaoXyaSnpHamDMLFGfX670AIQsN3uVKjPQgoiWq5Bwa1FDRegB0oIU6WfKw2i9BeZMyE96SvnSi93r8mLQzO3mniExD8H+rtlEJIXmV0wKgK1sh5MRnCxNDoXmGv2jx7VIXFQgno30HO6rUuL6QfsjN6LV7m7gnwUBjinOYKSLEizfQqXFsalkUN2naR3a5Z31gABE6Ljvds7ahEnSpb1WY/PTzchBnuZCkAD+PwPQyEQ43eCCZjLIf8pGjTTeoe09782sDY7djXM2oAmb1ioyJqulNVW0V9Yr0A1zwLaA+9t0ciMokluAuS7wgkySCrrLIOVb/NOcKVpdNzrB/cU+9aglf5ewSTQ5HTh8LDsXQVya4mfV2v/DduxKDIAnHAXtBNn3iHJzqPdP5ofpo9z42SBvuMKx9I0PCGbG4iixIBiRBVAdJVWiPfhbM/fUhYBZiEFdbmsah7O1GF9JOVs4e7+mwI7XUNs04EiXJsLy+GjQJq1Q2YCwHBBQbAhIYk999GM0TRw1g77xY3jaCiLSaceGJiFt5/8US29q74zAzqiZzr7Cpjigb4+2F/JqC6t5PF9PvCJbAht4Pnb/GdCoJO0kv4jFWyEX/0WvZTV+6x7C3l5k9KpkpS01+97VprPyHaa9qGI/LcXBLhv8A4bsYPJu4vU60TYc49cATXQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(23010399003)(376014)(1800799024)(36860700016)(921020)(11063799006)(56012099006)(261021123027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qMmsE4uUT4/wfscg5v1gFM3jzmfAEyR/w36Ai3p9WLhFx5CoTbZxinGezuONxPI2eIITaMkCR9d5NH7TiA3dnD9TvcYOBAnqM+y3SyQo4jDa1a8udbXzS3eZN58nw9jhAf4d03ncsTOQiaSv9JlmgG/zE0YWxxmTHxTMyuqFk19xFwmKkh5+MMKQ2R1t8mZxhpcYcvZNii13nGbBtoShjZ2ZnKkHY4yLdGwEhsV8SpvDz4AggnildI/Y5xW6Y7Y4ra0a4flgUSeqTWqV4YTcpjMONuNHEHacmHSjSiX7+L9ryFFW3erFBzWQDfR14pVSJFgnaimtDDut7Sx6lESfYEJgd83WiYHE/jmbKNdnsods5ypSS7LMnH7Vybi1lzYp1imiaMjzkmQIKxbP4E6Biu41QEJmvdy9jZpAT5s3B0dcTSTkAMPMY/TCEXHed4x0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 10:32:49.0849
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca67b578-80dd-41d6-c18c-08df334c7b6e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3DB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7665

heap_stack_gap has been unused since at least the start of git history,
commit 1da177e4c3f4 ("Linux-2.6.12-rc2").

Link: https://lore.kernel.org/linux-mm/20140430083620.GA4711@dhcp22.suse.cz/
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/nommu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 91ab65afda70..df8ef1323e18 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -43,7 +43,6 @@
 #include "internal.h"
 
 unsigned long highest_memmap_pfn;
-int heap_stack_gap = 0;
 
 atomic_long_t mmap_pages_allocated;
 

-- 
2.53.0

