From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
Date: Sat, 11 Jun 2022 04:52:06 +0800
Message-ID: <202206110457.uD5lLvbh-lkp@intel.com>
References: <20220610194435.2268290-7-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654894381; x=1686430381;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IloPOG6rb4/h3WwQsyZ0qK0FPygA1mR4l8uI6GNZRZY=;
  b=P51CVVWh57qs6sBC+S2TyW3xqiK1o4y3zHDqtdbVktb8+si0OR1jpud8
   3yo7z5LG7EB3WVBuT7KBNfTxlo9ulrzSaN9IXelOeYGmv8wxqvTA/W0hw
   09+a/1vWHS5FxKXjUM3Q94Ea11VcZnNd1zOz9zEsFBM1trLi+WEAQw9FA
   QfW58oy1dQMp8pXrzpFpJ3cDEENxwggLYidndfwcsR2FOCPGUr0Ir5eP6
   ytUKBDyFDOXZk0DYU5m5zfWiJ2tUNd4q2v8En+B65mkb9ibaXPSaFwWzg
   +xvGafOzeqMS9UPtT8/7TtUnHJ0T9mGB73ybA/06R/ZVjhLX6cnlxEJ9x
   Q==;
Content-Disposition: inline
In-Reply-To: <20220610194435.2268290-7-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Yosry,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220611/202206110457.uD5lLvbh-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/83f297e2b47dc41b511f071b9eadf38339387b41
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
        git checkout 83f297e2b47dc41b511f071b9eadf38339387b41
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash kernel/cgroup/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All warnings (new ones prefixed by >>):

>> kernel/cgroup/rstat.c:161:22: warning: no previous prototype for 'bpf_rstat_flush' [-Wmissing-prototypes]
     161 | __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
         |                      ^~~~~~~~~~~~~~~
   kernel/cgroup/rstat.c:509:10: error: 'const struct btf_kfunc_id_set' has no member named 'sleepable_set'; did you mean 'release_set'?
     509 |         .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
         |          ^~~~~~~~~~~~~
         |          release_set
>> kernel/cgroup/rstat.c:509:27: warning: excess elements in struct initializer
     509 |         .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
         |                           ^
   kernel/cgroup/rstat.c:509:27: note: (near initialization for 'bpf_rstat_kfunc_set')


vim +/bpf_rstat_flush +161 kernel/cgroup/rstat.c

   148	
   149	/*
   150	 * A hook for bpf stat collectors to attach to and flush their stats.
   151	 * Together with providing bpf kfuncs for cgroup_rstat_updated() and
   152	 * cgroup_rstat_flush(), this enables a complete workflow where bpf progs that
   153	 * collect cgroup stats can integrate with rstat for efficient flushing.
   154	 *
   155	 * A static noinline declaration here could cause the compiler to optimize away
   156	 * the function. A global noinline declaration will keep the definition, but may
   157	 * optimize away the callsite. Therefore, __weak is needed to ensure that the
   158	 * call is still emitted, by telling the compiler that we don't know what the
   159	 * function might eventually be.
   160	 */
 > 161	__weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
   162					     struct cgroup *parent, int cpu)
   163	{
   164	}
   165	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
