From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cpuset: fix a locking issue in cpuset_migrate_mm()
Date: Thu, 27 Feb 2014 18:19:03 +0800
Message-ID: <530F1117.1020605@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

I can trigger a lockdep warning:

  # mount -t cgroup -o cpuset xxx /cgroup
  # mkdir /cgroup/cpuset
  # mkdir /cgroup/tmp
  # echo 0 > /cgroup/tmp/cpuset.cpus
  # echo 0 > /cgroup/tmp/cpuset.mems
  # echo 1 > /cgroup/tmp/cpuset.memory_migrate
  # echo $$ > /cgroup/tmp/tasks
  # echo 1 > /cgruop/tmp/cpuset.mems

  ===============================
  [ INFO: suspicious RCU usage. ]
  3.14.0-rc1-0.1-default+ #32 Not tainted
  -------------------------------
  include/linux/cgroup.h:682 suspicious rcu_dereference_check() usage!
  ...
    [<ffffffff81582174>] dump_stack+0x72/0x86
    [<ffffffff810b8f01>] lockdep_rcu_suspicious+0x101/0x140
    [<ffffffff81105ba1>] cpuset_migrate_mm+0xb1/0xe0
  ...

We used to hold cgroup_mutex when calling cpuset_migrate_mm(), but now
we hold cpuset_mutex, which causes task_css() to complain.

This is not a false-positive but a real issue.

Holding cpuset_mutex won't prevent a task's cpuset from changing, and
it won't prevent the original task->cgroup from destroying during this
change.

Fixes: 5d21cc2db040 (cpuset: replace cgroup_mutex locking with cpuset internal locking)
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.9+
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d8bec21..5f50ec6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -948,12 +948,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
  *    Temporarilly set tasks mems_allowed to target nodes of migration,
  *    so that the migration code can allocate pages on these nodes.
  *
- *    Call holding cpuset_mutex, so current's cpuset won't change
- *    during this call, as manage_mutex holds off any cpuset_attach()
- *    calls.  Therefore we don't need to take task_lock around the
- *    call to guarantee_online_mems(), as we know no one is changing
- *    our task's cpuset.
- *
  *    While the mm_struct we are migrating is typically from some
  *    other task, the task_struct mems_allowed that we are hacking
  *    is for our current task, which must allocate new pages for that
@@ -970,8 +964,10 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 
 	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
 
+	rcu_read_lock();
 	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
 	guarantee_online_mems(mems_cs, &tsk->mems_allowed);
+	rcu_read_unlock();
 }
 
 /*
-- 
1.8.0.2
