From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH cgroup/for-3.14] cgroup: fix fail path in cgroup_load_subsys()
Date: Thu, 12 Dec 2013 23:17:08 +0400
Message-ID: <1386875828-5075-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Calling cgroup_unload_subsys() from cgroup_load_subsys() after
online_css() failure will result in a NULL ptr dereference on attempt to
offline_css(), because online_css() only assigns css to cgroup on
success. Let's fix that by skipping calls to offline_css() and
css_free() in cgroup_unload_subsys() if there is no css, and freeing css
in cgroup_load_subsys() on online_css() failure.

Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 402f7aa..7030f04 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4652,8 +4652,10 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	write_unlock(&css_set_lock);
 
 	ret = online_css(css);
-	if (ret)
+	if (ret) {
+		ss->css_free(css);
 		goto err_unload;
+	}
 
 	/* success! */
 	mutex_unlock(&cgroup_root_mutex);
@@ -4680,6 +4682,7 @@ EXPORT_SYMBOL_GPL(cgroup_load_subsys);
 void cgroup_unload_subsys(struct cgroup_subsys *ss)
 {
 	struct cgrp_cset_link *link;
+	struct cgroup_subsys_state *css;
 
 	BUG_ON(ss->module == NULL);
 
@@ -4693,7 +4696,9 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	mutex_lock(&cgroup_mutex);
 	mutex_lock(&cgroup_root_mutex);
 
-	offline_css(cgroup_css(cgroup_dummy_top, ss));
+	css = cgroup_css(cgroup_dummy_top, ss);
+	if (css)
+		offline_css(css);
 
 	/* deassign the subsys_id */
 	cgroup_subsys[ss->subsys_id] = NULL;
@@ -4720,7 +4725,8 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	 * need to free before marking as null because ss->css_free needs
 	 * the cgrp->subsys pointer to find their state.
 	 */
-	ss->css_free(cgroup_css(cgroup_dummy_top, ss));
+	if (css)
+		ss->css_free(css);
 	RCU_INIT_POINTER(cgroup_dummy_top->subsys[ss->subsys_id], NULL);
 
 	mutex_unlock(&cgroup_root_mutex);
-- 
1.7.1
