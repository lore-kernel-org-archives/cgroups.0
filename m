Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4932372B57
	for <cgroups@vger.kernel.org>; Mon,  5 Oct 2026 07:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791183999; cv=none; b=gPfii89a4phiHwje+rll/OaRcjLAgWzS5WgcNA/R9o/x3k9us3pOiUQ3hxbNCHEOPU2qMpOWs4y5c5JvHUO9flefhET3ytm29m8BdQkH05t0naEVEqPdXgeVNT2nV+f74ld/vWfzo6BoabY58MyTBkKU5fZYcTyA/WCDjXMsZjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791183999; c=relaxed/simple;
	bh=6M4HGbS+p7lOb6XrrGjaP2sdMucXjqa41a2994VHXaU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jqSHpk6H+XByAS9keFVFkGwHmYrAlfvx3OXxXXbf97A08VH8sXnCeQVXyFpklV/sibi0wfssLT+veexRNuO3ZfW1btYVVDrEqGNBw/p9osO6gcaSnq85I43utf8GXsW/YC/Nt1v4s1lg6yS9MCxnJOFYaBZcRaaJocDH9eJ3Xu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oLN8Lv7H; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oLN8Lv7H"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a1626d6a6cso7998895e9.0
        for <cgroups@vger.kernel.org>; Mon, 05 Oct 2026 00:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791183995; x=1791788795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xMdSKwu9/ElFEdH/LD1A0vG0lduxhS11tDoBv8deiFQ=;
        b=oLN8Lv7H/DXTaaUEB5k21VdTStuwG4oWGs2qBRxCp0atg+bO/MLkz4YZzjb8Ot57Df
         IcnPLB8rU5VMssUQUUsxDVqOvDFartxEv8kY6lruibrgXjVKA2Z3s84ZFdLwBhQlPBvP
         tiDijOqFI/L3tDRv1Hy5kb31U2OVkiP5pGw0aVQmttrUNG6+lW5iqXRFS1nOW5A3jkR2
         cUz8S5oV+IdZaX4I9GeAC+aG3QX3XHaqidjWBLdHCH9OBF1jVzTp+GlxuZTSNeSkHBBN
         0N8f/XBtpQQSPGr0M8x9keWt+7/s597K+4ykBhhn5zlliZWqipvp0M51cPQ/bBNC7/Qc
         41GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791183995; x=1791788795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xMdSKwu9/ElFEdH/LD1A0vG0lduxhS11tDoBv8deiFQ=;
        b=JEoF3jI0m2o696bhvfQYljQSTJg72uCFnN+S7qQnLKNdn+HydN82jPA9iiwzBoNueH
         XbVzJyc3n9mSwC70JEv0VX4+il4qgSelylql2YzYO1xzbZx9yGX/qDOrNiSDXU+pLMeH
         vmegso3EIimMgXChRIH5oBcw/jhBDRSfDYb+SS4JvubrPxX+owY5EEID+ydMkIvdHZcl
         XDMBNx45AwZPO+TFYgOUr+SwOnY+cRzBCRww96DfVry9FS8I6HevC0gEb473TRygBARV
         Kwp9afwiGyMw8LlMFYwSFxVT1gUSZd09lwBhP3fpqm1Q8zggRuQpO3DWE05WWKJB9vK8
         6iEg==
X-Forwarded-Encrypted: i=1; AKwUvBw83clvmMdW8rP6eF4UEdUzV48CS4uMCF2SFaJork87sXwcQ8ijdSXCFTHtcm4rAkf+WemuQ5Fq@vger.kernel.org
X-Gm-Message-State: AFuF++l9rhXtMa5r00imyKzTMRZkFEllhyT4RlTa7M7HKGUbSOm78XaF
	jhKNxiKPf7/RrjWTPJJEtmoViyxjbd/qINk1216PssZxmh1amXUaebIE
