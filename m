Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.192.110
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794586459;
	b=ZT5YLA09yr44tnHg2RCgSlla8YYZSoJy/iqXbVHrVJehi8pyW91BQvL8G4hBLyNDHNjb
	 5Yod1LZ7IDdZUj7SFpv3Ok6pPdo61Wf9kJQSO/OohGutkrlJ1v03zWmbDyky1CDDsZ/T8
	 eFykGTnUg1ddGTDYsUxMw/0bqPPHPHlb4fEiAoIwzxXQ+bIMDb1Sb1KmoQyYA3t98nSQT
	 4ebLn7R5T1+1MGDMhmHUue5FFgITuctfRO34k7mWRDvBYRhmjo70WpDAROvaVV7kcOffw
	 NkZmEGBc63o8BspMtovyaRTVGQW9NVmjphJ3Vrio8Zj8cM2r/hrDtsbCv5StWUqqPsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586459;
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
	bh=6hI5tNXA513NBCy0gNIQ8HQ+bb2KKxu3o9tRZc/rsdM=;
	b=a5+4PGaGLfHT5wuSKRbusEv7915Q/Nxt6qjEWSxNAE3Znb6TzDGETOxjgNfe0MSW3Wej
	 U/qA893tgvLjF+jcDbnYQPxGurg9n5bIoqibIXBnq/SgAA6WJrPziRPfWhKVMXLzblbJf
	 hDMZTueucv8SNmWhhbLgw3CRNs4pnhM9BGGGtAOfWiNTntuUE31nNZbNLhOX0PxiBKURI
	 PGGpN3c5/N2V2UujT+35W54ZajWQdtLEJsHH4eKa1+E5yYaa0D/8I9eRawBohb2yfM4//
	 lLmp9bXqICNnR3Rsrico+AEdZZZhaiLQPBR68KO+SyuFf+zeXg10oI7+gG+sPBLnsBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Luv78FCa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.192.110
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021110.outbound.protection.outlook.com [40.107.192.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D306070233;
	Fri, 13 Nov 2026 16:14:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38D306070233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Luv78FCa
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tWog3Q4la1RXqGICfeG8MMdmgaFzwKPzWO4UcFMh6+G473XjeLSsYZZh5MVLvc5hnN8s3M5CUGRioNlj1EXH4DBKSD9g/85ApZkBPpqNYMV+tH2eZSHiPyi8B0MpBVh9uV/omqO9ZxZ/lU7JFPPjjplvhFL0sAPEhdt2fFnL5mcw41zby6Ij19s17ZxxGdal8LUvXL/q3/Y+zwMkXJyIFFCGOvTTWUiQts0mbLkkEVTA60FOiOCL8M+/cwUR3568r7TCwwPjrWfOMSf53415JlNUY7IfCfqy+NF+EASb4q3GW4K1xdhfiLljM8oA6Fh1rLrlN2Nc2lDI6raztDHxMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hI5tNXA513NBCy0gNIQ8HQ+bb2KKxu3o9tRZc/rsdM=;
 b=cEVfkR7GWdUH9kJ+iPRqeYyjOJeF7tZPykvW8W9/RuR4tXnXUyS53RThF2x5kLWTXc7THS822qU16bx7/CoVGJiqKRohz5LG3LS+jtdoZoZKQzSGfJRlS19EpSEcn3RXC9VIjrhmYCgPsdhKrgdebEz+osC8H5D30zdRkz92y2YPhcXrXaOOb8YSrQcYQGp6gydzuywiED0p20Tn81uVvEx0rbwBGaILEiTxkn6N109OuLN+f4Gf6tN2Cei3L5kfRsGUFhPcbHwTzPDiLbVf255sHv+WrZoClZgzEWEfaHp7HkEPghp8rN9wLZaMCZCuAoaVy2LgUBvnEpJhiMvktw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hI5tNXA513NBCy0gNIQ8HQ+bb2KKxu3o9tRZc/rsdM=;
 b=Luv78FCaS+egMoAukbly36YVwo/XaWIxnV9zYmPO8AFtjay+KxVeu5bipV23iVX9NdcRZatVElqGTjVycQoDwOcBbwVtnnMpkFU6gvUdGWwLJTMXfIriEaofx1LNuIUoAWh80MadmgC192wbftEWHamoww2ZXXCEycjz1rKNd1GMge82tGr1PM/fRf5Z/Z6cNAndNLK4l4coC/iSEf8Oe6OLokIQpQS3Mfr3pa3Wlii5C4ceTi3ukin24HlJIQNSSDsfiE1d21gMt4wNH6gHpTSaEir1yGaFVls0mgDzB4Re2HRvcce6Rrr+4QXTonoCmTv6uxOKK7UcW0DBnJMlbA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQ1PR01MB735820.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:d7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 16:14:13 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 16:14:13 +0000
Message-ID: <3b2419e4-3874-4ccd-8af1-3ca76df20717@efficios.com>
Date: Fri, 13 Nov 2026 11:14:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/29] cgroup/cpuset: Give back the bandwidth an attach
 did not move
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
 <20261108185406.1549770-21-mathieu.desnoyers@efficios.com>
 <avWEta7b9X4K6hF7@jlelli-thinkpadt14gen4.remote.csb>
 <e21aaf40-b929-444c-b707-3200e21d7301@efficios.com>
 <avczaaXEh_xUhxpa@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avczaaXEh_xUhxpa@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0332.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::6) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQ1PR01MB735820:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a8aa315-1b77-4e28-b696-08df41a12877
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|10067099003|56012099006|4143699003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	D0mv3kPpB8KoRON7LzxKgvY5YQSmYwksbqKPBynUJOVSsMdEMUPqpNxBbbtDsawJdMQFlyW0JjW5hklJhNtQjeRQafXSSK2UUJZDw9wp9zcQ79smJBcAxqB7KFEkX6tcb1mUqSjVqvZoJq5JMQYRO3V8aZ+G9rq2D37haLSImZ99vR7HfF7hml2YqXCs519wkmCA6JgOlWnTBQKrzEZeJ6EXo9tmumXY4myyBCutYdq89UydrR5o+07RPIaut11te5f1Pb6HsfJ5msbLsfP3NoDKiv9W2DbjegYhxS85TNRAjjVBqrMWF2mEkmASJhq5P649TNpyEDnXLX8EkQgyLfcKhgEIjkF8FuIHQZkaBfUmGG0UuQZGCOIEDaJtq1AFhp8Cb6iDvUxdoV5wN8L/3B/aPuafOylDuf11Lipc2KYzLnQoWaCKHp30a/UcrzYL0xAtbVvor4Evt8Oqb1Ar5EVoxsaA7wrnmQMPQDsf/DT5qQ0PbwlA9ILJ1YlZ1DEtHJokpdX5pColNKZvWs/2y1sFVYXxhusrHeFJuNIjTkzL1YWhwlgpNHHywNRxtt28A123I52JNVstrK1DdUtQprOuhF3ik/Y5zKMeWlA/1Hw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(4143699003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWJkbFZDZnVQaytIY016aGIxUk9JQktXbWJRSVdNcjRHTlV2dzFFS1d2Qnc3?=
 =?utf-8?B?ZEtPR3lQb1lSamZJdTZFMFFONHhWK2JNcFBwWlFQYW9PcjcySStENmJmSzha?=
 =?utf-8?B?K2RJa1BQZEdVY1ozOVM5MG81bGlnZlJNUlNtU3VUaTMzNzF4VFhPbFl4WFNO?=
 =?utf-8?B?UW51WkxjeGFqOEk5YnRGa2JFZFFsUS91R0twZXlhM0Z2eS9nSG9nSk5BVVFP?=
 =?utf-8?B?VTJlY2VnQmhOdmw2Z3p2QUE3a2tQMTFyV1RyYnpHYTMyNXI1ejVMRzBLTzZM?=
 =?utf-8?B?Q0Ftcm8vT0Y3ckdCdHBzYzUxL3Q0Q1ZsL3lNYWFwblpJUFArekJHZmVFb0tU?=
 =?utf-8?B?V0lWbmpFc3Nxd3M3MU9tdVRFWGhtQURTRitweXJZV3oxZkxmY0kwY1VCVEhx?=
 =?utf-8?B?YnpuY0lqNFVSa1UvNjN6dlM3UFFVQW1EV0trQWkvYUIwNGVHeUxkUjlzOUF2?=
 =?utf-8?B?aStBdUhSVTRDVHZxSmN0Tmd6VC9FSkxzcE9rUFYyZFpJRWxHVGdwSllrcnRT?=
 =?utf-8?B?dmhqMU9HcnYvRjlYNHBsOXlrN1k0dXhBTmxHSUN4clh0elJ6SGtiTW1kQm1t?=
 =?utf-8?B?R3ZmMGtZYUxpVlBoajByTkpkbUM3a0ZCQnZaK3NMWVYrZXJ0MkhiaFZpaWZt?=
 =?utf-8?B?SjB1bnZadENYekhmcGFCNXIvRk85OER1akR2cm5YOThtRnRKaHhDZFc4enl5?=
 =?utf-8?B?RXV3R3hSczRkZVUxZ1lyUUpUYkYxSXpCb1dsU0lFSFZhY2ZqMGFqeG1rSStv?=
 =?utf-8?B?UUY1aWxlWXpjTTllMFoxRk1RSlEzNld1T2FXbkJhUmlqVkpIUDNKdEljSFZj?=
 =?utf-8?B?N0M2ai9BQ3lZeitnaWozaGhqYjV3YmQ3c1pjKzdwdk9rY05GNW5YTEZUSXpu?=
 =?utf-8?B?Y2h3WnFzQzdsaitxVWMyUGJabHhNQkY1amtENlFnSG0zTnZCbnQ4U1hNYmNV?=
 =?utf-8?B?Z08zRjVpenhlNzlsdUdPMlczYW5Fem5FL3JyV1FJU2RoMFAxSnZRbE1CR0Fu?=
 =?utf-8?B?NzhoVlcvUktDQlNzcm5YVHA5U1lyUU1NWkFIUzZGK2Yzb1dIWVQrbGhVbG5O?=
 =?utf-8?B?Yi92aEZGTGhjQTRQYVIwc3VBdGpESW8yaTR1b3BNTy9UOS9UWXdBT3FoSkRZ?=
 =?utf-8?B?ejhWM2Fkc3NlaTh1MU9jRTVZTjUwY3VHUVd3SmJlSmNxbERKOTl4bUg2Q3V4?=
 =?utf-8?B?bHRHTFhOSUxpNGp3S1pXRUc4Unp6dGs2cFYwRFhBaVUxMnpvY0RjS3B0b3k2?=
 =?utf-8?B?U0syQzdkeWFTdjlZMXRwdS9MVGpkNWJuV0tyam1qcFZRaU8vZ2c5eVpXeDJz?=
 =?utf-8?B?RXZiaDNzeGdjTDI5M2FXTnZCaWlGQjFLd0JBMFV2dE9sSGVVMWZ3VXFWRm1u?=
 =?utf-8?B?SkRoUnBxZXJzUDhwanRyWWxpNmRxZWhIMlh2eDhuNnNBbzdhS2p5OVNvYkJF?=
 =?utf-8?B?S0JiMUFwb3RrUlR6eWpYUXBpYzZXK3lRWkdrQmxGT3dHcnJMdmVyWTliN2Ft?=
 =?utf-8?B?VHZKWDRJTHdEWmtKUXQ1SWh1K1ZYVW9uWWNxT2REVVJHaGxKUWlTbTlYVStn?=
 =?utf-8?B?MFJUVGNNVjR1OGdJYXBUSFM5Yy9mSEgvNUQyZ3JiM3dHSW56czd0MXRhYUhs?=
 =?utf-8?B?enhoMCtFaVNjcEZqZFBqQ0tROEFJcWV4RmFKbUtzZU5qTnpvM2t6NzlWZTdI?=
 =?utf-8?B?ZW1xdS9GcHhFenkvWm5RQXBuRWd4UGRTNDg3RFRIUnNDb0JTeTY0NzZ1bFlD?=
 =?utf-8?B?bnFWOGRKUHBIamppeTZhVzFEbit3N2dzclczMkc2azMyR3Q5alU2R1FRYk5n?=
 =?utf-8?B?OEVMVmtGeGpZYlJlMy9SWVRxb1N3eDMvUmdnK1BzeXNxTzdYdE5ZdnAvYVJX?=
 =?utf-8?B?VXFsUm1YaWw3ZDE3ZmgrdEprR2RGa3g3MXo1SDE2SXZHYVVmU0pUam83N0kv?=
 =?utf-8?B?aXJ4OFkwWUN5YzNWSFFOZGtKRFJYQnhBa3hNMmdkb0daWjlWd2d6cHNKLzgy?=
 =?utf-8?B?L0JlczJaK00wV1JjYnpCa3ZyekxodGR0WmRPbytrQjlNeHNZTmtyQlNjZWQ1?=
 =?utf-8?B?R3l6OERIby9nVDRiNGtUTmRoaTA4SWh5Y3BVMmZKUWxlcEt2K0hpd2wzTFlQ?=
 =?utf-8?B?U0hndzVJRVVYNUJkTW1lckd3UnozdDg5cmtDSW1JVXhWOHdPTnNIMGx0d2x4?=
 =?utf-8?B?Nm9wK21MQ0RlWDZEQVUrZ1c4RFRhU21kWkR0aEcwQ0xvdEtoSDR4dEtQeW1V?=
 =?utf-8?B?Q29qS05jNXBFdTVXZHBMMTB1NTBNN1VSRnJCcCt2dkFlcDc1eHFzcnp4VjBT?=
 =?utf-8?B?NXdMUXQ3Mk5tY1hEYWdxVDArUkRqN1FUeGlBQStQcDhiUUo5SVdBKzFHcmpW?=
 =?utf-8?Q?zkBgYBqvITOIFP4D6Vw12Yx66C5fipZumXxbP?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8aa315-1b77-4e28-b696-08df41a12877
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 16:14:13.5339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGA0gknYGUXgrM6XY8hhzvvBdZOC3+eb7vHD046bWHVk2F1ds4GK9WUFBP8jS0Tl3jvU+Pt6wcG2VRp+gZ5Teak4Kal5pLrbLNhJhW7WmEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQ1PR01MB735820

Hi Juri,

> I believe we already have (maybe broken in-kernel) EBUSY on trying to
> hotplug last cpu with bw standing?

Yes, in dl_bw_manage(), for dl_bw_req_deactivate. It refuses a CPU
offline in two cases:
- the CPU is the last one of its root domain, and that root domain
   counts deadline bandwidth;
- the CPUs that remain lack the capacity for that bandwidth.

Both look at the root domain as a whole. The planned next version
leaves that check as it is.

The new refusal looks at each task. The root domain keeps other CPUs,
but none that the task is allowed on.

The case hotplug_last_refused of deadline_bw_test shows it, in a guest
booted with isolcpus="domain". I1 and I2 are isolated CPUs, in the
default root domain. H and K are housekeeping CPUs, in another root
domain. B is a cpuset of I1, I2 and H, and is not a partition root. T
is a deadline task, counted in the root domain of H and K. Without the
new check:

   root domain of H and K                 root domain of I1 and I2

   T sleeps on H
   echo T > B/cgroup.procs
     T is allowed on I1, I2 and H
     total_bw still counts T
   echo 0 > cpuH/online
     dl_bw_manage(): K remains, with
     enough capacity. Accepted.
                                          T wakes up on I1 or I2
                                            T was not admitted here

The new check refuses the offline of H with EBUSY. H is the last CPU
that T is allowed on in the root domain that counts it.

With admission control off, the new check is skipped. The existing one
is not.

> About a potential dedicate knob, Sebastian is proposing it as well [1],
> so maybe it's time we move to that. Need to sync with him I guess. :)

Agreed. The two refusals test dl_bandwidth_enabled(), not the sysctl.
So they follow whichever file turns admission control off. With
Sebastian's patch 5, that is /sys/kernel/sched/dl_runtime_us.

What depends on the file is text and tests on my side:
- two changelogs name sched_rt_runtime_us as the way past a refusal;
- deadline_bw_test writes it for its cases without admission control.

Sebastian, the planned next version is based on tip sched/urgent, so
it names sched_rt_runtime_us. If your series goes in first, I rebase
on it and switch both. If mine goes in first, the selftest needs the
new path in your patch 5. Tell me which you prefer.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
