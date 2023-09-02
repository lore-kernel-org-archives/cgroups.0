From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-6.6-fixes] cgroup: Put
 cgroup_local_stat_show() inside CONFIG_CGROUP_SCHED
Date: Sun, 3 Sep 2023 03:43:12 +0800
Message-ID: <202309030303.qSTfRgZC-lkp@intel.com>
References: <ZPNX-jZAZbebizXA@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693683811; x=1725219811;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+9vo+M2L7/MeOyDeQ/8iCmxYZrv+WsA2IvXTKmHiP14=;
  b=jV7cTCYyXWXLfxAZVj2idhK8LrtZe/XYmMhFYr/tAL93k0a0pU6rAwD1
   6Re1A/LWtXaaW9Qzc7/99CiGJObhW0NAgCXtthfmri1W+fs/RSL4H/PVQ
   mibBikCrmEmWJFExAhGMLampOF8GZgg/wh0hdNH6had7hSFHvD6zUDMD0
   02xhX+YCtHAq6GbUqZcWn/0N09E5qdDUGO6v9aI54u1OhkFZrKx+OX237
   DOW2DqDAuHabpt82eEYKp0w3U1nppd55DIMLVVvMoFfiGotz6Z7W7m1Oh
   bRVfF+7Vy3fREW2GQef5DjMFJXku85A+JyIMF/FPR3ukVORYubfZRSusV
   w==;
Content-Disposition: inline
In-Reply-To: <ZPNX-jZAZbebizXA-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Sudip Mukherjee (Codethink)" <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: oe-kbuild-all-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, regressions-cunTk1MwBs/YUNznpcFYbw@public.gmane.org

Hi Tejun,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20230831]
[cannot apply to linus/master v6.5 v6.5-rc7 v6.5-rc6 v6.5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tejun-Heo/cgroup-Put-cgroup_local_stat_show-inside-CONFIG_CGROUP_SCHED/20230902-234358
base:   next-20230831
patch link:    https://lore.kernel.org/r/ZPNX-jZAZbebizXA%40slm.duckdns.org
patch subject: [PATCH cgroup/for-6.6-fixes] cgroup: Put cgroup_local_stat_show() inside CONFIG_CGROUP_SCHED
config: arm-defconfig (https://download.01.org/0day-ci/archive/20230903/202309030303.qSTfRgZC-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: arm-linux-gnueabi-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230903/202309030303.qSTfRgZC-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309030303.qSTfRgZC-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

All warnings (new ones prefixed by >>):

>> kernel/cgroup/cgroup.c:503:36: warning: 'cgroup_tryget_css' defined but not used [-Wunused-function]
     503 | static struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
         |                                    ^~~~~~~~~~~~~~~~~


vim +/cgroup_tryget_css +503 kernel/cgroup/cgroup.c

42809dd4225b2f kernel/cgroup.c        Tejun Heo 2012-11-19  494  
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  495  /**
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  496   * cgroup_tryget_css - try to get a cgroup's css for the specified subsystem
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  497   * @cgrp: the cgroup of interest
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  498   * @ss: the subsystem of interest
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  499   *
08b2b6fdf6b260 kernel/cgroup/cgroup.c Zhen Lei  2021-05-24  500   * Find and get @cgrp's css associated with @ss.  If the css doesn't exist
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  501   * or is offline, %NULL is returned.
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  502   */
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23 @503  static struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  504  						     struct cgroup_subsys *ss)
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  505  {
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  506  	struct cgroup_subsys_state *css;
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  507  
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  508  	rcu_read_lock();
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  509  	css = cgroup_css(cgrp, ss);
a581563f1bef03 kernel/cgroup/cgroup.c Peng Wang 2019-07-03  510  	if (css && !css_tryget_online(css))
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  511  		css = NULL;
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  512  	rcu_read_unlock();
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  513  
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  514  	return css;
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  515  }
d41bf8c9deaed1 kernel/cgroup/cgroup.c Tejun Heo 2017-10-23  516  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
