From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 09/11] mm: memcontrol: use obj_cgroup APIs to charge
 the LRU pages
Date: Wed, 25 May 2022 02:16:47 +0800
Message-ID: <202205250202.1JanYiVZ-lkp@intel.com>
References: <20220524060551.80037-10-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653416229; x=1684952229;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EBnyAxgG8VMP5VnxxAr+i+RhOOaMEQkB+M7uuFYWkuc=;
  b=bI/9uEXkSQB7nCmz0HB7w68HgI0v5c8Uw4yDv5r+u40H9Dkn/cbbjYBW
   PkUboddFrO5oRJZ0GQNCE9G6l64gPQYHCEturdBtI2fM7km57LmskExVf
   W3IhrAAgw6Wchslegj5KqeiRL3FauVEpdQ/wPvv/tNuxB/vNDpqAYMyGB
   Og3wyLNSztW5qvRNXt0CqIkDWi6nUppW1OAlhR+FZ9PcEwDBM2mrweO21
   U19BlAc7DTjgJsB9VQwkytm8Gg9/83J74DQ+l9t4CHBbBilB4c1PcGR+e
   fper/iAKB53C9FWCU/xKA25cksBfeZItW5STEe/VX9aMZdhkuL2SLAppa
   g==;
Content-Disposition: inline
In-Reply-To: <20220524060551.80037-10-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: llvm-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Hi Muchun,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 4b0986a3613c92f4ec1bdc7f60ec66fea135991f]

url:    https://github.com/intel-lab-lkp/linux/commits/Muchun-Song/Use-obj_cgroup-APIs-to-charge-the-LRU-pages/20220524-143056
base:   4b0986a3613c92f4ec1bdc7f60ec66fea135991f
config: arm64-buildonly-randconfig-r005-20220524 (https://download.01.org/0day-ci/archive/20220525/202205250202.1JanYiVZ-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 10c9ecce9f6096e18222a331c5e7d085bd813f75)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/bec0ae12106e0cf12dd4e0e21eb0754b99be0ba2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Muchun-Song/Use-obj_cgroup-APIs-to-charge-the-LRU-pages/20220524-143056
        git checkout bec0ae12106e0cf12dd4e0e21eb0754b99be0ba2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All error/warnings (new ones prefixed by >>):

>> mm/memcontrol.c:6826:10: error: call to undeclared function '__get_obj_cgroup_from_memcg'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           objcg = __get_obj_cgroup_from_memcg(memcg);
                   ^
>> mm/memcontrol.c:6826:8: warning: incompatible integer to pointer conversion assigning to 'struct obj_cgroup *' from 'int' [-Wint-conversion]
           objcg = __get_obj_cgroup_from_memcg(memcg);
                 ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning and 1 error generated.


vim +/__get_obj_cgroup_from_memcg +6826 mm/memcontrol.c

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
