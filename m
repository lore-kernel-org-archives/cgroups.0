From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/5] cgroup: initialize cgrp_dfl_root_inhibit_ss_mask from
 !->dfl_files test
Date: Thu, 3 Jul 2014 11:21:03 -0400
Message-ID: <20140703152103.GF16191@htj.dyndns.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=3DH8VpSevudUGQSBw+k0MH2uE8a80165t6hPJvFQ3x8=;
        b=EkiI11PzsImSgT5h269grul+ChtdCrPRUAiVJ3e/bv0y/W7gFWdjwnlPfPV1g6k7km
         mCgnCzycO0jAVRq7orJchjS35XQlfTm2IEPfJS5ec3jY1KCjMtneKw9vGKUHfpLaHu6E
         YRRBxGBpdr5Knh8jPMRrlGkgdGKTKryiGay2vzYivGn7QH+lLW2566XlUOJDmo4Iee8o
         QL1F/F0c7iCRHCxtklexEDPo2wP1VUlLLrCYaHIrzpXsqaZrSm5z9+Veu5xJuNPa5crg
         +7nXGhCy995rzMQUPKQKN66N8cKsVL7y8Ok8zK6u7ubAUS33TbKnKPcD1hyEeSXWcIYa
         5YOg==
Content-Disposition: inline
In-Reply-To: <1404345055-8196-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From 29e5e8eac7ade8af5880020c91db9bc1c470596a Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Thu, 3 Jul 2014 11:18:31 -0400

cgrp_dfl_root_inhibit_ss_mask determines which subsystems are not
supported on the default hierarchy and is currently initialized
statically and just includes the debug subsystem.  Now that there's
cgroup_subsys->dfl_files, we can easily tell which subsystems support
the default hierarchy or not.

Let's initialize cgrp_dfl_root_inhibit_ss_mask by testing whether
cgroup_subsys->dfl_files is NULL.  After all, subsystems with NULL
->dfl_files aren't useable on the default hierarchy anyway.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bc38c75..a7fce52 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -156,11 +156,7 @@ static bool cgrp_dfl_root_visible;
 static bool cgroup_legacy_files_on_dfl;
 
 /* some controllers are not supported in the default hierarchy */
-static const unsigned int cgrp_dfl_root_inhibit_ss_mask = 0
-#ifdef CONFIG_CGROUP_DEBUG
-	| (1 << debug_cgrp_id)
-#endif
-	;
+static unsigned int cgrp_dfl_root_inhibit_ss_mask;
 
 /* The list of hierarchy roots */
 
@@ -4818,6 +4814,9 @@ int __init cgroup_init(void)
 		if (cgroup_legacy_files_on_dfl && !ss->dfl_cftypes)
 			ss->dfl_cftypes = ss->legacy_cftypes;
 
+		if (!ss->dfl_cftypes)
+			cgrp_dfl_root_inhibit_ss_mask |= 1 << ss->id;
+
 		if (ss->dfl_cftypes == ss->legacy_cftypes) {
 			WARN_ON(cgroup_add_cftypes(ss, ss->dfl_cftypes));
 		} else {
-- 
1.9.3
