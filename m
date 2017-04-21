From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH 00/14] cgroup: Implement cgroup v2 thread mode & CPU controller
Date: Fri, 21 Apr 2017 10:03:58 -0400
Message-ID: <1492783452-12267-1-git-send-email-longman@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 4E2A880490
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, Waiman Long <longman@redhat.com>

This patchset incorporates the following 2 patchsets from Tejun Heo:

 1) cgroup v2 thread mode patchset (5 patches)
    https://lkml.org/lkml/2017/2/2/592
 2) CPU Controller on Control Group v2 (2 patches)
    https://lkml.org/lkml/2016/8/5/368

Additional patches are then layered on top to implement the following
new features:

 1) An enhanced v2 thread mode where a thread root (root of a threaded
    subtree) can have non-threaded children with non-threaded
    controllers enabled and no internal process constraint does
    not apply.
 2) An enhanced debug controller which dumps out more information
    relevant to the debugging and testing of cgroup v2 in general.
 3) Separate control knobs for resource domain controllers can be
    enabled in a thread root to manage all the internal processes in
    the threaded subtree.

Patches 1-5 are Tejun's cgroup v2 thread mode patchset.

Patch 6 fixes a task_struct reference counting bug introduced in
patch 1.

Patch 7 moves the debug cgroup out from cgroup_v1.c into its own
file.

Patch 8 keeps more accurate counts of the number of tasks associated
with each css_set.

Patch 9 enhances the debug controller to provide more information
relevant to the cgroup v2 thread mode to ease debugging effort.

Patch 10 implements the enhanced cgroup v2 thread mode with the
following enhancements:

 1) Thread roots are treated differently from threaded cgroups.
 2) Thread root can now have non-threaded controllers enabled as well
    as non-threaded children.

Patches 11-12 are Tejun's CPU controller on control group v2 patchset.

Patch 13 makes both cpu and cpuacct controllers threaded.

Patch 14 enables the creation of a special "cgroup.self" directory
under the thread root to hold resource control knobs for controllers
that don't want resource competiton between internal processes and
non-threaded child cgroups.

Preliminary testing was done with the debug controller enabled. Things
seemed to work fine so far. More rigorous testing will be needed, and
any suggestions are welcome.

Tejun Heo (7):
  cgroup: reorganize cgroup.procs / task write path
  cgroup: add @flags to css_task_iter_start() and implement
    CSS_TASK_ITER_PROCS
  cgroup: introduce cgroup->proc_cgrp and threaded css_set handling
  cgroup: implement CSS_TASK_ITER_THREADED
  cgroup: implement cgroup v2 thread support
  sched: Misc preps for cgroup unified hierarchy interface
  sched: Implement interface for cgroup unified hierarchy

Waiman Long (7):
  cgroup: Fix reference counting bug in cgroup_procs_write()
  cgroup: Move debug cgroup to its own file
  cgroup: Keep accurate count of tasks in each css_set
  cgroup: Make debug cgroup support v2 and thread mode
  cgroup: Implement new thread mode semantics
  sched: Make cpu/cpuacct threaded controllers
  cgroup: Enable separate control knobs for thread root internal
    processes

 Documentation/cgroup-v2.txt     | 114 +++++-
 include/linux/cgroup-defs.h     |  56 +++
 include/linux/cgroup.h          |  12 +-
 kernel/cgroup/Makefile          |   1 +
 kernel/cgroup/cgroup-internal.h |  18 +-
 kernel/cgroup/cgroup-v1.c       | 217 +++-------
 kernel/cgroup/cgroup.c          | 862 ++++++++++++++++++++++++++++++++++------
 kernel/cgroup/cpuset.c          |   6 +-
 kernel/cgroup/debug.c           | 284 +++++++++++++
 kernel/cgroup/freezer.c         |   6 +-
 kernel/cgroup/pids.c            |   1 +
 kernel/events/core.c            |   1 +
 kernel/sched/core.c             | 150 ++++++-
 kernel/sched/cpuacct.c          |  55 ++-
 kernel/sched/cpuacct.h          |   5 +
 mm/memcontrol.c                 |   3 +-
 net/core/netclassid_cgroup.c    |   2 +-
 17 files changed, 1478 insertions(+), 315 deletions(-)
 create mode 100644 kernel/cgroup/debug.c

-- 
1.8.3.1

