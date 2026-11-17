Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794910956;
	b=nuaK1K/nBn2oYW1JRFK6tdiNNGYrHfYlqiGuBSV3ygVUuMxcUr5sqrKioWV/8KcWWFES
	 +NrHbuQ0PTQ2IbImP1xA1C8tIS2dH5fZ1Kw9K4hp3GvcBSBHerKAxVbjmfV+d6LZp+mRb
	 TRaSF1G2346gjzrzo4IqbXKuDMtBsiK0vTM4FCiUDZtxZoqaRI6tSz8SDYgjqXn2x/WM8
	 sIa6SxOURFZs6F8ngN1eHj8gEZsJ573UDb5RTXzVnJgQWkVtc/LX3x6vpUcIMyJpIU3Ed
	 dHLWdJTLfjiDIiDKFE/mmQBk9wrBFdf+o5ByUWOG1VSw8eL6lkc2dneL/tOAhmGty8Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794910956;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Aq2HfZxK57r5c8CIAtTaplQVsaI9UayBsZXE7N5Vioc=;
	b=ahbAAuKrsHr6UO7U/v3NVdp9otcKb/pM1zVsTEievfAcmoAxRkDcAeSziHd3d2MQrNVF
	 R/OXMwNio0BH4roUigNJfWDTUXwkRoQSfBViwt+Km5vC8AUfHTRIv41p6vYMvR+lfVy1L
	 P2v7jygzCg1qpyENJORMcw2QoIeTzk3E90FnSeYgGBFLl6HIgbfFM2AdP4WgyOa0cvw/s
	 Q6oh2Bn+AWGfkGwjg7r/x8smxtBPyNUFU4lvPfA2dZN3+8wQqn9QfJNL3NLoI9besk6n5
	 Z++RvCEh1Sy+bk2uIfUHX1JPlTnFHjMgCRb5a7X4Wph5h9S8cyX/W6Ejy9kWO2jUi8g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=0V4GjCUF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.5
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010005.outbound.protection.outlook.com [52.101.85.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF795606A32F;
	Tue, 17 Nov 2026 10:22:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF795606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=0V4GjCUF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h2sCR6UksDclMJx3ws4gFt5tr57E/ofkH7cxbZeNDswtKxPXhNggLq5/ECMJWxRRicPPLogYDoIacn7fUI3bJBZH6mFeVFnnrvKFVxgTHoMDA57Ad9kXczi5ZX9zsUY5Jqm29B2AXGxLt68r5J8+noPYTOlhndVKQdy+BG7YHN4VkENGQ8vfQ/Md+U370Tcw2RxYvwZGXeIrI0XTfH8EZUvVWZNtJp6hxHzIncwo7w5PgLR6TWWi9t2HMyz6YsQxGUJXJE4/b6t5RT/vq8TorScVeXPrUDLziLZ0ajSpqpiWF4qFUdf0fwtq/oNUGokZ7jglcA35Oq3bSH4Y/VAY/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aq2HfZxK57r5c8CIAtTaplQVsaI9UayBsZXE7N5Vioc=;
 b=k/VxjEDTtQHMByPFpCD0A4Jjkzc7FRUmKN8i9bf2pSzeZGCFLViuWlwuLp7hB1h8G9PT4l5iwpFq0F4Dxi/xUpDGO/INBYSrCHLWQqhHD+t2EsQDFMeNiiH7t7azvrnG0VyGwwdkdtOwfb9cBgtqoe0n2sOE/SkUjpLVXiSN/dfIkj3Qtvw7tgvo1x8Gyi7QMSke20lcgvKN4bvAAmn5CEtdikiYmEi8NmW5SPaBFgwPkNV/RdwdYLc2n3Mg2DSZtjYE+fQWleIN8ahchezrK5ih8VxHgtM461izPOigcDGdYRJIck8v5wAphDkRJ3a89caE9ks59g6IWclw7/Zv0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aq2HfZxK57r5c8CIAtTaplQVsaI9UayBsZXE7N5Vioc=;
 b=0V4GjCUFlcM1+iK8BnkJ2q2MWo5Kv9wdvhnQ7pS+yz5u4cjVW0+yCjN13AhwQsAF8efQ46atxncvRkaJZNvNkgSq3tvhnV+lyPbKd3nKNT6//oM2D3+oyE5nc/RHUy6h0DuO2l3qCs01N0cVPbswZ/Rm3iAV0NmIRSEaqW62280=
Received: from BY3PR05CA0023.namprd05.prod.outlook.com (2603:10b6:a03:254::28)
 by PH7PR12MB5594.namprd12.prod.outlook.com (2603:10b6:510:134::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 10:22:29 +0000
Received: from MW3PEPF00001652.namprd21.prod.outlook.com
 (2603:10b6:a03:254:cafe::a8) by BY3PR05CA0023.outlook.office365.com
 (2603:10b6:a03:254::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.0 via Frontend Transport; Tue, 17
 Nov 2026 10:22:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MW3PEPF00001652.mail.protection.outlook.com (10.167.249.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.0 via Frontend Transport; Tue, 17 Nov 2026 10:22:28 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 04:22:26 -0600
Received: from [10.136.43.35] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 04:22:21 -0600
Message-ID: <add0d6ee-c28d-4274-b8d1-58638abac47a@amd.com>
Date: Tue, 17 Nov 2026 15:52:15 +0530
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] core scheduling latency with idle load
To: Mihail Mihov <mihovmihailp@gmail.com>, Peter Zijlstra
	<peterz@infradead.org>
CC: <mingo@kernel.org>, <longman@redhat.com>, <chenridong@huaweicloud.com>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <tj@kernel.org>,
	<hannes@cmpxchg.org>, <mkoutny@suse.com>, <cgroups@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <jstultz@google.com>, <qyousef@layalina.io>,
	<regressions@lists.linux.dev>
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org> <avt_mdiPQ5gwAisa@lima-fedora>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <avt_mdiPQ5gwAisa@lima-fedora>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PEPF00001652:EE_|PH7PR12MB5594:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e121163-96ea-4b30-f577-08df4494aedd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700016|82310400026|23010399003|10067099003|56012099006|11063799006|4143699003|261028144727099003|261022105027099003|261021123027099003|261026140227099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ijFy5q4LflUk9pl93AgPesXP6hvx3Js30ZxhpTXDjAZ0qR9CvpDhElwAQ/ih2FadMqXM1GTtXrCm4LyxvzMhGEB772wPxYO9QqmARgZYKMKn3Z+z71F6zfWU47eC2/ed/JbFe3thzta/I+p9KbNyK0ooIUd0oN7lAZKWB2veIq8HlVBeluwwpM/4ylr6viCKF4XlgJlwltkD9oraeMywwV1X3HRkCar3sOSPNN5EOf6IEvi+zlbRFu8ljbyerArITKwm2o9Ijcj1KmWcE7cGQqcKs089OwfDfQ3OcwZOSxXKxc2sL59Kfk/EVuOMn8laxLTaDjrvb6EUTFn3HL7Z7h/tykcGvla9nT3VyOa4jxQwnnHUZS0eYkzEY2Ibwbvu78v3T3gZI3iE4Qpo73EEDPbIiJQwPml3J3K9JOmFkzx+CQfmxlqf0lRm9s441rVXPBO+G2VBA6U3yzHrv5RjTmuoHwKzmu3QbP9rViYIuxC1FdqEd2QrAhfkP8nf4zlgNg+E7NK7Nq8588e5VwtchrfpL2u62xkLjCLnfXg4eqy6equsNMoDvObu1ttIUPWclt5CauerK6XQo8HilY2wPQOkhKHC4kYXeyZdQBrHQLRvkGKaMrCdBskjc204lnz664o3wSQwL4VrJYo72GBnydclf4yV1uT30UkK6jYa+eAvY9RimHptpTnq71Zz5uinktXK0oXq8TgNqmJiB3qORQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700016)(82310400026)(23010399003)(10067099003)(56012099006)(11063799006)(4143699003)(261028144727099003)(261022105027099003)(261021123027099003)(261026140227099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SF5XajKHmlt+Oczs5Z04j2AecoNq2qM9hehJfGEDYc+Hyi/5zCivrVDdgT/NsYqhv9TpIufFQgw486MkXOr9eB8TEskVCakkzbGuzNHdhx9IBtEvbAF9rzFXhfB8/Gd1Z5pQCQOBLDR+SSVH2vnVcLdI+ZmU5H1PjKW3MchigABiKt4Xj9Qpfl4mAytbzeA7nCRd32Gw+OPkq1ONekatyk8D6plgQi17haOzyghYKTBLP3lLqzQxAppK+VCA7UJJEejMLWeJdQ3EqPajP8UMCXy/3qCj7Mp5IGiNLvhbyv80nxu3w/E9Dg/JQ9hGTUb1PGwjJrrn/u4/KWsPdsoDlwt0TSoSPzcDk5y+pRV5JmTqLWOc9qfoBiTNueiI/qhX5YkMryxmH8UkHYLKIsXRisPhXY/1+oLQB4s+uSIfaNQ0qVA4+eH0KQHuKlwqlDKx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 10:22:28.8194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e121163-96ea-4b30-f577-08df4494aedd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW3PEPF00001652.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5594

Hello Mihail,

On 11/17/2026 3:52 AM, Mihail Mihov wrote:
> On Fri, Jun 05, 2026 at 02:40:20PM +0200, Peter Zijlstra wrote:
>> @@ -14893,30 +14803,8 @@ bool cfs_prio_less(const struct task_str
> [...]
>> -     se_fi_update(sea, rq->core->core_forceidle_seq, in_fi);
>> -     se_fi_update(seb, rq->core->core_forceidle_seq, in_fi);
> 
> In case it helps: adding these two calls back on v7.3.4 brought the
> cookie p99 back to 55 us.

I can confirm I see skipped cfs_rq->zero_vruntime_fi updates for root from
cfs_prio_less() which would have previously bumped up the zero_vruntime_fi
at common ancestor.

> I don't know whether that is the right thing
> to do, only that it changes this result.

It might be since cfs_prio_less() would have compared the zero_vruntime_fi
at common ancestor but now, everything is driven at root cfs_rq.

That said, perhaps se_fi_update() could itself be optimized now with
flattened pick. Could you try below changes a try:

  (Prepared on top of v7.4-rc3; Lightly tested)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0c8af1cac2d5..3935693bdf2f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -15278,30 +15278,21 @@ static inline void task_tick_core(struct rq *rq, struct task_struct *curr)
 /*
  * se_fi_update - Update the cfs_rq->zero_vruntime_fi in a CFS hierarchy if needed.
  */
-static void se_fi_update(const struct sched_entity *se, unsigned int fi_seq,
-			 bool forceidle)
+static void cfs_rq_fi_update(struct cfs_rq *cfs_rq, unsigned int fi_seq, bool forceidle)
 {
-	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-
-		if (forceidle) {
-			if (cfs_rq->forceidle_seq == fi_seq)
-				break;
-			cfs_rq->forceidle_seq = fi_seq;
-		}
+	if (forceidle && cfs_rq->forceidle_seq == fi_seq)
+		return;
 
-		cfs_rq->zero_vruntime_fi = cfs_rq->zero_vruntime;
-	}
+	cfs_rq->forceidle_seq = fi_seq;
+	cfs_rq->zero_vruntime_fi = cfs_rq->zero_vruntime;
 }
 
 void task_vruntime_update(struct rq *rq, struct task_struct *p, bool in_fi)
 {
-	struct sched_entity *se = &p->se;
-
 	if (p->sched_class != &fair_sched_class)
 		return;
 
-	se_fi_update(se, rq->core->core_forceidle_seq, in_fi);
+	cfs_rq_fi_update(&rq->cfs, rq->core->core_forceidle_seq, in_fi);
 }
 
 bool cfs_prio_less(const struct task_struct *a, const struct task_struct *b,
@@ -15319,6 +15310,9 @@ bool cfs_prio_less(const struct task_struct *a, const struct task_struct *b,
 	cfs_rqa = &task_rq(a)->cfs;
 	cfs_rqb = &task_rq(b)->cfs;
 
+	cfs_rq_fi_update(cfs_rqa, rq->core->core_forceidle_seq, in_fi);
+	cfs_rq_fi_update(cfs_rqb, rq->core->core_forceidle_seq, in_fi);
+
 	/*
 	 * Find delta after normalizing se's vruntime with its cfs_rq's
 	 * zero_vruntime_fi, which would have been updated in prior calls
-- 
Thanks and Regards,
Prateek

