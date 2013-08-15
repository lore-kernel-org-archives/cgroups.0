From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 3/4] devcg: save locally saved settings
Date: Thu, 15 Aug 2013 11:34:13 -0400
Message-ID: <1376580854-30929-4-git-send-email-aris@redhat.com>
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

Whenever writing rules in the current directory, save these rules so it
can be used whenever parent's rules change. This patch prepares for
revalidating the local rules based on parent's current state, which is
not only needed to retain whenever possible the local settings but to
allow moving the group to another part of the tree.

Signed-off-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 security/device_cgroup.c |   35 +++++++++++++++++++++++++++++++----
 1 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 8461e0f..7f55bb7 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -53,6 +53,7 @@ struct devcg_rules {
 struct dev_cgroup {
 	struct cgroup_subsys_state css;
 	struct devcg_rules active_rules;
+	struct devcg_rules local_rules;
 };
 
 static inline struct list_head *active_exceptions(struct dev_cgroup *devcg)
@@ -62,6 +63,13 @@ static inline struct list_head *active_exceptions(struct dev_cgroup *devcg)
 
 #define active_behavior(devcg) ((devcg)->active_rules.behavior)
 
+static inline struct list_head *local_exceptions(struct dev_cgroup *devcg)
+{
+	return &(devcg->local_rules.exceptions);
+}
+
+#define local_behavior(devcg) ((devcg)->local_rules.behavior)
+
 static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
 {
 	return s ? container_of(s, struct dev_cgroup, css) : NULL;
@@ -168,16 +176,22 @@ static void dev_exception_rm(struct list_head *exceptions,
 	}
 }
 
-static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
+static void __dev_exception_clean_one(struct list_head *exceptions)
 {
 	struct dev_exception_item *ex, *tmp;
 
-	list_for_each_entry_safe(ex, tmp, active_exceptions(dev_cgroup), list) {
+	list_for_each_entry_safe(ex, tmp, exceptions, list) {
 		list_del_rcu(&ex->list);
 		kfree_rcu(ex, rcu);
 	}
 }
 
+static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
+{
+	__dev_exception_clean_one(active_exceptions(dev_cgroup));
+	__dev_exception_clean_one(local_exceptions(dev_cgroup));
+}
+
 /**
  * dev_exception_clean - frees all entries of the exception list
  * @dev_cgroup: dev_cgroup with the exception list to be cleaned
@@ -245,6 +259,8 @@ devcgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		return ERR_PTR(-ENOMEM);
 	INIT_LIST_HEAD(active_exceptions(dev_cgroup));
 	active_behavior(dev_cgroup) = DEVCG_DEFAULT_NONE;
+	INIT_LIST_HEAD(local_exceptions(dev_cgroup));
+	local_behavior(dev_cgroup) = DEVCG_DEFAULT_NONE;
 
 	return &dev_cgroup->css;
 }
@@ -546,6 +562,9 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 				return -EPERM;
 			dev_exception_clean(devcgroup);
 			active_behavior(devcgroup) = DEVCG_DEFAULT_ALLOW;
+			if (local_behavior(devcgroup) == DEVCG_DEFAULT_DENY)
+				__dev_exception_clean_one(local_exceptions(devcgroup));
+			local_behavior(devcgroup) = DEVCG_DEFAULT_ALLOW;
 			if (!parent)
 				break;
 
@@ -560,6 +579,9 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 
 			dev_exception_clean(devcgroup);
 			active_behavior(devcgroup) = DEVCG_DEFAULT_DENY;
+			if (local_behavior(devcgroup) == DEVCG_DEFAULT_ALLOW)
+				__dev_exception_clean_one(local_exceptions(devcgroup));
+			local_behavior(devcgroup) = DEVCG_DEFAULT_DENY;
 			break;
 		default:
 			return -EINVAL;
@@ -650,9 +672,11 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 		 */
 		if (active_behavior(devcgroup) == DEVCG_DEFAULT_ALLOW) {
 			dev_exception_rm(active_exceptions(devcgroup), &ex);
+			dev_exception_rm(local_exceptions(devcgroup), &ex);
 			return 0;
 		}
 		rc = dev_exception_add(active_exceptions(devcgroup), &ex);
+		rc = dev_exception_add(local_exceptions(devcgroup), &ex);
 		break;
 	case DEVCG_DENY:
 		/*
@@ -660,10 +684,13 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 		 * an matching exception instead. And be silent about it: we
 		 * don't want to break compatibility
 		 */
-		if (active_behavior(devcgroup) == DEVCG_DEFAULT_DENY)
+		if (active_behavior(devcgroup) == DEVCG_DEFAULT_DENY) {
 			dev_exception_rm(active_exceptions(devcgroup), &ex);
-		else
+			dev_exception_rm(local_exceptions(devcgroup), &ex);
+		} else {
 			rc = dev_exception_add(active_exceptions(devcgroup), &ex);
+			rc = dev_exception_add(local_exceptions(devcgroup), &ex);
+		}
 
 		if (rc)
 			break;
-- 
1.7.1
