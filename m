Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012032.outbound.protection.outlook.com [40.93.195.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA94471D16;
	Wed, 30 Sep 2026 09:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758892; cv=fail; b=WMv7QEOk5MOk+a9HqrkH2tYPcXZ3q/MkLD/7sGdfLzp0YOoocKXypLi3GbG5SNnwjyibTkVX3egyxj1DKC+z11HT0bzbY0eWCOsouM3uyEAVQrFL2qi4twPsEEoCPZIbC/Z0X+bNOFstjzokZxYeR9Y0HDB6nA6bZaiJMQXVDzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758892; c=relaxed/simple;
	bh=GiBgMvDrCUmF7IiNULoqn6/30rKu2Z57X+3UfXJhMMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iTohidbLsbQbBXSHZCAoLrrEPNGFdbNQkXkDhJIMR65uiCGyNe8fssJsFTcNaVCrhIzu8dZgWlnBW9oBJJp66SO3m6i0pRo8+ICmUI70jtI9rLmJQfYjIezVl6zPs0RN6/LdUYPGtOvOGKNtMVKiPRy75n4v9oWG3GrRYbNEdnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lfMFqV2+; arc=fail smtp.client-ip=40.93.195.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lfMFqV2+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TjglnK+1bx+/tivVtdhj4yZ4U0xBnGt1A51GrQaj1oYkaCx57/mt1gCqhnaQioOVXWqK+ltcqNJplMg4mHVMFJQM12NjSEt6fsd11j940+qV5JbGl7g2zvjj4Y5F43Q277+lsfBdP9yAwLEh3VzauPLI78N09i+9b0RawyennnpbtNQratxAzepmDieccNGojRXFBcswI0mldblUolshn7Lg7b2DXiMcAv7YQU8aZ5uzn8HKCEbxwMgh6+4Vdivyue4oPvMM0EmS4BbC1iZU1VC+RGWtl/Tlfi+/UGIBAEFnOqv2zuOFretUIawcqzeZHt5bhb5yh9u49rQsbK3wfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6v2cP3bem3mPZfzGiuqFSexXdcTFZdB0skjBO47bghE=;
 b=L7Quthg55lgSolHqMJN91CG0OkgrcmsBsoq/35Xp4+lktBBkr5kyJl0gV/j0Y4IOjCl9aCuNuw1QXe8QYpDpvXlBHQRPXAYdNUwrGW5jyIErwz0iecB1q3CeGGXVxJekN6LilWyIxn6mv2VOJM5w4aiD39bUiEKI9mPrdQPTh1jhJ+6eHTC9A9ppqgR4e68MErIqq3xJ0GLVylkK9Ros7rhiNTRoH6FTNAF5QGI+An7BiPw7dpsWbdMqgrrkEh89U3s74BCIiXQNGqonwr7FphesB3ru36SxByanifGMgivZa8JrcSvZ0TIHV36Ru8qSXtA0e6V4iRd3LlMqkxTPAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6v2cP3bem3mPZfzGiuqFSexXdcTFZdB0skjBO47bghE=;
 b=lfMFqV2+8c6XcDTW4kbQOjJWIV4JYPNxDlzUhF8MoWoyrCv2SjvIsDztFAqjl3vJI8juzjikZ2O6imbkitZWTDTZppZRcopE2mb4pDRnQ6IidWl3AGOQBjb0aCSYqvLB+4rnneMbIk9YcE0Lj+yy1RyE1ffBmQEpyqS/H1uTyD17wrLQemgCDA3mNqhkbZ8+Owi69Y8l//xglskbMBczIfhMbpFCL3nelq+H3e94Zey78QsK8RbYsEsTb0vsUxakqYaL1RBgv4m8yRrCyad4NM5/PUZNLPOxjH7VYg9YfL8efsbn5iKZ3EZaIqRLZTac4ZmLEQxznAPWJ6wsmx15/A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by PH7PR12MB7817.namprd12.prod.outlook.com (2603:10b6:510:279::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Wed, 30 Sep
 2026 09:01:23 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 09:01:22 +0000
From: Andrea Righi <arighi@nvidia.com>
To: Tejun Heo <tj@kernel.org>,
	David Vernet <void@manifault.com>,
	Changwoo Min <changwoo@igalia.com>
Cc: Waiman Long <longman@redhat.com>,
	Michal Koutny <mkoutny@suse.com>,
	sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] selftests/sched_ext: Test scx_bpf_cgroup_nr_cpus()
