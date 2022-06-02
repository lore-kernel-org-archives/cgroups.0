From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/2] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Thu, 2 Jun 2022 09:52:55 +0800
Message-ID: <202206020948.yBhTYYDS-lkp@intel.com>
References: <20220601165324.60892-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654134815; x=1685670815;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1IXtlOaSA6Lu6LSh/sdcVQX9N0TOTnw/7092N1Jsl5w=;
  b=TTPGjlPwYmglc/HPqBf9VLuxiYqirQVNZQ4ijqUKvN47ni5YkCuWllcC
   anty21jwipDrQZmM8l7ysFBVb8XzuCZt0RiR3tcVYr/vZiTDO5cOMfv9+
   pSUVxPDkShqxLRfMKu+Elv9Ibuh+wgxbF3m6RzVLLsQv0WxuJzncVHaFz
   M2mPL2XP3muez1087FtlKHJQ4mZzDkqBOAdNASnyNJKXB2IxhKsEfAg5Z
   pFdSfcODha/4Z060P7XFP3hWOlmYMuH8WPqot8S3MHJhUCr5hbxplBLYB
   SdVKdDu0/2rEW0mM4V94JnPpoN5dKhNmi65yW18K8K6QAih3l3DI2GjcV
   g==;
Content-Disposition: inline
In-Reply-To: <20220601165324.60892-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: llvm-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi Waiman,

I love your patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master next-20220601]
[cannot apply to v5.18]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Waiman-Long/blk-cgroup-Correctly-free-percpu-iostat_cpu-in-blkg-on-error-exit/20220602-005557
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220602/202206020948.yBhTYYDS-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c825abd6b0198fb088d9752f556a70705bc99dfd)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/7f5ef1493e681454e71c11b2547638b94665a78f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Waiman-Long/blk-cgroup-Correctly-free-percpu-iostat_cpu-in-blkg-on-error-exit/20220602-005557
        git checkout 7f5ef1493e681454e71c11b2547638b94665a78f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All warnings (new ones prefixed by >>):

>> block/blk-cgroup.c:1239:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (!blkcg->lhead)
               ^~~~~~~~~~~~~
   block/blk-cgroup.c:1290:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   block/blk-cgroup.c:1239:2: note: remove the 'if' if its condition is always false
           if (!blkcg->lhead)
           ^~~~~~~~~~~~~~~~~~
   block/blk-cgroup.c:1223:33: note: initialize the variable 'ret' to silence this warning
           struct cgroup_subsys_state *ret;
                                          ^
                                           = NULL
   1 warning generated.


vim +1239 block/blk-cgroup.c

  1218	
  1219	static struct cgroup_subsys_state *
  1220	blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
  1221	{
  1222		struct blkcg *blkcg;
  1223		struct cgroup_subsys_state *ret;
  1224		int i;
  1225	
  1226		mutex_lock(&blkcg_pol_mutex);
  1227	
  1228		if (!parent_css) {
  1229			blkcg = &blkcg_root;
  1230		} else {
  1231			blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
  1232			if (!blkcg) {
  1233				ret = ERR_PTR(-ENOMEM);
  1234				goto unlock;
  1235			}
  1236		}
  1237	
  1238		blkcg->lhead = alloc_percpu_gfp(struct llist_head, GFP_KERNEL);
> 1239		if (!blkcg->lhead)
  1240			goto free_blkcg;
  1241		init_blkcg_llists(blkcg);
  1242	
  1243		for (i = 0; i < BLKCG_MAX_POLS ; i++) {
  1244			struct blkcg_policy *pol = blkcg_policy[i];
  1245			struct blkcg_policy_data *cpd;
  1246	
  1247			/*
  1248			 * If the policy hasn't been attached yet, wait for it
  1249			 * to be attached before doing anything else. Otherwise,
  1250			 * check if the policy requires any specific per-cgroup
  1251			 * data: if it does, allocate and initialize it.
  1252			 */
  1253			if (!pol || !pol->cpd_alloc_fn)
  1254				continue;
  1255	
  1256			cpd = pol->cpd_alloc_fn(GFP_KERNEL);
  1257			if (!cpd) {
  1258				ret = ERR_PTR(-ENOMEM);
  1259				goto free_pd_blkcg;
  1260			}
  1261			blkcg->cpd[i] = cpd;
  1262			cpd->blkcg = blkcg;
  1263			cpd->plid = i;
  1264			if (pol->cpd_init_fn)
  1265				pol->cpd_init_fn(cpd);
  1266		}
  1267	
  1268		spin_lock_init(&blkcg->lock);
  1269		refcount_set(&blkcg->online_pin, 1);
  1270		INIT_RADIX_TREE(&blkcg->blkg_tree, GFP_NOWAIT | __GFP_NOWARN);
  1271		INIT_HLIST_HEAD(&blkcg->blkg_list);
  1272	#ifdef CONFIG_CGROUP_WRITEBACK
  1273		INIT_LIST_HEAD(&blkcg->cgwb_list);
  1274	#endif
  1275		list_add_tail(&blkcg->all_blkcgs_node, &all_blkcgs);
  1276	
  1277		mutex_unlock(&blkcg_pol_mutex);
  1278		return &blkcg->css;
  1279	
  1280	free_pd_blkcg:
  1281		for (i--; i >= 0; i--)
  1282			if (blkcg->cpd[i])
  1283				blkcg_policy[i]->cpd_free_fn(blkcg->cpd[i]);
  1284		free_percpu(blkcg->lhead);
  1285	free_blkcg:
  1286		if (blkcg != &blkcg_root)
  1287			kfree(blkcg);
  1288	unlock:
  1289		mutex_unlock(&blkcg_pol_mutex);
  1290		return ret;
  1291	}
  1292	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
