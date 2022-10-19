From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 16/17] drm/i915: Wire up with drm controller GPU
 time query
Date: Wed, 19 Oct 2022 18:32:53 +0100
Message-ID: <20221019173254.3361334-17-tvrtko.ursulin@linux.intel.com>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1666200853; x=1697736853;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=oo5u0fET53D72nvRAabovnCgKyLAZjX42LHHrPrrjv8=;
 b=Ronbna1vVCkoz8LHYCfGKsKdfqMiqzFjXIbyXvg0H8t8+3nXiohq3W/J
 /zWu+QkljJkao/ZcQ5T1TFF0UDQJBLIuQJkXv00Th213jnkqX6p/lvUO4
 1DHrnlS2usY9txEy0bv7eidGq+UsXjIP9Xobz/+5NDXhJF42p1KuJ9FVa
 bdYW8BqdeKxGrudfZIVA2SeHrgDA9LYwKlGfqxMF8Q4Vg3O8brYNA+rmp
 fAsD3SZgDCBQx5I/+O7KBp+7i3AxoUWtTe+SEbH9Qfe97Cmg/hXhSdPwa
 YVYf8I9bKKVvHz6GOaxVqV8kxiqp8caIY4vS55JUhh8mk+nvEuOpXDCQ9 g==;
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
Content-Type: text/plain; charset="us-ascii"
To: Intel-gfx@lists.freedesktop.org
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Implement the drm_cgroup_ops->active_time_us callback.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 drivers/gpu/drm/i915/i915_driver.c     |   1 +
 drivers/gpu/drm/i915/i915_drm_client.c | 106 +++++++++++++++++++------
 drivers/gpu/drm/i915/i915_drm_client.h |   2 +
 3 files changed, 83 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_driver.c b/drivers/gpu/drm/i915/i915_driver.c
index 7912782b87cc..b949fd715202 100644
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -1896,6 +1896,7 @@ static const struct drm_ioctl_desc i915_ioctls[] = {
 #ifdef CONFIG_CGROUP_DRM
 static const struct drm_cgroup_ops i915_drm_cgroup_ops = {
 	.priority_levels = i915_drm_priority_levels,
+	.active_time_us = i915_drm_cgroup_get_active_time_us,
 };
 #endif
 
diff --git a/drivers/gpu/drm/i915/i915_drm_client.c b/drivers/gpu/drm/i915/i915_drm_client.c
index 61a3cdaa7b16..8527fe80d449 100644
--- a/drivers/gpu/drm/i915/i915_drm_client.c
+++ b/drivers/gpu/drm/i915/i915_drm_client.c
@@ -75,23 +75,7 @@ void i915_drm_clients_fini(struct i915_drm_clients *clients)
 	xa_destroy(&clients->xarray);
 }
 
-#ifdef CONFIG_CGROUP_DRM
-unsigned int i915_drm_priority_levels(struct drm_file *file)
-{
-	struct drm_i915_file_private *fpriv = file->driver_priv;
-	struct i915_drm_client *client = fpriv->client;
-	struct drm_i915_private *i915 = client->clients->i915;
-
-	if (GRAPHICS_VER(i915) < 8)
-		return 0;
-	else if (intel_uc_uses_guc_submission(&to_gt(i915)->uc))
-		return 3;
-	else
-		return 2047;
-}
-#endif
-
-#ifdef CONFIG_PROC_FS
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_CGROUP_DRM)
 static const char * const uabi_class_names[] = {
 	[I915_ENGINE_CLASS_RENDER] = "render",
 	[I915_ENGINE_CLASS_COPY] = "copy",
@@ -116,22 +100,92 @@ static u64 busy_add(struct i915_gem_context *ctx, unsigned int class)
 	return total;
 }
 
-static void
-show_client_class(struct seq_file *m,
-		  struct i915_drm_client *client,
-		  unsigned int class)
+static u64 get_class_active_ns(struct i915_drm_client *client,
+			       unsigned int class,
+			       unsigned int *capacity)
 {
-	const struct list_head *list = &client->ctx_list;
-	u64 total = atomic64_read(&client->past_runtime[class]);
-	const unsigned int capacity =
-		client->clients->i915->engine_uabi_class_count[class];
 	struct i915_gem_context *ctx;
+	u64 total;
+
+	*capacity =
+	    client->clients->i915->engine_uabi_class_count[class];
+	if (!*capacity)
+		return 0;
+
+	total = atomic64_read(&client->past_runtime[class]);
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(ctx, list, client_link)
+	list_for_each_entry_rcu(ctx, &client->ctx_list, client_link)
 		total += busy_add(ctx, class);
 	rcu_read_unlock();
 
+	return total;
+}
+#endif
+
+#ifdef CONFIG_CGROUP_DRM
+unsigned int i915_drm_priority_levels(struct drm_file *file)
+{
+	struct drm_i915_file_private *fpriv = file->driver_priv;
+	struct i915_drm_client *client = fpriv->client;
+	struct drm_i915_private *i915 = client->clients->i915;
+
+	if (GRAPHICS_VER(i915) < 8)
+		return 0;
+	else if (intel_uc_uses_guc_submission(&to_gt(i915)->uc))
+		return 3;
+	else
+		return 2047;
+}
+
+static bool supports_stats(struct drm_i915_private *i915)
+{
+	if (GRAPHICS_VER(i915) < 8)
+		return false;
+
+	/* temporary... */
+	if (intel_uc_uses_guc_submission(&to_gt(i915)->uc))
+		return false;
+
+	return true;
+}
+
+u64 i915_drm_cgroup_get_active_time_us(struct drm_file *file)
+{
+	struct drm_i915_file_private *fpriv = file->driver_priv;
+	struct i915_drm_client *client = fpriv->client;
+	unsigned int i;
+	u64 busy = 0;
+
+	if (!supports_stats(client->clients->i915))
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(uabi_class_names); i++) {
+		unsigned int capacity;
+		u64 b;
+
+		b = get_class_active_ns(client, i, &capacity);
+		if (capacity) {
+			b = DIV_ROUND_UP_ULL(b, capacity * 1000);
+			busy += b;
+		}
+	}
+
+	return busy;
+}
+#endif
+
+#ifdef CONFIG_PROC_FS
+static void
+show_client_class(struct seq_file *m,
+		  struct i915_drm_client *client,
+		  unsigned int class)
+{
+	unsigned int capacity;
+	u64 total;
+
+	total = get_class_active_ns(client, class, &capacity);
+
 	if (capacity)
 		seq_printf(m, "drm-engine-%s:\t%llu ns\n",
 			   uabi_class_names[class], total);
diff --git a/drivers/gpu/drm/i915/i915_drm_client.h b/drivers/gpu/drm/i915/i915_drm_client.h
index bd5925241007..99b8ae01c183 100644
--- a/drivers/gpu/drm/i915/i915_drm_client.h
+++ b/drivers/gpu/drm/i915/i915_drm_client.h
@@ -69,4 +69,6 @@ void i915_drm_clients_fini(struct i915_drm_clients *clients);
 
 unsigned int i915_drm_priority_levels(struct drm_file *file);
 
+u64 i915_drm_cgroup_get_active_time_us(struct drm_file *file);
+
 #endif /* !__I915_DRM_CLIENT_H__ */
-- 
2.34.1