Date: Wed, 30 Sep 2026 11:00:19 +0200
Message-ID: <20260930090049.1035813-3-arighi@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930090049.1035813-1-arighi@nvidia.com>
References: <20260930090049.1035813-1-arighi@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:510:2da::25) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|PH7PR12MB7817:EE_
X-MS-Office365-Filtering-Correlation-Id: fd851fa3-73e3-47a7-bae0-08df1ed1663b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|10067099003|11063799006|3023799007|6133799003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	XWqlREm2FaJCtRKEBHnPDphi+qUptlFihWjvByD62vYCiqJp6OR5ClzeA/Q9RpEuPJj9qXZdkrTJSI8ujAcvG98ObC7BqWfBV3HUM/ADE9eAQc6nxRU8DsFCdGK1NAzR9Btd3/qKgWX7qg7BGfVkvo7SDWZCbtQrU5mYR62mrBcDcAn0W6rAMuFw+T/GnF/nurVliaG7BIIr3PypXTjarYffzzRfd0jpO7cstJElWaBrQF91Zl1PJQ86GT9BihSU4SOv2dVah7lqqUPpcCrao8qwSKcWBtdlxQJYWlbG+q0tMZI5DQ3ztCWDdR4uXZAbpkVg46rIiM7prX7BQchfU/7yTeQ2HP2ZIr8xqcQ95jD5RlW5q9E8G7NRqKwsWhQMF4Bs6eQNCtbAbIu1+iM30vge/pv/udV3WUn9RqPL+kwM6fhQ46uTJRJLxzc/WMUHOxlgLEynrI+K5/se2ArtqNrBgC6lyShJ/0nkPU9CC3SCEAFmxPosFNpGKjkoMyZejsApOg8NPabqeca7y5hpf36T96OHJW+X4dDP8npRjBA2D382djg5E2zEjWMxhNdF7wEgTjemvOcf/Ux8Jcqj9bpX+e8HJbIn9AsdHlmAJPKC2Ob6AcWrcEH68RFdO2mYzYj472b8V0HH6/F79WsAhDJE7q2tqn2EmkhxcttF/gs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(10067099003)(11063799006)(3023799007)(6133799003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gXzdLPskmDE1laUowDEE8qLFHcKPablYVAod9xanXo+8S7eF5CEsfGOWorJD?=
 =?us-ascii?Q?ZZZqGSgdFbFTqkIHYjJB7+qtPnljv+aPeNAIFpCqaItBTafQXIuM15aMDhtF?=
 =?us-ascii?Q?NFPMcNZefSPF5pHixbPuYNmu1WVQj0aZFOXufAtUe+66AZoyZgFQXLVqmoqs?=
 =?us-ascii?Q?+d1eXjKxoXM9t+TDiD4G69Yw3AbvmY72Xjhb15aQ6Du4Ou8VG6K88dkAdsda?=
 =?us-ascii?Q?NHw6cew2jbfhSc1P570lKZhDcVsyLKa5d7dNkP3yWmgx/ccRUg2NhjSpWq4C?=
 =?us-ascii?Q?blnH7h6FYSMgqFGNacErXQGShaXZ7aveZg1mlEZrG5f9b6gVV67/wMYETr8A?=
 =?us-ascii?Q?ftXL36rGH4cwIkXWOxBKB195CvX4mxJvT3luA99CVH9BkbH6yTYF7uRwvsA4?=
 =?us-ascii?Q?4XZsLIQ8nvyfdo9/4uxwP32+yGLaIXaOwMZ3SijYZiYvLpywzSbUuULcP/2D?=
 =?us-ascii?Q?HL4NwhqPb37e9X7PErtJu31HdJvUictoEL1XGYetwpRV8RYl1GauJpav9Qp9?=
 =?us-ascii?Q?TqbP01IQlMp9yA7BuFxVqUnklMi2wYWQmIEW0xF7tjMFf1MUi5N/0ZU3C9Ch?=
 =?us-ascii?Q?quTleK++g6J8mOWufx6vbapaFKLX8UZSUuAqmu9OlET1bea3aRmeInZOKAyZ?=
 =?us-ascii?Q?0R4t7zlZyKe0wV2A6Wa2kYDua2dga9w063SIerQcw3AWOO74I+HlEv6uCUQQ?=
 =?us-ascii?Q?CrrgyY4p1vWA0BcqBdkVTMSA8WphhQT+sgO1UzLVZCBEqJn60GEkZvKe9dmD?=
 =?us-ascii?Q?ZzufmWn5FJdBqhvqz6H4G46wW9QQb7QQtWJ6XoiH10P7gNyYL/xOMMnijgCG?=
 =?us-ascii?Q?ABVTH+4H8ToNTWbCoDFcBurIaZgyL6yUu07F++wB5bmNwd0M1eiAa1NBDdqM?=
 =?us-ascii?Q?5ovsC5+izajRa+H+YN//rcQgqhtXvM8QLCDi1Cfs7e9GoXbBYud4z0Lz68Hk?=
 =?us-ascii?Q?ZtQltcemAoyUrMRL/rTlG+xckJnF6uvB85u6sY/yKe7Ltxhk2zjMUj8yxQVe?=
 =?us-ascii?Q?DNbEfY0EccsZTSjJ8zbJqMf3VEkS6xDkkTdef05PHXfQpME4WQehR2eiYIUn?=
 =?us-ascii?Q?9fXbu0n4nbwwAaqtkfkGHLAcBzrOrdtcWtsre90Q5fvK56WePYg5IF/eD7I1?=
 =?us-ascii?Q?2YvMCYdFKxwKIGnxyDmpIu1FePdrkm6laMrYyuwgKvBYuRWU6IAVSv+hKkxp?=
 =?us-ascii?Q?dWV32M+lFySP5S2z5WA/QjZmjZkx3e90U8JlpVLEpzZQ11CRTmiMpHB2JDne?=
 =?us-ascii?Q?BghQnKA6Er0Tzsh2Rvfe3NtimlNUBBobH83G/bKcz/Ds4dlH0pHLmqLmV7rc?=
 =?us-ascii?Q?FJ2gsUmC/H0CmZtovAB7DielFzbs3h2c+fwAL5pXLtHf7t5UWI5K9HbD6KuX?=
 =?us-ascii?Q?vkq5ezpR0HT8HfaxBx7cMopIH4XOeH6gAA4Fkc8PklZEXzxHm7mwDCI1Z/LB?=
 =?us-ascii?Q?A2fpYXFIMcE5KL0EuLm5VyspY3A/Npb04hjJD78cHFLgd5IOJ2n+R2NGqq/u?=
 =?us-ascii?Q?w0Fx0gbjSSCLKTS5LSxseCsDUaiJT051l2oJApT/g0pA0x5zpvGIJA7HIRdQ?=
 =?us-ascii?Q?Q0yzqGQD4syjqwq2UW4+o+ywgN1d2BCsJYaJeHv/LMd86y3gqnscNoXSLdsR?=
 =?us-ascii?Q?vF37KLrzWqEv9BQpMeNW06mD0MWQtad3pOkLVBAUhwVaoCmV3UN59WFo8ETq?=
 =?us-ascii?Q?ilbQyRw0jn6/m0F9IBXjcRlCImBkWlSZYLOk//BE/kWmabun1m6HAjWVViVY?=
 =?us-ascii?Q?fK8DJtEF0g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd851fa3-73e3-47a7-bae0-08df1ed1663b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 09:01:22.6319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kldQ5Hh/CUiCSLNQKG3IQFEd1Og0mcd0/PTW12Mu4hrfT8V4KJgFgOm4IxU0hyhWqpZYqFQhnBU/uGUb+LLhyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7817

Verify that scx_bpf_cgroup_nr_cpus() reports the number of CPUs in a
cgroup's effective cpuset.

Create a cgroup-v2 subtree where a child owns a cpuset and a leaf
inherits it. Sample the kfunc from a BPF_PROG_TYPE_SYSCALL program and
compare it with cpuset.cpus.effective for the root, the cpuset owner and
the inheriting leaf, without a scheduler attached. Attach a scheduler
and verify the value observed from ops.cgroup_init(). Then restrict the
child's cpuset to a non-contiguous and a single-CPU set, and finally
disable cpuset below the parent so that both cgroups inherit the
parent's cpuset.

A disabled cpuset css stays attached to its cgroup until it is
asynchronously offlined, so poll briefly for the last step. Skip the
test when the required controllers or two CPUs are unavailable.

Assisted-by: LLM
Signed-off-by: Andrea Righi <arighi@nvidia.com>
---
 tools/testing/selftests/sched_ext/Makefile    |   6 +-
 .../selftests/sched_ext/cgroup_nr_cpus.bpf.c  |  60 +++
 .../selftests/sched_ext/cgroup_nr_cpus.c      | 419 ++++++++++++++++++
 tools/testing/selftests/sched_ext/config      |   1 +
 4 files changed, 484 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/sched_ext/cgroup_nr_cpus.bpf.c
 create mode 100644 tools/testing/selftests/sched_ext/cgroup_nr_cpus.c

diff --git a/tools/testing/selftests/sched_ext/Makefile b/tools/testing/selftests/sched_ext/Makefile
index 286b510fd76e1..ff59c95b9b386 100644
--- a/tools/testing/selftests/sched_ext/Makefile
+++ b/tools/testing/selftests/sched_ext/Makefile
@@ -10,6 +10,7 @@ TEST_GEN_MODS_DIR := test_modules
 # override lib.mk's default rules
 OVERRIDE_TARGETS := 1
 include ../lib.mk
+include ../cgroup/lib/libcgroup.mk
 
 CURDIR := $(abspath .)
 REPOROOT := $(abspath ../../../..)
@@ -154,7 +155,7 @@ $(INCLUDE_DIR)/%.bpf.skel.h: $(SCXOBJ_DIR)/%.bpf.o $(INCLUDE_DIR)/vmlinux.h $(BP
 
 override define CLEAN
 	rm -rf $(OUTPUT_DIR)
-	rm -f $(TEST_GEN_PROGS)
+	rm -f $(TEST_GEN_PROGS) $(EXTRA_CLEAN)
 endef
 
 # Every testcase takes all of the BPF progs are dependencies by default. This
@@ -163,6 +164,7 @@ endef
 all_test_bpfprogs := $(foreach prog,$(wildcard *.bpf.c),$(INCLUDE_DIR)/$(patsubst %.c,%.skel.h,$(prog)))
 
 auto-test-targets :=			\
+	cgroup_nr_cpus			\
 	create_dsq			\
 	dequeue				\
 	dequeue_iter			\
@@ -216,7 +218,7 @@ $(testcase-targets): $(SCXOBJ_DIR)/%.o: %.c $(SCXOBJ_DIR)/runner.o $(all_test_bp
 $(SCXOBJ_DIR)/util.o: util.c | $(SCXOBJ_DIR)
 	$(CC) $(CFLAGS) -c $< -o $@
 
-$(OUTPUT)/runner: $(SCXOBJ_DIR)/runner.o $(SCXOBJ_DIR)/util.o $(BPFOBJ) $(testcase-targets)
+$(OUTPUT)/runner: $(SCXOBJ_DIR)/runner.o $(SCXOBJ_DIR)/util.o $(BPFOBJ) $(LIBCGROUP_O) $(testcase-targets)
 	@echo "$(testcase-targets)"
 	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
 
diff --git a/tools/testing/selftests/sched_ext/cgroup_nr_cpus.bpf.c b/tools/testing/selftests/sched_ext/cgroup_nr_cpus.bpf.c
new file mode 100644
index 0000000000000..841c83abb41bb
--- /dev/null
+++ b/tools/testing/selftests/sched_ext/cgroup_nr_cpus.bpf.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Validate scx_bpf_cgroup_nr_cpus() from both BPF_PROG_TYPE_SYSCALL and
+ * struct_ops contexts.
+ *
+ * Copyright (c) 2026 NVIDIA Corporation.
+ */
+
+#include <scx/common.bpf.h>
+
+char _license[] SEC("license") = "GPL";
+
+UEI_DEFINE(uei);
+
+/* input to cgroup_nr_cpus_read() */
+u64 query_cgid;
+/* output of cgroup_nr_cpus_read(), -1 if @query_cgid couldn't be resolved */
+s64 query_nr_cpus = -1;
+
+/* recorded by ops.cgroup_init() for @init_cgid */
+u64 init_cgid;
+s64 init_nr_cpus = -1;
+
+SEC("syscall")
+int cgroup_nr_cpus_read(void *ctx)
+{
+	struct cgroup *cgrp;
+
+	query_nr_cpus = -1;
+
+	cgrp = bpf_cgroup_from_id(query_cgid);
+	if (!cgrp)
+		return -ENOENT;
+
+	query_nr_cpus = scx_bpf_cgroup_nr_cpus(cgrp);
+	bpf_cgroup_release(cgrp);
+
+	return 0;
+}
+
+s32 BPF_STRUCT_OPS(cgroup_nr_cpus_cgroup_init, struct cgroup *cgrp,
+		   struct scx_cgroup_init_args *args)
+{
+	if (cgrp->kn->id == init_cgid)
+		init_nr_cpus = scx_bpf_cgroup_nr_cpus(cgrp);
+
+	return 0;
+}
+
+void BPF_STRUCT_OPS(cgroup_nr_cpus_exit, struct scx_exit_info *ei)
+{
+	UEI_RECORD(uei, ei);
+}
+
+SEC(".struct_ops.link")
+struct sched_ext_ops cgroup_nr_cpus_ops = {
+	.cgroup_init		= (void *)cgroup_nr_cpus_cgroup_init,
+	.exit			= (void *)cgroup_nr_cpus_exit,
+	.name			= "cgroup_nr_cpus",
+};
diff --git a/tools/testing/selftests/sched_ext/cgroup_nr_cpus.c b/tools/testing/selftests/sched_ext/cgroup_nr_cpus.c
new file mode 100644
index 0000000000000..4973f70803532
--- /dev/null
+++ b/tools/testing/selftests/sched_ext/cgroup_nr_cpus.c
@@ -0,0 +1,419 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Verify that scx_bpf_cgroup_nr_cpus() reports the number of CPUs in a
+ * cgroup's effective cpuset, including inherited and updated cpusets.
+ *
+ * Copyright (c) 2026 NVIDIA Corporation.
+ */
+
+#define _GNU_SOURCE
+#include <bpf/bpf.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/limits.h>
+#include <scx/common.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "cgroup_nr_cpus.bpf.skel.h"
+#include "cgroup_util.h"
+#include "scx_test.h"
+
+/*
+ * Hierarchy under the cgroup2 root, all with the cpu controller enabled so
+ * that ops.cgroup_init() runs for each of them:
+ *
+ *   parent		cpuset enabled by the root, enables cpuset for its children
+ *   parent/child	owns a cpuset
+ *   parent/child/leaf	no cpuset of its own, inherits child's
+ */
+struct cgroup_nr_cpus_ctx {
+	struct cgroup_nr_cpus *skel;
+	struct bpf_link *link;
+	char root[PATH_MAX];
+	char parent[PATH_MAX];
+	char child[PATH_MAX];
+	char leaf[PATH_MAX];
+	bool parent_created;
+	bool child_created;
+	bool leaf_created;
+};
+
+static int join_path(char *dst, size_t dst_size, const char *parent, const char *name)
+{
+	int ret;
+
+	ret = snprintf(dst, dst_size, "%s/%s", parent, name);
+	if (ret < 0 || (size_t)ret >= dst_size)
+		return -ENAMETOOLONG;
+	return 0;
+}
+
+static u64 cgroup_id(const char *path)
+{
+	union {
+		u64 id;
+		unsigned char bytes[8];
+	} id = {};
+	struct file_handle *handle;
+	int mount_id, ret;
+
+	handle = calloc(1, sizeof(*handle) + sizeof(id));
+	if (!handle)
+		return 0;
+	handle->handle_bytes = sizeof(id);
+	ret = name_to_handle_at(AT_FDCWD, path, handle, &mount_id, 0);
+	if (!ret && handle->handle_bytes == sizeof(id))
+		memcpy(id.bytes, handle->f_handle, sizeof(id));
+	free(handle);
+
+	return ret ? 0 : id.id;
+}
+
+/*
+ * Parse a cpulist such as "0-3,8,10-11". Return the number of CPUs and the
+ * lowest and highest CPU in @first and @last, or -errno on failure.
+ */
+static int parse_cpulist(const char *cpulist, u32 *first, u32 *last)
+{
+	const char *p = cpulist;
+	u32 lowest = UINT_MAX, highest = 0;
+	int count = 0;
+
+	while (*p && *p != '\n') {
+		unsigned long start, end_cpu;
+		char *end;
+
+		errno = 0;
+		start = strtoul(p, &end, 10);
+		if (errno || end == p || start > INT_MAX)
+			return -EINVAL;
+		end_cpu = start;
+		p = end;
+		if (*p == '-') {
+			end_cpu = strtoul(p + 1, &end, 10);
+			if (errno || end == p + 1 || end_cpu > INT_MAX || end_cpu < start)
+				return -EINVAL;
+			p = end;
+		}
+		if (end_cpu - start + 1 > (unsigned long)(INT_MAX - count))
+			return -EOVERFLOW;
+		if (start < lowest)
+			lowest = start;
+		if (end_cpu > highest)
+			highest = end_cpu;
+		count += end_cpu - start + 1;
+		if (*p == ',')
+			p++;
+		else if (*p && *p != '\n')
+			return -EINVAL;
+	}
+
+	if (first)
+		*first = lowest;
+	if (last)
+		*last = highest;
+	return count;
+}
+
+/*
+ * Number of CPUs in @cgroup's cpuset.cpus.effective, or -errno.
+ *
+ * A sparse cpulist can exceed a page on large systems. cg_read() does a single
+ * bounded read, so size the buffer for the worst case of NR_CPUS=8192 and
+ * reject a read that fills it rather than parsing a truncated list.
+ */
+static int effective_nr_cpus(const char *cgroup, u32 *first, u32 *last)
+{
+	static char buf[65536];
+
+	if (cg_read(cgroup, "cpuset.cpus.effective", buf, sizeof(buf)))
+		return -EIO;
+	if (strlen(buf) >= sizeof(buf) - 1)
+		return -EOVERFLOW;
+	return parse_cpulist(buf, first, last);
+}
+
+/* Run the SYSCALL program to sample scx_bpf_cgroup_nr_cpus() for @path. */
+static int kfunc_nr_cpus(struct cgroup_nr_cpus_ctx *ctx, const char *path, s64 *nr_cpus)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+	u64 cgid;
+	int err;
+
+	cgid = cgroup_id(path);
+	if (!cgid) {
+		SCX_ERR("Failed to read cgroup ID of %s", path);
+		return -ENOENT;
+	}
+
+	ctx->skel->bss->query_cgid = cgid;
+	err = bpf_prog_test_run_opts(bpf_program__fd(ctx->skel->progs.cgroup_nr_cpus_read),
+				     &topts);
+	if (err || topts.retval) {
+		SCX_ERR("BPF_PROG_RUN failed for %s (err=%d retval=%d)",
+			path, err, (int)topts.retval);
+		return err ?: -EIO;
+	}
+
+	*nr_cpus = ctx->skel->data->query_nr_cpus;
+	return 0;
+}
+
+static bool check_nr_cpus(struct cgroup_nr_cpus_ctx *ctx, const char *path, int expected,
+			  const char *what)
+{
+	s64 nr_cpus;
+
+	if (kfunc_nr_cpus(ctx, path, &nr_cpus))
+		return false;
+	if (nr_cpus != expected) {
+		SCX_ERR("%s: expected %d CPUs, got %lld", what, expected,
+			(long long)nr_cpus);
+		return false;
+	}
+	return true;
+}
+
+/*
+ * Like check_nr_cpus() but tolerate a transient mismatch. A cpuset css being
+ * disabled stays attached to its cgroup until it's asynchronously offlined, and
+ * cpuset_num_cpus() keeps reporting its stale mask until then.
+ */
+static bool wait_nr_cpus(struct cgroup_nr_cpus_ctx *ctx, const char *path, int expected,
+			 const char *what)
+{
+	s64 nr_cpus = -1;
+	int i;
+
+	for (i = 0; i < 1000; i++) {
+		if (kfunc_nr_cpus(ctx, path, &nr_cpus))
+			return false;
+		if (nr_cpus == expected)
+			return true;
+		usleep(1000);
+	}
+	SCX_ERR("%s: expected %d CPUs, got %lld", what, expected, (long long)nr_cpus);
+	return false;
+}
+
+static bool controller_enabled(const char *cgroup, const char *file, const char *controller)
+{
+	char buf[4096], *saveptr, *token;
+
+	if (cg_read(cgroup, file, buf, sizeof(buf)))
+		return false;
+	for (token = strtok_r(buf, "\n ", &saveptr); token;
+	     token = strtok_r(NULL, "\n ", &saveptr))
+		if (!strcmp(token, controller))
+			return true;
+	return false;
+}
+
+static void cleanup_ctx(struct cgroup_nr_cpus_ctx *ctx)
+{
+	bpf_link__destroy(ctx->link);
+	cgroup_nr_cpus__destroy(ctx->skel);
+	if (ctx->leaf_created)
+		cg_destroy(ctx->leaf);
+	if (ctx->child_created)
+		cg_destroy(ctx->child);
+	if (ctx->parent_created)
+		cg_destroy(ctx->parent);
+}
+
+/*
+ * Enable @controller in the root's subtree_control if needed. Like the cgroup
+ * selftests, leave it enabled afterwards: the root is shared, and another
+ * manager may start relying on the controller while the test runs.
+ */
+static enum scx_test_status enable_controller(const char *root, const char *controller)
+{
+	char value[32];
+
+	if (controller_enabled(root, "cgroup.subtree_control", controller))
+		return SCX_TEST_PASS;
+	if (!controller_enabled(root, "cgroup.controllers", controller))
+		return SCX_TEST_SKIP;
+
+	snprintf(value, sizeof(value), "+%s", controller);
+	if (cg_write(root, "cgroup.subtree_control", value))
+		return SCX_TEST_SKIP;
+	return SCX_TEST_PASS;
+}
+
+static enum scx_test_status setup_cgroups(struct cgroup_nr_cpus_ctx *ctx)
+{
+	enum scx_test_status status;
+	char name[64];
+
+	if (cg_find_unified_root(ctx->root, sizeof(ctx->root), NULL))
+		return SCX_TEST_SKIP;
+
+	status = enable_controller(ctx->root, "cpu");
+	if (status != SCX_TEST_PASS)
+		return status;
+	status = enable_controller(ctx->root, "cpuset");
+	if (status != SCX_TEST_PASS)
+		return status;
+
+	snprintf(name, sizeof(name), "scx_nr_cpus_%d", getpid());
+	if (join_path(ctx->parent, sizeof(ctx->parent), ctx->root, name) ||
+	    join_path(ctx->child, sizeof(ctx->child), ctx->parent, "child") ||
+	    join_path(ctx->leaf, sizeof(ctx->leaf), ctx->child, "leaf")) {
+		SCX_ERR("Cgroup path is too long");
+		return SCX_TEST_FAIL;
+	}
+
+	if (cg_create(ctx->parent)) {
+		SCX_ERR("Failed to create cgroup %s", ctx->parent);
+		return SCX_TEST_FAIL;
+	}
+	ctx->parent_created = true;
+	if (cg_write(ctx->parent, "cgroup.subtree_control", "+cpu +cpuset")) {
+		SCX_ERR("Failed to enable controllers in %s", ctx->parent);
+		return SCX_TEST_FAIL;
+	}
+	if (cg_create(ctx->child)) {
+		SCX_ERR("Failed to create cgroup %s", ctx->child);
+		return SCX_TEST_FAIL;
+	}
+	ctx->child_created = true;
+	if (cg_write(ctx->child, "cgroup.subtree_control", "+cpu")) {
+		SCX_ERR("Failed to enable cpu in %s", ctx->child);
+		return SCX_TEST_FAIL;
+	}
+	if (cg_create(ctx->leaf)) {
+		SCX_ERR("Failed to create cgroup %s", ctx->leaf);
+		return SCX_TEST_FAIL;
+	}
+	ctx->leaf_created = true;
+
+	return SCX_TEST_PASS;
+}
+
+static enum scx_test_status run(void *arg)
+{
+	struct cgroup_nr_cpus_ctx ctx = {};
+	enum scx_test_status status;
+	char value[32];
+	u32 first, last;
+	int nr_root, nr_child;
+
+	(void)arg;
+
+	/*
+	 * SCX_ENUM_INIT() exits the process if vmlinux BTF can't be loaded, so
+	 * run it before creating any cgroups that would then be left behind.
+	 */
+	ctx.skel = cgroup_nr_cpus__open();
+	if (!ctx.skel) {
+		SCX_ERR("Failed to open skel");
+		return SCX_TEST_FAIL;
+	}
+	SCX_ENUM_INIT(ctx.skel);
+
+	status = setup_cgroups(&ctx);
+	if (status != SCX_TEST_PASS)
+		goto out;
+	status = SCX_TEST_FAIL;
+
+	nr_root = effective_nr_cpus(ctx.root, NULL, NULL);
+	nr_child = effective_nr_cpus(ctx.child, &first, &last);
+	if (nr_root < 0 || nr_child < 0) {
+		SCX_ERR("Failed to read effective cpusets");
+		goto out;
+	}
+	/* The effective cpuset can be empty, e.g. under a partition root. */
+	if (nr_child < 2) {
+		status = SCX_TEST_SKIP;
+		goto out;
+	}
+
+	ctx.skel->bss->init_cgid = cgroup_id(ctx.leaf);
+	if (!ctx.skel->bss->init_cgid) {
+		SCX_ERR("Failed to read cgroup ID of %s", ctx.leaf);
+		goto out;
+	}
+	if (cgroup_nr_cpus__load(ctx.skel)) {
+		SCX_ERR("Failed to load skel");
+		goto out;
+	}
+
+	/* The kfunc must be callable without a scheduler attached. */
+	if (!check_nr_cpus(&ctx, ctx.root, nr_root, "root") ||
+	    !check_nr_cpus(&ctx, ctx.child, nr_child, "child") ||
+	    !check_nr_cpus(&ctx, ctx.leaf, nr_child, "inherited leaf"))
+		goto out;
+
+	/* ops.cgroup_init() runs for existing cgroups when attaching. */
+	ctx.link = bpf_map__attach_struct_ops(ctx.skel->maps.cgroup_nr_cpus_ops);
+	if (!ctx.link) {
+		SCX_ERR("Failed to attach scheduler");
+		goto out;
+	}
+	if (ctx.skel->data->init_nr_cpus != nr_child) {
+		SCX_ERR("ops.cgroup_init(): expected %d CPUs, got %lld", nr_child,
+			(long long)ctx.skel->data->init_nr_cpus);
+		goto out;
+	}
+
+	/* Non-contiguous cpuset, observed by the owner and by the inheritor. */
+	if (nr_child > 2) {
+		snprintf(value, sizeof(value), "%u,%u", first, last);
+		if (cg_write(ctx.child, "cpuset.cpus", value)) {
+			SCX_ERR("Failed to set cpuset.cpus=%s for %s", value, ctx.child);
+			goto out;
+		}
+		if (!check_nr_cpus(&ctx, ctx.child, 2, "sparse child") ||
+		    !check_nr_cpus(&ctx, ctx.leaf, 2, "sparse inherited leaf"))
+			goto out;
+	}
+
+	snprintf(value, sizeof(value), "%u", first);
+	if (cg_write(ctx.child, "cpuset.cpus", value)) {
+		SCX_ERR("Failed to set cpuset.cpus=%s for %s", value, ctx.child);
+		goto out;
+	}
+	if (!check_nr_cpus(&ctx, ctx.child, 1, "single-CPU child") ||
+	    !check_nr_cpus(&ctx, ctx.leaf, 1, "single-CPU inherited leaf"))
+		goto out;
+
+	/*
+	 * Disabling cpuset below @parent makes @child and @leaf inherit
+	 * @parent's effective cpuset, which spans all of the root's CPUs.
+	 */
+	if (cg_write(ctx.parent, "cgroup.subtree_control", "-cpuset")) {
+		SCX_ERR("Failed to disable cpuset in %s", ctx.parent);
+		goto out;
+	}
+	nr_child = effective_nr_cpus(ctx.parent, NULL, NULL);
+	if (nr_child < 0) {
+		SCX_ERR("Failed to read effective cpuset of %s", ctx.parent);
+		goto out;
+	}
+	if (!wait_nr_cpus(&ctx, ctx.child, nr_child, "child after cpuset disable") ||
+	    !wait_nr_cpus(&ctx, ctx.leaf, nr_child, "leaf after cpuset disable"))
+		goto out;
+
+	if (ctx.skel->data->uei.kind != EXIT_KIND(SCX_EXIT_NONE)) {
+		SCX_ERR("Scheduler exited unexpectedly");
+		goto out;
+	}
+
+	status = SCX_TEST_PASS;
+out:
+	cleanup_ctx(&ctx);
+	return status;
+}
+
+struct scx_test cgroup_nr_cpus = {
+	.name = "cgroup_nr_cpus",
+	.description = "Verify scx_bpf_cgroup_nr_cpus() reports effective cpuset CPU counts",
+	.run = run,
+};
+REGISTER_SCX_TEST(&cgroup_nr_cpus)
diff --git a/tools/testing/selftests/sched_ext/config b/tools/testing/selftests/sched_ext/config
index affa3cf33470a..8173f9170ffe8 100644
--- a/tools/testing/selftests/sched_ext/config
+++ b/tools/testing/selftests/sched_ext/config
@@ -1,6 +1,7 @@
 CONFIG_SCHED_CLASS_EXT=y
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_SCHED=y
+CONFIG_CPUSETS=y
 CONFIG_EXT_GROUP_SCHED=y
 CONFIG_BPF=y
 CONFIG_BPF_SYSCALL=y
-- 
2.55.0

