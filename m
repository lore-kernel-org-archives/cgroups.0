Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.100.83
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795061249;
	b=ccnF/ZyYgN9/93GPmpDLfpyq6BQFizMqLf0ypau1uPwqnp7wZBC8EkkfN3KoaScaQ0vw
	 HlkD1vET+28/HiygLctQzLl9Hi5UczYlC8kVRjVNxs3CYEZL/8pU8Lecl/6efZsPfIEav
	 BHP4uyQxr68aiMl6xzY94kuvUfBuchdeOzq3SN6o0Hkd6nIGeCAWCiTLdbrjyQJfh3PtT
	 2irDwxNMSDrICdHTfFQAQmJJgISjon/3cMpixb39ankP7XJayuesJdKOruIaZ3YFqu8TE
	 jUxEIdjrP/QZbZ1Fj2jI4ZMHgt1u13w38PxN9HslsauO23WV7bng3mUVkURqiI7IBhw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061249;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
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
	bh=v1YQmYrtQN03py1+huoTf75RYVuK2/mjH8luBCGttSk=;
	b=FmMrKj6enIOVWhYLrBfulOsG2thKR9KZBUusuPjKfx/nr96xWkILlj72s+vA6v3jJoLe
	 MaP9rDNjqex0AQDlhv7nyZ4mAHoBS5eUqszcCichbnZzleS+1a7bypt2vY42XfVOwK09G
	 x/vshtpDH70ww82SsL5drROYYho3Qzug79ZiiyVLFwkSsjKQlfvwHXBMy2Ila/sVX6/IK
	 oI4cDtLRCB/zi6VYP780W24AM2AJHpq8rAHHDUirgOMw5NKMq6mAptnYwLhjACircQng8
	 pvBWzvTvvlumRyIzdsH1qwgiHF1ZEOBhu9m7cOZP0EwtyCqq1M50wOh35wyayNuEJKA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=atomlin.com;
	spf=pass smtp.mailfrom=atomlin.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.100.83
Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021083.outbound.protection.outlook.com [52.101.100.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57958606A331;
	Thu, 19 Nov 2026 04:07:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57958606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KbHt4RY4t8AiJ++uBdCyqqf1nK8Kt3ZP9sKQFCSJy8Gax65wsYZ7+mwcXFo8/X7V9eG0sC+2RVc6ZFlrCsnL1pLyhIO7IP/dtUuS31AYHUEe2MTYQiWlWWR0Dz5Dhu3xQE8y8DhMtbJWAtdZFLy1wGfPdIeKlKg61k2B9N5kvTdHkAni1HVddDbJSCMKPh/5G+Ic83xUOvkj22c+uMTFwPpjs1ciknSpr6uZoXhlJ+09U30YA0cTNsl1Kt0sk7O6IafcNrBk/SrGAjqs3j2KM4YKXFdJpVxPj4ml0ODAaGanLc649M8roTwoY03TX2NruqBurbTKr7lg5XHGAseh0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=v1YQmYrtQN03py1+huoTf75RYVuK2/mjH8luBCGttSk=;
 b=iVZMVfhMMU66MHud6APwSUhbEEBeBWx/y7EcfVwa05072kox3BROJH6yQs1pArSwVmHg1LJUM1ULbHnX7wJynFrOChyyLMyfa89aNhrj2doUCw6JKM6F5tr3O3kLLBUJaXm6wXCD8GvVQ/FmbJ98eVA/jyGy1gLPErM5JXNRnDrEY6aTxsEjMTy3dsSRMYDbZbvV/y4CmMFUg7Ffqk3UvDzqbZTDh+bEmXmcYY0pc6DoFkAVToLop6WtYb7SN65vJjzRN9v955Br195gBSRGHdh+Gm/BgVkMApbK8j8CDuxURNzrlZbEaI26n3BOgHNht+sXt5FgIiGU7Ku7AFFZUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:b1::11)
 by LO9P123MB7808.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:3e7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 04:07:24 +0000
