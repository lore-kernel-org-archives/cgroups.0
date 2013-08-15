From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 1/4] devcg: move behavior and exceptions into its own structure
Date: Thu, 15 Aug 2013 11:34:11 -0400
Message-ID: <1376580854-30929-2-git-send-email-aris@redhat.com>
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

From: Aristeu Rozanski <aris-moeOTchvdi7YtjvyW6yDsg@public.gmane.org>

This patch is in preparation for the next one that will allow saving locally
set rules.

Signed-off-by: Aristeu Rozanski <aris-moeOTchvdi7YtjvyW6yDsg@public.gmane.org>
---
 security/device_cgroup.c |   72 ++++++++++++++++++++++++++-------------------
 1 files changed, 42 insertions(+), 30 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index c123628..a4b7df4 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -45,12 +45,23 @@ struct dev_exception_item {
 	struct rcu_head rcu;
 };
 
-struct dev_cgroup {
-	struct cgroup_subsys_state css;
+struct devcg_rules {
 	struct list_head exceptions;
 	enum devcg_behavior behavior;
 };
 
+struct dev_cgroup {
+	struct cgroup_subsys_state css;
+	struct devcg_rules active_rules;
+};
+
+static inline struct list_head *active_exceptions(struct dev_cgroup *devcg)
+{
+	return &(devcg->active_rules.exceptions);
+}
+
+#define active_behavior(devcg) ((devcg)->active_rules.behavior)
+
 static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
 {
 	return s ? container_of(s, struct dev_cgroup, css) : NULL;
@@ -113,7 +124,7 @@ static int dev_exception_add(struct dev_cgroup *dev_cgroup,
 	if (!excopy)
 		return -ENOMEM;
 
-	list_for_each_entry(walk, &dev_cgroup->exceptions, list) {
+	list_for_each_entry(walk, active_exceptions(dev_cgroup), list) {
 		if (walk->type != ex->type)
 			continue;
 		if (walk->major != ex->major)
@@ -127,7 +138,7 @@ static int dev_exception_add(struct dev_cgroup *dev_cgroup,
 	}
 
 	if (excopy != NULL)
-		list_add_tail_rcu(&excopy->list, &dev_cgroup->exceptions);
+		list_add_tail_rcu(&excopy->list, active_exceptions(dev_cgroup));
 	return 0;
 }
 
@@ -141,7 +152,7 @@ static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
 
 	lockdep_assert_held(&devcgroup_mutex);
 
-	list_for_each_entry_safe(walk, tmp, &dev_cgroup->exceptions, list) {
+	list_for_each_entry_safe(walk, tmp, active_exceptions(dev_cgroup), list) {
 		if (walk->type != ex->type)
 			continue;
 		if (walk->major != ex->major)
@@ -161,7 +172,7 @@ static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
 {
 	struct dev_exception_item *ex, *tmp;
 
-	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
+	list_for_each_entry_safe(ex, tmp, active_exceptions(dev_cgroup), list) {
 		list_del_rcu(&ex->list);
 		kfree_rcu(ex, rcu);
 	}
@@ -182,7 +193,7 @@ static void dev_exception_clean(struct dev_cgroup *dev_cgroup)
 
 static inline bool is_devcg_online(const struct dev_cgroup *devcg)
 {
-	return (devcg->behavior != DEVCG_DEFAULT_NONE);
+	return (active_behavior(devcg) != DEVCG_DEFAULT_NONE);
 }
 
 /**
@@ -200,12 +211,12 @@ static int devcgroup_online(struct cgroup_subsys_state *css)
 	mutex_lock(&devcgroup_mutex);
 
 	if (parent_dev_cgroup == NULL)
-		dev_cgroup->behavior = DEVCG_DEFAULT_ALLOW;
+		active_behavior(dev_cgroup) = DEVCG_DEFAULT_ALLOW;
 	else {
-		ret = dev_exceptions_copy(&dev_cgroup->exceptions,
-					  &parent_dev_cgroup->exceptions);
+		ret = dev_exceptions_copy(active_exceptions(dev_cgroup),
+					  active_exceptions(parent_dev_cgroup));
 		if (!ret)
-			dev_cgroup->behavior = parent_dev_cgroup->behavior;
+			active_behavior(dev_cgroup) = active_behavior(parent_dev_cgroup);
 	}
 	mutex_unlock(&devcgroup_mutex);
 
@@ -217,7 +228,7 @@ static void devcgroup_offline(struct cgroup_subsys_state *css)
 	struct dev_cgroup *dev_cgroup = css_to_devcgroup(css);
 
 	mutex_lock(&devcgroup_mutex);
-	dev_cgroup->behavior = DEVCG_DEFAULT_NONE;
+	active_behavior(dev_cgroup) = DEVCG_DEFAULT_NONE;
 	mutex_unlock(&devcgroup_mutex);
 }
 
@@ -232,8 +243,8 @@ devcgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	dev_cgroup = kzalloc(sizeof(*dev_cgroup), GFP_KERNEL);
 	if (!dev_cgroup)
 		return ERR_PTR(-ENOMEM);
-	INIT_LIST_HEAD(&dev_cgroup->exceptions);
-	dev_cgroup->behavior = DEVCG_DEFAULT_NONE;
+	INIT_LIST_HEAD(active_exceptions(dev_cgroup));
+	active_behavior(dev_cgroup) = DEVCG_DEFAULT_NONE;
 
 	return &dev_cgroup->css;
 }
@@ -298,14 +309,15 @@ static int devcgroup_seq_read(struct cgroup_subsys_state *css,
 	 * - List the exceptions in case the default policy is to deny
 	 * This way, the file remains as a "whitelist of devices"
 	 */
-	if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
+	if (active_behavior(devcgroup) == DEVCG_DEFAULT_ALLOW) {
 		set_access(acc, ACC_MASK);
 		set_majmin(maj, ~0);
 		set_majmin(min, ~0);
 		seq_printf(m, "%c %s:%s %s\n", type_to_char(DEV_ALL),
 			   maj, min, acc);
 	} else {
-		list_for_each_entry_rcu(ex, &devcgroup->exceptions, list) {
+		list_for_each_entry_rcu(ex, active_exceptions(devcgroup),
+					list) {
 			set_access(acc, ex->access);
 			set_majmin(maj, ex->major);
 			set_majmin(min, ex->minor);
@@ -339,7 +351,7 @@ static bool may_access(struct dev_cgroup *dev_cgroup,
 			   lockdep_is_held(&devcgroup_mutex),
 			   "device_cgroup::may_access() called without proper synchronization");
 
-	list_for_each_entry_rcu(ex, &dev_cgroup->exceptions, list) {
+	list_for_each_entry_rcu(ex, active_exceptions(dev_cgroup), list) {
 		if ((refex->type & DEV_BLOCK) && !(ex->type & DEV_BLOCK))
 			continue;
 		if ((refex->type & DEV_CHAR) && !(ex->type & DEV_CHAR))
@@ -354,7 +366,7 @@ static bool may_access(struct dev_cgroup *dev_cgroup,
 		break;
 	}
 
-	if (dev_cgroup->behavior == DEVCG_DEFAULT_ALLOW) {
+	if (active_behavior(dev_cgroup) == DEVCG_DEFAULT_ALLOW) {
 		if (behavior == DEVCG_DEFAULT_ALLOW) {
 			/* the exception will deny access to certain devices */
 			return true;
@@ -391,7 +403,7 @@ static int parent_has_perm(struct dev_cgroup *childcg,
 
 	if (!parent)
 		return 1;
-	return may_access(parent, ex, childcg->behavior);
+	return may_access(parent, ex, active_behavior(childcg));
 }
 
 /**
@@ -404,7 +416,7 @@ static inline int may_allow_all(struct dev_cgroup *parent)
 {
 	if (!parent)
 		return 1;
-	return parent->behavior == DEVCG_DEFAULT_ALLOW;
+	return active_behavior(parent) == DEVCG_DEFAULT_ALLOW;
 }
 
 /**
@@ -425,7 +437,7 @@ static void revalidate_active_exceptions(struct dev_cgroup *devcg)
 	struct dev_exception_item *ex;
 	struct list_head *this, *tmp;
 
-	list_for_each_safe(this, tmp, &devcg->exceptions) {
+	list_for_each_safe(this, tmp, active_exceptions(devcg)) {
 		ex = container_of(this, struct dev_exception_item, list);
 		if (!parent_has_perm(devcg, ex))
 			dev_exception_rm(devcg, ex);
@@ -465,8 +477,8 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
 		 * in case both root's behavior and devcg is allow, a new
 		 * restriction means adding to the exception list
 		 */
-		if (devcg_root->behavior == DEVCG_DEFAULT_ALLOW &&
-		    devcg->behavior == DEVCG_DEFAULT_ALLOW) {
+		if (active_behavior(devcg_root) == DEVCG_DEFAULT_ALLOW &&
+		    active_behavior(devcg) == DEVCG_DEFAULT_ALLOW) {
 			rc = dev_exception_add(devcg, ex);
 			if (rc)
 				break;
@@ -533,12 +545,12 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 			if (!may_allow_all(parent))
 				return -EPERM;
 			dev_exception_clean(devcgroup);
-			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+			active_behavior(devcgroup) = DEVCG_DEFAULT_ALLOW;
 			if (!parent)
 				break;
 
-			rc = dev_exceptions_copy(&devcgroup->exceptions,
-						 &parent->exceptions);
+			rc = dev_exceptions_copy(active_exceptions(devcgroup),
+						 active_exceptions(parent));
 			if (rc)
 				return rc;
 			break;
@@ -547,7 +559,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 				return -EINVAL;
 
 			dev_exception_clean(devcgroup);
-			devcgroup->behavior = DEVCG_DEFAULT_DENY;
+			active_behavior(devcgroup) = DEVCG_DEFAULT_DENY;
 			break;
 		default:
 			return -EINVAL;
@@ -636,7 +648,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 		 * an matching exception instead. And be silent about it: we
 		 * don't want to break compatibility
 		 */
-		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
+		if (active_behavior(devcgroup) == DEVCG_DEFAULT_ALLOW) {
 			dev_exception_rm(devcgroup, &ex);
 			return 0;
 		}
@@ -648,7 +660,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 		 * an matching exception instead. And be silent about it: we
 		 * don't want to break compatibility
 		 */
-		if (devcgroup->behavior == DEVCG_DEFAULT_DENY)
+		if (active_behavior(devcgroup) == DEVCG_DEFAULT_DENY)
 			dev_exception_rm(devcgroup, &ex);
 		else
 			rc = dev_exception_add(devcgroup, &ex);
@@ -731,7 +743,7 @@ static int __devcgroup_check_permission(short type, u32 major, u32 minor,
 
 	rcu_read_lock();
 	dev_cgroup = task_devcgroup(current);
-	rc = may_access(dev_cgroup, &ex, dev_cgroup->behavior);
+	rc = may_access(dev_cgroup, &ex, active_behavior(dev_cgroup));
 	rcu_read_unlock();
 
 	if (!rc)
-- 
1.7.1
