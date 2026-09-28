Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43232EEE86;
	Mon, 28 Sep 2026 03:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790565962; cv=fail; b=d7hIggLrTk06pqxIPuMt+Xxhl7IrRk90G/a6Dlr1Wo4ysBro1Z1Tg27yv8ngmo91HoScIO3oI/2QLNb+77TnKdg6Xyc3s3L5IUYtbRQKaIuEZOdocBFwsEjkr93N7JmN4XCrkCXtPEQDlnctB7/A1hC8MiPFNNBNIx4VN2ux6/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790565962; c=relaxed/simple;
	bh=+RHZIE01zD0lF6RoT1mScn118CzlIcP+n/bwlExWONQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f8sZe5nA4JgrH3dnzGzcoSTcU3dNS2QCl4pmjv1zEGfPqCYr0ezFmLYsams1YH/Pwfxt5MWXjp4do79hklx7nR1HWC3B3qKi8T5VZcEztkDMnkfl6C4YEe5V6+61Rc17BoxpKdl7PUsUZHLZu/G0179Mpf2yyCCzzAlgLtZnBJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gZbkp3/l; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZbkp3/l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790565960; x=1822101960;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=+RHZIE01zD0lF6RoT1mScn118CzlIcP+n/bwlExWONQ=;
  b=gZbkp3/lW7iJsNw4hMGcMGsS1L8+hvZCiYysnODu/FE/IEYNf/gNsD++
   29OhZH3tsbxU7qdWFeWvgBdJdolwqQprOvsPFviA6rSNsY27d+2purUBf
   kLdZhQp6Kn/Mu/uLwY6iYHELzROhz29RFZDJYT4mgt5+NFPYeMMmNd3Su
   B04Ad8A8noMdamNwGLr18540wWmT0Hp4yCE+Uc/m1a++4QwUj9C6Vivwc
   NuQ++PFsXvhbL6MRMmmapbQgyTfCFqUUmDYwq5/wXZNj33KfiHFAb1lQQ
   dxofcDBYa5bpm56FsnPaONATZ+RczYldXa5MLU9uvjSsvPLDhW/rCLcOh
   Q==;
X-CSE-ConnectionGUID: QtRu6UT2SsCFKX7zRgeQAg==
X-CSE-MsgGUID: iMFG0EQqTAuAT7oA5sJupA==
X-IronPort-AV: E=McAfee;i="6800,10657,11918"; a="90299666"
X-IronPort-AV: E=Sophos;i="6.27,127,1787036400"; 
   d="scan'208";a="90299666"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2026 20:26:00 -0700
