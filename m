From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] device_cgroup: rename deny_all to behavior
Date: Fri, 19 Oct 2012 17:16:27 -0400
Message-ID: <20121019211626.583893413@napanee.usersys.redhat.com>
References: <20121019211626.219447423@napanee.usersys.redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=deny_all.patch
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This was done in a v2 patch but v1 ended up being committed. The variable name
is less confusing and stores the default behavior when no matching exception
exists.


Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Cc: Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>

---
 security/device_cgroup.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- github.orig/security/device_cgroup.c	2012-10-19 16:35:37.936804289 -0400
+++ github/security/device_cgroup.c	2012-10-19 16:35:46.366102913 -0400
@@ -42,7 +42,10 @@ struct dev_exception_item {
 struct dev_cgroup {
 	struct cgroup_subsys_state css;
 	struct list_head exceptions;
-	bool deny_all;
+	enum {
+		DEVCG_DEFAULT_ALLOW,
+		DEVCG_DEFAULT_DENY,
+	} behavior;
 };
 
 static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
@@ -182,13 +185,13 @@ static struct cgroup_subsys_state *devcg
 	parent_cgroup = cgroup->parent;
 
 	if (parent_cgroup == NULL)
-		dev_cgroup->deny_all = false;
+		dev_cgroup->behavior = DEVCG_DEFAULT_ALLOW;
 	else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
 		mutex_lock(&devcgroup_mutex);
 		ret = dev_exceptions_copy(&dev_cgroup->exceptions,
 					  &parent_dev_cgroup->exceptions);
-		dev_cgroup->deny_all = parent_dev_cgroup->deny_all;
+		dev_cgroup->behavior = parent_dev_cgroup->behavior;
 		mutex_unlock(&devcgroup_mutex);
 		if (ret) {
 			kfree(dev_cgroup);
@@ -260,7 +263,7 @@ static int devcgroup_seq_read(struct cgr
 	 * - List the exceptions in case the default policy is to deny
 	 * This way, the file remains as a "whitelist of devices"
 	 */
-	if (devcgroup->deny_all == false) {
+	if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
 		set_access(acc, ACC_MASK);
 		set_majmin(maj, ~0);
 		set_majmin(min, ~0);
@@ -314,12 +317,12 @@ 		if (ex->minor != ~0 && ex->minor != re
 	 * In two cases we'll consider this new exception valid:
 	 * - the dev cgroup has its default policy to allow + exception list:
 	 *   the new exception should *not* match any of the exceptions
-	 *   (!deny_all, !match)
+	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
 	 * - the dev cgroup has its default policy to deny + exception list:
 	 *   the new exception *should* match the exceptions
-	 *   (deny_all, match)
+	 *   (behavior == DEVCG_DEFAULT_DENY, match)
 	 */
-	if (dev_cgroup->deny_all == match)
+	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
 		return 1;
 	return 0;
 }
@@ -375,11 +378,11 @@ 	memset(&ex, 0, sizeof(ex));
 			if (!parent_has_perm(devcgroup, &ex))
 				return -EPERM;
 			dev_exception_clean(devcgroup);
-			devcgroup->deny_all = false;
+			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
 			break;
 		case DEVCG_DENY:
 			dev_exception_clean(devcgroup);
-			devcgroup->deny_all = true;
+			devcgroup->behavior = DEVCG_DEFAULT_DENY;
 			break;
 		default:
 			return -EINVAL;
@@ -452,7 +455,7 @@ 		case '\0':
 		 * an matching exception instead. And be silent about it: we
 		 * don't want to break compatibility
 		 */
-		if (devcgroup->deny_all == false) {
+		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
 			dev_exception_rm(devcgroup, &ex);
 			return 0;
 		}
@@ -463,7 +466,7 @@ 			return 0;
 		 * an matching exception instead. And be silent about it: we
 		 * don't want to break compatibility
 		 */
-		if (devcgroup->deny_all == true) {
+		if (devcgroup->behavior == DEVCG_DEFAULT_DENY) {
 			dev_exception_rm(devcgroup, &ex);
 			return 0;
 		}
