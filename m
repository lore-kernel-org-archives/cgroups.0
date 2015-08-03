From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH] cgroup: fix idr_preload usage
Date: Mon, 3 Aug 2015 15:32:26 +0300
Message-ID: <1438605146-23962-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

It does not make much sense to call idr_preload with the same gfp mask
as the following idr_alloc, but this is what we do in cgroup_idr_alloc.
This patch fixes the idr_preload usage by making cgroup_idr_alloc call
idr_alloc w/o __GFP_WAIT. Since it is now safe to call cgroup_idr_alloc
with GFP_KERNEL, the patch also fixes all its callers appropriately.

Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 kernel/cgroup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 75c5110d09c2..2a33fdc855dc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -210,7 +210,7 @@ static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
 
 	idr_preload(gfp_mask);
 	spin_lock_bh(&cgroup_idr_lock);
-	ret = idr_alloc(idr, ptr, start, end, gfp_mask);
+	ret = idr_alloc(idr, ptr, start, end, gfp_mask & ~__GFP_WAIT);
 	spin_unlock_bh(&cgroup_idr_lock);
 	idr_preload_end();
 	return ret;
@@ -1669,7 +1669,7 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned long ss_mask)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	ret = cgroup_idr_alloc(&root->cgroup_idr, root_cgrp, 1, 2, GFP_NOWAIT);
+	ret = cgroup_idr_alloc(&root->cgroup_idr, root_cgrp, 1, 2, GFP_KERNEL);
 	if (ret < 0)
 		goto out;
 	root_cgrp->id = ret;
@@ -4582,7 +4582,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
 	if (err)
 		goto err_free_css;
 
-	err = cgroup_idr_alloc(&ss->css_idr, NULL, 2, 0, GFP_NOWAIT);
+	err = cgroup_idr_alloc(&ss->css_idr, NULL, 2, 0, GFP_KERNEL);
 	if (err < 0)
 		goto err_free_percpu_ref;
 	css->id = err;
@@ -4659,7 +4659,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	 * Temporarily set the pointer to NULL, so idr_find() won't return
 	 * a half-baked cgroup.
 	 */
-	cgrp->id = cgroup_idr_alloc(&root->cgroup_idr, NULL, 2, 0, GFP_NOWAIT);
+	cgrp->id = cgroup_idr_alloc(&root->cgroup_idr, NULL, 2, 0, GFP_KERNEL);
 	if (cgrp->id < 0) {
 		ret = -ENOMEM;
 		goto out_cancel_ref;
-- 
2.1.4
