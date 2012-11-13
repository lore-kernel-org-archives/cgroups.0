From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 13/17] cgroup: simplify cgroup_load_subsys() failure path
Date: Mon, 12 Nov 2012 19:01:40 -0800
Message-ID: <1352775704-9023-14-git-send-email-tj@kernel.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=dCiwDldr1bISU5vxemq2xvg8We1PZX5IuPfKK9G1iP8=;
        b=oqHf3KqKfq8sm5uUkI5OMb7nRyHSmPf85bf3Kb7B6j6PsrmXk2m63p3zj1RTaMlrDJ
         pcdM+xUKwdGnFsEfjCDrUCFLoBd9Wdbz4mwi+w+6KkRBt7mvv8wvE/VngQ8oTgVIsdJx
         7H3PiohDQ9A4mOpGnWx11Oo/oIyUJlc4ZwUcgr4v60REFhKBQtUH8cyPhF3ymY1RCiYX
         NPYJ0kJJ8kgsZ1eogGW9ZlKZH+RwRcSSec8gs0TFAN2nGizcwCbGUtV/ianiknUykJ2Z
         fJl4xVHww9Dh0SlYCk2WZgnCjOsEGaft6vat7jc8Hmw3UhbbwRegLyg5sOtyJQTBjlYP
         60iA==
In-Reply-To: <1352775704-9023-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Now that cgroup_unload_subsys() can tell whether the root css is
online or not, we can safely call cgroup_unload_subsys() after idr
init failure in cgroup_load_subsys().

Replace the manual unrolling and invoke cgroup_unload_subsys() on
failure.  This drops cgroup_mutex inbetween but should be safe as the
subsystem will fail try_module_get() and thus can't be mounted
inbetween.  As this means that cgroup_unload_subsys() can be called
before css_sets are rehashed, remove BUG_ON() on %NULL
css_set->subsys[] from cgroup_unload_subsys().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c3087f5..b42f63f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4400,8 +4400,8 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
  */
 int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 {
-	int i;
 	struct cgroup_subsys_state *css;
+	int i, ret;
 
 	/* check name and function validity */
 	if (ss->name == NULL || strlen(ss->name) > MAX_CGROUP_TYPE_NAMELEN ||
@@ -4452,15 +4452,9 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	init_cgroup_css(css, ss, dummytop);
 	/* init_idr must be after init_cgroup_css because it sets css->id. */
 	if (ss->use_id) {
-		int ret = cgroup_init_idr(ss, css);
-		if (ret) {
-			ss->destroy(dummytop);
-			dummytop->subsys[ss->subsys_id] = NULL;
-			subsys[ss->subsys_id] = NULL;
-			list_del_init(&ss->sibling);
-			mutex_unlock(&cgroup_mutex);
-			return ret;
-		}
+		ret = cgroup_init_idr(ss, css);
+		if (ret)
+			goto err_unload;
 	}
 
 	/*
@@ -4498,6 +4492,12 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	/* success! */
 	mutex_unlock(&cgroup_mutex);
 	return 0;
+
+err_unload:
+	mutex_unlock(&cgroup_mutex);
+	/* @ss can't be mounted here as try_module_get() would fail */
+	cgroup_unload_subsys(ss);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(cgroup_load_subsys);
 
@@ -4548,7 +4548,6 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 		struct css_set *cg = link->cg;
 
 		hlist_del(&cg->hlist);
-		BUG_ON(!cg->subsys[ss->subsys_id]);
 		cg->subsys[ss->subsys_id] = NULL;
 		hhead = css_set_hash(cg->subsys);
 		hlist_add_head(&cg->hlist, hhead);
-- 
1.7.11.7
