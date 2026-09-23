Received: from mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B4937B011
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 05:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790139707; cv=none; b=fei1MrcEj9nX7SksWaw88QgAu/ipoOkKj558lTEnYQNQ/HmW51LaLkz9+GXAzI07zW/wBPihlzDj1JFWULIlp45tjx9fOJPtpXLo5mqCHVLaiP1emEkuB7a9ThSEl1H9sIbJ0e5dCgoj6yOs7z6aDxenGvCCV9apdxbXCQA47Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790139707; c=relaxed/simple;
	bh=NB7W55nnv9m3j88EBS7Q0Dokgh3/GpiTCpBCTKnORdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqbo+CVXtam1lZmiNs+T6YrpIMJdCEKa+/AVB83lizfwNJHcGFqWlylmcg8mTrAuo7KeOp11ji7qAsZk3EyIT7HQdjtWAV4rpcyzX3gkGazApiqs1TvMCEnHr98TdTxrV0DrCK6s+dtVG0aUpiTGhCfb9RFlsWDomWenCuY4TFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fo+vXgTv; arc=none smtp.client-ip=91.218.175.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fo+vXgTv"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NB7W55nnv9m3j88EBS7Q0Dokgh3/GpiTCpBCTKnORdI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790139703; v=1; x=1790744503;
 b=Fo+vXgTvuuwFvhU44uiODjdzEfZREoBMOPh8ibNilFnXXdT140/NjwCRZVs3TogcaoJbMKgd
 uYOxiTLwZwWrnLCzD9ynYU8WtzcUY1gklJXpU6/8U7iXQbmM6Wam1rKD+oSPVSvBtSWo2ZvHCUS
 ikuy2ATCfIc0jbF/QmZQJg8M=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 49ed22ea22592f26;
	Wed, 23 Sep 2026 05:01:43 +0000
X-Mizu-Trace-ID: 49ed22ea22592f26
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: Paul McKenney <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] locking: add opt-in tracking of sleeping lock holders
Date: Tue, 22 Sep 2026 22:01:18 -0700
Message-ID: <51bb3e392cc129937686ed8a87b2102cef2a1a93.1790139577.git.shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790139577.git.shakeel.butt@linux.dev>
References: <cover.1790139577.git.shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A task that stalls while holding a widely shared lock also stalls the
tasks waiting for that lock. One source of such stalls is a memory
allocation by the lock holder, which can get stuck in memory reclaim
because the system is low on memory or because a memcg limit is being
enforced. More concretely, if an allocation made while holding
cgroup_mutex or kernfs_rwsem gets stuck in memory reclaim (global or
memcg), other cgroupfs operations can end up waiting too, even for
unrelated cgroups.

To avoid this, the allocation path (memcg and global) needs a cheap way
to tell whether the task holds such a lock. Locks do not record all
their holders, so ask the task instead: let each task count the sleeping
locks it holds that have opted in to tracking. Read the count with
task_holds_tracked_lock(), current_holds_tracked_lock() or
task_nr_tracked_locks(). BPF can read task->nr_tracked_locks through
BTF. Only the task itself changes its count, so it needs no atomics.

No lock is tracked by default. Until the first lock opts in, the hooks
are a static branch that is off (a 2-byte NOP on x86_64). The first
opt-in turns it on for good.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 MAINTAINERS                 |   1 +
 include/linux/lockholder.h  | 119 ++++++++++++++++++++++++++++++++++++
 include/linux/sched.h       |   8 +++
 kernel/Kconfig.locks        |  16 +++++
 kernel/exit.c               |   4 ++
 kernel/fork.c               |   3 +
 kernel/locking/Makefile     |   1 +
 kernel/locking/lockholder.c |  19 ++++++
 8 files changed, 171 insertions(+)
 create mode 100644 include/linux/lockholder.h
 create mode 100644 kernel/locking/lockholder.c

