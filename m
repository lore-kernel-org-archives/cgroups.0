From: kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 5/9] cgroup/cpuset: Add cpuset.cpus.exclusive for v2
Date: Tue, 27 Jun 2023 12:12:37 +0800
Message-ID: <202306271214.Vd5UDf4Y-lkp@intel.com>
References: <20230627005529.1564984-6-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687839180; x=1719375180;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e1b0fi0vY8js4lH2qqnZOIMHiQIDCirQwxuk84EGyQM=;
  b=H7DOV8VfFryKhYQJ0A5/yOhjfxkzDC3QjXJM5nHLf4QahDlICjsi+sfx
   XDKSOwO8i8+mZ5NPbOdjgA0ACiF0lnzuBl+nPnxf3uH8YTGlNX8LvioqU
   V7/+jb5S0vkg83s6Ct3iIAhJXpGcxnv4Q6MOldNDYHYUAJbopW53q4slO
   7b9O/udQtpSuSJX6GdtlL7iDtq80lJJkxtGNULnu8PtGtq0qSoKahhv58
   EjJo6LbR/OzHP0QEVFn1Okkp0pDksEOQCUEg588iiqA2wJWx6JgEpdugM
   Aflq5+Hn6W9xOz8eQ9zJkqieMD3MDGrg60iATNjiZ9zdOY696G7om49fd
   Q==;
Content-Disposition: inline
In-Reply-To: <20230627005529.1564984-6-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>, Waiman Long <longman@redhat.com>

Hi Waiman,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20230626]
[also build test ERROR on v6.4]
[cannot apply to tj-cgroup/for-next linus/master v6.4 v6.4-rc7 v6.4-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Waiman-Long/cgroup-cpuset-Inherit-parent-s-load-balance-state-in-v2/20230627-090025
base:   next-20230626
patch link:    https://lore.kernel.org/r/20230627005529.1564984-6-longman%40redhat.com
patch subject: [PATCH v3 5/9] cgroup/cpuset: Add cpuset.cpus.exclusive for v2
config: s390-defconfig (https://download.01.org/0day-ci/archive/20230627/202306271214.Vd5UDf4Y-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230627/202306271214.Vd5UDf4Y-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306271214.Vd5UDf4Y-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/cgroup/cpuset.c: In function 'cpu_exclusive_check':
>> kernel/cgroup/cpuset.c:699:15: error: assignment to expression with array type
     699 |         cpus1 = cpumask_empty(cs1->exclusive_cpus)
         |               ^
   kernel/cgroup/cpuset.c:701:15: error: assignment to expression with array type
     701 |         cpus2 = cpumask_empty(cs2->exclusive_cpus)
         |               ^


vim +699 kernel/cgroup/cpuset.c

   689	
   690	/*
   691	 * cpu_exclusive_check() - check if two cpusets are exclusive
   692	 *
   693	 * Return 0 if exclusive, -EINVAL if not
   694	 */
   695	static inline bool cpu_exclusive_check(struct cpuset *cs1, struct cpuset *cs2)
   696	{
   697		cpumask_var_t cpus1, cpus2;
   698	
 > 699		cpus1 = cpumask_empty(cs1->exclusive_cpus)
   700			? cs1->cpus_allowed : cs1->exclusive_cpus;
   701		cpus2 = cpumask_empty(cs2->exclusive_cpus)
   702			? cs2->cpus_allowed : cs2->exclusive_cpus;
   703	
   704		if (cpumask_intersects(cpus1, cpus2))
   705			return -EINVAL;
   706		return 0;
   707	}
   708	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
