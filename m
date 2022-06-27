From: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [Question] The system may be stuck if there is a cpu cgroup
 cpu.cfs_quato_us is very low
Date: Mon, 27 Jun 2022 14:50:25 +0800
Message-ID: <5987be34-b527-4ff5-a17d-5f6f0dc94d6d@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, mgorman-l3A5Bk7waGM@public.gmane.org

Hi all,

I'm working on debuging a problem.
The testcase does follew operations:
1) create a test task cgroup, set cpu.cfs_quota_us=2000,cpu.cfs_period_us=100000.
2) run 20 test_fork[1] test process in the test task cgroup.
3) create 100 new containers:
   for i in {1..100}; do docker run -itd  --health-cmd="ls" --health-interval=1s ubuntu:latest  bash; done

These operations are expected to succeed and 100 containers create success. however, when creating containers,
the system will get stuck and create container failed.

After debug this, I found the test_fork process frequently sleep in freezer_fork()->mutex_lock()->might_sleep()
with taking the cgroup_threadgroup_rw_sem lock, as follow:

copy_process():
	cgroup_can_fork()			---> lock cgroup_threadgroup_rw_sem
	sched_cgroup_fork();
	  ->task_fork_fair(){
	      ->update_curr(){
		  ->__account_cfs_rq_runtime() {
			resched_curr();		---> the quota is used up, and set flag TIF_NEED_RESCHED to current
		   }
	cgroup_post_fork();   		
	  ->feezer_fork()
	      ->mutex_lock() {	
		  ->might_sleep()  		---> schedule() and the current task will be throttled long time.

	  ->cgroup_css_set_put_fork()    	---> unlock cgroup_threadgroup_rw_sem


Becuase the task cgroup's cpu.cfs_quota_us is very small and test_fork's load is very heavy, the test_fork
may be throttled long time, therefore, the cgroup_threadgroup_rw_sem read lock is held for a long time, other
processes will get stuck waiting for the lock:

1) a task fork child, will wait at copy_process()->cgroup_can_fork();

2) a task exiting will wait at exit_signals();

3) a task write cgroup.procs file will wait at cgroup_file_write()->__cgroup1_procs_write();
...

even the whole system will get stuck.

Anyone know how to slove this? Except for changing the cpu.cfs_quota_us.


[1] test_fork.c

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>

int main(int argc, char **argv)
{
    pid_t pid;
    int count = 20;

    while(1) {
        for (int i = 0; i < count; i++) {
            if ((pid = fork()) <0) {
                printf("fork error");
                return 1;
            } else if (pid ==0) {
                exit(0);
            }
        }

        for (int i = 0; i < count; i++) {
            wait(NULL);
        }
	sleep(1);
    }
    return 0;
}

Thanks a lot.
-Qiao
-
