From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v13 0/5] cgroup: add PIDs subsystem
Date: Sat,  6 Jun 2015 09:42:11 +1000
Message-ID: <1433547736-11707-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

This is a small update to v12 of the pids patchset[1] (most of which was
merged into Tejun's tree, but was later reverted due to some bogus GCC
warnings). The main changes are:

* Fix up include/linux/cgroup.h changes to take into account Tejun's
  refactoring of cgroup.h into cgroup-defs.h.

* Move ->can_attach() and ->cancel_attach() charge/revert into
  ->attach(), since we can't fail and it's simpler to just charge there.

* Remove tset_get_css(), because the premise of its existence is flawed
  and switch ->attach() code to just task_get_css() itself.

* Remove a patch that was rendered uneccesary by the cgroup.h refactor.

* Fix up the for_each_subsys_which patchset so that it doesn't trigger
  a GCC warning when CGROUP_SUBSYS_COUNT = 0, but cgroups are enabled.
  The warning is bogus anyway, since the whole block becomes a noop in
  that case.

[1]: https://lkml.org/lkml/2015/5/18/439

Aleksa Sarai (4):
  cgroup: use bitmask to filter for_each_subsys
  cgroup: replace explicit ss_mask checking with for_each_subsys_which
  cgroup: allow a cgroup subsystem to reject a fork
  cgroup: implement the PIDs subsystem

Tejun Heo (1):
  cgroup, block: implement task_get_css()

 CREDITS                       |   5 +
 include/linux/cgroup-defs.h   |  12 +-
 include/linux/cgroup.h        |  41 ++++-
 include/linux/cgroup_subsys.h |  28 ++++
 init/Kconfig                  |  16 ++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               | 171 +++++++++++++------
 kernel/cgroup_freezer.c       |   2 +-
 kernel/cgroup_pids.c          | 377 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |  17 +-
 kernel/sched/core.c           |   2 +-
 11 files changed, 616 insertions(+), 56 deletions(-)
 create mode 100644 kernel/cgroup_pids.c

-- 
2.4.2
