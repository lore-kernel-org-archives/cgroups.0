Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.101.109
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899342;
	b=1fpRVWOnH851Meb6vUOQjG8XUSx60F5ONL0zW8T8u2/fO2TpuK8ZY2onM9rnQYgaA32C
	 hG0RqBiHgveMGmaJEphTj847I/RuqqS3AnXBBS+MfxVjfVlvrrU3WI+c5AXHZEervzkr2
	 3Cz0HudF9cz038iCVV/sqrKArmGLq0+bzLq84pAk8/oqUarzMZX5tdMkB8wpqObG9oBQ4
	 iK4tP7zDjBmePBQlJBx5psF5lXaRgyGzJ1n43ElsAwUHGJAzxUIq3ubaCqveI0jjKUT/Z
	 ofV3e5w7z5vim44uQ7QAvRskqR8RH20XXKjNjWmoJleG9pULfUwYqTb8HgatvXP6+ow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899342;
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
	bh=Rc0wtIy/6o6xnqCrEec5zLi/2wTDYClsRFEZFtvgqJg=;
	b=V6nLj0Qs3rpiC5oy3N5/Vr1YF6eTzDr77z8yhrKn4ZdDaWNAVGQytBJ92h2bJnPb+ESh
	 w5ozSyi/ccTUicDjCWyQu8rJ+xkigTA0gKZG+ALbJrZJQXMQljlCGigUMM64Y1z28Lq1u
	 pACOUWP1y0J1ZXRitdoNqKeDzNFJ2v2506WTwJdZOfQ3R2J+2gcXpffalQa4dN+Da+/EE
	 OV7cdxzVKE1PlshPPMuhFTTlo10mCXBGVUlIVXqaUPD+/vAeje8H4smN4I9g+2uMQRHei
	 ypCfZ6xWb0CssLTfZ5QiT8pHZZx0iliuOY9bhSyzEhvYPUcH2FweMsBWaKDGcCfW94Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=atomlin.com;
	spf=pass smtp.mailfrom=atomlin.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.101.109
Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022109.outbound.protection.outlook.com [52.101.101.109])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C7B606A326;
	Thu,  5 Nov 2026 17:22:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37C7B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TY6qq1pawL8q4B6DNPGFHSbPgqCdGjXy/k/0mJT8189pcOM8p1b0cy4XyJA7kdFzMTV4Ag3nqvq1zyqBZKsStPlwuFN37tZm8mUbFRtZ8gyoqSGCbvUlVFaPPlvEERCGyj0SP2QIxQ7bwSUJtc2N72YuLHxIuyMlZ2Inuxmfrh8DqvCWaMLC1+yvrNG4HfH3ATHXkXy581ejg/QVtphzBo69RKTPZvTFSiEAn6yJCtr/KVckNp9zNrCMvmmXWTPWz5tx4vvnldWnMcc1wfClfa7RyvNDpFdMmpw56Sy7XmCy1ED2qui/CCWRB0u5GFtYANhz4Jzmmu0SWwvC5sjOyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=Rc0wtIy/6o6xnqCrEec5zLi/2wTDYClsRFEZFtvgqJg=;
 b=jGJVXAOeTVsdXgX/qlPxDwqAxdSBx10EypmHTIzNrm6UKskJZyJJwtkG+Bb4r4/+vLWQvt/F07p9uH2e6FZulMzZRUdYnJq8e9jx0gLuirFa+hTntJfb5HgEIBTu/tW3uq0VfjKPgU7g4vS1vBYi3vRW3vLQC/4EKBDHZlXvxebRjvqjttdJtCY41Q9N1s20OUQYviq99mKm8jTzqhNYM6mHUOxJImgSKB74z3KQ4gWUZEiUxTpkuPs0rVFBAGAhCnTsjYcNM+vGVa6uvq1ufLh7ZpcTw00cyK7OF6QH8kZgBboEPcb1lvl25Z9rupzXzrjYyIHiEfDQcCGos4SGLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:163::8)
 by LO8P123MB624071.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:80a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 17:22:17 +0000
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a]) by LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 17:22:16 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: tsbogend@alpha.franken.de,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
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
Cc: chenridong@huaweicloud.com,
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v5] security: Expand task_setscheduler LSM hook
Date: Thu,  5 Nov 2026 12:22:10 -0500
Message-ID: <20261105172210.76706-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0155.namprd04.prod.outlook.com
 (2603:10b6:806:125::10) To LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: LO2P123MB4190:EE_|LO8P123MB624071:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a1fd20a-ce0e-438a-8a4e-08df3b6156bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|6133799003|18002099003|3023799007|921020|261021135927099003|261022113327099003|261022075727099003|10067099003|5023799004|261102123227099003|261026121527099003|261028144727099003|261102125427099003|261026140227099003|261021123027099003|56012099006|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	p6cVRD6oQbJfSYHJ84c19uqR4HdVFccpCXRWeMA7OnsrQiaziYPW1NwMUhtvXZaCsfgEsrb8hPcnOJUBx+xc4F5VYE328WXFi1CJplvZlOn/eBCKIS6rRFiNEyzMns/7qznweLBnLe0pe17j8jMYBU0pP+/FrUJWX80JSpJbz5rT0x3ypuUhUr8B/kznDQ9sPibClXlw3Nmdfa2WBm67drKpPh73ErArVhK7NbFndwt8CVWpsvEuNqr8d94+DZUCCxQ55nZ397Hu9kuW3JX4g+06CSyW/UTm0sH9+Y8Bg6++ZWoJbr0lmisMu8NAwvjRBUTOXAAUqHba3jLJg0LqRryENVOH/nmJiQ8WOM0A1m3uTIlU+WrTw0EZbHCT/x7pPdRMED7KG7DSYEJ/qCSqzgANcy5PehtqMh8wPCd/bb0fQlj2Pwz+5CmtZKr2KCaG+zqVBiw9PaO64iUhuep97DdbNInD+o+x1/8jJcOndaSvh7R8WZHKibJSIFTuhl9IWktkZGRmLYRX2Db4DqXixVurSk/8bdQzu5cYqnZUbR8mLfl5+cx4hdoU/U7cEm90KXlZRN3WXvncBq25UZXSJXyUdjCvLh/qJWMMgux5S++OrWQJRLS2xhHPny3CiZZyES5PF25mePeVMSs3htkTyJj5f97d/yVonpdAst5lZ7g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(6133799003)(18002099003)(3023799007)(921020)(261021135927099003)(261022113327099003)(261022075727099003)(10067099003)(5023799004)(261102123227099003)(261026121527099003)(261028144727099003)(261102125427099003)(261026140227099003)(261021123027099003)(56012099006)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S+3HrkW5uaJokgM0nAddV8bX6nLj6+f2f+oZvJGeu90lIk5E7EQB+gWZEZUx?=
 =?us-ascii?Q?0tDxF59g6p7Gyb880e/if5HYil4LkUA9yjjVSXB+R7zUiKGZgTwFpb/Erfjh?=
 =?us-ascii?Q?rSufmIhNB04WddAPORJzHhsyhNukwFX0WWA3hD5EnadZRC78Qyi/u1pvcuoj?=
 =?us-ascii?Q?A9p53hRn1W/vDcIbaUzExrmBFczhd0NFHF4g1znKUNa+ije3uukGIgblIqTm?=
 =?us-ascii?Q?HMElXaDquY7z7BJ5JeVNEiw7qmd2S7LBxlhqtQb4va7nULcbG27LNR3yJgGr?=
 =?us-ascii?Q?MgZJKxofZW7DuXGN862SS6q6mheGa81bqT1BINh64w37oPZdW+VgMMu4IIES?=
 =?us-ascii?Q?k1DZTlFVz1oAmEh41WgjMche4uwpk96IYkG5P+9/n+QI7e19NWhCzQO5RVol?=
 =?us-ascii?Q?eGyaonFPnZoxsE7QpRHPU4m3iNgogB3HKntk8gFyBPlOh13FXLReztAmjckr?=
 =?us-ascii?Q?G8kXWR//KVic8Q4AwgAihpqGYFLzsRaCBmQ/iwo8hG6yk4VX3sRi5qMap07Z?=
 =?us-ascii?Q?n9WmpNHpYoDr1inkrjlwnBprCsGNMBiYD5Zb2xp449oqVinTwZSuR1Z8b2IZ?=
 =?us-ascii?Q?D9EeD6QwgT8lResM7T/dNmghctA43sORcB22LtOz/53T+f3QXDzQjmTkHQ8O?=
 =?us-ascii?Q?PpJdX44EBOw2C6UWaWoeeZNUr2Qk5kW2DICV2UmmwwshjSHeEZ9tAXxElXxP?=
 =?us-ascii?Q?sYsRD8k66qLjJMIngIPQQUXsT6Lzm8MiyOQSA0EuTRSel4LTtVpDkTzWGDLG?=
 =?us-ascii?Q?lzID2r660qzD4qzw4WE2VWK1xIeV7tFdeBuAFdIcMLcn99I4hLL3y8LXAQ1W?=
 =?us-ascii?Q?4DfTmo2ZDrdrF4HrdA6R2PifFVik1+XKquz4bqnj/gmXoBxGrhP4wMvQxaJw?=
 =?us-ascii?Q?L/sApPSK8XEaj4bsSL5Z5Yc0ip0pIgEYvngDu7qVhQGm0qfNqXLM8IvLc7wp?=
 =?us-ascii?Q?FC/yZEvEKHGKexldGHBXk6QOkk5utMAtlo8Ujs3HZP7p5SZ2i9+7o9kihEcz?=
 =?us-ascii?Q?fM8lYak2n/h5qTx4mVPPBoCWYo/NmraKvRW60dtRmyft2rVp7zzhRdfBLkqa?=
 =?us-ascii?Q?P1jGvCnh2epQtVLmf5nUIdOt844v2pmBoACDZBU/0ZddxFAleP5YLDNOF6i1?=
 =?us-ascii?Q?i3HTStG1+9DlI/ZYmh2Qal5rTh43fAXOc1t7sms5gsPc5w6lZjikIiqXK6LT?=
 =?us-ascii?Q?6QDwDUm5N6ySFvcaDaeqnbNs9W0jGYFRiftSxKdMa3FhSlr8HHF8bbgwFrxL?=
 =?us-ascii?Q?+s0rtDQuqAq9NG/R1JqTlaYBQPgxDztx0+EUGIM2mZsoD7F+qeC/D+8xtND1?=
 =?us-ascii?Q?aWl5WqKf1lenMyg+jYc9YdiIi5zceFJ44LXCD3V6epnnYdlP2uCbwFJA7eNj?=
 =?us-ascii?Q?5re/xkv2AXkxKcZ9LjluP4184R16UghWlzQy/HTY11odb7L1XYgjxKvxUekW?=
 =?us-ascii?Q?+8IToiQlqIN1/p44hInsTXC5KxCkBrx7K0v4U/zOqpg/LINWYiQYuYYQK2da?=
 =?us-ascii?Q?oEqlprOZ9YjQGwpPII0/1zgsiMSm8O38MoiYf5vbMA8jjlnFaQ65mFdzUVlM?=
 =?us-ascii?Q?kNjWQ6b6K/3Fmq13nKMTxp+ubPEKqbMbiUJfglNjrLPXLKjWW0Yrr31L1Umw?=
 =?us-ascii?Q?hQicYIVLPFVnbGUiplqGewEt/8hFsLfaxfMPs4XTGUTa4jF7dutXHanILfKP?=
 =?us-ascii?Q?q22vgMe/9HZAbo7t4L2rXaxPti+DEhvcFYsdeKTS8dS2JGgBArSB3YJZjM39?=
 =?us-ascii?Q?zloXGLwkBA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a1fd20a-ce0e-438a-8a4e-08df3b6156bb
