From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] Add a file named cgroup.procs_stat in cgroup
Date: Sat, 5 May 2018 15:34:09 +0800
Message-ID: <201805051540.FuMfhg8K%fengguang.wu@intel.com>
References: <1525444100-4858-1-git-send-email-qiangzh.hust@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1525444100-4858-1-git-send-email-qiangzh.hust@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhangq95 <qiangzh.hust@gmail.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, peterz@infradead.org, cgroups@vger.kernel.org, riel@redhat.com, gs051095@gmail.com, akpm@linux-foundation.org, oleg@redhat.com, tglx@linutronix.de, keescook@chromium.org, gregkh@linuxfoundation.org, longman@redhat.com, prsood@codeaurora.org, guro@fb.com, davem@davemloft.net, mhocko@suse.com, kirill.shutemov@linux.intel.com, marcos.souza.org@gmail.com, hoeun.ryu@gmail.com, rostedt@goodmis.org, bigeasy@linutronix.de, alexander.levin@verizon.com, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, zhangq95 <qiangzh.hust@gmail.com>

Hi zhangq95,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.17-rc3]
[cannot apply to cgroup/for-next next-20180504]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/zhangq95/Add-a-file-named-cgroup-procs_stat-in-cgroup/20180505-115518
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> kernel//cgroup/cgroup-v1.c:634:39: sparse: incorrect type in return expression (different base types) @@    expected int @@    got voiint @@
   kernel//cgroup/cgroup-v1.c:634:39:    expected int
   kernel//cgroup/cgroup-v1.c:634:39:    got void *
   kernel//cgroup/cgroup-v1.c:655:33: sparse: undefined identifier 'CPUACCT_PROCS_SWITCHES'
   kernel//cgroup/cgroup-v1.c:657:33: sparse: undefined identifier 'CPUACCT_PROCS_FORKS'
   kernel//cgroup/cgroup-v1.c:659:33: sparse: undefined identifier 'CPUACCT_PROCS_RUNNING'
   kernel//cgroup/cgroup-v1.c:661:33: sparse: undefined identifier 'CPUACCT_PROCS_IOWAIT'
   kernel//cgroup/cgroup-v1.c:521:16: sparse: context imbalance in '__cgroup1_procs_write' - wrong count at exit
>> kernel//cgroup/cgroup-v1.c:654:55: sparse: call with no type!
   kernel//cgroup/cgroup-v1.c:656:52: sparse: call with no type!
   kernel//cgroup/cgroup-v1.c:658:58: sparse: call with no type!
   kernel//cgroup/cgroup-v1.c:660:53: sparse: call with no type!
   kernel//cgroup/cgroup-v1.c: In function 'cgroup_procs_stat_show':
   kernel//cgroup/cgroup-v1.c:634:11: warning: return makes integer from pointer without a cast [-Wint-conversion]
       return ERR_PTR(ret);
              ^~~~~~~~~~~~
   kernel//cgroup/cgroup-v1.c:655:5: error: 'CPUACCT_PROCS_SWITCHES' undeclared (first use in this function)
        CPUACCT_PROCS_SWITCHES, 0);
        ^~~~~~~~~~~~~~~~~~~~~~
   kernel//cgroup/cgroup-v1.c:655:5: note: each undeclared identifier is reported only once for each function it appears in
   kernel//cgroup/cgroup-v1.c:657:5: error: 'CPUACCT_PROCS_FORKS' undeclared (first use in this function); did you mean 'CPUACCT_PROCS_SWITCHES'?
        CPUACCT_PROCS_FORKS, 0);
        ^~~~~~~~~~~~~~~~~~~
        CPUACCT_PROCS_SWITCHES
   kernel//cgroup/cgroup-v1.c:659:5: error: 'CPUACCT_PROCS_RUNNING' undeclared (first use in this function); did you mean 'CPUACCT_PROCS_FORKS'?
        CPUACCT_PROCS_RUNNING, 0);
        ^~~~~~~~~~~~~~~~~~~~~
        CPUACCT_PROCS_FORKS
   kernel//cgroup/cgroup-v1.c:661:5: error: 'CPUACCT_PROCS_IOWAIT' undeclared (first use in this function); did you mean 'CPUACCT_PROCS_FORKS'?
        CPUACCT_PROCS_IOWAIT, 0);
        ^~~~~~~~~~~~~~~~~~~~
        CPUACCT_PROCS_FORKS
