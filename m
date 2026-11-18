Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.115
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795013643;
	b=OEHkh71qfLUz7/LMJsimbmDsuuEG/Jc69xKr4Se7G3UnUamZIokbSK1IMRCyKd2PnAQN
	 hmeQQG3axvl2xjfoRLa4eynd/uWgqVrVkqyaSqLIGCo5j1IESDwJnT/xQjPfCh2Ik6bVC
	 Vy51RFjWsyQx5+VlnJoFMtmOqrWWpyBhUkwgE9akgYOcsGRa5bAcg/vvbj349sxukYGeR
	 uUC7ug1BroExQUz+XjTWYQ8nrca+ElrGCvDmeRPJN3bY8gXY6YeZaMWjd5Z/wV/HuCFvA
	 V6e5wT/3GJgyUi/AEcML01ZrnQkzwAmGWulKGtfeZ2Ii1a7+48EwzHr2B6l8Qh+2jhQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013643;
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
	bh=8FPfOcAdXt2ggEErUMKkioLUQmBr9RqatCRdxuLXbPc=;
	b=0oTOt+v3sP3tnxce3sukjnvlyXbpxIWF3+60VeXQKM5zXXLyJaY42fj/FslmPWTiHin2
	 rC6zdezC3EODt4hEnCEsYM2ug0poz58pb1tK663H5DtsoFnTn5wIyMDUzO6kXUQhyWAO9
	 PT70aHmEkIXW4Ug+N/uOKTXklOhBuchGunDONvBfQAaY4GxsiV+JRK5VhRsBTMSJApWC+
	 m/rW3elY9m0A/wOosWHqFo2g3M7XabnghXMl3fPM3TGClDnC/a7I5LaCvd96xYCIeEZpr
	 FzVhnhPtL40gLf9uLxtJmA+MTaSiBsvgKFCisxpU80cwKPWKQiE5JlPtNuwwM+iVCQQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=YnZAQpxx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.115
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022115.outbound.protection.outlook.com [40.107.193.115])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8C9606A320;
	Wed, 18 Nov 2026 14:54:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E8C9606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=YnZAQpxx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/KAXPnxmE5qqSuUUMu7lSRBxPreYJdFp4C7eQrkH7S0nK/gEH1F9kA6cF1FWrAl10afNFIirIl9kCKiAW0op8SDiTPHmW0adz9o8VdwpUhkQKNL7zxaKLOaCbjT8cbKJeOaCfYERIv4hk9N8Vvz27oYeJ/jGc/+aSwyhNdmmd23idjdfbgc9iNrdUs+p2vdk5Gsnk5jo2YtqriE/ownZ2u1jDJTPnV8RzsRZYwjIPxkaDLElolHAlWMjSdGUDSSGpR5Fyqley+W2cRkVFkrQsV3MFVAe9fmTTW+GrHSOFdMna7Lbbtzrev4t2vq/RO0nkPdeOusOSQ+PoH0LUvxZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FPfOcAdXt2ggEErUMKkioLUQmBr9RqatCRdxuLXbPc=;
 b=GN5Vz9+GPEeJ2/fvEautzUNwWrYJKZYmyERDc0l5jhCh1yvAhNnwKMGIJ1xHIfnq+cEOYN+vuaQAkqbg9uiB5XGETzaMsDTw1hLFqU1bxazJMOftC9jVfkVGWmmHgRdSUGHEc9c0HBnbs+OEFQdLNOiYwcpE7GLrWundXuyAkEcYunuV+MVi9pzr0HomxpMh6i+QD2WhyGCWNKNKfoRGotj0L7YxZNaXwHMeiZ6LIPBnJa4izoj6N4Ir8zzCBZoKTvByCSaA28KuqLh3XQ8+q3hqzoh73QMqQ/CKLgxvNNNcGyTpiKTDEOh4jGrgijgAh0Lr3jJC2+dO+8UU9YDclQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FPfOcAdXt2ggEErUMKkioLUQmBr9RqatCRdxuLXbPc=;
 b=YnZAQpxxFCmobWmSHLiCoUqnJGud7yPlypT2nuvrGwNtxZPH49HOLBFpzebF/M+Dk8N7noTeZGv+f2lKbbLowzsWmB+1L92iG5k7n7ZJ4qyFCySVphDYYvrYpsI1L1ZDnmPg7gqq8klBYOTWceDBC2514qS7ZXZG+JNh6vQa2fBFJyw9F+GZymvy05lAZ5vS/odrCPHJ5Y23Qc+PTu4LW37T3KwpYBJ7EuMdBICMW9VRLfcc/JFI49qds0mzEzqfKoa5YMvihNx0v177bjZRsMS0LaH+xC3u2FuVBZAMXavYWDCqMbJDzDCR+E7WBQ6mGyo78nvWsBVZUX5ih7nHyw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT3PR01MB8482.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:9f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 14:53:59 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 14:53:59 +0000
