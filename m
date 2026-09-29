Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013053.outbound.protection.outlook.com [40.107.201.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9383B38B5;
	Tue, 29 Sep 2026 08:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790671312; cv=fail; b=O64QDnwSs5KgZEP9H7/VzGVJmlsFlXs/6gmobUyQ1MV2FU24eblcpwR9o7BW5mVzIQS0bSMs477SW8IRdiQX5XJwDkQq43xCZkC1jkDaF4wQDaxBT4G/hv8m3R8bvDMIJJKX9WCop/TM7FQsof5Pj7BZGVSjaBYqBIVOF1iEKx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790671312; c=relaxed/simple;
	bh=CrQ7pBK0DcLqclXlPN0QSpOAnaMbamcA3UAq7F/b/CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q8hXZp0C9aijl7MTft8ThUmw+GKL0aFYjlcOqxZxd/YDIIXb0PWOJ6iYZ+VBir5IRVTbYSPRk4uMQrbK2fKRr4Ljp3CS7JAsYn7Mui/LVvMvr1FLtk/Bs84c6N5u+B3EMd/+Ntqlp0s8XYwQt/NrUrU4O9mrEl5vUKWFAFCUXHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gtCSUv0Z; arc=fail smtp.client-ip=40.107.201.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gtCSUv0Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wZi0gmc9qy/MJxGYNi5QKFZYqKbEU81hTshgHl5R52d49ldeYCx3euOJtRkcd5F+5oWb+7atH19CaujI/MDWGrZh+RZnZJhgloU4F1Zl+PkFlTzTxy/OGXXfuMc8hXDESY1pXfxgTiNXjgRcY10g25lc/O+aHXY3vQfrJN8Q9XdN+woi5QKRMDTEVS5oD46ZxR2z6d4vz8Y5/Ih3RPBkzuNJjBNNVd2I2fl6LtR8xHRJZ+Z4V5nA82dyQCaI+07nPIr9CJRWcDLcBH2HQAc/nCtHwlzjTfWiFJYu6qeOr/M9W7AtRgFSIJaeyLo2WUt//l8LAjkO0TaN6RY1tDmEJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kw8xBeZ/DFjqRR85Y/m5XwLH32HBP5lpMZqeJk9lQY=;
 b=bR02msPz/+lbTya/PV48QhVuS5MuVbL30QHdNTTD5Ts7xZnUFzGsjIwq+nR2xBZnOT8svVtLb3u3gQUA2M2vw+Wu93E1YClPVCp/sxs0eFN1L8avW7pve7S1IDVCoVqGWn8qoUkCpZgi6HO0c9AbqoK6dEa7CPSgJJsWhjxdvKc+/ZDvgpvZrIAlXWaC4R45zgo0RWYDRhfOdr0O3CVF7rOxm0K+Cm8psLFpykNxVdW9l6MvOQ3kDtLyKbjTof0GpFARy9clSGcnRzusDHEs+6dgOMWlNSe+5dSsj6+iqeZwLM5dJGnfeypDWPPfp5DOeamAqAaTjL03wLhI+PhtGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kw8xBeZ/DFjqRR85Y/m5XwLH32HBP5lpMZqeJk9lQY=;
 b=gtCSUv0ZKC3vXBmvbUrgU01h0YhfnVvwpRHrKkWapehjyb0FWx6HNHlPI3uo8fLZa7Z41cAvV/v9pRZ319r4NO5+G+Wm9KNiqj2CsIlVO4+M66DJjOZlorQlc6tbXtL3TBsYV/rkat8rbncwHkZr/B/AyzgbI7iw4xra2+JwmRNe0mgoebkr6wnVDFWRuZLV/qRTmgDaODgTp+Jn6kWhpRgMWW7SQkGWQFqsvzWjFFXI054KIL36ncsgzMH76hsbJUdxrnna1UBSaJHJTn5uI3otW3VIjsIysTti4x6kK2LEL0gXmJA41wgnu08DwN0HEBCC0SVI2SKTVRvQ1E0Z8w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by PH0PR12MB7816.namprd12.prod.outlook.com (2603:10b6:510:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Tue, 29 Sep
 2026 08:41:47 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 08:41:47 +0000
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
Subject: [PATCH 1/3] cgroup/cpuset: Protect is_in_v2_mode() in cpuset_num_cpus()
Date: Tue, 29 Sep 2026 10:37:38 +0200
Message-ID: <20260929084124.626693-2-arighi@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929084124.626693-1-arighi@nvidia.com>
References: <20260929084124.626693-1-arighi@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MI3PEPF0000753F.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::4db) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|PH0PR12MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: dd761814-df22-473e-89c9-08df1e057f48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|11063799006|6133799003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	AbPdFljGmqy4+hxjevXtSvIaCRkWVJ2X5uEmFxDgz8a7/zYp2GHDFZwB/K/IC1vSVOSpVJJXLoXPHTv4C7oqcIQSjRmShyTa4HpwAihTfpW6BkGZUtLi0IN5MU3xjsd/ty0KNEP0Wwm9+xF3V1AcWsyr/TNPbTVM+CYtKSCDmSjc3JJrDsVgEDjbemd3ES4tJbvmVUlRbqVWYTsvUnqCLBMeAMNdy9ofdx62lVcj8S0OMxUOnKAhuMAoe9n1QczspPGrkamghNKJm0Eh3BTkK3UpkqNFeY1MPJmsHSPY7129DbauHdbyu7JQlgHC48Lukq97aon4KF474TxFBt7/kmbgGwdMl4sGkIjXtaUByKOONc0mO8zujyGWuZ04+Jmly5qzD9llvr40f1mL/oOn31+aXMHXLRs5JlR5uuywF3+CJ11pMiOqwpRK/ifoybMqgAFXSw4HTyRc3FCIcXvm0e6QwlHd+CX2+o4Hc94nn0ZnJfr1Z0yIthfdAcAkijig67t0i5pcv6oANf9syP7wFO7O77YNlPklcEO2EqjdgYHEaoSdNU5P6awDRNz4knL0yJqwK+LOTY0iNwjOAokDlXUqves6qZfXnsZqj+G2LQHSBtT7G1zx4MhQxY1YfGbmNaWbwAJ64t7mhT0Xv6mK3bscWD5C8je7y2N5U5WSumI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(11063799006)(6133799003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9PeEi9SR7Lr23CY0mQ9duZdqM15TjxvmlfLGDq0AK9p5zaZpJzCegLcpr/Q6?=
 =?us-ascii?Q?dtu62N7pJlz8M6x/9MBLSTHU4PW4WAk9sITrhpzWx1OvGqezZFijFLH9Owua?=
 =?us-ascii?Q?gCNUy0YFx3QSgj2xvPfpqq6FjBq1uCmb/ztAfhXmZFDuVMfVsC+uSrErQAk4?=
 =?us-ascii?Q?+7fY9tUfUC6oDHRM2jxwH3EQ0z4qyXsgxLxtxNIORBCviQZwdd2M3PhIOl9v?=
 =?us-ascii?Q?vcKA/nPSR9y4PI8nO7WijFUSl8roCku1rNXJ2Kv2qY0rRzI0IhcY+zu1nDlT?=
 =?us-ascii?Q?eLyBhFcCX4ef3+vBpdlK2t5rffJJBNp/kZ3tz7OqWCkB/h5b9whz0mmL0PcQ?=
 =?us-ascii?Q?Z+d577Jcm4rImn8kUyj0ZOV1vTQC4d4T0ElIKOIqqSUo0XgJbHvGVQ32gM+t?=
 =?us-ascii?Q?WoO9g8VYvItbM2DgQRpxLwKn3r2HjBpBlKYujWFQOfGGznREnv7dFEtJX+pW?=
 =?us-ascii?Q?vExDOSXz94CGWy8qaKcLt+9kVnhQydec50blenh4FhbPVNOpjBHl8QQPqllb?=
 =?us-ascii?Q?6UOpvHiacK2kLoZGCZJoybEcaKftfNDBA0aorZW3FaKS2wWz23uqgdnidTyJ?=
 =?us-ascii?Q?ZiriuTa1C5zq4KyHEmHmppgzA49Tdh0GSyNF47s3x2CC5b3RZqgE1m0IyJw5?=
 =?us-ascii?Q?ElbQ/XT5EmSpLHo++8tHLcyrAd9FomAPk9ASzc1znxVeCebIqTDeewGkeH+i?=
 =?us-ascii?Q?1xME+oXlWvISLesOVXVETRm77xk9FPQAVT1w1aqYdCzq12UDeCTGtfFLKLRv?=
 =?us-ascii?Q?caxFL+s05tbcEr1w6eRNfWtN3ZzyCqK0TSv1xnFI78RlxDk/Y4pK8BGANKEi?=
 =?us-ascii?Q?K9iPkOKDJkCaGu//y6nTrgWy03IvDPJOBIFD9TdlwEZpLuA+4Id5RKo7/pgf?=
 =?us-ascii?Q?6IgU5or0uZEgJJ9IG78LSU1uynnOR3GLrGVyzcTKwusliqaSsOcZac6nmz+h?=
 =?us-ascii?Q?LTEMDKEFN3PcOkiqBKYneb6rfIlJQUlnLfb+WBT4G531Kfl4OFhbv5ryNlJG?=
 =?us-ascii?Q?8M81UEuxSxRkr2pmtPKMinwKTJOeu/0TWDHs6DK3vgpTOz2hSBXMhbnE3rZ3?=
 =?us-ascii?Q?HkPS/j0rKSU0GZL1xMVh6XV6XRffsfkvG5EwACNhoXIKU9QdV88wu7Wzvxrb?=
 =?us-ascii?Q?pRvtMKM+tEyx3VKXCxSyAAW8iz2hkdhGVaHxTOGowADX3XwY92KK96kQ44Y9?=
 =?us-ascii?Q?lATbmtzB+xIqroSXjBd0K0i+s84vSmMqR2AvtAGUavm1vNiPtCo0T0vbS51S?=
 =?us-ascii?Q?5eFGNZ1dvsYOoQ5r9PvjvRzguxAa9M2DZDy0AfrY2TWCvng9LoQmoxw9eMKi?=
 =?us-ascii?Q?TC8K23ExefClhj1mvzPw0FOg4gB9n+lJSBAQYZxHlty1E4YLYUCN9uyDyqr4?=
 =?us-ascii?Q?O5j4+nAVB+Qf9ugN/JMZnyPWMTycdPjZuyVdOW7/c65BSZx9BA6J7ZTnHy+4?=
 =?us-ascii?Q?FX79QCoYYzw+hC8T4hCRfH+UgUvFYDVImAt5YXhiGWUEsZDHbi0acAhSs3Wq?=
 =?us-ascii?Q?v1uP1T0DLIeUZGAWFOtTEKKGkifIMSrQz6D23x8iG4ECWbUx4/A/qe4DL8gQ?=
 =?us-ascii?Q?myOO+KvUDP6iUGWCZiSC8uVNthPl5sqG73OVscHoiOEHK22DBx8oxlAfcPgV?=
 =?us-ascii?Q?9ZC+wQ7lC9gYhjoenniZBjd1SpBpORSiyoXUUlVVNViEl146F3G5tY4TfN2r?=
 =?us-ascii?Q?TUgN7l58+LJDWujQ4/gJXCOQyJI1tiNKYlwZ0T3ng2trkgvgOTB0l916JyO2?=
 =?us-ascii?Q?NURAUGgCBQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd761814-df22-473e-89c9-08df1e057f48
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 08:41:47.0138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JpsxaZFzlu5terWbTuj1zo1YnaOHa55Z2hprBiHspxGYIpPhoPu07KP5bfXCL3UyCjr0RB0CeAuwnWLN3bNdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7816

cpuset_num_cpus() enters its RCU read-side section only after checking
is_in_v2_mode(). When cpuset is bound to a v1 hierarchy, is_in_v2_mode()
dereferences cpuset_cgrp_subsys.root, which is freed via kfree_rcu()
once that hierarchy is destroyed and cpuset is rebound to the default
hierarchy. A preemptible caller outside RCU can therefore read the flags
of a freed root.

The only current caller, fair's group share calculation, runs under the
rq lock with preemption disabled, so it can't hit this. However, the
helper already means to protect itself with RCU, and upcoming sched_ext
support exposes it to sleepable BPF programs.

Take the RCU read lock before is_in_v2_mode() so that the whole lookup
is protected regardless of the caller's context.

Signed-off-by: Andrea Righi <arighi@nvidia.com>
---
 kernel/cgroup/cpuset.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index d100634fa12b7..03fa9472c0893 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4292,8 +4292,12 @@ int cpuset_num_cpus(struct cgroup *cgrp)
 	int nr = num_online_cpus();
 	struct cpuset *cs;
 
+	/*
+	 * is_in_v2_mode() dereferences cpuset's hierarchy root, which can be a
+	 * v1 root freed via kfree_rcu() on unmount.
+	 */
+	guard(rcu)();
 	if (is_in_v2_mode()) {
-		guard(rcu)();
 		cs = css_cs(cgroup_e_css(cgrp, &cpuset_cgrp_subsys));
 		if (cs)
 			nr = cpumask_weight(cs->effective_cpus);
-- 
2.55.0

