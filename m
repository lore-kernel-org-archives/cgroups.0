Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.142
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794342368;
	b=h3ntytrlN4w7tF2/SbJuF9v4T2mPL+Um8npSYxWcQEPj8dIvSGbecBpn/yOFZlZOv+h2
	 ZmJihA9yfmA/lEjCXJMNkYxovlrR3nLT/U2mtVAWfnFBpZq23QBQ/SssGhXVbbrdakx6I
	 qysa+YPV7rufxQPh1iLzwVZePSVMid2vvsPQUX0f9dqHkswDbJvxpnizteJBwPf6jWBtS
	 VLNEBlNmhMKIzxzv7AAG/HG7bIdWSbhemMxI8lOHznCcmq5C8gdW69csq5Fy8T3quVeTD
	 iQbbbPFcigYlSjEZ0Z8RgUpwlngPSC8yEpdwYFE3w5GpwYYBMg5FkLSEk7WBqmtOLZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794342368;
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
	bh=8nATj7DD7boPPt0Vr2MrZquWqAyKgLnPyA+UkdTsKJ8=;
	b=gBpmB8w0yNJhaf5OuCJwvzPCtjxX6UK1BsKqTaygDTMxjtUEBflRlyn6gZy+ZRr5nQek
	 3l1zlaOdyypjSbDIXS9880Dys41rlzeDx2+NTUK+JbnxqgTOc9qlErDnDdOPUsMXZv1Jw
	 9O4AiI98/aHp1E85NjRpEo8dJ2445VnKpKsz9MiA046SAVi4Fap9WTiXjuH5hThxzTpsS
	 8UN/nm+L5N70xfYkDDcs9fxt4UYthawcr/WbJZczfNlZki5KgosN6goNYO8ElJm4GcvuS
	 kDAytoKa0rMb/0A137PLaoQOgik8XicM3t9rYze7HScxHUj3uBvf8XAhR+vsnR0xCzQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=XjU42KqQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.142
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022142.outbound.protection.outlook.com [40.107.193.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1889F606A333;
	Tue, 10 Nov 2026 20:26:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1889F606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=XjU42KqQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PdvKLWPv44zAi1MadX7Tygo6ynqhUwd+nW0vmO+hmAKa8VZ/22MVH5QMILtYR/+o2ifH8Ntgq+HC7vqTnSW6T6TpHDFcQodQgjFfJOnUFqElCWVqQ1G0tejrhFpO4ceI3W2CERyYhkUfREM/1kpCWSTs2tUhHykS8r0lpl/XaOpnyY9maFrlKdBmNcTE9oG7aVw3YVj2rtARsx+2u66hzJaqCAv9ZTU+D1Gxss+NUxzmuJf5vXxY3QLFIEKd6MC9WakQFsFzbxrC6h0tqoWTIf8HK+BklRIyrRjfCGwP4tsYsa77aJ5y90KLmmxp/EWTuAQ4vM3gpZCJQ7p5VbbuUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nATj7DD7boPPt0Vr2MrZquWqAyKgLnPyA+UkdTsKJ8=;
 b=ndDDmkNUlQRj8W/gQN96ek8EcEd5mixwueeu0Q9D215cJdpemSJWO2AkSQEp26TIOLUP4QyLzD+cV5R75AUJq5csr1wKGnx3A5VgerePXlKQyVJavC3wdb8WrhcgKXoH4nkWova+PImkuUWjGO8BETYX/v/DOpJeLJqC/nhsC97OHA2hzaTZO2d1xwHgJh+yHJRflh4N2qBjvp/IPJ5Te4MVLCX5zbemhhQ2IQmLpPz6MVHTYo+NcEvT6EfcSvekZ/FXp3mNPmPWLPmIMYn8hIYKsq2d2SaCT+22F0/0yHOkYoACLt26/rm5YV4Aw8Mjk1dVqFqatyyMEH5gMdJFEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nATj7DD7boPPt0Vr2MrZquWqAyKgLnPyA+UkdTsKJ8=;
 b=XjU42KqQXdUp/QM/czJ1/XFXm2kN1PhUfy+KGKfo0miT3K2CeSWKc1oVGdi3hea2taUh3TgenTJX255h8JFxnVyPnRfTr/IA+mBCnS6wVdcFHxWQfgaCgS65SR7xRWG166oLBRY2zoeqiTc4fU8lcKrNFgaXzkm+WEZeUR9UXHx4yurwdLUGIIKWXSlhhPn4SKgZiOEFb4U8oc3NxED3dsbwl4rCDMINHFLTOITvmrfrsZc5p0ZcCElW/cwWIUGcK9Ed8QkqtsiHlEVSPoSl0JYuoKaX0oxPjSwSeBJ9ym2YdYbzgFO/nsSomGNZSc0tZSJitjUpMmizMzSZW1LJ8A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT3PR01MB8675.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:7a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 20:26:04 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 20:26:04 +0000
Message-ID: <aa698c24-873b-4fcf-bbf4-44e204c10cee@efficios.com>
Date: Tue, 10 Nov 2026 15:26:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/29] sched/deadline: Release the bandwidth of a task
 that leaves the class asleep
