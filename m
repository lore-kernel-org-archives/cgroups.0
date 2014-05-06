From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/5] cgroup: remove cgroup->control_kn
Date: Tue,  6 May 2014 08:44:26 -0400
Message-ID: <1399380266-3324-6-git-send-email-tj@kernel.org>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pNFWHMxjg0Tap7BOCCl3r9cmHu9HLskeLzYuhvEwOWM=;
        b=aqfEtPbViN/ElpbVAwmSmh4B5mLSS0HBocvckovXzd5Fb69F4ZnkVYsU3m0gBHl4j1
         mIUVoqUOwgJ8wmt9oOXGjKsMBKh8rVca5C3SE8oW3bIsWWkrQCYPoiScJ/ZBvmJyqyHb
         bpDWFIJ2sPBIQiNn/00Yjz7FADIjJR8kwL73VSsydfrdDiWfy2WW+psWNus6lAvwSa3q
         h8v+/U2A6Ewr7DG9Xb8BSCeycLqRsonKDIqecsTrnu/iggQdyh+Y8zSIbPjIwjS8sIky
         a01hv0FTpJm18pTsGpRrdjguO5rAZAWqS5ITe+Tw57YFa0BRwGQHsoI2vV3I5LRzU7OC
         12GA==
In-Reply-To: <1399380266-3324-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Now that cgroup_subtree_control_write() has access to the associated
kernfs_open_file and thus the kernfs_node, there's no need to cache it
in cgroup->control_kn on creation.  Remove cgroup->control_kn and use
@of->kn directly.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h | 1 -
 kernel/cgroup.c        | 8 +++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f8cfadb..037fa80 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -179,7 +179,6 @@ struct cgroup {
 
 	struct cgroup *parent;		/* my parent */
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
-	struct kernfs_node *control_kn;	/* kn for "cgroup.subtree_control" */
 	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
 
 	/*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 06ad484..eeb4b62 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2578,7 +2578,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 * active_ref protection.
 	 */
 	cgroup_get(cgrp);
-	kernfs_break_active_protection(cgrp->control_kn);
+	kernfs_break_active_protection(of->kn);
 
 	mutex_lock(&cgroup_tree_mutex);
 
@@ -2695,7 +2695,7 @@ out_unlock:
 out_unlock_tree:
 	mutex_unlock(&cgroup_tree_mutex);
 out_unbreak:
-	kernfs_unbreak_active_protection(cgrp->control_kn);
+	kernfs_unbreak_active_protection(of->kn);
 	cgroup_put(cgrp);
 	return ret ?: nbytes;
 
@@ -2885,9 +2885,7 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 		return ret;
 	}
 
-	if (cft->seq_show == cgroup_subtree_control_show)
-		cgrp->control_kn = kn;
-	else if (cft->seq_show == cgroup_populated_show)
+	if (cft->seq_show == cgroup_populated_show)
 		cgrp->populated_kn = kn;
 	return 0;
 }
-- 
1.9.0
