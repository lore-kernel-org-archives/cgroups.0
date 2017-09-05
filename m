From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v4.14-rc1
Date: Tue, 5 Sep 2017 07:39:31 -0700
Message-ID: <20170905143931.GI1774378@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=pic5lCzWfqkaqx+01iCOVd8XCNs/qwgrO1Z8RiN7kzY=;
        b=PH2FLLZipRY7Q15VU+NpvH20OQQ0KCbWXbqKfIxhKGHr/Cek+PYDxXdkkS1NDXI877
         /PaMEpS3WXnkra9F0waF5scr8q0PUR4AlDTYMc9UPf3FJjaOzugPYGfMmtCPI5WTioFl
         pGxG/PtdntnT0LyaMi/tKgAwQINsD+zYpJ9wuX317Du5zIOWt7FRIT/iLpkUH/cplqmp
         SStCbLJJNxNAAkjJXxBWvu03PtijmCBVXyNHpzNevnEGgoD2CmsgmoWXMrblDYVGYpUH
         RSi/ofaKUdIFJS77z5j7jjkm5D3h+oVryPh/24xBvdorHqDSzvpUOBfZMLLVuBksEEnJ
         2kIg==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello, Linus.

Several notable changes this cycle.

* Thread mode was merged.  This will be used for cgroup2 support for
  CPU and possibly other controllers.  Unfortunately, CPU controller
  cgroup2 support didn't make this pull request but most contentions
  have been resolved and the support is likely to be merged before the
  next merge window.

* cgroup.stat now shows the number of descendant cgroups.

* cpuset now can enable the easier-to-configure v2 behavior on v1
  hierarchy.

Thanks.

The following changes since commit 5771a8c08880cdca3bfb4a3fc6d309d6bba20877:

  Linux v4.13-rc1 (2017-07-15 15:22:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.14

for you to fetch changes up to b8d1b8ee93df8ffbabbeadd65d39853cfad6d698:

  cpuset: Allow v2 behavior in v1 cgroup (2017-08-18 08:24:22 -0700)

----------------------------------------------------------------
Dan Carpenter (1):
      cgroup: remove unneeded checks

Roman Gushchin (4):
      cgroup: keep track of number of descent cgroups
      cgroup: implement hierarchy limits
      cgroup: add cgroup.stat interface with basic hierarchy stats
      cgroup: re-use the parent pointer in cgroup_destroy_locked()

Tejun Heo (13):
      cgroup: update outdated cgroup.procs documentation
      cgroup: remove now unused list_head @pending in cgroup_apply_cftypes()
      cgroup: distinguish local and children populated states
      cgroup: replace css_set walking populated test with testing cgrp->nr_populated_csets
      cgroup: reorganize cgroup.procs / task write path
      cgroup: add @flags to css_task_iter_start() and implement CSS_TASK_ITER_PROCS
      cgroup: introduce cgroup->dom_cgrp and threaded css_set handling
      cgroup: implement CSS_TASK_ITER_THREADED
      cgroup: implement cgroup v2 thread support
      cgroup: remove unnecessary empty check when enabling threaded mode
      cgroup: add comment to cgroup_enable_threaded()
      cgroup: short-circuit cset_cgroup_from_root() on the default hierarchy
      cgroup: misc changes

Waiman Long (3):
      cgroup: update debug controller to print out thread mode information
      cgroup: Add mount flag to enable cpuset to use v2 behavior in v1 cgroup
      cpuset: Allow v2 behavior in v1 cgroup

 Documentation/cgroup-v2.txt     | 221 +++++++++-
 include/linux/cgroup-defs.h     |  68 ++-
 include/linux/cgroup.h          |  39 +-
 kernel/cgroup/cgroup-internal.h |  12 +-
 kernel/cgroup/cgroup-v1.c       |  75 +++-
 kernel/cgroup/cgroup.c          | 947 +++++++++++++++++++++++++++++++---------
 kernel/cgroup/cpuset.c          |  39 +-
 kernel/cgroup/debug.c           |  53 ++-
 kernel/cgroup/freezer.c         |   6 +-
 kernel/cgroup/pids.c            |   1 +
 kernel/events/core.c            |   1 +
 mm/memcontrol.c                 |   2 +-
 net/core/netclassid_cgroup.c    |   2 +-
 13 files changed, 1194 insertions(+), 272 deletions(-)

-- 
tejun
