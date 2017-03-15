From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2] kthread, cgroup: close race window where new kthreads
 can be migrated to non-root cgroups
Date: Wed, 15 Mar 2017 19:19:20 -0400
Message-ID: <20170315231920.GB13656@htj.duckdns.org>
References: <20170315231827.GA13656@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=908GQbytM2R9XiXkpbUk2wND6MCaA3w5W12f4lBPVwo=;
        b=l5cOXY0JzHqnEaGxlVD3SEHAUrjcz+Cv4JtgQzwiBQ/rRGaNNzT/zK1pjTDnFsngsE
         u1yTmPDftD91Z2eMhwuRf+z6vgvLz8IubTZ/FcNp5bsLAAC5JrDuX8E5TAU2EkqOY3gD
         mixiGfCX0FgYw3vCPkBtD3RMsLPqRm9aY+vGYASR8L5L9sGDDVs+pNydr1nYqQMVTWnH
         uXr1RlbzoWCTtgLbWzy8v5fhJ4UGmJgSWj5rU2AUzuFuTp+czySTsJZFASuzb5BhlaVK
         u2FBfo/uQdpZBa0k28b+iewATXLtSs2GSp3padMK1IQBZpw6R6lZyEDKER7/e5vCZTtm
         KqEA==
Content-Disposition: inline
In-Reply-To: <20170315231827.GA13656@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>, linux-kernel@vger.kernel.org, kernel-team@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

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

This patch introduces KTHREAD_INITIALIZED which is set after the
kthread finishes initialization.  cgroup core closes the race window
by testing kthread_initialized() and rejecting migration accordingly.

It'd be better to wait for the initialization instead of failing but I
couldn't think of a way of implementing that without adding either a
new PF flag, or sleeping and retrying from waiting side.  Even if
userland depends on changing cgroup membership of a kthread, it either
has to be synchronized with kthread_create() or periodically repeat,
so it's unlikely that this would break anything.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Reported-and-debugged-by: Chris Mason <clm@fb.com>
Cc: stable@vger.kernel.org # v4.3+ (we can't close the race < v4.3)
---
 include/linux/kthread.h |    1 +
 kernel/cgroup/cgroup.c  |   10 ++++++----
 kernel/kthread.c        |   21 ++++++++++++++++++++-
 3 files changed, 27 insertions(+), 5 deletions(-)

--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -49,6 +49,7 @@ struct task_struct *kthread_create_on_cp
 })
 
 void free_kthread_struct(struct task_struct *k);
+bool kthread_initialized(struct task_struct *k);
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 void kthread_bind_mask(struct task_struct *k, const struct cpumask *mask);
 int kthread_stop(struct task_struct *k);
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2425,11 +2425,13 @@ ssize_t __cgroup_procs_write(struct kern
 		tsk = tsk->group_leader;
 
 	/*
-	 * Workqueue threads may acquire PF_NO_SETAFFINITY and become
-	 * trapped in a cpuset, or RT worker may be born in a cgroup
-	 * with no rt_runtime allocated.  Just say no.
+	 * kthreads may acquire PF_NO_SETAFFINITY during initialization.
+	 * If userland migrates such kthread to a non-root cgroup, it can
+	 * become trapped in a cpuset, or RT kthread may be born in a
+	 * cgroup with no rt_runtime allocated.  Just say no.
 	 */
-	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY)) {
+	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY) ||
+	    ((tsk->flags & PF_KTHREAD) && !kthread_initialized(tsk))) {
 		ret = -EINVAL;
 		goto out_unlock_rcu;
 	}
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -50,6 +50,7 @@ struct kthread {
 
 enum KTHREAD_BITS {
 	KTHREAD_IS_PER_CPU = 0,
+	KTHREAD_INITIALIZED,
 	KTHREAD_SHOULD_STOP,
 	KTHREAD_SHOULD_PARK,
 	KTHREAD_IS_PARKED,
@@ -57,7 +58,7 @@ enum KTHREAD_BITS {
 
 static inline void set_kthread_struct(void *kthread)
 {
-	/* paired with smp_read_data_barrier_depends() in to_kthread() */
+	/* paired with smp_read_barrier_depends() in to_kthread() */
 	smp_wmb();
 
 	/*
@@ -95,6 +96,23 @@ void free_kthread_struct(struct task_str
 }
 
 /**
+ * kthread_initialized - has the kthread finished initialization?
+ * @k: thread created by kthread_create().
+ *
+ * Test whether @k, which must be a kthread, finished initialization and is
+ * ready to execute the threadfn.  The kthread owner finishes
+ * initialization by waking up the new kthread for the first time.  If this
+ * function returns %false, the kthread owner could still be configuring
+ * the kthread.
+ */
+bool kthread_initialized(struct task_struct *k)
+{
+	struct kthread *kthread = to_kthread(k);
+
+	return kthread && test_bit(KTHREAD_INITIALIZED, &kthread->flags);
+}
+
+/**
  * kthread_should_stop - should this kthread return now?
  *
  * When someone calls kthread_stop() on your kthread, it will be woken
@@ -238,6 +256,7 @@ static int kthread(void *_create)
 	create->result = current;
 	complete(done);
 	schedule();
+	set_bit(KTHREAD_INITIALIZED, &self->flags);
 
 	ret = -EINTR;
 	if (!test_bit(KTHREAD_SHOULD_STOP, &self->flags)) {
