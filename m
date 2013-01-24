From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v2 3/4] device_cgroup: make may_access() stronger
Date: Thu, 24 Jan 2013 14:50:00 -0500
Message-ID: <20130124194957.663514303@napanee.usersys.redhat.com>
References: <20130124194957.198022148@napanee.usersys.redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=strengthen-may_access.patch
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

In order to revalidate local exceptions for the hierarchy change propagation,
make may_access() stronger.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 security/device_cgroup.c |   48 +++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 18 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-24 10:40:46.384253615 -0500
+++ github/security/device_cgroup.c	2013-01-24 10:41:07.513567697 -0500
@@ -353,13 +353,15 @@ 	return 0;
  *		won't have more privileges than its parent or to
  *		verify if a certain access is allowed.
  * @dev_cgroup: dev cgroup to be tested against
+ * @behavior: behavior of the exception
  * @refex: new exception
  */
-static int may_access(struct dev_cgroup *dev_cgroup,
-		      struct dev_exception_item *refex)
+static bool may_access(struct dev_cgroup *dev_cgroup,
+		       struct dev_exception_item *refex,
+		       enum devcg_behavior behavior)
 {
 	struct dev_exception_item *ex;
-	bool match = false;
+	int match = false;
 
 	rcu_lockdep_assert(rcu_read_lock_held() ||
 			   lockdep_is_held(&devcgroup_mutex),
@@ -380,18 +382,28 @@ 		if (ex->minor != ~0 && ex->minor != re
 		break;
 	}
 
-	/*
-	 * In two cases we'll consider this new exception valid:
-	 * - the dev cgroup has its default policy to allow + exception list:
-	 *   the new exception should *not* match any of the exceptions
-	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
-	 * - the dev cgroup has its default policy to deny + exception list:
-	 *   the new exception *should* match the exceptions
-	 *   (behavior == DEVCG_DEFAULT_DENY, match)
-	 */
-	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
-		return 1;
-	return 0;
+	if (dev_cgroup->behavior == DEVCG_DEFAULT_ALLOW) {
+		if (behavior == DEVCG_DEFAULT_ALLOW) {
+			/* the exception will deny access to certain devices */
+			return true;
+		} else {
+			/* the exception will allow access to certain devices */
+			if (match)
+				/*
+				 * a new exception allowing access shouldn't
+				 * match an parent's exception
+				 */
+				return false;
+			return true;
+		}
+	} else {
+		/* only behavior == DEVCG_DEFAULT_DENY allowed here */
+		if (match)
+			/* parent has an exception that matches the proposed */
+			return true;
+		else
+			return false;
+	}
 }
 
 /*
@@ -408,7 +420,7 @@ static int parent_has_perm(struct dev_cg
 	if (!pcg)
 		return 1;
 	parent = cgroup_to_devcgroup(pcg);
-	return may_access(parent, ex);
+	return may_access(parent, ex, childcg->behavior);
 }
 
 /**
@@ -442,7 +454,7 @@ static int devcgroup_update_access(struc
 {
 	const char *b;
 	char temp[12];		/* 11 + 1 characters needed for a u32 */
-	int count, rc;
+	int count, rc = 0;
 	struct dev_exception_item ex;
 	struct cgroup *p = devcgroup->css.cgroup;
 	struct dev_cgroup *parent = NULL;
@@ -660,7 +672,7 @@ 	memset(&ex, 0, sizeof(ex));
 
 	rcu_read_lock();
 	dev_cgroup = task_devcgroup(current);
-	rc = may_access(dev_cgroup, &ex);
+	rc = may_access(dev_cgroup, &ex, dev_cgroup->behavior);
 	rcu_read_unlock();
 
 	if (!rc)
