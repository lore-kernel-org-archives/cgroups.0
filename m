Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.98
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794424785;
	b=hBFKRutmGYI4Aod8KMQ0rZQPemkqOcsk+BphSNWjVuj9BTbgB+wjVpooOLSW7mbKfxh2
	 BAKWAsc2XVmK+cPSVRq8i1x0FxzY68LtMXQt+3LkSLMgWRcgL1SxUNPPYUaORhzLWBpHw
	 Jn72Yo1JRh8P6WbOImUxb0ncungqy3YvhkbxuSbJHrzBdgkDP+2NbYHyyA7LdCmyk7GHa
	 HDB+Tz95CxKzpIociy72JFGaQI6dAzreA+xpQgOOwt6E39zBxMwjHbhirr+ZVD7XGV2EC
	 LGPRa0HqmIMu0XF9DXSZi6ZonsoNoaeSkVOlWxGlSvwDuCdhCQKdN72tnGaHJvhXm4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424785;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
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
	bh=ho9Rf2XD48MaQYjFb6vO0dY8OM1AY6Zil4Pvi3jrxeo=;
	b=lySDgiu6Mh4cLPF8X1WvknTjVOxbm82zwd6P0K08IOOn5y4oDplBuhebzUx7y7qOXdqq
	 zPtLG4xi6CRdykM9ryw8+p5K9VlEHO+VwZrxK5IsbLlxi3740y5PuofN8VlzVcFR26Z7I
	 /FVzktIs+OhhvL+YRWKea8qLlocNZUiRsgLheoICGckbEBOStW8LEuafuJDG3M8Xw1CpH
	 ISDTa+U3SIh+shkbzEXoCbowS2Be3fdBt44EnX0bSlg4treMFJd4Gu25YrMJ+frznN2lc
	 avpvEcRwUwvIRQlKKt5NSU/XeaArssSaiu79JmD5DHc1xCmQKqsW9goVXkbphBy2VFg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=SAVA7k+O;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.98
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020098.outbound.protection.outlook.com [52.101.189.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A250B606A33B;
	Wed, 11 Nov 2026 19:19:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A250B606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=SAVA7k+O
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k7w+c31IdFJp7wDkP7w/+kxl47gA5JmeTm/YJxQJn0c5EJwDNs1cdwCKbFtU+fwy4BvwHEn+p9+R+W2kLjRDSxbV0R7TvyXEUQzeyWd44oti1Rv3xpCSyAJwMwRptzPy9qUTxGOgDv+HhiHbbhMMji25ePO4XtUXMyGxXA3HIoOzC7eMcHMQP542ZxhQ9kSZ2B3t+AyU5S2hS0vdny2/kAmYrkKDFHlhtguutJAL2ZFxorNehrhNIxIy8gmjnrga1d4tFQmzy4rixoQp3t/nBLs8aufJS53bNnyw1Z+imMMXay0o95q4UU9CF4x6lbOjaw3CYtQKZaHrjwRzFFrVBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ho9Rf2XD48MaQYjFb6vO0dY8OM1AY6Zil4Pvi3jrxeo=;
 b=swuVLXLGT9n8Vvd46N0WZVSSlHBhFalPhecUYdh6rTq5d4GoOzsFNTtJK6XsBic/CYDSlvYyd2nieB2RkTG5X1svsWpX+q7hWLU0zM/MZQUNUdo1v2s9EIec0deHuxE9bGSVVyEJZ0BJDZ0NHPqSwF+OZsVxC8Bqn7KmNHKfGGjROF0wPSC/dDVpycdqJZnV0zohXShsJGX0uem5qh00fbeBgD2yT2GLjxymvGhq6szs4HHr+pS2WCy9q/FeoVRxRMGR9KkbtyC2ARvkyIDRnG+V2jqcKq370mbPn1OybnaeA/xu8Hr1tMOwcT/6sL0nwh70LDewXngch4RvwmBJbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ho9Rf2XD48MaQYjFb6vO0dY8OM1AY6Zil4Pvi3jrxeo=;
 b=SAVA7k+Ozg8LdS4DHvOt/8wOUXVF7CWTganDQ5MJqdy3TAWalwHNgep2nYp54QW2uSU6bNKmx0Nf1FBXZ40MQS3fDMHP7IfGFvNUPHWsfOrw6MVgeS4A1hmgjDQDksoLqAEEddxDGQLUvliFwrzCDvtvR4uPYfrqAo0iQ3MhdNJL6Buj1s4xojFZiPCIsru+XPAVaujj6ZlBIqZa7CwQa+XKBHcQ62JtuKLsC3f/I3dLHWOSDVuGzC+jivXIkDCDxdd4mai9ubM9A2LPLB4foCY+m7+xiPsM7mVJAt/N9imqsrCVrgpxjT3KwwVgLRtIQsPFqXxDBIFvdH0XrF5Sgg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT2PR01MB6160.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:4e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 19:19:36 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Wed, 11 Nov 2026
 19:19:36 +0000
Message-ID: <83b2244c-f68a-4af3-9c8f-0fabb4eacbb4@efficios.com>
Date: Wed, 11 Nov 2026 14:19:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/29] sched/deadline: Keep departing bandwidth across
 a root domain rebuild
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>, mingo@redhat.com,
 vincent.guittot@linaro.org, linux-kernel@vger.kernel.org, tglx@kernel.org,
 will@kernel.org, boqun@kernel.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
 mathieu.poirier@linaro.org, longman@redhat.com, ridong.chen@linux.dev,
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
 m.szyprowski@samsung.com, kayracizmeci@gmail.com, weihengqiuu@gmail.com,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-14-mathieu.desnoyers@efficios.com>
 <avRmoK08LoIeySBL@jlelli-thinkpadt14gen4.remote.csb>
 <c3e7054a-486c-4e5a-a646-eee42e815ce4@efficios.com>
 <20261111161912.GP1779021@noisy.programming.kicks-ass.net>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20261111161912.GP1779021@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0056.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::17) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT2PR01MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e9399d6-b821-4d2c-e465-08df4028b972
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|22082099003|18002099003|3023799007|4143699003|10067099003|56012099006|261028144727099003|261022105027099003|261026121527099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	cwljkFthZUZMynTsDn/U2S2zxN/71OZ1N8OBResjFdqycatFWakqOAGRgiGyWQ2dmQLHxrmSisnvOID3J1dv6PTMOk/sJVRUhdKBgjp/YL2ZEy0sy0EOGw93Vjw8lmGUw2qHYjDW/9VE8+YFoj0901ErWGKIe8KXiP/BrtfIH/WXEBcOx+VGvNoeATLVBoQ5Js8MtweLfWVbzvefUohP6I5rOx+eUzyHi54dStiPiK1uTMx8uKmW/NKXD0+3mFWuKY6JHLOEPXf4s3hPmJgqrxk54pR8kV2eh4HyFVHZ9gLscksFGDl/3wvJUt4BS1a+J+NJ2AHPO4eop8fEf5gY14Xn8YmJJ1gDFTrcjX6t8DigsxxYd/VESqHLlqsarUOLtgq7pKno67fT5g12V4j0+yJR+i+6T6/V+/fGQgjooK0DiB+JqeNUA9Z3Kf+3R8D0Q2XDTWXpTmecrTLFQqjSAc7WOI13alfYGQDwt2z64QJfru+rPud3v85YlSTNfGeIoumGoi085TChOJFP27M+trMgEfcvF4LO+R3nGRqDmHtS2iXWjosqCVq7UTr+DqX/M6k7SRd/tmA8jv8vePU8/RjZCloq7KSZzoMAZ7PruZg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(22082099003)(18002099003)(3023799007)(4143699003)(10067099003)(56012099006)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzlIMnQwVEFJSnc1LzRQSnN2SEljV0pwdGJ2TXE5K2JhNk10eWpnY1JiWHBJ?=
 =?utf-8?B?bzVaK0d1LzNIWWROd093Z2t3WUs5V29yWEplRVU0ZVBWYXEyeTNWejJ5dFgr?=
 =?utf-8?B?cXZnU3NTQ3kxSkVRT0thZzJHb0pVWmhYaFRZdmZMSm9XYnFab280bVFMa21W?=
 =?utf-8?B?K0VoTG1rVW1CNkhRR0R0YzBiQ1F5dGY3OU9Ma2lmWENZRnBJU3hKS0k2bklp?=
 =?utf-8?B?ZGxTYmRMbDVHVGE1V2pmMGFCRlNLQVlldXdMc29ZTUU2bXExdHcxajVwWmw1?=
 =?utf-8?B?SjRibGlWNDNFcGpFa25lTUxoVU1UcExVQmdYY0ZGN2VlWThrUUpNeWZIOUVI?=
 =?utf-8?B?RnJpaXFTTVFUbVlqYzhkMko3YXBSVUR2L1VET0dHYVFiWXkvN1BQckRjQjRQ?=
 =?utf-8?B?bldob20yZzhlSFlBNkl4Z0RiWW5Nbm9nMzhXYTNoN01KcFIxa1hxOGRDb2JL?=
 =?utf-8?B?UlhGbldtTmtiUGFXc2J3UGJBTGZ3VlNJNFVTUG8rWTBQRzNOQmMyWG9HQkI4?=
 =?utf-8?B?YTRCcmhPRlBvdkx5SHVucmJEaHBGQ21abjFHM2dpZk5wWHFYYUVTN3Rrbnlv?=
 =?utf-8?B?QXJ3M1NWN0hFR0crbzhsdzFRbWVRcysvZlpYNHNucGUyWnZkNlVad21NLytJ?=
 =?utf-8?B?enpxTUVUaERhbnhKVFRNL0xtek4vR0EzNDNPNFdtTXlpb0hXTlYxdTNHTVVO?=
 =?utf-8?B?N0pwNGFCSml5L2RwY2k5UzNIYWVsVG1yRGg5eXdUTjUxTkg5dlpEdExuYzVs?=
 =?utf-8?B?SzhXQWNSTVRuWkV2azRKZ0dNeGlUMWlxOXFFM2RJNzNmREh4SEgxNFJkQm5L?=
 =?utf-8?B?WHhlV0FlcHcwcUltaXdKWUtmSW0zbDZ2dlJ4bEJnVUpMOGdOSm95c3p4R3B2?=
 =?utf-8?B?REhqK2JUcHlPNXBjQmhJKzBIckI3QVB1STdITkxTSGZKc0QrLyttaWlnSzAy?=
 =?utf-8?B?QTJQZFdkRG02akNmZElISXl6WGU5bXlhaUpEM09TSUNmOFNNTjgzYVZnL1pN?=
 =?utf-8?B?WmZUeFVFWGtFZTFaaFlxaWpOTWppRGNOSlkxREU1ZmpVd3REdk1KMlJZRDZk?=
 =?utf-8?B?S2ZKUGt0Z2tvNy9XcmpVRjBNSXpLemgyTFdiL2xsVTVBZHhHbG9GL2tCMS9V?=
 =?utf-8?B?cmpPaE1KZmJ1MnZYSlJ1UFBpSlAvWkM3b0JTMVZDQmp5dDhWMTFiVFVtYk1Q?=
 =?utf-8?B?bUpXOElzQURLNTF4TGowTzVKdldMcFFhOG1JYXhzcFBqQTc3REQwV0JDYUph?=
 =?utf-8?B?RTNucnRqY1FEUGEyOFdpazJ0Rm1EaXpSMVluMGR6NnpxbVB6aDVNSDJQUzhy?=
 =?utf-8?B?NHZPK1cwdWdHRTFOUGFMYll0TzhnOEo0UUcyUTh1WVdvTHpPZGVtQ21aME52?=
 =?utf-8?B?dEZJVG9OZENkZXBXNFhxYkM3S3RodGZQNTZMSm1kSHZySEhpdXIzN3BHQ29T?=
 =?utf-8?B?NDNvMWtWUktkQnJpaDNUaDRhdnlOUkk5ZTR0V0UwTEZuVzAwTmZrZVdMc0ll?=
 =?utf-8?B?YWxZUjJ4ZyswUU83Z1EwSHhwSWpWVjVnbHI0UjBXUHplVEtPTk5Od2hzK09a?=
 =?utf-8?B?aFpTM2kyTHNmK2s5WWN3ZitrN29qaUdtTEFsL09tU3pUTkY1UEljbktPOVF5?=
 =?utf-8?B?N0JNZjhTUERqNHBMREZJcDdZL293aWNHemlpTEl4RUwwa0w0OVpTelFpdVJv?=
 =?utf-8?B?amR4emd1Q1BaWVNuSkxzZWQxS2VRUndkTUZ5WlJxNTIrRFB1aFVpMmltci9B?=
 =?utf-8?B?L3lqeGpmQnVPWFlRNHc4a3ROQ2VrRWRGYkRHZHc0TXN0WE84RllTaUlOa2lZ?=
 =?utf-8?B?RlJyeEFTQnJYOXZaZ1ZMdVlZWnRlZ0ljekd4ZmEyTXZiRFBiZWhvcEpma0xu?=
 =?utf-8?B?M3E3UDJscjk1d3JYVnhFczdkUHduZ1A1SFJRZ0NYZkJEa2VqOFExM1ZFTFM1?=
 =?utf-8?B?MHFDeWNwUVkzTUZUdEorUnVGdHlOTUwxQVVnR1VqOGpJOWJ1V1BwTERvLys2?=
 =?utf-8?B?MUhWUitRZHNHaENSSFBEZ1ozR0kzbWNwTngxWlAyY0I2OVdaYjNLdzRyN3pp?=
 =?utf-8?B?UkQ5bCt0RCthQmNPamZmM3dTbkZnOEg1WUZiM0gvZmlGR0p1cU1aUFB3M0ND?=
 =?utf-8?B?aituL2toNDVtaVlEUG5LU0dhS1hUeW1HU2tYR3FKZitXUGEyU2hUeHBucHFN?=
 =?utf-8?B?UUxjRHY1blRpZFBiMzJiZlBTR1Y1TzdRdmEzMGtWVTJZNGhlL2lzelhxVWww?=
 =?utf-8?B?Zk5sN2JySU9acFVDRnJrelI3QkR5ZExpY09Cdi9MSmhCSzZ3Q2VuNnJMejBh?=
 =?utf-8?B?WU1mcXFZTmRlSkZGS3JORW1qM2loajdML0VoTCs3WkNMOU5yR2VrMXBIeWJj?=
 =?utf-8?Q?/BdlklObdgiS81NRzph4+TWv/CCpvq5QA8cPj?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e9399d6-b821-4d2c-e465-08df4028b972
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 19:19:36.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92ZqqcCQW0BTIYkGJXyGKZ7gKhv3dsgAUj9rtpcEilOLB3RKJwHfrQMtUpw7ZtNvk1EJUCJPGuLkpKpSTveLMOVbzzUQh5fgNgu+foU/okY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6160

