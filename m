From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] cgroup: remove some useless forward declarations
Date: Wed, 17 Sep 2014 18:18:09 +0800
Message-ID: <54195FE1.9030607@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h | 1 -
 kernel/cgroup.c        | 2 --
 2 files changed, 3 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b5223c5..f7898e0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -27,7 +27,6 @@
 
 struct cgroup_root;
 struct cgroup_subsys;
-struct inode;
 struct cgroup;
 
 extern int cgroup_init_early(void);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 940aced..0ce9d9e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -185,7 +185,6 @@ static int need_forkexit_callback __read_mostly;
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
-static void cgroup_put(struct cgroup *cgrp);
 static int rebind_subsystems(struct cgroup_root *dst_root,
 			     unsigned int ss_mask);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
@@ -195,7 +194,6 @@ static void css_release(struct percpu_ref *ref);
 static void kill_css(struct cgroup_subsys_state *css);
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
-static void cgroup_pidlist_destroy_all(struct cgroup *cgrp);
 
 /* IDR wrappers which synchronize using cgroup_idr_lock */
 static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
-- 
1.8.0.2
