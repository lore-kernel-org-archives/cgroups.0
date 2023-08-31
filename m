From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Thu, 31 Aug 2023 08:40:39 +0800
Message-ID: <202308310858.19VshX68-lkp@intel.com>
References: <20230830175335.1536008-5-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693442499; x=1724978499;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E0Kpa3glzmhOit+Gfb9EdvlhhILV82Bjg5COBTCvIV4=;
  b=fOeIwm49maEVtyfdf+ter0TurPRe4CWb4FSupeODdTz5RUZRFVZ3DQx8
   72albatUQFdQUHI+WzwsnLvInQgtBo7eE+ho2XCG3vXCeNoN6MJYYsSqV
   0zoLasynUp7xtwRWy0qPKo43wVegbi58uEtEiaqoBmD+45O6ZRUH6dkCt
   n/iN/ZEUpnHkqMZNVVXJfSbjVwg+nsDn0gbn5GykEUCBy7/bMBHSC2r5W
   C6EvC4In22qODZ1iu/eE7EK92/TJx7zNQk1WndhTltIo9xKtigoSCHjol
   MO/eDG4TEnVEFDvokNfzAN6oMnzCksJCr4WXOzQNIK4RQKqkJu1+AQR15
   Q==;
Content-Disposition: inline
In-Reply-To: <20230830175335.1536008-5-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: oe-kbuild-all-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Yosry,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master next-20230830]
[cannot apply to v6.5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yosry-Ahmed/mm-memcg-properly-name-and-document-unified-stats-flushing/20230831-015518
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20230830175335.1536008-5-yosryahmed%40google.com
patch subject: [PATCH v3 4/4] mm: memcg: use non-unified stats flushing for userspace reads
config: m68k-randconfig-r016-20230831 (https://download.01.org/0day-ci/archive/20230831/202308310858.19VshX68-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: m68k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230831/202308310858.19VshX68-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308310858.19VshX68-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

All warnings (new ones prefixed by >>):

>> mm/memcontrol.c:667:6: warning: no previous prototype for 'mem_cgroup_user_flush_stats' [-Wmissing-prototypes]
     667 | void mem_cgroup_user_flush_stats(struct mem_cgroup *memcg)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/mem_cgroup_user_flush_stats +667 mm/memcontrol.c

   658	
   659	/*
   660	 * mem_cgroup_user_flush_stats - do a stats flush for a user read
   661	 * @memcg: memory cgroup to flush
   662	 *
   663	 * Flush the subtree of @memcg. A mutex is used for userspace readers to gate
   664	 * the global rstat spinlock. This protects in-kernel flushers from userspace
   665	 * readers hogging the lock.
   666	 */
 > 667	void mem_cgroup_user_flush_stats(struct mem_cgroup *memcg)
   668	{
   669		mutex_lock(&stats_user_flush_mutex);
   670		do_stats_flush(memcg);
   671		mutex_unlock(&stats_user_flush_mutex);
   672	}
   673	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
