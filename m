From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:review-cgroup-reorg 7/13] kernel/cgroup/cgroup.c:4764:16:
 sparse: incompatible types in comparison expression (different address
 spaces)
Date: Wed, 21 Dec 2016 06:19:38 +0800
Message-ID: <201612210610.PJMy3KLl%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-reorg
head:   3fd6a2eec6783bff033e553a3773c897a7f93109
commit: 71f76f958ba552114971653cdb56e5d8ce0b9988 [7/13] cgroup: move cgroup files under kernel/cgroup/
reproduce:
        # apt-get install sparse
        git checkout 71f76f958ba552114971653cdb56e5d8ce0b9988
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> kernel/cgroup/cgroup.c:4764:16: sparse: incompatible types in comparison expression (different address spaces)
   kernel/cgroup/cgroup.c:6248:16: sparse: incompatible types in comparison expression (different address spaces)

vim +4764 kernel/cgroup/cgroup.c

72ec70299 kernel/cgroup.c Tejun Heo    2013-08-08  4748  	struct css_task_iter it;
846c7bb05 kernel/cgroup.c Balbir Singh 2007-10-18  4749  	struct task_struct *tsk;
33d283bef kernel/cgroup.c Li Zefan     2008-11-19  4750  
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11  4751  	/* it should be kernfs_node belonging to cgroupfs and is a directory */
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11  4752  	if (dentry->d_sb->s_type != &cgroup_fs_type || !kn ||
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11  4753  	    kernfs_type(kn) != KERNFS_DIR)
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11  4754  		return -EINVAL;
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11  4755  
bad346603 kernel/cgroup.c Li Zefan     2014-02-14  4756  	mutex_lock(&cgroup_mutex);
bad346603 kernel/cgroup.c Li Zefan     2014-02-14  4757  
846c7bb05 kernel/cgroup.c Balbir Singh 2007-10-18  4758  	/*
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11  4759  	 * We aren't being called from kernfs and there's no guarantee on
ec903c0c8 kernel/cgroup.c Tejun Heo    2014-05-13  4760  	 * @kn->priv's validity.  For this and css_tryget_online_from_dir(),
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11  4761  	 * @kn->priv is RCU safe.  Let's do the RCU dancing.
846c7bb05 kernel/cgroup.c Balbir Singh 2007-10-18  4762  	 */
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11  4763  	rcu_read_lock();
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11 @4764  	cgrp = rcu_dereference(kn->priv);
bad346603 kernel/cgroup.c Li Zefan     2014-02-14  4765  	if (!cgrp || cgroup_is_dead(cgrp)) {
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11  4766  		rcu_read_unlock();
bad346603 kernel/cgroup.c Li Zefan     2014-02-14  4767  		mutex_unlock(&cgroup_mutex);
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11  4768  		return -ENOENT;
2bd59d48e kernel/cgroup.c Tejun Heo    2014-02-11  4769  	}
bad346603 kernel/cgroup.c Li Zefan     2014-02-14  4770  	rcu_read_unlock();
846c7bb05 kernel/cgroup.c Balbir Singh 2007-10-18  4771  
9d800df12 kernel/cgroup.c Tejun Heo    2014-05-14  4772  	css_task_iter_start(&cgrp->self, &it);

:::::: The code at line 4764 was first introduced by commit
:::::: 2bd59d48ebfb3df41ee56938946ca0dd30887312 cgroup: convert to kernfs

:::::: TO: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
:::::: CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