Received: from CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM
 ([fe80::beaf:db0b:23fd:822a]) by CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM
 ([fe80::beaf:db0b:23fd:822a%4]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 04:07:24 +0000
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
Subject: [PATCH v6 1/2] security: Expand task_setscheduler LSM hook
Date: Wed, 18 Nov 2026 23:07:04 -0500
Message-ID: <20261119040705.684987-2-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119040705.684987-1-atomlin@atomlin.com>
References: <20261119040705.684987-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0983.namprd03.prod.outlook.com
 (2603:10b6:408:109::28) To CWLP123MB4179.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:be::14)
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
X-MS-TrafficTypeDiagnostic: CWXP123MB4183:EE_|LO9P123MB7808:EE_
X-MS-Office365-Filtering-Correlation-Id: 771dcdce-09ed-4267-2b1a-08df45f29db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|6133799003|22082099003|261009223027099003|18002099003|3023799007|921020|261021135927099003|56012099006|261026121527099003|261102125427099003|261102123227099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|261022113327099003|261021123027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	D9uUPaqATU0rxddw/ZNh8DzcffwK6bmaVXbMoE4gdBCLyJNtiZnmWPi/a06BsJONzZ8H+ngvhclhCC6lItvRqmRpeyv+SjGv6JDTZPn5lnbvdOefbWfqR4S0SdS64PXcZdI0qBPsTRUB34rm/76T5KTSz7jbL/bNLM2o3SSw2Kw37TUkKC2a9g4llQxMq031jkRCvmIH+qXgy+a7s+rSBQZ1ikZAuzjZrUGs9HcIDtr3THMNecu4folPyyyMQNpoWlN0MG3swVg9X82vR2sprawkKbHh8XK8VsOnOSeSpQmo57QTTclju8uBP5y/I3LsBVjT6glEoJ0GCDTlyZ8GbXLzVD10MU/JrQTWFXAmFKlMZ/PvintRLnhnVGqm++MtmMWswaNqY26mDoSsSmip32DEhd6hpB2YoVMNUSRUFnb8JaMAUltWlCHT65n8cst7yCVqH27gTu6hv3oUNPi1dXQ5XHHzpaixiIqgNjoj5p0K7tF+PLM90WDtdaeQnlsiorFNtUAVgRlUGGyVcFtS5AneM0klJG6LAeMNSZVVM57TD9zCIAEtftaapWcNILYtNOBgIJBNcAb1Xv642KDzq11j693E2xEgWtmjzh9FJG/0jvPrBA1DuELDPmRq2IIOjGIis+Zs/A978d8HMdIL4MFaizZdwsZ7OrmWZtQvHENRJESn05/Rht5cJ1fgyDGJ2nOgcCM1k1qOPCAJygYtIg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(6133799003)(22082099003)(261009223027099003)(18002099003)(3023799007)(921020)(261021135927099003)(56012099006)(261026121527099003)(261102125427099003)(261102123227099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(261022113327099003)(261021123027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N0z20XtYLJtc8C7oDRWTj5iDMauiiM96QOl8+mEAFTAOIWntjDT+jt0RFryh?=
 =?us-ascii?Q?bDQdJjs9XLCCbB9DEgws+IIhsANAoYEsYLuec+cFWrM8lcEFI1YCxocTNzbk?=
 =?us-ascii?Q?ax5x/rrMaTcYoY8h4Va1iHStJSMByHiEYuNao6h0uMq8j31HHLLIauUAB6Rm?=
 =?us-ascii?Q?SKzrCwfW/7/MXU4WdJXBsDBL9fTtSCBZQADR3k9i5NmQDeLaNd7F2uGGXY16?=
 =?us-ascii?Q?cHpsR5Dz4M9nm/aR7kuHcr1OaSa0d4sAmC5mayA9QQedOLY9vBbebI40ebTO?=
 =?us-ascii?Q?KKJZZjBK0tDp9bZpJOYYwrFmOrTvTFWKbDeOrpKOsicVdxC/6jHFfJnAFr5Q?=
 =?us-ascii?Q?YZMb9ePhKNUHykXy7iEseN4bqBdU8mo7d8F54kwJUsIsA6Gcmv1+6jZsiMxN?=
 =?us-ascii?Q?s7xFvyEYakyTKmqnTdsrXPcxrXh5gald11qJ3CViQHW0RH8lhBwsRFyNf1QR?=
 =?us-ascii?Q?lYF+3s6lLslEHipBofmlExay00yJv5Y4kjdF7hOQNfhjByim6YkxOFvVaLG7?=
 =?us-ascii?Q?2S0hbmPJCx0iVAujALjdx1rhRqAoJ4rhx0BEvdJVH3mdZ8SAyd2TDd4JLJBs?=
 =?us-ascii?Q?+yoGwbSNkBVFCPSFFSiLvFS16bY46IKsFhfHCZqlo5Nq9/LOv580DcsCA6l2?=
 =?us-ascii?Q?U7uyz3kD+g/Wpg3tFHW9eDHzTZi4GFqlYlGnmKFwTyw6tuPUMpsDXxZf0la6?=
 =?us-ascii?Q?HVEWSmRUfaDezJ0BnPBcDzBab2QxeyRzM3osKGrl1s2KsRS0OEnDumVv19yG?=
 =?us-ascii?Q?ATye7KGTFzx7mSoDrITnpjkBGwsruBlir5nixWOk9JsjD4mDlkNeXLQh/47+?=
 =?us-ascii?Q?Fh3iG5MnWwbLqvdSUCPrUFKTdT8dJYsAFjRveOZIEipZd0QZN719jbna5XQo?=
 =?us-ascii?Q?7Ji1N1PwfwTbOmJXZ8JOXU0dwL+HRaU1KnPb6xj4gradg+Z4R7lp48NIH8mT?=
 =?us-ascii?Q?BPDbEbUh5U23on3j9ywQJC9mEQdqvchxtiaa0KBN9JkGdlqsDFMJGssIs6RW?=
 =?us-ascii?Q?IDHvmKNuIFkoGodPplnDAyJNRcNKMnWZzffeTFJRnhF2Q/34Mf/DHhhfV6ii?=
 =?us-ascii?Q?luyYPFwQGHM7w0PCWPkcuMZuaF3aUV+5QZzMD6IIVf29A6aaNAYBRwLtJkFd?=
 =?us-ascii?Q?QmfC40LhXcdPRBBJGz7L2dpx7ntKJr9QCBzxAN0W2PYVf+2V5srxxNbXZCgg?=
 =?us-ascii?Q?0Xn+k1lwzoM5N8KlnJCdDyWhDLS9aUm0Mpq8h4YMJaki3fdyZtjJZUfA59wg?=
 =?us-ascii?Q?8XNUXHUphsfuJEBtb9v4JFOHFGYeHKaI1SSsqp4YdQuYq60tyzvOiOguK5vO?=
 =?us-ascii?Q?lHlx5pcJnS5RHaAakaujvbFUMkiwbG8h8eO1423oR0ZvXFbkFYIeOBx+j2yH?=
 =?us-ascii?Q?TGSJACMkY8r/sdkHH51Lz+VuaB1b99O8RfBbnBNifFRQrvhiNbv3zgZoMFmJ?=
 =?us-ascii?Q?NU72E7A2pkDxu9N9SYaYFOjowFY1lEIaJX1EA/jYoWZd9NUMuNPP3vUULpVj?=
 =?us-ascii?Q?wGdUHU5dsoNV5a3LpULRiG5ycCR75Yp1VAv0nGKVuB2pQKXZ0ZHXarlUJepP?=
 =?us-ascii?Q?e5OxqvVrewdFkdhOjN0ZRPBG2Ph291DgV2ofUSvySJjAXfOQKwnKk6f2xq+/?=
 =?us-ascii?Q?JFqbYpyrb0K6jQ/CeLkC5AdY6JkWab0UydABXxZiIdE4WPeYDzWSXzgDNotA?=
 =?us-ascii?Q?+3sp6w8zREz9Jp49oJFRRcMOtdoruVG7YVzPXyU6lK1cuMVz78oScvL87QTj?=
 =?us-ascii?Q?Ogc5eoQ5Ng=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 771dcdce-09ed-4267-2b1a-08df45f29db1
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB4179.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 04:07:24.2896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sfh1s2xdYFOFMXe1XPP976vHDwrKkN7sLMhE/oGMGTmAzcQZ6MPyDdxnQGNfSVhI8W4KHDf93e1nDDy7De4z6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO9P123MB7808

At present, the task_setscheduler LSM hook only accepts the target
task_struct pointer. It lacks visibility into the requested scheduling
attributes (sched_attr) and the CPU affinity or cpuset mask (cpumask).
Consequently, security modules cannot inspect the target scheduling
parameters or CPU mask passed through the hook.

For CPU affinity requests via sched_setaffinity(), auditing or
filtering the raw mask requested by userspace requires inspecting the
mask before __sched_setaffinity() intersects it with the task's allowed
cpuset CPUs. Seccomp filters cannot perform this inspection because the
affinity mask and scheduling attribute structures are passed behind
user pointers, and scheduler tracepoints only observe the effective
mask after intersection with the cpuset configuration.

This patch expands the security_task_setscheduler() hook signature to
include pointers to the requested sched_attr and cpumask alongside the
target task_struct. In __sched_setscheduler(), a local copy of
sched_attr is populated with the resolved scheduling policy and
effective SCHED_FLAG_RESET_ON_FORK state so that parameter-only updates
(such as sched_setparam() or sched_setattr() with
SCHED_FLAG_KEEP_POLICY) always pass the effective values to the hook
rather than internal sentinels or caller defaults. For
sched_setaffinity(), the user-requested affinity mask is passed, whilst
for cpuset migrations and CLONE_INTO_CGROUP the destination cpuset's
effective_cpus mask is passed. Note that direct writes to cpuset.cpus
update task affinity via cpuset_update_tasks_cpumask() without invoking
this hook. Call sites that do not provide scheduling attributes or a
CPU mask (such as /proc/[pid]/timerslack_ns writes) pass NULL for the
respective parameter. To protect against unverified dereferences, both
parameters are annotated with __nullable in the LSM hook definition,
ensuring the BPF verifier mandates explicit NULL checks for attached
eBPF programs.

This change updates all in-tree security modules (capabilities,
SELinux, and Smack) to accommodate the new parameters mechanically,
whilst providing LSMs such as the BPF LSM with visibility into and
mediation of explicit scheduling policy and parameter updates,
sched_setaffinity() requests, and cpuset task migrations.

Reviewed-by: Casey Schaufler <casey@schaufler-ca.com> # Smack
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 arch/mips/kernel/mips-mt-fpaff.c |  2 +-
 fs/proc/base.c                   |  2 +-
 include/linux/lsm_hook_defs.h    |  4 +++-
 include/linux/security.h         | 15 +++++++++++----
 kernel/cgroup/cpuset.c           |  4 ++--
 kernel/sched/syscalls.c          | 11 +++++++++--
 security/commoncap.c             |  9 +++++++--
 security/security.c              | 21 ++++++++++++++++-----
 security/selinux/hooks.c         |  4 +++-
 security/smack/smack_lsm.c       | 13 +++++++++++--
 10 files changed, 64 insertions(+), 21 deletions(-)

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
index 45a127deeadd..16c97553e5ff 100644
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
@@ -540,7 +542,12 @@ int __sched_setscheduler(struct task_struct *p,
 		if (attr->sched_flags & SCHED_FLAG_SUGOV)
 			return -EINVAL;
 
-		retval = security_task_setscheduler(p);
+		lsm_attr.sched_policy = policy;
+		if (reset_on_fork)
+			lsm_attr.sched_flags |= SCHED_FLAG_RESET_ON_FORK;
+		else
+			lsm_attr.sched_flags &= ~SCHED_FLAG_RESET_ON_FORK;
+		retval = security_task_setscheduler(p, &lsm_attr, NULL);
 		if (retval)
 			return retval;
 	}
@@ -1215,7 +1222,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 			return -EPERM;
 	}
 
-	retval = security_task_setscheduler(p);
+	retval = security_task_setscheduler(p, NULL, in_mask);
 	if (retval)
 		return retval;
 
diff --git a/security/commoncap.c b/security/commoncap.c
index d47ab3022343..7a9a5091d761 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -1222,13 +1222,18 @@ static int cap_safe_nice(struct task_struct *p)
 /**
  * cap_task_setscheduler - Determine if scheduler policy change is permitted
  * @p: The task to affect
+ * @attr: Requested scheduling attributes (ignored)
+ * @in_mask: Requested CPU affinity or destination cpuset mask (ignored)
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
index f6583d507395..ebb06f1044e5 100644
--- a/security/security.c
+++ b/security/security.c
@@ -3261,17 +3261,28 @@ int security_task_setrlimit(struct task_struct *p, unsigned int resource,
 }
 
 /**
- * security_task_setscheduler() - Check if setting sched policy/param is allowed
+ * security_task_setscheduler() - Check if setting sched policy/param/affinity is allowed
  * @p: target task
+ * @attr: requested scheduling attributes, or NULL if not changing parameters
+ * @in_mask: user-requested CPU affinity mask for sched_setaffinity(), the
+ *           destination cpuset's effective_cpus mask for cpuset cgroup
+ *           migration and CLONE_INTO_CGROUP, or NULL otherwise
  *
- * Check permission before setting scheduling policy and/or parameters of
- * process @p.
+ * Check permission before setting the scheduling policy, parameters, and/or
+ * CPU affinity of process @p, or migrating/cloning @p into a cpuset. Note
+ * that during cpuset migration and CLONE_INTO_CGROUP, @in_mask reflects the
+ * destination cpuset's effective CPU configuration rather than a per-task
+ * pinning request, and may be passed even when the effective CPU mask itself
+ * does not change (for example, on cgroup v1 migrations or when only memory
+ * nodes change on cgroup v2).
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
index 28a8e12603ce..61574ee35c85 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2350,10 +2350,19 @@ static int smack_task_getioprio(struct task_struct *p)
 /**
  * smack_task_setscheduler - Smack check on setting scheduler
  * @p: the task object
+ * @attr: Requested scheduling attributes (ignored)
+ * @in_mask: Requested CPU affinity or destination cpuset mask (ignored)
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

