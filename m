From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Thu, 5 May 2022 20:49:47 +0800
Message-ID: <202205052006.qFYTjcyt-lkp@intel.com>
References: <20220505033814.103256-1-xu.xin16@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651755013; x=1683291013;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A9PXcXkJKXOiPlbiJL9+S1g3O2eDE4FkjAv8/9Dq67g=;
  b=m7jai3T36OY75WFYibDaVdjr0qQkh5wOl6MtJyrjDpy0GNGycZEsFOar
   /dBOLGgUexM0hUngYQfl9cz6/ws1xamE+ETcMHaZdDaU7XeuFVbi385in
   GcLS5oPlMaUrh/BeQZ0jHL6aiLfuWPorXuJsTCB+B1/M3SVRCzv6DeIPY
   gD4rOcg+eS7Oryj9kn7ZA36g2KNTCCJvbHw2OL40aA5fZMJH0F2D27VIt
   9agn6HqRXoc5OSFpNwv3shpzmtS5Zsc8HUEKscCfi/s5SQFA4Fr+iwTeH
   qErsDc1w0/Gh/74GnZiDhgPforyovwM4+dW2/lzhprO/K6mWKiT7AzhZk
   Q==;
Content-Disposition: inline
In-Reply-To: <20220505033814.103256-1-xu.xin16-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linux/master]
[also build test ERROR on linus/master v5.18-rc5 next-20220505]
[cannot apply to hnaz-mm/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/cgel-zte-gmail-com/mm-memcg-support-control-THP-behaviour-in-cgroup/20220505-114028
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 107c948d1d3e61d10aee9d0f7c3d81bbee9842af
config: mips-decstation_64_defconfig (https://download.01.org/0day-ci/archive/20220505/202205052006.qFYTjcyt-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: mips64el-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f08a35b9798572693a91c6a3d823ed9ae54ef688
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/mm-memcg-support-control-THP-behaviour-in-cgroup/20220505-114028
        git checkout f08a35b9798572693a91c6a3d823ed9ae54ef688
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All errors (new ones prefixed by >>):

   mips64el-linux-ld: mm/memory.o: in function `__handle_mm_fault':
   memory.c:(.text+0x60a8): undefined reference to `__transparent_hugepage_enabled'
>> mips64el-linux-ld: memory.c:(.text+0x6108): undefined reference to `__transparent_hugepage_enabled'
   mips64el-linux-ld: mm/huge_memory.o: in function `transparent_hugepage_active':
   huge_memory.c:(.text+0x21e4): undefined reference to `__transparent_hugepage_enabled'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