diff --git a/MAINTAINERS b/MAINTAINERS
index dccddc99ac9a..097e3d9e4973 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15428,6 +15428,7 @@ F:	Documentation/locking/
 F:	arch/*/include/asm/spinlock*.h
 F:	include/linux/local_lock*.h
 F:	include/linux/lockdep*.h
+F:	include/linux/lockholder.h
 F:	include/linux/mutex*.h
 F:	include/linux/rwlock*.h
 F:	include/linux/rwsem*.h
diff --git a/include/linux/lockholder.h b/include/linux/lockholder.h
new file mode 100644
index 000000000000..480d8cdd0fbb
--- /dev/null
+++ b/include/linux/lockholder.h
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Opt-in tracking of sleeping lock holders.
+ *
+ * Each task counts the opted-in sleeping locks it holds. This gives a
+ * cheap way to check whether a task holds a lock that other tasks may be
+ * waiting for, e.g. to avoid throttling it in memory.high enforcement.
+ *
+ * No lock is tracked by default. Until the first lock opts in, the hooks
+ * are a static branch that is off.
+ */
+#ifndef __LINUX_LOCKHOLDER_H
+#define __LINUX_LOCKHOLDER_H
+
+#include <linux/bug.h>
+#include <linux/jump_label.h>
+#include <linux/sched.h>
+
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+
+DECLARE_STATIC_KEY_FALSE(lock_holder_tracking_key);
+
+/*
+ * Turn the hooks on. There is no way to turn them off, as locks never
+ * opt out. May sleep; call after jump_label_init().
+ */
+void lock_holder_tracking_enable(void);
+
+static __always_inline void __lock_holder_acquired(void)
+{
+	current->nr_tracked_locks++;
+}
+
+static __always_inline void __lock_holder_released(void)
+{
+	/*
+	 * Only the task changes its own count, so zero here means a missed
+	 * acquire hook, not a race. Don't wrap around: the task would look
+	 * like a lock holder forever.
+	 */
+	if (WARN_ON_ONCE(!current->nr_tracked_locks))
+		return;
+	current->nr_tracked_locks--;
+}
+
+/*
+ * Hooks for lock implementations. @tracked says whether this lock opted
+ * in. It is only evaluated once the static branch is on, so nothing runs
+ * until a lock opts in.
+ */
+#define lock_holder_acquired_if(tracked)				\
+do {									\
+	if (static_branch_unlikely(&lock_holder_tracking_key) &&	\
+	    (tracked))							\
+		__lock_holder_acquired();				\
+} while (0)
+
+#define lock_holder_released_if(tracked)				\
+do {									\
+	if (static_branch_unlikely(&lock_holder_tracking_key) &&	\
+	    (tracked))							\
+		__lock_holder_released();				\
+} while (0)
+
+/* For lock types that keep the opt-in in a bool "tracked" member. */
+#define lock_holder_acquired(lock)	lock_holder_acquired_if((lock)->tracked)
+#define lock_holder_released(lock)	lock_holder_released_if((lock)->tracked)
+
+static inline void lock_holder_task_init(struct task_struct *p)
+{
+	p->nr_tracked_locks = 0;
+}
+
+static inline unsigned int task_nr_tracked_locks(struct task_struct *p)
+{
+	/*
+	 * Only @p writes this, so a cross-task read can see a stale value.
+	 * Callers asking about another task want a hint, not a guarantee.
+	 */
+	return data_race(p->nr_tracked_locks);
+}
+
+#else /* !CONFIG_TRACK_LOCK_HOLDERS */
+
+#define lock_holder_acquired_if(tracked)	do { (void)(tracked); } while (0)
+#define lock_holder_released_if(tracked)	do { (void)(tracked); } while (0)
+#define lock_holder_acquired(lock)	do { (void)(lock); } while (0)
+#define lock_holder_released(lock)	do { (void)(lock); } while (0)
+
+static inline void lock_holder_task_init(struct task_struct *p) { }
+
+static inline unsigned int task_nr_tracked_locks(struct task_struct *p)
+{
+	return 0;
+}
+
+#endif /* CONFIG_TRACK_LOCK_HOLDERS */
+
+/**
+ * task_holds_tracked_lock - check if a task holds an opted-in lock
+ * @p: task to check
+ *
+ * For a task other than current, the answer can change at any time.
+ * Always false without CONFIG_TRACK_LOCK_HOLDERS.
+ */
+static inline bool task_holds_tracked_lock(struct task_struct *p)
+{
+	return task_nr_tracked_locks(p) != 0;
+}
+
+/**
+ * current_holds_tracked_lock - check if current holds an opted-in lock
+ */
+static inline bool current_holds_tracked_lock(void)
+{
+	return task_holds_tracked_lock(current);
+}
+
+#endif /* __LINUX_LOCKHOLDER_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5ce350a616e4..3f7f459e33fd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1306,6 +1306,14 @@ struct task_struct {
 	struct held_lock		held_locks[MAX_LOCK_DEPTH];
 #endif
 
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+	/*
+	 * Number of opted-in sleeping locks held. Only the task itself
+	 * changes it, so it needs no atomics. See linux/lockholder.h.
+	 */
+	unsigned int			nr_tracked_locks;
+#endif
+
 #if defined(CONFIG_UBSAN) && !defined(CONFIG_UBSAN_TRAP)
 	unsigned int			in_ubsan;
 #endif
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 1c6423aafcd4..9489e6ce72c0 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -279,3 +279,19 @@ config ARCH_HAS_MMIOWB
 config MMIOWB
 	def_bool y if ARCH_HAS_MMIOWB
 	depends on SMP
