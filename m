From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v2 2/6] cgroup: implement __cgroup_task_count() helper
Date: Mon, 12 Nov 2018 15:04:18 -0800
Message-ID: <20181112230422.5911-4-guro@fb.com>
References: <20181112230422.5911-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FP20pGgu3D25STEzu2nQYXaFb5vqYhGB0+bCEyu/01c=;
        b=gYj4+QLLPEksUSiryQwvQyfZONhBhGfmUh6aioSQOgcZxDkws2ECAoGpjf/mp/Nbxr
         KPARXI8utFVk1kJaUtwb3VxjhHO4OJzsCDBhLN0sdIIJ1AQ49ulu+9Qw7yDo5R2Wj2Ph
         nNrZ24JgzwwK0O8lrvif9dZ4PVotn32doQl23DdWJ29gLWXeujl2ol6Y1lMQW+JnqKWk
         AopiBCgKrtdHzGGHEIugqmwW0f/+uVRM7lJzJ4KCyOX4xW/Rv+J3+y8HihBX/lh+Kdt/
         YcZ4ow5oHeZqFGJZV5FBmy4apL0w4PTmLhrQ7UfnAyfyGQWFSzJJkWF/9rr6RTw0dwFE
         09tA==
In-Reply-To: <20181112230422.5911-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

The helper is identical to the existing cgroup_task_count()
except it doesn't take the css_set_lock by itself, assuming
that the caller does.

Also, move cgroup_task_count() implementation into
kernel/cgroup/cgroup.c, as there is nothing specific to cgroup v1.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
---
 kernel/cgroup/cgroup-internal.h |  1 +
 kernel/cgroup/cgroup-v1.c       | 16 ----------------
 kernel/cgroup/cgroup.c          | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 75568fcf2180..fe01a9fa4a8d 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -224,6 +224,7 @@ int cgroup_rmdir(struct kernfs_node *kn);
 int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 		     struct kernfs_root *kf_root);
 
+int __cgroup_task_count(const struct cgroup *cgrp);
 int cgroup_task_count(const struct cgroup *cgrp);
 
 /*
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 51063e7a93c2..6134fef07d57 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -336,22 +336,6 @@ static struct cgroup_pidlist *cgroup_pidlist_find_create(struct cgroup *cgrp,
 	return l;
 }
 
-/**
- * cgroup_task_count - count the number of tasks in a cgroup.
- * @cgrp: the cgroup in question
- */
-int cgroup_task_count(const struct cgroup *cgrp)
-{
-	int count = 0;
-	struct cgrp_cset_link *link;
-
-	spin_lock_irq(&css_set_lock);
-	list_for_each_entry(link, &cgrp->cset_links, cset_link)
-		count += link->cset->nr_tasks;
-	spin_unlock_irq(&css_set_lock);
-	return count;
-}
-
 /*
  * Load a cgroup's pidarray with either procs' tgids or tasks' pids
  */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 4a3dae2a8283..ef3442555b32 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -561,6 +561,39 @@ static void cgroup_get_live(struct cgroup *cgrp)
 	css_get(&cgrp->self);
 }
 
+/**
+ * __cgroup_task_count - count the number of tasks in a cgroup. The caller
+ * is responsible for taking the css_set_lock.
+ * @cgrp: the cgroup in question
+ */
+int __cgroup_task_count(const struct cgroup *cgrp)
+{
+	int count = 0;
+	struct cgrp_cset_link *link;
+
+	lockdep_assert_held(&css_set_lock);
+
+	list_for_each_entry(link, &cgrp->cset_links, cset_link)
+		count += link->cset->nr_tasks;
+
+	return count;
+}
+
+/**
+ * cgroup_task_count - count the number of tasks in a cgroup.
+ * @cgrp: the cgroup in question
+ */
+int cgroup_task_count(const struct cgroup *cgrp)
+{
+	int count;
+
+	spin_lock_irq(&css_set_lock);
+	count = __cgroup_task_count(cgrp);
+	spin_unlock_irq(&css_set_lock);
+
+	return count;
+}
+
 struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
 {
 	struct cgroup *cgrp = of->kn->parent->priv;
-- 
2.17.2

