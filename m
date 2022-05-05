From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Thu, 5 May 2022 21:31:19 +0800
Message-ID: <202205052101.TsTEcZoc-lkp@intel.com>
References: <20220505033814.103256-1-xu.xin16@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651757531; x=1683293531;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0n9xKziNJR4TEkk9TsrLeTOHao554U8zzlo+fCxG4Ow=;
  b=HUV3jhWcDBoqOh5Gdqgx7j6ITYlNWOhwFs2Pz03YC9FfbkWBqUM/IMHd
   I8d5FhPJB/w2gX9wFIhD4si6lJv2JqdWwWzO12PvENxAcVbSCfdfF33X/
   f1zDWgj6WzoQ2YkQaMVhJHWr+YAYLTObpFLaYUT8lFw+M1qZZ3OeeRnie
   0m2DbKL5jkKBX5c7zXK/1GR6hJPR8gw4zKpea7/PBF5IbjGnsYVAgY8bA
   hwxI2DePHP+kjJTxfY3BfEJMAkSc8LQGwpr5rjKytdZACHFdw3j4dPcGm
   FjQojIZD7bUpSvF/Ka+X12bXXTBxdQllAn0d3ceF5ynRdSTbralTwaJuZ
   g==;
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
config: i386-randconfig-a001 (https://download.01.org/0day-ci/archive/20220505/202205052101.TsTEcZoc-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/f08a35b9798572693a91c6a3d823ed9ae54ef688
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/mm-memcg-support-control-THP-behaviour-in-cgroup/20220505-114028
        git checkout f08a35b9798572693a91c6a3d823ed9ae54ef688
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All errors (new ones prefixed by >>):

   ld: mm/memory.o: in function `__handle_mm_fault':
>> memory.c:(.text+0xc6f9): undefined reference to `__transparent_hugepage_enabled'
>> ld: memory.c:(.text+0xc751): undefined reference to `__transparent_hugepage_enabled'
   ld: mm/huge_memory.o: in function `transparent_hugepage_active':
>> huge_memory.c:(.text+0x6351): undefined reference to `__transparent_hugepage_enabled'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