X-Gm-Gg: AYBFou05K2SxKTQ+JtNIJzSbs/zDcXiqWDPbABcKCUsba6cGBiAXhGPeUZA2yV9/CGN
	4TbmBPPgiFkR7DEW7sjuP36W11JG/k1KZwBICWHn1/2B9ZHjwWT/ZHvaweBg5uOfwcTkBWaCe5A
	gdf0PjaKCSty/36TB8G1FQ9gSGLMUPESAjJaYLO586Gr2d+FyyXI2Hd4GZQbBgqIqCocB+8qYx6
	/aECU6/mPa1e+jisYZUrTZZ9W8Bfx3XN7JJXoQ7tKc7siTQgtroJQPvDiafAqeS7KTfg8eOY3da
	dXd0+mNcNbrGyIYWoQLU9cza/EjMFsP85Jml0phY6lP8hHESmR+P76PegmOMV5lyG1C5SDMa8R6
	ZY5F1BC8ycC0qLSvDzcnMlYgNJvN19061kFDjbhy/Xk3Wv2FRNffyAJx2u7QF+tWUaEnzba1CZM
	m/TbE6LW3L8kjVM2AKUfNpXb9FKhKRlAXPFV3StabCgdykpgSX3doew5SGdnPkxYz3z3jZArwVJ
	lKyOrlVzLd4UxuOr2TUr+TV4uXwErwIwM8mjA6JvrHRG0UEHTD18YQxlGRB9PpAKnAFI4IBxHm3
	qgO17sRmIzogIQ1N67Wx09Ybo15Ifib4Z+fj7OwhQ1R/C+3u8gRV1MtCwEPeCscHU5O22S62sHn
	q/Q==
X-Received: by 2002:a05:600c:c108:b0:49d:174e:2a1e with SMTP id 5b1f17b1804b1-4a1680f7421mr72735665e9.19.1791183994787;
        Mon, 05 Oct 2026 00:06:34 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b305-2001-39fa-3d24-821a-4eae.310.pool.telefonica.de. [2a02:3100:b305:2001:39fa:3d24:821a:4eae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a16bcb9a21sm283461465e9.10.2026.10.05.00.06.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 05 Oct 2026 00:06:34 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Stevens <stevensd@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 1/3] locking/rtmutex: Support atomic PREEMPT_RT spin trylocks
Date: Mon,  5 Oct 2026 09:06:23 +0200
Message-Id: <20261005070625.8871-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261005070625.8871-1-kmehltretter@gmail.com>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No-lock allocation may run with preemption disabled or while a raw lock is
held.  On PREEMPT_RT, allocator spinlocks are backed by rtmutexes.  A
successful spin_trylock() can therefore enter priority inheritance or
wakeup code when the lock is released, which is not safe for these callers.

Add spin_trylock_nolock_irqsave() for bounded sections which cannot enter
the rtmutex slow path.  Preemptible callers retain the regular RT trylock.
For a non-preemptible caller, acquire only an uncontended lock, mark the
owner as atomic, and keep preemption and local interrupts disabled until
release.

A regular waiter sets HAS_WAITERS before waiting for an atomic owner.  This
prevents another atomic owner from barging ahead.  The atomic owner
releases to NULL | HAS_WAITERS without entering priority inheritance or
waking a task.  Disabling interrupts while the atomic owner holds the lock
also prevents a waiter from spinning through hardirq work on the owner's
CPU.

The protected section must not block and must remain bounded because a
regular waiter spins with interrupts disabled and cannot boost an atomic
owner.  Document that a successful acquisition must be released with
spin_unlock_irqrestore(), and keep the MM-only entry point unexported.

Pass the real unlock call site to lockdep for both regular and irqrestore
unlocks.  Also make the debug slow unlock publish the free state with
cmpxchg after dropping wait_lock, so an atomic owner cannot reuse an
embedded lock before the old unlock has finished with it.  Use the same
slow-unlock helper in debug and non-debug builds.

Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 Documentation/locking/rt-mutex.rst |  40 ++++--
 include/linux/rtmutex.h            |   4 +-
 include/linux/spinlock.h           |   3 +
 include/linux/spinlock_rt.h        |  28 +++-
 kernel/locking/rtmutex.c           | 211 +++++++++++++++++------------
 kernel/locking/spinlock_rt.c       |  66 ++++++++-
 6 files changed, 239 insertions(+), 113 deletions(-)

