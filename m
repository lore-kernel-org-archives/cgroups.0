From: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/1] do not abuse ->cred_guard_mutex in threadgroup_lock()
Date: Sat, 9 Mar 2013 21:01:06 +0100
Message-ID: <20130309200106.GB8149@redhat.com>
References: <20130306223657.GA7392@redhat.com> <20130307172545.GA10353@redhat.com> <20130307180139.GD29601@htj.dyndns.org> <20130307180332.GE29601@htj.dyndns.org> <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org> <513A9A67.60909@huawei.com> <20130309032936.GT14556@mtj.dyndns.org> <513AE918.7020704@huawei.com> <20130309200046.GA8149@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130309200046.GA8149@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org

threadgroup_lock() takes signal->cred_guard_mutex to ensure that
thread_group_leader() is stable. This doesn't look nice, the scope
of this lock in do_execve() is huge.

And as Dave pointed out this can lead to deadlock, we have the
following dependencies:

	do_execve:		cred_guard_mutex -> i_mutex
	cgroup_mount:		i_mutex -> cgroup_mutex
	attach_task_by_pid:	cgroup_mutex -> cred_guard_mutex

Change de_thread() to take threadgroup_change_begin() around the
switch-the-leader code and change threadgroup_lock() to avoid
->cred_guard_mutex.

Note that de_thread() can't sleep with ->group_rwsem held, this
can obviously deadlock with the exiting leader if the writer is
active, so it does threadgroup_change_end() before schedule().

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c             |    3 +++
 include/linux/sched.h |   18 ++++--------------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 20df02c..bea2f7d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -898,11 +898,13 @@ static int de_thread(struct task_struct *tsk)
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
+			threadgroup_change_begin(tsk);
 			write_lock_irq(&tasklist_lock);
 			if (likely(leader->exit_state))
 				break;
 			__set_current_state(TASK_KILLABLE);
 			write_unlock_irq(&tasklist_lock);
+			threadgroup_change_end(tsk);
 			schedule();
 			if (unlikely(__fatal_signal_pending(tsk)))
 				goto killed;
@@ -960,6 +962,7 @@ static int de_thread(struct task_struct *tsk)
 		if (unlikely(leader->ptrace))
 			__wake_up_parent(leader, leader->parent);
 		write_unlock_irq(&tasklist_lock);
+		threadgroup_change_end(tsk);
 
 		release_task(leader);
 	}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 932a90c..67cfdb5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2486,27 +2486,18 @@ static inline void threadgroup_change_end(struct task_struct *tsk)
  *
  * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
  * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
- * perform exec.  This is useful for cases where the threadgroup needs to
- * stay stable across blockable operations.
+ * change ->group_leader/pid.  This is useful for cases where the threadgroup
+ * needs to stay stable across blockable operations.
  *
  * fork and exit paths explicitly call threadgroup_change_{begin|end}() for
  * synchronization.  While held, no new task will be added to threadgroup
  * and no existing live task will have its PF_EXITING set.
  *
- * During exec, a task goes and puts its thread group through unusual
- * changes.  After de-threading, exclusive access is assumed to resources
- * which are usually shared by tasks in the same group - e.g. sighand may
- * be replaced with a new one.  Also, the exec'ing task takes over group
- * leader role including its pid.  Exclude these changes while locked by
- * grabbing cred_guard_mutex which is used to synchronize exec path.
+ * de_thread() does threadgroup_change_{begin|end}() when a non-leader
+ * sub-thread becomes a new leader.
  */
 static inline void threadgroup_lock(struct task_struct *tsk)
 {
-	/*
-	 * exec uses exit for de-threading nesting group_rwsem inside
-	 * cred_guard_mutex. Grab cred_guard_mutex first.
-	 */
-	mutex_lock(&tsk->signal->cred_guard_mutex);
 	down_write(&tsk->signal->group_rwsem);
 }
 
@@ -2519,7 +2510,6 @@ static inline void threadgroup_lock(struct task_struct *tsk)
 static inline void threadgroup_unlock(struct task_struct *tsk)
 {
 	up_write(&tsk->signal->group_rwsem);
-	mutex_unlock(&tsk->signal->cred_guard_mutex);
 }
 #else
 static inline void threadgroup_change_begin(struct task_struct *tsk) {}
-- 
1.5.5.1

