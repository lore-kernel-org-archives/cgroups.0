Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712680;
	b=BQb/CV2Gqnf9XBFaRNCeMlYdXyBUYD307NMHQYkf2cFPvu1m4ScHmROhqeuir/lJNgEv
	 k4EJdnPdChnRuBGHxQa+PG/s37uCziosoQm268RnqU3bahXU1LQlv5EOVWCVC2sgZMpwO
	 SgvL1dbm9pB0jUGI9cL8Y0byFLlhSlryJ+Lyx48blVidO2a0NQKOE4CCiC+P2djfXT/0T
	 z5tpyB3lHKBEmxBFK0GSWWcA9IuLKf+5XJ/vnvlWQwvFgbhbQPJAMp1DuWDUBdwVgsY5q
	 4yONS+JZEq1EuJYwwa5WLD3g1vK7zLVTvdX4LMDzGRUxzp5JBUx35Y9QsDagVPr5P2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712680;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=bqSSouDoyJf0YGFehgWYnnk2xGKwMtREqQQCF8wiudg=;
	b=IXI2NedoZHQAf3EwgK7J2dE3e1iFeXHDjGrQN2QSIXPwhcJ7Qv7A/+cAJY/cC4AsAHL3
	 iR8KyLbEDm3cRYYD1n3t4xBi44gXvKksTUSMLsD6A4OS6M4dVcI2RQcoMDHI4mAjK5mIa
	 hDhjVYFjG6IPLC7kRJ8t6yNcqRw1j+oJGvl7T3CAkQVF85mwkBzP7MLHMuXK5xFkFLXCy
	 BdB6aRwFjJvF+1Y9d4F/yCmIwjckpEunakB6FAEUIE+gWQ7dqdbjT08WahK2qR8wyqh8e
	 jhXr+wbUg0CFdQF6+OcZQv1mr1KZKDyFjEJUDjNkxYx4xEsj2IHhGnfFzRsOIIAecvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SBMs4pMo;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A77E606A33A;
	Tue,  3 Nov 2026 13:31:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A77E606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SBMs4pMo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793712680; x=1825248680;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hkR8M4AVECxKSn4GYebF87vUMQPK1tTyUqELFgxgqRs=;
  b=SBMs4pMoauBtpedelBcC49z4kvO8AMo7TtACgeFMjLOfl4DXt66bxMHJ
   XEh4U4rRY32DpnOKeliENg5B02GQ3JiJidpJS/9izMPO9ZCO31XGYrmTr
   lOL4EqqPCT3BibNcwOU2x3jB0Eclj2BAzdtY3JdaneuY+iqALFKtIIGiC
   RlR3fb2d8C9XO5L19+mJ+6k8ZrQvpJfNgso30NmiltPSZCIxEwN7oLilw
   YyAD/2OecJOyqSqFxAeTbofirdkfkLEGBjdJehOaV3POiwrOLbu9ofEgi
   Qqaptfs0Xqz7Lparr2lXq3+yIlGaqQXBWnRleNmGO6sxsWWIxLNi5PeB4
   Q==;
X-CSE-ConnectionGUID: REkoUaqRQcaGfQpDmI1H/g==
X-CSE-MsgGUID: dpZiRuxSRSK1VrSc8Tcorg==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2429900"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2429900"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 05:31:19 -0800
X-CSE-ConnectionGUID: lTrs3dgKTlWdj0SfnJ8l6A==
X-CSE-MsgGUID: kcSFKz+DTo2hkMUZE0wIXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6542067"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 03 Nov 2026 05:31:12 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOEbU-00000000ilw-1efr;
	Tue, 03 Nov 2026 13:31:08 +0000
Date: Tue, 3 Nov 2026 21:30:46 +0800
From: kernel test robot <lkp@intel.com>
To: Matthew Ruffell <matthew.ruffell@canonical.com>,
	Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
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
Message-ID: <202611032138.4bxGcYLC-lkp@intel.com>
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
config: sh-allnoconfig (https://download.01.org/0day-ci/archive/20261103/202611032138.4bxGcYLC-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261103/202611032138.4bxGcYLC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611032138.4bxGcYLC-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/folio.c: In function '__folio_batch_add_and_move':
>> mm/folio.c:293:13: error: implicit declaration of function 'lru_batching_bypassed' [-Wimplicit-function-declaration]
     293 |         if (lru_batching_bypassed())
         |             ^~~~~~~~~~~~~~~~~~~~~


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
