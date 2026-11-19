Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.195.115
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795061241;
	b=aL2CDvuLzTOgKqRS3e0xSDw3bjjWkPzYElmT4tYsiQiR2Vq+ZdBuhyodNm4utR9LIutS
	 ZFbk7taz15DbBd5v1H+Z+XF3tHoeEwz6l0ZNp2FsoPw/5raTEHTsiIWYmkO+uj1QqrvBi
	 WASBKvyiIjjqMzK804AkNu/pj3ikcGfI/7I7THsv3auejqy5UY3oMqNJ0yL+94z0/YuAv
	 7ztRC70GUhahdisxfSG8z3zEmklb1V6piyCtlyiBbv/T87Ez5PvbVxnd/rm+ZVIs3lyws
	 I3KRy3vyi2K2w8aJ2G6uCZPnPRV14RtpfggGk3plYV+xB0yuSpp+8L0nnwE7L4mGM5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061241;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=/DZVkrVqsfVligCm+wSKfov/rAwxs10kx7HsUv9GsGY=;
	b=iCkxK25s8uM5xTGfvmi8FnciAXiwNgYXZt8eEgcDNH+DxGr8UapnMf1E7bcUpvgFXwPW
	 ZhIdGn9+JIBa4YqHD4oyTnKExLzdaBZwrb4mEbnQOrzEsPYEn/1hYLM3bBGA91OvDTdgY
	 ZPtEwAsyryZBtKRjGFYHHLqvw3yU0QZQmJUQMwRdhHFhJAxWv49QqrsJ/9TkDxz7F2i7X
	 jv+pJ+1VgZLgbkErQGKLUVhgern4S+S9PDTHezXTaeDcu6Wa8ZR6bn2D5BvAcLjYnRDT3
	 EhpoH3/l5FR9RiVUE8bbBICqFljdUwSfuqOSjs1wg3pmZeDJATFGlgx4R8vSX0yKwiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=atomlin.com;
	spf=pass smtp.mailfrom=atomlin.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.195.115
Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020115.outbound.protection.outlook.com [52.101.195.115])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF711606A320;
	Thu, 19 Nov 2026 04:07:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF711606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pn1i3x3qjt3zy+8+ITqB9nZ/kOtdTNOhTd/Po8Q1PHThDzg9k4zpVMr/2nmZqfz1ktYfu2XeLJtWkSUGmjkG44Eyivx5a43ORP6Nl0k0FoUFu1UifDlD3xWeauKOGeG1BNzPqC1BbylXLYUN/JkaUtQkreoKqclwiPvLDw3ycSkA0chNSNclV/6fovnLA1XnIUEpmDt6Ym+GPBLT3/fhBR7U8G+RwjM8nXe0QJ8KzG7jxyPncj9ea1v0tYaGoUCMfPF1I3MCAaFveMmX8mADNhnav3FiO7wh56y5hSK171fy5DVkKMEhrGKwgjG3IP7HWYY8gDIh0r6R2ORMuXPpDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=/DZVkrVqsfVligCm+wSKfov/rAwxs10kx7HsUv9GsGY=;
 b=bioWUondq4LYPEvf08H4Cg20M0b9NRUMqMyCNn/aai8V5oKwtB1iO1yhoD9JCrrRqqBai1VP1ZBUh3lzWfCN7ptPyFyt/pFftVoZqB2evOi6UyOoC9iHVt3lcl4QsV5YNFoWsTu3vXvEAnBKI+FPgOf+QCSasvBMOypbjoXJLVgzicAswXxdepQ+hNQDXt3UP2l4Z/zgOwTnK497rrfYZ5xBR0yY2GIHEfRti719AkMx6CYtpMk5VfpNhg91/Ife4UVMBLGO8f1Ql2VsiyPocxc+zuhBNFquZuCsGT/4qwTDzvjbauY9+qsXaOa7WGqLGFKv+KPF/5Ki9Sy7BgiGbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:b1::11)
 by CW1P123MB7694.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:243::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 04:07:16 +0000
Received: from CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM
 ([fe80::beaf:db0b:23fd:822a]) by CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM
 ([fe80::beaf:db0b:23fd:822a%4]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 04:07:15 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: tsbogend@alpha.franken.de,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	andrii@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com,
	longman@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com
Cc: ihor.solodrai@linux.dev,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	chenridong@huaweicloud.com,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	omosnace@redhat.com,
	kees@kernel.org,
	atomlin@atomlin.com,
	neelx@suse.com,
	sean@ashe.io,
	chjohnst@gmail.com,
	steve@abita.co,
	mproche@gmail.com,
	nick.lange@gmail.com,
	cgroups@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/2] security: Expand task_setscheduler LSM hook
