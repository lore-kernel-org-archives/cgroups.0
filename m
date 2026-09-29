Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011045.outbound.protection.outlook.com [40.107.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A1547F79D;
	Tue, 29 Sep 2026 08:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790671319; cv=fail; b=tljYU0CYpX2+KY8mz1kOnsV0QWFFsAZQsLj05juRvU2Fj/TXh4EAaOsLgpwYMIkHF1eP6TaxHfFSoDcz4Rp+zaBtG9RelOIIFlc72cI7O+fXe5bVhg1fE/s6k2gLMGmy8iP21uz13jQQCfPspf5sKTmfvqxV/Hwa0VH8R1ByTY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790671319; c=relaxed/simple;
	bh=I1y+fx6ZhzdmeMd8/w0MMIXUqNcwYITRsUGf1ju8W7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ogET9f0YXq9Q8miBsLdNTXL/hi+WDs+FbeIz2MIdlYsSJs5/Q+C4i8/2HZkVhnvl+CqzJgyh70pJsvDRIafdbVZsHpBK/vmn93k/nJT9gxbh/zXSXMgjSmmPM32R//TrZSTiMsRZ4tzfgtEAkv06f2KgfVl4471IVOATDA57+xU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KapWZ6dG; arc=fail smtp.client-ip=40.107.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KapWZ6dG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EaBPPkwF0jmdyOkySg9jwUZz/7gtx52Ih9ia2TUK6+UUW9yC7jvAzCO6AvOF2Ey5Uhbm5uJxPxMYx0ngesYoKp9UN/4vBNSNlOhSQ8M4Rv7yjs7a+JgbaZEnYX/CxmFjAwpIXSaP/sW/0lEbJXao8UXYaSB/alzP7bCcQpNJIBrOLvqkTryoOvqJQu1orj0+kVJKMAoJgui2dH8kyQy1sl/FCdjuvnsWrp2cfRmzZiIDIiBI9rUCTIYzmkMSgw/MoO0TVOreICY0IADo8n7pUgsfLmjaCnyloHAuL/AZxiK9bnus8lWClkY4jYE5EuaiV+QT9vXTXBcaDpCDnXnt/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CM9pKWXrfHRsfePgz81gAIP9mou38gyYnpKa2z903c=;
 b=v5NILFY+57fNjIIWEpHh/LrGhommMlYmiNrBLglg5m/0/SZGHrdjwYhvYh7A63gilEhS7QGKOCK8Ye2WLBbJmFhJgPeI4YzKUJBVvxa3uvfaZUezR07t/dKSLF6Ges2bSYM2PUnGxfoxCA00OZKvGzgH2kY2yxONj6iJb4NximyJbbX27wiOnEoufdJ0RtFu+noq2YVnfJF46lBRbaSXtqDlw0edaCOayxGbe8wOX/QUoC2XyP1CU4/5F2p9j3gH1YWQGPXy2Q4EnG6lAODb2r0HNhi37XkoN/cGyHlpntUkWSNkT/LUse0SC0/D2Fuis/oZfJQ0kumj9IEBQocRrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CM9pKWXrfHRsfePgz81gAIP9mou38gyYnpKa2z903c=;
 b=KapWZ6dGb4lddpE3Q0oqjKGz5Km7u5RuZojY7Sr89p+C3PUJhIj9/P5Ith01p9Gb/m53NiMMSaCzFBbP2+4rF5PSN5LBjVjHB1UzBDk0JBV4polf8BjutZil1eISe7lpU5qkXTxQ9aviRBSZ20/MD5pJUxMgep9jSfPVr1Iz+VDmNVMLumUaRW/gyL0HYVDeLNNlUraJAXj9UpATQMidBrxzpzuCA99yuA0Gp9/vPuV3KwGVWhLLMGFUI9FwkL2Le9+u1soILjzOwPSMBV+/6Ge05BYNuzB61czWIGGjpB9T/F0VbPGvWeNZhUeT7TkaoE5e3AF3Lq/Uwm/XhhcFkQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by PH0PR12MB7816.namprd12.prod.outlook.com (2603:10b6:510:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Tue, 29 Sep
 2026 08:41:51 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 08:41:51 +0000
From: Andrea Righi <arighi@nvidia.com>
To: Tejun Heo <tj@kernel.org>,
	David Vernet <void@manifault.com>,
	Changwoo Min <changwoo@igalia.com>
Cc: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] sched_ext: Introduce scx_bpf_cgroup_nr_cpus()
Date: Tue, 29 Sep 2026 10:37:39 +0200
Message-ID: <20260929084124.626693-3-arighi@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929084124.626693-1-arighi@nvidia.com>
References: <20260929084124.626693-1-arighi@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0222.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::17) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|PH0PR12MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 2742f740-e341-4b84-8324-08df1e058225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|11063799006|3023799007|6133799003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	K5AVDxaseyV6UTvMW2l4HAgvU4FoV/D6Dnxc24+pmReZrmCrzThqgh6jeEYBWd3xIYcH2F01AthIN3aT6hqY32lnARhMk9XCgZCcsfOi/ZQJxLEgfCVVMSR2ELmKtof/nhUWmA9sygaKGRWjzGe2SmlC7YwpKu931WYewLYWErAGHOeF/9Vr1Nxu60d54IHs4OTTYMEUqvWRxd+urRWVDWM83QGNA2lLKPIIHYsJbEVdi0CJky/vjxrE2fi0VdjjkX3M67xP4LvO3IZFEumwoq05JPtmJT1QuZmOA+g/eOoDa5DiMif8IacR2m/WxNGC2+sxxbUjeuxAaK7sCRM6cBvi9wTSpxNviXgjsTN4UQnYCyE8QEzk8ZnJZ5K8r4SMi8WFCu1TEodCnE56yXXndurecEKXr1BuMF7eEiSRZMnVKyl7cK372pRHURc2AUdUv0tIhLSdC1sB4PzqncR0Wg1x2x6QYAlztYlS3HdFIKGLjy1PoAvs1H+SDH416YnUeZTwMMskzJN6Uz+zvEto5XabKo1vDP9eGkTvTdGRxgGotU9c0H3Vc7PrtkAuD5nAdKzrNc0hBrIUatNAaiB0mKQ4NDO5CBDAav7wOnYEZLwHm4ccpGFmV3/ZDp8lGVVH99KScCQfCpcNdjA1BNlwSTriHxpBsVNQTDEKdUuWZL4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(11063799006)(3023799007)(6133799003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rK/UL5/1KDrxbUkVLHNFVoDqtXDJtImizU0mG3m0txgbyHvsL6SlH7iHZNzZ?=
 =?us-ascii?Q?9BsAt0tw6UQ8Z5ICQqFHSyT5t52DuOE8BbM/qO7zvoPT098QnwLyGRzb1nGi?=
 =?us-ascii?Q?Gz7lZYp/8ZbcWU6YeT7/46nm2P8n8IAZQAtAO5pFaFgouobJ7akrtUPOz8wD?=
 =?us-ascii?Q?KAJB/04RFm3KBpSvh4GLmznRlL+BWejlxYf6CnPyWrC/bTwOb2bKyvdPquRe?=
 =?us-ascii?Q?gtVvcLr0YUJ/RuA8sNSZjBA3ZL+a0o/gL5bk63ywoKLODG+Yhe4phvYC1ESe?=
 =?us-ascii?Q?dh2tRReM/ayra4jiF8d+9UdM2Rwt+UaHJWJqTRE2OnhA1/+XoQVw9HZ/U3Hw?=
 =?us-ascii?Q?eUWuCJaFYxmstbfSmB2KTmCs+VbIK9H2hg/V7pJeBQvVOMPyHWm0TZF1zg/8?=
 =?us-ascii?Q?2UcK3GESRsmIxoKD9nMt60HQBRSuX/QUIVRHQFaord+NgTePtl9SExRmmlnP?=
 =?us-ascii?Q?HaqB6jG/GvqXwM0vs2jolJl/jLxjYx+OqbLneKGYhMh51fA6ipQZn7zgH1A4?=
 =?us-ascii?Q?tfGs+qT9VZGPkL9Xtwrfjwirvg3wPBW3my68jOfpoVN8HZOVI+PY/lIYegwI?=
 =?us-ascii?Q?5wd26SdmmVJdEbKzYAbTEqiqpc8Q7eqMsJbxo1yD8suKI30xV5QrreGcZO6t?=
 =?us-ascii?Q?f8CGsJfnjWOUL2cRhiyOvyNoGDkDCY6szJViCOgZ6acyGVIfsAtCaqrCx+G1?=
 =?us-ascii?Q?DI1LcTgrm/GzdDOgX+Wr3K8P25atazHrIzANodRwfPmEqQdBiAbmGg37Fe/d?=
 =?us-ascii?Q?wv3m3y1S4Le6CILIyPFt1uAQtVly1zFfQVBkwRVTwpbHqKp7Mw9CunsTY4Yw?=
 =?us-ascii?Q?0uaAZM2aaB+D+bfT7/MKSLa8TtM+PSu0vviO7XlvW8CXoswtv3oY42mt3v44?=
 =?us-ascii?Q?z3nJfkBJ0AjS8svzzCYn9bMt1/WYmvv4sHEPO+k4XSjqiQeZb3O6FL/l24M1?=
 =?us-ascii?Q?AoGXkXh27Nd0xPSQwq5jQqwLyvRrEpI4gKjAdmwbiK7rBjjD9o566HIrLwtV?=
 =?us-ascii?Q?kx3BcBrTwJf2NwHzPpJGzk+EcH9RLdmPPn7MKQJrDTFSbF4e+QRgmJyR49Cr?=
 =?us-ascii?Q?NigX/hURK4Ei75qQIJOSrz6hxfCQoP1dXxJBK0UVklP2oupgAE8vYjNUaHq6?=
 =?us-ascii?Q?nKB2GBm51h+erfuRG763k98qWsPxq8Un1yJgdnAUMTJNvRBSgP1y7rfzNV+3?=
 =?us-ascii?Q?B4GiovSu4Ty7X/DgapJB+K1K7VtvQnoR8/iOS/wgi+mh5zyw+441t/r+417w?=
 =?us-ascii?Q?Z/RKWxFhdP5Zz7b5PA5zsGer+lfzDZdoQ1VbrjYUP1MaAudyytYTgHGyj0n2?=
 =?us-ascii?Q?oROLqcChopDOIZmQpQiZvsdV/YAdq6tUm3JQOwggS/x5SwLXwSvSKMuBK1fq?=
 =?us-ascii?Q?r/RL6oHVjkolO4k/HTY+ZqptLdqVNW2vjgs+fcVGhf2QY1OmGd9eFVuhS0Ss?=
 =?us-ascii?Q?tCIQJEi2cs9KXPL2hg9m3OMT3yGQq3NrFFarbYFWU9+5nllCNmzCuIebwKEE?=
 =?us-ascii?Q?/9TSFb3BstbCKGxRJRwHw8fKWopnDd6OHddLnMt3K6id7Vp2f06E0epVOSkF?=
 =?us-ascii?Q?aUtPdcw7/dpHUWNb2rzxTQh2kvr6UcSvju7uJAjbHvj6pWekLOWjyuQ1MOkB?=
 =?us-ascii?Q?RvuOO5UazdaAp1+znofJyBcXLdSGsMb9JUmFxfbdMAmYnGKCPJNLr+Q0ZTQ0?=
 =?us-ascii?Q?WL6efWw8j6NixC8kKSFrg5kU0/YVCJJuKYEj30iFp/6/JZdOJnZ9lRWIlrKW?=
 =?us-ascii?Q?xFb3FoWIOw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2742f740-e341-4b84-8324-08df1e058225
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 08:41:51.8560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YWcO8mf4d38iOqG7DvLc1ZTfqHjrZzsgKfYZp6nCvODR0WRTanMgwDOLMOaqtbmHhIoPzH1UK0KdBUQID9qBhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7816

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
schedulers from any context. Also add the a compat wrapper which falls
back to nr_cpu_ids on older kernels.

Signed-off-by: Andrea Righi <arighi@nvidia.com>
---
 kernel/sched/ext/ext.c                   | 22 ++++++++++++++++++++++
 tools/sched_ext/include/scx/common.bpf.h |  1 +
 tools/sched_ext/include/scx/compat.bpf.h |  7 +++++++
 3 files changed, 30 insertions(+)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index e48aac45afeaf..bb668a1749f55 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -11350,6 +11350,27 @@ __bpf_kfunc struct cgroup *scx_bpf_task_cgroup(struct task_struct *p,
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
+ * On cgroup v1 without the cpuset_v2_mode mount option, or when cpuset is not
+ * configured, the number of online CPUs is returned. The result may be 0 for a
+ * partition root which has no effective CPUs left.
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
@@ -11397,6 +11418,7 @@ BTF_ID_FLAGS(func, scx_bpf_now)
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

