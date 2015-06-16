From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/4] cgroup: separate out cgroup_procs_write_permission() from __cgroup_procs_write()
Date: Tue, 16 Jun 2015 15:10:15 -0400
Message-ID: <1434481817-32001-3-git-send-email-tj@kernel.org>
References: <1434481817-32001-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1DV0dGktp//s1GfgdlOyQOjI9W7V1nIh8H7KLFVvrIA=;
        b=Fp+LcSoKrtUnPmZDTDbG1BIV6HvXklqvVhq+w7JXHBNVYnRvDhCcg4gj2LxL7Vr7A2
         DWxprbJdnSONHgm6SRN13rhRlQm2B+h3tHYHzPDQ6qB8Mlv3hAAWyfyt4BT/e5Y3asUQ
         JELxmpfWKAO68PDQL9mCvHmRDC2rlkwnxExGbCxuv0awlEHdyBv5eKc7WOLSd5xgnwN6
         EhW6bxeINxfzDuueUhXa6UQLrDHdBYv38XZQBZNMwgQqO+RTz3W7X9i3Y5orh7cflOra
         +NQ8Xv6g5ihJQagBh/xWmfx+SfdMNMNWfKvsjgPtPQeOhT3QyZpSW+h4RJCPvG/jB3FK
         DkHA==
In-Reply-To: <1434481817-32001-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Separate out task / process migration permission check from
__cgroup_procs_write() into cgroup_procs_write_permission().

* Permission check is moved right above the actual migration and no
  longer performed while holding rcu_read_lock().
  cgroup_procs_write_permission() uses get_task_cred() / put_cred()
  instead of __task_cred().  Also, !root trying to migrate kthreadd or
  PF_NO_SETAFFINITY tasks will now fail with -EINVAL rather than
  -EACCES which should be fine.

* The same permission check is now performed even when moving self by
  specifying 0 as pid.  This always succeeds so there's no functional
  difference.  We'll add more permission checks later and the benefits
  of keeping both cases consistent outweigh the minute overhead of
  doing perm checks on pid 0 case.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 12b580f..4504d64 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2392,6 +2392,25 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	return ret;
 }
 
+static int cgroup_procs_write_permission(struct task_struct *task)
+{
+	const struct cred *cred = current_cred();
+	const struct cred *tcred = get_task_cred(task);
+	int ret = 0;
+
+	/*
+	 * even if we're attaching all tasks in the thread group, we only
+	 * need to check permissions on one of them.
+	 */
+	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
+	    !uid_eq(cred->euid, tcred->uid) &&
+	    !uid_eq(cred->euid, tcred->suid))
+		ret = -EACCES;
+
+	put_cred(tcred);
+	return ret;
+}
+
 /*
  * Find the task_struct of the task to attach by vpid and pass it along to the
  * function to attach either it or all tasks in its threadgroup. Will lock
@@ -2401,7 +2420,6 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 				    size_t nbytes, loff_t off, bool threadgroup)
 {
 	struct task_struct *tsk;
-	const struct cred *cred = current_cred(), *tcred;
 	struct cgroup *cgrp;
 	pid_t pid;
 	int ret;
@@ -2421,19 +2439,9 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 			ret = -ESRCH;
 			goto out_unlock_rcu;
 		}
-		/*
-		 * even if we're attaching all tasks in the thread group, we
-		 * only need to check permissions on one of them.
-		 */
-		tcred = __task_cred(tsk);
-		if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
-		    !uid_eq(cred->euid, tcred->uid) &&
-		    !uid_eq(cred->euid, tcred->suid)) {
-			ret = -EACCES;
-			goto out_unlock_rcu;
-		}
-	} else
+	} else {
 		tsk = current;
+	}
 
 	if (threadgroup)
 		tsk = tsk->group_leader;
@@ -2451,7 +2459,9 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	get_task_struct(tsk);
 	rcu_read_unlock();
 
-	ret = cgroup_attach_task(cgrp, tsk, threadgroup);
+	ret = cgroup_procs_write_permission(tsk);
+	if (!ret)
+		ret = cgroup_attach_task(cgrp, tsk, threadgroup);
 
 	put_task_struct(tsk);
 	goto out_unlock_threadgroup;
-- 
2.4.3
