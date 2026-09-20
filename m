Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013036.outbound.protection.outlook.com [52.101.72.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56BB3B6C14;
	Sun, 20 Sep 2026 02:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789871438; cv=fail; b=DGIzCigsc+ILsbviPKRyhuPmhcYe5EZkssz42xE6B1yCc+K97ylfQZirrGPcd8qp9vzwaFsNjrP4i4MNEGQ6QcRO8DUtG5y14sevGkQ7UIgxVDM/YfBDXZVeKBzhfcfPuAvpRyvD1nIZN1XSwaM+HZR7ZPfbIalRHo6+nfJp03A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789871438; c=relaxed/simple;
	bh=OScU3SFgfyuAFWw4H/eSZX4K0EuzVwwfA+AtFoaIrBA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RGEXczoj4huKL4WKx77Jz8bZP01yVhclycElZXfnEjYMBh5SfkVyGboZ1JdKf9/AD5Fbg2INotNFMTM1d3Rv7WEdiivgnWEQWUE+36GMuubmKKHlOB80ZHQd2vwoHX1ikhz4Xg09y7PZ6Kr9Ap4JSELkd3BIPGtLzIVfGkyNFp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=D4xb0Co2; arc=fail smtp.client-ip=52.101.72.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="D4xb0Co2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=juVTWliiadJibqw4mocRCbSEtHV2BKw4dl6WFMXPFe/VBAaFOGhKSO5jFAkLQHFtJfAzSvm2Sl1jGn504CQlHGr9CAROwqgczOBqDyT2koW5fmfFTgJSdocgJil/eMLsCRpJw8s+j+KGVxche/6FAjsfPt5G2dP0ROIQ9GlXVdmSNFbVaXMZHCOy502qPD5cgPTzBPHnDtMQysDK9xBaLycS/dMbUqerHVcL0wM5C4bm6ORJTFvO1Bo/cbKwGI0CycZjGk0BTgo3KHxWJkcU4GRabwgToNkegMd1ONg9486Y7d2kheJWgAoZxFiRexqotw2WIovyhEzzB5Ci/D5cPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wq3tj7DSXKt1P7uCyk4k0tG8NOD23YBFmr8xOyfs5iE=;
 b=KAHKO0V92SvcUF+6y1zU+/EK3dWTOUEI57Dddc36pdpww5CA/iR3O0vqTUBerSHqNkaDMhPAqgvUOB6mBW6I0288yxLfh04rDRhiB4gNMYPESu0W0znNvhbptAaheLXs7690LAMGKR9kHojiyNJFXpUmzJTq7NOzgam2GzNDWGrhD0idNoW2sGDv+flNy7HTbWITNdjA2K2J/hCR6/tM74mEt5WgEYNlabcGAb2dJJdSNnlf7im3jOmg7WH/Wz70snfogazPXjS7yROvUbuE3LLcOdM/4JkZjMdppVknppXpwlVtiVGq874d0UzwvoYjttiESFQuocPKx+Jo7oIi8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wq3tj7DSXKt1P7uCyk4k0tG8NOD23YBFmr8xOyfs5iE=;
 b=D4xb0Co2TrIjDeITOuHyQ7bhzfEHU0R8VUIblaGr931C0jNQ/zJAZmjm8im8X31dKHkst2k6TqDSNQYMjGDl5pE5Dtki0qZFBcp0yF9l1w++J9d5B4WqczUjD9GWuqlri+cXYstmVvxCgGzj/zaOctjM/xXgR6nWutEcuJCJrZkkfCJRcl243ZR3Px6Pdm1pCSAdTysP4lP7vqQO2VJcVu3i3Aqmw79cwh8WWayoY3ElHZ3zq5wQ0A2yI9VdM9Z3/I34DV0C4URmDwjj0J16KYGD04paFx2CdPwO5kwtDstOXx5gygK3F0TtJNEm4/QXZoZdk3Mgq1gHWPQATBa+UA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by PAXPR04MB9596.eurprd04.prod.outlook.com (2603:10a6:102:23e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Sun, 20 Sep
 2026 02:30:08 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.014; Sun, 20 Sep 2026
 02:30:08 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	cgroups@vger.kernel.org
Subject: [PATCH] cgroup: use assign_bit() where applicable
Date: Sun, 20 Sep 2026 10:27:37 +0800
Message-ID: <20260920022738.3145820-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|PAXPR04MB9596:EE_
X-MS-Office365-Filtering-Correlation-Id: d1486f3a-edd9-42ec-0e1f-08df16bf1644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|19092799006|366016|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	eGeQFeKLOwHMkCcQRjgIvOgynKo865jF8Q2IeRyW2Y5F7KGdmgSSQYzYj61kqfiEftoQsVwLgVedpm+YKxrJEO8AAKdsMKMCT2mI0+nBLCzyhLW3G5cv8UIxGVl3YxfntvYkSXIPQ5gLSFPQ1sdouhdL/7RWmth3TO++uabPNhC+Bj2VwBLtYvEwQ4EtIEnKoVpgqYKnkhv3WpFm3GLIuZAqv/mUxhckvyjKXjg07YtPsmFCZcvh7UMNsi0SNnGj2i6lsDJpKhD9rtUa1Xf5ec72o7R8AcOEYcHp16W9KFs8eas8SB/TwRBT5KxL2+dbSVbfAUZIK5Ms5seRERUXvj/wlFKtxjDFTPsFsY2wid2E6+tULqu1XWpF5MHf+pEAzM9xIJNd8ggVUhnKTg9FgImsGSsW8agvTodAU9qMFFNnzdNYuynuA0RBa9yMtBVH2X8zsCzZHekWSiuADOUaTfpfjq2j9P+rA4YyXb7LkGl4zcKN6PahhrJlCjWWN5AHZm2eLM4rVXmE/Vp+HWLUb2hsgfp5nSkV9+T+ppQhOuponFQgv5+9OzjuLSsKpgt7xn0YlSC5oGqsP8PcJvPqFPH4m08XMcfFQwBfyukvtWlRo5IultaIQZNF6wE4Cobl1JNzaRAgJv4sxa8d49doACt8jx4FSw3Yyi8rpWurksA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(19092799006)(366016)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DfjZ2L8aaomKRaKWEkaYZlbt62rCkoqwgFIo9j/5ZXS86O+KfAcLd3NYQoiN?=
 =?us-ascii?Q?5dJF7Aii8Hjr8d6Cfop61yKlo1kTK784IbP9lUIPpavTZ+xqJe2LECqA6hK3?=
 =?us-ascii?Q?geJU9nm9b4phs3CdkY1PVnTyePcAGC1hwvm1Wa71e2T9wCFy3WPVx3F+I2FB?=
 =?us-ascii?Q?Ay5M+uwdqSeTLwxGqOS5RJr3ypDnTd5KZd+gquz1piK5aewk5cSnAnlkvGne?=
 =?us-ascii?Q?0nWZ/P8IK5u9JiNrZDSoGW57gZ4mJS94JJUsychj4OVUtjrnb746upsZ8EX6?=
 =?us-ascii?Q?TbG3W/+9SaG9s1zsWvNI59S4p4uSjfpJTk+6rQbquVHnnvcQXsz88qtBwWD5?=
 =?us-ascii?Q?3EO/BZaGxDlNXVRd0gYIWutOlIp5IRS6WTnm/Le3xzoGUnzlj5nd2ROXKZFs?=
 =?us-ascii?Q?gFRIhZWegEOWBr71GF6HJB//ZROgVjQPbJk0CbH+IOnqkcJvztC3AcJ5yzyF?=
 =?us-ascii?Q?hsb4rYqXDSxV+GBEvxn/3/BnSPym3RkHjXnTjMQnfZIGkqLplYwjuMBaPZCh?=
 =?us-ascii?Q?yZDcqKqo65CZ2fNU8TRTk7If7uyubjRDY/SBdAxKsKQRFc05ihbhFdolmJ0s?=
 =?us-ascii?Q?WgxrvzAaarJo5J+cg03EnqfGqBEkqV1mjzeEOrcrsbdvttipqeOLjhS7eZU7?=
 =?us-ascii?Q?x+7+gketn3y+yKq7j3drNeczoo3DdyAbShzRHsYXepfT7Dzb8xpJTAzC9cYZ?=
 =?us-ascii?Q?2gdJRqnA/U0yTxDYdH7O9AsQvBHwoLi7HSy8LQ/WoxtR0QZ/WZRras03xaEG?=
 =?us-ascii?Q?cZ4b/1NFFEOIe3ymLnJm5sag5Wjpc6Mp2EBxTJVev09Zg5QwVB1qd/P4RQ+Q?=
 =?us-ascii?Q?+2014UM+WBIYoJtjnMNfw7TjnElNXg5qT0QgZnHPA77qF/UbrTO5DOaV5kXd?=
 =?us-ascii?Q?LCA1PrqI2H8JZaDGiMPnuxhwMjh8lsyzR1rYflSaxI72Yq2wUACPOBGdp0AD?=
 =?us-ascii?Q?qmF7hGYjkS50bfq4C0Pp2BPXopyk4/TxGwm75q+SkvY581wnW6CEK7NJoTsc?=
 =?us-ascii?Q?6hW94Qb27QUt40S18RbqgMfivx3F9qi4D+GpuWfqskgJD3QAsmJoQsBKg3Cf?=
 =?us-ascii?Q?wdi3lWXJc/cnKEpcYM+VrcPp96Qc1OSr+NKjRnyu7+lGAI2LtRFMb2KcLAfo?=
 =?us-ascii?Q?xMCPkbbjxJIeWNsPMJ0uNjmrnuTOI6bVuRw6+4R6+eoRAoIRjGL9bK05kPfE?=
 =?us-ascii?Q?L49yq/Ft9SpA93BtErn9UvEcBM2I4IXVscW8xmQvfhi1IwmlXCCW1DEaN2J2?=
 =?us-ascii?Q?zYwrsLEZerAkn61SpN4EiM5gICGCMUgpPrfnKLdAy0+pY0E/+TIH/bvrKvda?=
 =?us-ascii?Q?eb4i6M3lw3FNSRxuf9jghG0rBZuJ9zpftJ2QYArpnOFbFEdw3Y+ctVuP0nS0?=
 =?us-ascii?Q?qWciQSGJO4oOoAf4gnMPDpFtRK2vx9DHTd3Z7Qo8TYrYYf1DXbIqx7Ow/w5L?=
 =?us-ascii?Q?OAHCDh3Hs76KgdLEmQWSd5yhFr9LNv0ST2rPyhw6FxbRC/mqmds09KHqeEOy?=
 =?us-ascii?Q?R8uBzxrOMC/nkMdXB91iO4nQ2m0hEOkFW9rH4rEurYh0LKJ4Dq6NsvLFbggz?=
 =?us-ascii?Q?0mC6w5B5VrelEmVrH5KJ5Uwb/qRYeo257HSPy+XuftFYhY9TikIDOlESJzRU?=
 =?us-ascii?Q?3R0V7UD9EWgLveUztr/8pUxsIpre6svnfNHB9fXdZ5qhsGrVfIr8FCR4B63F?=
 =?us-ascii?Q?654uhbskVFfeq99fh7v9g4juwYWGwGXsFt45B2sm5DRdOrvvOVGuak5R9llg?=
 =?us-ascii?Q?8MqekVZR/EGdNmMcEqZj2cIx9soxQerEfnjKRKxcCMAGAhC2pKtE?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1486f3a-edd9-42ec-0e1f-08df16bf1644
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2026 02:30:07.9680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZlEkXuW8ZrQMOBJzISut2N9IzUIEgzqzlAndUg9hITcNL+mGJ8SlJ7+0dqMlEkNFFnbiVXPuT7gT6SEnlMqRnNpYqUaP7mnwSGJOPaEfPeapZ20JJs7uCyY0aSTIVud
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9596

From: Peng Fan <peng.fan@nxp.com>

Convert open-coded if/else with set_bit/clear_bit and their
non-atomic __set_bit/__clear_bit variants to the assign_bit/__assign_bit
API.

Done with Coccinelle semantic patch:
    // set_bit -> clear_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        set_bit(bit, addr);
    -else
    -        clear_bit(bit, addr);
    +assign_bit(bit, addr, cond);

    // clear_bit -> set_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        clear_bit(bit, addr);
    -else
    -        set_bit(bit, addr);
    +assign_bit(bit, addr, !cond);

    // __set_bit -> __clear_bit => __assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        __set_bit(bit, addr);
    -else
    -        __clear_bit(bit, addr);
    +__assign_bit(bit, addr, cond);

    // __clear_bit -> __set_bit => __assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        __clear_bit(bit, addr);
    -else
    -        __set_bit(bit, addr);
    +__assign_bit(bit, addr, !cond);

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 kernel/cgroup/cgroup-v1.c | 10 ++--------
 kernel/cgroup/cpuset.c    | 16 ++++------------
 kernel/cgroup/freezer.c   |  5 +----
 3 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 167bf6555a49..6825db74abf4 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -605,10 +605,7 @@ static u64 cgroup_read_notify_on_release(struct cgroup_subsys_state *css,
 static int cgroup_write_notify_on_release(struct cgroup_subsys_state *css,
 					  struct cftype *cft, u64 val)
 {
-	if (val)
-		set_bit(CGRP_NOTIFY_ON_RELEASE, &css->cgroup->flags);
-	else
-		clear_bit(CGRP_NOTIFY_ON_RELEASE, &css->cgroup->flags);
+	assign_bit(CGRP_NOTIFY_ON_RELEASE, &css->cgroup->flags, val);
 	return 0;
 }
 
@@ -621,10 +618,7 @@ static u64 cgroup_clone_children_read(struct cgroup_subsys_state *css,
 static int cgroup_clone_children_write(struct cgroup_subsys_state *css,
 				       struct cftype *cft, u64 val)
 {
-	if (val)
-		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags);
-	else
-		clear_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags);
+	assign_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags, val);
 	return 0;
 }
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2538faac9aba..32e04bc0da64 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1216,10 +1216,7 @@ static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
 	}
 	if (new_lb != !!is_sched_load_balance(cs)) {
 		rebuild_domains = true;
-		if (new_lb)
-			set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
-		else
-			clear_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+		assign_bit(CS_SCHED_LOAD_BALANCE, &cs->flags, new_lb);
 	}
 
 	if (rebuild_domains)
