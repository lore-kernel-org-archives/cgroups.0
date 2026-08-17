Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012046.outbound.protection.outlook.com [40.107.209.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73339448BB5;
	Mon, 17 Aug 2026 16:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786984519; cv=fail; b=plmSYhtnZFXGlu+9DgbeU0AAxHrrSM7K6mvuUvL3D+5tOlyDfe7rdN4QpIidXYwIMLVaeRa64h9+/H2xmPa0lHe6rVXMCyWfwb04wPVH0dvoDIeOHM/tkDYbs2Lr6Bse0Ux3Bm99x8bCc2g5CqjfLY+qpaK885kequfCIq0TZwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786984519; c=relaxed/simple;
	bh=FH5Xt1WpbW2BZCi9I8u2qZEQKuGZVwRr6BDW1MBAve0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ndGqcuV05TRNaEEw2aOd/PPeZpnoh3cawqlnRjE+ydp25r7lddra76PLFqZxC/liryR644v883feAQ+TYzaDdjAnEeTDzWib7dc3cfQxFd3nRZ/irHoXovldMQjVmLpjCIDxLVObOw3u2nyObo8ElUUCPP0oiCBxTwHpHPnNJwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sktGeAHa; arc=fail smtp.client-ip=40.107.209.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sktGeAHa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iJk0vjEoz7to5B2VveXyLt8CCdIjkZ7plV82lN64loRH9VhW+0oVTyZj+S3N4nc5+zTRgdH0HgmJ7PXUahiuoHS9fW28Zk29NxC2y6VwCCsQRSVlCOgpW5FoErj+++nqpu2DGn67pPFU+RDSASwl26Uuy78N6rh8X9+a0+S+sN5ZP225uH5MBKiGnFda8ztX8ZIxbOOx2Ad2N2MF3BcIMPoIdyTXiuypKhEZ9Giqh7HnI7swmgiPxiHbxDEmo/JQb4Wl3e59PId/1AsET3YVH2PMNPKrphmT9XiP6ftgtll0+HkrHJChILQnswbjMoF9r7/uHOXROPiH0QKB0Bam3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5D3o1R8/v6XlY7NoAP/3SE2PsX8efYF6j8932KVxVk=;
 b=Q00QZuuN3YwcOr5ERdwkYKRVpkeAzmab4O/pex/FDbXIKmqhQm0IPm+iRH7+mPbKU39IWtBrohaUviTzaxnBkdBaGOjV6NjQZOVhUEQn1ISPVRybz03tb87CW+jztAtbFoE1c8blLVgqCohzj+ne46Yv1eaXZxOLRAjiOrzG7NSLwEM7A9Clzm395DXRFiyj1ip5O5qdjdskkJ0tA+Gys0RZuzDAz47myPAtzuyJ9UBVASEP9j3lyPqvPe4GFmKixjdfoR/ge09+f7Eu8HZuEb6XtngJUcxMSO9PlSNkYr9gAeKVhoHMdxW85V9JGnVpt35SwIfR5v/CZ0Vjebrz4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5D3o1R8/v6XlY7NoAP/3SE2PsX8efYF6j8932KVxVk=;
 b=sktGeAHa8OHN/RmkSDtgCyGEU5dGquG6aiX0ca42+Au6Ca1uwjFkb2uPYJiw4Z14prVT44Xdt9UpvadLZ0442I6a/qjBo04mbFTeC+oISCV2s+cwLtDw9WdJ3cOBzOe/7N9naj6m4yKj3g6rQeXsoYKmxOae+WeiiiWM/1EcAhs=
Received: from SA9P223CA0005.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::10)
 by SA3PR12MB9179.namprd12.prod.outlook.com (2603:10b6:806:3a1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 16:35:13 +0000
Received: from SA2PEPF00003AE4.namprd02.prod.outlook.com
 (2603:10b6:806:26:cafe::20) by SA9P223CA0005.outlook.office365.com
 (2603:10b6:806:26::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.17 via Frontend Transport; Mon,
 17 Aug 2026 16:35:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003AE4.mail.protection.outlook.com (10.167.248.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Mon, 17 Aug 2026 16:35:13 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 17 Aug
 2026 11:35:12 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 17 Aug
 2026 11:35:12 -0500
Received: from [172.31.184.125] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.45 via Frontend
 Transport; Mon, 17 Aug 2026 11:35:06 -0500
Message-ID: <d690a668-7bb2-4cd1-a229-295e556d4f28@amd.com>
Date: Mon, 17 Aug 2026 22:05:05 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] sched: Flatten the pick
To: Szabina Korbai <szkorbai@linux.ibm.com>, Peter Zijlstra
	<peterz@infradead.org>, <mingo@kernel.org>
CC: <longman@redhat.com>, <chenridong@huaweicloud.com>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <tj@kernel.org>,
	<hannes@cmpxchg.org>, <mkoutny@suse.com>, <cgroups@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <jstultz@google.com>, <qyousef@layalina.io>,
	<euan@linux.ibm.com>, <huschle@linux.ibm.com>
References: <20260605105513.354837583@infradead.org>
 <fecf5eb215b4b86bec11ca47eb6b5b17f5e0fea5.camel@linux.ibm.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <fecf5eb215b4b86bec11ca47eb6b5b17f5e0fea5.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE4:EE_|SA3PR12MB9179:EE_
X-MS-Office365-Filtering-Correlation-Id: 848756fb-c0e7-4ac6-c261-08defc7d82f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|7416014|1800799024|56012099006|10067099003|3023799007|22082099003|18002099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	s8pyUXyAvTtlTbR6zfyby3ADBn+eKWsk+Id2eWYRwEgAkhu8WzarSu5f+GmtJuDadgiIhH9wxDWFPraof3eVdZ4IXiLCz62zYqetGLJCguKOJNdvvbscif42RaSMgAnNBKGwAYEWaopoS8nCGDLMZIOYae9AN0vrq6V9Q9Jl/T32ivOpmTQ1x45zfP+08GJpEO3UH5pnGwrhj0lZAP6hbhwTnI61xO+RYWoRt2Yh1kRHoANq2ZhPOaThG9m7UFILS87k79mBO6hBNAT1BpNcoVb3NXJDN5M/03AaLG/3jdpPt9E/7NdIlSJXNmuATpJHcu7YvYgkwT0Fs23+yRbfYGlDOH/VXWewSIekWY4guOPcgydBm4CC7UD30lLeWHxpU02ga+Zc+oaI6Da2fifd0cRX0SkuAYrNsSz7nutE42u92j5EJcAoagTbKYdqaMNP700Mvi0jWpsG/+hmFDltTqRdS6nfSAHKJQGwNbOBE7wSFXEvHLZytsif+CLsc5pfplrT/Ge0xqdp0d0bDCx/Qa7mdenHWQya2dJ5hG8FEHblV9jXlfhAULB6c+tbD7CBdALHnwmS37lEEN4w0CvKEo+gt7me59xpkBi77Fo1FsDfTVzrX21P47hcAMfCga8qqU5PuoO/ALz6FT03fpm6qAhOIpslCz1G0tfxzrZY25WzCS1Mnj/QS0z7PuDVO6gk6/JrAInF78QGz7QQbMruSg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(7416014)(1800799024)(56012099006)(10067099003)(3023799007)(22082099003)(18002099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eMfG7hgs4n8+Vr+ge0XL7CvbnylnloX0cKjcZytDTzIGCTerwzBlh/Y3s1NAOo6+buIbD82zd5kiaeMrtkRqmw+4kHP+RXivSAu996tyIjlIVWQ2wOpEJS0QKJOCb8wFSdTW1YVfGDjGmqyXXad9fnXmm2FYl+bPnX09hUuX1qivyBZBOz+M7qeFrWUaWD90QUVTo0wEvv1onBCS0Rb4k4aeZ7z6JkLYxTVOTJmc24SXz2xt0A0EnKzv8anDcuLyhLcpwEZIbl/lgZ1oQbpVAE/oXfvq+n4GZiqifUzLvSCY1CMThDoe6utnUHEEyCMLul5VRaCr44ZYfsKGSm/QvSXYSvZiiIlZ/WLcy9uzT70s1aMo3kMlIC0XrsIGy3C8eghk1Z9HKsiYJOjKS6yVQRInymX+Cie//SxE0KaYetNmi/fdxwjINAYCCT5Hxjqr
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 16:35:13.0610
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 848756fb-c0e7-4ac6-c261-08defc7d82f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9179

Hello Szabina,

On 8/17/2026 9:35 PM, Szabina Korbai wrote:
> Hello Peter,
> 
> We ran the same benchmarks (schbench, sysbench, hackbench) as Shubhang
> has on s390 on an LPAR running fedora 43 with 32 vCPUs.
> 
> We ran the benchmarks for each of the cgroup modes, and for the
> baseline, we chose the commit prior to the patches (f666241e6bd5 -
> sched/fair: Unify cfs_rq throttling via account_cfs_rq_runtime() ).
> 
> We have also tried running stress-ng in parallel with the benchmarks
> (set to generate 50% or 90% utilization for each vCPU).
> 
> Compared to simply running the benchmarks on their own, this has
> revealed some performance trade-offs that the move to a single runqueue
> can introduce.

Are you using tip:sched/core at commit 68e3748781 ("sched/fair: Fix flat
hierarchy") for the flat_cg numbers or did you checkout at 85570f10a4c6
("sched/eevdf: Move to a single runqueue")?

There are a couple fixes for vruntime update and Vincent's optimizations
for preemption bits which might make a difference to the overall
results.

-- 
Thanks and Regards,
Prateek

