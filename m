Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDC647CA87
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 13:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786626992; cv=none; b=mnAb33sDiA6UI3zLxnFr5QYYk51BMFH+2fl3eIhKHRuIVubSliwIrpK5renBOLNEI349LYlhvu1xHniALga/1KJK9i1pLEKhVkNw6hSU1tg8OTo0XNDfm+sh6qOYPuZy8tbqejq8zBP+o6jLVWkd6oFBt1a9QAuxRUdCuR5AWjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786626992; c=relaxed/simple;
	bh=Lf9SZ0pwZEYsjvNWHi7qkXhT5ob7kt+GLztd/lIRdy4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XiN4id0CYCKdF9cKr091kAmL7Pz/T2deEp7kkrGPLct4im28VG+6ZgdaZBpSDmR+2tSkQOSme7jyT9dz/rqppBkHh16RLaBt1e0oyydQERDWoa3SzUwY4QSKwITCTYMGheag1IGZvywxKghSdwv4g1k8CpP2uHqa9SjfL29ugAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PgzDiNbF; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PgzDiNbF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786626990; x=1818162990;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Lf9SZ0pwZEYsjvNWHi7qkXhT5ob7kt+GLztd/lIRdy4=;
  b=PgzDiNbFV/bhFTRXCFmBewZw6rJY2wD/VJXboXVmCXMM20vVonmGHgKj
   rq0XsUApG71ecOSoPQK3jqxzwHdoMYp0v1/RJoO0UaQ9LqGGgZhOcfTSf
   2oJo7B4LQweY2PUZ9+yAvLVr+17XDqeIysAjlrqdWAAG2ZicmJBDamDf5
   BjNL2nrs2idr9nEYJgnS8gSlEZCoHrCQoJd6AVfAlpR4IZu6PBjSHv6Rh
   BevKqTEhrzg2w03pG/5hHN3YUBWUatsp2V2Ksph/4HNCSpWnQ2hpq7tqV
   4aZahjJHmb2CQcOL6IJXq8vDQVjHAF4VhcjzQg5vmHVwR4mbX/0lHuoI5
   Q==;
X-CSE-ConnectionGUID: TEmRQVUpQnWUao3ghlhQoQ==
X-CSE-MsgGUID: EcXEMYDpTtaORWy6afVNvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11873"; a="87221296"
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="87221296"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 06:16:29 -0700
X-CSE-ConnectionGUID: Je51M1g8RjO4yb82bTtaMg==
X-CSE-MsgGUID: a8tbCZAETQO+2o7tS8Y+JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="267454311"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 06:16:26 -0700
Date: Thu, 13 Aug 2026 21:16:22 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, yi1.lai@intel.com
Subject: [linux-next:master] [mm/vmpressure]  ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
Message-ID: <202608131743.c6a7dda4-lkp@intel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Hello,

kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:

commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

in testcase: stress-ng
version: stress-ng-x86_64-29ce10a2c-1_20260712
with following parameters:

	nr_threads: 100%
	testtime: 60s
	test: mremap
	cpufreq_governor: performance



config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
compiler: gcc-14
test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com


2026-08-11 09:13:23 sysctl -w kernel.sched_autogroup_enabled=0 kernel.sched_autogroup_enabled = 0
2026-08-11 09:13:23 stress-ng --timeout 60 --times --verify --metrics --no-rand-seed --mremap 256
stress-ng: info:  [10886] setting to a 1 min run per stressor
stress-ng: info:  [10886] dispatching hogs: 256 mremap
stress-ng: info:  [11033] mremap: using 1MB per stressor instance (total 256MB of 243.06GB available memory)
stress-ng: metrc: [10886] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
stress-ng: metrc: [10886]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
stress-ng: metrc: [10886] mremap          2212529     59.96    209.34  15014.92     36901.22         145.33        99.19          6684
stress-ng: metrc: [10886] miscellaneous metrics:
stress-ng: metrc: [10886] mremap            151372.07 nanosecs per mremap call (harmonic mean of 256 instances)
stress-ng: info:  [10886] for a 60.01s run time:
stress-ng: info:  [10886]   15363.58s available CPU time
stress-ng: info:  [10886]     209.34s user time   (  1.36%)
stress-ng: info:  [10886]   15015.19s system time ( 97.73%)
stress-ng: info:  [10886]   15224.53s total time  ( 99.09%)
stress-ng: info:  [10886] load average: 163.54 47.28 16.30
stress-ng: info:  [10886] skipped: 0
stress-ng: info:  [10886] passed: 256: mremap (256)
stress-ng: info:  [10886] failed: 0
stress-ng: info:  [10886] metrics untrustworthy: 0
stress-ng: info:  [10886] successful run completed in 1 min



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260813/202608131743.c6a7dda4-lkp@intel.com



--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


