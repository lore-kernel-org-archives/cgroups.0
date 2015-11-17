From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:review-xt_cgroup2 4/5] include/linux/cgroup.h:584:43:
 warning: 'struct sock' declared inside parameter list
Date: Wed, 18 Nov 2015 01:30:18 +0800
Message-ID: <201511180116.8bthupI3%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-xt_cgroup2
head:   a2ea5b8e460c458101f96739c6a579b4d8ec325a
commit: a139ca59402a4a18bf85ffb975f1c26943bf5b00 [4/5] sock, cgroup: add sock->sk_cgroup
config: i386-tinyconfig (attached as .config)
reproduce:
        git checkout a139ca59402a4a18bf85ffb975f1c26943bf5b00
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   In file included from include/linux/memcontrol.h:22:0,
                    from include/linux/swap.h:8,
                    from include/linux/suspend.h:4,
                    from arch/x86/kernel/asm-offsets.c:12:
>> include/linux/cgroup.h:584:43: warning: 'struct sock' declared inside parameter list
    static inline void cgroup_sk_alloc(struct sock *sk) {}
                                              ^
   include/linux/cgroup.h:584:43: warning: its scope is only this definition or declaration, which is probably not what you want
   include/linux/cgroup.h:585:42: warning: 'struct sock' declared inside parameter list
    static inline void cgroup_sk_free(struct sock *sk) {}
                                             ^

vim +584 include/linux/cgroup.h

   568					    struct dentry *dentry) { return -EINVAL; }
   569	
   570	static inline void cgroup_fork(struct task_struct *p) {}
   571	static inline int cgroup_can_fork(struct task_struct *p,
   572					  void *ss_priv[CGROUP_CANFORK_COUNT])
   573	{ return 0; }
   574	static inline void cgroup_cancel_fork(struct task_struct *p,
   575					      void *ss_priv[CGROUP_CANFORK_COUNT]) {}
   576	static inline void cgroup_post_fork(struct task_struct *p,
   577					    void *ss_priv[CGROUP_CANFORK_COUNT]) {}
   578	static inline void cgroup_exit(struct task_struct *p) {}
   579	static inline void cgroup_free(struct task_struct *p) {}
   580	
   581	static inline int cgroup_init_early(void) { return 0; }
   582	static inline int cgroup_init(void) { return 0; }
   583	
 > 584	static inline void cgroup_sk_alloc(struct sock *sk) {}
   585	static inline void cgroup_sk_free(struct sock *sk) {}
   586	
   587	#endif /* !CONFIG_CGROUPS */
   588	
   589	#endif /* _LINUX_CGROUP_H */

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--fdj2RfSjLxBAspz7
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--fdj2RfSjLxBAspz7--
