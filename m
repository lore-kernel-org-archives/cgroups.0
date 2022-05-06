From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcg: support control THP behaviour in cgroup
Date: Fri, 6 May 2022 22:29:44 +0800
Message-ID: <202205062206.5pPA18rP-lkp@intel.com>
References: <20220506031804.437642-1-yang.yang29@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651847410; x=1683383410;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/3bQs46ARc9z6IxvGQKAIeVw9c66t2zrtmGP1N90Tss=;
  b=kIlxcGKBxmL8XxzICY8ODoqt39SOIU1lTJf2fwm3FuIJVE0oooGDznnO
   oWtjwc5d1fEMNMC6SPePgk5d6lCIx9KIE0Dh49E+yWN9g5AUCupasuxjD
   w1U76aLwEYMckJcdklun//fIRSnHkqyHTcIujFCj0gLkHg3kiIkIui/kN
   6YIZ8CbwweVEpGO/m6Sg1uUyQCH9euRI7VjJJZtpJ5vUqctcRaDxbgzvG
   e5Kml5gQdYGcPBC5EZlam1VF98PXcImhSxP+FaU5WT1TYZudx6c1iD5s4
   8GFKmLe/M4qP6DO1WmaLv4qgHRq9uq0GZ6UfgRxMJMx5eDgRbuqnooz/i
   Q==;
Content-Disposition: inline
In-Reply-To: <20220506031804.437642-1-yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linux/master linus/master v5.18-rc5 next-20220506]
[cannot apply to hnaz-mm/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/cgel-zte-gmail-com/mm-memcg-support-control-THP-behaviour-in-cgroup/20220506-112100
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
config: s390-randconfig-r013-20220505 (https://download.01.org/0day-ci/archive/20220506/202205062206.5pPA18rP-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: s390-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/01b750c350f3c12ca3908e94dc4447041ac9d89b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/mm-memcg-support-control-THP-behaviour-in-cgroup/20220506-112100
        git checkout 01b750c350f3c12ca3908e94dc4447041ac9d89b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All errors (new ones prefixed by >>):

   s390-linux-ld: mm/shmem.o: in function `shmem_zero_setup':
   shmem.c:(.text+0x380): undefined reference to `khugepaged_always'
>> s390-linux-ld: shmem.c:(.text+0x3f2): undefined reference to `khugepaged_req_madv'
   s390-linux-ld: mm/huge_memory.o: in function `do_huge_pmd_anonymous_page':
>> huge_memory.c:(.text+0x3d9c): undefined reference to `khugepaged_always'
>> s390-linux-ld: huge_memory.c:(.text+0x3e2a): undefined reference to `khugepaged_req_madv'
   s390-linux-ld: mm/khugepaged.o: in function `set_recommended_min_free_kbytes':
   khugepaged.c:(.text+0x1d06): undefined reference to `khugepaged_enabled'
   s390-linux-ld: mm/khugepaged.o: in function `hugepage_vma_check.part.0':
   khugepaged.c:(.text+0x24c4): undefined reference to `khugepaged_always'
   s390-linux-ld: mm/khugepaged.o: in function `khugepaged_wait_work':
   khugepaged.c:(.text+0x2da8): undefined reference to `khugepaged_enabled'
>> s390-linux-ld: khugepaged.c:(.text+0x2e94): undefined reference to `khugepaged_enabled'
   s390-linux-ld: mm/khugepaged.o: in function `khugepaged_do_scan':
   khugepaged.c:(.text+0x46e8): undefined reference to `khugepaged_enabled'
   s390-linux-ld: khugepaged.c:(.text+0x482a): undefined reference to `khugepaged_enabled'
   s390-linux-ld: mm/khugepaged.o: in function `khugepaged_enter_vma_merge':
   khugepaged.c:(.text+0x4bb2): undefined reference to `khugepaged_always'
>> s390-linux-ld: khugepaged.c:(.text+0x4c1a): undefined reference to `khugepaged_req_madv'
   s390-linux-ld: mm/khugepaged.o: in function `start_stop_khugepaged':
   khugepaged.c:(.text+0x4eb6): undefined reference to `khugepaged_enabled'
   s390-linux-ld: mm/khugepaged.o: in function `khugepaged_min_free_kbytes_update':
   khugepaged.c:(.text+0x5066): undefined reference to `khugepaged_enabled'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
