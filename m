From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 06/19] kernel: convert perf_event_context.refcount from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:18:55 +0200
Message-ID: <1487585948-6401-7-git-send-email-elena.reshetova@intel.com>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, paul@paul-moore.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 include/linux/perf_event.h |  3 ++-
 kernel/events/core.c       | 12 ++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 000fdb2..7b130fc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -54,6 +54,7 @@ struct perf_guest_info_callbacks {
 #include <linux/perf_regs.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/refcount.h>
 #include <asm/local.h>
 
 struct perf_callchain_entry {
@@ -743,7 +744,7 @@ struct perf_event_context {
 	int				nr_stat;
 	int				nr_freq;
 	int				rotate_disable;
-	atomic_t			refcount;
+	refcount_t			refcount;
 	struct task_struct		*task;
 
 	/*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4669f2c..07a778b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1108,7 +1108,7 @@ static void perf_event_ctx_deactivate(struct perf_event_context *ctx)
 
 static void get_ctx(struct perf_event_context *ctx)
 {
-	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
+	WARN_ON(!refcount_inc_not_zero(&ctx->refcount));
 }
 
 static void free_ctx(struct rcu_head *head)
@@ -1122,7 +1122,7 @@ static void free_ctx(struct rcu_head *head)
 
 static void put_ctx(struct perf_event_context *ctx)
 {
-	if (atomic_dec_and_test(&ctx->refcount)) {
+	if (refcount_dec_and_test(&ctx->refcount)) {
 		if (ctx->parent_ctx)
 			put_ctx(ctx->parent_ctx);
 		if (ctx->task && ctx->task != TASK_TOMBSTONE)
@@ -1200,7 +1200,7 @@ perf_event_ctx_lock_nested(struct perf_event *event, int nesting)
 again:
 	rcu_read_lock();
 	ctx = ACCESS_ONCE(event->ctx);
-	if (!atomic_inc_not_zero(&ctx->refcount)) {
+	if (!refcount_inc_not_zero(&ctx->refcount)) {
 		rcu_read_unlock();
 		goto again;
 	}
@@ -1328,7 +1328,7 @@ perf_lock_task_context(struct task_struct *task, int ctxn, unsigned long *flags)
 		}
 
 		if (ctx->task == TASK_TOMBSTONE ||
-		    !atomic_inc_not_zero(&ctx->refcount)) {
+		    !refcount_inc_not_zero(&ctx->refcount)) {
 			raw_spin_unlock(&ctx->lock);
 			ctx = NULL;
 		} else {
@@ -3744,7 +3744,7 @@ static void __perf_event_init_context(struct perf_event_context *ctx)
 	INIT_LIST_HEAD(&ctx->pinned_groups);
 	INIT_LIST_HEAD(&ctx->flexible_groups);
 	INIT_LIST_HEAD(&ctx->event_list);
-	atomic_set(&ctx->refcount, 1);
+	refcount_set(&ctx->refcount, 1);
 }
 
 static struct perf_event_context *
@@ -9630,7 +9630,7 @@ __perf_event_ctx_lock_double(struct perf_event *group_leader,
 again:
 	rcu_read_lock();
 	gctx = READ_ONCE(group_leader->ctx);
-	if (!atomic_inc_not_zero(&gctx->refcount)) {
+	if (!refcount_inc_not_zero(&gctx->refcount)) {
 		rcu_read_unlock();
 		goto again;
 	}
-- 
2.7.4

