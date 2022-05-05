From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Fri, 6 May 2022 00:09:59 +0800
Message-ID: <202205052327.RldmheYL-lkp@intel.com>
References: <20220505033814.103256-1-xu.xin16@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651767060; x=1683303060;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1eGeIh+xMiBRTxqWkXlfYujous1v8oMKzohvreSWsN8=;
  b=FNMAdsi+bg+d8+nosUfVJUoMrzCP+ZwWMIIQ38Sis9BZBryE1ITu1E24
   /F8BHqZsOr/ZDTPD3/safwHP+4+KVD6dds7ponxMCg40eon1sCWXVL/25
   MgLPGzhmn4F/GvSULHgWYJsczT5Tn68ITVnCmq9TG4Os63l3rJxWGULVq
   TqWTOrlj2Pa0QGs7LQUDgdYRrl0hzbogNCb1PQhwlzeDoN5ItvVN+6t4/
   Ql8gC/WlZLP03T/ZV2OodXeDhsnXV6P3g0XvSGZUMRTFlXriAQQH6p7tK
   ObfP/5DoCeyQ3wW46OXSGOvS7iwwOSAM3ZuwhUkRueHfCEKQJJY8iOCeX
   w==;
Content-Disposition: inline
In-Reply-To: <20220505033814.103256-1-xu.xin16-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linux/master]
[also build test WARNING on linus/master v5.18-rc5]
[cannot apply to hnaz-mm/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/cgel-zte-gmail-com/mm-memcg-support-control-THP-behaviour-in-cgroup/20220505-114028
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 107c948d1d3e61d10aee9d0f7c3d81bbee9842af
config: i386-randconfig-s001 (https://download.01.org/0day-ci/archive/20220505/202205052327.RldmheYL-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/f08a35b9798572693a91c6a3d823ed9ae54ef688
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/mm-memcg-support-control-THP-behaviour-in-cgroup/20220505-114028
        git checkout f08a35b9798572693a91c6a3d823ed9ae54ef688
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


sparse warnings: (new ones prefixed by >>)
   mm/huge_memory.c: note: in included file (through include/linux/mm.h):
>> include/linux/huge_mm.h:272:43: sparse: sparse: marked inline, but without a definition
   mm/huge_memory.c: note: in included file:
>> include/linux/khugepaged.h:30:36: sparse: sparse: marked inline, but without a definition
   include/linux/khugepaged.h:31:38: sparse: sparse: marked inline, but without a definition
--
   mm/memory.c:1024:17: sparse: sparse: context imbalance in 'copy_pte_range' - different lock contexts for basic block
   mm/memory.c:1752:16: sparse: sparse: context imbalance in '__get_locked_pte' - different lock contexts for basic block
   mm/memory.c:1800:9: sparse: sparse: context imbalance in 'insert_page' - different lock contexts for basic block
   mm/memory.c:2302:17: sparse: sparse: context imbalance in 'remap_pte_range' - different lock contexts for basic block
   mm/memory.c:2558:17: sparse: sparse: context imbalance in 'apply_to_pte_range' - unexpected unlock
   mm/memory.c:2847:9: sparse: sparse: context imbalance in 'wp_page_copy' - different lock contexts for basic block
   mm/memory.c:3185:17: sparse: sparse: context imbalance in 'wp_pfn_shared' - unexpected unlock
   mm/memory.c:3248:19: sparse: sparse: context imbalance in 'do_wp_page' - different lock contexts for basic block
   mm/memory.c: note: in included file (through include/linux/mm.h):
>> include/linux/huge_mm.h:272:43: sparse: sparse: marked inline, but without a definition
>> include/linux/huge_mm.h:272:43: sparse: sparse: marked inline, but without a definition
