From: kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v4 09/11] mm: memcontrol: use obj_cgroup APIs to charge
 the LRU pages
Date: Tue, 24 May 2022 20:29:49 +0800
Message-ID: <202205242030.FAaW4e04-lkp@intel.com>
References: <20220524060551.80037-10-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653395435; x=1684931435;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QesgYJtIYpO+DLyYwVVFn+Dd5yDLs1Cg8cnWq0AHJy4=;
  b=kl5jbeps4TByGf8RdP2CJ+dJ/DRSjyJxwo/WnD0oUMhD06Tz7kYk6rH7
   utcIX7hL2IzzZJnIjicpIsf9LMmQ/XtCX0b5Z4vI9cupi1XYVCURK1oVX
   RszUpatFvTyvakpFwxxTYIrj8XvjPdzw3EMWHwN5HG7sR7Uha12V6Ia9N
   LAfZ6APXv5ofNPWk//xYzrcT0xh2/D0WZaL2XuilTiHtJj4NVKMbMoWvd
   /rMQHHBk2qrQQB7HK7HbN/foznqQX35dXAS/iJYdGXgw5tNbzOtoD7jJh
   0STGK8WpNO1b4hFj2L5ACAMgTbfHYevOWz3e/qf4aBDTp1XZLkymIZKTV
   A==;
Content-Disposition: inline
In-Reply-To: <20220524060551.80037-10-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com
Cc: kbuild-all@lists.01.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com, longman@redhat.com, Muchun Song <songmuchun@bytedance.com>

Hi Muchun,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 4b0986a3613c92f4ec1bdc7f60ec66fea135991f]

url:    https://github.com/intel-lab-lkp/linux/commits/Muchun-Song/Use-obj_cgroup-APIs-to-charge-the-LRU-pages/20220524-143056
base:   4b0986a3613c92f4ec1bdc7f60ec66fea135991f
config: x86_64-randconfig-m001 (https://download.01.org/0day-ci/archive/20220524/202205242030.FAaW4e04-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/bec0ae12106e0cf12dd4e0e21eb0754b99be0ba2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Muchun-Song/Use-obj_cgroup-APIs-to-charge-the-LRU-pages/20220524-143056
        git checkout bec0ae12106e0cf12dd4e0e21eb0754b99be0ba2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   mm/memcontrol.c: In function 'charge_memcg':
>> mm/memcontrol.c:6826:17: error: implicit declaration of function '__get_obj_cgroup_from_memcg'; did you mean 'get_mem_cgroup_from_mm'? [-Werror=implicit-function-declaration]
    6826 |         objcg = __get_obj_cgroup_from_memcg(memcg);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                 get_mem_cgroup_from_mm
   mm/memcontrol.c:6826:15: warning: assignment to 'struct obj_cgroup *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    6826 |         objcg = __get_obj_cgroup_from_memcg(memcg);
         |               ^
   cc1: some warnings being treated as errors


vim +6826 mm/memcontrol.c

  6818	
  6819	static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
  6820				gfp_t gfp)
  6821	{
  6822		struct obj_cgroup *objcg;
  6823		long nr_pages = folio_nr_pages(folio);
  6824		int ret = 0;
  6825	
> 6826		objcg = __get_obj_cgroup_from_memcg(memcg);
  6827		/* Do not account at the root objcg level. */
  6828		if (!obj_cgroup_is_root(objcg))
  6829			ret = try_charge(memcg, gfp, nr_pages);
  6830		if (ret)
  6831			goto out;
  6832	
  6833		obj_cgroup_get(objcg);
  6834		commit_charge(folio, objcg);
  6835	
  6836		local_irq_disable();
  6837		mem_cgroup_charge_statistics(memcg, nr_pages);
  6838		memcg_check_events(memcg, folio_nid(folio));
  6839		local_irq_enable();
  6840	out:
  6841		obj_cgroup_put(objcg);
  6842		return ret;
  6843	}
  6844	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
