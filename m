Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793155354;
	b=FfVo+3g0G3OoAr0BabmILBYxF6t/aibmu/BtfJwzhxVjDEu23t8mAirAmYUsqIGo4Hya
	 H/n+x++6EC6Ec9w0oypkrSzz5QGyUqcB4x0A47thuNks2w2ckm6A2A5I3sNgpzzN/lT2S
	 Y/DHcS26iOrV5D1CNBOyydsNKYG1/uDqNWK5HoA3KZ9j+3ls1Ev5vQwgpSvjb7S23AOQh
	 RskaiETOqK9GNtR9XHqg/RZR5Q7O9g1EfGEKkKV4x1+VbHvVbi2fqJ5i5KOj9HSXSb/AC
	 p7g8RiLNzmW4fN2t9yjFc1DRWhykQaXNV84KPcbtGyRZljWwPMLzBZzforMBjm4ya3Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793155354;
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
	bh=HQL9p3RFteYJHSpyeeyXsYlloO2LuHIDKkrEoNphPtY=;
	b=uVKo1AlPv9T60VymzCMCahZwo4T9Xi3HoR6DPrEhqwBcTN+6lf+zVlVwM+CTJBIGrsGs
	 rQq1ZyWsfQuz8Y0IHRBbBoLgyBAS7U+I/sAwyPiDYzig9nsYE0lxRxFbgquNBDWOa7y+0
	 xOlwfWZEnFkyH2kWWdCBF9Yv/ONqjmfwvNkKfgQqDScdEzIZv4VjboCL+J4DmdAUwrY+b
	 67v5v4PIn2fU2OTvG7g9nHGdY0T6KbJ8Qe+FFZ/20X94S0zGIGlexUSXkgOAvQ/3oCnpW
	 ZqO+zEyZs+SUMXAYBGT+hz8aE7VKaevVJwrxe1hd8H/CwSlv1sbfOA8Di91oBY28yUA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=d+znapmE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.54
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010054.outbound.protection.outlook.com [52.101.193.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A8A606A31E;
	Wed, 28 Oct 2026 02:42:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3A8A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=d+znapmE
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M/ephZvh1LCzHl4LPvVumqkfd7po3L8ii9dgTv5N/iqhz76shsnwXHLm+J4BN7F9qe30p3mBc2DMCYGbS7QmhsgeSkS/TJfkyedSRbcdT7h5/YkdhgVyYaUPkIn4Wa1vHPhZhOV166ZC3xNXPlBEDyV2iGNXGFaH6jaJQPmiB2Dkto4eazCI3psZuJBXoDcAkRaC00hvCBskD34Q5jh3Zlgw7Q3cwu6z6IVHjgYD4UOUwAjWypgX6h78G9BUPUY7i1ezSbHU/kPbnNr+b2wTGvuKWu2uzfcTwMh6X0nXn3DaBcbamghW5iXZ93beQuPOyybieNPtDCEqhrhdAFNB3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQL9p3RFteYJHSpyeeyXsYlloO2LuHIDKkrEoNphPtY=;
 b=OoI6uzax/Sa1Rthn1ZfbeP3mjyDtcJdnAwwE7tZoecf8IMrHja2CYx7Liy2KlxaRnrow3Bq8oep75nLXmeakZf6RACzmDNytk2xj/XKqojE0y75FRXpYwGVH8qd3Z6TOCUBBwRBgqlIBQnmQ0QnEP5jOiGTFfHkjdAtpI5j9ByTDjhUJ0nx3Xclx750aLngzw2IVrA46K2B8AW1hFJXYwF5/QiDybXQh/I3Wm/KMjC2wxX2V4rIRQdVGEjOsaate1q6jQ/+tD0HMQGBdWRs/iROBNtVAMKJmt0h/z9bYP5udyTyB3JYVuGi8KRX+j/1zS0CmZDYwvuhJDSs/c09Dww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQL9p3RFteYJHSpyeeyXsYlloO2LuHIDKkrEoNphPtY=;
 b=d+znapmEb1KQgRCUnZ7aB/ym/gpluz99SVHRWseB0AjnMwM/rjHaqKbjcnsyQMNk9ZlZGZg/7mlALHnnZTTLj6jSEDdxKSNi1cRAZjGP4qEYJu3SaAnvjkBoImsoQh6tz3e68hJWRBkMfdJcuKYwj/bubRY/MZ3DjtUiGtNcd9l4avhLo+uZvpDL7MmRObxUcCWPuPj1wtUpALfGWfWtuIUbp/54tfx6+g/TXX051Bo5ggpVo501pw3kNWCndvFNsies1s8nnEJi31Ft+fotLMELj8C2vyqTRZ+TmsyXvzXLQ0uzcYNZAziucZlj7cqaJgz9WaGNp6Fp6WYDKdCLkw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by CH2PR12MB4278.namprd12.prod.outlook.com (2603:10b6:610:ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.18; Wed, 28 Oct
 2026 02:42:25 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 02:42:25 +0000
Date: Wed, 28 Oct 2026 13:42:20 +1100
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
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old
 generation
Message-ID: <auFhDMtwymMynf8j@parvat>
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028010611.3929937-3-tjmercier@google.com>
X-ClientProxiedBy: ME3P282CA0013.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:80::23) To CH3PR12MB9730.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|CH2PR12MB4278:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b21672b-5cc8-44fe-7850-08df349d1978
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|261026140227099003|261021121427099003|56012099006|261009223027099003|5023799004|4143699003|11063799006|261021123027099003|18002099003|22082099003|261026121527099003|10067099003|6133799003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	uuWX0HDSR+44vsbilm3jEqqNW1Ts8ar7zlr8zAfPvpL6f0NU4n5CV0w6naNs8ik90pq0XFL5wiSPIV2f7QovrplOs3Or2bbAXXkOob0FpCWudiZwlje5zbvKz7l+L+4aPNvDEUKd9r4uL7Y/ygq7WijYxT5kmwDx59zyDSZD1FkdkzMxcLpSUkgfdIQxDKOx+K9IpEQ6uKam+uHOcUwnSFLvUT41pmxHn48H5mLJt5fe5LxddJENKY3EHVvw64WBsFPueGYvvhLpdNc21nd0H6WwOvm6EnifyGm8MDHlznLp8QRIJzmbG8/cY0vXmB3PY0Sn3aQM8BekawPDq5LFowk7KnnoO7mjTAHigTHAFSgwOTxeEer8myaM5MBdXtayxe+z4MEsGRHml/A+xaB9/1M3ixhiyqLrDAjKJpGkrgSdDrEdTWVBEIJ4nxcWPtd2igKydaVklhH3ojYmqrb8Kr04H2WW7dP2qZmoIQ2G5HQH/DCLNpc19CFSgvNC/dZydAV5VTO/tsBenHFeGFsEHmi/XxdlhrLnLaHFvsKEIkTfqPqPPx2GyBQN46j7Y5X0ku07BI32P+THG6Y+OGy2I6IGP/hQfn5dArOATvKMgMb1KAy+RH35YwVi/5i7Q4udshv1yDC0ZVxbd8/o7apkrCaC7KcQNxHk1je+Gc5NoFw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(261026140227099003)(261021121427099003)(56012099006)(261009223027099003)(5023799004)(4143699003)(11063799006)(261021123027099003)(18002099003)(22082099003)(261026121527099003)(10067099003)(6133799003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QghB/Imr3Wvc5oEyAD4m7cssR2euuSunKiQvY0U2j3Hi3nj3538Ys3MJfrvN?=
 =?us-ascii?Q?k6aWFsYWNkrxBpn6lgpr7F1RzkEw2TtA7+G/W+8tRiIE0cqKR4XPro+gVXMy?=
 =?us-ascii?Q?yQjBHeNyJCx4elFW3QNHwxyB3RDrcCY5/BsXMnaeg9Jx7i3eXg4rqpKGMIIo?=
 =?us-ascii?Q?roa45xhJkXEMKTa4QZMzwDzWLr6UCYXsk2NI6EWWcHi12+xrE41ZEwDQy+k9?=
 =?us-ascii?Q?JZNWIbGgItNmy0wjnjKO6EB9vQxKMbE/cIVqdMrXIwbO+wWnLgJaS+EaBwPV?=
 =?us-ascii?Q?KBQXl2oKozntH0wb+r6/5NPHBmV96oBuC6DETukrGflJv+I0T3QfcI2uD9KY?=
 =?us-ascii?Q?tnq4XcIT9ES6XTEoMfUky1F0pA7Uohz9ZK8r78NeUMHOt6Q5P51zBcUEp3Od?=
 =?us-ascii?Q?HkBMqGT7ZlgmFEaQ2wt1ybGkYt50Fjc4uRz574iAg29Fy1ljGIR4SOMyjo8Q?=
 =?us-ascii?Q?OyjYJwjOV1XfZjm3f36eYAf2v8oJhZ1RGLzUidom9ALgiRw5Et+rH9WzKatI?=
 =?us-ascii?Q?3qEWhiaJNOqtJhZiq0ta2MzAYKGLIIp9H9rcisKXR2l9W/ABGtcznmsEbrm8?=
 =?us-ascii?Q?AsFOIpEI0wRSZU3V3pMINAQaRf6PAIIp1gFiceBJ7DfvjkyAeg7mnQMJ3yTU?=
 =?us-ascii?Q?zZD/ixxvb5TTBi+dfhXBmBkfXKKDNACeFrzO/utUN31Llac/esIkNUlR2vZ5?=
 =?us-ascii?Q?pEKVesCn6fBZbdsv4hG1yxZ+mTRosFIkeS67QVmylBiRK+9Gc6F0P1zXfp0K?=
 =?us-ascii?Q?C8d7aYxHOeW24FnAI4RWgEgOOvaqsQkv5g1y5Nw4Z1IBm6F9MUZF/b3JN8Nu?=
 =?us-ascii?Q?MOwsoveKz7f3HbDoB5bAHUS7HVq8x7cE8losyTABZIp+QOphCuMn7kVwr/0f?=
 =?us-ascii?Q?37r+LtroFMtslpivXu3M1yv8r3CJpEDLNTFohje5Rce/ojn3feuOn/ObbObe?=
 =?us-ascii?Q?GZmFJ7oCWQ64OwyiAbd2ieYkE/hTBe606mA+4W6qSKwa/vc3qa8x4K5z6tGz?=
 =?us-ascii?Q?gjIYT02iDLDx2mvNc1B5buNcO4TN2KZHBn8tNxAubv88xdPdmP5XOicC81ub?=
 =?us-ascii?Q?Eek78S1kTTyB8f0K9V6t0SAIjLavdGp0ue+a13hac9msoTOJStEY2quAqxw0?=
 =?us-ascii?Q?MixOePQAr95zna90SMnyatytnnoLePduDiiyie6mIyNyyMzSQMxJcJajkwte?=
 =?us-ascii?Q?H/jrjSRgtP596be2EZI0NhUZS7E9iAea9Lb3dtJrOzIO13D63ofGB2oAnyIA?=
 =?us-ascii?Q?/w3FN6sTsQYa77glwas/BXwIAzcgfqHT9AeNCvLYmOsNn2c3rEYLCRfmtEwA?=
 =?us-ascii?Q?MZDwjCQ7FOpkmw/2OQnWkI1OFgJZ8swj9lKx0CGbj+ajzigwORnikSBNxu79?=
 =?us-ascii?Q?gxaTmXltOYj0iCb2Nwwhm48HSjE8ol/LzRRcGIcGsU8Ey96OwJJArTwInA4b?=
 =?us-ascii?Q?Gdruq5SS8yH/8mUAZu61hdkkhe+MZ+KXJEh7WQsBs+nr/eyMzvWGfe4N5CKP?=
 =?us-ascii?Q?UEJFlxfoxFq8qRje3S9LHQ5VPkn00IVNQjrJWOZVTpFelekSubHxwqZAazdk?=
 =?us-ascii?Q?XAAdcqXYw9SqHIECWWIJfzxK5P6EMCnhbPm+0FgxxTNsX/eM90gtN97zwtaA?=
 =?us-ascii?Q?is8CgJEPKNpC1sJ0WNP84hDNXMOgTR2zhN2uqQ8hkKLtvXulW5kEcrIOPDDu?=
 =?us-ascii?Q?8ZoCvVON+fAv8h6ja3s9nMogzUEAiz+qlN38KN2dqURe5x2OWSsmOUAEHK+T?=
 =?us-ascii?Q?iWIOtOcKHQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b21672b-5cc8-44fe-7850-08df349d1978
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 02:42:25.4808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YpBE/1KFuK7VsHKcdklkKCwQUtNHbagxm4jEzL6h9EwYhN3d6glbEMBqSoAukByOAtlYP8Ut6M1ERCOpYlwzCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4278

On Tue, Oct 27, 2026 at 06:06:06PM -0700, T.J. Mercier wrote:
> lru_gen_offline_memcg() moves an offlining memcg to the head of the old
> generation of the memcg LRU (MEMCG_LRU_OLD), so that global reclaim
> visits it first and evicts the folios it left behind.
> 
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios"), those folios are reparented to the
> parent before lru_gen_offline_memcg() runs, and nothing can be added
> back to the offlined memcg's lruvec afterwards. Putting an empty
> offlined memcg at the head of the old generation no longer serves any
> purpose and only delays reclaim from the memcgs that still have memory
> due to additional shrink_many() iteration.
> 
> Remove lru_gen_offline_memcg(), so that an offlined memcg is rotated
> like any other memcg below the reclaimable size threshold until
> lru_gen_release_memcg() takes it off the memcg LRU. MEMCG_LRU_OLD has no
> other user, so remove the op and update the memcg LRU comment as well.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---
>  Documentation/mm/multigen_lru.rst |  4 +---
>  include/linux/mmzone.h            | 14 +++-----------
>  mm/memcontrol.c                   |  1 -
>  mm/vmscan.c                       | 20 +-------------------
>  4 files changed, 5 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/mm/multigen_lru.rst b/Documentation/mm/multigen_lru.rst
> index 52ed5092022f..b532ce961371 100644
> --- a/Documentation/mm/multigen_lru.rst
> +++ b/Documentation/mm/multigen_lru.rst
> @@ -234,9 +234,7 @@ the active/inactive LRU (of folios):
>  1. It has the young and the old (generations), i.e., the counterparts
>     to the active and the inactive;
>  2. The increment of ``max_seq`` triggers promotion, i.e., the
> -   counterpart to activation;
> -3. Other events trigger similar operations, e.g., offlining an memcg
> -   triggers demotion, i.e., the counterpart to deactivation.
> +   counterpart to activation.
>  
>  In terms of global reclaim, it has two distinct features:
>  
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7f078ff0dd76..542e465ee7a1 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -626,12 +626,10 @@ struct lru_gen_mm_walk {
>   * per-node memcg generation counter, whose reminder (mod MEMCG_NR_GENS) indexes
>   * the old generation, is incremented when all its bins become empty.
>   *
> - * There are three operations:
> + * There are two operations:
>   * 1. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
>   *    current generation (old or young) and updates its "seg" to "tail";
> - * 2. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
> - *    generation, updates its "gen" to "old" and resets its "seg" to "default";
> - * 3. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
> + * 2. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
>   *    young generation, updates its "gen" to "young" and resets its "seg" to
>   *    "default".
>   *
> @@ -643,8 +641,7 @@ struct lru_gen_mm_walk {
>   * 3. The second attempt to reclaim a memcg below reclaimable size threshold,
>   *    which triggers MEMCG_LRU_YOUNG;
>   * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
> - * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
> - * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> + * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG.
>   *
>   * Notes:
>   * 1. Memcg LRU only applies to global reclaim, and the round-robin incrementing
> @@ -675,7 +672,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr);
>  void lru_gen_init_memcg(struct mem_cgroup *memcg);
>  void lru_gen_exit_memcg(struct mem_cgroup *memcg);
>  void lru_gen_online_memcg(struct mem_cgroup *memcg);
> -void lru_gen_offline_memcg(struct mem_cgroup *memcg);
>  void lru_gen_release_memcg(struct mem_cgroup *memcg);
>  void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
>  bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
> @@ -709,10 +705,6 @@ static inline void lru_gen_online_memcg(struct mem_cgroup *memcg)
>  {
>  }
>  
> -static inline void lru_gen_offline_memcg(struct mem_cgroup *memcg)
> -{
> -}
> -
>  static inline void lru_gen_release_memcg(struct mem_cgroup *memcg)
>  {
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a05d9a8baa1b..e2ddf0680e62 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4475,7 +4475,6 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  	memcg_reparent_objcgs(memcg);
>  	reparent_shrinker_deferred(memcg);
>  	wb_memcg_offline(memcg);
> -	lru_gen_offline_memcg(memcg);
>  
>  	drain_all_stock(memcg);
>  
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 636152d8c94d..45a2c1021f4f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  enum {
>  	MEMCG_LRU_NOP,
>  	MEMCG_LRU_TAIL,
> -	MEMCG_LRU_OLD,
>  	MEMCG_LRU_YOUNG,
>  };
>  
> @@ -4560,8 +4559,6 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
>  	/* see the comment on MEMCG_NR_GENS */
>  	if (op == MEMCG_LRU_TAIL)
>  		seg = MEMCG_LRU_TAIL;
> -	else if (op == MEMCG_LRU_OLD)
> -		new = get_memcg_gen(pgdat->memcg_lru.seq);
>  	else if (op == MEMCG_LRU_YOUNG)
>  		new = get_memcg_gen(pgdat->memcg_lru.seq + 1);
>  	else
> @@ -4571,11 +4568,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
>  	WRITE_ONCE(lruvec->lrugen.gen, new);
>  
>  	hlist_nulls_del_rcu(&lruvec->lrugen.list);
> -
> -	if (op == MEMCG_LRU_OLD)
> -		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
> -	else
> -		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
> +	hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
>  
>  	pgdat->memcg_lru.nr_memcgs[old]--;
>  	pgdat->memcg_lru.nr_memcgs[new]++;
> @@ -4613,17 +4606,6 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg)
>  	}
>  }
>  
> -void lru_gen_offline_memcg(struct mem_cgroup *memcg)
> -{
> -	int nid;
> -
> -	for_each_node(nid) {
> -		struct lruvec *lruvec = get_lruvec(memcg, nid);
> -
> -		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_OLD);
> -	}
> -}
> -
>  void lru_gen_release_memcg(struct mem_cgroup *memcg)
>  {
>  	int gen;

Acked-by: Balbir Singh <balbirs@nvidia.com>