X-CSE-ConnectionGUID: 3aJGj4DiQy+eLrJO8ZsMZQ==
X-CSE-MsgGUID: SxtgnBLMTMKgdaNeGg38JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,127,1787036400"; 
   d="scan'208";a="271411901"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2026 20:25:59 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 27 Sep 2026 20:25:58 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Sun, 27 Sep 2026 20:25:58 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.67) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 27 Sep 2026 20:25:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPL3Zrk4voh+iCK0UqVfdPRzndGfqB70sKXbcdVJU23y8LmEHXat4T5uNFm4Uuy2QWwIJHdaOF0CU2BPE1Rj4GBH7z9Yf3L4Zayvz+m7akq03OCrB0IasF4+Qbxi9eU5g5BAaHajpsCKEE6PM76ub+hQoR7kF7JLlQAB/TzxPHiOGRg+OFgEUWrt+nUzr/KWFzXzFqYXGnr2oCkEc75ObCIo6PeYDoTtOO8d5Vtopu7QJvbHVEmBPM+bS41dmDvgiOCIpyzaZ5nhpdqoB2GlYKDbMsFf0P/IDyMKJKlEXgBKie27h7sYCDW8ls4Yv4t3dVpwFGQHjf94F4D2ifhitA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6v0kGju+v1o5Sq+bRKlu65+HHMborkUTP+adDei1Y8=;
 b=Rey6MD7kZ9sOO1A+/1xthbah9qEfLjvPsKzo+Q9ImwgaY+x8N4mWrYkKYLHPS4yCVKLH6PAH/9RNawjOCICdCkc8kii3C/Pm+bJuGPSlkojsad8290ELM/WaQc18f9EHMKx88WbcNOBscwP/Ph2s5bbQ23Fn3XqvO656Whpfe14m3QRmVnGHuozLHkkDO5GJpaIXIj22d+6NPktKbFiuuAJE+Nb848tOarFEnHUlCaK9/lDb07gcXfASWJDM/Ux1cilARhinQXMCDalaEc4Ejqy4DItuvxktFXhFWkNQ7ARgygLR71FHg/IpOf7qlMVt+TB+MI6tIJHCK3uZxVSdBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 SN7PR11MB7465.namprd11.prod.outlook.com (2603:10b6:806:34e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 03:25:55 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 03:25:55 +0000
Date: Mon, 28 Sep 2026 11:12:40 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Mike Galbraith <efault@gmx.de>, <kprateek.nayak@amd.com>
CC: Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>, Peter Zijlstra
	<peterz@infradead.org>, <mingo@kernel.org>, <longman@redhat.com>,
	<chenridong@huaweicloud.com>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <tj@kernel.org>, <hannes@cmpxchg.org>,
	<mkoutny@suse.com>, <cgroups@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <jstultz@google.com>,
	<kprateek.nayak@amd.com>, <qyousef@layalina.io>, Ryan Roberts
	<ryan.roberts@arm.com>, <chen.yu@linux.dev>
Subject: Re: [REGRESSION] [PATCH v3 7/7] sched/eevdf: Move to a single
 runqueue
Message-ID: <arnbKNWNIIEcQ0a-@chenyu-dev>
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org>
 <bd81bbec-ee59-401a-bec6-116196ad3a34@arm.com>
 <arQCykkkCnADu5ek@chenyu-dev>
 <128e93ca1424630546e39f9e9c1377f8185f7644.camel@gmx.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <128e93ca1424630546e39f9e9c1377f8185f7644.camel@gmx.de>
X-ClientProxiedBy: SI2PR06CA0011.apcprd06.prod.outlook.com
 (2603:1096:4:186::16) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|SN7PR11MB7465:EE_
X-MS-Office365-Filtering-Correlation-Id: fa08abdb-0d88-4eb3-54e7-08df1d103472
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|10067099003|11063799006|5023799004|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: +Rqf+kBRowDtFyqe8NwBiebSAFkhAdF5OLOLSiXL54LPkSEuXtUzc/hirgTp7ySaQwZJeIQnT4vMGbnZKkIZCjuonM8HnxHTq5mU6rzvfEEZXKlAcbAc9OjVSWVP5SrVoQfo5KJyPX6DR5L8rKP4qY0oi+7Zbk+2qqh3NeRtAebo3Os5Mh4XuRaAsRHHDMJVy7AWFNsPE7LRc5wMn7sqWpfiEJJ9/1521zXRwKoMyMIzxnhFHRteqJ/+hg/ZB0WuQ8ih4iU3fqF6ZzOaFUF5mzLz/uMHaCbY9KXCDXm4iGe0mJWR+Z6ieuM8a6OOuz68qynPsGvbxHT5d0/ULWiBHO+vY838d9FAwlyRlvKX/6YgdsLVULo/zprAk7arme2R8rl0knSu1LkIycTHl2Bsn/Mo6dPfcvKgLAVoVXyi6fadYdqoMoW8W2cnmWYKnzRoTVQHv4ZOY/G7FH6evt18Pu4uk8lUM1/z2Qw+VAhEt7NvA1yA2UWw2B/vSmhLm6qGHKzh/4Bml/IBv1GNqAJmkhiDT2c2i/6a2U6uxUa9oU87oZ+ecHlfrmXhM88BeZoe+SB5/KFWOyheJkh9M6j75WqU44So7qpkcX6fmzj2jddUf68uWU1xEiQeVVu1+RBMlaiu49pHUS2NVsZpV0/tl0vMLIgIwfcPIuTJSoG8A+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(10067099003)(11063799006)(5023799004)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?qq/AqzXuRIvFOvBKRnW1jU8jR93qO6hXicxS0FCDkNWthnz8FoGj+4AsK7?=
 =?iso-8859-1?Q?AcTmaCGu1W3uCWq68RTSOFOAtke90RJbZ85Q8TbZSwyMNQcZbp/57qupr+?=
 =?iso-8859-1?Q?Gnrp8aUxvt/xOqOL5Q14Tr/6u+YWnRCHAgKA7prp/D7JZc8bGmwIHLZL8n?=
 =?iso-8859-1?Q?CCM5kfVfMWmpqDG9xzw3rUEkdXt4IPY0t1cLea26amW230s2EOTfa+FjJJ?=
 =?iso-8859-1?Q?rN2UmWkNhF2yQdIt9jACcNL6Nz8lvIvC+MKStUEupeQK2UPlZclut/iYcc?=
 =?iso-8859-1?Q?o05BsYS+3ue04QNEuxhzzwoImQ815BYvF/O5Vx3pzx5db2t1lEBa1exL9T?=
 =?iso-8859-1?Q?0TNaxJ/DHpUk4Ph18Fn7Ti9ggTCjf17WsV7kts7mXYLRCBbN1J98aPWe9b?=
 =?iso-8859-1?Q?oLipOHN3nBQEWs9YBnBBUr8aLYGfrbDd6UhFOOK2fL2S34cNNb2CAeuJcG?=
 =?iso-8859-1?Q?H14d4I7HFsIreUQnmFndJoEPVr4uVi1cMigwnS46YUxhtJAujVoqByjoE4?=
 =?iso-8859-1?Q?px+UhTQiWxBA0cnq/URKzJcexDXDtPTh2W/e8gXNU1ev7aODGCjNmbE+FM?=
 =?iso-8859-1?Q?ReteF7T5cYlufMaqtfBZxw5Y8NejAPu4WiFOAJTf+ZxG+fGTUObcIlNVUf?=
 =?iso-8859-1?Q?hqkepSlW806ygdNqW6XkKsTBoHhrhVNC34O6T/ltT/W55kyzX+KQk8hVYf?=
 =?iso-8859-1?Q?+pDV/XbkV+N5J/KKTXbs6iL0XTkOWVHs0/Z3jfV9NlK/B3hS9Z+vrh6sIN?=
 =?iso-8859-1?Q?hQWEE3IdRMe/lObKBA3AhTRNdMZNh2FTLyg3rqwF4jFAbRG/2FnscqZaJz?=
 =?iso-8859-1?Q?ZyVMYMavY9YXp+peGE2EOz+RID1NWlvWmmxlIuepftY9faZgxK0L5wiwlP?=
 =?iso-8859-1?Q?ChNtITzyssmpoIgjIXJq9jXOZqchYgFI6tiDmaLQyikw+vREVWw2wKmDSB?=
 =?iso-8859-1?Q?17ovpEEo1w12U6couLVvA72+V0TI6FjXyGs6P2bQSgqFWZS9AuR7B3hWDp?=
 =?iso-8859-1?Q?ReVH05W3akRtljfVCMYNRuwwVOdOrLonagSJDgVar07Z5wmbx0+FXLRlgI?=
 =?iso-8859-1?Q?c8wOSa+8zdRGcii0xiaSkbn4hSrBwAzYnc376eIHpw0494HfPzNUjNqJzB?=
 =?iso-8859-1?Q?1dNHZon79II0e+1gjcQZAUsI8zPWoaXR8cN8NreWDp2YtmXFrjPW8fJ/7r?=
 =?iso-8859-1?Q?hBhUDHzBINLoN7kBAJQtshsLfLp33QZ0pkKwPr8a+kYEe2HpHGoLiNZ2il?=
 =?iso-8859-1?Q?JOi8dy/AdLXINxphBAKLRqPKxBvUSZJTobNpB+/3unXV2yw6GXsxuWaDtL?=
 =?iso-8859-1?Q?qn5VEzRCh5LJlvB5mgnRR4QpWwFz0arC0RFopxmcb/hZmj2/xrrKoasK8D?=
 =?iso-8859-1?Q?hbKepDLoLibkVlJzeoVtT2igOe7bU4fW0n95JkkbWGphrcFf0XLdnGf2ir?=
 =?iso-8859-1?Q?nzBSdZ6ZjHd9M3Oi8anOgoQH1PAPfcXmOMMBDZHE7Qbq+RK5pGtPhuobG/?=
 =?iso-8859-1?Q?ViwjEHIHM7eKp5Hubh/bQXfZjm+bKxXuThw6xtvg9bIHGwOSTDwtah5Q5L?=
 =?iso-8859-1?Q?FDRczvAJTLGUsJ2RKKoKZGfB4+HPbE1GytmjwDmdOiN2GudzUiHi9+1OaG?=
 =?iso-8859-1?Q?DOrNigLHg+dbC3c3PaOvOMrxUlVJBlvGNtfoa/gdiKsaiw2hOEIomYeSpw?=
 =?iso-8859-1?Q?iEinNb2+GhK6D1h40BLc2e3hxoAD8Y5IKzvCqw44sFkZJ194qwb8+mNn8A?=
 =?iso-8859-1?Q?k36AiQCGd70lCQs67eo2E+E7gxJBxl/dpSld0OMZjOU9Cfht9d/hT8+Ct0?=
 =?iso-8859-1?Q?J4OsUimBGQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: ENgkI3o4wJXk3rEfKAp6TcsR6+srfoO6tjWJn7LrWOnEhjIxB1Yf0zFDn3fi1fstQHSioh7CQM1PKHa/AOM9cORzmq8qs8ew6TEZKEvI25H3ZgJ0HKEaqHlx1/hObm54wBbokeqCHouW0/7PM/xvNc0GnyRYTiX+9J1GA5vh+sVv90+6IrBykpm0tyqq1jRuGj3zrjJ1DKrP+oRtmYhXSgJKxNfq3vXOEcrAoyAux5KyX8eyswpXbaZ7q3cAKeVRaaPEW36I8/CuxT5144Iwdi4C3777OWjbjiLbmNSbRsfkY4+Vvcbl/tBstmuaWuBQFCj/hnKebn48aMtSeiMHwA==
X-MS-Exchange-CrossTenant-Network-Message-Id: fa08abdb-0d88-4eb3-54e7-08df1d103472
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 03:25:55.1197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L7Xf+PXQ6yhHVRwIZfu32EUsavgzY1+VFIlxMgwpyaqHYIMsgyxbeQw4HDWykCEDL64ZL9hH+qSKCE0ZJl+K7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7465
X-OriginatorOrg: intel.com

Hi Mike, Prateek,

On Thu, Sep 24, 2026 at 10:19:35AM +0200, Mike Galbraith wrote:
> On Thu, 2026-09-24 at 00:48 +0800, Chen Yu wrote:
> > 
> > Would disabling WA_WEIGHT help? I happened to find that this workaround works
> > for me to restore netperf performance (though it is a throughput score rather
> > than a latency one), it seems that task_h_load() becomes much
> > larger(also on sched/task_h_load):
> > echo NO_WA_WEIGHT > /sys/kernel/debug/sched/features
> > https://lore.kernel.org/lkml/aoxah90s0bQ4tcUW@three-body/ 
> 
> A long while back, I caught WA_WEIGHT causing firefox's event thread
> pool to stack on a single CPU.  

I just realized that what I suggested - disabling WA_WEIGHT - does the opposite.
Actually, WA_WEIGHT does help in the netperf scenario. Disabling WA_WEIGHT makes
the performance of both "smp" and "concur" modes drop to the same poor level, which
makes it look like the regression disappears, but actually it does not.

According to my test last week, stacking the waker and wakee on the same CPU brings
a big improvement on my machine, iff the memory bandwidth is saturated. By comparison,
if the memory bandwidth is low, stacking the wakee on top of the waker causes harm.

The machine I used has 2 NUMA nodes; each node has 96 cores, and these 96 cores share
L3, while every 4 cores share L2. The L2 miss rate is much lower if the waker and wakee
are on the same CPU than if the wakee is put on other idle CPUs in the same L2 domain.
Yes, the same L2 - which goes against intuition. How could the L2 miss rate rise even
if the waker and wakee are in the same L2 domain?

I guess this is because stacking the waker and wakee on the same CPU and letting them
run alternately would be the most efficient way to consume the data without evicting
L2 cache lines too much, when the memory bandwidth is saturated.

> In that particular case, the victims
> (32 of 'em in 8 rq box!) did nothing but go back to sleep, so no real
> harm was done. However, I also measured modest real stacking impact, so
> gave task_h_load() a floor on GP.
> 
> Perhaps weightless burst stacking is a bigger deal for some than it was
> here?  That firefox event thread burst showed potential.
>  

It depends on the workload and the memory bandwidth of the system, I suppose. 
If the workload is a producer-consumer type, and the system is under memory bandwidth
pressure, stacking the producer and consumer would bring good data locality - in terms
of L2 locality, per my test.

In summary, the "regression" of flat cgroup task-pick on netperf (or, producer-consumer
type workloads) seems to be the expected consequence. Maybe we need to make WA_WEIGHT
consider more factors here.

I'll collect more data and provide the information later.

thanks,
Chenyu
> 	-Mike