X-MS-Exchange-CrossTenant-AuthSource: LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 17:22:16.5545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TM0htGxTfAIDOlfEhMZ+LxsnB1Jr1JhQA/ZLzP/ZcPw7i9tucRAJZGdPWwEuxU8sHWFt5jjEtXn+dg8eRAm05A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO8P123MB624071

At present, the task_setscheduler LSM hook only accepts the target
task_struct pointer. It lacks visibility into the requested scheduling
attributes (sched_attr) and the requested CPU affinity mask (cpumask).
Consequently, security modules are blind to both the target scheduling
parameters and target CPUs, preventing granular access control decisions
based on scheduling policy or spatial isolation.

In modern multi-tenant and real-time environments, CPU and scheduling
isolation are critical boundaries. The inability to audit or restrict
specific scheduling policy changes or CPU pinning requests limits the
effectiveness of security policies, particularly when attempting to
shield isolated or cryptographic cores from unprivileged or compromised
tasks.

This patch expands the security_task_setscheduler() hook signature to
include pointers to the requested sched_attr and cpumask alongside the
target task_struct. In __sched_setscheduler(), a local copy of
sched_attr is populated with the resolved scheduling policy so that
parameter-only updates (such as sched_setparam() or sched_setattr() with
SCHED_FLAG_KEEP_POLICY) always pass the effective scheduling policy to
the hook rather than an internal sentinel. Because this is a shared hook
used across multiple paths, call sites that do not modify scheduling
attributes or CPU affinity pass NULL for the respective parameter. To
protect against unverified dereferences, both parameters are annotated
with __nullable in the LSM hook definition, ensuring the BPF verifier
mandates explicit NULL checks for attached eBPF programs.

