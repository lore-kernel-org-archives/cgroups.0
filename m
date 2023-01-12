From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 09/12] cgroup/drm: Client exit hook
Date: Thu, 12 Jan 2023 16:56:06 +0000
Message-ID: <20230112165609.1083270-10-tvrtko.ursulin@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1673542673; x=1705078673;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=wO4vq8DTSbSrK6Q8SSiu3RWC+/DM/VhnYEUQ6NLXXx0=;
 b=TC796vYsJ8JOXMGv1HNywJG9U8Z/Tghl6V/HVSbKB1rrVkFQFg6J3jFH
 BigP0ie4fCTNFwjVOvSCsipl/A/dR1bJ6Qc6gGpMVntsUC7d2fOsqWhQR
 6t8ARVD2fZTUgGBJBzrkrbxBBHXx+zKQvGQRQsGeilLlpX6iwIA95QZIf
 LPJJncYEtd7qjn03y5UiOC4Y1yhLKQT4eNj7k/nJSMulLuvPrrUml6o4u
 dy/5yCwsAgvlUQWhscdWZgF99AQ5GtwZGZ7T9fH/C43MR/93O3YT7j1UJ
 BmYYswX4sTG3f7C6mxJUqZGQ6DPf/h12KAOcghzbbQcuKclJmnlYiSYJM Q==;
In-Reply-To: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

We need the ability for DRM core to inform the cgroup controller when a
client has closed a DRM file descriptor. This will allow us not needing
to keep state relating to GPU time usage by tasks sets in the cgroup
controller itself.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 drivers/gpu/drm/drm_cgroup.c |  9 +++++++++
 include/linux/cgroup_drm.h   |  4 ++++
 kernel/cgroup/drm.c          | 13 +++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/drm_cgroup.c b/drivers/gpu/drm/drm_cgroup.c
index 09249f795af3..ea1479d05355 100644
--- a/drivers/gpu/drm/drm_cgroup.c
+++ b/drivers/gpu/drm/drm_cgroup.c
@@ -3,6 +3,8 @@
  * Copyright =C2=A9 2022 Intel Corporation
  */
=20
+#include <linux/cgroup_drm.h>
+
 #include <drm/drm_drv.h>
 #include <drm/drm_clients.h>
 #include <drm/drm_print.h>
@@ -32,6 +34,7 @@ void drm_clients_close(struct drm_file *file_priv)
 {
 	struct drm_device *dev =3D file_priv->minor->dev;
 	struct drm_pid_clients *clients;
+	struct task_struct *task;
 	struct pid *pid;
=20
 	lockdep_assert_held(&dev->filelist_mutex);
@@ -44,6 +47,12 @@ void drm_clients_close(struct drm_file *file_priv)
 	if (drm_WARN_ON_ONCE(dev, !clients))
 		return;
=20
+	task =3D get_pid_task(pid, PIDTYPE_PID);
+	if (task) {
+		drmcgroup_client_exited(task);
+		put_task_struct(task);
+	}
+
 	__del_clients(clients, file_priv, (unsigned long)pid);
 }
=20
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
index bf8abc6b8ebf..2f755b896136 100644
--- a/include/linux/cgroup_drm.h
+++ b/include/linux/cgroup_drm.h
@@ -6,4 +6,8 @@
 #ifndef _CGROUP_DRM_H
 #define _CGROUP_DRM_H
=20
+struct task_struct;
+
+void drmcgroup_client_exited(struct task_struct *task);
+
 #endif	/* _CGROUP_DRM_H */
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index 48a8d646a094..3e7f165806de 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -22,6 +22,11 @@ css_to_drmcs(struct cgroup_subsys_state *css)
 	return container_of(css, struct drm_cgroup_state, css);
 }
=20
+static inline struct drm_cgroup_state *get_task_drmcs(struct task_struct *=
task)
+{
+	return css_to_drmcs(task_get_css(task, drm_cgrp_id));
+}
+
 static struct drm_root_cgroup_state root_drmcs;
=20
 static void drmcs_free(struct cgroup_subsys_state *css)
@@ -46,6 +51,14 @@ drmcs_alloc(struct cgroup_subsys_state *parent_css)
 	return &drmcs->css;
 }
=20
+void drmcgroup_client_exited(struct task_struct *task)
+{
+	struct drm_cgroup_state *drmcs =3D get_task_drmcs(task);
+
+	css_put(&drmcs->css);
+}
+EXPORT_SYMBOL_GPL(drmcgroup_client_exited);
+
 struct cftype files[] =3D {
 	{ } /* Zero entry terminates. */
 };
--=20
2.34.1

