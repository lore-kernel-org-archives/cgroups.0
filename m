From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v8 0/4] cgroups: add pids subsystem
Date: Wed,  1 Apr 2015 19:57:17 +1100
Message-ID: <1427878641-5273-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

This is an alternate version of the pids v7 patchset[1]. The main
difference is that this version doesn't add a new callback for
an association change during a fork -- it lets subsystems handle such
cases by themselves by allowing for a private pointer to be passed
around between the callbacks.

* Pass a cgroup_fork_state structure between the
  cgroup_{can,cancel,post}_fork hooks which stores the private opaque
  pointer for each subsystem. This allows for subsystems to decide which
  (if any) state to save in the can_fork callback to refer back to in
  the post_fork callback.

[1]: https://lkml.org/lkml/2015/3/31/1058

Aleksa Sarai (4):
  cgroups: use bitmask to filter for_each_subsys
  cgroups: replace explicit ss_mask checking with for_each_subsys_which
  cgroups: allow a cgroup subsystem to reject a fork
  cgroups: implement the PIDs subsystem

 include/linux/cgroup.h        |  35 +++-
 include/linux/cgroup_subsys.h |   4 +
 init/Kconfig                  |  16 ++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               | 208 ++++++++++++++++++------
 kernel/cgroup_freezer.c       |   2 +-
 kernel/cgroup_pids.c          | 367 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |  31 +++-
 kernel/sched/core.c           |   2 +-
 9 files changed, 608 insertions(+), 58 deletions(-)
 create mode 100644 kernel/cgroup_pids.c

-- 
2.3.4
