From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 4/7] mm: page_owner: add support for splitting to any
 order in split page_owner.
Date: Wed, 29 Mar 2023 22:48:41 +0800
Message-ID: <202303292237.pg39cTKv-lkp@intel.com>
References: <20230329011712.3242298-5-zi.yan@sent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680101340; x=1711637340;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/JwzapEZeOEBEAVO2IFsUIdXBxnyulcntsu8vKQEY0I=;
  b=PEpHPACXgoLWWEev4d5mOiNasffK/Sbxm0fkkYdUCIWJGsCmqSNSpLy0
   v3T8EX+qtf1OT7SRX64ApqV1IfPXNdV2RubOpNl/+630gLg8zr4DpHawX
   A/O2RKxPUNgv8oTLH/SAhXgPRC/DiYoOL60Lt/s2eeLB6nGIWs7/HQeu+
   eFXXneNpDuk6tTPVb+S6jxgvVGxat73KE/QW54CoLhTAi9Jmmy9Qz5z63
   YX3KzQk6abDVyuy7WRvti99rZ0WAAnmZFNQnz17KNeMHygcacE9cpniDt
   JOZRi6+iPrZ43rjdtcM/pDNlEVLL1/InbCvbZNu34nMbOf3TyG6OEedC1
   w==;
Content-Disposition: inline
In-Reply-To: <20230329011712.3242298-5-zi.yan-vRdzynncJC4@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: llvm-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, oe-kbuild-all-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Zi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.3-rc4 next-20230329]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zi-Yan/mm-memcg-use-order-instead-of-nr-in-split_page_memcg/20230329-091809
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20230329011712.3242298-5-zi.yan%40sent.com
patch subject: [PATCH v2 4/7] mm: page_owner: add support for splitting to any order in split page_owner.
config: x86_64-randconfig-a016 (https://download.01.org/0day-ci/archive/20230329/202303292237.pg39cTKv-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6d1831c0e01a1a742e026454fe6e5643e08c5985
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Zi-Yan/mm-memcg-use-order-instead-of-nr-in-split_page_memcg/20230329-091809
        git checkout 6d1831c0e01a1a742e026454fe6e5643e08c5985
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
| Link: https://lore.kernel.org/oe-kbuild-all/202303292237.pg39cTKv-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

All error/warnings (new ones prefixed by >>):

>> mm/page_owner.c:226:14: error: implicit declaration of function 'lookup_page_ext' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
                   page_ext = lookup_page_ext(page + i);
                              ^
>> mm/page_owner.c:226:12: warning: incompatible integer to pointer conversion assigning to 'struct page_ext *' from 'int' [-Wint-conversion]
                   page_ext = lookup_page_ext(page + i);
                            ^ ~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning and 1 error generated.


vim +/lookup_page_ext +226 mm/page_owner.c

   213	
   214	void __split_page_owner(struct page *page, int old_order, int new_order)
   215	{
   216		int i;
   217		struct page_ext *page_ext = page_ext_get(page);
   218		struct page_owner *page_owner;
   219		unsigned int old_nr = 1 << old_order;
   220		unsigned int new_nr = 1 << new_order;
   221	
   222		if (unlikely(!page_ext))
   223			return;
   224	
   225		for (i = 0; i < old_nr; i += new_nr) {
 > 226			page_ext = lookup_page_ext(page + i);
   227			page_owner = get_page_owner(page_ext);
   228			page_owner->order = new_order;
   229		}
   230		page_ext_put(page_ext);
   231	}
   232	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
