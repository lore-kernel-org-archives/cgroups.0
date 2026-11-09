Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.122
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794241799;
	b=BEhutH4eOdus/J7EtZlDhcNgVuT/oXL6TrZ+fuRCS9SBrexQMRz6lSkswT/SQfDefIyf
	 SNsn60RihIt8hBeTnFZPefg7T57xNkxkpGvFnqzXHMpVI5M+u6XEu6uUY0H8GbBgClwkG
	 3S8sCVHs34Du4b0PnQF6YdR4nxLb3qk2ObHn3bv9y2nJJe3LnBQ4BzlqjmCBZpAH9Ue32
	 o591rXFxmM3LBzITCFuT8TdfcNCntuGZrlrLBlCblgw4G9FZH2ja8QqN8NSTgTgjwe9A7
	 Xid7L4dVo2P7jPnhwG6pGXAxlv56sOGa3L1e5s0R14O+EPgIEMhGnYZiGPXZGSMdMyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794241799;
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
	bh=86jltWKvVHrprA1wJbGYw5Fgl0ExT4bwVfOE72AwHLo=;
	b=dGULKQN8pwYugZPxo5SrWxS/OcC7zVzAKfYSmlgPo3EY+uDosEgT8cajBc4PMDl7oM5O
	 37Sjv2kjYMX3lSE9bk9v8KIdDtyWwgF2Fkq9himS1jdFzMrhhZ89aQMwBC3FnszYg4NhA
	 aFqVNy6laLwNO0pDqBNt/eAsGQKBcUKQpmhYTDeI3xubgFzAkVMe+H2V6PC+fyKheOsBT
	 u4I5PPB6S0KgOTFITqxqNoIGP9Y4zo7USOAArOFbiLGjjiZbEX3Acvw6encnhw11cYI3x
	 uyVkIUOOptHW8XOPC1JJYfUCTVtI2OzesnK/vEdVQOhA4Ej2f5wMqdXjoUtdCMy8Bng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b="Q1/8cShP";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.122
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020122.outbound.protection.outlook.com [52.101.189.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF59606A321;
	Mon,  9 Nov 2026 16:29:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EF59606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Q1/8cShP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPBIzOo6X+yU+QuT5i1z65KuhGxOVdhJzyBkImTdJlA2K9j1tf/QUX7TikMg8KOqxA50E9D+Cnh17t64NhczjP5hYLCi4an+DLODoPk7LuW0BxF76DVXFR/jjhBv9RMd9gxOq6yNteSNSKAw1dRH52g9YPiRp3oxkitXB/LjYUK3mxcNeVdvGaXs/vNCPTeXLnAOi74Ak41WTcXfn27KNz2UgFQRvL58pUM1iioBReeY1BMzTxymc7bnowQ2L4xvfP3EeB0e7tuqbyyhyFoUYqdoX2mdZncl3Cej0vV7t/xtwiaBZWf3nzhC3GlMJYhS7np7e93XGyFLfCulvulB+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86jltWKvVHrprA1wJbGYw5Fgl0ExT4bwVfOE72AwHLo=;
 b=GyX9ECfQ57G/Rl25pVwddLtdKFifl1C4MvvkqEr0ie7gIGtuTqTYe53ZkEiCJI6l3JbyrgIMUPHwwVGhHgOoucodfgyu0Kewd/7hx5hVZ6fpwm/2RyY0yH4mnUQuucQ7h2dHDFfJ+dHFS+5iIArRbv+NYJjABCx9uU3QCj+j3MeYKsnq5E3/CBqhieZuFzVsyqJRRk33juO4MZze2dAWHSTVGZdMyX9rJV5RmBn8ICgdum/sIptcLZkSmtL8BBc8cjHEYDvYvXV3obL1F//R51NUxMUu3NFy+00nMTSnUsmyML32Ci0f05x3qPsPLdUqWkDcpXOx+pEjnJiJx4auQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86jltWKvVHrprA1wJbGYw5Fgl0ExT4bwVfOE72AwHLo=;
 b=Q1/8cShPJltCuWTOmQ45OZrw1RYtqwEzEDRXeTWyYJL3AIJUgkMk9F5VizuwYl2vlEeIw02MCJylis6/qPuFI7Uhf6AiEXJvefvUc31fM7wzKlcUQYv+hyFgNjEJBZth4G2nDLNRB52fCJJQMukLdtyMrc6+G0lanRYUXHLvmlwsKAQwRxcFTZrLK/605kuCCMb5Dm/H5jcm3t9W5U7dNzj5hUWLzsEX6h5OTuW8z0Ry0bcxDIi/tnoSWfp39FAfGSJx3h8eslZt/AyF7EwSBv1EOfM6AVmTWLhkSqxs9C0LQzQbhvLinB7Li0xJVdZEw5LEtNA6ikAq0Yj7eDvX7g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT1PPF825E3514F.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b08::559) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 16:29:53 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 16:29:53 +0000
