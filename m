Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022121.outbound.protection.outlook.com [52.101.101.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00283B5F63;
	Sat, 29 Aug 2026 15:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788018948; cv=fail; b=aLkcjpUK1Wwm2mG1oh2XSrR5/vH60+KFHxWLrHOo69DqQmeTYj/cNWJfSUxLxtqtPs/9AWO3IKy+6Hx0c+9pjxQZE7+gHEN/BpQsMPD1r47aPsT709/hqD8waRuzQjSdRTSbLmaj0l5/mIhHPyLFVsa94JCs79BkNfwu8kCal78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788018948; c=relaxed/simple;
	bh=7c14YmGi+MhA4QVQzV6uhT+FzRepdMx61HoBQnSxWz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ks2+Kn5xh1wsD9hAHbuUvRsYtqXCOsflPDXMpJ9SXYrWUsHpYEOLeuDckqlaf/NuFn+MlzpA2icUmR5DxAmR0EzXOP912vVUl+wH7uuDYdihQuva7AftG1eXRESBt2oPxioTTZr7P5zmuNBbZSsoKSBSESBs4TvnA9llbYUf3SY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jK5x/jXCKLfpfEFM754UKPvVWvqZwQWPonseYFZs6U5kVzAL0mP7S2tLkbe49BS1F2CK9fDfbnndHhMwP9L/J5Frb2/doR34Xg/OH48RppU55ystWLt3atAYYS9Sh3Uumw/ZTHIwSj331R10aK1ZvYiQDsUcjo+ccHP90lfUCFHXhZPVPX9TkBvC9HoJNVgdYKE3ltXQVtQBucQhf3rJGbsqhYgk21/9X0jaCXTpvggcfXVOTQ/Kx/7HwLegrbamW+mKPr8e7KeOE+TwJqpsqObw0avQl5a/1yJrwt1fefg0fmZWb2NJJkcG0jHITm5prICmfpMzvb3oX+0l2CKMfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=LAZ+ZjUdzB4kC3BwoVkq58cUctHOXl72lD1gWnBjEw4=;
 b=Je0sRlTXCRZd5N+rcLOw/O1uASM3PVp03nL+OC/VDWgTRqIEKsQX2ctVhO2SsN927nP5n3yySmiHBJzXjtcfHLi8/oDnUghNgVMYJvFbrotwVLHBlWN+YR3y1/7S0t2nGDWHy3PMDHVBlmHDHhqQK/FIx60SF9hSIIS8okKGuiq+KdoXXEz3sUIqv6emW40pfTEHo9wZCSE73dPMFNsnj7wt+mriVxHgv1awaBlTFqeoiD/JKQ5pBpeL5FzatNs/t9nOfLenVvAJDvOf4w0653y9FUlWM+BWn6rmuzFj/575KEyVzt38cujxzuJaodoDM6/cHq0r7NkYsAapl49k/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by LO0P123MB7955.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:42c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Sat, 29 Aug
 2026 15:55:41 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0360.008; Sat, 29 Aug 2026
 15:55:40 +0000
Date: Sat, 29 Aug 2026 11:55:36 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: tsbogend@alpha.franken.de, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, 
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com
Cc: chenridong@huaweicloud.com, dietmar.eggemann@arm.com, 
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, omosnace@redhat.com, kees@kernel.org, neelx@suse.com, 
	sean@ashe.io, chjohnst@gmail.com, steve@abita.co, mproche@gmail.com, 
	nick.lange@gmail.com, cgroups@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] security: Expand task_setscheduler LSM hook
