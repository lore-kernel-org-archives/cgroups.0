Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=52.101.191.128
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794230209;
	b=1ZmKxp9cAyVxGH0gyEtAdVccaCSdOUeif5Zezj4al/T8JBjdjEHVw37aftYaFODcDR2S
	 itLTa24prcLGcpAtYXW/QcAaO/zT5m6GYB51e3s1siYQjCYJ7Cr3cptbFki8ujKgD4+9M
	 aXYKqXyp8S/S9a7Uc4YvKaVlb/UJ23qo7RDrhQLnA9H7PB6y9Xjg6sDu6GRyEGrkB8Qbm
	 nMWkxVR1+cErYQ7EvTNV8NTVYvXw3aku7cyb2q175itZp7V4VQ4469NVyHbknJPlTkJdW
	 oCgjASa8R2buJkkWcEfuT3kWRvvGPSOB4/UwHmQFFJ7gKiyTUO0grqdlmO0v9quSC6A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794230209;
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
	bh=DynErxUbBsxpuEok4boDYuthCXDhDunU0h507qNMZNY=;
	b=M3i/llvjZ8RZ2ncOBHlPr7rQ1hOAV38xettUU+8as3PBTMFSq6ZFuykJbKXmaBEXMdMC
	 MCO+WrXRgUTXAiOTGYRheYVo38PveTPvwDyIhlcXpduCr7+B2APY5ZZ1Ct8ENO8M7uqPZ
	 jaspyAJ6mdaxJmcKQUpDE1PJJd/av36cu9gRRKxrEKUOBJel1BLUBm25puOlKFuES0wu4
	 oooPU8AKk1nmQh8U7l5F5qtb+TmUKoWzJU0LsY63bf16kvwT1qs1BYc2uzQqBsv16k9yL
	 vdx25zoFAI85k6K5niFlkyKqISTdf9yxaea25xF9TEufYlMOerIo1qq2GfNLj74ytyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=j3krXVp6;
	arc=fail smtp.remote-ip=52.101.191.128
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020128.outbound.protection.outlook.com [52.101.191.128])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A63606A31C;
	Mon,  9 Nov 2026 13:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97A63606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=j3krXVp6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PhcEKmGYjodJcRrL//17775TCV0+KBMZ67vHVSzwiikQJ9gfYqn5+1jpZOrnBjIFPfXiaulW3OMR1oyNiyDeTj9uUjPkIe4FQxSVGRA6Nqk9Q0LY8VnLUjfSxaI4sqau1wuI2H3AAEWc8gUqC+dMIxXzoOazYcHXBAlylLBf3PoWrgMhVXdwczc4IpU631bijziwLu680tCp7Jv+Ai/DeD4emWicuZHxpcNFKifWYKJKDS55zHG/24vHLV2foD/Qxxihe6rDYGQNDamfzM3xMTBbJr5Tr/IuHjZRh9Rnhvgzabft5XeM/kR8Rt6sGqUj7bkwYZCyreWyGj/ISDNa8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DynErxUbBsxpuEok4boDYuthCXDhDunU0h507qNMZNY=;
 b=t11sKPWKDmuYXojh8QG6x7+TnRtPKhG9qf3BYHlT1AlEuPmNn3IzmOYZ/G+cwP/BpLmnufXyrTB7dlG0hTay9Z3PzB5IZ8YV0e+AF7cMCDkodkHQHfkHO0QErTfjvFl3bmzoS3+KpMh/qKuzJm66P+m3RD6vI7lFWfYs8RnTcnIknkc4KZ/Ds2xh95X7YyuSXXQl4qPo4gwt2uw065uidQDWUUkpOLRt5eRmolNCHsgcgta+wUjKgObefRLr7EJXzCXtsGxHDyoULQtkIp0yaGAOT8YuKvU6V9fB6epd9t76ltvowSjykN6PYD8c+5HCAE4nf48YJs7RSrlrRfjm4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DynErxUbBsxpuEok4boDYuthCXDhDunU0h507qNMZNY=;
 b=j3krXVp6x7jiuhs8FNbGi3rDZIECqgiW5X5l7a5z3V70/nD7I+Hss5DVwJY/+KeoQ6r0o9oN1jIYe9gGoMkWVumPR2Vzn2EG37uJ4duQnwO10QtR2SYF8OZ/khAFGRXPluES13iM4uxP77mWqnpgQDysjrF8X/WVTwPQW5yDzylAJIG01Y2Tr1AgF9Hu0DTTgEamDS4AB5ZcFDP5dD1Ovg8MhR1yK9Dpce69OyaW3XJFrVOp+1VLyRycCSpA6FRH1cN5Gb5nOWoecL/nImc8coZBjnDXTD8Omp0a0hxjyJHkdPXHaVEW9W7xjr3o+s12paqqLL5Noan3FkhrNQtRGg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT4PR01MB11683.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:159::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 13:16:44 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 13:16:44 +0000
