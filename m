From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:review-cgroup2-rgroup 55/58] include/linux/cgroup.h:552:1:
 warning: no return statement in function returning non-void
Date: Fri, 11 Mar 2016 06:53:39 +0800
Message-ID: <201603110638.FXFONnR1%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-rgroup
head:   b8a6f70a51d537bf2a1fd47b90a29af6807ad978
commit: 1e9fdf21c0176c14ca30b3c5c4ed0bf57581eb69 [55/58] cgroup: introduce resource group
config: i386-tinyconfig (attached as .config)
reproduce:
        git checkout 1e9fdf21c0176c14ca30b3c5c4ed0bf57581eb69
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   In file included from include/linux/memcontrol.h:22:0,
                    from include/linux/swap.h:8,
                    from include/linux/suspend.h:4,
                    from arch/x86/kernel/asm-offsets.c:12:
   include/linux/cgroup.h: In function 'cgroup_exec':
>> include/linux/cgroup.h:552:1: warning: no return statement in function returning non-void [-Wreturn-type]
    static inline int cgroup_exec(void) {}
    ^

vim +552 include/linux/cgroup.h

   536	
   537	static inline void css_put(struct cgroup_subsys_state *css) {}
   538	static inline int cgroup_attach_task_all(struct task_struct *from,
   539						 struct task_struct *t) { return 0; }
   540	static inline int cgroupstats_build(struct cgroupstats *stats,
   541					    struct dentry *dentry) { return -EINVAL; }
   542	
   543	static inline int cgroup_can_fork(struct task_struct *p,
   544					  unsigned long clone_flags,
   545					  struct css_set **new_rgrp_csetp) { return 0; }
   546	static inline void cgroup_cancel_fork(struct task_struct *p,
   547					      unsigned long clone_flags,
   548					      struct css_set *new_rgrp_cset) {}
   549	static inline void cgroup_post_fork(struct task_struct *p,
   550					    unsigned long clone_flags,
   551					    struct css_set *new_rgrp_cset) {}
 > 552	static inline int cgroup_exec(void) {}
   553	static inline void cgroup_exit(struct task_struct *p) {}
   554	static inline void cgroup_free(struct task_struct *p) {}
   555	
   556	static inline int cgroup_init_early(void) { return 0; }
   557	static inline int cgroup_init(void) { return 0; }
   558	
   559	#endif /* !CONFIG_CGROUPS */
   560	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--pWyiEgJYm5f9v55/
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--pWyiEgJYm5f9v55/--