Message-ID: <ee5cf128-9563-470b-9bf8-2189c7130223@efficios.com>
Date: Wed, 18 Nov 2026 09:53:58 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/40] rtmutex: Continue the chain walk when a waiter's
 deadline donor changes
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
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
 <c8b228501d8981454f63843b394019fefd4002f3.1794922146.git.mathieu.desnoyers@efficios.com>
 <av215SnBF5GShg0J@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <av215SnBF5GShg0J@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR01CA0153.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::15) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT3PR01MB8482:EE_
X-MS-Office365-Filtering-Correlation-Id: bf6ff0c2-b9c4-4356-853f-08df4583c757
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|261022075727099003|10067099003|5023799004|56012099006|4143699003|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261026121527099003|261102123227099003|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	u4as5w7hGhTnZPBabebAR5KjP0TuFTHIljacz0Nyz8pnwqF4I3MKiJGERzLiJBK+PvMosOUZVli92VvZsx0lzB2+PErZHXuzIPQgHWny+sNmU6bbxtpx/Fyjy+DObVSOJUIoBqYuBKS7G1WNyiB6v0oe0+lvYrpPOaKZU/xkenoWMBGIxQHqUSMCEOscuv5uSm/hXeADVtNlQwOCZrQlUpzGVRGJIxhpWHIaz62wHDBNEp/pBGnL7sGJ9hnEuQcBkaTs6BzzaqeeY1bP1J78DW5aY+97Z25RFb+hPv3xHGIACvMKC/D2HyGZIz+BBS4xryiL9mq6Ea8ofEDNdUusd92L+1EJCIRYymYpRpcQk59ERecMULJXGAn2aLj8xFTtxF49Tjkr+akw7r4j3OlYLAIQIcWwjgHWgRue8JjR6lu7px5iusriecUErU2z1QgXZkyelS9LQ5fGietSsARW3jcQpcawwZyZe2NXVHg0fsRpLo6bU+YN9d+27Obtrhhy+UTH2BlYfi9wVU8WrwVcWTWZm5lGNO/R99gUS+c99OT7hvDz2C58/H+6Qm5oZR3oXBKZhzk3i/KofKrcSgH6Hkk8V4ihgmY7J181xBQ8jOY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(261022075727099003)(10067099003)(5023799004)(56012099006)(4143699003)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261102123227099003)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHdLaTdMYXpkR0VORmFlN1NoOUNYdWMrVjRYTjZPSDF2aW9jbzVUc2cvUitk?=
 =?utf-8?B?WlRTSk9qLzhnZFhpQWNJVXpnVXp0cTQyTThvVjE2Z1FDam5uMnRPdC9iMEhu?=
 =?utf-8?B?bzg5TWc4dmFPb1IySGFmVElxYU5zMllqVUhiTEtrZ3JiM3J1TjhLYWFSalpy?=
 =?utf-8?B?K3cyTVZtSEFaUU13R2VSUEhDSXVBSzJ2dUdTdTlpdG43V2w3djVxTE5XSG10?=
 =?utf-8?B?R25qendYQ09UWGNjalBIbTI5WDZPMVRaOTNqMVU5R0dMQWhBSU9HZzRzcFNu?=
 =?utf-8?B?TDQwdFZEN3EvekRwbEhrRm5aT0JlVGZoZ2U2UXJZUVVndXQ1RFRoS2NBMjFz?=
 =?utf-8?B?WVBmT05wWDF3NVlOMmlPN2Mrd05pWkdQNFpiVDRzZDBTMVpIbjdscnYyTnVG?=
 =?utf-8?B?ZUExSGVwWUFZV2N4Q0pMbkc2WCt2UUswdEFPeEZqRTJNRjNKbnpxUVg0c3dr?=
 =?utf-8?B?c0VyN204cXFFUXJmZmZ6QlRtQmdpOHovWFhuZFdyVk5mdkxoVklNTDZUb3lV?=
 =?utf-8?B?VzdmYXBDenlIOENac0NPTE5XVHN0ZEg1V2t6U01INXpvNjRNUmd1TE5ER0Vi?=
 =?utf-8?B?T0syWXovVlBNcFU1TTJIYmVyM0MyblZPVlZZRlNxYXQvdERmVlBxUEZ4M21h?=
 =?utf-8?B?Rm1TMFpTbTZ5LzJ5RzlhUmhCeHNhaStTb291Z0thMWVnczZZUUFkL2JRNy9E?=
 =?utf-8?B?N29oTzNMOHpYK3hLNWZ6TCt1Q0dyV2ozQjV6dXNPL1NPQWRyZS9NaEhsUEk5?=
 =?utf-8?B?TkpEOW1uRjdEYjRRbUpwYXlMNEhmRTVVTkw4eUR4MnBtZUxTL2hoNmFmanlI?=
 =?utf-8?B?eWZVU21wSmoxWjBQRlRBeGo1TnUrbDB6Zyt6d01VbUVISFNMcEFmcjZZWnMx?=
 =?utf-8?B?VDVzTTVjb0tYOWlvek4xQ3l3amxoblpJeTFHRk5WTFVVRzhtY3N4ZS9EVGF1?=
 =?utf-8?B?QVZHTHNoVVV4NWRHMmhramZqK3JjNXBXNXA3OE16WklveDI4UWdJSnFTZ2hP?=
 =?utf-8?B?TlJ0eXRFK3NVdmYwYkRWRVdSdUIyT1lBeFRuQS9YOHQ1cG9wN3RGU05ubG1Y?=
 =?utf-8?B?WksxTG04SkZ4Y001Z1RxTU9VRCt1bkoxc2JoQzNPZ0Z5R3ZkMmYwNytOaXZU?=
 =?utf-8?B?S1B4MDc1ZklJT29KKzNBQ1MxRWRKNXIrREp1aTRROWRydkNJczFkRnNncmpH?=
 =?utf-8?B?QnNHREM5eUVwTzFHZTJkWmtsVTliOXdaOTR3dTVzd0VDRHdlWG1jblpQMmI3?=
 =?utf-8?B?WjR6ZzRVSTJZZU1Sc3Y1Mk1HUFAvUXBiZkE2aFN6YXhhY3RJakhDdmkwdDJ3?=
 =?utf-8?B?SWtac3ZuRnFOR1cxc0V5c2VMWGVZZWxSaElHbkZIWnBRdzVucUFnOEF3UU5h?=
 =?utf-8?B?MTNDQ1FzZmJLaDI2MTAwbHBkcTY0RWVKVHYrZHU5K05hczhjZXRqdDhJVms3?=
 =?utf-8?B?VGcwNGtTZG1uaGJ3RDBtenpNcUVBTGk2ZXRhL1kvdzVNYzRmOXVncklKWGlW?=
 =?utf-8?B?aVp1bzBlVWVPdDh3WlJIVUxMOXh5S1FVYmpPRkZPOUt1WDJpQmhKRUtGWWF5?=
 =?utf-8?B?VFZSUzlDOXprNUR0QzR3cENyd3Y2a0VjekpwNENtVXhxcGoySVBxVlI4ZWs4?=
 =?utf-8?B?Z0kySGVMc1pQL2JyTDNpYmhPWnJKdlJJZHpXaVhHblZCeEdkK1M5R09ubHNs?=
 =?utf-8?B?TFVwVnFNTGFDUmJwNWxFVU5NTCtMNjhVZ1c1aEN0d29JRk9OSWtkaUc4K0FO?=
 =?utf-8?B?dk9aU2JVZDFXb1gzNXl5dHZrRzNnU3dvbm52ek9EMjVMTnBxVU5uSS9tS1Ev?=
 =?utf-8?B?OFlmdlVQanhoY1lvV1ZLQVVuMDcwOVYyaEpLNm1FRnkvVVp0ZytNOFRkaXZa?=
 =?utf-8?B?L1BQQTMxQ0x2VEFaR0wvbzBKWjh1YlV2NjM0QndDTjQ2U2pjcldrdm1PTkw4?=
 =?utf-8?B?ZXRXRHpQMlhBbGRBTHYxU2xIZ2FuU0s1ditVaTRGNE5XK3RlQWlCV1JXTTg4?=
 =?utf-8?B?d1kxOEhnMHhYZDRPZm14OXVUMldFT3hBNDczdy9BWmhucjYwd1oxRUU2cFp1?=
 =?utf-8?B?ZmF0Qm9xRUF4S0N3UmU3NE51bzJsbVZuK3VaR28rMDd6VWtFVi83RjhJbjR6?=
 =?utf-8?B?bDBocjlkaHZOZktkMld5ZzVlQUUrQjJGZFZJWVgvUjVvZkJaVmM4RDhmbkdV?=
 =?utf-8?B?Nkt1eGw0azJHVG9WTG1yU2paalk1T3VXSDVQbjdzRWFIcVZLK3hFWE85NjFz?=
 =?utf-8?B?cjhyYUpqcG1NNk84V1dKb3Bnc3FDTlByNElYb3lDUFc5WGgrdHAvdUJjT0VE?=
 =?utf-8?B?SDVoYzVrczF4aHlCdngzQm1PZUFGd0Jqa09hTnN5eFRjV0l4RXBrQzRldExt?=
 =?utf-8?Q?xpSptXVPdRavBFDSyCc9tUxqi0UvxixUwUbeG?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6ff0c2-b9c4-4356-853f-08df4583c757
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 14:53:59.8136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rWx7Sel552IlfrbfqQRUSMq667oByyIP7bmP/H5+KOr0HhzJgGhRzCf1/TiTgbo0at5yojjrZ9TqzHew4Cw6Lvgft/TJrzMmt1qbxYCRqqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB8482

