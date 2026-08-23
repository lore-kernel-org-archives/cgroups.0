Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAE925D53B
	for <cgroups@vger.kernel.org>; Sun, 23 Aug 2026 13:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787491768; cv=fail; b=mrmSFpEqctdJOK1xHEzz5E6qWyIbpCjigvdBTv3RqmoYqMZ9aZs/pD/CoXj8MbG828HVsZ7wpWs1cKDyI0KOiwhEniM3tSz6dbIeNgK5GaWdBOLUw90BjB2KOWEYyNHi5/ijCyyeYxXJFugFvGddeqMuFOC2lJfZlsK3gxr82rI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787491768; c=relaxed/simple;
	bh=5LqY5XSGLvlJa/03XhlhrqhM8uISt8sBcYsvnk+F+/M=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=AnGk1RYuKruMdgGRxxOJpRYqYTyWl4B3tkrvT2Id4D56WhpUNZI9N/E533M6fLnLBPN1LhlamiJcq15tfgEtriuwkzTIER/6JYd5O9+G4UJvbK42u63QkUVsCzRrouJ8gDCfiD1SHZq+2lda/okbSfdg3s/cAQH6Me4zOleqG84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QCFom7HQ; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QCFom7HQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787491766; x=1819027766;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5LqY5XSGLvlJa/03XhlhrqhM8uISt8sBcYsvnk+F+/M=;
  b=QCFom7HQ3kUPduut0ICl7cO7cuiJ/JNmMPleuVts+JBt99PzxkMFxX7W
   DGAJTQhq/IGb/mBBZZDsrHcKf0YCHlWPl0fZBk29P57puWhAX7Rt0jMCp
   U/u9W+RWm9sQQNU+ywPx8gNvnjkhViYDBm87P4oLwJc4IMfXW0mqFVB4E
   po5Tq9pQ+LM1zRWKTNmvpTSFpp8WLIQ+rUdUcRnAJmHIrSaKVk5Nli/EL
   aWCQZjdKWCC8VrGMRZT2YUIp6WwXBlvuzB8VQR9HGasv/N5xbC0cbjTI5
   dnAP5vb9Irt/qVxQKcvwp8YxxGQNwvBV1l1c9d/V8QXmT1vs8DsUdjy4t
   w==;
X-CSE-ConnectionGUID: z/uFrZYhQIiqEjqR1+5S6w==
X-CSE-MsgGUID: sHwnfC3lSpuoClkvprOm5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11883"; a="98635348"
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="98635348"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 06:29:26 -0700
X-CSE-ConnectionGUID: WMSkT75CSEam7ZmINJ17ew==
X-CSE-MsgGUID: 85XXM0pYRp6zqWawuwdl2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="263510492"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 06:29:26 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 06:29:25 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 23 Aug 2026 06:29:25 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.37) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 06:29:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IDB6So/4dlKW803SYbD/uVul9yaqIeVqk0umLwrJePUPOAt9UPtVohTnasX6eilwNdrbIb8WkYIl0wyPJUxHjrveDQxb3iiiGPF0354tjwFdLuCy4H/pV7qThYGO37iXSD0kzb8OKEI91p3aMVJ/mvnRdG4e6sN6qnVNefTbfIOUjKmFHRy7bk5vcf9oKCb2nXOcFVSZqUm8nGqeFpukFJqNtxyT5GpAbNdVh7/o9Yc/rIkLIlKCyNSq/v1UDNtCCtzeWjxeIc55Tfna3IR0MPqNSYHwKLM/Kyv6I8SthlU33S4TPH54YuUQmsnrPTOdlQK/DSCD7qI0hhFhMu5FUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0vhTsjMtgbYNipa1MmU/H672AzGX9h5dkDyzaXAAko4=;
 b=yfZ3Sv+ucMCoPlar3iXXOnJbd+bYlSaCkTaGVaRDvGdyUticwEv6TssEGslQY5G/O+UDkCq69fSI6iTnbdyCzanxvZyMaO8bxagLa6Z3/q3yyE53j8ke+CIFUsor/+JJ06fIKMIj/VM8XVGcFXfVC3CcuoLEaYTlyQWLi9Uc5kG+5bgkK93SwJyk1R8mh7GLn+ZPBie+KTZlqDnzJlesR9CW4C8lzmpGUP+BwxpWasaf7DmVaVvMfSzd8jD3vdvxh7z50Fd/gnH/dqexUA9yTJ1ga0GxcPKF61AGkavqDnmUnGP7NIffvlSnArfdL7gCXz1Zpx+dhjVJ224s2YwatA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
 by BN9PR11MB5241.namprd11.prod.outlook.com (2603:10b6:408:132::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 13:29:18 +0000
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640]) by SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640%4]) with mapi id 15.21.0339.012; Sun, 23 Aug 2026
 13:29:18 +0000