To: Juri Lelli <juri.lelli@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
 linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
 boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
 mathieu.poirier@linaro.org, longman@redhat.com, ridong.chen@linux.dev,
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
 m.szyprowski@samsung.com, kayracizmeci@gmail.com, weihengqiuu@gmail.com,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-12-mathieu.desnoyers@efficios.com>
 <avN0wpOY2zoRnK8q@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avN0wpOY2zoRnK8q@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0040.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::26) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT3PR01MB8675:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fbb5742-475a-4b4a-0cd2-08df3f68d801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|23010399003|376014|56012099006|4143699003|18002099003|22082099003|3023799007|10067099003|261026121527099003|261026140227099003|261022105027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	6PqjMNtxrwW5MaByLfmqnas9Mgy4mJ2NK2X4thmAwhpjxMfFcdFvY+hEJiWXVWPqblV+XGIdWM/616WhtUbNuy9wc1x9d/IAjszyZ3/WgZgnz8/GoU/9L6HMphhSI3ypJVz85+quwGdG2q2AU0CGWJQoicnQ4BKojGlGveEg3PD416oMzBDssq5DsLK+xnebXI2dH7lEY7q9O0zZAlL+qiZtr/sFRNtqIvYUnOIXcZG26QOQHF1Yip/2cztLM2XisxVitHBN0tQjigpxiQWkEcQ/WYWW1Qg3Yif/XzoeEanb/DPRlJm57Om310regB215ZjNpYzXl30ufYWjP0Oggtwza78lf6pZ1Dqc+theIWp0TEwPVPmxhAPCo3LFvuacNnIRSOEqphURFuVVMMiOo0QchvpmIg6ylm0pQlxx9x+hzOIlJ8B7JwRz0Dx4hH0059VolSQ2wMBi3NHt93JO/iEgmFjudAU8thIfuLSiEy/iPy2KZ6dZ9OxZxXb+g9Hw6NCLzEEIpcDbwlRFW0gUay+qhU4HW7gEriBYS3IApGc5Ih1rWIpcHh63jcz1NzsW6Q5ubxBMRH9eB0pfZ+HTjX24VzT8I5su6haxz4bLuqI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(23010399003)(376014)(56012099006)(4143699003)(18002099003)(22082099003)(3023799007)(10067099003)(261026121527099003)(261026140227099003)(261022105027099003)(261028144727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFhqVGROYms0Y3JucEpRMFptYVVDbGFicVNERXZzQlJwbnJQQ25XUFgwTDB2?=
 =?utf-8?B?YjZFd3RaYXRBenJXR3QyZXJHamduQXhrcGJ4djJvMGNhdmR4YXdadGhheGVE?=
 =?utf-8?B?S1B1OXl1U3ZLdG11NEIwTG1VekVDd2JUbXNIaW1sT084K3RPa3Rmd0RnN09R?=
 =?utf-8?B?ZnlScTlYaFRZQk9QR3laUXVRWG5TaTVNRVozM0I5ellzalM2VHBmWGhrc1JE?=
 =?utf-8?B?N3NETEszQ2wxQjVtQUhaaVNYUjVNYWZuanZIS3B4RFZIV1RWdlVJZHFLVEwy?=
 =?utf-8?B?Mlo4eTc0OFVQUGZOVUkvbkptMmdMQktYS3dsUHNLdTROZFlGUUZ1b0lKZE4v?=
 =?utf-8?B?eENFSEJ0bUtNWkVrRUNoUmkxY0l6SHl6UEhDbXNDM3NjbGpyNDlTR0tqN0V4?=
 =?utf-8?B?cUVZRXBRdTFBdjdYeFZWYm80bldXakF3T2FDSjVRWEZ0UXdSR1l3MFIrM1Fz?=
 =?utf-8?B?dXZLNytTSnVCNFZNdy8rMnR3LzRlZForMFpqakNudERzR3BvSjhGQ3RiaGJr?=
 =?utf-8?B?a3VDYmx5akxPc3ZJRjVCQ2NmTFo5UWJyTnJ5N3U5Y01rSk10N1NZc3E1UUtC?=
 =?utf-8?B?Tmk2RUdoTEZxdHdlaHhRTjB3YVgyOHlZV3kvaXJMRCtsMnA0bi9BM3VnZVpj?=
 =?utf-8?B?SWRTR01xSldxOXc5am5RZXo0RlN4SWlpTXg5emZCNXpRcklRaG0vQ2h0TE9v?=
 =?utf-8?B?Mm9iRFVueU9NRmM2d3BiZjR0OVpuSXVYN3RyTnZzNjRRU1JudURwRWY3WFZ3?=
 =?utf-8?B?UmRWc0tIbkcxd1dmTmJmekpkNlJVOFI2VEt4WmlYT1lIQklaUkdCcG0wWkJM?=
 =?utf-8?B?VjBGNmQ5NjJSMzVNd0l6ZzhaTFVsWkMyQjdVMHNvWHdwV21QRytPK1RWTUt5?=
 =?utf-8?B?QzBwTmVDTWlzWU5kL3ZIWktnbVgzaHFwUUFaN0VCNXpjTTJxVGEzS3J2RCs4?=
 =?utf-8?B?RkFoam5XL3Z6Zkx3WGs3cnFBdDhocXUwMHZ5d0ZubkVEdnZ4TGVWa1RyaFdI?=
 =?utf-8?B?MXowYUtPa25DRzZuOUVFNTVBbFNSMnNQczJReS9MMElmYjdXWFA0cjNNSXNo?=
 =?utf-8?B?WlJTSm1HVzVCUVk3UVIrWVVZTXZtc0JUVGlHRHRWQmlnM3NublE3aTQxb05q?=
 =?utf-8?B?UHd0c3ZLUXJVQ3FVeGYwZmJKM2I2RFY1QXVZVzBNZlpER3Q5NHNxY1BVaDRj?=
 =?utf-8?B?a1ArZXpLbDE0MkdMeDliZTNaN0tsM2pkZ2s5QWJwb0M3Tyt5WGprejdmQXVQ?=
 =?utf-8?B?VVhTKzlFakpXd2htZE9sRFU0YXZNZ0NsOUhaWGxYb0hUOUZLaFJ5V3FZS3JN?=
 =?utf-8?B?ZzVmVTI1U2NEYzJMQVdYeW9HYzBKOHBodGVBeGljNFRtTWNWay9PZjhqeFZX?=
 =?utf-8?B?TW5UbllSUWFoMVdBVlNMaTJHMmlKVG1qM2thSjRqM1VEMTAwVDRoUnVTQmZJ?=
 =?utf-8?B?dWdheFgrS1NvaU9aVGcwL0MzY2txdURuNnBJVjJsQlI5U3pJbXdhVm1HRVI3?=
 =?utf-8?B?UEorckk3NmZHMjVRclY4TlNPTFh5aUdJS016aFF5czhmTFZ1ZnhJK0JXSXlI?=
 =?utf-8?B?dHJGdmxBeXdSeS9vbFp6bGJlaGRNcXRUR1R6SGZHYy9yUWRLVCtiWExkc284?=
 =?utf-8?B?R0haaEg2a1A0NkN0bE1JV0ZraXN4T3pYS0tuRlJ1QVVRV0ZNK3krRk1USHQx?=
 =?utf-8?B?VWpMUUV0a1RaUGVnVG9yb2IrTlN1MER4eFVGUTNYd1BWVzJYcW12RTcxRjlz?=
 =?utf-8?B?bFJVY0h1aDErcERsK3A4eHk3ODVQU2llc1RMTHFRVENrMWFLbktMZ2Uwd045?=
 =?utf-8?B?U0MvaHBFeUJ1dGF5NloxUmJqS0kwSVJMVE94anRXRk5LY3p3elM4RHdNNnQz?=
 =?utf-8?B?V3FObjF5MWZLY2dicktqSG55QjVGRDVqdGZGSU1UUElNK0NLSW4rSzhSVlA4?=
 =?utf-8?B?QWpIekNHVE1FeWU3cWN1SnBqV0dOckNPYzFVdnhpRWt5WTJRcFpvakw1OHl0?=
 =?utf-8?B?dGIvMDFVZDFja29nWjcxUmxtTHlHWE5KNE0zbXMzOStGRnRrTkJtbjJBazRZ?=
 =?utf-8?B?TEM3cXFMSXQ5L3AzZU1EN1pULzdmY2tyVjhPdjBQUGxHWWdOb2h6dEZFekZt?=
 =?utf-8?B?ampUODhJbnl0SEFUZCttSk5JdE1iajFhczJiMzlIZkhuVjNhNHdWYTZYaTIx?=
 =?utf-8?B?aENqMDlJdXllQjQ4d3BGWGVPNVVSd3NKeXlpQncwM0YyYlh0UmZBRWhZQnhF?=
 =?utf-8?B?M3A1VHlkZ1M5T3QzWm82V0poUTNhMjFoVXlZb0NWVS9vN2lXVHkwU2c0TkJy?=
 =?utf-8?B?OFgwYWxQNFdacGR4WFk3djZ5VlhPdG9KZ2x5MlArc2pjbGF2bkhSWmZLa2Iw?=
 =?utf-8?Q?jDGSN/H83unH7e71R3Mp9AIh3TslV7N/aYB+q?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbb5742-475a-4b4a-0cd2-08df3f68d801
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 20:26:04.3786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +BeT3kAIZQ5VthLk4xfNq4lx1gpkFRELcxF2fJ3vkI2WVj1Okg1srjJcDq5SFegQvwEAfyiqgZ65p5FTZTEILP7SGFlSL0IMfmNPzxnpFx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB8675

On 2026-11-10 14:47, Juri Lelli wrote:
[...]
> The fix looks right, but I wondered if we can condense a bit the above
> if-else tree. It's essantially doing what task_non_contending() does
> already (special and non-DL tasks checks included)?
>
> What about something like
>
>      if (!task_on_rq_queued(p)) {
>          if (p->dl.dl_non_contending)
>            sub_running_bw(&p->dl, &rq->dl);
>          sub_rq_bw(&p->dl, &rq->dl);
>
>          if (!p->dl.dl_non_contending)
>            task_non_contending(&p->dl, false);
>     }
>
> I ran the same collapse on top of the series and it passed the selftests
> with LOCKDEP w/o warnings.

Good idea, thanks. I checked it against the series, at this patch and
at its end. task_non_contending() makes the same checks, and its two
paths are the two branches I open-coded. Your order also matters:
sub_rq_bw() must come before the clear of the parameters, which sets
dl_bw to 0.

v6 will take your version. Four later patches of the series change that
branch too. In v6, they will change task_non_contending() only.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