diff --git a/Documentation/locking/rt-mutex.rst b/Documentation/locking/rt-mutex.rst
index 3b5097a380e6..53011c917710 100644
--- a/Documentation/locking/rt-mutex.rst
+++ b/Documentation/locking/rt-mutex.rst
@@ -46,21 +46,26 @@ is used]
 The state of the rt-mutex is tracked via the owner field of the rt-mutex
 structure:
 
-lock->owner holds the task_struct pointer of the owner. Bit 0 is used to
-keep track of the "lock has waiters" state:
-
- ============ ======= ================================================
- owner        bit0    Notes
- ============ ======= ================================================
- NULL         0       lock is free (fast acquire possible)
- NULL         1       lock is free and has waiters and the top waiter
-		      is going to take the lock [1]_
- taskpointer  0       lock is held (fast release possible)
- taskpointer  1       lock is held and has waiters [2]_
- ============ ======= ================================================
-
-The fast atomic compare exchange based acquire and release is only
-possible when bit 0 of lock->owner is 0.
+lock->owner holds the task_struct pointer of the owner. Bit 0 tracks the
+"lock has waiters" state. Bit 1 marks an atomic owner used by PREEMPT_RT
+spinlock trylocks whose callers cannot enter the priority inheritance or
+wakeup paths:
+
+ ============ ======= ======= ================================================
+ owner        bit1    bit0    Notes
+ ============ ======= ======= ================================================
+ NULL         0       0       lock is free (fast acquire possible)
+ NULL         0       1       lock is free and has waiters and the top waiter
+			      is going to take the lock [1]_
+ taskpointer  0       0       lock is held (fast release possible)
+ taskpointer  0       1       lock is held and has waiters [2]_
+ taskpointer  1       0       lock is held by an atomic owner
+ taskpointer  1       1       lock is held by an atomic owner while a slow
+			      path excludes new atomic owners [3]_
+ ============ ======= ======= ================================================
+
+The regular fast atomic compare exchange based acquire and release is only
+possible when both flag bits of lock->owner are clear.
 
 .. [1] It also can be a transitional state when grabbing the lock
        with ->wait_lock is held. To prevent any fast path cmpxchg to the lock,
@@ -72,6 +77,11 @@ possible when bit 0 of lock->owner is 0.
        To prevent a cmpxchg of the owner releasing the lock, we need to
        set this bit before looking at the lock.
 
+.. [3] The slow path sets bit 0 before waiting for the atomic owner. The
+       atomic owner then releases to ``NULL | HAS_WAITERS`` without entering
+       priority inheritance or wakeup handling. This lets the slow path take
+       the lock and prevents another atomic owner from barging ahead of it.
+
 BTW, there is still technically a "Pending Owner", it's just not called
 that anymore. The pending owner happens to be the top_waiter of a lock
 that has no owner and has been woken up to grab the lock.
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index 9e1f012f89db..e889a6d1d0be 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -46,12 +46,14 @@ static inline bool rt_mutex_base_is_locked(struct rt_mutex_base *lock)
 
 #ifdef CONFIG_RT_MUTEXES
 #define RT_MUTEX_HAS_WAITERS	1UL
+#define RT_MUTEX_OWNER_ATOMIC	2UL
+#define RT_MUTEX_OWNER_MASK	(RT_MUTEX_HAS_WAITERS | RT_MUTEX_OWNER_ATOMIC)
 
 static inline struct task_struct *rt_mutex_owner(struct rt_mutex_base *lock)
 {
 	unsigned long owner = (unsigned long) data_race(READ_ONCE(lock->owner));
 
-	return (struct task_struct *) (owner & ~RT_MUTEX_HAS_WAITERS);
+	return (struct task_struct *)(owner & ~RT_MUTEX_OWNER_MASK);
 }
 #endif
 extern void rt_mutex_base_init(struct rt_mutex_base *rtb);
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 3d405cc4c121..e1f4804efce5 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -444,6 +444,9 @@ static __always_inline bool _spin_trylock_irqsave(spinlock_t *lock, unsigned lon
 }
 #define spin_trylock_irqsave(lock, flags) _spin_trylock_irqsave(lock, &(flags))
 