Date: Sun, 23 Aug 2026 21:29:11 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 95c1ac1fa516d2c42319c707cc17db5fe9b47223
Message-ID: <202608231238.g5Cd2zqY-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:195::15) To SJ0PR11MB5214.namprd11.prod.outlook.com
 (2603:10b6:a03:2df::22)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5214:EE_|BN9PR11MB5241:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fbed193-dba7-4c87-ecf7-08df011a8894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info: npXFtCnynGtwp7RzhVlzy+MMcZZZVB0APodu5KdpxyJzTGvSRtfe54B0rFez50PPsDhapbxTR39We+mcofL0lKCiSHgRGoic2ud16YZQynnBSSpO/Uldbc8v8nG6dyHVMNKDClSZB+Oi5A5Xi5bpr7MNAi5H8tZ3hl2/hQdymNG+aebwWFyS1ZtAr9SdjfPe4ePYvtgTIM/8HpZjKjUl2PJYLwYtghLlsSttn0y5lbWCY68QvL5Gpb9/kf4SBeutI7fJ0mYM3qJ3UyZpbUSOt6CyHsDwhcfB51AJPu4+JSqMCLdopztYQYzLcVB/6pOq593le6Xjg8BdwYAjXz4EoxrH/39hhikBPTr3WmezV60qazwl52AEpHJG5xWtzJ1qA6yrSxDNdBZxSyeMcEH2cZzwJiuV3R1cyBJOrvgAL5tORHwsc++qoYQ2OUYkAIDNDkntzOybl/zRIKYNg3t8YBUlqZ6iz4yOdiTdT44NdXtfg6wnXfMPBggbE4lM5962jYm4gw3ne7fW/34MxG7n28Y+LHkBv/51ZlXRa1+Lis3hhW+yZHgXdj+yNC6xNxAQI8Zosx2NGQpdma4Hzb7B8o5xPsBaatsn2JaCsMJTF/LrIvCUA/Q+7HzW5CddqW4WdTC44tKBInzqzU3oiYARV6AAKq8NnLOiT0h+azphTrQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KxqPD+TEpQ7yQaPwfK8h4o0V154as1bL/tbrfsE7PLuWP9J23LVq2V3ARm5r?=
 =?us-ascii?Q?bpHm34DHU7A9IDtxhXgrIoQCbL0Od3H8dJywvrDaoc3ozmCCMgfxcJFY8grX?=
 =?us-ascii?Q?7iqQ3OU8UlSAssTgzazZ0BupnBtbq8bwuOv1MmOOutyUJQQbZCCOFIecTvZ7?=
 =?us-ascii?Q?OI1BcPpzgdy3+tsphjOnfxYzNV80ts7HtnMnL9q4xj9ZLq38FtgMSRIYFHgT?=
 =?us-ascii?Q?fBZeiH39p4aHzE1TOi5Prwd0D2mDerYqOEeU2RhB58qStxEa7dHUESRmY8pz?=
 =?us-ascii?Q?Nsr5EKC9cyv1K9WzMAQ/XfCaZ4SP3Se9BzH84AJjOm3ao4rZTCbxiXITxvjj?=
 =?us-ascii?Q?pUpdCXopxszfchMb+T0RTF1/VM0gCM/lyGakN038hDWI/npYcFKCTav4+u2j?=
 =?us-ascii?Q?NWS02zZ49ZtrZtoS9wqn0POKnyurqNKp63Yb6MzC5uO8pOxhdtN/MGFUwDvn?=
 =?us-ascii?Q?5NCk87m8mqsd6Fsg+exr7L86u3LQwrayx/fXGmM5kUxoubVF8Vd+kPvR2a6/?=
 =?us-ascii?Q?irMy0R1wT2R3WnVC8wJhPu8B0k3Dh70ElqwylPP6pgH10MWRvS/NGRuCTt+8?=
 =?us-ascii?Q?+OGfxZOIS9kkItEVHXm+Awi2qw1kXeod5cPwIqWQbx2mCsQsJhD7kg9hG10T?=
 =?us-ascii?Q?0uquQmdXDu6o/qwq/jYlavHSUfowLUWyqCUtiC1bZ26DIYXAbUetUG640GKE?=
 =?us-ascii?Q?34LCUQ3QzOAmdaXcTwfGp3wDidVwRZ3haMW7eCMoqWoY2j8XiphTFwZjzGmH?=
 =?us-ascii?Q?5HVgSgqfHUB44SnIIswsmD2M6sGiwccvadhd1ZKXWm+FlQ9fj/VAVyP+HvYY?=
 =?us-ascii?Q?d1FWxKQs2wkDiflbFMXXDMb+c3o4qUbfqPIescHw3ih/op/1FomlUeUq13fI?=
 =?us-ascii?Q?+jXVwG/a+z29SkB/trKJdMREZlDnhtTgeS7DZVqhTbEGHB8KA/yvqDzethTc?=
 =?us-ascii?Q?6wx3vFfHwCAH3nKuP7biy4sOz0d1i9OyVt0GOMzDR88LH+c1WnrtUEjF4v9e?=
 =?us-ascii?Q?3FyCXZeSbDoBm9ekyPpZJVPPmQ/bL6+uzbsJOz1yVce6sQEKgbEFYF3phAqb?=
 =?us-ascii?Q?zcG8l9RL6iw4r6rEa2rdbcqjnM1uRVM0o/hPmau/gwcg4vUW/yAmngRDS1No?=
 =?us-ascii?Q?cnhgmh+e5UTCdKT+K+kyhbITaxpfB0Cw7YMoWfJAGKNs0erPPLJMt2i69nAw?=
 =?us-ascii?Q?n1assmCDDVs5xrAlOXAqZCatRq2BcQZx3E4nHmKdR/c1EuIAOO02wXN7L6ZA?=
 =?us-ascii?Q?8ApCR7Zofbp5VdPQz3tjFf5Aqwlus+i1+68NnYRORIxoTIF0cjF54BzsAdpi?=
 =?us-ascii?Q?7cxYnvtgzH0VsVqc6GS0bKNNCivtBIPDXYkxDulvGMLpK/CZKUSxts1GpLLC?=
 =?us-ascii?Q?r7JaBCimX+aaVGKNBV3HWH813Tx7uDDTDj0/QCV1RpEEH+PHu7j4yMTpHnLK?=
 =?us-ascii?Q?JBgn8k80ri58d6wn62sLGYp4k8b+uJQ3fo81gaf/muwMFL6JaRB0INipV0Fg?=
 =?us-ascii?Q?SZudr6JH1eBBxylqbttAhvRRr9CV4ale/IHOpwYYbsO4czjv66Oj+flXyP3t?=
 =?us-ascii?Q?KfGkq/41OuMrWn8hkfRL79/BC1P6CQw1O57DmQKEE+FW7iJLr4TqjXQ8h5Ab?=
 =?us-ascii?Q?Z60qudN2e5s2m46spGcEJdJipRvYFB8OquTXDtF9VwRGysItm78L18RTwgzf?=
 =?us-ascii?Q?V22gz/VUgSgKx8eiSFIpskS1gwT4E3G84+SIe3GjSLqvvwNIXvBpfdNcuceA?=
 =?us-ascii?Q?YOku4KdsiA=3D=3D?=
