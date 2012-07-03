From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: cgroup_rm_files() was calling simple_unlink() with
 the wrong inode
Date: Tue, 3 Jul 2012 10:38:06 -0700
Message-ID: <20120703173806.GD555@google.com>
References: <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
 <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
 <20120629165809.GB21048@google.com>
 <4FEE98EE.1050409@huawei.com>
 <20120630064724.GC14083@ZenIV.linux.org.uk>
 <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com>
 <20120630083421.GD14083@ZenIV.linux.org.uk>
 <20120703171033.GC555@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=i1WCM9DsH8B9x37w8fyNbz4LkB2BVghPeq7oOg5LsAo=;
        b=gWvJOOUjrwu3reQGFxJBAd8wX4RDt7EROLPbQtsPk7O6wyHGLvTU+oqFgXPob2SdYc
         sqr6VQ7fnk18B9OShkocJ88D/XVwcSoxbqM+AbaS6nxYaNPcA3v49Qwq87j11LUn+PRw
         CrsB1zPCq33n81Ayxvy1eDDVzx04XzbZqEbUPlFBXHJ7UK5orofT3OWs9QrqBFAY1JFH
         Ccg/6jKbYqjO7H3itAC07/OoO/W4ALX33SadR558T1IrW7RzOMkgWgeJ/x0l+lNJvctZ
         nr0MFaRVk6tR7QyZ2Yft8XKFYTtoeHyW+9Jm9456sgq3rDLcYO0cnL5axHthT6wdAJ4y
         9dfw==
Content-Disposition: inline
In-Reply-To: <20120703171033.GC555-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From 6da2689412c78b97716ec524cc30baf7b46508cd Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 3 Jul 2012 10:32:26 -0700

While refactoring cgroup file removal path, 05ef1d7c4a "cgroup:
introduce struct cfent" incorrectly changed the @dir argument of
simple_unlink() to the inode of the file being deleted instead of that
of the containing directory.

The effect of this bug is minor - ctime and mtime of the parent
weren't properly updated on file deletion.

Fix it by using @cgrp->dentry->d_inode instead.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
---
Will commit to cgroup/for-3.5-fixes.  Li, can you please ack this?

Thanks.

 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2097684..b214fc2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -964,7 +964,7 @@ static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 
 		dget(d);
 		d_delete(d);
-		simple_unlink(d->d_inode, d);
+		simple_unlink(cgrp->dentry->d_inode, d);
 		list_del_init(&cfe->node);
 		dput(d);
 
-- 
1.7.7.3
