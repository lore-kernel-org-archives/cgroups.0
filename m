Received: from mta1.migadu.com (out-148.mta1.migadu.com [95.215.58.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F64A64EF
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 15:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265062; cv=none; b=Jaia9llsfD0G/eWoJEEiAYCO2qZhxq8I3ayXSwnHHtoz7WFNBSSPNxgAPSxnyMYDV8dJjhiQaQ66zPO6cnpSPA9Ht95AKWz6ViA55qPSDXyA+8tdIwhHhoNGKxUr/4m678Bcp907B5C19V0jEPvGJj+an2A4hZszZigKfPYhxpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265062; c=relaxed/simple;
	bh=fY0M/nvwSqFu2VO+4chH0AAhbw1JI0Dvh901qmDdq38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TD8xrrBDlRZV3lc/u/Wq9ZPHnKWDoTfT0D+csiFhEM1/vOBebehYCVEbOGTNreK35ZLRtZC0jARviQ7eOCToyAMVGjkmUrhOPnsUAtOz8pdhs0MrC/fYeo8BfqiGBNC9uFseQUsg3Zg+UWBFs8rjh2J39NVXubeOhZGvc0FEPFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ieidb80v; arc=none smtp.client-ip=95.215.58.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ieidb80v"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fY0M/nvwSqFu2VO+4chH0AAhbw1JI0Dvh901qmDdq38=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790265058; v=1; x=1790869858;
 b=Ieidb80vPgf5GlJOhjaUE9+vMdXFjQTUHfslVU4HcW+G1n+2EMwBnnjsuZl2qQjvpUSDSWzl
 9ODollNtJBuovOdgO/6ugbw2g/5DGdh8lHimmjE2DKrljEqZ4o8wI33iGyrNQ7wWe2Tu83c+QpO
 8i8F15Hd69PRpKeUAtSeUWbc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1b80499ef56cc112;
	Thu, 24 Sep 2026 15:50:57 +0000
X-Mizu-Trace-ID: 1b80499ef56cc112
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
Subject: [PATCH RESEND 3/7] locking/mutex: track holders of opted-in mutexes
Date: Thu, 24 Sep 2026 08:50:21 -0700
Message-ID: <20260924155025.949998-4-shakeel.butt@linux.dev>
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

Add mutex_track_holder() to opt a mutex in to holder tracking.

On !PREEMPT_RT, current takes a mutex only in __mutex_trylock_common()
and __mutex_trylock_fast(), and releases it only in
__mutex_unlock_fast() and __mutex_unlock_slowpath(). Hooking these four
places covers every mutex_lock*(), mutex_trylock(), ww_mutex_lock*() and
handoff. __mutex_unlock_fast() drops the count after the release, which
needs no care: the count is in current, not in the mutex.

On PREEMPT_RT, the hooks are in __mutex_lock_common(), mutex_trylock(),
_mutex_trylock_nest_lock() and mutex_unlock() in rtmutex_api.c. There,
ww_mutex is an rt_mutex and is not covered. mutex_track_holder() itself
is shared by both builds.

As with rwsem, mutex_track_holder() warns and does nothing if the mutex
is held, and mutex_init() clears the flag with the rest of ->owner.

The opt-in is bit 3 of ->owner, which is below the alignment of a
task_struct pointer. It is sticky: unlike the other flag bits it
survives unlock, so a free tracked mutex reads MUTEX_FLAG_TRACKED rather
than zero.

Bit 3 needs a task_struct aligned to 16 rather than the 8 that bits 0-2
needed. fork_init() aligns to at least L1_CACHE_BYTES, whose smallest
value in the tree is 16, so a static_assert() records the requirement.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/mutex.h        | 14 +++++++
 kernel/locking/mutex.c       | 79 ++++++++++++++++++++++++++++++++----
 kernel/locking/mutex.h       | 48 +++++++++++++++++++++-
 kernel/locking/rtmutex_api.c | 36 ++++++++++++++--
 4 files changed, 165 insertions(+), 12 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 734048c02f4f..74f54ee83685 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -75,6 +75,20 @@ do {									\
  */
 #define mutex_init_with_key(mutex, key) __mutex_init((mutex), #mutex, (key))
 
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+/**
+ * mutex_track_holder - track the holder of a mutex
+ * @lock: initialized mutex that no one holds yet
+ *
+ * Count @lock in task_nr_tracked_locks() of the task holding it. Use it
+ * for locks whose holders can stall unrelated work. Call it before anyone
+ * can take @lock, e.g. right after mutex_init().
+ */
+void mutex_track_holder(struct mutex *lock);
+#else
+static inline void mutex_track_holder(struct mutex *lock) { }
+#endif
+
 #ifndef CONFIG_PREEMPT_RT
 #define __MUTEX_INITIALIZER(lockname) \
 		{ .owner = ATOMIC_LONG_INIT(0) \
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 942a939cee95..d4b5a3674e39 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -28,6 +28,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
+#include <linux/lockholder.h>
 #include <linux/osq_lock.h>
 #include <linux/hung_task.h>
 
@@ -45,6 +46,7 @@
 
 static void __mutex_init_generic(struct mutex *lock)
 {
+	/* Clearing owner also clears MUTEX_FLAG_TRACKED. */
 	atomic_long_set(&lock->owner, 0);
 	scoped_guard (raw_spinlock_init, &lock->wait_lock) {
 		lock->first_waiter = NULL;
@@ -81,6 +83,9 @@ unsigned long mutex_get_owner(struct mutex *lock)
 
 /*
  * Returns: __mutex_owner(lock) on failure or NULL on success.
+ *
+ * Only this and __mutex_trylock_fast() take the lock for current, so the
+ * holder count goes up in these two.
  */
 static inline struct task_struct *__mutex_trylock_common(struct mutex *lock, bool handoff)
 {
@@ -109,8 +114,10 @@ static inline struct task_struct *__mutex_trylock_common(struct mutex *lock, boo
 		}
 
 		if (atomic_long_try_cmpxchg_acquire(&lock->owner, &owner, task | flags)) {
-			if (task == curr)
+			if (task == curr) {
+				lock_holder_acquired_if(flags & MUTEX_FLAG_TRACKED);
 				return NULL;
+			}
 			break;
 		}
 	}
@@ -154,12 +161,28 @@ static __always_inline bool __mutex_trylock_fast(struct mutex *lock)
 	__cond_acquires(true, lock)
 {
 	unsigned long curr = (unsigned long)current;
-	unsigned long zero = 0UL;
+	/*
+	 * A free tracked mutex reads MUTEX_FLAG_TRACKED, not 0, and the
+	 * flag has to survive the acquire, so both the expected and the
+	 * new value carry it. Reading it first keeps this to a single
+	 * cmpxchg, and the read cannot race because the flag is sticky.
+	 */
+	unsigned long flag = mutex_tracked_flag(lock);
+	unsigned long expected = flag;
 
 	MUTEX_WARN_ON(lock->magic != lock);
 
-	if (atomic_long_try_cmpxchg_acquire(&lock->owner, &zero, curr))
+	if (atomic_long_try_cmpxchg_acquire(&lock->owner, &expected, curr | flag)) {
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+		/*
+		 * The flag is only set once the static branch is on, so a
+		 * set flag means tracking is enabled.
+		 */
+		if (flag)
+			__lock_holder_acquired();
+#endif
 		return true;
+	}
 
 	return false;
 }
@@ -168,8 +191,23 @@ static __always_inline bool __mutex_unlock_fast(struct mutex *lock)
 	__cond_releases(true, lock)
 {
 	unsigned long curr = (unsigned long)current;
+	/*
+	 * A tracked mutex unlocks to MUTEX_FLAG_TRACKED, not to 0. Read the
+	 * flag while the mutex is still held, so this needs only a single
+	 * cmpxchg and never looks at @lock after giving it away.
+	 */
+	unsigned long flag = mutex_tracked_flag(lock);
+	unsigned long owner = curr | flag;
+
+	if (atomic_long_try_cmpxchg_release(&lock->owner, &owner, flag)) {
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+		if (flag)
+			__lock_holder_released();
+#endif
+		return true;
+	}
 
-	return atomic_long_try_cmpxchg_release(&lock->owner, &curr, 0UL);
+	return false;
 }
 
 #else /* !CONFIG_DEBUG_LOCK_ALLOC */
@@ -242,7 +280,7 @@ __mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter)
 	__must_hold(&lock->wait_lock)
 {
 	if (list_empty(&waiter->list)) {
-		__mutex_clear_flag(lock, MUTEX_FLAGS);
+		__mutex_clear_flag(lock, MUTEX_STATE_FLAGS);
 		lock->first_waiter = NULL;
 	} else {
 		if (lock->first_waiter == waiter)
@@ -257,7 +295,7 @@ __mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter)
 /*
  * Give up ownership to a specific task, when @task = NULL, this is equivalent
  * to a regular unlock. Sets PICKUP on a handoff, clears HANDOFF, preserves
- * WAITERS. Provides RELEASE semantics like a regular unlock, the
+ * WAITERS and TRACKED. Provides RELEASE semantics like a regular unlock, the
  * __mutex_trylock() provides a matching ACQUIRE semantics for the handoff.
  */
 static void __mutex_handoff(struct mutex *lock, struct task_struct *task)
@@ -270,7 +308,7 @@ static void __mutex_handoff(struct mutex *lock, struct task_struct *task)
 		MUTEX_WARN_ON(__owner_task(owner) != current);
 		MUTEX_WARN_ON(owner & MUTEX_FLAG_PICKUP);
 
-		new = (owner & MUTEX_FLAG_WAITERS);
+		new = (owner & (MUTEX_FLAG_WAITERS | MUTEX_FLAG_TRACKED));
 		new |= (unsigned long)task;
 		if (task)
 			new |= MUTEX_FLAG_PICKUP;
@@ -986,6 +1024,7 @@ static noinline void __sched __mutex_unlock_slowpath(struct mutex *lock, unsigne
 	unsigned long owner;
 	unsigned long flags;
 
+	lock_holder_released_if(mutex_is_tracked(lock));
 	mutex_release(&lock->dep_map, ip);
 	__release(lock);
 
@@ -1276,6 +1315,32 @@ __weak int arch_contended_release_trace_reg(void) { return 0; }
 
 __weak void arch_contended_release_trace_unreg(void) { }
 
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+void mutex_track_holder(struct mutex *lock)
+{
+	/*
+	 * A task holding @lock now was not counted, so its mutex_unlock()
+	 * would make its count wrong.
+	 */
+	if (WARN_ONCE(mutex_is_locked(lock),
+		      "%s: mutex is held; opt in before it is published\n",
+		      __func__))
+		return;
+
+	/*
+	 * Turn the hooks on before the flag, so that a lock carrying the
+	 * flag always has them on.
+	 */
+	lock_holder_tracking_enable();
+#ifdef CONFIG_PREEMPT_RT
+	lock->rtmutex.tracked = true;
+#else
+	atomic_long_or(MUTEX_FLAG_TRACKED, &lock->owner);
+#endif
+}
+EXPORT_SYMBOL_GPL(mutex_track_holder);
+#endif
+
 /**
  * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
  * @cnt: the atomic which we are to dec
diff --git a/kernel/locking/mutex.h b/kernel/locking/mutex.h
index 3e263e98e5fc..833f084d5bb0 100644
--- a/kernel/locking/mutex.h
+++ b/kernel/locking/mutex.h
@@ -7,6 +7,7 @@
  *  Copyright (C) 2004, 2005, 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  */
 #ifndef CONFIG_PREEMPT_RT
+#include <linux/lockholder.h>
 #include <linux/mutex.h>
 /*
  * This is the control structure for tasks blocked on mutex, which resides
@@ -29,12 +30,32 @@ struct mutex_waiter {
  * Bit0 indicates a non-empty waiter list; unlock must issue a wakeup.
  * Bit1 indicates unlock needs to hand the lock to the top-waiter
  * Bit2 indicates handoff has been done and we're waiting for pickup.
+ * Bit3 indicates the lock opted in to holder tracking. Unlike the others
+ * it is sticky: it survives unlock, so an unlocked tracked mutex reads
+ * MUTEX_FLAG_TRACKED rather than 0.
  */
 #define MUTEX_FLAG_WAITERS	0x01
 #define MUTEX_FLAG_HANDOFF	0x02
 #define MUTEX_FLAG_PICKUP	0x04
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+#define MUTEX_FLAG_TRACKED	0x08
+#else
+#define MUTEX_FLAG_TRACKED	0x00
+#endif
+
+/* The state flags, which unlock clears. */
+#define MUTEX_STATE_FLAGS	(MUTEX_FLAG_WAITERS | MUTEX_FLAG_HANDOFF | \
+				 MUTEX_FLAG_PICKUP)
+#define MUTEX_FLAGS		(MUTEX_STATE_FLAGS | MUTEX_FLAG_TRACKED)
 
-#define MUTEX_FLAGS		0x07
+/*
+ * The flags live below the task_struct pointer in ->owner, so every
+ * task_struct has to be aligned past them. Bits 0-2 needed 8 bytes;
+ * MUTEX_FLAG_TRACKED needs 16. fork_init() aligns task_struct to at
+ * least L1_CACHE_BYTES and init_task is __aligned(L1_CACHE_BYTES), so
+ * that is the value to check; its smallest value in the tree is 16.
+ */
+static_assert(L1_CACHE_BYTES > MUTEX_FLAGS);
 
 /*
  * Internal helper function; C doesn't allow us to hide it :/
@@ -48,6 +69,31 @@ static inline struct task_struct *__mutex_owner(struct mutex *lock)
 	return (struct task_struct *)(atomic_long_read(&lock->owner) & ~MUTEX_FLAGS);
 }
 
+static inline bool mutex_is_tracked(struct mutex *lock)
+{
+	if (!IS_ENABLED(CONFIG_TRACK_LOCK_HOLDERS))
+		return false;
+
+	return atomic_long_read(&lock->owner) & MUTEX_FLAG_TRACKED;
+}
+
+/*
+ * The opt-in flag as it sits in owner, for the fast paths that fold it
+ * into a cmpxchg. The flag is only set once the static branch is on, so
+ * an off branch means no mutex carries it and the read can be skipped.
+ */
+static inline unsigned long mutex_tracked_flag(struct mutex *lock)
+{
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+	if (!static_branch_unlikely(&lock_holder_tracking_key))
+		return 0;
+
+	return atomic_long_read(&lock->owner) & MUTEX_FLAG_TRACKED;
+#else
+	return 0;
+#endif
+}
+
 static inline struct mutex *get_task_blocked_on(struct task_struct *p)
 {
 	guard(raw_spinlock_irqsave)(&p->blocked_lock);
diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
index eb18b094473c..41ca3c1d92f6 100644
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -2,6 +2,7 @@
 /*
  * rtmutex API
  */
+#include <linux/lockholder.h>
 #include <linux/spinlock.h>
 #include <linux/export.h>
 
@@ -544,10 +545,26 @@ void rt_mutex_debug_task_free(struct task_struct *task)
 /* Mutexes */
 static void __mutex_rt_init_generic(struct mutex *mutex)
 {
+	/* rt_mutex_base_init() also clears the holder tracking opt-in. */
 	rt_mutex_base_init(&mutex->rtmutex);
 	debug_check_no_locks_freed((void *)mutex, sizeof(*mutex));
 }
 
+/*
+ * mutex_track_holder() is in mutex.c, shared with !PREEMPT_RT. Here the
+ * opt-in is a flag in the padding inside the rtmutex, not a bit of
+ * ->owner: rt_mutex clears ->owner on unlock, so a bit there would not
+ * survive.
+ */
+static inline bool mutex_is_tracked(struct mutex *lock)
+{
+#ifdef CONFIG_TRACK_LOCK_HOLDERS
+	return lock->rtmutex.tracked;
+#else
+	return false;
+#endif
+}
+
 static __always_inline int __mutex_lock_common(struct mutex *lock,
 					       unsigned int state,
 					       unsigned int subclass,
@@ -560,10 +577,12 @@ static __always_inline int __mutex_lock_common(struct mutex *lock,
 	might_sleep();
 	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
 	ret = __rt_mutex_lock(&lock->rtmutex, state);
-	if (ret)
+	if (ret) {
 		mutex_release(&lock->dep_map, ip);
-	else
+	} else {
 		lock_acquired(&lock->dep_map, ip);
+		lock_holder_acquired_if(mutex_is_tracked(lock));
+	}
 	return ret;
 }
 
@@ -623,8 +642,10 @@ int __sched _mutex_trylock_nest_lock(struct mutex *lock,
 		return 0;
 
 	ret = __rt_mutex_trylock(&lock->rtmutex);
-	if (ret)
+	if (ret) {
 		mutex_acquire_nest(&lock->dep_map, 0, 1, nest_lock, _RET_IP_);
+		lock_holder_acquired_if(mutex_is_tracked(lock));
+	}
 
 	return ret;
 }
@@ -666,10 +687,16 @@ EXPORT_SYMBOL(mutex_lock_io);
 
 int __sched mutex_trylock(struct mutex *lock)
 {
+	int ret;
+
 	if (IS_ENABLED(CONFIG_DEBUG_RT_MUTEXES) && WARN_ON_ONCE(!in_task()))
 		return 0;
 
-	return __rt_mutex_trylock(&lock->rtmutex);
+	ret = __rt_mutex_trylock(&lock->rtmutex);
+	if (ret)
+		lock_holder_acquired_if(mutex_is_tracked(lock));
+
+	return ret;
 }
 EXPORT_SYMBOL(mutex_trylock);
 #endif /* !CONFIG_DEBUG_LOCK_ALLOC */
@@ -677,6 +704,7 @@ EXPORT_SYMBOL(mutex_trylock);
 void __sched mutex_unlock(struct mutex *lock)
 	__releases(lock) __no_context_analysis
 {
+	lock_holder_released_if(mutex_is_tracked(lock));
 	mutex_release(&lock->dep_map, _RET_IP_);
 	__rt_mutex_unlock(&lock->rtmutex);
 }
-- 
2.53.0-Meta

