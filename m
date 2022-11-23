From: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: Optimize update_tasks_nodemask()
Date: Wed, 23 Nov 2022 08:21:57 +0000
Message-ID: <20221123082157.71326-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yo2K84hmvJF9oKmVUE8rVWn5muORVTM6UmA/7exBFUM=;
        b=VmEnvFprI1mHKVy+07lphANsK+RLSjSH8ZZGVFzeZ0SQCYsAvYfb8tQwV+GaQs4jMd
         Fhfh4ZC4WvVGyUc3TlX3vl0ZqD5kHFvh/BahqrDF0S8wapyOl1nAVvuhgDLPI6yPojVw
         LuFg+XX0OxUSgPe8Zq2RVjTjeKnvONyFn0cZRTsjOuIaEo7QUKwVu9hXgIFK9LgJ14Ym
         u3w+77ooTwpLJsCE55lO0l2qS8XmJ7T/0uHynGwdGMPgSlRm37X1Cfy9zcnQgo28/bZd
         G3Tcu28J0Id40ep5xIQ7m6QU0kNdS5nxA2SEjOkuuftUUfY2jdqRM7I4BdF79Ew+iIXI
         HGnA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

When change the 'cpuset.mems' under some cgroup, system will hung
for a long time. From the dmesg, many processes or theads are
stuck in fork/exit. The reason is show as follows.

thread A:
cpuset_write_resmask /* takes cpuset_rwsem */
  ...
    update_tasks_nodemask
      mpol_rebind_mm /* waits mmap_lock */

thread B:
worker_thread
  ...
    cpuset_migrate_mm_workfn
      do_migrate_pages /* takes mmap_lock */

thread C:
cgroup_procs_write /* takes cgroup_mutex and cgroup_threadgroup_rwsem */
  ...
    cpuset_can_attach
      percpu_down_write /* waits cpuset_rwsem */

Once update the nodemasks of cpuset, thread A wakes up thread B to
migrate mm. But when thread A iterates through all tasks, including
child threads and group leader, it has to wait the mmap_lock which
has been take by thread B. Unfortunately, thread C wants to migrate
tasks into cgroup at this moment, it must wait thread A to release
cpuset_rwsem. If thread B spends much time to migrate mm, the
fork/exit which acquire cgroup_threadgroup_rwsem also need to
wait for a long time.

There is no need to migrate the mm of child threads which is
shared with group leader. Just iterate through the group
leader only.

Signed-off-by: haifeng.xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 589827ccda8b..43cbd09546d0 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1968,6 +1968,9 @@ static void update_tasks_nodemask(struct cpuset *cs)
 
 		cpuset_change_task_nodemask(task, &newmems);
 
+		if (!thread_group_leader(task))
+			continue;
+
 		mm = get_task_mm(task);
 		if (!mm)
 			continue;
-- 
2.25.1