Message-ID: <7546267d-8b07-4387-b673-f466ad7754ba@efficios.com>
Date: Mon, 9 Nov 2026 08:16:42 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/29] sched/deadline: Do not admit bandwidth for
 parameters that are kept
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
 <20261108185406.1549770-4-mathieu.desnoyers@efficios.com>
 <avG_pJmgQr3V-PXZ@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avG_pJmgQr3V-PXZ@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0197.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::34) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT4PR01MB11683:EE_
X-MS-Office365-Filtering-Correlation-Id: 53985059-7ed2-42a5-65e7-08df3e63b375
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|5023799004|4143699003|56012099006|261021121427099003|261021123027099003|261022105027099003|261022075727099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	emCR4Kglc01h3GSf31YmkammGnY/5dVhabs3JKEZ0ddbkC7b0NxRvjFNCBpo91Aq2fzfcPT5M04A75kNlCIJZkENax9+aWJD+/kP6W3p5iL4p5+E1/4XCj4fCyh0+kWiRlr55tbJcZF5ACIjMWt7zsyN8QcqtHD0hSflbeFZlSq0nItFg4PO92i3pgrFIrPYNgoQf+WvoVi6Ai1+3vxse0eOb45Mn+FXUxUDeboKlzIUr+d2wNDIbFMuiHMJZVsXeRsepKcSOo86MUT2Zb6eO5+HR7pO43Z8+OhKxyZKBkb1zt/elH/9WaUSM63GOPagJPZXQ7AR8ruNt+X4EQvRTIhiDczwcatElv75KEDjQNCNT68P9R04JZQKJaksrRayprXPo4xikalwU+I/YQhlaYk3LxsLE8mLSlD6keFC4EPdrxGW1t25xSZMf5roKFdDgFtUrvMaqqUph8b1wZflC4K3/lPDk4C/C7IZDwtuBR/fbEhhCMQIAKpK3r0lCegxX3WcMKEAxzPuysjdHIKH4vqlezEhvqaILNKEV9rV7I0EW5O7ubtEykNokqjZBRZ4COPp9NY3w1MK5z6UdOIIwnn3o7uqcqc6pCDXzcEGCuw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(5023799004)(4143699003)(56012099006)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3dCc2M4OTk4TCtPTUxNNytyVFh4c3V5ekRLU1BJRXFtZzBLZnBXeUp6aEV5?=
 =?utf-8?B?ZGlMVVRNVDlZQU1CNnVqYzRraVNaMmZ0UXp2SFdSczRKNjNVMVp6ZmVHdVgr?=
 =?utf-8?B?MXpQcnQzYjFydVhwaUh4T3VMRlZScC9xU05TemVuOWtEdHNYYmRWM2RITVRk?=
 =?utf-8?B?R2IyMm1mZ09jVndCRFB4OVNML0w4cW1rSEdXY09ldXhrcStrd0R4eTFaSWJW?=
 =?utf-8?B?T1kzVHd1aFU5TVdyK3ZTN2pHbHZHeDUrRitabk5HSmx4K1Zra04vbDNCWWZC?=
 =?utf-8?B?TGZ4eWlZVGI0eU0vRWFNd1FDRGdtZG15OFF5MVN0YStjYnVDMHdlQlFqcjlk?=
 =?utf-8?B?UCtJelhPSlZQL2M3ZllPS2c1MlZIczNXYnBtcGsrT0N3L1k0dTNtVGJrc3pD?=
 =?utf-8?B?YVkvaUg4RTQxckUzWmQ5M1RRcWZJUVV6eThyeTl1NGlNSWdNVDVIYzNjWFh5?=
 =?utf-8?B?MHlrMmhSUW1ickNnUEpVTkNtTWdueEF4a3pteG93b0VyL3pQZG1CbUszTC9E?=
 =?utf-8?B?bWx5SXdiaFRXdmFCL1pNNWdUYmNyaWVzVTZ5R1hKZ1BjNUI2SU9pMzJDVVM2?=
 =?utf-8?B?Z1p1ejF5elk0OFlUNnRRL2F3WTFFcENRWVNPMzZCVFN0RmhjYkVVMHlwbjVu?=
 =?utf-8?B?ajM3ZDZYOG1ySktPc2VZZ0taSndrY2JxdzFvNzE5YVNhalFPdTFxdUtUU3Yr?=
 =?utf-8?B?aWJ5MFUxRVBkKzhHb0R4UEhnU1VZdWtiWlhLVFE1RSsxekJIZmpsVTNiZ2Nq?=
 =?utf-8?B?aE12eGErOTZEb0ZlZ0VwMkNzQU54YTgzaTl6VUgyTmdnRnVNWlBtUWYraEFD?=
 =?utf-8?B?dDBTQVBYc1gvdXNtekt5YU02OTU0QnNkR3dnYWowQjJraXZ0NG9qS2xMOXZ3?=
 =?utf-8?B?ZVpiUi9xSXhGNWVBVGJXUzJQb3pmK2lMeTVoUlNqSlllOVp3WHhKSE9JMU1u?=
 =?utf-8?B?RkVjYkR5RWpKcTBBK1o1K2hGMWdDQUZORHZ6cm4rclRsUWdnTzRyTGMrVEFu?=
 =?utf-8?B?YVhzRXVwcGpGa2dYbmx3b0tuNjV4ZkJrQmxOc0ljYlBMVkhVZlUycnpFUkdz?=
 =?utf-8?B?Y0pQbExMQ1ZSdjFjVTFjWXFtZEFRY0gzclBvaEZod1JuUUJUZEFuRjRoZHVW?=
 =?utf-8?B?WWIwc3hPZTJpWHR1WjYrVVU3WHJLeDYyWVdSWExuc09PYUhHRGdudnd3Rmtl?=
 =?utf-8?B?ZHYxQy9aSXFhTm9ZbjlSbnBXbDYwZFN3SURxY2tBaUJVNm5QK2JFaEhERWdU?=
 =?utf-8?B?dUIzMlNlNjJhbjdjeDZlc2xvMFJNb0dERUM5QjVFTUFLbkpCTHF4alhRN1k0?=
 =?utf-8?B?bzBnLy8zanE4QzRNcEZGNkVVR2pLc004UTNOdkVFbjZ4MWUycHdLZnIyb1Yr?=
 =?utf-8?B?K2N6UmVrYzU1RCtIRVlVS0VYdlpOVXNvRW1ZNnVjc3RGQ29kOUJJcmpZa2to?=
 =?utf-8?B?QzJWQjdQdXp0YkVGVDVGRUt6VmZYM09YL2pISlZuVXVVSVlKci83VnZ0Z3RT?=
 =?utf-8?B?Vk9yOEU0ejNsUG81b2tSWUNkOEt0YlRVWko3Q3RTa2czZFJxaW9iRldZQ0Ja?=
 =?utf-8?B?YkJPZkJCZDMvNUlaUDR0dEdJWXV2WUdkTmpyZ20zYnpNcHlGWVNQR0hIZzhC?=
 =?utf-8?B?TWRFMGhJdXYzU3I2Tm11OUVJTHNGcVM3b1BxQk9kV2U2UjdMek5aaTl2Y2Fl?=
 =?utf-8?B?TlVZNy9IWmlNSS8xcWVEK1dOZ294cE8rY2U5Y21JUXQ5ZFJhL0sxSGUybUpP?=
 =?utf-8?B?cGRGMXpraUR3b1dLWjUzbWxGZXVpbm5Oc3d0Q1VWN1h4bXp5YTlta3dxTjll?=
 =?utf-8?B?N1VMWllwcUN4YVRwcDBQckhHa0M0UEhlOVoxck5CQU9GRUh3Y0xuSC9XdWFq?=
 =?utf-8?B?SnhUMXV6eWVpdjlBU2RZWHc0SzVrM1k4VTJDS1NqRzdjVXY1S0gwbzdlMnZm?=
 =?utf-8?B?b0FYUkNMaU1TYksxSnRqV0gydnU0TGNPa1MzN0ZLZlVDVzZjQjFPK0RmbGpL?=
 =?utf-8?B?N3A0NXk4SWpZc3I3R0drTFJqdEtJYW1XMXlET1B5U3NOZjdCUHFXNTFjWFNP?=
 =?utf-8?B?UzRJSGg0eGs5OG1UYlhJekg5djI2cW9kQXEwVStTb0VqZjRVRlQwalZyclVo?=
 =?utf-8?B?RmV0TEhDVUJMZ2lXSzRsTzUreVVmemZ5eE01WENhMU1pb0E2aFcyUmlMdVdO?=
 =?utf-8?B?UkkrV3JwVE14TFVHWVhCLzZSNUloNlh5R0h3c0RnZ0lTbmNoaTZOVHJtcGx5?=
 =?utf-8?B?eEhCazJBZUVUMDE4aDJBOUVYb2dJQkZHOGQ5MG00WGZRNUtMOCsya0QyYm1T?=
 =?utf-8?B?YllFajVwM1QwZVl2WWhKR3Naa0o5Q2llSXpxVDUvUWVFNnhqVldJaG1TWnlo?=
 =?utf-8?Q?cB6+r9WYRTWF2rQbU/gePRRl5wtqYn88jV9t+?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53985059-7ed2-42a5-65e7-08df3e63b375
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 13:16:44.4493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JDvJjnS3un4aCuY6WDjSK85ZdQMqRtpCA0TiCHZ2udARupzZartcVhyZDX7N5JuN/ndMvD9/rhS+vN4h1cIomNnUvzy0YmnzgF8rxb7IIBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT4PR01MB11683

