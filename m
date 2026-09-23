Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E871B3EB815;
	Wed, 23 Sep 2026 17:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182901; cv=fail; b=qzDr96M6mKuUX58yNr+7Ih6Z345nVdRW696zdR04+Br9gWADxHvaa0EiARD2a7gf8JFkS9X+Eo2C+TKpCgy1V4ELYRZMg6rxIUuNF2WoYUrczudwd9tfIFJnM1eqRoJzKTYh8XSg/MpWAQNxLLBVy+SfYEMmwIzDhA21YgkWbpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182901; c=relaxed/simple;
	bh=jx4dE8tX24PK8IS00abW6mxPIL7CtuCO8Y5TqhPdLpE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lEadJOfES6TyZXTwX7fGgDCeh+sDs3ANCQ+XJozfMH3dcrDE3k+ypYeEGEDOgucu9MX6R6yEZ5PCDdYUmT3KRlIqBY972UZans/8WxwVWwz60h2+NWoWjvxsgv20oB6c6kFjUpKQExaOZIsImCGe2nBCb1QWMfEDsTcLcQmtJj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lbipr3p7; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lbipr3p7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790182898; x=1821718898;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jx4dE8tX24PK8IS00abW6mxPIL7CtuCO8Y5TqhPdLpE=;
  b=Lbipr3p7LWuPYCPIvM/XMSeGqw6QYy8XYq7NVPeMwJHsJeGuPTst26Ht
   Qxe8fIS/726C6k1RXA4UpHPBbkKEL9JY8lEafqqKCrnhlcDA/OBGtc7E0
   obrGaTn0ZKimx3vOd1qC33i+PFWdlnTkj4U8kfssxkMBQXAGBIlrbXgZ3
   RGQfcswN2gyhEamB/NX9M/qpkeVZKhLRy0n61oPtwHVflJ9Z0KmfUDayp
   wMEGJiVI6NLVt6Rfl6TwuFG+9tCgh0GQpezw8M9E4ung6V8tQs8vu0lyL
   E15CCsQGfNSEGiuAUp+GhBtOtfsI0LcE8LTzL33LV8yRDIhBkt3aDM9Vt
   A==;
