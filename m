Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794281718;
	b=wJvsn6xT1FfPXMd28JkSUNmPTSj2rebU4c06rrymWVDNbm/uDhWQ+VWlxrpig2Yo9FB4
	 BuU/qVYGvAvniGQdgmN7tadSbxCMRMJqdIgnVIkGR2l0rW8Ib4D7mKH03Owbd0Zhm6i9w
	 dQy5JvIeIZEx4KRRPN9ohUNZqeEYJMmtoL/0QY2cVNjCCJwN+EICkO6+L2Ve0oUesUE7/
	 Id+06Z27rIhwBQmjA7vNMDMtJR9f6Vte6zMBg1XWDJsBjKnDr+UvXORH+8Uykw7RLdQQs
	 Mr/4778E031sIauxD1Gul5rpGDuh3WEjV6xLQqX8ezn5DHIhp80tDimKfG571LJn1Nw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281718;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:X-Mailer:Message-ID:In-Reply-To:References:Content-Type:
	 X-MS-Reactions:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
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
	bh=WkkM/R5qWbfTISU6pj4CyXD/2ii2VVA9oJ6sQdXNT50=;
	b=2yY8Lv0JnFiF/atMVbiJ6vwZf1HqI8zGfCuop9E63kAAdYTpYxU/lIeUyuoPG/Iml5/t
	 vz80rXmr5bohX6ZS1pQYuo8wpPuPZHkSShlGosqrRPisX1OSe32xYRyUnacZAlX5PqhdI
	 RM6rlyD77wYEo7evfsSnVuyxQzT7odNnUvhoxVkENFAgCpsNbkpeEvtlyN0m881xrFQAI
	 eVqMTcI0ORFP4AuYUet0aUE46DJt+Spqu8uvsMhrUHkU0xmplMX8cBVyG6Bjd46vU/1xk
	 eyD7qYh83oPm5iLbnTRSTEwUIZ+S4d59gdmNz8Mq6SKNlSUKiKLVuq+0djFnxMo3qKA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=s3vcb4kv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.25
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013025.outbound.protection.outlook.com [40.107.201.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D989606A332;
	Tue, 10 Nov 2026 03:35:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D989606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=s3vcb4kv
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cSod3yjXBebeic/hqd9Qi646naT0LqCGcz0Wpjzpi2p7JsVM0weujbbnwHkqQXlXwgeDATPfSEIXnaCM4ThEA3YvxSkiB2v7U70RYowo3xvLTswjgliKM1nwV/SiIluSH87+wEHHXPkRufpRYOKpVKq/ZmQIDbox8lXi1oW+6LMrTqTjvg6B2Y0xWW17JX+pbs6d3SXgvZ8igRXwPSu/9Dvz/cTuJld24PP0W1ISbl1dBmQoMpS+gUTCkaIMofZEqAvm9LwgIgdM3fiVOt3VzC4OhxjinUKEGvOQtQQwed/GdvZrd2XNeomiyrgVd794gwCUitj4wmX0y5CDIe1b7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkkM/R5qWbfTISU6pj4CyXD/2ii2VVA9oJ6sQdXNT50=;
 b=mJkUtY4w+/25qbG29aZiqAzNwFoEk/MDqdsydvBENZ1LXDvLuhbJH1x/eRXI27eRYf78Rb/Cbzs/U9nXLYYVayVPOhYF6iBkb3H7M/p5HUBshf6r1M+ySQqqi4n9xqnwjeLAcGHv+u1YyRm8PqZ0GKgDX8+v3vDwkhGLVtl3wnjNA1LgiOKoQfBAH1prX6lADCVnnBnUm25l0XF/8YdEUcUIfM/M7fYYHSPmfyO2XTFODEBDUGS7tl2m2hnfOLRoUdHulkDeGqmc9zJ4gDBOnoSSIMrNa79KBw80oGZOCwblZa7i1s0SxZGVvAIBAxUk0e+csPbmPfxsDL8QmGsOPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkkM/R5qWbfTISU6pj4CyXD/2ii2VVA9oJ6sQdXNT50=;
 b=s3vcb4kvJlRC1Aomk6n6SmCmj6r6ugMNtl37g2C3Y/9YpxXj/J6ePIB4mwSD1+7S0nqhdtBX2mbbW7Y7UNmj9BInuudR22n9xYtuKJbDg6IudngMPDBlCxN7ip1I0v6fRrOIMqDsrhVtoNPNQEKag65o8WyTrr1NQq2vjbZlui2igPqIfAAwsknaKEdYCDJ6V0gfeRFiENB9JUAaaeMXHbQuGQ6wsH8iye0EncwJnPnp4DRAaF7voIxg6vbNANxFayqOUKR6MFd4+uSggt+1OqDIoCVzw+VLuLsSgZkp15L+sk4xluPsZE/kHdN2B2Ie/yW9si+wgCqGRmEcfbV2aA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6977.namprd12.prod.outlook.com (2603:10b6:510:1b7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 03:35:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 03:35:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Yafang Shao <laoar.shao@gmail.com>,
 Ying Huang <ying.huang@linux.alibaba.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org,
 david@kernel.org, gourry@gourry.net, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev,
 yu.c.chen@intel.com, zhao1.liu@intel.com, tim.c.chen@linux.intel.com,
 lizhe.67@bytedance.com, mgorman@suse.de, bpf@vger.kernel.org,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next v4 0/4] BPF-based per-cgroup NUMA balancing
 mode selection
Date: Mon, 09 Nov 2026 22:35:10 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <8D6452ED-CB2A-4D08-863E-039A9D0DA453@nvidia.com>
In-Reply-To: <20261110032913.71974-1-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0P223CA0030.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::33) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b6f453-739f-4e7e-4266-08df3edba0b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|22082099003|18092099006|18002099003|6133799003|10067099003|3023799007|5023799004|11063799006|261028144727099003|261026121527099003|261102123227099003|261022075727099003|261022105027099003|56012099006|261021123027099003|261021121427099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	MZygwOPh19Gj/cgBwW/hyB8COVqsWbOvYZCeo2EKVlaSxoGkZ8DaFylJUNmRJKXJv3QSSdv256ynhaDr3LpI9cUzUcJyomnyq4rCuv+9y9KYt65uRx2plEpRbWB02WV6UkT08P+lbKOD0v1LPbXkmHwaalxVVQNuwbHh/1V7seUzGDinshXRWMEbsVMf8ag/u6QmXL4I2wZuwoouXge5QKqEHhQ4jdpUWBVRaWAwr6ca31kNlSu2hY2vbIvjn2odGlMKfBw/caHLm6fj92hQ1dmlwYqKGmMg2/TGWxLfloD7vZBi20L/fv1iNB9HJcC+4E82CN2tKD3pb1AAJf+RV0/T6EbzKRb2V+jPlvNpxz8LsQlGiZUaH4DbbNGBAFX6pabH4LdSnggKg+Alx4w4BsMXDA+pAWFKa255p4vEirbGNHP0WdXI8Y4ux9A+iPDPSn7c/8nlm3xx4GD6sx45u3UUgGCdqCET0V508axlELnHGAdHvNyXP6ahRlSEE9v0x7Hz7zKlJbz0ToLd1MGMIT68aFL1sXtJeyetHNTQU+Y8g9nfGXPig6wDxEKiKkRWnh+yzX13lExUGlx2Q68VThzIic+AeWbuuoUBVyZvj4DkXVmQ+nbwD3NsJR5pwF8CURZ0PbPofVws7rWYjH3C/ZIKPi037pi5e3ES00SC/qc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(22082099003)(18092099006)(18002099003)(6133799003)(10067099003)(3023799007)(5023799004)(11063799006)(261028144727099003)(261026121527099003)(261102123227099003)(261022075727099003)(261022105027099003)(56012099006)(261021123027099003)(261021121427099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k7rQ+DqWBAhqc6NVV2UYOl7xz0N8/Fo7T6JaJL+OmEQ/+MGW8fKU0UNrL6EH?=
 =?us-ascii?Q?OuhzXOhSKgqxfii0KpDvYwjxoNOUJlcQ6XYp7SkljAXth8u04dnZZglM8VHV?=
 =?us-ascii?Q?tEh6GXk2XAASorHjbdrQQISr8UM3u9oDpOphUKkZm9WVVnjl4e7aXIXaq1KD?=
 =?us-ascii?Q?GbPURd4lgrd5Qm/QzVaLGSSzdfMYoRuv7O8LGsZzhSvlcIHv4nhCF65Wfba4?=
 =?us-ascii?Q?pnLFPVQDjXtZ71PaH+ST2ArFuRSw8nnK3n6dy+/qNIhrgrSFmFcGAUJCuevj?=
 =?us-ascii?Q?Ghr6Pq0CfysxUJwp+eE+CUxIrxY4xqGGVUuieILLlQ+wqYIaC1HP8zRbXxhI?=
 =?us-ascii?Q?fPaE0GiTX2CnGD9T5TvZbzMsLYhK+rFSfHH/uckH1zfeSk1AykubQVryJ9jd?=
 =?us-ascii?Q?oDLKt6BO3PLg0OI6PhcazF77PhUITHEoIe2AG6xE0t3itpub4BvWsYSQ510Y?=
 =?us-ascii?Q?Pvj/+5L5F1/opQFFsfO0cayNs/GCwWdx6gxPOyyaRB3wMOb5K3uicJoS/ZTg?=
 =?us-ascii?Q?RJ6vtV+1cNWt038J8GLs0FYomVT+aN4mOjI2n009B9pyJP2Kwn7+07zdvo2J?=
 =?us-ascii?Q?WZ32sXcUKMeudOpdXDZPG8ItjeVhG2YPuASdcGbG7cdlcLw13U6CtSi3/+qf?=
 =?us-ascii?Q?uDiKTqSMZplh36V+n0atbxmQSfxK2z3OfZelVGTXx8cwJa0ojk4X6N7GqD5p?=
 =?us-ascii?Q?2CcNcDqEROkOf/8kt/k7xTOB7ud+Nm9yY12iMNJ/Lx7Y5WnchO6ePzuSGsxl?=
 =?us-ascii?Q?krsUo116YFxijDCFJasxRTK0EHOUa+tHiGvqNIGm2M6q/PTHMKcgLkY9dbYY?=
 =?us-ascii?Q?j+47YYWpoxWbMwfS7zNmwUBRSSntI2tt/6ARL6JgqFXaqcxFEKmR4OCGqEMY?=
 =?us-ascii?Q?/Mi0RWFxgvA7MmuX4Evf5ptzyIrbtbtHKpD7ywxB+RoTjzd5OkR5NYBGYCMG?=
 =?us-ascii?Q?KHM48DedD9yEcVGvOLHgCwzmNEML7HswcCi3FoJtH7CqV14JE5scWHY0eZBW?=
 =?us-ascii?Q?NYWviFqpOx2NadvANS/bFPWIQAcozup0+Y9DD/rpndJdW8Gm+FzU3UuGuC5n?=
 =?us-ascii?Q?87aCQd2HLlQFRvivPaPerRGXoAqhKW78pbaUy52EOiTBlpzv9/wsG5bqvtTU?=
 =?us-ascii?Q?zZE4gvYIQn67KIVuTRNI4QUCpYlCyh4iblyl94nVv+iEaO34q8+KDoYZmwDl?=
 =?us-ascii?Q?nmtchjpBfiJwr5norlw5m2BTOAlHkWE4x03QVHBGSMlkmcl2csQ8OR5fN5g1?=
 =?us-ascii?Q?O97w3KseC556biCv7Bs/yg+noXBJ2tWHR1NQ0XHX97+gbRJiOyijC92jNa67?=
 =?us-ascii?Q?wp0zo8hRWUPHBUgPc43ald1cZxi8oUIBts5rG0SwbCxvZjhtpHEV96oaCAfz?=
 =?us-ascii?Q?ZVZXvoZ4PDzt6QNrT4JstyjSX59xzkTraksYRU6XnNOiPqP7hlVQAsxAj/bH?=
 =?us-ascii?Q?T7KP//PZfn8oLyiX6CmcMAH4WxWacXjIIcKi/Lq3X8FtvYxIAVu89WqTe6e6?=
 =?us-ascii?Q?1bjUGql9ornR/BElA5ehl88ABJ7K9th1Un2sbcVcdZDOD8X0/biW5meUS3x5?=
 =?us-ascii?Q?O1e+TkZP3nzfQ7oX3zwj9ubP4YSFA8tmM/oZ2siEledpin5M5i59PdmztRo+?=
 =?us-ascii?Q?zNsHBkkt5BPLYW4spqF9uGl1w3+zwTJOgWdV5AIyz4RKP5zIkZ6FTdaZcVJ2?=
 =?us-ascii?Q?siWnbB5g6QMlP75vQ6dzYh19Jzm2IxfnQj3OdhzJ4FoPqAhs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b6f453-739f-4e7e-4266-08df3edba0b2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 03:35:12.5890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/Lt6Pn9+Uy95WGwAGhbRRY7l757nTBqGkQt5YDFZOchwx3VLlsfgrFtj5Pw0jIM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6977

+Ying, who did a lot of work on NUMA balancing

On 9 Nov 2026, at 22:29, Yafang Shao wrote:

> Problem
> =======
>
> In our large fleet of Kubernetes-managed servers, NUMA balancing has
> historically been disabled globally on each server. With the growing
> deployment of multi-socket AMD EPYC servers, cross-NUMA access has become
> a critical performance issue, which led us to reconsider enabling NUMA
> balancing.
>
> kernel.numa_balancing is a single system-wide sysctl. Latency-sensitive
> workloads want NUMA balancing disabled, while NUMA-aware workloads want it
> enabled. No single global setting serves both.
>
> Design
> ======
>
> Core structure
> ~~~~~~~~~~~~~~
>
> This series follows Tejun's suggestion to store the existing NUMA
> balancing mode bits in the cgroup's memcg and expose them through BPF
> kfuncs.
>
> A new field, mem_cgroup::numab_mode, holds the per-cgroup NUMA balancing
> setting. Two kfuncs are added to set and read it:
>
>   bpf_numab_set_mode(): set the mode for a specific memory cgroup. The
>                         update is rejected with -EOPNOTSUPP if the cgroup
>                         has no visible, online memcg. Valid
>                         values are the NUMAB_* mode enum and
>                         NUMAB_FOLLOW_SYSTEM (-1); NUMAB_FOLLOW_SYSTEM
>                         uses the global sysctl state.
>
>   bpf_numab_get_mode(): return the combined task-side request of the
>                         cgroup's effective memcg and of all its ancestors.
>                         NUMAB_FOLLOW_SYSTEM is returned when no request is
>                         present. A cgroup without a memcg resolves to its
>                         nearest ancestor memcg. The following section
>                         describes how the request is combined across the
>                         hierarchy.
>
> Both kfuncs are registered for BPF_PROG_TYPE_SYSCALL. bpf_numab_set_mode()
> is KF_SLEEPABLE because it takes the mode mutex and the jump-label locks;
> bpf_numab_get_mode() does not sleep. The mode values are exposed as a BTF
> enum, so a BPF program can use NUMAB_FOLLOW_SYSTEM and the NUMAB_* mode
> names without hardcoding private integers.
>
> Effective mode semantics
> ~~~~~~~~~~~~~~~~~~~~~~~~
>
> In the current implementation, a memory cgroup can be set to the
> following modes:
>
>   NUMAB_FOLLOW_SYSTEM (-1):   use the global sysctl state
>   NUMAB_DISABLED (0):         disabled
>   NUMAB_NORMAL (0x1):         normal mode
>   NUMAB_TIERING (0x2):        tiering mode
>   NUMAB_NORMAL_TIERING (0x3): normal mode plus memory tiering
>
> The diagrams below assume that each cgroup shown has its own memcg. A
> cgroup without one resolves to its nearest ancestor memcg, as described
> in Storage of numab_mode.
>
> Except for the sentinel and the opt-out described below, the effective
> mode is the OR of this memcg's mode and that of all its ancestors.
>
> - An opt-out wins for the task side and binds the subtree
>
>   A DISABLED mode anywhere in the cgroup's ancestry opts the cgroup's
>   tasks out entirely. Given:
>                      Pods (normal)
>                      /
>           Pod-A (disabled)
>           /           \
>    cgroup-A1(normal)   cgroup-A2(tiering)
>
>   The effective task-side mode for tasks(*) in cgroup-A1 and cgroup-A2
>   is:
>
>                      Pods (normal)
>                      /
>           Pod-A (disabled)
>           /           \
>    cgroup-A1(disabled)   cgroup-A2(disabled)
>
>   (*) The folio side is described below.
>
> - NUMAB_FOLLOW_SYSTEM is skipped
>
>   Given:
>
>                      Pods (normal)
>                      /
>           Pod-A (-1)
>           /           \
>    cgroup-A1(none)   cgroup-A2(none)
>
>   The effective mode for tasks in cgroup-A1 and cgroup-A2 is:
>
>                      Pods (normal)
>                      /
>           Pod-A (normal)
>           /           \
>    cgroup-A1(normal)   cgroup-A2(normal)
>
> - For all other modes, the effective value is the OR of this memcg's
>   mode and that of its ancestors
>
>   Given:
>
>                      Pods (normal)
>                      /
>           Pod-A (-1)
>           /           \
>    cgroup-A1(none)   cgroup-A2(tiering)
>
>   The effective mode for tasks in cgroup-A1 and cgroup-A2 is:
>
>                      Pods (normal)
>                      /
>           Pod-A (-1)
>           /           \
>    cgroup-A1(normal)   cgroup-A2(normal|tiering)
>
> - The rationale behind these semantics
>
>   The cgroup hierarchy semantics invoked here are those of resource
>   limits: an ancestor's limit binds every descendant. That is the right
>   semantics for limits: a limit partitions a shared, finite resource,
>   and what a descendant consumes comes out of its ancestors' pool, so an
>   ancestor's limit must bind every level below it.
>
>   A policy request is a different kind of control: it is a preference
>   about how the kernel should treat the workload, not a quantity drawn
>   from a parent's pool. Expressing it consumes nothing, so the limit
>   semantics does not carry over; the question is only how the preferences
>   of several levels should combine.
>
>   We chose the additive interpretation: a descendant may ask for more on
>   top of what its ancestors asked for, while an opt-out at any level
>   still wins: DISABLED anywhere in the ancestry caps the whole subtree.
>
> Task and folio keying
> ~~~~~~~~~~~~~~~~~~~~~
>
> The NUMA balancing knob is consulted at some callsites with only a folio
> and no task, and at others with only a task and no folio.
>
> - Task only
>
>   kernel/sched/fair.c: task_numa_fault()
>   kernel/sched/fair.c: update_scan_period()
>   kernel/sched/fair.c: migrate_degrades_locality()
>   kernel/sched/fair.c: exceed_llc_capacity()
>   kernel/sched/fair.c: get_pref_llc()
>   kernel/sched/fair.c: get_scan_cpumasks()
>
> - Task and folio
>
>   kernel/sched/fair.c: should_numa_migrate_memory()
>
> - Folio only
>
>   mm/memory-tiers.c: folio_use_access_time()
>   mm/mempolicy.c: folio_can_map_prot_numa()
>   mm/migrate.c: folio_migrate_flags()
>   mm/migrate.c: migrate_misplaced_folio_prepare()
>   mm/migrate.c: migrate_misplaced_folio()
>
> Therefore, the helpers are split by side:
>
>   folio_numab_effective_mode()
>   folio_numab_in_*_mode()
>   task_numab_enabled()
>   task_numab_get_modes()
>
> Another concern is how to handle callsites that have both a task and a
> folio. The following anchor resolves it. Both the user fault path and the
> kswapd demotion path reach folio_migrate_flags():
>
> kswapd demotion (no task):
>
>   kswapd
>   + shrink_folio_list
>     + demote_folio_list
>       + migrate_pages
>         + folio_migrate_flags
>           + folio_numab_in_tiering_mode
>
> Fault path (user task):
>
>   do_numa_page
>   + mpol_misplaced
>     + should_numa_migrate_memory(task-m, folio-n) (A)
>       + task or folio?
>   + migrate_misplaced_folio_prepare(folio-n)
>   + migrate_misplaced_folio(folio-n)
>     + migrate_pages
>       + folio_migrate_flags(folio-n) (B)
>         + folio_numab_in_tiering_mode
>
> folio_migrate_flags() must key on the folio, since kswapd has no task to
> consult. In the user fault path, both should_numa_migrate_memory() and
> folio_numab_in_tiering_mode() are called. Since both refer to the same
> folio in this context, keying on the folio at B but not at A would be
> inconsistent. The rule is therefore simple: if a folio is available, key
> on the folio; otherwise, key on the task. This also keeps the keying
> robust to future refactoring: if either folio-keyed function is ever
> reached by a kernel thread, the answer does not change.
>
> Storage of numab_mode
> ~~~~~~~~~~~~~~~~~~~~~
>
> Some cgroups do not have the memory controller enabled:
>
> Given:
>           Pods (+memory)
>           /
>        Pod-A ()
>         /
>       cgroup-A1 ()
>
> cgroup-A1 has no memcg. Given the task/folio split, where should the
> mode for such a cgroup live?
>
> - If the mode were stored in struct cgroup and setting it on cgroup-A1
>   were allowed, tasks in cgroup-A1 would use cgroup-A1's request while
>   its folios would use Pod-A's memcg request, which is inconsistent.
>
> - Storing the mode in struct mem_cgroup avoids that: cgroup-A1 cannot be
>   set, and both its tasks and its folios resolve to the same ancestor
>   memcg (Pod-A).
>
> For consistency, the mode is stored in mem_cgroup, setting it on a
> cgroup without the memory controller enabled is rejected with
> -EOPNOTSUPP, and both task and folio lookups resolve a cgroup without a
> memcg to its nearest ancestor memcg. A request is effective only while
> its memcg is visible and online. Disabling the memory controller or
> offlining the memcg clears the request, and lookups skip such a memcg, so
> a pinned memcg cannot keep applying a stale request. A re-enabled memcg
> starts transparent.
>
> Shared memory semantics
> ~~~~~~~~~~~~~~~~~~~~~~~
>
> With the mode stored in the memcg, the longstanding shared-memory
> problem in memcg has to be addressed for per-memcg NUMA balancing as
> well.
>
> Given:
>
>     cgroup-A     cgroup-B
>            \       | (charge)
>            Memory_shared_by_cgroup-A_and_cgroup-B
>
> A choice is required when the NUMA modes of cgroup-A and cgroup-B
> differ. Since the folio-side lookup starts at the folio's memcg, a task
> in cgroup-A operating on this shared memory uses cgroup-B's folio-side
> mode. If DISABLED were applied to memory, cgroup-B's DISABLED would
> prevent cgroup-A from promoting the shared page. We avoid that by making
> DISABLED task-side only.
>
> In our experience, NUMA balancing is mostly disabled to avoid the
> potential latency spikes it can cause. The intent of disabling it for
> cgroup-B is to avoid latency spikes for tasks in cgroup-B; it does not
> matter whether tasks in other cgroups perform NUMA balancing. We
> therefore disable the task side only, not the memory side: DISABLED
> applies to tasks, not to memory.
>
> Demotion is global reclaim, not a per-cgroup balancing request.
> DISABLED only opts the cgroup's tasks out of NUMA balancing; it must
> not become a memory-side reclaim veto, or a cgroup could keep cold
> pages in the fast tier, leaving less fast-tier capacity for other
> cgroups' hot pages and defeating promotion for those pages.
>
> So, in the end, DISABLED is a task-side property and does not gate
> memory-side operations.
>
> Shared fast tier
> ~~~~~~~~~~~~~~~~
>
> A promotion competes for capacity in the shared fast tier, but it
> cannot consume more memory than the cgroup may already consume: it moves
> the cgroup's own folios, within its own memory limit, from the slow tier
> to the fast tier. Each contributor's own limit bounds its footprint,
> but the fast tier is still a shared resource; demotion is the global
> release valve that keeps cold pages from occupying it indefinitely.
>
> So a child can still enable tiering mode if its ancestor has only set
> normal.
>
> Given:
>
>                      Pod (normal)
>                      /        \
>           cgroup-A (none)  cgroup-B (tiering)
>
> the effective mode is:
>
>                       Pod (normal)
>                      /        \
>           cgroup-A (normal)  cgroup-B (normal|tiering)
>
> What an ancestor cannot do now is cap only tiering while leaving normal
> balancing available below. If that targeted cap is wanted, the natural
> extension is a negative request: NO_TIERING would propagate down the
> tree like the positive requests and mask TIERING out of the effective
> mode. It would cap promotion, not demotion; demotion remains global
> reclaim. With:
>
>                   Pod (normal | no_tiering)
>                      /            \
>             cgroup-A (none)   cgroup-B (tiering)
>
> the effective modes would be:
>
>                       Pod (normal)
>                      /            \
>             cgroup-A (normal)  cgroup-B (normal)
>
> For this version, I would keep the modes minimal and add NO_TIERING as a
> follow-up once there is a real user for it.
>
> Cost
> ====
>
> On the task side, an ancestor can opt out the whole subtree with
> DISABLED, but cannot cap only tiering while leaving normal balancing
> available below. On the memory side there is no opt-out at all:
> DISABLED is task-side only, so a descendant's TIERING request is enough
> to enable promotion for its own memory, and promotion is the mode that
> consumes the shared fast tier.
>
> The per-cgroup override was measured with schbench, 384 workers, on a
> two-node 384-core machine. In that configuration, a cgroup mode put the
> cgroup at the throughput of the equivalent system-wide setting, within a
> fraction of a percent. This is a throughput measurement, not a
> microbenchmark of the scan path: while the static key is on, a folio
> lookup is O(cgroup depth), and callers that need more than one bit now
> share a single lookup. An effective-mode cache may be worthwhile for
> very deep hierarchies; that is left for follow-up measurements.
>
> Limitations
> ===========
>
> The mode is per-memcg, not per-task. A cgroup without its own memcg
> cannot be set; its tasks and folios resolve to the nearest ancestor
> memcg. If multiple tasks in a single cgroup need different modes, place
> them in separate child cgroups with the memory controller enabled.
>
> For threaded cgroups, the mode must be set on the nearest domain
> ancestor that has the memory controller enabled, because the memory
> controller is not threaded.
>
> Changelog
> =========
>
> RFC v3 -> RFC v4:
> - Store numab_mode in mem_cgroup instead of struct cgroup
> - Refine the commit log
>
> RFC v3: https://lwn.net/Articles/1101442/
>
> RFC v2 -> RFC v3:
> - Replace the struct_ops interface with two kfuncs, following Tejun's
>   suggestion.
> - Improve function naming and simplify the code (David)
>
> RFC v2: https://lwn.net/Articles/1099962/
>
> RFC v1 -> RFC v2:
> - v1 keyed the hook on the memory cgroup and temporarily embedded the
>   cgroup id into the struct_ops value, because cgroup struct_ops support
>   was still under development.
> - v2 attaches through the cgroup struct_ops support that has since landed
>   in bpf-next, keys the task side on the task's cgroup and the memory side
>   on the folio's memcg, and adds the memory-tiering mode alongside enable
>   and disable.
>
> RFC v1: https://lwn.net/Articles/1054030/
>
> Yafang Shao (4):
>   sched: add helpers for numa balancing
>   sched: sample NUMA balancing mode once per path
>   sched: add BPF-based per-cgroup NUMA balancing mode selection
>   selftests/bpf: add tests for the numab kfuncs
>
>  include/linux/memcontrol.h                    |   6 +
>  include/linux/sched/numa_balancing.h          | 144 +++++++++
>  init/Kconfig                                  |  23 ++
>  kernel/sched/bpf_numab.c                      | 261 +++++++++++++++++
>  kernel/sched/build_policy.c                   |   4 +
>  kernel/sched/fair.c                           |  99 +++++--
>  kernel/sched/sched.h                          |   1 -
>  mm/memcontrol.c                               |  14 +
>  mm/memory-tiers.c                             |   9 +-
>  mm/mempolicy.c                                |   9 +-
>  mm/migrate.c                                  |   9 +-
>  mm/vmscan.c                                   |   6 +-
>  tools/testing/selftests/bpf/config            |   2 +
>  .../selftests/bpf/prog_tests/bpf_numab.c      | 273 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bpf_numab.c |  32 ++
>  15 files changed, 844 insertions(+), 48 deletions(-)
>  create mode 100644 kernel/sched/bpf_numab.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab.c
>
> -- 
> 2.52.0


Best Regards,
Yan, Zi
