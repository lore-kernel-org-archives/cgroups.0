From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/7] cgroup: rename cgroup_pidlist->mutex
Date: Thu, 1 Aug 2013 09:52:15 +0800
Message-ID: <51F9BF4F.5030704@huawei.com>
References: <51F8C7C5.9040608@huawei.com> <51F8C818.4080308@huawei.com> <20130731113518.GJ2810@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130731113518.GJ2810-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

It's a rw_semaphore not a mutex.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ae905a5..6662811 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3436,7 +3436,7 @@ struct cgroup_pidlist {
 	/* pointer to the cgroup we belong to, for list removal purposes */
 	struct cgroup *owner;
 	/* protects the other fields */
-	struct rw_semaphore mutex;
+	struct rw_semaphore rwsem;
 };
 
 /*
@@ -3509,7 +3509,7 @@ static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
 	struct pid_namespace *ns = task_active_pid_ns(current);
 
 	/*
-	 * We can't drop the pidlist_mutex before taking the l->mutex in case
+	 * We can't drop the pidlist_mutex before taking the l->rwsem in case
 	 * the last ref-holder is trying to remove l from the list at the same
 	 * time. Holding the pidlist_mutex precludes somebody taking whichever
 	 * list we find out from under us - compare release_pid_array().
@@ -3518,7 +3518,7 @@ static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
 	list_for_each_entry(l, &cgrp->pidlists, links) {
 		if (l->key.type == type && l->key.ns == ns) {
 			/* make sure l doesn't vanish out from under us */
-			down_write(&l->mutex);
+			down_write(&l->rwsem);
 			mutex_unlock(&cgrp->pidlist_mutex);
 			return l;
 		}
@@ -3529,8 +3529,8 @@ static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
 		mutex_unlock(&cgrp->pidlist_mutex);
 		return l;
 	}
-	init_rwsem(&l->mutex);
-	down_write(&l->mutex);
+	init_rwsem(&l->rwsem);
+	down_write(&l->rwsem);
 	l->key.type = type;
 	l->key.ns = get_pid_ns(ns);
 	l->owner = cgrp;
@@ -3591,7 +3591,7 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	l->list = array;
 	l->length = length;
 	l->use_count++;
-	up_write(&l->mutex);
+	up_write(&l->rwsem);
 	*lp = l;
 	return 0;
 }
@@ -3669,7 +3669,7 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 	int index = 0, pid = *pos;
 	int *iter;
 
-	down_read(&l->mutex);
+	down_read(&l->rwsem);
 	if (pid) {
 		int end = l->length;
 
@@ -3696,7 +3696,7 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 static void cgroup_pidlist_stop(struct seq_file *s, void *v)
 {
 	struct cgroup_pidlist *l = s->private;
-	up_read(&l->mutex);
+	up_read(&l->rwsem);
 }
 
 static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
@@ -3742,7 +3742,7 @@ static void cgroup_release_pid_array(struct cgroup_pidlist *l)
 	 * pidlist_mutex, we have to take pidlist_mutex first.
 	 */
 	mutex_lock(&l->owner->pidlist_mutex);
-	down_write(&l->mutex);
+	down_write(&l->rwsem);
 	BUG_ON(!l->use_count);
 	if (!--l->use_count) {
 		/* we're the last user if refcount is 0; remove and free */
@@ -3750,12 +3750,12 @@ static void cgroup_release_pid_array(struct cgroup_pidlist *l)
 		mutex_unlock(&l->owner->pidlist_mutex);
 		pidlist_free(l->list);
 		put_pid_ns(l->key.ns);
-		up_write(&l->mutex);
+		up_write(&l->rwsem);
 		kfree(l);
 		return;
 	}
 	mutex_unlock(&l->owner->pidlist_mutex);
-	up_write(&l->mutex);
+	up_write(&l->rwsem);
 }
 
 static int cgroup_pidlist_release(struct inode *inode, struct file *file)
-- 
1.8.0.2
