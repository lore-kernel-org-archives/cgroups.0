Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021088.outbound.protection.outlook.com [52.101.100.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5812620DE;
	Mon, 20 Jul 2026 01:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784511726; cv=fail; b=A7DsJTdZCq1sN3BiIWUQcN0GoRwpstckdjXDUijEf24FA0zMTfsSV3njtGtRoWiflbz1pGKt5cAZqWJlxB1tuJQ4H36lVt97V4tovlEvPh8/naPXvhivSp3TfWyg0Wrjb658kOZVTbyV38p39AnbdmEdhACWbbycd0KB6ha59KU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784511726; c=relaxed/simple;
	bh=4xWzVqKH0Jee4ArLIuJiHzJJ4KWj37wTT+lYhIUy1mY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RrJXiqvYAGN7rig1IBSgElZ0c+niRQyFTMQjfxJ7WL9QUkJV0xg9Et0XAhOotCvoVv6UHjOV265Q7FC+4mqJy4FpmSe1XnFUfc4KNngnRbnwhM361YcHkdEMjNQ2Hxq4g6Ox2ZU074i4y5+of3WM809syRoN4vktQmwrvEsAS8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.100.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HN+Jx2piuADR5R05MOnCMmWjODj52yS6x//cupUce52Xgi4K7tWbzYR56LZVgIAuhEkvsHSDp/I6mh6pLL+YDvURvzpznzzcFHws3UX+5A72F3nEH3X6X1Ceeidmvy7H0T+UtepEWKnSHWdhNEMXGYtH1Ni6vcmZPO6Mo93Rpe8dLwpa7n4PrkMkgdtZSIUJ3PO32k9BbTnNLrAtAWZ61l6ewpSBnxTYowsPGy/KYYOKp1txc8RMo3rHT6RRo4mUytpo1Mch83xTDRhbfaY9LRzcuflZoWYQzGMB39q3eik8HYfyBCLmbsamt1//hCTGvQIkKb2RsfqkSWkFl7uv3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=oZLJNwHQhk5EyQV4N9xbEtn1ssF3H0XMCxYKm7eIaeU=;
 b=TK6IZL388JZQ4G/yYe8gFo6BQMBydAZD7emelyUfbx972mYI8Ib8jUexSEIh6N3pBtTYOXiERWh3SqYxI9NqkyysXeNVqrO1mL50YyjmnKPsq06VOzMiOwoOKnqQKPtILa9iw3MD5S9HAjN6G4tb9sEviLVCeOz1qRW6W1D3yBt0sP3zrnWA5h3mm59hTrNSd4DYiz1PPY0S5/41mPBANuA/BPW/FKv2ejar7BjIZtqvrxfPgv2PixVqsJb4d1By621LOSjJxmzmoYBibvCXg7gqxN/k6a26DTOEB0/cURoRTfQCQiappf1hKeyfVAapHtevsy+D01+BB1tsWxDykg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by LOYP123MB2781.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:ed::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.16; Mon, 20 Jul
 2026 01:42:00 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 01:42:00 +0000
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
Subject: [PATCH v4] security: Expand task_setscheduler LSM hook
Date: Sun, 19 Jul 2026 21:41:56 -0400
Message-ID: <20260720014156.459386-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN1PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:408:e0::14) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|LOYP123MB2781:EE_
X-MS-Office365-Filtering-Correlation-Id: de9fdcf9-e770-48de-5180-08dee6001755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|5023799004|56012099006|10067099003|6133799003|3023799007|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	qIQdW4uHz6k/RxhRz63tfUoK7HNXppHILUZXSVluMofpjIy8IKJmSj2AUYwhcEtzYkkb/ooy8b4XGZ+u0FUvmW02KpAkJoD9lnbAP11jtqVLbWPGF/oq4ORXpmjw1ZhM8xMxwzON+2F5H+JOoUhUVpi8hF2yjwcpAHptcve/6/6Jo+/e4q+yMDh28eseMq7g9k2OSHGCgc6Gh82xkP6nMNiWAJLWI4SxB90b9Yc71Rce6eBRU4zeXiJ6WaYe2VUTC/1yFdDNgxGUWpYAUDFcrOPoTa0MQwcnD8h6sdfGj+dAWnS5bMy8vwNViQFelrG+fNCOldCr0WmvSGd3XD2cnfHrEeZqRDJhD82+Ch5nDgtiX+qzLQVzRjC3p31kMmBJ+iuyeskugwoAVklD/2L9RWCvwtVRboTTYck5aWpAhDwR7kDrDOFJN+hbw9p6IbAywQ8Kmi4nN25+B47bX0p3kkBj1ilxPG3f7dm2Hbkp/YzRCCNzK9YYdqM0sszDTqdTRYMP3WRROwLMgBpgoabwsJDPAFKOG/3vx5bVeBe44t6IGiK1CtcYgZJwzeZnyiHEGQWpclYmSFV6FqC/f3RQWG5RylyxBXjHLcO8D0D8zhVWpi3CYLkvi+f5EAxlJlOY2XN6Nwl1Sk9zPPOhToTxdW1z35mbNWjoSfUosHUWtIy2V2Ws5Hizt3puUfJryPn0QOPfRllphODnAB31e0h6GA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(5023799004)(56012099006)(10067099003)(6133799003)(3023799007)(18002099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KvzR1PE48UfAKBXnVKOBbnei0F/syYdM5kgHkLxjBc8qMF2Us05nwyLguU9r?=
 =?us-ascii?Q?M0DJcuMJX3N6hFCPCEBxpVU93oL8AFjKxoTR7ADDRwvGzIXAv5sgwa85AvjR?=
 =?us-ascii?Q?/BPqdKU40r+Pqvjo1Hsncd6/YwmSqEuA1Is4eE+0raSOS/2DLzpUu6C4uIGl?=
 =?us-ascii?Q?vcCOhUFsRrdirT3E1Zl7aorGQOgfkgb8/OL13rEyAqvMzfha8p4cIelUIbQE?=
 =?us-ascii?Q?hIOJl+YQU2Z0nHpK97e6hnSveEF/eFSDFTCpGRJZIMl8/fviDD22CHd/RXyP?=
 =?us-ascii?Q?KqRtfkDgjAtt5sOsMte2LZeaMZIF5N6JooSHZn2dWm95e+zqQ4IW38QkCEpG?=
 =?us-ascii?Q?wtP4GhlDtLfi4zAYdNF+g3/+UM4nqETlITdb/kFY2pFwGo2McNJsOoBBslBX?=
 =?us-ascii?Q?S2tCm06OwV7POYXBEKTe5px79wmX1Co86CuDlJcvTi6tEWQyf0gTXnZ9TWGA?=
 =?us-ascii?Q?qrk/IA+HFbtso7EB01qqGVBUYi1uvLFPn+lTKYg1gFcTH83pm5i6SvjBQPlu?=
 =?us-ascii?Q?8sSySoPFoJ11Xo9rmVQDN7rdJsQ/jyboZTCFPQHqElpcS3rAfXdoNgd09M2y?=
 =?us-ascii?Q?RW6vm45tTWj12bkSYfp0DOiLVRyCz8BtT1P6gZMoAk/nsVrCver55endlxs6?=
 =?us-ascii?Q?emv+aiy/+sDpWzJtAYdma63JD+gyc4Fy/Ln5eBJPgkjMpAaN9U2N5og+nkYd?=
 =?us-ascii?Q?THm206s0SNhzDbDbHmn8S1ZSx02z+0cSEAK8MkmwGlz5PamvvHXXBRU/KdWH?=
 =?us-ascii?Q?rXW+cOkr84poW88YtQivPF80attCsQlI7vspWLc2vrWcRadSq9Uy7zwgC11B?=
 =?us-ascii?Q?BE8DlEcOxlc+N1KAy+ktFnRBXFfoQ2qRe9xzRPwtDbisoS0Z5HfjRzxEkkV4?=
 =?us-ascii?Q?2YA+UDnO/83btz4ptgM79Foj82YM0qq/Q1Qc7tRsmehGYAdyCEzcHw4wUICw?=
 =?us-ascii?Q?p6ssct7yCtUczJvvTfkPDXGJVvKrFscCj1FBzVozTayZHOm+48Kc73xYF5ce?=
 =?us-ascii?Q?7U2rimmtrXyvLbQcrdU5V+iNlpz0wrW6hWnXgQN7xvYrqndTuynUGdAK63LV?=
 =?us-ascii?Q?aENxyyoe9BhcmK/xyoU5klKFHQNfaMs/SC/HjLCjRCajlqN9Rp2UN5nmkaLM?=
 =?us-ascii?Q?QI9rcYJBAlj+KlTzi4XlE4o5WGcDkpaGXoG1qI/kifQlqvGM+Rf3RSbGWaDu?=
 =?us-ascii?Q?VbBfGgZ9bAoE+wwMxDvp6cbGl6TiHGDa25ePwqSJIosSV7qVJTu4945sXRvu?=
 =?us-ascii?Q?MOIp6SUS2Kv5wXP71DBF6yUMUmVQLVG5POwfzZFc3/YBn7MaXUq91L5mDtvU?=
 =?us-ascii?Q?MgTmzo5btp1TCTz0OM25jTW2PBsUgiAO39Edv1cQZZd18Os0WocxNVcigp1/?=
 =?us-ascii?Q?8LabvY2lt6v9/OKhsK+9PqaqbmtFG21kA6QXhcrety6VZg/rK4wRMVcQapUh?=
 =?us-ascii?Q?QGXbzwU3fsD6Td6Qk2lClmO0lX5rvenDfaGeg5BNPKssGpR6zxPRMdECcfHD?=
 =?us-ascii?Q?Q0pSrmR97gj/RuBUNE43AbvIgu+QozvZNdHzhtuHLfbPVY+vBZ7SVmeXg3gf?=
 =?us-ascii?Q?9spGadQvYSv/Swu38sB7Jvyk7Nbt6cvvgjWWi+meELIa/7QFpRiehgullTYd?=
 =?us-ascii?Q?ZY5HJpH+97BlgS605oZsdakRTdtLINyxeEvF2Oob96YRPnMmP0f6Q1YVpY2Y?=
 =?us-ascii?Q?B3mYYxKK7Y7ftcW8/WaCzrBvzaNrYK/Gr1wUwg7jsBOYooPDlCi71OAOlKql?=
 =?us-ascii?Q?20z560UJRA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de9fdcf9-e770-48de-5180-08dee6001755
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 01:42:00.1725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFZCd6EKzm0Ob41S7LvfGhXH0VXid3iWH6mEsRu6GpV56Fj0uh2rUEar/SXTPFeyJ2K7SE/QwuCoIpPnu7afGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOYP123MB2781

At present, the task_setscheduler LSM hook provides security modules
with the opportunity to mediate changes to a task's scheduling policy by
inspecting the requested sched_attr. However, when invoked via
sched_setaffinity(), the hook lacks visibility into the actual CPU
affinity mask being requested. Consequently, security modules are
entirely blind to the target CPUs and cannot make granular access
control decisions based on spatial isolation.

In modern multi-tenant and real-time environments, CPU isolation is a
critical boundary. The inability to audit or restrict specific CPU
pinning requests limits the effectiveness of security policies,
particularly when attempting to shield isolated or cryptographic cores
from unprivileged or compromised tasks.

This patch expands the security_task_setscheduler() hook signature to
include a pointer to the requested cpumask alongside the existing
sched_attr. Because this is a shared hook used for multiple scheduling
attribute changes, call sites that do not modify CPU affinity are
updated to safely pass NULL for the mask. To protect against unverified
dereferences, the parameter is annotated with __nullable in the LSM hook
definition, ensuring the BPF verifier mandates explicit NULL checks for
attached eBPF programs.

Historically, SELinux has governed all scheduling alterations under a
single, monolithic PROCESS__SETSCHED access vector. However, by
inspecting fields such as attr->sched_policy or attr->sched_priority, a
security module can introduce granular access controls. For instance,
differentiating between standard time-sharing policies and
latency-sensitive real-time policies.

This change updates all in-tree security modules (SELinux and Smack) to
accommodate the new parameter mechanically, while providing LSMs with
the necessary context to enforce strict affinity policies.

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
Changes since v3:

 - Expanded the task_setscheduler LSM hook to accept the 'sched_attr'
   payload, enabling BPF and other LSMs to inspect scheduling attributes
   (Peter Zijlstra)

 - Updated all call sites for security_task_setscheduler() to correctly
   pass the attr structure when available, or NULL otherwise
   (Peter Zijlstra)

 - Added the necessary forward declaration for struct sched_attr to
   include/linux/security.h

 - Linked to v3: https://lore.kernel.org/lkml/20260526142838.774711-1-atomlin@atomlin.com/

Changes since v2:

 - Dropped patch 1. This is to be addressed by the cgroup cpuset
   maintainer (Waiman Long)

 - Dropped patch 3. Will be submitted as a separate patch (Paul Moore)

 - Linked to v2: https://lore.kernel.org/lkml/20260509213803.968464-1-atomlin@atomlin.com/

Changes since v1:

 - Reordered the allocation and user-copy of new_mask in the MIPS
   architecture's mipsmt_sys_sched_setaffinity() to occur before the
   LSM hook is invoked. This ensures the security modules evaluate a fully
   populated mask rather than uninitialised memory, while cleanly handling
   error unwinding

 - Updated cpuset_can_fork() to pass the destination cpuset's effective CPU
   mask instead of NULL

 - Linked to v1: https://lore.kernel.org/lkml/20260509164847.939294-1-atomlin@atomlin.com/

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 arch/mips/kernel/mips-mt-fpaff.c |  2 +-
 fs/proc/base.c                   |  2 +-
 include/linux/lsm_hook_defs.h    |  4 +++-
 include/linux/security.h         | 15 +++++++++++----
 kernel/cgroup/cpuset.c           |  4 ++--
 kernel/sched/syscalls.c          |  4 ++--
 security/commoncap.c             |  9 +++++++--
 security/security.c              | 14 +++++++++-----
 security/selinux/hooks.c         |  4 +++-
 security/smack/smack_lsm.c       | 13 +++++++++++--
 10 files changed, 50 insertions(+), 21 deletions(-)

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
index 780f81259052..b14401030e5c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2589,7 +2589,7 @@ static ssize_t timerslack_ns_write(struct file *file, const char __user *buf,
 		}
 		rcu_read_unlock();
 
-		err = security_task_setscheduler(p);
+		err = security_task_setscheduler(p, NULL, NULL);
 		if (err) {
 			count = err;
 			goto out;
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 65c9609ec207..80ca02879620 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -255,7 +255,9 @@ LSM_HOOK(int, 0, task_prlimit, const struct cred *cred,
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
index 153e9043058f..82dfe4e3f8d1 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -82,6 +82,7 @@ struct ctl_table;
 struct audit_krule;
 struct user_namespace;
 struct timezone;
+struct sched_attr;
 
 enum lsm_event {
 	LSM_POLICY_CHANGE,
@@ -196,7 +197,9 @@ extern int cap_mmap_addr(unsigned long addr);
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
@@ -531,7 +534,9 @@ int security_task_prlimit(const struct cred *cred, const struct cred *tcred,
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
@@ -1393,9 +1398,11 @@ static inline int security_task_setrlimit(struct task_struct *p,
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
index 45944b3e31ca..6ab47cf5582b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3042,7 +3042,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 			goto out_unlock;
 
 		if (setsched_check) {
-			ret = security_task_setscheduler(task);
+			ret = security_task_setscheduler(task, NULL, cs->effective_cpus);
 			if (ret)
 				goto out_unlock;
 		}
@@ -3600,7 +3600,7 @@ static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
 	if (ret)
 		goto out_unlock;
 
-	ret = security_task_setscheduler(task);
+	ret = security_task_setscheduler(task, NULL, cs->effective_cpus);
 	if (ret)
 		goto out_unlock;
 
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index b215b0ead9a6..86490035e815 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -540,7 +540,7 @@ int __sched_setscheduler(struct task_struct *p,
 		if (attr->sched_flags & SCHED_FLAG_SUGOV)
 			return -EINVAL;
 
-		retval = security_task_setscheduler(p);
+		retval = security_task_setscheduler(p, attr, NULL);
 		if (retval)
 			return retval;
 	}
@@ -1213,7 +1213,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 			return -EPERM;
 	}
 
-	retval = security_task_setscheduler(p);
+	retval = security_task_setscheduler(p, NULL, in_mask);
 	if (retval)
 		return retval;
 
diff --git a/security/commoncap.c b/security/commoncap.c
index 3399535808fe..d83eee0459fe 100644
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
index 71aea8fdf014..a6725dddc34f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -3240,17 +3240,21 @@ int security_task_setrlimit(struct task_struct *p, unsigned int resource,
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
index 8d6945edae7a..d77a8d5c364c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4559,7 +4559,9 @@ static int selinux_task_setrlimit(struct task_struct *p, unsigned int resource,
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
index ff115068c5c0..cf28ccc28b80 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2338,10 +2338,19 @@ static int smack_task_getioprio(struct task_struct *p)
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
2.54.0

