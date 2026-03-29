Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1811B344DAB;
	Sun, 29 Mar 2026 11:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774782652; cv=none; b=Q/TAXchdt80t6cL2inzM3lDzRS89nTr9BO7OG+mSWu3rOn0myRAHTJ0k/v0FoTMCrbLZLamkr+ClJ+67oesjrn/NSFc8h+0yKJ4JVmAoMewSnOtN8QPpCYMla1m6O+id7GEBqeJfj6yg7gU7Y6qi5YHB/5UXGbAEt3T0smckQwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774782652; c=relaxed/simple;
	bh=HSIx2LO02QH/6HF5EjjOZpEuKotkH/5qG4AaR3HsyBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSC8jtQmRWARxtg4ZEEZwEi2/uvE5c9+1ctfDsEhMnZ3mjbaUw1rIl9ZXzaOaTqlVx29Wvdlh/t41agR5lx17zaO+McTdmaqb6rsoXKmvYMruSYL1x9NKhwF7gySQbh0gcClcy9WVIEBJSJkAVV1E6+TR9zskwFlkxCRnOgtLoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fwc1eDtS; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fwc1eDtS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774782650; x=1806318650;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HSIx2LO02QH/6HF5EjjOZpEuKotkH/5qG4AaR3HsyBQ=;
  b=fwc1eDtSmqo8PoeN+FLKKZuEwiO6CvVFswIiAwcCilYf/5d3q93WY9PJ
   vuhUpVXR7vDV0GqxPeCg2W9Ov25i/oNhKzDSG5Gido/hCFeDHYyF9We0g
   e4wXeXdKGaNJukmdc9tzrSh8fg51oX0W9s09qiRgY+31JJ3X/C8YJakQM
   i3oamPdjTx/M+WIEuGhOIAzchwcQGxzTreHqLFsJ7mpOGEyXcZwLC+cJ3
   XmHG7ipUP3xFZDa4gRckJr1MCcyn21CPiupneYIsl9ffKB9D3QH6qaCYE
   HrlSFErsmXLJ1aZLWIie6ZyjrzuBXj9de59kUPUXJLoG9+FJV5mTIWKYw
   g==;
X-CSE-ConnectionGUID: 6z6RpIugS4G9xmLnV7XngQ==
X-CSE-MsgGUID: fgFJqPWZSTyH1htGhYVx+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="93179810"
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="93179810"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 04:10:50 -0700
X-CSE-ConnectionGUID: TIhXxH2NTkiv3cMrceKMMQ==
X-CSE-MsgGUID: Q79xZq8XQEujZC6TnehROw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="229848130"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 29 Mar 2026 04:10:45 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6o2T-00000000CJ7-1TfT;
	Sun, 29 Mar 2026 11:10:41 +0000
Date: Sun, 29 Mar 2026 19:10:20 +0800
From: kernel test robot <lkp@intel.com>
To: Youngjun Park <youngjun.park@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Chris Li <chrisl@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com
Subject: Re: [PATCH v5 3/4] mm: memcontrol: add interfaces for swap tier
 selection
Message-ID: <202603291945.9q4pyvON-lkp@intel.com>
References: <20260325175453.2523280-4-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325175453.2523280-4-youngjun.park@lge.com>

Hi Youngjun,

kernel test robot noticed the following build errors:

[auto build test ERROR on 6381a729fa7dda43574d93ab9c61cec516dd885b]

url:    https://github.com/intel-lab-lkp/linux/commits/Youngjun-Park/mm-swap-introduce-swap-tier-infrastructure/20260327-203639
base:   6381a729fa7dda43574d93ab9c61cec516dd885b
patch link:    https://lore.kernel.org/r/20260325175453.2523280-4-youngjun.park%40lge.com
patch subject: [PATCH v5 3/4] mm: memcontrol: add interfaces for swap tier selection
config: hexagon-randconfig-002-20260329 (https://download.01.org/0day-ci/archive/20260329/202603291945.9q4pyvON-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 054e11d1a17e5ba88bb1a8ef32fad3346e80b186)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260329/202603291945.9q4pyvON-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603291945.9q4pyvON-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/swap_tier.c:141:10: warning: format specifies type 'long' but the argument has type '__ptrdiff_t' (aka 'int') [-Wformat]
     139 |                 len += sysfs_emit_at(buf, len, "%-16s %-5ld %-11d %-11d\n",
         |                                                       ~~~~~
         |                                                       %-5td
     140 |                                      tier->name,
     141 |                                      TIER_IDX(tier),
         |                                      ^~~~~~~~~~~~~~
   mm/swap_tier.c:33:24: note: expanded from macro 'TIER_IDX'
      33 | #define TIER_IDX(tier)  ((tier) - swap_tiers)
         |                         ^~~~~~~~~~~~~~~~~~~~~
>> mm/swap_tier.c:342:8: error: incomplete definition of type 'struct mem_cgroup'
     342 |                 child->tier_mask |= mask;
         |                 ~~~~~^
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   mm/swap_tier.c:343:8: error: incomplete definition of type 'struct mem_cgroup'
     343 |                 child->tier_effective_mask |= mask;
         |                 ~~~~~^
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   mm/swap_tier.c:420:20: error: incomplete definition of type 'struct mem_cgroup'
     420 |                 = parent ? parent->tier_effective_mask : TIER_ALL_MASK;
         |                            ~~~~~~^
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   mm/swap_tier.c:422:7: error: incomplete definition of type 'struct mem_cgroup'
     422 |         memcg->tier_effective_mask
         |         ~~~~~^
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   mm/swap_tier.c:423:27: error: incomplete definition of type 'struct mem_cgroup'
     423 |                 = effective_mask & memcg->tier_mask;
         |                                    ~~~~~^
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   1 warning and 5 errors generated.


vim +342 mm/swap_tier.c

   330	
   331	/*
   332	 * When a tier is removed, set its bit in every memcg's tier_mask and
   333	 * tier_effective_mask. This prevents stale tier indices from being
   334	 * silently filtered out if the same index is reused later.
   335	 */
   336	static void swap_tier_memcg_propagate(int mask)
   337	{
   338		struct mem_cgroup *child;
   339	
   340		rcu_read_lock();
   341		for_each_mem_cgroup_tree(child, root_mem_cgroup) {
 > 342			child->tier_mask |= mask;
   343			child->tier_effective_mask |= mask;
   344		}
   345		rcu_read_unlock();
   346	}
   347	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
