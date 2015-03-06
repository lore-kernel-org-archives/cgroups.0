From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/2] cgroup: add pids subsystem
Date: Fri,  6 Mar 2015 12:45:55 +1100
Message-ID: <1425606357-6337-1-git-send-email-cyphar@cyphar.com>
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

This is a checkpatch'd version of the pids patchset[1]. It fixes some
style problems, as well as switch to using need_canfork_callback inside
kernel/cgroup.c. Also remove the dependency on PAGE_COUNTER (because
pids now uses an internal hierarchical counter) in Kconfig.

[1]: https://lkml.org/lkml/2015/3/4/1198

Aleksa Sarai (2):
  cgroups: allow a cgroup subsystem to reject a fork
  cgroups: add a pids subsystem

 include/linux/cgroup.h        |   9 ++
 include/linux/cgroup_subsys.h |   4 +
 init/Kconfig                  |  11 ++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               |  82 +++++++++---
 kernel/cgroup_pids.c          | 282 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |  12 +-
 7 files changed, 384 insertions(+), 17 deletions(-)
 create mode 100644 kernel/cgroup_pids.c

-- 
2.3.1
