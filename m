From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 0/7] cgroups: add pids subsystem
Date: Sat, 16 May 2015 14:13:34 +1000
Message-ID: <1431749621-30451-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

This is an updated version of v10 of the pids patchset[1], with a few
quite large-ish updates and improvments:

* Switch all internal cgroup.c bitmasks to use (unsigned long), modify
  for_each_subsys_which() to use for_each_set_bit() [which required some
  other changes]. Also modify for_each_subsys_which() to take the
  pointer to the bitmask as an argument.

* Modify argument order of for_each_subsys_which() so that it follows
  the kernel style of (cursors..., iterable).

* Make naming of prefork / canfork consistent such that all references
  are canfork (such as CGROUP_CANFORK_*).

* A whole bunch of style and naming fixes.

* Remove ->detach and implement it using ->{can,cancel}_attach.

* Remove the cancelfork bitmask -- just do ss->cancel_fork checks since
  it's not a hot path.

* Add subsys_canfork_private{,p}().

* Include Tejun's implementation of task_get_css()[2] so that fork()s
  aren't failed because of a migration operation (which is guaranteed to
  complete in constant time).

* Switch valid input value range for `pids.max` to [0, PIDS_MAX), to
  make the interface more consistent (so that you can't input a value
  that translates to "max" transparently).

* Fixed up a whole bunch of comments that were too pids-specific or not
  explicit enough.

[1]: https://lkml.org/lkml/2015/4/19/39
[2]: http://lkml.kernel.org/g/1428350318-8215-8-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Aleksa Sarai (6):
  cgroup: switch to unsigned long for bitmasks
  cgroup: use bitmask to filter for_each_subsys
  cgroup: replace explicit ss_mask checking with for_each_subsys_which
  cgroup: move enum cgroup_subsys_id definition
  cgroup: allow a cgroup subsystem to reject a fork
  cgroup: implement the PIDs subsystem

Tejun Heo (1):
  cgroup, block: implement task_get_css() and use it in
    bio_associate_current()

 CREDITS                       |   5 +
 block/bio.c                   |  11 +-
 include/linux/cgroup.h        |  76 +++++++--
 include/linux/cgroup_subsys.h |  22 +++
 init/Kconfig                  |  16 ++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               | 215 ++++++++++++++++--------
 kernel/cgroup_freezer.c       |   2 +-
 kernel/cgroup_pids.c          | 379 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |  17 +-
 kernel/sched/core.c           |   2 +-
 11 files changed, 652 insertions(+), 94 deletions(-)
 create mode 100644 kernel/cgroup_pids.c

-- 
2.4.1
