From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] eventfd: introduce eventfd_signal_hangup()
Date: Sat, 2 Feb 2013 14:50:44 +0800
Message-ID: <510CB744.7000300@huawei.com>
References: <510CB733.2080904@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510CB733.2080904-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

When an eventfd is closed, a wakeup with POLLHUP will be issued,
but cgroup wants to issue wakeup explicitly, so when a cgroup is
removed userspace can be notified.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 fs/eventfd.c            | 11 +++++++++++
 include/linux/eventfd.h |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 35470d9..acf15e3 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -67,6 +67,17 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
+/**
+ * eventfd_signal_hangup - Notify that this eventfd is hung up.
+ * @ctx: [in] Pointer to the eventfd context.
+ *
+ * Issue a POLLHUP wakeup.
+ */
+void eventfd_signal_hangup(struct eventfd_ctx *ctx)
+{
+	wake_up_poll(&ctx->wqh, POLLHUP);
+}
+
 static void eventfd_free_ctx(struct eventfd_ctx *ctx)
 {
 	kfree(ctx);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 3c3ef19..68af706 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -35,6 +35,7 @@ struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
+void eventfd_signal_hangup(struct eventfd_ctx *ctx);
 ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
 				  __u64 *cnt);
@@ -60,6 +61,10 @@ static inline int eventfd_signal(struct eventfd_ctx *ctx, int n)
 	return -ENOSYS;
 }
 
+static inline void eventfd_signal_hangup(struct eventfd_ctx *ctx)
+{
+}
+
 static inline void eventfd_ctx_put(struct eventfd_ctx *ctx)
 {
 
-- 
1.8.0.2
