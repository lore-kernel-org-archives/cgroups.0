Received: from mta1.migadu.com (out-164.mta1.migadu.com [95.215.58.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494144A6898
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 15:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265068; cv=none; b=GOrerDsTgadc8Fj1tPOJfR2hLhUdFhjOxeSHt+GNiedlrpj0G/PJ+K/0zX0x7H2thVfjAfYTNYKCiFn58UFraGsJNHTH10fRPHWYLuyNGCCEcBpEzDHpWLOXjWkpOAraXimF+XZbEZSx1qAfIdKyC9pl9tht+uE3UVmz3dwOPUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265068; c=relaxed/simple;
	bh=/WnTB8msSHSCldW0fmcb/5h6xZ2faRRaUT+OuE281eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQVM6BN/AV9y6JCX5A2vsDvN63nvtPFUZCA8JvbsQyGlD/pXIzAH0OKmXcdtKu09C/5mmlgK2ZSVRoNriF1hWbE9uVtdyHEd6y4zJ7YFU/mJS5/aeNnwSRGXMedWesCoMonFnclPYSfeRHLG+2e7j9bI8+WCgBHeKoMubr62RrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=inSg2nrN; arc=none smtp.client-ip=95.215.58.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="inSg2nrN"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/WnTB8msSHSCldW0fmcb/5h6xZ2faRRaUT+OuE281eI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790265064; v=1; x=1790869864;
 b=inSg2nrN7O2FDmaTPstXjzxtY7J3JfNGFvj3YcF/of4UNmg72g8l+W/vvWz9SexPstCQ4Y17
 oLzSzFxfcvFFB/+tfilSvDPallFkAWac6O4oScp+4svDhgWd2LQPRkxJPa4pLNfixvV3ky2J7wL
 tPSdeffL/fUKvM22AzsWMz+A=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2331acd99201f663;
	Thu, 24 Sep 2026 15:51:03 +0000
X-Mizu-Trace-ID: 2331acd99201f663
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
Subject: [PATCH RESEND 4/7] locking/percpu-rwsem: track holders of opted-in percpu_rw_semaphores
Date: Thu, 24 Sep 2026 08:50:22 -0700
Message-ID: <20260924155025.949998-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924155025.949998-1-shakeel.butt@linux.dev>
References: <20260924155025.949998-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add percpu_rwsem_track_holder() to opt a percpu_rw_semaphore in to
holder tracking.

The read fast and slow paths meet before the hook in
percpu_down_read_internal(), so one hook covers both.
percpu_down_read_trylock() counts only on success.

percpu_rwsem_release() and percpu_rwsem_acquire() pass a held lock to
another task. Filesystem freeze uses them to return to user space
holding the lock, and async writes (kiocb_start_write()) use them
because the write may complete in another context. Move the count in
these calls too, so it stays right for each task.

The read side counts inside the preempt-disabled region, so a task is
never preemptible holding @sem without being counted for it.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/percpu-rwsem.h  | 42 +++++++++++++++++++++++++++++++++++
 kernel/locking/percpu-rwsem.c | 28 +++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index 39d5bf8e6562..1a131ed8e8f1 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -8,6 +8,7 @@
 #include <linux/wait.h>
 #include <linux/rcu_sync.h>
 #include <linux/lockdep.h>
+#include <linux/lockholder.h>
 #include <linux/cleanup.h>
 
 struct percpu_rw_semaphore {
@@ -16,6 +17,13 @@ struct percpu_rw_semaphore {
 	struct rcuwait		writer;
 	wait_queue_head_t	waiters;
 	atomic_t		block;
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+	/*
+	 * Set by percpu_rwsem_track_holder() before first use. Fits in the
+	 * padding after block, so the struct does not grow on 64-bit.
+	 */
+	bool			tracked;
+#endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
@@ -65,6 +73,11 @@ static inline void percpu_down_read_internal(struct percpu_rw_semaphore *sem,
 		this_cpu_inc(*sem->read_count);
 	else
 		__percpu_down_read(sem, false, freezable); /* Unconditional memory barrier */
+	/*
+	 * Count the lock before preemption comes back, so the task is
+	 * never preemptible holding @sem but not counted for it.
+	 */
+	lock_holder_acquired(sem);
 	/*
 	 * The preempt_enable() prevents the compiler from
 	 * bleeding the critical section out.
@@ -95,6 +108,12 @@ static inline bool percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
 		this_cpu_inc(*sem->read_count);
 	else
 		ret = __percpu_down_read(sem, true, false); /* Unconditional memory barrier */
+	/*
+	 * Count the lock before preemption comes back, as in
+	 * percpu_down_read_internal().
+	 */
+	if (ret)
+		lock_holder_acquired(sem);
 	preempt_enable();
 	/*
 	 * The barrier() from preempt_enable() prevents the compiler from
@@ -111,6 +130,7 @@ extern void __percpu_up_read(struct percpu_rw_semaphore *sem);
 
 static inline void percpu_up_read(struct percpu_rw_semaphore *sem)
 {
+	lock_holder_released(sem);
 	rwsem_release(&sem->dep_map, _RET_IP_);
 
 	preempt_disable();
@@ -129,6 +149,20 @@ extern bool percpu_is_read_locked(struct percpu_rw_semaphore *);
 extern void percpu_down_write(struct percpu_rw_semaphore *);
 extern void percpu_up_write(struct percpu_rw_semaphore *);
 
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+/**
+ * percpu_rwsem_track_holder - track the holders of a percpu_rw_semaphore
+ * @sem: initialized percpu_rw_semaphore that no one holds yet
+ *
+ * Count @sem in task_nr_tracked_locks() of the tasks holding it. Use it
+ * for locks whose holders can stall unrelated work. Call it before anyone
+ * can take @sem, e.g. right after percpu_init_rwsem().
+ */
+void percpu_rwsem_track_holder(struct percpu_rw_semaphore *sem);
+#else
+static inline void percpu_rwsem_track_holder(struct percpu_rw_semaphore *sem) { }
+#endif
+
 DEFINE_GUARD(percpu_read, struct percpu_rw_semaphore *,
 	     percpu_down_read(_T), percpu_up_read(_T))
 DEFINE_GUARD_COND(percpu_read, _try, percpu_down_read_trylock(_T))
@@ -156,9 +190,16 @@ extern void percpu_free_rwsem(struct percpu_rw_semaphore *);
 #define percpu_rwsem_is_held(sem)	lockdep_is_held(sem)
 #define percpu_rwsem_assert_held(sem)	lockdep_assert_held(sem)
 
+/*
+ * These pass a held lock to another task. For example, filesystem freeze
+ * returns to user space holding the lock, and thaw, maybe in another
+ * task, releases it. The holder count moves with the lock, as lockdep's
+ * view of it does.
+ */
 static inline void percpu_rwsem_release(struct percpu_rw_semaphore *sem,
 					unsigned long ip)
 {
+	lock_holder_released(sem);
 	lock_release(&sem->dep_map, ip);
 }
 
@@ -166,6 +207,7 @@ static inline void percpu_rwsem_acquire(struct percpu_rw_semaphore *sem,
 					bool read, unsigned long ip)
 {
 	lock_acquire(&sem->dep_map, 0, 1, read, 1, NULL, ip);
+	lock_holder_acquired(sem);
 }
 
 #endif
diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
index 6c78961fe753..e100c33731ca 100644
--- a/kernel/locking/percpu-rwsem.c
+++ b/kernel/locking/percpu-rwsem.c
@@ -22,6 +22,9 @@ int __percpu_init_rwsem(struct percpu_rw_semaphore *sem,
 	rcuwait_init(&sem->writer);
 	init_waitqueue_head(&sem->waiters);
 	atomic_set(&sem->block, 0);
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+	sem->tracked = false;
+#endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
 	lockdep_init_map(&sem->dep_map, name, key, 0);
@@ -201,6 +204,28 @@ bool percpu_is_read_locked(struct percpu_rw_semaphore *sem)
 }
 EXPORT_SYMBOL_GPL(percpu_is_read_locked);
 
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+void percpu_rwsem_track_holder(struct percpu_rw_semaphore *sem)
+{
+	/*
+	 * A task holding @sem now was not counted, so its percpu_up_*()
+	 * would make its count wrong.
+	 */
+	if (WARN_ONCE(percpu_is_read_locked(sem) || percpu_is_write_locked(sem),
+		      "%s: rwsem is held; opt in before it is published\n",
+		      __func__))
+		return;
+
+	/*
+	 * Turn the hooks on before the flag, so that a lock carrying the
+	 * flag always has them on.
+	 */
+	lock_holder_tracking_enable();
+	sem->tracked = true;
+}
+EXPORT_SYMBOL_GPL(percpu_rwsem_track_holder);
+#endif
+
 /*
  * Return true if the modular sum of the sem->read_count per-CPU variable is
  * zero.  If this sum is zero, then it is stable due to the fact that if any
@@ -256,11 +281,14 @@ void __sched percpu_down_write(struct percpu_rw_semaphore *sem)
 	rcuwait_wait_event(&sem->writer, readers_active_check(sem), TASK_UNINTERRUPTIBLE);
 	if (contended)
 		trace_contention_end(sem, 0);
+
+	lock_holder_acquired(sem);
 }
 EXPORT_SYMBOL_GPL(percpu_down_write);
 
 void percpu_up_write(struct percpu_rw_semaphore *sem)
 {
+	lock_holder_released(sem);
 	rwsem_release(&sem->dep_map, _RET_IP_);
 
 	if (trace_contended_release_enabled() && wq_has_sleeper(&sem->waiters))
-- 
2.53.0-Meta

