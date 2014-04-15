From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0.5/12] cgroup: cgroup_apply_cftypes() shouldn't skip the
	default hierarhcy
Date: Tue, 15 Apr 2014 18:06:27 -0400
Message-ID: <20140415220627.GC13099@mtj.dyndns.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=nHLLtV5l2/wFC9U+DsaG1itVoPhCwxslJkS5Yaf3SLw=;
	b=rehiHFB4uUBti2cY5fVi+EK++u5QoUZkiohpYwexamlxqJUtlQwQUPFyEnOc6RWY6k
	qE9zwSphvK81on8340YNVI/pk37b1Hf5qsd4faRWW4fGF53NFqMI4WzieTkLg5mVji+j
	T4a68pKS29Hiok3Ai2vBZ2iFAfJKj/ZFQUSAtNS6+32kLgM12pLdiELupnFFjGz1DiMo
	PIRWV3ElcE/ngfo4+Xwm9ZFG3HjntcFHnJRg4dBcyS0jTBCH91hMW3bvi6FpqUB2N+e3
	izRX33oEY+AC6VelTisQ5stIC5Qk3Oc9CLh0KeouNwXkDwLJwYxBK6JFMkq2Y7RLvTvu
	CF6Q==
Content-Disposition: inline
In-Reply-To: <1397511430-2673-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
