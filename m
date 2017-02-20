From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 00/19] Kernel subsystem refcounter conversions
Date: Mon, 20 Feb 2017 12:18:49 +0200
Message-ID: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, paul@paul-moore.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, Elena Reshetova <elena.reshetova@intel.com>

Now when new refcount_t type and API are finally merged
(see include/linux/refcount.h), the following
patches convert various refcounters in the kernel susystem from atomic_t
to refcount_t. By doing this we prevent intentional or accidental
underflows or overflows that can led to use-after-free vulnerabilities.

The below patches are fully independent and can be cherry-picked separately.
Since we convert all kernel subsystems in the same fashion, resulting
in about 300 patches, we have to group them for sending at least in some
fashion to be manageable. Please excuse the long cc list.

Elena Reshetova (19):
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
  kernel: convert cgroup_namespace.count from atomic_t to refcount_t
  kernel: convert css_set.refcount from atomic_t to refcount_t
  kernel: convert group_info.usage from atomic_t to refcount_t
  kernel: convert cred.usage from atomic_t to refcount_t
  kernel: convert audit_tree.count from atomic_t to refcount_t
  kernel: convert audit_watch.count from atomic_t to refcount_t
  kernel: convert numa_group.refcount from atomic_t to refcount_t
  kernel: convert futex_pi_state.refcount from atomic_t to refcount_t
  kernel: convert kcov.refcount from atomic_t to refcount_t

 fs/exec.c                       |  4 ++--
 include/linux/cgroup-defs.h     |  3 ++-
 include/linux/cgroup.h          |  7 ++++---
 include/linux/cred.h            | 13 ++++++------
 include/linux/init_task.h       |  7 ++++---
 include/linux/nsproxy.h         |  6 +++---
 include/linux/perf_event.h      |  3 ++-
 include/linux/sched.h           | 19 +++++++++--------
 kernel/audit_tree.c             |  8 +++----
 kernel/audit_watch.c            |  8 +++----
 kernel/cgroup/cgroup-internal.h | 10 ++++++---
 kernel/cgroup/cgroup-v1.c       |  4 ++--
 kernel/cgroup/cgroup.c          | 10 ++++-----
 kernel/cgroup/namespace.c       |  2 +-
 kernel/cred.c                   | 46 ++++++++++++++++++++---------------------
 kernel/events/core.c            | 18 ++++++++--------
 kernel/events/internal.h        |  5 +++--
 kernel/events/ring_buffer.c     |  8 +++----
 kernel/events/uprobes.c         |  8 +++----
 kernel/fork.c                   | 24 ++++++++++-----------
 kernel/futex.c                  | 15 +++++++-------
 kernel/groups.c                 |  2 +-
 kernel/kcov.c                   |  9 ++++----
 kernel/nsproxy.c                |  6 +++---
 kernel/sched/fair.c             |  8 +++----
 kernel/user.c                   |  8 +++----
 26 files changed, 137 insertions(+), 124 deletions(-)

-- 
2.7.4