Historically, SELinux has governed all scheduling alterations under a
single, monolithic PROCESS__SETSCHED access vector. By inspecting fields
such as attr->sched_policy or attr->sched_priority, as well as the
requested cpumask, a security module can introduce granular access
controls, such as differentiating between standard time-sharing policies
and latency-sensitive real-time policies.

This change updates all in-tree security modules (capabilities, SELinux,
and Smack) to accommodate the new parameters mechanically, while
providing LSMs with the necessary context to enforce strict scheduling
and affinity policies.

Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
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
---
 arch/mips/kernel/mips-mt-fpaff.c |  2 +-
 fs/proc/base.c                   |  2 +-
 include/linux/lsm_hook_defs.h    |  4 +++-
 include/linux/security.h         | 15 +++++++++++----
 kernel/cgroup/cpuset.c           |  4 ++--
 kernel/sched/syscalls.c          |  7 +++++--
 security/commoncap.c             |  9 +++++++--
 security/security.c              | 14 +++++++++-----
 security/selinux/hooks.c         |  4 +++-
 security/smack/smack_lsm.c       | 13 +++++++++++--
 10 files changed, 53 insertions(+), 21 deletions(-)

diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
index 4fead87d2f43..c7a5d55cf7ca 100644
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -110,7 +110,7 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
 		goto out_unlock;
 	}
 
