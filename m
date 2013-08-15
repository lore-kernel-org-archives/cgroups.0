From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 2/4] devcg: make dev_exception_ functions to use lists
Date: Thu, 15 Aug 2013 11:34:12 -0400
Message-ID: <1376580854-30929-3-git-send-email-aris@redhat.com>
References: <1376580854-30929-1-git-send-email-aris@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376580854-30929-1-git-send-email-aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

From: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

In preparation for having active and locally set list of rules.

Signed-off-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 security/device_cgroup.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index a4b7df4..8461e0f 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -113,7 +113,7 @@ free_and_exit:
 /*
  * called under devcgroup_mutex
  */
-static int dev_exception_add(struct dev_cgroup *dev_cgroup,
+static int dev_exception_add(struct list_head *exceptions,
 			     struct dev_exception_item *ex)
 {
 	struct dev_exception_item *excopy, *walk;
@@ -124,7 +124,7 @@ static int dev_exception_add(struct dev_cgroup *dev_cgroup,
 	if (!excopy)
 		return -ENOMEM;
 
-	list_for_each_entry(walk, active_exceptions(dev_cgroup), list) {
+	list_for_each_entry(walk, exceptions, list) {
 		if (walk->type != ex->type)
 			continue;
 		if (walk->major != ex->major)
@@ -138,21 +138,21 @@ static int dev_exception_add(struct dev_cgroup *dev_cgroup,
 	}
 
 	if (excopy != NULL)
-		list_add_tail_rcu(&excopy->list, active_exceptions(dev_cgroup));
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
 
-	list_for_each_entry_safe(walk, tmp, active_exceptions(dev_cgroup), list) {
+	list_for_each_entry_safe(walk, tmp, exceptions, list) {
 		if (walk->type != ex->type)
 			continue;
 		if (walk->major != ex->major)
@@ -440,7 +440,7 @@ static void revalidate_active_exceptions(struct dev_cgroup *devcg)
 	list_for_each_safe(this, tmp, active_exceptions(devcg)) {
 		ex = container_of(this, struct dev_exception_item, list);
 		if (!parent_has_perm(devcg, ex))
-			dev_exception_rm(devcg, ex);
+			dev_exception_rm(active_exceptions(devcg), ex);
 	}
 }
 
@@ -479,7 +479,7 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
 		 */
 		if (active_behavior(devcg_root) == DEVCG_DEFAULT_ALLOW &&
 		    active_behavior(devcg) == DEVCG_DEFAULT_ALLOW) {
-			rc = dev_exception_add(devcg, ex);
+			rc = dev_exception_add(active_exceptions(devcg), ex);
 			if (rc)
 				break;
 		} else {
@@ -489,7 +489,7 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
 			 * root's behavior: deny, devcg's: deny
 			 * the exception will be removed
 			 */
-			dev_exception_rm(devcg, ex);
+			dev_exception_rm(active_exceptions(devcg), ex);
 		}
 		revalidate_active_exceptions(devcg);
 
@@ -649,10 +649,10 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 		 * don't want to break compatibility
 		 */
 		if (active_behavior(devcgroup) == DEVCG_DEFAULT_ALLOW) {
-			dev_exception_rm(devcgroup, &ex);
+			dev_exception_rm(active_exceptions(devcgroup), &ex);
 			return 0;
 		}
-		rc = dev_exception_add(devcgroup, &ex);
+		rc = dev_exception_add(active_exceptions(devcgroup), &ex);
 		break;
 	case DEVCG_DENY:
 		/*
@@ -661,9 +661,9 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 		 * don't want to break compatibility
 		 */
 		if (active_behavior(devcgroup) == DEVCG_DEFAULT_DENY)
-			dev_exception_rm(devcgroup, &ex);
+			dev_exception_rm(active_exceptions(devcgroup), &ex);
 		else
-			rc = dev_exception_add(devcgroup, &ex);
+			rc = dev_exception_add(active_exceptions(devcgroup), &ex);
 
 		if (rc)
 			break;
-- 
1.7.1