Message-ID: <h3jmgorwo2jbwz4vv2bvq647agkcdyfqd4e7j2mu7vep33pe2b@um2nrycbeedi>
References: <20260720014156.459386-1-atomlin@atomlin.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260720014156.459386-1-atomlin@atomlin.com>
X-ClientProxiedBy: IA1P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::14) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|LO0P123MB7955:EE_
X-MS-Office365-Filtering-Correlation-Id: 08bf8910-329b-439c-c9f9-08df05e5f99c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|921020|6133799003|10067099003|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OF4PsV9VNxqSO5zTsdpgtx9x4rZz0oPlHNhilzzwEUT7XavAW+VoYOOf+YmVEV0dE547NNUeu8rlImQkqoqMOqFna9k3+BGxBF4BF8RHMlCIhqvJs1cdF5Q6RkFDsFIPnZHTQzvhJDIWoeLMAzVXvPtj2YlZNiYUr69EJ1F5y3pxlAOaZjPn04EhwfOrz7M90UExkNPYfyDQ7X61ZfO/LTr148xpLcOJ4IVj6uXLS9DXH/rG5p11/BXU/9VzvIibB1Qacc+vjAuJJGbR48+89070K/PDvkM636mBYIUZ6Hy6Z2YPJp1ZtFJKszZkHq6yA1Adwid0pzyybUyiKpX7g0LgaEstLriWaZGLrkhFasQCuJ6UinrQro3PwOSEqHlvZ1aumFgDjnlT+MWhM0Tii+xmIHtPTipvcBKvhiUI/iAXfAlEcLxOQCV2X7+jtd5o9gDPBhfM5OhrXaE41/kmihSs6ParMKrYgbdtGPwS8PbOh3HR68FGC4X+snBeB6Co8oAgvCHb6++uqFcNXu0OWs1bMqr9vRxve05j/iwrg1Pddp2c3OQJnhrxVTZsI2sIMMNKpSo6EQ2kZLU3Xxjh2zeOUc6t7rj33w8/f47lhNGR7mgQ/zjvQbF0fkl44iYwhDuotvle23rTdaqwAnuB5jEo0OdqwzmGI//uel6SBihhnWdSAAEaqJvvsoORnXpqFbS7+512pGziOqnLqNTxuQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(6133799003)(10067099003)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0Nid1o1R3I3bXcxK09aWlZIbGd6WVE4M2lvRWR2QWRHc1pJU2doTWJiMXIx?=
 =?utf-8?B?OWoxZlErL1lleEtmVVFFd2FYdnFYU1ZxRExCU2dKQnZuUkRnVExUalNKcEtt?=
 =?utf-8?B?Y0c5c0c3S3VNSVFIbzlsYlU0dktyNEZZRm8wTXBGUk5sMUNCSHFvbUdiMFcz?=
 =?utf-8?B?bWMvWVdvYVBESEg2L2hPMWRuSVBhcEhTQTRrNFVzbGlLN25NdE9lblZhejRN?=
 =?utf-8?B?YmtQUEo0QW1YTkhka1VOUWovd2lCdTUyZkE5SlJQQVhrbFdmUmh6dWs0V2l6?=
 =?utf-8?B?L1p2dlp5VjdPSGNXbGtiV1pwelhLYzlQUk4xcUtwV2FXQnJqNms4QzZFc1FL?=
 =?utf-8?B?WmdKTVdZR2IxVkJNVlhsN0JJM2ZRdU9ZamxjQTB0S0srMUlMOTdCY1hLUGRj?=
 =?utf-8?B?MkN5SFJQRjRaVDFtNExlWjJodmlSUHpQdUF4Vk1sVUwzTkR0T0N5TjMrSEpC?=
 =?utf-8?B?NXZDeDlGdUw2bW4wL2hCMU41aGxXM2hmZnE1aFlHZW1FRlJ5eWJPUE9vODY0?=
 =?utf-8?B?ZWlhanJpek5tQVFvKzBLZUhnaE9tc3puYWduS1hya2lkVHZZK0Q4UmVqdTZo?=
 =?utf-8?B?OXJvM3dtaVhVNmErSGZ5d3dZd1VDdWtYY0EwSkxURDVXR0pxbGFyS1lvVFBY?=
 =?utf-8?B?MlBES1ZyU2RBVnQzZTV5UllyRWFLclFhWUllMFVMOXpCcytXcmFPaUV0OW1Y?=
 =?utf-8?B?aVhwdXNwZ3BtdEM2Mm9vRWNCTzFXUXMrL2tla2M4aWlkOEd6dkcwckM4UnZO?=
 =?utf-8?B?ZjQ4VitqbE5adXEvbmNyTDlveStEN1lEenlmYW1UcWdGV1QwR09DeGovaHJL?=
 =?utf-8?B?WGdraHRTcUt6OUluRXV0Q2hrQ2szbEI0WVNRc1BFcFZnQVcydzRVS0JFU3Fr?=
 =?utf-8?B?MXRRR00xTUtuOFdOZjFTR3JyMVgybTBPUEdkd1BKdDJ3cXRYeGxTS3BBcXRB?=
 =?utf-8?B?enhteUJZcjdlSkpFV25uTW5CMUp6NVZEZVB0ajljeFlTVlFHYnhsQk1YY1Vu?=
 =?utf-8?B?QkhxL3pKZ1hYOG9CR0NsVG9WcFZVeEY5Zm9ETDh2QlJHTkJaY093RFhyV0la?=
 =?utf-8?B?Y0ltRTJpZ3krMU9Vb296Z2xobm5lUjc5dVhFelpZSXI2QzVQbjJJREZ0OTBH?=
 =?utf-8?B?YXp6Sk8rdDZLWjFxS3ZsMFZteVdYUE51blB3UXp2K2x2QlZTczRZc0RVeUZU?=
 =?utf-8?B?ZC9yeXF2cVF6RmFpWStHZjRBS1ZYd1lEYjZ1VmkxdmU5Tzl1aEFmcExYQjhj?=
 =?utf-8?B?M1JSNnpWTEVKVS9JNE11U0VvLzd2NkdLWmd2SVFveEFHY3VPWFJKRmtvenhR?=
 =?utf-8?B?VTI5OENhT1RJc3FCZ01WZ002cGt0UzRRUS9zV1IzeS9yNUNWRWZnT3RQNXhE?=
 =?utf-8?B?MHRIclFueStFNnFIaFdqaWZxN0dTcWtVUG9LM2Rpd3RLVDNEUHJPWEZaYmc4?=
 =?utf-8?B?YlIyeVdrWTdLN1hnVXBvbEkwM1lrUVRwZ3Q3WXdLa25EZ1VMZ29wMnY2cUJi?=
 =?utf-8?B?QTgrTENpQVFQbjZmUi9NSlBIek5ua1B5cmhtSUR0cVRXSTA4ODViWjFRZTNm?=
 =?utf-8?B?UHlKaXdRems5cG1FcCtuVE1qblk3dUFRY25aaDJYTzFMQUlSSm9BUTBIUUdv?=
 =?utf-8?B?R0NKa2V5RU1jVHZrK3laem1hSHdGZzhpazViK0MrZnZKdW1PdzMzMndzNHJw?=
 =?utf-8?B?M05ZcWxsSE9yOThMTXlwVHNaY0xFYTdWOHhKTnRZd1phVFptS21RYjA3T0Jj?=
 =?utf-8?B?aFZXWk9aOFNzeVl5Q0FLc0ExVklXWk9qNWoySWNFdEU0OFlkS3BSNlVuMHc0?=
 =?utf-8?B?NkljYkZNREtTNGRyb0NlczJldTRNQ2NHcCtGam5JT1IyWHI4blpTOWxvQjVH?=
 =?utf-8?B?U25Ud2FOT20raE5TdG85VHhSUDlhZStUSDhpc2QvNXhQWU9QR3JTWWxjb05k?=
 =?utf-8?B?WEhPaHpRVnhuYTN6dzA1TVo3QkhTYUFaRHpWUGd2Q0hPTG5HdFYrbXNzdk1G?=
 =?utf-8?B?ZWFEbWYwcVRvVllLWit1bzB1QUI3eUZ0ZTZKZHVycjBYQUhlalZKREVza3ZX?=
 =?utf-8?B?NFBDaStlZW5FWnFtK3lWRTkxSW5leFhWeHNXZWR3b2gyOHEyaDFuRk1wdHRN?=
 =?utf-8?B?R3RqZXZ4dUlWQ1dmTTErWVI0Q1lyT0ErMS9mL1Awdm1RVUFYbGpwZDJCVnk1?=
 =?utf-8?B?ekJRT1Z3blpJM3BJb2RYdkRPMHNKOGRKRjd6UGdOY2pHMHZHa0x5K0pDdnEz?=
 =?utf-8?B?TXlIY0lWQ0ZnNWRoNWFaa0xuZTd5TzBZaDZNT3BWNUZ2S1IyWENiN2gyRlhL?=
 =?utf-8?B?NGdpZE55ZStJR0ZDZ3B1OTlIQ1Nub212cHp3UTNJK2RpekFGMjNuUT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08bf8910-329b-439c-c9f9-08df05e5f99c
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 15:55:40.5196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Te9+KUC/Lr/N1+tyS1WdYTAyguWGN7/O2RY3YsWRZGPDCF+OGQQ+hYyH6FwoLFKXo+Ffp5uBB8ZjIzJt8epn1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7955

