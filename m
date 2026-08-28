Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9337D3E0090;
	Fri, 28 Aug 2026 10:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787912756; cv=none; b=qp0hPH/q327wqVLOtfKMcmtaxIZUpRDsADrCqimULVjhUAapwsB72zmqWtdckTjZaFFyG0Kf+wd0WyPrNuKPZFtouhxhJl4jpqQ8yU485OvYxRdPe/L5GrpUI0ze1FHOu7JGTwW7uVzNah5E8jZcmWJbZzu0pQQyP51qMjs6Li4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787912756; c=relaxed/simple;
	bh=y2hbqMERCbiubt7BDkFMXl1dBTo5MssDHay4qoq9wxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ozCm98zg02vUPisZdZlWGwMNPMtPYGY8hPUTwxgN9yJC91zSOL0KnrLn5zF4jRA332I8DhFbl+YXNIJElXmv0tZvg5Mdx+RvXXxWX9p+kAw91mwq/ejL4weTFBMoLoeN0/v9z7QBU26S6Ddb07Bhg17UBTCU1Z36sQ0130jbyEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OfwhvkOr; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OfwhvkOr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787912754; x=1819448754;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y2hbqMERCbiubt7BDkFMXl1dBTo5MssDHay4qoq9wxA=;
  b=OfwhvkOr2b6oN/wkqJr2bItw5OFPB4ZA2LHG8T7BrhRI4axAumrRRael
   xK4zQOXtDNeuP16L45eUbonQgRi/P1qaS0IdUgwvBBnIX+1t/VJVm3bJC
   je2ewzc2Xwm9JbzzvmcUVfnk39A+G5aCInhxfdk1vn7lkk9W0ovrEb6Y0
   iEnGUsFcBvyPnPfMteOzaX8dmvWMEQ5jybYzJzasz9BeL+UjM3C9Wb6D1
   FPMYQU3ehGzpDC32xb3FdaUg+LFTeHl9gkczQwg3QBGjUkOpcUKuHiewU
   uHB7JIY3A9HYhcR9Bf/SR2uynTwvKB4JATG25SYrJurDOiDc+OAeq7zCf
   Q==;
X-CSE-ConnectionGUID: TfqW/FaASqqYVdzPw83XRA==
X-CSE-MsgGUID: MlqczSQBTO2WoLoB87Th4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="99580841"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="99580841"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 03:25:54 -0700
X-CSE-ConnectionGUID: 6SUyTDvTToGtt1YkFVWwbw==
X-CSE-MsgGUID: xaSfKNblR3SZYeLPnQSyQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="273380978"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 28 Aug 2026 03:25:51 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wztmO-00000000Ar3-0FNM;
	Fri, 28 Aug 2026 10:25:48 +0000
Date: Fri, 28 Aug 2026 18:25:01 +0800
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
Message-ID: <202608281724.4MTLH1h2-lkp@intel.com>
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
config: nios2-randconfig-r121-20260828 (https://download.01.org/0day-ci/archive/20260828/202608281724.4MTLH1h2-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260828/202608281724.4MTLH1h2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608281724.4MTLH1h2-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/memcontrol.c:2380:6: sparse: sparse: symbol 'drain_all_stock_sync' was not declared. Should it be static?
   mm/memcontrol.c:4678:52: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/memcontrol.c:4678:52: sparse:    struct task_struct [noderef] __rcu *
   mm/memcontrol.c:4678:52: sparse:    struct task_struct *

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
