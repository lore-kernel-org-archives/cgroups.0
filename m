Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.94
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792514742;
	b=Rd8Jx8NIHh5VSFnSs2yf4oGNWPHfZUhngzQ9kG4uhQ4eAm+pelZvh7VRzhnLpz+tnrrZ
	 eZ4ckAwY7XegSXTLzNy9Aat8VlSJvfTROw+SICw3QBmgP3QseVmxOiVQRO6g8YI18fb9n
	 oFEjw6tU1flSGjYKOk5hFcysvM2bFqM4yjsacTeYRcag1mi573Ey8CefxpIB+CvrkXZv9
	 vpMpuO9Snwp72NE9KUIfQ61Vv//J8X7TH9Y3LxIoH8ZangfjAQ06yA0N8/HJPZs+D/em4
	 uI9mxbFbiTuSThOQISO4jBWXCRqpSUWyGs01Muy8pI3/uU2V+kaJcrZFj481QYsaekw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514742;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=CaC1tbqlhAutnDuJlc4cbz63VLGiulIGGi5uK1XKrF8=;
	b=WOAxbORJiLyBKhlbApyXWu9J6bqyNgQ+lw4Sb72T2FBrSGWdqCtrwOhHIB0hWx6X0Kkv
	 f/MKZJWa/f9RdVQrK4tXtg040dtIqk6JmBuBoa285/sJ/NvKr8kr4Rc9xx+YCaawihSyK
	 BYeDnjAPKsXOmRIVe5zidcELErhjIN8JNAc4kdoy7X6LnXQxuoqWQhi4EOEuDq7JOTfWw
	 EAw9NOEIYsX0mIMSbHgBSvVIzIu1u910lgwJCU1JDzXxKM75aHOdjT2CtxIiQMLWVbwnu
	 ywJUe1E8gFwS0EeyLd9fQG5cL1kI6OAbOlHwIonyOieQh/kCVnYiw1IqJbQEtXyiZnA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=s5iDtaWo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.94
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022094.outbound.protection.outlook.com [52.101.66.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B5D606D554;
	Tue, 20 Oct 2026 16:45:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9B5D606D554
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=s5iDtaWo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H82w0IBKM9XVxH42tYwUmRLnwGpaWTxRB1LPvcUtVFDxuZLjWnooyrXflmNAaAByxRJU+ZlhHNu3zSIm/pbZzNtunxIou14/LaT/cic6aqJEi8Bwr+F/wpRAAb8+faeWtTa9Y3K3kl3xJ2GlrkZHSC+pGXYw9B4YgJAjd2InIo475MctvLBsIVdjadCeI0WxQBW79xzesZx/fqeAReI+l560M6k46zr04DHSN0+T8RXaUzdcU0wWGJ0RWdV6YGYFL0tOao4lsBUXAgKuAAw6uPKserH8szs+SFZDQVmW4Cl2r76jdZlf9XpaM7kOxhn1LNzvNiQJk2xhWvjhUMpvjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CaC1tbqlhAutnDuJlc4cbz63VLGiulIGGi5uK1XKrF8=;
 b=xdgOmGnSpVGDzTbZaNp1dV5laUjZPKCmrS6x35JmFiLWVMo45WOtc3H8hBzYkuXtqs7/rTsFedaEMUiPMZsGv2V29Xn15wcKh55TRQyUI9yJCFiH6RlV191b/Wvk4V22mcLWw/cmapdQOLnIYZEmfK/8VJWRUARpbbWhdetQFEqA1Cv3HKNPl5AzKWtV4BTinlf/IAeIQTymIebr0qIq/uLdUwSWMlRYZcIMhtzCA3mK810/bHtehFfXqs4KGLdnZY6ABpFo3214lUPZYABoUptA/RbqGsQMtmt17DuT4uC7y13AEWsfRAemJ7kn48DKRsWSW3Aazzh45AXGiA+yHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CaC1tbqlhAutnDuJlc4cbz63VLGiulIGGi5uK1XKrF8=;
 b=s5iDtaWodrpcZDyRG23CFAJeIn/j6uMLuH/cowoa3V1u5k2CM1CRnlaQjipX/5CXiwbiBXUedsOQbaqlnXhKNAJcb81KJ9SivDW0UcscKu2wMsBH3kRChTn43inyE3Dmfs2vK5LXb1InIH/OZPAHDt4axFwe4ZryR5SYmBR59MCgpmdfpeRLAxQTKeSHKnViQRpPphZP4PhFlqq1+Sy9gPAPejlWf117j16+wHoBj4gj0yZv350XiKtSUtn8Nd0S6B37LW34+Gtum1qGmSLpV4A70z9yslL0SyLuDxyprbC4ER7nYGnvc1Kq5b6EJ+sapFEVYtOpx/kQ0dwxXEyrHA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by AS8PR08MB10027.eurprd08.prod.outlook.com
 (2603:10a6:20b:63b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Tue, 20 Oct
 2026 16:45:38 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0546.012; Tue, 20 Oct 2026
 16:45:38 +0000
Message-ID: <f0fd6ac7-0cf6-4456-8f6c-0620c3d9fbf4@virtuozzo.com>
Date: Tue, 20 Oct 2026 18:45:36 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/shrinker: per-memcg shrinker units in an xarray,
 allocated on demand
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com>
 <atZeVV-uZMaLL_Id@thinkstation>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <atZeVV-uZMaLL_Id@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P192CA0027.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::17) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
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
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|AS8PR08MB10027:EE_
X-MS-Office365-Filtering-Correlation-Id: 355448b9-60de-4386-44c5-08df2ec991b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|6133799003|22082099003|18002099003|10067099003|5023799004|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	VKCY8Dex3boUIbXLCZRZZOz56qDJURWMlMU5jacr2OppkBV6LkEQzocSWd1NBVQEA3hINH98xb4VvVNRB2T66z1GZgDr0J1O17SI8VxpI3MAf6E3AFGVcE2YzLyIzrqiZjt72AJa8PZ/6/Oi5VEh78KFYVf22/Jq2lKHJXPL1ZPdpevoaYFkPYecM9wPqUsh4A//ZBcwugyythmjfqvu2sCXo3Of3Vrd4qcnBLcvL/VKLPrjIs6QkfHWC+d2KfV42ug5NWkQu5Q3N0edmmZzf5Y8g66vJyyhsGP9g7g+dUuVLzUm8YpuXlfmNFudSANVrAJ+ZFJX22zhIydt5UVPvCehtxh129P9ICBkIFq/lDEUAaKOxRK/XDCkFU3qovttojxtf9HzcaqvlC7ueeNDKcWJkx8/NwBpmcDbVMCNZb9TjJ/VT1/73yNbW06Tw66PHn/4rZRI3rE1S+Mu9H3KnKLt0xPQad9LmGA+b9lkVLtSi7Z6UbsRwPSOGFpZGcsUIdJGRStGqRX50Q1fbsMI6KONuCqLbW8t1Z7OGqrsNTALx4FKmviTJKMUONmmV300nulAMMhOQrbeUklv2Jx2focCSfxqKhSTfVVIuIjDyl+/+yl9FqbrcQZP+N0a/vki
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(10067099003)(5023799004)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUIzdGpwSGVKMDRVRUxFaVFDcHRTS2tLY04xMmtacjRUbnlJU0dOZHBJS0tT?=
 =?utf-8?B?ODFWUVVMSUh1UXhFdkhrbGhlNlJCVEJqaW5tZE1maGIvQW1jcFQ4bFFhd0lL?=
 =?utf-8?B?M0Fma1FWL2NkV1RQa2lLcTVGbkRHVk9RQjhqbzlOcHd2Mk0zSjBBeWJqTURO?=
 =?utf-8?B?MldET0FKV2llNlRSOHdMUk4xVjNzZSt0QlBIZzF0Rk4zU3lQcjJrUlRwd1VQ?=
 =?utf-8?B?bjQrMEY3amhFcElWdU5FU3ZheFBRT0RyZGh0REdBVS9lYTZKTlN2TThHeHJL?=
 =?utf-8?B?d2x3N1VLYmwrR2dLdytkeTdZRXVCTjNEV3llTGlFWDBIYnZiMVQ3em5KL1dk?=
 =?utf-8?B?Wk5kZDJiQ1dZS0ZvYU03V05kQTJNd1dxMXZuU2FYUm5sYWFNNlVBMUs1M04z?=
 =?utf-8?B?UFQ0a3oxeFhOeXJXdGdidFF0TDVjNkJNbVkzbStra0hwS2VJdHlKVGt4Ym5M?=
 =?utf-8?B?a0FpbC9lcXVDK3JWMlUxQnVmVUx1TjFwa0VpNWl2RWIycm1haTcrZ1JnMHlm?=
 =?utf-8?B?YlIzVENMODZab213bk1tVFo4K3plRTczbjhNLzZ0S0c4bUdOZEhZQU5jdk85?=
 =?utf-8?B?L3E0OWsveC8yd2RGOFFtbi9rbCtYVG5iazhtWXEvN2p1L3RlMHQ4ckt3bWIr?=
 =?utf-8?B?b3BIMGZTeTVaOXVmN0dkTHNzVDMxT1RWL2tRWFc1NFZGRU1mZ044MTVLditk?=
 =?utf-8?B?MUUyZU00K2c4SVl0RDdhd2s2eDNHN2VoS1FJV0QxR1lPbGpYSjN5d2JPajBn?=
 =?utf-8?B?S1RaM3ZIZGFIMkQ2Z0xJQUJBN3RQc0hNWjB0NmFDWkxEVjUrZDFjUWtWNDRz?=
 =?utf-8?B?d3A2YnpWZEptQlFuODdpU0ZEaVBJaXVRb25BNmpOSUw0WEJLaS85R04ralha?=
 =?utf-8?B?TExSQ2dBclU4bjY4MG0xQ3FRRml5eUdiNHVyYWhYSzZBQ2YwcXlTOExDcXEz?=
 =?utf-8?B?MEt4Z2lBcDk1NUVWUlFHaFAycE5hZXZCOTk1Uk5TWloycVA3aEprNTlhR3ZV?=
 =?utf-8?B?S0pQYWR5ZVJyb1Q0L1dWZTIrcHZnWWpDcmVWeEpqZzhFaXZOempNd3ZXM2kw?=
 =?utf-8?B?N0FsNHhBNGNtSytaNlAzdGpNWHlFd2NCVzhHdmE4USs5S3BwR2ZnaU5ndUg5?=
 =?utf-8?B?NzVYMVZyeTJxR2hKbG5zUXBIWEEzUGdZM2ZCdWhrcENUVzJSOTlwWkRpbHdP?=
 =?utf-8?B?SllWTlk1Z1NuNjVrNVhVOGNjT3ZLUm9rUmpRNlhHSjlyS0EreStGUnozeXNQ?=
 =?utf-8?B?RnJJcU9YbzRZcXN3cVpWT2E5UGlkemtkQU80Wnp3ZWplTHl3dUUrMlplRWhP?=
 =?utf-8?B?enJLckN5S1ZaNk1raGxVL0NpNndOREZobFBkc0RoNGVMSXJXT010blhFbjM0?=
 =?utf-8?B?WWd0ZGpCUmUzYmw3ZmtTUGN4aytMRUpoQlJvZVpBZEwzMDZoSnl3akZLQmRh?=
 =?utf-8?B?NG9Rc1lDNVVObGFiNzNXZEcvWjdhNlFoVGFYaXJnSnVDODBROGpzbCtHWkc4?=
 =?utf-8?B?WDFEalo4WGo5bEQ0cDJiQWtCTE0yUUl1Tm1WUjUzWUQ3Z2tKTVBNN2JIbzJK?=
 =?utf-8?B?WEx6TFBNVnNjbStEYldFR3NYNXVWbENWeUYxMlMvSTVjUDNjZ2wxR2FHOFVs?=
 =?utf-8?B?VFBGUzNDRnowb2pud1NGQzcxbWdUK0Z0VFFTTlhsbFNOOUFLMm5uOURNbjNE?=
 =?utf-8?B?Q1MzbFlSYjBNVzlDRmtPTVl4L0t3V2MyTVhxalhmTkJiNjl0eWI1R05Xd0Za?=
 =?utf-8?B?TTdXdzlZUitLREZVbDhQbS80TUFUdmdMN1RTekhHTzNsc0duWGJDQjlidHU1?=
 =?utf-8?B?ck8vSlNtK2Z4M1FjNmY0RmxoRW00TXNWUk01bUxDc1Izd1ZvYUd0UW5EUFh2?=
 =?utf-8?B?Z0lDSFhFNGRiN09WS1I2T1BLeDZpbGkyc083eU85ZUh0TmRzNCswdXZJemxQ?=
 =?utf-8?B?c0creWxrUlYyQVo1d1dFK3VyY2JZeWtza29TbjV1UHZ2TzdiK2x2bEw4c21U?=
 =?utf-8?B?OFRzUERuakNGL1RPOVA1Q3hIK1doRkFQa0J2Y1lQZlBZbzlXRFBMSEMrVEND?=
 =?utf-8?B?NE13bTg5LzZVVDZRMkdKeWd5ckhqTUxTWTEvcUJGK3RaRzU2ZkRvMjlRckdk?=
 =?utf-8?B?WkpWRHhOQlZFT1ZqVWhPQXEwbG84QjJSeCtLKzcvM08wQmZKU3Jxbk1nSnNw?=
 =?utf-8?B?RGt6MHZldkhGT3QzRWt5S2NrcDl3Tk4xYk9yT091amovUUZDL2pROFZSSCtz?=
 =?utf-8?B?bFh1YWJTMVpNOWhWYnpoZ1dWUlRJVktMOUFXTm1ZWnlUb0lFZVZXeDgwLyt0?=
 =?utf-8?B?b3JJUGgwK0VSRnQvNTNPNUpaWG4wU2hFaHpVT1R3dWxQRXJQSHd6UT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 355448b9-60de-4386-44c5-08df2ec991b1
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 16:45:37.9622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5MZzHb0+ruYPf6XDKZoi6wUGUBIpMCFZgg7brKbA7MdfOlSdE8P4YEZ46O24CU/li6zmaSkD8yHP4H6uUHR/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10027

On 10/19/26 20:32, Harry Yoo wrote:
> On Mon, Oct 19, 2026 at 07:39:22PM +0200, Konstantin Khorenko wrote:
>> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
>> per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not
>> it ever charges an object to those shrinkers, plus a pointer array
>> sized for shrinker_nr_max. Every superblock registers such a shrinker,
>> and shrinker_nr_max never comes down, so a host that mounts many
>> filesystems and runs many cgroups pays for every superblock in every
>> cgroup, live or dying, and keeps paying for new cgroups after the
>> mounts are gone.
>>
>> This replaces patch 2/2 of v2, "mm/shrinker: allocate the per-memcg
>> shrinker units on demand", with the xarray variant discussed in that
>> thread. It applies on top of "mm/shrinker: allocate shrinker_info_unit
>> from a dedicated kmem_cache", patch 1/2 of v2 sent on its own as v3:
>> https://patch.msgid.link/20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com
>>
>> Patch 1 keeps the units in an xarray per memcg and node instead of the
>> pointer array. A new unit is inserted where it belongs: nothing is
>> reallocated, copied or published under RCU when shrinker_nr_max grows,
>> and the readers find a unit with xa_load() or walk the present ones
>> with xa_for_each(). The units are still allocated up front, so this
>> patch changes no behaviour.
>>
>> Patch 2 allocates a unit only when the cgroup gets a list on that
>> shrinker's list_lru, which is where map bits are set: a cgroup pays for
>> the shrinkers it holds objects of, not for every superblock on the
>> host. The install is an xarray insert with the gfp of the list
>> allocation; there is no array to race with, so no lock of its own.
>> The root memcg keeps its units for the deferred work of global reclaim
>> and is the only memcg a shrinker registration still visits.
>>
>> Measured on a 4-CPU, single-node VM, 20000 tmpfs mounts (shrinker_nr_max
>> 20096) and 2000 memory cgroups, on three kernels:
>>
>>   base                 v7.3-rc7 with the kmem_cache patch: every cgroup
>>                        has every unit, in a pointer array
>>   xarray               base + this series: units on demand, in an xarray
>>   old array on demand  base + patch 2/2 of v2, rebased: units on demand,
>>                        in the pointer array
>>
>>                                                      old array
>>                                       base    xarray  on demand
>>   slab per empty cgroup               185 KB  18 KB   22 KB
>>   shrink_slab_memcg(), empty cgroup   1.6 us  0.2 us  1.6 us
>>   same, cgroup with objects on 100 sb 1.9 us  0.9 us  1.7 us
>>   mkdir/rmdir the cgroups, 4000 more
>>   mounts with them alive              same within noise
> 
> I think 'old array on demand' is probably good enough, and replacing it
> with xarray is not justifiable unless you have a realistic scenario that
> would benefit from it?

Well, i would not say that i'm happy just to rewrite a lot of code,
too many completely new code, i agree, but i have to admit that
measurements say xarray approach looks better.

For the memory we are kinda good in both cases: we drop most of
redundant memory, the rest numbers are low for both cases.
What the array keeps is three costs that scale with
shrinker_nr_max x cgroups x nodes instead of with what a cgroup uses.

Measured on a 48-CPU, 4-node host (the one from the v1 cover letter)
with 50000 tmpfs mounts (shrinker_nr_max 50112) and 20000 live, empty
memory cgroups:

+--------------------------------------+-----------+-----------+--------+
|                                      | base      | old array | xarray |
|                                      |           | on demand |        |
+--------------------------------------+-----------+-----------+--------+
| unreclaimable slab per empty cgroup  | 1.6 MB    | 65 KB     | 34 KB  |
|   of it, the per-cgroup container    | 32 KB     | 32 KB     | 0      |
+--------------------------------------+-----------+-----------+--------+
| 640 mounts crossing 10 unit          |           |           |        |
| boundaries, 20000 cgroups alive      | 1.41 s    | 1.31 s    | 0.10 s |
|   the same 640 mounts, no cgroups    | 0.08 s    | 0.08 s    | 0.07 s |
+--------------------------------------+-----------+-----------+--------+
| echo 2 > drop_caches: shrink_slab()  |           |           |        |
| for every online cgroup, the walk    |           |           |        |
| kswapd does on every pass            | 23 s      | 11.3 s    | 1.3 s  |
|   of it, shrink_slab_memcg() per     |           |           |        |
|   cgroup and node                    | 22.8 us   | 10.7 us   | 0.5 us |
+--------------------------------------+-----------+-----------+--------+

base is v7.3-rc7 with the kmem_cache patch: every cgroup gets every
unit; both on-demand variants sit on top of it.

The array row by row:

- The container is a pointer array sized for shrinker_nr_max, 6 KB
  here rounded up to kmalloc-8k, per cgroup and node, for cgroups that
  hold nothing: 32 KB per cgroup on four nodes, 640 MB for the 20000.
- A registration that crosses a unit boundary reallocates and copies
  that array for every cgroup on every node under shrinker_mutex, which
  every other mount and umount then waits for: about 120 ms per
  boundary here.
- shrink_slab_memcg() walks shrinker_nr_max / 64 indexes per cgroup
  and node on every reclaim pass, whether the cgroup has objects or
  not. The 11 s of drop_caches here is that walk; kswapd pays it at
  every priority.

The xarray version pays for the units a cgroup has and nothing per
shrinker_nr_max, so none of the three rows grows with the number of
mounts.

Surprising it is also less code at its final version: it removes the
array reallocation path and the spinlock the on-demand array needs so
that an install is not lost in a copy, and ends up with fewer lines than
before the series.

--
Cheers,
Konstantin.
