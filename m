From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH V3 04/10] sched/core: Prevent race condition between
 cpuset and __sched_setscheduler()
Date: Thu, 15 Feb 2018 12:08:44 +0100
Message-ID: <20180215110844.GY12979@localhost.localdomain>
References: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
 <1518553967-20656-5-git-send-email-mathieu.poirier@linaro.org>
 <20180214103639.GR12979@localhost.localdomain>
 <20180214104935.GS12979@localhost.localdomain>
 <20180214112721.GT12979@localhost.localdomain>
 <CANLsYkwPo-uHOWwLZDdvhykx1EU2O--uphJ9KbZYAnD--nFoVg@mail.gmail.com>
 <20180214163145.GV12979@localhost.localdomain>
 <20180215103353.GX12979@localhost.localdomain>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180215103353.GX12979@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Claudio Scordino <claudio@evidence.eu.com>, Daniel Bristot de Oliveira <bristot@redhat.com>, Tommaso Cucinotta <tommaso.cucinotta@santannapisa.it>, "luca.abeni" <luca.abeni@santannapisa.it>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 15/02/18 11:33, Juri Lelli wrote:
> On 14/02/18 17:31, Juri Lelli wrote:
> 
> [...]
> 
> > Still grabbing it is a no-go, as do_sched_setscheduler calls
> > sched_setscheduler from inside an RCU read-side critical section.
> 
> I was then actually thinking that trylocking might do.. not sure however
> if failing with -EBUSY in the contended case is feasible (and about the
> general uglyness of the solution :/).

Or, as suggested by Peter in IRC, the following (which still would
require conditional locking for the sysrq case).

--->8---
 kernel/sched/core.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0d8badcf1f0f..4e9405d50cbd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4312,6 +4312,7 @@ static int __sched_setscheduler(struct task_struct *p,
 	/* Avoid rq from going away on us: */
 	preempt_disable();
 	task_rq_unlock(rq, p, &rf);
+	cpuset_unlock();
 
 	if (pi)
 		rt_mutex_adjust_pi(p);
@@ -4409,10 +4410,16 @@ do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
 	rcu_read_lock();
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
-	if (p != NULL)
-		retval = sched_setscheduler(p, policy, &lparam);
+	if (!p) {
+		rcu_read_unlock();
+		goto exit;
+	}
+	get_task_struct(p);
 	rcu_read_unlock();
+	retval = sched_setscheduler(p, policy, &lparam);
+	put_task_struct(p);
 
+exit:
 	return retval;
 }
 
@@ -4540,10 +4547,16 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 	rcu_read_lock();
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
-	if (p != NULL)
-		retval = sched_setattr(p, &attr);
+	if (!p) {
+		rcu_read_unlock();
+		goto exit;
+	}
+	get_task_struct(p);
 	rcu_read_unlock();
+	retval = sched_setattr(p, &attr);
+	put_task_struct(p);
 
+exit:
 	return retval;
 }
 