+#define spin_trylock_nolock_irqsave(lock, flags) \
+	spin_trylock_irqsave(lock, flags)
+
 static __always_inline int spin_trylock_irq_disable(spinlock_t *lock)
 	__cond_acquires(true, lock) __no_context_analysis
 {
diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index 560d06384e0c..b913b8b57b04 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -35,9 +35,14 @@ extern void rt_spin_lock(spinlock_t *lock) __acquires(lock);
 extern void rt_spin_lock_nested(spinlock_t *lock, int subclass)	__acquires(lock);
 extern void rt_spin_lock_nest_lock(spinlock_t *lock, struct lockdep_map *nest_lock) __acquires(lock);
 extern void rt_spin_unlock(spinlock_t *lock)	__releases(lock);
+extern void rt_spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
+	__releases(lock);
 extern void rt_spin_lock_unlock(spinlock_t *lock);
 extern int rt_spin_trylock_bh(spinlock_t *lock) __cond_acquires(true, lock);
 extern int rt_spin_trylock(spinlock_t *lock) __cond_acquires(true, lock);
+extern int rt_spin_trylock_nolock_irqsave(spinlock_t *lock,
+					  unsigned long *flags)
+	__cond_acquires(true, lock);
 
 static __always_inline void spin_lock(spinlock_t *lock)
 	__acquires(lock)
@@ -138,7 +143,7 @@ static __always_inline void spin_unlock_irqrestore(spinlock_t *lock,
 						   unsigned long flags)
 	__releases(lock)
 {
-	rt_spin_unlock(lock);
+	rt_spin_unlock_irqrestore(lock, flags);
 }
 
 #define spin_trylock(lock)	rt_spin_trylock(lock)
@@ -161,6 +166,27 @@ static __always_inline bool _spin_trylock_irqsave(spinlock_t *lock, unsigned lon
 }
 #define spin_trylock_irqsave(lock, flags) _spin_trylock_irqsave(lock, &(flags))
 
+/*
+ * For bounded no-lock allocator sections. A non-preemptible caller can
+ * acquire only an uncontended lock. Success creates an atomic owner, leaves
+ * local interrupts disabled, and adds a preemption-disable level. NMI and
+ * hard interrupt callers fail.
+ *
+ * The section must not block. A regular waiter spins with interrupts disabled
+ * and cannot boost the atomic owner. Pair every successful call with
+ * spin_unlock_irqrestore(lock, flags); spin_unlock() does not restore the
+ * interrupt state of an atomic owner.
+ */
+static __always_inline bool
+_spin_trylock_nolock_irqsave(spinlock_t *lock, unsigned long *flags)
+	__cond_acquires(true, lock)
+{
+	return rt_spin_trylock_nolock_irqsave(lock, flags);
+}
+
+#define spin_trylock_nolock_irqsave(lock, flags) \
+	_spin_trylock_nolock_irqsave(lock, &(flags))
+
 #define spin_is_contended(lock)		(((void)(lock), 0))
 
 static inline int spin_is_locked(spinlock_t *lock)
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 4728631ae719..342028cd682f 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -68,18 +68,23 @@ static inline int __ww_mutex_check_kill(struct rt_mutex *lock,
 /*
  * lock->owner state tracking:
  *
- * lock->owner holds the task_struct pointer of the owner. Bit 0
- * is used to keep track of the "lock has waiters" state.
+ * lock->owner holds the task_struct pointer of the owner. Bit 0 is used to
+ * keep track of the "lock has waiters" state. Bit 1 identifies an atomic
+ * owner which cannot participate in priority inheritance. Atomic ownership
+ * is used only by PREEMPT_RT spinlock trylocks whose caller cannot block.
  *
- * owner	bit0
- * NULL		0	lock is free (fast acquire possible)
- * NULL		1	lock is free and has waiters and the top waiter
- *				is going to take the lock*
- * taskpointer	0	lock is held (fast release possible)
- * taskpointer	1	lock is held and has waiters**
+ * owner       bit1 bit0
+ * NULL        0    0    lock is free (fast acquire possible)
+ * NULL        0    1    lock is free and has waiters; the top waiter
+ *                       is going to take the lock*
+ * taskpointer 0    0    lock is held (fast release possible)
+ * taskpointer 0    1    lock is held and has waiters**
+ * taskpointer 1    0    lock is held by an atomic owner
+ * taskpointer 1    1    lock is held by an atomic owner while a slow path
+ *                       excludes further atomic acquisitions***
  *
- * The fast atomic compare exchange based acquire and release is only
- * possible when bit 0 of lock->owner is 0.
+ * The regular fast atomic compare exchange based acquire and release is only
+ * possible when both flag bits in lock->owner are 0.
  *
  * (*) It also can be a transitional state when grabbing the lock
  * with ->wait_lock is held. To prevent any fast path cmpxchg to the lock,
@@ -90,8 +95,50 @@ static inline int __ww_mutex_check_kill(struct rt_mutex *lock,
  * waiters. This can happen when grabbing the lock in the slow path.
  * To prevent a cmpxchg of the owner releasing the lock, we need to
  * set this bit before looking at the lock.
+ *
+ * (***) The slow path sets the waiters bit while holding ->wait_lock, then
+ * waits for the atomic owner to release the lock to NULL|HAS_WAITERS. The
+ * atomic owner never enters the PI machinery and can release without taking
+ * ->wait_lock or waking a task. It cannot be preempted while holding the lock.
  */
 
+static __always_inline bool
+rt_mutex_atomic_owner(struct rt_mutex_base *lock)
+{
+	return (unsigned long)READ_ONCE(lock->owner) & RT_MUTEX_OWNER_ATOMIC;
+}
+
+static __always_inline bool
+rt_mutex_atomic_try_acquire(struct rt_mutex_base *lock)
+{
+	struct task_struct *old = NULL;
+	struct task_struct *new = (struct task_struct *)
+		((unsigned long)current | RT_MUTEX_OWNER_ATOMIC);
+
+	return try_cmpxchg_acquire(&lock->owner, &old, new);
+}
+
+static __always_inline bool
+rt_mutex_atomic_release(struct rt_mutex_base *lock)
+{
+	struct task_struct *old = READ_ONCE(lock->owner);
+	struct task_struct *new;
+	unsigned long owner;
+
+	for (;;) {
+		owner = (unsigned long)old;
+		if (WARN_ON_ONCE((owner & ~RT_MUTEX_OWNER_MASK) !=
+				 (unsigned long)current) ||
+		    WARN_ON_ONCE(!(owner & RT_MUTEX_OWNER_ATOMIC)))
+			return false;
+
+		new = (struct task_struct *)(owner & RT_MUTEX_HAS_WAITERS);
+		if (try_cmpxchg_release(&lock->owner, &old, new))
+			return true;
+		cpu_relax();
+	}
+}
+
 static __always_inline struct task_struct *
 rt_mutex_owner_encode(struct rt_mutex_base *lock, struct task_struct *owner)
 	__must_hold(&lock->wait_lock)
@@ -214,6 +261,37 @@ fixup_rt_mutex_waiters(struct rt_mutex_base *lock, bool acquire_lock)
 	}
 }
 
