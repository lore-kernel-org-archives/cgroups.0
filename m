Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8223A38B7A7;
	Fri, 28 Aug 2026 03:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787887380; cv=none; b=hU33m8pMyKxaY4FPWhwU0VUfud8Bv0D7zdMy045ylqcx1WGweByY6h7O9knpzGUwDN4rFi4g5Pr01ATXYEiIuCGMOPO7RVxyHDBi7glMQNup4IH1RS4QjOBQinz22fGMoY6ZThHiVtR7Jab8nlAK3cJQwg2hnHliFAC0dIpz+pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787887380; c=relaxed/simple;
	bh=e9hRHQ6aFzR5cn+38V4JJ8FVmkjRNBrpiy92HLnfLew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fWCohV3Obt1NXsYiMS+nQDvPwFkJoTdA/f6dYmyEhUY4bj7ZWPrqBZAkk/Wrlt6u+IPX/ed52La4klQGzMMRl0sX4CD/nMDczCQYpuD/5RD+CHw6enfOjjQw/xdkrmL95N/0ZFlC5u9S5+USzXH9n5k/Qaq3/iAevIP9mzwjqaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MWBkayRI; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MWBkayRI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787887378; x=1819423378;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e9hRHQ6aFzR5cn+38V4JJ8FVmkjRNBrpiy92HLnfLew=;
  b=MWBkayRI/kq8R1YMVh31aTu38dqaZxh+8x3He4Y+eHclL3Hrst9jBQbV
   MHS+zD/S4hE7BzL+SRbE3cSW28Ax+5RIUvEqlipszEl9FuJOkWW7ToCMT
   W2nbwBbF0Zpv2D5rZwVUCif0AmoO7K3qfIZmkZbp6fh1wf/PeubzsQL7p
   yG6ST5bsd3m4slADxqdkG6j1mPiAWcg5yp9Z+cpbOWOrgsRcRPGF1q7Az
   +j+HPWlNIRWz4joDpdSB5FBMWEfPwYhJtyJtQ0i0KPRqx4oaW9AWgmzb6
   U+pG4H/94TCVvjrI/FzT5jNwiD8MaW63HiujffydA1ugJlpZwd8dZ3RxA
   A==;
X-CSE-ConnectionGUID: EldlS51/QmOkBskFqlALzg==
X-CSE-MsgGUID: M/f4JxZnShiVtUYaDI6d5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="88518140"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="88518140"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 20:22:57 -0700
X-CSE-ConnectionGUID: bIY3IgiKTmi14/iipIiR9A==
X-CSE-MsgGUID: Q1F7nL41TcmvXhXm5pucxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="266231271"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 27 Aug 2026 20:22:55 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wznB6-00000000AIb-2U06;
	Fri, 28 Aug 2026 03:22:52 +0000
Date: Fri, 28 Aug 2026 11:22:03 +0800
From: kernel test robot <lkp@intel.com>
To: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: oe-kbuild-all@lists.linux.dev, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during
 offline
Message-ID: <202608281149.3OqBLtQa-lkp@intel.com>
References: <20260827124211.3b94b103@fangorn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827124211.3b94b103@fangorn>

Hi Rik,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Rik-van-Riel/mm-memcg-fix-UAF-in-drain_all_stock-async-work-during-offline/20260827-124211
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260827124211.3b94b103%40fangorn
patch subject: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during offline
config: xtensa-randconfig-r073-20260828 (https://download.01.org/0day-ci/archive/20260828/202608281149.3OqBLtQa-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 16.1.0
smatch: v0.5.0-9187-g5189e3fb
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260828/202608281149.3OqBLtQa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608281149.3OqBLtQa-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/memcontrol.c:2380:6: warning: no previous prototype for 'drain_all_stock_sync' [-Wmissing-prototypes]
    2380 | void drain_all_stock_sync(struct mem_cgroup *root_memcg)
         |      ^~~~~~~~~~~~~~~~~~~~


vim +/drain_all_stock_sync +2380 mm/memcontrol.c

  2379	
> 2380	void drain_all_stock_sync(struct mem_cgroup *root_memcg)
  2381	{
  2382		/*
  2383		 * Make sure the workqueue is done with this memcg
  2384		 * before freeing it.
  2385		 */
  2386		__drain_all_stock(root_memcg, true);
  2387		flush_workqueue(memcg_wq);
  2388	}
  2389	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
