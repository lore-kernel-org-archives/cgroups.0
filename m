Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792551223;
	b=UJXQKLakufFuUFoJZGuWJ9B6yfn7ajyK95+AKvit4CaoLTtNb5TU8c9Uf2cHq/jmIFtj
	 5EuIyZa6q27WOjHG6G+ViAKYazWtA3TBgGnTT6xnWSXG0TSUPdTBiHOtectSJL8hfeO4H
	 r0ERl3dVguPWoxtBEltYrMUoG/OrvbgBHOzgQSrv83tOlD3Bgnt6veiq7RmB1B1O1+Oex
	 XRDpa54YzJXISLpnzq6xd8P50K35dUEloApOkItriZQ+VrgmiSan/IlNm+ey5MDUOXB1h
	 IdH5iuUqRmHzknemSKaelGpqTsroPF7J3qRbKDbP3g7cgHyO8y2sER2vH3PovQc6z2Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792551223;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=XC64uL5nVoxMdfpVg77MbUPuWU0UmP9Ae7D7/df/QZ4=;
	b=sFUJZfLtYEGLbSGdK1L/nQ/896DLzednFUxOlXoQDiVnVpCGYd0ur7g9PC7igW5VD94Z
	 UaKC6FcZav7W5NbgIxFjpc54DQ1i/r2AG87gq6HFHyBh6rdE6THcRRu38gzKiw+ksaVc4
	 oTtt7uALtao1yaR8J6pnvRAS1Bz32XeQAshjKNGhqm4BSlEkXH01A8U31obi/mmOad19E
	 sVyHn8nr0j/yB7nTTTvPkjEwMPcwgEZf8axnW545zf7JV4Y+5TNalat5yLy5F3xL5AJHh
	 5P0AhMqxHP5QR8ADZVkU2RNh1p4+sjDgyjOkQ7RGisqUU9W97E3HYIRuvAXbw8Xpvbw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=j3dHOHvU;
	arc=fail smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CA0606A319;
	Wed, 21 Oct 2026 02:53:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6CA0606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=j3dHOHvU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792551222; x=1824087222;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XC64uL5nVoxMdfpVg77MbUPuWU0UmP9Ae7D7/df/QZ4=;
  b=j3dHOHvUAYD8iXveNL7cV0BUqlEdqowjdPznF28ggMA3TqrBmngzE+DF
   k/7QmFaz0IYoXEChZUYnt6GdSZxb7p/D14lVD75Op8Ve63Ih/+VlY7TVC
   4XIziDFHBgox8bG1cGNYIjj4PZgMTCkkhvHQG/+cFRl7KZI1x92mtGpKM
   x6HgJUNIwaFsX4ZQTYeDQ+uZHsPgEfCM8Nzto61smXE43JV9wZrJ2bwpO
   Y5NOTk7bHLTsVAIg+dtz27nAtUg4Dvt9GOPICglrVDgScfy3AxQVAEIjY
   FNpGBaH41xa/OmQhtt99oY0CHU5BQKVJB2O+31c8Amu26RK2L74249RIu
   Q==;
X-CSE-ConnectionGUID: ahzIKUQTRIG0/Rrzk8tLOQ==
X-CSE-MsgGUID: WVaV5ClPTSuQR+IVNqqjxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1270006"
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="1270006"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 19:53:41 -0700
X-CSE-ConnectionGUID: fNZE1lQrRR6HIJvdleDTMg==
X-CSE-MsgGUID: d9jtRrWuREmYep++qm6c0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="4723643"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 19:53:41 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 19:53:40 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 20 Oct 2026 19:53:40 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.30) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 19:53:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fOpi6V+2vh1/7+N980D3N5OcdDvHIqwN3oAb6b99G3lL4OjsMkXWOzo/r/EAcxoRhBJ4CUl//2Kt4E/Ix5uXJXo0NTZE3k1eo604cmS1BZyQG1EDd+mkl0WTZsmMmgE87UHFzgp4sC9Jed4uzFppq1M0vn9kwIy0qfAxFj+DVWFW+gxEW6WlYlkg5PHDDcm9WTANMDejFGGhdoMhDG6s3H/zlz/c+rUt14+gZ59lRyrUh7MLqfPY5tZNFTku0Rq3UUvuPDnenlanRN4c4wP5hu9Url/qvDV56pkCbyViaD0pZJd/SZ9zgnXZwnb80T4YaAG8j6ieIsFSWcB42lnaxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XC64uL5nVoxMdfpVg77MbUPuWU0UmP9Ae7D7/df/QZ4=;
 b=AsOrE5fqdL7IrzojGf01bmQcwYWmZJJexxjEZUqG6d7KdiiuZQnsp299iKWKxWI979pR4JrqpZ1KLVkqtCuvCVZ4hsTOxzl53Vukz+ityqmG/wVloPw3cueFzuNAL0e7ZdJ2MWERJ0yM3cPWEIkKNxG5Gc9/OXIU9JZGSK4Fbx95d1gL4E6+fSNe3AK5FAZWmwR+itaZunBzSEHsaCI4NtX/2XCbb6lci6GtSdB3FoyT7/4pIi23AKoUrkw8yIEqldv8n6NLLBW+Z/1QZivqY4v+sMlSw2OgvrsPjcR2sM5yhMqbMGPreR5nVLR6A60YCU+TzOiaUetXNeS9dEysEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 SA0PR11MB4765.namprd11.prod.outlook.com (2603:10b6:806:9b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.19; Wed, 21 Oct 2026 02:53:05 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 02:53:05 +0000
Date: Wed, 21 Oct 2026 10:40:02 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Yafang Shao <laoar.shao@gmail.com>
CC: <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
	<eddyz87@gmail.com>, <memxor@gmail.com>, <mingo@redhat.com>,
	<peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <gourry@gourry.net>, <tj@kernel.org>,
	<hannes@cmpxchg.org>, <mkoutny@suse.com>, <shakeel.butt@linux.dev>,
	<roman.gushchin@linux.dev>, <zhao1.liu@intel.com>,
	<tim.c.chen@linux.intel.com>, <lizhe.67@bytedance.com>,
	<bpf@vger.kernel.org>, <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3 bpf-next 1/5] sched: fix stale get_pref_llc() stub
 for !CONFIG_SCHED_CACHE
