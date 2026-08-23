Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A173625D53B
	for <cgroups@vger.kernel.org>; Sun, 23 Aug 2026 13:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787491783; cv=fail; b=K3CvIkSlSY4j/3Pc8I4lLl1bBG/6SIRXUsNpHNGmnsXiokw4k/88vQmmGS/Vw6pd8X3QehamgsQv17FI4uf8WherBBUnFrytuA3on045K+zS3jIK+AZ0ZCWLwsebmu6rj3FABkaQ5ViRRifX0K4gbjZotYXDJ+sf2J4kuLFiRnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787491783; c=relaxed/simple;
	bh=d9JuRxrrFDI2ySZyK9Fyw9o8uuD0rA9DKKb4rmB7Q/w=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=OV1Q6JS5P4pEBOSl+4WbugB5XBC8e0ib4prcRukLBI3jhq1MlBhyrUogP9QA4LwnyKThFkH5TTZ7x+eVHv+YUqUj7YI78w45Z6zzHtNO8HJMM2JekJhSuTcYNRl3ZGsHoVDHJo/R0ca8wpJ3QviKotJ6U2PwfEkmuZpCETlkCMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y3p7eJgF; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y3p7eJgF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787491781; x=1819027781;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=d9JuRxrrFDI2ySZyK9Fyw9o8uuD0rA9DKKb4rmB7Q/w=;
  b=Y3p7eJgF/Zisa42/B1icS9KjpZQHKWZ/645GEK6qaTT4v31A0/sPqLe+
   MRxO5vEmGPwK4ZdIcxWFAq5MdrGhspOUDsC8goJ3uMCr6+UTHUKSX91lO
   LZ92M3Rtid0QeKjSu1wGjk80mrP3LonV06laXNrvD3mVWOKs9lw6368R8
   BpGxnDI84b589jBxJDRtSuny+zfAk7OIvw7lH8OpHEaK3NHeI97sx33NP
   Y0qK3rJM/5HpE7npIlAdEu4IJzGgEYp/Xz+4kCkzMYvHib4mzwiJiEZDQ
   PnfgbBCr0JFLupfvjUuY06/gdK9GVM0enq1NP1d4TBniwwSnTFFeGuO4B
   g==;
X-CSE-ConnectionGUID: TpKlCtGkRqC21HnayoLYlQ==
X-CSE-MsgGUID: NIIaSZuNRXGpSAXdazWOGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11883"; a="98297936"
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="98297936"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 06:29:41 -0700
X-CSE-ConnectionGUID: bSmIxHugTR+uURuAziOUFQ==
X-CSE-MsgGUID: isTmbQT3RCasgz9SK02kGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="265470614"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 06:29:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 06:29:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 23 Aug 2026 06:29:40 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.9) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 06:29:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mLocHAIueTmh+KDvAQW2It4/GljIAe+XF4H5yB0D1KgQD+zASizpG2/5obXEeZZFFv0QTRLEbLMjTvrdy3VbvbGntSWyiN7tb5oLLKYcn9mwa0TxU0j8saLrpVzExCSRch7M6ZQxzbRG7HM9/FH1JJMPIoFInBI8DvI4bJu5Q8vayWtUx224inzuUPUB8zAaN06z6LNLMhIZlO1aYdyfpFUcijyxSVNd9sFexKaSLzWvGJtdpSrHweD+9xlfkMMCCM6+z7UdzzNqFAseCUdmf0tRA+Bsu5Ji8ysOUlYAISrAfv5kz1EESuxJ2qZp4iroE5b48g9QiPq+WvFRQVuHBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IraA2bskX/xCYWEfdKz9cXNtcWDhuJ85Hxuj2IHm3JY=;
 b=ScJpZ+ucz8/KTVs8IMqfnqaXxE9jaFO2+1a4OB9s3s0qZS9CkRsYiMb0YuQETPPfkJ92Z7oL7TvnbhUnuj1mVVHXyx+vT5Rks3hqrpqA+BJPTZ8jWBszpBLRkCwOcVq/U4W97Q7sbEMGdpyTGZLvMH+i+tdL6C0zpGRNTMqDkflGBVTTti1mOK8ZJcuxlMZ3gLalhTlwFRmA5drykeLM1fyhw3HAiMfL4u1xUYpX1ypDkcAroTxRBHJl+B1Tq35MJqwyx6/lx/k58LcIGpS+6sMkzwnkyCaQI2uedl65XTGHTf9CFUV3kjDhms115vZfZIHHrpAVS7vdZ4VAZ1wpMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
 by BN9PR11MB5241.namprd11.prod.outlook.com (2603:10b6:408:132::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 13:29:34 +0000
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640]) by SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640%4]) with mapi id 15.21.0339.012; Sun, 23 Aug 2026
 13:29:33 +0000
