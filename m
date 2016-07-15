From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [PATCH 2/3] cgroupns: Close race between cgroup_post_fork and copy_cgroup_ns
Date: Fri, 15 Jul 2016 00:16:34 -0500
Message-ID: <87wpkn32h9.fsf@x220.int.ebiederm.org>
References: <87h9br4h80.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87h9br4h80.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Fri, 15 Jul 2016 00:12:47 -0500")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


In most code paths involving cgroup migration cgroup_threadgroup_rwsem
is taken.  There are two exceptions:

- remove_tasks_in_empty_cpuset calls cgroup_transfer_tasks
- vhost_attach_cgroups_work calls cgroup_attach_task_all

With cgroup_threadgroup_rwsem held it is guaranteed that cgroup_post_fork
and copy_cgroup_ns will reference the same css_set from the process calling
fork.

Without such an interlock there process after fork could reference one
css_set from it's new cgroup namespace and another css_set from
task->cgroups, which semantically is nonsensical.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 66d2441f6db2..c99b0bcd2647 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2956,6 +2956,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 	int retval = 0;
 
 	mutex_lock(&cgroup_mutex);
+	percpu_down_write(&cgroup_threadgroup_rwsem);
 	for_each_root(root) {
 		struct cgroup *from_cgrp;
 
@@ -2970,6 +2971,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 		if (retval)
 			break;
 	}
+	percpu_up_write(&cgroup_threadgroup_rwsem);
 	mutex_unlock(&cgroup_mutex);
 
 	return retval;
@@ -4337,6 +4339,8 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 
 	mutex_lock(&cgroup_mutex);
 
+	percpu_down_write(&cgroup_threadgroup_rwsem);
+
 	/* all tasks in @from are being moved, all csets are source */
 	spin_lock_bh(&css_set_lock);
 	list_for_each_entry(link, &from->cset_links, cset_link)
@@ -4365,6 +4369,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	} while (task && !ret);
 out_err:
 	cgroup_migrate_finish(&preloaded_csets);
+	percpu_up_write(&cgroup_threadgroup_rwsem);
 	mutex_unlock(&cgroup_mutex);
 	return ret;
 }
-- 
2.8.3
