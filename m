Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793355326;
	b=gSxFCS62Jip02uUXhA/k163YfxuDatPlZM5NMgXK5Tszaouk5P9IJmupqSAeBI/tqiA1
	 Sp54NcXZyygzZFVTjo9T4x5tftBlMK4FT4hL2Rttm36oLFyZfKz1haz/PBXTw3oG8LhUM
	 4XfIPyKU/B/mAbN0EdgyoqrfkGVOv2/CFiTZhGmm39hSxtH15h0Mvsyqxq/EF18P4iGHB
	 M/YwxORBNawVTpWpN6CBN0aEjROMUfCaFv1mRlef2qbY5hzRse3jrj2hyJZ5cL3BTnxNF
	 0L7NnSCZ6QNYtWuSJo+fzDH4S8YKNkmIlHMJr1fdjUr9Zopbv77YGoSr7EMxRwq1opg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793355326;
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
	bh=bpSoJ8ERAGE+2HdLcrLZ/w9bdGlkebvz/Cx8ZnJ0+sg=;
	b=KNK7FNvLbXsOlvXpH6a6d5249i1D59Aw1LJNhN1PXC+gKaG+BNbY8LEBtflt2qvR3ZzE
	 IOql21/gkjh2RWXqug1rECRE25ZkFgbnKInd/1LDD3YrOh363nLWE9o9/P7pglYa+3F+X
	 +qjoIcsDcGmE4sz9GTYisL+sFNwfH2O0R4SMTZj4RUdr0uP27SQCsL9JjmbeDpkk02w0g
	 DFawXYHCG8XpxXD95BeyP5fRu/ISrM5cStM4E4tHUNHm9wcWa/tb22u9ITxNh3wsYzGCW
	 xXpcx9j/sGrdt8F6Gq4ufthQjkZWhXZCei28Ca8800MFx/o4KsdC6N1a3nFkjeNaysg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=FMNS+2JS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.52
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010052.outbound.protection.outlook.com [52.101.61.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB551606A327;
	Fri, 30 Oct 2026 10:15:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB551606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=FMNS+2JS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hjd7bcipzyKzyTNbDSW3hoWQVCoxsE/mXf+py9buiW7IIxWkWP3q0C5CpFoePpk6hfIV/bvKmy4yxFqX9ZxvP/1OcNVbPpgBaRGlr76Z3QNXPJWaXAbzkxRdCc/dXetY4Stz36NulG6ydgn8O4oFc6zzL83Lw1KuAh14zJxgcuNDGP/h046OALWRCAMqLqhtIgFqJ0Pp2c2Hq4y3qvT8ek4KdAbO/Nb5prIJbfXW+bw0BOWl+dECvclVJth8OIRvl13Hr48KSl+Um3owz1mZJy4NtwNOdJPcwTsqE9lv+D+lbM/d1o5VZpof/WqOb5A/Z0WExsbSOObuKuyraC5ewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpSoJ8ERAGE+2HdLcrLZ/w9bdGlkebvz/Cx8ZnJ0+sg=;
 b=qpuyrAhJiruyh+CUV1JpiK93W2sKEFfDJtPKg+daWw5y+298NNbDi5ajm+ZZONaZcJtF9WL0IH3+mQSmM9qfFYMPAd+LJj8uUTSCcvykVfYCpQccjTzxPV2CvkRrye2d1M+Dbm9MRWXiKdoFVDjRfFKezpYEzTZ0NdNu7g2ZTvpmvjYPeUnLjpDeJDRTvcr4bR04uVU7dvnMwNIg7rXHCh1qT+A8YDWOa/tI9RTNLN5Hzn9KSHGQ27zmRwq3ZZ4V4fYCAOPVoj8EzbylA9UieAWAvcPrw5HJ9MM1v7Qj+IDd9+ApKZaBbWAWfj+NYkb4PGo4gQqfgRgAUsiPWdnBMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpSoJ8ERAGE+2HdLcrLZ/w9bdGlkebvz/Cx8ZnJ0+sg=;
 b=FMNS+2JSpnfxs47IL5iXV79FVeRkk4f2mAREunP72TxSJw2hsJC2d73tXyeEDMekuKvFPUqDBhx0qEGnH9vfL5U9wJlGDb/DiSPzmqr4W8Zf4zViLeg0JfEsLXEku+IfNMQovz+NTRDHvJxDUGxqgnFjb+48kWKQ85ikMudWocU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MW4PR12MB6681.namprd12.prod.outlook.com (2603:10b6:303:1e1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Fri, 30 Oct
 2026 10:15:03 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0546.021; Fri, 30 Oct 2026
 10:15:02 +0000
Message-ID: <08705a7a-86aa-4b43-a22a-e80a572010f2@amd.com>
Date: Fri, 30 Oct 2026 11:14:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] dma-buf: transfer memcg charges via
 DMA_BUF_IOCTL_XFER_CHARGE
To: Albert Esteve <aesteve@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>, Christian Brauner
 <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
 op-tee@lists.trustedfirmware.org, echanude@redhat.com, mripard@kernel.org
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
 <20261027-v2_20230123_tjmercier_google_com-v3-7-78d2c4cb8647@redhat.com>
 <d76d8bfe-e955-4e90-9f5f-e3e914c0869c@amd.com>
 <auIeQU0nAnOLdKUB@aesteve-thinkpadp1gen8.rmtes.csb>
 <9ebce3f2-f7a0-46a9-bad7-39059b99423f@amd.com>
 <auNzHjhT5xezyZ4I@aesteve-thinkpadp1gen8.rmtes.csb>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <auNzHjhT5xezyZ4I@aesteve-thinkpadp1gen8.rmtes.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0516.namprd03.prod.outlook.com
 (2603:10b6:408:131::11) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MW4PR12MB6681:EE_
X-MS-Office365-Filtering-Correlation-Id: 4588d9bc-e088-473b-b563-08df366ea973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|22082099003|18002099003|10067099003|11063799006|4143699003|56012099006|261021123027099003|261021121427099003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261009223027099003|261009221227099003;
X-Microsoft-Antispam-Message-Info:
	y6jeYfReWPIn11AK8DxxwrAaYxYfsyHmSuI05RtAAIFhJK/Pc/UPVbNQfjHPfjvjEkcmp5htahnN8sutRpr3NIP5eHm+gXJVuxw342kQAt84cZ2Gq+hNpT1UxerGeU7OKduvM2kydnk7FRC3tfujCcJD/Thv2QJLKFgK71eHu2wILlVlVXmA/VsHHDQN0NAZy4u0y03D1uflTk+SxPJ17pWFW+jWdkFM+0jC9LkpDyxHrL4Ryu0tYD/KpiIG1X2Ua/VLqmvIlssG+k2uXCU4B6V0XGEgnIf69ojN10nKLlOqvsgVXP9ONJe5J0AtVJ1OjjgbaMJEFAJoyJK8EKvmXc1lMuWaMRCqkRVZCXKlgVcbIVF5H6coxvkq68XiI/XRDIZRl8dgDDrEu6ex8pohm6339PV85ewjXO4OybFqOJO3t3nn6AJTnobOJudoK1mbwOdV1wMpw9vNsYqzsWx/uMUgsuNnlwmqjMTz6YhdJUEwhajvtdtSh5t6uhBnJpYfgD51x1XqB/zJWSIsGloTeE2qiYrNebbxHKaTAcZW1fXVVshXmQnNZN6po3LXf6jqBtkdDoSd/ax43WJ3TOyJihHsbe3tc80gykye6WZKkhNlJI8d2x0IYMAnSjj3El4THS/2nenWsQ3HoTV8uhW6uzzQFJ+qKWSlPd99gYfo+Kg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(10067099003)(11063799006)(4143699003)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261009223027099003)(261009221227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0duRlQ2Qk9HbitDNzZYVjlINEFvQlZ5N2hrN1FSUDlvTnN3b0xETjJYVjRz?=
 =?utf-8?B?cXVINFJLQ1lzVUswV2pvZUFGRmJGNnBndkFtK0oyRTJ0QW9NU1V5OUxWeTN2?=
 =?utf-8?B?K3lTSHVuYXRpbzVHUTk4cTRZeXU5eUZaQ2hsYjVhd0U3Znh1ZE14U3VsMTRt?=
 =?utf-8?B?VnE2SndwdUVOWGd0QTE3RXFCcmhGZXlTYTdFODIxLzd5b3F4ZmhCb3pIbmNH?=
 =?utf-8?B?RTZDU3Btb05MMnVnaU1KYUN2aWVMOEpFR3VrZ3B6Z3JTNEtqazdJT3dRUlEr?=
 =?utf-8?B?ZVNBK1dYVklzNzRQZ3lQSjFBYjBoZEEwY08veVFnN0NzaGhsOGNBWHNhUUlL?=
 =?utf-8?B?cVYzZmxqOVg0d2NETnRLbEhFQTB6Sjc4Rm95MW9SQ05tcWxOOVAvL1l5YnhH?=
 =?utf-8?B?RDhReVFUQUc1UEZ1SFA4c0lyeWJEY0FUQTBLUUYwT3U5MXJHY25QWVZyelhi?=
 =?utf-8?B?MGE2L2NyWWVsWFl3Si9ib1ZZdEhZTU9WQzc5RGpLR0MrZ25pbDJnajBYdFZ1?=
 =?utf-8?B?WUY3SEFJL1FmQzBCcitQTGxxU3ZyNGsxcm9XbTB5Mm1yMzdCUWxQeTJldFVN?=
 =?utf-8?B?RElLeTlmTlpsMHl3bTdGTjJrcHI3bFAxT2ppMDZyVldRVnVTVGN2T2djSlBD?=
 =?utf-8?B?VmpTTTJVQy9ZdTB0L0tBb042UFVDOVFJdGFYWlpzNEdmWUNUR1czcXRIQ09r?=
 =?utf-8?B?MGdyS2JoNjUvdDBWK0hLMzIyclhkUVBYVWtlRkwyTjN3bTFkQSt6aWtBNmlJ?=
 =?utf-8?B?TWs3TmUzZEduN3VLYSsvWXBrTW04TGE0bTY1UktpZDRkUnFDUFh3akVZYUpM?=
 =?utf-8?B?ekNlbG92R1hwOGFTTzUvSWxhOG4wZDhzRGNlTjdnQldXdGJ4VWtPWTZKbkQ2?=
 =?utf-8?B?SmIrNlJFVnVjVFZhZVdJdVVHMXBSbkRWcU0yMGc3SDIvZHlPVzRrS1VNQklu?=
 =?utf-8?B?VVlZWExMWjV0Z2RyYnl1cm5rTko2YlpUR2cyL2x3dkJJR0xBM2NkVW9VSGl3?=
 =?utf-8?B?TDVCMTFXMlU3YzVibmJwTzJQaktnQ2ltSURVNVA0djQxZ1FzMTNaWUxQdTN2?=
 =?utf-8?B?YnFVMEx6YlpBVHJPR0xJYUorZEVTbTk5OC9OWU1kTWFNYjFUbFhrZkpnTFVP?=
 =?utf-8?B?aHphemt4VDlSOWZzOU5tNFNmYjczTjZpY0dDM05GY2Z4SUwwNmlCSmRHeUxr?=
 =?utf-8?B?c1NMSFIwR3NzYmJGMDB1L0xoS0t3RGJ6Y2NaWFdQc0RVM2JHcmQxRWtUN2RB?=
 =?utf-8?B?UkwvUUVqY1FmS3JJMjdQdFp4U0FuNWw0RUU4Wm9EdEhNMm5ROW5pd3JKVWdF?=
 =?utf-8?B?VlJCRksxLy94S1c3V3RCTHRqWHdJTm9NZEdpT2FOdVJjdGxGa2hNS3JNOWQ4?=
 =?utf-8?B?NGZUQzJ6ZnFnREc5djVEbzFpNXVxRFhhRUxVVEtJY0E2QkU5UjVnaXdkYlNU?=
 =?utf-8?B?OVhhOVUwWVBUeG5vayt5aklRM2QxM0hRZHV6WnlmTFlmOUU2SURuV1ZYSzVj?=
 =?utf-8?B?Y0pvYUloVXI4QVM5MW8vd2t2Sm5wNnNNQmtrTVpSaEVFZUpraGhqNG9xYmdB?=
 =?utf-8?B?Mlc1eWRMVkRNdVhqb0xNdStCWFV1cS85MzVPMjlNVXM0Rmk5amZmUEVjUlFY?=
 =?utf-8?B?RnZtV3dBS0dKNk9yZExGU2dUOS9wM09CRnpQUEdkRW81R3NvcHluTWc0ZFU3?=
 =?utf-8?B?aVpsRGExV3IrZXc5cHIwOENDNEFFUGNxNWZ4RkFWeWN0U3MyU2Y3MnZRTERW?=
 =?utf-8?B?YVNPZUNKRWlzRmVneEhvajNxcDZ2b3V5VlBablgxcjRRTExEQ0EvT2dlN3Zk?=
 =?utf-8?B?RjBqa2grRUYvc3FWUzRxa3pPaTc5SVNCeEFaeDdvbHplRkhQWmlxdnFvbzVR?=
 =?utf-8?B?aVFnTElIMFFodmkvNlNGam9mWWw3SDJQMUdpN2FMS1JwTHAzcjFFQWFGYjFo?=
 =?utf-8?B?OW8xaUx5dStWaEZJbDc0bG1OZmVNRjJMRm1UckVUeWkyaUVvbGEwYUc3WjBq?=
 =?utf-8?B?SzExUWRGUWxLZ1o4Z29nUmRJYmJGSzkzbEdmd0dBQkNpZ3A5MlJnVGxqc3lh?=
 =?utf-8?B?OCtlblpacXRJNFRLYzJhem5wV0VyaEs4T3IwT0pCaWxYSVRmZUhRTXZkNUpy?=
 =?utf-8?B?K0hIaDNqMFovSlQ1dWsvYTBkVzkvY2U4QzBrZVcxZEJodFFLRFpLTkVOa3hQ?=
 =?utf-8?B?TUFxOGFub0JyakFKWlZhUklsSkg2V0FPNVV6MmNYSXp4cjFleTFHQXI3RnZr?=
 =?utf-8?B?dXY5T0Iva2UveFUrWnpYVWNSUFpiOGlncU1BS0ZNTTFHRk5US3Q2MmlzV2dE?=
 =?utf-8?Q?pvS0X8YwQ5HfbtQm6B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4588d9bc-e088-473b-b563-08df366ea973
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 10:15:02.8607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBMw7bU5ATVx9U3Q87yo4fNwgg4A39Ak4V+pBeARA/8fbuhZFCJRvf+zuMAt+ep9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6681

On 10/29/26 17:23, Albert Esteve wrote:
> On Thu, Oct 29, 2026 at 03:16:12PM +0100, Christian König wrote:
>> On 10/28/26 17:09, Albert Esteve wrote:
>>> On Wed, Oct 28, 2026 at 10:08:19AM +0100, Christian König wrote:
>>>> On 10/27/26 16:02, Albert Esteve wrote:
>>>>> dma-heap already supports charging a specific cgroup at allocation
>>>>> time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
>>>>> originate from any exporter (DRM, V4L2, etc.), and the allocator may
>>>>> not know the final owner at allocation time.
>>>>>
>>>>> Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
>>>>> to a different cgroup after allocation. The target is identified by
>>>>> charge_fd, which may be a cgroupfd or a pidfd.
>>>>>
>>>>> The transfer charges the new cgroup before uncharging the old one,
>>>>> preserving the original charge on failure. An atomic cmpxchg on
>>>>> dmabuf->memcg prevents races with concurrent transfers.
>>>>>
>>>>> Not all dma-buf exporters back their buffers with reclaimable system
>>>>> memory. Some represent device registers, VRAM, or carved-out pools
>>>>> where size is not a meaningful memory cost. Add a memcg_account flag
>>>>> to dma_buf_export_info that exporters set when their buffers should
>>>>> participate in memcg accounting. The xfer ioctl returns -EOPNOTSUPP
>>>>> for buffers that do not set the flag. Currently only the system heap
>>>>> sets it, other exporters can opt in as needed.
>>>>>
>>>>> Usage example:
>>>>>   int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);
>>>>>
>>>>>   struct dma_buf_transfer_charge xfer = {
>>>>>       .charge_fd = cg_fd,
>>>>>   };
>>>>>   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
>>>>>   /* charge now on app1's cgroup */
>>>>>   close(cg_fd);
>>>>>
>>>>> Signed-off-by: Albert Esteve <aesteve@redhat.com>
>>>>> ---
>>>>>  drivers/dma-buf/dma-buf.c           | 43 +++++++++++++++++++++++++++++++++++++
>>>>>  drivers/dma-buf/heaps/system_heap.c |  1 +
>>>>>  include/linux/dma-buf.h             |  5 +++++
>>>>>  include/linux/memcontrol.h          |  9 ++++++++
>>>>>  include/uapi/linux/dma-buf.h        | 26 ++++++++++++++++++++++
>>>>>  mm/memcontrol.c                     | 41 +++++++++++++++++++++++++++++++++++
>>>>>  6 files changed, 125 insertions(+)
>>>>>
>>>>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>>>>> index f31f49ebd0af..07513ecedc10 100644
>>>>> --- a/drivers/dma-buf/dma-buf.c
>>>>> +++ b/drivers/dma-buf/dma-buf.c
>>>>> @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
>>>>>  }
>>>>>  #endif
>>>>>  
>>>>> +/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
>>>>> +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
>>>>> +				const void __user *user_data)
>>>>> +{
>>>>> +	struct dma_buf_transfer_charge arg;
>>>>> +	struct mem_cgroup *memcg;
>>>>> +	int ret = 0;
>>>>> +
>>>>> +	if (copy_from_user(&arg, user_data, sizeof(arg)))
>>>>> +		return -EFAULT;
>>>>> +
>>>>> +	if (!IS_ENABLED(CONFIG_MEMCG))
>>>>> +		return 0;
>>>>> +
>>>>> +	if (arg.flags != 0)
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	if (!dmabuf->memcg_account)
>>>>> +		return -EOPNOTSUPP;
>>>>> +
>>>>> +	memcg = mem_cgroup_get_from_fd(arg.charge_fd);
>>>>> +	if (IS_ERR(memcg))
>>>>> +		return PTR_ERR(memcg);
>>>>> +
>>>>> +	if (dmabuf->memcg == memcg)
>>>>> +		goto skip_transfer;
>>>>> +
>>>>> +	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
>>>>> +		ret = -ENOMEM;
>>>>> +		goto skip_transfer;
>>>>> +	}
>>>>> +
>>>>> +	return 0;
>>>>> +
>>>>> +skip_transfer:
>>>>> +	mem_cgroup_put(memcg);
>>>>> +	return ret;
>>>>> +}
>>>>> +
>>>>>  static long dma_buf_ioctl(struct file *file,
>>>>>  			  unsigned int cmd, unsigned long arg)
>>>>>  {
>>>>> @@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
>>>>>  		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
>>>>>  #endif
>>>>>  
>>>>> +	case DMA_BUF_IOCTL_XFER_CHARGE:
>>>>> +		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
>>>>> +
>>>>>  	default:
>>>>>  		return -ENOTTY;
>>>>>  	}
>>>>> @@ -750,6 +792,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>>>>>  	dmabuf->size = exp_info->size;
>>>>>  	dmabuf->exp_name = exp_info->exp_name;
>>>>>  	dmabuf->owner = exp_info->owner;
>>>>> +	dmabuf->memcg_account = exp_info->memcg_account;
>>>>
>>>> The initial charging should probably be done here as well.
>>>>
>>>> This way DMA-buf heaps only needs to pass in the charge_fd and we can re-use the functionality for other DMA-buf exporters as well.
>>>
>>> The problem with doing the charge here is that it happens too late.
>>> That is the reasoning for this proposal to move all the charging logic
>>> into heap allocators before pages are allocated.
>>
>> Oh, that is a really good point we need to talk about.
>>
>> DMA-buf heaps is actually a rather simple use case, but we have way more complex things.
>>
>> For example in some use cases the backing store of a DMA-buf is only allocated on first use and only then it needs to be comitted to it's memcg or dmem.
> 
> Yes. The idea is focus on heaps for now. But the uAPI is actually
> agnostic of the time when the charge happens. When we deal with
> lazy-allocation in the future we can just call the reserve/cancel
> helpers wherever is more appropiate. As long as the pages are not
> allocated, exporters do not set dmabuf->memcg, and XFER does not
> work (returns -EOPNOTSUPP).

