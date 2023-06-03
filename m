From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: make cgroup_is_threaded() and cgroup_is_thread_root() static
Date: Sat, 3 Jun 2023 15:13:04 +0800
Message-ID: <20230603071304.1077085-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

They're only called inside cgroup.c. Make them static.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup-internal.h | 2 --
 kernel/cgroup/cgroup.c          | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 367b0a42ada9..c56071f150f2 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -220,8 +220,6 @@ static inline void get_css_set(struct css_set *cset)
 
 bool cgroup_ssid_enabled(int ssid);
 bool cgroup_on_dfl(const struct cgroup *cgrp);
-bool cgroup_is_thread_root(struct cgroup *cgrp);
-bool cgroup_is_threaded(struct cgroup *cgrp);
 
 struct cgroup_root *cgroup_root_from_kf(struct kernfs_root *kf_root);
 struct cgroup *task_cgroup_from_root(struct task_struct *task,
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 8b8ca2e01019..824e3b465f6f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -357,7 +357,7 @@ static bool cgroup_has_tasks(struct cgroup *cgrp)
 	return cgrp->nr_populated_csets;
 }
 
-bool cgroup_is_threaded(struct cgroup *cgrp)
+static bool cgroup_is_threaded(struct cgroup *cgrp)
 {
 	return cgrp->dom_cgrp != cgrp;
 }
@@ -396,7 +396,7 @@ static bool cgroup_can_be_thread_root(struct cgroup *cgrp)
 }
 
 /* is @cgrp root of a threaded subtree? */
-bool cgroup_is_thread_root(struct cgroup *cgrp)
+static bool cgroup_is_thread_root(struct cgroup *cgrp)
 {
 	/* thread root should be a domain */
 	if (cgroup_is_threaded(cgrp))
-- 
2.27.0

