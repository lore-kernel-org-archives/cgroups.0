Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010062.outbound.protection.outlook.com [52.101.201.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29ED3655F0;
	Wed, 30 Sep 2026 09:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758881; cv=fail; b=hn0Tu9d+f5vqgPfHqNdTlmcYj6yo9TziRKA9+f1+weDaAgefbPRIm+mAm6N1e/cOLTpAJVG33s9qa85S/pMGeeWMkVD+g5d/nCUNM7yAP8emRsBK3duZIjwFcjTfgabhGY0gpBThz5ZtxQBr6U0l41NLv9o2Av6u25NDlTVL8lU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758881; c=relaxed/simple;
	bh=ChTzQLwtYwmH9d+rHk8l7E2by0Ixrg6cHFxouCRVpAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RabvgUvPM2kjTqPgCuJY/KOrTosdHKEPnOAhgGS7rne3l+GOIlWYtQLcEDzTMntv8oRJxQQOGviM10X7NSOcsXO3k7hJUdfTrIOxy8zJh+xkAWfKGvc9wsZOp1OvPeAMXo0qY3mha3FCaQxQU/1Vgtk1qVawaBIs1PuW6L65g+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RXE0CyKw; arc=fail smtp.client-ip=52.101.201.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RXE0CyKw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AvB00aozWvyyUZ0OXO1mRPdW/Zb6JWndSjPD7RnvjhFtNn3USmCQVn1tCzq52HeS4g/2ldu5rgYynYj1MkCBUt/3vxGhgDGT/4Z1rH025FY3RdNBgpFn7Mhw19Ayt/XzqKa5uPZuzwoYrE0tSw+QZL+ud00OupN/ARw8hHuqnRw0Ivql2UwiuQtomrpkzsaJpmmFpQQw8mknXJsTCv+LxaETqAFJR7uzhImzxf4c7aObdvfgy4d+dd/1ZYpst+f25MciKxj/CSD6MjoGweCsRQRxJkdSaP1vOBxj1VS38ylAr7PqP3GH8ZrppE2Sc1JtadFj+OE57aTANKsF3SLIHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auch4pnVeNVljjEDBGS3BPv7WUH0Q6Wx088TYS/oxNQ=;
 b=UmOOaoarotNEeVQxi4MYt0j8yBygEjPa9A2SIAOZx33D86Alctzyd8LXeukvB5m9LFkuTk/SCSJCuolnjsNHv+/bw1RdQFFZujmq/0EfndEy6N6XauRK+PZqs4HPTDrJLjuZMLg1Wk9RCpj8wGNeRj7qWLvqR7MqR8cKbkqS8bxLAJLHNATCDOqSNqJtghblWqtlzN7VysUv/H+Fd5cMAli63qsLK7s2hhyIVhwNxig1nJBazZnEMedndzGztOIKfxWdCmuHWf696k26/emNj46CO/KsSX8LmSeUGT9g4U6Zmajgsnvc6MvgCnba1Muh4jIap0cWMXydKW4kfGtHlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auch4pnVeNVljjEDBGS3BPv7WUH0Q6Wx088TYS/oxNQ=;
 b=RXE0CyKwR3jWXYNfR1foYGJIiPiXnJCkLaN9xPOxv3J4W2gr51QCSG8etZPHaL6s/fxl/uJ6udgYssbPSPBNDijiOR3BUo241xLIs9WKZLTAPjmT+wd+SxpAr1D/mDo7ZUCYlQ17tTUcI8UzdlAuWh4vlg1dRsH7rhtTFexWkX2Mp+1OUSB2ESdUXjhocYw+li1euHLRHytg57A9ynw0Qi2MS2spU17XcA8w2Cc0vK8jBKp6cOVaSlKHEAoHCWzqGTyhbvQrojqOTDNbrIaYxhJcnsNhtJyrE/zLv9YqHvyxReSnQtVxMhXiKrbaehSzMz9NGWJpMRMN0Zf42zXzvQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by PH7PR12MB7817.namprd12.prod.outlook.com (2603:10b6:510:279::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Wed, 30 Sep
 2026 09:01:16 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 09:01:16 +0000
From: Andrea Righi <arighi@nvidia.com>
To: Tejun Heo <tj@kernel.org>,
	David Vernet <void@manifault.com>,
	Changwoo Min <changwoo@igalia.com>
Cc: Waiman Long <longman@redhat.com>,
	Michal Koutny <mkoutny@suse.com>,
	sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] sched_ext: Introduce scx_bpf_cgroup_nr_cpus()
Date: Wed, 30 Sep 2026 11:00:18 +0200
Message-ID: <20260930090049.1035813-2-arighi@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930090049.1035813-1-arighi@nvidia.com>
References: <20260930090049.1035813-1-arighi@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR1PEPF000077F3.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:918::451) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|PH7PR12MB7817:EE_
X-MS-Office365-Filtering-Correlation-Id: ed61ac09-77db-4405-689c-08df1ed162b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|10067099003|11063799006|3023799007|6133799003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	PM+92DwHe7Zbw/F8omHVtWOn+Q2rkjzBxoZRVRSob2xL21Tps+uHHRa6OwzIGL50XEqm3IdUM6PKeIqeikvNddZ72ukYMwLnl08JAMoA0/RWdaSAQfeXIbJGvRZJFm/iizBLal2VO9fMaMAdCnXUZvWeZVb33ie02sff30qiy5GwfyCgGVHVuYuJYZzTRyF51LdpeAYxoYo3RUz0zYaEtZ6aol1Gz5qzGS6qHrhb88uw69iaWvZWwx4MPE10+zLYQ+8QMwmy9eAHfJ0d8jnsmfEBTviOFjZA8y0xq47qqskH7D4Xo79bTbD2UAHMRiCL5RAvErlLcXUibA6pR6fkMJHW+26Zpt1M+t/3ikOi1l5Y0IvJVdGy6QJtss9Q9XQvXOTXhrgWvLMxEaAUb+KsXA30Y9ybu+fHZq7eaXADixlZ9vXJn798kcFMnmEBF5pwkYeVmTnzejtI1UH78gXi826QT6vuo++aUY8QVKvlqCICpUWlOhQ7aoIaXdIOVryutxCEDnJ8D4Ns9YA+18uyMLwiz7fwzQwkFqcw7Gi4QezhAddGo3zDuR1Td2g/eonQ7LcoujJ1163fzjZOePkPHANWsxBewwQsmMdl4aDCtcsaY4Q/Ge7/8MRgKc0jMBlgxNTYg++4n4iW+0h3lKIc3QVwZRGcnEeMTBoDwLR8X3w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(10067099003)(11063799006)(3023799007)(6133799003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+nlnf9dRM0hqBB4sAdHXbEXVwcP0L1Gbwhn6hMsllAch9KyJ2xORqaqKoUkg?=
 =?us-ascii?Q?5tKsYLklVLnSpKozRIhaPNJ7GBHuYeDwJk8f9yAzvFMaVzvujYrZgVAfqDNL?=
 =?us-ascii?Q?bJE1BmIZaCPlmD+FcR6Gc88oAV8PHan05KNdFppY2v3kUwDUGA+OOqsT8yaF?=
 =?us-ascii?Q?r4tsEnfFdS2VTujQM0rnesVZ1DJ03+CxOOLDO8n9quNWKdk2s9el7ChqOXKz?=
 =?us-ascii?Q?1cNjBhtbq4EKkmravt7hdtayv0NyhmgYUSiApqxLlGZj7ODbIqAnZjI+hfYd?=
 =?us-ascii?Q?i0g7NJQO/sCDHSOqkYFm9rWDcVwh53HDWEX1NMI61pqEFCR9aL5C2U8HST/j?=
 =?us-ascii?Q?+j1TbClxAXqkTRL7TTynJerBBFM49EEP2q4YU/PMZ/Sfdlh102kq+YEOyd2e?=
 =?us-ascii?Q?ZU00n2Bjd6d4e4DI5sx0wViy5bIW9toQPTsi7h7AUfvspiDfChpc4juwh/Bx?=
 =?us-ascii?Q?CxmrLbDSY1ai5SOPXFDLFckQ9GJLrZRCYh8aOb/p/yCQZFdVhl6FOem/EHzC?=
 =?us-ascii?Q?hr0y0lCP+8IGivSHZ66kTaHmmSLuwFrwzFk1o75tTIctCk0YhIemQWo9F/EK?=
 =?us-ascii?Q?9bHo5C/Bl9qlIaAZHSGvN8BioWX3F1xekxVYK8CmtMmRJqn1AgSiQCnf3OPv?=
 =?us-ascii?Q?0d7ACHhXN/FTRLzs+81Z+4saFSj8VWNh0qfSBD1CrQNi/hGWn2foOr1iFodc?=
 =?us-ascii?Q?lTF6eXCzMI1UoLMXp35a1Cy22X4K/FtJhpOKtV1VgmAdVP8id5sPo6I2Rqb2?=
 =?us-ascii?Q?pe/ocMsZfgSLRXfuU02/W0NJJxgCHCHfZd5pAMF6khSHw96jP3HUTBoIp68P?=
 =?us-ascii?Q?jeRzan5hp8X5w/5Xzsrh0kv1Z9/ZIv+khaJQjU/43cmD6B+JLum6+RoMHQo3?=
 =?us-ascii?Q?LjPPQFDmMjYIcwRMjgaLIjjzheCGyEXo7Xt+y/ltxVe6XOPKM7NxdAabFN/F?=
 =?us-ascii?Q?bogakEbD8udJiDGLCnGnnivUji2rw2LzbDGbuHBrItFeSf13gpmQH3u4iawr?=
 =?us-ascii?Q?eW5DMAH/pfJ5c0zd21YGi91vBabZiqjcvf0bI1rFhe3FLzfpGd/YRh7TNOVl?=
 =?us-ascii?Q?VPq2VgG5QQFpY2F35geTeEQ4NcGda0bCRGdyiVR4PPzYkhh5Hjzxh1Km0ip0?=
 =?us-ascii?Q?9b8E9yhxws5bZbb0Vv6jOM2UFR4bMNpitM7X6ABxQd9K1Qv9Qz9Yg+vG7LjY?=
 =?us-ascii?Q?CfAFGU3PZfmWrjgp2Jf++/8xIr9bQMB+iNLQ2WAIofbSwGOPvQUvQw1YvrJG?=
 =?us-ascii?Q?orOkF0pin2lyypkQJ497VWl6tjfUjtcCEQnoaO8SMEPbNLSTkx2fcRWmYWg3?=
 =?us-ascii?Q?0s0LU25hkTZycpAqG00hEmZD6ecEZBIk6BxqL03q6iDWkFG0XteRVI5ep26C?=
 =?us-ascii?Q?h6ydJ5VtHoeH+QSw/H5N0+BTfp54RB2Cx8jFBaW1+J3MdFqQD+bOHN5q78wV?=
 =?us-ascii?Q?zUkc0CybizxFvz57osln+8rnZsBPE3nGD6CyvKO5pkhnf2u3X83I0jQcKz9a?=
 =?us-ascii?Q?lpaQ+n00boSO43h5UfG0cfPgLE6Kp0Wn2WkIPGAgrf/P3EcABfulV9xcDnVe?=
 =?us-ascii?Q?IZzdCaBL52+8ySGz1qxwF0mBuqRfcsaezYpeuWZiykXXrvoPbMKkWZMgRyPm?=
 =?us-ascii?Q?iaeXNGQMIb5T43X0KDrLgJjux/iqeqWsTWA5pu2an8Dye/Gi26/lv6V9u3J4?=
 =?us-ascii?Q?zGAAdlQbpqnwjDviNg3NlyEgQCs+rWoN+kD6KtieYuz/jxMrVEeHTASvJYpc?=
 =?us-ascii?Q?z90PYqZObw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed61ac09-77db-4405-689c-08df1ed162b3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 09:01:16.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wyx+tzzpUQ9suQEgS7Qxv8Fld3Fpn9p62gJ8idTKMNTtkTDHRkUMANQ/zUsqOTpc2TB5BcViqdKc5v/eICQnEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7817

Hierarchical BPF schedulers may need to know how many CPUs a cgroup can
run on when distributing group-wide weights.

For example, fair's group share calculation scales a group's weight by
the smaller of its estimated runnable task count and the number of CPUs
in its effective cpuset. Without that count, a BPF scheduler can only
use the machine-wide CPU count and may give a group confined to a few
CPUs excessive shares.

A task's effective affinity can include per-task restrictions, so it
cannot reliably represent the group's cpuset. Reading the cpuset
directly from BPF would require CO-RE access to private cgroup and
cpuset structures, including inherited cpuset resolution, making the
approach fragile across kernel versions.

Add scx_bpf_cgroup_nr_cpus(), which returns the same count fair uses
through cpuset_num_cpus(). The count is independent of CPU or CID
numbering, so the kfunc is available to both cpu-form and cid-form
schedulers from any context. Also add a compat wrapper which falls
back to nr_cpu_ids on older kernels.

Signed-off-by: Andrea Righi <arighi@nvidia.com>
---
 kernel/sched/ext/ext.c                   | 18 ++++++++++++++++++
 tools/sched_ext/include/scx/common.bpf.h |  1 +
 tools/sched_ext/include/scx/compat.bpf.h |  7 +++++++
 3 files changed, 26 insertions(+)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 405d0d1038f82..e35f513876959 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -11355,6 +11355,23 @@ __bpf_kfunc struct cgroup *scx_bpf_task_cgroup(struct task_struct *p,
 	cgroup_get(cgrp);
 	return cgrp;
 }
+
+/**
+ * scx_bpf_cgroup_nr_cpus - Return the number of CPUs in a cgroup's cpuset
+ * @cgrp: cgroup of interest
+ *
+ * Return the number of CPUs in @cgrp's effective cpuset, which is inherited
+ * from the nearest ancestor with the cpuset controller enabled. This matches
+ * the count used by fair's group share calculation and lets hierarchical BPF
+ * schedulers bound a group's weight by the CPUs it can actually run on.
+ *
+ * The value is a snapshot and may change at any time through cpuset updates or
+ * CPU hotplug. Schedulers should re-read it when recomputing group state.
+ */
+__bpf_kfunc u32 scx_bpf_cgroup_nr_cpus(struct cgroup *cgrp)
+{
+	return cpuset_num_cpus(cgrp);
+}
 #endif	/* CONFIG_CGROUP_SCHED */
 
 __bpf_kfunc_end_defs();
@@ -11402,6 +11419,7 @@ BTF_ID_FLAGS(func, scx_bpf_now)
 BTF_ID_FLAGS(func, scx_bpf_events, KF_IMPLICIT_ARGS)
 #ifdef CONFIG_CGROUP_SCHED
 BTF_ID_FLAGS(func, scx_bpf_task_cgroup, KF_IMPLICIT_ARGS | KF_RCU | KF_ACQUIRE)
+BTF_ID_FLAGS(func, scx_bpf_cgroup_nr_cpus, KF_RCU)
 #endif
 BTF_ID_FLAGS(func, scx_bpf_sub_grant, KF_IMPLICIT_ARGS)
 BTF_ID_FLAGS(func, scx_bpf_sub_revoke, KF_IMPLICIT_ARGS)
diff --git a/tools/sched_ext/include/scx/common.bpf.h b/tools/sched_ext/include/scx/common.bpf.h
index 5003e33f51423..28337ae8d9e66 100644
--- a/tools/sched_ext/include/scx/common.bpf.h
+++ b/tools/sched_ext/include/scx/common.bpf.h
@@ -104,6 +104,7 @@ struct task_struct *scx_bpf_cpu_curr(s32 cpu) __ksym __weak;
 struct task_struct *scx_bpf_tid_to_task(u64 tid) __ksym __weak;
 u64 scx_bpf_now(void) __ksym __weak;
 void scx_bpf_events(struct scx_event_stats *events, size_t events__sz) __ksym __weak;
+u32 scx_bpf_cgroup_nr_cpus(struct cgroup *cgrp) __ksym __weak;
 s32 scx_bpf_cpu_to_cid(s32 cpu) __ksym __weak;
 s32 scx_bpf_cid_to_cpu(s32 cid) __ksym __weak;
 s32 scx_bpf_cid_node(s32 cid) __ksym __weak;
diff --git a/tools/sched_ext/include/scx/compat.bpf.h b/tools/sched_ext/include/scx/compat.bpf.h
index c5c90d1d81e04..a793c5e8814b9 100644
--- a/tools/sched_ext/include/scx/compat.bpf.h
+++ b/tools/sched_ext/include/scx/compat.bpf.h
@@ -248,6 +248,13 @@ static inline bool __COMPAT_is_enq_cpu_selected(u64 enq_flags)
 	(bpf_ksym_exists(scx_bpf_cid_node) ?				\
 	 scx_bpf_cid_node(cid) : NUMA_NO_NODE)
 
+/*
+ * v7.4: Add scx_bpf_cgroup_nr_cpus().
+ */
+#define __COMPAT_scx_bpf_cgroup_nr_cpus(cgrp)					\
+	(bpf_ksym_exists(scx_bpf_cgroup_nr_cpus) ?				\
+	 scx_bpf_cgroup_nr_cpus(cgrp) : scx_bpf_nr_cpu_ids())
+
 /*
  * v6.18: Add a helper to retrieve the current task running on a CPU.
  *
-- 
2.55.0

