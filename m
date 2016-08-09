From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: add tracepoints for basic operations
Date: Tue, 9 Aug 2016 01:27:03 -0400
Message-ID: <20160809052703.GA4906@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=57gEyBAQpnVCsbJAWnK2VBAXUEFv2CWPDPK/dmbIN8M=;
        b=t4k0ClI7w/bv4D6ZUB8pTcQWGnMhuvE9n968eNoE4DkDJa1ULulE8mRzfWqYOgM35j
         fAkIrSFFKZG2HqU9m3/1gmLIU055jx4H3X3T7KDIoY4/E/KtRlEUIVv3GsLf2utI+4gt
         By6nmwFXGhVVnLii2Z4FkuCL1FtepeFk6/5E2qazZgY0GcqGHgapNdMK/8ciqMmS4WSm
         8WQJUE/60TJrQq4hjPa+2iwuCsom5J3s/EvRKGBtqEKOkqge9RLe2v3ZMndcXU+UpNYA
         32Rc45/7xZkg1P6GRQ2dOkk4UDPtHNOyp56hU1mZ4SZuRU9b0VicWQClrsIeHMeTh2RI
         2EWg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

From 471f89b317a21a78dacaee85957984b9f11e79e4 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 9 Aug 2016 01:11:13 -0400

Debugging what goes wrong with cgroup setup can get hairy.  Add
tracepoints for cgroup hierarchy mount, cgroup creation/destruction
and task migration operations for better visibility.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
This patchset is on top of

  v4.8-rc1 29b4817d4018df78086157ea3a55c1d9424a7cfc
+ [PATCHSET] kernfs, cgroup: make kernfs_path*() and cgroup_path*() behave in strlcpy() style
  http://lkml.kernel.org/r/1470720204-4605-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

and also available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-tracepoints

Thanks.

 include/trace/events/cgroup.h | 163 ++++++++++++++++++++++++++++++++++++++++++
 kernel/cgroup.c               |  25 +++++++
 2 files changed, 188 insertions(+)
 create mode 100644 include/trace/events/cgroup.h

diff --git a/include/trace/events/cgroup.h b/include/trace/events/cgroup.h
new file mode 100644
index 0000000..ab68640
--- /dev/null
+++ b/include/trace/events/cgroup.h
@@ -0,0 +1,163 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM cgroup
+
+#if !defined(_TRACE_CGROUP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_CGROUP_H
+
+#include <linux/cgroup.h>
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(cgroup_root,
+
+	TP_PROTO(struct cgroup_root *root),
+
+	TP_ARGS(root),
+
+	TP_STRUCT__entry(
+		__field(	int,		root			)
+		__field(	u16,		ss_mask			)
+		__string(	name,		root->name		)
+	),
+
+	TP_fast_assign(
+		__entry->root = root->hierarchy_id;
+		__entry->ss_mask = root->subsys_mask;
+		__assign_str(name, root->name);
+	),
+
+	TP_printk("root=%d ss_mask=%#x name=%s",
+		  __entry->root, __entry->ss_mask, __get_str(name))
+);
+
+DEFINE_EVENT(cgroup_root, cgroup_setup_root,
+
+	TP_PROTO(struct cgroup_root *root),
+
+	TP_ARGS(root)
+);
+
+DEFINE_EVENT(cgroup_root, cgroup_destroy_root,
+
+	TP_PROTO(struct cgroup_root *root),
+
+	TP_ARGS(root)
+);
+
+DEFINE_EVENT(cgroup_root, cgroup_remount,
+
+	TP_PROTO(struct cgroup_root *root),
+
+	TP_ARGS(root)
+);
+
+DECLARE_EVENT_CLASS(cgroup,
+
+	TP_PROTO(struct cgroup *cgrp),
+
+	TP_ARGS(cgrp),
+
+	TP_STRUCT__entry(
+		__field(	int,		root			)
+		__field(	int,		id			)
+		__field(	int,		level			)
+		__dynamic_array(char,		path,
+				cgrp->kn ? cgroup_path(cgrp, NULL, 0) + 1
+					 : strlen("(null)"))
+	),
+
+	TP_fast_assign(
+		__entry->root = cgrp->root->hierarchy_id;
+		__entry->id = cgrp->id;
+		__entry->level = cgrp->level;
+		if (cgrp->kn)
+			cgroup_path(cgrp, __get_dynamic_array(path),
+				    __get_dynamic_array_len(path));
+		else
+			__assign_str(path, "(null)");
+	),
+
+	TP_printk("root=%d id=%d level=%d path=%s",
+		  __entry->root, __entry->id, __entry->level, __get_str(path))
+);
+
+DEFINE_EVENT(cgroup, cgroup_mkdir,
+
+	TP_PROTO(struct cgroup *cgroup),
+
+	TP_ARGS(cgroup)
+);
+
+DEFINE_EVENT(cgroup, cgroup_rmdir,
+
+	TP_PROTO(struct cgroup *cgroup),
+
+	TP_ARGS(cgroup)
+);
+
+DEFINE_EVENT(cgroup, cgroup_release,
+
+	TP_PROTO(struct cgroup *cgroup),
+
+	TP_ARGS(cgroup)
+);
+
+DEFINE_EVENT(cgroup, cgroup_rename,
+
+	TP_PROTO(struct cgroup *cgroup),
+
+	TP_ARGS(cgroup)
+);
+
+DECLARE_EVENT_CLASS(cgroup_migrate,
+
+	TP_PROTO(struct cgroup *dst_cgrp, struct task_struct *task, bool threadgroup),
+
+	TP_ARGS(dst_cgrp, task, threadgroup),
+
+	TP_STRUCT__entry(
+		__field(	int,		dst_root		)
+		__field(	int,		dst_id			)
+		__field(	int,		dst_level		)
+		__dynamic_array(char,		dst_path,
+				dst_cgrp->kn ? cgroup_path(dst_cgrp, NULL, 0) + 1
+					     : strlen("(null)"))
+		__field(	int,		pid			)
+		__string(	comm,		task->comm		)
+	),
+
+	TP_fast_assign(
+		__entry->dst_root = dst_cgrp->root->hierarchy_id;
+		__entry->dst_id = dst_cgrp->id;
+		__entry->dst_level = dst_cgrp->level;
+		if (dst_cgrp->kn)
+			cgroup_path(dst_cgrp, __get_dynamic_array(dst_path),
+				    __get_dynamic_array_len(dst_path));
+		else
+			__assign_str(dst_path, "(null)");
+		__entry->pid = task->pid;
+		__assign_str(comm, task->comm);
+	),
+
+	TP_printk("dst_root=%d dst_id=%d dst_level=%d dst_path=%s pid=%d comm=%s",
+		  __entry->dst_root, __entry->dst_id, __entry->dst_level,
+		  __get_str(dst_path), __entry->pid, __get_str(comm))
+);
+
+DEFINE_EVENT(cgroup_migrate, cgroup_attach_task,
+
+	TP_PROTO(struct cgroup *dst_cgrp, struct task_struct *task, bool threadgroup),
+
+	TP_ARGS(dst_cgrp, task, threadgroup)
+);
+
+DEFINE_EVENT(cgroup_migrate, cgroup_transfer_tasks,
+
+	TP_PROTO(struct cgroup *dst_cgrp, struct task_struct *task, bool threadgroup),
+
+	TP_ARGS(dst_cgrp, task, threadgroup)
+);
+
+#endif /* _TRACE_CGROUP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3861161..5e2e81a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -64,6 +64,9 @@
 #include <linux/file.h>
 #include <net/sock.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/cgroup.h>
