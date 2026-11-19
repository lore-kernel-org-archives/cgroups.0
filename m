Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.95.101
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795056244;
	b=pViDoDbVlh7OrNph9sgMd2RuCEXg9jttlWM4CktsGvY/AEaT1v0PxlKqKQvctsNgc2dm
	 FXxNm7KaF2gfvv5sRpIzRjKuQrHeVbs/r1bTwEKyIBu8PwlJhex3GvJKKzHSNCB+f7RLj
	 hlB7yU5R55RxrH5Z9JEma0sY6JDmm+b/yY3EbOhUu6nOSIiycLSM0wVp8izShedF6eYUX
	 RaNsIbi19jIY0nly2Z9zjMI8mU61cK65BK1R7hiaZg2fmEQSpweR5bk368Ryl0PoFrwW4
	 Xc9EO1Fuw7p+h4T47Nhhj2UUgAHNEW5XG+amgPL/Sa58VAE1CcOOc/UHjtQIs3GDvIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056244;
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
	bh=IJWhb68m27RcCXvCQAeK2pXdTQjOGz6GdP/uTLcyOMc=;
	b=uuVWJxUpHOvLNy+EmX0sTJjsHczQ4al1EMMWVmG3fiJ6sW5o/UuGVXozOc0vP68uZZj3
	 JhuSpPFJ8Lgy2VXmsvHq+MTHVmVZvLDuqLdB1CjPTiMP8AvtpkHriWCVrGMtqF+i6BXKO
	 dBqOVs/dvD1TQG9ACu5vSFJs3iB9GWVDU5qIsqXb09WLJBJ0EMwhZZoPOG4ZCe/VpJGaF
	 CXXWU1KsY/TGPKE8RCwdFcDH3XNvz8ff8T9+aO7EXpywHbZ6mr5x95tp86mT1z9uejQ57
	 wycFu4K6k4PeskNnIOMyjXq1w/0xENyoIR2CGJvWjhM5YTCuGB/3il9rlJOOhWM4gwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=atomlin.com;
	spf=pass smtp.mailfrom=atomlin.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.95.101
Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021101.outbound.protection.outlook.com [52.101.95.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2A3606A320;
	Thu, 19 Nov 2026 02:44:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD2A3606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D+GeqNtgJCTX/D8znkF3N6UN4CopSL+6PWeTiuVnrsuAzXvFn/xJoIClgSgXSVyQwG0Ahs8TY8UixlcTWFBfQ9FDMkgaugpfvDHbPGoPeRwcoYZ4tN1JOljrxDNLwaotjNAFcf5IsXDgiuJu4uMS3i3kuujJK6fOBuAqlrh0EjYOQ0dB6Sfc8euoV8dQhWHKnDQakUn6Nhxc3hY6VGnnQOXGsDLaBYHFMK+Ojyg6lITPJeERrh/2MyCn9wJ0cvo01erMaRkjPGOUUf32A29PrSsek0O9FEd+Y2QieFp3tt9Bcb2sxDlb+xbxT7U705f9fdUhDauaN1yVdpFTs6es6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=IJWhb68m27RcCXvCQAeK2pXdTQjOGz6GdP/uTLcyOMc=;
 b=qqzWLd3YkahO/i6zjJ/4FT7+djXNeXIgxBYgefpY6d7D6xCQpmbt0b7Jd4sJoK4s8haFdfofxA/vmMNt3QJeKoUd/RcFkj6qkBgNyhcMNdxymhe5hxcxcY1ZoQ9sUU1RwQEabxd08oBmOEbUm4Av3q1RAJMA7hWI+o++59E/bHmJAyfjMtTTled0ID98ijVyI1jAq/OBgKZR1bH+JPsKPvcFAeS07tctcSCQ690pXEtwqrIiEOfPgneO0/L4+hNia/QwqFD9vaOZq6zJS7Vgcb0JHDnH5yixTT4Ofs/mn0WyDz7uzXA1AgpaZfs0pTidxGbg7xt88X9S8MeGbXNoqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:163::8)
 by CWXP123MB2919.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:37::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 02:43:59 +0000
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a]) by LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a%5]) with mapi id 15.21.0615.017; Thu, 19 Nov 2026
 02:43:58 +0000
Date: Wed, 18 Nov 2026 21:43:52 -0500
From: Aaron Tomlin <atomlin@atomlin.com>
To: Chris Down <chris@chrisdown.name>
Cc: tsbogend@alpha.franken.de, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, 
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	chenridong@huaweicloud.com, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	omosnace@redhat.com, kees@kernel.org, neelx@suse.com, sean@ashe.io, 
	chjohnst@gmail.com, steve@abita.co, mproche@gmail.com, nick.lange@gmail.com, 
	cgroups@vger.kernel.org, linux-mips@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] security: Expand task_setscheduler LSM hook
