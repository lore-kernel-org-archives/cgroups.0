From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-4.4] cgroup: make zombies retain cgroup membership and fix pids controller
Date: Fri,  9 Oct 2015 23:29:27 -0400
Message-ID: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=CcU2GjqNIiB4o1WSV0eyYtjegjoYV4aebnCp+EhdYAk=;
        b=etamAGW9zpwVK+G07EuuYf/xp9q2CCX5o49VshwMy3M6sQ+CH5NKTvokzkr1/rFz8F
         z1t/FsHJRdyH+W/YpzE95odQLkbnT/LvM6XmSn4QfVo+dafIMDOhZ1GO80nWRCWxF0Mx
         e99bJS758DvPBsXlCDwcsdcfKT5ogux8vMcRsSKDBiaSVF3LoEt1Ub54DiwxQjDyuSiU
         7pj/G5mF5doZGXNlxeOP8JO/OUNLMsrnczBF+s7EXcdWF9EQ0PFwdPhT7PiwwFxagaxI
         eYSyZ9nodmdSKQ3NBkOzUnoH/XpESbSbn4z0uRmk/kNrserug36X+B7jFYQiInNznkPQ
         Hc0A==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

cgroup currently disassociates a task from its cgroups on exit and
reassigns it to the root cgroup.  This behavior turns out to be
problematic for several reasons.

* Resources can't be tracked for zombies.  This breaks pids controller
  as zombies escape resource restriction.  A cgroup can easily go way
  above its limits by creating a bunch of zombies.

* It's difficult to tell where zombies came from.  /proc/PID/cgroup
  gets reset to / on exit so given a zombie it's difficult to tell
  from which cgroup the zombie came from.

* It creates an extra work for controllers for no reason.  cpu and
  perf_events controllers implement exit callbacks to switch the
  exiting task's membership to root when just leaving it as-is is
  enough.

Unfortunately, fixing this involves opening a few cans of worms.

* Decoupling tasks being on a css_set from its reference counting so
  that css_set can be pinned w/o tasks being on it and decoupling
  css_set existence from whether a cgroup is populated so that pinning
  a css_set doesn't confuse populated state tracking and populated
  state can be used to decide whether certain operations are allowed.

* Making css task iteration drop css_set_rwsem between iteration steps
  so that internal locking is not exposed to iterator users and
  css_set_rwsem can be converted to a spinlock which can be grabbed
  from task free path.

After this patchset, besides pids controller being fixed, the visible
behavior isn't changed on traditional hierarchies but on the default
hierarchy a zombie reports its cgroup at the time of exit in
/proc/PID/cgroup.  If the cgroup gets removed before the task is
reaped, " (deleted)" is appended to the reported path.

This patchset contains the following 14 patches.

 0001-cgroup-remove-an-unused-parameter-from-cgroup_task_m.patch
 0002-cgroup-make-cgroup-nr_populated-count-the-number-of-.patch
 0003-cgroup-replace-cgroup_has_tasks-with-cgroup_is_popul.patch
 0004-cgroup-move-check_for_release-invocation.patch
 0005-cgroup-relocate-cgroup_-try-get-put.patch
 0006-cgroup-make-css_sets-pin-the-associated-cgroups.patch
 0007-cgroup-make-cgroup_destroy_locked-test-cgroup_is_pop.patch
 0008-cgroup-keep-css_set-and-task-lists-in-chronological-.patch
 0009-cgroup-factor-out-css_set_move_task.patch
 0010-cgroup-reorganize-css_task_iter-functions.patch
 0011-cgroup-don-t-hold-css_set_rwsem-across-css-task-iter.patch
 0012-cgroup-make-css_set_rwsem-a-spinlock-and-rename-it-t.patch
 0013-cgroup-keep-zombies-associated-with-their-original-c.patch
 0014-cgroup-add-cgroup_subsys-free-method-and-use-it-to-f.patch

0001-0007 decouple populated state tracking from css_set existence and
allows css_sets to be pinned without tasks on them.

0008-0012 update css_set task iterator to not hold lock across
iteration steps and replace css_set_rwsem with a spinlock.

0013 makes zombies keep their cgroup associations.  0014 introduces
->exit() method and fixes pids controller.

The patchset is pretty lightly tested and I need to verify that the
corner cases behave as expected.

This patchset is on top of cgroup/for-4.4 a3e72739b7a7 ("cgroup: fix
too early usage of static_branch_disable()") and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-zombies

diffstat follows.  Thanks.

 Documentation/cgroups/cgroups.txt           |    4 
 Documentation/cgroups/unified-hierarchy.txt |    4 
 include/linux/cgroup-defs.h                 |   16 
 include/linux/cgroup.h                      |   14 
 kernel/cgroup.c                             |  522 +++++++++++++++++-----------
 kernel/cgroup_pids.c                        |    8 
 kernel/cpuset.c                             |    2 
 kernel/events/core.c                        |   16 
 kernel/fork.c                               |    1 
 kernel/sched/core.c                         |   16 
 mm/memcontrol.c                             |    2 
 11 files changed, 354 insertions(+), 251 deletions(-)

--
tejun
