From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0.5/12] cgroup: cgroup_apply_cftypes() shouldn't skip the
 default hierarhcy
Date: Tue, 15 Apr 2014 18:05:04 -0400
Message-ID: <20140415220504.GA13099@mtj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nHLLtV5l2/wFC9U+DsaG1itVoPhCwxslJkS5Yaf3SLw=;
        b=A4x9F6qGAMykMezXXZNQ2RuwTiRAX5nogSuiD+cyIc2ry+ZChjPhoKhxj0ObnGxT5/
         nr3PDN7TdBV13yfHM/e+tqi69HSU9F4VFcpq5zRlxHs/2jwXksBbO46spIOKcPRBv2rP
         98HF+EwInG5nyioxSlOexB7TMxk9movwqqvbGz7z/Bl6Ip15CyO2v1hiCGQmza1+rZKp
         WjtNTSqB0hLmvbLNs3OSj+wUgtkqM9/f78i2ahM6EhAeX2/ryvunwmkxjzwLMs0YcJ82
         wNnQi08o/pQqc+NQPFqfmmiPtxE0IBAwSm3ZG9SOkO4tKPFj9BRYfdTF4cbOnuMBOaxz
         ErEQ==
Content-Disposition: inline
In-Reply-To: <1395974461-12735-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From c7596b2f33e9f7a57cef6909c30fec268e921c3b Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 15 Apr 2014 18:02:12 -0400

cgroup_apply_cftypes() skip creating or removing files if the
subsystem is attached to the default hierarchy, which led to missing
files in the root of the default hierarchy.

Skipping made sense when the default hierarchy was dummy; however, now
that the default hierarchy is full functional and planned to be used
as the unified hierarchy, it shouldn't be skipped over.

Reported-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9fcdaa7..fbcc710 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2436,10 +2436,6 @@ static int cgroup_apply_cftypes(struct cftype *cfts, bool is_add)
 
 	lockdep_assert_held(&cgroup_tree_mutex);
 
-	/* don't bother if @ss isn't attached */
-	if (ss->root == &cgrp_dfl_root)
-		return 0;
-
 	/* add/rm files for all cgroups created before */
 	css_for_each_descendant_pre(css, cgroup_css(root, ss)) {
 		struct cgroup *cgrp = css->cgroup;
-- 
1.9.0