--
   kernel//sched/core.c:279:17: sparse: expression using sizeof(void)
   kernel//sched/core.c:509:9: sparse: incompatible types in comparison expression (different address spaces)
   kernel//sched/core.c:1614:17: sparse: incompatible types in comparison expression (different address spaces)
   kernel//sched/core.c:1802:27: sparse: incompatible types in comparison expression (different address spaces)
   kernel//sched/core.c:3417:33: sparse: undefined identifier 'CPUACCT_PROCS_SWITCHES'
   kernel//sched/core.c:3477:33: sparse: undefined identifier 'CPUACCT_PROCS_SWITCHES'
   kernel//sched/core.c:3766:24: sparse: expression using sizeof(void)
   kernel//sched/core.c:3766:24: sparse: expression using sizeof(void)
   kernel//sched/core.c:3999:21: sparse: expression using sizeof(void)
   kernel//sched/core.c:3999:21: sparse: expression using sizeof(void)
   kernel//sched/core.c:3999:21: sparse: expression using sizeof(void)
   kernel//sched/core.c:3999:21: sparse: expression using sizeof(void)
   kernel//sched/core.c:3999:21: sparse: expression using sizeof(void)
   kernel//sched/core.c:3999:21: sparse: expression using sizeof(void)
   kernel//sched/core.c:3999:21: sparse: expression using sizeof(void)
   kernel//sched/core.c:4002:16: sparse: expression using sizeof(void)
   kernel//sched/core.c:4002:16: sparse: expression using sizeof(void)
   kernel//sched/core.c:4002:16: sparse: expression using sizeof(void)
   kernel//sched/core.c:4002:16: sparse: expression using sizeof(void)
   kernel//sched/core.c:4002:16: sparse: expression using sizeof(void)
   kernel//sched/core.c:4002:16: sparse: expression using sizeof(void)
   kernel//sched/core.c:4002:16: sparse: expression using sizeof(void)
   kernel//sched/core.c:3766:24: sparse: expression using sizeof(void)
   kernel//sched/core.c:3766:24: sparse: expression using sizeof(void)
   kernel//sched/core.c:3766:24: sparse: expression using sizeof(void)
   kernel//sched/core.c:3766:24: sparse: expression using sizeof(void)
   kernel//sched/core.c:4536:28: sparse: expression using sizeof(void)
   kernel//sched/core.c:4536:28: sparse: expression using sizeof(void)
   kernel//sched/core.c:4536:28: sparse: expression using sizeof(void)
   kernel//sched/core.c:4536:28: sparse: expression using sizeof(void)
   kernel//sched/core.c:4536:28: sparse: expression using sizeof(void)
   kernel//sched/core.c:4536:28: sparse: expression using sizeof(void)
   kernel//sched/core.c:4536:28: sparse: expression using sizeof(void)
   kernel//sched/core.c:4939:39: sparse: expression using sizeof(void)
   kernel//sched/core.c:4939:39: sparse: expression using sizeof(void)
   kernel//sched/core.c:6560:11: sparse: symbol 'max_cfs_quota_period' was not declared. Should it be static?
   kernel//sched/core.c:6561:11: sparse: symbol 'min_cfs_quota_period' was not declared. Should it be static?
   kernel//sched/core.c:6641:5: sparse: symbol 'tg_set_cfs_quota' was not declared. Should it be static?
   kernel//sched/core.c:6654:6: sparse: symbol 'tg_get_cfs_quota' was not declared. Should it be static?
   kernel//sched/core.c:6667:5: sparse: symbol 'tg_set_cfs_period' was not declared. Should it be static?
   kernel//sched/core.c:6677:6: sparse: symbol 'tg_get_cfs_period' was not declared. Should it be static?
   kernel//sched/core.c:6760:33: sparse: expression using sizeof(void)
   kernel//sched/core.c:6760:33: sparse: expression using sizeof(void)
