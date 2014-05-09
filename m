From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 07/14] cgroup: link all cgroup_subsys_states in their sibling lists
Date: Fri,  9 May 2014 17:31:24 -0400
Message-ID: <1399671091-23867-8-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9i5RjiArj3MIzeWeFzbmGZ47expPvnWh4sEbkjEA65E=;
        b=Uloeo9o44fKiVcBmdB171x09tFcDtfOobHZITDJ7GdN/q5aAVhTDt0/rxmQgGrPCoJ
         sZ6bQdtyiaGh79It2DS37+1oeg0F1G8dmrBYBR2tAWz/ekjP0tjFj4LYmVy7IcnOpDXo
         c6UJ0E02okkrz5TodC0GAE+ZJ/+7DdjfqRFpkEKP2pRpH3ZgD/1/NgOSfPLckgO2E7AB
         iyqxxJDlQl+H1WF1mzgIiPtBc9uEH9Ggy0ijjdDZhRcAVQTbPKO7r0sbINA1DG/mzyEB
         SCq8uxk3SM5W4R+4X9TpmaI9QdnwpQj53/Yj2Vbz5him5cMJF1mgelkoTReGEcH9tWsc
         uMlw==
In-Reply-To: <1399671091-23867-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Currently, while all csses have ->children and ->sibling, only the
self csses of cgroups make use of them.  This patch makes all other
csses to link themselves on the sibling lists too.  This will be used
to update css iteration.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3d6c0aa..6930b78 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4137,19 +4137,21 @@ static void css_release_work_fn(struct work_struct *work)
 	struct cgroup_subsys *ss = css->ss;
 	struct cgroup *cgrp = css->cgroup;
 
+	mutex_lock(&cgroup_mutex);
+
+	list_del_rcu(&css->sibling);
+
 	if (ss) {
 		/* css release path */
 		cgroup_idr_remove(&ss->css_idr, css->id);
 	} else {
 		/* cgroup release path */
-		mutex_lock(&cgroup_mutex);
-		list_del_rcu(&cgrp->self.sibling);
-		mutex_unlock(&cgroup_mutex);
-
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 		cgrp->id = -1;
 	}
 
+	mutex_unlock(&cgroup_mutex);
+
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 }
 
@@ -4229,12 +4231,13 @@ static void offline_css(struct cgroup_subsys_state *css)
 static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
+	struct cgroup_subsys_state *parent_css = cgroup_css(parent, ss);
 	struct cgroup_subsys_state *css;
 	int err;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	css = ss->css_alloc(cgroup_css(parent, ss));
+	css = ss->css_alloc(parent_css);
 	if (IS_ERR(css))
 		return PTR_ERR(css);
 
@@ -4254,11 +4257,12 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 		goto err_free_id;
 
 	/* @css is ready to be brought online now, make it visible */
+	list_add_tail_rcu(&css->sibling, &parent_css->children);
 	cgroup_idr_replace(&ss->css_idr, css, css->id);
 
 	err = online_css(css);
 	if (err)
-		goto err_clear_dir;
+		goto err_list_del;
 
 	if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
 	    cgroup_parent(parent)) {
@@ -4271,7 +4275,8 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	return 0;
 
-err_clear_dir:
+err_list_del:
+	list_del_rcu(&css->sibling);
 	cgroup_clear_dir(css->cgroup, 1 << css->ss->id);
 err_free_id:
 	cgroup_idr_remove(&ss->css_idr, css->id);
-- 
1.9.0