Message-ID: <c5a408b8-1388-4dcf-bfa6-bc987ce83fae@efficios.com>
Date: Mon, 9 Nov 2026 11:29:51 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/29] sched/deadline: Do not lose a throttled task
 switched out and back
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
 <20261108185406.1549770-8-mathieu.desnoyers@efficios.com>
 <avHvPjz4dL0zNyGb@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avHvPjz4dL0zNyGb@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0455.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::25) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT1PPF825E3514F:EE_
X-MS-Office365-Filtering-Correlation-Id: 915755a8-3004-4bc4-b1d7-08df3e7eaec5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|6133799003|10067099003|3023799007|4143699003|5023799004|261028144727099003|261102123227099003|261022105027099003|56012099006|261021121427099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	p5aQOjqZsJHSGkh8MDJQtYir/wIOowLmFa3zAtuBL3DyntMyCNgKw16LzqUPJqU6gNcC3sYE9DqF34iwdih0vCLrc+3oo6wS8KIG5OPvH+SIzN6HaMTO9UYXrzIzGMOD7gFW+BbjkMb8UWWurzXLKGxmvv3KvwIHsUC7srXlmNBiWwyYuoUb7KxC8rK2vIxkKEfGelAvWEcJ5P39cc6VWvZchqt6rGZrmHWyGXJ3Vqj25HGBxXI8VdDuYjmfhJJrwQk4cQBBtc3WVrxl5Bf8AtT+L2bH2Muf0b9WxPY1Xz/8YSLfPh+Ji8Idd2mCMUUOVKwJg2XrzGiAzuxZ/wKM0LuO0R90Pwea2n9XHlF3iZBww8JiwuP6ZY8h1T2bf2Fs7we5QdzdibtBeH45IX7IGTNrTyif8Lsfi4sRTg4JJ4BcNFS8Jhd47vRDTo0pPHjD4vN3/k9ZITM7U2ksXQmvAMqkTq/Icjn0z1/mFyoukkngedLDRVd7RxjFCStRHXbNeVF8IcvGZX4aEecbV7gkW5UWVbr9lk5kXImRFa4J0yuZaxbXC0PHb7epX2VTQrAANHOS+K9/4pIQdkFYrcAkggRVcHd6XbN5Pqo4BLSZkj8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(6133799003)(10067099003)(3023799007)(4143699003)(5023799004)(261028144727099003)(261102123227099003)(261022105027099003)(56012099006)(261021121427099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGk1SDhJZmZuTnBtQ2srK2RoQy9iNEhyMmJCcld2MzdERjRqRWhtb05iTHhY?=
 =?utf-8?B?b29vNjYxQ3pLWDgzaDNkVTdHdWRBcUJnSzhYajdvaFFYbGpjK2Q0VDI0TXp2?=
 =?utf-8?B?em5lRHRObC9CMnJONTREL240Q211SHFFbm8ySlpRY3NZODA0a29uaDJ5ajRj?=
 =?utf-8?B?VVNYd0w5a2RKK3FrNXJqbUdsNnEzMTNkVDhXVU9NWExFeVRtMXR2Z3lRdXd6?=
 =?utf-8?B?V3RHU2RyZE1DcmdLNEg0cFgxVm52T3AwczNCQk94bi8rWkZZMEdFQTV1eC81?=
 =?utf-8?B?V3Zvak5ZWXpGUGZyd3dqQy9rRmg4aUtpY2dTN0xpdkJIL0FmSEU2dnBlVmN2?=
 =?utf-8?B?TVlrbisxUWp6Yk9VNElVTS9XcWw5ekx2b3M1RVk0SHJQRTJFMVpkazlkaFRa?=
 =?utf-8?B?L2lvQ1E4ekZQbHZybG1pdFA5QlVKZFZMSWIwQjlnV3lZZVUzU0loQi9IUHor?=
 =?utf-8?B?KzVZQWNNVkpPRE1mVVlwRnR3amV2anZjM1hqVDJiSW42aUtVUWhPUFp2dzB3?=
 =?utf-8?B?TEVISExRRFJaSlBhZDJ3S2IrZlFKei9FanRpQTlwSVRZaVB1K1hXelh1RUxI?=
 =?utf-8?B?TXJoV1JUeXRybWtMMDcxS0RYTk1zYWpmak1ZSjBSQmZ5OTdtYnhIa2tGRU9W?=
 =?utf-8?B?ODB5aEIrbllhY0JxdVVhM2prckM3dE9Dd3dnQVFlc0txb0lLUEpvT3A0a0Ra?=
 =?utf-8?B?TVQ0MDlPWHpsc2M3UU9tTURWa0FoeDRHL2dkaUk4SWwzYUdrSzliUkt6ZmJk?=
 =?utf-8?B?dXlsWS9PQnEzd0hEdlBxVmtwWXA4SzNzZnpodFgrVVZHMmRBV3dtMmlWMWhr?=
 =?utf-8?B?QTF4ei8yd3BxODcwdFlESFU2TjFkc09XZm9Ha3Fic21qUnpQeE8yMGUwWTJI?=
 =?utf-8?B?U0FsQXhXVFhIanoyZmNEK3QrTmJxME8xME45VVRlaCtmVFJsK2VTbys1Zm9q?=
 =?utf-8?B?bWdweWJKY2NjN0E4TEZOaitnbU45Z09kek1rOW1ycURxVm5tRFdqNHR6R2ZW?=
 =?utf-8?B?NU5yb3c2alVPekJ3ZE42MExLV0hRRnpwNjlwbmpoc0pyRlllQ05RSXRINHdL?=
 =?utf-8?B?bytnVHJ2VE1sSjFIM3h4bWczWW53KzIveEtVUW8rN2ZnQjZYMGE0QUNkajZq?=
 =?utf-8?B?bXFuNW53V0tlR2VES252SmYwYU9YNmNldEh5WVpCSnhZbE5mVlpTbm1QUWt4?=
 =?utf-8?B?Q0tvQ2tpVDVFN1pKb1ZWSW8wbS9WVmpySitDb1loM0RVWkdNYU5ZSnZjYXV2?=
 =?utf-8?B?eVhiN2pjclRNTm54UytXSEY4Y2dLVTZlQ0JnalVGM2FFS3Y1MFk1MXljdSsv?=
 =?utf-8?B?ZlpsdDZkMHovUnM4QTMrdGZCaFhBenJkUEI0Szk5UkJIYWZOY21nNVFISjdv?=
 =?utf-8?B?enFOR1oxMUUwY25oNFJubHM2RGpON1RDcGg0VG0xUTR6azZsOUN0eHByZVc5?=
 =?utf-8?B?WTFmN3ArNHBhaVNmWHpGcDltSXZGRlBZM3VPb09KWjBPWXM0Y2xQZEZ2Mk9J?=
 =?utf-8?B?dmFXTDRHdnhpN1VGdnpZZFZnNGtUZytzMnVOV0NwOVVxZFpjRlF2b29vVm1H?=
 =?utf-8?B?RysyckFJNisrTlErMlNrb3dRcHpiZUMySjd0eFY2UVRLS2lML1Z0WUpONmEx?=
 =?utf-8?B?M1Q1K3QxZTVuckQvZm82WUZsRmxhdFQ4ZDNkVGtYcXVxKzZIM0FvVjdzOFlQ?=
 =?utf-8?B?THFzVVRyUDdheGFjL0l5VWU3WnU2bmUzMzdYNlRmRHF0ZHNJWTB5cUd2VHV6?=
 =?utf-8?B?TnRHNlFGOVQwZExGMFVVVXozK0grZTRlM051amFGTEg0amJyUGg5UUJPQWxB?=
 =?utf-8?B?Y1IyVzRLdmxwOG5EUmxmRGU5RUE4WGhDeW1acDc1dmJtRUYxcCtNcWdlNGFo?=
 =?utf-8?B?VFgyOGlSUzFhMlBmV2VKam1KbnJsalFaZTRRVlFuZitQbzF2NVpEbklMcGJN?=
 =?utf-8?B?MXg0LzdYMzU5MzNxU2NITkxPZFVBR1htV205U056K3YxdWhublFCSEVZT3lS?=
 =?utf-8?B?TUYyU3hNbVI2d0NQbjh2YzlNS20wTFJqQUM2SkxZdnpPUWhXZ01oYkEydjBy?=
 =?utf-8?B?cVNyZDlHa2trMDFsZFloeUZ6Y2hQeFFtbWMvTFZ6WDBreEVkZUFjcldvc3dM?=
 =?utf-8?B?MjZIbjZJOTlwYnpRRWhlaWJPSFN5eDIwUzFVN1MvQ01oY0RZWFBPR3NNUHMw?=
 =?utf-8?B?eFNmd2g1M0gvK25TcmtLdlNUR3Bhd0ZLK0E1NUNXcGdxRjA3cDdlNXppaElS?=
 =?utf-8?B?ZytEYWZSUCtVdFQ5WGVKZXFlS0tYU1BLclNqRGR5WXB4SzF1dWk5Q2hMenpt?=
 =?utf-8?B?VHZDQlNBMUJIcnhIREhBeS9iMzBPVUtPRFZTVFVNeW42b3lrbHJ6V25zZUE5?=
 =?utf-8?Q?Y0STZ0ZhiXyftoAw=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 915755a8-3004-4bc4-b1d7-08df3e7eaec5
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 16:29:52.9919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TTgHm8idJuuOJuQxRwWbrWDvv2blW4fOrq/jjlhRINg0jBpw4xHTbIX24ufTQpi/DW8MSQ9WIjCeCSHM8lQNwVnpGXvNamsTuE14AYL7MKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PPF825E3514F

On 2026-11-09 11:05, Juri Lelli wrote:
> Hello,
> 
> On 08/11/26 13:53, Mathieu Desnoyers wrote:
>> A SCHED_DEADLINE task can be throttled, switched to another policy, and
>> switched back before its 0-lag time. It may then never run again, not
>> even to die of a fatal signal.
>>
>> A task that leaves SCHED_DEADLINE keeps its parameters until its 0-lag
>> time, so that leaving and coming back gains nothing. Commit 209a0cbda7a0
>> ("sched/deadline: Improve the tracking of active utilization") moved
>> their reset from the replenishment timer to the inactive timer, which
>> switched_to_dl() cancels.
>>
>> This misses a task that was throttled when it left. An overrun can put
>> its 0-lag time after its replenishment timer. That timer fires while
>> the task is out of the class, and does nothing. On the return of the
>> task, enqueue_dl_entity() leaves it to that timer, which has fired. The
>> task is then on no dl_rq, with no timer pending, until it leaves
>> SCHED_DEADLINE again.
>>
>> Fix this by replenishing the task when the timer finds it out of the
>> class, as for a throttled task that is not queued. Its return then
>> enqueues it.
>>
>> Clearing dl_throttled alone would not do. It would forgive the overrun.
>> A yield left set, or the old deadline of a constrained task, would
>> throttle the task again. The Sashiko AI review of the first posting
>> found this in the first version of this patch.
>>
>> A cgroup selftest under development hung on this bug about once in
>> 1350 runs. The throttled_round_trip case of deadline_switch_test, added
>> later in this series, fails 8 times out of 8 on v7.3 and v7.4-rc1. It
>> passes with this patch.
>>
>> Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> ---
> 
> this still fixes the hang, so my v2 comment stands: take it, and keep
> working the potential additional re-entry corners separately.
> 
> Acked-by: Juri Lelli <juri.lelli@redhat.com>

Noted, thanks!

> 
> Still have to review them properly, but between 09/29 and 24/29 I
> believe every return at or after the 0-lag time is now covered, that was
> the bulk of what I was "seeing more of" in my v2 review.
> 
> What I think is still open is the other half: a return before the 0-lag
> time, with different parameters, where the budget carried over from the
> old reservation is never validated against the new one. IIUC that can
> only buy a task one instance past its new admission (it converges at the
> next replenishment), so it should not block this series and we can
> discuss separately/later on. Just mentioning here so that I hopefully
> don't forget.

Your insight points to a coverage hole in my proposed test cases (last
patches of the series). Let's see if I can improve coverage there.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