>> kernel//sched/core.c:3416:50: sparse: call with no type!
   kernel//sched/core.c:3476:50: sparse: call with no type!
   kernel//sched/core.c: In function '__schedule':
   kernel//sched/core.c:3417:5: error: 'CPUACCT_PROCS_SWITCHES' undeclared (first use in this function)
        CPUACCT_PROCS_SWITCHES, 1, 0);
        ^~~~~~~~~~~~~~~~~~~~~~
   kernel//sched/core.c:3417:5: note: each undeclared identifier is reported only once for each function it appears in
--
   kernel//sched/rt.c:851:43: sparse: expression using sizeof(void)
   kernel//sched/rt.c:851:43: sparse: expression using sizeof(void)
   kernel//sched/sched.h:2148:16: sparse: incompatible types in comparison expression (different address spaces)
   kernel//sched/sched.h:2148:16: sparse: incompatible types in comparison expression (different address spaces)
   kernel//sched/rt.c:733:40: sparse: expression using sizeof(void)
   kernel//sched/rt.c:733:40: sparse: expression using sizeof(void)
   kernel//sched/rt.c:962:9: sparse: expression using sizeof(void)
   kernel//sched/rt.c:962:9: sparse: expression using sizeof(void)
   kernel//sched/rt.c:1330:50: sparse: undefined identifier 'CPUACCT_PROCS_RUNNING'
   kernel//sched/rt.c:1342:50: sparse: undefined identifier 'CPUACCT_PROCS_RUNNING'
   kernel//sched/rt.c:1664:9: sparse: incompatible types in comparison expression (different address spaces)
   kernel//sched/rt.c:2291:24: sparse: expression using sizeof(void)
   kernel//sched/rt.c:2291:24: sparse: expression using sizeof(void)
>> kernel//sched/rt.c:1330:34: sparse: call with no type!
   kernel//sched/rt.c:1342:34: sparse: call with no type!
   kernel//sched/rt.c:1757:9: sparse: context imbalance in 'find_lock_lowest_rq' - different lock contexts for basic block
   kernel//sched/rt.c:1852:9: sparse: context imbalance in 'push_rt_task' - unexpected unlock
   kernel//sched/rt.c: In function 'enqueue_task_rt':
   kernel//sched/rt.c:1330:43: error: 'CPUACCT_PROCS_RUNNING' undeclared (first use in this function)
     update_cpuacct_procs_stat(p, cpu_of(rq), CPUACCT_PROCS_RUNNING, 1, 0);
                                              ^~~~~~~~~~~~~~~~~~~~~
   kernel//sched/rt.c:1330:43: note: each undeclared identifier is reported only once for each function it appears in
   kernel//sched/rt.c: In function 'dequeue_task_rt':
   kernel//sched/rt.c:1342:43: error: 'CPUACCT_PROCS_RUNNING' undeclared (first use in this function)
     update_cpuacct_procs_stat(p, cpu_of(rq), CPUACCT_PROCS_RUNNING, -1, 0);
                                              ^~~~~~~~~~~~~~~~~~~~~

