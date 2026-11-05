Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.85
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793913660;
	b=KL+7pnH+r9fXvnHxUfheU1wmUGEAvRzyslzPYwBzpyn+7bhVy/TJ7NllTrPB4JK/Prju
	 0k1Hr7F78V1ptK+FpigVxje3ipudyqp7kXvFPA0+lQJmmqHTRvChYahvSIkpCgeoMbQj/
	 2Na+po5nRNs/J7dReuRQEb1jJcjeS5ojzDE1Jm9X1oNCqn+Dq9ZguRTXl/7aA09VgPCcp
	 eSODam4rW5FslWiXtRxCkVPBg1bQ0Uy3bOc7uPUqKZ/MZKlSJxW/lWtu98P32SBWK2xPo
	 PqDJQ+mD8MqLL2ztAj6leIXa+y4U1uaO2N7X74toDakFWC05cKRqhTTFjjAckVjHKFg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793913660;
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
	bh=EpoIeE4Cztinb7cwNKrU/WdBjjEwDfObg9ueQaqvSkY=;
	b=pY0qXw0IsqZ3pwhtqqufCQRaaCS+9bmvDwJB9dhN/Wuf0r2EWgpmiIts+qSE7TB/QOtZ
	 o6WI1ACuUcUkmFnRgIsnQ/6vy4SQ4NZBsmqOOOvHH8CTGxuC2G93f+T6MCwoBZKNvvN6s
	 UuWDxvgFm+wP9wyVGt9PtyCZpahiR337KEkwUtHfxe/b0YEjGbEQim2H7+S+EbJRvKiTV
	 4mfFZFHB9KeHNS2zRg2ylnnYndAgUEAT2QnGXYDPVAPYrJr3LERwK9Epd8Q47YDLrogjO
	 5hlVoA7qZdW1i61M2c0RxTF6Tb+ng+SzZuMcgnivbvni7nXcdvfVk4kaRi9LqzY5q8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=s5jnoWXO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.85
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022085.outbound.protection.outlook.com [40.107.193.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E01606A32E;
	Thu,  5 Nov 2026 21:20:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16E01606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=s5jnoWXO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VcyOzqGkq3awnWaBeCm4f0bpSpChrnJhODoUdRH3AJQcT85C6ph13QxW1XkeErRH/DWoep/z2BFIy7QnecIKIPbn11ihwNzfaee92kjhj4UtLSUhIJHb72LUiFTDUxJbYNMz9icYUCLpSZboHpxYV+mN7uBfQBkYg3a8qt/INdRCRD5VFfKNcCFD0eR1FEwsjWX/vTo5L7fNT/7biXkOQtMVpzsEukEh6xeYNsu9M0XbWoLBK+ut8VjVCGr9Ao/KqpGqin41W4eeAMAP9loMlzouUD5bHllazV0b/uRatOmbn7y9Cl9IuYuWXUTVeOSwQmo/AUAqxmMI7jIVdxUhAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpoIeE4Cztinb7cwNKrU/WdBjjEwDfObg9ueQaqvSkY=;
 b=X9ufUtK6GudJYu161LvIUuYB4BYHOn1GeeePtQTkfCQEH20r9l87gW2qe0npQgqV+mqrV4n7lp/gvWLN9iB4aY6u4ZGC6jpHzfcVvlZl+pf8bGniAL0mRMRIOyC3KFIAlq7eOq5+Bj5ulSZMadh1roQMqelUHAnGN15r5bl62/7w8j8jQhlFeqzUziXMrvavGl9zdpT6MwS6V/+vzJ2hJkFq/JX5//VGUByB9ztNa/vWKI3g8X2PQVPcLaTjwcX0CCZeWbd/l9o3mpOwMuw27ZyQ3PnRUZ8xtoj5VWeqmboCasgTCHC/LbTHVZIllDsMU+pmzwDoLGX47uacZQcwpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpoIeE4Cztinb7cwNKrU/WdBjjEwDfObg9ueQaqvSkY=;
 b=s5jnoWXOkkXvcOyoUTQilkDldsYhkR4Pl/GVkxuP+PyZrajrqSMIgYdlsOWxtDBxSc4r1PIdoNsEbnvDFy2B1wlru3MV/cWnb3lMN20D9mfX/ojhIkwfVh7uadjzLHzfCs+95YrKJ7KcHpLy1NAST2I/6qfvG9ALIufmX44b3mI6CqX4XyJ6BsagzgPAIbkKUc0+YSpA/mpUqj9HdufdpHpIp6hm4gq6LaSx6+/U5ylbww9oBuXibU/HujCF0KST0LeRhJNHry2X/oOK7dnlttQjA335vWaZOFmHnV3cKgf6oN/nHvcIDloLtV4Et9YEkFkDA3APoH1D1z3/ILgoPw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT2PR01MB8310.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b1::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 21:20:56 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 21:20:56 +0000
Message-ID: <f9576e17-0325-477e-85c8-567771e7b2dd@efficios.com>
Date: Thu, 5 Nov 2026 16:20:55 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/24] sched/deadline: bandwidth accounting fixes and
 selftests
