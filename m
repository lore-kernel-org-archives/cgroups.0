From: Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH 07/14] resource limits: track highwater mark of user processes
Date: Fri, 15 Jul 2016 13:35:54 +0300
Message-ID: <1468578983-28229-8-git-send-email-toiwoton@gmail.com>
References: <1468578983-28229-1-git-send-email-toiwoton@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8NdK4lMlomqYCd9Q0WrgCXJdpJ//Xr4ZlGvcrgxzA5M=;
        b=YrT/6/eINwVZd8A/JF2EWOT2w2cpGSE+IxD8jmoICjU1olZ4/HFAQTGukRGMDHvDEE
         wSKhvYdn/P5Kjn3XQ0voecllI4DWTYxhQ6T5oWs/HcTHiOWdcFo0FdKRdX+HDvlUmvpH
         BkyLiFwi9GQsdYRJGVyiCJcClHXM8/odqhvEukPdKgBWs//ddUDZ9dW5eZvjJ8Y6KRa1
         KGxFTtbH4fYHYMurpppi2Ug8SuI5h01SYi7gY2HFht+B4mpBGbkGH8CkwTKgAkuFhnfU
         kpZi3HQQoEEd4EIs9Xa1B6KFEnf0vo5sbb1aF/Xfm0FQYbeYfT0utQ3XDt4zxlCQ39jO
         ZT6g==
In-Reply-To: <1468578983-28229-1-git-send-email-toiwoton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Topi Miettinen <toiwoton@gmail.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov@virtuozzo.com>, Joe Perches <joe@perches.com>, Frederic Weisbecker <fweisbec@gmail.com>, Andrea Arcangeli <aarcange@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Mateusz Guzik <mguzik@redhat.com>, John Stultz <john.stultz@linaro.org>, Ben Segall <bsegall@google.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>