Date: Wed, 18 Nov 2026 23:07:03 -0500
Message-ID: <20261119040705.684987-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0978.namprd03.prod.outlook.com
 (2603:10b6:408:109::23) To LO0P123MB4185.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:155::6)
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
X-MS-TrafficTypeDiagnostic: CWXP123MB4183:EE_|CW1P123MB7694:EE_
X-MS-Office365-Filtering-Correlation-Id: f609d0e7-a475-4d08-b975-08df45f297f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|18002099003|6133799003|3023799007|921020|5023799004|261022075727099003|261026121527099003|261022105027099003|261026140227099003|261021121427099003|261021123027099003|56012099006|261102123227099003|261009223027099003|261102125427099003|261022113327099003|261028144727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	o4uFC1NK+GYKoe+9Zuy/aIiklTy51DowQD1RShr+OsuBDYiEchzUMF6DxsyZOr4w80oOfSL9Z10uUVK+q9YpY3cDM3bt+pAfN472+VhdIiP3RIiYHItsrIZD41RdMt48YMYumyCm4GlOcXjep0suJV6iIeiiAWqVVcrYosVfnMfPIUaYdYFJD8MX11bBtolORGXxvfCRqU/9Y5t7fop/WD10g1ahLdKMGOVv9aSi8tNqwi7EKwhvqFYlrlOCXCEmxvO8mpYG5oUnz0SlKZARjm8vCu8eDeNyItu6pBeP8DaZ3AXzNyw+ecfSqFu316f79TIlALcLrw3f+Y5WswzeYeUtsYVXx7uMwgM3b8pLasA00+JPgHpY8GnW0e1q+rCZ05fscNAqmhKStdG4pqSDxzqtA+VxoJgqe5b+O2p5oPLZjJC6bhOQulXxyWloNINJ9844bvjdMIKZ7mNFSrZPeIU+/0REHvwZBdwd+HYMGMHfJ0x+kuzcV9SLgoESJu72kHSSK+WAaq7L3a9eN1p1ykVBh/joWR2vAkExEy4K2So7w4XYS1qNdbUfX9he9qlcHdHWAzZPDhkjM+SgZF+x3U3AKXBr4qsUWCWzyk1Yrx5N+8tukg+kvAD4YduLiQQEowO0/dC37Mmjwd9VWw1KkybqrCoOARgINF9b1eqQ6A0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(18002099003)(6133799003)(3023799007)(921020)(5023799004)(261022075727099003)(261026121527099003)(261022105027099003)(261026140227099003)(261021121427099003)(261021123027099003)(56012099006)(261102123227099003)(261009223027099003)(261102125427099003)(261022113327099003)(261028144727099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WiEhkDfCJOn07GHDltMhTcBJYaXMpf4TZSZ4tzXzfyy8o08Yn4PMMa53kCAL?=
 =?us-ascii?Q?FwM+goAjjq1VzdtTvnDJYGPWHaAN99Nb3qd2yjAwJJs8xhVFobfRe0cXX/jf?=
 =?us-ascii?Q?q/+cJhWvyOOuGPVesLXfKJ7GN3rHHyLcTC/mDZqia3cj20lA2KLNi4mWOwlP?=
 =?us-ascii?Q?b1c+KtKefo/j2rq4YHE6R+aQTwXrrLx/fwo3One0ivKat2Tfb3qOOYDUaBhK?=
 =?us-ascii?Q?kJMJlpcYFd965/K3PJNDtvotA5VYdJgWt4Zam7fba2YkTssvCkjblxFqEchQ?=
 =?us-ascii?Q?ZBWqTDuscnK+/ee7veT+kuZq141ENeRZjz8/6V98WCFX6sIZR1b4v5y2HnOc?=
 =?us-ascii?Q?1mM1V4ZGRMNFMv0R+xyicKy4Lvdjdv1l4PhqC2w/VOSfxbfQ5QF285KLla5l?=
 =?us-ascii?Q?kLOAIu0lGo8yXSXnH/KGo1k70xUUeAIxPzI5PpyujqeZAIEz/DjGSop4g5ec?=
 =?us-ascii?Q?OaFJs992fkgIr+KBGmGY/CXmr1bQP2CPZ8NYDd3B7FwJnrCX4UDdUXeYJuiy?=
 =?us-ascii?Q?8oP3Xyzkc3uYiqurB2uXnGzbQkRgnGIOLVkcFesFEsU/f/Sthsf9wiKFNrYL?=
 =?us-ascii?Q?aUSMemIyDDqAj7SmE5vObZ2KCItmfA4VDtZW3JxfLOlfH7Km64R8HOJGk5Yz?=
 =?us-ascii?Q?u9d6Qp32Ev7l/vFWP3kHwGF5vma5BRJnjux0VQC2k1Ao+5KmfSM1LtpXjUCG?=
 =?us-ascii?Q?EZWlrZM4AwYLI9qvgd8/O2I15mBHueVlIqZ9Hg/KHaNpuWdddJg61qy1QLbG?=
 =?us-ascii?Q?Qd6STpJ4un6xKFjsNNEX4wBwr2TcEBA6nIGDs1COeySMwHSvN7RytfKCJl24?=
 =?us-ascii?Q?664Y6W6Ukqz3NlGMrtZNZ3HLcNlUxpdLz8h4/YX+6z+1iqI4GUXkeJFziP8f?=
 =?us-ascii?Q?ZfEsFoyivFhXFtNDFk9FW8Xor+Bkx0s4R6/3LCU/DnFsTphIlE8omfh21R+a?=
 =?us-ascii?Q?MXe2G9MF03CNeoPnu8azySCHZe64xm0qEJhKjN06w7UhDW8KVYxNGfs2p4m9?=
 =?us-ascii?Q?vY2kfsogDPE3jKBuAayFFEiheF9DUZBZ5dUR/ot9PLzO6ajnKNVL0p27azLR?=
 =?us-ascii?Q?l5QLsh7Lsyu/blqOW/+vaU6RXYvrIgU2Ho6PrgxdFHvqMAq6M9XKb7xyUvrj?=
 =?us-ascii?Q?YoDY4AeILtHdHtPSej7XlPAZTn8Xlp1WsnWgu5aVJrWBztMXOrNpdo/5Auyi?=
 =?us-ascii?Q?8wy/JkopNJhU8IWs+tARUq7jAL4VAkNaeNRUG+SIq++QychtlrakMVc07ZqN?=
 =?us-ascii?Q?c/21MCBD+NmTSIPkYbMoBZOL27rqRoq35bUq6mqPGLcDyRUdVhONvgnOkgzz?=
 =?us-ascii?Q?yvtsmJJPIpgPD9eUBWsQjzq3aM0mE9temKDsFG5QncND/AwH9+FFp+imOc0w?=
 =?us-ascii?Q?rxsdG8T5TNx6rz/PSipqUWEpPRPdYekguvqpRcfNPS5hoIexZNnGqT3fcqq5?=
 =?us-ascii?Q?CZL25DweCUkmKOsRDYkllq/Lxq6JsLyHuf4yZ4hZ8k9dQmbnhg+suL18Wt8U?=
 =?us-ascii?Q?svfvifYQrQYsy3V/KPqMwwuPT3dQzpngzfby5ncYbRAXu52+OCXljfl678zq?=
 =?us-ascii?Q?7y5qr47RJv+s8c6/yAbGkI9NKeDgii1CM9toG7qB0sAOcpKOx6JM+O6UZ2/g?=
 =?us-ascii?Q?gnXbD9u5cRRHloXuLB4k6/0ETWVHi0SJJfU9Tz7KElMpzeYdkwTDtQIf4rgk?=
 =?us-ascii?Q?X38maMAbd4MHi0IYxAdV5lXHNeVRYpwv6toX9UtfcHD7g1+czSZBzspoCQH2?=
 =?us-ascii?Q?qGnSy3Z18g=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f609d0e7-a475-4d08-b975-08df45f297f0
X-MS-Exchange-CrossTenant-AuthSource: LO0P123MB4185.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 04:07:14.8265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IgYclzaVFDf8OilU5NdRBwU1RWwILuWi8kax+vfIh0e6a4pcJNmqlRcYljp1+AbCEh++OcSYKXycmH20MIO0aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB7694

This series expands the task_setscheduler LSM hook to accept nullable
pointers to the requested sched_attr and cpumask alongside the target
task_struct. For sched_setaffinity(), passing the raw user-supplied
affinity mask allows LSMs such as the BPF LSM to audit or filter the
mask as requested by userspace before __sched_setaffinity() intersects
it with the task's allowed cpuset CPUs, which seccomp filters cannot
inspect behind user pointers and scheduler tracepoints only observe
post-intersection. Similarly, __sched_setscheduler() passes a local
sched_attr populated with the resolved scheduling policy and effective
SCHED_FLAG_RESET_ON_FORK state so parameter-only updates expose the
effective values rather than internal sentinels or caller defaults, and
cpuset task migrations and CLONE_INTO_CGROUP pass the destination
cpuset's effective_cpus mask (note that direct writes to cpuset.cpus
update task affinity via cpuset_update_tasks_cpumask() without invoking
this hook).