X-CSE-ConnectionGUID: 6qU5uormTq+rse8/S6U7hQ==
X-CSE-MsgGUID: DxvSKwppTXC9xwy777u+3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="94722121"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="94722121"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 10:01:37 -0700
X-CSE-ConnectionGUID: 6jn8KQEVTnG8yih/9mkczg==
X-CSE-MsgGUID: 67JCPu6aQguPRYSM/OK6xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="272286253"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 10:01:36 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 23 Sep 2026 10:01:36 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 23 Sep 2026 10:01:36 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.6) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 23 Sep 2026 10:01:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xAlkKgDBZdMg9xcCGL1nOn0EOVwkGplLE/Fnbm3peNFbWagvHHmpS9B5V1s2Za5ZzodR+s6KcRQOPI3XnLp37mPjFRCTCxU8tFYRBNcesdgTZNNkyxIo8cjnIrGQq0R34jgqBO581i3Oy9L9bk5uEL77KhfZYo9D9iU4P+F4uvOGOrbigV+SEFMGE2XDzx6ZAhHaCNZqUCIrPRZOhhHyCc0begp2TjRByuqYKn130tuHCMLJzsq9nTm99o3k7DL2dzv9RdVI9cBO1lQEZHHx2l1ErPFnRA2//T5SSqvgarn+Nv0ZZx5thWQ5757sO0n4EfuhcX2O0T4DZ2nIZvkozg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LX+Lu0wUKshBgPzSwb/qcveKTBpPrq3N7P4bEPiYszQ=;
 b=WdgouZVV+hJMVeWwN81QKyojVK1ze8YpbJzEjqoD1VecoYL3TW16FZVhxn0ctAbGNgMR0SIoplPnN/aGPZqZ7TsxEyuayXUXD4GNh5JWdhkImfV2OXk6tnpt0pWfrien9d2rr7eg89S8vFlxRHJ9sKfLYDBbUnzc47/nc/5Y8sowuS3iQcd7LBf3/gS7pro569ikuwvmN3hh31uLNX3JYX3sHSX8U0szOAF+hwp1fgIMLzrq3De1CgSg3PfON+ByPmynwvqlSwdoa3xDWYsbfOvCO28GwqrSuStiT3ChMgO/cWVgxRYokrcNkQ8Uv21fgU9KPztgTu1SWBgW1MvQuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 LV2PR11MB6070.namprd11.prod.outlook.com (2603:10b6:408:179::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 17:01:30 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 17:01:26 +0000
Date: Thu, 24 Sep 2026 00:48:10 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>, <mingo@kernel.org>,
	<longman@redhat.com>, <chenridong@huaweicloud.com>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <tj@kernel.org>, <hannes@cmpxchg.org>,
	<mkoutny@suse.com>, <cgroups@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <jstultz@google.com>,
	<kprateek.nayak@amd.com>, <qyousef@layalina.io>, Ryan Roberts
	<ryan.roberts@arm.com>, <chen.yu@linux.dev>
Subject: Re: [REGRESSION] [PATCH v3 7/7] sched/eevdf: Move to a single
 runqueue
Message-ID: <arQCykkkCnADu5ek@chenyu-dev>
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org>
 <bd81bbec-ee59-401a-bec6-116196ad3a34@arm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bd81bbec-ee59-401a-bec6-116196ad3a34@arm.com>
X-ClientProxiedBy: TY4P301CA0065.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:36a::14) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|LV2PR11MB6070:EE_
X-MS-Office365-Filtering-Correlation-Id: 21fe0e45-97a7-4cf2-76e0-08df19944e0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|6133799003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: /YhTUDFg02vn1H+uHsJbiqwAp+K6SIlyCCh4tYi5ecYOMIK/Jp6ggaBOam3mQOCBsUkkqKlbJ9j92ckCc/AVP0xiRrRNUuE+MWTyig6vvnFG8FKl6q5D1QCfQ07gRG7cCIpBd3dXHHaO+ASfTbefZvlTYheZTff8iqc91ewq+XIV44tb/9NGDZb01HoJ4jLxom76q0qMdgdnbIfhpf1G7xBzwj2mGMa8canUugETUY4fXSxiGlZQG4kPMNMKklTKAFzent1nPwgco9gJvImTeEvXdivxVfgQNnPfgun27HS/rLZ4pYPx37Am9FNzry7KzaLoheWH6cGuZ0zbYXRTNsKCa2uaRF6U+SaGJZVXS54aaCXi0gTl1ZpB5Boj+D405OCvfjlqGoKRhBNeYCDSjFl3iBLO+Uu68vuXYH90EpTxDXCM/Qca79w7T9XHheNBsZ1tDOB3mY2o4yS7Abh4eSMOG7ZA7n+bB7LykfLNP9ptM9vmvwVCil21lf78C/VX7+jheaVtBtgcPDI1pRJN688Rg5wBw06E2FrQCzumiDZrlCMkg1h/cpJ69CuTDZZSmgKnQv2Zz4lf+pc3u5fcEsTXigIAL6mUJrfCUQJGKLfVE3W7xUcOsY59VvawspCe5mhWr4LjByQDEl2UyqkZj50BwpvD7lo+b9u6rsQGT+c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FoeAx5JrhWq4ekSlC9tWhDm5Sq5K+fnqzeoBxWJJcpIU8J9uYP6Z1VhTEJv6?=
 =?us-ascii?Q?J3wQZoBbu94QSOBSuGhUhUf5zS62Msztyyv1ZPlNP6OT4uojubVtTH8SwJdI?=
 =?us-ascii?Q?Kwl3yyJaORzZTvRxwl8vxqNa4i1SPDIUDP8Le6i13poCfPcyErGmUmO46Dwv?=
 =?us-ascii?Q?RxJ0AJfoSmGWuIqh3YuxkQ0QIRW2d1Q9m7F8bafL0Mh+fa76NLQf5MeBL2G6?=
 =?us-ascii?Q?xwnqk90pQkSBQjh4le40ZAmrCa7btL+Np6MsmuT7LblHgIsXfvv/6ts94vPl?=
 =?us-ascii?Q?3HTVnJdMPwXuEiw0E4AJ05ieaC9VnoaizOJIQzVtb31ze1tPvKH89sxwA137?=
 =?us-ascii?Q?3w8XICGjQUp9ghwLoozYh/pBtPxeEOkMZ0SKwh+HJdWSvvIEYcXfIWO8suWh?=
 =?us-ascii?Q?U8LI+Gbst447uOr9s4Xm9/tNjz2qEd2LFMfVRTDiPDNo8MkVItDPB1HHagjI?=
 =?us-ascii?Q?EN/j3cOPgz9HujVht+hyRiQJchQCd8mfSwsLlgL8qcN0Et0xFQ1me/6YC0OV?=
 =?us-ascii?Q?9UJif4T4Nb7vJ2SMf//krqQ74d1suxGn70eELkJoTBclolMZZQTcB5/Yv0MG?=
 =?us-ascii?Q?MIjMUYsBnRfBDE8e0jd5FWNNT62Cd1lUb94qhS9/rxPS4lHOQR1JFbiK6lA3?=
 =?us-ascii?Q?SN7xs8cszzNjrBGCwRakVZMXYACGND9EJRbNvWJmmEJ+SnCTl03FkABCjFvA?=
 =?us-ascii?Q?o+WvF59RBHMDlQ+zHGk0kO0VvjVde7ocpYgO/rgwwetyUJfOMmixJMGWLPQL?=
 =?us-ascii?Q?O+BKz8NgVcvCWbMbS2wraX2FwyEuxahT9MUXJxUN61GF+DOoB9OShY1Q7uqE?=
 =?us-ascii?Q?vR7SBye8EJgMQGyZJaSmojqkpp0sgEW3qAlMfp2cdmlmXzQCjf3Vq0bWrDLm?=
 =?us-ascii?Q?KfrlIdpfKLLwiw8xRZoHlHQsEazISUX3OKcKs55b0pV8G4Hnjskbo5FGU4eV?=
 =?us-ascii?Q?Fw1Ist6DLTUkMFtBRICzo+kDH0MD1Jw2IptWlYLJz5c/O99smFC2zZ8MY84e?=
 =?us-ascii?Q?bGK1zAhIDip2xlZC3tQ4ITbhA/efxYdGgeN/7Mh1TkQONsK4PSnA6uh2V/NM?=
 =?us-ascii?Q?H5ktsdyCyLZDHH/6978xh//IbU5UOGyWK0qxMEdR+YG4YRx0iwEPcvtizHrJ?=
 =?us-ascii?Q?gdBNp5K0HyOrqPI+cu8kqBQ1QBNoNziVpu980gHgg9RA3VHZDkQQcFw4vUY6?=
 =?us-ascii?Q?2LeXzgyaePTO71lZerVFjum9+9RNPRoc4+TSRPHnOpCJZBYqhsozWJC3OHzy?=
 =?us-ascii?Q?uHQ5hK9YRrcJ7Hpgmo+Qn8trCvdpXHCduLtwm8BnN/0ebyr4TWSO5x6kUZUE?=
 =?us-ascii?Q?5JovZsY0dvqeqrd6NY9VyVVLy3ceCvRFLpAze2NIZPoYmnGU9b8XnRAncKek?=
 =?us-ascii?Q?/QOCromjAD92Hr10PXkgENgYgjslshSTqV9BtKDSyMogh46cyVWOGZNzEx5o?=
 =?us-ascii?Q?57Vno08Kn7eVm3+haXj3DPv4DUlRgytpdDB2lU8G53hWv9baoPdlO+o7nkqA?=
 =?us-ascii?Q?QRcS8/1sKwhEf7duhNGmqXy6ZXyXsvSQiIFB8wLycfksZG90rQ5BOwM9ILAg?=
 =?us-ascii?Q?vP1WzhkfY38j6cxfvDEkJY7kewpQQ8lIhW8bJZXN/QYFBKUc3z8RuPC9t1uI?=
 =?us-ascii?Q?1GVh9Xv1Ohz/QTqAIORhfHha0FmGxSxKSpEAbUqXOsSw4ISn+z6Zfuyk1SzE?=
 =?us-ascii?Q?+QlLsKg8ccJdUyyhEZarMZuMVtH/74ckOuVl4WWd5iL7M4qsiREOIRTfb0ni?=
 =?us-ascii?Q?z6YRYeebfQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: FEd+l/UuFuFcG2JKfEpmH1ha1js7M1kMW6gVYE7g5LvOSzTC2WMGjto316XF1Of23iy0dblbjmxF/4iAXMnHP7dLrG1d+NaCj3NlqE9RAxf/KlUCJZQKIvx+EqJti7bBmqJU9/Dp0mLEaEsd+5H1A+wbUi00SwiOnzaHsFdtg/owVdqVmxSQLg/hgA1tvXUIeS/C5mwHg41lLLtNum855mgQPKx/bp3QnCTePDfRv9mnNAD0jRrI8nnj46S/XyeiaYmAZ69jk3QzkQvtVC+jo/flQV6QNvNWtp8V3m3TjjCpvv6nI+FD5dzbueOZGF95Je+4ocBem8Ir0D79rc/Vhg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fe0e45-97a7-4cf2-76e0-08df19944e0f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 17:01:26.7067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JR4XGrNyfTuPDRPHXqaxf6ZIvYWKXLJ73CsRLJeG4nvkxEZVx5E5m+jxtIbnMbL+Ra404kOvKF4T8YVWJmDoNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6070