Track maximum number of processes per user, to be able to configure
RLIMIT_NPROC resource limits. The information is available
with taskstats and cgroupstats netlink socket.

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 include/linux/sched.h | 30 ++++++++++++++++++++++++++++++
 kernel/cgroup.c       | 31 +++++++++++++++++++++++++++----
 kernel/cred.c         |  1 +
 kernel/fork.c         |  2 ++
 kernel/sys.c          |  2 ++
 kernel/tsacct.c       | 23 ++++++++++++++++++++++-
 6 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e4d7482..d6af49b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -840,6 +840,7 @@ static inline int signal_group_exit(const struct signal_struct *sig)
 struct user_struct {
 	atomic_t __count;	/* reference count */
 	atomic_t processes;	/* How many processes does this user have? */
+	atomic_t max_processes;	/* How many processes has this user had at the same time? */
 	atomic_t sigpending;	/* How many pending signals does this user have? */
 #ifdef CONFIG_INOTIFY_USER
 	atomic_t inotify_watches; /* How many inotify watches does this user have? */
@@ -3344,6 +3345,27 @@ static inline void update_resource_highwatermark(unsigned int limit,
 {
 	task_update_resource_highwatermark(current, limit, r);
 }
+
+static inline void user_update_maxproc_highwatermark(struct user_struct *u)
+{
+	int processes;
+
+	processes = atomic_read(&u->processes);
+	if (atomic_read(&u->max_processes) < processes)
+		atomic_set(&u->max_processes, processes);
+}
+
+static inline void task_update_maxproc_highwatermark(struct task_struct *t)
+{
+	const struct cred *tcred;
+
+	rcu_read_lock();
+	tcred = __task_cred(t);
+
+	user_update_maxproc_highwatermark(tcred->user);
+
+	rcu_read_unlock();
+}
 #else
 static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
 {
@@ -3370,6 +3392,14 @@ static inline void update_resource_highwatermark(unsigned int limit,
 						 unsigned long r)
 {
 }
+
+static inline void user_update_maxproc_highwatermark(struct user_struct *u)
+{
+}
+
+static inline void task_update_maxproc_highwatermark(struct task_struct *t)
+{
+}
 #endif
 
 #ifndef TASK_SIZE_OF
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9b2d805..38a272f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4660,6 +4660,23 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	return 0;
 }
 
+static void cgroup_update_maxproc_highwatermark(struct cgroup *cgrp,
+						struct task_struct *t)
+{
+	const struct cred *tcred;
+	struct user_struct *u;
+	int max_processes;
+
+	tcred = __task_cred(t);
+	u = tcred->user;
+
+	user_update_maxproc_highwatermark(u);
+
+	max_processes = atomic_read(&u->max_processes);
+	if (cgrp->stats.resource_hiwater[RLIMIT_NPROC] < max_processes)
+		cgrp->stats.resource_hiwater[RLIMIT_NPROC] = max_processes;
+}
+
 /*
  * Update cgroupstats based on the stats from exiting task
  */
@@ -4678,10 +4695,16 @@ static void cgroup_update_stats_from_task(struct cgroup *cgrp,
 		seq = nextseq;
 		flags = read_seqbegin_or_lock_irqsave(&sig->stats_lock, &seq);
 		for (i = 0; i < RLIM_NLIMITS; i++)
-			if (cgrp->stats.resource_hiwater[i] <
-			    sig->resource_highwatermark[i])
-				cgrp->stats.resource_hiwater[i] =
-					sig->resource_highwatermark[i];
+			switch(i) {
+			case RLIMIT_NPROC:
+				cgroup_update_maxproc_highwatermark(cgrp, tsk);
+				break;
+			default:
+				if (cgrp->stats.resource_hiwater[i] <
+				    sig->resource_highwatermark[i])
+					cgrp->stats.resource_hiwater[i] =
+						sig->resource_highwatermark[i];
+			}
 
 		/* If lockless access failed, take the lock. */
 		nextseq = 1;
diff --git a/kernel/cred.c b/kernel/cred.c
index 0c0cd8a..e12ab6e 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -467,6 +467,7 @@ int commit_creds(struct cred *new)
 	rcu_assign_pointer(task->cred, new);
 	if (new->user != old->user)
 		atomic_dec(&old->user->processes);
+	user_update_maxproc_highwatermark(new->user);
 	alter_cred_subscribers(old, -2);
 
 	/* send notifications */
diff --git a/kernel/fork.c b/kernel/fork.c
index 4a7ec0c..3f636c7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1640,6 +1640,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		nr_threads++;
 	}
 
+	task_update_maxproc_highwatermark(p);
+
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
 	syscall_tracepoint_update(p);
diff --git a/kernel/sys.c b/kernel/sys.c
index d84c87e..f1def17 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -439,6 +439,8 @@ static int set_user(struct cred *new)
 	else
 		current->flags &= ~PF_NPROC_EXCEEDED;
 
+	user_update_maxproc_highwatermark(new_user);
+
 	free_uid(new->user);
 	new->user = new_user;
 	return 0;
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 231bae3..9fd4cef 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -184,6 +184,19 @@ void acct_clear_integrals(struct task_struct *tsk)
 	tsk->acct_vm_mem1 = 0;
 }
 
+static __u64 task_get_maxproc_highwatermark(struct task_struct *t)
+{
+	const struct cred *tcred;
+	struct user_struct *u;
+
+	tcred = __task_cred(t);
+	u = tcred->user;
+
+	user_update_maxproc_highwatermark(u);
+
+	return (__u64)atomic_read(&u->max_processes);
+}
+
 /*
  * fill in resource accounting fields
  */
@@ -201,7 +214,15 @@ void racct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 		seq = nextseq;
 		flags = read_seqbegin_or_lock_irqsave(&sig->stats_lock, &seq);
 		for (i = 0; i < RLIM_NLIMITS; i++)
-			stats->resource_hiwater[i] = (__u64)sig->resource_highwatermark[i];
+			switch(i) {
+			case RLIMIT_NPROC:
+				stats->resource_hiwater[i] =
+					task_get_maxproc_highwatermark(tsk);
+				break;
+			default:
+				stats->resource_hiwater[i] =
+					(__u64)sig->resource_highwatermark[i];
+			}
 
 		/* If lockless access failed, take the lock. */
 		nextseq = 1;
-- 
2.8.1

