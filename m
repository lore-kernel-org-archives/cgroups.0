From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v3 7/9] devcg: split single exception copy from dev_exceptions_copy()
Date: Tue, 29 Jan 2013 14:08:06 -0500
Message-ID: <20130129190800.291395350@napanee.usersys.redhat.com>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=exceptions_copy.patch
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

This patch is in preparation for hierarchy support

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 security/device_cgroup.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-29 11:49:16.076677425 -0500
+++ github/security/device_cgroup.c	2013-01-29 11:49:16.374681863 -0500
@@ -89,20 +89,30 @@ static int devcgroup_can_attach(struct c
 	return 0;
 }
 
+static int dev_exception_copy(struct list_head *dest,
+			      struct dev_exception_item *ex)
+{
+	struct dev_exception_item *new;
+
+	new = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	list_add_tail(&new->list, dest);
+	return 0;
+}
+
 /*
  * called under devcgroup_mutex
  */
 static int dev_exceptions_copy(struct list_head *dest, struct list_head *orig)
 {
-	struct dev_exception_item *ex, *tmp, *new;
+	struct dev_exception_item *ex, *tmp;
 
 	lockdep_assert_held(&devcgroup_mutex);
 
 	list_for_each_entry(ex, orig, list) {
-		new = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
-		if (!new)
+		if (dev_exception_copy(dest, ex))
 			goto free_and_exit;
-		list_add_tail(&new->list, dest);
 	}
 
 	return 0;
