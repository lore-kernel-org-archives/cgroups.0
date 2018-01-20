From: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 7/9] drm: Add helper to obtain cgroup of drm_file's owning process
Date: Fri, 19 Jan 2018 17:51:39 -0800
Message-ID: <20180120015141.10118-8-matthew.d.roper@intel.com>
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

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/drm/drm_file.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
index 0e0c868451a5..08855a99069c 100644
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -32,6 +32,7 @@
 
 #include <linux/types.h>
 #include <linux/completion.h>
+#include <linux/cgroup.h>
 
 #include <uapi/drm/drm.h>
 
@@ -378,4 +379,31 @@ void drm_event_cancel_free(struct drm_device *dev,
 void drm_send_event_locked(struct drm_device *dev, struct drm_pending_event *e);
 void drm_send_event(struct drm_device *dev, struct drm_pending_event *e);
 
+#ifdef CONFIG_CGROUPS
+/**
+ * drm_file_get_cgroup - obtain cgroup for drm_file's owning process
+ * @file_priv: DRM file
+ * @root: cgroup hierarchy to search for process in
+ *
+ * Obtains the cgroup from a specific hierarchy that the drm_file's owning
+ * process belongs to.  The cgroup may be used to set driver-specific
+ * policy (priority, vram usage, etc.).
+ */
+static inline struct cgroup *
+drm_file_get_cgroup(struct drm_file *file_priv, struct cgroup_root *root)
+{
+	struct task_struct *task = pid_task(file_priv->pid, PIDTYPE_PID);
+	struct cgroup *cgrp;
+
+	mutex_lock(&cgroup_mutex);
+	cgrp = task_cgroup_from_root(task, root);
+	mutex_unlock(&cgroup_mutex);
+
+	return cgrp;
+}
+#else
+static inline struct cgroup *
+drm_file_get_cgroup(struct drm_file *file_priv) { return NULL; }
+#endif
+
 #endif /* _DRM_FILE_H_ */
-- 
2.14.3
