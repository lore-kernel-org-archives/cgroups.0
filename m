From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v5.3-rc1
Date: Mon, 8 Jul 2019 10:10:05 -0700
Message-ID: <20190708171005.GG657710@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=BdKgnrOU06X/Q8S32FIzC7gdOJEflmilCgUnr8XW8Uo=;
        b=fzo2ZCAFTzMmFJzkdRl+282iXZMLC1B8DcfQnfKKCF6eSHkIfKS3jaHlbbozr54zVQ
         t9P4Idy3pi9FO8UhmrQTi1VqveI0S/NbmPYoGqe56988OJF01xM64cks05Hzv6XO+era
         y7zJpaeUz05G9e2CPc/e4XUOModyaVHABcfrFeeZIeGuXPbB/CoS9Hcs6vIFw/QsRVfh
         AQBT6UNuMzGXUxZMPXSPIklxUoLAxFMp87ZR5sLo+CYsvmcZQC+/FRbgPJuua62cBWJL
         m2NpSPN/hu02oh4+qA1unN+tA+fpk7KWgYt+i6a0jN8VV+bgvwgnTxBhQv82st4vquUJ
         CGnA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello, Linus.

Documentation updates and the addition of cgroup_parse_float() which
will be used by new controllers including blk-iocost.

Thanks.

The following changes since commit c596687a008b579c503afb7a64fcacc7270fae9e:

  cgroup: Fix css_task_iter_advance_css_set() cset skip condition (2019-06-10 09:08:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.3

for you to fetch changes up to 99c8b231ae6c6ca4ca2fd1c0b3701071f589661f:

  docs: cgroup-v1: convert docs to ReST and rename to *.rst (2019-06-14 13:29:54 -0700)

----------------------------------------------------------------
Mauro Carvalho Chehab (1):
      docs: cgroup-v1: convert docs to ReST and rename to *.rst

Tejun Heo (3):
      cgroup: add cgroup_parse_float()
      Merge branch 'for-5.2-fixes' into for-5.3
      cgroup: Move cgroup_parse_float() implementation out of CONFIG_SYSFS

 Documentation/admin-guide/cgroup-v2.rst            |   6 +
 Documentation/admin-guide/hw-vuln/l1tf.rst         |   2 +-
 Documentation/admin-guide/kernel-parameters.txt    |   4 +-
 .../admin-guide/mm/numa_memory_policy.rst          |   2 +-
 Documentation/block/bfq-iosched.txt                |   2 +-
 .../{blkio-controller.txt => blkio-controller.rst} |  96 +++--
 .../cgroup-v1/{cgroups.txt => cgroups.rst}         | 186 +++++----
 .../cgroup-v1/{cpuacct.txt => cpuacct.rst}         |  15 +-
 .../cgroup-v1/{cpusets.txt => cpusets.rst}         | 209 ++++++----
 .../cgroup-v1/{devices.txt => devices.rst}         |  40 +-
 ...freezer-subsystem.txt => freezer-subsystem.rst} |  14 +-
 .../cgroup-v1/{hugetlb.txt => hugetlb.rst}         |  41 +-
 Documentation/cgroup-v1/index.rst                  |  30 ++
 .../cgroup-v1/{memcg_test.txt => memcg_test.rst}   | 265 +++++++-----
 Documentation/cgroup-v1/{memory.txt => memory.rst} | 463 +++++++++++++--------
 .../cgroup-v1/{net_cls.txt => net_cls.rst}         |  37 +-
 .../cgroup-v1/{net_prio.txt => net_prio.rst}       |  24 +-
 Documentation/cgroup-v1/{pids.txt => pids.rst}     |  82 ++--
 Documentation/cgroup-v1/{rdma.txt => rdma.rst}     |  66 +--
 Documentation/filesystems/tmpfs.txt                |   2 +-
 Documentation/scheduler/sched-deadline.txt         |   2 +-
 Documentation/scheduler/sched-design-CFS.txt       |   2 +-
 Documentation/scheduler/sched-rt-group.txt         |   2 +-
 Documentation/vm/numa.rst                          |   4 +-
 Documentation/vm/page_migration.rst                |   2 +-
 Documentation/vm/unevictable-lru.rst               |   2 +-
 Documentation/x86/x86_64/fake-numa-for-cpusets.rst |   4 +-
 MAINTAINERS                                        |   2 +-
 block/Kconfig                                      |   2 +-
 include/linux/cgroup-defs.h                        |   2 +-
 include/linux/cgroup.h                             |   2 +
 include/uapi/linux/bpf.h                           |   2 +-
 init/Kconfig                                       |   2 +-
 kernel/cgroup/cgroup.c                             |  43 ++
 kernel/cgroup/cpuset.c                             |   2 +-
 security/device_cgroup.c                           |   2 +-
 tools/include/uapi/linux/bpf.h                     |   2 +-
 37 files changed, 1017 insertions(+), 648 deletions(-)
 rename Documentation/cgroup-v1/{blkio-controller.txt => blkio-controller.rst} (90%)
 rename Documentation/cgroup-v1/{cgroups.txt => cgroups.rst} (88%)
 rename Documentation/cgroup-v1/{cpuacct.txt => cpuacct.rst} (90%)
 rename Documentation/cgroup-v1/{cpusets.txt => cpusets.rst} (90%)
 rename Documentation/cgroup-v1/{devices.txt => devices.rst} (88%)
 rename Documentation/cgroup-v1/{freezer-subsystem.txt => freezer-subsystem.rst} (95%)
 rename Documentation/cgroup-v1/{hugetlb.txt => hugetlb.rst} (70%)
 create mode 100644 Documentation/cgroup-v1/index.rst
 rename Documentation/cgroup-v1/{memcg_test.txt => memcg_test.rst} (62%)
 rename Documentation/cgroup-v1/{memory.txt => memory.rst} (71%)
 rename Documentation/cgroup-v1/{net_cls.txt => net_cls.rst} (50%)
 rename Documentation/cgroup-v1/{net_prio.txt => net_prio.rst} (71%)
 rename Documentation/cgroup-v1/{pids.txt => pids.rst} (62%)
 rename Documentation/cgroup-v1/{rdma.txt => rdma.rst} (79%)

-- 
tejun
