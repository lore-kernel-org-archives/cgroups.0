From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Thu, 31 Aug 2023 11:08:43 +0800
Message-ID: <202308311025.538QuXBV-lkp@intel.com>
References: <20230830175335.1536008-5-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693451331; x=1724987331;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mYEk4LI2pL8XWPF1zKc5qz6vdX12xJGX7KbAifejJ34=;
  b=FcJDNC7z0soWTaunVNw+0vkguzfXZPshXnMQrzTRX32YWy649eQuFfx+
   CEQ6wIkkbMU+9AZvu4AvqHECloNSVSAJ6xTHrXw1s/oRg2D+3sAHCof39
   1HbyqIczXJK/A9Z0PX99iHPncOKNw3AIomi8PdEsHh6N3EfpdxwMRPOeq
   xnqXAJl7JOeV/ORv1uFuWXtQQerrKUupK9AMKrs9JbO6bxlbazwjFuN3V
   auxBZHkPRGCcKGCrTgHPr4Xa21XpZt2AaAKW/sIsIbd1673tItwr2Z2eq
   5SnMaQppUVIZD/iXnAQlQ3mcB+t2o/c7bpZskzSmGnY1Pbgz5pyVz5bXr
   A==;
Content-Disposition: inline
In-Reply-To: <20230830175335.1536008-5-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: llvm-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, oe-kbuild-all-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

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
config: i386-randconfig-r013-20230831 (https://download.01.org/0day-ci/archive/20230831/202308311025.538QuXBV-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230831/202308311025.538QuXBV-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308311025.538QuXBV-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

All warnings (new ones prefixed by >>):

>> mm/memcontrol.c:667:6: warning: no previous prototype for function 'mem_cgroup_user_flush_stats' [-Wmissing-prototypes]
   void mem_cgroup_user_flush_stats(struct mem_cgroup *memcg)
        ^
   mm/memcontrol.c:667:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void mem_cgroup_user_flush_stats(struct mem_cgroup *memcg)
   ^
   static 
   1 warning generated.


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
