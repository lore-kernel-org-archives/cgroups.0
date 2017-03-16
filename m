From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] cgroup, kthread: close race window where new kthreads can
 be migrated to non-root cgroups
Date: Thu, 16 Mar 2017 16:54:24 -0400
Message-ID: <20170316205424.GH15810@htj.duckdns.org>
References: <20170315231827.GA13656@htj.duckdns.org>
 <20170315231920.GB13656@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pIQK6rrtKwoVPKEePAs9wPN7fTu1KizOcLVkzTp8xe4=;
        b=s1qTmd6Jcfr+JWUQbPJ2FjeWhT3g2GSE7L/52YptmxMVTcGpt650VgDjxnDASUeimQ
         +AD+oGLesqmSWyVioVov9u2SPABxQFpGWc+siQwAlk59bMzHuBiaNATe1U1JBsjUA497
         ZD8LZei0HQJp2mJ50Z1MpDLtcDust0SJfWwKxgU0RE0pJY88POkJJ4IMqwEY5//Gi14U
         JIKVkOPUbGvAc717du9HzIFgPMmdkI9QoJS/IPpjetzBFRK7K4OON4MelI2p/CD/C3pA
         9Knd4u9uyr6Z1nzuhflZblOgDLAO8tPHG8v0upbgGlKiE65bLiKNDc0TdoZtDEsH1DXe
         jHKw==
Content-Disposition: inline
In-Reply-To: <20170315231920.GB13656-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I tried a couple variants but Oleg's suggestion turns out to be the
simplest.  This patch doesn't require the first barrier patch.  Oleg,
if you're okay with the patch, I can route this through
cgroup/for-4.11-fixes.

Thanks!

------ 8< ------
Creation of a kthread goes through a couple interlocked stages between
the kthread itself and its creator.  Once the new kthread starts
running, it initializes itself and wakes up the creator.  The creator
then can further configure the kthread and then let it start doing its
job by waking it up.

In this configuration-by-creator stage, the creator is the only one
that can wake it up but the kthread is visible to userland.  When
altering the kthread's attributes from userland is allowed, this is
fine; however, for cases where CPU affinity is critical,
kthread_bind() is used to first disable affinity changes from userland
and then set the affinity.  This also prevents the kthread from being
migrated into non-root cgroups as that can affect the CPU affinity and
many other things.

Unfortunately, the cgroup side of protection is racy.  While the
PF_NO_SETAFFINITY flag prevents further migrations, userland can win
the race before the creator sets the flag with kthread_bind() and put
the kthread in a non-root cgroup, which can lead to all sorts of
problems including incorrect CPU affinity and starvation.

This bug got triggered by userland which periodically tries to migrate
all processes in the root cpuset cgroup to a non-root one.  Per-cpu
workqueue workers got caught while being created and ended up with
incorrected CPU affinity breaking concurrency management and sometimes
stalling workqueue execution.

This patch adds task->no_cgroup_migration which disallows the task to
be migrated by userland.  kthreadd starts with the flag set making
every child kthread start in the root cgroup with migration
disallowed.  The flag is cleared after the kthread finishes
initialization by which time PF_NO_SETAFFINITY is set if the kthread
should stay in the root cgroup.

It'd be better to wait for the initialization instead of failing but I
couldn't think of a way of implementing that without adding either a
new PF flag, or sleeping and retrying from waiting side.  Even if
userland depends on changing cgroup membership of a kthread, it either
has to be synchronized with kthread_create() or periodically repeat,
so it's unlikely that this would break anything.

v2: Switch to a simpler implementation using a new task_struct bit
    field suggested by Oleg.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Suggested-by: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Reported-and-debugged-by: Chris Mason <clm-b10kYP2dOMg@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.3+ (we can't close the race on < v4.3)
---
 include/linux/cgroup.h |   21 +++++++++++++++++++++
 include/linux/sched.h  |    4 ++++
 kernel/cgroup/cgroup.c |    9 +++++----
 kernel/kthread.c       |    3 +++
 4 files changed, 33 insertions(+), 4 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -570,6 +570,25 @@ static inline void pr_cont_cgroup_path(s
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
@@ -590,6 +609,8 @@ static inline void cgroup_free(struct ta
 
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
+static inline void cgroup_init_kthreadd(void) {}
+static inline void cgroup_kthread_ready(void) {}
 
 static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
 					       struct cgroup *ancestor)
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
 
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2425,11 +2425,12 @@ ssize_t __cgroup_procs_write(struct kern
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
