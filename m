Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793010752;
	b=T2KMJw/kLC4SRDKu8fXAs+xddCxyeDlL215e9Urkh3j1ZSCFlTjhKx9ocER4D9FS9KQ0
	 67JDuSLFLdeeF4E0sHGxXeQhGST83+qreFnkVJnFM0iTPfENsFBCtU5/vhZz5tXUB/juT
	 UWSpDFUHtJKp2npdEcLyAZfGrCYWGDLvS2/psz5fykRnttgvFk+wDEDtUhdu8HrdnzJCz
	 Bgjr2256lrm9noRzs55se5C6qTgEwbt00SYxC9Z0nVgIkINvYDOmNZyxLDXMSk2KVEmtz
	 bsVTWirOHjcWbjJT6eb6VBEMg/RET4GE2usk/rult6Qx0nuTRwKleOLvIHUsH2FfHNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793010752;
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
	bh=5VW6ZoLOQmTvszguKeoSlx207R5HMYS9bHA2b2/Ec7c=;
	b=TfHzsKvdVw7eerRgU4EzPUg1i+4jEz6ujkW6m5rfHOm5TY0njwIHkGLYYhs36EmKw0Bk
	 FeSoYFsUe4l+6xfPEG59Q0P/dH+YofJ+T28XevMU0+QpVqH+H7PHDh1fZqhai5XU0R/Ra
	 U4/BB+b0DRbQBlTAVPOQ9dCuLpqJfjbpI74P9+4nkiS3QWXD+HUjTxqYZCsTSWiYIwBPD
	 wDnMSmIqpOjA46PHA6NYdQi+wCpHpNYt6NaeI/socoP1no8VqKbqVwA6eDBJWWMLRaW/E
	 dVKyD7s5RfnK7aB+SZc+LqP83tiuej0AUAB9o8Kj3gyZQDFNz35J9y5B5fXaffc3d0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=MxoaZJ+1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.8
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012008.outbound.protection.outlook.com [40.107.209.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1E6606A337;
	Mon, 26 Oct 2026 10:32:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E1E6606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=MxoaZJ+1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uz7cAzz0fJ9xI/rK82XS+CinPjzr652JwFqS/AFKJuBpee2D95D7W9KFdvKrHlYze84TNY3gXgaNMJJEkbBSaurjqJ3pxfC1ybKjFN00W5D0Aj7XBwVbOvCbmzGP9XhQboOILB0iVw3EjLfRXb0aNtIRnYJNMys6nuKpnGitqVhMY6yMn9J9/tRoRHA+5BPWyJJstCcOO+7tzaXpciSvnwW8KV47LSpSujMp+DUuM9/NYpK87j2Ij4Ap6AyW+ZZLajkAz/cZUr7PbtAo3GR6RZzb0y06k6MMGqYt1Z+bA2CNcmuAGNxCcBU1sZ6qSOUJZB3yieV7cWPagL+edXFaSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5VW6ZoLOQmTvszguKeoSlx207R5HMYS9bHA2b2/Ec7c=;
 b=votaE6DiOWYALDJhjYNkPtLfttMrB3jSHIev8BJFtJElOqxF0P8zH5voXNm95e0BzPfZCVilongD4kdGhouaMKfaiz1xkYBXF9lLxTmmK9Du13NLVQgJJeGlJUD4oTaTHt8ApWB8cmU/4wy7Rj31im5dgd+igmlo4xqmuSGrDkEmbvxFev5TxU/MzH6x20ltap9UgcsBEVAMEzFLa3h+PR4t3ebzTmXVf7hKrBt5iAtIbCOEiUYGmMut1OpFa39HA+G9kU5UeY/wInnagpZO61UMSaBgakssEXlKXtEWd56VUpiGxqHG2I/uXhHL3pbgjMW1alE0qaTa2gxbLATTPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VW6ZoLOQmTvszguKeoSlx207R5HMYS9bHA2b2/Ec7c=;
 b=MxoaZJ+1gg1L6Np57o9XAK3Lg8MYzdV1TcjMtJ+6gjrGqtEgp9b/BGqvM7FAUKTChVf6A0ZjyzPvAtOPq1ZxUxM1XwjbI0QBdBsl91o5KcQWzmv9912ir/IayMRndXpyyudUGDXhPS4A9u/d7UduUfS0hFHUpAu4WIuzaCW+IUM=
Received: from YT3PR01CA0018.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:86::22)
 by DS0PR12MB8562.namprd12.prod.outlook.com (2603:10b6:8:164::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 10:32:26 +0000
Received: from BL6PEPF0006C3DD.namprd02.prod.outlook.com
 (2603:10b6:b01:86:cafe::8a) by YT3PR01CA0018.outlook.office365.com
 (2603:10b6:b01:86::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.22 via Frontend Transport; Mon,
 26 Oct 2026 10:32:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3DD.mail.protection.outlook.com (10.167.249.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 10:32:25 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 26 Oct
 2026 05:32:14 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Mon, 26 Oct 2026 10:30:34 +0000
Subject: [PATCH 6/8] mm/swap: remove unused folio_to_swp_tb()
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
Message-ID: <20261026-unused-sym-v1-6-82ca2dceabe1@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793010663; l=812;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=URWo9obVsCA6pcG6WT8S5PEHMhIam1Uh4htoYs1sN0o=;
 b=8P8QRMAB7RWg8a9VhRGJHEcoNSaOtC6CDiz95+Giy14ikHZJqmPuPaLBucqz3EPkbdh38mJNP
 FAz+zTfRNjEDYIS9sZiIm3EuWKkW55bkvdEF498iFzyG4yUJCe3Vem6
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3DD:EE_|DS0PR12MB8562:EE_
X-MS-Office365-Filtering-Correlation-Id: fcece2de-3160-43af-cb43-08df334c6d79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|7416014|23010399003|10067099003|18002099003|22082099003|921020|56012099006|11063799006|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	3wGlUANdvVhLC8YSeRvB5mM5DJ0PraPAjGz72n7KkT/MeX6FYGydUlzergdZ3Nm7jg7ZWyV199FHo41SoirDeMDhKt8Xi38KVqoWZfujGboESSe3d0tHmMwmztLE3cffNMBJpZC7+0KpN8kuVPvy6/qyZmVQIErqloQHMh8qKRx9rPXvNALQPk4avMrBcEQEJVoPv9dYafhNHbE4qM7+N9rIWNjz5me850htr152sA2bl/Tr72rdVSYIaNboI6ZaX3SOl/5OKSKbrFl3MTgS9aFM5NgAOhvzToewPu3jZdSzQRSeOSfds5jJ2zlwkbZmgDRm6hyGuyXrFaBnbsr1l4PhXae2wnnkgXAWo5V/Jfk6T6/kXqvF+f6q5EOmHRezNK1NGVygE3Y++BPpnWuC8uMqdB0kdyZemAXENkGl5DpBylAeu+/pQtK8hnuqXF5v4CZ4LdbeVVSl3jc5e32d+Buh+eicjZFq2ygYJxFeTcW60A7StUuM1+mTIBAulmvkyajVcWbilEwNACs6xEWt7b/Bb6eFq5RfKlhMOok+ZXd3WUTqyI8UOQtq2L1vPq+PuUEKxLFwSDEdyY2KxK7vPYcC3ihSi1ZkCtiHYnhJVKgJL26sIKJErWSFK5/j4/Z+5E1uEj6ChU1aCldJg8G8YZhJnc2UpJPH21HcJy8Dn6FYoE7jW6gin/tU6EmiX+iEjoc3yhR8kJdgNbJPyIh4V0vH3LDa9MTDx7xHAaSfaLx58bf4ZnCZV8ztb6XdaT7E
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(7416014)(23010399003)(10067099003)(18002099003)(22082099003)(921020)(56012099006)(11063799006)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	n+dk/flh96VcFP/NDuzdgwCbv/Au0xlWtxmsh6BdeQ3lfcCxedM7DEpIscty/C5zdqGw8dyvS/2iFUmU8OYT7f2Eka+AQ73rZtqE7yhr85hdRJRCacEX4N/mp7/M08r751fEpHfDbCVqB0ctRIh2nlHh9Hs6awZRu+AXKe0L9A6/Smz5pcgqV7xcsIeCw/SQp+23Ixdw3IjS3vrYd0xVPam4Gv4divCglA0aL3LtpkVfhLxszgoKV+ODd0q54MnV00dx+lSvpMhzKParqMc2jBP+9OG3cCQWnUUpTQ+kSbU3z37vFbwdmQhXQ5bZ7NqbeGgiL5iER0r2nhvBoDzIfriMkynp7W2ofUAbBSN/tycHpYrrxBKGsGBSPSozVdUD20yXqfSGBOOI1jEOLwHJPGj2TVpgEpjpXMMX6jJtTbaEiIeSJvidZeQs9yYFNDkY
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 10:32:25.6696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcece2de-3160-43af-cb43-08df334c6d79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3DD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8562

Its last users were removed in commit 0d6af9bcf383 ("mm, swap: use the
swap table to track the swap count").

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/swap_table.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index e6613e62f8d0..dae7dcca3196 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -126,11 +126,6 @@ static inline unsigned long pfn_to_swp_tb(unsigned long pfn, unsigned char flags
 	return swp_tb | __flags_to_swp_tb(flags);
 }
 
-static inline unsigned long folio_to_swp_tb(struct folio *folio, unsigned char flags)
-{
-	return pfn_to_swp_tb(folio_pfn(folio), flags);
-}
-
 static inline unsigned long shadow_to_swp_tb(void *shadow, unsigned char flags)
 {
 	BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=

-- 
2.53.0

