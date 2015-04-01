From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v7 0/4] cgroups: add pids subsystem
Date: Wed,  1 Apr 2015 13:31:26 +1100
Message-ID: <1427855490-5280-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

This is a futher revised version of the pids v6 patchset[1]. The main
changes include:

* Actually separate the subsystem callback bitmasks for use with
  for_each_subsys_which(needs_*_callback, ...). Also switch from the
  usage of explicit ss_mask checking with for_each_subsys() with
  for_each_subsys_which().

* Pass an opaque cgroup_fork_state structure between the
  cgroup_{can,cancel,post}_fork hooks which stores the current
  task_struct's css_set. The refcount bumping and dropping is handled
  within cgroup_cfs_{get,put}() respectively. This is done so that
  the internal implementation of cgroup_fork_state is not exposed to
  copy_process(), while also allowing the caller to decide when they
  want to snapshot the current css_set.

* Fix a bug where migrating a task between cgroup hierachies would not
  decrement pids.counter in the source hierarchy. This would cause
  limits to be enforced prematurely due to residual charges on the pid
  counter. This is done by adding a detach() callback that alerts a
  subsystem to a task detaching from it.

[1]: https://lkml.org/lkml/2015/3/14/2

Aleksa Sarai (4):
  cgroups: use bitmask to filter for_each_subsys
  cgroups: replace explicit ss_mask checking with for_each_subsys_which
  cgroups: allow a cgroup subsystem to reject a fork
  cgroups: implement the PIDs subsystem

 include/linux/cgroup.h        |  42 +++++-
 include/linux/cgroup_subsys.h |   4 +
 init/Kconfig                  |  16 +++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               | 244 ++++++++++++++++++++++++++-------
 kernel/cgroup_pids.c          | 310 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |  38 +++++-
 7 files changed, 596 insertions(+), 59 deletions(-)
 create mode 100644 kernel/cgroup_pids.c

-- 
2.3.4
