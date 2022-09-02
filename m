From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Add a new isolated mems.policy type.
Date: Fri, 2 Sep 2022 18:00:08 +0800
Message-ID: <202209021748.qgRnQldF-lkp@intel.com>
References: <20220902063303.1057-1-hezhongkun.hzk@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662112836; x=1693648836;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z8Mgib2QatymcoG6hN4+y5eGn6bdmJ5yNpC/dUxkJo4=;
  b=AQjzhRnl2aG82uFSNNRo+e4d8zTE1fOq6vv1D2wIoB8E27qYLkN7P9p8
   YrGikrHC+nhAG04qTCbTdBksBySb8OtHRvi+NWURielimeArATjJ3UEic
   HkasJb5KHhP3Q9JUg6FDObOTeYIjn/klrbt3L0QV42Y+/rcK0RWCy41UA
   l0eRVngyktPC/asdy9E4w+YeK4gZHH136O8IN8OczwpU5u+K9oB+PbRF/
   NGuwfMJB7K1blb0KpvaydaPBifdyBPk9rOWT9twT0fzcgLklgYC6ZiPaU
   AfOKXSVvt6xRlEN8Sj4SaG1kmtT9RnZdyCh44YAXNido9rzYZFG970h1n
   g==;
Content-Disposition: inline
In-Reply-To: <20220902063303.1057-1-hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hezhongkun <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Hi hezhongkun,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on tip/sched/core]
[also build test ERROR on linus/master v6.0-rc3 next-20220901]
[cannot apply to tj-cgroup/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/hezhongkun/cgroup-cpuset-Add-a-new-isolated-mems-policy-type/20220902-143512
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git 53aa930dc4bae6aa269951bd37103083145d6691
config: mips-allyesconfig (https://download.01.org/0day-ci/archive/20220902/202209021748.qgRnQldF-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: mips-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/7b7fbf5ae59ebc703a8d545fabd305563c0f42f6
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review hezhongkun/cgroup-cpuset-Add-a-new-isolated-mems-policy-type/20220902-143512
        git checkout 7b7fbf5ae59ebc703a8d545fabd305563c0f42f6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash kernel/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All errors (new ones prefixed by >>):

   In file included from include/linux/sched.h:22,
                    from include/linux/ratelimit.h:6,
                    from include/linux/dev_printk.h:16,
                    from include/linux/device.h:15,
                    from include/linux/node.h:18,
                    from include/linux/cpu.h:17,
                    from kernel/cgroup/cpuset.c:25:
   kernel/cgroup/cpuset.c: In function 'update_nodemasks_hier':
>> kernel/cgroup/cpuset.c:1867:54: error: 'struct mempolicy' has no member named 'w'
    1867 |                                         cp->mempolicy->w.user_nodemask);
         |                                                      ^~
   include/linux/nodemask.h:163:56: note: in definition of macro 'nodes_and'
     163 |                         __nodes_and(&(dst), &(src1), &(src2), MAX_NUMNODES)
         |                                                        ^~~~
   kernel/cgroup/cpuset.c: In function 'cpuset_change_task_cs_mpol':
>> kernel/cgroup/cpuset.c:2477:12: error: 'struct task_struct' has no member named 'il_prev'
    2477 |         tsk->il_prev = 0;
         |            ^~
   kernel/cgroup/cpuset.c: In function 'cpuset_mpol_write':
   kernel/cgroup/cpuset.c:2525:63: error: 'struct mempolicy' has no member named 'w'
    2525 |                 nodes_and(cs_allowed, cs->effective_mems, mpol->w.user_nodemask);
         |                                                               ^~
   include/linux/nodemask.h:163:56: note: in definition of macro 'nodes_and'
     163 |                         __nodes_and(&(dst), &(src1), &(src2), MAX_NUMNODES)
         |                                                        ^~~~
   kernel/cgroup/cpuset.c: In function 'cpuset_mpol_show':
>> kernel/cgroup/cpuset.c:2558:26: error: 'struct mempolicy' has no member named 'mode'
    2558 |         if (!mpol || mpol->mode == MPOL_DEFAULT)
         |                          ^~
>> kernel/cgroup/cpuset.c:2561:9: error: implicit declaration of function 'mpol_to_str' [-Werror=implicit-function-declaration]
    2561 |         mpol_to_str(buffer, sizeof(buffer), mpol);
         |         ^~~~~~~~~~~
   kernel/cgroup/cpuset.c: In function 'cpuset_css_alloc':
>> kernel/cgroup/cpuset.c:2981:15: error: implicit declaration of function 'mpol_dup'; did you mean 'mpol_put'? [-Werror=implicit-function-declaration]
    2981 |         new = mpol_dup(pcs->mempolicy);
         |               ^~~~~~~~
         |               mpol_put
   kernel/cgroup/cpuset.c:2981:13: warning: assignment to 'struct mempolicy *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    2981 |         new = mpol_dup(pcs->mempolicy);
         |             ^
   cc1: some warnings being treated as errors


vim +1867 kernel/cgroup/cpuset.c

  1821	
  1822	/*
  1823	 * update_nodemasks_hier - Update effective nodemasks and tasks in the subtree
  1824	 * @cs: the cpuset to consider
  1825	 * @new_mems: a temp variable for calculating new effective_mems
  1826	 *
  1827	 * When configured nodemask is changed, the effective nodemasks of this cpuset
  1828	 * and all its descendants need to be updated.
  1829	 *
  1830	 * On legacy hierarchy, effective_mems will be the same with mems_allowed.
  1831	 *
  1832	 * Called with cpuset_rwsem held
  1833	 */
  1834	static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
  1835	{
  1836		struct cpuset *cp;
  1837		struct cgroup_subsys_state *pos_css;
  1838		nodemask_t cs_allowed;
  1839	
  1840		rcu_read_lock();
  1841		cpuset_for_each_descendant_pre(cp, pos_css, cs) {
  1842			struct cpuset *parent = parent_cs(cp);
  1843	
  1844			nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
  1845	
  1846			/*
  1847			 * If it becomes empty, inherit the effective mask of the
  1848			 * parent, which is guaranteed to have some MEMs.
  1849			 */
  1850			if (is_in_v2_mode() && nodes_empty(*new_mems))
  1851				*new_mems = parent->effective_mems;
  1852	
  1853			/* Skip the whole subtree if the nodemask remains the same. */
  1854			if (nodes_equal(*new_mems, cp->effective_mems)) {
  1855				pos_css = css_rightmost_descendant(pos_css);
  1856				continue;
  1857			}
  1858	
  1859			if (!css_tryget_online(&cp->css))
  1860				continue;
  1861			rcu_read_unlock();
  1862	
  1863			spin_lock_irq(&callback_lock);
  1864	
  1865			if (cp->mempolicy)
  1866				nodes_and(cs_allowed, *new_mems,
> 1867						cp->mempolicy->w.user_nodemask);
  1868			mpol_rebind_policy(cp->mempolicy, &cs_allowed);
  1869			cp->effective_mems = *new_mems;
  1870			spin_unlock_irq(&callback_lock);
  1871	
  1872			WARN_ON(!is_in_v2_mode() &&
  1873				!nodes_equal(cp->mems_allowed, cp->effective_mems));
  1874	
  1875			update_tasks_nodemask(cp);
  1876	
  1877			rcu_read_lock();
  1878			css_put(&cp->css);
  1879		}
  1880		rcu_read_unlock();
  1881	}
  1882	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
