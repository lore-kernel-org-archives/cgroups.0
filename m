From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
Date: Sat, 11 Jun 2022 20:55:37 +0800
Message-ID: <202206112000.LRgcxlpN-lkp@intel.com>
References: <20220610194435.2268290-5-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654952181; x=1686488181;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Gf95eJ/ArhVLLpZRM+17h14LteF1hhKgMQ48Z7Xbs3s=;
  b=VBhSgR561Z+psGHpylvY14JI5jb29D1a1SRq7grR7REYcmskztMSjFtN
   4MFWBaqAFSmUW/XeJIyjcv+dBdlfMyO26PoCnAr2+w1mJVK15HQIDfwn7
   mVDjxvRk1ShuWW04Cy6BFAI/u6tktk3GCNtKImP6KJ7TiHaN6fWBTWIKP
   NETxHE2EGBrPbn/J+1wfkB7WP6p7ppKBNhu727mRyHQsJHohaP3bjSS4S
   CloPXieT+s/lfekt6H460xcxFNUIC3RI4f8IRYzPWclpNU+8FcUCmz5yp
   NQ3DON4mQvp9jibJlubQL8TEUgv7M/6qSm/8hBFZKOMpU6ttejKgqo9xf
   A==;
Content-Disposition: inline
In-Reply-To: <20220610194435.2268290-5-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Yosry,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: m68k-randconfig-r004-20220611 (https://download.01.org/0day-ci/archive/20220611/202206112000.LRgcxlpN-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/619857fd1ec4f351376ffcaaec20acc9aae9486f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
        git checkout 619857fd1ec4f351376ffcaaec20acc9aae9486f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash kernel/bpf/ kernel/cgroup/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All error/warnings (new ones prefixed by >>):

   In file included from kernel/bpf/cgroup_iter.c:9:
>> kernel/bpf/../cgroup/cgroup-internal.h:78:41: error: field 'iter' has incomplete type
      78 |                 struct css_task_iter    iter;
         |                                         ^~~~
   kernel/bpf/../cgroup/cgroup-internal.h: In function 'cgroup_is_dead':
>> kernel/bpf/../cgroup/cgroup-internal.h:188:22: error: invalid use of undefined type 'const struct cgroup'
     188 |         return !(cgrp->self.flags & CSS_ONLINE);
         |                      ^~
>> kernel/bpf/../cgroup/cgroup-internal.h:188:37: error: 'CSS_ONLINE' undeclared (first use in this function); did you mean 'N_ONLINE'?
     188 |         return !(cgrp->self.flags & CSS_ONLINE);
         |                                     ^~~~~~~~~~
         |                                     N_ONLINE
   kernel/bpf/../cgroup/cgroup-internal.h:188:37: note: each undeclared identifier is reported only once for each function it appears in
   kernel/bpf/../cgroup/cgroup-internal.h: In function 'notify_on_release':
>> kernel/bpf/../cgroup/cgroup-internal.h:193:25: error: 'CGRP_NOTIFY_ON_RELEASE' undeclared (first use in this function)
     193 |         return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
         |                         ^~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/../cgroup/cgroup-internal.h:193:54: error: invalid use of undefined type 'const struct cgroup'
     193 |         return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
         |                                                      ^~
   kernel/bpf/../cgroup/cgroup-internal.h: In function 'put_css_set':
>> kernel/bpf/../cgroup/cgroup-internal.h:207:39: error: invalid use of undefined type 'struct css_set'
     207 |         if (refcount_dec_not_one(&cset->refcount))
         |                                       ^~
   kernel/bpf/../cgroup/cgroup-internal.h: In function 'get_css_set':
   kernel/bpf/../cgroup/cgroup-internal.h:220:27: error: invalid use of undefined type 'struct css_set'
     220 |         refcount_inc(&cset->refcount);
         |                           ^~
   kernel/bpf/../cgroup/cgroup-internal.h: At top level:
>> kernel/bpf/../cgroup/cgroup-internal.h:284:22: error: array type has incomplete element type 'struct cftype'
     284 | extern struct cftype cgroup1_base_files[];
         |                      ^~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c: In function 'cgroup_iter_seq_start':
>> kernel/bpf/cgroup_iter.c:55:24: error: implicit declaration of function 'css_next_descendant_pre' [-Werror=implicit-function-declaration]
      55 |                 return css_next_descendant_pre(NULL, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~
>> kernel/bpf/cgroup_iter.c:55:24: warning: returning 'int' from a function with return type 'void *' makes pointer from integer without a cast [-Wint-conversion]
      55 |                 return css_next_descendant_pre(NULL, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> kernel/bpf/cgroup_iter.c:57:24: error: implicit declaration of function 'css_next_descendant_post' [-Werror=implicit-function-declaration]
      57 |                 return css_next_descendant_post(NULL, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:57:24: warning: returning 'int' from a function with return type 'void *' makes pointer from integer without a cast [-Wint-conversion]
      57 |                 return css_next_descendant_post(NULL, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c: In function 'cgroup_iter_seq_next':
   kernel/bpf/cgroup_iter.c:83:24: warning: returning 'int' from a function with return type 'void *' makes pointer from integer without a cast [-Wint-conversion]
      83 |                 return css_next_descendant_pre(curr, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:85:24: warning: returning 'int' from a function with return type 'void *' makes pointer from integer without a cast [-Wint-conversion]
      85 |                 return css_next_descendant_post(curr, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> kernel/bpf/cgroup_iter.c:87:28: error: invalid use of undefined type 'struct cgroup_subsys_state'
      87 |                 return curr->parent;
         |                            ^~
   kernel/bpf/cgroup_iter.c: In function '__cgroup_iter_seq_show':
   kernel/bpf/cgroup_iter.c:100:38: error: invalid use of undefined type 'struct cgroup_subsys_state'
     100 |         if (css && cgroup_is_dead(css->cgroup))
         |                                      ^~
   kernel/bpf/cgroup_iter.c:104:31: error: invalid use of undefined type 'struct cgroup_subsys_state'
     104 |         ctx.cgroup = css ? css->cgroup : NULL;
         |                               ^~
   kernel/bpf/cgroup_iter.c: In function 'cgroup_iter_seq_init':
>> kernel/bpf/cgroup_iter.c:137:29: error: invalid use of undefined type 'struct cgroup'
     137 |         p->start_css = &cgrp->self;
         |                             ^~
   kernel/bpf/cgroup_iter.c: In function 'bpf_iter_attach_cgroup':
>> kernel/bpf/cgroup_iter.c:157:24: error: implicit declaration of function 'cgroup_get_from_fd'; did you mean 'cgroup_get_from_id'? [-Werror=implicit-function-declaration]
     157 |                 cgrp = cgroup_get_from_fd(fd);
         |                        ^~~~~~~~~~~~~~~~~~
         |                        cgroup_get_from_id
>> kernel/bpf/cgroup_iter.c:157:22: warning: assignment to 'struct cgroup *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     157 |                 cgrp = cgroup_get_from_fd(fd);
         |                      ^
>> kernel/bpf/cgroup_iter.c:159:24: error: implicit declaration of function 'cgroup_get_from_path'; did you mean 'cgroup_get_from_id'? [-Werror=implicit-function-declaration]
     159 |                 cgrp = cgroup_get_from_path("/");
         |                        ^~~~~~~~~~~~~~~~~~~~
         |                        cgroup_get_from_id
   kernel/bpf/cgroup_iter.c:159:22: warning: assignment to 'struct cgroup *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     159 |                 cgrp = cgroup_get_from_path("/");
         |                      ^
   kernel/bpf/cgroup_iter.c: In function 'bpf_iter_cgroup_show_fdinfo':
>> kernel/bpf/cgroup_iter.c:190:9: error: implicit declaration of function 'cgroup_path_ns'; did you mean 'cgroup_parent'? [-Werror=implicit-function-declaration]
     190 |         cgroup_path_ns(aux->cgroup.start, buf, PATH_MAX,
         |         ^~~~~~~~~~~~~~
         |         cgroup_parent
   kernel/bpf/cgroup_iter.c: In function 'cgroup_iter_seq_next':
   kernel/bpf/cgroup_iter.c:88:1: error: control reaches end of non-void function [-Werror=return-type]
      88 | }
         | ^
   cc1: some warnings being treated as errors


vim +/iter +78 kernel/bpf/../cgroup/cgroup-internal.h

0d2b5955b36250 Tejun Heo       2022-01-06   68  
0d2b5955b36250 Tejun Heo       2022-01-06   69  struct cgroup_file_ctx {
e57457641613fe Tejun Heo       2022-01-06   70  	struct cgroup_namespace	*ns;
e57457641613fe Tejun Heo       2022-01-06   71  
0d2b5955b36250 Tejun Heo       2022-01-06   72  	struct {
0d2b5955b36250 Tejun Heo       2022-01-06   73  		void			*trigger;
0d2b5955b36250 Tejun Heo       2022-01-06   74  	} psi;
0d2b5955b36250 Tejun Heo       2022-01-06   75  
0d2b5955b36250 Tejun Heo       2022-01-06   76  	struct {
0d2b5955b36250 Tejun Heo       2022-01-06   77  		bool			started;
0d2b5955b36250 Tejun Heo       2022-01-06  @78  		struct css_task_iter	iter;
0d2b5955b36250 Tejun Heo       2022-01-06   79  	} procs;
0d2b5955b36250 Tejun Heo       2022-01-06   80  
0d2b5955b36250 Tejun Heo       2022-01-06   81  	struct {
0d2b5955b36250 Tejun Heo       2022-01-06   82  		struct cgroup_pidlist	*pidlist;
0d2b5955b36250 Tejun Heo       2022-01-06   83  	} procs1;
0d2b5955b36250 Tejun Heo       2022-01-06   84  };
0d2b5955b36250 Tejun Heo       2022-01-06   85  
0a268dbd7932c7 Tejun Heo       2016-12-27   86  /*
0a268dbd7932c7 Tejun Heo       2016-12-27   87   * A cgroup can be associated with multiple css_sets as different tasks may
0a268dbd7932c7 Tejun Heo       2016-12-27   88   * belong to different cgroups on different hierarchies.  In the other
0a268dbd7932c7 Tejun Heo       2016-12-27   89   * direction, a css_set is naturally associated with multiple cgroups.
0a268dbd7932c7 Tejun Heo       2016-12-27   90   * This M:N relationship is represented by the following link structure
0a268dbd7932c7 Tejun Heo       2016-12-27   91   * which exists for each association and allows traversing the associations
0a268dbd7932c7 Tejun Heo       2016-12-27   92   * from both sides.
0a268dbd7932c7 Tejun Heo       2016-12-27   93   */
0a268dbd7932c7 Tejun Heo       2016-12-27   94  struct cgrp_cset_link {
0a268dbd7932c7 Tejun Heo       2016-12-27   95  	/* the cgroup and css_set this link associates */
0a268dbd7932c7 Tejun Heo       2016-12-27   96  	struct cgroup		*cgrp;
0a268dbd7932c7 Tejun Heo       2016-12-27   97  	struct css_set		*cset;
0a268dbd7932c7 Tejun Heo       2016-12-27   98  
0a268dbd7932c7 Tejun Heo       2016-12-27   99  	/* list of cgrp_cset_links anchored at cgrp->cset_links */
0a268dbd7932c7 Tejun Heo       2016-12-27  100  	struct list_head	cset_link;
0a268dbd7932c7 Tejun Heo       2016-12-27  101  
0a268dbd7932c7 Tejun Heo       2016-12-27  102  	/* list of cgrp_cset_links anchored at css_set->cgrp_links */
0a268dbd7932c7 Tejun Heo       2016-12-27  103  	struct list_head	cgrp_link;
0a268dbd7932c7 Tejun Heo       2016-12-27  104  };
0a268dbd7932c7 Tejun Heo       2016-12-27  105  
e595cd706982bf Tejun Heo       2017-01-15  106  /* used to track tasks and csets during migration */
e595cd706982bf Tejun Heo       2017-01-15  107  struct cgroup_taskset {
e595cd706982bf Tejun Heo       2017-01-15  108  	/* the src and dst cset list running through cset->mg_node */
e595cd706982bf Tejun Heo       2017-01-15  109  	struct list_head	src_csets;
e595cd706982bf Tejun Heo       2017-01-15  110  	struct list_head	dst_csets;
e595cd706982bf Tejun Heo       2017-01-15  111  
610467270fb368 Tejun Heo       2017-07-08  112  	/* the number of tasks in the set */
610467270fb368 Tejun Heo       2017-07-08  113  	int			nr_tasks;
610467270fb368 Tejun Heo       2017-07-08  114  
e595cd706982bf Tejun Heo       2017-01-15  115  	/* the subsys currently being processed */
e595cd706982bf Tejun Heo       2017-01-15  116  	int			ssid;
e595cd706982bf Tejun Heo       2017-01-15  117  
e595cd706982bf Tejun Heo       2017-01-15  118  	/*
e595cd706982bf Tejun Heo       2017-01-15  119  	 * Fields for cgroup_taskset_*() iteration.
e595cd706982bf Tejun Heo       2017-01-15  120  	 *
e595cd706982bf Tejun Heo       2017-01-15  121  	 * Before migration is committed, the target migration tasks are on
e595cd706982bf Tejun Heo       2017-01-15  122  	 * ->mg_tasks of the csets on ->src_csets.  After, on ->mg_tasks of
e595cd706982bf Tejun Heo       2017-01-15  123  	 * the csets on ->dst_csets.  ->csets point to either ->src_csets
e595cd706982bf Tejun Heo       2017-01-15  124  	 * or ->dst_csets depending on whether migration is committed.
e595cd706982bf Tejun Heo       2017-01-15  125  	 *
e595cd706982bf Tejun Heo       2017-01-15  126  	 * ->cur_csets and ->cur_task point to the current task position
e595cd706982bf Tejun Heo       2017-01-15  127  	 * during iteration.
e595cd706982bf Tejun Heo       2017-01-15  128  	 */
e595cd706982bf Tejun Heo       2017-01-15  129  	struct list_head	*csets;
e595cd706982bf Tejun Heo       2017-01-15  130  	struct css_set		*cur_cset;
e595cd706982bf Tejun Heo       2017-01-15  131  	struct task_struct	*cur_task;
e595cd706982bf Tejun Heo       2017-01-15  132  };
e595cd706982bf Tejun Heo       2017-01-15  133  
e595cd706982bf Tejun Heo       2017-01-15  134  /* migration context also tracks preloading */
e595cd706982bf Tejun Heo       2017-01-15  135  struct cgroup_mgctx {
e595cd706982bf Tejun Heo       2017-01-15  136  	/*
e595cd706982bf Tejun Heo       2017-01-15  137  	 * Preloaded source and destination csets.  Used to guarantee
e595cd706982bf Tejun Heo       2017-01-15  138  	 * atomic success or failure on actual migration.
e595cd706982bf Tejun Heo       2017-01-15  139  	 */
e595cd706982bf Tejun Heo       2017-01-15  140  	struct list_head	preloaded_src_csets;
e595cd706982bf Tejun Heo       2017-01-15  141  	struct list_head	preloaded_dst_csets;
e595cd706982bf Tejun Heo       2017-01-15  142  
e595cd706982bf Tejun Heo       2017-01-15  143  	/* tasks and csets to migrate */
e595cd706982bf Tejun Heo       2017-01-15  144  	struct cgroup_taskset	tset;
bfc2cf6f61fcea Tejun Heo       2017-01-15  145  
bfc2cf6f61fcea Tejun Heo       2017-01-15  146  	/* subsystems affected by migration */
bfc2cf6f61fcea Tejun Heo       2017-01-15  147  	u16			ss_mask;
e595cd706982bf Tejun Heo       2017-01-15  148  };
e595cd706982bf Tejun Heo       2017-01-15  149  
e595cd706982bf Tejun Heo       2017-01-15  150  #define CGROUP_TASKSET_INIT(tset)						\
e595cd706982bf Tejun Heo       2017-01-15  151  {										\
e595cd706982bf Tejun Heo       2017-01-15  152  	.src_csets		= LIST_HEAD_INIT(tset.src_csets),		\
e595cd706982bf Tejun Heo       2017-01-15  153  	.dst_csets		= LIST_HEAD_INIT(tset.dst_csets),		\
e595cd706982bf Tejun Heo       2017-01-15  154  	.csets			= &tset.src_csets,				\
e595cd706982bf Tejun Heo       2017-01-15  155  }
e595cd706982bf Tejun Heo       2017-01-15  156  
e595cd706982bf Tejun Heo       2017-01-15  157  #define CGROUP_MGCTX_INIT(name)							\
e595cd706982bf Tejun Heo       2017-01-15  158  {										\
e595cd706982bf Tejun Heo       2017-01-15  159  	LIST_HEAD_INIT(name.preloaded_src_csets),				\
e595cd706982bf Tejun Heo       2017-01-15  160  	LIST_HEAD_INIT(name.preloaded_dst_csets),				\
e595cd706982bf Tejun Heo       2017-01-15  161  	CGROUP_TASKSET_INIT(name.tset),						\
e595cd706982bf Tejun Heo       2017-01-15  162  }
e595cd706982bf Tejun Heo       2017-01-15  163  
e595cd706982bf Tejun Heo       2017-01-15  164  #define DEFINE_CGROUP_MGCTX(name)						\
e595cd706982bf Tejun Heo       2017-01-15  165  	struct cgroup_mgctx name = CGROUP_MGCTX_INIT(name)
e595cd706982bf Tejun Heo       2017-01-15  166  
0a268dbd7932c7 Tejun Heo       2016-12-27  167  extern struct mutex cgroup_mutex;
0a268dbd7932c7 Tejun Heo       2016-12-27  168  extern spinlock_t css_set_lock;
0a268dbd7932c7 Tejun Heo       2016-12-27  169  extern struct cgroup_subsys *cgroup_subsys[];
0a268dbd7932c7 Tejun Heo       2016-12-27  170  extern struct list_head cgroup_roots;
0a268dbd7932c7 Tejun Heo       2016-12-27  171  extern struct file_system_type cgroup_fs_type;
0a268dbd7932c7 Tejun Heo       2016-12-27  172  
0a268dbd7932c7 Tejun Heo       2016-12-27  173  /* iterate across the hierarchies */
0a268dbd7932c7 Tejun Heo       2016-12-27  174  #define for_each_root(root)						\
0a268dbd7932c7 Tejun Heo       2016-12-27  175  	list_for_each_entry((root), &cgroup_roots, root_list)
0a268dbd7932c7 Tejun Heo       2016-12-27  176  
0a268dbd7932c7 Tejun Heo       2016-12-27  177  /**
0a268dbd7932c7 Tejun Heo       2016-12-27  178   * for_each_subsys - iterate all enabled cgroup subsystems
0a268dbd7932c7 Tejun Heo       2016-12-27  179   * @ss: the iteration cursor
0a268dbd7932c7 Tejun Heo       2016-12-27  180   * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
0a268dbd7932c7 Tejun Heo       2016-12-27  181   */
0a268dbd7932c7 Tejun Heo       2016-12-27  182  #define for_each_subsys(ss, ssid)					\
0a268dbd7932c7 Tejun Heo       2016-12-27  183  	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
0a268dbd7932c7 Tejun Heo       2016-12-27  184  	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
0a268dbd7932c7 Tejun Heo       2016-12-27  185  
0a268dbd7932c7 Tejun Heo       2016-12-27  186  static inline bool cgroup_is_dead(const struct cgroup *cgrp)
0a268dbd7932c7 Tejun Heo       2016-12-27  187  {
0a268dbd7932c7 Tejun Heo       2016-12-27 @188  	return !(cgrp->self.flags & CSS_ONLINE);
0a268dbd7932c7 Tejun Heo       2016-12-27  189  }
0a268dbd7932c7 Tejun Heo       2016-12-27  190  
0a268dbd7932c7 Tejun Heo       2016-12-27  191  static inline bool notify_on_release(const struct cgroup *cgrp)
0a268dbd7932c7 Tejun Heo       2016-12-27  192  {
0a268dbd7932c7 Tejun Heo       2016-12-27 @193  	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
0a268dbd7932c7 Tejun Heo       2016-12-27  194  }
0a268dbd7932c7 Tejun Heo       2016-12-27  195  
dcfe149b9f45aa Tejun Heo       2016-12-27  196  void put_css_set_locked(struct css_set *cset);
dcfe149b9f45aa Tejun Heo       2016-12-27  197  
dcfe149b9f45aa Tejun Heo       2016-12-27  198  static inline void put_css_set(struct css_set *cset)
dcfe149b9f45aa Tejun Heo       2016-12-27  199  {
dcfe149b9f45aa Tejun Heo       2016-12-27  200  	unsigned long flags;
dcfe149b9f45aa Tejun Heo       2016-12-27  201  
dcfe149b9f45aa Tejun Heo       2016-12-27  202  	/*
dcfe149b9f45aa Tejun Heo       2016-12-27  203  	 * Ensure that the refcount doesn't hit zero while any readers
dcfe149b9f45aa Tejun Heo       2016-12-27  204  	 * can see it. Similar to atomic_dec_and_lock(), but for an
dcfe149b9f45aa Tejun Heo       2016-12-27  205  	 * rwlock
dcfe149b9f45aa Tejun Heo       2016-12-27  206  	 */
4b9502e63b5e2b Elena Reshetova 2017-03-08 @207  	if (refcount_dec_not_one(&cset->refcount))
dcfe149b9f45aa Tejun Heo       2016-12-27  208  		return;
dcfe149b9f45aa Tejun Heo       2016-12-27  209  
dcfe149b9f45aa Tejun Heo       2016-12-27  210  	spin_lock_irqsave(&css_set_lock, flags);
dcfe149b9f45aa Tejun Heo       2016-12-27  211  	put_css_set_locked(cset);
dcfe149b9f45aa Tejun Heo       2016-12-27  212  	spin_unlock_irqrestore(&css_set_lock, flags);
dcfe149b9f45aa Tejun Heo       2016-12-27  213  }
dcfe149b9f45aa Tejun Heo       2016-12-27  214  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