+
+config TRACK_LOCK_HOLDERS
+	bool "Track holders of selected sleeping locks"
+	help
+	  Keep a per-task count of held sleeping locks that have opted in
+	  to tracking. This lets code check whether a task holds a lock
+	  that others may be waiting for, e.g. to avoid stalling it in
+	  memcg limit enforcement or under global memory pressure.
+
+	  No lock is tracked until one opts in. Until then, the lock hooks
+	  are a static branch that is off. The opt-in is a spare bit in a
+	  word the lock already has, or existing padding, so on 64-bit no
+	  lock grows. Where there is no padding to use, as on 32-bit, some
+	  locks grow by a word.
+
+	  If unsure, say N.
diff --git a/kernel/exit.c b/kernel/exit.c
index 0430d7c16600..57b05fb19ea3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -35,6 +35,7 @@
 #include <linux/mount.h>
 #include <linux/proc_fs.h>
 #include <linux/kthread.h>
+#include <linux/lockholder.h>
 #include <linux/mempolicy.h>
 #include <linux/taskstats_kern.h>
 #include <linux/delayacct.h>
@@ -1025,6 +1026,9 @@ void __noreturn do_exit(long code)
 	 * Make sure we are holding no locks:
 	 */
 	debug_check_no_locks_held();
+	WARN_ONCE(task_holds_tracked_lock(tsk),
+		  "%s/%d exiting while holding %u tracked lock(s)\n",
+		  tsk->comm, task_pid_nr(tsk), task_nr_tracked_locks(tsk));
 
 	if (tsk->io_context)
 		exit_io_context(tsk);
diff --git a/kernel/fork.c b/kernel/fork.c
index 39be51048d77..6c461c7e2187 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -94,6 +94,7 @@
 #include <linux/sysctl.h>
 #include <linux/kcov.h>
 #include <linux/livepatch.h>
+#include <linux/lockholder.h>
 #include <linux/thread_info.h>
 #include <linux/kstack_erase.h>
 #include <linux/kasan.h>
@@ -2265,6 +2266,8 @@ __latent_entropy struct task_struct *copy_process(
 
 	lockdep_init_task(p);
 
+	lock_holder_task_init(p);
+
 	p->blocked_on = NULL; /* not blocked yet */
 	p->blocked_donor = NULL; /* nobody is boosting p yet */
 
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index cee1901d4cff..a0945beb304c 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -9,6 +9,7 @@ CONTEXT_ANALYSIS_ww_rt_mutex.o := y
 CONTEXT_ANALYSIS_rwsem.o := y
 
 obj-y += mutex.o semaphore.o rwsem.o percpu-rwsem.o
+obj-$(CONFIG_TRACK_LOCK_HOLDERS) += lockholder.o
 
 # Avoid recursion lockdep -> sanitizer -> ... -> lockdep & improve performance.
 KASAN_SANITIZE_lockdep.o := n
diff --git a/kernel/locking/lockholder.c b/kernel/locking/lockholder.c
new file mode 100644
index 000000000000..99428c6141c6
--- /dev/null
+++ b/kernel/locking/lockholder.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Opt-in tracking of sleeping lock holders. See linux/lockholder.h.
+ */
+#include <linux/export.h>
+#include <linux/lockholder.h>
+
+/* Exported for inline lock functions used by modules. */
+DEFINE_STATIC_KEY_FALSE(lock_holder_tracking_key);
+EXPORT_SYMBOL_GPL(lock_holder_tracking_key);
+
+void lock_holder_tracking_enable(void)
+{
+	/* static_branch_enable() takes cpus_read_lock() even if already on. */
+	if (static_key_enabled(&lock_holder_tracking_key))
+		return;
+
+	static_branch_enable(&lock_holder_tracking_key);
+}
-- 
2.53.0-Meta