+/*
+ * Callers hold ->wait_lock, which serializes slow-path updates. This cmpxchg
+ * also arbitrates with regular lockless fast-path owner transitions when
+ * enabled and with atomic owner transitions, which do not take ->wait_lock.
+ * Once HAS_WAITERS is set, no new lockless acquisition can succeed. If an
+ * atomic owner was already present, wait until it drops its task pointer while
+ * preserving HAS_WAITERS.
+ */
+static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
+	__must_hold(&lock->wait_lock)
+{
+	unsigned long *p = (unsigned long *)&lock->owner;
+	unsigned long owner, new;
+
+	owner = READ_ONCE(*p);
+	for (;;) {
+		new = owner | RT_MUTEX_HAS_WAITERS;
+		if (try_cmpxchg_relaxed(p, &owner, new))
+			break;
+		cpu_relax();
+	}
+
+	/*
+	 * The cmpxchg above is relaxed to avoid back-to-back ACQUIRE operations
+	 * in the event of contention. Ensure the successful cmpxchg is visible.
+	 */
+	smp_mb__after_atomic();
+
+	smp_cond_load_relaxed(p, !(VAL & RT_MUTEX_OWNER_ATOMIC));
+}
+
 /*
  * We can speed up the acquire/release, if there's no debugging state to be
  * set up.
@@ -238,34 +316,45 @@ static __always_inline bool rt_mutex_cmpxchg_release(struct rt_mutex_base *lock,
 	return try_cmpxchg_release(&lock->owner, &old, new);
 }
 
-/*
- * Callers must hold the ->wait_lock -- which is the whole purpose as we force
- * all future threads that attempt to [Rmw] the lock to the slowpath. As such
- * relaxed semantics suffice.
- */
-static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
+#else
+static __always_inline bool rt_mutex_cmpxchg_acquire(struct rt_mutex_base *lock,
+						     struct task_struct *old,
+						     struct task_struct *new)
 {
-	unsigned long *p = (unsigned long *) &lock->owner;
-	unsigned long owner, new;
+	return false;
+}
 
