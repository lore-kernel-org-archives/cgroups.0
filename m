From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 07/17] drm/i915: i915 priority
Date: Wed, 19 Oct 2022 18:32:44 +0100
Message-ID: <20221019173254.3361334-8-tvrtko.ursulin@linux.intel.com>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1666200823; x=1697736823;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=OrYOCnpePJk9ybiiJejaW8hbTOJ7aQUhUryDqIC49tk=;
 b=i0J4LWpaiKVIzZEFHS2y5ithuHig42FrqgGUSx7JE4bqbE3EZzn4K/WH
 Ow6HvUB43bImX7+yMJ7ZHq7erOkj9w28QmhvEiRwuTOe+465TdzUASR53
 SOjXXWazGAY8NvmgJtHnCceDfxWY1GG0leLNic3dCft9dAjLgBhSktXaT
 c8769vg7uelCgwu8GzKgg094qcLvzbm+hquFbFjGAyKMaZOjtrXm5g6eO
 c9kcHkmsH7NDd6it68+t4/OP+5ZuoHCUCpEWCUQjYLwt0nIWFIU6ZLRFX
 8bg69Mr+gcjP6e44D5/PD03lLRJdYStjGQHG95JcuSk+IbyjPfsctw+Qd Q==;
In-Reply-To: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
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
To: Intel-gfx@lists.freedesktop.org
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Register i915 as supporting the drm cgroup controller priority management
and wire it up at execbuf time.

GEM context configured priority then works as a relative value on top of
the base level obtained from the drm cgroup controller.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 27 ++++++++++++++++++-
 drivers/gpu/drm/i915/i915_driver.c            | 10 +++++++
 drivers/gpu/drm/i915/i915_drm_client.c        | 16 +++++++++++
 drivers/gpu/drm/i915/i915_drm_client.h        |  4 +++
 4 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/d=
rm/i915/gem/i915_gem_execbuffer.c
index 1160723c9d2d..391c5b5c80be 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -4,8 +4,10 @@
  * Copyright =C2=A9 2008,2010 Intel Corporation
  */
=20
+#include <linux/cgroup_drm.h>
 #include <linux/dma-resv.h>
 #include <linux/highmem.h>
+#include <linux/minmax.h>
 #include <linux/sync_file.h>
 #include <linux/uaccess.h>
=20
@@ -3015,6 +3017,29 @@ static void retire_requests(struct intel_timeline *t=
l, struct i915_request *end)
 			break;
 }
=20
+#ifdef CONFIG_CGROUP_DRM
+static void copy_priority(struct i915_sched_attr *attr,
+			  const struct i915_execbuffer *eb)
+{
+	const int scale =3D DIV_ROUND_CLOSEST(DRM_CGROUP_PRIORITY_MAX,
+					    I915_CONTEXT_MAX_USER_PRIORITY);
+	int prio;
+
+	*attr =3D eb->gem_context->sched;
+	prio =3D attr->priority * scale + eb->file->drm_cgroup_priority;
+	prio =3D DIV_ROUND_UP(prio, scale);
+	attr->priority =3D clamp(prio,
+			       I915_CONTEXT_MIN_USER_PRIORITY,
+			       I915_CONTEXT_MAX_USER_PRIORITY);
+}
+#else
+static void copy_priority(struct i915_sched_attr *attr,
+			  const struct i915_execbuffer *eb)
+{
+	*attr =3D eb->gem_context->sched;
+}
+#endif
+
 static int eb_request_add(struct i915_execbuffer *eb, struct i915_request =
*rq,
 			  int err, bool last_parallel)
 {
@@ -3031,7 +3056,7 @@ static int eb_request_add(struct i915_execbuffer *eb,=
 struct i915_request *rq,
=20
 	/* Check that the context wasn't destroyed before submission */
 	if (likely(!intel_context_is_closed(eb->context))) {
-		attr =3D eb->gem_context->sched;
+		copy_priority(&attr, eb);
 	} else {
 		/* Serialise with context_close via the add_to_timeline */
 		i915_request_set_error_once(rq, -ENOENT);
diff --git a/drivers/gpu/drm/i915/i915_driver.c b/drivers/gpu/drm/i915/i915=
_driver.c
index ffff49868dc5..7912782b87cc 100644
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -1893,6 +1893,12 @@ static const struct drm_ioctl_desc i915_ioctls[] =3D=
 {
 	DRM_IOCTL_DEF_DRV(I915_GEM_VM_DESTROY, i915_gem_vm_destroy_ioctl, DRM_REN=
DER_ALLOW),
 };
=20
+#ifdef CONFIG_CGROUP_DRM
+static const struct drm_cgroup_ops i915_drm_cgroup_ops =3D {
+	.priority_levels =3D i915_drm_priority_levels,
+};
+#endif
+
 /*
  * Interface history:
  *
@@ -1921,6 +1927,10 @@ static const struct drm_driver i915_drm_driver =3D {
 	.lastclose =3D i915_driver_lastclose,
 	.postclose =3D i915_driver_postclose,
=20
+#ifdef CONFIG_CGROUP_DRM
+	.cg_ops =3D &i915_drm_cgroup_ops,
+#endif
+
 	.prime_handle_to_fd =3D drm_gem_prime_handle_to_fd,
 	.prime_fd_to_handle =3D drm_gem_prime_fd_to_handle,
 	.gem_prime_import =3D i915_gem_prime_import,
diff --git a/drivers/gpu/drm/i915/i915_drm_client.c b/drivers/gpu/drm/i915/=
i915_drm_client.c
index b09d1d386574..61a3cdaa7b16 100644
--- a/drivers/gpu/drm/i915/i915_drm_client.c
+++ b/drivers/gpu/drm/i915/i915_drm_client.c
@@ -75,6 +75,22 @@ void i915_drm_clients_fini(struct i915_drm_clients *clie=
nts)
 	xa_destroy(&clients->xarray);
 }
=20
+#ifdef CONFIG_CGROUP_DRM
+unsigned int i915_drm_priority_levels(struct drm_file *file)
+{
+	struct drm_i915_file_private *fpriv =3D file->driver_priv;
+	struct i915_drm_client *client =3D fpriv->client;
+	struct drm_i915_private *i915 =3D client->clients->i915;
+
+	if (GRAPHICS_VER(i915) < 8)
+		return 0;
+	else if (intel_uc_uses_guc_submission(&to_gt(i915)->uc))
+		return 3;
+	else
+		return 2047;
+}
+#endif
+
 #ifdef CONFIG_PROC_FS
 static const char * const uabi_class_names[] =3D {
 	[I915_ENGINE_CLASS_RENDER] =3D "render",
diff --git a/drivers/gpu/drm/i915/i915_drm_client.h b/drivers/gpu/drm/i915/=
i915_drm_client.h
index 69496af996d9..bd5925241007 100644
--- a/drivers/gpu/drm/i915/i915_drm_client.h
+++ b/drivers/gpu/drm/i915/i915_drm_client.h
@@ -15,6 +15,8 @@
=20
 #define I915_LAST_UABI_ENGINE_CLASS I915_ENGINE_CLASS_COMPUTE
=20
+struct drm_file;
+
 struct drm_i915_private;
=20
 struct i915_drm_clients {
@@ -65,4 +67,6 @@ void i915_drm_client_fdinfo(struct seq_file *m, struct fi=
le *f);
=20
 void i915_drm_clients_fini(struct i915_drm_clients *clients);
=20
+unsigned int i915_drm_priority_levels(struct drm_file *file);
+
 #endif /* !__I915_DRM_CLIENT_H__ */
--=20
2.34.1