Date: Sun, 23 Aug 2026 21:29:26 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>
Subject: [tj-cgroup:for-7.3-fixes] BUILD SUCCESS
 a8c6daab4b0e276508b7ffdd66c60fd3020a9178
Message-ID: <202608231222.ByqxV2Sr-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR01CA0017.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::19) To SJ0PR11MB5214.namprd11.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: f73768aa-5547-41aa-4ad6-08df011a91c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info: 1+vjnuVlAZ8ronz81XPb5u7gHovbeZdWiu9lmgnkfT/XCmpEU6OISVCAj0m4vXHOJWh7vP0fYNwtw4u3BubaMGnMFdxQCvLe2ucH3wB0kPngNOjszEmu2gBNrQpP2xii9m5NamOt+7nG/kJeJHd6rmfxxUmHskTmPpvg9jMZIlk45ISKpgOf06FGOlqk95KolxOG3SrZ8mrYi54dDcXp7UWBuJWyMFJSRzjja9nZjx1vuEL7/e+wrlSpAbkhA00x7a72nd09cqeYNMbACEhxNxi4FSnQPR4VTg089/GlFbXpsm1Pm4aZXb5dzPtBfMDb8mc2RCyUMX0VqwmwyArKU/xtGxE2uiG68iFoFasmL0aqgJ3g0z8JmcLFxzQdqcP2kv4eUXOOVrGhUxOP5g1p9T0dbIbreRCrueD8bU296X5ivOmmyUOjWDTjOTGCuOUjdCF/WIoY3mSL9TjlpjplzZ3pjzdCybg5dnCU9nN0BtXQI35xb+525f2MDrHuug+dDiPiGliNW2ZTr6r8vPRfcma21J/IQQzjaYY1SXRLUk77IuE3Mr9mlMH7+oABULVxmYKSKSdkhXmydmHyv3Dx1pGlklh+GcJ5PYR5lnUGlPNdrO+Dc/SXvvK+g01jTiPa4tBaN0EUdNxSDZL3dfwbJ5BE3mn5sOg88spmBTKNcX8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aFjWthJ4NA1oL1P6on37s8QLkzKJZhgczzAfrAYHmg9xxmYbiRwx6yJepA71?=
 =?us-ascii?Q?qYgpG8RmgCEzeF34iUB97BNMtDC3TM57jHXlN2cIaig3lcZtbZc9lbr4ssaE?=
 =?us-ascii?Q?VGs9a899Z3EUXf/Bb4VnIV91RbFO25i3EPD3j8eVdWrTMZeP+/AB35N2zweC?=
 =?us-ascii?Q?KsErPV2A8A9/0F8+DcCPh63k0ff3zHfUJPDKKGuzwffOo7t8MA43H1HgbKXz?=
 =?us-ascii?Q?zYuOqWMyrwP0/GEKVf8kNavjUfKffOAjWSpPURMK/lnYYvjdcE9aYeeJ/Opa?=
 =?us-ascii?Q?zM5SyvLHH+EUKtzn/YIRGI889DZRpo6bGZ1AIr+l+0dwRFmGDqf8VnS1p8Lp?=
 =?us-ascii?Q?v7i03682UBYSzHMjFQGoa7y3GvDfNw6hMTlJMFqMCuebnlsUOTOLeBqEKKh2?=
 =?us-ascii?Q?U/T8ZZztVysToBnlFTmquoSluVYaWNRdMbXwwhAANXiewql8Wcedwgkh5lzs?=
 =?us-ascii?Q?iU82lv5iLfieH3rMfFrfekJ/Pq6bugbvPGmCEf4bvRO5cSQA+K2NOQJ/pgT+?=
 =?us-ascii?Q?KqviAa8C5p5jh5BhikZ7PcJcMRYySI0ndy6CXuUuHL0521ezqKn6YIsFm0Qf?=
 =?us-ascii?Q?gweazwQlIDMZp/SnFLNZLq1xNJa8GZUTUuNjFDCxZ1pXHkic6KXzoKzEdOCs?=
 =?us-ascii?Q?79s8QzGBy/CFkMt4M10320ua9jGmk1b47lwUeY7eCt01+sknGvJUydcoecxb?=
 =?us-ascii?Q?bcrpCo9P7YIoG9brKMLH3Jp0R9EqejyZrv8/W4EpF6O7aN36Oz/DpJQGJ5Am?=
 =?us-ascii?Q?AqHRZ4z5LYCJs2T9ur98rzXjzzDvosAlWTfsKvlyM42XKUSm0N30KCZpxrx9?=
 =?us-ascii?Q?8ODdF3Wx7JEnBksBRiw8+zoGEbVDq0fT7F5dY3833zE0o3iBD7vKeNJPTXtQ?=
 =?us-ascii?Q?5GDjIIwKDYC9dSRUijk7zPAGWdcPNvnOJyYYVDBs1QoRG2Xib1sp2VrPlYB2?=
 =?us-ascii?Q?QhUBhekV0hgmitv2I3hnGhyzDa8df0RObbl29OQeOnTLwcwUmOcK41L9nySR?=
 =?us-ascii?Q?KZ0CH09jFbUVFdR/S4P81RTR3Oli+tc4vJoB++5GbfMkxoSKLx0YifMPjQ99?=
 =?us-ascii?Q?8LkCFD9lm48K0I/9q8HqK2/NLEUoZtZvExR1SZPf8g6hbGC27vWHTGAS6HCV?=
 =?us-ascii?Q?kbqGs93tDRvqiaK5h9iOw0n7/dqDfVpHcwZKo1NfetRL3/Z7gEucssW0AZqD?=
 =?us-ascii?Q?67X2VfKRzwPuG7eQ9H8Mhdsi1pmlMlvrHKk5SraMDHe3HSg4XS0vRUKDj1HK?=
 =?us-ascii?Q?tfFj/JVPedRtBy4TtwMrBITVfIAbFSmiy6nfc2nnIjIJlFH3TYXdyqI/4H1A?=
 =?us-ascii?Q?nzxPAN1H+iwxDhJNTvAgyrOT/uhewN7pXxzEFk/qPeZb2t3mwKcLgCnguq5x?=
 =?us-ascii?Q?UGkg7owi4L5hBCQDCKIGUEWa/T9mBR3RsLVmuwn8XTv8DS3aP7KPjIt+KzYz?=
 =?us-ascii?Q?HhGIRLNKt3W9VtxXVb84e3gvkC1PJ69prlDe8nJLAc9C3wnjN37PEEZSCHs2?=
 =?us-ascii?Q?kGkRgMw1mTlsgXK4u10MeCNPJWuIKt9jRW7IUC9gqbhtL9pms/Pwsh/SrZOV?=
 =?us-ascii?Q?NbtRGmYtteML7CwhVPXVVXkvIOlGPKmfRV3jOdOw3yuVhNd9Hyf6qjUSPVey?=
 =?us-ascii?Q?xWdTwTL1I4tsDMuDNCDizhke+D00iHDgjo/wQeRef6TtroI2xtQEjHlukQxs?=
 =?us-ascii?Q?gWjUtClOf7B/oR+rnS8qq8tRRLJAJF0fLMGAxqGRUTcXNNZFbiXP4G84SwuP?=
 =?us-ascii?Q?dzDb0Zu4dA=3D=3D?=
