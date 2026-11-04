Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793810006;
	b=inCtQbJV02A36gg5c0um/wpnzDR7wQWcMsI0uC7VYb8h6wpfDBlAix+Qz2DJPwNvzx3A
	 4Rtcsu0ppq1Z3+H9PFhD0nUUS0+TSbG6magLEHM3n9oClFtk32turBMgtMYHv5hvVftx9
	 yh/JXI4EdZHOJVdVA/C1G2ABz9ZaJRtyTjXNi7pfuUC9kIjLYhJDZnwOITGbShZmpR70t
	 Jdyo3Wb5ucmIxly3L34bhtR3eFeq1Km6+kLHCK9QuToG2UirrvVZ0MLnuMOkUviQh4gAb
	 JHJvbV3d+y0ZI4aiuRUeGMtUTVua1OJogxJwDHUGtFMMLrNqz76ksPaFogw6SlzZXOQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810006;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Subject:Cc:To:
	 From:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
	bh=myhXyle9lO2SIRjoXQ60s9A2f4kGSdTHXzw8uuNpnb8=;
	b=NpmrVzBqP56D1JN9FrJPbrmubluIQ7pmesg73y7QBrkARmaWqIp71TvmsZxS0MQCrWVd
	 hyIgcY2UKxzFqBE/867nhert+gglV6DF112+5BmjlVFc1nV8dztwz/fpFhegx6g3U5RqE
	 iLykz2npjBrIjJBQF5Y8Afnj7FpyKDEEO3pX486a7av8FKXBp+QFignkQtMxdnLhzpQxC
	 eDW+5xAmhuVE82UuYFqRy9rICS2t+FLiPKtUuuxdveBSlU+FQmXjfm2ZKbc/rKgNZLqau
	 94ou5DBd0gfc871lUQQ6LhShO5AG7W9kHZ8AD6B7p4rFPYBSOsXqTFixuz9YG7dZSHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=sbKjyiLg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.38
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC610606A31B;
	Wed,  4 Nov 2026 16:33:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC610606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=sbKjyiLg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HAwFp2GzPsPJS8Vz+2xuiE/iGDwQbTp1wPl4r60gLxnSb+kTezq6GCg6zf7aaBvbK+JQ09WpedHAbvp+tXI+zz3EHFt2BzQKj3fCN+u1Ovh/2+/VgPKVBJ+JuCHVBzpyA3uEARJzwM/QWJNgjkWN+jSfz5E86LYtNvG9ElfGr7JTNMRZdxV/c/rIzsWzrEvk3wqDqFp2ZWOb2WOZur4tebxnrrxHCJdEETyqVbDSifRqSRJriOydBGz8lGpnfPKAS08b4SJdXLo+Rp7gFvtyHqsi+0unNkP+h+Y9gU4Gp/1j9xuw/3+x9Nw8lAmZqkMjSfl+h70lnZrLSoUdThudNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=myhXyle9lO2SIRjoXQ60s9A2f4kGSdTHXzw8uuNpnb8=;
 b=oRzZXD4pm+FTqv7RFaq18Glzjh10si9vZN/bsd/au259myws2ib0hjLLbEXUBAR5/lXVbt4tM0gbPPyU5+wxd2x1jEtbSg1yQuZ2CSQWJCT9nqMAaxDqABOm8RaDp6AFUQvq9Fwstisfv+ci305eWjjxCVF/bHXNoheGT0PTTMHA/DY17whlWyr+dr+S9p1019g0kY05RFfZuwAW1EGSIj3jnLjuCw03xJn5v6nSRFdo3JiEFJcBnxZP+dEeDiNFYUDEILaAl73PUU8y90Nj3OfnOkEwMR0O1XF55JFOiMG97BJTHwusUk/ebGdvygkVvUeiWTgkcKVQZwj2tSGtUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=myhXyle9lO2SIRjoXQ60s9A2f4kGSdTHXzw8uuNpnb8=;
 b=sbKjyiLgBVxvNXcR4Ixor8NltI1nDTiDVxTWUCHGacKKMLqs/+wEZyIglw582RXZFrALLbhN+Y7Ua1L0EftwjnfPuZRBnaOgnbA3BOUO/6Rg8NGSDwEKJfnOsBjyqKX8agFqk5qnmDVYlOLYq08LIFCAxZlcX0XJNKZ++OI8shvaZmas1o+K0wnftE8tvFZ2KUckLSd09kx8CGu8XS6fkvPNuY052QUTfZ3+dvohc2KXam9CJ3tEP4uM6njY2fZb/zCVa/+l5fRlb9+WSpWpiTHH5xThOxZZxjwpWIDH+km6WeKdXCFdmLcv1ji+tAleWzVu1JOJtGu9i75YEXfCkA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB5903.namprd12.prod.outlook.com (2603:10b6:510:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Wed, 4 Nov 2026
 16:33:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 16:33:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Nov 2026 11:33:17 -0500
Message-Id: <DMMKKOIGA9UJ.353PCUUMFLCCJ@nvidia.com>
Subject: Re: [PATCH 1/2] mm/huge_memory: set memcg_data before a split page
 leaves the folio
Cc: "Tao Yi" <escape@deepseek.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "David Hildenbrand"
 <david@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, <linux-mm@kvack.org>,
 <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <stable@vger.kernel.org>
To: <daejun7.park@samsung.com>, "Andrew Morton" <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
 <20261104-kpagecgroup-split-v1-1-f70e947fec85@samsung.com>
In-Reply-To: <20261104-kpagecgroup-split-v1-1-f70e947fec85@samsung.com>
X-ClientProxiedBy: YQZPR01CA0047.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB5903:EE_
X-MS-Office365-Filtering-Correlation-Id: eef6f414-1eca-44da-5ac5-08df3a9155db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|4143699003|11063799006|261021121427099003|261021123027099003|261009223027099003|56012099006|261102123227099003|261022105027099003|261028144727099003|261026140227099003|261026121527099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	n7J4XfH+96SCEvbW9g7J7yR+bZ+jkMYIDeLuuXaYWnGNN3Abp3HGl5nuYHXnRF+E/BrCPfT7+iM0HUNJhCIzP7P+MAKMXZg2iRqMW8QiTfJnPPa36BCFK83M7uFeCPpopoylFWQ43+8yRk7S2bLGDOvOoETdaju/irOkLDnqbduO4+GNS3aRpr9mafEUTEQY+mA7bhCIYL/WcU125pTNG4ZYMCmWNciVl2Pb3wmaEK7JzaZP/bzfHTJzz6e5ycOng5BuF4B/SJq6X3bl9ofGkygxmZgFwuIdfeRr2t81+i3uhJSeZnzim3Mx/ofnpgCMGTz13xR0WeXy+0m5RbDoVapyd4k5hukE/Sjv+haXpmbYh91Sy1l8si0r/P3Slpln1C4D6OZegftLa6JPo0h3//DoTNZtQoXT0g/5IkPrxDrVtIeqQH/hxharBijEvyGyANsrOG1nM3ZrCqXaKwuNlNYsol/h0mBDSndXzZLEgDzdWqcgcKgChm5cofliwOUasKR1YJYnsyrEaUCrjKJu1qmMf86OaEHffvLyzL6fbkjgNHEhLJdVBEKH4Em9Hfmk9O8dSMSmSwXESWMXR4Zh487xHZQ5VyWqU4EArJnNKJg4I340T2m+7+qvC/prUl2lCTBi1/0Y6xs7qmjt4prrgeiV5uZfGN1vX8SIawv08pA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(4143699003)(11063799006)(261021121427099003)(261021123027099003)(261009223027099003)(56012099006)(261102123227099003)(261022105027099003)(261028144727099003)(261026140227099003)(261026121527099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eHcyd1NhaTQ3cGlyNjdHRVJydTNWZHRJbkx6RDBKY2luOWh6V0Uvak9jKzI4?=
 =?utf-8?B?VklWYmNWVXc5NzB4dTZ3SHZ2OFRlMWZkWjlObFhXY3A1d2dOVUNoTWZjV3d1?=
 =?utf-8?B?SVZUK0tud3JucTBzc2VQL1djc1pYT3FkWWtwbDk1OGdzMG5ILy9lVk4wM3FY?=
 =?utf-8?B?RnU4NHNIbXpPTW9WMmdLbW8wVGQ3bHp4TGZwVVcxMDQ3a3NQSFBjdWVMNWNO?=
 =?utf-8?B?ckhIZVZRV1NTelVxSWxYTmQ1RUs3bDVUSXdpb2NDSDB2WmdhNjlubFgwTEJM?=
 =?utf-8?B?OGUwci9XeTJtR2ZsRHl4aXhhQWkvV0ZBbnJxdGloQkR2L1dyZTI0OFZVRXd3?=
 =?utf-8?B?MmZ5UGk2TWU0dlUvUW1RNTdYcWlVMStweXlyUkZubEUrNzJ6bVdSMGV2WUdT?=
 =?utf-8?B?ZWZyWE9tZW5QTDZNU0hWWGMyUDBpdFgxNXpha1VITnlHRjVWUmQvSHhBNGRi?=
 =?utf-8?B?M0dxdXFyUDY4MTVZRElaZXR3SFhxYnBBbGRyMTZkcWdJN25OVVZTZ0JRak9r?=
 =?utf-8?B?STZPbnQ4UnJKSUZZM3ZDUEplOGxMOTRHV1JMSmNJWGVGaFo0Ym9aUHhXdEFh?=
 =?utf-8?B?SURTZVFKNDltVWx6LzhLWkxYd21kWkZBSGRZbHZWNmh1VkN1SGUyVFFZTEtE?=
 =?utf-8?B?UnMybXU1RVdDVmNETUFoSnVoZHJCbTc0QVhTMDZYWmVzMVlUS0Nnc0dESWIw?=
 =?utf-8?B?Z280TFpTSzFhd0JsblZadDZVUTdscmc0TXNVSEY4TThEZDRNSXFmdjlGb1dv?=
 =?utf-8?B?L3kwU0JmcE9GWnUxWHVjTXVGTTlsOU5VeSs3NFNhZWgxQTBNNUZudi8yMW82?=
 =?utf-8?B?dzNHQ2ZhTzN5THQvTFE2bVpyWTdlMUE3QlhTZTgyQTl1VDhpYlVzaVdJL3BB?=
 =?utf-8?B?RlRRMmszK0hiNXBLNWVwSHF2ampabUViNURZaGdxSnlHK2VmMVNwclNsamo5?=
 =?utf-8?B?Vy94bjgyemRpa0k5NXovWUJSVGQ2eTFGL0xaRHYxWG52SlJwVmd1R2hxcmZz?=
 =?utf-8?B?VS8rVXZrdUF0ektNd0ZSQlp6ZmhWajhmV1VkRjI1RVZ5S1NYRklSNCtZSlhk?=
 =?utf-8?B?OWxxWXlISTVVb0x3RGp0dSsyeDIrM005K01XaFFXYlQ4RjZpNnZmTlJmQWRV?=
 =?utf-8?B?KytKYzBNZm4rbU54WVJNVm54R0VaK1paVW4xTnovcnlZYjQ0WGFEYzJaemZM?=
 =?utf-8?B?aW9Qdlc0YUhObC8xV1d4eHQ4eVpLTGxPdDFYcWZPcmtJbkl6aXJ5Zkx2NkV0?=
 =?utf-8?B?VGVGdTFxd0dGSkRQZXd6RTRKQkhUd1gxQTdCN25zY2VRTktLbUJkc21KVmpX?=
 =?utf-8?B?UmFwUzFBQjhDbWc2Sm9CUFVaMFVqYnhHOTcyVUhUZWw4VE95OFdVVXp2Sm1a?=
 =?utf-8?B?QlppbUxqd3NhbHBObXAxNEE1Nk9DMjZ4RFlFL21Vb2FoYlRndHVHbk5kMGdQ?=
 =?utf-8?B?YXBIU1dIWldNcE9lN3U3ZW9KR2Fpa1dvSGY5OXBtdDhUZUJxTkNzdEVZd3Vz?=
 =?utf-8?B?RzRNbDFBTFVQS2lXYUgrcjBEZUVpMU1YclY0enVOUmlja0RrS3ljQ1dYN0ZK?=
 =?utf-8?B?ZVN4KzUxYVQ0NG5TQ0FXN3B2bGYzVENOUDJKYW1CUGdEZXM5YnhNL3M5QjYw?=
 =?utf-8?B?ZHBwZGlhdUptUThJaFlXY3dXL0s1SHhwWU1RZUx1cXlPVVFXcGgvbmcxdmpv?=
 =?utf-8?B?Z2htQWNlTitNSDl1R0FQMjdoRXZoeTB4Z1NZTU05ajUzOVUvVXlIdm5scWVl?=
 =?utf-8?B?enprZFB5dk1wb3dOcFM1dzF2L24zMVR6Y0hsQytQbHFRNzNpdHMwR2M1akhL?=
 =?utf-8?B?ZXN0Tk1LVGJabE1ZWVFZbEZ4MTNOM2lJSUJFQ1ZsaU1HRzdrZ091MnJ1bXhu?=
 =?utf-8?B?UFNSN1BFQ1c2N04yVCtvNGVyTXJPSFlIbHZFN1hLS0Y5R1NkcHhqdXh3cy9R?=
 =?utf-8?B?dndsOTZqNTROSkdwN3A0emdnRE9VYXRrbVJGMG5wV09oS3Rob3lLQTZjaVNK?=
 =?utf-8?B?QWJMcWxHS2V0NTNZTGZvckRmNGNvcmxFM2E3OEhxZEdlczZjVHdMdEc1d3VR?=
 =?utf-8?B?dlVJemdackw3MmsrQ1VJc0t0WGhOeHpIQWtqanZJMVU2djJPMXp6c2JIdmJ4?=
 =?utf-8?B?T1JjREpUVGt6dm9nWTd0dFlvcGpPZlFUeDUvSDliRHRIWk5UNlRsK2F4bnRI?=
 =?utf-8?B?SXE2M29uZk5jWC9vZklJVmYzazdjcFZRdHd6YmZTUjhUTmh1OGRXR1U2eHFy?=
 =?utf-8?B?Z2ZvV2E0NEdoV20wWWpWd2M4cWtPeWgwNG9CZStPZnluWWVMZGlGemJuTHl6?=
 =?utf-8?Q?dQwB6rOp0hUcq7pPVq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef6f414-1eca-44da-5ac5-08df3a9155db
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 16:33:19.6931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q0aS/bc78hBdpzengt1ATABZEeJi3E+0w7B83VB8hvLdv/IarKim2Sey5PRNv1rL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5903

On Wed Nov 4, 2026 at 4:59 AM EST, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
>
> __split_folio_to_order() copies memcg_data to a new folio after
> clear_compound_head(). Until then, memcg_data of the first tail page
> holds the folio's _nr_pages. page_cgroup_ino() can see that page as a
> folio in the window and take _nr_pages for an objcg pointer. Reading
> /proc/kpagecgroup as root then oopses while folios are split to
> order 0.
>
> Copy memcg_data before the smp_wmb(), as before commit fa23a338de93
> ("mm: separate folio_split_memcg_refs() from split_page_memcg()"). Add
> the paired smp_rmb() to page_cgroup_ino().
>
> Fixes: fa23a338de93 ("mm: separate folio_split_memcg_refs() from split_pa=
ge_memcg()")
> Reported-by: Tao Yi <escape@deepseek.com>
> Closes: https://lore.kernel.org/all/20260907124001.1544655-1-escape@deeps=
eek.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> Tested on x86_64 with KASAN (7.3-rc7 and mm-hotfixes-unstable) in an
> 8-vCPU QEMU guest: six threads read /proc/kpagecgroup for page 1 of 64
> THPs that debugfs split_huge_pages splits to order 0. Base oopsed in 6
> of 6 runs, 4 of them within 1.5 s. With patch 1, 8 runs of 300 s had
> no oops.
>
> Before 7.4, page_cgroup_ino() and folio_memcg_check() take non-const
> pointers, so a stable backport needs "struct folio *folio" there. The
> hunk applies to those trees without a conflict, and the build then
> fails with CONFIG_WERROR=3Dy (-Wdiscarded-qualifiers).
> ---
>  mm/huge_memory.c | 17 +++++++++++++----
>  mm/memcontrol.c  |  9 ++++++++-
>  2 files changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 14599d0fff..adc5a47ee7 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3768,7 +3768,19 @@ static void __split_folio_to_order(struct folio *f=
olio, int old_order,
>  		if (folio_test_swapcache(folio))
>  			new_folio->swap.val =3D folio->swap.val + i;
> =20
> -		/* Page flags must be visible before we make the page non-compound. */
> +#ifdef CONFIG_MEMCG
> +		/*
> +		 * In the first tail page, memcg_data still holds
> +		 * folio->_nr_pages. Lockless PFN walkers (page_cgroup_ino(),
> +		 * page_owner) read memcg_data once the page is not a tail.
> +		 */

How about? Because clear_compound_head() makes the new_folio be
recognized as a folio by reference-free readers.

Assign memcg data before clear_compound_head(), so lockless,
reference-free readers get the right value instead of bogus data from
the overlaid ->_nr_pages in the first tail page.

> +		new_folio->memcg_data =3D folio->memcg_data;
> +#endif
> +
> +		/*
> +		 * Page flags and memcg_data must be visible before we make the
> +		 * page non-compound.
> +		 */
>  		smp_wmb();
> =20
>  		/*
> @@ -3803,9 +3815,6 @@ static void __split_folio_to_order(struct folio *fo=
lio, int old_order,
>  			folio_set_young(new_folio);
>  		if (folio_test_idle(folio))
>  			folio_set_idle(new_folio);
> -#ifdef CONFIG_MEMCG
> -		new_folio->memcg_data =3D folio->memcg_data;
> -#endif
> =20
>  		folio_xchg_last_cpupid(new_folio, folio_last_cpupid(folio));
>  	}
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 84f4a8fd4d..c244d56446 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -375,12 +375,19 @@ struct cgroup_subsys_state *get_mem_cgroup_css_from=
_folio(const struct folio *fo
>   */
>  ino_t page_cgroup_ino(const struct page *page)
>  {
> +	const struct folio *folio;
>  	struct mem_cgroup *memcg;
>  	unsigned long ino =3D 0;
> =20
>  	rcu_read_lock();
>  	/* page_folio() is racy here, but the entire function is racy anyway */
> -	memcg =3D folio_memcg_check(page_folio(page));
> +	folio =3D page_folio(page);
> +	/*
> +	 * Order the memcg_data load after the compound_info load in
> +	 * page_folio(). Pairs with smp_wmb() in __split_folio_to_order().
> +	 */
> +	smp_rmb();
> +	memcg =3D folio_memcg_check(folio);
> =20
>  	while (memcg && !css_is_online(&memcg->css))
>  		memcg =3D parent_mem_cgroup(memcg);

Otherwise, LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

