From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:review-cgroup2-threads-v3 10/10]
 kernel/cgroup/debug.c:137:21: sparse: incompatible types in comparison
 expression (different address spaces)
Date: Tue, 18 Jul 2017 07:07:55 +0800
Message-ID: <201707180750.LyrRAyBE%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-threads-v3
head:   6fb1273ffe28c2f094c7816768854a74312bf1ed
commit: 6fb1273ffe28c2f094c7816768854a74312bf1ed [10/10] cgroup: update debug controller to print out thread mode information
reproduce:
        # apt-get install sparse
        git checkout 6fb1273ffe28c2f094c7816768854a74312bf1ed
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:260:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> kernel/cgroup/debug.c:137:21: sparse: incompatible types in comparison expression (different address spaces)

vim +137 kernel/cgroup/debug.c

   111	
   112	#define MAX_TASKS_SHOWN_PER_CSS 25
   113	static int cgroup_css_links_read(struct seq_file *seq, void *v)
   114	{
   115		struct cgroup_subsys_state *css = seq_css(seq);
   116		struct cgrp_cset_link *link;
   117		int dead_cnt = 0, extra_refs = 0, threaded_csets = 0;
   118	
   119		spin_lock_irq(&css_set_lock);
   120	
   121		if (cgroup_is_thread_root(css->cgroup))
   122			seq_puts(seq, "[thread root]\n");
   123		else if (cgroup_is_threaded(css->cgroup))
   124			seq_puts(seq, "[threaded]\n");
   125	
   126		list_for_each_entry(link, &css->cgroup->cset_links, cset_link) {
   127			struct css_set *cset = link->cset;
   128			struct task_struct *task;
   129			int count = 0;
   130			int refcnt = refcount_read(&cset->refcount);
   131	
   132			/*
   133			 * Print out the proc_cset and threaded_cset relationship
   134			 * and highlight difference between refcount and task_count.
   135			 */
   136			seq_printf(seq, "css_set %pK", cset);
 > 137			if (rcu_dereference_protected(cset->dom_cset, 1) != cset) {
   138				threaded_csets++;
   139				seq_printf(seq, "=>%pK", cset->dom_cset);
   140			}
   141			if (!list_empty(&cset->threaded_csets)) {
   142				struct css_set *tcset;
   143				int idx = 0;
   144	
   145				list_for_each_entry(tcset, &cset->threaded_csets,
   146						    threaded_csets_node) {
   147					seq_puts(seq, idx ? "," : "<=");
   148					seq_printf(seq, "%pK", tcset);
   149					idx++;
   150				}
   151			} else {
   152				seq_printf(seq, " %d", refcnt);
   153				if (refcnt - cset->nr_tasks > 0) {
   154					int extra = refcnt - cset->nr_tasks;
   155	
   156					seq_printf(seq, " +%d", extra);
   157					/*
   158					 * Take out the one additional reference in
   159					 * init_css_set.
   160					 */
   161					if (cset == &init_css_set)
   162						extra--;
   163					extra_refs += extra;
   164				}
   165			}
   166			seq_puts(seq, "\n");
   167	
   168			list_for_each_entry(task, &cset->tasks, cg_list) {
   169				if (count++ <= MAX_TASKS_SHOWN_PER_CSS)
   170					seq_printf(seq, "  task %d\n",
   171						   task_pid_vnr(task));
   172			}
   173	
   174			list_for_each_entry(task, &cset->mg_tasks, cg_list) {
   175				if (count++ <= MAX_TASKS_SHOWN_PER_CSS)
   176					seq_printf(seq, "  task %d\n",
   177						   task_pid_vnr(task));
   178			}
   179			/* show # of overflowed tasks */
   180			if (count > MAX_TASKS_SHOWN_PER_CSS)
   181				seq_printf(seq, "  ... (%d)\n",
   182					   count - MAX_TASKS_SHOWN_PER_CSS);
   183	
   184			if (cset->dead) {
   185				seq_puts(seq, "    [dead]\n");
   186				dead_cnt++;
   187			}
   188	
   189			WARN_ON(count != cset->nr_tasks);
   190		}
   191		spin_unlock_irq(&css_set_lock);
   192	
   193		if (!dead_cnt && !extra_refs && !threaded_csets)
   194			return 0;
   195	
   196		seq_puts(seq, "\n");
   197		if (threaded_csets)
   198			seq_printf(seq, "threaded css_sets = %d\n", threaded_csets);
   199		if (extra_refs)
   200			seq_printf(seq, "extra references = %d\n", extra_refs);
   201		if (dead_cnt)
   202			seq_printf(seq, "dead css_sets = %d\n", dead_cnt);
   203	
   204		return 0;
   205	}
   206	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
