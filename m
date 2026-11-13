Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.85
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794576997;
	b=Na5ewrPMG+4fBm81DVBUJfWZ3OzpOVu7DLbMHtwXN3TWlLwN9/TfwUgNKIXkNiqprIzJ
	 1ghHDCnX6rJNkUHs33jORk+2o4PJXl1VO0B4bpWK5oztWFcN7+DPE5C4esTjRv9u9+zmx
	 rIPlJRf0uZWLrbfbj0JpVxgd+Ve+CPVgC1+rsRULY+WZKe7caIwy6gx0GgxnkMsUW44Gv
	 TX1JqZnWCcSrkzxtR//SHCPKnd65Y+TSQzj3yYLzdaAgYls4pa7gZxBST3OTBPdTuhPH7
	 FNx+DWq0VSJlRQI1YKAeoTuQh4g9IKRSb23HVgXp6DfkJgVVF1Nr8B6mIs0+mYXKkRA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794576997;
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
	bh=jNYeCJbttj4YzQ0q8nMt9Kmch7p/dEHLKDmR6U7CdF0=;
	b=QQm2HJTYOEPVBqGkR9H23yx4V5l6riiBCFE8Xv2Zb7QRIBqt0WDRZ4rdqpHJu9mPZeRH
	 l0mqhrQs+go4JI7lpPVCOytYfeY3n0efsEDcw9xwRf/OXufbO8t7QXe+Di1Czc8Nd9S5f
	 pCmA0Z4pX+EziFwXQhzGE39sGinVmqsl+XMi9aNRhBRjT2BMzwq0mNuxpZLhWMcutrx+H
	 jQO6o3LHO4/rV8Ge+Y/dABxYZpmtWCy6/xChajG2RHSR4HUkpI3ahAKSAw1WMiOrzQnhw
	 VxavNjKaef0+5+6PGBA25BvPGOTeA2Xgj+iox5jTQWfVqxjNLbQvsRFb9eJadFk8BJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=cOZX2MbE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.85
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020085.outbound.protection.outlook.com [52.101.191.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9202606A330;
	Fri, 13 Nov 2026 13:36:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9202606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=cOZX2MbE
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJN6FEcgBHysLJ/SQK7x/Ot1g2TQDjALtukR52wyeGhdnTJBJVRozDl4iCATGYyV/2UFIIWJINVkTkzGVayXAJ19b+lx6EGqSHaWBtkd0yINKQSpW+ia3/H2uqUQJPyuDqcxRsLFxQ8N8kXvtKBeQQjPbsoqunb0VsPfNoaSVOw5LdVGOabMqUZpNO69YaSHaTaVcGuWQ+cCsaxAkIJQDWAmpVNUuQ+TTwdXO3DnmbmJG/sYH6qScea/K6Tuqm5pCXLtgObJkuzYTPMwNZi7P5SbHwU4AKTvG2ogGzmi4LTRrAXClh4Yeo/SLXkHGhhCw4RY9KLXUkKZkN53JdzYiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNYeCJbttj4YzQ0q8nMt9Kmch7p/dEHLKDmR6U7CdF0=;
 b=VCW32cfuUGBbXLlB2AMjddypT7fHeyF5DLcee+8uN9hhxrIzKhzY4STwDAv7kVgIH7We+iidUIAlT7ZN7WB3G6IKGKBu82gGqyYhpsET0me/EaOC9eQUd7gxY3XQZqO6SoXtlGqm9X9UduGnrN+llwbu3iKDPUpkUn3aYUBnHfSkvzYwDVYWNO6rgOTxZy/1BOzOl7l7U84GyRgu2YcVWaM0xFZ5CmWf1/lfpE7CoT5Jq6W9mXzdw2JXXgO8nfV7kVaVbnXOAXy1/DGyJXwZ47ThkzxjCCLDj4N66dDWZNdl1jG2T+ANoNUlS2vVvKMBmzohEyIvWwfudNbNoMRM3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNYeCJbttj4YzQ0q8nMt9Kmch7p/dEHLKDmR6U7CdF0=;
 b=cOZX2MbEEPnAq2KYoi+Axs5RbxoMFBk7wCOrsKCGVdkDykskU6vt+fyRfAAl85jj3XD/fWIRhRFiR/Bt3fMPw+5DUr8LIvl6Cy1G7c8ljEdvwL465CfHoN3AVjAP2tXLuBekOr40rDbVnNgDP8OnhF/iEpGu5jxBpxRlNmDVZvPVjKcntLVTHHWnhozDfxcWiX5s65U1dHJkkxb8ltd+1HQ9utNYepiYqGxeNZTGomfQ09RfFd2BSKhjgA9YEOCcv/yue8bCptK6G18AxEhV5ZXzsG77Xjk4ytljZlY0n5FLYC8DBWqdsGJhbvXz9RVSnjav615v7IxeLKEbkaMSVw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQBPR01MB11116.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:98::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 13:36:32 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 13:36:32 +0000
Message-ID: <bcf6f03a-d596-4afc-9d3f-54219935bc2c@efficios.com>
Date: Fri, 13 Nov 2026 08:36:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 26/29] sched/debug: Show the deadline bandwidth of each
 runqueue
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
 linux-rt-devel@lists.linux.dev
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-27-mathieu.desnoyers@efficios.com>
 <avWWlEGGqVPYkuZw@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avWWlEGGqVPYkuZw@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0464.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::21) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQBPR01MB11116:EE_
