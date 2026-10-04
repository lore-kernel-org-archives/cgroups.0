Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9353245039;
	Sun,  4 Oct 2026 02:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791079906; cv=fail; b=aA5TOay3b+WR0yBGki8bCVZq37qEzRSJJgWFKRTa18YP4Sb3zW53LPdKXXG2ffvqLwA8EcwGGEas29gVYFUgUM1L6b5RHppW+zlOqJFjbwPBT5uykTYO06z0Bzi9qc/5uAXYXQsbLLx3eHEa44K4R/9CpadHX5b0MPdXgRuKPSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791079906; c=relaxed/simple;
	bh=ZKb9yBvtYoEUa2ZgmPLssHNzCtXWZpe2A9FV2G9kmBA=;
	h=Content-Type:Date:Message-Id:From:Subject:Cc:To:References:
	 In-Reply-To:MIME-Version; b=Cylre000vhnj+3aavrn+4qZ25jxlV8Q00uSH4Asd0dh6T/HGQKwiHsE1LNIGkLDG6SSIWxLosId7psV4c06uwuhXpSuUZxRG5drgZW16K0bA5hMwoxqKGuvZpsMSgdtZ5mgHY74eF1WuV7avqVwYkoxvMlU+1BxHL0a5D9/F11o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oI1AWIb0; arc=fail smtp.client-ip=40.93.195.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oI1AWIb0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qct5yymrNPTI1YaUVPnNYzNoMg0jL/2W+ZCHYYIBGWj1eK2AnASZjpZEa3pLJXtDN0AR42E7U/gnx0HGcWQTMGJWGmkS1XmsLVSs+BlLvfK7OEHZw5myzmW+FywItabl/XH4wSc/NbfYjjSBX6wqfyjqUeh2CxrUtGAyKLmsTTuovSMu1xX3YulZSsd3JOBe3AGljzJhvDp1RXzi681KU+AVdq4kVv+HI0lnfmQH1wkucxnXDRGuRW64fMHkZA3IALiWHDE6TwgiDbMOaRp4ojLYHos8ahal+WOasOFfbt3pyyc5yUKjSMFn4+Uz07y5rMbDeDw4ttk9uSYcF3gQCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7t3CfkWURhOppHSB69QbSkK3cWRfvDZG0L6BoiO7za4=;
 b=TOpArcWeLmEi268RJGsF0rrpu1goMdME/vCTxkTonIojciwsb4V7hL6bMJBwAdIv9TZ5KIHfV+vfSqt4tD5VioTVVIzBMJmP0YqjqbJfkF7a6ct0ReLeSUH6LnFn7TKaQ6tFns5+M8DI9uMGqueCkBZHPOiO8vIccGannH2LhbR3BO5zhkBeenbRwLd3YxinO4clpF/WY1KIM8TItGBk6a4PB+UT6IqHAYP8zy0K9NC6UUYi5kiElykMYvVroenTre2uSxzcOLj7pvSXdSUv97Ds4kMvAu/rW/aNRL3VCWJAohf2eJ/WrEV0aml6HN9I9CtwZV6jv1DaxOhWC7/AyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7t3CfkWURhOppHSB69QbSkK3cWRfvDZG0L6BoiO7za4=;
 b=oI1AWIb0t39xymzgiqp6/aiibpxJYOqGY3Q0t0a7CA48bwq4v1wqCY33i4Qd1yOcM+sU3pcIr4ulNtL1GfUxz95kRpFryDibpl4SWyPTn+ZXVzRe9bmEGZYkijMTwRN1guyCR3K0X/uKJxSffy6sJhWEwPRNRlSfj7e9M0LfnxEl/spiniNzF5q/klxmX2Jx/WY+WVGlnUohwdcw7PyraRP593vqD5+fzdezCqYKJW+N62QgOE3rVLtg/qbG1PK2Gy+V10vIBzXJyZKnLssdxfmyTTe9AmPunT/nZBHAbLjsjG3dEJo8oiPIF1OP+JXYB6HkQwQid1u0eIktmrvV5A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CHAPR12MB999224.namprd12.prod.outlook.com (2603:10b6:610:302::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Sun, 4 Oct
 2026 02:11:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Sun, 4 Oct 2026
 02:11:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 03 Oct 2026 22:11:32 -0400
Message-Id: <DLVOTZLINBSQ.2FBQBO7G548GA@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC v3 15/17] mm/khugepaged: check folio referenced
 state via LRU refs under MGLRU
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Muchun Song" <muchun.song@linux.dev>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Chris
 Li" <chrisl@kernel.org>, "Baoquan He" <baoquan.he@linux.dev>, "Nico Pache"
 <nico.pache@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Barry Song" <baohua@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>,
 "Wei Xu" <weixugc@google.com>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Kemeng Shi"
 <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Youngjun
 Park" <youngjun.park@lge.com>, "Gregory Price" <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Hugh
 Dickins" <hughd@google.com>, "SeongJae Park" <sj@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Yu Zhao" <yuzhao@google.com>, "Vernon
 Yang" <vernon2gm@gmail.com>, "Zicheng Wang" <wangzicheng@honor.com>, "Chen
 Ridong" <chenridong@xiaomi.com>, "Tal Zussman" <tz2294@columbia.edu>,
 "Kairui Song" <ryncsn@gmail.com>, "Xiang Liu" <liuxiang.277@bytedance.com>,
 "Ehab Ababneh" <ehab.ababneh@intel.com>, "zhaozhengzhuo"
 <zhaozhengzhuo@uniontech.com>, "Lian Wang" <lianux.mm@gmail.com>, "Kunwu
 Chan" <kunwu.chan@gmail.com>, <linux-kernel@vger.kernel.org>,
 <cgroups@vger.kernel.org>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
