Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.192.88
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794598272;
	b=EJV8PMpc+yao6RfU+DSOU2zZqqiiFjav4tnPx/eP9dUqLboBOppaMcrLq0eSTmnWTy+p
	 pi6ej6inMFdNboRms/MnG9xkbBAZ8+5X9gq8AkSk/ludP77W/T9qzMPABUM49VLoj5Rf6
	 LbG/+RJam/7uP+WZFW4velpnm6/a3dIanRxaFsOEDeTDXHu5C2yYNryzZGBQflSFK71h7
	 KJh93oskpADKb6dnnMUUwowB1yKuuldK3YLrS94+MMn8pdc4Q9MUvNWt8w7kl66TukXwW
	 bh9Q7glNkCkuJ4n3R6RRC/hfsJdoQc6v9u3V/qUPVtd8FurHz/sGDlRnZq5Vz07jZzA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598272;
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
	bh=weH0WDpdTgV93efTtz/KJr0XwSp6tp8FsOFCuTWC2Ew=;
	b=5pZHogrcDsoPNE8lP0H3oMgqR50OjSxU0rqmC7gNluDtBrGLCbsB4ivbWm9QkduRjljN
	 k+wBVzd4Savr46Pnfc70aAbGBNJTdI8fybwvANmBKmdZHOgznIm85PybUoSVnFdfiLT3I
	 GYHDp5AA9Vt6mVIPEbyf6z/JVn1xlBIxDDK5mNenJXEJLWvZcd+Q1Aw8GKIDh4kHeFaqD
	 a/njln9DbaQD1kr9CuoXCQmyNWyFXypXpvzN1t8OJVThbVxwf4iQjD5u7kqtXidxo95jo
	 uEobkBGrYmkceU/EVihwvZXba7wetOJHN8hfqKGYDIR2gEncUF4lnWwH3/JsOQ3IDPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=FlCqaSPX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.192.88
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021088.outbound.protection.outlook.com [40.107.192.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216AC606A884;
	Fri, 13 Nov 2026 19:31:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 216AC606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=FlCqaSPX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S0DfjkOtutse8OsrQzVLgQCwnNYBj4A1HQYE+gkFr2hfRzU12QxY/1uoQwm8IiqPINmlYM/5/+l9pGvQYbQaFuJ+udCnpb1jjvVCzFBUmttAFJLMh7KQCUat2o9Yk4boKPrZh6MsJAn2PIH1ygaIy6xgPwSZmqoC1MfhC2IJAJQGeLb3Tj/59Xy819HzNH5aLZ++Fh8FENPDEDUDz8g3iTjAW1gLDtO5UOvMF9Ucpsd4mVWCbtvhsDrBfSZxP26DA2r8uCUx/9L4CMbkTF6prRm7LNGraVJmV5rhDjMnCHyiIUPHIHdhTOtNKNJ85uwUgSkDbh+xcWr12dKmD660bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weH0WDpdTgV93efTtz/KJr0XwSp6tp8FsOFCuTWC2Ew=;
 b=knaINz2h9yMl60s8SB+E2U+B+s/uZOVl2Nsd7xfpuYEqPtQZZhkqrRdcjnCSLwBkvEp3Cph8J7KUXoVF227kA9HQynmOdZQHTF+x3GSklknZeOm2NI5rCwqNHqDTPoPROO6SbOqOcbFkXw915mgAMg71tIPOXNR+vWoFcp2E6V7OlcEQEabld3iok1zOHRyDK3VE5S8eZujN4/veDgQw+MSnXJGKY4a79vh3CFj7l/c9rqmYshDyB3Em2c0y0TiliJgmEMLiYWDSbuR3+G6Jrqi4ULHMtWP0CkIK57p8VXPnKzjktBiEMzSlkttyflgYi82eRNW97SthVlHYgVs+fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=weH0WDpdTgV93efTtz/KJr0XwSp6tp8FsOFCuTWC2Ew=;
 b=FlCqaSPXS43hjV79vClePf4OqK5gNgiQQr4tqvAubr7AsNFannaexr+Og5MFSlyIYOhhTD86QvcS1WAHxBzs+ihkgkk+JX3BzQTScGNQ105KC3sqJPw4ccjQlKPOrITMw41uK1zWZ5LqJqGZdTM/YGnk1ZdcrLAyp6dykvL7PcEC05fZN1lCjKz7Ef+d2TGKiVmEW/sp5WuKEeSZShrx8Aq2VPTlzZz70S4WiR+Fy8x3mZUnyC8ZPvoQoV48jzddfdG3mMrUGYXsiLtNRyOIdmiE/WCKzUd/gDBatyABWP5JE0i2QxqOr7UGS3c/l8OpRcJLOGbmWUaf8Qv7VXnaJw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT3PR01MB286964.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:198::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 19:31:08 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 19:31:08 +0000
Message-ID: <0fe54be2-0231-4039-9a5b-a98ea3bfbaed@efficios.com>
Date: Fri, 13 Nov 2026 14:31:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/29] sched/deadline: Move a task's bandwidth only
 where room was made
