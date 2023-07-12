From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [PATCH 01/17] drm/i915: Add ability for tracking buffer
 objects per client
Date: Wed, 12 Jul 2023 12:45:49 +0100
Message-ID: <20230712114605.519432-2-tvrtko.ursulin@linux.intel.com>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1689162461; x=1720698461;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=jIekYEv/mCaiq571PcVklUhND7deBIECiGN863EZEiE=;
 b=QCpPFtx/vXciiPwI0MEhqv0rlstki7HwcRpuCiip8RRQdB5dufgVrgQW
 K9yO0dZno9sti/HxmBL3qN5DSCVNpnA7NDVODzqZ/QKGmW2l0d07YvvY4
 1x7xNeeyYMOHdFEwrbLH36+3ia1qSzoY/STf7lXcTPsrKUg9TsMLD8wcF
 xOiRm5VuahqHYJ/r9klHzkZKj1uhZtqaWN31f4FHgFrVExaupB0yAI3Hd
 o15oqHAv1lkdFAWVymQ+VHVw/bRisgRQUgBXtdFQ/G2iVhz8TvZNctUNz
 ILzNv7hUiexUwYV4PK3gt0awtLbTHNO9cysK4tm2qevj6sDNott2NMvWH g==;
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

In order to show per client memory usage lets add some infrastructure
which enables tracking buffer objects owned by clients.

We add a per client list protected by a new per client lock and to support
delayed destruction (post client exit) we make tracked objects hold
references to the owning client.

Also, object memory region teardown is moved to the existing RCU free
callback to allow safe dereference from the fdinfo RCU read section.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_object.c    | 13 +++++--
 .../gpu/drm/i915/gem/i915_gem_object_types.h  | 12 +++++++
 drivers/gpu/drm/i915/i915_drm_client.c        | 36 +++++++++++++++++++
 drivers/gpu/drm/i915/i915_drm_client.h        | 32 +++++++++++++++++
 4 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.c b/drivers/gpu/drm/i915/gem/i915_gem_object.c
index 97ac6fb37958..3dc4fbb67d2b 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -105,6 +105,10 @@ void i915_gem_object_init(struct drm_i915_gem_object *obj,
 
 	INIT_LIST_HEAD(&obj->mm.link);
 
+#ifdef CONFIG_PROC_FS
+	INIT_LIST_HEAD(&obj->client_link);
+#endif
+
 	INIT_LIST_HEAD(&obj->lut_list);
 	spin_lock_init(&obj->lut_lock);
 
@@ -292,6 +296,10 @@ void __i915_gem_free_object_rcu(struct rcu_head *head)
 		container_of(head, typeof(*obj), rcu);
 	struct drm_i915_private *i915 = to_i915(obj->base.dev);
 
+	/* We need to keep this alive for RCU read access from fdinfo. */
+	if (obj->mm.n_placements > 1)
+		kfree(obj->mm.placements);
+
 	i915_gem_object_free(obj);
 
 	GEM_BUG_ON(!atomic_read(&i915->mm.free_count));
@@ -388,9 +396,6 @@ void __i915_gem_free_object(struct drm_i915_gem_object *obj)
 	if (obj->ops->release)
 		obj->ops->release(obj);
 
-	if (obj->mm.n_placements > 1)
-		kfree(obj->mm.placements);
-
 	if (obj->shares_resv_from)
 		i915_vm_resv_put(obj->shares_resv_from);
 
@@ -441,6 +446,8 @@ static void i915_gem_free_object(struct drm_gem_object *gem_obj)
 
 	GEM_BUG_ON(i915_gem_object_is_framebuffer(obj));
 
+	i915_drm_client_remove_object(obj);
+
 	/*
 	 * Before we free the object, make sure any pure RCU-only
 	 * read-side critical sections are complete, e.g.
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
index e72c57716bee..8de2b91b3edf 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -300,6 +300,18 @@ struct drm_i915_gem_object {
 	 */
 	struct i915_address_space *shares_resv_from;
 
+#ifdef CONFIG_PROC_FS
+	/**
+	 * @client: @i915_drm_client which created the object
+	 */
+	struct i915_drm_client *client;
+
+	/**
+	 * @client_link: Link into @i915_drm_client.objects_list
+	 */
+	struct list_head client_link;
+#endif
+
 	union {
 		struct rcu_head rcu;
 		struct llist_node freed;
diff --git a/drivers/gpu/drm/i915/i915_drm_client.c b/drivers/gpu/drm/i915/i915_drm_client.c
index 2a44b3876cb5..2e5e69edc0f9 100644
--- a/drivers/gpu/drm/i915/i915_drm_client.c
+++ b/drivers/gpu/drm/i915/i915_drm_client.c
@@ -28,6 +28,10 @@ struct i915_drm_client *i915_drm_client_alloc(void)
 	kref_init(&client->kref);
 	spin_lock_init(&client->ctx_lock);
 	INIT_LIST_HEAD(&client->ctx_list);
+#ifdef CONFIG_PROC_FS
+	spin_lock_init(&client->objects_lock);
+	INIT_LIST_HEAD(&client->objects_list);
+#endif
 
 	return client;
 }
@@ -108,4 +112,36 @@ void i915_drm_client_fdinfo(struct drm_printer *p, struct drm_file *file)
 	for (i = 0; i < ARRAY_SIZE(uabi_class_names); i++)
 		show_client_class(p, i915, file_priv->client, i);
 }