Because BPF_LSM_MAC trampolines place the previous return value in
context argument slot nr_args, expanding task_setscheduler from one
parameter to three shifts ret from slot 1 to slot 3; existing
two-argument BPF_PROG(name, struct task_struct *p, int ret) programs on
lsm/task_setscheduler will therefore be rejected by the verifier until
updated to the expanded signature. Patch 2 extends the BPF LSM
selftests to verify the hook's runtime arguments and -EPERM mediation
across sched_setscheduler(), sched_setparam(), sched_setattr() with
SCHED_FLAG_KEEP_POLICY, sched_setaffinity(), and
/proc/[pid]/timerslack_ns, alongside verifier checks for the __nullable
annotations.

Changes since v5:

 - Replaced the second paragraph of Patch 1's commit message with the
   concrete rationale for inspecting the user-requested affinity mask
   and scheduling attributes prior to cpuset intersection, and clarified
   the scope of affinity mediation relative to cpuset.cpus writes
   (Chris Down, Peter Zijlstra)

 - In __sched_setscheduler(), synchronised SCHED_FLAG_RESET_ON_FORK in
   lsm_attr.sched_flags with the resolved reset_on_fork value so
   parameter-only updates accurately reflect the task's effective
   reset-on-fork state (Chris Down)

 - Clarified the kerneldoc for security_task_setscheduler() to document
   what @in_mask represents for sched_setaffinity(), cpuset cgroup
   migrations, and CLONE_INTO_CGROUP (Chris Down)

 - Added Patch 2 to extend the BPF LSM runtime and verifier selftests
   for the expanded task_setscheduler hook

 - Link to v5: https://lore.kernel.org/lkml/20261105172210.76706-1-atomlin@atomlin.com/

