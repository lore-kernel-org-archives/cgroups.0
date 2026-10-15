Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021082.outbound.protection.outlook.com [40.107.130.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FC5277C96;
	Thu, 15 Oct 2026 11:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792064570; cv=fail; b=KOh5oW2nto5VWZAIvN6cerbbrJs0dNtseJIiCeLl0C0ip1dr50liWVvF5EDLrUKzOc+imN0HXjbscCH2mTbeb2z981Q1pLNMcWVoNNlxp8p9WQZg0E08yN2haHqZE+8VEdyULARk04KtvuxQLWx9rHtV4+y1loTz858Gfo6ABrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792064570; c=relaxed/simple;
	bh=Jh7Vvtj1UPk74IuhhiD0cuY1hhgQ5MnVbe3/bgIEClk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W5QB98vsr8zktRJ5crPMuUnS5tc1Z7X4lUzSBlRZd9rlhHSwBLP/OnC577UFFulyey6hnMdx3om6PZpwGq+5g2gyADvcnF5a4iB9ZGcjHxPHTaY4Fwx7cXZTfsAfNo2JI+6YyXR2cKAv1JHncH8GD2b/beF70Jl5DC2/Ye5Ik0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=UPODPDh6; arc=fail smtp.client-ip=40.107.130.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="UPODPDh6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tTHIFzvBkZhgpBwg3BekgajBKrgzD7K/qb1RRyhrdCTMfoI7dbZ+VIhZkP+uxESiuEQw3uOlESQK6DW3QdQJBft5wntsUpgOqSyeVIdvGpz0lcpdidob3UBPud6ceJQyqOhrbJnYZpg5scfk9OU0G13NLMuc1jdpbE7M9ffbPVR4FnLO9bxzetBAS3wlKtGNiryhWwW788hCcpzreFGGVNMFHb0EKE962HEjcq27BxBmEH9T7WG2aj8UEJFQUTweDn7A6iY6ZYxCEXmrOmVcMkZZOMLp/F5mVdrb4Jw76k/+yZvh1JlMrFFoZUE5KZACn2GfuM3+/1ng/l3Mfo1yuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/T4hyFcGXUMRK8yb0SqCkYfpKnS/MxgxRiSmFAUtN6E=;
 b=WzIdJa6fSlPEs166kgUXdzLivj8rjBjz0xK/CKk7IIe/P2r23DgO79gzpV2L6eGrzhbxZULc/PwGsDf1I+I7E8KZ7wdQKOeHQtyr4VLU+AJujH9B45v6Ds3LKWnOdqoublWOc/s3HoGEq6gOBVs/F4celLH7uTgXXFWZyMPo/UGbwp4/Xs87NlCfCSS2qDkI+XJnjlXcNvBraQ+fcA/QLwNO2IiAphe86G/6J6UjHebHIduLLG5+L4MH61xGtUUYtkOunMNfK6kqy6L2euMMSQ49Uuo/Ixya9Bh3DyvD0QfK+j/cpPSFV8rTghttls1P098JqKyrka/feuv+LloRug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/T4hyFcGXUMRK8yb0SqCkYfpKnS/MxgxRiSmFAUtN6E=;
 b=UPODPDh63zvKx3yCKjn4wSFXfTzdqth0ToXgv0I/RwQmaEGZwXbBABAV7TM8jfxgFgW+L+wG8Z9dOoosCWkob1P7SYtNbWi3LEhbAQCvQBj+ZPSQH652CD/QJdx1reBhlAl3gArORIkWNqH0vcbbYRcAOzTiYwWkPSucGStgprJg6dc9+i2RdL9fspe+txgxCME+WWmE1j4t+nuvwRLsyvGlqxD2aUkFxZtuSg7raLK6O1zJQcu/dID0i3tKerEcVpa81L1M1PAxTj5iifIHjFnbW0/RLv9bApc6I5pkE8F0FyOllY55DvAz9TP1+nt0/KAHbA8c5BTZ2MzxPOzXMA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by AS1PR08MB7659.eurprd08.prod.outlook.com
 (2603:10a6:20b:47a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Thu, 15 Oct
 2026 11:42:43 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0546.006; Thu, 15 Oct 2026
 11:42:43 +0000
Message-ID: <84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
Date: Thu, 15 Oct 2026 13:42:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units cheaper
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
 <20261014135046.7b13252ce99d918ffcdb1f49@linux-foundation.org>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <20261014135046.7b13252ce99d918ffcdb1f49@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::15) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|AS1PR08MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: a7b7afdb-2fea-4451-2e21-08df2ab16ce5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	VsrSJCRwYQ5mLnaBihJvOzz0AdXZj3Z/j3p+V/9+urEZfolibwKa6pjv5dtumAAFGSo2gJusf3kJQKBBSd/9GZ+Nc0OxSIIYBWKz3QDWJ44ipRoRQcj080eMXeN3eLQ1sPDn+Y46A4iThIzjLgNSlCLn/jUY+2t8gkuPXP2l2Awjc3OPbmB1A0/frPhx7O7et/2A4SAK8232jvY0HY8OTqZyQpYGIMVL74YnDVwfUXXyKH5OjbYH7cgWXp1KLd+aliNTh9KlPQ1sYGjuJ9gJIrMJ8IO/qZ1g1NlUtTIY+pK5RhhqMQqujYe7nbj4Gem2HoxLVaZJuE2o2PgasPyo58e7ABHr6BGxu0UzSwvZH0Av8P9SUgRZvfxGg6cmoR4dVZItBJv2oj2jMQnzqJSEX3BPkxz8tHuEttnPxas9yaMCVnI69JUwS6kCzKiD+eEgL2O5BUdKi5FRNp76NFn58bZOhfb7FURVd7mIO3a60UVSZV0OktmAuuz3lToLVgwuOH+a0D5/9ZPK6ZGnGgydCZEWBsYIq1immTq9y0/z2O2qePZW0otOyneLJg17P89J57ikKl5Zf19lXyOQnkf5CugnwkrYcmGOS6pMwCmkqxQam+ztT1HaaouyY6om9JmXZ2P5GAQXbfH7JNbYxb/oPJAxZC2YREa4IxhMIWulpLs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUd1cGZicFhkTVMzNTlkdDhuY3pHU0pXV2lDSzhQbHJsUzV3RFBNWjlMVkRI?=
 =?utf-8?B?RkxGNCtUOGhldUdocTdEeEJPeTgzZ0R2YTNzYmRTcVJUaGxDRmdqcnVxVzJS?=
 =?utf-8?B?amRMNDdLWmF6by9hNE9ocE9ZWWJQY2h3eWh6OVMvVmhFdFhDc3Y0ckRLU1Z5?=
 =?utf-8?B?UkljL2s3N014VGdWVE1LNTRZRFJYcXAxZjBuamlLTXJCZHhQbWRPMkhLY0tz?=
 =?utf-8?B?ajVzVkhvSWFuN1JYN09rNkdhbDFuSk9GQXNYaGQzUGFhNjg3ZmZtQ25HNjBm?=
 =?utf-8?B?bGlNS1JWSG1xRlRYWUljUEN1bUJkNmFJaFE3RThJS2s0Y0wyVHljSmZuRWhH?=
 =?utf-8?B?bWpBeDBhNjZUU1BWNW1qdVZKYkk1bll3cENyVlI2bUVBZU9UWENZYWlYb0dY?=
 =?utf-8?B?MVNRUjhVQ1JDaTBNRld6Q1NoLzJ5Sk12WDVRTjFPb3cvbkR1alQwWGxRQzZQ?=
 =?utf-8?B?WEhrbHFTcWx5eTFGbStWNjhvNjQ3VzFuTUszVWNRMG0wcG5OL2pXVjBTVlBr?=
 =?utf-8?B?djFzTDJIWTFrNVVsb09LWjRBdC96djkxNmJ0ZllOT2FTbjZYYUVTWjFPd0M2?=
 =?utf-8?B?UTluNlVlUVVtMW9icmRiOXpZV1Q0WmlJTEVWaWJuOWxFeXJkVXRaUGZGSTBI?=
 =?utf-8?B?NkRZaWcrSDJGOC92dlg5eHJDR3N2Q09MMWd3cEdoT2djZE9ISkdjNXlaQ0U0?=
 =?utf-8?B?dTM1N3p5b3ZZRGNKNnBWcFdXWFREb25tYTlOZGNobkFRVFJuc2xzaXI1cGwz?=
 =?utf-8?B?bThNU3Arb1dhNGpxL3F2OVYxbXdZVm9PRlprNEpSMXFEN3ZwZGdiZi9YKzIr?=
 =?utf-8?B?L3B0dTUvcGZzL1dCcWJBODg2emp2bFVPSDg2eDRiRXVMbEVrT3g5Y3NQQmI0?=
 =?utf-8?B?WFphKzA1TnZEZnFIdm1QVVEvUG5GZ2ErUkdqT1NTSkIwaUNENmJFOEpveFZ2?=
 =?utf-8?B?ZWxvSGt4R0lSTjBrS2dEdVFrQThNNHQ5WDkzZWpibS9rcW1lcEFQRHRFOEZM?=
 =?utf-8?B?TG10eVlYd3Nhb2crV0NlOCt2ZnY4OFRsbGVQZmV3N2JNaUxwZXQ3TzMzSEF4?=
 =?utf-8?B?ZHJKZ0lnd2xFSHdXYitMQ2tNODQ2d2Nwanplci9rVWc0cDlkNjFubDFmVTN0?=
 =?utf-8?B?b3lTK2JKem53RndFbnJIMS9wMGVBeTJkWnd1YW9LaHpramRvaW83blVGSFYy?=
 =?utf-8?B?dXFvNlhWanM5N3NJZ1ZVd1dyQ0FWbExhYXN1THFISUN4aDlUSXNKYjdpckVq?=
 =?utf-8?B?RXNBVkNieDdMR1czTmFURUZoZVlNSFRpb3RPUXJkcEExQ0tlaFZOSFIwZDEy?=
 =?utf-8?B?ZUpHQzd5L0RJTm9NTHRvR2w5TVI5aVRlZ2diUHVaNE52L3FRWHMvSmZQWlh5?=
 =?utf-8?B?Y2hSaU44WTI2emJQMGl5YTA4TElqRkl2dGhzMXgzZEJYanhtLy9pdjhKanZC?=
 =?utf-8?B?THdvb0YwU1pQSFJoOUIycEZXZm1TdnRyNGJubWVQTURVZm55aXhNOWR3L2Jp?=
 =?utf-8?B?eHRBVFFSU21ka2kzb215dlFsM0RaNkY3S01DR3YzcVZ4YmJMNlJRYXlmMDRs?=
 =?utf-8?B?U09MRExIMkRMZEMrMUpSamlBUnpQZlk2cVdtN0x6VGtsUnAvQS9jVit2eUZW?=
 =?utf-8?B?eXBRcHE3MEtjQXlKVFBGT0xqSmpPdzA4aXNhamtuVTF5ejFIRHNyc3ZqczJp?=
 =?utf-8?B?eGhXbXh1MW82YjZKSjJTQzdvclBGS3ptMXVaQ2hJZWxrQnVoamo0dUZiVXpO?=
 =?utf-8?B?MS9MWE1leVVPNmlqeFF2S3lXV2RoN0huSnVYTit5VEF4c2NUU1QzQnZrRnhO?=
 =?utf-8?B?UGZRM1dhUEVBSFpBbENKdVUrMG5XMFdiZDNKYzhNL0tsNFVVQmVwY1N0cFJ0?=
 =?utf-8?B?d2VSSkFTeU5idnczZktNOHpKcmZvVEFPUTVqQ2V2Q3NPWFhmTmVwRFhMZU9y?=
 =?utf-8?B?em1zTTZDTjBSbGVFYzVTTUpBK0cvMnZGSkJZZlMwVnZNd1pDeVZrSGltUEZi?=
 =?utf-8?B?TUUzRnhiS0xjVXpVZ3RLMTBqb0lOSmN5ekIwTGNEaUJOSWl5TzF5RmlwKzBN?=
 =?utf-8?B?aHVxaDNYenErT050Wm5pUnppK05xTG9WeGpnSmpkb3hXdC9DRmRvdmp5a0ZH?=
 =?utf-8?B?V1FLMGVKNEdXcnBreXg4cUFla1BlcW1ZUDZ5bXNhN1MzQlNQNVJTOHVrRG9T?=
 =?utf-8?B?MCtIMk1BeUxtQjBjNU4zZWV1SUdFZUMrWXhDK25uRnRzRlBWdnI1cmJTUVdU?=
 =?utf-8?B?NjBVQXJQMHpsRFJJVVJtRjVZS1A4cVJlbWxXNlRKd1ZvdFpieFF0cTkzYUlP?=
 =?utf-8?B?N1hFTmNxeHA3NG1RQTBpUXNxa25UN3I3Ri8wM2hhWmZqR1NiSkVDQT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b7afdb-2fea-4451-2e21-08df2ab16ce5
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 11:42:43.6219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGRj4cRm3Cok5vl/qOJ/OTofUQdt+1axLmeP4f7LHo6jjbBPi3N9KLGorpxe6oOpyOQLN+TqAYxoow+d0vUpVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7659

On 10/14/26 22:50, Andrew Morton wrote:
> On Wed, 14 Oct 2026 16:54:36 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:
> 
>> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
>> per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not it
>> ever charges an object to those shrinkers. Every superblock registers
>> such a shrinker, so the cost is
>>
>>   memory cgroups x NUMA nodes x shrinker_nr_max / 64 x 1 KiB
>>
>> because the unit is 520 bytes and comes from kmalloc-1k.
> 
> So we could almost halve this just by using a dedicated kmem_cache?

Yeap, a dedicated cache gets approximately the same cost per shrinker id.
On a 48-CPU box SLUB puts 31 units in an order-2 slab, about 528 bytes each:

                                      ids/unit  bytes/unit  bytes/id
    today, kmalloc-1k                    64        1024        16
    patch 1, kmalloc-512                 63         512       ~8.1
    dedicated cache                      64        ~528       ~8.3
    dedicated cache, HWCACHE_ALIGN       64         576        9

So the two are ~equal on memory, and the choice is about the code.

I went with 63 ids per unit because the unit then simply fills the
kmalloc slot it already comes from.

The price is an odd SHRINKER_UNIT_BITS and roundup() instead of round_up(),
plus the static_assert.

If you prefer the cache, I'm happy to redo patch 1 that way.
Patch 2 does not care about the unit size.

--
Best regards,
Konstantin

