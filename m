From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] nfs: include xattr.h from fs/nfs/nfs3proc.c
Date: Mon, 3 Feb 2014 14:31:07 -0500
Message-ID: <20140203193107.GH30250@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=CfWH0p/Afx4OVQGaJh2OlLXn5/+a7Ntc49gbZdeyBOU=;
        b=0mAEP2JrLkBvMDdZnc5Xs9CAos6iggS2s0BrIC7T2ozBKHUAfvtALejOwCtWoZ1Vt8
         nYZsZFdDTJEZWqq84KCvz9KbZVeUV4i7N5Afo1XpvwISheYLPeIu2ejOCfjmcDxn8VxI
         YwK5BcMZoFsAk4XRi6/J71Vxog+h9Zbzpmt9wUNcl9zW7K7RqZTFPc4oU40ZwfX2Cmmr
         +qJ7BG7++FYo/s0JTGec70MpA168JPy05HZGjDGmkGicAWJwyiWaBXdQBGK3b1YVHgSr
         ycqyp16R0olHh7vqqA0pnOOK/GmbGXtBUIhDe/xnUyL2YX+t+0MsBu8aiA6RMbuOQpDO
         gDOQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

fs/nfs/nfs3proc.c is making use of xattr but was getting linux/xattr.h
indirectly through linux/cgroup.h, which will soon drop the inclusion
of xattr.h.  Explicitly include linux/xattr.h from nfs3proc.c so that
compilation doesn't fail when linux/cgroup.h drops linux/xattr.h.

As the following cgroup changes will depend on these changes, it
probably would be easier to route this through cgroup branch.  Would
that be okay?

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nfs/nfs3proc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -18,6 +18,7 @@
 #include <linux/lockd/bind.h>
 #include <linux/nfs_mount.h>
 #include <linux/freezer.h>
+#include <linux/xattr.h>
 
 #include "iostat.h"
 #include "internal.h"
