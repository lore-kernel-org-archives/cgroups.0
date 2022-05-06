From: kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] mm/memcg: support control THP behaviour in cgroup
Date: Sat, 7 May 2022 07:12:20 +0800
Message-ID: <202205070730.ekn8xxfz-lkp@intel.com>
References: <20220506031804.437642-1-yang.yang29@zte.com.cn>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651878780; x=1683414780;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ivKLSc3Gz/VoaAyyf+KCJfvGkIFxkKCWMielKh/Fppg=;
  b=GVG6h9CZA1jfByghGDw1R65aQ32f9pMEAdoBEWbj90Q0r5YLFXDnmcc6
   dh1y0+Gc0N/ECEjmrkCTLfd7tnJ4sn/Ukd4PFBc3r1uNYrfCl8iWoghnc
   IYW/1mujkVQVidenIlzhdOTOd8YRtrBDcCPG8wqOsUmta/rkddahyW0M/
   q0HT1+3COSeLNnyxnWEQgY2k5ZnqblheXYJN5ZuVT47571pdmUBx3ctuH
   xh/k4jgxKjA0rxZ5RSJA2naZCe0I84Yf+iM56o2B0mSyttNGpFq57oSGh
   khYBJZMBc20RExNu/JfzomMgjw2OdoQC5iF3tvdqgsPyLljBy3G/W72Fa
   w==;
Content-Disposition: inline
In-Reply-To: <20220506031804.437642-1-yang.yang29@zte.com.cn>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgel.zte@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, willy@infradead.org, shy828301@gmail.com
Cc: kbuild-all@lists.01.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, linmiaohe@huawei.com, hughd@google.com, songmuchun@bytedance.com, surenb@google.com, vbabka@suse.cz, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, william.kucharski@oracle.com, peterx@redhat.com, Yang Yang <yang.yang29@zte.com.cn>

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
config: arm64-randconfig-r005-20220506 (https://download.01.org/0day-ci/archive/20220507/202205070730.ekn8xxfz-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/01b750c350f3c12ca3908e94dc4447041ac9d89b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/mm-memcg-support-control-THP-behaviour-in-cgroup/20220506-112100
        git checkout 01b750c350f3c12ca3908e94dc4447041ac9d89b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   aarch64-linux-ld: Unexpected GOT/PLT entries detected!
   aarch64-linux-ld: Unexpected run-time procedure linkages detected!
   aarch64-linux-ld: mm/shmem.o: in function `shmem_zero_setup':
   shmem.c:(.text+0x6a0): undefined reference to `khugepaged_always'
>> aarch64-linux-ld: shmem.c:(.text+0x6b4): undefined reference to `khugepaged_req_madv'
   aarch64-linux-ld: mm/huge_memory.o: in function `do_huge_pmd_anonymous_page':
   huge_memory.c:(.text+0x3a78): undefined reference to `khugepaged_always'
>> aarch64-linux-ld: huge_memory.c:(.text+0x3a8c): undefined reference to `khugepaged_req_madv'
   aarch64-linux-ld: mm/khugepaged.o: in function `hugepage_vma_check':
   khugepaged.c:(.text+0x1370): undefined reference to `khugepaged_always'
   aarch64-linux-ld: mm/khugepaged.o: in function `set_recommended_min_free_kbytes':
   khugepaged.c:(.text+0x1654): undefined reference to `khugepaged_enabled'
   aarch64-linux-ld: mm/khugepaged.o: in function `khugepaged_wait_work':
   khugepaged.c:(.text+0x1b08): undefined reference to `khugepaged_enabled'
>> aarch64-linux-ld: khugepaged.c:(.text+0x1c4c): undefined reference to `khugepaged_enabled'
   aarch64-linux-ld: mm/khugepaged.o: in function `khugepaged_do_scan':
   khugepaged.c:(.text+0x3a58): undefined reference to `khugepaged_enabled'
   aarch64-linux-ld: khugepaged.c:(.text+0x3b10): undefined reference to `khugepaged_enabled'
   aarch64-linux-ld: mm/khugepaged.o: in function `khugepaged_enter_vma_merge':
   khugepaged.c:(.text+0x3f6c): undefined reference to `khugepaged_always'
>> aarch64-linux-ld: khugepaged.c:(.text+0x3f80): undefined reference to `khugepaged_req_madv'
   aarch64-linux-ld: mm/khugepaged.o: in function `start_stop_khugepaged':
   khugepaged.c:(.text+0x42ec): undefined reference to `khugepaged_enabled'
   aarch64-linux-ld: mm/khugepaged.o: in function `khugepaged_min_free_kbytes_update':
   khugepaged.c:(.text+0x442c): undefined reference to `khugepaged_enabled'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
