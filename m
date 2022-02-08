From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC 00/12] locking: Separate lock tracepoints from lockdep/lock_stat (v1)
Date: Tue,  8 Feb 2022 10:41:56 -0800
Message-ID: <20220208184208.79303-1-namhyung@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QcpIxzZvYuuAm3c/D++SXFKUkjezGRIPoDnuT7gjuS4=;
        b=BNWmQDGzQhJOJLr20D/etrQQuhY81jJWwmpDL0Xt0O5f43GCoxY1ICkUWrXJklrxBo
         rFIACHenEAbPu/P+VHLv9FX9FzCi64wyj8O0snxr9fugo+7Z3kvYdxcb533QCN7bPL66
         NGyI94u9gLrg3frZKDcuxAHINbEWXiRjOdGpsLeZ6hu3L0LQuJFXHtp1cPWsOsTeOpsb
         kKM9k9gyjWDRGWTMT1HXqMu2QWbxiDdhcw0yWtxn+5PrO7ltohv3rXARS315XZu0CXBv
         lZWznhdZ3Kc9DAf6inpM0ihrBwwS0u4efdhQFkbHrNhZbLd0pKBKGhMJRajOJ+H5OeBK
         Vw+w==
Sender: Namhyung Kim <namhyung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, "Paul E. McKenney" <paul.mckenney-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org

Hello,

There have been some requests for low-overhead kernel lock contention
monitoring.  The kernel has CONFIG_LOCK_STAT to provide such an infra
either via /proc/lock_stat or tracepoints directly.

However it's not light-weight and hard to be used in production.  So
I'm trying to separate out the tracepoints and using them as a base to
build a new monitoring system.

As the lockdep and lock_stat provide good hooks in the lock functions,
it'd be natural to reuse them.  Actually I tried to use lockdep as is
but disables the functionality at runtime (initialize debug_locks = 0,
lock_stat = 0).  But it still has unacceptable overhead and the
lockdep data structures also increase memory footprint unnecessarily.