-	retval = security_task_setscheduler(p);
+	retval = security_task_setscheduler(p, NULL, new_mask);
 	if (retval)
 		goto out_unlock;
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index c9aebee0a338..d9a3c892586e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2596,7 +2596,7 @@ static ssize_t timerslack_ns_write(struct file *file, const char __user *buf,
 		}
 		rcu_read_unlock();
 
-		err = security_task_setscheduler(p);
+		err = security_task_setscheduler(p, NULL, NULL);
 		if (err) {
 			count = err;
 			goto out;
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 87d9d06710cb..411a5b977915 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -256,7 +256,9 @@ LSM_HOOK(int, 0, task_prlimit, const struct cred *cred,
 	 const struct cred *tcred, unsigned int flags)
 LSM_HOOK(int, 0, task_setrlimit, struct task_struct *p, unsigned int resource,
 	 struct rlimit *new_rlim)
-LSM_HOOK(int, 0, task_setscheduler, struct task_struct *p)
+LSM_HOOK(int, 0, task_setscheduler, struct task_struct *p,
+	 const struct sched_attr *attr__nullable,
+	 const struct cpumask *in_mask__nullable)
 LSM_HOOK(int, 0, task_getscheduler, struct task_struct *p)
 LSM_HOOK(int, 0, task_movememory, struct task_struct *p)
 LSM_HOOK(int, 0, task_kill, struct task_struct *p, struct kernel_siginfo *info,
diff --git a/include/linux/security.h b/include/linux/security.h
index 40831fab5470..b2c43e745447 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -84,6 +84,7 @@ struct audit_krule;
 struct ns_common;
 struct user_namespace;
 struct timezone;
+struct sched_attr;
 
 enum lsm_event {
 	LSM_POLICY_CHANGE,
@@ -198,7 +199,9 @@ extern int cap_mmap_addr(unsigned long addr);
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
-extern int cap_task_setscheduler(struct task_struct *p);
+extern int cap_task_setscheduler(struct task_struct *p,
+				 const struct sched_attr *attr,
+				 const struct cpumask *in_mask);
 extern int cap_task_setioprio(struct task_struct *p, int ioprio);
 extern int cap_task_setnice(struct task_struct *p, int nice);
 extern int cap_vm_enough_memory(struct mm_struct *mm, long pages);
@@ -537,7 +540,9 @@ int security_task_prlimit(const struct cred *cred, const struct cred *tcred,
 			  unsigned int flags);
 int security_task_setrlimit(struct task_struct *p, unsigned int resource,
 		struct rlimit *new_rlim);
-int security_task_setscheduler(struct task_struct *p);
+int security_task_setscheduler(struct task_struct *p,
+			       const struct sched_attr *attr,
+			       const struct cpumask *in_mask);
 int security_task_getscheduler(struct task_struct *p);
 int security_task_movememory(struct task_struct *p);
 int security_task_kill(struct task_struct *p, struct kernel_siginfo *info,
@@ -1408,9 +1413,11 @@ static inline int security_task_setrlimit(struct task_struct *p,
 	return 0;
 }
 
-static inline int security_task_setscheduler(struct task_struct *p)
+static inline int security_task_setscheduler(struct task_struct *p,
+					     const struct sched_attr *attr,
+					     const struct cpumask *in_mask)
 {
-	return cap_task_setscheduler(p);
+	return cap_task_setscheduler(p, attr, in_mask);
 }
 
 static inline int security_task_getscheduler(struct task_struct *p)
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3219f927c35e..d122de948572 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3267,7 +3267,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 			attach_ctx.old_cs = task_cs(task);
 
 		if (setsched_check) {
-			ret = security_task_setscheduler(task);
+			ret = security_task_setscheduler(task, NULL, cs->effective_cpus);
 			if (ret)
 				goto out_unlock;
 		}
@@ -3816,7 +3816,7 @@ static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
 	if (ret)
 		goto out_unlock;
 
-	ret = security_task_setscheduler(task);
+	ret = security_task_setscheduler(task, NULL, cs->effective_cpus);
 	if (ret)
 		goto out_unlock;
 
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 45a127deeadd..1b3f81e6e18e 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -533,6 +533,8 @@ int __sched_setscheduler(struct task_struct *p,
 		return -EINVAL;
 
 	if (user) {
+		struct sched_attr lsm_attr = *attr;
+
 		retval = user_check_sched_setscheduler(p, attr, policy, reset_on_fork);
 		if (retval)
 			return retval;
@@ -540,7 +542,8 @@ int __sched_setscheduler(struct task_struct *p,
 		if (attr->sched_flags & SCHED_FLAG_SUGOV)
 			return -EINVAL;
 
-		retval = security_task_setscheduler(p);
+		lsm_attr.sched_policy = policy;
+		retval = security_task_setscheduler(p, &lsm_attr, NULL);
 		if (retval)
 			return retval;
 	}
@@ -1215,7 +1218,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 			return -EPERM;
 	}
 
-	retval = security_task_setscheduler(p);
+	retval = security_task_setscheduler(p, NULL, in_mask);
 	if (retval)
 		return retval;
 
diff --git a/security/commoncap.c b/security/commoncap.c
index d47ab3022343..0c33f94a5707 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -1222,13 +1222,18 @@ static int cap_safe_nice(struct task_struct *p)
 /**
  * cap_task_setscheduler - Determine if scheduler policy change is permitted
  * @p: The task to affect
+ * @attr: Requested scheduling attributes (ignored)
+ * @in_mask: Requested CPU affinity mask (ignored)
  *
  * Determine if the requested scheduler policy change is permitted for the
- * specified task.
+ * specified task. The capabilities security module does not evaluate the
+ * @attr or @in_mask parameters, relying solely on cap_safe_nice().
  *
  * Return: 0 if permission is granted, -ve if denied.
  */
-int cap_task_setscheduler(struct task_struct *p)
+int cap_task_setscheduler(struct task_struct *p,
+			  const struct sched_attr *attr __always_unused,
+			  const struct cpumask *in_mask __always_unused)
 {
 	return cap_safe_nice(p);
 }
diff --git a/security/security.c b/security/security.c
index f6583d507395..9ca3438ef96a 100644
--- a/security/security.c
+++ b/security/security.c
@@ -3261,17 +3261,21 @@ int security_task_setrlimit(struct task_struct *p, unsigned int resource,
 }
 
 /**
- * security_task_setscheduler() - Check if setting sched policy/param is allowed
+ * security_task_setscheduler() - Check if setting sched policy/param/affinity is allowed
  * @p: target task
+ * @attr: requested scheduling attributes, or NULL if not changing parameters
+ * @in_mask: requested CPU affinity mask, or NULL if not changing affinity
  *
- * Check permission before setting scheduling policy and/or parameters of
- * process @p.
+ * Check permission before setting the scheduling policy, parameters, and/or
+ * CPU affinity of process @p.
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_task_setscheduler(struct task_struct *p)
+int security_task_setscheduler(struct task_struct *p,
+			       const struct sched_attr *attr,
+			       const struct cpumask *in_mask)
 {
-	return call_int_hook(task_setscheduler, p);
+	return call_int_hook(task_setscheduler, p, attr, in_mask);
 }
 
 /**
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6168dd5f91c2..4fc3e8c51035 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4690,7 +4690,9 @@ static int selinux_task_setrlimit(struct task_struct *p, unsigned int resource,
 	return 0;
 }
 
-static int selinux_task_setscheduler(struct task_struct *p)
+static int selinux_task_setscheduler(struct task_struct *p,
+				     const struct sched_attr *attr __always_unused,
+				     const struct cpumask *in_mask __always_unused)
 {
 	return avc_has_perm(current_sid(), task_sid_obj(p), SECCLASS_PROCESS,
 			    PROCESS__SETSCHED, NULL);
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 28a8e12603ce..a5f0de59dfc0 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2350,10 +2350,19 @@ static int smack_task_getioprio(struct task_struct *p)
 /**
  * smack_task_setscheduler - Smack check on setting scheduler
  * @p: the task object
+ * @attr: Requested scheduling attributes (ignored)
+ * @in_mask: Requested CPU affinity mask (ignored)
  *
- * Return 0 if read access is permitted
+ * Evaluate whether the current task has write access to the target task @p
+ * to change its scheduling policy. The Smack security module relies
+ * strictly on label-based access control and does not evaluate CPU
+ * affinity masks or scheduling attributes.
+ *
+ * Return: 0 if write access is permitted
  */
-static int smack_task_setscheduler(struct task_struct *p)
+static int smack_task_setscheduler(struct task_struct *p,
+				   const struct sched_attr *attr __always_unused,
+				   const struct cpumask *in_mask __always_unused)
 {
 	return smk_curacc_on_task(p, MAY_WRITE, __func__);
 }
-- 
2.55.0

