From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v12 0/8] cgroup: add pids subsystem
Date: Tue, 19 May 2015 00:50:59 +1000
Message-ID: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

This is a small update to v11 of the pids patchset[1], including:

* Fix up (incorrect) commit messages.
* Remove defunct code.
* Modify subsys_canfork_private{,p} signatures to use
  (void *[SUBSYS_CANFORK_COUNT]).

[1]: https://lkml.org/lkml/2015/5/16/1

Aleksa Sarai (7):
  cgroup: switch to unsigned long for bitmasks
  cgroup: use bitmask to filter for_each_subsys
  cgroup: replace explicit ss_mask checking with for_each_subsys_which
  cgroup: move enum cgroup_subsys_id definition
  cgroup: allow a cgroup subsystem to reject a fork
  cgroup: add a tset_get_css macro
  cgroup: implement the PIDs subsystem

Tejun Heo (1):
  cgroup, block: implement task_get_css() and use it in
    bio_associate_current()

 CREDITS                       |   5 +
 block/bio.c                   |  11 +-
 include/linux/cgroup.h        |  80 ++++++++--
 include/linux/cgroup_subsys.h |  22 +++
 init/Kconfig                  |  16 ++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               | 216 +++++++++++++++++--------
 kernel/cgroup_freezer.c       |   2 +-
 kernel/cgroup_pids.c          | 355 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |  17 +-
 kernel/sched/core.c           |   2 +-
 11 files changed, 633 insertions(+), 94 deletions(-)
 create mode 100644 kernel/cgroup_pids.c

-- 
2.4.1
