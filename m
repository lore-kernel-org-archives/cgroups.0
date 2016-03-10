From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:review-cgroup2-rgroup 54/58] DockBook:
 include/linux/sched.h:2813: warning: No description found for parameter
 'child'
Date: Fri, 11 Mar 2016 07:37:35 +0800
Message-ID: <201603110727.cJyWi9wO%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-rgroup
head:   b8a6f70a51d537bf2a1fd47b90a29af6807ad978
commit: 4f219e29ed6614341d3691a4cf53346206787ceb [54/58] cgroup, fork: add @child and @clone_flags to threadgroup_change_begin/end()
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/linux/init.h:1: warning: no structured comments found
>> include/linux/sched.h:2813: warning: No description found for parameter 'child'
>> include/linux/sched.h:2813: warning: No description found for parameter 'clone_flags'
   kernel/sys.c:1: warning: no structured comments found
   drivers/dma-buf/seqno-fence.c:1: warning: no structured comments found
   drivers/dma-buf/reservation.c:1: warning: no structured comments found
   include/linux/reservation.h:1: warning: no structured comments found
   include/linux/spi/spi.h:540: warning: No description found for parameter 'max_transfer_size'

vim +/child +2813 include/linux/sched.h

4f219e29 Tejun Heo    2016-03-10  2797  					    struct task_struct *child,
4f219e29 Tejun Heo    2016-03-10  2798  					    unsigned long clone_flags)
4714d1d3 Ben Blum     2011-05-26  2799  {
7d7efec3 Tejun Heo    2015-05-13  2800  	might_sleep();
4f219e29 Tejun Heo    2016-03-10  2801  	cgroup_threadgroup_change_begin(tsk, child, clone_flags);
4714d1d3 Ben Blum     2011-05-26  2802  }
77e4ef99 Tejun Heo    2011-12-12  2803  
77e4ef99 Tejun Heo    2011-12-12  2804  /**
7d7efec3 Tejun Heo    2015-05-13  2805   * threadgroup_change_end - mark the end of changes to a threadgroup
7d7efec3 Tejun Heo    2015-05-13  2806   * @tsk: task causing the changes
77e4ef99 Tejun Heo    2011-12-12  2807   *
7d7efec3 Tejun Heo    2015-05-13  2808   * See threadgroup_change_begin().
77e4ef99 Tejun Heo    2011-12-12  2809   */
4f219e29 Tejun Heo    2016-03-10  2810  static inline void threadgroup_change_end(struct task_struct *tsk,
4f219e29 Tejun Heo    2016-03-10  2811  					  struct task_struct *child,
4f219e29 Tejun Heo    2016-03-10  2812  					  unsigned long clone_flags)
4714d1d3 Ben Blum     2011-05-26 @2813  {
4f219e29 Tejun Heo    2016-03-10  2814  	cgroup_threadgroup_change_end(tsk, child, clone_flags);
4714d1d3 Ben Blum     2011-05-26  2815  }
4714d1d3 Ben Blum     2011-05-26  2816  
f037360f Al Viro      2005-11-13  2817  #ifndef __HAVE_THREAD_FUNCTIONS
f037360f Al Viro      2005-11-13  2818  
f7e4217b Roman Zippel 2007-05-09  2819  #define task_thread_info(task)	((struct thread_info *)(task)->stack)
f7e4217b Roman Zippel 2007-05-09  2820  #define task_stack_page(task)	((task)->stack)
a1261f54 Al Viro      2005-11-13  2821  

:::::: The code at line 2813 was first introduced by commit
:::::: 4714d1d32d97239fb5ae3e10521d3f133a899b66 cgroups: read-write lock CLONE_THREAD forking per threadgroup

:::::: TO: Ben Blum <bblum-OM76b2Iv3yLQjUSlxSEPGw@public.gmane.org>
:::::: CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--XsQoSWH+UP9D9v3l
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
qITgPyk0sQ4pWAAA

--XsQoSWH+UP9D9v3l--