X-Exchange-RoutingPolicyChecked: o70gaE+wLwSMOeQnwnNGNXhpbcRZBiC7qT6snql0rZtY+0JtMeqVCcBGmdoaBQXr46hRIYbh8Igv9tongp9f/13EbEQQEfQebaUS4GYYCaSgeq3eagaeWftizwre5Xnom90g5f20QwvQjQtoBrzaPjUMwsSE3HexZ54KVMgnVsUgquv/U/AfpwF/ZaUNV3MePPZbBeDjb040C+RKjuAmx6SpmiV6FyLAfRO8gkxa7KZOwcZ+maCaGqzYRB+QVSyxzp+BsX1kK+3uAgJuuO52MfKziZ+BtpgNqAYgaN3uxX/uqh420gTejP3Q4TM/o2dG+dLjyyyIpIuhp69JSkXXAw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fbed193-dba7-4c87-ecf7-08df011a8894
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2026 13:29:18.4480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T8L2Ptu9MDpB5+3szoQggCH6QVEPvGewCo/CTiev0wfdxLkaM27jH71wQNSMksRjMs7OwllCqdqmArrK1/lxew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5241
X-OriginatorOrg: intel.com

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 95c1ac1fa516d2c42319c707cc17db5fe9b47223  Merge branch 'for-7.3-fixes' into for-next

