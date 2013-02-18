From: Li Zefan <lizefan@huawei.com>
Subject: [RFC][PATCH] kvm: fix a race when closing irq eventfd
Date: Mon, 18 Feb 2013 11:13:27 +0800
Message-ID: <51219C57.7080809@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Gregory Haskins <ghaskins@novell.com>, "Kirill A. Shutemov" <kirill@shutemov.name>

While trying to fix a race when closing cgroup eventfd, I took a look
at how kvm deals with this problem, and I found it doesn't.

I may be wrong, as I don't know kvm code, so correct me if I'm.

	/*
	 * Race-free decouple logic (ordering is critical)
	 */
	static void
	irqfd_shutdown(struct work_struct *work)

I don't think it's race-free!

	static int
	irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
	{
	...
			 * We cannot race against the irqfd going away since the
			 * other side is required to acquire wqh->lock, which we hold
			 */
			if (irqfd_is_active(irqfd))
				irqfd_deactivate(irqfd);
	}

In kvm_irqfd_deassign() and kvm_irqfd_release() where irqfds are freed,
wqh->lock is not acquired!

So here is the race:

CPU0                                    CPU1
-----------------------------------     ---------------------------------
kvm_irqfd_release()
  spin_lock(kvm->irqfds.lock);
  ...
  irqfd_deactivate(irqfd);
    list_del_init(&irqfd->list);
  spin_unlock(kvm->irqfd.lock);
  ...
					close(eventfd)
					  irqfd_wakeup();
    irqfd_shutdown();
      remove_waitqueue(irqfd->wait);
      kfree(irqfd);
					    spin_lock(kvm->irqfd.lock);
					      if (!list_empty(&irqfd->list))
						irqfd_deactivate(irqfd);
						  list_del_init(&irqfd->list);
					    spin_unlock(kvm->irqfd.lock);

Look, we're accessing irqfd though it has already been freed!

Here's a fix I have. Please enlighten me with a better fix.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/eventfd.c            | 34 ++++++++++++++--------------------
 include/linux/eventfd.h | 17 +++++++++++++++++
 virt/kvm/eventfd.c      | 45 +++++++++++++++++++++++++++++++++++----------
 3 files changed, 66 insertions(+), 30 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 35470d9..cda8a4c 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -22,21 +22,6 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
-struct eventfd_ctx {
-	struct kref kref;
-	wait_queue_head_t wqh;
-	/*
-	 * Every time that a write(2) is performed on an eventfd, the
-	 * value of the __u64 being written is added to "count" and a
-	 * wakeup is performed on "wqh". A read(2) will return the "count"
-	 * value to userspace, and will reset "count" to zero. The kernel
-	 * side eventfd_signal() also, adds to the "count" counter and
-	 * issue a wakeup.
-	 */
-	__u64 count;
-	unsigned int flags;
-};
-
 /**
  * eventfd_signal - Adds @n to the eventfd counter.
  * @ctx: [in] Pointer to the eventfd context.
@@ -153,20 +138,29 @@ static void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt)
  * This is used to atomically remove a wait queue entry from the eventfd wait
  * queue head, and read/reset the counter value.
  */
-int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
+int eventfd_ctx_remove_wait_queue_locked(struct eventfd_ctx *ctx, wait_queue_t *wait,
 				  __u64 *cnt)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	eventfd_ctx_do_read(ctx, cnt);
 	__remove_wait_queue(&ctx->wqh, wait);
 	if (*cnt != 0 && waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, POLLOUT);
-	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return *cnt != 0 ? 0 : -EAGAIN;
 }
+EXPORT_SYMBOL_GPL(eventfd_ctx_remove_wait_queue_locked);
+
+int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
+				  __u64 *cnt)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	ret = eventfd_ctx_remove_wait_queue_locked(ctx, wait, cnt);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+	return ret;
+}
 EXPORT_SYMBOL_GPL(eventfd_ctx_remove_wait_queue);
 
 /**
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 3c3ef19..61085ac 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -26,6 +26,21 @@
 #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
 #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
 
+struct eventfd_ctx {
+	struct kref kref;
+	wait_queue_head_t wqh;
+	/*
+	 * Every time that a write(2) is performed on an eventfd, the
+	 * value of the __u64 being written is added to "count" and a
+	 * wakeup is performed on "wqh". A read(2) will return the "count"
+	 * value to userspace, and will reset "count" to zero. The kernel
+	 * side eventfd_signal() also, adds to the "count" counter and
+	 * issue a wakeup.
+	 */
+	__u64 count;
+	unsigned int flags;
+};
+
 #ifdef CONFIG_EVENTFD
 
 struct file *eventfd_file_create(unsigned int count, int flags);
