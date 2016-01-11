From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.5-rc1
Date: Mon, 11 Jan 2016 15:06:07 -0500
Message-ID: <20160111200607.GK1898@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=eEtlSU6rXNnPDQAd9qzBr2LZ8L4/+dxJetsl7FlVIyQ=;
        b=n/j8KlWJfxmBQjb4xGbIwxnWogzDInNMuD52orD/3wI8dUbODWtPvsA8Q3tuHkAwTj
         BPztDZVuHmu+i8mEay/E5uVR8qhUfmhSlQwnt2ALJoEL5wubGI3yzz4AJPddVkD966a5
         HFThW0iSa5eddjx9ZeOT1KiX8phpW7VMpHHVVZRshEj0sh4Flf5Z2fiUHi93fnWj+xrA
         xcfJ/Vk+T5CYid+NTYexWdT2GY/YXPG9wdmloZy3x1nj20JHbBpz34mgJmslYfmRrVI6
         a/r8NLZmzsQNU+qdEGrTSWF2iloeyWo6KjBE15L7uwVaFV2uA0jt6L4KIm9093KagEyk
         dxkg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

cgroup changes for v4.5-rc1.

* cgroup v2 interface is now official.  It's no longer hidden behind a
  devel flag and can be mounted using the new cgroup2 fs type.
  Unfortunately, cpu v2 interface hasn't made it yet due to the
  discussion around in-process hierarchical resource distribution and
  only memory and io controllers can be used on the v2 interface at
  the moment.

* The existing documentation which has always been a bit of mess is
  relocated under Documentation/cgroup-legacy/.
  Documentation/cgroup.txt is added as the authoritative documentation
  for the v2 interface.

* Some features are added through for-4.5-ancestor-test branch to
  enable netfilter xt_cgroup match to use cgroup v2 paths.  The actual
  netfilter changes will be merged through the net tree which pulled
  in the said branch.

* Various cleanups.

Thanks.

The following changes since commit 67cde9c4938945b9510730c64e68d2f1dd7bc0aa:

  cgroup_pids: don't account for the root cgroup (2015-12-03 10:18:21 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.5

for you to fetch changes up to 2cfa2b191e56fd4c5c6ffb72e1d1e82ed225676d:

  cgroup: fix a typo. (2016-01-10 12:26:45 -0500)

----------------------------------------------------------------
Arnd Bergmann (1):
      cpuset: Replace all instances of time_t with time64_t

Johannes Weiner (2):
      cgroup: clean up the kernel configuration menu nomenclature
      cgroup: put controller Kconfig options in meaningful order

Oleg Nesterov (1):
      cgroup: kill cgrp_ss_priv[CGROUP_CANFORK_COUNT] and friends

Rami Rosen (2):
      cgroup_pids: fix a typo.
      cgroup: fix a typo.

Ross Zwisler (1):
      cgroup: Fix uninitialized variable warning

Tejun Heo (9):
      cgroup: replace __DEVEL__sane_behavior with cgroup2 fs type
      cgroup: rename Documentation/cgroups/ to Documentation/cgroup-legacy/
      cgroup: replace unified-hierarchy.txt with a proper cgroup v2 documentation
      cgroup: record ancestor IDs and reimplement cgroup_is_descendant() using it
      kernfs: implement kernfs_walk_and_get()
      cgroup: implement cgroup_get_from_path() and expose cgroup_put()
      Merge branch 'for-4.4-fixes' into for-4.5
      Merge branch 'for-4.5-ancestor-test' of git://git.kernel.org/.../tj/cgroup into for-4.5
      cgroup: demote subsystem init messages to KERN_DEBUG

Yuan Sun (2):
      Subject: cgroup: Fix incomplete dd command in blkio documentation
      cgroup: Remove resource_counter.txt in Documentation/cgroup-legacy/00-INDEX.

 Documentation/{cgroups => cgroup-legacy}/00-INDEX  |    2 -
 .../blkio-controller.txt                           |   82 +-
 .../{cgroups => cgroup-legacy}/cgroups.txt         |    0
 .../{cgroups => cgroup-legacy}/cpuacct.txt         |    0
 .../{cgroups => cgroup-legacy}/cpusets.txt         |    0
 .../{cgroups => cgroup-legacy}/devices.txt         |    0
 .../freezer-subsystem.txt                          |    0
 .../{cgroups => cgroup-legacy}/hugetlb.txt         |    0
 .../{cgroups => cgroup-legacy}/memcg_test.txt      |    0
 .../{cgroups => cgroup-legacy}/memory.txt          |    0
 .../{cgroups => cgroup-legacy}/net_cls.txt         |    0
 .../{cgroups => cgroup-legacy}/net_prio.txt        |    0
 Documentation/{cgroups => cgroup-legacy}/pids.txt  |    0
 Documentation/cgroup.txt                           | 1293 ++++++++++++++++++++
 Documentation/cgroups/unified-hierarchy.txt        |  647 ----------
 fs/kernfs/dir.c                                    |   46 +
 include/linux/cgroup-defs.h                        |   27 +-
 include/linux/cgroup.h                             |   44 +-
 include/linux/cgroup_subsys.h                      |   18 -
 include/linux/kernfs.h                             |   12 +
 include/uapi/linux/magic.h                         |    1 +
 init/Kconfig                                       |  241 ++--
 kernel/cgroup.c                                    |  152 +--
 kernel/cgroup_freezer.c                            |    2 +-
 kernel/cgroup_pids.c                               |    6 +-
 kernel/cpuset.c                                    |   12 +-
 kernel/fork.c                                      |    7 +-
 kernel/sched/core.c                                |    2 +-
 mm/memcontrol.c                                    |    2 +-
 29 files changed, 1607 insertions(+), 989 deletions(-)
 rename Documentation/{cgroups => cgroup-legacy}/00-INDEX (95%)
 rename Documentation/{cgroups => cgroup-legacy}/blkio-controller.txt (80%)
 rename Documentation/{cgroups => cgroup-legacy}/cgroups.txt (100%)
 rename Documentation/{cgroups => cgroup-legacy}/cpuacct.txt (100%)
 rename Documentation/{cgroups => cgroup-legacy}/cpusets.txt (100%)
 rename Documentation/{cgroups => cgroup-legacy}/devices.txt (100%)
 rename Documentation/{cgroups => cgroup-legacy}/freezer-subsystem.txt (100%)
 rename Documentation/{cgroups => cgroup-legacy}/hugetlb.txt (100%)
 rename Documentation/{cgroups => cgroup-legacy}/memcg_test.txt (100%)
 rename Documentation/{cgroups => cgroup-legacy}/memory.txt (100%)
 rename Documentation/{cgroups => cgroup-legacy}/net_cls.txt (100%)
 rename Documentation/{cgroups => cgroup-legacy}/net_prio.txt (100%)
 rename Documentation/{cgroups => cgroup-legacy}/pids.txt (100%)
 create mode 100644 Documentation/cgroup.txt
 delete mode 100644 Documentation/cgroups/unified-hierarchy.txt

-- 
tejun
