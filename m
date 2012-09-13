From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] fs: add missing documentation to simple_xattr
 functions
Date: Thu, 13 Sep 2012 11:11:24 -0700
Message-ID: <20120913181124.GD7677@google.com>
References: <20120911202809.988739953@napanee.usersys.redhat.com>
 <20120911202810.725043407@napanee.usersys.redhat.com>
 <50521FA6.7040900@xenotime.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JxCVOqGkSiTciFoXE0Qew8AmF8DGKXOV8ta7+P5kJE4=;
        b=QtwxUQCCVC0ZCQ6I6QXVkXjLZgLGCGe/E/IQZPFpGTWfH4i53HeB53QF3mszk+boAb
         kp8dO5iAKL/iq1h9HP+ykRKEepAvSXTEiRH7PSUPlmwXddfV8I9tevOxVbDES368RtXp
         uarp6rOUfvlbjTnGA7kWEeHNOK5E+k86FCbqZt2+4smxuEEf1QZVzjPnU5VE8hXhCVd1
         rswK82b8NfXI2gbheBz3MEt9vCahfPtG1acy4jialRKd28xwKvynB22fmZIs0myQ+83Z
         PjiCqxlWbdW4G66QYxavFY7Ae7diokDvXiNe8T6E2UbeQK7r2pP587EKm2Aj4VYxOCvp
         P78w==
Content-Disposition: inline
In-Reply-To: <50521FA6.7040900-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Sep 13, 2012 at 11:02:14AM -0700, Randy Dunlap wrote:
> On 09/11/2012 01:28 PM, Aristeu Rozanski wrote:
> 
> 
> +/**
> + * simple_xattr_set: xattr SET operation for in-memory/pseudo filesystems
> 
> The format for the function name/description uses '-', not ':', as:
> 
>  * simple_xattr_set - xattr SET operation for in-memory/pseudo filesystems
> 
> + * @xattrs: simple_xattr list
> + * @name: name of the new extended attribute
> + * @value: value of the new extended attribute. If NULL, will remove the
> + *	   attribute
> 
> Missing @size parameter description.

Updated the patch in place accordingly.  Thanks.

From 4895768b6aab55bbdbebcf2da090cb1a5ccf5463 Mon Sep 17 00:00:00 2001
From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Tue, 11 Sep 2012 16:28:11 -0400
Subject: [PATCH] fs: add missing documentation to simple_xattr functions

v2: add function documentation instead of adding a separate file under
    Documentation/

tj: Updated comment a bit and rolled in Randy's suggestions.

Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 fs/xattr.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index e17e773..f053c11 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -892,8 +892,19 @@ out:
 
 }
 
-/*
- * xattr SET operation for in-memory/pseudo filesystems
+/**
+ * simple_xattr_set - xattr SET operation for in-memory/pseudo filesystems
+ * @xattrs: target simple_xattr list
+ * @name: name of the new extended attribute
+ * @value: value of the new xattr. If %NULL, will remove the attribute
+ * @size: size of the new xattr
+ * @flags: %XATTR_{CREATE|REPLACE}
+ *
+ * %XATTR_CREATE is set, the xattr shouldn't exist already; otherwise fails
+ * with -EEXIST.  If %XATTR_REPLACE is set, the xattr should exist;
+ * otherwise, fails with -ENODATA.
+ *
+ * Returns 0 on success, -errno on failure.
  */
 int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 		     const void *value, size_t size, int flags)
@@ -950,6 +961,9 @@ ssize_t simple_xattr_list(struct simple_xattrs *xattrs, char *buffer,
 	return used;
 }
 
+/*
+ * Adds an extended attribute to the list
+ */
 void simple_xattr_list_add(struct simple_xattrs *xattrs,
 			   struct simple_xattr *new_xattr)
 {
-- 
1.7.7.3
