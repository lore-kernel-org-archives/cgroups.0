From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v5.2-rc1
Date: Thu, 9 May 2019 10:36:42 -0700
Message-ID: <20190509173642.GA374014@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=iom6SqE2pGkNK9Z5BBYeoQQuW8YcGD2ELbPKlGymboM=;
        b=cs0FXI2lpYwghUSDOf097f2v6Rt4diQmigrD+c/Xo1713L8qT08oedAGfjEbWsJUYJ
         Y4uKJTdVdNlH5L2MyZL/0C5q/QLyE+ubVYeRFqZX8QwccR9HwEcpxshclYF2cqqOMnBL
         ArKHoK9IiybB9p/TBSc6izdky9KEgTCNrSG3YfvQ5t+M1AsJdSrAr23HIhrXJJ8a1+OZ
         6DiXvnfAxygTWRdUtaronQth1170tRMp467SFEcmAwqwIOvJSO9k64YUc5qLMAbbjhDT
         KLFHGOIbXHgb3WyyF+MGnwAIvJejG1ZOLF7KZ4/O+H7WoXMreTJzTS7OfgJbDsYUqCGA
         9WDQ==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>, Oleg Nesterov <oleg@redhat.com>

Hello, Linus.

This pull request includes Roman's cgroup2 freezer implementation.
It's a separate machanism from cgroup1 freezer.  Instead of blocking
user tasks in arbitrary uninterruptible sleeps, the new implementation
extends jobctl stop - frozen tasks are trapped in jobctl stop until
thawed and can be killed and ptraced.  Lots of thanks to Oleg for
sheperding the effort.

Other than that, there are a few trivial changes.

Thanks.

The following changes since commit 145f47c7381d43c789cbad55d4dbfd28fc6c46a4:

  Merge tag '5.1-rc3-smb3-fixes' of git://git.samba.org/sfrench/cifs-2.6 (2019-04-03 20:21:25 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.2

for you to fetch changes up to f2b31bb598248c04721cb8485e6091a9feb045ac:

  cgroup: never call do_group_exit() with task->frozen bit set (2019-05-09 07:56:47 -0700)

----------------------------------------------------------------
Fuqian Huang (1):
      kernel: cgroup: fix misuse of %x

Roman Gushchin (12):
      cgroup: rename freezer.c into legacy_freezer.c
      cgroup: implement __cgroup_task_count() helper
      cgroup: protect cgroup->nr_(dying_)descendants by css_set_lock
      cgroup: cgroup v2 freezer
      kselftests: cgroup: don't fail on cg_kill_all() error in cg_destroy()
      kselftests: cgroup: add freezer controller self-tests
      cgroup: make TRACE_CGROUP_PATH irq-safe
      cgroup: add tracing points for cgroup v2 freezer
      cgroup: document cgroup v2 freezer interface
      cgroup: prevent spurious transition into non-frozen state
      cgroup: get rid of cgroup_freezer_frozen_exit()
      cgroup: never call do_group_exit() with task->frozen bit set

Shakeel Butt (1):
      cgroup: remove extra cgroup_migrate_finish() call

Shaokun Zhang (1):
      cgroup: Remove unused cgrp variable

 Documentation/admin-guide/cgroup-v2.rst       |  27 +
 include/linux/cgroup-defs.h                   |  33 +
 include/linux/cgroup.h                        |  43 ++
 include/linux/sched.h                         |   2 +
 include/linux/sched/jobctl.h                  |   2 +
 include/trace/events/cgroup.h                 |  55 ++
 kernel/cgroup/Makefile                        |   4 +-
 kernel/cgroup/cgroup-internal.h               |   8 +-
 kernel/cgroup/cgroup-v1.c                     |  16 -
 kernel/cgroup/cgroup.c                        | 152 ++++-
 kernel/cgroup/debug.c                         |   8 +-
 kernel/cgroup/freezer.c                       | 639 +++++++------------
 kernel/cgroup/legacy_freezer.c                | 481 +++++++++++++++
 kernel/fork.c                                 |   2 +
 kernel/signal.c                               |  66 +-
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 tools/testing/selftests/cgroup/cgroup_util.c  |  58 +-
 tools/testing/selftests/cgroup/cgroup_util.h  |   5 +
 tools/testing/selftests/cgroup/test_freezer.c | 851 ++++++++++++++++++++++++++
 20 files changed, 2012 insertions(+), 443 deletions(-)
 create mode 100644 kernel/cgroup/legacy_freezer.c
 create mode 100644 tools/testing/selftests/cgroup/test_freezer.c

-- 
tejun
