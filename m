From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.3 2/3] cgroup: drop
 cgroup__DEVEL__legacy_files_on_dfl
Date: Wed, 5 Aug 2015 13:20:43 -0400
Message-ID: <20150805172043.GP17598@mtj.duckdns.org>
References: <20150805172012.GO17598@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fApWrOZzh1NGo7ppfmtjDO2n2sNSs6X5ZWkblvsteM4=;
        b=FRpeguGx6XYJi/462jp5jy0serkug3jHs9zB/uRxLFyyhmsTK0BODCnlBgqNuGHAeX
         /Yze7Nk1F2oJrJgC39y6naAUqRMNZWQFeFahbcoaBMbxNELIA37CXXAryswoArrWClvX
         t/9HTHja6u540gSvhPSMqLRum/YYU13NWy1UettbM8lRX8Rqv0w17uj8jrFRM2wygpHm
         f20Q7UoJz17ttNblskGczMZObwiYdW5ZO+ZYcTGtrljI7hXUt9Du45FD4kgarV6swjiw
         gGUhTM2e1RtngGmNmDYrz9LEDpktml322nZ95jHQYeNqhozqTL9D+vE3N32ZnAHmgpQg
         jkYg==
Content-Disposition: inline
In-Reply-To: <20150805172012.GO17598-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Now that interfaces for the major three controllers - cpu, memory, io
- are shaping up, there's no reason to have an option to force legacy
files to show up on the unified hierarchy for testing.  Drop it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 Documentation/cgroups/unified-hierarchy.txt |    6 -----
 kernel/cgroup.c                             |   30 +---------------------------
 2 files changed, 2 insertions(+), 34 deletions(-)

--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -107,12 +107,6 @@ root of unified hierarchy can be bound t
 allows mixing unified hierarchy with the traditional multiple
 hierarchies in a fully backward compatible way.
 
-For development purposes, the following boot parameter makes all
-controllers to appear on the unified hierarchy whether supported or
-not.
-
- cgroup__DEVEL__legacy_files_on_dfl
-
 A controller can be moved across hierarchies only after the controller
 is no longer referenced in its current hierarchy.  Because per-cgroup
 controller states are destroyed asynchronously and controllers may
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -152,12 +152,6 @@ struct cgroup_root cgrp_dfl_root;
  */
 static bool cgrp_dfl_root_visible;
 
-/*
- * Set by the boot param of the same name and makes subsystems with NULL
- * ->dfl_files to use ->legacy_files on the default hierarchy.
- */
-static bool cgroup_legacy_files_on_dfl;
-
 /* some controllers are not supported in the default hierarchy */
 static unsigned long cgrp_dfl_root_inhibit_ss_mask;
 
@@ -3340,17 +3334,8 @@ int cgroup_add_legacy_cftypes(struct cgr
 {
 	struct cftype *cft;
 
-	/*
-	 * If legacy_flies_on_dfl, we want to show the legacy files on the
-	 * dfl hierarchy but iff the target subsystem hasn't been updated
-	 * for the dfl hierarchy yet.
-	 */
-	if (!cgroup_legacy_files_on_dfl ||
-	    ss->dfl_cftypes != ss->legacy_cftypes) {
-		for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
-			cft->flags |= __CFTYPE_NOT_ON_DFL;
-	}
-
+	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
+		cft->flags |= __CFTYPE_NOT_ON_DFL;
 	return cgroup_add_cftypes(ss, cfts);
 }
 
@@ -5055,9 +5040,6 @@ int __init cgroup_init(void)
 
 		cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 
-		if (cgroup_legacy_files_on_dfl && !ss->dfl_cftypes)
-			ss->dfl_cftypes = ss->legacy_cftypes;
-
 		if (!ss->dfl_cftypes)
 			cgrp_dfl_root_inhibit_ss_mask |= 1 << ss->id;
 
@@ -5474,14 +5456,6 @@ static int __init cgroup_disable(char *s
 }
 __setup("cgroup_disable=", cgroup_disable);
 
-static int __init cgroup_set_legacy_files_on_dfl(char *str)
-{
-	printk("cgroup: using legacy files on the default hierarchy\n");
-	cgroup_legacy_files_on_dfl = true;
-	return 0;
-}
-__setup("cgroup__DEVEL__legacy_files_on_dfl", cgroup_set_legacy_files_on_dfl);
-
 /**
  * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
  * @dentry: directory dentry of interest
