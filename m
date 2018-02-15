From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 04/10] sched/core: Prevent race condition between
 cpuset and __sched_setscheduler()
Date: Thu, 15 Feb 2018 11:33:53 +0100
Message-ID: <20180215103353.GX12979@localhost.localdomain>
References: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
 <1518553967-20656-5-git-send-email-mathieu.poirier@linaro.org>
 <20180214103639.GR12979@localhost.localdomain>
 <20180214104935.GS12979@localhost.localdomain>
 <20180214112721.GT12979@localhost.localdomain>
 <CANLsYkwPo-uHOWwLZDdvhykx1EU2O--uphJ9KbZYAnD--nFoVg@mail.gmail.com>
 <20180214163145.GV12979@localhost.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180214163145.GV12979-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Claudio Scordino <claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tommaso Cucinotta <tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org>, "luca.abeni" <luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 14/02/18 17:31, Juri Lelli wrote:

[...]

> Still grabbing it is a no-go, as do_sched_setscheduler calls
> sched_setscheduler from inside an RCU read-side critical section.

I was then actually thinking that trylocking might do.. not sure however
if failing with -EBUSY in the contended case is feasible (and about the
general uglyness of the solution :/).

--->8---
 include/linux/cpuset.h | 4 ++--
 kernel/cgroup/cpuset.c | 6 +++---
 kernel/sched/core.c    | 4 +++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 4bbb3f5a3020..53c3f4e13cb0 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -55,7 +55,7 @@ extern void cpuset_init_smp(void);
 extern void cpuset_force_rebuild(void);
 extern void cpuset_update_active_cpus(void);
 extern void cpuset_wait_for_hotplug(void);
-extern void cpuset_lock(void);
+extern int cpuset_trylock(void);
 extern void cpuset_unlock(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
@@ -178,7 +178,7 @@ static inline void cpuset_update_active_cpus(void)
 
 static inline void cpuset_wait_for_hotplug(void) { }
 
-static inline void cpuset_lock(void) { }
+static inline int cpuset_trylock(void) { return 1; }
 
 static inline void cpuset_unlock(void) { }
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 41f8391640e6..995aac5b032d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2410,11 +2410,11 @@ void __init cpuset_init_smp(void)
 }
 
 /**
- * cpuset_lock - Grab the cpuset_mutex from another subsysytem
+ * cpuset_trylock - Try to grab the cpuset_mutex atomically from another subsytem
  */
-void cpuset_lock(void)
+int cpuset_trylock(void)
 {
-	mutex_lock(&cpuset_mutex);
+	return mutex_trylock(&cpuset_mutex);
 }
 
 /**
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0d8badcf1f0f..b491b406a835 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4180,7 +4180,8 @@ static int __sched_setscheduler(struct task_struct *p,
 	 * domains can be rebuilt or modified while operations like DL
 	 * admission checks are carried out.
 	 */
-	cpuset_lock();
+	if (!cpuset_trylock())
+		return -EBUSY;
 
 	/*
 	 * Make sure no PI-waiters arrive (or leave) while we are
@@ -4312,6 +4313,7 @@ static int __sched_setscheduler(struct task_struct *p,
 	/* Avoid rq from going away on us: */
 	preempt_disable();
 	task_rq_unlock(rq, p, &rf);
+	cpuset_unlock();
 
 	if (pi)
 		rt_mutex_adjust_pi(p);