On 2026-11-11 11:19, Peter Zijlstra wrote:
> On Wed, Nov 11, 2026 at 10:35:17AM -0500, Mathieu Desnoyers wrote:
> 
>> Measured in a 64-vCPU guest with sleeping deadline tasks:
>>
>>    tasks    today: rebuild, longest irqs-off    single list, all irqs-off
>>    1000     0.75ms, under 0.1ms                 0.12ms (0.19ms worst)
>>    10000    7.4ms, under 0.1ms (0.3ms once)     0.9ms (1.2ms worst)
>>
>> The rebuild itself is 8 times shorter. That comes from updating the
>> extra_bw of the CPUs once per root domain, not once per task. But the
>> longest section with interrupts disabled grows with the number of
>> deadline tasks. I do not think that is a step forward for a real-time
>> class.
> 
> This is domain rebuild? Do we really care about performance there?

My worry is not performance, but rather the contribution of this
"iteration on all tasks" on the irqoff latency of the system, which
is relevant for RT.

What I don't know:

1) is 10k deadline tasks something that we should consider as realistic
    for sched deadline, or it's way beyond practical scale ?

2) is a irqoff latency of 1.2ms (rather than 0.3ms) something which is
    relevant in terms of irq off latency on a preempt rt kernel, or is it
    in the noise ?

3) are those domain rebuild expected to happen with a live RT workload,
    or are those operations expected to never happen on a RT system under
    real-time constraints ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