@@ -38,6 +53,8 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
 ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
 				  __u64 *cnt);
+int eventfd_ctx_remove_wait_queue_locked(struct eventfd_ctx *ctx, wait_queue_t *wait,
+				  __u64 *cnt);
 
 #else /* CONFIG_EVENTFD */
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index b6eea5c..ccbeb9a 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -89,6 +89,7 @@ struct _irqfd {
 	struct list_head list;
 	poll_table pt;
 	struct work_struct shutdown;
+	wait_queue_head_t *wqh;
 };
 
 static struct workqueue_struct *irqfd_cleanup_wq;
@@ -160,13 +161,6 @@ static void
 irqfd_shutdown(struct work_struct *work)
 {
 	struct _irqfd *irqfd = container_of(work, struct _irqfd, shutdown);
-	u64 cnt;
-
-	/*
-	 * Synchronize with the wait-queue and unhook ourselves to prevent
-	 * further events.
-	 */
-	eventfd_ctx_remove_wait_queue(irqfd->eventfd, &irqfd->wait, &cnt);
 
 	/*
 	 * We know no new events will be scheduled at this point, so block
@@ -197,15 +191,23 @@ irqfd_is_active(struct _irqfd *irqfd)
 /*
  * Mark the irqfd as inactive and schedule it for removal
  *
- * assumes kvm->irqfds.lock is held
+ * assumes kvm->irqfds.lock and irqfd->wqh.lock are held
  */
 static void
 irqfd_deactivate(struct _irqfd *irqfd)
 {
+	u64 cnt;
+
 	BUG_ON(!irqfd_is_active(irqfd));
 
 	list_del_init(&irqfd->list);
 
+	/*
+	 * Synchronize with the wait-queue and unhook ourselves to prevent
+	 * further events.
+	 */
+	eventfd_ctx_remove_wait_queue_locked(irqfd->eventfd, &irqfd->wait, &cnt);
+
 	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
 }
 
@@ -260,6 +262,7 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
 			poll_table *pt)
 {
 	struct _irqfd *irqfd = container_of(pt, struct _irqfd, pt);
+	irqfd->wqh = wqh;
 	add_wait_queue(wqh, &irqfd->wait);
 }
 
@@ -454,6 +457,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 	if (IS_ERR(eventfd))
 		return PTR_ERR(eventfd);
 
+	spin_lock_irq(&eventfd->wqh.lock);
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
@@ -472,6 +476,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 	}
 
 	spin_unlock_irq(&kvm->irqfds.lock);
+	spin_unlock_irq(&eventfd->wqh.lock);
 	eventfd_ctx_put(eventfd);
 
 	/*
@@ -504,14 +509,34 @@ void
 kvm_irqfd_release(struct kvm *kvm)
 {
 	struct _irqfd *irqfd, *tmp;
+	struct eventfd_ctx *ctx;
 
 	spin_lock_irq(&kvm->irqfds.lock);
+again:
+	if (list_empty(&kvm->irqfds.items)) {
+		spin_unlock_irq(&kvm->irqfds.lock);
+		goto out;
+	}
+
+	irqfd = list_first_entry(&kvm->irqfds.items, struct _irqfd, list);
+	ctx = eventfd_ctx_get(irqfd->eventfd);
+
+	spin_unlock_irq(&kvm->irqfds.lock);
 
-	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list)
-		irqfd_deactivate(irqfd);
+	spin_lock_irq(&ctx->wqh.lock);
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
+		if (irqfd->eventfd == ctx)
+			irqfd_deactivate(irqfd);
+	}
 
 	spin_unlock_irq(&kvm->irqfds.lock);
+	spin_unlock_irq(&ctx->wqh.lock);
 
+	eventfd_ctx_put(ctx);
+	goto again;
+out:
 	/*
 	 * Block until we know all outstanding shutdown jobs have completed
 	 * since we do not take a kvm* reference.
-- 
1.8.0.2
