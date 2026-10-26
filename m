Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793010730;
	b=vKaeBorFMPXIZHTDl5GN9Ymea4GuNKLiAE4nhd2TFbp5JNfsVgDhEr11Bu/R2B6GOleE
	 dPbgviInkNsfz2BtFQtPK/BKeW/7NBbWVEVgHcop4F7yyu7k3gwOOfLumFyVLgVYw7isV
	 qQUkP2KYIWzZ1WCZUXWHW5Yref5zQhSfGj6IyF8l7xP2j1l124edRVmpq2pW7DP9LuE1g
	 lyX4RMkMXiONOGqDv7homL0skNtlZCIPS9HJTkYfrN+1clbfxK5CcDXqk51+/4fswX3Oi
	 TSBXHkkXYf9+/R8zWya9ZiogW+COw/hH2ZJjPVolaZzvuuqR8/9Aa+rrJE27cQJ/1zQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793010730;
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
	bh=cKQuU8FWpJ8D8dulIHu/87PdGR24YF7Bm3/2w3/VeOg=;
	b=t6B7FVLpxwMRgFBSaGsgCSwuJbePgzxsGYS8RZsUzh5uWUuF2IVQ+iwyEwtTIHpro5DI
	 8AjNqVH7TA5fQZlP6PLnvQ28Lmh+k+mzGtEO225de9XwOq1Ot44HdEzZkusRvPSniPxjL
	 aZkP7ykv2rQgZRQ3JGC1Frpj64a/Dorq+7B7JpSmsfhVn4TUrlWDYn9w9B1NidyCVO2bi
	 KMvThrCwlk73x3NCkdiJag/NwhdVRVzJwL0HKzjng7IlD3MuiF6MCHJGzx8TkCKGC14QW
	 A5lMwAB0HkoJ3I9h9WhVbdqgdhQ/syYsYaAGS5EsN8Emq1gA6QXny2vYBcSdlKoc8Sg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=iGWxkRJG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.66
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012066.outbound.protection.outlook.com [52.101.53.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860D6606A31A;
	Mon, 26 Oct 2026 10:32:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 860D6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=iGWxkRJG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D7MXymBQ9S8sk7X9O7YeiPcaYc9mzCzcdBSEMUHr70d+KjqczAN4ygDvffQBQtRgRUHf8DDjaBmvEwDNx7/lwZV5QiY7VIIaa34Xg7z1RFB22OHFPuQffg5bM43y+aYVhPoXwvcr8fibYWbI4kKelcwc5TvK+a7Irp4eF7rdxPt/lgv3BXKLGm0MvZXza8KZcN+YVtUu5ifw3YjiL1+YziPCtpj7/MRNmvoFzV6TwckyXRqk6Lc4Uh5XG1MSfLSpoqKKM54+Wf5SDGll45u2X97lK4ozj7VLJ+pMjS8S3hqqd0RR5wgsAtzT9xt6szup2NW4yzgJXuUYWFVPiH9GrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cKQuU8FWpJ8D8dulIHu/87PdGR24YF7Bm3/2w3/VeOg=;
 b=W6zxwQo1XOaRJUUNEQnx9pw7hx8LFMVr48R9OHl8hoVmkLg7Mcdl0hAyJePXQHB8yOd23gJ357uTVHah4R9WZAwmUp78vBGbgCzb5X54+ecIjb8j3fBXN5Afldjkmkao1ojYeR8IRyKxlkzaQnusnSIho3dBpvTFlMv3h2BYWdw8ZNniBNi9DbQuIX6cjYKlArOAx7FqdpRFx9J+ZVvT4140HK+AacVQewoLtggCs/knJeANLh5Rh+kZKMgiomWfqPvGKDT4kO15uYKW0UotlNij0Wtg7NEus8iC8Bb3JxSnY3o1ZHwDyngKrvVj5yHy7t5hg7wLJuHjUbyBhhdzZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKQuU8FWpJ8D8dulIHu/87PdGR24YF7Bm3/2w3/VeOg=;
 b=iGWxkRJGdX3Hkzmbc8tUXN3wNu45CAWajK1vqP/pBfWQpiBHcBdIkfH34VLsZB5EfKGpEvUt7f63adUq2BWgBKn0sFzkmh8Mv9i4G9d1dgoD0XVe3S9bD1Aeh+I3112af8LK7/qlB43ZjcMe6RtEuPb+kmhU8jTLt9RlXoGi/MM=
Received: from CH0PR13CA0014.namprd13.prod.outlook.com (2603:10b6:610:b1::19)
 by SA5PPFDC35F96D4.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Mon, 26 Oct
 2026 10:32:05 +0000
Received: from BL6PEPF0006C3E1.namprd02.prod.outlook.com
 (2603:10b6:610:b1:cafe::87) by CH0PR13CA0014.outlook.office365.com
 (2603:10b6:610:b1::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.7 via Frontend Transport; Mon, 26
 Oct 2026 10:32:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3E1.mail.protection.outlook.com (10.167.249.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 10:32:05 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 26 Oct
 2026 05:31:50 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Mon, 26 Oct 2026 10:30:32 +0000
Subject: [PATCH 4/8] mm: remove unused helpers from pagemap.h
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
Message-ID: <20261026-unused-sym-v1-4-82ca2dceabe1@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793010663; l=1463;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=MKRG0Tut7D1LURgzKk6ngApEOX0i2KzX06LbNh9bmyE=;
 b=DjOptxCcbj7el2V+oiBO+EOF98q21rTg/sUAkvtEaHrmH4a7spldpEpa0+wYgW8V75iIId6mF
 nkLbtRdoYX0BFdhsxJ1E9VKbLUMPGqY7aLQwzhK82e5NVhdO6aArrGH
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3E1:EE_|SA5PPFDC35F96D4:EE_
X-MS-Office365-Filtering-Correlation-Id: 903ee56a-9bca-41a7-52f0-08df334c6147
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700016|23010399003|7416014|261009223027099003|261021123027099003|18002099003|22082099003|10067099003|11063799006|921020|56012099006;
X-Microsoft-Antispam-Message-Info:
	cUQoI33ejbzvJm0q3DhD9WlkhQSmXlzacrvXCMWAaewmu81h6fRgFXXTg333QoTSJ8jShtIYAxw7KvtKLGHQG9tKAFltpcA7aLIbi8b4rfT7B3QeuWckXRBa9GSL647g3ebNsvnHxYy2r5Cccdt1Ynq67dHaMtPHDb3b14IYa4q9Z9d68c4HhflrHouAP1ZLwN2SgAGSFfeCQEOMbevV/RKYmQh57j1KlvHJBXcY+IbF2RxVx2TXvISMBEGvXC+16JXJZTLjxqCiNvNH2zJCFej1ZfczsCrlXxgxadxWZFdnR1TSBHm7D12zZ93S7cNIxRfvrWT5MNefOhIjlnYMKz1cCumhcFs5Wj3ETFuanhbJq9Frw6DMOAYPvp71GwN9DSy/TH8jaxnAdkHfv3uDC8PAt2/zOpp3qA6Oe203RK+xH+seYL3APRHVNo4ebUGJ5kEY2p0dj/NGekbc3E4Z3CnhfZwT9mJwKHDZbt/0yNzWIijWBCv0LlxeURZ218JObsLF7ilHxPCWJ72YvDObrOmxFBiLZfi8sTobkpctBcwNhljRvrgnhURjzDjRxm3/p44SyGlKhzyRlixJE8Vk+EKL/elnqyQg9/UWCuX3MZ1aTd/g1gOWcm0tOljdRCHTG/ji8GVzMXRl/GKGmVDZ33sVABH+NNRCEDQcLpZxOtm0VIljBHta1Dk2dnzJHfqw+NryA13UEV+DWSBd2cZZJiFFp5l6MmhdipfWsg+2tRTcY1fyh/3h2CgLvscAF9xt
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700016)(23010399003)(7416014)(261009223027099003)(261021123027099003)(18002099003)(22082099003)(10067099003)(11063799006)(921020)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z0OC1atot80ge79DjlTv85YGfDJWk4moYwMJ5hMh9+HTF4cqjb3zRJi7ZHDaoh5V9a6y7iSk5W7KKNASZp3QZI1hI/zDMcFNKRRKy+pgJfniIW3nL4c4dalctwdqQ+liMu98BmecMejo2CoPpwpgtm3FuOQTuFQ72WS4L7Fnf03fMetCxTHlKXvEGn0EbtIqiPdZb3Pn8txny1ChA2mrIJOXbEZr/MYM7ih71o+mBC3bx+ApvTt5CW/EzMUfyWmL+cyoUW9MBck2egmUT29UPubiW7uyyA6M6gKhyiOp2RX6f0h6E3k6GH7mW5NzP/lEKxq/QmS43c2s0NnPVL78bghmFELeIUYq5XjZB0PatJCgPgpSP2qmF0A/vF5vCMjuLHxAuac3TfdwO6MLb0oXKLQ4M3hfbpHEWB7SHidWh4cg7GA0KsnbjJ9fBxJAgDFz
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 10:32:05.2084
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 903ee56a-9bca-41a7-52f0-08df334c6147
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3E1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFDC35F96D4

invalidate_remote_inode() lost its last user in commit d73065e60dcc
("afs: Use alternative invalidation to using launder_folio").
mapping_clear_release_always() has no callers.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/pagemap.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index bcbb0afe1a68..b6ff219a78d0 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -21,12 +21,6 @@ struct folio_batch;
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
 
-static inline void invalidate_remote_inode(struct inode *inode)
-{
-	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-	    S_ISLNK(inode->i_mode))
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
-}
 int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
@@ -299,11 +293,6 @@ static inline void mapping_set_release_always(struct address_space *mapping)
 	set_bit(AS_RELEASE_ALWAYS, &mapping->flags);
 }
 
-static inline void mapping_clear_release_always(struct address_space *mapping)
-{
-	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
-}
-
 static inline bool mapping_stable_writes(const struct address_space *mapping)
 {
 	return test_bit(AS_STABLE_WRITES, &mapping->flags);

-- 
2.53.0