Yeah exactly that's the reason why I'm raising this topic. That approach won't work in all cases.

See userspace is not aware that the kernel is delaying allocation or that the kernel is allocating the backing store asynchroniously in a background worker for example.

So returning -EOPNOTSUPP when the backing store is not allocated yet and might be allocated later on is rather questionable uAPI because that is racy by design.
>>
>> I don't mind implementing it for DMA-buf heaps first, but we should have the uAPI and it's handling so solid that it also works for future use cases.
> 
> Agreed. I think we should cover all usecases with the current status.
> Your feedback helped a lot in getting there!

I mean we can postpone that until we finally need it, but essentially we need to be able to distinct between charging, e.g. making sure the cgroup has enough free limit, and committing, e.g. allowing the resource to be reclaimed.

And then it is possible that when the memcg of a DMA-buf changes that only the charging changes, but there isn't any comitted backing store yet...

>>> What we could do is fill the dmabuf->memcg field when the flag is set
>>> (i.e., committing into the dmabuf in the patch semantics). But for that
>>> we'd need adding the memcg we want to charge it to into exp_info in
>>> order to support charging to cgroups other than the allocator's (for
>>> the common case would be simpler as we can just look at current).
>>> Maybe that's what you meant?
>>
>> At least for the DMA-buf heaps use case that sounds reasonable for now.
> 
> Thanks! Next version will have the flag removed and just use
> dmabuf->memcg as indicator, set within dma_buf_export().
> Also, `nr_pages` will be computed within dma_buf_export(), the
> contract being that exporters setting exp_info.memcg assert that
> size reflects actual system memory bytes.

