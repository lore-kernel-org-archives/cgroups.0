Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF3B4A5EA8
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 15:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265060; cv=none; b=MEVgi1jmuSLNoyyX0vmnCp3yqESbUORqerkCjiZrxKPNVY7roVAmPz/ZxE1gGFDff1Pt9sdiq43shGFWMz2S3LM1F/wG/RwNOlsrdPX2qELM+NVNKH3O03VSMtoGnmxtYhaiNZrbfVYCgusC8LL9iNA/fZSC4+7k8DihjxDjlZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265060; c=relaxed/simple;
	bh=iQ4uLoMjcj0junE2ksDopo/DPDn3rk3XgKmcn0anIUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gh9em+mx/ELH970okp2ItqQZrEgPmwsGYmKQYCs3GZQRw4m1uxXD6UP3czfB17mf/D+cjFp6Jw8PJUR4JP6B8NkI7P2pwJDt5KR8JgbHBPoakaDMRlQwI9KngUlyOgeBMzRc/YqLQsTUZC7qqqr1zC53iHQ2Nd9C1vjlLPcO4FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K404oP1M; arc=none smtp.client-ip=91.218.175.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K404oP1M"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iQ4uLoMjcj0junE2ksDopo/DPDn3rk3XgKmcn0anIUs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790265055; v=1; x=1790869855;
 b=K404oP1MvTCpI6M9DXeyQi/iNtkv2fO6jIsaqbRZGPuTvg+PpA161UfXRpEktdUqEVcM3RAf
 dZdZSkhZjnwsdOhmT/IvVCeyONyZJ9Bco2bkUkp0inXDS//XKyCG9HkPaTdLePxlpW+e4hKrzii
 CF4/pvMtbIPQzmpUIGk2AYSc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 49b038366049e99a;
	Thu, 24 Sep 2026 15:50:55 +0000
X-Mizu-Trace-ID: 49b038366049e99a
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
Subject: [PATCH RESEND 2/7] locking/rwsem: track holders of opted-in rw_semaphores
Date: Thu, 24 Sep 2026 08:50:20 -0700
Message-ID: <20260924155025.949998-3-shakeel.butt@linux.dev>
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

Add rwsem_track_holder() to opt an rw_semaphore in to holder tracking.

The count goes up once down_*() has the lock and down before up_*()
releases it. Waiting is not counted, as the task does not hold the lock
yet. The killable, interruptible and trylock variants count only on
success. downgrade_write() keeps the lock held, so it needs no hook.

down_read_non_owner() and up_read_non_owner() can run in different
tasks, which a per-task count cannot follow. Both warn on a tracked
rwsem and neither counts. The warn is on both sides because the two are
not always paired with each other: bpf task_iter takes mm->mmap_lock
with mmap_read_lock_killable() and drops it with up_read_non_owner(),
so warning only on the acquire side would miss it. This matters only
with CONFIG_DEBUG_LOCK_ALLOC, as without it both are defined to plain
down_read() and up_read(), which are counted and balanced.

A lock must opt in before anyone takes it. A task already holding it was
not counted, so its up_*() would make its count wrong.
rwsem_track_holder() warns and does nothing if the rwsem is held, and
__init_rwsem() clears the flag with the rest of count.

The opt-in is bit 3 of ->count, which is reserved. It is sticky: unlike
the other flag bits it survives unlock, so a free tracked rwsem reads
RWSEM_FLAG_TRACKED rather than zero, and rwsem_is_locked() and
rwsem_assert_held_nolockdep() mask it off. Nothing else has to change,
because every other path either adds to count or writes back a value it
read, so the bit comes along.

PREEMPT_RT builds rw_semaphore on rt_mutex_base, which clears ->owner on
unlock, so a bit there would not survive. On 64-bit it has four bytes of
padding after ->wait_lock, so the flag goes there.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/rtmutex.h         | 11 ++++
 include/linux/rwsem.h           | 65 +++++++++++++++++++++-
 kernel/locking/rtmutex_common.h |  3 ++
 kernel/locking/rwsem.c          | 96 ++++++++++++++++++++++++++++++---
 4 files changed, 167 insertions(+), 8 deletions(-)

diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index 9e1f012f89db..3001a25705ac 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -22,6 +22,17 @@ extern int max_lock_depth;
 
 struct rt_mutex_base {
 	raw_spinlock_t		wait_lock;
+#if defined(CONFIG_TRACK_LOCK_HOLDERS) && defined(CONFIG_PREEMPT_RT)
+	/*
+	 * Opt-in to holder tracking, set before first use. On PREEMPT_RT
+	 * the sleeping locks that can be tracked are built on this one.
+	 * On 64-bit the flag fits in the padding after wait_lock, so none
+	 * of them grows. Where that padding does not exist, as on 32-bit,
+	 * everything built on rt_mutex_base grows by a word, spinlock_t
+	 * included.
+	 */
+	bool			tracked;
+#endif
 	struct rb_root_cached   waiters __guarded_by(&wait_lock);
 	struct task_struct	*owner  __guarded_by(&wait_lock);
 };
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 6a1a7bae5f81..fa4f999330ca 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -68,17 +68,30 @@ context_lock_struct(rw_semaphore) {
 
 #define RWSEM_UNLOCKED_VALUE		0UL
 #define RWSEM_WRITER_LOCKED		(1UL << 0)
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+/*
+ * Sticky: set by rwsem_track_holder(), cleared only by init. count bits
+ * 3-7 are reserved, and the lock and unlock paths only add to count or
+ * write back a value they read, so the bit survives. See
+ * kernel/locking/rwsem.c.
+ */
+#define RWSEM_FLAG_TRACKED		(1UL << 3)
+#else
+#define RWSEM_FLAG_TRACKED		0UL
+#endif
 #define __RWSEM_COUNT_INIT(name)	.count = ATOMIC_LONG_INIT(RWSEM_UNLOCKED_VALUE)
 
 static inline int rwsem_is_locked(struct rw_semaphore *sem)
 {
-	return atomic_long_read(&sem->count) != RWSEM_UNLOCKED_VALUE;
+	return (atomic_long_read(&sem->count) & ~RWSEM_FLAG_TRACKED) !=
+		RWSEM_UNLOCKED_VALUE;
 }
 
 static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
 	__assumes_ctx_lock(sem)
 {
-	WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
+	WARN_ON((atomic_long_read(&sem->count) & ~RWSEM_FLAG_TRACKED) ==
+		RWSEM_UNLOCKED_VALUE);
 }
 
 static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
@@ -87,6 +100,21 @@ static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *
 	WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
 }
 
+static inline bool rwsem_is_tracked(const struct rw_semaphore *sem)
+{
+	if (!IS_ENABLED(CONFIG_TRACK_LOCK_HOLDERS))
+		return false;
+
+	return atomic_long_read(&sem->count) & RWSEM_FLAG_TRACKED;
+}
+
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+static inline void __rwsem_set_tracked(struct rw_semaphore *sem)
+{
+	atomic_long_or(RWSEM_FLAG_TRACKED, &sem->count);
+}
+#endif
+
 /* Common initializer macros and functions */
 
 #ifdef CONFIG_DEBUG_RWSEMS
@@ -157,6 +185,23 @@ context_lock_struct(rw_semaphore) {
 #endif
 };
 
