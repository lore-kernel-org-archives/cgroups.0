From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] net: set proper memcg for net_init hooks allocations
Date: Sat, 23 Apr 2022 17:39:52 +0800
Message-ID: <202204231728.QUjBA8ZH-lkp@intel.com>
References: <6f38e02b-9af3-4dcf-9000-1118a04b13c7@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650706818; x=1682242818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x4gibxkXSQUSgz2sAF3rTXs7Ao5Dc8l24/Si0JmeV2U=;
  b=ms/r9cQX4PjjvNTb/1041EJXpo/i4wnPy2C0hpQjGEbj93alVKvdTWJd
   L+BPi0czykAGOFgJXf/8yKIQqBsvrfxF0x3pXaRp9O4Ko+L1z65A4b16y
   ISv8YDPAxQQQf/B+djgBabo9Bnq8kSWSK8cBfS7A2zFTA3sqat165kZXW
   DFXEFyDzcYhmGemd3Dm/6vdkNyXHBZCSLEF06DoOVvcdCftYekZVkayvH
   JTW2PCNd2ymo9Z4lJYa5NW58y6zi8fyOTehOPlz01DVp9iyYXuJ8H9cbT
   dVMynNkmtYHrb5C8kesT+GQ6LwanrJXe7JwLYBXtwGlVZGjL0ZxDKkxpR
   w==;
Content-Disposition: inline
In-Reply-To: <6f38e02b-9af3-4dcf-9000-1118a04b13c7-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: llvm-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi Vasily,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.18-rc3 next-20220422]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Vasily-Averin/net-set-proper-memcg-for-net_init-hooks-allocations/20220423-160759
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git c00c5e1d157bec0ef0b0b59aa5482eb8dc7e8e49
config: powerpc-buildonly-randconfig-r004-20220422 (https://download.01.org/0day-ci/archive/20220423/202204231728.QUjBA8ZH-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5bd87350a5ae429baf8f373cb226a57b62f87280)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install powerpc cross compiling tool for clang build
        # apt-get install binutils-powerpc-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/3b379e5391e36e13b9f36305aa6d233fb03d4e58
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vasily-Averin/net-set-proper-memcg-for-net_init-hooks-allocations/20220423-160759
        git checkout 3b379e5391e36e13b9f36305aa6d233fb03d4e58
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=powerpc prepare

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All errors (new ones prefixed by >>):

   In file included from arch/powerpc/kernel/asm-offsets.c:21:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
>> include/linux/memcontrol.h:1773:38: error: incomplete definition of type 'struct mem_cgroup'
           } while (memcg && !css_tryget(&memcg->css));
                                          ~~~~~^
   include/linux/mm_types.h:31:8: note: forward declaration of 'struct mem_cgroup'
   struct mem_cgroup;
          ^
   1 error generated.
   make[2]: *** [scripts/Makefile.build:120: arch/powerpc/kernel/asm-offsets.s] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [Makefile:1194: prepare0] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:219: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +1773 include/linux/memcontrol.h

  1765	
  1766	static inline struct mem_cgroup *get_mem_cgroup_from_kmem(void *p)
  1767	{
  1768		struct mem_cgroup *memcg;
  1769	
  1770		rcu_read_lock();
  1771		do {
  1772			memcg = mem_cgroup_from_obj(p);
> 1773		} while (memcg && !css_tryget(&memcg->css));

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