vim +634 kernel//cgroup/cgroup-v1.c

   609	
   610	static int cgroup_procs_stat_show(struct seq_file *s, void *v)
   611	{
   612		struct kernfs_open_file *of = s->private;
   613		struct cgroup *cgrp = seq_css(s)->cgroup;
   614		struct cgroup_pidlist *l;
   615		enum cgroup_filetype type = seq_cft(s)->private;
   616		struct task_struct *tsk;
   617		int ret, i = 0, j = 0, tmp = 0;
   618		unsigned long forks = 0, iowait = 0, nr_runnable = 0;
   619		pid_t *start;
   620		struct timespec64 boottime;
   621		unsigned long long start_time, switches = 0;
   622		unsigned long per_softirq_nums[NR_SOFTIRQS] = {0};
   623		unsigned long sum_softirq = 0;
   624		struct cpumask cpus_allowed;
   625	
   626		mutex_lock(&cgrp->pidlist_mutex);
   627		if (of->priv)
   628			of->priv = cgroup_pidlist_find(cgrp, type);
   629	
   630		if (!of->priv) {
   631			ret = pidlist_array_load(cgrp, type,
   632						 (struct cgroup_pidlist **)&of->priv);
   633			if (ret)
 > 634				return ERR_PTR(ret);
   635		}
   636		l = of->priv;
   637	
   638		start = l->list;
   639	
   640		tsk = find_task_by_pid_ns(*start, &init_pid_ns);
   641		getboottime64(&boottime);
   642	
   643		if (in_noninit_pid_ns(tsk) &&
   644			task_in_nonroot_cpuacct(tsk)) {
   645			if (task_css(tsk, cpuset_cgrp_id)) {
   646				memset(&cpus_allowed, 0, sizeof(cpus_allowed));
   647				get_tsk_cpu_allowed(tsk, &cpus_allowed);
   648			}
   649	
   650			start_time = tsk->real_start_time / NSEC_PER_SEC;
   651			start_time += (unsigned long long)boottime.tv_sec;
   652	
   653			for_each_cpu_and(i, cpu_possible_mask, &cpus_allowed) {
 > 654				switches += task_ca_procs_stat(tsk, i,
   655					CPUACCT_PROCS_SWITCHES, 0);
   656				forks += task_ca_procs_stat(tsk, i,
   657					CPUACCT_PROCS_FORKS, 0);
   658				nr_runnable += task_ca_procs_stat(tsk, i,
   659					CPUACCT_PROCS_RUNNING, 0);
   660				iowait += task_ca_procs_stat(tsk, i,
   661					CPUACCT_PROCS_IOWAIT, 0);
   662	
   663				for (j = 0; j < NR_SOFTIRQS; j++) {
   664					tmp = task_ca_procs_stat(tsk, i, j, 1);
   665					per_softirq_nums[j] += tmp;
   666					sum_softirq += tmp;
   667				}
   668			}
   669	
   670		} else {
   671			cpumask_copy(&cpus_allowed, cpu_possible_mask);
   672			nr_runnable = nr_running();
   673			forks = total_forks;
   674			iowait = nr_iowait();
   675			switches = nr_context_switches();
   676			start_time = (unsigned long long)boottime.tv_sec;
   677	
   678			for (j = 0; j < NR_SOFTIRQS; j++) {
   679				unsigned long softirq_stat = kstat_softirqs_cpu(j, i);
   680	
   681				per_softirq_nums[j] += softirq_stat;
   682				sum_softirq += softirq_stat;
   683			}
   684		}
   685	
   686		seq_printf(s, "softirq %lu ", sum_softirq);
   687		for (j = 0; j < NR_SOFTIRQS; j++)
   688			seq_printf(s, "%lu ", per_softirq_nums[j]);
   689	
   690		seq_puts(s, "\n");
   691		seq_printf(s,
   692			"ctxt %llu\n"
   693			"btime %llu\n"
   694			"processes %lu\n"
   695			"procs_running %lu\n"
   696			"procs_blocked %lu\n",
   697			switches,
   698			start_time,
   699			forks,
   700			nr_runnable,
   701			iowait);
   702	
   703		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork,
   704			CGROUP_PIDLIST_DESTROY_DELAY);
   705		mutex_unlock(&cgrp->pidlist_mutex);
   706	
   707		return 0;
   708	}
   709	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
