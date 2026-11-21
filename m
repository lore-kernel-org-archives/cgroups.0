Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.100.97
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795290430;
	b=V6BQk0rOnjx4TzDIx56qBV6m9oo+9Et6ToXzRg2RAwDHWzL+u+Dw6J/3WCcoztzqonSU
	 mBDCt1kP3r8he7HGIperlm+UrQ8gDkGm9zaYMELwe6Y/Rh8QEICDGE7vKTiU7I3yUf9VY
	 wLZn/J3uJuu4e534Jp+fN7HXLsuKGJVQRSuJCv8yvXDGcplu5D426dKsOZczNsRVpY0/U
	 oVqahNMSxHQV5wualiI+srdqB2fg1/hLDb0+gy8Ff5saTEW9eNub28bxC+R8V/QQc2J9z
	 GKDxncGD1UeClXeIyCNr0k25oL3MsyOVp0UU7H2uiOIqSv8YMZvEjA6NSHsvzMBdj0g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795290430;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=lQ2kfgj2cqEW41SjRFJ8z3F2mWTze5/8rB7va5fc+to=;
	b=sXKt01JLruVDqVp5bFLgqrFcftoJuIkAt4x4N57Cua7fwL4oEnUFuINyEHnqsVLdQZuK
	 l2qIOoTag4T2l0JQ0X0Qy/DRhzxTohmjF9vcAzZg8v/Ng5Bqme7PoWyarfuLkfRTybSjD
	 XEBufls8USLxts9NoCUGnTIXau5W3pPIZKPElWkPZuyWqs89Dy6D1itlrjtK3a2GCCbIH
	 GawSUeKhYfPlq150QLpSmyQ5PNGfZTiaKHPpA2rpVMqhg6cVsVH1ZUwcuOJ2sM0fHoCIQ
	 PqCdK1Ygo1Erbc5K5xweBTeThas8XBbxsLi4b/FWHRiMvH4JAVc3nuyhl39/1inZhvw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=atomlin.com;
	spf=pass smtp.mailfrom=atomlin.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.100.97
Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021097.outbound.protection.outlook.com [52.101.100.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28083606A320;
	Sat, 21 Nov 2026 19:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28083606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CUR82kiE51EzdwzXV1viFNrcmpuaoIxtRhRBGE9F+aAcciiLgIVCw+RWDUrq4jFI6YzqA//pfUdmUXLUyXK58EzH0rtKxS+v61beZlUA4/VSItsWmV3DoBei/60+oLRPniV0Dgbc6gjfIoz+aGrRFl/wmHTmzN+jrUwxCrALbSjGDOlPdUaJqh7CD/hwP3BFUrkQbn0xgZyMIQrzNKYlQxXIcrdwUtL+LzQwMJoHGV3QPTKhuTN2VxztSE+5/dy/bZaMPmUsvSEFNoTohDuPaq1ShMGVVvXDWeXlm1WaxixgCtE29V8odJ7V+t/5400z2M7KTR0SrUr4BfGrQMEc3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=lQ2kfgj2cqEW41SjRFJ8z3F2mWTze5/8rB7va5fc+to=;
 b=qP83j0FyqOfR4gMnZZcPrieItft9zGZZ1QH7vp5cglETqbiRmfrs8d0uwyeHXUppB8aSk0aeYqlEKwfk44j+zqD9fIn3nmYOBHuO5ZWpRMGpz/Kbnfj8jpu1fx1OdMKEm9r2Xo1iBCn2SUVkitjpvs7cPttgWFkmuXylzmKTU771bab9Gpkb50I+bIiplNA5FAci7kj9GbdTr2QM+Wr3DHaejEDogxQWr1IjKjkynVoXSZQtTEgiuF2C+jGZi+PTyTxg/tKeHSmUg5g7OdSVlGU03zplf4Bqo4b7aOytXFnaU/GAPt6v8p2ZMO+V8dx/JP7z9sWDF9+G9GhiV3hxCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:163::8)
 by LO6P123MB6456.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:2a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 19:47:05 +0000
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a]) by LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a%5]) with mapi id 15.21.0639.012; Sat, 21 Nov 2026
 19:47:05 +0000