+
+void i915_drm_client_add_object(struct i915_drm_client *client,
+				struct drm_i915_gem_object *obj)
+{
+	unsigned long flags;
+
+	GEM_WARN_ON(obj->client);
+	GEM_WARN_ON(!list_empty(&obj->client_link));
+
+	spin_lock_irqsave(&client->objects_lock, flags);
+	obj->client = i915_drm_client_get(client);
+	list_add_tail_rcu(&obj->client_link, &client->objects_list);
+	spin_unlock_irqrestore(&client->objects_lock, flags);
+}
+
+bool i915_drm_client_remove_object(struct drm_i915_gem_object *obj)
+{
+	struct i915_drm_client *client = fetch_and_zero(&obj->client);
+	unsigned long flags;
+
+	/* Object may not be associated with a client. */
+	if (!client)
+		return false;
+
+	spin_lock_irqsave(&client->objects_lock, flags);
+	list_del_rcu(&obj->client_link);
+	spin_unlock_irqrestore(&client->objects_lock, flags);
+
+	i915_drm_client_put(client);
+
+	return true;
+}
 #endif
diff --git a/drivers/gpu/drm/i915/i915_drm_client.h b/drivers/gpu/drm/i915/i915_drm_client.h
index 67816c912bca..5f58fdf7dcb8 100644
--- a/drivers/gpu/drm/i915/i915_drm_client.h
+++ b/drivers/gpu/drm/i915/i915_drm_client.h
@@ -12,6 +12,9 @@
 
 #include <uapi/drm/i915_drm.h>
 
+#include "i915_file_private.h"
+#include "gem/i915_gem_object_types.h"
+
 #define I915_LAST_UABI_ENGINE_CLASS I915_ENGINE_CLASS_COMPUTE
 
 struct drm_file;
@@ -25,6 +28,20 @@ struct i915_drm_client {
 	spinlock_t ctx_lock; /* For add/remove from ctx_list. */
 	struct list_head ctx_list; /* List of contexts belonging to client. */
 
+#ifdef CONFIG_PROC_FS
+	/**
+	 * @objects_lock: lock protecting @objects_list
+	 */
+	spinlock_t objects_lock;
+
+	/**
+	 * @objects_list: list of objects created by this client
+	 *
+	 * Protected by @objects_lock.
+	 */
+	struct list_head objects_list;
+#endif
+
 	/**
 	 * @past_runtime: Accumulation of pphwsp runtimes from closed contexts.
 	 */
@@ -49,4 +66,19 @@ struct i915_drm_client *i915_drm_client_alloc(void);
 
 void i915_drm_client_fdinfo(struct drm_printer *p, struct drm_file *file);
 
+#ifdef CONFIG_PROC_FS
+void i915_drm_client_add_object(struct i915_drm_client *client,
+				struct drm_i915_gem_object *obj);
+bool i915_drm_client_remove_object(struct drm_i915_gem_object *obj);
+#else
+static inline void i915_drm_client_add_object(struct i915_drm_client *client,
+					      struct drm_i915_gem_object *obj)
+{
+}
+
+static inline bool i915_drm_client_remove_object(struct drm_i915_gem_object *obj)
+{
+}
+#endif
+
 #endif /* !__I915_DRM_CLIENT_H__ */
-- 
2.39.2

