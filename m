From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: demote subsystem init messages to KERN_DEBUG
Date: Tue, 29 Dec 2015 14:57:02 -0500
Message-ID: <20151229195702.GC3873@htj.duckdns.org>
References: <DB5PR01MB10625F9B4570BCFBBD47FC52ACFC0@DB5PR01MB1062.eurprd01.prod.exchangelabs.com>
 <5682D420.3030207@infradead.org>
 <20151229192414.GB3873@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FQvgzepupa5vSv1YNWNxqcW+cHR4sgpaFa0jg7Qr5mQ=;
        b=jVWtou7kyhHY/WlzFgtzYLZAPjHuGhYysHX1WcwWQ7ffH/BN3gNmgYbUC2/di/zsvO
         3bHoLevpYsAwPwHX4vO52juzhLmonuN88a6FizyxLWTem5Pc5nghu+JWVmI/wrGGLTk0
         0AWnwzGqum42c2Y6MzpZaNx+5a3PFP0/y07c5VgiCmXIk7J5143ufdSZ71NbQiF9n+kG
         xM6AG938xNCP+aD+XjMHzVp26lPUjE8FQdUtLNWtV7926NIVLMBlx/vJgpb7ogEiUUCO
         1YK+8eTU3PYuSiXSoHWj741s/ixAaPN/uG+ygp+jpR5ZyC2O1x85TnuNod/L+feYBoVP
         4V+Q==
Content-Disposition: inline
In-Reply-To: <20151229192414.GB3873-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alexandru GOIA <alexandru.goia-akc712wslOWvSplVBqRQBQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

From 507bd688e32c2b2ca4bed139d9123b3da6d2d19d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 29 Dec 2015 14:53:56 -0500

These are noisy during boot and not all that interesting.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Queued for the coming merge window.

Thanks.

 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f3836f3..7eb1d9d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5245,7 +5245,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 {
 	struct cgroup_subsys_state *css;
 
-	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
+	pr_debug("Initializing cgroup subsys %s\n", ss->name);
 
 	mutex_lock(&cgroup_mutex);
 
-- 
2.5.0