+/* The opt-in lives in the padding inside the rtmutex. */
+static inline bool rwsem_is_tracked(const struct rw_semaphore *sem)
+{
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+	return sem->rwbase.rtmutex.tracked;
+#else
+	return false;
+#endif
+}
+
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+static inline void __rwsem_set_tracked(struct rw_semaphore *sem)
+{
+	sem->rwbase.rtmutex.tracked = true;
+}
+#endif
+
 #define __RWSEM_INITIALIZER(name)				\
 	{							\
 		.rwbase = __RWBASE_INITIALIZER(name),		\
@@ -223,6 +268,22 @@ static inline void rwsem_assert_held_write(const struct rw_semaphore *sem)
 		rwsem_assert_held_write_nolockdep(sem);
 }
 
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+/**
+ * rwsem_track_holder - track the holders of an rw_semaphore
+ * @sem: initialized rw_semaphore that no one holds yet
+ *
+ * Count @sem in task_nr_tracked_locks() of the tasks holding it. Use it
+ * for locks whose holders can stall unrelated work. Call it before anyone
+ * can take @sem, e.g. right after init_rwsem(). Do not use
+ * down_read_non_owner() or up_read_non_owner() on a tracked rwsem: they
+ * can run in different tasks, which a per-task count cannot follow.
+ */
+void rwsem_track_holder(struct rw_semaphore *sem);
+#else
+static inline void rwsem_track_holder(struct rw_semaphore *sem) { }
+#endif
+
 /*
  * lock for reading
  */
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index c38b7bdea7b3..2228ac11910a 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -180,6 +180,9 @@ enum rtmutex_chainwalk {
 
 static inline void __rt_mutex_base_init(struct rt_mutex_base *lock)
 {
+#if defined(CONFIG_TRACK_LOCK_HOLDERS) && defined(CONFIG_PREEMPT_RT)
+	lock->tracked = false;
+#endif
 	scoped_guard (raw_spinlock_init, &lock->wait_lock) {
 		lock->waiters = RB_ROOT_CACHED;
 		lock->owner = NULL;
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index b9c180ac1eee..59e479a53f08 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -25,6 +25,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/clock.h>
 #include <linux/export.h>
+#include <linux/lockholder.h>
 #include <linux/rwsem.h>
 #include <linux/atomic.h>
 #include <linux/hung_task.h>
@@ -85,7 +86,8 @@
  * Bit  0    - writer locked bit
  * Bit  1    - waiters present bit
  * Bit  2    - lock handoff bit
- * Bits 3-7  - reserved
+ * Bit  3    - holder tracking opt-in (CONFIG_TRACK_LOCK_HOLDERS, sticky)
+ * Bits 4-7  - reserved
  * Bits 8-62 - 55-bit reader count
  * Bit  63   - read fail bit
  *
@@ -94,7 +96,8 @@
  * Bit  0    - writer locked bit
  * Bit  1    - waiters present bit
  * Bit  2    - lock handoff bit
- * Bits 3-7  - reserved
+ * Bit  3    - holder tracking opt-in (CONFIG_TRACK_LOCK_HOLDERS, sticky)
+ * Bits 4-7  - reserved
  * Bits 8-30 - 23-bit reader count
  * Bit  31   - read fail bit
  *
@@ -261,11 +264,39 @@ static inline bool rwsem_read_trylock(struct rw_semaphore *sem, long *cntp)
 	return false;
 }
 
+/*
+ * The opt-in flag as it sits in count, for the one path that folds it
+ * into a cmpxchg. The flag is only set once the static branch is on, so
+ * an off branch means no rwsem carries it and the read can be skipped.
+ */
+static inline long rwsem_tracked_flag(const struct rw_semaphore *sem)
+{
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+	if (!static_branch_unlikely(&lock_holder_tracking_key))
+		return 0;
+
+	return atomic_long_read(&sem->count) & RWSEM_FLAG_TRACKED;
+#else
+	return 0;
+#endif
+}
+
 static inline bool rwsem_write_trylock(struct rw_semaphore *sem)
 {
-	long tmp = RWSEM_UNLOCKED_VALUE;
+	/*
+	 * A free tracked rwsem reads RWSEM_FLAG_TRACKED, not 0, and the
+	 * flag has to survive the acquire, so both the expected and the
+	 * new value carry it. Reading it first costs one load but keeps
+	 * this to a single cmpxchg; the flag is sticky, so the read cannot
+	 * race. This is the only place the write side needs it: everywhere
+	 * else count is only added to, or written back from a value that
+	 * was read, so the flag survives.
+	 */
+	long flag = rwsem_tracked_flag(sem);
+	long tmp = flag;
 
-	if (atomic_long_try_cmpxchg_acquire(&sem->count, &tmp, RWSEM_WRITER_LOCKED)) {
+	if (atomic_long_try_cmpxchg_acquire(&sem->count, &tmp,
+					    flag | RWSEM_WRITER_LOCKED)) {
 		rwsem_set_owner(sem);
 		return true;
 	}
@@ -319,6 +350,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 #ifdef CONFIG_DEBUG_RWSEMS
 	sem->magic = sem;
 #endif
+	/* Clearing count also clears RWSEM_FLAG_TRACKED. */
 	atomic_long_set(&sem->count, RWSEM_UNLOCKED_VALUE);
 	atomic_long_set(&sem->owner, 0L);
 	scoped_guard (raw_spinlock_init, &sem->wait_lock) {
@@ -1488,6 +1520,7 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 void __init_rwsem(struct rw_semaphore *sem, const char *name,
 		  struct lock_class_key *key)
 {
+	/* init_rwbase_rt() also clears the holder tracking opt-in. */
 	init_rwbase_rt(&(sem)->rwbase);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -1564,6 +1597,35 @@ static inline bool is_rwsem_reader_owned(struct rw_semaphore *sem)
 
 #endif /* CONFIG_PREEMPT_RT */
 
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+void rwsem_track_holder(struct rw_semaphore *sem)
+{
+	/*
+	 * A task holding @sem now was not counted, so its up_*() would make
+	 * its count wrong.
+	 */
+	if (WARN_ONCE(rwsem_is_locked(sem),
+		      "%s: rwsem is held; opt in before it is published\n",
+		      __func__))
+		return;
+
+	/*
+	 * Turn the hooks on before the flag, so that a lock carrying the
+	 * flag always has them on.
+	 */
+	lock_holder_tracking_enable();
+	__rwsem_set_tracked(sem);
+}
+EXPORT_SYMBOL_GPL(rwsem_track_holder);
+#endif
+
+/*
+ * Holder tracking: the count goes up once down_*() has the lock and down
+ * before up_*() releases it. Waiting is not counted, as the task does not
+ * hold the lock yet. downgrade_write() keeps the lock held, so it needs no
+ * hook.
+ */
+
 /*
  * lock for reading
  */
@@ -1574,6 +1636,7 @@ void __sched down_read(struct rw_semaphore *sem)
 	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
+	lock_holder_acquired_if(rwsem_is_tracked(sem));
 }
 EXPORT_SYMBOL(down_read);
 
@@ -1588,6 +1651,7 @@ int __sched down_read_interruptible(struct rw_semaphore *sem)
 		return -EINTR;
 	}
 
+	lock_holder_acquired_if(rwsem_is_tracked(sem));
 	return 0;
 }
 EXPORT_SYMBOL(down_read_interruptible);
@@ -1603,6 +1667,7 @@ int __sched down_read_killable(struct rw_semaphore *sem)
 		return -EINTR;
 	}
 
+	lock_holder_acquired_if(rwsem_is_tracked(sem));
 	return 0;
 }
 EXPORT_SYMBOL(down_read_killable);
@@ -1615,8 +1680,10 @@ int down_read_trylock(struct rw_semaphore *sem)
 {
 	int ret = __down_read_trylock(sem);
 
-	if (ret == 1)
+	if (ret == 1) {
 		rwsem_acquire_read(&sem->dep_map, 0, 1, _RET_IP_);
+		lock_holder_acquired_if(rwsem_is_tracked(sem));
+	}
 	return ret;
 }
 EXPORT_SYMBOL(down_read_trylock);
@@ -1630,6 +1697,7 @@ void __sched down_write(struct rw_semaphore *sem)
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	lock_holder_acquired_if(rwsem_is_tracked(sem));
 }
 EXPORT_SYMBOL(down_write);
 
