From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Mon, 23 Feb 2015 14:08:09 +1100
Message-ID: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

The current state of resource limitation for the number of open
processes (as well as the number of open file descriptors) requires you
to use setrlimit(2), which means that you are limited to resource
limiting process trees rather than resource limiting cgroups (which is
the point of cgroups).

There was a patch to implement this in 2011[1], but that was rejected
because it implemented a general-purpose rlimit subsystem -- which meant
that you couldn't control distinct resource limits in different
heirarchies. This patch implements a resource controller *specifically*
for the number of processes in a cgroup, overcoming this issue.

There has been a similar attempt to implement a resource controller for
the number of open file descriptors[2], which has not been merged
becasue the reasons were dubious. Merely from a "sane interface"
perspective, it should be possible to utilise cgroups to do such
rudimentary resource management (which currently only exists for process
trees).

Aleksa Sarai (2):
  cgroups: allow a cgroup subsystem to reject a fork
  cgroups: add an nproc subsystem

 include/linux/cgroup.h        |   9 ++-
 include/linux/cgroup_subsys.h |   4 +
 init/Kconfig                  |  10 +++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               |  13 ++-
 kernel/cgroup_freezer.c       |   6 +-
 kernel/cgroup_nproc.c         | 181 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |   4 +-
 kernel/sched/core.c           |   3 +-
 9 files changed, 221 insertions(+), 10 deletions(-)
 create mode 100644 kernel/cgroup_nproc.c

[1]: https://lkml.org/lkml/2011/6/19/170
[2]: https://lkml.org/lkml/2014/7/2/640

-- 
2.3.0
