From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [PATCH 04/17] drm/i915: Account ring buffer and context
 state storage
Date: Wed, 12 Jul 2023 12:45:52 +0100
Message-ID: <20230712114605.519432-5-tvrtko.ursulin@linux.intel.com>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1689162464; x=1720698464;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=OMEwk0X8NNrrJfGShu2S3rKH+WcQr9i/VJ2no0E2OfU=;
 b=ZZ1YpQR9pt5W++90EQa4Lb/q+DFkbHl7HQFdaGs/6Pg9W0PBqyuoogHs
 DKi7AAIG42qG6xqLBenNRh1CO/mBZ/AJ7ypNJP6xCgKtLpiLdgdprQ50F
 DRf1+CWWm3e5b5/+FvF3hWlSaYFkGTFwKVaKxGSgQoWBTpniLFKpHTxL1
 s61/bYBXV7AsLAYeXL4gvmd6BYOVXMWTeoNyNlcgVEylBkA3O7hXd4SHR
 1w1cIqNC06hW/l5qpU4aeMszCcb1yF/gHigCv94QiiLWSx6r5jT0MS30L
 /7U2Bp3WENAfUWTpZ9450x5V1w+qzZlEorL7BpUPc35RnsrbNI/v3XkTr g==;
In-Reply-To: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
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
Content-Type: text/plain; charset="us-ascii"
To: Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Account ring buffers and logical context space against the owning client
memory usage stats.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Aravind Iddamsetty <aravind.iddamsetty@intel.com>
---
 drivers/gpu/drm/i915/gt/intel_context.c | 14 ++++++++++++++
 drivers/gpu/drm/i915/i915_drm_client.c  | 10 ++++++++++
 drivers/gpu/drm/i915/i915_drm_client.h  |  9 +++++++++
 3 files changed, 33 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_context.c b/drivers/gpu/drm/i915/gt/intel_context.c
index a53b26178f0a..a2f1245741bb 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.c
+++ b/drivers/gpu/drm/i915/gt/intel_context.c
@@ -6,6 +6,7 @@
 #include "gem/i915_gem_context.h"
 #include "gem/i915_gem_pm.h"
 
+#include "i915_drm_client.h"
 #include "i915_drv.h"
 #include "i915_trace.h"
 
@@ -50,6 +51,7 @@ intel_context_create(struct intel_engine_cs *engine)
 
 int intel_context_alloc_state(struct intel_context *ce)
 {
+	struct i915_gem_context *ctx;
 	int err = 0;
 
 	if (mutex_lock_interruptible(&ce->pin_mutex))
@@ -66,6 +68,18 @@ int intel_context_alloc_state(struct intel_context *ce)
 			goto unlock;
 
 		set_bit(CONTEXT_ALLOC_BIT, &ce->flags);
+
+		rcu_read_lock();
+		ctx = rcu_dereference(ce->gem_context);
+		if (ctx && !kref_get_unless_zero(&ctx->ref))
+			ctx = NULL;
+		rcu_read_unlock();
+		if (ctx) {
+			if (ctx->client)
+				i915_drm_client_add_context_objects(ctx->client,
+								    ce);
+			i915_gem_context_put(ctx);
+		}
 	}
 
 unlock:
diff --git a/drivers/gpu/drm/i915/i915_drm_client.c b/drivers/gpu/drm/i915/i915_drm_client.c
index 2e5e69edc0f9..a61356012df8 100644
--- a/drivers/gpu/drm/i915/i915_drm_client.c
+++ b/drivers/gpu/drm/i915/i915_drm_client.c
@@ -144,4 +144,14 @@ bool i915_drm_client_remove_object(struct drm_i915_gem_object *obj)
 
 	return true;
 }
+
+void i915_drm_client_add_context_objects(struct i915_drm_client *client,
+					 struct intel_context *ce)
+{
+	if (ce->state)
+		i915_drm_client_add_object(client, ce->state->obj);
+
+	if (ce->ring != ce->engine->legacy.ring && ce->ring->vma)
+		i915_drm_client_add_object(client, ce->ring->vma->obj);
+}
 #endif
diff --git a/drivers/gpu/drm/i915/i915_drm_client.h b/drivers/gpu/drm/i915/i915_drm_client.h
index 5f58fdf7dcb8..69cedfcd3d69 100644
--- a/drivers/gpu/drm/i915/i915_drm_client.h
+++ b/drivers/gpu/drm/i915/i915_drm_client.h
@@ -14,6 +14,7 @@
 
 #include "i915_file_private.h"
 #include "gem/i915_gem_object_types.h"
+#include "gt/intel_context_types.h"
 
 #define I915_LAST_UABI_ENGINE_CLASS I915_ENGINE_CLASS_COMPUTE
 
@@ -70,6 +71,8 @@ void i915_drm_client_fdinfo(struct drm_printer *p, struct drm_file *file);
 void i915_drm_client_add_object(struct i915_drm_client *client,
 				struct drm_i915_gem_object *obj);
 bool i915_drm_client_remove_object(struct drm_i915_gem_object *obj);
+void i915_drm_client_add_context_objects(struct i915_drm_client *client,
+					 struct intel_context *ce);
 #else
 static inline void i915_drm_client_add_object(struct i915_drm_client *client,
 					      struct drm_i915_gem_object *obj)
@@ -79,6 +82,12 @@ static inline void i915_drm_client_add_object(struct i915_drm_client *client,
 static inline bool i915_drm_client_remove_object(struct drm_i915_gem_object *obj)
 {
 }
+
+static inline void
+i915_drm_client_add_context_objects(struct i915_drm_client *client,
+				    struct intel_context *ce)
+{
+}
 #endif
 
 #endif /* !__I915_DRM_CLIENT_H__ */
-- 
2.39.2