X-OriginatorOrg: intel.com

On Wed, Sep 23, 2026 at 07:51:35PM +0530, Aishwarya Rambhadran wrote:
> Hi Peter,
> 
> We have observed some schbench p99 request latency regressions while
> comparing v7.2 against v7.3 cycle on an AWS Graviton3 (m7g.metal)
> using Fastpath (Linux kernel performance benchmarking tool).
> 
> The schbench suite as a whole does not show a significant regression,
> and the results appear to be a mix of improvements and regressions
> depending on the thread configuration. However, a few configurations
> show fairly large p99 request latency regressions. For example,
> comparing v7.2 against v7.3-rc4:
> 
> message-thread:16, worker-thread:16
> v7.2 = 662869 us
> v7.3-rc4 = 969557 us
> change% = -31.63%
> 
> message-thread:64, worker-thread:4
> v7.2 = 730453 us
> v7.3-rc4 = 942251 us
> change% = -22.48%
> 
> message-thread:32, worker-thread:4
> v7.2 = 74251 us
> v7.3-rc4 = 56725 us
> change% = +30.90%
> 
> 
> So this does not appear to be a general latency degradation; some
> configs improve while others regress.
> 
> I also ran a Fastpath automated git bisection for the m 16, t 16 p99
> request latency regression between v7.2 and v7.3-rc1, which identified
> this commit as the first bad commit. The original regression was ~30.9%,
> & the bisection reproducibility check showed ~27.8% regression with 20
> repeats across 2 boot sessions.
> 
> This commit looks relevant since it changes EEVDF runqueue organization
> and is intended, in part, to address latency issues with hierarchical fair/
> cgroup scheduling. I also noticed that there have been fixes on top of this
> change, including 68e37487810a ("sched/fair: Fix flat hierarchy"), which
> fixes vruntime handling and has a Fixes: 85570f10a4c6 tag.
> 
> Given that the overall schbench result is mostly neutral while some p99
> configurations move considerably in both directions, I wanted to check
> whether this could be an expected trade-off from the single-runqueue
> change, or whether the p99 regressions are worth investigating further.
> 
> I can run additional tests or provide the full results/bisection data if
> useful.
> 
>

Would disabling WA_WEIGHT help? I happened to find that this workaround works
for me to restore netperf performance (though it is a throughput score rather
than a latency one), it seems that task_h_load() becomes much
larger(also on sched/task_h_load):
echo NO_WA_WEIGHT > /sys/kernel/debug/sched/features
https://lore.kernel.org/lkml/aoxah90s0bQ4tcUW@three-body/ 

thanks,
Chenyu