To: Waiman Long <longman@redhat.com>
Cc: juri.lelli@redhat.com, peterz@infradead.org, mingo@redhat.com,
 vincent.guittot@linaro.org, linux-kernel@vger.kernel.org, tglx@kernel.org,
 will@kernel.org, boqun@kernel.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
 mathieu.poirier@linaro.org, ridong.chen@linux.dev, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
 m.szyprowski@samsung.com, kayracizmeci@gmail.com, weihengqiuu@gmail.com,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-19-mathieu.desnoyers@efficios.com>
 <bcb60245-abfb-4e3a-aa4e-f134ed310381@redhat.com>
 <20261113135110.160083-1-mathieu.desnoyers@efficios.com>
 <638e3138-1dfe-42a0-97bf-2acb32970fa3@redhat.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <638e3138-1dfe-42a0-97bf-2acb32970fa3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0123.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::32) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT3PR01MB286964:EE_
X-MS-Office365-Filtering-Correlation-Id: 948c6251-62e6-4467-96e2-08df41bcaa84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|261009223027099003|22082099003|3023799007|4143699003|56012099006|10067099003|261102123227099003|261026140227099003|261026121527099003|261028144727099003|261022105027099003|261022075727099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	40hqlBO9uvt7lUw6gCmY55ecwQUGzrlPoKQLUHC/D6wkYFbxUyPlLoHP6C2k1kK3A+qX+50TMXANSuqqQ5xy2xBRoauT2jUL65ThW4HI5HKgjRBlW9paUsnRpzpl9g0XKKC2msI11FnIgmxwQUmnLUiMQMuSbASd8oBq4r/oIxHV/l7PZnXifykxsfXpZRd+47X+WkI947eGAK70kiAf8rf/rWLrhKf/0Z4rHRjQAU9gMMDN2sXoxCW1yiTawty1t8wxJCYkR0rnHASxR+f7p/s1Jl8W/RY6UbuGugmpRe7AdFlJbN4nLmYtaYzYDdsxN1kscEXHGU0ZQ+MQrhGAlQ6PYLaVABZubGrE47fYU6y5hVS+RqErLOW90wHvujv5gHViLsbywOmRmhBmGW7gfcADo96wvZu/7jz69w7AtaiSel9ShIPY03yQ5GFvyTJmesFo1qb08VSw4hErMut45PFefvthIOiw7C1zxBReKvnsONZrBNLiC2oCILMOFKO+7C1zkHjPl85SdhcaU0pOc0VoPqicicVmwaNmjAebBbHwewnp5Fu0VjzrjNlFyyUWG7N5KaqHqckyMqpdkPGKMY4dPImTu9v1LdMORot0rk4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(261009223027099003)(22082099003)(3023799007)(4143699003)(56012099006)(10067099003)(261102123227099003)(261026140227099003)(261026121527099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021121427099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3czeUMzQzhLMGVPNFowOEQwREhIc21NbUVuM2sxL3l6Qzc1SVRnZWFsVnZn?=
 =?utf-8?B?WSt5RGZSRDJ5bGgyQWxpdFVEWFBCVTdiRmRZT2NjWUpWYlZqeDJRTXgvMFlL?=
 =?utf-8?B?VlZsaDRPdXpRNzdteG9xWWVuckU4bFpIZHN1OTZKU3NLd2pxTnNEeUpjWkUv?=
 =?utf-8?B?UG0rQVAwOEV0cVdIcGpPVHBFUWdpbjA4RUZiVjluSzJQMXZJMjNSVDR6cVo2?=
 =?utf-8?B?eGFrWFhKc1BDYlgwL3J2aEdOWmpQRFFWT3h3OFlDcGEzMWNoUHpBTWlwRXFD?=
 =?utf-8?B?aGpBRU9aZWRFR1VqcnBKRkhSQWM5QTB4VWkrS05kN2REMmdIQWpkc2dhc1Rr?=
 =?utf-8?B?YkpHNUxUclpkRXlsLzRxSlgvTnFpWlFBRWhScHZ2MHFhRzZPOWNOdmRRSkFw?=
 =?utf-8?B?MVdJRTZqMjkzUVpFb3RzWC9uTWQvVmVvNWl6RzRHaUZ6aGJYS2wvdW1DUGor?=
 =?utf-8?B?aHEzTmltY2IwNUlPRkNQKzJHa0U0akNqd1c3bmo1T29oOE92QTBYSmlkY1BB?=
 =?utf-8?B?SkxWRTYvYVZlWDBsYXhYS1phUjVUTW8xemxEK0x1dXJSSmZzRlhWbXRXUEY4?=
 =?utf-8?B?a3hSZFJoMkFIbWI2WXNPTVN3RTRGSENVU0NrQm1jMXFUejdzQnUrMTRtc0Nm?=
 =?utf-8?B?YlBzK2EydkNMeWdPUzlkd0wwaFpGT3ROT1AzSDMyOVFEOE9tNU1TK1pJdGhr?=
 =?utf-8?B?WTQ5RFVoNkQ1SCs2SEFyNmJpWG90NFphSUpkU241OWFrMHBDUTgraklLY0dO?=
 =?utf-8?B?c1dBdXFtcTJ1ZFNTaER5cGJYTWlWSnRON2lsdXNDcHFpejFZUkQ2TlA2NjJq?=
 =?utf-8?B?NFRqTGNpRTBXZktzaEc5aFNoRURuVStFSnFlbUJqVVpMdmtPR1FiZk5IT2M1?=
 =?utf-8?B?c3o0MEZNbDQzUG1ZdUNpdWorTVAyWTlrc3JLTmpFV1ZQMHRVOW0vMFdRM2RJ?=
 =?utf-8?B?NTJrWTdIY2hCeWtoNDZyOC91M0haZmlnUE1tLzgxb0s3WUVaMUt1cnpVTThi?=
 =?utf-8?B?V0xoRzR3d3Z5ZFpuZ2dUZ2VCdXVOaCtadzRvZkQ5NGtRS002RmdiNnc2ZWpu?=
 =?utf-8?B?dVA5RmVMNHp6WHpIVUV5MTBlOVluanM4K25ZTFJFc2Z1TFlWTldGM2NINlNk?=
 =?utf-8?B?QnJDZFZ0amkwMUR4dWhYVW0vcjRrT01XdXJ5YnFTL1pKVGtHYm9saUFSc3JB?=
 =?utf-8?B?ZGNveWFNYnJIUmNBdXpBQWJueW0vT1FZSW0yVUFjQVFCYnlGZUJsQ1lsTTRI?=
 =?utf-8?B?YkYxZWJVVUQxSnBjYWpIOXJRWHFyRWZNaE56WGs5cGhHNHV4NnhGZzBpYmZn?=
 =?utf-8?B?bHhGLzZ0bFk5MXdQUDh6RHRJS1VnUWhzRU56UGFUZGFFSVQrK1NiRmpVM1RX?=
 =?utf-8?B?cm1IYmVXazdNdDVlMm0vYkdPYkp2c3FqZFVHWEhleGR5emZpKzlyMUhRaEJa?=
 =?utf-8?B?d1Y1RDhSS0dWOWhBNG1oSERNQ0VwOTR0eXpTU2o5MnVVRzNpRm1OZVNWVzRm?=
 =?utf-8?B?cS9RS1Qrc2ZuNW03UjQ5MzZ0d0JKdy96a0h6MlNsS2hpelY2NEZCWHFLWDEx?=
 =?utf-8?B?WkphQllZY1kyRGtjL0lraDdEUGZJcUxISVZnWGlLTmZGeWdEd3Myb29hYlg1?=
 =?utf-8?B?cGtPQXYyd05ldFVHZG96UDhXUWJld2RBRVVZSWk4ZFBVM2U0dXlnUWJLRXVR?=
 =?utf-8?B?eGxRbm81SzNvamlXV0VDdU5seTN6TGN2N2xST0RrQkRBMW1NQ3AwRFNMZGpQ?=
 =?utf-8?B?UzN2YkkyVEJ5WjdPeHBQS1NvNE9UeWVpR3d1RUZ4L2FBcmViTG01M1Nkby9S?=
 =?utf-8?B?R1diZTQ4WUZuTG1YUTJ3RC9MRUlGTDRxZUYxT2VEY0RnbCtoNFk5YlQzbTVD?=
 =?utf-8?B?WHVPMkcyRG1uTk5lNzdyWUEzaU5UNDdvT0VwZEdJNlJBdkgzOWM2ZFZxRGVZ?=
 =?utf-8?B?WVRYQjdNUTZmQk5JTnlDd0ZFTlRnYVoxWkFBOVZHS0xCYmJrYnBCcGY2UUFO?=
 =?utf-8?B?S2NDa2hReFhQRFdzeU9ENmtCUUNJV3VVMEYzV09zU0tmdXNsMFJwTWJuYkww?=
 =?utf-8?B?UHNBZG8yS1BrdGN3V0dTYWdWWm9qZlg2T25iQ0VhcUZRQ3ZUcTlDSTlsbW5X?=
 =?utf-8?B?T0pKOUpZRlI4QWQ3YVRMWUJvY0pheVJHbEZoTzQ1ejc4Wms1OEhaTjlqTGN2?=
 =?utf-8?B?d1pmYUxlRzVuNWJNSjlFcDRrRzZWWkFoRm1lMUZRWk52VG9aV1A2bXdleEtO?=
 =?utf-8?B?dTIyakRYeExVVWd6MmlxbGxiS0VXeTRVMEZKUXlldXgrY3d0WTZHRkFGN1Ar?=
 =?utf-8?B?WUhIQnpFL3RXWG00ZEk1K0Z3MnUrZlBCeE82ZzdvSDVXaW5PZHhnaWR1d1lC?=
 =?utf-8?Q?a1paONkA03OtiEiI=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 948c6251-62e6-4467-96e2-08df41bcaa84
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 19:31:08.2151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBw77OqD/AzaTMHxjapFc56HzfoIgfwA6Ra7KpGeEAZAjWV3CC7DIsyM5fbWn+Lth8U1zWCrR44vxmTUoHTwQeTNrPPLaXko3QIg74KEd70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB286964

Hi Waiman,

On 2026-11-13 12:33, Waiman Long wrote:
> Right, top_cpuset is the exception here. Boot isolated CPUs are not
> allowed in a root partition. They are only allowed in isolated
> partitions. So root partition other than the top one cannot span more
> than one root domain.

Agreed for partition roots. The case I mean is a cpuset that is not a
partition root. A member cpuset below the top cpuset can list the
isolated CPUs, and gets them as effective CPUs. A in my last mail was
one, and B below is another.

> Are you referring to the case that shrinking the cpuset CPU count to
> reduce the total DL bandwidth will fail with EBUSY when it is less
> than what the existing DL tasks require?

No. That check is about capacity, and the planned next version leaves
it as it is. The two new refusals are about the root domain that
counts a task: the one whose total_bw holds its bandwidth. They apply
when a change leaves a deadline task no CPU in that root domain. There
is room everywhere in the two examples below.

Both are on tip sched/urgent, in a 5-CPU guest booted with
isolcpus=domain,1,2. CPUs 0, 3 and 4 are in the housekeeping root
domain. CPUs 1 and 2 are in the default root domain. B is a member
cpuset of CPUs 1-3:

   # echo 1-3 > B/cpuset.cpus
   # cat B/cpuset.cpus.effective
   1-3
   # cat B/cpuset.cpus.partition
   member

T is a task of the top cpuset, pinned to CPUs 0, 3 and 4 by
sched_setaffinity(). It calls sched_setattr() for 10% and is admitted.
I then move it into B:

   # echo $T > B/cgroup.procs

CPU 3 is the one CPU that B and the affinity of T share, so T is
allowed on CPU 3 only. The housekeeping root domain counts it. The
tables give total_bw of each root domain, from
/sys/kernel/debug/sched/debug. "Before" is the fair servers alone, and
T adds 104857.

1. A write to cpuset.cpus of B:

   # echo 1-2 > B/cpuset.cpus

   CPUs    before    T in B    after the write
   0,3,4   157284    262141    157284
   1,2     104856    104856    104856

The write is accepted. T is now allowed on CPUs 1-2 and is on CPU 1.
No root domain counts its 10%.

2. A partition root Q, next to B, takes CPU 3:

   # echo 3 > Q/cpuset.cpus
   # echo root > Q/cpuset.cpus.partition
   # cat Q/cpuset.cpus.partition
   root
   # cat B/cpuset.cpus.effective
   1-2

   CPUs    before    T in B    after Q is a partition root
   0,4     157284    262141    104856
   3       157284    262141     52428
   1,2     104856    104856    209713

CPUs 0, 3 and 4 are one root domain until Q is a partition root. Q is
valid. T is allowed on CPUs 1-2 and is on CPU 1. The rebuild counts it
in the default root domain, which was never asked for room.

With the planned next version:
- the write of case 1 fails with EBUSY, and B keeps CPUs 1-3;
- Q of case 2 is invalid, and cpuset.cpus.partition reads "root invalid
   (Deadline task would leave its root domain)".

T then stays on CPU 3, and total_bw keeps the values of the column
"T in B". A move of T to another cpuset still takes it to the other
root domain: the attach asks for room there.

> We already have pending cpuset patch that will disallow taking the
> last housekeeping CPU from the top_cpuset partition.

Which patch is it? I would like to test the series on top of it. From
your description it covers another case: in case 2 above, the top
cpuset keeps the housekeeping CPUs 0 and 4.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
