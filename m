From: kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 2/2] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Thu, 2 Jun 2022 14:32:57 +0800
Message-ID: <202206021418.wpJNbe3g-lkp@intel.com>
References: <20220601211824.89626-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654151597; x=1685687597;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bfI6YfacDQFmkZ6odkoNNWz0vnBz6nu6DVsXX5PqRSE=;
  b=UTYKXKFmHTNPwVjoX6Nxzc8d1VWqUFPG2ZGdqAOqtEKZ7w8nL7LfeDJI
   oMbVkHCgOXTdLRwmmkfU6QS0HTnGMSOo+ZmV8NT3DpPYdwdDJ8y7d1x0X
   PQCoVyT9v6FrNeay1mFh/AzwJGu/QZFQNrSTF7vqHRCVAv4ucHRk6/IFm
   tU9ZuBCAzKFsXDtfvMwD2Ot6YHjRsUQ09JZsO8yNlWUPNkYbmYKtFrYfW
   3OIQXAgVG5dxcq3gbDpVp9qBkx7Ws0q1BovJvrY7B7wNV9aeehgkP13lr
   WJCtYJPW7YJOihMJUIEvsEC+QxkTteon9F716tTtGr9dCAyTNMu/5MMdy
   w==;
Content-Disposition: inline
In-Reply-To: <20220601211824.89626-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: llvm@lists.linux.dev, kbuild-all@lists.01.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Waiman Long <longman@redhat.com>

Hi Waiman,

I love your patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master next-20220601]
[cannot apply to v5.18]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Waiman-Long/blk-cgroup-Optimize-blkcg_rstat_flush/20220602-052441
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: x86_64-randconfig-a012 (https://download.01.org/0day-ci/archive/20220602/202206021418.wpJNbe3g-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c825abd6b0198fb088d9752f556a70705bc99dfd)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/3f979cef411e5d5512b725753034b02f3b7baf44
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Waiman-Long/blk-cgroup-Optimize-blkcg_rstat_flush/20220602-052441
        git checkout 3f979cef411e5d5512b725753034b02f3b7baf44
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> block/blk-cgroup.c:1255:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (!blkcg->lhead)
               ^~~~~~~~~~~~~
   block/blk-cgroup.c:1306:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   block/blk-cgroup.c:1255:2: note: remove the 'if' if its condition is always false
           if (!blkcg->lhead)
           ^~~~~~~~~~~~~~~~~~
   block/blk-cgroup.c:1239:33: note: initialize the variable 'ret' to silence this warning
           struct cgroup_subsys_state *ret;
                                          ^
                                           = NULL
   1 warning generated.


vim +1255 block/blk-cgroup.c

  1234	
  1235	static struct cgroup_subsys_state *
  1236	blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
  1237	{
  1238		struct blkcg *blkcg;
  1239		struct cgroup_subsys_state *ret;
  1240		int i;
  1241	
  1242		mutex_lock(&blkcg_pol_mutex);
  1243	
  1244		if (!parent_css) {
  1245			blkcg = &blkcg_root;
  1246		} else {
  1247			blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
  1248			if (!blkcg) {
  1249				ret = ERR_PTR(-ENOMEM);
  1250				goto unlock;
  1251			}
  1252		}
  1253	
  1254		blkcg->lhead = alloc_percpu_gfp(struct llist_head, GFP_KERNEL);
> 1255		if (!blkcg->lhead)
  1256			goto free_blkcg;
  1257		init_blkcg_llists(blkcg);
  1258	
  1259		for (i = 0; i < BLKCG_MAX_POLS ; i++) {
  1260			struct blkcg_policy *pol = blkcg_policy[i];
  1261			struct blkcg_policy_data *cpd;
  1262	
  1263			/*
  1264			 * If the policy hasn't been attached yet, wait for it
  1265			 * to be attached before doing anything else. Otherwise,
  1266			 * check if the policy requires any specific per-cgroup
  1267			 * data: if it does, allocate and initialize it.
  1268			 */
  1269			if (!pol || !pol->cpd_alloc_fn)
  1270				continue;
  1271	
  1272			cpd = pol->cpd_alloc_fn(GFP_KERNEL);
  1273			if (!cpd) {
  1274				ret = ERR_PTR(-ENOMEM);
  1275				goto free_pd_blkcg;
  1276			}
  1277			blkcg->cpd[i] = cpd;
  1278			cpd->blkcg = blkcg;
  1279			cpd->plid = i;
  1280			if (pol->cpd_init_fn)
  1281				pol->cpd_init_fn(cpd);
  1282		}
  1283	
  1284		spin_lock_init(&blkcg->lock);
  1285		refcount_set(&blkcg->online_pin, 1);
  1286		INIT_RADIX_TREE(&blkcg->blkg_tree, GFP_NOWAIT | __GFP_NOWARN);
  1287		INIT_HLIST_HEAD(&blkcg->blkg_list);
  1288	#ifdef CONFIG_CGROUP_WRITEBACK
  1289		INIT_LIST_HEAD(&blkcg->cgwb_list);
  1290	#endif
  1291		list_add_tail(&blkcg->all_blkcgs_node, &all_blkcgs);
  1292	
  1293		mutex_unlock(&blkcg_pol_mutex);
  1294		return &blkcg->css;
  1295	
  1296	free_pd_blkcg:
  1297		for (i--; i >= 0; i--)
  1298			if (blkcg->cpd[i])
  1299				blkcg_policy[i]->cpd_free_fn(blkcg->cpd[i]);
  1300		free_percpu(blkcg->lhead);
  1301	free_blkcg:
  1302		if (blkcg != &blkcg_root)
  1303			kfree(blkcg);
  1304	unlock:
  1305		mutex_unlock(&blkcg_pol_mutex);
  1306		return ret;
  1307	}
  1308	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