X-MS-Office365-Filtering-Correlation-Id: d21d94a5-5947-460a-a48b-08df418b2152
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|18002099003|22082099003|6133799003|261009223027099003|56012099006|10067099003|4143699003|261102123227099003|261026121527099003|261022075727099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	U5tLb9zvZEeCUJJ5EBwsppDRe6rz43moRufIGo/0YHHL+HXfRZnUYMdR+05jt+ZMFqcukVNS0CIn+EPlRPY59rUFPL2PB8UG2teSzxq3pDHWRAY38Eo0vpPrGHLBPNUKmtS9pa2JTEmIxWYNYUBfK7UnaCj9ZzrDatmNru7hl6tFpU5bPSnYhcCXjo+xw22mzM3lc/7MRMhUuEn307cn6TcjioCzA6PanY846VftBo/b004BW8gdrtxQg5EuV19cmfyqT5IxYO8wSrDOhbayZkN4KD/tbcfLpXL2T/Jwuf8m0xC1FwPCpc21Vv9aZM0R/gh5flCSxSl3SncJF7yrVJjF1pgJFtng3Ck5gQjksxs8N4X6it8zxBZH17g8fl+IKpzZi/+aIN90ZQhtO6i2HjWOH0F6bOD+z7FLGvT81w+9I3AcXPDS2t38QSeXbpS4Y15pvzqbZA1mw9zo5ZE+f1afuv6FZWeWhqLzWCMocqLR36UkWH/TQvAlxi8c9Yx0VVqg5+QBSBxWdDq3DMK/vZMoJyWsE4lknyYcAx5eHI4en1KGoeSA6priBFvDioBF6RLsBMDUkzXwWb46yR5rpstsiz7j8/roWN6bq+hUyRs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(18002099003)(22082099003)(6133799003)(261009223027099003)(56012099006)(10067099003)(4143699003)(261102123227099003)(261026121527099003)(261022075727099003)(261021121427099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFQ2MTNOOU81cmdaajcydVVWSjZGY083RjIwb1RUbE5aSktmRTZnYXp4Z2Fn?=
 =?utf-8?B?czNhL2FpUlJCTEpVT3JOY1ExbkRBKzUyVXpuWHpnZDhRbGVEZThUeU0xY1l5?=
 =?utf-8?B?c3NBd3BoMFpRZE9pOENSeld6a00zZ05nUUh0MStrK0wwTytMUUZPRnpndTBu?=
 =?utf-8?B?MXhXMk5VYXRvYlovUkw3QisxY0ZsWHVZd0ltdStCVWE3WFJNcllSZ3pxTXZT?=
 =?utf-8?B?Ukg2MTBXaXNTKy96Sk81RzBib1Z4YkxPdytjZXNYM3ZETlBjdUhML3JaYUFO?=
 =?utf-8?B?V1pQaStTS3kyMnFkVkdTK0dkZjZ2YlU1ZjUwNXp4bDA0YVZmcllIMjNneG4r?=
 =?utf-8?B?SGo0VTFKNjQ5MzdvRXVyb0JUdEdqZWZuVlRkY1hRakpWT05yaVhiT1dMUld4?=
 =?utf-8?B?Tm1RQUtvS0QxU2FXMEtwT3hOeGNqSlhERUdNb1NPdnNZc2t5Tkd2dDBCRGc4?=
 =?utf-8?B?NEthWEphWE4vTk5QU3oxRFAzelVnNDNsSnMrWWdKN0doWk1ZeVpNbGhaSTRP?=
 =?utf-8?B?Wk1UT3g0Zys1YTdYUzdpcTB3NERkSk9iTUd4WkN5MXpwVERFOHEzSVJJVHRi?=
 =?utf-8?B?QndseEFockVCd3JwZjJIeVhkRk5iY1ZhalN2dVVmbzlMSTNrQXhicUZ4eU9V?=
 =?utf-8?B?dDlXdEJMVEJpell2RkFQUWNwRzZYNmlsbmh2YzgxQVdTZ1hIZkFwWUVEbWJN?=
 =?utf-8?B?aWNkMzcveU9QV0djdFFPaGtUUEN4cnZySTZJTDVDZkdEdUxIMi91KzZSQzBh?=
 =?utf-8?B?TXdoTUszait4aElkdmVrZUowZ0xxS05NV2RLd0xTN09qNEZiVitLT1p4Qm9r?=
 =?utf-8?B?dXhESWQrL1hLRUhheGI0UEZaTDZEeUlSUW5RbzJoYTR2bko3UU1IWkh2cnJ6?=
 =?utf-8?B?NDV2MVFwWG94WE82aGZuMmJkSnBNV0N1ZmovTWpOY29tVEJKNDRjWFhJZFFv?=
 =?utf-8?B?czlRMlNqUyt0VFo2bFVncU5MeUZmUGRHN2RiWElTQmtSVTZxdFVrUUhjdW94?=
 =?utf-8?B?bFhYN1JidFdlVWJiZkNBVFB1emEyaTlPd2M5UGN0MWEwell0WVJNa0pCT0tV?=
 =?utf-8?B?SjBVK3VnS0l4Q3Nyb0YvU05PZzh6Mi9jMFo4WXVEc08ySUFmNnZDSGZJU2JT?=
 =?utf-8?B?YVcxaGdZZmh6WDBzSWp4U2FsUkxPVlpMdG50V05zNkZ4Y0RWKzJ2SmRPeFgw?=
 =?utf-8?B?MDNUTHQwNHBhUFYwUktLT0gzK3lUczJ2eWQwWWo0d0xKNVRyck01OWd0Vkla?=
 =?utf-8?B?YjJERzBHeTZUaHVGUkhXOXB2Si96MzY3ZWtWa0pqdUVkQjFnZllRRFlaVDhM?=
 =?utf-8?B?L2RlWURMWlBHWiszdTBac3crS3dJbForaTJmaHlvMzI4NVRWNDdPYzE4UlpX?=
 =?utf-8?B?OHBVMEh1WFJvanh0QlByTE5Kb0IyeHlLdytnTnhaZVNSKytyejJyRU0vd1V6?=
 =?utf-8?B?UVI1QTMwMWlsOTMvUGhRREllNkZ4TWNaL2NtM0JVYlY1dEhVQWwzRzBJT3JK?=
 =?utf-8?B?Nm1xaUZFMHBXK0YrNTdDRFZlTERnVnVJYjZ3dkNFWTdaMnRkQ3FPWG5xOERC?=
 =?utf-8?B?RE1lTDR1SVEvNWJNMGFOWXd4eG9SVDdNdEhXSHE3V05xRkV3M3RscFplWWhP?=
 =?utf-8?B?UUswNlVtMTQrcWVOQ2c5U05WTUxCNzcyazIrYitlZXU3Um9kNkpQTlJVRW1V?=
 =?utf-8?B?UmthL2RWZ3JjUnJhZkM4QkVOWWNtMy9LS2RwMDVEc0FmN0NZUDZ0bytINjdi?=
 =?utf-8?B?MFI1L3l0dTlUem1IYTlxUGZKVlVVSnJKL2NlbWZ1SGo1NXdpZTJGUDJKemlj?=
 =?utf-8?B?TkQvaVFseTg5YzNoN0tLejVSOGk1b2RsdldjS21uMC9ndXMrQ2ZEYU8rWFZt?=
 =?utf-8?B?SC9UeEVmdGUxNUJKWVVTTGU3cXdldnU4ZDVsNzdSKzYwVzV6ZzgxczJUdE9O?=
 =?utf-8?B?RFNNaENvMmtXc1graHdtYmZmRm9sQVNtVjVrMFhteC9haXV1UHg2M1V4TWlZ?=
 =?utf-8?B?VmVHQWcwWkJnOWdBN2x5Z212NFg1MUE1bEM3c3h2WkxwaGdORHQwWWlTS1RK?=
 =?utf-8?B?SEk5VWNWaFRTNmtmem5vVHVJait5VWtwVlBsMzYxZ1U1cXRwbjBRS3BIUlhZ?=
 =?utf-8?B?KzFUZHY5MWkyaDQ2UXlxNnZWei85eVgwT1BZYm9vZTN4ZjkrQUZ2QjJKYWln?=
 =?utf-8?B?MjI0OUdKbE84T1BjbVZkS1lTY3Y4dW1vL0lMMFl1QTY5SldVc2pLSlVneWpm?=
 =?utf-8?B?eFF4dGRoS2VuZ2JwZ2Z0cWlvcEpKM2ZPVTQ3UStuSkZRUlVncm1rWnhjUk1s?=
 =?utf-8?B?U04ya1J3M1dvQm9DT0RzOHltZm4xcStLSzEzSWhOWE9IM3prY3Z0T2Jod2ZZ?=
 =?utf-8?Q?c0oLFN72uTW2WS7c=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21d94a5-5947-460a-a48b-08df418b2152
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 13:36:32.6170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wVN6xt5wicMUCywYwi+YsH/OfPJmGkvXdmqvN5+clJMIG7p1cUnKuRAUdQBA/psXVhDwp+gXR+DeqMGytS1+pE0MyePFFY+nVN8KmyQfN04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR01MB11116

Hi Juri,

> OK, but we will still not printing additional useful information like
> extra_bw, etc. Not sure if you are aware of tools/sched/dl_bw_dump.py
> drgn script; maybe that is already useful for the needed additional
> debugging information?

I did not know that script, thanks. It shows more than this patch does.

The two lines are there for the selftests. params_waking and random_mix
of deadline_bw_test read running_bw and this_bw of each CPU from
/sys/kernel/debug/sched/debug. A selftest cannot rely on drgn and on
the debug information of the running kernel.

So I would keep the patch as it is. I would not add extra_bw: no test
reads it, and your script has it.

Thanks,

Mathieu
-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
