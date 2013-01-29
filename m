From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v3 8/9] devcg: refactor dev_exception_clean()
Date: Tue, 29 Jan 2013 14:08:07 -0500
Message-ID: <20130129190800.443784569@napanee.usersys.redhat.com>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=exception_clean.patch
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

This patch is in preparation for hierarchy support.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 security/device_cgroup.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-29 11:49:16.374681863 -0500
+++ github/security/device_cgroup.c	2013-01-29 11:49:16.653686016 -0500
@@ -212,32 +212,33 @@ static int dev_exception_add(struct dev_
 	return rc;
 }
 
-static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
+static void dev_exception_clean(struct list_head *exceptions)
 {
 	struct dev_exception_item *ex, *tmp;
 
-	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
-		list_del_rcu(&ex->list);
-		kfree_rcu(ex, rcu);
-	}
-	list_for_each_entry_safe(ex, tmp, &dev_cgroup->local.exceptions,
-				 list) {
+	list_for_each_entry_safe(ex, tmp, exceptions, list) {
 		list_del_rcu(&ex->list);
 		kfree_rcu(ex, rcu);
 	}
 }
 
+static void __dev_exception_clean_all(struct dev_cgroup *dev_cgroup)
+{
+	dev_exception_clean(&dev_cgroup->exceptions);
+	dev_exception_clean(&dev_cgroup->local.exceptions);
+}
+
 /**
- * dev_exception_clean - frees all entries of the exception list
+ * dev_exception_clean_all - frees all entries of the exception list
  * @dev_cgroup: dev_cgroup with the exception list to be cleaned
  *
  * called under devcgroup_mutex
  */
-static void dev_exception_clean(struct dev_cgroup *dev_cgroup)
+static void dev_exception_clean_all(struct dev_cgroup *dev_cgroup)
 {
 	lockdep_assert_held(&devcgroup_mutex);
 
-	__dev_exception_clean(dev_cgroup);
+	__dev_exception_clean_all(dev_cgroup);
 }
 
 /**
@@ -303,7 +304,7 @@ static void devcgroup_css_free(struct cg
 	struct dev_cgroup *dev_cgroup;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
-	__dev_exception_clean(dev_cgroup);
+	__dev_exception_clean_all(dev_cgroup);
 	kfree(dev_cgroup);
 }
 
@@ -508,25 +509,22 @@ 	memset(&ex, 0, sizeof(ex));
 		case DEVCG_ALLOW:
 			if (!may_allow_all(parent))
 				return -EPERM;
-			dev_exception_clean(devcgroup);
+			dev_exception_clean_all(devcgroup);
 			if (parent)
 				rc = dev_exceptions_copy(&devcgroup->exceptions,
 							 &parent->exceptions);
 			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
 			devcgroup->local.behavior = DEVCG_DEFAULT_ALLOW;
-
-			if (rc)
-				return rc;
 			break;
 		case DEVCG_DENY:
-			dev_exception_clean(devcgroup);
+			dev_exception_clean_all(devcgroup);
 			devcgroup->behavior = DEVCG_DEFAULT_DENY;
 			devcgroup->local.behavior = DEVCG_DEFAULT_DENY;
 			break;
 		default:
-			return -EINVAL;
+			rc = -EINVAL;
 		}
-		return 0;
+		return rc;
 	case 'b':
 		ex.type = DEV_BLOCK;
 		break;