@@ -2308,10 +2305,8 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		 */
 		if (cpuset_v2() && !is_partition_valid(cp) &&
 		    (is_sched_load_balance(parent) != is_sched_load_balance(cp))) {
-			if (is_sched_load_balance(parent))
-				set_bit(CS_SCHED_LOAD_BALANCE, &cp->flags);
-			else
-				clear_bit(CS_SCHED_LOAD_BALANCE, &cp->flags);
+			assign_bit(CS_SCHED_LOAD_BALANCE, &cp->flags,
+				   is_sched_load_balance(parent));
 		}
 
 		/*
@@ -2890,10 +2885,7 @@ int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	if (!trialcs)
 		return -ENOMEM;
 
-	if (turning_on)
-		set_bit(bit, &trialcs->flags);
-	else
-		clear_bit(bit, &trialcs->flags);
+	assign_bit(bit, &trialcs->flags, turning_on);
 
 	err = validate_change(cs, trialcs);
 	if (err < 0)
diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
index 6c18854bff34..35112d62318a 100644
--- a/kernel/cgroup/freezer.c
+++ b/kernel/cgroup/freezer.c
@@ -20,10 +20,7 @@ static bool cgroup_update_frozen_flag(struct cgroup *cgrp, bool frozen)
 	if (test_bit(CGRP_FROZEN, &cgrp->flags) == frozen)
 		return false;
 
-	if (frozen)
-		set_bit(CGRP_FROZEN, &cgrp->flags);
-	else
-		clear_bit(CGRP_FROZEN, &cgrp->flags);
+	assign_bit(CGRP_FROZEN, &cgrp->flags, frozen);
 
 	cgroup_file_notify(&cgrp->events_file);
 	TRACE_CGROUP_PATH(notify_frozen, cgrp, frozen);
-- 
2.51.0