X-Mailer: aerc 0.22.0
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
 <20261003-mglru-fg-v3-15-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-15-cbd4546a5bd9@tencent.com>
X-ClientProxiedBy: BL1PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:208:256::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CHAPR12MB999224:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bdcb519-f726-4cd4-be29-08df21bcd042
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|10067099003|56012099006|4143699003|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cic9U+rMpzxD/mKk2wuuRKPgHo1AYsDtmPF8/j9w+Lx5MryCO/wlBZgGNDuRAe8PjqasOK6MlLhv7r58I+RqhBDTTtBrpQVO8ttV7dqnykgvnkNaXNvztWm3/t0v/GtUosioprzHWpg+QTT2+qFzzLeMbtTJqXxxmfMwEB6FtqlYhx2xTTTY06DbBqcVFz96WnGe438QUWTkjcOA/eRhISHtSSF3MaqM+VTlvwhpCWWDm2UdEwCwwEXyqAsEuwyJBZGAPOjB49+T/imcnSz/J7T4G4Ytbgx9b5Yc+zwMR5ChbDUPHMz/lnfwRAEOp8PXyShr8gK1Cl+q74BgMTfY7sSGgzW2XO3dqXTq9rlCMi4+02KZkS6CWjRmJLt2BhWBKtE+Jfu1ezhd3AsA4HJqWRWhaUj59UXu9aBmqSCfY3yQOPlAd9CH3tInnTzecYS29JgVvrYw1XbBI/a2yHO5G2d6bEY76TvkOVPrKofpuL77Wbt8JqlaK4Y8sKWJ56uZXpKFmUClC4+EK/lS0RIQr3WiCK1nH9nc+ssMN+s3aoYAWS28GvHe6vfMcGKg5p7xO7jQYdnw122jvjdcv8PhAHGNQ9mnkDS8G74jQUQeHOJtv2yHWJ7wF8hgopDvxH2osVxAnEQ8aU0lQGco3kP/a0xVLqGdjNJcRK6qodQrPUs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(10067099003)(56012099006)(4143699003)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDArc09ZMFpiNnRPTnQzMmdrdnVhaUVqZUNOTUpNdlNSNW14cXJsUFkySk5B?=
 =?utf-8?B?TnV2Q2txandZWFpwMWNyZVRQU01GZDB1N1hUN0VONlN1NEVQLzNnbUdHQUhp?=
 =?utf-8?B?V0RkVlZab1RuVm9vVVA0Q1MwSk9ETHZXb2pCN1pjZ2xMZ0lid2FQN2hoWFow?=
 =?utf-8?B?TGNCMFlpTmVTZjc1QWhFK2pzNElDMUF3U04rVDg5Zms0eHdDTFY5a0E0UTZv?=
 =?utf-8?B?R2duVDIyT05ORGljTXBwekcvbU15bjR6MjdpYWNVNkNPMGoySjg2YmE3L09K?=
 =?utf-8?B?Y1ZlN1VRS05DV1k4SjliYzZ4S2NGYk5yL2RDNm9FemZrVnh6MmQ5VWxTMlpy?=
 =?utf-8?B?VEFycG5SaFZxbXFocFlEVUtvOWkxQy9YR0g4YzFXOWpVTHZ0WFY5a2EzbUp0?=
 =?utf-8?B?MUJ3bHc1T1oyRFY3K016bzJGajlrQVZrc3lSRDhFVmVCMTVNYzJEMm8zTmNF?=
 =?utf-8?B?UWxMMDJhaDFMVWVCREdMMktkWEswSGlqaDQ0eDErbVlIMitiVEYrcUZqWGFB?=
 =?utf-8?B?UXRuY1ppK25SM3ByYUIzekxWUlFrZzYvUmd6UzVtVXhyalFEbGt5b0Rzc3NF?=
 =?utf-8?B?WXVhN1VKa1oxSUJGVmJLbExaN2pqbjFsdldMSWk0KzZMM3pua3A0aWpjYytn?=
 =?utf-8?B?R3V4aFlQRUo0Yk54bW1xVW0zaXJDRU85TDFTYUo2eVB1c1RrYzV3WHRncStu?=
 =?utf-8?B?aEpsTjdpcEhQeDBsVVg4TGtxT2F6VFdGSEVRVVdVT0tiKzNqS2lJVTU5dlI1?=
 =?utf-8?B?dDF4d0RaZTVLU3g5VlFTU0drR29temorQWk1WWN0T01CclAya0JiVXJ2RnBD?=
 =?utf-8?B?cy9ualRqMXBHdXZ5TDk0dkhFYzNnRFF1Y1hZd1ZncERMbThzczVHVFJHWFpM?=
 =?utf-8?B?d1pjY0REUDMrdSt5ejFwUnpzSUxhMWpBQzRjdlpKUWw1WTFJL08ydGhHNjlj?=
 =?utf-8?B?TDhUZ1BrazNxNUlsSFozMlpyNk1Ebms1UTBrbENLb05zQzNXRWNYWDE1cFJT?=
 =?utf-8?B?OE9TTyt2dWcwWkl3Ni9SRExueUJsUDVUYmJvYS81b251dVFXN1lTVmZkdWZq?=
 =?utf-8?B?MHFvNXVqTXVrZE00NVhieXpDWlFuenBmam80SGhweUU1TE50NTJJMC85bGF0?=
 =?utf-8?B?NmhZN1loR215aXJqM0lvNHRtYkhIRnNZM2hEM3BmU0huRU1rZHMzU3phYTRx?=
 =?utf-8?B?L2lPRjRIakhqM2QvaVl1c2oxR2Z5MWhyM05nOHBkNkJ2bmtQU0NrQjhEL201?=
 =?utf-8?B?WlhSN1BjOVBkaHZKS24xNXBFZFc3TVRpZnp0b01UNnJ0OG9YZkk1QUZ1ejVB?=
 =?utf-8?B?bWttblU2NytOc0lFdnNwT1kwRXpHN1RweFBkSS81VkZtUlA0R2tBaFQrNjdt?=
 =?utf-8?B?NUFTUFVFQVU5aWo2V0Y5K1JkVEZ6RTVZb1NVekNkYVloNHBaTW0xUTlsUllm?=
 =?utf-8?B?ZDJVWFlPcTlld2REZDdrejlWQmpGaSt2MFJ1NzUzdnBBcFdmbnpvY3NKYUxR?=
 =?utf-8?B?QUJEck1aRnJCUGFETmJ2UmNUVkgwMXpsSWh2aDVGSHU2VHlnRFZXT0h4bGkw?=
 =?utf-8?B?WE15TFdaVWZqNGpQU2dzQ2hlbzlpVVdzdUxjMTR3Z3Q2dUV0bTZ5TFFuMnlW?=
 =?utf-8?B?K2pqSUtqYUlsQ0d2L24vTWJrbHZ4NGRVVEN0MGhyQlNDL243ZDFLVzFlenpu?=
 =?utf-8?B?MFA2ZkJLTmhEUnF1V3NpRDgwL2hVQ0cvL2lsVlpZeUlhclZ0SXIxclFoYktm?=
 =?utf-8?B?SjZmSXd0L0pKcHU5K0g5NEFlS1BDYmdVbnRrUkxoY0JsdEc1K1c3SHpmV1A5?=
 =?utf-8?B?Z296c1ZreDNVZ0dzQzBPeFJCYlhtS0VYTzBIajgyTjlBejBmdnRzeTFNZmlO?=
 =?utf-8?B?VlNsOWkvWThSSENXT1hrVUVPRXhTV1RuKzhXZmJwd0M2elBCRDNENTJGOXJO?=
 =?utf-8?B?QVVvMitqM1pWNmFOdlBhRnh4ZXBUNnl2NWxEVlB0blMwRGs3MkJQSVJsZEJy?=
 =?utf-8?B?ajRyS0kveSt1Ukt4MFEzcGNJdGZZMGIwNFEwaWQ2bUJuU1dGOTlOb1Q1RlhD?=
 =?utf-8?B?ZWpnZTdNaTdOampxbzJkTVB2U2xwQ05HUFVrYW9XYThqMXdRVCt4Ymw1eW9t?=
 =?utf-8?B?dnNkTFBrak1FSXptcFRMMDZCaERpcFRqV05yTEJXaFN2SVF3ZEU1Q245aXlL?=
 =?utf-8?B?eUJ3RXQzQ0N0cDFON1NiWERqdU9RVFNRcVdJREZGMmszWUtCSzNVa05lZTQr?=
 =?utf-8?B?NWN5dGZiWlVrV1VyQWtRa29sb2pabEV4M2t0bVRaN3NoNVRzWlpGRktwZ3A2?=
 =?utf-8?Q?e8T3DMtebDCShOYTcx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bdcb519-f726-4cd4-be29-08df21bcd042
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2026 02:11:34.2708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POZHVJ915cR/E40D9zJUsxRCYB0LaSMtrQoJyF4oOVq9HFkBs9y9Gxczi7V7ZbJc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR12MB999224

On Sat Oct 3, 2026 at 8:55 AM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
> count, so folios with a higher refs count no longer have the bit set.
> folio_pte_referenced() testing the raw bit misses hot folios at
> refs >=3D 2, under-counting the referenced folios of a candidate range
> and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.
>
> Test the refs count directly when MGLRU is enabled, mirroring the
> smaps conversion.  The classical LRU keeps the plain bit test.

Why not reuse the smaps helper function? You can rename the helper to
check_folio_referenced() for general use.

>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/khugepaged.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 913086eaf17b..be18381c6efd 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -586,7 +586,9 @@ static bool folio_pte_referenced(struct folio *folio,
>  		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
>  {
>  	/* The folio was referenced previously ... */
> -	if (folio_test_young(folio) || folio_test_referenced(folio))
> +	if (folio_test_young(folio))
> +		return true;
> +	if (lru_gen_enabled() ? folio_lru_refs(folio) : folio_test_referenced(f=
olio))
>  		return true;
>  	/* ... or the PTE mapping was recently used */
>  	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);




--=20
Best Regards,
Yan, Zi

