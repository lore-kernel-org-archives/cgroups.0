From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix a failure path in create_css()
Date: Tue, 18 Mar 2014 17:02:36 +0800
Message-ID: <53280BAC.5060404@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If online_css() fails, we should remove cgroup files belonging
to css->ss.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3790617..e673407 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3408,17 +3408,17 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	err = percpu_ref_init(&css->refcnt, css_release);
 	if (err)
-		goto err_free;
+		goto err_free_css;
 
 	init_css(css, ss, cgrp);
 
 	err = cgroup_populate_dir(cgrp, 1 << ss->id);
 	if (err)
-		goto err_free;
+		goto err_free_percpu_ref;
 
 	err = online_css(css);
 	if (err)
-		goto err_free;
+		goto err_clear_dir;
 
 	cgroup_get(cgrp);
 	css_get(css->parent);
@@ -3434,8 +3434,11 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	return 0;
 
-err_free:
+err_clear_dir:
+	cgroup_clear_dir(css->cgroup, 1 << css->ss->id);
+err_free_percpu_ref:
 	percpu_ref_cancel_init(&css->refcnt);
+err_free_css:
 	ss->css_free(css);
 	return err;
 }
-- 
1.8.0.2
