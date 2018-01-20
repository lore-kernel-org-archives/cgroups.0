From: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 3/9] cgroup: Export cgroup_on_dfl() to drivers
Date: Fri, 19 Jan 2018 17:51:35 -0800
Message-ID: <20180120015141.10118-4-matthew.d.roper@intel.com>
References: <20180120015141.10118-1-matthew.d.roper@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180120015141.10118-1-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Drivers may wish to limit their own cgroup operations to cgroups in the
cgroup-v2 hierarchy.  Let's make this helper function usable outside the cgroup
core code.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup.h          | 2 ++
 kernel/cgroup/cgroup-internal.h | 1 -
 kernel/cgroup/cgroup.c          | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c9896027ed99..1c1758ac1a97 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -656,6 +656,8 @@ static inline union kernfs_node_id *cgroup_get_kernfs_id(struct cgroup *cgrp)
 
 void cgroup_path_from_kernfs_id(const union kernfs_node_id *id,
 					char *buf, size_t buflen);
+bool cgroup_on_dfl(const struct cgroup *cgrp);
+
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index b928b27050c6..7338083ee3bc 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -156,7 +156,6 @@ static inline void get_css_set(struct css_set *cset)
 }
 
 bool cgroup_ssid_enabled(int ssid);
-bool cgroup_on_dfl(const struct cgroup *cgrp);
 bool cgroup_is_thread_root(struct cgroup *cgrp);
 bool cgroup_is_threaded(struct cgroup *cgrp);
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f12c32c6ec7f..6069191653f8 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -298,6 +298,7 @@ bool cgroup_on_dfl(const struct cgroup *cgrp)
 {
 	return cgrp->root == &cgrp_dfl_root;
 }
+EXPORT_SYMBOL(cgroup_on_dfl);
 
 /* IDR wrappers which synchronize using cgroup_idr_lock */
 static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
-- 
2.14.3