@@ -1648,6 +1716,7 @@ int __sched down_write_killable(struct rw_semaphore *sem)
 		return -EINTR;
 	}
 
+	lock_holder_acquired_if(rwsem_is_tracked(sem));
 	return 0;
 }
 EXPORT_SYMBOL(down_write_killable);
@@ -1660,8 +1729,10 @@ int down_write_trylock(struct rw_semaphore *sem)
 {
 	int ret = __down_write_trylock(sem);
 
-	if (ret == 1)
+	if (ret == 1) {
 		rwsem_acquire(&sem->dep_map, 0, 1, _RET_IP_);
+		lock_holder_acquired_if(rwsem_is_tracked(sem));
+	}
 
 	return ret;
 }
@@ -1673,6 +1744,7 @@ EXPORT_SYMBOL(down_write_trylock);
 void up_read(struct rw_semaphore *sem)
 	__no_context_analysis
 {
+	lock_holder_released_if(rwsem_is_tracked(sem));
 	rwsem_release(&sem->dep_map, _RET_IP_);
 	__up_read(sem);
 }
@@ -1684,6 +1756,7 @@ EXPORT_SYMBOL(up_read);
 void up_write(struct rw_semaphore *sem)
 	__no_context_analysis
 {
+	lock_holder_released_if(rwsem_is_tracked(sem));
 	rwsem_release(&sem->dep_map, _RET_IP_);
 	__up_write(sem);
 }
