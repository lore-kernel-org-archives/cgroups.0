Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011005.outbound.protection.outlook.com [40.107.208.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC373CF032;
	Thu, 24 Sep 2026 07:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790233539; cv=fail; b=NL344KM751E8U2WiFRDuus+F8AuO2vSG8lMN16kjYqDbcMhSywfQN7FulWT93GYWMetQ5rLn5D9nS0BgpqEOWcB47m8jvy+eqOSXLz+aZPusqLRBNKTwIetfazc0fu0/dG/Ft8EUk2ppOGPQSNeq2xtwnH3vMTHv6W9SkgIa4zE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790233539; c=relaxed/simple;
	bh=hDjbenmg+oCjsBJHn7Lcef85AOBAC6Sz2muO4Dg/XF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=L9hvK0Y9yYh0ymQVHZ1NJiql6FMXLBWRVrNykm+GmHIYVZYNpMQtge0ihkADu6Js/ILTSJn63NQoMCY4Hx6R1PiB1jzhjw1sKvOIvmEsCiPD8tV1ylTaGIw4hZmhlZw7aaJPkDGJUPaTPahPH7SPxdiqUnvCY+ghlQsdOtXuabE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ti1mdKsX; arc=fail smtp.client-ip=40.107.208.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ti1mdKsX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TixWmMCRB6TskAoo7rAsH18tpyYpOje72B4eWXQiSHdPCLRaCv+0RJSY7667wx7+7yBKVVQYTClVqqPx8EGjxMpBlgp11/1QtKw50etL3xlny5JmRmbCo8LWw/o3y7+K9qDLiT+0K29aHG6mznV4gDAyTqeHVxV1H9nWuvZDdFtgYcpEcyq1GS4NVt6OyQGIMQBPCE0lMEyBi1RFp0vKxUnHToUBbiJ6u4YFSC0uj/C2L5FHalDJPZWdMHfiZT6UKc/5/NYmcXuEc4tycPQL79qLlVZXv2f+c1F3hXWAnwvFwbfKdtMBdMaVMPmzqYBZNzArRYiEaLJG+ImqlzUHnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvMEg7D9/3hCH3UG8U800lSvDw3XcWh/Ekf1wwu+TcA=;
 b=AqTcPqvvMo881q5ksWDRMmJlJ4Ym3ucro3UehVykNpKb8FHPDkaoPphw0ug+3Rgq5cNJTtagDjAQhmMu3uQlf4b0vDnZxJnJ0u/7GL6EquxtUVYFHal4j06TJC3s9Mc0BP14fa0zItlbLwtcuZQJBU3N05Y38ZPRfJyEJxCBx6IfjE+Ru72Q6FZU2mPOVe7OyFtgJUO64Gwq80VexcwHjV/1s+io09YA+mIYY52vmKvpvsJdb60bXettrY4Pr98qxaPr4ohCBFWtKQ54oh0FNYg7CykvjtdiRA8PvxKekFG9XhQZoM09ccblB+TW8hT+FRpUQDU7rYk611ClhzZzVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvMEg7D9/3hCH3UG8U800lSvDw3XcWh/Ekf1wwu+TcA=;
 b=Ti1mdKsXaowOP6pxD7BRHyg36YgNRTh2nByjrVv9Q5CRPkNtYFpeba//LWSSaCSI41fwdTIWzaUb7pknR8iFiB2T2wbLJ0KEX9BcKG0aWhLqTzInylrx0bUModZ1/4/IdD+LHQ3vejgzRKjqfJMiOl9J71rLhL37nU6Nm8RigcY=
Received: from BN9PR03CA0139.namprd03.prod.outlook.com (2603:10b6:408:fe::24)
 by DS8PR12MB333896.namprd12.prod.outlook.com (2603:10b6:8:447::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 07:05:27 +0000
Received: from BN3PEPF00022BC3.namprd05.prod.outlook.com
 (2603:10b6:408:fe:cafe::67) by BN9PR03CA0139.outlook.office365.com
 (2603:10b6:408:fe::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.17 via Frontend Transport; Thu,
 24 Sep 2026 07:05:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF00022BC3.mail.protection.outlook.com (10.167.248.215) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 24 Sep 2026 07:05:27 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 24 Sep
 2026 02:05:27 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 24 Sep
 2026 02:05:26 -0500
Received: from [10.136.33.35] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 24 Sep 2026 02:05:20 -0500
Message-ID: <587a9b32-bc54-46b9-b81e-c46a19f47e17@amd.com>
Date: Thu, 24 Sep 2026 12:35:19 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] [PATCH v3 7/7] sched/eevdf: Move to a single
 runqueue
To: Chen Yu <yu.c.chen@intel.com>, Aishwarya Rambhadran
	<aishwarya.rambhadran@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>, <mingo@kernel.org>,
	<longman@redhat.com>, <chenridong@huaweicloud.com>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <tj@kernel.org>, <hannes@cmpxchg.org>,
	<mkoutny@suse.com>, <cgroups@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <jstultz@google.com>, <qyousef@layalina.io>,
	Ryan Roberts <ryan.roberts@arm.com>, <chen.yu@linux.dev>
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org>
 <bd81bbec-ee59-401a-bec6-116196ad3a34@arm.com> <arQCykkkCnADu5ek@chenyu-dev>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <arQCykkkCnADu5ek@chenyu-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC3:EE_|DS8PR12MB333896:EE_
X-MS-Office365-Filtering-Correlation-Id: d2076868-e3a8-4b5d-15f8-08df1a0a3683
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|82310400026|1800799024|36860700016|13003099007|6133799003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6UwxFnG/jo19u4wciIzCGHH2EyOBc2B3uMzHTVqRc1ciX4M86HEE4kZQxA6oUWQX4Ro7LeKFx+DPKCRYWXvIvEBAJQ5ii899EXEyWH37h3S0dT0egl/3uUtTAY2hE0MJFhFa5pwwE0qBWysnIZ/sj4JOz2GupGSwWWF49DDTT3K4enPHT/8UOkJQB2eUvCJuMExBmRatjoM6Tqi4BveOX/g7ce1tmUmW38vkv1Rg2zci2NL3GD0KLtuWjD5bOvgknY3FmhyL0x7Kf+ql5ohUpWB7gXT5+on3zxCaQXg8gkAn+FGbm/CPRA32732y77FH7NZXtCbk6qZWmnRDnbWxC8iKI+FqKIB4E1ps2tyJNxidDAQuMt/E3MsvT0q2j1VRUXAydaSF62h04LEhq+BOOcnER2goE+Xbrxi82q+RPxZhZxzyISzhfe3c0w40ItfbNI6INcp2Simymbggk1vPXfW+KoKBFzUHuWGTajDsXsVpF1rh8gp8d2EWKUrCmeIDElSbZZYHVQtBXBq++9sZsPX02SPG7L2VhVZB9sKs5Vofy6XBmbu6et4Er+xGbYIoSJxTM2Rw5uT9lJrmwH9eq3G5Tegdwle5glOVA0wAm9pqUxgJ0Q1f08FbO9drXNbGx3VdheQwjDORYzXzBaUJ4w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(82310400026)(1800799024)(36860700016)(13003099007)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+aUHELLA8nP49KSJEUWbdieXqNZkzbBXBVLATmXRbAxNrD0XHZSId1eA+fahloJkDREvnJ89gUEHOkGFw1WmYf8l9BBNF1rR9Ddvyrj+nUYKdjuLzFDX/wg5AkdyUD7SfyJyRSFG3OGODyKGJozgoRX069n2U40TBVBiTRv4fz8TFriunXLGvqPCQBUfK9l3BMK7qxC08d4B+zx5lrjEBnp14ysXJ83kYGLRwOLG5G/+MTtYR5txYa6CJ1yf+jL8DrVfL6p1fsr7qV+iqdX+e4i4j/sEBOh6P7Fk18OVuW6G30kmko9nEZ0o7ClgKSigfbUK5sYgu6NnVBAAteGGvkfK/as1pBic/6sH3fwOkt766pOX7P4R9GLCEO94x2juSq3vtSiHxvQqrmappgSMUFjg4FOa0ff6hjiTnYJe/ErTwA5ERe9uqON+9cHvwnZ+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 07:05:27.6053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2076868-e3a8-4b5d-15f8-08df1a0a3683
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS8PR12MB333896

On 9/23/2026 10:18 PM, Chen Yu wrote:
> On Wed, Sep 23, 2026 at 07:51:35PM +0530, Aishwarya Rambhadran wrote:
>> Hi Peter,
>>
>> We have observed some schbench p99 request latency regressions while
>> comparing v7.2 against v7.3 cycle on an AWS Graviton3 (m7g.metal)
>> using Fastpath (Linux kernel performance benchmarking tool).
>>
>> The schbench suite as a whole does not show a significant regression,
>> and the results appear to be a mix of improvements and regressions
>> depending on the thread configuration. However, a few configurations
>> show fairly large p99 request latency regressions. For example,
>> comparing v7.2 against v7.3-rc4:
>>
>> message-thread:16, worker-thread:16
>> v7.2 = 662869 us
>> v7.3-rc4 = 969557 us
>> change% = -31.63%
>>
>> message-thread:64, worker-thread:4
>> v7.2 = 730453 us
>> v7.3-rc4 = 942251 us
>> change% = -22.48%
>>
>> message-thread:32, worker-thread:4
>> v7.2 = 74251 us
>> v7.3-rc4 = 56725 us
>> change% = +30.90%
>>
>>
>> So this does not appear to be a general latency degradation; some
>> configs improve while others regress.
>>
>> I also ran a Fastpath automated git bisection for the m 16, t 16 p99
>> request latency regression between v7.2 and v7.3-rc1, which identified
>> this commit as the first bad commit. The original regression was ~30.9%,
>> & the bisection reproducibility check showed ~27.8% regression with 20
>> repeats across 2 boot sessions.
>>
>> This commit looks relevant since it changes EEVDF runqueue organization
>> and is intended, in part, to address latency issues with hierarchical fair/
>> cgroup scheduling. I also noticed that there have been fixes on top of this
>> change, including 68e37487810a ("sched/fair: Fix flat hierarchy"), which
>> fixes vruntime handling and has a Fixes: 85570f10a4c6 tag.
>>
>> Given that the overall schbench result is mostly neutral while some p99
>> configurations move considerably in both directions, I wanted to check
>> whether this could be an expected trade-off from the single-runqueue
>> change, or whether the p99 regressions are worth investigating further.
>>
>> I can run additional tests or provide the full results/bisection data if
>> useful.
>>
>>
> 
> Would disabling WA_WEIGHT help? I happened to find that this workaround works
> for me to restore netperf performance (though it is a throughput score rather
> than a latency one), it seems that task_h_load() becomes much
> larger(also on sched/task_h_load):
> echo NO_WA_WEIGHT > /sys/kernel/debug/sched/features
> https://lore.kernel.org/lkml/aoxah90s0bQ4tcUW@three-body/ 

In addition to Chenyu's suggestion, I would also suggest trying out
different cgroup modes via "/sys/kernel/debug/sched/cgroup_mode" if
NO_WA_WEIGHT doesn't resolve your issue.
(P.S. Peter has a branch with some fixes for the task_h_load() at
https://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git/log/?h=sched/task_h_load
in case you can try a custom kernel build on your setup)

In my testing, I did see some regression in schbench with the default
"concur" mode for RPS metric but the "smp" mode which used the older
formula for weight calculation seemed to be running on par with the
hierarchical pick.
https://lore.kernel.org/lkml/65980119-a26a-40d6-bec8-dd597833a6e8@amd.com/

-- 
Thanks and Regards,
Prateek

