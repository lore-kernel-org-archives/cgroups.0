From: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Subject: [PATCH] cgroup: add tracepoints to track cgroup events
Date: Wed, 20 Aug 2014 21:46:25 -0600
Message-ID: <1408592785-6700-1-git-send-email-andrea@betterlinux.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=betterlinux.com;
	s=default; t=1408592807;
	bh=CUGoJMvptPz0IJ1NSR1WLTRdUUfiiLMBTJjyEX6pRGo=;
	h=From:To:Cc:Subject:Date:Message-Id;
	b=DMFVjvFKETApyTcmWFq7YO/kgMQsgwWaUB1byr4Dg9gZET2vwe8SA2eDf8QLVtA5W
	 dfFFm9iD/fhqgBZL/zydarwfR+SHRPmdb6s9x6qVPhk39pSJkbNmebRRMqGTcWq6cC
	 bpsJ8CRNPKEOXQtScKLBwCo4dtZUM2fD97lKKCeQ=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>, Matt Heaton <matt-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>

This patch adds the following tracepoints:
 o trace_cgroup_create       when a new cgroup is created
 o trace_cgroup_destroy      when a cgroup is removed
 o trace_cgroup_task_migrate when a task/thread is moved from a cgroup to another

The purpose of these tracepoints is to identify and help cgroup "managers" to
diagnose problems and detect when they are doing an excessive amount of work.

Signed-off-by: Matt Heaton <matt-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Signed-off-by: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
---
 include/trace/events/cgroup.h | 95 +++++++++++++++++++++++++++++++++++++++++++
 kernel/cgroup.c               | 14 ++++++-
 2 files changed, 108 insertions(+), 1 deletion(-)
 create mode 100644 include/trace/events/cgroup.h

diff --git a/include/trace/events/cgroup.h b/include/trace/events/cgroup.h
new file mode 100644
index 0000000..937b41e
--- /dev/null
+++ b/include/trace/events/cgroup.h
@@ -0,0 +1,95 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM cgroup
+
+#if !defined(_TRACE_CGROUP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_CGROUP_H
+
+#include <linux/cgroup.h>
+#include <linux/tracepoint.h>
+
+#define TRACE_CGROUP_PATH_MAX	256
+
+#ifdef CREATE_TRACE_POINTS
+static inline void cgroup_safe_path(struct cgroup *cgrp, char *buf,
+				    size_t buflen)
+{
+	char *path = cgroup_path(cgrp, buf, buflen);
+	size_t len;
+
+	if (likely(path)) {
+		/* NOTE: path is always NULL terminated */
+		len = strlen(path);
+		memmove(buf, path, len);
+		buf[len] = '\0';
+	} else {
+		strncpy(buf, "(NULL)", buflen);
+	}
+}
+#endif
+
+TRACE_EVENT(cgroup_create,
+
+	TP_PROTO(struct cgroup *cgrp),
+
+	TP_ARGS(cgrp),
+
+	TP_STRUCT__entry(
+		__array(char, name, TRACE_CGROUP_PATH_MAX)
+	),
+
+	TP_fast_assign(
+		cgroup_safe_path(cgrp, __entry->name, TRACE_CGROUP_PATH_MAX);
+	),
+
+	TP_printk("%s", __entry->name)
+);
+
+TRACE_EVENT(cgroup_destroy,
+
+	TP_PROTO(struct cgroup *cgrp),
+
+	TP_ARGS(cgrp),
+
+	TP_STRUCT__entry(
+		__array(char, name, TRACE_CGROUP_PATH_MAX)
+	),
+
+	TP_fast_assign(
+		cgroup_safe_path(cgrp, __entry->name, TRACE_CGROUP_PATH_MAX);
+	),
+
+	TP_printk("%s", __entry->name)
+);
+
+TRACE_EVENT(cgroup_task_migrate,
+
+	TP_PROTO(struct cgroup *old_cgrp, struct cgroup *new_cgrp,
+		 const struct task_struct *p),
+
+	TP_ARGS(old_cgrp, new_cgrp, p),
+
+	TP_STRUCT__entry(
+		__field(pid_t, pid)
+		__array(char, old_name, TRACE_CGROUP_PATH_MAX)
+		__array(char, new_name, TRACE_CGROUP_PATH_MAX)
+		__array(char, comm, TASK_COMM_LEN)
+	),
+
+	TP_fast_assign(
+		__entry->pid = p->pid;
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		cgroup_safe_path(old_cgrp, __entry->old_name,
+				 TRACE_CGROUP_PATH_MAX);
+		cgroup_safe_path(new_cgrp, __entry->new_name,
+				 TRACE_CGROUP_PATH_MAX);
+	),
+
+	TP_printk("pid=%d comm=%s from=%s to=%s",
+		  __entry->pid, __entry->comm,
+		  __entry->old_name, __entry->new_name)
+);
+
+#endif /* _TRACE_CGROUP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7dc8788..00a50b9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -60,6 +60,9 @@
 
 #include <linux/atomic.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/cgroup.h>
+
 /*
  * pidlists linger the following amount before being destroyed.  The goal
  * is avoiding frequent destruction in the middle of consecutive read calls
@@ -2014,6 +2017,7 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset)
  * Must be called with cgroup_mutex, threadgroup and css_set_rwsem locked.
  */
 static void cgroup_task_migrate(struct cgroup *old_cgrp,
+				struct cgroup *new_cgrp,
 				struct task_struct *tsk,
 				struct css_set *new_cset)
 {
@@ -2022,6 +2026,8 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
 	lockdep_assert_held(&cgroup_mutex);
 	lockdep_assert_held(&css_set_rwsem);
 
+	trace_cgroup_task_migrate(old_cgrp, new_cgrp, tsk);
+
 	/*
 	 * We are synchronized through threadgroup_lock() against PF_EXITING
 	 * setting such that we can't race against cgroup_exit() changing the
@@ -2274,7 +2280,7 @@ static int cgroup_migrate(struct cgroup *cgrp, struct task_struct *leader,
 	down_write(&css_set_rwsem);
 	list_for_each_entry(cset, &tset.src_csets, mg_node) {
 		list_for_each_entry_safe(task, tmp_task, &cset->mg_tasks, cg_list)
-			cgroup_task_migrate(cset->mg_src_cgrp, task,
+			cgroup_task_migrate(cset->mg_src_cgrp, cgrp, task,
 					    cset->mg_dst_cset);
 	}
 	up_write(&css_set_rwsem);
@@ -2988,6 +2994,7 @@ static int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	if (cgroup_on_dfl(cgrp))
 		return -EPERM;
 
+	trace_cgroup_destroy(cgrp);
 	/*
 	 * We're gonna grab cgroup_mutex which nests outside kernfs
 	 * active_ref.  kernfs_rename() doesn't require active_ref
@@ -3004,6 +3011,9 @@ static int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 
 	kernfs_unbreak_active_protection(kn);
 	kernfs_unbreak_active_protection(new_parent);
+
+	trace_cgroup_create(cgrp);
+
 	return ret;
 }
 
@@ -4587,6 +4597,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 		goto out_free_id;
 	}
 	cgrp->kn = kn;
+	trace_cgroup_create(cgrp);
 
 	/*
 	 * This extra ref will be put in cgroup_free_fn() and guarantees
@@ -4791,6 +4802,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		list_del_init(&cgrp->release_list);
 	raw_spin_unlock(&release_list_lock);
 
+	trace_cgroup_destroy(cgrp);
 	/*
 	 * Remove @cgrp directory along with the base files.  @cgrp has an
 	 * extra ref on its kn.
-- 
1.9.1
