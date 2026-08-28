Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8EC30DED5;
	Fri, 28 Aug 2026 00:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787877772; cv=none; b=ovXMkQv75DS1vdW/8nW0jICEa3pIyKg2iB4zLWjovZTUYH89DnG7eTUMJgFcgNim/NgIZCHI8xLajFfw8R+C7S8Yvn2sORRC2TEQWUriFCaq+WgYqVjn4cuZo+8bQws6+TfTQAQt0Vzsod15PlzlvWCw1O3xF0xpZ693HAUmllI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787877772; c=relaxed/simple;
	bh=rXFUXxlKqBaXuqzdOpAFlhPtekA9ua3NlNpqEnttbNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qstcg8WklqKWr+5pB+UxIum4thFKznY6hxfhJcGJZ5EmBI8arlRUcAXmoTpqs7CPRGfaJBK01nRiXJyfjkqPV7NoIkzcv1yT5Z03qJpdZ4mZ0FEEkLv/3gkq/b5FI7mn7y+2n84sdahhD1DG3VtuCAdpoxCrclRT7jXXwei/hRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eSoXWTb5; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eSoXWTb5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787877770; x=1819413770;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rXFUXxlKqBaXuqzdOpAFlhPtekA9ua3NlNpqEnttbNU=;
  b=eSoXWTb55RHWJohS9YWqNhHsHQCkRgHpQVp5sbuZztjqY+t6g7lgTFUI
   L7TPHujEH1nfy/9xGAZoBpjLLw0RXWjFRPxu+foGVXu6SD9dpikzV1Hi1
   ZIq1J2p/mXjvwhm9uS2mJJo36FhARtL0g5TU9ISbt0YSD7OEnEUn5BmEF
   b583SoUzwJbOwVTpybkpiPQ/zhOE+K7HTXB/E+Y+xI9BbOLOdNnflVZKC
   gbdE8dF3zWAccGxZX2aZRVKCdIgH+wm3ii5OYaWcJAc9i6GktktH7X0Ni
   lAp6+FPwkHhG6qVEiPYqGqVCxDXAqqCJr0JLJcxDThpe6A3RnRNj1I/1I
   g==;
X-CSE-ConnectionGUID: QWLVAIhQSkSXlEI30xEQEw==
X-CSE-MsgGUID: ma225OYvRtWU+SsyDGLSuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="92245951"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="92245951"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 17:42:50 -0700
X-CSE-ConnectionGUID: XDqL6UANT36uEF3p2NzRAQ==
X-CSE-MsgGUID: xNdi13Q/QkOl/mSsam120g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="271831002"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 27 Aug 2026 17:42:47 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wzkg8-00000000ACb-1p3b;
	Fri, 28 Aug 2026 00:42:44 +0000
Date: Fri, 28 Aug 2026 08:42:25 +0800
From: kernel test robot <lkp@intel.com>
To: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during
 offline
Message-ID: <202608280832.9NUcmGpu-lkp@intel.com>
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
config: x86_64-randconfig-074-20260828 (https://download.01.org/0day-ci/archive/20260828/202608280832.9NUcmGpu-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260828/202608280832.9NUcmGpu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608280832.9NUcmGpu-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/memcontrol.c:2380:6: warning: no previous prototype for function 'drain_all_stock_sync' [-Wmissing-prototypes]
    2380 | void drain_all_stock_sync(struct mem_cgroup *root_memcg)
         |      ^
   mm/memcontrol.c:2380:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    2380 | void drain_all_stock_sync(struct mem_cgroup *root_memcg)
         | ^
         | static 
   1 warning generated.


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
