From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 9/8] cgroup: fix RCU related sparse warnings
Date: Thu, 22 Dec 2016 12:29:00 -0500
Message-ID: <20161222172900.GD31216@htj.duckdns.org>
References: <20161220210827.11176-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O/Nw0zLFL0o1YCZYvGy8Brm5sL7xGdKpsiCSu6lcXrE=;
        b=YPivIpYIfyp/eVJrtJwZjTQi2UJcz2ZFgZmEB0n7G3GFB+s22dW6hK7uaOX/mZImOa
         PCWiPVqEE00JXIG2qWNZ74kqnxFwzfJJZYguhNnSrp6Q5pO7hKty/xI7EOwLQhcXnv8t
         g8WJmZgNOWForVLil/FFRMy8bnwyIAB2t4T4jtVqtMk7Y8vLtLmTrPccYv/pgTzYLqZj
         dauavkXLlvMZnUgiz0N+VYhXqvG+AFKc1Yd7XCWQFfQIG73Mq9AH/0RzAeToAW3VdSG2
         ZXgYQHTS3aZCseaw7of97n+Lrt3y3rkXvg6cw3rcnoxs5G2cExTl0YFzpZv+1QofF3NG
         A4qg==
Content-Disposition: inline
In-Reply-To: <20161220210827.11176-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

From 9ca76e7e3cb885bc5701e9b1fe90c44f4aef123a Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Thu, 22 Dec 2016 12:28:01 -0500

kn->priv which is a void * is used as a RCU pointer by cgroup.  When
dereferencing it, it was passing kn->priv to rcu_derefreence() without
casting it into a RCU pointer triggering address space mismatch
warning from sparse.  Fix them.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 2 +-
 kernel/cgroup/cgroup.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 37be09e..465b101 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -694,7 +694,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	 * @kn->priv is RCU safe.  Let's do the RCU dancing.
 	 */
 	rcu_read_lock();
-	cgrp = rcu_dereference(kn->priv);
+	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
 	if (!cgrp || cgroup_is_dead(cgrp)) {
 		rcu_read_unlock();
 		mutex_unlock(&cgroup_mutex);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b6b9068..d9d82e9 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4932,7 +4932,7 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 	 * have been or be removed at any point.  @kn->priv is RCU
 	 * protected for this access.  See css_release_work_fn() for details.
 	 */
-	cgrp = rcu_dereference(kn->priv);
+	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
 	if (cgrp)
 		css = cgroup_css(cgrp, ss);
 
-- 
2.9.3
