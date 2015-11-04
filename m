From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.4-rc1
Date: Wed, 4 Nov 2015 16:10:29 -0500
Message-ID: <20151104211029.GC396@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=lIVtNU7Bko25XSADnLkWBKUgb4RkbX80fftrN+B534g=;
        b=qiKwpOJNAovqdAN0UMr1zDQw82nDcb5+D5noGF/n9S/3pa27yVwbMl/wGiAYx62ynR
         WZMNwuZj9KttmyDfKz+2Pg048vWZRdol4Lg2QT8TYUDinJLr+VLS/vbak3XzUeh2SF9A
         Y2ALW+4ueoGinynGcg9OmBvLctBQJBxEUj3rpSeUiLLMWViTezk5HcPRy+Wfy0Bdd/QM
         WkoWoGxvTsTQ2fa1H0WuF9P7NzO32pdlIS7geikh5sD1UPvxPg5GiySKA0jLiSg1sWtX
         NU1IQh20rimxSt0Gkc94wY6mw/SSJqQiFIdgmSUVbxdZj3/iS89n7NO3JzNHQLUUHxxD
         9AUQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

cgroup core saw several significant updates this cycle.

* percpu_rwsem for threadgroup locking is reinstated.  This was
  temporarily dropped due to down_write latency issues.  Oleg's rework
  of percpu_rwsem which is scheduled to be merged in this merge window
  resolves the issue.

* On the v2 hierarchy, when controllers are enabled and disabled, all
  operations are atomic and can fail and revert cleanly.  This allows
  ->can_attach() failure which is necessary for cpu RT slices.

* Tasks now stay associated with the original cgroups after exit until
  released.  This allows tracking resources held by zombies
  (e.g. pids) and makes it easy to find out where zombies came from on
  the v2 hierarchy.  The pids controller was broken before these
  changes as zombies escaped the limits; unfortunately, updating this
  behavior required too many invasive changes and I don't think it's a
  good idea to backport them, so the pids controller on 4.3, the first
  version which included the pids controller, will stay broken at
  least until I'm sure about the cgroup core changes.

* Optimization of a couple common tests using static_key.  This
  replaces cgroup_on_dfl() with cgroup_subsys_on_dfl() and causes a
  silent conflict in mm/vmscan.c which causes a build failure.  -mm
  has the updates but for now the following patch fixes the conflict.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7f63a93..e7057af 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -175,7 +175,7 @@ static bool sane_reclaim(struct scan_control *sc)
 	if (!memcg)
 		return true;
 #ifdef CONFIG_CGROUP_WRITEBACK
-	if (cgroup_on_dfl(memcg->css.cgroup))
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return true;
 #endif
 	return false;

Thanks.

The following changes since commit 9badce000e2ce68ba74838a3cd356dde58221c2f:

  cgroup, writeback: don't enable cgroup writeback on traditional hierarchies (2015-09-24 16:48:52 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.4

for you to fetch changes up to d57456753787ab158f906f1f8eb58d54a2ccd9f4:

  cgroup: fix race condition around termination check in css_task_iter_next() (2015-10-29 11:43:05 +0900)

----------------------------------------------------------------
Tejun Heo (39):
      sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem
      cgroup: simplify threadgroup locking
      jump_label: make static_key_enabled() work on static_key_true/false types too
      cgroup: implement static_key based cgroup_subsys_enabled() and cgroup_subsys_on_dfl()
      cgroup: replace cgroup_subsys->disabled tests with cgroup_subsys_enabled()
      cgroup: replace cgroup_on_dfl() tests in controllers with cgroup_subsys_on_dfl()
      cgroup: replace "cgroup.populated" with "cgroup.events"
      cgroup: replace cftype->mode with CFTYPE_WORLD_WRITABLE
      cgroup: relocate cgroup_populate_dir()
      cgroup: make cgroup_addrm_files() clean up after itself on failures
      cgroup: cosmetic updates to rebind_subsystems()
      cgroup: restructure file creation / removal handling
      cgroup: generalize obtaining the handles of and notifying cgroup files
      memcg: generate file modified notifications on "memory.events"
      cpuset: migrate memory only for threadgroup leaders
      cgroup, memcg, cpuset: implement cgroup_taskset_for_each_leader()
      cgroup: reorder cgroup_migrate()'s parameters
      cgroup: separate out taskset operations from cgroup_migrate()
      cgroup: make cgroup_update_dfl_csses() migrate all target processes atomically
      cgroup: Merge branch 'for-4.3-fixes' into for-4.4
      cgroup: fix too early usage of static_branch_disable()
      cgroup: remove an unused parameter from cgroup_task_migrate()
      cgroup: make cgroup->nr_populated count the number of populated css_sets
      cgroup: replace cgroup_has_tasks() with cgroup_is_populated()
      cgroup: move check_for_release() invocation
      cgroup: relocate cgroup_[try]get/put()
      cgroup: make css_sets pin the associated cgroups
      cgroup: make cgroup_destroy_locked() test cgroup_is_populated()
      cgroup: keep css_set and task lists in chronological order
      cgroup: factor out css_set_move_task()
      cgroup: reorganize css_task_iter functions
      cgroup: don't hold css_set_rwsem across css task iteration
      cgroup: make css_set_rwsem a spinlock and rename it to css_set_lock
      cgroup: keep zombies associated with their original cgroups
      cgroup: add cgroup_subsys->free() method and use it to fix pids controller
      cgroup: replace error handling in cgroup_init() with WARN_ON()s
      cgroup: drop cgroup__DEVEL__legacy_files_on_dfl
      blkcg: don't create "io.stat" on the root cgroup
      cgroup: fix race condition around termination check in css_task_iter_next()

 Documentation/cgroups/cgroups.txt           |    4 +
 Documentation/cgroups/unified-hierarchy.txt |   25 +-
 block/blk-cgroup.c                          |    1 +
 block/blk-throttle.c                        |    2 +-
 block/cfq-iosched.c                         |    4 +-
 include/linux/backing-dev.h                 |    5 +-
 include/linux/cgroup-defs.h                 |   76 +-
 include/linux/cgroup.h                      |  129 +--
 include/linux/hugetlb_cgroup.h              |    4 +-
 include/linux/init_task.h                   |    8 -
 include/linux/jump_label.h                  |   18 +-
 include/linux/memcontrol.h                  |    8 +-
 include/linux/sched.h                       |   12 -
 kernel/cgroup.c                             | 1297 +++++++++++++++------------
 kernel/cgroup_pids.c                        |    8 +-
 kernel/cpuset.c                             |   72 +-
 kernel/events/core.c                        |   16 -
 kernel/fork.c                               |    5 +-
 kernel/sched/core.c                         |   16 -
 mm/memcontrol.c                             |   27 +-
 20 files changed, 951 insertions(+), 786 deletions(-)

-- 
tejun
