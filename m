From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH v2 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 15:17:17 +1100
Message-ID: <1425010639-16492-1-git-send-email-cyphar@cyphar.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424660891-12719-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

This is an updated version of the nproc patchset[1], in which the forking
cleanup issue has been resolved by adding can_fork and cancel_fork
callbacks to cgroup subsystems. The can_fork callback is run early
enough that it doesn't get called after the "point of no return" where
the process is exposed (which is when fork) is called, and cancel_fork
is run during the cleanup of copy_process if the fork fails due to other
reasons.

[1]: https://lkml.org/lkml/2015/2/22/204

Aleksa Sarai (2):
  cgroups: allow a cgroup subsystem to reject a fork
  cgroups: add an nproc subsystem

 include/linux/cgroup.h        |   9 ++
 include/linux/cgroup_subsys.h |   4 +
 init/Kconfig                  |  10 +++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               |  80 +++++++++++++----
 kernel/cgroup_nproc.c         | 198 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |  12 ++-
 7 files changed, 296 insertions(+), 18 deletions(-)
 create mode 100644 kernel/cgroup_nproc.c

-- 
2.3.1
