From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v2 1/4] device_cgroup: prepare exception list handling functions for two lists
Date: Thu, 24 Jan 2013 14:49:58 -0500
Message-ID: <20130124194957.375712635@napanee.usersys.redhat.com>
References: <20130124194957.198022148@napanee.usersys.redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=dev_exception_helpers.patch
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

In the following patches, device_cgroup structure will have two sets of
behavior and exceptions list (actual one, another with the local settings)
so rework the functions to use exception list, not a device_cgroup.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 security/device_cgroup.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-24 10:40:32.814051897 -0500
+++ github/security/device_cgroup.c	2013-01-24 10:40:33.913068234 -0500
@@ -104,7 +104,7 @@ free_and_exit:
 /*
  * called under devcgroup_mutex
  */
-static int dev_exception_add(struct dev_cgroup *dev_cgroup,
+static int dev_exception_add(struct list_head *exceptions,
 			     struct dev_exception_item *ex)
 {
 	struct dev_exception_item *excopy, *walk;
@@ -115,7 +115,7 @@ static int dev_exception_add(struct dev_
 	if (!excopy)
 		return -ENOMEM;
 
-	list_for_each_entry(walk, &dev_cgroup->exceptions, list) {
+	list_for_each_entry(walk, exceptions, list) {
 		if (walk->type != ex->type)
 			continue;
 		if (walk->major != ex->major)
@@ -129,21 +129,21 @@ static int dev_exception_add(struct dev_
 	}
 
 	if (excopy != NULL)
-		list_add_tail_rcu(&excopy->list, &dev_cgroup->exceptions);
+		list_add_tail_rcu(&excopy->list, exceptions);
 	return 0;
 }
 
 /*
  * called under devcgroup_mutex
  */
-static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
+static void dev_exception_rm(struct list_head *exceptions,
 			     struct dev_exception_item *ex)
 {
 	struct dev_exception_item *walk, *tmp;
 
 	lockdep_assert_held(&devcgroup_mutex);
 
-	list_for_each_entry_safe(walk, tmp, &dev_cgroup->exceptions, list) {
+	list_for_each_entry_safe(walk, tmp, exceptions, list) {
 		if (walk->type != ex->type)
 			continue;
 		if (walk->major != ex->major)
@@ -514,10 +514,10 @@ 		case '\0':
 		 * don't want to break compatibility
 		 */
 		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
-			dev_exception_rm(devcgroup, &ex);
+			dev_exception_rm(&devcgroup->exceptions, &ex);
 			return 0;
 		}
-		return dev_exception_add(devcgroup, &ex);
+		return dev_exception_add(&devcgroup->exceptions, &ex);
 	case DEVCG_DENY:
 		/*
 		 * If the default policy is to deny by default, try to remove
@@ -525,10 +525,10 @@ 			return 0;
 		 * don't want to break compatibility
 		 */
 		if (devcgroup->behavior == DEVCG_DEFAULT_DENY) {
-			dev_exception_rm(devcgroup, &ex);
+			dev_exception_rm(&devcgroup->exceptions, &ex);
 			return 0;
 		}
-		return dev_exception_add(devcgroup, &ex);
+		return dev_exception_add(&devcgroup->exceptions, &ex);
 	default:
 		return -EINVAL;
 	}
