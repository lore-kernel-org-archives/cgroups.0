From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/14] cgroup: RCU protect each cgroup_subsys_state release
Date: Thu,  8 Aug 2013 16:13:51 -0400
Message-ID: <1375992831-4650-15-git-send-email-tj@kernel.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ViTSflQ6TXEDZD0mSmE8a5/zAduIXLYijm+g36v6FFE=;
        b=Cj5bCHZpqSSoe0EJG/exZB2YIyFs98NEl4W6yzOK2abrRi+wBagIOUvSOCo3AVCLi5
         WRar7J60SZ0A308Mh8MOBlxpP7+c/1VsVMHcXqfDHVfawVEBWfZgE7eZBfHSk9gcfgy9
         Tion9pCKwlGFr/Cw3XSMxk+E2uwwi261cH5mOKJ3L146RwecMj6fW2yNvKZAl5Orc/KP
         jjxrDq22D1JsWt7o6Q/nkOWjTCe1IF5JoO6LwLh2k2rzxJuc3MACxmScNwTHUxw+n3gl
         JKBzXUHSYwfZCWMJTlxwM8y43xyg6npdAGaJt6ZV/znQ4iZTTbbW+GFdyuPEZYSJv6+S
         bbdQ==
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

With the planned unified hierarchy, individual css's will be created
and destroyed dynamically across the lifetime of a cgroup.  To enable
such usages, css destruction is being decoupled from cgroup
destruction.  Most of the destruction path has been decoupled but the
actual free of css still depends on cgroup free path.

When all css refs are drained, css_release() kicks off
css_free_work_fn() which puts the cgroup.  When the cgroup refcnt
reaches zero, cgroup_diput() is invoked which in turn schedules RCU
free of the cgroup.  After a grace period, all css's are freed along
with the cgroup itself.

This patch moves the RCU grace period and css freeing from cgroup
release path to css release path.  css_release(), instead of kicking
off css_free_work_fn() directly, schedules RCU callback
css_free_rcu_fn() which in turn kicks off css_free_work_fn() after a
RCU grace period.  css_free_work_fn() is updated to free the css
directly.

The five-way punting - percpu ref kill confirmation, a work item,
percpu ref release, RCU grace period, and again a work item - is quite
hairy but the work items are there only to provide process context and
the actual sequence is kill confirm -> release -> RCU free, which
isn't simple but not too crazy.

This removes cgroup_css() usage after offline_css() allowing clearing
cgroup->subsys[] from offline_css(), which makes it consistent with
online_css() and brings it closer to proper lifetime management for
individual css's.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  3 ++-
 kernel/cgroup.c        | 53 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 71e77e7..c24bd0b 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -82,7 +82,8 @@ struct cgroup_subsys_state {
 	/* ID for this css, if possible */
 	struct css_id __rcu *id;
 
-	/* percpu_ref killing and putting dentry on the last css_put() */
+	/* percpu_ref killing and RCU release */
+	struct rcu_head rcu_head;
 	struct work_struct destroy_work;
 };
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d99ec53..75fc97f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -869,18 +869,8 @@ static struct cgroup_name *cgroup_alloc_name(struct dentry *dentry)
 static void cgroup_free_fn(struct work_struct *work)
 {
 	struct cgroup *cgrp = container_of(work, struct cgroup, destroy_work);
-	struct cgroup_subsys *ss;
 
 	mutex_lock(&cgroup_mutex);
-	/*
-	 * Release the subsystem state objects.
-	 */
-	for_each_root_subsys(cgrp->root, ss) {
-		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss->subsys_id);
-
-		ss->css_free(css);
-	}
-
 	cgrp->root->number_of_cgroups--;
 	mutex_unlock(&cgroup_mutex);
 
@@ -4281,32 +4271,62 @@ err:
 	return ret;
 }
 
+/*
+ * css destruction is four-stage process.
+ *
+ * 1. Destruction starts.  Killing of the percpu_ref is initiated.
+ *    Implemented in kill_css().
+ *
+ * 2. When the percpu_ref is confirmed to be visible as killed on all CPUs
+ *    and thus css_tryget() is guaranteed to fail, the css can be offlined
+ *    by invoking offline_css().  After offlining, the base ref is put.
+ *    Implemented in css_killed_work_fn().
+ *
+ * 3. When the percpu_ref reaches zero, the only possible remaining
+ *    accessors are inside RCU read sections.  css_release() schedules the
+ *    RCU callback.
+ *
+ * 4. After the grace period, the css can be freed.  Implemented in
+ *    css_free_work_fn().
+ *
+ * It is actually hairier because both step 2 and 4 require process context
+ * and thus involve punting to css->destroy_work adding two additional
+ * steps to the already complex sequence.
+ */
 static void css_free_work_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, destroy_work);
+	struct cgroup *cgrp = css->cgroup;
 
 	if (css->parent)
 		css_put(css->parent);
 
-	cgroup_dput(css->cgroup);
+	css->ss->css_free(css);
+	cgroup_dput(cgrp);
 }
 
-static void css_release(struct percpu_ref *ref)
+static void css_free_rcu_fn(struct rcu_head *rcu_head)
 {
 	struct cgroup_subsys_state *css =
-		container_of(ref, struct cgroup_subsys_state, refcnt);
+		container_of(rcu_head, struct cgroup_subsys_state, rcu_head);
 
 	/*
 	 * css holds an extra ref to @cgrp->dentry which is put on the last
-	 * css_put().  dput() requires process context, which css_put() may
-	 * be called without.  @css->destroy_work will be used to invoke
-	 * dput() asynchronously from css_put().
+	 * css_put().  dput() requires process context which we don't have.
 	 */
 	INIT_WORK(&css->destroy_work, css_free_work_fn);
 	schedule_work(&css->destroy_work);
 }
 
+static void css_release(struct percpu_ref *ref)
+{
+	struct cgroup_subsys_state *css =
+		container_of(ref, struct cgroup_subsys_state, refcnt);
+
+	call_rcu(&css->rcu_head, css_free_rcu_fn);
+}
+
 static void init_css(struct cgroup_subsys_state *css, struct cgroup_subsys *ss,
 		     struct cgroup *cgrp)
 {
@@ -4356,6 +4376,7 @@ static void offline_css(struct cgroup_subsys_state *css)
 
 	css->flags &= ~CSS_ONLINE;
 	css->cgroup->nr_css--;
+	RCU_INIT_POINTER(css->cgroup->subsys[ss->subsys_id], css);
 }
 
 /*
-- 
1.8.3.1
