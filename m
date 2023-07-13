From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 2/2] eventfd: simplify eventfd_signal_mask()
Date: Thu, 13 Jul 2023 12:05:38 +0200
Message-ID: <20230713-vfs-eventfd-signal-v1-2-7fda6c5d212b@kernel.org>
References: <20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689242793;
	bh=+Df4cQ3XZPwLfFxJgIqPrDY4l9UAdwCjr9DGoW3/ojk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=j+ukf52dvZ+nUEPwpL9/EYruyhEbJbg7d1yjKDMcd3GOYxX7RclutpFcH5UUHlkpI
	 fnIEho3ycJz28JfRAPfizI9cf3F0lqh4jC9ZF+UZUl5JTb6HfdwpWlIJ9bsmZ0DsOQ
	 PAjBHJokUk/yF6GqX5PHCHsaDKT13j+MVST75N+zeiC2em3PJTUKrCtRR1KKmsmMCX
	 MYnQq0YQbswQU++9LLW3pgHXNsdqcZtbb04btB9J/lGIIF9SRPTFcmVmql2ih2n6bH
	 BAMadKjZaQhxN2qUstf+rs137LSKZ/kMx1juo/8V60a80JJWvq1eqYcfgXe/BuR2sH
	 +vKmJxA1p+x+A==
In-Reply-To: <20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=4338; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+Df4cQ3XZPwLfFxJgIqPrDY4l9UAdwCjr9DGoW3/ojk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaSsP1NbdfmkaWaxQvZah7/MWs/ufCrO2q82U2T1DIWDSy0u
 LwzX6ChhYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIshkjww4t2ytlzT8ElQsqm7Su/N
 b3T10XyfCvYZ2XvvOJclnpCIbvvh+/WjLaTozOzj3stenvds+qri//VkTNPGGwWHTi+Uc8AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Sender: owner-linux-aio@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, Oded Gabbay <ogabbay@kernel.org>, Wu Hao <hao.wu@intel.com>, Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>, Xu Yilun <yilun.xu@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang <zhi.a.wang@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Jason

The eventfd_signal_mask() helper was introduced for io_uring and similar
to eventfd_signal() it always passed 1 for @n. So don't bother with that
argument at all.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 drivers/gpu/drm/i915/gvt/interrupt.c | 2 +-
 fs/eventfd.c                         | 9 +++++----
 include/linux/eventfd.h              | 9 ++++-----
 io_uring/io_uring.c                  | 4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/interrupt.c b/drivers/gpu/drm/i915/gvt/interrupt.c
index 3d9e09c2add4..31aff6f733d4 100644
--- a/drivers/gpu/drm/i915/gvt/interrupt.c
+++ b/drivers/gpu/drm/i915/gvt/interrupt.c
@@ -435,7 +435,7 @@ static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
 	 */
 	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
 		return -ESRCH;
-	if (vgpu->msi_trigger && eventfd_signal(vgpu->msi_trigger) != 1)
+	if (vgpu->msi_trigger && !eventfd_signal(vgpu->msi_trigger))
 		return -EFAULT;
 	return 0;
 }
diff --git a/fs/eventfd.c b/fs/eventfd.c
index dc9e01053235..077be5da72bd 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -43,9 +43,10 @@ struct eventfd_ctx {
 	int id;
 };
 
-__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
+bool eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask)
 {
 	unsigned long flags;
+	__u64 n = 1;
 
 	/*
 	 * Deadlock or stack overflow issues can happen if we recurse here
@@ -68,7 +69,7 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
 	current->in_eventfd = 0;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
-	return n;
+	return n == 1;
 }
 
 /**
@@ -82,9 +83,9 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
  *
  * Returns the amount by which the counter was incremented.
  */
-__u64 eventfd_signal(struct eventfd_ctx *ctx)
+bool eventfd_signal(struct eventfd_ctx *ctx)
 {
-	return eventfd_signal_mask(ctx, 1, 0);
+	return eventfd_signal_mask(ctx, 0);
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 562089431551..0155ee25f7c8 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -35,8 +35,8 @@ void eventfd_ctx_put(struct eventfd_ctx *ctx);
 struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
-__u64 eventfd_signal(struct eventfd_ctx *ctx);
-__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask);
+bool eventfd_signal(struct eventfd_ctx *ctx);
+bool eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
 void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
@@ -58,13 +58,12 @@ static inline struct eventfd_ctx *eventfd_ctx_fdget(int fd)
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline int eventfd_signal(struct eventfd_ctx *ctx)
+static inline bool eventfd_signal(struct eventfd_ctx *ctx)
 {
 	return -ENOSYS;
 }
 
-static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n,
-				      unsigned mask)
+static inline bool eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
 {
 	return -ENOSYS;
 }
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e8096d502a7c..a9359ef73935 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -537,7 +537,7 @@ static void io_eventfd_ops(struct rcu_head *rcu)
 	int ops = atomic_xchg(&ev_fd->ops, 0);
 
 	if (ops & BIT(IO_EVENTFD_OP_SIGNAL_BIT))
-		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 
 	/* IO_EVENTFD_OP_FREE_BIT may not be set here depending on callback
 	 * ordering in a race but if references are 0 we know we have to free
@@ -573,7 +573,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 		goto out;
 
 	if (likely(eventfd_signal_allowed())) {
-		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 	} else {
 		atomic_inc(&ev_fd->refs);
 		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops))

-- 
2.34.1


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
