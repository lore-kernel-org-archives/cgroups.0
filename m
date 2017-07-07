From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 00/15] v2 kernel core refcount conversions
Date: Fri,  7 Jul 2017 12:04:14 +0300
Message-ID: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>

Changes in v2:
 * dropped already merged patches
 * rebase on top of linux-next/master
 * Now by default refcount_t = atomic_t (*) and uses all atomic
   standard operations unless CONFIG_REFCOUNT_FULL is enabled.
   This is a compromise for the systems that are critical on
   performance (such as net) and cannot accept even slight delay
   on the refcounter operations.

This series, for core kernel components, replaces atomic_t reference
counters with the new refcount_t type and API (see include/linux/refcount.h).
By doing this we prevent intentional or accidental
underflows or overflows that can led to use-after-free vulnerabilities.

The patches are fully independent and can be cherry-picked separately.
If there are no objections to the patches, please merge them via respective trees.

If you want to test with refcount_t protection enabled, CONFIG_REFCOUNT_FULL
must be enabled.

* The respective change is currently merged into -next as
  "locking/refcount: Create unchecked atomic_t implementation".

Elena Reshetova (15):
  kernel: convert sighand_struct.count from atomic_t to refcount_t
  kernel: convert signal_struct.sigcnt from atomic_t to refcount_t
  kernel: convert user_struct.__count from atomic_t to refcount_t
  kernel: convert task_struct.usage from atomic_t to refcount_t
  kernel: convert task_struct.stack_refcount from atomic_t to refcount_t
  kernel: convert perf_event_context.refcount from atomic_t to
    refcount_t
  kernel: convert ring_buffer.refcount from atomic_t to refcount_t
  kernel: convert ring_buffer.aux_refcount from atomic_t to refcount_t
  kernel: convert uprobe.ref from atomic_t to refcount_t
  kernel: convert nsproxy.count from atomic_t to refcount_t
  kernel: convert group_info.usage from atomic_t to refcount_t
  kernel: convert cred.usage from atomic_t to refcount_t
  kernel: convert numa_group.refcount from atomic_t to refcount_t
  kernel: convert futex_pi_state.refcount from atomic_t to refcount_t
  kernel: convert kcov.refcount from atomic_t to refcount_t

 fs/exec.c                        |  4 ++--
 fs/proc/task_nommu.c             |  2 +-
 include/linux/cred.h             | 13 ++++++------
 include/linux/init_task.h        |  7 +++---
 include/linux/nsproxy.h          |  6 +++---
 include/linux/perf_event.h       |  3 ++-
 include/linux/sched.h            |  5 +++--
 include/linux/sched/signal.h     |  5 +++--
 include/linux/sched/task.h       |  4 ++--
 include/linux/sched/task_stack.h |  2 +-
 include/linux/sched/user.h       |  5 +++--
 kernel/cred.c                    | 46 ++++++++++++++++++++--------------------
 kernel/events/core.c             | 18 ++++++++--------
 kernel/events/internal.h         |  5 +++--
 kernel/events/ring_buffer.c      |  8 +++----
 kernel/events/uprobes.c          |  8 +++----
 kernel/fork.c                    | 24 ++++++++++-----------
 kernel/futex.c                   | 13 ++++++------
 kernel/groups.c                  |  2 +-
 kernel/kcov.c                    |  9 ++++----
 kernel/nsproxy.c                 |  6 +++---
 kernel/sched/fair.c              |  8 +++----
 kernel/user.c                    |  8 +++----
 23 files changed, 110 insertions(+), 101 deletions(-)

-- 
2.7.4

