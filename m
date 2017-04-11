From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.11-rc6
Date: Wed, 12 Apr 2017 08:32:09 +0900
Message-ID: <20170411233209.GB3573@wtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Ri23FOBYtjoONMm+fTS8g7RPNtAoAl+7VZah5Ge+eyY=;
        b=CnhUSmB1SLxNSb1Fv9MpjzWfWree0HN0QSFGpKKqqbFP5lCLaAYC0xpvIMUoB0WJku
         FUvx+zzD0LRRBaHS7IZzxtoentRrefVy92fmIvnJ2Cm3VDTeYjHEbryo2MlpSSo+Vk2z
         1TuIwnbYGi3DT1leXuqOYaQHYA2xXJXa8E2NktuDIXVssP4N5Cn256oVWaUt9f88GNBO
         xvn+lyQIn8dYDekpXR+hTQl6U75XP3SYO+pKQ3vce7n3tnhOWJu9Rk8dlVIhlUtfSHrS
         btFp/1npdX75ud8X9u90g9muthHnTOPbt5b6W5TtpkViMaDloVEocUyU26AJLtIHhKj1
         l0oA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Linus.

This pull request contains fixes for two long standing subtle bugs.

* kthread_bind() on a new kthread binds it to specific CPUs and
  prevents userland from messing with the affinity or cgroup
  membership.  Unfortunately, for cgroup membership, there's a window
  between kthread creation and kthread_bind*() invocation where the
  kthread can be moved into a non-root cgroup by userland.

  Depending on what controllers are in effect, this can assign the
  kthread unexpected attributes.  For example, in the reported case,
  workqueue workers ended up in a non-root cpuset cgroups and had
  their CPU affinities overridden.  This broke workqueue invariants
  and led to workqueue stalls.

  Fixed by closing the window between kthread creation and
  kthread_bind() as suggested by Oleg.

* There was a bug in cgroup mount path which could allow two competing
  mount attempts to attach the same cgroup_root to two different
  superblocks.  This was caused by mishandling return value from
  kernfs_pin_sb().  Fixed.

Thanks.

The following changes since commit b6a6759daf55dade2b65089957832759d502acfb:

  cgroups: censor kernel pointer in debug files (2017-03-06 15:16:03 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.11-fixes

for you to fetch changes up to bfb0b80db5f9dca5ac0a5fd0edb765ee555e5a8e:

  cgroup: avoid attaching a cgroup root to two different superblocks (2017-04-11 09:00:57 +0900)

----------------------------------------------------------------
Tejun Heo (1):
      cgroup, kthread: close race window where new kthreads can be migrated to non-root cgroups

Zefan Li (1):
      cgroup: avoid attaching a cgroup root to two different superblocks

 include/linux/cgroup.h    | 21 +++++++++++++++++++++
 include/linux/sched.h     |  4 ++++
 kernel/cgroup/cgroup-v1.c |  2 +-
 kernel/cgroup/cgroup.c    |  9 +++++----
 kernel/kthread.c          |  3 +++
 5 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f6b43fb..af9c86e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -570,6 +570,25 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 	pr_cont_kernfs_path(cgrp->kn);
 }
 
+static inline void cgroup_init_kthreadd(void)
+{
+	/*
+	 * kthreadd is inherited by all kthreads, keep it in the root so
+	 * that the new kthreads are guaranteed to stay in the root until
+	 * initialization is finished.
+	 */
+	current->no_cgroup_migration = 1;
+}
+
+static inline void cgroup_kthread_ready(void)
+{
+	/*
+	 * This kthread finished initialization.  The creator should have
+	 * set PF_NO_SETAFFINITY if this kthread should stay in the root.
+	 */
+	current->no_cgroup_migration = 0;
+}
+
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
@@ -590,6 +609,8 @@ static inline void cgroup_free(struct task_struct *p) {}
 
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
+static inline void cgroup_init_kthreadd(void) {}
+static inline void cgroup_kthread_ready(void) {}
 
 static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
 					       struct cgroup *ancestor)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d67eee8..4cf9a59 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -604,6 +604,10 @@ struct task_struct {
 #ifdef CONFIG_COMPAT_BRK
 	unsigned			brk_randomized:1;
 #endif
+#ifdef CONFIG_CGROUPS
+	/* disallow userland-initiated cgroup migration */
+	unsigned			no_cgroup_migration:1;
+#endif
 
 	unsigned long			atomic_flags; /* Flags requiring atomic access. */
 
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 1dc22f6..12e19f0 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -1146,7 +1146,7 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 		 * path is super cold.  Let's just sleep a bit and retry.
 		 */
 		pinned_sb = kernfs_pin_sb(root->kf_root, NULL);
-		if (IS_ERR(pinned_sb) ||
+		if (IS_ERR_OR_NULL(pinned_sb) ||
 		    !percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			if (!IS_ERR_OR_NULL(pinned_sb))
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0125589..638ef75 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2425,11 +2425,12 @@ ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 		tsk = tsk->group_leader;
 
 	/*
-	 * Workqueue threads may acquire PF_NO_SETAFFINITY and become
-	 * trapped in a cpuset, or RT worker may be born in a cgroup
-	 * with no rt_runtime allocated.  Just say no.
+	 * kthreads may acquire PF_NO_SETAFFINITY during initialization.
+	 * If userland migrates such a kthread to a non-root cgroup, it can
+	 * become trapped in a cpuset, or RT kthread may be born in a
+	 * cgroup with no rt_runtime allocated.  Just say no.
 	 */
-	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY)) {
+	if (tsk->no_cgroup_migration || (tsk->flags & PF_NO_SETAFFINITY)) {
 		ret = -EINVAL;
 		goto out_unlock_rcu;
 	}
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 2f26ade..26db528 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -20,6 +20,7 @@
 #include <linux/freezer.h>
 #include <linux/ptrace.h>
 #include <linux/uaccess.h>
+#include <linux/cgroup.h>
 #include <trace/events/sched.h>
 
 static DEFINE_SPINLOCK(kthread_create_lock);
@@ -225,6 +226,7 @@ static int kthread(void *_create)
 
 	ret = -EINTR;
 	if (!test_bit(KTHREAD_SHOULD_STOP, &self->flags)) {
+		cgroup_kthread_ready();
 		__kthread_parkme(self);
 		ret = threadfn(data);
 	}
@@ -538,6 +540,7 @@ int kthreadd(void *unused)
 	set_mems_allowed(node_states[N_MEMORY]);
 
 	current->flags |= PF_NOFREEZE;
+	cgroup_init_kthreadd();
 
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