-	owner = READ_ONCE(*p);
-	do {
-		new = owner | RT_MUTEX_HAS_WAITERS;
-	} while (!try_cmpxchg_relaxed(p, &owner, new));
+static int __sched rt_mutex_slowtrylock(struct rt_mutex_base *lock);
 
+static __always_inline bool rt_mutex_try_acquire(struct rt_mutex_base *lock)
+{
 	/*
-	 * The cmpxchg loop above is relaxed to avoid back-to-back ACQUIRE
-	 * operations in the event of contention. Ensure the successful
-	 * cmpxchg is visible.
+	 * With debug enabled rt_mutex_cmpxchg trylock() will always fail.
+	 *
+	 * Avoid unconditionally taking the slow path by using
+	 * rt_mutex_slow_trylock() which is covered by the debug code and can
+	 * acquire a non-contended rtmutex.
 	 */
-	smp_mb__after_atomic();
+	return rt_mutex_slowtrylock(lock);
 }
 
+static __always_inline bool rt_mutex_cmpxchg_release(struct rt_mutex_base *lock,
+						     struct task_struct *old,
+						     struct task_struct *new)
+{
+	return false;
+}
+
+#endif
+
 /*
  * Safe fastpath aware unlock:
  * 1) Clear the waiters bit
  * 2) Drop lock->wait_lock
  * 3) Try to unlock the lock with cmpxchg
+ *
+ * Atomic trylock also bypasses wait_lock, so debug builds need the same
+ * cmpxchg arbitration even though the regular fast path is disabled.
  */
 static __always_inline bool unlock_rt_mutex_safe(struct rt_mutex_base *lock,
 						 unsigned long flags)
