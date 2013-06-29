From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] cgroup: remove gratuituous BUG_ON()s from
 rebind_subsystems()
Date: Fri, 28 Jun 2013 21:13:05 -0700
Message-ID: <20130629041305.GB31353@htj.dyndns.org>
References: <20130629041231.GA31353@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NZRbFL54+FdYs6QOqHtiDoZHIzhpYvIZvk2sfcwjodE=;
        b=SjZqDfgLPXoPkDgZJIdcY1h/8pMEjQCsW/8D0XAd8mEf1nkLKgCAuUquyEKy6E8pki
         HowyhrJPTuCjo4XS8pk2mm7LHiQ3KMUASzhVmC/6geDB3WPhCW6CZ6wOoZURqE5+p/lC
         U3e6EXRLgl8zWL5S+4+Aunuz17vfWcGD302QevXqnIfpeRqD2eJs8xZ8IaMYncfyOiN5
         v1cg6re6ERvP5C4TKTnF0srh0pXE3w6TyDAClVZKYsj+xyFeVI2btMStovuusTDMhbJn
         dJC1gCjcAKp5xHU46TS1AUzLf8kAdZ9Ao0mJcdf8mKivFb4syv6DQJaRdk/9Pe6TDwst
         XGTA==
Content-Disposition: inline
In-Reply-To: <20130629041231.GA31353-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From 9d47f1dd70a19b78a9da53e71fc1bf41e0300026 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Fri, 28 Jun 2013 21:08:27 -0700

rebind_subsystems() performs santiy checks even on subsystems which
aren't specified to be added or removed and the checks aren't all that
useful given that these are in a very cold path while the violations
they check would trip up in much hotter paths.

Let's remove these from rebind_subsystems().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a65aff1..864a4b2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1071,15 +1071,6 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			/* subsystem is now free - drop reference on module */
 			module_put(ss->module);
 			root->subsys_mask &= ~bit;
-		} else if (bit & root->subsys_mask) {
-			/* Subsystem state should already exist */
-			BUG_ON(!cgrp->subsys[i]);
-#ifdef CONFIG_MODULE_UNLOAD
-			BUG_ON(ss->module && !module_refcount(ss->module));
-#endif
-		} else {
-			/* Subsystem state shouldn't exist */
-			BUG_ON(cgrp->subsys[i]);
 		}
 	}
 
-- 
1.8.3.1
