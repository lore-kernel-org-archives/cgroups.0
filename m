Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023085.outbound.protection.outlook.com [52.101.72.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BA95477E;
	Wed, 14 Oct 2026 13:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983910; cv=fail; b=LWynN8b+BtL91S/dVM3sblB/YDOkX0mgh76Ia4FxDRX49T/lamKy90uK0hwhlNhveGa3Ec0zKU+fhhMh8C9mWABfq/3oFwCFg5tgtCKJqHT+DOKLof5gsEj+SXSbHJHmq7NI+JEfUpTtwImOEYuXfqVVPBjRNDpUYy4CF20s3uI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983910; c=relaxed/simple;
	bh=42lVt2MIds8yKfySSWMIFQ7rGrYp4D/1wUfZOdHPD18=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RHyN8vjXZXy34J8omb9SK/iZT/vW0oMAKFoaaKapayAjLD8kdqCrh85lSE1seihRF4OS4i4ZmeGDelp8/I3IBQt1Gjdc20SJ4QdCmaTubOsbaMQV8rluWbYaUNiHqv0T0SV7o6bJL9L/R/yK/8Mtv9VRGRS8YJ02YU9dPjPufvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=tNGgUaNc; arc=fail smtp.client-ip=52.101.72.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="tNGgUaNc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jTc90a+SfTE4fgUT8ZUWSGtOvjWo6kTZTSbKvga7UwEuIGLl+Oj2aYNA1v4PIxeSqfaV942PU5elRFyWV+IR89obXvdUgufD6prdAN1gO3SiuiXuaOy7HD/RQ2yi4AWg7ezbqJWbwaJjHG0afCxBO6ahLBF4e5N4Ye0TMaW3YNz9gn6tCoUGjNuCvAdUyQz+IMgD47WC7/HrOy8YqhFVKAvCQr2it7C6sauayeSXjppT+6gVrqvXvelUvLJ88B3q6AHqOQRPkm7qia34lenS7/Js7nVjfig+nD1Qb8P2LwPY4RwDjzqZFyq/NJsgDm/15AiQN6nML3C16EJxTFXodw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16I7Gnlehp4rtQgca/20zMUSGtwWYLFnOQWH6uyrbAo=;
 b=Ba6Zf4CiMZpns1FN15TxR0mIsi88xFxwWUFw4zAPED987/tsCHMnDwCych3uRKkHdNqtLjNiuDAIzbTKblAElnSHTNgiP5rif4pCVLBBWAIG7q14CMn9DYxMdP2GnZ/g5Gep4plZTGDoo9U7jkQfKqNJtiTnne8SX3fwE5TUFRPaYrYI19V+t1CLO6ocv+uQ8ukMh74Aw0Qv5nHwarHEGfm30YjV/7nY7AIzjgnTjtZanUkChsHbP2geLwBVacGCR84pQBGzZHBvGyGGfMNPJGsV8h8nSa0kNHHpzv988cbIljSh5H3RginvjKpvhsHX5Nc58IaBCjHZnrr2cFTGUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16I7Gnlehp4rtQgca/20zMUSGtwWYLFnOQWH6uyrbAo=;
 b=tNGgUaNc8W8e/opjNd7hcls6GHD51/YFuSckYVQVMfIrpskhTUOvwO/Ek5TvhEXoSf1d6yyJeoPmaxQU3GXoUl4x/Y1KYiU77IMvOtWdtK49DvNbsaE4lPMO+Ww0Ul8Z7eB9ixT3NN0b2zeEge+G59Ui1D/XcKcVdnNKcNleKP7M+kCVn3BwFjAVy1hDsQ+TvRmtCiAsBmo0CY+JKgiHt6R0ULDw8OMAtAo0dF+9xwkhoqu2mzFDHmzAlMjP3IOuZZ+zcZzKXCHDk38xSO16ai4wF+TGdwYpvhncCltFR7EVhHciwtCrhVGiP7lUuaIJDFTvZ4jGPcVkVrz/6W8AiQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by ZR6PR08MB999901.eurprd08.prod.outlook.com
 (2603:10a6:910:d2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.11; Wed, 14 Oct
 2026 13:18:26 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 13:18:26 +0000
Message-ID: <723a480e-1aa2-4e06-a5b5-38948a8b50d5@virtuozzo.com>
Date: Wed, 14 Oct 2026 15:18:24 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shrinker: size shrinker_info_unit to a power of
 two
To: Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
 <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
 <c2d25c25-2fd4-4bb5-a021-3cdf23e493d0@linux.dev>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <c2d25c25-2fd4-4bb5-a021-3cdf23e493d0@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0047.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::14) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|ZR6PR08MB999901:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b3de81-b7a5-440e-168a-08df29f5a192
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	pQllWE4gLaAXpvliRIi+a+F7fbSEniOMDYEC6Fpn9/HaJo67NziN6vnqZ/u4lNEMUeyBaqQYTf5EkvYYCb9kXFOUaIS79S0ZCdzpJMpcADnt+BJpV/B0O+Emfa+Yv7AZT0MxaeT7CCdNQeT+uDDaykohk4SZgoNtrj8IRvNHJ4LhJSiEcRaqZW8QcTPmdcpuQdBI0Fgu/KKhiqbjUmUonMR+0nX0R/RroiT0UpfsrXMaSfgqhBd9QwikTCjCqcG+2kXBg6mkPKGcEDhYMRnwnrLqOZrMMJZKszfDLYYonnfJjekekWjzlUtsDnDDb9w1bdXfYddU34b0oEP1qKUQc31aa9D2k+IbLP+FCJasBDkF1aD1WndTc7IdPo3YAJ28ueeuEoUnCyyhlEHY5zAa5zIZs2Gv24mngE9+0F+z2Lyl1YZzWmvMyoa0t0U9MNAF1YLpBrCB3Bgmlkz92s8RtT/7w3LPyjyWKlbA85PYCcnDZlU62PjA7EtdbslW/1Jnro2LjDsbZI2On0WZvqcStmmq1pFtTMxMIkrLmcNbl5cF/gPt0WApueQGvgTdAMdO63bZo4mttk9RTmHMzuJdpA7ELlCDwwgEfQsY+J3Z4PxrkUpWyG1uaAZq76A6hCwb10FgZW6QZRZ2ydva3suRSACxucR662MA5T3GSU08Mto=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWQvRGwyZEV3TVJVMnFrS0h3MFlWZ1VieGxsY0VpK0VnVE5GcFFXQ1NpRldm?=
 =?utf-8?B?ckVoQTVYZVRielcrbDRDcHhBYlV2NXd3cUpmd1ZHcUVZQTNtME95M0hILzQ1?=
 =?utf-8?B?cFROMnZ5Z1F6ZDErU3BWTEFrMnVjQzFxVEd4MUtPamN1bHFIVW9EKzJQcmUz?=
 =?utf-8?B?djF4QnQvTXFqamx2Z0pBbkM2Z2xDQURaTUREY1gxY0pXbFdmREVYSE9TT3Az?=
 =?utf-8?B?VVFNdkNqRFJkU2xNUDRvOXR6cVVwcVdhNTJGSnZZaEhGRHhvQVpYTWowMGNO?=
 =?utf-8?B?WUJwYUZHV1J1TTNRT0pNQzJxUDczRkM1VU1Ga2ZHYnA4eENZK3E0bmc0QkxJ?=
 =?utf-8?B?aERrUFB4Vm9yZnRhQmgvczkyZTQ0L2NoTnZ6TDVCRmpGaGNDdDNJOEdJSHM3?=
 =?utf-8?B?TlFvY0pVWFJFOFFHd1F5RE5vdU9GU1NJb1FlajJuYWRPWGkwdXR2VnlZN2ZK?=
 =?utf-8?B?eHBxWGJEKy9xWCtxYlFwSDhuT1pteWNBclJjZkRMOVUwTjNxNzhWR2pUeTMw?=
 =?utf-8?B?Ri93K09QQUtDK2YvUWdKdFVkTzFINk1aSVVrMG9DYzUvRCt1NS9BUy9tRTdS?=
 =?utf-8?B?Q1JPZDVFZno1MG5RVWtCMjBUUkdNbDBmeGk4enk5UjdDVXBFemlUbXJPdWR3?=
 =?utf-8?B?VjdMbFR1QVZOcFNZL3NPQkptbFpiMThFWEQ5WGE4dVhaZmFrWFFVMmZGTVRG?=
 =?utf-8?B?S2x6b2xwUkVEZHpZdEx5RXRFSmNya2ZLTS9uYTYxT0IxNlFsV0ZnQ295RGta?=
 =?utf-8?B?VExPVmFsd2N0OVB2RnpxMko4ck9SNkFTN0ZOU203T2JORUZJRGkzbGR0bGhj?=
 =?utf-8?B?TThENHZONkh5MktNZlBQNWhRTW94OHMrUXZvQldBazFjMUlpZFRoYUtVM0lG?=
 =?utf-8?B?VHpERno0bGRYU3daQld0MUdZTHdFUWJaUWFUeWdmaUx1RFZyb0ZZMTVXdmFq?=
 =?utf-8?B?V2lJUGV6TW52MXNQbDUvQlczWFhteEhuSzdIaVpuWHRoUUF5akx4RjVRRFEz?=
 =?utf-8?B?NHhaM0svc0YrRnB2bWlVSUhVTHN6VEF3bDVvSkRVTjFKUGduWWFUVkJNamhF?=
 =?utf-8?B?bEs2cjNXZERZV01Ya0dXZVMvcFpkR1ZUTHg0WEFUZGM3NGpOWkZPVDVtQkNj?=
 =?utf-8?B?bUwwbXRXdVQyd3FMV21hSStGVXBGNlpGb2p2Q0RtaEc1Kzl0NEVnZ0RYbmNi?=
 =?utf-8?B?ZGJvU05RMVFsWXk1bys2Uys4V3pCMjdVb1Fvd09FanJGQWc5eXRqYzZOZ2M1?=
 =?utf-8?B?dDFnOWJETjBBZ0xWb2Y2VDlERWdWTGdVc002ai82TG1ocXV4YTNLc3VhUFFO?=
 =?utf-8?B?RGVlMUg5bmdseklOd1p6WENwMU1NNHZmUldGZDluQjNZNUI2Ym1FTlU2Mmdw?=
 =?utf-8?B?czBvT2R0ZmRCaGxkUUxiaDR3L0NpdzFhWmFjaWlHOVVQYktkOFNIbS9CcnFn?=
 =?utf-8?B?ZmxwZ1RScEFnT1Z3YklQQU1YcTFoUUw2eVNLeE1lZmZnTFNzWTVXNlF6K04z?=
 =?utf-8?B?bkV2QnpHZURQZjFsMDVIaHlaMkFiMnRDVHNiQml5V2U3WHhYNjd2all5UXRr?=
 =?utf-8?B?MGo4d3BmR252QzIzMmNLdjJ6Mk83UFhVRWtaM0tOaXVWTERrWTB0ZVkrUjVj?=
 =?utf-8?B?TCtXUi9tSDQ5YVVMUmNRSDIvQ1YrTjl5MVlhaVRpVlVhT1ZTRVQ1Ry9CWFJR?=
 =?utf-8?B?NjF3WThCaVlTdnduc3BidndUWTBxeW5UU2p5Sys0YU4xbHhyQlR6dnFvMWNI?=
 =?utf-8?B?UWNUcGoxcW9PTnhVMmtMZERYMkIwbWdDMDA5VnB6c1N2YVk1UTBaS1lUSktu?=
 =?utf-8?B?UDhPKzB0dDR5VlkyMzI0Q1ZEZW5WRlhad2Q2WlZKeU1Ra2txSCtXL1BCSW5Q?=
 =?utf-8?B?WmtLdU1FMUFzUnBYMEo1R1pYdElUd0dpTHVMMkV3djEra3ZHdXRpN2V2dlBj?=
 =?utf-8?B?KzZxQ0lnVE1BS3hVU3Q0bmo3dkJuK1lpQW56bVFhM2JBdnhmSWhhc0hDUDF4?=
 =?utf-8?B?b2pzTWRoaWtpeU1BbXgreHN6alMyMThzbGFRL2d2RVhZcTlYZy9QYm9CMEw2?=
 =?utf-8?B?ZXlRdTVLYzc5eThieElXdFpCRjZMS2FjR1JEQjVoL2Q1bDRNaTAzQ0k1YzNG?=
 =?utf-8?B?dk10eUxyeHk1RnpNSHpEOWs3b2s4ckxIdytBQTJSK2g5MjBhNUFKYmhxbEox?=
 =?utf-8?B?NHdMZzNtWFg2TW15VEFlSTBNRWRXZk9iNGhSdEpKSkFaRzNMYXBzcHA1cXBu?=
 =?utf-8?B?dW95NVNMWVcrTUhXTnhUZGpETFZINU15QkQ0My9RQVNaZmkyVE1xQVNob3hj?=
 =?utf-8?B?SVBQZFhva2QwaTJRZnZ2Q3c4MWZCL1JWeGY0UjQ0RDBqaTZxa2ZjUT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b3de81-b7a5-440e-168a-08df29f5a192
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:18:26.5401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RaWC/HV9vAgkUAzO+oR8MNHWtjWAFknPTscIbtD/F2AaR9iquHyGB4pR4YEuie0C8BU+OhziDPEOmtfCjMLhXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR08MB999901

On 10/13/26 04:52, Qi Zheng wrote:
> On 10/13/26 3:02 AM, Konstantin Khorenko wrote:
>> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
>> for every SHRINKER_UNIT_BITS shrinker ids up to shrinker_nr_max. The
>> unit holds BITS_PER_LONG atomic_long_t of deferred work, a power of
>> two, plus the one-word bitmap of shrinkers with objects charged to the
>> cgroup. That word takes the unit just past the power of two, to 520
>> bytes on 64-bit, so every unit comes from kmalloc-1k and almost half of
>> it is padding.
>>
>> The units are allocated when the cgroup goes online and freed when it is
>> freed, so a dying cgroup keeps them until the last reference to it is
>> gone. Their number is the number of memory cgroups, times the NUMA
>> nodes, times shrinker_nr_max / SHRINKER_UNIT_BITS. shrinker_nr_max is
>> the peak number of memcg-aware shrinkers registered at once, and every
>> superblock registers one, so a host that mounts many filesystems and
>> runs many cgroups carries the padding as unreclaimable slab, and keeps
>> paying it for new cgroups after the mounts are gone.
>>
>> Let a unit cover one id less than a word holds. The bitmap still fits
>> one word, and nr_deferred[] plus that word add up to BITS_PER_LONG
>> longs, so the unit fills a power-of-two kmalloc slot exactly and, on
>> 64-bit, the memory taken by units halves, for about one unit more in
>> BITS_PER_LONG.
>> round_up() in expand_shrinker_info() needs a power-of-two step and
>> becomes roundup(); the other uses of SHRINKER_UNIT_BITS are divisions,
>> modulos and multiplications that do not care. Assert the unit size at
>> build time, since the layout depends on it.
>>
>> Assisted-by: LLM
>> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
>> ---
<skipped>

> 
> Acked-by: Qi Zheng <qi.zheng@linux.dev>

Qi, thank you for the review!

> 
> Thanks,
> Qi
> 
> 
> 