To: juri.lelli@redhat.com, peterz@infradead.org, mingo@redhat.com,
 vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
 mathieu.poirier@linaro.org, longman@redhat.com, ridong.chen@linux.dev,
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
 m.szyprowski@samsung.com, kayracizmeci@gmail.com, weihengqiuu@gmail.com,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0258.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::35) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT2PR01MB8310:EE_
X-MS-Office365-Filtering-Correlation-Id: f529a6fd-6589-40dc-4941-08df3b82ae26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|18002099003|22082099003|3023799007|10067099003|261102123227099003|261028144727099003|261026140227099003|56012099006|261022105027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	LXFjd9AF7t96lybF3rA1brJid7al8lP/OYKmJMLW2aEbdk3+NM1/6yjb3XCB+31T7Xl2XUSPcrbZfMycqqh8dbC5yaL9ZQrC9AoZMlz8Q8ulv4G9+jYI8phrNsC/EqSdU0Jzztl7kIYAyF6L0UhXXydqcKqWaFltzA/iky6uaYbmqWqhVgXRh4c6XjAuOkAU/C7Bbdh+nplvjBOQXfDJe5HvUmwmtx7PaDRNAiCzBlXSw7gikKnBBKWWu0cEuGEtura2NFZuZHJ09Rsq1zPxL1d95TWhTSpkKrWfrWKs/uU2r8+TMngRsy+aU7vECeX48x1k27aXaRIc44ymd+atcUT44ZEEWEgaxdeUzNhYpVK81md5oQnJWV53qyvfeMHrd5CK0+GK9iTvJ1sV1mKeSvrJyKiyO9VM19CKxYKqYiPNaAOzcTqudzz/Ww4I5/RcQBmK/LXsvLoLZl5IZlGkYL6yo9IYE26exDCZhJnbgNGOmKW3sRzIamxQZ1dICHg57gHT7FLJAoWd4Q5+2nxX5JAaxVxTc5Mijs1HdKS4m48h5fIyU58t7qK3bOe/hyHWc6DX9Pa6vViLZepjiUIkXIATrxlFv+l0BLi5FYFyKgU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(18002099003)(22082099003)(3023799007)(10067099003)(261102123227099003)(261028144727099003)(261026140227099003)(56012099006)(261022105027099003)(261021121427099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDVraVpzbSs3RGZ1VE9LK0J0UFEwdXpncWM1YkFKOC91NGltc0l0djRTR0pV?=
 =?utf-8?B?TDVpZXlrKytqWmZjMkplYkxwQmxBZ1FkdnlzNFI5VnNXLy9UUlJWY2dmUEJt?=
 =?utf-8?B?NFJtNk1UN2xWWnRsV29mblZ6dmhtamxuZGZFbHRJS1RwY3hURmt5UUZacUZH?=
 =?utf-8?B?UnE0ZGNLamZLOVZHY3dXTUNxMEFlR1ZXWDROK3JMc05qQ0t5ZVl1c0QzNFdp?=
 =?utf-8?B?Q3NVYmI0bWU1Nk1uODlpcENpY09MZTFqbWRMbnhuTmRBRGhSNGVXRXdzcTRN?=
 =?utf-8?B?bEtkM3loS2Jwdk5qSlRHeFNhUzhOU2o0M3hjMTJjTTdNa1BJNnBhNEwwSXF2?=
 =?utf-8?B?V3RDakpvbE5BSy9RajE0UzkxWm5xRU5aUTRmY1dGZVpmODE5TDUxQ1Myb2Qx?=
 =?utf-8?B?WldtOE5SVldpWWN6em81VEVsNE03MzJoM2R3dDZZTWRMeEUySlJBTW4xZXpR?=
 =?utf-8?B?Q1BXWldqc2NjMnZmbDBMRFBXSXV2QmUySW5mRVM2S1ZJM0FSYWhDam1UQXRP?=
 =?utf-8?B?Tzg3VGNsYnFNS1BGcE1maC9WM254aUx4bDVORDlqR1NzcUlwc2xjcWZlcSs1?=
 =?utf-8?B?eml0c3VmYXMrcXFSVFhJbDZpWHZXU0RjR0crNy9FV2Y5ekcwbXFKUEh0N3hZ?=
 =?utf-8?B?azdJd01QL29lQTZSRGNaTStZZ1ZwaGdYSTk1VitYemNuMWtjbUdObU4wcHMx?=
 =?utf-8?B?QVdoVlRZNDVVNWU2OWFRTEpiZG1VMW4xQ2JFcnVhcUozZnhDOFlvVnVNc2dT?=
 =?utf-8?B?L3NZNW1lNnNNb09GVGVJUUxreWZMUVNnWGE4Y1ZjYkFOUFZPMWJNNUlrRFlu?=
 =?utf-8?B?TVlvTnp5MUU5cVdWbWkwdVJ2dDcyVW1yUVA2WmFjS2h5UUx6UTNtMFN2NjBG?=
 =?utf-8?B?YTF5TW5BbWZKcktTQU9BZHB0RldCU0VrQ05YTnkzdFJoVFhEaWpPbEFIL2pX?=
 =?utf-8?B?VWo3R0FCMGlGVUlVSS9Ic1RFN2tmYnpxSjlEaXBNd29QcEM2bm52RFcyVisv?=
 =?utf-8?B?R3krdy9uN2w0S1VjNktwTVNWb0VnTzZyY0Z2cHp3TGluR0lUK3I2QXhlUmZ2?=
 =?utf-8?B?SDVqd001cFMwNkdzL1BJYzZPUVpwKy8xdEVxQ3JPQkZ4eWRseitqMDBXQTht?=
 =?utf-8?B?aDU0ZjYrZTd3WndDYlZ4T1BVSVZHbzhJQnQ0QjNVT0RGd3pmdEtJdDF6OVJj?=
 =?utf-8?B?Sm9OazlxajBmQUphNjJUZTBrRTkwMnRUZzBHbEdjRUNoR3V0UHdaQmlVUjNj?=
 =?utf-8?B?aytFaUxoU3hkdURKM2Y2ZTRFYVA3ZWZtWVBjdXJSKy83N0NBcWxwZnh5WGQ2?=
 =?utf-8?B?UlgzYWw0b245ZmRxZFRYOThIK3pVTWtMbnhOUjIrcVRVNE12TkRwUzZ0Znp6?=
 =?utf-8?B?QlBRTXZDNnE2RU9nUmRzQVFCZDhBeEY4Y21qZDJQcnE2RmFDbzd3VjRHRERv?=
 =?utf-8?B?OTAvdUJBTGFOVkgzOTJZMWl0aUhtNEpsNzN3VHFOalZBendseGR6cDlwRmVC?=
 =?utf-8?B?elc2TmJ5UUNsVVhJMjh3ZmIxb3pjNW1sS09lbEVsdi9EQjBENkFWRW1IZEtk?=
 =?utf-8?B?QlBvNENZOTR1S1lNWmdHb1FaLys3aXdxcEFuVVdiaWUvSFM1bzNJOTJ5MUF0?=
 =?utf-8?B?aE9xUW8vdVgxeUMxNUMzbC9hS0ZhU29TVkZTK2RwSjROM0k4OTZoOUxxRHNz?=
 =?utf-8?B?UlJZUStRSndqRkIvc3B3VjU0aDNGZXpMMXhNY1ZOM0dscDhacXFlMUovYWNU?=
 =?utf-8?B?bExneFV3ak1ySjBxd2hNTDdjNnVyQnBKVjRYRzRwQnhjUHBUM0V5cEx3K0tn?=
 =?utf-8?B?NXVENmdYQlExaWdxWC9kSFU3MEtPZFEydGVTMUhscXBUenZQSENsSnNlWDl3?=
 =?utf-8?B?b0ZFeWZLTzZUS2xTVnZDTStvazI0MGZnaDk3akxaQ1dBTXdWR0NVSEhwWXRy?=
 =?utf-8?B?dDFqbGVqK3UzMXVuVzlldnQxQjNicjJuVHFJMXBLamltY1haK3k2MzZDa29N?=
 =?utf-8?B?SWc4bVRUYU5Obk82endSMTBEZ2JUNXdTUmZQd0s3NWhhTXB0RXVNOFI1L25z?=
 =?utf-8?B?c2orUktvREhKSHBqUTJQYnE0SDRrRTVCOXNpZ1M2bGZQLzFLM0FkYnZSR2Nt?=
 =?utf-8?B?dll4QnIxcHRMRzZ5UWkzSWlVd2NPNFRXL3RFSlJsRXNMczh0d2d5bUovZFI4?=
 =?utf-8?B?TVUvUktFTGM0L0RZcGZvMjEzMUFzMHVDZnZJeE9DSnY4QnV5Y0N5dGl2Q3NY?=
 =?utf-8?B?RURweXczU21qcmZ0ZTJQTWFTeDhjMlpwTjdpSXlxTFloZ21NM285c0dmeE4w?=
 =?utf-8?B?VTZLZUJjSjB3TGlUWVZibGx2aFZob2tCWHZnQjloclhGTDgwcG9pNng1TUQ5?=
 =?utf-8?Q?uez0F0FhI/Jmxz4M=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f529a6fd-6589-40dc-4941-08df3b82ae26
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:20:56.4516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7elEfNw/WA/U53KNjDA7Ucprrya7mjKCxh9SEII5uC1M+juqvsQvXfc96H/tgg7I3LYSP1n52UNKKNCFx4UCQGH8XWz1nn6kxIhRDz41Zz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB8310

On 2026-11-05 14:33, Mathieu Desnoyers wrote:
> Hi Ingo, Juri,
> 
> Please find in this series twenty fixes to SCHED_DEADLINE bandwidth
> accounting on v7.4-rc1, followed by the sched_debug output of a
> runqueue's deadline bandwidth and the three selftests that catch the
> fixes: twenty-four patches, the fixes first, as you asked, so that
> stable can take patches 1 to 20 and stop.
> 
Sashiko got chatty again. Will fix and respin a v4 in the coming
days.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
