From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/9] cgroup: use restart_syscall() for mount retries
Date: Wed, 14 May 2014 09:12:48 -0400
Message-ID: <20140514131248.GF28815@htj.dyndns.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
 <1399670015-23463-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uMkEirjTZ43Gr0g9wmmfNqPsZdyNeGOvzsR1GgKVnks=;
        b=PVWALsGx7CKS+LHK0d7Kn1PS0D5lMVu9/iZulYvZh+MxcLa0jfsiOwWaecohA/Qg2b
         JgOUTNB6Dwqw7Dynu6mbY9uHUxrOdHDVLEIz8GPskUjZxAlWZkF5V2k5PpgnrvJs7X1K
         NONIn93juXIEgTiuiWz/txuDfYS55vVYwnpfV15tOnXSSoD1eIT+skAnJSusKyJE+Sgq
         AcjxlD+EJGyFBnKjeCOGJTVJ0rg0BPBHg3xBXLnZ6Fhp6euam8B4W0Slv046kCO31/EI
         UL0x71wAsZWy89HgX9dN535l6/NtVAJwGZJcOKr4nqsrWBkbwt7GOyUme+HwaK3j6N2V
         A3wg==
Content-Disposition: inline
In-Reply-To: <1399670015-23463-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cgroup_mount() uses dumb delay-and-retry logic to wait for cgroup_root
which is being destroyed.  The retry currently loops inside
cgroup_mount() proper.  This patch makes it return with
restart_syscall() instead so that retry travels out to userland
boundary.

This slightly simplifies the logic and more importantly makes the
retry logic behave better when the wait for some reason becomes
lengthy or infinite by allowing the operation to be suspended or
terminated from userland.

v2: The original patch forgot to free memory allocated for @opts.
    Fixed.  Caught by Li Zefan.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1681,7 +1681,7 @@ static struct dentry *cgroup_mount(struc
 	ret = parse_cgroupfs_options(data, &opts);
 	if (ret)
 		goto out_unlock;
-retry:
+
 	/* look for a matching existing root */
 	if (!opts.subsys_mask && !opts.none && !opts.name) {
 		cgrp_dfl_root_visible = true;
@@ -1740,8 +1740,8 @@ retry:
 		if (!atomic_inc_not_zero(&root->cgrp.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			msleep(10);
-			mutex_lock(&cgroup_mutex);
-			goto retry;
+			ret = restart_syscall();
+			goto out_free;
 		}
 
 		ret = 0;
@@ -1772,7 +1772,7 @@ retry:
 
 out_unlock:
 	mutex_unlock(&cgroup_mutex);
-
+out_free:
 	kfree(opts.release_agent);
 	kfree(opts.name);
 
