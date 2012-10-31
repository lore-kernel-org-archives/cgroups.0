From: Aristeu Rozanski <aris@redhat.com>
Subject: [PATCH] device_cgroup: fix unchecked cgroup parent usage
Date: Wed, 31 Oct 2012 12:04:30 -0400
Message-ID: <20121031160430.GD14789@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>, Serge Hallyn <serge.hallyn@canonical.com>, Jiri Slaby <jslaby@suse.cz>, cgroups@vger.kernel.org

In 4cef7299b4786879a3e113e84084a72b24590c5b the cgroup parent usage is
unchecked. root will not have a parent and trying to use
device.{allow,deny} will cause problems. For some reason my stressing
scripts didn't test the root directory so I didn't catch it on my
regular tests.

Andrew, Tejun, this patch needs to make Linus tree ASAP or a revert for
4cef7299b4786879a3e113e84084a72b24590c5b.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

--- github.orig/security/device_cgroup.c	2012-10-26 17:18:01.739366780 -0400
+++ github/security/device_cgroup.c	2012-10-29 10:03:33.221918003 -0400
@@ -352,6 +352,8 @@
  */
 static inline int may_allow_all(struct dev_cgroup *parent)
 {
+	if (!parent)
+		return 1;
 	return parent->behavior == DEVCG_DEFAULT_ALLOW;
 }
 
@@ -376,11 +378,14 @@
 	int count, rc;
 	struct dev_exception_item ex;
 	struct cgroup *p = devcgroup->css.cgroup;
-	struct dev_cgroup *parent = cgroup_to_devcgroup(p->parent);
+	struct dev_cgroup *parent = NULL;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (p->parent)
+		parent = cgroup_to_devcgroup(p->parent);
+
 	memset(&ex, 0, sizeof(ex));
 	b = buffer;
 
@@ -391,11 +396,14 @@
 			if (!may_allow_all(parent))
 				return -EPERM;
 			dev_exception_clean(devcgroup);
+			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+			if (!parent)
+				break;
+
 			rc = dev_exceptions_copy(&devcgroup->exceptions,
 						 &parent->exceptions);
 			if (rc)
 				return rc;
-			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
 			break;
 		case DEVCG_DENY:
 			dev_exception_clean(devcgroup);
