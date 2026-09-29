Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013036.outbound.protection.outlook.com [40.107.201.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646803A872C;
	Tue, 29 Sep 2026 08:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790671304; cv=fail; b=T+Vw6M+w9PnAQ2/d9HIo/ntc7E+dEiFAadQwA0Q1TMzTSuog1sgH0xtDds7Kph8Ea7fO6aGNUlP+LcwlKtzF/cbRiVfyxv2y/hI2aHUI65VVJ/dVYzkw+DJngLfdg7y+so7qZSqToc10GZ5hQMzEP5jyFzPgHv3zmOaJ5NJ73mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790671304; c=relaxed/simple;
	bh=ZlVQocRhOgNHEUG0TYY5Gj0Gt+dpp9GyQBJqjEbkROQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PSumwhNpbw/o004TRQFVJlukfXna5TKvhp/H4GFu7MKBBNoxbzK0wEpuITiWYyjDj0CMnBfrvwUz1qPzRiZRuilf+hrAAhCXTwZNla29oTXjZWr3mlhPcVLqOwpP1RcTvESnOSzA8Jocwj9ttkyS47nxXxPy5ic9JUBraEDqiGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iDunn7yL; arc=fail smtp.client-ip=40.107.201.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iDunn7yL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W6xGw1GDSnl8Nu1kExDtXOrBfcG6gHXDL22VWtoFRK0duYY4u/qPiu5w8cCw65Xn523V1FW0qBSSjTun9KItGNBZyvIMfTvXJoZJJ1aQQ0qSgJ1HI4ftJan8wvbTZIQBkhqCofMhvXtVdXgwXOS10LpCCYxFKHtDXLDU99smk+OSwxTKwDfrKH1kZ7SFpBHYvDXT/3cbtpbLKmbeh6Ng6F+PqU6Jbqw4pvBJG6kmgOsCbvwxKfOF81o3IvhNEcSo/CDrXTr1VTi+ATjoDW2jBP/QJ/ywv06MZaYPbuqyoLWMwaFWor7rA52mY1q1VF2aUd3YYkW+gxdStx6giDMtCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1vYFT9RSrqpv7qfig0xPyf3CXgxWrBB82C7m/vt0gA=;
 b=m/e1nZphObSe7KM9md5xjUEOOc5B11JUYxHEwMAT+otswm130/RPm+ItiD2PZO7Yqoqs9ldnyJ7ZM6uJ7iibVw01KJUsh84KBmfKiRlzF7IzVpWqtHzwFbxZuxkTx+YhYUiEbrOKUGUIXJwEiaawSowGHBqpdbWR/p1s98M9DqkidQhzepVVk42O67fqmr6w64xtNID3eNQIsHaPRzQr+qUzk9ZsA7T7jVMZlQiRNhUGaHfDifGJnWdgeiN/uin97XNsgCdj+ZCA5jp0anLFUE0M8oPPiSi7vIOZYHZv2cqij/hIJgKzQUKLhNwKWR93biTnpl+MjWwypTVKGEfzmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1vYFT9RSrqpv7qfig0xPyf3CXgxWrBB82C7m/vt0gA=;
 b=iDunn7yL95cDelaTxsR94fZazDi/LITiA9EwPg07bk5D4aiqlaOJxVAwBB8r/B20dUV4+fjArnXpgQPM6r7Ez/lD6RFe1KBKMP1WwPm0FgQy0JtjCEPmk1MnnqNgDjKg+myi8ucAMu5SWeGssmxsGYev7B6r2nwU9WoI7WhTb/iQGjqu2KgjPsBt6LqLAX9a5oDoT3o18gEjqwv9y7STSIXrNCRdBTeMUwe+t6MJKExWRZevfybtCE8GKwzjju1WdppK5bWGSjU4OB8nDhjhtFeXLbGUVzCCwIgQrAv3U5HExTXb6wOnIC2esskfLPUl+oIl1+HMTPcJ7Z0J2aMBpQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by PH0PR12MB7816.namprd12.prod.outlook.com (2603:10b6:510:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Tue, 29 Sep
 2026 08:41:38 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 08:41:38 +0000
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
Subject: [PATCHSET sched_ext/for-7.4] sched_ext: Add scx_bpf_cgroup_nr_cpus()
Date: Tue, 29 Sep 2026 10:37:37 +0200
Message-ID: <20260929084124.626693-1-arighi@nvidia.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR09CA0026.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::9) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|PH0PR12MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 6801d1ac-bf6f-454d-f236-08df1e0579f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|11063799006|6133799003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	pnDAhIYwWfENBCJTydOSACZ/gIoRiE+sAmw05CDqJ8wDL7UR4nf06rSjy+IaTUY5wHe5Gd2v75vNEwYgkaGTdoiAxeCp7O/CqCkkz0cIOtvL+RxHxRHnFnTFnkWp7JdR4huRbHv8FrGSwl6mQ1mNkxJQPL63fPEZtAlgLOEPNGCC0IKFpOa5k5AKn7feGJoD9RYRIMl6BAACar9RcVjK2BOSHlDi4jwFn73e50qwO/eMBSxIiLtPhARu7L9uCbl1aR/NcW0n2zAui/Kc5V7zfHereYP0/KOACwIxRD4C6NG+IWVq6I2PX8OTwhKwb1OWQwk2XmZpoULOATi4ibte5vDeIbwAicsCjABbOMOocIX6BZtboO2wuUOvTMv2sUFeZDVi6Q1CQbDCGvLGsjUHkn131wUsTvXhi7TmDLEiZIa/Ouud5n+MKhSa96KJfQax/liNeICf4fi5i4Da1xmmKw51P/+WyvDtXyzp5TOS0quOp6EH0cXQVdAnKnq4mlb1tAV0IS223dmog+beT1pUhAAGEy6J5vHyN8QFI6WeQ+lM4Vp7xVf+J3DIlytPQT8G3WoYaTtE5ZDXiI2N8vSIsnRP7YZi5SGyFf/5PFfIJuuYraojLGD+7kPtHnjabofuENiO6e6Xk7Jzf/EHgHRS4oCmJoOWGEB/6F7P7NPebv4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(11063799006)(6133799003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v9pPvGlw/9dH7CdQ1cJnbNiJoGJDxcCSmkA/7De3+r+8NpLjUFbv961WO5SG?=
 =?us-ascii?Q?G4ENrT5F+Spy10vKPtCaL8nZ0qJu0AaKj2sAQMPVO7jy/aEjF8O+3v92dXqw?=
 =?us-ascii?Q?3wNladq+ihuH3DjrCRqfuaBBBkZIDVWvbOGm4c/+gBpjgcU/HUcG3pD40iWy?=
 =?us-ascii?Q?tS6QKM1Q2pI4fJdWCnIE26mxNwKCuhWey8WYP9gtys0QCzS3zPwQmlQTtQPK?=
 =?us-ascii?Q?QrZEYsERRBV0Xl2SDkW00q5/7ayqM/LQKBddAg2kPopL+e1sYzJ2RTSFqp0q?=
 =?us-ascii?Q?Ju/EGNVme94jqnEPNjGiM1DXyievAbkULekLmKhAqykyN7cQUmRBZ0XV6uwC?=
 =?us-ascii?Q?m18UJ52SstnNHBlBmxZ4pTSKygDy4DynvTGB5CuC+27jmNF9ILOqI/vSbiDC?=
 =?us-ascii?Q?kZNbCp8rloOGM/f3YdOSrd2B9wMBMyScpzX9S0dPnuZ03YvU2NFPdCSSvzfn?=
 =?us-ascii?Q?grp7gZpnpiLfBrUwKI4zYkVRq5Nn23kMgWHprnjEDr0a64EnRHAIpoYBipac?=
 =?us-ascii?Q?+vhoCcCurzOfVBInQJy96mNMcFbTuukwLwoUX3tp9jHd3QmqVp9QsFgE8yo0?=
 =?us-ascii?Q?HANWz8RwS8QMij3TWQ7AuxzBzjzoOU5cz6T3lGCmrR9Rcv8axPvlTI52YAiH?=
 =?us-ascii?Q?7Zt6ua8/3tQ8a/Xd2OdaPwXuVcpplbUky0cTmqEslpOmBWRUSdgamw4Y/BJ7?=
 =?us-ascii?Q?mwYpf9Y9yUQQyoCiJ27TIMLSrZJwKaBGSyRI2DMn+fnwpQwaAX34Lt/pUcaV?=
 =?us-ascii?Q?hWGk1ksAABeLkWNNE60IPFR+zUvLU0oWpVqEbUl4nPH1NBuuA3+aGe3H4LLf?=
 =?us-ascii?Q?EhspPKoV+8bNEjC/73wrQC/mGet6NbwqiUl6BIdID+7ruKQQLM57fVUqkOcD?=
 =?us-ascii?Q?JXCFSW28dZH+XQHlcRk1IhoSG1Ln9WClSLqNx/euTzwVnBeh/wcN7RXsKBlF?=
 =?us-ascii?Q?WvSlJZGuKg/A2Bv+ARZQjQd0BhVHSUjYGXKYLL0YWHm8yrmM6aWSz6jPkcNW?=
 =?us-ascii?Q?SPzmqlLzWvLH+bSmShbpUWEetBeq5hiDbwACthhSaXe/JoyApfBSalYq+8dZ?=
 =?us-ascii?Q?91pxM5QJQpoY7cmY14fSY4xVoka/tMxAcvme1+axuY1WMcsPUt/UNlv01+aE?=
 =?us-ascii?Q?iag0wi6s9Zzp0hHAC7EpIbE05eksSm47Bs+OgdUk5K2Js3Zr+blJJSlarMf5?=
 =?us-ascii?Q?dhp1S5MsMU3scaGoGi5nvpZRVSegW/MouYQFbxXA/piOlALNEAL9oWNBbSaA?=
 =?us-ascii?Q?3PNOZv7F4dOSAsQLaNcknioWmXwObf5qFNZ2ibnipjnPLayssAPBy9LVUvu5?=
 =?us-ascii?Q?V+GpVmS5d1bQ1TA9PZXMnDdE0VHlxoX9rQfetX3NupLOWB+Vd3xmFta7Acne?=
 =?us-ascii?Q?r6hSeFtuSNyUx385tfBnLKVJjco6ZCrqGP163VI6vdftPZyAUTeiev9OVTsI?=
 =?us-ascii?Q?u2Dt/9XdLDAk54nPEyhjMY+T1hK5Zs/denc2VT4EqdTk6ke7B0ePgasHWsxJ?=
 =?us-ascii?Q?N/aUEf9B1SWadoSx5tHdrR4qESClN7v+KkiyG6S+Hy1OMSu+J4DRuSnC3qZv?=
 =?us-ascii?Q?sVLeevUZtYswRWe4edBmBcIAM3zH0ogtHaKSOBC0wLbPCtbk95iTSDD57Ifk?=
 =?us-ascii?Q?m5bhGdEJrH5tl5TzQtu7koDOvSdY3TPQm+dIWRwnU+QYzYjUrkDk16NDBCz+?=
 =?us-ascii?Q?gjAyC64yNaDvFalO6nnGJ2euPb5sd/o8sr9Z6e2Q1/saQo7d2Jth9lD1pXoz?=
 =?us-ascii?Q?EDYrz2H0WQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6801d1ac-bf6f-454d-f236-08df1e0579f2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 08:41:38.1159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0oe+0JTBM8HTPgQynfVX/MT2VRJG2OB1w+3jWsmgpz4WZPFNwgWpet4dq9khZwIN52LVPBrzqrrVs6vv/8S5uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7816

Hierarchical BPF schedulers need to know how many CPUs a cgroup can run on when
distributing group-wide weights. For example, fair's group share calculation
scales a group's weight by the smaller of its estimated runnable task count and
the number of CPUs in its effective cpuset (tg_cpus() -> cpuset_num_cpus()).
Without that count, a BPF scheduler can only use the machine-wide CPU count and
may give a group confined to a few CPUs excessive shares.

This patchset adds scx_bpf_cgroup_nr_cpus(), a kfunc that returns the same count
fair uses. This allows scx_eevdf to implement proper group scheduling, computing
per-cgroup shares the same way fair does, including for groups confined to a
subset of CPUs through cpuset.

Andrea Righi (3):
      cgroup/cpuset: Protect is_in_v2_mode() in cpuset_num_cpus()
      sched_ext: Introduce scx_bpf_cgroup_nr_cpus()
      selftests/sched_ext: Test scx_bpf_cgroup_nr_cpus()

 kernel/cgroup/cpuset.c                             |   6 +-
 kernel/sched/ext/ext.c                             |  22 ++
 tools/sched_ext/include/scx/common.bpf.h           |   1 +
 tools/sched_ext/include/scx/compat.bpf.h           |   7 +
 tools/testing/selftests/sched_ext/Makefile         |   6 +-
 .../selftests/sched_ext/cgroup_nr_cpus.bpf.c       |  60 +++
 tools/testing/selftests/sched_ext/cgroup_nr_cpus.c | 419 +++++++++++++++++++++
 tools/testing/selftests/sched_ext/config           |   1 +
 8 files changed, 519 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/sched_ext/cgroup_nr_cpus.bpf.c
 create mode 100644 tools/testing/selftests/sched_ext/cgroup_nr_cpus.c
