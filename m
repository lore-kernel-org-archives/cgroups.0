Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.139
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795013549;
	b=DMVfM6Su0l2JvP79/4i75KnDfJgCgcZYmKiVAt9mKSPeZHch5Yw2LVBaYKD+sZONlu5/
	 w8m6XNWNbY2+ZczLI2/zuoLedr+w+V0KILSZG/BIKbDcKDnPGzr4p6bVT+rPHRDqjiF/T
	 p1TIhNYz8SGKmIk4evtwq/XOgld4M15VA8uyPbMQOX97DjxsG7gsYmzGZDdwWeRU99Ok3
	 Z9ZxLr5kW5f2Y/4WTmwM5s3cpcdnQOKGE9BURK/nuasRLyKzTKX/qJ9CXfgFkSzrltlMy
	 6kzdpa16qykBALGYelsH4xWc2AZuVouWqM1TjaUBuimI7CIuGikMU+WoWmoqVF/+rnw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013549;
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
	bh=Nq5o9yhkYtuH+ZXDc69/fViNewBFXpBRSbbR1U7zUpI=;
	b=MF9SYgv2LonWNb+pwY0EF4B2u7zBcMsgeqZfAPs5Vrf9qyFVEEBrLZWiPKXRPEeMprfu
	 He2ErrJAMujICdkgbYX/GUDiAusqcY0d3b855Ksqw4RqIa499nQoP652FcGcQFA8sKzn0
	 LgydSbdVYPo31mnpXAElww/WzMhh6TyROLZelb7G3vnMiRNMaSObxyMRK1oBZhq4YsvVa
	 NVWbo0SWiwULf0I/u4/Rn/U5pA7DI05DfK0LIJ7PScL+838YBLPJ0Gl6n5D3xC5fORQrK
	 AdIGHHWFpHNSDlGD6+vghlmWqtgSCHFn/dOkkStC58HngalYlU2FkgwPLaDE5NiBjUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=WnDz1sCM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.139
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022139.outbound.protection.outlook.com [40.107.193.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEC4606A331;
	Wed, 18 Nov 2026 14:52:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AEC4606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=WnDz1sCM
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uPmkJTL1NCGg76pAIUrFL3pmeyKcTzPdK9CyU8dXxSEWKzez7ysOfULYpsYqOoUs2KUuYhcA6pq4WBMr+BmdPGQ3OuwZnzjV9Nwyiwz01XI+VEUzQhVw+0JKSpoqP2OLd2wPcIVsCW1PKN35VEXEQ7h33Thuoywk8saHR5LfeZ4AqMCn9znItVnLMuZNwM6f92c6XIkHfo3m4RHg5LevToVZ4KQxyfJc9ICvcDc7uiYRcUIjzuyTc6/XXiygiW1qCmGY7rA55MiwgqQgPc3+MgzF/KT42crJU80BDOefmRITsOLmX6J6/rWYtmrPl60IXSaEpxhzwIz1RFKKhLOrGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nq5o9yhkYtuH+ZXDc69/fViNewBFXpBRSbbR1U7zUpI=;
 b=gJLzTJtfMx8ZmtL9PSXAvWzhVEBr8F2O8cfsDuV+fSaxo9dBnOLDW/maH7tD/VVcu+ABlUBDZaYa2Itu6Uw8r3iyBEfI3wlVZLGNQGbVTUrjDnQU+jW1hqURWgKWHfKQH5obmzeiVQtcRh+hLbjfHTe4ivruifML3Jc/+ADqsjdFSwGO+cfHk1PE7UBMKo3N0byJqkvcGHFEhdouXmyLWcg+NaOhRXh2vT2IT4NEAHqgDXl9DTyZAEuU4oiugoCQ7Om4whdFnWIJIhlsC/OzS6TB4QHU3t3NsPQDDEn4otcHyelHpVmDDZY2pEIf/t9uqP4I0tyBO8Ask4QwtjxmJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nq5o9yhkYtuH+ZXDc69/fViNewBFXpBRSbbR1U7zUpI=;
 b=WnDz1sCM6HUcYzV8QNrKtcKa93WZFGKP2ItTpTkICALORfMLfGJ2nGB1Tmoxi80JRIGv+QJOEyz5RsuCtF64w4p3UHRQBGuMePKG9m5wIeywcmHiMMrsP1Rd3Xy64yvhh8oqH16sqHk1Zz7365Qvs17lHuyvaYTTpEamnRoLBGxofqBuclhMIIKbqesMm1k1xH9epAAh9i/FL5kDJ15v/8slWeJCyVmApj5zr+jHVw966mAAouhI3Ytpf0nNYFAF9NERbDzVHf1rVGBrUN9O6tCFT7iN/DTH6AN3VALa773iiK6X58M09iLeqfm56oWupisUF/VL8yS9n/8/TZD4xg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT2PR01MB8487.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b6::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 14:52:24 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 14:52:23 +0000
Message-ID: <f6919908-b943-44a9-a71a-35d5a85d54c7@efficios.com>
Date: Wed, 18 Nov 2026 09:52:22 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/40] sched/deadline: Do not replenish a boost from
 cleared parameters
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
 <cefacab5f1c0e7617f17e050af4ef5f6db01700a.1794922146.git.mathieu.desnoyers@efficios.com>
 <av2k8JlLvUcBBOhn@jlelli-thinkpadt14gen4.remote.csb>
 <ddd215ff-d6de-4dea-b12a-80948a9b5ea6@efficios.com>
 <av2295tJMdwRp3wK@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <av2295tJMdwRp3wK@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR01CA0149.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::13) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT2PR01MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: a1fa2958-050d-455a-a29f-08df45838e19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|22082099003|18002099003|261009223027099003|4143699003|56012099006|261026121527099003|261028144727099003|261026140227099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ODccdgiX3mhxduAm90yuGwsI+4vv06dvbOQCS+ZYv0hgG1DpxuTZZYqFEaekYW9x98U8d0KqG8eFQAUYF9aXjYv9puS5EG6nVXNEPGcNoz+B4vuFOLlup2GlKXncwYb2XZPOJ330NguQF9sdeNLxVXYqFVodSC9lJUD7IEPEvJk7XLpeTvz7hX19mDUqO/+JtjNaEd1pcHVnptB/X7SY2pRvmPxCywF+mF0f1hqsvvA20NSDdoMztU0rKi2Lth9X6UXlglFKQWyrh5VF0ioe2k12aQaoZ26p4s1fjAUQLzj0MQ+m7O+Y6dR1R4sLCNUpJRZN8o2jWd+FPU7wIcA+ydVvMHVfrgauE10GSNH96IL14T6+Gwh/q4BNaRNhwIC4E01BniOmUousjJ/qmq6SGbatiOuHTloUQqbPJu/Ye7HQACGxJVktg2zwYnm/BAIFIjeOdSJsfQkfEitZubp7/tRqLm3alPBzv+mh0vMkZY8KDLhI5AECfQ04fHEsVZzidpycZGBTGGm1TbTQ2exkKweSDtMueiE+VoHYlqjqjulSCUaBQJSAPKk1MbufBKG11XEAQW8LHCYTVPBIV6PfxowMfS/lOg9vrq4zwPWQEEM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(22082099003)(18002099003)(261009223027099003)(4143699003)(56012099006)(261026121527099003)(261028144727099003)(261026140227099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmhMTm1rMWVoT0dXOFJJZnZIUU1MbFdmZnFBakNmc0tzY251UXRKV0VmM2o3?=
 =?utf-8?B?U0pCV3pOMHJKQjBZMzBjcDd0TXVhV3hBSnFKZjU3cEwyd3Q0SVpuNXd3MXVC?=
 =?utf-8?B?VVdoUnBHQkd6cmYvZkdVaDFocDRTNy9lb1B2dVB1cWJJNXprZlBqSHhua0Ez?=
 =?utf-8?B?WmpZa3AzVEEwUXBJa2VMYjUra01taHBKZ2x5elRYMUFNMG1WTnozemNtLzVG?=
 =?utf-8?B?SUU4Y3VyUk1LOWMxUTJFNWowRXV2S2dmbUorQnNNTEUrZU45YjhZdTUybk1q?=
 =?utf-8?B?NFdjTkNsTEFmN2dyZkNMR0NvbkZZQlVldXo4NlhxWHJONmFJd1pLMVA1dkxm?=
 =?utf-8?B?YlJYOVdOQ1k4SHFaZ256LzJXb1dnTUFJcUhvcHJaN094alYyVFJ6emprUTda?=
 =?utf-8?B?TGF4RkFsak1kREhjMFM4dXRBUWgzOUZ3bUlORlRaT2FWWlgwZXdkdjVsckx2?=
 =?utf-8?B?eklDOVgzMDh2ZURKK2xtUFNoMGpMVHJEMkhkbCtIb0JZZ1FNU2htV0xqelFR?=
 =?utf-8?B?Tmw1TzkvSHQ3eEJCc2s1SG1TNHJwc1dyQXA5Qk9rZGllZUxxMTNwZWgybStB?=
 =?utf-8?B?N2xRalhDQ1RUZ1NMcjJLYWNaQjAxaGNXdllMRG16Qk91d2NrWklKV2xaYk5R?=
 =?utf-8?B?Q280U2VMR1VxRWt6anAwS3JLQUN1dCt1WHc4akFvRmlKejFSRllkT1R6UTdL?=
 =?utf-8?B?NFRKYkdYMDl4cVNMUjVQMHB4Ni9PS2hEd1J2bEEwR0F4K2JvbVJwbXU0SHRN?=
 =?utf-8?B?T1piNkx2cEFvWC9rTkdkbDB5UnMwZnZ6cElFVklicnRrUFhoUndOWWhmSHZW?=
 =?utf-8?B?WnBZWnpxejAyLzY2MzVBeUUrZm5nZWlqSFY2YlpBR3ZlWDJRV1QycW93UWZR?=
 =?utf-8?B?N1h2WUZZb24vbzB5Ryt2aGJNTExjTVlCMHV5dG1rMFBIeHJ6TVhHQUd6aVVP?=
 =?utf-8?B?M3NZb2ZNUk53bm1hOFlXRUdIYUdjbGhOc1U3YlBoRHg1aTZRYzFKSm1QTExE?=
 =?utf-8?B?QlFYSU1sOTc4RXkvNkQwbS9WNW5zbGZnQnNLaDhFZUIrcnhIT0dpczJHWGNr?=
 =?utf-8?B?S05MUE12WWRXWi9MeVFoMlAyRUFPV2Z5b2hMRWRoQUpUV2pHSjFWTk1OOWFp?=
 =?utf-8?B?Y3cvSlZIcno0a2pBdzlMakdYaG02VGxQcFZYNWsxdXVORCsxNTBiUXBZd2xO?=
 =?utf-8?B?MGduTFFuODg5VzR2NTlRaE1mVmRJRm1PUS9qeW1aSFZQdHRSajRrMnRJT0Rx?=
 =?utf-8?B?SC9vTGd0QktSbmd2czM3eEFQRHZxOFhRNXRsN2hJVVcvUU1yNys0Zk1mTjF0?=
 =?utf-8?B?WFR2ZWVpTEw2a3NhSXF1cXhBY0xKTWNhUlpLUUtQYk5WU201R0pRdW85ZzIv?=
 =?utf-8?B?Wit5TDFXc2Rtekg0UmlGYXFCajhVNTRlOTZJdEVuMjdJcE1OdUU2aHhRaFpl?=
 =?utf-8?B?WHNzL2xxa0FxNGxpUkJCakVVRHd2cmxEUDVncnJlTDJ3aDhtNEluRURVQ2Jw?=
 =?utf-8?B?L0xIMHQvU3hSVkVISkVHbHordHRzYm11L3BGOVRGY096QWNmZXcxNUdqNDBS?=
 =?utf-8?B?UGYySEk1Y0d4dk9MRnA3aEVkQy84aWwyVFk3QWh1RU5DNThNOVg3Z24zV1dY?=
 =?utf-8?B?SmJoSEUvZ00vWUFSNnFudG13NmlFYXAyN3EwS1hSVHFiRHZDNFdRdmI3RHdp?=
 =?utf-8?B?UTcxelJodUprSFlVT1VJVHFGdmdtbmZ4WXFzdjJVMWhraDkxSTQ4ZDFYRUNN?=
 =?utf-8?B?cmhlNGFoSzAyUUNCTHdYL2RYeWZERWNkWVdManRTMGxKblBKczFVUndVZ2RJ?=
 =?utf-8?B?MzB0WkxCTG5VWlJOWjhoSXBURkhSWitoWUlYbWtlZVdUd3lrWTZyNjU5M2RN?=
 =?utf-8?B?SzduWlBSZUdmb240dmxNWDJaZTBvL2RoMnVldVlqa0lXUVJ5SWZTWjg1aElF?=
 =?utf-8?B?bUhHQTdEVnFwTzRFWTZpQ0dEc3k5V0FJdjlYQjhsbzFSNUN4cnVBTmg5SWxH?=
 =?utf-8?B?UFJBNktzKzBJajZwdVkvVm5RUU5WRTJFRUU4STVJMTdwemRnak1mYjBXVVlz?=
 =?utf-8?B?UWhpRnBJK3pySE0rYUZtUVRLamlFVXV2MTB3WkN2dkFJazRXSDc5c3hUeU9K?=
 =?utf-8?B?bUYyZTBOMCtZWUNWZjdTZ1puSVYxRHJNNElhZXpwbkFQbXJSSTJsVUsrTk1h?=
 =?utf-8?B?Q3plUUZ5dU5jSmZCemF1bE5ueDNZd09xb0MzY2xCSEhEaVdhVFRSc2NqUUNG?=
 =?utf-8?B?YmJ3RFBOVDNRSFJiSnprR1F1cU9UWjY1TkduNzZSbHBjWWlrcldUTTdzOU9Y?=
 =?utf-8?B?YnR4M25ieUxJSTNSUUdETThLck41b1NQSGpyanUyNVJ5WTZReGl3dWc4cjUz?=
 =?utf-8?Q?yndiduiSK5/sH7SifPbL9vugRwdx1aE+8PaZp?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1fa2958-050d-455a-a29f-08df45838e19
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 14:52:23.7951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LvCPkxGN4RNczm6w0xV9Gl1FDYmsrZyO0Kp8kPAUW7+e8Fg7O8t1HENOJSYiYTFcoOlBnm1cHWhkN9oZWUbE6mGWqJ7K1V5okzf3SQeh/2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB8487

On 18/11/26 15:32, Juri Lelli wrote:
> Hummm, now that you say it, crediting Sashiko for findings might be
> worthwhile (for usefulness statistics etc), though.

Agreed. Documentation/process/generated-content.rst also asks for it:
"if a tool was used to find a problem addressed by a change, that
should be noted in the changelog". The next version keeps the credit,
without the number of the posting. For this patch:

  The Sashiko AI review of this series found the lockup.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
