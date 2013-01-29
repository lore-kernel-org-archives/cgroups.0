From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v3 4/9] devcg: expand may_access() logic
Date: Tue, 29 Jan 2013 14:08:03 -0500
Message-ID: <20130129190759.857103871@napanee.usersys.redhat.com>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
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

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 security/device_cgroup.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-29 11:49:15.244665037 -0500
+++ github/security/device_cgroup.c	2013-01-29 11:49:15.514669057 -0500
@@ -382,15 +382,18 @@ 		if (ex->minor != ~0 && ex->minor != re
 
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
+	if (dev_cgroup->behavior == DEVCG_DEFAULT_DENY) {
+		if (match)
+			return 1;
+	} else {
+		if (!match)
+			return 1;
+	}
 	return 0;
 }
 
