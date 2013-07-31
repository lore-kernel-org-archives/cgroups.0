From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 4/7] cgroup: rename cgroup_pidlist->mutex
Date: Wed, 31 Jul 2013 16:17:28 +0800
Message-ID: <51F8C818.4080308@huawei.com>
References: <51F8C7C5.9040608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51F8C7C5.9040608@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

It's a semaphore not a mutex.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f0d7f5d..0d378b1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3417,7 +3417,7 @@ struct cgroup_pidlist {
 	/* pointer to the cgroup we belong to, for list removal purposes */
 	struct cgroup *owner;
 	/* protects the other fields */
-	struct rw_semaphore mutex;
+	struct rw_semaphore sem;
 };
 
 /*
@@ -3490,7 +3490,7 @@ static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
 	struct pid_namespace *ns = task_active_pid_ns(current);
 
 	/*
-	 * We can't drop the pidlist_mutex before taking the l->mutex in case
+	 * We can't drop the pidlist_mutex before taking the l->sem in case
 	 * the last ref-holder is trying to remove l from the list at the same
 	 * time. Holding the pidlist_mutex precludes somebody taking whichever
 	 * list we find out from under us - compare release_pid_array().
@@ -3499,7 +3499,7 @@ static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
 	list_for_each_entry(l, &cgrp->pidlists, links) {
 		if (l->key.type == type && l->key.ns == ns) {
 			/* make sure l doesn't vanish out from under us */
-			down_write(&l->mutex);
+			down_write(&l->sem);
 			mutex_unlock(&cgrp->pidlist_mutex);
 			return l;
 		}
@@ -3510,8 +3510,8 @@ static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
 		mutex_unlock(&cgrp->pidlist_mutex);
 		return l;
 	}
-	init_rwsem(&l->mutex);
-	down_write(&l->mutex);
+	init_rwsem(&l->sem);
+	down_write(&l->sem);
 	l->key.type = type;
 	l->key.ns = get_pid_ns(ns);
 	l->owner = cgrp;
@@ -3572,7 +3572,7 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	l->list = array;
 	l->length = length;
 	l->use_count++;
-	up_write(&l->mutex);
+	up_write(&l->sem);
 	*lp = l;
 	return 0;
 }
@@ -3650,7 +3650,7 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 	int index = 0, pid = *pos;
 	int *iter;
 
-	down_read(&l->mutex);
+	down_read(&l->sem);
 	if (pid) {
 		int end = l->length;
 
@@ -3677,7 +3677,7 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 static void cgroup_pidlist_stop(struct seq_file *s, void *v)
 {
 	struct cgroup_pidlist *l = s->private;
-	up_read(&l->mutex);
+	up_read(&l->sem);
 }
 
 static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
@@ -3723,7 +3723,7 @@ static void cgroup_release_pid_array(struct cgroup_pidlist *l)
 	 * pidlist_mutex, we have to take pidlist_mutex first.
 	 */
 	mutex_lock(&l->owner->pidlist_mutex);
-	down_write(&l->mutex);
+	down_write(&l->sem);
 	BUG_ON(!l->use_count);
 	if (!--l->use_count) {
 		/* we're the last user if refcount is 0; remove and free */
@@ -3731,12 +3731,12 @@ static void cgroup_release_pid_array(struct cgroup_pidlist *l)
 		mutex_unlock(&l->owner->pidlist_mutex);
 		pidlist_free(l->list);
 		put_pid_ns(l->key.ns);
-		up_write(&l->mutex);
+		up_write(&l->sem);
 		kfree(l);
 		return;
 	}
 	mutex_unlock(&l->owner->pidlist_mutex);
-	up_write(&l->mutex);
+	up_write(&l->sem);
 }
 
 static int cgroup_pidlist_release(struct inode *inode, struct file *file)
-- 
1.8.0.2
