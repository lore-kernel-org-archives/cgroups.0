From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] device_cgroup: do not use rule acceptance function to
 validate access
Date: Mon, 14 Apr 2014 10:47:54 -0400
Message-ID: <20140414144736.GS29214@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

may_access() is currently used to validate both new exceptions from children
groups and to check if an access is allowed. This not only makes it hard to
understand and maintain, but it's also incorrect.

It currently allows one to:

	# mkdir new_group
	# cd new_group
	# echo $$ >tasks
	# echo "c 1:3 w" >devices.deny
	# echo >/dev/null
	# echo $?
	0

This patch implements the device file access check separately and fixes
the issue.

This is broken since c39a2a3018f8065cb5ea38b0314c1bbedb2cfa0d

After review, this should be considered for stable series.

Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 8365909..d390d21 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -704,21 +704,35 @@ static int __devcgroup_check_permission(short type, u32 major, u32 minor,
 				        short access)
 {
 	struct dev_cgroup *dev_cgroup;
-	struct dev_exception_item ex;
-	int rc;
-
-	memset(&ex, 0, sizeof(ex));
-	ex.type = type;
-	ex.major = major;
-	ex.minor = minor;
-	ex.access = access;
+	struct dev_exception_item *ex;
+	enum devcg_behavior behavior;
+	bool match = false;
 
 	rcu_read_lock();
 	dev_cgroup = task_devcgroup(current);
-	rc = may_access(dev_cgroup, &ex, dev_cgroup->behavior);
+	behavior = dev_cgroup->behavior;
+	list_for_each_entry_rcu(ex, &dev_cgroup->exceptions, list) {
+		if (type == DEV_BLOCK && !(ex->type & DEV_BLOCK))
+			continue;
+		if (type == DEV_CHAR && !(ex->type & DEV_CHAR))
+			continue;
+		if (ex->major != ~0 && major != ex->major)
+			continue;
+		if (ex->minor != ~0 && minor != ex->minor)
+			continue;
+		if (access & (~ex->access))
+			continue;
+		match = true;
+		break;
+	}
 	rcu_read_unlock();
 
-	if (!rc)
+	if (behavior == DEVCG_DEFAULT_ALLOW && match)
+		/* access matches a rule to disallow access */
+		return -EPERM;
+
+	if (behavior == DEVCG_DEFAULT_DENY && !match)
+		/* no exceptions found, default action is to deny access */
 		return -EPERM;
 
 	return 0;
