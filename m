Received: from mta1.migadu.com (out-100.mta1.migadu.com [95.215.58.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4A14A4F09
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 15:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265043; cv=none; b=R0y6bsrOUHewQ8a5udY9tDgSf0kYV9QdhRUKfedM96w88qkovbbzKJBqvcTHsiQMjen2t5NDlEnOPgvlVxHAQsv3IdHBeElVLN2u8iBYauetcBcv7cKJJTOp9KLdJoe3V9SWZm+LpLQlMBU84tZAWqIzAIQ4cEwl3GuLEzpeS3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265043; c=relaxed/simple;
	bh=St5Qemc/F9W9cPqioS33TbJZOQduQNBSdTaFFw3vb60=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bi6cAG3ZlUPExgk1w3H1Q3dqskC3NwSKsMKc0Mp40an2sJ0TpX4y7Kt3ZMDOu/zqFOGxn34m5fZ7oPuZcpmlkkHkd1QAS+UoU2GccmbP18WdsZu7qAKz9DWCqS0DJrYpC/ppVkYfDl0bIFxnRaH+rd/Le+tQv1BEh2GpbkTsd5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I2NHyTLM; arc=none smtp.client-ip=95.215.58.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I2NHyTLM"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=St5Qemc/F9W9cPqioS33TbJZOQduQNBSdTaFFw3vb60=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790265038; v=1; x=1790869838;
 b=I2NHyTLM1NByByei0rBpvyqKo5B9kzGUsjFw7U+o7VNqxq0m3yy0Gz0zuDj0uNB8CLOw5d+0
 Ofj5tPCBxHbC9rTIwlQcFKnXUJIr24SjGd0IEwlZpQqSei3hJIQWB7JXLnG11vYNYZDsEsd7ewm
 ARShyV1L7EckuI1DBNIoD7KY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 020b30244c62fc19;
	Thu, 24 Sep 2026 15:50:31 +0000
X-Mizu-Trace-ID: 020b30244c62fc19
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
Subject: [PATCH RESEND 0/7] locking: opt-in tracking of sleeping lock holders
Date: Thu, 24 Sep 2026 08:50:18 -0700
Message-ID: <20260924155025.949998-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resending the full series because the first posting [0] did not reach
all recipients. The patches are unchanged.

[0] https://lore.kernel.org/cover.1790139577.git.shakeel.butt@linux.dev/

This series adds a cheap way to answer one question:

  Is this task holding a lock that other tasks may be waiting for?

The answer is a count in task_struct. Only the locks that ask to be
tracked are counted. The mechanism introduced here is planned to be used
by solutions for shared lock isolation scenarios [1].

The problem
===========

A task that stalls while holding a widely shared lock does not just slow
itself down. Everything waiting behind that lock slows down too, and
those waiters can be from unrelated cgroups.

This is an isolation failure. Pressure in one workload leaks into an
unrelated workload through a shared lock, and the second workload has no
way to defend itself.

The case we hit is memory. An allocation made while holding a lock can
get stuck in reclaim, either because a memcg limit is being enforced or
because the machine is low on memory. If the lock is cgroup_mutex or
kernfs_rwsem, every other cgroup operation on the machine waits for that
reclaim, whichever cgroup caused it.

Knowing the task holds such a lock lets the allocator treat it
differently:

 - under a memcg limit, skip the throttling that enforcement does
   inline, and leave it for the return to user space, where memory.high
   is enforced anyway;

 - under global pressure, let the allocation reach the memory reserves
   so it finishes instead of waiting for reclaim.

Either way the task gets out of the critical section quickly, and the
pressure is still accounted for.

CPU limits have the same shape of problem, and the scheduler has already
paid to avoid it: commit e1fad12dcb66 ("sched/fair: Switch to task based
throttle model") stopped throttling a task the moment its cpu.max quota
runs out, and now defers it to the return to user space, so a task
cannot be stopped in the middle of a critical section. That works
without knowing anything about locks, because it defers for every task.
The allocator cannot do the same, because dropping the inline work for
everybody may cause more isolation issues due to global memory pressure,
or make the system unstable by fully depleting the memory reserves.


Why not something that already exists
=====================================

Everything in the tree that can answer the question is too expensive,
and the ones that are cheap enough cannot answer it.

Too expensive:

 - lockdep. lock_is_held_type() answers exactly this, for every sleeping
   lock type including the rw_semaphore read side. It is the only thing
   in the tree that does. But the cost cannot be trimmed down to it:
   DEBUG_LOCK_ALLOC selects DEBUG_SPINLOCK, DEBUG_MUTEXES and LOCKDEP,
   and LOCKDEP selects STACKTRACE and KALLSYMS_ALL. Measured here on
   will-it-scale, x86_64: DEBUG_LOCK_ALLOC costs 36-53% throughput and
   PROVE_LOCKING 39-70%, and task_struct grows from 4096 to 6784 bytes.
   lockdep also answers about one named lock, so the caller would have
   to know the set of interesting locks and test each one.

 - BPF on the lock primitives [1]. This works, and we prototyped it:
   fentry on the down_*() exits, fexit on the up_*() entries, per task
   depth in task storage. It cost about 8% throughput against the same
   policy hooking a single function, because the probe fires on every
   down_read() in the kernel and only then compares the address.

Cannot answer it:

 - The locks' own owner fields. A mutex, an rt_mutex and a write held
   rw_semaphore know their owner. The rw_semaphore read side does not,
   and that is the side that matters. kernel/locking/rwsem.c says why:
   "Ideally we would like to track all the readers that own a rwsem, but
   the overhead is simply too big." percpu_rw_semaphore is the same, by
   design: its readers are spread over per-CPU counters.

 - hung-task blocker tracking. task->blocker records what a task waits
   for, not what it holds, and inherits the same rwsem reader gap.

 - Lock tracepoints. The two that fire on every acquire and release are
   inside #ifdef CONFIG_LOCKDEP. The ones that need no lockdep only fire
   on contention. The closest, contended_release, is holder side but
   fires at release, after the decision has to be made.

 - A new PF_ flag set by the callers. Save and restore cannot express
   non-LIFO release, and sleeping locks are released out of order all
   the time: take A, take B, release A, and the flag is cleared while B
   is still held. Getting that right needs a counter, which is this
   series with hand written call sites. The cgroupfs kernfs rwsems alone
   are taken in 37 places, and missing one is silent.

 - Reusing PF_MEMALLOC. It means "I am reclaiming, let me into the
   reserves": it grants ALLOC_NO_WATERMARKS and skips direct reclaim. A
   cgroupfs walker holding kernfs_rwsem across many allocations would
   drain the reserves rather than politely skip a throttle.

 - rwsem_is_locked() and friends say somebody holds the lock, not you.

This series inverts that: instead of a lock knowing its many readers,
each task knows how many interesting locks it holds.

The opt-in is a spare bit of a word the lock already has, bit 3 of
rw_semaphore::count and of mutex::owner, or existing padding, so on
64-bit no lock grows. With CONFIG_TRACK_LOCK_HOLDERS=n the locking code
is unchanged. With it built in but nothing opted in, the hooks are a
static branch that has not been patched in, so every lock still runs the
instructions it ran before.


The patches
===========

 1  the core: the counter, the static key, the hooks, Kconfig
 2  rw_semaphore support
 3  mutex support
 4  percpu_rw_semaphore support
 5  KUnit tests
 6  documentation
 7  opt in the cgroupfs locks: the kernfs rwsems, cgroup_mutex and
    cgroup_threadgroup_rwsem


Testing
=======

19 KUnit tests in kernel/locking/lockholder_kunit.c. Sixteen check that
the count always matches the number of opted-in locks the task holds,
across every way each lock type can be taken and dropped: fast and slow
paths, failed trylocks, out of order release, downgrade_write(), the
percpu handover calls, cleanup.h guards, and a second task to check the
counts are per task. Three cover what the opt-in changes besides the
count: that an opted-in but unheld lock still reads unlocked, that
*_track_holder() refuses a lock that is already held, and that the
non_owner rwsem calls warn and do not count.

  tools/testing/kunit/kunit.py run --kunitconfig=kernel/locking/ lockholder

They pass in four configurations: UML, x86_64, x86_64 with
PROVE_LOCKING, DEBUG_MUTEXES and DEBUG_RWSEMS, and x86_64 with
PREEMPT_RT. The debug one earns its place twice over: it compiles the
mutex fast paths out, so every acquire and release goes through the slow
paths that rebuild the flag word, and it is the only one that runs the
non_owner test, as without CONFIG_DEBUG_LOCK_ALLOC those calls are
defined to plain down_read() and up_read(). That test skips in the other
three. A full x86_64 build with modules is clean.


[1] https://lore.kernel.org/20260921192559.2619635-1-shakeel.butt@linux.dev/

Shakeel Butt (7):
  locking: add opt-in tracking of sleeping lock holders
  locking/rwsem: track holders of opted-in rw_semaphores
  locking/mutex: track holders of opted-in mutexes
  locking/percpu-rwsem: track holders of opted-in percpu_rw_semaphores
  locking/selftests: add KUnit tests for lock holder tracking
  Documentation/locking: document sleeping lock holder tracking
  kernfs, cgroup: track holders of the cgroupfs locks

 Documentation/locking/index.rst               |   1 +
 .../locking/lock-holder-tracking.rst          | 168 ++++
 MAINTAINERS                                   |   1 +
 fs/kernfs/dir.c                               |   5 +
 include/linux/kernfs.h                        |   7 +
 include/linux/lockholder.h                    | 119 +++
 include/linux/mutex.h                         |  14 +
 include/linux/percpu-rwsem.h                  |  42 +
 include/linux/rtmutex.h                       |  11 +
 include/linux/rwsem.h                         |  65 +-
 include/linux/sched.h                         |   8 +
 kernel/Kconfig.locks                          |  16 +
 kernel/cgroup/cgroup.c                        |  27 +-
 kernel/exit.c                                 |   4 +
 kernel/fork.c                                 |   3 +
 kernel/locking/.kunitconfig                   |   4 +
 kernel/locking/Makefile                       |   2 +
 kernel/locking/lockholder.c                   |  19 +
 kernel/locking/lockholder_kunit.c             | 741 ++++++++++++++++++
 kernel/locking/mutex.c                        |  79 +-
 kernel/locking/mutex.h                        |  48 +-
 kernel/locking/percpu-rwsem.c                 |  28 +
 kernel/locking/rtmutex_api.c                  |  36 +-
 kernel/locking/rtmutex_common.h               |   3 +
 kernel/locking/rwsem.c                        |  96 ++-
 lib/Kconfig.debug                             |  13 +
 26 files changed, 1539 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/locking/lock-holder-tracking.rst
 create mode 100644 include/linux/lockholder.h
 create mode 100644 kernel/locking/.kunitconfig
 create mode 100644 kernel/locking/lockholder.c
 create mode 100644 kernel/locking/lockholder_kunit.c

base-commit: a8c591ed6b672915e0be57843f943a2a723aff40
-- 
2.47.3
