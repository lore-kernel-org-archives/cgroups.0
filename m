From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v4 4/9] devcg: expand may_access() logic
Date: Wed, 30 Jan 2013 12:11:05 -0500
Message-ID: <20130130171101.690972553@napanee.usersys.redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=split_may_access_logic.patch
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

In order to make the next patch more clear, expand may_access() logic.

v2: may_access() returns bool now

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 security/device_cgroup.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-30 08:56:29.532063723 -0500
+++ github/security/device_cgroup.c	2013-01-30 08:58:02.934460404 -0500
@@ -355,8 +355,8 @@ 	return 0;
  * @dev_cgroup: dev cgroup to be tested against
  * @refex: new exception
  */
-static int may_access(struct dev_cgroup *dev_cgroup,
-		      struct dev_exception_item *refex)
+static bool may_access(struct dev_cgroup *dev_cgroup,
+		       struct dev_exception_item *refex)
 {
 	struct dev_exception_item *ex;
 	bool match = false;
@@ -382,16 +382,19 @@ 		if (ex->minor != ~0 && ex->minor != re
 
 	/*
 	 * In two cases we'll consider this new exception valid:
-	 * - the dev cgroup has its default policy to allow + exception list:
-	 *   the new exception should *not* match any of the exceptions
-	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
 	 * - the dev cgroup has its default policy to deny + exception list:
 	 *   the new exception *should* match the exceptions
-	 *   (behavior == DEVCG_DEFAULT_DENY, match)
+	 * - the dev cgroup has its default policy to allow + exception list:
+	 *   the new exception should *not* match any of the exceptions
 	 */
-	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
-		return 1;
-	return 0;
+	if (dev_cgroup->behavior == DEVCG_DEFAULT_DENY) {
+		if (match)
+			return true;
+	} else {
+		if (!match)
+			return true;
+	}
+	return false;
 }
 
 /*