+
 /*
  * pidlists linger the following amount before being destroyed.  The goal
  * is avoiding frequent destruction in the middle of consecutive read calls
@@ -1176,6 +1179,8 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	struct cgroup *cgrp = &root->cgrp;
 	struct cgrp_cset_link *link, *tmp_link;
 
+	trace_cgroup_destroy_root(root);
+
 	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
 
 	BUG_ON(atomic_read(&root->nr_cgrps));
@@ -1874,6 +1879,9 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 		strcpy(root->release_agent_path, opts.release_agent);
 		spin_unlock(&release_agent_path_lock);
 	}
+
+	trace_cgroup_remount(root);
+
  out_unlock:
 	kfree(opts.release_agent);
 	kfree(opts.name);
@@ -2031,6 +2039,8 @@ static int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	if (ret)
 		goto destroy_root;
 
+	trace_cgroup_setup_root(root);
+
 	/*
 	 * There must be no failure case after here, since rebinding takes
 	 * care of subsystems' refcounts, which are explicitly dropped in
@@ -2825,6 +2835,10 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 		ret = cgroup_migrate(leader, threadgroup, dst_cgrp->root);
 
 	cgroup_migrate_finish(&preloaded_csets);
+
+	if (!ret)
+		trace_cgroup_attach_task(dst_cgrp, leader, threadgroup);
+
 	return ret;
 }
 
@@ -3587,6 +3601,8 @@ static int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	mutex_lock(&cgroup_mutex);
 
 	ret = kernfs_rename(kn, new_parent, new_name_str);
+	if (!ret)
+		trace_cgroup_rename(cgrp);
 
 	mutex_unlock(&cgroup_mutex);
 
@@ -4355,6 +4371,8 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 
 		if (task) {
 			ret = cgroup_migrate(task, false, to->root);
+			if (!ret)
+				trace_cgroup_transfer_tasks(to, task, false);
 			put_task_struct(task);
 		}
 	} while (task && !ret);
@@ -5020,6 +5038,8 @@ static void css_release_work_fn(struct work_struct *work)
 			ss->css_released(css);
 	} else {
 		/* cgroup release path */
+		trace_cgroup_release(cgrp);
+
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 		cgrp->id = -1;
 
@@ -5306,6 +5326,8 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (ret)
 		goto out_destroy;
 
+	trace_cgroup_mkdir(cgrp);
+
 	/* let's create and online css's */
 	kernfs_activate(kn);
 
@@ -5481,6 +5503,9 @@ static int cgroup_rmdir(struct kernfs_node *kn)
 
 	ret = cgroup_destroy_locked(cgrp);
 
+	if (!ret)
+		trace_cgroup_rmdir(cgrp);
+
 	cgroup_kn_unlock(kn);
 	return ret;
 }
-- 
2.7.4
