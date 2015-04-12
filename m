From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v9 0/4] cgroups: add pids subsystem
Date: Sun, 12 Apr 2015 10:51:53 +1000
Message-ID: <1428799917-15141-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

This is an updated version of v8 of the pids patchset[1], with a few
small fixes, namely:

* Remove the cgroup_fork_state abstraction and just store the ss_state
  (void *)[CGROUP_PREFORK_COUNT] on the stack.

* Only pass a (void **) to can_fork, and pass (void *) to
  {cancel_,}fork.

* Add a tagging macro to cgroup_subsys.h, so that the ss_state array can
  be CGROUP_PREFORK_COUNT in size.

[1]: https://lkml.org/lkml/2015/4/1/145

Aleksa Sarai (4):
  cgroups: use bitmask to filter for_each_subsys
  cgroups: replace explicit ss_mask checking with for_each_subsys_which
  cgroups: allow a cgroup subsystem to reject a fork
  cgroups: implement the PIDs subsystem

 include/linux/cgroup.h        |  67 ++++++--
 include/linux/cgroup_subsys.h |  43 +++++
 init/Kconfig                  |  16 ++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               | 182 +++++++++++++++------
 kernel/cgroup_freezer.c       |   2 +-
 kernel/cgroup_pids.c          | 367 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |  19 ++-
 kernel/sched/core.c           |   2 +-
 9 files changed, 633 insertions(+), 66 deletions(-)
 create mode 100644 kernel/cgroup_pids.c

-- 
2.3.5
