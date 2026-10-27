Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793113479;
	b=A2WGJ/3YzIM6ZkWV3+aJh6nRXW+OIRIDgnUpo3l+6klz0351xmq/B9SM+0A9l5O31nuf
	 /Gt7SlfNLtXFEbSf/p5/pVb+YwJm3wZI8GXf/y6v0GEb5KfsIIc0GxHK6ceEf6SX/i4WS
	 SPztCG/QAbqqCmUitTI5nUrttz81GQ17Zvv9rxxpwl4GXBQLHQqByCBhYsMlLGNnyraG1
	 Nmp5W8YDQjVOWLra/2RklsMO8ux3hjNhF86WJzpWMlJIHNtns3mfFGRpCxsBpQjzz+2QE
	 wWP+pi4LkviYRffw2fkVX4abOuem6UUbhhgJx2X2rM9Jhq0A/I3iPPwf+mhOoOyeSWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113479;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:X-Mailer:Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-MS-Reactions:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=qq4mh4EQ0eFU7IR5aQFnIoyJEAscSabo3lQGAD1qryk=;
	b=zuxu1SpSo4uDEYGRdRfz7ajMMsvVgcN1vvwMqOD+B7J9tHOuTTzhfuNOVZt7lJSGciRv
	 E3SmLRq5dOELqrl7/TYtk7jm94ejeuCIweswyOpsVyHxo9DRulDmGRJ8rluP2bOBy5fZF
	 1yr9pbJa4RqmvWw4qizAqk39CYSIz8iOlrgbdUcQpia7N00aDMRUd86rMT7auivUi4GQW
	 LiQVzHgqvUc9dV5HYN92KHOVFzuP1DdUqBJrffW01MgIZh28AfQeIqIBGettSzfW0dOUt
	 7VwpbnI0YH4Plo1yUdXFY6wq3XgRqS1b5KA7UsmvaFV2TCKDygImETP7m9YUwgEUovQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="V/Qs3BNy";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.67
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012067.outbound.protection.outlook.com [52.101.43.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA72606A32E;
	Tue, 27 Oct 2026 15:04:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FA72606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=V/Qs3BNy
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tPiBKDJhaq0X3UBtjeTv5TFLoj43W8cwQss1JY5f12kGLwA3elFJvo9y6Q+jgbm4NjW0JX2ZZTGH4OXLgWq938qgz8QC7k3/xDvBflk6VI8yKlGcuameJBEHWcBkzB8wPBtdAyoM+veLRMVtoGi+dgjUoe6Iuz6MST5onh9ERcuNYJf1khBdm2eD76PJk/HrJT81nn6RtVCnQC5Ouge2cVtxvsy5PyaAY3WIR2UzRXdJTIYFSImrxtxn8sWSsDe1YmLRnkOq5kbfJVgwe+OwVlJHDdxh2lUPnppyXaRzDACIoDSeRr+lxq2XE5ts50k7i4jlPcfiab2WlFdzlNiLUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qq4mh4EQ0eFU7IR5aQFnIoyJEAscSabo3lQGAD1qryk=;
 b=CGN8e5/h/pJgim9aFidwPYPF3ZGNFlQKZTsZv6hhTfZZkFIbRbu+HbmgB5VxOQngHl3y6Fzwz2nJwl/mAit16shvNm2UmjsPri75NFD1cLY95XNn7y2AhxTGZZR05aoWbv0bIwWbM4eAX9FjNaxq+li07zuE/dJ7711QohTN2H5jLSKinQDPtNBJ4FPtryVOeB6WdN5EKGMZXn1Jo9XnOMiloj6UdVIXTIcLcclhtJ8WeGS2XOfXzZICKwPEJDxi2OU4cA3fT39gMrmNgccQxHYiYsQFjyhNkUDHr9jrwUA7cayQn0Cd112Nob8HzymMRiwNh+e0SN6rW39NutsMfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qq4mh4EQ0eFU7IR5aQFnIoyJEAscSabo3lQGAD1qryk=;
 b=V/Qs3BNyQAd/VpvND9FlloI+YEhS+a/IawhUEuTNv3yXdO2OEQyzoCSkDWiXEzkmffip4CiJ7paC2WEybio4vHly4sMxeO9e/fOTcdURUbfWBYKfGJ0BfNV1qJqlZiUvqc9wQfhmRuVqFQ7YiACrBg7n//5t9Zt+Yiinh3LpS3Oluo7w0C0Juwp0Ns2maHHdgml63kEeE0eOGnLueBqMtEARYANseOwoQ3rvo/BUc0GNxO5RPMWo3xTzKUDSJmZ5mkLT+XQyrpqIXV8zMnvr01AoLDL5A8rArsyN9kUV9CWkTtKLFGmIgRzXngNJSeDUHhtX2sJ/RZM/hN5t+EPrZQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB5854.namprd12.prod.outlook.com (2603:10b6:510:1d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 15:04:29 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 15:04:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 mkoutny@suse.com, david@kernel.org, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
Date: Tue, 27 Oct 2026 11:04:21 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <4C44AE80-1642-4808-ACF2-896E4B84EEAA@nvidia.com>
In-Reply-To: <8fe2314a-ec7c-4ff0-92cf-27f7f8c9c132@linux.alibaba.com>
References: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
 <8fe2314a-ec7c-4ff0-92cf-27f7f8c9c132@linux.alibaba.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB5854:EE_
X-MS-Office365-Filtering-Correlation-Id: 28cab706-f6d9-43a3-f468-08df343b96d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|261026140227099003|11063799006|4143699003|261026121527099003|10067099003|261021123027099003|261021121427099003|261022075727099003|261009223027099003|56012099006|261022105027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	eSlLaNh2f2wZMHfoV62h2CFsJrjwyqO7zlGv1nca7uYPP8xIVZI8fpGpcoyx3LtqX3RqwjTL2w0t+4+PLheQQ3INwjXSidmvSBahXI530QUD9vlDMhz3rAzKsrvSyxLKrhVmmoLQ0jHyxQSme1GdkKiXjr4b49z2Wx6MNHDhKRzkkbKanS0D4/OAYQeYhzRd2ChWSTXBoczfVYAz2rd8y2BT0TQTiHfjaWGl2lRUBt3Gv+LT5MysOA2Fq+TKtRHGOsS9AChio9c77ipvoWvEj8IaGa+eHR1+7wMOuZEPuHIDx0b1g14uArPtOuGwcvnf6NX6jSvOFI1Jfm35PZgYUw8jpCVAx26wo0DR5GRRGObsONjuopSZh/hxLy75VwujwHitcv1+wLmdhY26ZlySUKCcFUMSxFo1KhS40VvScbH/6cfT79Yaw8lukxCAguBpOohJ1QWfCs5Z0o2KTpXUvPdfl9WmJHA89jg2x9Hcl51diZPgzx0GQ2XYWFcq/0S8FmOhNPFlrIWgFxWh2ydu1Qis+eCLV+F7CFOdfYhDIIEDDJDjITjXbQl7oxBSIWQmTjgkSHlaMSKbqKfn98UObhPv6Aw2IJVeZ9JptZnOt3Z0DRWVwXKtlalARrmaCpASb2ZUMNKpgatm3T6hshhE6HwdJEuCjBVMMs1rPXM5VKc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(261026140227099003)(11063799006)(4143699003)(261026121527099003)(10067099003)(261021123027099003)(261021121427099003)(261022075727099003)(261009223027099003)(56012099006)(261022105027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hssYbx46NQGM5PIjdJ7mrN5M2bvfwI1cJfzLzAl8WVLYP7JBJkw266ITmX6u?=
 =?us-ascii?Q?ZqaWc2Q4djwHEVh2xXh9HTgAq5OXhFE2QStrGEniaSw8t4+QZw5e8HXI20wq?=
 =?us-ascii?Q?r9x4utu+7Ao1bUyixkCMDgr30fVtVHYybLiBbIKij/cprc3trDj5jGKw4mD/?=
 =?us-ascii?Q?3RTQRIRcc8BDAY1rq1CTfnojFaBjFOc/A9nc6buDMtp5ievXa/iIWN3fFLvz?=
 =?us-ascii?Q?frGgCUWCnr4cG7IwYlJc4PgGzuH0u3DLtrP8pKSS3OQByweRtfmk4UEnF59g?=
 =?us-ascii?Q?8soc4ioZXkGl3svgiwTNx60UaKb8kmNHjCl4xsjxoto7gY5Xb2eypO6oLrv1?=
 =?us-ascii?Q?u8yIghL32QSpQT/PXpp3Q5Ez3Ncjefch1y6nW1XHaJ60nlpgn4Z68e2qi5tE?=
 =?us-ascii?Q?SBNhvgYHqweEiCGaFr98W42Ta3rQT1qiSpW+ekm4hLLUoW2KkX4TvF82CMzw?=
 =?us-ascii?Q?CKB3y/kDa4ywAW7rLTxZ5aMyaXTbNcVCU18tYrSpn4eLaPrN4w8ky+Q1ARD6?=
 =?us-ascii?Q?G6wFOPZqpvlPds25cyZ4ESb1S3qwf1GlQiTTyrmmQDFMvjGtNTbjvxepql0E?=
 =?us-ascii?Q?m3OcSbbtjJCz1uE3xRBr409bAliZq5dM8dOI4MjggLTprqsc1EmgWj+rFvT8?=
 =?us-ascii?Q?pCKi2j4dapTMSbhCKUf6xftaW3EFRmo6zwh+MDv5igOHprzGaLEeaA+L2rs8?=
 =?us-ascii?Q?khhLY0YapiAja7//jk5NrzsjItyiMORoi7F3xobt2ILXys9GvWsm3Yc6pOjX?=
 =?us-ascii?Q?uKbW3Q8Sm+LD66UQwgK8MSf1fsVJc1RyxlxK9x/izNDmjdYOQTE8y3Xk4JbI?=
 =?us-ascii?Q?1udo6fWmyu97ra38TFaiSt2wLbPIkcHRwHXYInkxk8kxJzaT2LuQ3twOc+au?=
 =?us-ascii?Q?4ZKe8qYLWWKM5+fgOY7twBKF+W9K1g2fameETkApox52GZdeKhBUslyPsM+7?=
 =?us-ascii?Q?abvVsW1UuT3qX0muDwq97aceMQzqIxnXlNWiWoUDLcER0rZGTSYU/ACamlbX?=
 =?us-ascii?Q?dPaDRJam1W9FyZKIaYl4mGOZ8ppjhE1Ijpwr/PUqXPiMw2sMuMzSx2HiJsG6?=
 =?us-ascii?Q?iJzPNLK9e90/mVrj5qW3hQZk/WVBRdS8snjm4fkVO9NZ9Q6oED+fmc/BxLQi?=
 =?us-ascii?Q?fHBRwGTGA9wrDiN2i1q3MjHNninmYspXdJnxjAkzWvEZgLFzOV+BdNsuXE8j?=
 =?us-ascii?Q?7c2US+lr/9D2pV9kE93QY39UMcrUiO9j3H7ac/qBCwUsu6W2hivW4JGMDab6?=
 =?us-ascii?Q?33tG1X9dPQWbS23fHRcQI3+q7E7Ao0puN4N7l6/GVOaLTrNEir7cmKOTHd8N?=
 =?us-ascii?Q?xCtfKoLyrwbs5E8+dWwIKoZIbyotZhNjgJRs5+/wAZf8onj/xrPnzaqSrM8r?=
 =?us-ascii?Q?7pwYulglmXMU93Wi2Ms4PU183n0bL6IjXPzfuye3wXvHKRagLeBP6uFw9+ua?=
 =?us-ascii?Q?xdzT0bQPlGVJgj2XDbxJo9GrTefINM7O7KAcb/K0qR9lBAAHMg9KX8jsS+8Y?=
 =?us-ascii?Q?wB4Z9Gnu6dJXRfIBvAt+akIfxg4kAWBXAK8SiBfJ11DEgVy4RD3YhhJ8j70X?=
 =?us-ascii?Q?kHlvgd/dRlK0org19pqc/Ux6O8A6qTv5loWr99lNCe+TLs7FBuaomkUy/k6a?=
 =?us-ascii?Q?IwmRTv+Ijo2PUK2CmjiqnD3Od/UpoUOBAdk28L4CirFfJyOaa4ypLxGw4Zvf?=
 =?us-ascii?Q?ptNCv01x/nubPcIeWBKDYoynuCD9O0K/XgRt892uu6gWKH5AU2Ikk9BYWp5J?=
 =?us-ascii?Q?ZOu4JMHaaA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28cab706-f6d9-43a3-f468-08df343b96d1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 15:04:24.9444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7RhQO6ywt2A63JGOUmZpMyRgWiE+o6jIeViGyHJ4vOC4DPdX9Yv/o5vDH2hnOK4R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5854

On 26 Oct 2026, at 2:26, Qinyun Tan wrote:

> Hi, All
>
> Gentle ping on this series.
>
> V4 fixes the boot hang Kairui reported against v3 -- the root cause
> was that the walker reverse-resolved xarray keys as private memcg IDs
> after the keys were switched to cgroup IDs, causing shrink_dcache_sb()
> to loop forever on the global drain. The fix passes the xarray index
> directly through the internal walk path (new patch 1), so no reverse
> lookup is needed.
>
> Could someone take a look when they have a chance?

People are currently busy with reviewing various mm fixes[1][2].
Hopefully we will come back to this after the merge window closes.

[1] https://lore.kernel.org/all/20261027-fixes_core-v1-0-6f74bec9a5bb@ker=
nel.org/
[2] https://lore.kernel.org/all/20261027-fixes_shmem-v2-0-86a00952acb9@ke=
rnel.org/

>
> Thanks,
> Qinyun Tan
>
> On 10/13/26 11:12 AM, Qinyun Tan wrote:
>> With cgroup.memory=3Dnokmem, the THP deferred split shrinker and the
>> zswap shrinker are degraded in two ways.
>>
>> First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
>> shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
>> limit-induced reclaim of a cgroup neither splits its partially
>> unmapped THPs nor writes back its zswapped pages.  v1 of this series
>> [1] restored the flag to fix that.
>>
>> However, as Sashiko's review of v1 pointed out [2], the flag alone
>> is not enough.  __list_lru_init() also collapses every list_lru into
>> per-node lists under nokmem, so even with the flag restored, the
>> objects of all cgroups share one list per node: the per-memcg
>> shrinker bit is only set for whichever memcg happens to repopulate
>> the empty list, so pressure in other cgroups may not even trigger
>> the scan, and when it does, the scan walks everyone's objects.
>>
>> Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
>> list_lru"), THP had fully per-memcg deferred split queues embedded
>> in struct mem_cgroup, working independently of kmem accounting.
>> nokmem only opts out of kernel slab accounting; THPs and zswapped
>> pages are user memory and remain charged to their cgroups, so
>> per-memcg reclaim is still what these shrinkers want.
>>
>> This series keeps list_lrus backed by SHRINKER_NONSLAB shrinkers
>> memcg aware under nokmem:
>>
>> Patch 1 passes the xarray index directly to the list_lru walker and
>> drops the reverse memcg lookup that v3 still performed between the
>> xarray iteration and the walk.  That lookup was the cause of the
>> boot hang reported against v3 [3]: after the keys were switched to
>> cgroup IDs, the walker kept resolving them as private memcg IDs, so
>> the global drain kept skipping non-empty per-memcg sublists and
>> shrink_dcache_sb() could loop forever.  Passing the index directly
>> also removes the temporary css reference from the walk.
>>
>> Patch 2 drops the kmemcg_id copy, which is only assigned when kmem
>> accounting is enabled, and indexes the list_lru xarray with
>> mem_cgroup_id() instead, so the index works independently of kmem
>> accounting.  The list_lru plumbing passes memcg pointers now, and
>> memcg_online_kmem()/memcg_offline_kmem() are inlined into the css
>> online/offline hooks.  It also drops the nokmem early return from
>> the offline path so these lrus are reparented on offline.
>>
>> Patch 3 keeps a list_lru memcg aware under nokmem when its backing
>> shrinker is registered SHRINKER_NONSLAB.
>>
>> Patches 4 and 5 restore/add SHRINKER_NONSLAB on the THP deferred
>> split shrinker and the zswap shrinker.
>>
>> The savings of nokmem are preserved: slab-backed lrus (e.g. the
>> superblock dentry/inode lrus) still fall back to per-node lists, and
>> the per-memcg lists are only allocated when a memcg actually holds
>> such objects.
>>
>> Changes in v4:
>>  - Fix the boot hang reported by Kairui against v3 [3]: the walker
>>    no longer reverse-resolves the xarray keys; the index is passed
>>    directly through the internal walk path (new patch 1, split out
>>    as a preparation so patch 2 remains a pure key switch).
>>  - Drop the kmemcg_id member from memcg_struct_check() along with
>>    the field removal, as pointed out by Gregory Price [4].
>>  - Otherwise unchanged from v3.
>>
>> Changes in v3:
>>  - Index the list_lru xarray with mem_cgroup_id() (the cgroup ID)
>>    instead of the private memcg ID, whose lifetime only covers
>>    online groups, and pass memcg pointers through the list_lru
>>    plumbing; inline memcg_online_kmem()/memcg_offline_kmem() into
>>    the css online/offline hooks (patch 1 as numbered in v3, per
>>    Johannes's review of v2 [5]).
>>  - Describe in the THP patch's changelog why fafaeceb89a5 dropped
>>    SHRINKER_NONSLAB knowingly, per Johannes's pointer to the
>>    original discussion [5].
>>  - Collected review tags: Johannes's Reviewed-by on patches 2-4,
>>    Nhat's and Yosry's Acked-by on patch 4 (numbering as in v3).
>>
>> Changes in v2:
>>  - Keep the list_lrus behind the two shrinkers per-memcg under
>>    nokmem, so the shrinker bits are set for the right memcgs and
>>    scans stay scoped to the target cgroup's objects (patches 1-2
>>    as numbered in v2, new; addresses Sashiko's review of v1 [2]).
>>  - Patches 3-4 unchanged from v1; collected the review tags.
>>
>> [1] https://lore.kernel.org/lkml/20260904033503.4067283-1-qinyuntan@li=
nux.alibaba.com/
>> [2] https://sashiko.dev/#/patchset/20260904033503.4067283-1-qinyuntan@=
linux.alibaba.com
>> [3] https://lore.kernel.org/lkml/20260910080722.3961351-1-qinyuntan@li=
nux.alibaba.com/
>> [4] https://lore.kernel.org/lkml/arNK64PxTXbVEhis@gourry-fedora-PF4VCD=
3F/
>> [5] https://lore.kernel.org/lkml/20260907110111.2286932-1-qinyuntan@li=
nux.alibaba.com/
>>
>> Qinyun Tan (5):
>>   mm: list_lru: pass the memcg index directly to the walker
>>   mm: memcontrol: drop kmemcg_id and use mem_cgroup_id() for list_lru
>>     indexing
>>   mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lr=
us
>>   mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
>>   mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
>>
>>  include/linux/memcontrol.h |  16 ------
>>  mm/huge_memory.c           |   3 +-
>>  mm/list_lru.c             | 114 +++++++++++++++++++++----------------=

>>  mm/memcontrol.c            |  45 +++------------
>>  mm/zswap.c                 |   4 +-
>>  5 files changed, 77 insertions(+), 105 deletions(-)
>>


Best Regards,
Yan, Zi