Changes since v4:

 - Rebased against v7.4-rc1

 - In __sched_setscheduler(), populate a local copy of sched_attr with
   the resolved scheduling policy before calling
   security_task_setscheduler() so parameter-only updates (such as
   sched_setparam() or sched_setattr() with SCHED_FLAG_KEEP_POLICY) pass
   the effective policy rather than SETPARAM_POLICY (-1)

 - Clarified the commit message to reflect that both the sched_attr and
   cpumask parameters are introduced by this patch

 - Link to v4: https://lore.kernel.org/all/20260720014156.459386-1-atomlin@atomlin.com/

Changes since v3:

 - Expanded the task_setscheduler LSM hook to accept the 'sched_attr'
   payload, enabling BPF and other LSMs to inspect scheduling attributes
   (Peter Zijlstra)

 - Updated all call sites for security_task_setscheduler() to correctly
   pass the attr structure when available, or NULL otherwise
   (Peter Zijlstra)

 - Added the necessary forward declaration for struct sched_attr to
   include/linux/security.h

 - Link to v3: https://lore.kernel.org/lkml/20260526142838.774711-1-atomlin@atomlin.com/

Changes since v2:

 - Dropped patch 1. This is to be addressed by the cgroup cpuset
   maintainer (Waiman Long)

 - Dropped patch 3. Will be submitted as a separate patch (Paul Moore)

 - Link to v2: https://lore.kernel.org/lkml/20260509213803.968464-1-atomlin@atomlin.com/

Changes since v1:

 - Reordered the allocation and user-copy of new_mask in the MIPS
   architecture's mipsmt_sys_sched_setaffinity() to occur before the
   LSM hook is invoked. This ensures the security modules evaluate a fully
   populated mask rather than uninitialised memory, while cleanly handling
   error unwinding

 - Updated cpuset_can_fork() to pass the destination cpuset's effective CPU
   mask instead of NULL

 - Link to v1: https://lore.kernel.org/lkml/20260509164847.939294-1-atomlin@atomlin.com/

Aaron Tomlin (2):
  security: Expand task_setscheduler LSM hook
  selftests/bpf: Verify task_setscheduler LSM hook parameters

 arch/mips/kernel/mips-mt-fpaff.c              |   2 +-
 fs/proc/base.c                                |   2 +-
 include/linux/lsm_hook_defs.h                 |   4 +-
 include/linux/security.h                      |  15 +-
 kernel/cgroup/cpuset.c                        |   4 +-
 kernel/sched/syscalls.c                       |  11 +-
 security/commoncap.c                          |   9 +-
 security/security.c                           |  21 ++-
 security/selinux/hooks.c                      |   4 +-
 security/smack/smack_lsm.c                    |  13 +-
 .../selftests/bpf/prog_tests/test_lsm.c       | 164 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c       |  51 ++++++
 .../selftests/bpf/progs/verifier_lsm.c        |  49 ++++++
 13 files changed, 328 insertions(+), 21 deletions(-)

-- 
2.55.0