Date: Sat, 21 Nov 2026 14:47:01 -0500
From: Aaron Tomlin <atomlin@atomlin.com>
To: tsbogend@alpha.franken.de, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, stephen.smalley.work@gmail.com, 
	casey@schaufler-ca.com, longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com
Cc: ihor.solodrai@linux.dev, martin.lau@linux.dev, song@kernel.org, 
	yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com, 
	chenridong@huaweicloud.com, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	omosnace@redhat.com, kees@kernel.org, kpsingh@kernel.org, matt@bobrowski.net, 
	chris@chrisdown.name, neelx@suse.com, sean@ashe.io, chjohnst@gmail.com, steve@abita.co, 
	mproche@gmail.com, nick.lange@gmail.com, cgroups@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, bpf@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] security: Expand task_setscheduler LSM hook
Message-ID: <oa7e3wzdkq6vvdgast5eohbrvtcvfz4mhqexisdxztq3g3l2ys@pxii4gqdgozp>
References: <20261119040705.684987-1-atomlin@atomlin.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261119040705.684987-1-atomlin@atomlin.com>
X-ClientProxiedBy: BN9P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::23) To LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:163::8)
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
X-MS-TrafficTypeDiagnostic: LO2P123MB4190:EE_|LO6P123MB6456:EE_
X-MS-Office365-Filtering-Correlation-Id: 78d79859-b496-449d-09f8-08df48083864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|6133799003|18002099003|22082099003|261009223027099003|261021121427099003|261022105027099003|261022075727099003|921020|261028144727099003|261022113327099003|261026140227099003|261026121527099003|56012099006|10067099003|261102125427099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	McI+X4GoyEQib46nSsEWZ4HrRHq7BVf1imMA20bfdtFZt3rQybjXqTDZ5ubjNnmDvujrJBDs0L1tEUcRca1JuGHldPIQZ0u19tbyCd24rs4aAEs77Jj2MzgCTCOG3w41bBCJs79DhNnj3C+YZJ8o4/8tQrqDwsr4MiFymo98GytVDL7MbysweXdwSXJq1/U/DtPya+SN5gfk3NJut08pm4XKSNQiwtYcEqjgg17fe4jixmyOmpfNqpwH7Bbzkt9Z0wpqGO9f6WJYw3S+/8MruK/PJlUmLGjlJdWfcw+LySHXZaCvQ1jogoa2YTQOX7kZayiwlnGkEifwnSYAcvT3DU0bd79N2kIrS9M5j24wpBah3PKzIRpDICzt0QvQbYiqoFAZhYmIhW2n0+/xe3h6fH8qYqLqB7nquXVY6/BF3+Jif6JX9koNFC8Yi3zW1y+DfqyU8rO/dm3GGW7Cahl8nuJ4GovYgFaXyhUub3Ia9ELTWDf4OMspLOKXn3iscn38r/9ENULnmNKVB6flgGr+ihyGLPJfzXoTbZtXPaoZR2Xy4TPOp8eTr1XMHQEGSXBr5vHG4ZvFaPGR094XkZeZ0SyZVUHMXmLV+heYJa4R5McXXYQw23sOhDikh2/LA1gEHrdQpexP7jnaVcL7Jwkwd52fGUpMYvei+TRMGE/EuhWfptc668ATSOqGS3ClcTNXVhSlygOHQF7QrbDi4iHgZg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(6133799003)(18002099003)(22082099003)(261009223027099003)(261021121427099003)(261022105027099003)(261022075727099003)(921020)(261028144727099003)(261022113327099003)(261026140227099003)(261026121527099003)(56012099006)(10067099003)(261102125427099003)(261102123227099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDU5aHptNjcyTi9TMGZabVdNL0l1VGNkeVBvWmI0MDFyN0MvNXdWdEx5NFpm?=
 =?utf-8?B?NkVRdk1pMjUxQW9oQkxOMFpTTllGVTRjRUpvUmQzbTZzQnJQbVU3MWtmYS8x?=
 =?utf-8?B?aXVvMnd6ekxaMlIwNkNJWDIzOXROS2tJQVlHRGlKYTFkNDJ4ZzVNVytPcDcz?=
 =?utf-8?B?RUpHaUxnSlFpZ3BjQWxuaGg5d1U1SFlIUW1jZk5rUFRaTzEzODhPa0hYb0Nt?=
 =?utf-8?B?eXZHODlVWUtXNzI5WTU3Yk9zamN0RndFclhxcEJtejFyZHJyYWJlYjh4RWVG?=
 =?utf-8?B?TzE2cklJbXhCR2x1UksvSFNYazh1M0RONHpXY0QwWkk0NEtDcU1GMVpOaktQ?=
 =?utf-8?B?SDRoenZ1enNWczhIN0FjMGZXWWFQazMxcll3U1o1TzZHM2x4d2R0Q2ZVNzF0?=
 =?utf-8?B?MzF1VzRBUnhQNk9lZUVUYWMzQndKd2xrcmxkSnBkSXczUVYzaUtiVVNVMk8x?=
 =?utf-8?B?b2poa24xRkNUa3l3RmZnZ0FGVTFZWktkNWxTcmdPTVNIQkU0b1dOZTFXMEVH?=
 =?utf-8?B?aVBqUTU3dFhLQWE0enNnY3U4OFZmZ0dJTWNiNndtcEltZWlhSldIQ3JkZVRM?=
 =?utf-8?B?ajZPa0NScTNXM3U3dExLTGJQQXh0eTY4QkZESWlSdndtQkRkeEtZbmhGcGlJ?=
 =?utf-8?B?TFl4TGdHVU9HVVV1KzdCMEl1Um1sTkZEUjBWNmt5SE1jajN1N2lkMDBCeisv?=
 =?utf-8?B?VzhJSzl4ZC92YmJXdE54dDQrendpS2dqRHRVY3lEa3dOcEJMMFFpazkvSjVF?=
 =?utf-8?B?Y0wzWmpLSjZiRVVBalZvWXpGTnJncVMvUDBWcGs5eEoxazhaUndmak9GZjh3?=
 =?utf-8?B?b2R6YnhGdnpybGpaUjBYdG5NT0I2TWlRSlQrcHVyVStGTXhvbVpvbEg0b21M?=
 =?utf-8?B?cktiUU1wYTNRVHlpSWRCMFk5Z2trRFVlVnhGeXlpZktBODVmYktTcE1sOXhz?=
 =?utf-8?B?YkRxUDd2OWd2cSszeG1uSmtrOU13cHMwRmZKMjBkdkp0emF2TWIybU5OU2ZU?=
 =?utf-8?B?ek45cmVPVkdSZGlwdjBZTjRyRWF5eXhkRDVKTnZScWl0MEZuY3pmdklPakpJ?=
 =?utf-8?B?MDJhUlIyT2RLYnlWTFNRUENVWDA2Sk5qOHlUSE4vZ3NLN3Z2SkRsSTJTcW9S?=
 =?utf-8?B?eGlRcldSRXRmTTVwcFJCSDlRcnlWN0pFazY2QjRFVitoaVp5andXcmh2SzQz?=
 =?utf-8?B?M2xUQWRvUkhpSGEzMkNjODlZVTRjQU9VTzlWcXlPWmQ0NzR2R3JRaklhSW5S?=
 =?utf-8?B?WW8vMUc0eHZneC8rWjUraWRlY1Z0ZFNTaXZtUEFlVHNLL3ZCMUl4Wm53dVdi?=
 =?utf-8?B?QWpVZllYaWx3T0xXVDd4Z0hIQnpDU3hBYjMwRjBxVWxOdllyM3dTeHl2MkRN?=
 =?utf-8?B?Qjk3NWVmd1plaCtMM0RuRFYwUU9kM051eDNsNmpaMVl3Z05zaU83ZXQ4WUFm?=
 =?utf-8?B?Z0h6NUlBdTVOYlJ2bUdEdkFkZUZyR3I1NXdSa1lEZ2E1LzhFM2RGcThSWUYz?=
 =?utf-8?B?R1VZZDBhTDIxd24yUS9ic25XOVlnWnUzL0N5NkdCSmVxS2wvRDJKZWpMWXJ5?=
 =?utf-8?B?RmtmSHBWZmdPZzh1YTZ3L0FpK0lqVHo0SHFIcllCT0lGdWRlMXdpWXRpOFh1?=
 =?utf-8?B?OVc4VkNWQkR2UmpDem9ZYWFqMFM0U1B2UWZ2c0Fmc2dyT3p5UUdqanRkZktU?=
 =?utf-8?B?cU9yUFBpWGwwWjZKbkE2UW13SDNiK0UzdGpUZjZueUt5ZjBwamJzbk1FYWh5?=
 =?utf-8?B?M0dnNVE5ZUtMUmtFbmd5YU56WHl4b09ESHF6V2d3WURad3hmV3VrZmVBRHNZ?=
 =?utf-8?B?T1hZRjVDWkNaTHNkL2RLRTRGZVk0VnN0TStKd1kzT2VZb3FpRU9kb09CUlh3?=
 =?utf-8?B?bk5lbWpKMW5XTVNkd0JvUEo0cmhpUlpyTUhSRlhWZC9GdDVpQ01xNXNJeGhI?=
 =?utf-8?B?ME55ekpjelhocGhjVWo5R1BWRVBBazErNTY1ZTFBQWw5UGJjRXpUQWwxVHR0?=
 =?utf-8?B?bFBiZGU5WExhdU43VWMxWHBqUS9OS1lHRmE4OFREcGtad2s5QjBvclFUa2tK?=
 =?utf-8?B?TTNOL28rMUxJaThzUHRraWdUNlRHZzdtU2dxZnIwZC9hRFFyODNuTFBna1VI?=
 =?utf-8?B?ZkdsMURHNnZuRHFzWlJqLytyRjYzem5RaHVBNjJiYXM0S0oyM1JyM3psYnpS?=
 =?utf-8?B?ZVZzeTg5alo4TDNJUkl6eFdROWZLU1ZLdVJxWmsxZTFBTTNTZ1daRTRCSlFi?=
 =?utf-8?B?aUhGNE9Dd3kxK0xyOXBCbDIyWUxiSGwxaTBuS0FPcU1pZVV5bm42eU83WnFI?=
 =?utf-8?B?MHl1Szl4WXpwbk4yTFczNjR5S3FlRFhOcXl5cjZrUUFINUtPQkY2UT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d79859-b496-449d-09f8-08df48083864
X-MS-Exchange-CrossTenant-AuthSource: LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 19:47:05.4456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zYUVIqSSNZdp/htLIxtgBS9nfKMuWt1KybSl5WnjQzZphWOa7SVDEtixf0Zpt0buzu7C1YlnjlpKKj5Nd8ElA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO6P123MB6456

On Wed, Nov 18, 2026 at 11:07:03PM -0500, Aaron Tomlin wrote:
> This series expands the task_setscheduler LSM hook to accept nullable
> pointers to the requested sched_attr and cpumask alongside the target
> task_struct. For sched_setaffinity(), passing the raw user-supplied
> affinity mask allows LSMs such as the BPF LSM to audit or filter the
> mask as requested by userspace before __sched_setaffinity() intersects
> it with the task's allowed cpuset CPUs, which seccomp filters cannot
> inspect behind user pointers and scheduler tracepoints only observe
> post-intersection. Similarly, __sched_setscheduler() passes a local
> sched_attr populated with the resolved scheduling policy and effective
> SCHED_FLAG_RESET_ON_FORK state so parameter-only updates expose the
> effective values rather than internal sentinels or caller defaults, and
> cpuset task migrations and CLONE_INTO_CGROUP pass the destination
> cpuset's effective_cpus mask (note that direct writes to cpuset.cpus
> update task affinity via cpuset_update_tasks_cpumask() without invoking
> this hook).

Adding KP Singh, Matt Bobrowski, and Chris Down to Cc.

KP, Matt: I would particularly appreciate your thoughts from the BPF LSM
side on expanding task_setscheduler (which shifts the trailing ret context
slot from slot 1 to slot 3 for existing two-argument lsm/task_setscheduler
programs).

Kind regards,
-- 
Aaron Tomlin
