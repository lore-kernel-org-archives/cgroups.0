From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH] cgroup: Fix deadlock in cpu hotplug path
Date: Tue, 19 Dec 2017 12:56:57 +0530
Message-ID: <1513668417-26785-1-git-send-email-prsood@codeaurora.org>
References: <b50d7b64-121f-9a4c-5269-aec9a73787ba@codeaurora.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513668431;
        bh=eSNzE7tJyPuLUED7+x6BK2Zws9oi/Sd/xXOT/BBjBYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSPczLAV9HKtcCXC0xbxX8+pCncsaT8bwX/2umURYudulifUF6stq670SF8Fe7fdH
         Gy7YIaCNNdNbexwEDsIqOtiTwUJTF1NlymBdEyCs3G6UrS8ctShpjNEK60Q5isoC3P
         qWVZ0G17KsuYEYypqg/0LkSmw/vYX/j6C/vvanSo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513668430;
        bh=eSNzE7tJyPuLUED7+x6BK2Zws9oi/Sd/xXOT/BBjBYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bhgqP9No9h14vMs+XQKUlZ5l1lxNgqAjsqjk33tXMpXgPwjL2c/8KpFq0zfYt8EXI
         PqmxxtGWsQyBlRfk54PZDxJ9WCPXnXgRe4w9/K8PhyOhcdru46LSFo43KS8lXJTF8X
         9hBlLvoUYJtGtQzE8/3B4mtlfutkf+M606oaF1F4=
In-Reply-To: <b50d7b64-121f-9a4c-5269-aec9a73787ba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Deadlock during cgroup migration from cpu hotplug path when a task T is
being moved from source to destination cgroup.

kworker/0:0
cpuset_hotplug_workfn()
   cpuset_hotplug_update_tasks()
      hotplug_update_tasks_legacy()
        remove_tasks_in_empty_cpuset()
          cgroup_transfer_tasks() // stuck in iterator loop
            cgroup_migrate()
              cgroup_migrate_add_task()

In cgroup_migrate_add_task() it checks for PF_EXITING flag of task T.
Task T will not migrate to destination cgroup. css_task_iter_start()
will keep pointing to task T in loop waiting for task T cg_list node
to be removed.

Task T
do_exit()
  exit_signals() // sets PF_EXITING
  exit_task_namespaces()
    switch_task_namespaces()
      free_nsproxy()
        put_mnt_ns()
          drop_collected_mounts()
            namespace_unlock()
              synchronize_rcu()
                _synchronize_rcu_expedited()
                  schedule_work() // on cpu0 low priority worker pool
                  wait_event() // waiting for work item to execute

Task T inserted a work item in the worklist of cpu0 low priority
worker pool. It is waiting for expedited grace period work item
to execute. This work item will only be executed once kworker/0:0
complete execution of cpuset_hotplug_workfn().

kworker/0:0 ==> Task T ==>kworker/0:0

In case of PF_EXITING task being migrated from source to destination
cgroup, migrate next available task in source cgroup.

Change-Id: I8874fb04479c136cae4dabd5c168c7749df66664
Signed-off-by: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 024085d..a2c05d2 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -123,7 +123,11 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	 */
 	do {
 		css_task_iter_start(&from->self, 0, &it);
-		task = css_task_iter_next(&it);
+
+		do {
+			task = css_task_iter_next(&it);
+		} while (task && (task->flags & PF_EXITING));
+
 		if (task)
 			get_task_struct(task);
 		css_task_iter_end(&it);
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., 
is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
