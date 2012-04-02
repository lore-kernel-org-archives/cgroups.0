From: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC] patch
Date: Mon, 02 Apr 2012 08:22:14 +0400
Message-ID: <4F792976.4090503@samsung.com>
References: <4F7928BE.8000502@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_GfRcHUF1NjqdNQofyaSE2A)"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4F7928BE.8000502-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

This is a multi-part message in MIME format.

--Boundary_(ID_GfRcHUF1NjqdNQofyaSE2A)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT




-- 
Best regards,
      Alex Nikiforov,
      Mobile SW, Advanced Software Group,
      Moscow R&D center, Samsung Electronics


--Boundary_(ID_GfRcHUF1NjqdNQofyaSE2A)
Content-type: text/x-patch; name=cgroup-task-event.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=cgroup-task-event.patch

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e9b6021..86b0031 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -192,6 +192,11 @@ struct cgroup_pidlist {
 	struct rw_semaphore mutex;
 };
 
+struct fe_eventfd_list {
+	struct list_head list;
+	struct eventfd_ctx *eventfd;
+};
+
 struct cgroup {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
@@ -243,6 +248,10 @@ struct cgroup {
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
+
+	/* fork-exit event */
+	struct list_head fe_notify;
+	spinlock_t fe_list_lock;
 };
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5d3b53..6c5dda9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1336,6 +1336,8 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->css_sets);
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
+	INIT_LIST_HEAD(&cgrp->fe_notify);
+	spin_lock_init(&cgrp->fe_list_lock);
 	mutex_init(&cgrp->pidlist_mutex);
 	INIT_LIST_HEAD(&cgrp->event_list);
 	spin_lock_init(&cgrp->event_list_lock);
@@ -3659,6 +3661,38 @@ static int cgroup_clone_children_write(struct cgroup *cgrp,
 	return 0;
 }
 
+static int tasks_register_event(struct cgroup *cgrp,
+	struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
+{
+	struct fe_eventfd_list *ev;
+
+	ev = kmalloc(sizeof(*ev), GFP_KERNEL);
+	if(!ev)
+		return -ENOMEM;
+
+	spin_lock(&cgrp->fe_list_lock);
+	ev->eventfd = eventfd;
+	list_add(&ev->list, &cgrp->fe_notify);
+	spin_unlock(&cgrp->fe_list_lock);
+
+	return 0;
+}
+
+static void tasks_unregister_event(struct cgroup *cgrp,
+	struct cftype *cft, struct eventfd_ctx *eventfd)
+{
+	struct fe_eventfd_list *ev, *tmp;
+
+	spin_lock(&cgrp->fe_list_lock);
+	list_for_each_entry_safe(ev, tmp, &cgrp->fe_notify, list) {
+		if (ev->eventfd == eventfd) {
+			list_del(&ev->list);
+			kfree(ev);
+		}
+	}
+	spin_unlock(&cgrp->fe_list_lock);
+}
+
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -3670,6 +3704,8 @@ static struct cftype files[] = {
 		.open = cgroup_tasks_open,
 		.write_u64 = cgroup_tasks_write,
 		.release = cgroup_pidlist_release,
+		.register_event = tasks_register_event,
+		.unregister_event = tasks_unregister_event,
 		.mode = S_IRUGO | S_IWUSR,
 	},
 	{
@@ -4558,6 +4594,22 @@ void cgroup_fork(struct task_struct *child)
 	child->cgroups = current->cgroups;
 	get_css_set(child->cgroups);
 	INIT_LIST_HEAD(&child->cg_list);
+
+	struct cgroupfs_root *root;
+
+	/* send event to the userspace */
+	mutex_lock(&cgroup_mutex);
+	for_each_active_root(root) {
+		struct cgroup *cgrp;
+		struct fe_eventfd_list *ev;
+
+		cgrp = task_cgroup_from_root(child, root);
+
+		list_for_each_entry(ev, &cgrp->fe_notify, list) {
+			eventfd_signal(ev->eventfd, 1);
+		}
+	}
+	mutex_unlock(&cgroup_mutex);
 }
 
 /**
@@ -4653,6 +4705,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 {
 	struct css_set *cg;
 	int i;
+	struct cgroupfs_root *root;
 
 	/*
 	 * Unlink from the css_set task list if necessary.
@@ -4666,6 +4719,20 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 		write_unlock(&css_set_lock);
 	}
 
+	/* send event to the userspace */
+	mutex_lock(&cgroup_mutex);
+	for_each_active_root(root) {
+		struct cgroup *cgrp;
+		struct fe_eventfd_list *ev;
+
+		cgrp = task_cgroup_from_root(tsk, root);
+
+		list_for_each_entry(ev, &cgrp->fe_notify, list) {
+			eventfd_signal(ev->eventfd, 1);
+		}
+	}
+	mutex_unlock(&cgroup_mutex);
+
 	/* Reassign the task to the init_css_set. */
 	task_lock(tsk);
 	cg = tsk->cgroups;

--Boundary_(ID_GfRcHUF1NjqdNQofyaSE2A)--
