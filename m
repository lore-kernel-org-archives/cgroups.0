From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v5 2/7] cgroup: implement __cgroup_task_count() helper
Date: Fri,  7 Dec 2018 12:15:26 -0800
Message-ID: <20181207201531.1665-3-guro@fb.com>
References: <20181207201531.1665-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CXMv0Vhrfz8OgUyxnyaG6yJ3Btg8UiW/JMvPPUaP47g=;
        b=iv1dU8CL7eCxkwjdGBFS0mbtxk6GU8XmzSL0nJFOoIS3VrhbCDGf0tP7iWGdFyLajD
         aplvV93AwOr0eNpnVx2zfFszUcI9KJzC3oAbVs0+ahZvCFNKy+zAlp8pkxa97NR92hMK
         pjgD1Fm33eANuoVbsiu7oh7dI0OarvO/14v6gXDwWqljuOHakvlaZDRSXOua3/s8mujq
         IaDC3x/5XRCDmnhvPaBJZHXh66MAnAM5vF+v0MytJfiEbYunsILafsGbXfnynRIPXzwN
         ysUrfKuhMeXogcAMnw5sPNpw2f175HdVKRuW7TFFgHtHiu2p3QYsNPAaktOHWdQM1i84
         5GQA==
In-Reply-To: <20181207201531.1665-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

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
index c950864016e2..a195328431ce 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -226,6 +226,7 @@ int cgroup_rmdir(struct kernfs_node *kn);
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
index e06994fd4e34..7519a4307021 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -563,6 +563,39 @@ static void cgroup_get_live(struct cgroup *cgrp)
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