So I'm proposing a separate tracepoint-only configuration and keeping
lockdep_map only with minimal information needed for tracepoints (for
now, it's just name).  And then the existing lockdep hooks can be used
for the tracepoints.

The patch 01-06 are preparation for the work.  In a few places in the
kernel, they calls lockdep annotation explicitly to deal with
limitations in the lockdep implementation.  In my understanding, they
are not needed to analyze lock contention.

To make matters worse, they rely on the compiler optimization (or
macro magic) so that it can get rid of the annotations and their
arguments when lockdep is not configured.

But it's not true any more when lock tracepoints are added and it'd
cause build errors.  So I added #ifdef guards for LOCKDEP in the code
to prevent such errors.

In the patch 07 I mechanically changed most of code that depend on
CONFIG_LOCKDEP or CONFIG_DEBUG_LOCK_ALLOC to CONFIG_LOCK_INFO.  It
paves the way for the codes to be shared for lockdep and tracepoints.
Mostly, it makes sure that locks are initialized with a proper name,
like in the patch 08 and 09.

I didn't change some places intentionally - for example, timer and
workqueue depend on LOCKDEP explicitly since they use some lockdep
annotations to work around the "held lock freed" warnings.  The ocfs2
directly accesses lockdep_map.key so I didn't touch the code for now.
And RCU was because it generates too much overhead thanks to the
rcu_read_lock().  Maybe I need to revisit some of them later.

I added CONFIG_LOCK_TRACEPOINTS in the patch 10 to make it optional.
I found that it adds 2~3% of overhead when I ran `perf bench sched
messaging` even when the tracepoints are disabled.  The benchmark
creates a lot of processes and make them communicate by socket pairs
(or pipes).  I measured that around 15% of lock acquisition creates
contentions and it's mostly for spin locks (alc->lock and u->lock).

I ran perf record + report with the workload and it showed 50% of the
cpu cycles are in the spin lock slow path.  So it's highly affected by
the spin lock slow path.  Actually LOCK_CONTENDED() macro transforms
the spin lock code (and others) to use trylock first and then fall
back to real lock function if failed.  Thus it'd add more (atomic)
operations and cache line bouncing for the contended cases:

  #define LOCK_CONTENDED(_lock, try, lock)		\
  do {							\
      if (!try(_lock)) {				\
          lock_contended(&(_lock)->dep_map, _RET_IP_);	\
          lock(_lock);					\
      }							\
      lock_acquired(&(_lock)->dep_map, _RET_IP_);	\
  } while (0)

If I modify the macro not to use trylock and to call the real lock
function directly (so the lock_contended tracepoint would be called
always, if enabled), the overhead goes down to 0.x% when the
tracepoints are disabled.

I don't have a good solution as long as we use LOCK_CONTENDED() macro
to separate the contended locking path.  Maybe we can make it call
some (generic) slow path lock function directly after failing trylock.
Or move the lockdep annotations into the each lock function bodies and
get rid of the LOCK_CONTENDED() macro entirely.  Ideas?

Actually the patch 11 handles the same issue on the mutex code.  The
fast version of mutex trylock was attempted only if LOCKDEP is not
enabled and it affects the mutex lock performance in the uncontended
cases too.  So I partially reverted the change in the patch 07 to use
the fast functions with lock tracepoints too.  Maybe we can use it
with LOCKDEP as well?

The last patch 12 might be controversial and I'd like to move the
lock_acquired annotation into the if(!try) block in the LOCK_CONTEDED
macro so that it can only be called when there's a contention.

Eventually I'm mostly interested in the contended locks only and I
want to reduce the overhead in the fast path.  By moving that, it'd be
easy to track contended locks with timing by using two tracepoints.

It'd change lock hold time calculation in lock_stat for the fast path,
but I assume time difference between lock_acquire and lock_acquired
would be small when the lock is not contended.  So I think we can use
the timestamp in lock_acquire.  If it's not acceptable, we might
consider adding a new tracepoint to track the timing of contended
locks.

This series base on the current tip/locking/core and you get it from
'locking/tracepoint-v1' branch in my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Thanks,
Namhyung


Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>
Cc: rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org


Namhyung Kim (12):
  locking: Pass correct outer wait type info
  cgroup: rstat: Make cgroup_rstat_cpu_lock name readable
  timer: Protect lockdep functions with #ifdef
  workqueue: Protect lockdep functions with #ifdef
  drm/i915: Protect lockdep functions with #ifdef
  btrfs: change lockdep class size check using ks->names
  locking: Introduce CONFIG_LOCK_INFO
  locking/mutex: Init name properly w/ CONFIG_LOCK_INFO
  locking: Add more static lockdep init macros
  locking: Add CONFIG_LOCK_TRACEPOINTS option
  locking/mutex: Revive fast functions for LOCK_TRACEPOINTS
  locking: Move lock_acquired() from the fast path

 drivers/gpu/drm/drm_connector.c               |   7 +-
 drivers/gpu/drm/i915/i915_sw_fence.h          |   2 +-
 drivers/gpu/drm/i915/intel_wakeref.c          |   3 +
 drivers/gpu/drm/i915/selftests/lib_sw_fence.h |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |   4 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   2 +-
 drivers/tty/tty_ldsem.c                       |   2 +-
 fs/btrfs/disk-io.c                            |   4 +-
 fs/btrfs/disk-io.h                            |   2 +-
 fs/cifs/connect.c                             |   2 +-
 fs/kernfs/file.c                              |   2 +-
 include/linux/completion.h                    |   2 +-
 include/linux/jbd2.h                          |   2 +-
 include/linux/kernfs.h                        |   2 +-
 include/linux/kthread.h                       |   2 +-
 include/linux/local_lock_internal.h           |  18 +-
 include/linux/lockdep.h                       | 170 ++++++++++++++++--
 include/linux/lockdep_types.h                 |   8 +-
 include/linux/mmu_notifier.h                  |   2 +-
 include/linux/mutex.h                         |  12 +-
 include/linux/percpu-rwsem.h                  |   4 +-
 include/linux/regmap.h                        |   4 +-
 include/linux/rtmutex.h                       |  14 +-
 include/linux/rwlock_api_smp.h                |   4 +-
 include/linux/rwlock_rt.h                     |   4 +-
 include/linux/rwlock_types.h                  |  11 +-
 include/linux/rwsem.h                         |  14 +-
 include/linux/seqlock.h                       |   4 +-
 include/linux/spinlock_api_smp.h              |   4 +-
 include/linux/spinlock_rt.h                   |   4 +-
 include/linux/spinlock_types.h                |   4 +-
 include/linux/spinlock_types_raw.h            |  28 ++-
 include/linux/swait.h                         |   2 +-
 include/linux/tty_ldisc.h                     |   2 +-
 include/linux/wait.h                          |   2 +-
 include/linux/ww_mutex.h                      |   6 +-
 include/media/v4l2-ctrls.h                    |   2 +-
 include/net/sock.h                            |   2 +-
 include/trace/events/lock.h                   |   4 +-
 kernel/cgroup/rstat.c                         |   7 +-
 kernel/locking/Makefile                       |   1 +
 kernel/locking/lockdep.c                      |  40 ++++-
 kernel/locking/mutex-debug.c                  |   2 +-
 kernel/locking/mutex.c                        |  22 ++-
 kernel/locking/mutex.h                        |   7 +
 kernel/locking/percpu-rwsem.c                 |   2 +-
 kernel/locking/rtmutex_api.c                  |  10 +-
 kernel/locking/rwsem.c                        |   4 +-
 kernel/locking/spinlock.c                     |   2 +-
 kernel/locking/spinlock_debug.c               |   4 +-
 kernel/locking/spinlock_rt.c                  |   8 +-
 kernel/locking/ww_rt_mutex.c                  |   2 +-
 kernel/printk/printk.c                        |  14 +-
 kernel/rcu/update.c                           |  27 +--
 kernel/time/timer.c                           |   8 +-
 kernel/workqueue.c                            |  13 ++
 lib/Kconfig.debug                             |  14 ++
 mm/memcontrol.c                               |   7 +-
 mm/mmu_notifier.c                             |   2 +-
 net/core/dev.c                                |   2 +-
 net/sunrpc/svcsock.c                          |   2 +-
 net/sunrpc/xprtsock.c                         |   2 +-
 62 files changed, 391 insertions(+), 180 deletions(-)


base-commit: 1dc01abad6544cb9d884071b626b706e37aa9601
-- 
2.35.0.263.gb82422642f-goog