On Sun, Jul 19, 2026 at 09:41:56PM -0400, Aaron Tomlin wrote:
> At present, the task_setscheduler LSM hook provides security modules
> with the opportunity to mediate changes to a task's scheduling policy by
> inspecting the requested sched_attr. However, when invoked via
> sched_setaffinity(), the hook lacks visibility into the actual CPU
> affinity mask being requested. Consequently, security modules are
> entirely blind to the target CPUs and cannot make granular access
> control decisions based on spatial isolation.
> 
> In modern multi-tenant and real-time environments, CPU isolation is a
> critical boundary. The inability to audit or restrict specific CPU
> pinning requests limits the effectiveness of security policies,
> particularly when attempting to shield isolated or cryptographic cores
> from unprivileged or compromised tasks.
> 
> This patch expands the security_task_setscheduler() hook signature to
> include a pointer to the requested cpumask alongside the existing
> sched_attr. Because this is a shared hook used for multiple scheduling
> attribute changes, call sites that do not modify CPU affinity are
> updated to safely pass NULL for the mask. To protect against unverified
> dereferences, the parameter is annotated with __nullable in the LSM hook
> definition, ensuring the BPF verifier mandates explicit NULL checks for
> attached eBPF programs.
> 
> Historically, SELinux has governed all scheduling alterations under a
> single, monolithic PROCESS__SETSCHED access vector. However, by
> inspecting fields such as attr->sched_policy or attr->sched_priority, a
> security module can introduce granular access controls. For instance,
> differentiating between standard time-sharing policies and
> latency-sensitive real-time policies.
> 
> This change updates all in-tree security modules (SELinux and Smack) to
> accommodate the new parameter mechanically, while providing LSMs with
> the necessary context to enforce strict affinity policies.
> 
> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
> ---
> Changes since v3:
> 
>  - Expanded the task_setscheduler LSM hook to accept the 'sched_attr'
>    payload, enabling BPF and other LSMs to inspect scheduling attributes
>    (Peter Zijlstra)
> 
>  - Updated all call sites for security_task_setscheduler() to correctly
>    pass the attr structure when available, or NULL otherwise
>    (Peter Zijlstra)
> 
>  - Added the necessary forward declaration for struct sched_attr to
>    include/linux/security.h
> 
>  - Linked to v3: https://lore.kernel.org/lkml/20260526142838.774711-1-atomlin@atomlin.com/
> 
> Changes since v2:
> 
>  - Dropped patch 1. This is to be addressed by the cgroup cpuset
>    maintainer (Waiman Long)
> 
>  - Dropped patch 3. Will be submitted as a separate patch (Paul Moore)
> 
>  - Linked to v2: https://lore.kernel.org/lkml/20260509213803.968464-1-atomlin@atomlin.com/
> 
> Changes since v1:
> 
>  - Reordered the allocation and user-copy of new_mask in the MIPS
>    architecture's mipsmt_sys_sched_setaffinity() to occur before the
>    LSM hook is invoked. This ensures the security modules evaluate a fully
>    populated mask rather than uninitialised memory, while cleanly handling
>    error unwinding
> 
>  - Updated cpuset_can_fork() to pass the destination cpuset's effective CPU
>    mask instead of NULL
> 
>  - Linked to v1: https://lore.kernel.org/lkml/20260509164847.939294-1-atomlin@atomlin.com/
> 
> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
> ---

Hi Paul,

I hope this message finds you well.

I am writing to follow up on the submission of [PATCH v4] security: Expand
task_setscheduler LSM hook [1].

Casey [2] has kindly reviewed the Smack portion, and to the best of my
knowledge, the suggestions raised across earlier revisions have now been
fully addressed.

Appreciating that you have many competing demands on your time, I should be
very grateful to learn whether you have any further thoughts or
reservations regarding this series, or if any additional adjustments are
required on my part before it might be considered for the LSM tree.

Thank you very much for your time and continued guidance!

[1]: https://lore.kernel.org/lkml/20260720014156.459386-1-atomlin@atomlin.com/
[2]: https://lore.kernel.org/lkml/31679bf5-a0cb-41b6-bc1d-7833c4fc9744@schaufler-ca.com/

Kind regards,
-- 
Aaron Tomlin
