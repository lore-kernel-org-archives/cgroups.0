From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for 4.3
Date: Wed, 2 Sep 2015 08:42:43 -0400
Message-ID: <20150902124243.GD22326@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=0sJYgbN4EGFMRzdF/nIlovB7GwcdGZbHEEGimVYAdKQ=;
        b=MylaLs8moEMvHE7JOtA4gBTwLEkcHjGCcRT35fkovC9i95mfNbptwqwVHsvr2qjnjf
         dNTJGskC51GaAPxDV4JwCaaGRKto5QSQK0To1/6uJ1b0R5+Aj2UBoRg0Fgjms2c1LLAB
         /qZrT8nn9hlwphneTghuY9DzEb17nCOICio01zT/cFeBQyFdU5tFQaasmpBRHeKPxH6w
         JPZ5YJwA1FJUbi3lkMpzPbyjsCxYxoUtXpxYSuNNiFUx+dkMyWgnwOja+E1CH1uCvWPp
         Ll5giMvlpMSQIq+lEfT69IF2GQQ9Ype+jz0nizlVxZbmFE0q7Kza2xGu+d7soABqxHfO
         cvQA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

cgroup changes for 4.3.

* A new PIDs controller is added.  It turns out that PIDs are actually
  an independent resource from kmem due to the limited PID space.

* More core preparations for the v2 interface.  Once cpu side
  interface is settled, it should be ready for lifting the devel mask.
  for-4.3-unified-base was temporarily branched so that other trees
  (block) can pull cgroup core changes that blkcg changes depend on.

* A non-critical idr_preload usage bug fix.

Thanks.

The following changes since commit d770e558e21961ad6cfdf0ff7df0eb5d7d4f0754:

  Linux 4.2-rc1 (2015-07-05 11:01:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.3

for you to fetch changes up to 20f1f4b5ffb870631bf4a4e7c7ba10e3528ae6a6:

  Merge branch 'for-4.3-unified-base' into for-4.3 (2015-08-25 14:19:29 -0400)

----------------------------------------------------------------
Aleksa Sarai (4):
      cgroup: allow a cgroup subsystem to reject a fork
      cgroup: implement the PIDs subsystem
      cgroup: add documentation for the PIDs controller
      cgroup: pids: fix invalid get/put usage

Tejun Heo (6):
      cgroup: define controller file conventions
      cgroup: export cgrp_dfl_root
      cgroup: make cftype->private a unsigned long
      cgroup: don't print subsystems for the default hierarchy
      cgroup: introduce cgroup_subsys->legacy_name
      Merge branch 'for-4.3-unified-base' into for-4.3

Vladimir Davydov (1):
      cgroup: fix idr_preload usage

 CREDITS                                     |   5 +
 Documentation/cgroups/00-INDEX              |   2 +
 Documentation/cgroups/pids.txt              |  85 +++++++
 Documentation/cgroups/unified-hierarchy.txt |  80 ++++++-
 include/linux/cgroup-defs.h                 |  15 +-
 include/linux/cgroup.h                      |  24 +-
 include/linux/cgroup_subsys.h               |  28 +++
 init/Kconfig                                |  16 ++
 kernel/Makefile                             |   1 +
 kernel/cgroup.c                             | 122 ++++++++--
 kernel/cgroup_freezer.c                     |   2 +-
 kernel/cgroup_pids.c                        | 355 ++++++++++++++++++++++++++++
 kernel/fork.c                               |  17 +-
 kernel/sched/core.c                         |   2 +-
 14 files changed, 717 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/cgroups/pids.txt
 create mode 100644 kernel/cgroup_pids.c

-- 
tejun
