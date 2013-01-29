From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v3 2/9] devcg: reorder device exception functions
Date: Tue, 29 Jan 2013 14:08:01 -0500
Message-ID: <20130129190759.567563910@napanee.usersys.redhat.com>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=reorder_exception_functions.patch
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

In preparation for the next patch, reorder dev_exception_add() and
dev_exception_rm().

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 security/device_cgroup.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-29 11:49:14.739657516 -0500
+++ github/security/device_cgroup.c	2013-01-29 11:49:14.987661210 -0500
@@ -104,18 +104,14 @@ free_and_exit:
 /*
  * called under devcgroup_mutex
  */
-static int dev_exception_add(struct list_head *exceptions,
+static void dev_exception_rm(struct list_head *exceptions,
 			     struct dev_exception_item *ex)
 {
-	struct dev_exception_item *excopy, *walk;
+	struct dev_exception_item *walk, *tmp;
 
 	lockdep_assert_held(&devcgroup_mutex);
 
-	excopy = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
-	if (!excopy)
-		return -ENOMEM;
-
-	list_for_each_entry(walk, exceptions, list) {
+	list_for_each_entry_safe(walk, tmp, exceptions, list) {
 		if (walk->type != ex->type)
 			continue;
 		if (walk->major != ex->major)
@@ -123,27 +119,29 @@ static int dev_exception_add(struct list
 		if (walk->minor != ex->minor)
 			continue;
 
-		walk->access |= ex->access;
-		kfree(excopy);
-		excopy = NULL;
+		walk->access &= ~ex->access;
+		if (!walk->access) {
+			list_del_rcu(&walk->list);
+			kfree_rcu(walk, rcu);
+		}
 	}
-
-	if (excopy != NULL)
-		list_add_tail_rcu(&excopy->list, exceptions);
-	return 0;
 }
 
 /*
  * called under devcgroup_mutex
  */
-static void dev_exception_rm(struct list_head *exceptions,
+static int dev_exception_add(struct list_head *exceptions,
 			     struct dev_exception_item *ex)
 {
-	struct dev_exception_item *walk, *tmp;
+	struct dev_exception_item *excopy, *walk;
 
 	lockdep_assert_held(&devcgroup_mutex);
 
-	list_for_each_entry_safe(walk, tmp, exceptions, list) {
+	excopy = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
+	if (!excopy)
+		return -ENOMEM;
+
+	list_for_each_entry(walk, exceptions, list) {
 		if (walk->type != ex->type)
 			continue;
 		if (walk->major != ex->major)
@@ -151,12 +149,14 @@ static void dev_exception_rm(struct list
 		if (walk->minor != ex->minor)
 			continue;
 
-		walk->access &= ~ex->access;
-		if (!walk->access) {
-			list_del_rcu(&walk->list);
-			kfree_rcu(walk, rcu);
-		}
+		walk->access |= ex->access;
+		kfree(excopy);
+		excopy = NULL;
 	}
+
+	if (excopy != NULL)
+		list_add_tail_rcu(&excopy->list, exceptions);
+	return 0;
 }
 
 static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
