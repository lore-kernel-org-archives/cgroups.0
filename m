From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 1/5] cgroup: bpf: add a hook for bpf progs to
 attach to rstat flushing
Date: Sat, 21 May 2022 19:26:24 +0800
Message-ID: <202205211932.e4nkPC3e-lkp@intel.com>
References: <20220520012133.1217211-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653132423; x=1684668423;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FMPnoL06zNFDkI/2hBPZGwhNOH5Z9rbc5IUvZk5e1UU=;
  b=Q7CV8kLg0eNks8mie0MSO26vIO8mCNw5FSjtfpDTskC1AiEfYg1GoNnn
   x2WSvZLA9Eqzv7Edht5rh0ICFOjSN/9BFHvrTVGa3rOHKlwEf2XUpYz9/
   miRbgzvPommhVGTsYq5NOs+AUhbMa1y1r/PaSJkK066HVWtm/mk8eIL/8
   afWpRLi9Ggt5OP0HU3yDv4QtztiXm9WRHpelXoHrKcSmwHBSpC8sRZoNq
   qZxfv6DvGiUnDTQynepxjnCYo0xXHFcN3OqwJRJmMmvK9He7eCmM87uJ8
   2dmz9v+pwYDax4eI2CpYEKnT/yNQf3L9z4Ifm2a/htTjvCcgfNp/WqgVS
   g==;
Content-Disposition: inline
In-Reply-To: <20220520012133.1217211-2-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Yosry,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220520-093041
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220521/202205211932.e4nkPC3e-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/23c4c48fb35b084dc1173c7b9d23d4e6e1a084a3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220520-093041
        git checkout 23c4c48fb35b084dc1173c7b9d23d4e6e1a084a3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash kernel/cgroup/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All warnings (new ones prefixed by >>):

>> kernel/cgroup/rstat.c:145:22: warning: no previous prototype for 'bpf_rstat_flush' [-Wmissing-prototypes]
     145 | __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
         |                      ^~~~~~~~~~~~~~~


vim +/bpf_rstat_flush +145 kernel/cgroup/rstat.c

   143	
   144	/* A hook for bpf stat collectors to attach to and flush their stats */
 > 145	__weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
   146					     struct cgroup *parent, int cpu)
   147	{
   148	}
   149	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
