From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/2] fs: add missing documentation to simple_xattr functions
Date: Tue, 11 Sep 2012 16:28:11 -0400
Message-ID: <20120911202810.725043407@napanee.usersys.redhat.com>
References: <20120911202809.988739953@napanee.usersys.redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=simple_xattr_doc.txt
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

v2: add function documentation instead of adding a separate file under
    Documentation/

Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 fs/xattr.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: github/fs/xattr.c
===================================================================
--- github.orig/fs/xattr.c	2012-09-11 14:48:12.648072176 -0400
+++ github/fs/xattr.c	2012-09-11 15:33:14.502770685 -0400
@@ -892,8 +892,19 @@
 
 }
 
-/*
- * xattr SET operation for in-memory/pseudo filesystems
+/**
+ * simple_xattr_set: xattr SET operation for in-memory/pseudo filesystems
+ * @xattrs: simple_xattr list
+ * @name: name of the new extended attribute
+ * @value: value of the new extended attribute. If NULL, will remove the
+ *	   attribute
+ * @flags: if XATTR_CREATE is set, no already existing extended attribute may
+ *	   exist. If XATTR_REPLACE is set, the extended attribute should exist.
+ *
+ * returns -ENOMEM for allocation failures, -EEXIST in case XATTR_CREATE is
+ *	   set in flags and an extended attribute with the same name exists,
+ *	   -ENODATA if XATTR_REPLACE is set in flags but no entry with the
+ *	   specified name exists.
  */
 int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 		     const void *value, size_t size, int flags)
@@ -950,6 +961,9 @@
 	return used;
 }
 
+/*
+ * Adds an extended attribute to the list
+ */
 void simple_xattr_list_add(struct simple_xattrs *xattrs,
 			   struct simple_xattr *new_xattr)
 {