Thinking more about it I would also put changing dmabuf->memcg under the dmabuf->resv lock instead of doing it with cmpxchg.

We don't need it currently, but the dmabuf->resv lock is used for all state changes of the DMA-buf object and this operation is not performance critical in any way possible.

If there is a problem with locking order we at least get lockdep screaming at us very early and not when we want to extend the functionality in the future.

Regards,
Christian.

> 
>>
>> Regards,
>> Christian.
>>
>>>
>>>>
>>>>>  	spin_lock_init(&dmabuf->name_lock);
>>>>>  	init_waitqueue_head(&dmabuf->poll);
>>>>>  	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
>>>>> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
>>>>> index adeea8cd328b..a764167167ba 100644
>>>>> --- a/drivers/dma-buf/heaps/system_heap.c
>>>>> +++ b/drivers/dma-buf/heaps/system_heap.c
>>>>> @@ -479,6 +479,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>>>>>  	exp_info.size = buffer->len;
>>>>>  	exp_info.flags = fd_flags;
>>>>>  	exp_info.priv = buffer;
>>>>> +	exp_info.memcg_account = true;
>>>>>  	dmabuf = dma_buf_export(&exp_info);
>>>>>  	if (IS_ERR(dmabuf)) {
>>>>>  		ret = PTR_ERR(dmabuf);
>>>>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>>>>> index 23ec0ff23fba..ac0ec88cab93 100644
>>>>> --- a/include/linux/dma-buf.h
>>>>> +++ b/include/linux/dma-buf.h
>>>>> @@ -433,6 +433,9 @@ struct dma_buf {
>>>>>  
>>>>>  	/** @memcg: the cgroup to which this buffer is currently attributed */
>>>>>  	struct mem_cgroup *memcg;
>>>>> +
>>>>> +	/** @memcg_account: account buffer memory to cgroup */
>>>>> +	bool memcg_account;
>>>>>  };
>>>>>  
>>>>>  /**
>>>>> @@ -505,6 +508,7 @@ struct dma_buf_attachment {
>>>>>   * @flags:	mode flags for the file
>>>>>   * @resv:	reservation-object, NULL to allocate default one
>>>>>   * @priv:	Attach private data of allocator to this buffer
>>>>> + * @memcg_account:	account buffer memory to cgroup
>>>>>   *
>>>>>   * This structure holds the information required to export the buffer. Used
>>>>>   * with dma_buf_export() only.
>>>>> @@ -517,6 +521,7 @@ struct dma_buf_export_info {
>>>>>  	int flags;
>>>>>  	struct dma_resv *resv;
>>>>>  	void *priv;
>>>>> +	bool memcg_account;
>>>>>  };
>>>>>  
>>>>>  /**
>>>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>>>> index 6b30baa79fa9..36fddafbef4e 100644
>>>>> --- a/include/linux/memcontrol.h
>>>>> +++ b/include/linux/memcontrol.h
>>>>> @@ -679,6 +679,9 @@ bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
>>>>>  void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
>>>>>  			      unsigned int nr_pages);
>>>>>  
>>>>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
>>>>> +				       struct mem_cgroup *new_memcg);
>>>>> +
>>>>>  void __mem_cgroup_uncharge(struct folio *folio);
>>>>>  
>>>>>  /**
>>>>> @@ -1206,6 +1209,12 @@ static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
>>>>>  {
>>>>>  }
>>>>>  
>>>>> +static inline bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
>>>>> +						     struct mem_cgroup *new_memcg)
>>>>> +{
>>>>> +	return true;
>>>>> +}
>>>>> +
>>>>>  static inline void mem_cgroup_uncharge(struct folio *folio)
>>>>>  {
>>>>>  }
>>>>> diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
>>>>> index e827c9d20c5d..ea957f4b1d38 100644
>>>>> --- a/include/uapi/linux/dma-buf.h
>>>>> +++ b/include/uapi/linux/dma-buf.h
>>>>> @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
>>>>>  	__s32 fd;
>>>>>  };
>>>>>  
>>>>> +/**
>>>>> + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
>>>>> + *
>>>>> + * Any holder of a dma-buf file descriptor can perform a
>>>>> + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
>>>>> + * cost to a specific cgroup, or move it from one cgroup to
>>>>> + * another.  The ioctl charges the new cgroup before uncharging
>>>>> + * the old one atomically.  On failure the original charge is
>>>>> + * preserved.  If the buffer has no existing charge, a new
>>>>> + * charge is established.
>>>>> + */
>>>>> +struct dma_buf_transfer_charge {
>>>>> +	/** @flags: Reserved, must be zero */
>>>>> +	__u32 flags; /* unused for now */
>>>>> +	/**
>>>>> +	 * @charge_fd: File descriptor identifying the target cgroup.
>>>>> +	 *
>>>>> +	 * May be either a pidfd, in which case the charge moves to the
>>>>> +	 * memory cgroup of the referenced process, or a cgroupfd obtained
>>>>> +	 * by opening a cgroup v2 directory, in which case the charge moves
>>>>> +	 * directly to that cgroup's memory controller.
>>>>> +	 */
>>>>> +	__u32 charge_fd;
>>>>> +};
>>>>> +
>>>>>  #define DMA_BUF_BASE		'b'
>>>>>  #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
>>>>>  
>>>>> @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
>>>>>  #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
>>>>>  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
>>>>>  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
>>>>> +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
>>>>>  
>>>>>  #endif
>>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>>> index 7b841b905759..3adc84fe6668 100644
>>>>> --- a/mm/memcontrol.c
>>>>> +++ b/mm/memcontrol.c
>>>>> @@ -5786,6 +5786,47 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
>>>>>  		refill_stock(memcg, nr_pages);
>>>>>  }
>>>>>  
>>>>> +/**
>>>>> + * mem_cgroup_transfer_dmabuf_charge - move a dma-buf charge
>>>>> + * @dmabuf: buffer to transfer charge
>>>>> + * @new_memcg: target memcg; caller must hold a reference
>>>>> + *
>>>>> + * Transfers the charge for @dmabuf to @new_memcg and, on
>>>>> + * success, stores @new_memcg in @dmabuf->memcg.
>>>>> + * Returns %true on success, %false if the charge against @new_memcg
>>>>> + * failed or a concurrent transfer raced on @dmabuf->memcg.
>>>>> + * On failure the caller retains its reference to @new_memcg.
>>>>> + */
>>>>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
>>>>> +				       struct mem_cgroup *new_memcg)
>>>>
>>>> I would make that more generic instead of dmabuf specific. E.g. something like this:
>>>>
>>>> bool mem_cgroup_transfer_charge(struct struct mem_cgroup **ptr_memcg, struct mem_cgroup *new_memcg, enum memcg_stat_item item, unsigned int nr_pages)
>>>
>>> Ah yes, I like this generalization. And the implementation remains
>>> mostly the same. Thanks!
>>>
>>>>
>>>>> +{
>>>>> +	struct mem_cgroup *old_memcg = READ_ONCE(dmabuf->memcg);
>>>>
>>>>> +	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
>>>>
>>>> This way we can also document in the DMA-buf caller that this conversation must be ok when memcg_account is true.
>>>>
>>>> Regards,
>>>> Christian.
>>>>
>>>>> +
>>>>> +	if (mem_cgroup_disabled())
>>>>> +		return true;
>>>>> +
>>>>> +	if (!mem_cgroup_reserve_dmabuf(new_memcg, GFP_KERNEL, nr_pages))
>>>>> +		return false;
>>>>> +
>>>>> +	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
>>>>> +
>>>>> +	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) != old_memcg) {
>>>>> +		mod_memcg_state(new_memcg, MEMCG_DMABUF, -nr_pages);
>>>>> +		mem_cgroup_cancel_dmabuf(new_memcg, nr_pages);
>>>>> +		return false;
>>>>> +	}
>>>>> +
>>>>> +	if (old_memcg) {
>>>>> +		/* Uncharge old cgroup */
>>>>> +		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
>>>>> +		mem_cgroup_cancel_dmabuf(old_memcg, nr_pages);
>>>>> +		mem_cgroup_put(old_memcg);
>>>>> +	}
>>>>> +
>>>>> +	return true;
>>>>> +}
>>>>> +
>>>>>  /**
>>>>>   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
>>>>>   * @dmabuf: buffer to uncharge
>>>>>
>>>>
>>>
>>
> 

