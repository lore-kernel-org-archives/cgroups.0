From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 0/3] cgroups: add pids subsystem
Date: Sat, 14 Mar 2015 15:37:12 +1100
Message-ID: <1426307835-5893-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

This is a revised version of the pids v5 patchset, modified to deal with
several stylistic and correctness issues put forward by Tejun Heo. The
main changes include:

* Add bitmask filtering of for_each_subsys() in the form of
  for_each_subsys_which().

* Revert all succeeded can_fork() callbacks if any one of them fails
  inside cgroup_can_fork().

* Move revert/reapply code to a reapply_fork() callback provided by each
  cgroup controller. It is only run if the association for the specific
  subsystem changed during the interlude between cgroup_can_fork() and
  cgroup_post_fork().

* Pass an opaque pointer between cgroup_*_fork(), which holds the
  "current" task css_set. The css_set is pinned by bumping the refcount
  in cgroup_can_fork() and later unpinned in
  cgroup_{cancel,post}_fork().

* A whole bunch of userland API and stylistic fixes.

Aleksa Sarai (3):
  cgroups: use bitmask to filter for_each_subsys
  cgroups: allow a cgroup subsystem to reject a fork
  cgroups: add a pids subsystem

 include/linux/cgroup.h        |  13 +-
 include/linux/cgroup_subsys.h |   4 +
 init/Kconfig                  |  11 ++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               | 132 +++++++++++++++---
 kernel/cgroup_pids.c          | 301 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |  18 ++-
 7 files changed, 459 insertions(+), 21 deletions(-)
 create mode 100644 kernel/cgroup_pids.c

-- 
2.3.2
