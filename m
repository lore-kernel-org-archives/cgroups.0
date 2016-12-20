From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:review-cgroup-reorg 8/13] kernel/cgroup/cgroup-v1.c:695:16:
 sparse: incompatible types in comparison expression (different address
 spaces)
Date: Wed, 21 Dec 2016 06:49:39 +0800
Message-ID: <201612210629.LUq2MQnk%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-reorg
head:   8a6dc1a57dc250394be839aeb7741dc351e84da7
commit: 183e7e19c8e2dec9a4f64a3b40fe1c01e7c47f50 [8/13] cgroup: move cgroup v1 specific code to kernel/cgroup/cgroup-v1.c
reproduce:
        # apt-get install sparse
        git checkout 183e7e19c8e2dec9a4f64a3b40fe1c01e7c47f50
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> kernel/cgroup/cgroup-v1.c:695:16: sparse: incompatible types in comparison expression (different address spaces)

vim +695 kernel/cgroup/cgroup-v1.c

   679		struct css_task_iter it;
   680		struct task_struct *tsk;
   681	
   682		/* it should be kernfs_node belonging to cgroupfs and is a directory */
   683		if (dentry->d_sb->s_type != &cgroup_fs_type || !kn ||
   684		    kernfs_type(kn) != KERNFS_DIR)
   685			return -EINVAL;
   686	
   687		mutex_lock(&cgroup_mutex);
   688	
   689		/*
   690		 * We aren't being called from kernfs and there's no guarantee on
   691		 * @kn->priv's validity.  For this and css_tryget_online_from_dir(),
   692		 * @kn->priv is RCU safe.  Let's do the RCU dancing.
   693		 */
   694		rcu_read_lock();
 > 695		cgrp = rcu_dereference(kn->priv);
   696		if (!cgrp || cgroup_is_dead(cgrp)) {
   697			rcu_read_unlock();
   698			mutex_unlock(&cgroup_mutex);
   699			return -ENOENT;
   700		}
   701		rcu_read_unlock();
   702	
   703		css_task_iter_start(&cgrp->self, &it);

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
