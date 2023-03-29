From: kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 4/7] mm: page_owner: add support for splitting to any
 order in split page_owner.
Date: Wed, 29 Mar 2023 17:58:44 +0800
Message-ID: <202303291732.7OqWI96E-lkp@intel.com>
References: <20230329011712.3242298-5-zi.yan@sent.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680083936; x=1711619936;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L329AyF3OgVN9WsY0kOL7oj+CaQXmNshjdDst3A4NC8=;
  b=LPiiCvEDsDa7Ajl75aAYPrUy51vTISx0HxCwD2fI3hY3eAVmlU4tlP1F
   IkGHrVUCzKmt1veMHLlgTc2U9Bqnn6FNAchYSNfsLBiXOrdgyQ1nvkcvT
   b54bOhHz0jJFvvEbB3plSI0BVW8kf4SaiUuMbpYdEYsPyNs/fOccTY8hh
   kYOLa/M+Sls/8CM79iDeVZwo1op2pbCOqJfGayCgmSX1MerbPCw8r4pM+
   gR0fweeZ08idY+anbGOXcGZWQloRjeBKWK2ez/JfqT64+Zx4BEMLN2Dl+
   mouxUJxRbqDSlbEDJ3T5boY2q6sbBR5rxXbR2qm7bhEsjTkevtEkfvsvF
   Q==;
Content-Disposition: inline
In-Reply-To: <20230329011712.3242298-5-zi.yan@sent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zi Yan <zi.yan@sent.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yang Shi <shy828301@gmail.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, Zi Yan <ziy@nvidia.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ryan Roberts <ryan.roberts@arm.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, Zach O'Keefe <zokeefe@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org

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
config: i386-randconfig-m021 (https://download.01.org/0day-ci/archive/20230329/202303291732.7OqWI96E-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/6d1831c0e01a1a742e026454fe6e5643e08c5985
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Zi-Yan/mm-memcg-use-order-instead-of-nr-in-split_page_memcg/20230329-091809
        git checkout 6d1831c0e01a1a742e026454fe6e5643e08c5985
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303291732.7OqWI96E-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/page_owner.c: In function '__split_page_owner':
>> mm/page_owner.c:226:28: error: implicit declaration of function 'lookup_page_ext' [-Werror=implicit-function-declaration]
     226 |                 page_ext = lookup_page_ext(page + i);
         |                            ^~~~~~~~~~~~~~~
   mm/page_owner.c:226:26: warning: assignment to 'struct page_ext *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     226 |                 page_ext = lookup_page_ext(page + i);
         |                          ^
   cc1: some warnings being treated as errors


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
