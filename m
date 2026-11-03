Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793710457;
	b=hHZ7DZ62XlAG2vcE+7lEF2UjMCuJYxhHvKuyKx1KVZ+zfc1lNUqBE/EODrbkPBnChAuZ
	 4dS+zt/tJAsbfFI/LOl2kYvW2zzceEk+Guim5GbXlFkYTlGZang5hHDjijLdfHEQ7P6U/
	 /OV38zGFtza7h+JV/8+GxNKwlFIaXBzGyDvlhb3SRUC8+ufpMvdzNtYq7TX3Gb7wKevSe
	 REiC7RZ2MCtLKfLY9H0u+qZjZnMRvDXcmf4WYnFxDOjX5mALiLF5T3bplibOXKKxvatQZ
	 0Zg6QZ6SGP59hAfIEqJj+114DDyo8S59KM1zM3k5W99e6Vh0i8DCRn5TJmrJkb7laZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793710457;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=T84aiAJqcr9eIc+RMHEdRg8f3K7zIQJ4MBqlwh+rBPc=;
	b=1cKeOjacCyOG9Tce5+Oohvs/upubk8ETiszWAeSOVoODQGoxRCms+ICyuo7AhFeVJlln
	 nhsDq0v48OSBE9EmG260kQ8mmnz1EVeAA3qvTCBTICG0ReWR28HCsFeRFjDXoWGEeUXZM
	 9PQQ7WevTC5eajnZHWc8xEg5Mt5yvJAvLxAsVsv+bTnR5P/E5IZi9rj4kqVCF2bP5CLlL
	 nobvTZYDO3dWQYtkRJNhcFonlWq8gvKxRsOmcjt+/HDiYYzyhmVPn0KP0vZ9hhnnNVbbD
	 hyG2S4WNOhgTNJ0l7HdiT/Dykd9XeoaAsREuoxFVVRnaTn0kTxVPxzm+2YsW7i69Zlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mMsegJ5d;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8BA606A32F;
	Tue,  3 Nov 2026 12:54:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE8BA606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mMsegJ5d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793710454; x=1825246454;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IhRkmlNFW8wvqh1/ycRf3KZ3oTStQ6uioF6qvXYIdxs=;
  b=mMsegJ5dKg6nPnD0khk1DwMuw8ekVkHkKZAm3a9AvqaqWnMn8udLFEdq
   CW51kiwgk0aMyd9r1rpBJqHaOdQKD5ddqDJhAjOLIA+3+1UrBzjqI+5K0
   iKfPbmsoaUALpZQaV6EPs2+1mhRDbY6C5Cj+kokYkXsqrWEms5RSBeNvk
   2f0PGyYWQnzq1Oh4obBpGkrp4IYogNTD75pSyTSVLrOjO0t7wVXpNRxoA
   iJgt7zubVj0zJd9asR7v4EQ8jeopApDqDw3ngtsxoHVOlBsJ268ATqvNM
   WIwrUZc0zIobaw+jLsfKAWtEmS1dQ1bvHJsov7ENVnwM73hwoih9E7BUf
   w==;
X-CSE-ConnectionGUID: 3LCnV0BxRqG3LKfyLylI7A==
X-CSE-MsgGUID: v8ont5CzReat21RRZ1HWqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2323234"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2323234"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 04:54:13 -0800
X-CSE-ConnectionGUID: bIrfVphKRsiEpMbkrvetPA==
X-CSE-MsgGUID: 3fvg2CqPSWirao/zO/h4zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="8203943"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 03 Nov 2026 04:54:07 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOE1a-00000000ik4-3PiJ;
	Tue, 03 Nov 2026 12:54:02 +0000
Date: Tue, 3 Nov 2026 20:53:34 +0800
From: kernel test robot <lkp@intel.com>
To: Matthew Ruffell <matthew.ruffell@canonical.com>,
	Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/folio, mm/mlock: Don't batch folios in per-CPU
 LRU caches on isolated CPUs
Message-ID: <202611032053.I3Ud8d11-lkp@intel.com>
References: <20261103075940.110308-4-matthew.ruffell@canonical.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103075940.110308-4-matthew.ruffell@canonical.com>

Hi Matthew,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthew-Ruffell/sched-isolation-Consider-nohz_full-CPUs-isolated-in-cpu_is_isolated-again/20261103-205935
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20261103075940.110308-4-matthew.ruffell%40canonical.com
patch subject: [PATCH 3/6] mm/folio, mm/mlock: Don't batch folios in per-CPU LRU caches on isolated CPUs
config: um-allnoconfig (https://download.01.org/0day-ci/archive/20261103/202611032053.I3Ud8d11-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261103/202611032053.I3Ud8d11-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611032053.I3Ud8d11-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/folio.c:293:6: error: call to undeclared function 'lru_batching_bypassed'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     293 |         if (lru_batching_bypassed())
         |             ^
   1 error generated.


vim +/lru_batching_bypassed +293 mm/folio.c

   280	
   281	static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
   282			struct folio *folio, move_fn_t move_fn, bool disable_irq)
   283	{
   284		unsigned long flags;
   285	
   286		folio_get(folio);
   287	
   288		if (disable_irq)
   289			local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
   290		else
   291			local_lock(&cpu_fbatches.lock);
   292	
 > 293		if (lru_batching_bypassed())
   294			folio_move_lru_now(folio, move_fn);
   295		else if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
   296				!folio_may_be_lru_cached(folio) || lru_cache_disabled())
   297			folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
   298	
   299		if (disable_irq)
   300			local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
   301		else
   302			local_unlock(&cpu_fbatches.lock);
   303	}
   304	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
