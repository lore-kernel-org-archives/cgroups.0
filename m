From: Kamal Mostafa <kamal-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [3.13.y.z extended stable] Patch "device_cgroup: check if exception removal is allowed" has been added to staging queue
Date: Tue, 17 Jun 2014 14:42:11 -0700
Message-ID: <1403041331-8077-1-git-send-email-kamal@canonical.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kamal Mostafa <kamal-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, kernel-team-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org

This is a note to let you know that I have just added a patch titled

    device_cgroup: check if exception removal is allowed

to the linux-3.13.y-queue branch of the 3.13.y.z extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.13.y-queue

This patch is scheduled to be released in version 3.13.11.4.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.13.y.z tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Kamal

------

From 152e5116473774df795e48c4364a868d47a05e27 Mon Sep 17 00:00:00 2001
From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Mon, 5 May 2014 11:18:59 -0400
Subject: device_cgroup: check if exception removal is allowed

commit d2c2b11cfa134f4fbdcc34088824da26a084d8de upstream.

[PATCH v3 1/2] device_cgroup: check if exception removal is allowed

When the device cgroup hierarchy was introduced in
	bd2953ebbb53 - devcg: propagate local changes down the hierarchy

a specific case was overlooked. Consider the hierarchy bellow:

	A	default policy: ALLOW, exceptions will deny access
	 \
	  B	default policy: ALLOW, exceptions will deny access

There's no need to verify when an new exception is added to B because
in this case exceptions will deny access to further devices, which is
always fine. Hierarchy in device cgroup only makes sure B won't have
more access than A.

But when an exception is removed (by writing devices.allow), it isn't
checked if the user is in fact removing an inherited exception from A,
thus giving more access to B.

Example:

	# echo 'a' >A/devices.allow
	# echo 'c 1:3 rw' >A/devices.deny
	# echo $$ >A/B/tasks
	# echo >/dev/null
	-bash: /dev/null: Operation not permitted
	# echo 'c 1:3 w' >A/B/devices.allow
	# echo >/dev/null
	#

This shouldn't be allowed and this patch fixes it by making sure to never allow
exceptions in this case to be removed if the exception is partially or fully
present on the parent.

v3: missing '*' in function description
v2: improved log message and formatting fixes

Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Kamal Mostafa <kamal-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 security/device_cgroup.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 8e62b67..7fac654 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -467,6 +467,37 @@ static int parent_has_perm(struct dev_cgroup *childcg,
 }

 /**
+ * parent_allows_removal - verify if it's ok to remove an exception
+ * @childcg: child cgroup from where the exception will be removed
+ * @ex: exception being removed
+ *
+ * When removing an exception in cgroups with default ALLOW policy, it must
+ * be checked if removing it will give the child cgroup more access than the
+ * parent.
+ *
+ * Return: true if it's ok to remove exception, false otherwise
+ */
+static bool parent_allows_removal(struct dev_cgroup *childcg,
+				  struct dev_exception_item *ex)
+{
+	struct dev_cgroup *parent = css_to_devcgroup(css_parent(&childcg->css));
+
+	if (!parent)
+		return true;
+
+	/* It's always allowed to remove access to devices */
+	if (childcg->behavior == DEVCG_DEFAULT_DENY)
+		return true;
+
+	/*
+	 * Make sure you're not removing part or a whole exception existing in
+	 * the parent cgroup
+	 */
+	return !match_exception_partial(&parent->exceptions, ex->type,
+					ex->major, ex->minor, ex->access);
+}
+
+/**
  * may_allow_all - checks if it's possible to change the behavior to
  *		   allow based on parent's rules.
  * @parent: device cgroup's parent
@@ -701,17 +732,21 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,

 	switch (filetype) {
 	case DEVCG_ALLOW:
-		if (!parent_has_perm(devcgroup, &ex))
-			return -EPERM;
 		/*
 		 * If the default policy is to allow by default, try to remove
 		 * an matching exception instead. And be silent about it: we
 		 * don't want to break compatibility
 		 */
 		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
+			/* Check if the parent allows removing it first */
+			if (!parent_allows_removal(devcgroup, &ex))
+				return -EPERM;
 			dev_exception_rm(devcgroup, &ex);
-			return 0;
+			break;
 		}
+
+		if (!parent_has_perm(devcgroup, &ex))
+			return -EPERM;
 		rc = dev_exception_add(devcgroup, &ex);
 		break;
 	case DEVCG_DENY:
--
1.9.1