@@ -299,59 +388,9 @@ static __always_inline bool unlock_rt_mutex_safe(struct rt_mutex_base *lock,
 	 *					lock(wait_lock);
 	 *					acquire(lock);
 	 */
-	return rt_mutex_cmpxchg_release(lock, owner, NULL);
-}
-
-#else
-static __always_inline bool rt_mutex_cmpxchg_acquire(struct rt_mutex_base *lock,
-						     struct task_struct *old,
-						     struct task_struct *new)
-{
-	return false;
-
-}
-
-static int __sched rt_mutex_slowtrylock(struct rt_mutex_base *lock);
-
-static __always_inline bool rt_mutex_try_acquire(struct rt_mutex_base *lock)
-{
-	/*
-	 * With debug enabled rt_mutex_cmpxchg trylock() will always fail.
-	 *
-	 * Avoid unconditionally taking the slow path by using
-	 * rt_mutex_slow_trylock() which is covered by the debug code and can
-	 * acquire a non-contended rtmutex.
-	 */
-	return rt_mutex_slowtrylock(lock);
-}
-
-static __always_inline bool rt_mutex_cmpxchg_release(struct rt_mutex_base *lock,
-						     struct task_struct *old,
-						     struct task_struct *new)
-{
-	return false;
-}
-
-static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
-	__must_hold(&lock->wait_lock)
-{
-	lock->owner = (struct task_struct *)
-			((unsigned long)lock->owner | RT_MUTEX_HAS_WAITERS);
+	return try_cmpxchg_release(&lock->owner, &owner, NULL);
 }
 
