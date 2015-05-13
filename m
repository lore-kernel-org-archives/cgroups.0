From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] cgroup, sched: restructure threadgroup locking and replace it with a percpu_rwsem
Date: Wed, 13 May 2015 16:35:15 -0400
Message-ID: <1431549318-16756-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=kCEk7bvEo8sM7U5l8TfVQbw2cK2RfNJdg2lUWz/StK0=;
        b=Ns4aZKl3Hd6l73Ju5miU+X0XmmrTZvpJpihiFPBkgNFGkrfm3Dee2HHtCBcsSzG83z
         iUuM1KzQAP6Lf/3ZYgmm6if/H4/J7MJ6TlaVTUjsh+tfqgUUO12CY7mZRFrH+v0pwQ6/
         9wCPhx6ZvEnTJIVOxA/6WIahgjADGzCQEasb26xrUqXfL8m61sBPIu6TGsV2PZdmM+oE
         X0tGIpcb8mzZWROgBl32k3NrCqFJgpGvsfhZ5mquUs92+tpZg1NNcq3ZXWQj1g8I2q5T
         u7gt9xk6LPdTLj5sl32kAAvcqeTTN8RriazDpzaDc8ZOTzS8eM7u1ENyxRbJtcJMAeYP
         9cEA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

threadgroup locking was added because cgroup needs threadgroups to
stay stable across attach operations.  It was implemented as a
per-signal_struct generic locking mechanism so that other users which
require threadgroups stable across blocking operations can use it too;
however, it hasn't grown any other use cases and still conditionalized
on CONFIG_CGROUPS.

It turns out that a single percpu_rwsem would serve cgroup's use case
better as it's lighter on the thread operations and allows atomic
operations across multiple processes.  We can change the generic
threadgroup lock mechanism to do that but it's pointless to put this
in core task code.  What's necessary from the task code is a place
which subsystems needing synchronization against threadgroup
operations can hook into so that they can implement the necessary
exclusion.

This patchset moves the specific locking details into cgroup proper
leaving threadgroup_changes_begin/end() as the section markers and
then converts the cgroup specific locking to use a percp_rwsem.

This patchset contains the following three patches.

 0001-sched-cgroup-reorganize-threadgroup-locking.patch
 0002-sched-cgroup-replace-signal_struct-group_rwsem-with-.patch
 0003-cgroup-simplify-threadgroup-locking.patch

0001 moves threadgroup locking details into cgroup proper.

0002-0003 convert per-signal_struct group_rwsem with a global
percpu_rwsem.

This patchset is on top of

  cgroup/for-4.2 d0f702e648dc ("cgroup: fix some comment typos")
+ [1] [PATCH] cgroup: separate out include/linux/cgroup-defs.h
+ [2] [PATCH] cgroup: reorganize include/linux/cgroup.h

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-threadgroup-percpu-rwsem

diffstat follows.  Thanks.

 include/linux/cgroup-defs.h |   33 ++++++++++++++++++++
 include/linux/init_task.h   |    8 ----
 include/linux/sched.h       |   65 ++++++++++------------------------------
 init/Kconfig                |    1
 kernel/cgroup.c             |   71 ++++++++++++++++----------------------------
 kernel/fork.c               |    4 --
 6 files changed, 78 insertions(+), 104 deletions(-)

--
tejun

[1] http://lkml.kernel.org/g/20150513193840.GC11388-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org
[2] http://lkml.kernel.org/g/20150513202416.GE11388-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org
