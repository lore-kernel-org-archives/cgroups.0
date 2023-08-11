From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: cgroup: =?utf-8?Q?Remo?=
 =?utf-8?B?dmUgdW5uZWNlc3Nhcnkg4oCYMOKAmQ==?= values from ret
Date: Fri, 11 Aug 2023 21:17:55 +0800
Message-ID: <202308112134.cHq2KhFM-lkp@intel.com>
References: <20230813014734.2916-1-kunyu@nfschina.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691759925; x=1723295925;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=LZExdhkOrTYKPjUezsTjpMDrT0pVuYd3aBLIrKl/gtg=;
  b=XWxaR1Nl5ZoMrhAmCanUMkycMZS9xRKpbMrtk2YWkWj7jMwqdhkUj2Vx
   VQ2u+5VuDbrFfboRN61IwB6P7OUPwkwBYn3TembxeKgSbWbQpHFY6t+5k
   w9RbhbzeoyWnAM+C9pZKBNfGGNYJHZopLrEF+GD6RgvpBu4al1WvG/wdu
   NMJhqrW0QcqAOlpFm1KvRNo2uFVhGnY4U7KaLuHtbhED8hJe9TkBPm9Dk
   f9zDkuhKZS4MuVZrC0SE6k+anu9smLbIg8Hat4mtK557jY2D3CXaSdFmH
   GOAH9ZLOJ1tFVyiVRYOHw2n1+dy70g9Z4igz/4mKm7G1obQXnruag58jk
   Q==;
Content-Disposition: inline
In-Reply-To: <20230813014734.2916-1-kunyu-5L972MDCkn1Wk0Htik3J/w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Li kunyu <kunyu-5L972MDCkn1Wk0Htik3J/w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: oe-kbuild-all-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li kunyu <kunyu-5L972MDCkn1Wk0Htik3J/w@public.gmane.org>

Hi Li,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v6.5-rc5]
[also build test WARNING on linus/master next-20230809]
[cannot apply to tj-cgroup/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Li-kunyu/cgroup-cgroup-Remove-unnecessary-0-values-from-ret/20230811-171814
base:   v6.5-rc5
patch link:    https://lore.kernel.org/r/20230813014734.2916-1-kunyu%40nfschina.com
patch subject: [PATCH] cgroup: cgroup: Remove unnecessary ‘0’ values from ret
config: nios2-randconfig-r031-20230811 (https://download.01.org/0day-ci/archive/20230811/202308112134.cHq2KhFM-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: nios2-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230811/202308112134.cHq2KhFM-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308112134.cHq2KhFM-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

All warnings (new ones prefixed by >>):

   kernel/cgroup/cgroup.c: In function 'delegate_show':
>> kernel/cgroup/cgroup.c:7000:15: warning: 'ret' is used uninitialized [-Wuninitialized]
    7000 |         ret = show_delegatable_files(cgroup_base_files, buf + ret,
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    7001 |                                      PAGE_SIZE - ret, NULL);
         |                                      ~~~~~~~~~~~~~~~~~~~~~~
   kernel/cgroup/cgroup.c:6998:17: note: 'ret' was declared here
    6998 |         ssize_t ret;
         |                 ^~~


vim +/ret +7000 kernel/cgroup/cgroup.c

01ee6cfb1483fe Roman Gushchin 2017-11-06  6992  
01ee6cfb1483fe Roman Gushchin 2017-11-06  6993  static ssize_t delegate_show(struct kobject *kobj, struct kobj_attribute *attr,
01ee6cfb1483fe Roman Gushchin 2017-11-06  6994  			      char *buf)
01ee6cfb1483fe Roman Gushchin 2017-11-06  6995  {
01ee6cfb1483fe Roman Gushchin 2017-11-06  6996  	struct cgroup_subsys *ss;
01ee6cfb1483fe Roman Gushchin 2017-11-06  6997  	int ssid;
3d7f13682faf54 Li kunyu       2023-08-13  6998  	ssize_t ret;
01ee6cfb1483fe Roman Gushchin 2017-11-06  6999  
8a693f7766f9e2 Tejun Heo      2022-09-06 @7000  	ret = show_delegatable_files(cgroup_base_files, buf + ret,
8a693f7766f9e2 Tejun Heo      2022-09-06  7001  				     PAGE_SIZE - ret, NULL);
8a693f7766f9e2 Tejun Heo      2022-09-06  7002  	if (cgroup_psi_enabled())
8a693f7766f9e2 Tejun Heo      2022-09-06  7003  		ret += show_delegatable_files(cgroup_psi_files, buf + ret,
8a693f7766f9e2 Tejun Heo      2022-09-06  7004  					      PAGE_SIZE - ret, NULL);
01ee6cfb1483fe Roman Gushchin 2017-11-06  7005  
01ee6cfb1483fe Roman Gushchin 2017-11-06  7006  	for_each_subsys(ss, ssid)
01ee6cfb1483fe Roman Gushchin 2017-11-06  7007  		ret += show_delegatable_files(ss->dfl_cftypes, buf + ret,
01ee6cfb1483fe Roman Gushchin 2017-11-06  7008  					      PAGE_SIZE - ret,
01ee6cfb1483fe Roman Gushchin 2017-11-06  7009  					      cgroup_subsys_name[ssid]);
01ee6cfb1483fe Roman Gushchin 2017-11-06  7010  
01ee6cfb1483fe Roman Gushchin 2017-11-06  7011  	return ret;
01ee6cfb1483fe Roman Gushchin 2017-11-06  7012  }
01ee6cfb1483fe Roman Gushchin 2017-11-06  7013  static struct kobj_attribute cgroup_delegate_attr = __ATTR_RO(delegate);
01ee6cfb1483fe Roman Gushchin 2017-11-06  7014  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