@@ -1708,6 +1781,7 @@ void down_read_nested(struct rw_semaphore *sem, int subclass)
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, subclass, 0, _RET_IP_);
 	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
+	lock_holder_acquired_if(rwsem_is_tracked(sem));
 }
 EXPORT_SYMBOL(down_read_nested);
 
@@ -1722,6 +1796,7 @@ int down_read_killable_nested(struct rw_semaphore *sem, int subclass)
 		return -EINTR;
 	}
 
+	lock_holder_acquired_if(rwsem_is_tracked(sem));
 	return 0;
 }
 EXPORT_SYMBOL(down_read_killable_nested);
@@ -1732,13 +1807,19 @@ void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest)
 	might_sleep();
 	rwsem_acquire_nest(&sem->dep_map, 0, 0, nest, _RET_IP_);
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	lock_holder_acquired_if(rwsem_is_tracked(sem));
 }
 EXPORT_SYMBOL(_down_write_nest_lock);
 
+/*
+ * The non_owner calls can run in different tasks, which a per-task count
+ * cannot follow, so tracked rwsems must not use them.
+ */
 void down_read_non_owner(struct rw_semaphore *sem)
 	__no_context_analysis
 {
 	might_sleep();
+	WARN_ON_ONCE(rwsem_is_tracked(sem));
 	__down_read(sem);
 	/*
 	 * The owner value for a reader-owned lock is mostly for debugging
@@ -1756,6 +1837,7 @@ void down_write_nested(struct rw_semaphore *sem, int subclass)
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	lock_holder_acquired_if(rwsem_is_tracked(sem));
 }
 EXPORT_SYMBOL(down_write_nested);
 
@@ -1771,6 +1853,7 @@ int __sched down_write_killable_nested(struct rw_semaphore *sem, int subclass)
 		return -EINTR;
 	}
 
+	lock_holder_acquired_if(rwsem_is_tracked(sem));
 	return 0;
 }
 EXPORT_SYMBOL(down_write_killable_nested);
@@ -1779,6 +1862,7 @@ void up_read_non_owner(struct rw_semaphore *sem)
 	__no_context_analysis
 {
 	DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
+	WARN_ON_ONCE(rwsem_is_tracked(sem));
 	__up_read(sem);
 }
 EXPORT_SYMBOL(up_read_non_owner);
-- 
2.53.0-Meta