Message-ID: <nvs2442ks3blgphnzy242wro6d3fxmfya2wnfbb7jxiu3m7gpy@7cz34im5yvuk>
References: <20261105172210.76706-1-atomlin@atomlin.com>
 <20261112144615.df72a3bef0a52f3c@chrisdown.name>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261112144615.df72a3bef0a52f3c@chrisdown.name>
X-ClientProxiedBy: CY8PR11CA0008.namprd11.prod.outlook.com
 (2603:10b6:930:48::20) To LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: LO2P123MB4190:EE_|CWXP123MB2919:EE_
X-MS-Office365-Filtering-Correlation-Id: d14e16b2-d53c-4094-c99c-08df45e6f605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|18002099003|22082099003|6133799003|3023799007|56012099006|4143699003|261028144727099003|261102125427099003|261102123227099003|261026140227099003|261026121527099003|261022113327099003|261022105027099003|261022075727099003|261021121427099003|261021123027099003|261021135927099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	MLrcSdf7VnLZI0ydKOSSfTpe5jae2lnxbqHNMpV87vUvBphEMFNjiPRyOexe4uiBTDKcSQMe4cyrdUxa+QbC8AYoibsIojiSKCw7JV3C2nUIwEdnuWotDrx5QASeRsWJVCKYZ1OHvZl72Zes9SVIQ3yvUEd/HxFZOALepLforDiKsRwFQat6My5ayPzXGYyycoSheXFlIbCMdVhQPSiR2yzTfqR8QbFBqggZeG4jCKyiIIQ/zDvGFuLceRg/SRsUxPedryLL0Qm9PQSUX372Y0hLYD2uupn4AxhrfvOPkNKPRxRkTsILX930njl9PAY7c0oc+fXAJe/O03iKMEWHF34MwxOd6p6tpkH7GG6lfDysxmh69QxmixUNCDThpv4qYjbVmn5i6sb4nJGL/UEwq3tOcakcduUmZBf/JzlJp2VWOOnq339LG3/3CHjW0+eSKgblnCP21EkDdc+rOWVyu+gDnI5CniTwSKACTgQfOtnk39hcWCDRhDp963Bd0/cdJCIoEqJv7AZRBb3bbf19hFGdrzqq8lMuYQuJXO0NhnUV9JXmTdhiDhvgi8fL0yQKluyOXym7etGF51zZVA5dShsuewl+yr0LF5csIiPxYOhnyfNTVeNZ3bar5rl8bWaNVoEZZlI0mVED8lFFdrdvmZJn6T4vIXIYaCeBt9Tzfw8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(6133799003)(3023799007)(56012099006)(4143699003)(261028144727099003)(261102125427099003)(261102123227099003)(261026140227099003)(261026121527099003)(261022113327099003)(261022105027099003)(261022075727099003)(261021121427099003)(261021123027099003)(261021135927099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0FFWlpmTVhqSWEvRFdqbE5zRHJFWWljb0VMdVhMemIwRXh6cGFPUlhlejVX?=
 =?utf-8?B?dzBBSlZRWjRITjRwL3BoTExzak0yTzNTQ1c4VXBrYnVydmViL2NQMmlKemcr?=
 =?utf-8?B?bVlNdUR6dHFrbFA4cTQxemtQL3RHQndYVEs0dXJVTVRNaXVROXh1NlpWUlpw?=
 =?utf-8?B?ZzN1aGljcUlFVUthWkhndUxwWUZ3QVJlbzM2QWVqVEZrWnB4MFM1dFVFa3Ni?=
 =?utf-8?B?RnVISzd4SEtrb0JNcDNwUks5OVk4dVVWeGtsRVVveEdDZ1NvdEtYL2p3NmZV?=
 =?utf-8?B?UklmdHJTN2RiSWpwenoyNy9YdUlPMVhzR0NnSmdETWdRWDFSOGdQN0IvY2d1?=
 =?utf-8?B?cUk1Nnh3T1pYZ0tRUDh0WDlVTllEOEJMd3FkUzV0WWVWTVUxL2JDK3E5Q2Q3?=
 =?utf-8?B?bmNUQlV1T0xReGVwMnN3L2Nya05MZXpheTNiM0R5TUcwUzJqMzBxWlY1WVpB?=
 =?utf-8?B?V0dwcnlabGNkVXB0ajNyeWVld3VRQ3lKdTcrNnFrVXJRUUZsZjdHSU0wZW80?=
 =?utf-8?B?dGtMNEtoQlV5OWxVUDRkazZkeERXQUh1cFJNV0graDllMXoveE41Q3p5Z0FG?=
 =?utf-8?B?dVNLNy9EZDRlY0VlUVpsZHpRRnBSVnlscmUwMlcvaDk2dmR2RnpRUUI4VllG?=
 =?utf-8?B?cDFLc210UDhlaUgzUXBPb3ZTWWtFNE9va3QwaTgvRG1HVGViWFEwNnExSmFx?=
 =?utf-8?B?c0tYSVJOT1NtSDhzREZyMXNDbXRmYmFmWVRJQ2RtUlYzTlVGRTVQVlB2d3Vp?=
 =?utf-8?B?cVFCWFM4R2VhckhFWWhWOVd1em9LSTBJNGlrRmdjRnQ3MytHMGdOemVBNGpl?=
 =?utf-8?B?UmpYTTBhQm13Y1pYQ2N4T1ZQM055bmU5Sk55Y1BQS1RMWkVhWE9yQmdvRXFX?=
 =?utf-8?B?MzVNUzVqdXNTcEFHUUY5bDRaUDRYUkRzMlkzNDdSTGdJK1QxZS96VGplTUVs?=
 =?utf-8?B?TnhKVE8zM1RRMTVidkp5eGlsR0NFZG9RS0VrSTNVSW1uR1phc2N3Z0tPcWd4?=
 =?utf-8?B?M0NPVXNSVWtuTW1zRjFHL3VnTFBZd2xva0J0RXl1RkN4T3hyYnVDUm4zMVJ1?=
 =?utf-8?B?MUEzSnZyM0tCdjNwUForZ3d3TG43cys3d2s2OGM2NEdDM2FpTS9lU1ZIUExT?=
 =?utf-8?B?TDNIOXZJeU9xM1ZWZ2txc1gwY2ZtaGkxL0doOFVDWTBLV0Q3enpWYXlWZzAy?=
 =?utf-8?B?TnRlNnppRGNLMGNMcDRtWDJiMmdacnNYV3hJWUNXekU2aDNEcHc3cnRvUk5v?=
 =?utf-8?B?dHI3MVljMExubCtrOXNjaDk3OFd5RjFIOWROSkNNZ253Nlk5VDE2TXhRNlk1?=
 =?utf-8?B?Rk5MdVAzZEhaSzdPZWdhcUtYNmcrbmc1bmhQeHRMK0lRWEdadGxHVmgrWFlO?=
 =?utf-8?B?MU8vc2NwdTFlUDNkSzdqTmtmOXNESTJyVGl6bTJUZHF4dDVnOTVTaVZWK1pS?=
 =?utf-8?B?UE91cGIrcG5jd1dHYWJSNzMySDZlTHd3T2tvRUdWZTlGS3VaeDBKZElCN3R5?=
 =?utf-8?B?NmE3QkVzTE9Yd3gvYXRhSU1Nd2xkZjBTMngvNWFYYys4SjRyLzVBcUNqbldw?=
 =?utf-8?B?VUFBc2pCSWl2UHFoNFZqZnVrS084MzFRMWltajBUQ2V2MGRFcEhaSTloclVQ?=
 =?utf-8?B?TjAwbVFJT0QzOW02dG9nNmxWY1VBSFZCM2UxQ0hMdXV5OFNPUkhyaFFveVJE?=
 =?utf-8?B?MkR4ZUdpbzhTRzNtUHVibW13YjdjeW1QUEV1TGU3a0gwMStYOGtJSExkWS9C?=
 =?utf-8?B?UERGcitqRWZoc0dDS3cyV1BPc2FRT2xUa2tjRE5wb3pFRUdIU3hrbXFKeitS?=
 =?utf-8?B?dHMzR2dRekVnakx1R3VYNzVvVG91ZjVxVnM1Ym1iczM1SnZQdFQ1UlhNSHAz?=
 =?utf-8?B?U0xoNmd1dEg0UnhkK1MrUEo2VmQyeWtjSm1hQXFTL3pleU9IdVUvQWJPaGp2?=
 =?utf-8?B?Nmd4U2d1U2duYzJVWG1NRTkveDYyNm5UWkZIb282Q1JGSU9LRmFod0RRN1p2?=
 =?utf-8?B?QTI1N1loRVhzUHBoUkowdE5PSVM2SDFwV0ltM2pUR3FiV1ZXY0MxU1BaUldM?=
 =?utf-8?B?ZE5tNHNQNjUxbWtPZWpSSmxvb2xFQlNwY084dTNQa3A3ZUkxZVJsNS8zY0RV?=
 =?utf-8?B?K1dnZExNVm1FTUNicFV5WXA1SEtvNGJReXJZczU1UFIvOVd5UEV2M3NZN2Vk?=
 =?utf-8?B?QmtwSGthR0ZBOGFIN0crMUZpMk9WTklyMXRzcHBGNGZ1T0NHUTFmdlBIS3NB?=
 =?utf-8?B?Q1o5VVVSVm5BZkRHZzJydmlCUlJhdXlZQThQU0R1MUJKanEvK0paODE4VlpF?=
 =?utf-8?B?WUx3UTAyRklwTTJXZVRUOFB5b0w3TWRtczZNWW54YUxsWUtoSWlCQT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d14e16b2-d53c-4094-c99c-08df45e6f605
X-MS-Exchange-CrossTenant-AuthSource: LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 02:43:58.5336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGmMLVSQTOX3WHJkWDKwAyyxLqWtGDowGlJ2c+K++M3/ZMoHaxQeTJ3lEISHsZc4fkMEBWxvRn7XQz+OZs2t9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB2919

On Thu, Nov 12, 2026 at 02:46:15PM -0800, Chris Down wrote:
> Hi Aaron,

Hi Chris,

I appreciate your feedback.

> Aaron Tomlin writes:
> > In modern multi-tenant and real-time environments, CPU and scheduling
> > isolation are critical boundaries. The inability to audit or restrict
> > specific scheduling policy changes or CPU pinning requests limits the
> > effectiveness of security policies, particularly when attempting to
> > shield isolated or cryptographic cores from unprivileged or compromised
> > tasks.
> 
> Peter objected to this paragraph on v3, and you said there that you would
> drop it. What you told him the patch is really for was auditing the
> affinity mask as userspace asked for it, before cpuset intersects it with
> the allowed CPUs, which seccomp can't do because the mask is behind a user
> pointer. That should be in the changelog in place of this paragraph. (I
> object to it as well. Please avoid such LLM grandiosity.)

Apologies for the oversight in leaving that paragraph in after v3. I will
drop it in v6 and replace it with the concrete rationale: auditing and
filtering the raw user-supplied affinity mask and scheduling attributes
before __sched_setaffinity() intersects the mask with the task's allowed
cpuset CPUs, which seccomp cannot inspect because both are passed behind
user pointers.

> 
> > This change updates all in-tree security modules (capabilities, SELinux,
> > and Smack) to accommodate the new parameters mechanically, while
> > providing LSMs with the necessary context to enforce strict scheduling
> > and affinity policies.
> 
> An LSM can only enforce an affinity policy through this hook if all possible
> ways of changing a task's affinity go through it, but writes to cpuset.cpus
> don't. With a BPF LSM program on this hook that rejects any mask containing
> CPU 3, sched_setaffinity() to CPU 3 gets EPERM. An unprivileged user with a
> delegated cgroup v2 subtree can still write 3 to the task's cpuset.cpus,
> though, and the task ends up on CPU 3 without the hook being called.
> cpuset_update_tasks_cpumask() just calls set_cpus_allowed_ptr() on every
> task in the cpuset.
> 
> So what this gives an LSM is visibility into sched_setaffinity() requests
> and cpuset migrations, not control over where a task runs. That may be
> enough for auditing, but the changelog shouldn't promise enforcement. It
> also looks like the kind of gap Paul meant on v3 when he asked how this
> fits into a more comprehensive approach to resource control in the LSM.

I see, fair point. While all user-initiated scheduling policy and parameter
syscalls pass through __sched_setscheduler(), writes to cpuset.cpus update
task affinity directly via cpuset_update_tasks_cpumask() ->
set_cpus_allowed_ptr() without invoking security_task_setscheduler().

I will reword the commit message in v6 so that it does not claim
comprehensive CPU placement enforcement, and instead accurately states that
the expanded hook provides visibility into and mediation of explicit
scheduling policy/parameter updates, sched_setaffinity() requests, and
cpuset task migrations.

> 
> > -LSM_HOOK(int, 0, task_setscheduler, struct task_struct *p)
> > +LSM_HOOK(int, 0, task_setscheduler, struct task_struct *p,
> > +	 const struct sched_attr *attr__nullable,
> > +	 const struct cpumask *in_mask__nullable)
> 
> Since the BPF LSM is the only thing that reads these, please Cc
> bpf@vger.kernel.org and the BPF LSM maintainers (KP Singh and Matt
> Bobrowski) on the next version.
> 
> While the __nullable annotations do what you say, and a program that
> dereferences either argument without a NULL check is rejected by the
> verifier here, there is still a problem. Existing programs on this hook
> that follow Documentation/bpf/prog_lsm.rst and pass on the previous
> program's ret now get attr in that slot. One declared as
> 
>     int BPF_PROG(x, struct task_struct *p, int ret)
> 
> that returns ret when it's non-zero loads and runs fine, but with this
> patch the verifier rejects it. LSM hooks aren't stable ABI, so that may
> well be fine, but the BPF folks should get to say so :-)

