From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: wait for css offline when rmdir
Date: Fri, 27 May 2022 16:46:01 +0800
Message-ID: <202205271657.MRX54zi5-lkp@intel.com>
References: <1653619158-27607-1-git-send-email-zhanghongchen@loongson.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653641184; x=1685177184;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YKsDt6Azr1nuJYOFtdAXGL2S2Sin9T2sVAVbgDSU0NU=;
  b=beP3AtmtB4KM6G0F/tZYeOujB4JSO2CwTjFG/ThpBlg+PGvg5EuBT+UB
   hWymzH6aLXOuILPwQURejQabiq8HZxWPpP87MtskaFJJdj9dKYggNodIi
   02WPksD25103WGrZdwjcxb1EzV+XJkxVmLBHLtOhO5tsDiktA+BELh0pr
   BCLdho5MBZxnyNi9VliDkCj9rJr97JSz0bURFovs2z8n0hGwT4UVScnyY
   XwCP8icRfvI9uEwbOHZ3BwlyT4OiZ1ZQyimhmTfCNieRd+QLn283LtXFE
   bzl32ySlHWuqkpi1IKnZqZX8BRhHMkwPA84Gpu0CLeP3WbZLGBIVyGQvr
   Q==;
Content-Disposition: inline
In-Reply-To: <1653619158-27607-1-git-send-email-zhanghongchen-cXZgJK919ebM1kAEIRd3EQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hongchen Zhang <zhanghongchen-cXZgJK919ebM1kAEIRd3EQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hongchen Zhang <zhanghongchen-cXZgJK919ebM1kAEIRd3EQ@public.gmane.org>

Hi Hongchen,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on tj-cgroup/for-next]
[also build test WARNING on v5.18 next-20220527]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Hongchen-Zhang/cgroup-wait-for-css-offline-when-rmdir/20220527-104105
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220527/202205271657.MRX54zi5-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/9cd51af8f62de826ed76ffb6a63dce3d14926a03
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hongchen-Zhang/cgroup-wait-for-css-offline-when-rmdir/20220527-104105
        git checkout 9cd51af8f62de826ed76ffb6a63dce3d14926a03
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash kernel/cgroup/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All warnings (new ones prefixed by >>):

>> kernel/cgroup/cgroup.c:3024:6: warning: no previous prototype for 'cgroup_wait_css_offline' [-Wmissing-prototypes]
    3024 | void cgroup_wait_css_offline(struct cgroup *cgrp)
         |      ^~~~~~~~~~~~~~~~~~~~~~~


vim +/cgroup_wait_css_offline +3024 kernel/cgroup/cgroup.c

  3022	
  3023	/* wait all cgrp's csses become offlined */
> 3024	void cgroup_wait_css_offline(struct cgroup *cgrp)
  3025	{
  3026		struct cgroup_subsys *ss;
  3027		int ssid;
  3028	
  3029		lockdep_assert_held(&cgroup_mutex);
  3030		for_each_subsys(ss, ssid) {
  3031			struct cgroup_subsys_state *css = cgroup_css(cgrp, ss);
  3032			DEFINE_WAIT(wait);
  3033	
  3034			if (!css || !percpu_ref_is_dying(&css->refcnt))
  3035				continue;
  3036	
  3037			prepare_to_wait(&cgrp->offline_waitq, &wait,
  3038					TASK_UNINTERRUPTIBLE);
  3039	
  3040			mutex_unlock(&cgroup_mutex);
  3041			schedule();
  3042			finish_wait(&cgrp->offline_waitq, &wait);
  3043	
  3044			mutex_lock(&cgroup_mutex);
  3045		}
  3046	}
  3047	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