elapsed time: 1477m

configs tested: 213
configs skipped: 7

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                nsimosci_hs_smp_defconfig    gcc-16.1.0
arc                  randconfig-001-20260822    gcc-10.5.0
arc                  randconfig-001-20260823    clang-24
arc                  randconfig-002-20260822    gcc-10.5.0
arc                  randconfig-002-20260823    clang-24
arm                  randconfig-001-20260822    gcc-10.5.0
arm                  randconfig-001-20260823    clang-24
arm                  randconfig-002-20260822    gcc-10.5.0
arm                  randconfig-002-20260823    clang-24
arm                  randconfig-003-20260822    gcc-10.5.0
arm                  randconfig-003-20260823    clang-24
arm                  randconfig-004-20260822    gcc-10.5.0
arm                  randconfig-004-20260823    clang-24
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260822    clang-24
arm64                randconfig-001-20260822    gcc-14.3.0
arm64                randconfig-001-20260823    gcc-15.2.0
arm64                randconfig-002-20260822    clang-24
arm64                randconfig-002-20260822    gcc-14.3.0
arm64                randconfig-002-20260823    gcc-15.2.0
arm64                randconfig-003-20260822    clang-24
arm64                randconfig-003-20260822    gcc-14.3.0
arm64                randconfig-003-20260823    gcc-15.2.0
arm64                randconfig-004-20260822    clang-24
arm64                randconfig-004-20260822    gcc-14.3.0
arm64                randconfig-004-20260823    gcc-15.2.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260822    clang-24
csky                 randconfig-001-20260822    gcc-14.3.0
csky                 randconfig-001-20260823    gcc-15.2.0
csky                 randconfig-002-20260822    clang-24
csky                 randconfig-002-20260822    gcc-14.3.0
csky                 randconfig-002-20260823    gcc-15.2.0
hexagon              randconfig-001-20260822    gcc-16.1.0
hexagon              randconfig-001-20260823    gcc-16.1.0
hexagon              randconfig-002-20260822    gcc-16.1.0
hexagon              randconfig-002-20260823    gcc-16.1.0
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    clang-22
i386       buildonly-randconfig-001-20260822    clang-22
i386       buildonly-randconfig-001-20260823    gcc-14
i386       buildonly-randconfig-002-20260822    clang-22
i386       buildonly-randconfig-002-20260823    gcc-14
i386       buildonly-randconfig-003-20260822    clang-22
i386       buildonly-randconfig-003-20260823    gcc-14
i386       buildonly-randconfig-004-20260822    clang-22
i386       buildonly-randconfig-004-20260823    gcc-14
i386       buildonly-randconfig-005-20260822    clang-22
i386       buildonly-randconfig-005-20260823    gcc-14
i386       buildonly-randconfig-006-20260822    clang-22
i386       buildonly-randconfig-006-20260823    gcc-14
i386                          randconfig-001    clang-22
i386                 randconfig-001-20260822    clang-22
i386                 randconfig-001-20260823    gcc-14
i386                 randconfig-002-20260822    clang-22
i386                 randconfig-002-20260823    gcc-14
i386                 randconfig-003-20260822    clang-22
i386                 randconfig-003-20260823    gcc-14
i386                 randconfig-004-20260822    clang-22
i386                 randconfig-004-20260823    gcc-14
i386                 randconfig-005-20260822    clang-22
i386                 randconfig-005-20260823    gcc-14
i386                 randconfig-006-20260822    clang-22
i386                 randconfig-006-20260823    gcc-14
i386                 randconfig-007-20260822    clang-22
i386                 randconfig-007-20260823    gcc-14
i386                          randconfig-011    gcc-14
i386                 randconfig-011-20260822    gcc-14
i386                 randconfig-011-20260823    clang-22
i386                 randconfig-012-20260822    gcc-14
i386                 randconfig-012-20260823    clang-22
i386                 randconfig-013-20260822    gcc-14
i386                 randconfig-013-20260823    clang-22
i386                 randconfig-014-20260822    gcc-14
i386                 randconfig-014-20260823    clang-22
i386                 randconfig-015-20260822    gcc-14
i386                 randconfig-015-20260823    clang-22
i386                 randconfig-016-20260822    gcc-14
i386                 randconfig-016-20260823    clang-22
i386                 randconfig-017-20260822    gcc-14
i386                 randconfig-017-20260823    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260822    gcc-16.1.0
loongarch            randconfig-001-20260823    gcc-16.1.0
loongarch            randconfig-002-20260822    gcc-16.1.0
loongarch            randconfig-002-20260823    gcc-16.1.0
m68k                      m5249evb_defconfig    gcc-16.1.0
mips                         eyeq5_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260822    gcc-16.1.0
nios2                randconfig-001-20260823    gcc-16.1.0
nios2                randconfig-002-20260822    gcc-16.1.0
nios2                randconfig-002-20260823    gcc-16.1.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260822    gcc-15.2.0
parisc               randconfig-001-20260823    gcc-10.5.0
parisc               randconfig-002-20260822    gcc-15.2.0
parisc               randconfig-002-20260823    gcc-10.5.0
powerpc              randconfig-001-20260822    gcc-15.2.0
powerpc              randconfig-001-20260823    gcc-10.5.0
powerpc              randconfig-002-20260822    gcc-15.2.0
powerpc              randconfig-002-20260823    gcc-10.5.0
powerpc                    tqm8560_defconfig    gcc-16.1.0
powerpc64            randconfig-001-20260822    gcc-15.2.0
powerpc64            randconfig-001-20260823    gcc-10.5.0
powerpc64            randconfig-002-20260822    gcc-15.2.0
powerpc64            randconfig-002-20260823    gcc-10.5.0
riscv                         randconfig-001    clang-24
riscv                randconfig-001-20260822    clang-17
riscv                randconfig-001-20260823    clang-24
riscv                randconfig-002-20260822    clang-17
riscv                randconfig-002-20260823    clang-24
s390                 randconfig-001-20260822    clang-17
s390                 randconfig-001-20260823    clang-24
s390                 randconfig-002-20260822    clang-17
s390                 randconfig-002-20260823    clang-24
sh                                 defconfig    gcc-16.1.0
sh                         r7780mp_defconfig    gcc-16.1.0
sh                   randconfig-001-20260822    clang-17
sh                   randconfig-001-20260823    clang-24
sh                   randconfig-002-20260822    clang-17
sh                   randconfig-002-20260823    clang-24
sh                         rsk7201_defconfig    gcc-16.1.0
sparc                randconfig-001-20260822    gcc-8.5.0
sparc                randconfig-001-20260823    gcc-10.5.0
sparc                randconfig-002-20260822    gcc-8.5.0
sparc                randconfig-002-20260823    gcc-10.5.0
sparc64              randconfig-001-20260822    gcc-8.5.0
sparc64              randconfig-001-20260823    gcc-10.5.0
sparc64              randconfig-002-20260822    gcc-8.5.0
sparc64              randconfig-002-20260823    gcc-10.5.0
um                   randconfig-001-20260822    gcc-8.5.0
um                   randconfig-001-20260823    gcc-10.5.0
um                   randconfig-002-20260822    gcc-8.5.0
um                   randconfig-002-20260823    gcc-10.5.0
x86_64              buildonly-randconfig-001    clang-22
x86_64     buildonly-randconfig-001-20260822    clang-22
x86_64     buildonly-randconfig-001-20260823    clang-22
x86_64     buildonly-randconfig-002-20260822    clang-22
x86_64     buildonly-randconfig-002-20260823    clang-22
x86_64     buildonly-randconfig-003-20260822    clang-22
x86_64     buildonly-randconfig-003-20260823    clang-22
x86_64     buildonly-randconfig-004-20260822    clang-22
x86_64     buildonly-randconfig-004-20260823    clang-22
x86_64     buildonly-randconfig-005-20260822    clang-22
x86_64     buildonly-randconfig-005-20260823    clang-22
x86_64     buildonly-randconfig-006-20260822    clang-22
x86_64     buildonly-randconfig-006-20260823    clang-22
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260822    gcc-12
x86_64               randconfig-001-20260822    gcc-14
x86_64               randconfig-001-20260823    clang-22
x86_64               randconfig-002-20260822    gcc-12
x86_64               randconfig-002-20260822    gcc-14
x86_64               randconfig-002-20260823    clang-22
x86_64               randconfig-003-20260822    gcc-12
x86_64               randconfig-003-20260822    gcc-14
x86_64               randconfig-003-20260823    clang-22
x86_64               randconfig-004-20260822    gcc-12
x86_64               randconfig-004-20260822    gcc-14
x86_64               randconfig-004-20260823    clang-22
x86_64               randconfig-005-20260822    gcc-12
x86_64               randconfig-005-20260822    gcc-14
x86_64               randconfig-005-20260823    clang-22
x86_64               randconfig-006-20260822    gcc-12
x86_64               randconfig-006-20260822    gcc-14
x86_64               randconfig-006-20260823    clang-22
x86_64                        randconfig-011    clang-22
x86_64               randconfig-011-20260822    clang-22
x86_64               randconfig-011-20260823    clang-22
x86_64               randconfig-012-20260822    clang-22
x86_64               randconfig-012-20260823    clang-22
x86_64               randconfig-013-20260822    clang-22
x86_64               randconfig-013-20260823    clang-22
x86_64               randconfig-014-20260822    clang-22
x86_64               randconfig-014-20260823    clang-22
x86_64               randconfig-015-20260822    clang-22
x86_64               randconfig-015-20260823    clang-22
x86_64               randconfig-016-20260822    clang-22
x86_64               randconfig-016-20260823    clang-22
x86_64                        randconfig-071    gcc-14
x86_64               randconfig-071-20260822    clang-22
x86_64               randconfig-071-20260822    gcc-14
x86_64               randconfig-071-20260823    gcc-14
x86_64               randconfig-072-20260822    clang-22
x86_64               randconfig-072-20260822    gcc-14
x86_64               randconfig-072-20260823    gcc-14
x86_64               randconfig-073-20260822    clang-22
x86_64               randconfig-073-20260822    gcc-14
x86_64               randconfig-073-20260823    gcc-14
x86_64               randconfig-074-20260822    clang-22
x86_64               randconfig-074-20260822    gcc-14
x86_64               randconfig-074-20260823    gcc-14
x86_64               randconfig-075-20260822    clang-22
x86_64               randconfig-075-20260822    gcc-14
x86_64               randconfig-075-20260823    gcc-14
x86_64               randconfig-076-20260822    clang-22
x86_64               randconfig-076-20260822    gcc-14
x86_64               randconfig-076-20260823    gcc-14
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260822    gcc-8.5.0
xtensa               randconfig-001-20260823    gcc-10.5.0
xtensa               randconfig-002-20260822    gcc-8.5.0
xtensa               randconfig-002-20260823    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
