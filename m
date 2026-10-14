Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021086.outbound.protection.outlook.com [52.101.65.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127EB51B18D;
	Wed, 14 Oct 2026 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984065; cv=fail; b=AtnHaI2CTldm5zEXQzmsiIS2Pu428Tv0C1iwePULROkUj/3+389lm1lw3WcqghOyPjFWl4T5A104KOjojjKYJ+Gm94XjJOb9YSNuYvcsFTdoSZOBDW0z3tZ52DRdmWmh7zUGSr0VSD0MtBRPSHGJEdZtJBVZcKSApMsSFnvYvXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984065; c=relaxed/simple;
	bh=zdCUhY3OGcWP0GaiBdganPrxpuVw2W03cDqVPmQ1/7M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NDiA8wA9gk4/Vqc9QRW8rAniCV9gS67gTMVjq8yDI3wfTG7jhtrnZEB8RerHHf78U3ATUFmGiePsfJiZG46PAJQAzJauzKnhIfd/epllMKuQFsjdmg2O3BzM5euMJlTyk8yvtRgqMusfoksU2e1tpL3benc+CiBo1Dy88vX4/Bw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=RGlt/vA8; arc=fail smtp.client-ip=52.101.65.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="RGlt/vA8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yVvLjrBtIHdS2/ZhegY1/HGFnKDUJdjgesZf5tECjVkpln6e9XIbMXXUaDFxjM+QlO0m2QRucVtJg2cjRvygVYw4uSlNkPNC7dvW4H3nhqHCXL2ER8Lji3HZ97802/2n65jIPBBJij+1W2he1DiOmvxVwGPiQz72v2toUU9yQrxEQ0bx+tRFqhisxPCPan+PVgYTxh8+hhXZQ1JEHlCYWII1l2yvCtNpfV6IdEYco+VakGYQhoazrVw4aDZVXRUwEFCBKisFW6DfaeDIAw9H4ePViMkywFR5QMM3dnnYqXdk/XH5fXoI7WIwJGYsSvLsEF9us3YveGS8EIxhYW6udA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySbuWqyOG7qfPC9SJMX9PPTulpIPyCip4Vvwurb/yuk=;
 b=PGtokdeaFIGrW/jZEpK0opJKsK+jzaqzvpOvC1PFUwSAlzXKqk/UymoOsxqj0tVCdqpES8rDR/xVadwEr1Cu4eVwMVVBLYw0W+C+DGKexnpQkR0a3sjADDguqqnzZf9nomc6go8/n2mYXM0H+xnBWbycLdgR/Ny6+tY0A/YDkwrbtZCIdgLiIQPB+m1Cnfp6QUF7ANL2HI6XMgnWkC+Bc+9JCFxDwpfDFId8cv1vnHbTSq0wXns3BhW4QVw1sjJIJDMZek1AU/jjLJ0Q5n20AjA1ugxMsV65ZQmHqkgGrpzAUWM6IwtsLwV2RwPoIO8WU7O1CJO0WIDi74VIzLiNJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySbuWqyOG7qfPC9SJMX9PPTulpIPyCip4Vvwurb/yuk=;
 b=RGlt/vA8ePhjr8GAVrondJI1tuDCnNXbfw0d6Ng7uciSUpcgc4c6JlWN7Lz0whN38zclc0I8VEwNYRZGCv+WNxulJ7aSUj0+mJr7t3e5yDDiktHPUdn3bUSy+G/5ZU7wvQrrb9JN/9qWr97Ds9DXXcusdaBkZYMUwlEwMx80U+ZjL2QUl6Kh9q3aDWktWJ9zk2MRYCOwS3e4DMWUedkQefX/Bp7wtyjrBcuTG8Dj4OnChca4L9gOtwjYkQacGjyIm9nXry97C38cD+5faMZ4kf2IBCaJ2HTZpgfDfTWU5sS6SBoSBShgZEtztaBb39zVsx9Fdxf578DmzeLZFkQeZw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by GV1PR08MB10422.eurprd08.prod.outlook.com
 (2603:10a6:150:166::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 13:20:58 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 13:20:58 +0000
Message-ID: <7d037519-3034-4e7b-bd9d-6bac0960fcbf@virtuozzo.com>
Date: Wed, 14 Oct 2026 15:20:53 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shrinker: size shrinker_info_unit to a power of
 two
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
 <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
 <EDF08D88-7AD8-4697-A1EE-F20BB1F83AF6@linux.dev>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <EDF08D88-7AD8-4697-A1EE-F20BB1F83AF6@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::18) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|GV1PR08MB10422:EE_
X-MS-Office365-Filtering-Correlation-Id: 09233156-a3dc-4995-7972-08df29f5fbe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|18002099003|22082099003|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	w1qK37Fjj+thQJ6nWOjKAbujD8WRRLdLjNfCajkAf1vgLt5kq9gO+KM4WzC5Uq8c66jgyb5zap6gIGPMr0Rhruv4I2cyxkazp09+QRPjp6YxgeT8mD/ulddkdUOzCJhIKYl4utyJ+NORtYlts7eYx+tq/qizfs/a2supTror2cNHoJG+oTwvRn5TrDJYc8KAcTmqvwgDyAOPINbbAPmRTYoMEV74hNAzDaI4N/a/479rtoxFXGw7+ek+fWYeY2mbVWhukd7he9AcUcFVTm4WT/xLXlsdkoIT/FrfyxIeuOOQTlbWiEn2YX0g/CHf2Nimtp3iQdeNmzntEIvDybdLRge60DpbJHqKCo1y0GDv0zVMHfeEBK7kVPwMfOsdVVob5OqnTtpCplqyUYgqriQ6X/bTZS9sXxPIM4l3xkgsUZEUaK+a2YuoNODrgCJAVXKwQCvCC2huGftt76CCuudjbCMM5bi6tAdrwB2s81bFSc+kesPLNergJOUfBb7x+FouVegoya9Ow19pSCiYl3hdE9ZNKzqRodxeCSVC6FDDnN/VBqwWge8Y1I+XG/wqlBRsuM/7OWPSvV8gXIlOulqTUnFxORJW9++r0gnJxbiNWm0sO7la1+cBlk0FgczDtqfzqyPWcsLXqvs3SyqVRbGtT/W9JKrBx2aRVSkJYork1dk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(18002099003)(22082099003)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUc0SzZGZG9uWnAwZ2p0M0RUWis4RHAzU1BybE8zM1hiaFR3Q1pnL3ErVFdo?=
 =?utf-8?B?OUl3UnFJUnZ6L0o4WGw5a2dlWnExN2w3T3o2Y2ZqYUs2RG05MERVOENiLzR4?=
 =?utf-8?B?dk5FS3ZaN3FEMERkeURGemltWE44TWt0Yms3Rm9hc1k3SmV0aHpNZHRQOW53?=
 =?utf-8?B?dk4rVXMxcTRsVXRPVmZXbFFRMFMxRmNETEpheXkxNGUvLzFxdk1xbDJBOWh3?=
 =?utf-8?B?ektBUVdhbk5ob0pKaXRKNWRFbmRSTW0yeWIxNmpSN3FYbGhPREFEbk9tcklF?=
 =?utf-8?B?S1U4QTk4a0RWZStWSzgxYzJyem05WksrNHBnVFJNU29mUjZOaXQvTnhQWW1X?=
 =?utf-8?B?aXNmNUdwRld2Z3B1Y3dlUElNcHVmYkNQeDI2aGd3SDNmSzl2TVNJK2phYzJN?=
 =?utf-8?B?MnF6RUZDZ2NHRWl2TlJVVGQxamFmL2E3Y0dJSS91enVxV2tNNVdlZ0t6YUIw?=
 =?utf-8?B?Z0RnMkw3VnZHZGdKaFFKdlVoOU5WeFJiZUY0b2FtcyswV1hGaUQvbEhTTEhr?=
 =?utf-8?B?MHN6L2FEWTh3YzVKVENFM2YwdU5ycENLcHZTS0FqVnFOWFRETkF2bDJvMS9Q?=
 =?utf-8?B?RU8yL1lNYW9wZ2kzUWlYVWFXYTdyZGRTN0EvZzlkbkUyYWg4dUhTMWZ2MHMr?=
 =?utf-8?B?NDVmOE54ODJiMlNHejJLaVkwaWY4aDVDYlZ5TTdyR1FONk1oNFh0UGNrc3hZ?=
 =?utf-8?B?RVduNTRWZXRsUGYyV0pVZU84RGR1eTZ4KzFLQTVWMFVZUlpQVFQzZU9sUWRs?=
 =?utf-8?B?em9keFFrKzNTbnR5ZTNIU2pQb083Q3crK1JrbkhDdnZCU25HWTltSGQ1Kytl?=
 =?utf-8?B?YW9wY1Q5bmtUaUh3aXd5Sk1neGpWU1NxRGpLTHBRWDBaeHFHSFkycVhiM2J0?=
 =?utf-8?B?aVFZaVdyZHVaSkFaRlFqMmFNcVRWSi9aVVRlTWpsN3RpSXhoYk5XSHRtNlZI?=
 =?utf-8?B?b3Z0UjNKQnk5NHAyV0gvQjhwMEFsY0xNOTdjYmI4MWVpdTJVL1pmR3RJVzY3?=
 =?utf-8?B?T1p4UWxsNUkyUStUTWRRTjBvb1VUWUgwTllGTnZvbHRpQnlXSjBUbzVTUXpv?=
 =?utf-8?B?TEZkYzJhVDJEd2QwbURodlpoa0o1RTFvUDJTcTdBdDlVd0JPVnFzZElxQjln?=
 =?utf-8?B?S201aFRoRk5IR3I1WVFYV3prNU9kWmhaZVhKRGZLUGZBV01DM1pKc1NKV0l3?=
 =?utf-8?B?UCtCaE9OWmVXWElEbVB1SkVzbngrcmJqQkI5Wkt4a2haeWZlM1dRZ2ErVWFs?=
 =?utf-8?B?VFFUZVBHNmVxQTk4UDNLZDVBNnBGZDFVUVZMZ3JVanlKMk9oUlJlNXlUL0pJ?=
 =?utf-8?B?cldWMlFSUFJ2RTZ5dGthYVErdHhKWVBkNng3OHdXMHhONThTODZOWEVGZVZu?=
 =?utf-8?B?KzJicG5oTUtGVU4zODd1QlQ1R1dnaThkN01CYzM1QXZNekFPdW9FVFZoUmVH?=
 =?utf-8?B?S28wS2hPRzN2R0YzOFhhNVZtRUhDamw5QTZ2UWRKRWZrL1dCY1BwbTBVWG5a?=
 =?utf-8?B?bW1qQ3dzT0Zma2hHdmR2V1Fyc0NTQXFVYkF3c3NBdU85QVROK0ZxK1BweEtF?=
 =?utf-8?B?VFNSWEFEajk2MGs5VGpFY1ZxQ3VNdlQrTm9JSmgyRTROUUZ2Ynlmd1BBblpu?=
 =?utf-8?B?WllOOXRiMFZkK040RWdJMGNXRXJTbitHWHVKbytOcVNmczlTS21Pa3VuSkxO?=
 =?utf-8?B?dWtIV3NLNk9XRjFGUUwwUVVrQmVXVTRQSWxWSWJaVDV5QzVkeFBhdWYyNXJP?=
 =?utf-8?B?T2I2VDR3WVFMK1Q5MTZhNEw2NWN6MHZaRkNVVlRpRGtPY1hoN1pPRFZmL3pi?=
 =?utf-8?B?dW54d3p3cGVXN2s5WUxBVVByanBBYW1STXJ4U1FreTJXN1EwenMxTDJqSk42?=
 =?utf-8?B?NWltWUJ2OWgxUm4rOE9sV2NVV3FTQnY1M3dGWURFYmdNRm9ndFdZNUxlYWRR?=
 =?utf-8?B?NmUrV085d21EamdJdDF6eFBsd2E1ZDRsNGVWVWdsei9Za2lldUZrNDFYQlBp?=
 =?utf-8?B?a21tQXh5SjVBaWhJQThXYVl2alA1NFdpdEwzVHJXa0NXaVE1QTlWUHB4QzBD?=
 =?utf-8?B?Y0hUd2R2T05rTlV2Ni9oMHJNR1ZHRWNUUURDYlVoT2kwN1htRmFJRS9qS3pV?=
 =?utf-8?B?cjRyWTdpcXczUlpuYy8yTFBtOEtUcXpSY3hhVGtya09tWm1ZNEtsQ3ZsMXdO?=
 =?utf-8?B?MXNPS3pOTmR2MmNwUVplOTVwd3kwOTRyUm9kbjY3SEViWlBZdEwvVi9sRjJ5?=
 =?utf-8?B?ZnBjMVpGVVpmemd1OFJ3ekhPSFV0M3p3M1VuZkxpV3hGUlA5Tm12QW1veEdC?=
 =?utf-8?B?MSszaW13ZVVCdWZVMGJMbkppNVdYY0Z1U3BVdGNuTU8xbGRaYjZrZz09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09233156-a3dc-4995-7972-08df29f5fbe8
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:20:58.5267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h3Y1q+6mEsiRyYedZ1joy6pV1Kwi5PpSN1Qr51whDBVc4D5dhckr16ojDUsHUox5F+nGd0OdJ31EmAMhgtaeGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10422

On 10/13/26 08:18, Muchun Song wrote:
> 
> 
>> On Oct 13, 2026, at 03:02, Konstantin Khorenko <khorenko@virtuozzo.com> wrote:
>>
<skipped>

>> /*
>>  * Bitmap and deferred work of shrinker::id corresponding to memcg-aware
>> @@ -18,6 +22,9 @@ struct shrinker_info_unit {
>> DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);
>> };
>>
>> +static_assert(!(sizeof(struct shrinker_info_unit) &
>> + 		(sizeof(struct shrinker_info_unit) - 1)));
> 
> This assertion is not straightforward. I'd like to use is_power_of_two().
> Like:
> 
>   BUILD_BUG_ON(!is_power_of_2(sizeof(struct shrinker_info_unit)));

No problem, i'll send a v2 with the modified assertion.
Muchun, thank you for the review!

--
Best regards,

Konstantin Khorenko,
Virtuozzo Linux Kernel Team