Message-ID: <atgmAsvUt4gvcoga@chenyu-dev>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
 <20261019064157.29885-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261019064157.29885-2-laoar.shao@gmail.com>
X-ClientProxiedBy: JH0PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:990:56::10) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
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
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|SA0PR11MB4765:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a66a6c1-6735-475d-2e7f-08df2f1e6e24
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|10067099003|56012099006|22082099003|18002099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info: MZ2Nrwwg102YPynqmnKVMsFtHI1c5Zk9QIxKSfLXLLv4+ruOuZNhlSgpOcfapR6UZYM5YDLAUQOL3VGH+y/8kZxWkG6O01ibhcGeI0v84gyWA4g9iz9A5IzuULh5AG3jWpgRSymCLIvLFyJtOUdbpf15/R0/F6i6ucZa0SKcbqQmZjam3Z9GDBKwofEC6GP9v8CDTS4GnLqvYprs4xTjwoQM17Dq1f2mrUWq+/tqJU3SwRJJrcKF9H7tEqbLPy+GVh2p0btndzqFFzrvso0U0AdJrrSxKh3kE7togATN8V0acGbVZgWau+yFidxFCmopKsVAWIf9sacSUauNSXJVrJQA5yPGbRgONjz68PIs57MsNOqUxI4B/KjsOZJua8ko7jqJW/vlbtY6cuhLOfn57Vff+2fTnqdNyDsUV1rSc+jM6uO/80w2LEAlQNOrAjcjR1IfUdPBNYBUKUxuLDhOFYbsEXFrHMT/5zqXdJF8xdqsLR9yw2u7LMsNuUdY8MMT/m/tlaGpy26fuCYIJUJAfFzMqMexqupSY+jb8R8DkBRFjdRhCMlFTUOxm6FOCea3sBCvpvGphsmuTCJQRalLPOnt9EebrF1k7C6Gj54/snkkxqmEZZlQ26lVv2bBlV3FqOyEN3vrCVeNAIkzRvpWZqGxT6EY8EZ65RRHALqEsGE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(10067099003)(56012099006)(22082099003)(18002099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YcVd0LmsbnfeUd6b8UEkOTAMY3rXDXweUFzwbp+NUdUoTl/wlTSFMeagm3Y0?=
 =?us-ascii?Q?VPhjzmJ4rexnLb2Af23GhiGcJ2tIsNpQafflCLysCs/hCXvRNITwUsP3qJfv?=
 =?us-ascii?Q?5NukEs5NZ8V9Svn1tuMVpT8T0AxsUjIUnrtU31xdksV8PG86B7oVivYK9JxY?=
 =?us-ascii?Q?ze7umsNlltPD9ii+H8Opd9BURnP47fQdGyGSM/33T5Z+1TbA4xqKToLw/lAS?=
 =?us-ascii?Q?KfmuzFIfOFvVoU6LTt/AW3+bWVBBsvKAAkOsyVaOZu/fEk68n2reng+PNMDi?=
 =?us-ascii?Q?5XVOb+/UPaXulFucAFCE7aMHpYDpgC7mv0Ppg4d73LiWJnrUDCwFmQ5ULBfU?=
 =?us-ascii?Q?mNLxyoD8EgjDpcbwgGgVup12scPEYgMSvG00VIghVEkiXFNwXtNkjTUrp9zu?=
 =?us-ascii?Q?OKNl1a+AiiCajKeWAt+B0ZZ8FvjEDV1HgWIfgfbUtbc21EoHkwxLPt892MlI?=
 =?us-ascii?Q?x5g6HwHkeuLYxGqYNaFxnw/+qR9oheeL2+Q4x/ujCaK30aRpZ0Zww8EVkwdQ?=
 =?us-ascii?Q?6BCYSrnOvUqe3aS7WKk5xW1gBI1bsjjgLuxNqWBEuxDVGTy7MMyR9o/sOY7v?=
 =?us-ascii?Q?f5qQ7pD4b/RZDmZFM5H0ZYt3axir0hLsUbx7GYGNOUb9FGGiLm/MbMDP5NCX?=
 =?us-ascii?Q?/9K50q+e2wCgyFr0dpRcAcnF/+A0AxjTquOf9eyoWphXQzv8loyf/qPZij5t?=
 =?us-ascii?Q?21ohutv9TLKOlDX2J97vVIE1eujqseEed+6my89LHRplM59/i0QVduUPdY9y?=
 =?us-ascii?Q?GH27ZZtCJh9KTH6V6wWAAWhnWmTz0iJvbzV76gvwl9m010lnskkgnhYJs+hp?=
 =?us-ascii?Q?LdhNWaxPIsb1VWr63dLvr1SO2QfyN9ngbLxJ/JEoLSpbDa+3NkbgaK+Q66Eg?=
 =?us-ascii?Q?CzI2VawJX4YlccsjLd4DCNFeviXnGGgyr7e7LSnZkGynRp4PgySQDX4R3R+G?=
 =?us-ascii?Q?LyFGRpZBohmQaGYvAviBkA/jCZHMRlWJLIEGwPvOOVePnjnyUe6wgoKOTHro?=
 =?us-ascii?Q?Zengj/qGkoCF3vf1NdRWpZoNzn8qKqyEeu8z84/qLrBwASLnijzbd++P5o7M?=
 =?us-ascii?Q?32m2w/ttn38aOqcKHISHK/gaaAjsgKf/sY5WlB60YClbdjTFc+FDLdvyHRzb?=
 =?us-ascii?Q?DhA1z2LXYm2cXRdDqdP8gHo7jdjP+GD/NebztubDcEt/JTqyE+AUJfwSBipW?=
 =?us-ascii?Q?DMZvR3S/647KiG5gLYu30LsxGuP5jXI9Wb3btQ0sgF/hmOsC3DH1nrAcdSQd?=
 =?us-ascii?Q?s8h0DQ/04jb06cnRsytrWd0M7C3U+toJf0A1bXfKmdlg73qzeUXo/r7MtXG2?=
 =?us-ascii?Q?v94EdDlYr+LwNiQ856l9qGJfWWVFHGLohiofmKkDXb/loLlW46ZjB1d36F7a?=
 =?us-ascii?Q?6CK2u0+Ta9oH7HWdnljUR9BMTJ8VcxADij5qNuzbbj1jj4RYIFq8Ph+LP4ZL?=
 =?us-ascii?Q?78NMlIXVtcG0HOp37EFXJ6ROIrdpbipjalN3OOfUxKXWLWalF6RNxTr4ekl/?=
 =?us-ascii?Q?Okd1s+0Lmb3M300R8l79VV//J5BREHbQ+aK99K6w1El/8W1MTNDFlMP1NC44?=
 =?us-ascii?Q?o7KUlJBVlBY7oC6MWGP+NfPplm9jSUPG1pHbli9v0ZtQK8bEWBr/v3X59Wgk?=
 =?us-ascii?Q?2bDQhTNLWw/D3wurBavyxOSj4fAO8NZ/HHomP4sOyV4DrgvaV+enEJsrld6R?=
 =?us-ascii?Q?j/3nNjGhqTcoHcBhhn89jFUPkmVyuH7/9YvU2jn8Fl/Rz8K64bvQrD4NqVr/?=
 =?us-ascii?Q?IoAcUDHAZg=3D=3D?=
X-Exchange-RoutingPolicyChecked: LSxzViR3N+lAI0LVHDx1piZKxjtjmQEnGEcxV3nZti3/niTijuf3IJMvIT7xtl0nNxvQyVPl9Sb3kKOEUBUfXnX6VwnDlfJHHOx98x1KWzBB6mnveKb0kyLXl5gwCWKNC1Nonx5/XZd8nScYO3TnVUWfn5fgdSS06EY/AQt43ZU0aIW5acmYsm1af3TC1bjyunTte/c32arQc8FfGwkFjGyWP9J6ZdeCPSN2k5T6y4vvxMP683RKWoNbY+OFG9GVQdyq/pW2XW6+7wBVSMDwETlmT/p+LvRIvDhWSpiM70xflb2uVIxg0UagNE43Q0i66YXyCCJC2jQ40XFI78PN4g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a66a6c1-6735-475d-2e7f-08df2f1e6e24
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 02:53:05.4698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lVlrec4EnwMo1EFGfnRiSqNnrFzY9i+QPsAWCvIaEr+ksV+Rmd1j1d9LMZitJ1PYKdLbr+gSQsMtO0WxZq4RFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4765
X-OriginatorOrg: intel.com

On Mon, Oct 19, 2026 at 02:41:53PM +0800, Yafang Shao wrote:
> Commit b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp
> to fix UAF") switched get_pref_llc() from taking a struct mm_struct * to
> taking the task's struct sched_cache_group *, but only updated the
> CONFIG_SCHED_CACHE definition and its caller: the stub in the
> !CONFIG_SCHED_CACHE branch kept the old mm_struct parameter.
>

Ah, right,

Reviewed-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu
