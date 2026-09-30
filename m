Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D5D391E77;
	Wed, 30 Sep 2026 09:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758872; cv=fail; b=R7IprHaecwr2z9RvzsQC5/MGqo1akd7xvCLpVa9mGuiZY7D+7kzomw8a/i0X5yLCqqSQdXKgV7Et4w5eHUR76o4yIisUtVzD9Kl8YxDIvWpGyKxugk5OKcJlgSO3k9eyNEVDNpzLNruXe1JnZlI1THC5r6O0o33yA5lWs/r8UEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758872; c=relaxed/simple;
	bh=l06CtcCxLkwUVbVSbhQAITex466XgBUAUmgla9ivPC4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=dxIaK01yYsY8c7Fg/FpVXPp3ZpfExFo4S9+4ME5S4vd5SjufBGbf4LBgecQfcY0151KUU/6ZdtHy/JDYHW8bQ3DVOTLgcTB7cnD3eB9YhXI5z0LgEOzpO59LiTBAINoFom1d36DaUkVG11vSWBf+kSgRWovz6u8H+hfA8f+UcQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=caoAqgF+; arc=fail smtp.client-ip=52.101.193.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="caoAqgF+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YmSJbyaUUvga54Dqq+cq43F+ZiNzaqYAR7ehFWQMfl0P5/W8zJBTcCjFyNdKK/TaxzZD03Bng+0LQJopqd5i+0PKanFkZxQoduD93pZm1SufZ8uTsz6nTP5x/fu6WcF6VAaRjEYdxxHOA/ktoJXhVCqU6LNWYkIIX3+VcvxVkyTqPYcwddERwNlSFryJAzzT6aormCF+74ofenhK8WAAlQm+vSDlkz5u8WsEurYKnOtc0m1w61rVwake0vwwC8BrVNHC/En/V8Z6diqfT1Ou+aIe903ChyvDvtfQUuqktojuw4pT6G0c/oDRDtjC7omDQHwD+eywzaZmdUHHzL2HYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0V72Bq4P6JLfiadUPwP0mp/wp/RFat7psPiYP0RC16g=;
 b=l/IUjbcGBVvv+5fMLFFlpl1xp4Rge5PF2kpVXGVfKOQOzCj1Sb0dpEBiG9wIyxlOVimQDv/e0UO02myfGXWI/b2XF3CF8YH/Mz7tsjbpk2TwvzvqRZkDHgyydDn6Vdo/dMIThZenUVrr66E4NSkPVB7sUT6Kj3iXopLRNsrQhU52KOGXVms+aZ9iQMXG8bC02B64jmjUYlPvVdgldMI0M47RqeWjJTxmnNzTBEdIkrJ+DEFwlqG43NffqdrHTBkjfppNvGh9RZXuY/IrqG4dZkyfLjN7xxZamIMdnrc8y61T3qsmMawG1mJc/yDPHbosJ2c+mYQqT1j0wrLGhjKWYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0V72Bq4P6JLfiadUPwP0mp/wp/RFat7psPiYP0RC16g=;
 b=caoAqgF+OpnIkEAn/fDQs7f0Ho7N3ok19j0Gh+2VrXSKk/Wp+0s1fnWAakWeHB80y75rcZL8Dpo0OG1fdchyX8Typ7+6F0wOozA+oULbAaNRQqBm8XmVmYjJ1oKt5EKgjIMfS1rIr43OJbF5zXj/sYr2o1BtBYWUY+0QhJAORHBaU7Ho1r4S3zcNqiTSmrX+Q2T5UFr/TPJLG6GcCkbkrHMgTrnllK0Npfztgi33UGmoeMzH+ScytxhtRuZLYIxxzADtk/KiMmn5VJUdReoQ2qHUGT58OF8SSk0IW4nWhn+rYJ5NekLtRR8Y8v6dxMNA2cSuDV+53U/qJxJH4C3jNA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by PH7PR12MB7817.namprd12.prod.outlook.com (2603:10b6:510:279::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Wed, 30 Sep
 2026 09:01:07 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 09:01:06 +0000
From: Andrea Righi <arighi@nvidia.com>
To: Tejun Heo <tj@kernel.org>,
	David Vernet <void@manifault.com>,
	Changwoo Min <changwoo@igalia.com>
Cc: Waiman Long <longman@redhat.com>,
	Michal Koutny <mkoutny@suse.com>,
	sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCHSET v2 sched_ext/for-7.4] sched_ext: Add scx_bpf_cgroup_nr_cpus()
Date: Wed, 30 Sep 2026 11:00:17 +0200
Message-ID: <20260930090049.1035813-1-arighi@nvidia.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV0P278CA0063.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:2a::14) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|PH7PR12MB7817:EE_
X-MS-Office365-Filtering-Correlation-Id: dd11823f-8705-4fb2-6ad4-08df1ed15c86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|10067099003|11063799006|6133799003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	t3uQAIeXOz9uHTAfr5wBDGe7dDVx3cl9hCdTxcYQT69b3WNSBvMi59fFPzvpvDdc2FEoXjNMEq6KI1u80mCXQe7BAz9UFlT5djmx0a+gOf5ORtlTFEEZscSMIx+aFMrDct97WDEQ1H7s3vnolTa7GbeSYXbhUu9CjUe8FQruACbhJilc5QTqnRSqd7g7LMZLsq+ugSwCwwp2opbx8Z/N45hzzWr+M+OwPKz3Z4LvYGvO75dqjJuXLfUfeBHCpFgShV9yQuS+JBacTA44/5jtfV9/JahPwZjllpIgCes38dZhCDmn+wwtA4GCo8aN+jXTqYtVcgOLd6CmtTQtZm6q640n326hsi3m8VQNBNzmLaza0YJEtWFWYfFB+5JY+BWmXYt8GespSVYqrcnUooiHYIxeuwfIBJFgBeamyHKuINCfbo3Gxm+E1OUxmm0viyNyiy5GHF/hj3bNDZTByXoVGvQjXmmjzFEqj9+r/6AZQvt1vJ6wr6T8zAjzjFlPq7rKPvQih2LPqZBiWDUElPGMy7ygWzV0j75+Tigk5AQ4ORlnrarQWX4q896mO8wYX4YoOZyGn9AhANK/3Ljqw3B8eq9XLvB6/zrUi4+sJodd7Jan9zGtsPIej9fuXVoqEK6EPCq45E06pfK37Oc4OTYgfif5X27MVAySNz/3vXKr9kM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(10067099003)(11063799006)(6133799003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JvKk3R+RGJ3TkKiediGx2dQuSjeDQ8Nr556lP/g3gQnoDyRLJGIXN1PlHHDx?=
 =?us-ascii?Q?N5Kz6gfLEJHmuyfALqtZJX4/uzEf/segYyM4eFRTMZjaflaxQk2TI4qqbU5Q?=
 =?us-ascii?Q?3MbxLQVTW7uUk2+oVJOe3u+Ix1gizL6iHFWhXKL4Tu/COc2vp1Vs5ZkPVT0e?=
 =?us-ascii?Q?B9t8Nz+FnOugg0dd8dXS7muSQQLZhSxldD2ees/hDti+F+SRhGI5UgDKhAG+?=
 =?us-ascii?Q?DP4MosVcb60XUxQ41Z2UNVV/BB6D+/DqM7nhNQAHYo2A1rGmXdnwJdJsnrsI?=
 =?us-ascii?Q?sGgKoFGOzLoRcDZelgBKrbXejVZT3+FtPRoap+k5531evFsuOLv3abbfm6WX?=
 =?us-ascii?Q?C5y/JPI89qhDnln4pWn9j3+G+41IwQLMO3prZc2ZJ+bgs0brzhUZgQ6Dzt5L?=
 =?us-ascii?Q?RnZGfPYVeOoNf6VB52XfToEK97rlCTZFy0envV0y1ZtvQjf2E/4Xnp6IMIS+?=
 =?us-ascii?Q?2iW3MeUU9a/V7wTpyzk8cexTlGFBPnymbujQzoqG/w94pVVYGNRuMo7Jam1G?=
 =?us-ascii?Q?NB3w20Blpan+QiLVfKqNpKjY4WspUWsvTpTMLOtZRvXoS04AuvDh9BCemqx5?=
 =?us-ascii?Q?5w8L9Xfhlt3iOfpXmPjU+CTUUuPD88yozblhTxQAh/ThjDvqGGfcEumHKj+d?=
 =?us-ascii?Q?YA4oQt3HfD2XQwNfDbtsG6KFFULxCdkgsubg1DRs9iYh+DRLyhlL1QTThsEt?=
 =?us-ascii?Q?dHLYzKR3Nh33/nThUxhhqNnMzfnLonLNqEvMkKGgzo2SgWK/9op+IUwMbmqV?=
 =?us-ascii?Q?uStmEVd3R5wPwsaKtzmKPSAsKXfg7jcpzcwhl0FkuINWT45yEE6/0OH2N6Xq?=
 =?us-ascii?Q?RD8eyvZsuoq0MdeOeIWibPdWesI4U8iJBEV4bThXMmp6sUEJXfBXAAeLhMjf?=
 =?us-ascii?Q?K0t4TISE23TdVH0IbM4SHy52IDd110yGKH9TxN2CoFD1ynsdk/ROqdOMFnZS?=
 =?us-ascii?Q?EjHV4iUsFnCY/7G/Ed4uC/hIdVkax72QKhYyPtXkTTJIArIRRI8Kkyqq8UJl?=
 =?us-ascii?Q?3m77qs4wFeCutGIZvATYheRq0eY5dmNugMKx85FqQkg/gBgEgnAohmEolYty?=
 =?us-ascii?Q?kUo6E8qFusz1NySJynzSZjYFqb3X2Xzkh4XRTCVYmCHnwNVrQzPz8dRFZegP?=
 =?us-ascii?Q?F0zw/Nk7ETdIiOmbbZO9CfKhKw4drTVFfdk0jIMMvHzLg8Zj0nG1e0kW9EL1?=
 =?us-ascii?Q?iFKNAlKHt+2btRG577Ds0prn2eebBcD+BLovnRJa3AIz6xRe4ZVtBx77PkCd?=
 =?us-ascii?Q?Er/E2GSThtkXlaHdGJsAsMt1ZoYfFlTAUwltoiW0sp37FC9jScLokIasDzUe?=
 =?us-ascii?Q?WVa3hYB8a94XQv7zT14QNzhMIvIEAqvtZtk7JCl8zwsicBDm2uqjJnXiPP/T?=
 =?us-ascii?Q?/5okPEkDAzUDx+BwW4L36AaEZTIaymBl2kgjyWCGIATNVkbYQboEkSs7ekh5?=
 =?us-ascii?Q?GxfRbx6tR4zw5FEYPUrxQZ64eoBqo0ozWyykLNy9u/bNQ/MgT+bbQTn0+r6K?=
 =?us-ascii?Q?IsizXr1YUXsTpZtSxMhjO4OPVhnxEKMAVq9RGmM0O5VDgKdek6i6wLIcRiFl?=
 =?us-ascii?Q?7RY7wi5+ajksWZRGS8p+xhePPTcbw6Pb7oLlc436T2Z6JULUmIllLhGc1rje?=
 =?us-ascii?Q?ybPqjKxLwE0S13G0DvFzrXA4cvCNG1ujErt8x6Gp5UmmJhpYw5lDaZS5xRZD?=
 =?us-ascii?Q?vWLMQ2H0yo1WmlEQA/RUoY8V27zyE1Ow0pQjldUNc0niXj9jzMxxl//ubbRY?=
 =?us-ascii?Q?dU+osoP9Xg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd11823f-8705-4fb2-6ad4-08df1ed15c86
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 09:01:06.1539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Q9IVPdEzWJvWuP0AcX9IOTAczQL6NayWhbOhQd1cvbdc5rINkjpQHuVbKg5QA8Qc7oMgPg/vcjlxWxD6IXVjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7817

Hierarchical BPF schedulers need to know how many CPUs a cgroup can run
on when distributing group-wide weights. For example, fair's group share
calculation scales a group's weight by the smaller of its estimated
runnable task count and the number of CPUs in its effective cpuset.
Without that count, a BPF scheduler can only use the machine-wide CPU
count and may give a group confined to a few CPUs excessive shares.

This series adds scx_bpf_cgroup_nr_cpus(), a kfunc that returns the same
count fair uses. This allows scx_eevdf to compute per-cgroup shares for
groups confined to a subset of CPUs through cpuset. A selftest covers
effective and inherited cpusets, changes to the allowed CPUs, and calls
with and without a scheduler attached.

This series requires Waiman Long's cpuset fix to avoid a potential
use-after-free in a rare cgroup filesystem rebind race:
https://lore.kernel.org/r/20260930031833.660267-1-longman@redhat.com

Changes in v2:
 - Drop the cpuset RCU guard patch
 - Link to v1:
   https://lore.kernel.org/r/20260929084124.626693-1-arighi@nvidia.com

Andrea Righi (2):
  sched_ext: Introduce scx_bpf_cgroup_nr_cpus()
  selftests/sched_ext: Test scx_bpf_cgroup_nr_cpus()

 kernel/sched/ext/ext.c                        |  18 +
 tools/sched_ext/include/scx/common.bpf.h      |   1 +
 tools/sched_ext/include/scx/compat.bpf.h      |   7 +
 tools/testing/selftests/sched_ext/Makefile    |   6 +-
 .../selftests/sched_ext/cgroup_nr_cpus.bpf.c  |  60 +++
 .../selftests/sched_ext/cgroup_nr_cpus.c      | 419 ++++++++++++++++++
 tools/testing/selftests/sched_ext/config      |   1 +
 7 files changed, 510 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/sched_ext/cgroup_nr_cpus.bpf.c
 create mode 100644 tools/testing/selftests/sched_ext/cgroup_nr_cpus.c

-- 
2.55.0
