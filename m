From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/5] cgroup: convert "tasks" and "cgroup.procs" handle to use cftype->write()
Date: Tue,  6 May 2014 08:44:25 -0400
Message-ID: <1399380266-3324-5-git-send-email-tj@kernel.org>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6oCWc/YHwbV06ws7TdOdVAqg1GVFx9gRH59Xz9gb6LQ=;
        b=Ku/PaLbATDQU/e2rdEP+Z5sJU9aOfrOf7U+oiEEKNYaRRVVEU2jSjudV6bHN9wNKIb
         XsQmgb3D27RqJPnUsp2HalHyROdpc7giFWGRCkx6RoiimU7vtyM1Flc3IvnZurddfOgo
         eDt7D88n3Na6LGs15vCel5oigpuOhqKHqBC3d1pZ19FTH2HCVngEbmeWw7xavrNjyavy
         Eub1GG8H13cmjonIRjp6kIkrZKRDpBNmdRgfGIAka/lwhtc4P5uOWU93+3jD5cqPB+/T
         cEDBc3qxWGlTmTIowVSxO8TI4pGnJ5bbU1W9nIDSc4/K0Q7456oKx/1jLRrIXqYQTgnR
         W2MA==
In-Reply-To: <1399380266-3324-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgroup_tasks_write() and cgroup_procs_write() are currently using
cftype->write_u64().  This patch converts them to use cftype->write()
instead.  This allows access to the associated kernfs_open_file which
will be necessary to implement the planned kernfs active protection
manipulation for these files.

This shifts buffer parsing to attach_task_by_pid() and makes it return
@nbytes on success.  Let's rename it to __cgroup_procs_write() to
clearly indicate that this is a write handler implementation.

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4b340c3..06ad484 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2232,12 +2232,18 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
  * function to attach either it or all tasks in its threadgroup. Will lock
  * cgroup_mutex and threadgroup.
  */
-static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
+static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
+				    size_t nbytes, loff_t off, bool threadgroup)
 {
 	struct task_struct *tsk;
 	const struct cred *cred = current_cred(), *tcred;
+	struct cgroup *cgrp = of_css(of)->cgroup;
+	pid_t pid;
 	int ret;
 
+	if (kstrtoint(strstrip(buf), 0, &pid) || pid < 0)
+		return -EINVAL;
+
 	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
 
@@ -2305,7 +2311,7 @@ retry_find_task:
 	put_task_struct(tsk);
 out_unlock_cgroup:
 	mutex_unlock(&cgroup_mutex);
-	return ret;
+	return ret ?: nbytes;
 }
 
 /**
@@ -2339,16 +2345,16 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
 
-static int cgroup_tasks_write(struct cgroup_subsys_state *css,
-			      struct cftype *cft, u64 pid)
+static ssize_t cgroup_tasks_write(struct kernfs_open_file *of,
+				  char *buf, size_t nbytes, loff_t off)
 {
-	return attach_task_by_pid(css->cgroup, pid, false);
+	return __cgroup_procs_write(of, buf, nbytes, off, false);
 }
 
-static int cgroup_procs_write(struct cgroup_subsys_state *css,
-			      struct cftype *cft, u64 tgid)
+static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
+				  char *buf, size_t nbytes, loff_t off)
 {
-	return attach_task_by_pid(css->cgroup, tgid, true);
+	return __cgroup_procs_write(of, buf, nbytes, off, true);
 }
 
 static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
@@ -3951,7 +3957,7 @@ static struct cftype cgroup_base_files[] = {
 		.seq_stop = cgroup_pidlist_stop,
 		.seq_show = cgroup_pidlist_show,
 		.private = CGROUP_FILE_PROCS,
-		.write_u64 = cgroup_procs_write,
+		.write = cgroup_procs_write,
 		.mode = S_IRUGO | S_IWUSR,
 	},
 	{
@@ -4000,7 +4006,7 @@ static struct cftype cgroup_base_files[] = {
 		.seq_stop = cgroup_pidlist_stop,
 		.seq_show = cgroup_pidlist_show,
 		.private = CGROUP_FILE_TASKS,
-		.write_u64 = cgroup_tasks_write,
+		.write = cgroup_tasks_write,
 		.mode = S_IRUGO | S_IWUSR,
 	},
 	{
-- 
1.9.0