Agreed. Because BPF_LSM_MAC trampolines place the previous return value in
argument slot nr_args, expanding the hook from one parameter to three
shifts ret from slot 1 to slot 3, causing existing two-argument programs to
fail verification in btf_ctx_access(). I will Cc bpf@vger.kernel.org on v6.

> 
> > 		if (setsched_check) {
> > -			ret = security_task_setscheduler(task);
> > +			ret = security_task_setscheduler(task, NULL, cs->effective_cpus);
> 
> The kerneldoc you add in security.c says @in_mask is NULL if affinity
> isn't changing, but that isn't what happens in cpuset_can_attach(). On v1
> setsched_check is always true, so moving a task between two cpusets with
> the same cpus and mems still calls the hook with the destination's
> effective_cpus. With a v1 cpuset mount I see the hook get 0xf for a move
> between two cpusets that both have cpus 0-3, and Cpus_allowed_list stays
> at 0-3. On v2 the same happens for moves where only the mems differ.
> 
> The hook also can't tell this from a sched_setaffinity() call, since both
> pass a NULL attr and a mask, but here the mask is the destination cpuset's
> configuration, rather than something anyone asked to pin to. Please say
> in the kerneldoc what @in_mask means for cgroup migration and
> CLONE_INTO_CGROUP, so LSM authors don't treat it as a pinning request.

Agreed. In cpuset_can_attach_check(), setsched_check is set whenever
!cpuset_v2() || cpus_updated || mems_updated (provided oldcs has non-empty
effective_cpus on v1), and cpuset_can_fork() likewise passes
cs->effective_cpus whenever the destination cpuset differs from the
parent's.

In v6, I will update the kerneldoc in security/security.c, including the
parameter descriptions in commoncap.c and smack_lsm.c to explicitly
document that @in_mask is the user-requested affinity mask for
sched_setaffinity(), the destination cpuset's effective_cpus mask for
cpuset cgroup migration and CLONE_INTO_CGROUP (even when only memory nodes
differ or on cgroup v1 migrations with identical CPUs), and NULL for
scheduling parameter updates or /proc/[pid]/timerslack_ns writes.

> 
> > +		lsm_attr.sched_policy = policy;
> > +		retval = security_task_setscheduler(p, &lsm_attr, NULL);
> 
> For sched_setparam() and SCHED_FLAG_KEEP_POLICY, the reset-on-fork setting
> that gets applied also comes from the task (reset_on_fork is set from
> p->sched_reset_on_fork above), but lsm_attr.sched_flags still belongs to
> the caller. On a task with SCHED_RESET_ON_FORK set, sched_setparam() reaches
> the hook with sched_flags of 0, and sched_getscheduler() still reports
> SCHED_RESET_ON_FORK afterwards. If lsm_attr is meant to show the hook what
> will be applied, SCHED_FLAG_RESET_ON_FORK should follow reset_on_fork as
> well.

Agreed. Since policy < 0 resolves reset_on_fork from p->sched_reset_on_fork
for both sched_setparam() and SCHED_FLAG_KEEP_POLICY, lsm_attr.sched_flags
should reflect that resolved state as well. In v6, I will synchronise
SCHED_FLAG_RESET_ON_FORK in lsm_attr.sched_flags with reset_on_fork prior
to invoking security_task_setscheduler():

        lsm_attr.sched_policy = policy;
        if (reset_on_fork)
            lsm_attr.sched_flags |= SCHED_FLAG_RESET_ON_FORK;
        else
            lsm_attr.sched_flags &= ~SCHED_FLAG_RESET_ON_FORK;
        retval = security_task_setscheduler(p, &lsm_attr, NULL);

Thank you for the thorough review.

Kind regards,
-- 
Aaron Tomlin