X-Exchange-RoutingPolicyChecked: ROVq+2bWt892jmktI0xxFZGom8n1/c5I9NvsXYmYWlVxahf5vAHQpgQaOpJCHI8pU+40LWiWq0uAvGszcy1ki8H/5Pp6x2V+VANZdZLq0YSH1I6AMNaN/y++DokEoGI2BVn9narIsb5/aPiSZu/g1E+jiFNkAT7JYzb1HTFav9sbqaK3t9e/KnBkAUJGZRfkWujipQwKpFWubiMiigqKRZKIPyHjUt7z+SUg1KwNAyHZg5UvpQ9DLYU6d7rSQDAPDCqKqKF1LI07MVpa+DyJ930ux+yPQWlTNAC7K6C8rhRZcrZRkuZ1g5pwj+5Xql6pDuRlpUaxDG6lECuSAfLDTQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: f73768aa-5547-41aa-4ad6-08df011a91c3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2026 13:29:33.8604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YurdmFuGSvU6coOZUW6GbdNpEh7PpRTxAgcyatbh7iD3KM7mWSJTfiCgz1M/xZNfIsCdAh5hlPKwxQtFmxMCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5241
X-OriginatorOrg: intel.com

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.3-fixes
branch HEAD: a8c6daab4b0e276508b7ffdd66c60fd3020a9178  selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter

elapsed time: 1477m

configs tested: 213
configs skipped: 1

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
arm                        vf610m4_defconfig    gcc-16.1.0
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
