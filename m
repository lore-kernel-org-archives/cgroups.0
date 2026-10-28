Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793154744;
	b=MoCzA+bCowYNEyLCXy4tmSsK7y/7gKDtew+lKnmSj6g8x7C03B8tguXsuItRyhysjPG3
	 aw0yRTVP0U04CsOGKyPZ5CZhVN9OPksGZG7LUB2MiMITVdGx9M2EE/6fKvbRQdneE+6ay
	 lCPq0BKY8cmm4mB+uLp04iPmFl6GG92Csz34cxt2lHoPDT0V/zhhFSoPMynmGzI74GHNx
	 qk8SQjxtJgGGsnTHSfq3eGOIkxTQY37kOejx1wVoOJjzWG3NwtCEbfKmTmT7J7QpaT5cZ
	 XTSlh/D13yhFVJnxJSirJsa8S+pWXri2nXqqmChW58ZXzNG/5hCrBgoV3U5J61PL83Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793154744;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=LCZc55SguUaUW/Qc9mttlPQidAeltmeG/JhdLNIZoHs=;
	b=v0f58XVrO9QhNzDxLkH0xiInOkkJw9grFeTBKApOQ782ccE2lFTL3QVGrfvag7LE4nwp
	 h1QY846BCPoQdBPduV4c4DXnh51tyl6uQ/yOA5d11NQCTN0YQZDTcWVo0DvXAlWpZtKu1
	 kWbM6TNRyxYmeIqjaYl+gc7vyOioQX2qpHQzVPTRqIXD+QqnXK5gg3D0qIsbJ3S8j8/w3
	 eersPUXvzHuYhKbFginsccN3pFMa0xc4B7QaJ+f6sd7nqlicK9jGiJ8EHMZVE9dHvyvdw
	 3KaDuMXtbMI63X9o274g1gCCv5u8vvqXwK3OdWo0f3UKzFA/xNQ9ApoJ/klNk1ej39g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SUWw6oyi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.28
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011028.outbound.protection.outlook.com [52.101.57.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F1F606A31A;
	Wed, 28 Oct 2026 02:32:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91F1F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SUWw6oyi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iWG7cVHhjDwUtacFag2q3t38dOB6LdV9/mTjySYTfSaQay88HHZSmz8dD+5f0reXRuDN2Kum9i98jmn8O7vrijlABmnCZmR8eO6Fqa3RhLOtjzrF0Mq1S2QqG1L+26Y4SiQa2UNGzPHDgWEuL6pDZ5/mTQaLsElBuOA9fRqS9hYmjwPlB+Gr+vqP6TvZ7viIOJOSi+nnHU8/2AvOJpdwUW2NgcyzCZivw2QlNukCyvLrtNSs5w/6UgijWYBF6HzYGlaJwSqlNvOFmeO4b9lE/v4SEUZzfkfNrxYLVAG9Jxyr8EuUDRWr2GUVEO4DU+8ohyyngHQLn8UzTGryUlef6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCZc55SguUaUW/Qc9mttlPQidAeltmeG/JhdLNIZoHs=;
 b=Bxs+kzkGQWVE5MFrOQvbFkJVcEX0163rIfW1KffzOsZDwiwp1rU5tp0148OUfbsPQKPamJsQN8h78qdxn0DXTKMDyDxL8Z1FiylDLYt3EF/NJwxJIz5FivpYYcsm1J4Y4H4862iQbULU3cwKYkAr8cUzBV1cF0ICoWvqsek92HH0Okm6dauxWkoSzo89uGw8ocUY6JHgmI3ib6/OvmpN9tN1ruvGKVNixrcgGgjRY3LSHVZxAQE2IQw68tJcT0q/qW5lZ+C55k8o8/EA4jUFOS50hV7BMcbT+dBuk/WzEnKeS0C0FdyqTrb8mB27lwAGqAvxyOXctrLcqt9xyB4DUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCZc55SguUaUW/Qc9mttlPQidAeltmeG/JhdLNIZoHs=;
 b=SUWw6oyiPpbC0McCCnEJpDiVIjQvlM2bLdhAYLuz862kYhUIvWz5w5PmSoDFAhuIvsX0R7WCksjkIgb3oFuCxOHlCU3pT4h6aCR97YohOg6r7crGFSrDGDk7axd1HIOotqG49SLmo0YL4vfM+D4StA8cMHLFthUtgRy9y4cdN7AvtB0/aCaym6PBuCl2K0UgM7SMKPsTl3v7vBJW54G2Rc36yez9ZmTvYdX77ctYu9cKjB2bFvLMDN/ruE0ZZLvDBYgdNQw2xIofqlm31VyrN2f5R/GwQPcB4hMlTln95yAirw6QMbR4M3Mwef8ANgysb+GsGPkk8IEhwcF2qc+u6w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by LV9PR12MB9783.namprd12.prod.outlook.com (2603:10b6:408:2e8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 02:32:20 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 02:32:20 +0000
Date: Wed, 28 Oct 2026 13:32:14 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online()
 checks
Message-ID: <auFerm6kHxeuPFpR@parvat>
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-2-tjmercier@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028010611.3929937-2-tjmercier@google.com>
X-ClientProxiedBy: ME0P300CA0013.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:220:20f::11) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|LV9PR12MB9783:EE_
X-MS-Office365-Filtering-Correlation-Id: 312bd075-e986-4a2b-42d8-08df349bb0a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|261026140227099003|4143699003|261021123027099003|56012099006|10067099003|261021121427099003|261009223027099003|5023799004|261022105027099003|261022075727099003|11063799006|22082099003|261026121527099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yc3J0loBpKnz60GZRVOcKcHuuM4jmSKTiZZJGkKT4vMqYq51gs4WiN2MaPY6L9naU6nKrVLPUU9wi00IRlcNnp1+FBMTnPi0WUab994u8ktQwwKLhX0ViyyX1plPK9Vw8Rhjjgo8LBNEN/w43S7+wD8m3pIj1DBU7IEwY8NJ2m4c20J2MGxlkuzClbnsW2PGRTmH6HFbYrTThARJqtFcVM/WFwnSYOITLiJOHvxyDJ7P4ROY65U+Y8H9g3LNKyg/U1JC+z8n79q9uc+TiUJBRdpDP3R1q3Ps6SMRvf6RHQGK8PlyGqcQz4TxPIsMvtD2NmCUwBrw1gjAZaEDempp+YTewXMncqSMwjFuzmFbMBkfpNOhKAor9ryATt0Mctl3oHMRVbvlPAboGIXb1Pwo2LTukLV889/R/bL2nXW2mkwR7uKuLiNPmMT31rsvYF7dI3SQdBH+VJzp4Lp5Z69WNPI/DJVoxWN9IzU8pGgAQBXk0OsOr43TtxwOUFrm252c4IKKKQeKd0PoBG8pSapwGDTR75DUIM1TTNG9d1lYLT8njuRIuBrR5rzMykGuD88nwykutLewV4WEVBF6+vuUaSZhouDWsK/zFj/gsWaXE+hv8Mb/w0W7PBzS4aul7CdXxBkHgfTW64X0qr4VJWwBEgynYufd+rUMLe6HTRxWsgc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(261026140227099003)(4143699003)(261021123027099003)(56012099006)(10067099003)(261021121427099003)(261009223027099003)(5023799004)(261022105027099003)(261022075727099003)(11063799006)(22082099003)(261026121527099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J8iYXGtzg6flsA7DkCusBD9kMvLGCDYWSdtGP/FLKDcL7HedLGQ8C1/LzikG?=
 =?us-ascii?Q?PbhsDkI4/In+O6lugcFi2FA11XqaiuSDP0aKtiVofCuTQ+G8rl9XnTGoGUOk?=
 =?us-ascii?Q?rc+ok4NfyzVvGsQtXpQm2VSg20zw/O7N758V9ulMCyf13OXdEjQI82dduKPn?=
 =?us-ascii?Q?FJ4i9XtvHWCBQOVFjB44dY8G1RPei8K3rEUJIIniwWK/SvuA0Mbk6Az7HdcO?=
 =?us-ascii?Q?X0sbiL7550XVykoKp6A1Kjh/FyzNgtCT46A1ZUB1SaAMSrWe5uwUNGj9eGUz?=
 =?us-ascii?Q?wEsqltJG3nhylPGlNJPAiOYz7o9quFCrHBZBcmLaUTIQh7EwDgj+7JFoVGPs?=
 =?us-ascii?Q?G7MrXCty0LwNKxzrK9FN+Ha9/Fj2p9eKpsURbUEOZUONPVrFYF/D+NLEMLMC?=
 =?us-ascii?Q?R21jr4iEP5yhMNLQKobe4Wram6pPL1ctdIdHfSlciY8cL5NhWbXDVLbZZg88?=
 =?us-ascii?Q?0FcLfRuBYen0rY0Z8RqHXWEhuVkvk9uwXJYH05cV1Nc8sRy8CTDNFUoe5Lrq?=
 =?us-ascii?Q?yyB7SHy5vKIWePQOY91bdHEI9rtmD4nXWVex+04Dct9HkFy0xB9ipWPaCHDc?=
 =?us-ascii?Q?3alcoUHl8CUendNswdR7K+cwZKvGGWFmfv9awRE4noIyvuVDH9RyyeeHjyk6?=
 =?us-ascii?Q?UY05ozBEKhz1BrNzsAWjoG44ybYzncQE/tdzsikBrW6qjPX7Gc/fzmcbAUsq?=
 =?us-ascii?Q?D3WAEPVj/5Bdg+17L/yADfSAGfTip8i8c7iTnI2vHyzpImWTi9G8+vdU1Rst?=
 =?us-ascii?Q?fVMpdcVKlhG+qVE8Cm1K1hFqIwNQgw31yu9f4F3isPSfeRYn4B54IgHNmvgY?=
 =?us-ascii?Q?FTF6tLYBu1CmbTWyJ6GrKYD7vD/DMykFGtwy3d/mzJ1xvR+WbG1hf7xtswhB?=
 =?us-ascii?Q?rBapoI14it33LEyBK++dyfsqM7A8HXrZ9UnjvZnR3Tj7SRPzAC/0jfUmoHKN?=
 =?us-ascii?Q?1Cufe9oWs3o/bLtU1ajZSzBJUBktpCzgA6KjyANyh32XrqoEoTgQ5S1goSiK?=
 =?us-ascii?Q?3UTyQQv9d8yB/6sPat2paTvCwR23TTR8E7JKxS4nnq8utllc4Bx/SRw3cthr?=
 =?us-ascii?Q?tQ0FnzYwT2jYb8s8FZDQjnqXlgkWXxGCio1aac9e99pUzee8/G8RFn0Ys5nV?=
 =?us-ascii?Q?3+RafaN1dx3hjyTpxkjfdYqZ65acXgMweYyvOq6OpIirl/cXwZcXWhVJ88r2?=
 =?us-ascii?Q?rEb/fvguB+lZfy4jsTogvlOBbxs1/MuWDC7m6e5jTeZBQzn7iRppI42mB1LM?=
 =?us-ascii?Q?K1j7K6SwZPfRztFKGL7CJX7dNwzAMa9UihfakIFVQBExO3F7gEh9wTHGZJI9?=
 =?us-ascii?Q?+mGFo+6juteXakn2O91zhKBB6otw+PBTDq5KEIvLNgYfzvBopEQVkTylXWjY?=
 =?us-ascii?Q?Excb1A1t0RgKC72JgdOlqRw8X01k3O+LOgmMRKpZLs69HuLdCVwL9qHh+yh5?=
 =?us-ascii?Q?1Q1Xa7Z8jmTfTx+O1cGDDhRgqQcxgYKMH5E2/WlMno6A0D4OWoJRJiyJz6zB?=
 =?us-ascii?Q?kpjH5PJ5Ei1uScB83xMGNrQcszrjAIR5u5vw8n6bLw95jZGcV2PhGZZmTFnb?=
 =?us-ascii?Q?NnZ5de4Xjd0TqsUVi8fEH5AN0MNYK3wOGab0uN4In7NaWpHgZjf+pdQF5MSS?=
 =?us-ascii?Q?/MlHk2K3Ta0gHlcTr/aZSBJS+THUF6WLebaQPV5Lb2avn5v7xVICD/HWZ65Q?=
 =?us-ascii?Q?FUJiVvj6uXwtO05HaEGZz/fHZ3Mz3UxxDLoH/AeLVJdBOMk8G4r2B1PXDcSY?=
 =?us-ascii?Q?2vbMn5Mrkg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 312bd075-e986-4a2b-42d8-08df349bb0a8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 02:32:19.9121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Qcn4vW8pZZw8Tz9JtCEsc3HKlrYGrXnH3mtpNzXT5edgGOeLVTU5g02QMqQcvZYM5tqZpCcA2tKlkWAB3cnQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9783

On Tue, Oct 27, 2026 at 06:06:05PM -0700, T.J. Mercier wrote:
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> move LRU size accounting on reparenting instead of copying it"),
> mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> afterwards. A folio that is off the LRU during reparenting looks up its
> lruvec through its objcg, which now points to the parent so it is put
> back on the parent's LRU.
> 
> As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> when !mem_cgroup_online(memcg) is true, making the offlined memcg special
> cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> code. Remove them.
> 
> With the get_nr_to_scan() special case removed, an offlined memcg that
> still has stale effective protection now has
> apply_proportional_protection() applied like get_scan_count() does, so
> the MGLRU and traditional LRU behavior is now the same.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---
>  include/linux/mmzone.h |  8 ++++----
>  mm/vmscan.c            | 28 +++++-----------------------
>  2 files changed, 9 insertions(+), 27 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 3b96d6c7123b..7f078ff0dd76 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -638,10 +638,10 @@ struct lru_gen_mm_walk {
>   * The events that trigger the above operations are:
>   * 1. The first attempt to reclaim a memcg below low, which triggers
>   *    MEMCG_LRU_TAIL;
> - * 2. The first attempt to reclaim a memcg offlined or below reclaimable size
> - *    threshold, which triggers MEMCG_LRU_TAIL;
> - * 3. The second attempt to reclaim a memcg offlined or below reclaimable size
> - *    threshold, which triggers MEMCG_LRU_YOUNG;
> + * 2. The first attempt to reclaim a memcg below reclaimable size threshold,
> + *    which triggers MEMCG_LRU_TAIL;
> + * 3. The second attempt to reclaim a memcg below reclaimable size threshold,
> + *    which triggers MEMCG_LRU_YOUNG;
>   * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
>   * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
>   * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce8..636152d8c94d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2754,13 +2754,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  		scan = apply_proportional_protection(memcg, sc, lruvec_size);
>  		scan >>= sc->priority;
>  
> -		/*
> -		 * If the cgroup's already been deleted, make sure to
> -		 * scrape out the remaining cache.
> -		 */
> -		if (!scan && !mem_cgroup_online(memcg))
> -			scan = min(lruvec_size, SWAP_CLUSTER_MAX);
> -
>  		switch (scan_balance) {
>  		case SCAN_EQUAL:
>  			/* Scan lists relative to size */
> @@ -2769,14 +2762,8 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  			/*
>  			 * Scan types proportional to swappiness and
>  			 * their relative recent reclaim efficiency.
> -			 * Make sure we don't miss the last page on
> -			 * the offlined memory cgroups because of a
> -			 * round-off error.
>  			 */
> -			scan = mem_cgroup_online(memcg) ?
> -			       div64_u64(scan * fraction[file], denominator) :
> -			       DIV64_U64_ROUND_UP(scan * fraction[file],
> -						  denominator);
> +			scan = div64_u64(scan * fraction[file], denominator);
>  			break;
>  		case SCAN_FILE:
>  		case SCAN_ANON:
> @@ -4355,12 +4342,11 @@ static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
>  {
>  	unsigned long total;
>  	int swappiness = get_swappiness(lruvec, sc);
> -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  
>  	total = lruvec_evictable_size(lruvec, swappiness);
>  
>  	/* whether the size is big enough to be helpful */
> -	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
> +	return total >> sc->priority;
>  }
>  
>  static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc,
> @@ -5199,10 +5185,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
>  
>  	evictable = lruvec_evictable_size(lruvec, swappiness);
>  
> -	/* try to scrape all its memory if this memcg was deleted */
> -	if (!mem_cgroup_online(memcg))
> -		return evictable;
> -
>  	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
>  	nr_to_scan >>= sc->priority;
>  
> @@ -5325,13 +5307,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  
>  	flush_reclaim_state(sc);
>  
> -	if (need_rotate && mem_cgroup_online(memcg))
> +	if (need_rotate)
>  		return MEMCG_LRU_YOUNG;
>  
> -	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
> +	if (lruvec_is_sizable(lruvec, sc))
>  		return 0;
>  
> -	/* one retry if offlined or too small */
> +	/* one retry if too small */
>  	return READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL ?
>  	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
>  }
> -- 

In some of the places do you want to consider adding a VM_WARN_ON_ONCE
for memcg_online not being true?

Acked-by: Balbir Singh <balbirs@nvidia.com>
