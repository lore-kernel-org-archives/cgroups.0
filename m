From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v14 0/4] cgroup: add PIDs subsystem
Date: Tue,  9 Jun 2015 21:32:06 +1000
Message-ID: <1433849530-22845-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

This is another small update to v13 of the pids patchset[1] (half of
which has already been merged to Tejun's tree). The main changes are:

* Fix uninitialised iterator in for_each_subsys_which when
  CGROUP_SUBSYS_COUNT = 0.

* A few small (mainly stylistic) fixes to kernel/cgroup_pids.c and
  kernel/cgroup.c.

[1]: https://lkml.org/lkml/2015/6/5/857

Aleksa Sarai (3):
  cgroup: fix uninitialised iterator in for_each_subsys_which
  cgroup: allow a cgroup subsystem to reject a fork
  cgroup: implement the PIDs subsystem

Tejun Heo (1):
  cgroup, block: implement task_get_css()

 CREDITS                       |   5 +
 include/linux/cgroup-defs.h   |  10 +-
 include/linux/cgroup.h        |  40 ++++-
 include/linux/cgroup_subsys.h |  28 ++++
 init/Kconfig                  |  16 ++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               |  75 ++++++++-
 kernel/cgroup_freezer.c       |   2 +-
 kernel/cgroup_pids.c          | 366 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |  17 +-
 kernel/sched/core.c           |   2 +-
 11 files changed, 552 insertions(+), 10 deletions(-)
 create mode 100644 kernel/cgroup_pids.c

-- 
2.4.2