On 2026-11-09 07:42, Juri Lelli wrote:
[...]
> 
>>   kernel/sched/syscalls.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
>> index 0e8b5c7324f6..894f93a80d5d 100644
>> --- a/kernel/sched/syscalls.c
>> +++ b/kernel/sched/syscalls.c
>> @@ -690,8 +690,13 @@ int __sched_setscheduler(struct task_struct *p,
>>   	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
>>   	 * is available. Keep this check last. If a later check failed,
>>   	 * nothing would give back the bandwidth it reserves.
>> +	 *
>> +	 * With SCHED_FLAG_KEEP_PARAMS, the task keeps its parameters, so
>> +	 * there is nothing to admit. The parameters in attr may also be
>> +	 * stale: sys_sched_setattr() read them from the task without a lock.
> 
> However I had to wonder what usecase would still make sense for a
> KEEP_PARAMS call on a SCHED_DEADLINE task, I would say a !DL params
> change (UCLAMP for example) for a (at the moment) DEADLINE task that
> might become !DEADLINE in the future? Maybe we could add this to the
> comment.

Yes, that is the case I see too. The deadline class does not set
uclamp_enabled, but __setscheduler_uclamp() stores the clamps for any
class. I will extend the comment in the next version:

          * With SCHED_FLAG_KEEP_PARAMS, the task keeps its parameters, so
          * there is nothing to admit. Such a call changes other attributes,
          * such as the utilization clamps. A deadline task does not use its
          * clamps, but keeps them for when it leaves the class. The
          * parameters in attr may also be stale: sys_sched_setattr() read
          * them from the task without a lock.

Thanks for the review!

Mathieu



-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
