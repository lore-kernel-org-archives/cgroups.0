From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v3 0/2] cgroup: add pids subsystem
Date: Thu,  5 Mar 2015 07:23:17 +1100
Message-ID: <1425500599-21676-1-git-send-email-cyphar@cyphar.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

This is a further updated version of the nproc v2 patchset[1] from
advice given by Tejun Heo[2]. The main changes include:

* Switching from mm/page_counter (which is a memcg implementation
  feature) to a pid-controller-specific hierarchical charge/uncharge
  counter with limits implementation using atomic_long_t (which is also
  lockless as it is based on page_counter).

* Updates to the user-space interface to allow for the setting of no
  limit to the number of pids in a cgroup (-1 == unlimited) as well as
  renaming of the files and the removal of nproc.max_limit.

* The controller was renamed to `pids`.

[1]: https://lkml.org/lkml/2015/2/26/787
[2]: https://lkml.org/lkml/2015/3/2/437

Aleksa Sarai (2):
  cgroups: allow a cgroup subsystem to reject a fork
  cgroups: add a pids subsystem

 include/linux/cgroup.h        |   9 ++
 include/linux/cgroup_subsys.h |   4 +
 init/Kconfig                  |  12 ++
 kernel/Makefile               |   1 +
 kernel/cgroup.c               |  80 +++++++++---
 kernel/cgroup_pids.c          | 281 ++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |  12 +-
 7 files changed, 381 insertions(+), 18 deletions(-)
 create mode 100644 kernel/cgroup_pids.c

-- 
2.3.1
