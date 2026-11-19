Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.96.117
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795061252;
	b=oAqlXCjTzyY1bRP7HWuLjFrwPRhy1/v4mwv+44WxaWcxHqrbIpAVWtG4H0NtSwBenOMJ
	 TpBQGUOUX8Ds8H9FWTkPGyNjgDvig0Pfk6lJeXi3OX+1FCYsB6F0S0fHUF96m7l20LANg
	 sX1LR0TGwBg1Xaa1KXZB08siOEt3PUIiZkPjFOpSSPydHH+7h95oAmgWNtbHB4M9v8Ln3
	 b9YpX3e5RyGDiNUVAhIlLzpKi5adarnPgCqX/QVzO2wN0bfIss06/9JNQloZp/5K5M1Zc
	 56UnPasf6KS/Fnd+B1tgBf1VyT1kCZUPi0iBPcHejVLdxO5Yz2o79o3TS2kjJdYpstg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061252;
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
	bh=+eHhVVsOmO0JdoWmm4cepF93v6NHncQmzT0Cf9yDGK0=;
	b=F3gi3D9G293hEKVSk/IuuIBjuvMPakhxQeKacCY2Y6EsG8FsHIBCjkdlyPo5E32FBt+0
	 P24bYVliRxGZSaegx+L8NV2Nt1eQm1EA4o8ThL/rc8hmUrXnbdOa+uP1abrIRNcrSUKes
	 1Ox8cEDb2yYe/0iH1FJGPsf2r8JVCSuQH9hjfu4lqLZEMgJM9wnaO7gYSuq8uF/oo6Vy6
	 R0VQpgqHHTurRGc1HbCHtGib81oKMr1Xve37E12Sfy3x6rKXizRWe6S/rF7FepUmwvxov
	 Qfyx53hOxx37uFCEOG4d9dh08FVlHCa8t/ud41rDHwYTkU/MOZOybB0r9dknAtqMHdA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=atomlin.com;
	spf=pass smtp.mailfrom=atomlin.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.96.117
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022117.outbound.protection.outlook.com [52.101.96.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D6060A2619;
	Thu, 19 Nov 2026 04:07:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86D6060A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ICzKYy7uY6VWb0ZvLDgcwpzUdRKQHoHbDi12SE8y4b8QdKBBiZ9n5s/c10EGR/EcDEwC5VT1jjkj6dCbNebmw/6DKc8LU93mF1pWiPr6Y0ficPWvRgOkYjjox5FLu4+SBc+cqQ928qXvYuHlSDCKO11A8ZbgCl0eYTLttow93JaFj9ZxD0Il1g2uD1weKFl79CNNuvRkYFOT0zzz78ezwRtfO5FnyApgLi+WQPYODZa/rha+9Gn1oXvUDfg/sFiSVErDxLLAd1pLfLiUowNsesTQWrRdkRYuuPfAkRxHQn3KEVY7d9Y1udzNwaXAtubNWv+UJeGVRGsqqcSQ8ne3rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=+eHhVVsOmO0JdoWmm4cepF93v6NHncQmzT0Cf9yDGK0=;
 b=ktIFQrjQ6uZIJ7DyB26isXsq+PGAdYpvUP/Pnunzr4WLGvl6UJ30V//OTi9/LLqGGu8z568nDFNvwDnSj2swOpvij8vzgfs2Y5TNcFcuME3ScdfyM79xt0PgOOnOzQeTtDxs5RB0z1i4FVf0PRBCKwSQol09+PYBC8QKjPQcn8b4FYE6ybCmm3YpMjbOazPwzBQS/PtADKCxLgJexOQ8iCOrqP1SGZHWcXQiyxTd7+HvHo4Y5BOjHM4VhkuTnsJojO6LUhQqyCTej4y5kAEbsnas4v9UrJaXTEweKIJZViEVSPeEwyZR2MtBuikkZ7y+fIYWHLdrzpbfiNqqpdFHGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:b1::11)
 by LO9P123MB7808.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:3e7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 04:07:29 +0000
Received: from CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM
 ([fe80::beaf:db0b:23fd:822a]) by CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM
 ([fe80::beaf:db0b:23fd:822a%4]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 04:07:29 +0000
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
Subject: [PATCH v6 2/2] selftests/bpf: Verify task_setscheduler LSM hook parameters
Date: Wed, 18 Nov 2026 23:07:05 -0500
Message-ID: <20261119040705.684987-3-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119040705.684987-1-atomlin@atomlin.com>
References: <20261119040705.684987-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0005.namprd17.prod.outlook.com
 (2603:10b6:510:324::14) To CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:b1::11)
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
X-MS-Office365-Filtering-Correlation-Id: 62829ee0-f9ee-4c85-0c3b-08df45f2a0b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|6133799003|22082099003|261009223027099003|17002099007|18002099003|3023799007|921020|261021135927099003|56012099006|261026121527099003|261102125427099003|261102123227099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|261022113327099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	4qN+pUF0MIOLvN0pE4qYy8VSzYkuNkFbEk7kSKqa5jqAMpF/KmrYteOrsgsQf5sCLJkkdY5GIDzX7nBRCLwHkFoKi5j4oSa+yyDtzHpPpuqyBKmtsKLPfR9tkHOeExb6kncnK3WLAWtpMBhsRYZqx8yjBHO2sFWpNauMWSZ5WHGbAVp70bbfwoarUx1PPCZFhuHSjMGJTpcgOPuwLRlGHvMRu8yMbDcoUzpx0o4ADfhZ9NDqGk7fcKxheZ0biXOIHVoj2jFKIrOgZ59Nb9cboJf9c+BcjoDV5qsuvIenwsl2A8K9nK+3/WELJOB1HHIAgb8VbndKUnY6A5HB/6acAO5T2EVo5z5E9tDH8rOIIHRUlVirYRQsVoLTYvqf2nPLJiYeA3C3oLZAIzOWnSRHiObHx5zrhWeotOe/45jqOMLHm+rdPuXco+Kq6rYgI3nBZ7uX9jJR/07v1L3Fu6GhtcVdBHMBoQ+9I9oeqxrtaxZh6v9i2QXbkqdm1bnvnjVb27cuxnhM778+Q2XBkYRKUpt5P8e8lnnnUHIlTojQXN1SuWmofi6Yn9Tio+7AYCoNcbQiNEsDO1rv3JKVvH8keq1vZWEwZGtT5jE8e6eoJeFv3Cj8W/V2B/TBJ5gCTQzaZsCr8/ykCapHMv+8v3arpJBy9Ypf4szzh0f+Ha6HBnW4Qq9rDkSZVvlHeC5R7o85b+a4vKrZpXBiuFyT/ZNB3Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(6133799003)(22082099003)(261009223027099003)(17002099007)(18002099003)(3023799007)(921020)(261021135927099003)(56012099006)(261026121527099003)(261102125427099003)(261102123227099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(261022113327099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w8Bpb70N45bbrGBKjxZiVyzoy01kEtbK/BD92biK6/zxRzHhk0aNpTqaGb5T?=
 =?us-ascii?Q?x42TytK1fJWMmteSAARchMFqIUohNO/LRR1/HaQXwg+Al0FE09wLJLCXj0EZ?=
 =?us-ascii?Q?VUBPcFoXNjyqbVmBiuwI9c3VvkOgAJqPbjEW7FZdeYuYAQvzLNNVvyJx0z36?=
 =?us-ascii?Q?4p0CZTxfrs4+8mV0NFkIQsddVrKy7empKp41e72KV6gIbGtq9uDKAV3aT35Z?=
 =?us-ascii?Q?ELY5DqNmDWexrjS/FZPv/V13SlzT9eye62imNZiF+2mVPZ8zijV51VQJlXaw?=
 =?us-ascii?Q?fhbeF7x/wUWCPsvGUHfkr1vo7pi9XyUBGhIZxvDpw+sJqCkLa7S8rsIfnKWw?=
 =?us-ascii?Q?Su52N0H1gD+R5Yr8j1n4+kYx9kaULNt1z5lS8mowFeTeSY7GTUnPByzthVuv?=
 =?us-ascii?Q?w5J/JcLouPrJGkaTZL2bQ8aA1NylR4ZDO3Ub6Q9uAeu7Q7SnmkZW/vwTFxRw?=
 =?us-ascii?Q?AAjWGo4DsQvkSrfnGgimFrZfYa/lm3SejM4JKociM00k8Lmpm4X/5eawNGyH?=
 =?us-ascii?Q?/XmdkXknmrusvZf14Ls3viznttvgeyrZwJT47XqRNy1pFlQBB+WB6wocjG8j?=
 =?us-ascii?Q?eJFMtCAI7g0e1depFyu0UHpFXLGd0kJWp3dGK+5I/RfvYSNDcaLLZBqaQu/+?=
 =?us-ascii?Q?oZROxX5xwPDhn7pnB58BVNd2UIuWwlPshpZymbeLqVUoIqjJBQnrkcOxHR5R?=
 =?us-ascii?Q?UwcHUdlm61Ms9IBJZCY13LDkaPXyyfgDR4Sv2AonQiGaJ+MV5ycYHZNjF8T+?=
 =?us-ascii?Q?Ob1SXFol4QidjUgZM6sOlJiLAXu28elP5E7vBNKChMDVE4jM1Nq4MNZJk6v8?=
 =?us-ascii?Q?BBMT55Qz/6MgYXu0GtE6fD5f4UFrun4XxV9gIhBqcj4ipXsAUHeCiqDTYprE?=
 =?us-ascii?Q?/cN8uKPoleTMgaP0qekptupC/Spdk2sMfXlN9w+EZeLfiUxB/5JdhCTvcFjm?=
 =?us-ascii?Q?kqyJ+eLSXuBfp2Be/AMYosxoughIa9ASieB8NfTlv5LQT6nwjSqVI5u5tdHt?=
 =?us-ascii?Q?1e4GmPCvXkVKDgqkJdzbTXQk6xXFFkqZXJ6jmrI5gDkRwsb97tAxeASyn8ta?=
 =?us-ascii?Q?vD2g5NC0TqLzP1tlW0eFI1vlBdGs/DXmdaha/qyDvPVNzAtq3NI0Ze+IJ7uy?=
 =?us-ascii?Q?xdOlRNkcc8Fv4Bxa9brqwXg/rrmJ6ZeecnySXimMUkqNuVRvhPfAh0tThS2L?=
 =?us-ascii?Q?kb4Ng+cqOmEO7rrdbTsQMwJt/esYFZiG6amCHgeY2fCnfuXAYK3rlWLqG4AZ?=
 =?us-ascii?Q?RQUkoYdaJ9HGgBYjpKO/T56mGgwGfTKXItNUh1dwoqvpaN4xa8uJdKMdBG9O?=
 =?us-ascii?Q?BuhaSq8+6VPI1C6j7MKIypBqENsCrngza1y2to54dJADsBkTWpV6RLFHqnON?=
 =?us-ascii?Q?Zq9NRwPc7KAYmCHdrSmu4chzFvsN0vlJUk9d8yGWe75pHgbpvDKJ3jq3nm/B?=
 =?us-ascii?Q?dKvBC4D8m1M7ZKvESnTmeIJiN5A9goAAQuyfEXbL5v0rz8bfWn2cw3Dfb8iG?=
 =?us-ascii?Q?pCo+hCmS1EfVOhmyQAYTtqIRfhnb5GGnhaLuWHJXj3i1Plf+OyCGxQnUY6d3?=
 =?us-ascii?Q?BuuR4y+rpIj2iijdytKW9dubL6isQ2jTF4iz+SfsQssjJRY52Yn7qja07lAp?=
 =?us-ascii?Q?vrPI1AegbG4oF2w3ggoKAZFtWMibv5/U9JCTAqmYs4we5lFydt4RWn1yzWqz?=
 =?us-ascii?Q?LORsHkvAZr9G4UglsMPGxgEYzLtUWATprT1RzsWahYz4+EMwum0pwNn7Ujre?=
 =?us-ascii?Q?ajc0zuBIWw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62829ee0-f9ee-4c85-0c3b-08df45f2a0b4
X-MS-Exchange-CrossTenant-AuthSource: CWXP123MB4183.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 04:07:29.2472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dw7aPEZSWhPZNMtEN3SsYVZBsdDX6YDLKbd7fwes6CJkPygvzAca6A95LgDBqXoBHVcuhRhNl+yLWkb1g+z4Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO9P123MB7808

Extend the BPF LSM selftest to attach to the task_setscheduler hook and
exercise scheduling policy updates via sched_setscheduler(), parameter
updates via sched_setparam() and sched_setattr() with
SCHED_FLAG_KEEP_POLICY, CPU affinity changes via sched_setaffinity(),
and child timer slack updates via /proc/[pid]/timerslack_ns. Verify that
the hook observes the expected sched_attr and cpumask arguments across
each path, including the resolved scheduling policy and effective
SCHED_FLAG_RESET_ON_FORK state for parameter-only updates as well as
NULL pointers when an argument does not apply, and that returning -EPERM
denies each operation.

Also add verifier test cases confirming that dereferencing the nullable
attr or in_mask parameters without an explicit NULL check is rejected by
the BPF verifier.

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 .../selftests/bpf/prog_tests/test_lsm.c       | 164 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c       |  51 ++++++
 .../selftests/bpf/progs/verifier_lsm.c        |  49 ++++++
 3 files changed, 264 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_lsm.c b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
index c0ae813698ae..5081c243bc5e 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_lsm.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
@@ -21,8 +21,30 @@
 
 char *CMD_ARGS[] = {"true", NULL};
 
+#ifndef SCHED_RESET_ON_FORK
+#define SCHED_RESET_ON_FORK	0x40000000
+#endif
+
+#ifndef SCHED_FLAG_KEEP_POLICY
+#define SCHED_FLAG_KEEP_POLICY	0x08
+#endif
+
+struct test_sched_attr {
+	__u32 size;
+	__u32 sched_policy;
+	__u64 sched_flags;
+	__s32 sched_nice;
+	__u32 sched_priority;
+	__u64 sched_runtime;
+	__u64 sched_deadline;
+	__u64 sched_period;
+	__u32 sched_util_min;
+	__u32 sched_util_max;
+};
+
 enum {
 	INODE_IDMAP_ALL = (1U << 6) - 1,
+	SETSCHED_SAW_ALL = (1U << 5) - 1,
 };
 
 int exec_cmd(int *monitored_pid)
@@ -255,6 +277,141 @@ static int test_lsm_inode_idmap(struct lsm *skel)
 	return ret;
 }
 
+static int find_first_cpu(const cpu_set_t *mask)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < CPU_SETSIZE; cpu++) {
+		if (CPU_ISSET(cpu, mask))
+			return cpu;
+	}
+
+	return -1;
+}
+
+static int test_lsm_task_setscheduler(struct lsm *skel)
+{
+	struct test_sched_attr sattr = {
+		.size = sizeof(sattr),
+		.sched_flags = SCHED_FLAG_KEEP_POLICY,
+	};
+	struct sched_param param = {}, saved_param = {};
+	cpu_set_t mask, saved_mask;
+	char timerslack_path[64];
+	int cpu, saved_policy = -1;
+	pid_t child_pid = -1, waited;
+	bool restore_sched = false;
+	bool restore_aff = false;
+	int len, ret = -1;
+
+	saved_policy = sched_getscheduler(0);
+	if (!ASSERT_GE(saved_policy, 0, "sched_getscheduler"))
+		return -1;
+	if (!ASSERT_OK(sched_getparam(0, &saved_param), "sched_getparam"))
+		return -1;
+	restore_sched = true;
+
+	if (!ASSERT_OK(sched_getaffinity(0, sizeof(saved_mask), &saved_mask),
+		       "sched_getaffinity"))
+		goto out;
+	restore_aff = true;
+
+	cpu = find_first_cpu(&saved_mask);
+	if (!ASSERT_GE(cpu, 0, "find_first_cpu"))
+		goto out;
+
+	if (saved_policy != SCHED_OTHER &&
+	    !ASSERT_OK(sched_setscheduler(0, SCHED_OTHER, &param),
+		       "sched_setscheduler_other"))
+		goto out;
+
+	child_pid = fork();
+	if (!ASSERT_GE(child_pid, 0, "fork"))
+		goto out;
+	if (child_pid == 0) {
+		pause();
+		_exit(0);
+	}
+
+	len = snprintf(timerslack_path, sizeof(timerslack_path),
+		       "/proc/%d/timerslack_ns", child_pid);
+	if (!ASSERT_GE(len, 0, "timerslack_snprintf") ||
+	    !ASSERT_LT(len, sizeof(timerslack_path), "timerslack_snprintf_len"))
+		goto out;
+
+	skel->bss->setsched_seen = 0;
+	skel->bss->setsched_affinity_cpu = cpu;
+	skel->bss->setsched_deny = 0;
+
+	if (!ASSERT_OK(sched_setscheduler(0, SCHED_BATCH | SCHED_RESET_ON_FORK,
+					  &param),
+		       "sched_setscheduler_batch"))
+		goto out;
+	if (!ASSERT_OK(sched_setparam(0, &param), "sched_setparam_batch"))
+		goto out;
+	if (!ASSERT_OK(syscall(__NR_sched_setattr, 0, &sattr, 0),
+		       "sched_setattr_keep_policy"))
+		goto out;
+	if (!ASSERT_EQ(sched_getscheduler(0),
+		       SCHED_BATCH | SCHED_RESET_ON_FORK,
+		       "sched_getscheduler_reset_on_fork"))
+		goto out;
+
+	CPU_ZERO(&mask);
+	CPU_SET(cpu, &mask);
+	if (!ASSERT_OK(sched_setaffinity(0, sizeof(mask), &mask),
+		       "sched_setaffinity"))
+		goto out;
+
+	if (!ASSERT_OK(write_file(timerslack_path, "0"), "timerslack_ns_allow"))
+		goto out;
+
+	if (!ASSERT_EQ(skel->bss->setsched_seen, SETSCHED_SAW_ALL,
+		       "setsched_seen"))
+		goto out;
+
+	skel->bss->setsched_deny = 1;
+
+	if (!ASSERT_EQ(sched_setscheduler(0, SCHED_BATCH, &param), -1,
+		       "sched_setscheduler_deny") ||
+	    !ASSERT_EQ(errno, EPERM, "sched_setscheduler_deny_errno"))
+		goto out;
+
+	if (!ASSERT_EQ(sched_setparam(0, &param), -1, "sched_setparam_deny") ||
+	    !ASSERT_EQ(errno, EPERM, "sched_setparam_deny_errno"))
+		goto out;
+
+	if (!ASSERT_EQ(syscall(__NR_sched_setattr, 0, &sattr, 0), -1,
+		       "sched_setattr_deny") ||
+	    !ASSERT_EQ(errno, EPERM, "sched_setattr_deny_errno"))
+		goto out;
+
+	if (!ASSERT_EQ(sched_setaffinity(0, sizeof(mask), &mask), -1,
+		       "sched_setaffinity_deny") ||
+	    !ASSERT_EQ(errno, EPERM, "sched_setaffinity_deny_errno"))
+		goto out;
+
+	if (!ASSERT_EQ(write_file(timerslack_path, "0"), -1,
+		       "timerslack_ns_deny") ||
+	    !ASSERT_EQ(errno, EPERM, "timerslack_ns_deny_errno"))
+		goto out;
+
+	ret = 0;
+out:
+	skel->bss->setsched_deny = 0;
+	if (child_pid > 0) {
+		kill(child_pid, SIGKILL);
+		do {
+			waited = waitpid(child_pid, NULL, 0);
+		} while (waited < 0 && errno == EINTR);
+	}
+	if (restore_aff)
+		sched_setaffinity(0, sizeof(saved_mask), &saved_mask);
+	if (restore_sched)
+		sched_setscheduler(0, saved_policy, &saved_param);
+	return ret;
+}
+
 static int test_lsm(struct lsm *skel)
 {
 	struct bpf_link *link;
@@ -282,6 +439,10 @@ static int test_lsm(struct lsm *skel)
 	if (!ASSERT_OK(err, "test_lsm_inode_idmap"))
 		return err;
 
+	err = test_lsm_task_setscheduler(skel);
+	if (!ASSERT_OK(err, "test_lsm_task_setscheduler"))
+		return err;
+
 	err = stack_mprotect();
 	if (!ASSERT_EQ(err, -1, "stack_mprotect") ||
 	    !ASSERT_EQ(errno, EPERM, "stack_mprotect"))
@@ -302,6 +463,9 @@ static int test_lsm(struct lsm *skel)
 	skel->bss->mprotect_count = 0;
 	skel->bss->inode_identity_idmap_seen = 0;
 	skel->bss->inode_idmapped_mount_seen = 0;
+	skel->bss->setsched_seen = 0;
+	skel->bss->setsched_affinity_cpu = 0;
+	skel->bss->setsched_deny = 0;
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
index e210e07d3a37..d8ff10d4174e 100644
--- a/tools/testing/selftests/bpf/progs/lsm.c
+++ b/tools/testing/selftests/bpf/progs/lsm.c
@@ -86,6 +86,15 @@ int mprotect_count = 0;
 int bprm_count = 0;
 __u32 inode_identity_idmap_seen = 0;
 __u32 inode_idmapped_mount_seen = 0;
+__u32 setsched_seen = 0;
+__u32 setsched_affinity_cpu = 0;
+int setsched_deny = 0;
+
+#define SCHED_BATCH			3
+#define SCHED_FLAG_RESET_ON_FORK	0x01
+#define SCHED_FLAG_KEEP_POLICY		0x08
+
+bool bpf_cpumask_test_cpu(u32 cpu, const struct cpumask *cpumask) __ksym __weak;
 
 enum {
 	INODE_IDMAP_CREATE	= 1U << 0,
@@ -96,6 +105,14 @@ enum {
 	INODE_IDMAP_PERMISSION	= 1U << 5,
 };
 
+enum {
+	SETSCHED_SAW_ATTR		= 1U << 0,
+	SETSCHED_SAW_SETPARAM		= 1U << 1,
+	SETSCHED_SAW_KEEP_POLICY	= 1U << 2,
+	SETSCHED_SAW_AFFINITY		= 1U << 3,
+	SETSCHED_SAW_BOTH_NULL		= 1U << 4,
+};
+
 static __always_inline bool is_monitored_idmap(struct mnt_idmap *idmap)
 {
 	__u32 pid = bpf_get_current_pid_tgid() >> 32;
@@ -164,6 +181,40 @@ int BPF_PROG(test_inode_permission, struct mnt_idmap *idmap,
 	return record_inode_idmap(idmap, INODE_IDMAP_PERMISSION, ret);
 }
 
+SEC("lsm/task_setscheduler")
+int BPF_PROG(test_task_setscheduler, struct task_struct *p,
+	     const struct sched_attr *attr, const struct cpumask *in_mask,
+	     int ret)
+{
+	__s32 pid = bpf_get_current_pid_tgid() >> 32;
+
+	if (ret || !monitored_pid || monitored_pid != pid)
+		return ret;
+
+	if (attr && !in_mask) {
+		if (attr->sched_policy == SCHED_BATCH &&
+		    (attr->sched_flags & SCHED_FLAG_RESET_ON_FORK)) {
+			if (p->policy != SCHED_BATCH)
+				setsched_seen |= SETSCHED_SAW_ATTR;
+			else if (attr->sched_flags & SCHED_FLAG_KEEP_POLICY)
+				setsched_seen |= SETSCHED_SAW_KEEP_POLICY;
+			else
+				setsched_seen |= SETSCHED_SAW_SETPARAM;
+		}
+	} else if (!attr && in_mask) {
+		if (bpf_cpumask_test_cpu(setsched_affinity_cpu, in_mask))
+			setsched_seen |= SETSCHED_SAW_AFFINITY;
+	} else if (!attr && !in_mask) {
+		if (p->pid != pid)
+			setsched_seen |= SETSCHED_SAW_BOTH_NULL;
+	}
+
+	if (setsched_deny)
+		return -EPERM;
+
+	return 0;
+}
+
 SEC("lsm/file_mprotect")
 int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	     unsigned long reqprot, unsigned long prot, int ret)
diff --git a/tools/testing/selftests/bpf/progs/verifier_lsm.c b/tools/testing/selftests/bpf/progs/verifier_lsm.c
index 8fbf7862265f..8e2bc3040867 100644
--- a/tools/testing/selftests/bpf/progs/verifier_lsm.c
+++ b/tools/testing/selftests/bpf/progs/verifier_lsm.c
@@ -188,6 +188,55 @@ int BPF_PROG(null_check, struct file *file)
 	return 0;
 }
 
+SEC("lsm/task_setscheduler")
+__description("not null checking nullable attr in bpf_lsm_task_setscheduler")
+__failure __msg("invalid mem access 'trusted_ptr_or_null_'")
+int BPF_PROG(task_setscheduler_attr_no_null_check, struct task_struct *p,
+	     const struct sched_attr *attr, const struct cpumask *in_mask)
+{
+	__u32 policy;
+
+	policy = attr->sched_policy;
+	__sink(policy);
+
+	return 0;
+}
+
+SEC("lsm/task_setscheduler")
+__description("not null checking nullable in_mask in bpf_lsm_task_setscheduler")
+__failure __msg("invalid mem access 'trusted_ptr_or_null_'")
+int BPF_PROG(task_setscheduler_mask_no_null_check, struct task_struct *p,
+	     const struct sched_attr *attr, const struct cpumask *in_mask)
+{
+	unsigned long bits;
+
+	bits = in_mask->bits[0];
+	__sink(bits);
+
+	return 0;
+}
+
+SEC("lsm/task_setscheduler")
+__description("null checking nullable pointers in bpf_lsm_task_setscheduler")
+__success
+int BPF_PROG(task_setscheduler_null_check, struct task_struct *p,
+	     const struct sched_attr *attr, const struct cpumask *in_mask)
+{
+	unsigned long bits;
+	__u32 policy;
+
+	if (attr) {
+		policy = attr->sched_policy;
+		__sink(policy);
+	}
+	if (in_mask) {
+		bits = in_mask->bits[0];
+		__sink(bits);
+	}
+
+	return 0;
+}
+
 SEC("lsm_cgroup/file_open")
 __description("sleepable lsm_cgroup program is rejected")
 __failure __msg("Program of this type cannot be sleepable")
-- 
2.55.0