-/*
- * Simple slow path only version: lock->owner is protected by lock->wait_lock.
- */
-static __always_inline bool unlock_rt_mutex_safe(struct rt_mutex_base *lock,
-						 unsigned long flags)
-	__releases(lock->wait_lock)
-{
-	lock->owner = NULL;
-	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
-	return true;
-}
-#endif
-
 static __always_inline int __waiter_prio(struct task_struct *task)
 {
 	int prio = task->prio;
@@ -1432,9 +1471,8 @@ static void __sched rt_mutex_slowunlock(struct rt_mutex_base *lock)
 	debug_rt_mutex_unlock(lock);
 
 	/*
-	 * We must be careful here if the fast path is enabled. If we
-	 * have no waiters queued we cannot set owner to NULL here
-	 * because of:
+	 * If there are no waiters queued, owner still cannot be set to NULL
+	 * while wait_lock is held because a lockless acquisition can race:
 	 *
 	 * foo->lock->owner = NULL;
 	 *			rtmutex_lock(foo->lock);   <- fast path
@@ -1444,10 +1482,9 @@ static void __sched rt_mutex_slowunlock(struct rt_mutex_base *lock)
 	 *				kfree(foo);
 	 * raw_spin_unlock(foo->lock->wait_lock);
 	 *
-	 * So for the fastpath enabled kernel:
-	 *
-	 * Nothing can set the waiters bit as long as we hold
-	 * lock->wait_lock. So we do the following sequence:
+	 * The regular fast path can do this when enabled. Atomic trylock can do
+	 * this in debug builds too. Nothing can set the waiters bit as long as
+	 * wait_lock is held, so use the following sequence in either case:
 	 *
 	 *	owner = rt_mutex_owner(lock);
 	 *	clear_rt_mutex_waiters(lock);
@@ -1455,12 +1492,6 @@ static void __sched rt_mutex_slowunlock(struct rt_mutex_base *lock)
 	 *	if (cmpxchg(&lock->owner, owner, 0) == owner)
 	 *		return;
 	 *	goto retry;
-	 *
-	 * The fastpath disabled variant is simple as all access to
-	 * lock->owner is serialized by lock->wait_lock:
-	 *
-	 *	lock->owner = NULL;
-	 *	raw_spin_unlock(&lock->wait_lock);
 	 */
 	while (!rt_mutex_has_waiters(lock)) {
 		/* Drops lock->wait_lock ! */
diff --git a/kernel/locking/spinlock_rt.c b/kernel/locking/spinlock_rt.c
index 1d5e1b3c60bf..27f263296ac2 100644
--- a/kernel/locking/spinlock_rt.c
+++ b/kernel/locking/spinlock_rt.c
@@ -75,9 +75,22 @@ void __sched rt_spin_lock_nest_lock(spinlock_t *lock,
 EXPORT_SYMBOL(rt_spin_lock_nest_lock);
 #endif
 
-void __sched rt_spin_unlock(spinlock_t *lock) __releases(RCU)
+static __always_inline bool
+__rt_spin_unlock(spinlock_t *lock, unsigned long ip)
 {
-	spin_release(&lock->dep_map, _RET_IP_);
+	spin_release(&lock->dep_map, ip);
+
+	if (unlikely(rt_mutex_atomic_owner(&lock->lock))) {
+		/*
+		 * Atomic trylock holders have preemption disabled and never
+		 * entered the rtmutex PI machinery. Leave a marked slow path
+		 * the transitional HAS_WAITERS state and let it acquire the lock.
+		 */
+		WARN_ON_ONCE(!rt_mutex_atomic_release(&lock->lock));
+		rcu_read_unlock();
+		return true;
+	}
+
 	migrate_enable();
 
 	if (unlikely(!rt_mutex_cmpxchg_release(&lock->lock, current, NULL)))
@@ -100,9 +113,26 @@ void __sched rt_spin_unlock(spinlock_t *lock) __releases(RCU)
 	 *			    UAF ->	  rt_mutex_cmpxchg_release(&p->lock.lock...)
 	 */
 	rcu_read_unlock();
+	return false;
+}
+
+void __sched rt_spin_unlock(spinlock_t *lock) __releases(RCU)
+{
+	if (__rt_spin_unlock(lock, _RET_IP_))
+		preempt_enable();
 }
 EXPORT_SYMBOL(rt_spin_unlock);
 
+void __sched rt_spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
+	__releases(RCU)
+{
+	if (__rt_spin_unlock(lock, _RET_IP_)) {
+		local_irq_restore(flags);
+		preempt_enable();
+	}
+}
+EXPORT_SYMBOL(rt_spin_unlock_irqrestore);
+
 /*
  * Wait for the lock to get unlocked: instead of polling for an unlock
  * (like raw spinlocks do), lock and unlock, to force the kernel to
@@ -115,7 +145,8 @@ void __sched rt_spin_lock_unlock(spinlock_t *lock)
 }
 EXPORT_SYMBOL(rt_spin_lock_unlock);
 
-static __always_inline int __rt_spin_trylock(spinlock_t *lock)
+static __always_inline int
+__rt_spin_trylock(spinlock_t *lock, unsigned long ip)
 {
 	int ret = 1;
 
@@ -123,7 +154,7 @@ static __always_inline int __rt_spin_trylock(spinlock_t *lock)
 		ret = rt_mutex_slowtrylock(&lock->lock);
 
 	if (ret) {
-		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		spin_acquire(&lock->dep_map, 0, 1, ip);
 		rcu_read_lock();
 		migrate_disable();
 	}
@@ -132,16 +163,39 @@ static __always_inline int __rt_spin_trylock(spinlock_t *lock)
 
 int __sched rt_spin_trylock(spinlock_t *lock)
 {
-	return __rt_spin_trylock(lock);
+	return __rt_spin_trylock(lock, _RET_IP_);
 }
 EXPORT_SYMBOL(rt_spin_trylock);
 
+int __sched rt_spin_trylock_nolock_irqsave(spinlock_t *lock,
+					   unsigned long *flags)
+{
+	if (unlikely(in_nmi() || in_hardirq()))
+		return 0;
+	if (preemptible()) {
+		*flags = 0;
+		return __rt_spin_trylock(lock, _RET_IP_);
+	}
+
+	local_irq_save(*flags);
+	preempt_disable();
+	if (!rt_mutex_atomic_try_acquire(&lock->lock)) {
+		preempt_enable();
+		local_irq_restore(*flags);
+		return 0;
+	}
+
+	spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+	rcu_read_lock();
+	return 1;
+}
+
 int __sched rt_spin_trylock_bh(spinlock_t *lock)
 {
 	int ret;
 
 	local_bh_disable();
-	ret = __rt_spin_trylock(lock);
+	ret = __rt_spin_trylock(lock, _RET_IP_);
 	if (!ret)
 		local_bh_enable();
 	return ret;
-- 
2.53.0