On 18/11/26 15:27, Juri Lelli wrote:
> So I have to
> wonder (and ask for Peter, Thomas, etc opinion) if we'd rather not keep
> extending the chain walk for DEADLINE PI, which is known broken and
> proxy execution is going to replace anyway, and leave rtmutex.c alone.
>
> It looks like what we lack is memory safety, apart from accurate PI.
> It's an hack after another, but how about having the owner pin its donor
> instead: take a reference on the task behind dl.pi_se whenever it is set
> to another task's entity, and drop it when pi_se changes
> (rt_mutex_setprio() and __setscheduler_dl_pi() are the only writers).

I like it. It closes the use after free in every case, also the window
that no change to the walk can close. I checked two points in the code.

The writers: rt_mutex_setprio() and __setscheduler_dl_pi() set pi_se to
a donor. dl_drop_boost() resets it to the task's own entity.
dl_deboost() calls it. One helper can do all of them: drop the reference
on the old donor, take one on the new one. The task behind pi_se is the
owner of that entity, which can be a donor further up the chain. A task
that exits while boosted needs its reference dropped too.

The locks: these writers hold the rq lock. put_task_struct() is safe
there. It frees the task through call_rcu(), also on PREEMPT_RT.

Then patch 9 is no longer needed for memory safety. I would drop it.
The owner keeps running on a stale donor until the next walk, as today.

The new patch after this one in the planned next version is a different
case. Its subject is "rtmutex: Continue the walk when the owner's top
waiter changes lock". It fixes a bug of RT priorities from 2006: an
owner stays boosted to the priority of a waiter that left the chain.
pi_chain_top_moves_rt shows it without any deadline task. I would keep
it, Cc'd to the locking maintainers, or send it on its own.

I will wait for Peter's and Thomas' opinion before I change the series.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
