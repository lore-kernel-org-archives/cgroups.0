From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: add the mempolicy interface for cgroup
 v2.
Date: Tue, 24 May 2022 23:02:17 +0800
Message-ID: <202205242200.VGAUIGvw-lkp@intel.com>
References: <20220524103638.473-1-hezhongkun.hzk@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653404594; x=1684940594;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NAtbRL6rOJ7RfXXVkiq9+gyiENENpvBI07+NLn2VSMw=;
  b=c1bdDpux4Sfd5IHYdQSdQ6WSYVmHxybh9l3M+Iv7qA60wduzv0tOOUJC
   xi8TmqJaSms+vB4NcKwAObmfHm/exAnNwiT/cIdqXnMvJwxli8Yyk8xQu
   ipuZKvxDillUdqPaf4/RKCpKl90YbNrO7U0R9uLdH4owUnEjNzx7B3CqQ
   8q1RPsfhaOKy0quVQxl4id6MtOkTh//yGhz+K/9/T3X/1/pznW90uKfx4
   vvy2qGbNx9P3h5yO8KSzQqwa5apcjDaBBVT/ZB/V3Ks07MbhAcrFUApGd
   icgC4/5shiNYySbTlaOtKSywNAJ0yKX/q16yMQR1zZbsbJPDQ9VofzhNE
   Q==;
Content-Disposition: inline
In-Reply-To: <20220524103638.473-1-hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hezhongkun <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org
Cc: llvm-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Hezhongkun <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Hi hezhongkun,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.18 next-20220524]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/hezhongkun/mm-memcontrol-add-the-mempolicy-interface-for-cgroup-v2/20220524-183922
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 143a6252e1b8ab424b4b293512a97cca7295c182
config: x86_64-randconfig-a016 (https://download.01.org/0day-ci/archive/20220524/202205242200.VGAUIGvw-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 10c9ecce9f6096e18222a331c5e7d085bd813f75)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6adb0a02c27c8811bee9783451ee25155baf490e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review hezhongkun/mm-memcontrol-add-the-mempolicy-interface-for-cgroup-v2/20220524-183922
        git checkout 6adb0a02c27c8811bee9783451ee25155baf490e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All error/warnings (new ones prefixed by >>):

>> mm/mempolicy.c:182:29: error: call to undeclared function 'mem_cgroup_from_task'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           struct mem_cgroup *memcg = mem_cgroup_from_task(p);
                                      ^
   mm/mempolicy.c:182:29: note: did you mean 'mem_cgroup_from_css'?
   include/linux/memcontrol.h:1267:20: note: 'mem_cgroup_from_css' declared here
   struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css)
                      ^
>> mm/mempolicy.c:182:21: warning: incompatible integer to pointer conversion initializing 'struct mem_cgroup *' with an expression of type 'int' [-Wint-conversion]
           struct mem_cgroup *memcg = mem_cgroup_from_task(p);
                              ^       ~~~~~~~~~~~~~~~~~~~~~~~
>> mm/mempolicy.c:184:23: error: incomplete definition of type 'struct mem_cgroup'
           pol = (memcg && memcg->mempolicy) ? memcg->mempolicy : get_task_policy(p);
                           ~~~~~^
   include/linux/mm_types.h:31:8: note: forward declaration of 'struct mem_cgroup'
   struct mem_cgroup;
          ^
   mm/mempolicy.c:184:43: error: incomplete definition of type 'struct mem_cgroup'
           pol = (memcg && memcg->mempolicy) ? memcg->mempolicy : get_task_policy(p);
                                               ~~~~~^
   include/linux/mm_types.h:31:8: note: forward declaration of 'struct mem_cgroup'
   struct mem_cgroup;
          ^
   mm/mempolicy.c:179:19: warning: no previous prototype for function 'get_cgrp_or_task_policy' [-Wmissing-prototypes]
   struct mempolicy *get_cgrp_or_task_policy(struct task_struct *p)
                     ^
   mm/mempolicy.c:179:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   struct mempolicy *get_cgrp_or_task_policy(struct task_struct *p)
   ^
   static 
   mm/mempolicy.c:1799:29: error: call to undeclared function 'mem_cgroup_from_task'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           struct mem_cgroup *memcg = mem_cgroup_from_task(current);
                                      ^
   mm/mempolicy.c:1799:21: warning: incompatible integer to pointer conversion initializing 'struct mem_cgroup *' with an expression of type 'int' [-Wint-conversion]
           struct mem_cgroup *memcg = mem_cgroup_from_task(current);
                              ^       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/mempolicy.c:1801:23: error: incomplete definition of type 'struct mem_cgroup'
           pol = (memcg && memcg->mempolicy) ? memcg->mempolicy : get_vma_policy(vma, addr);
                           ~~~~~^
   include/linux/mm_types.h:31:8: note: forward declaration of 'struct mem_cgroup'
   struct mem_cgroup;
          ^
   mm/mempolicy.c:1801:43: error: incomplete definition of type 'struct mem_cgroup'
           pol = (memcg && memcg->mempolicy) ? memcg->mempolicy : get_vma_policy(vma, addr);
                                               ~~~~~^
   include/linux/mm_types.h:31:8: note: forward declaration of 'struct mem_cgroup'
   struct mem_cgroup;
          ^
   3 warnings and 6 errors generated.


vim +/mem_cgroup_from_task +182 mm/mempolicy.c

   178	
   179	struct mempolicy *get_cgrp_or_task_policy(struct task_struct *p)
   180	{
   181		struct mempolicy *pol;
 > 182		struct mem_cgroup *memcg = mem_cgroup_from_task(p);
   183	
 > 184		pol = (memcg && memcg->mempolicy) ? memcg->mempolicy : get_task_policy(p);
   185		return pol;
   186	}
   187	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
