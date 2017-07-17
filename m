From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 07/15] kernel: convert ring_buffer.refcount from atomic_t to refcount_t
Date: Mon, 17 Jul 2017 13:43:18 +0300
Message-ID: <1500288206-12074-8-git-send-email-elena.reshetova@intel.com>
References: <1500288206-12074-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500288206-12074-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, keescook@chromium.org, tglx@linutronix.de, Elena Reshetova <elena.reshetova@intel.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 kernel/events/core.c        | 4 ++--
 kernel/events/internal.h    | 3 ++-
 kernel/events/ring_buffer.c | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index faf9925..9147397 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5049,7 +5049,7 @@ struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
 	if (rb) {
-		if (!atomic_inc_not_zero(&rb->refcount))
+		if (!refcount_inc_not_zero(&rb->refcount))
 			rb = NULL;
 	}
 	rcu_read_unlock();
@@ -5059,7 +5059,7 @@ struct ring_buffer *ring_buffer_get(struct perf_event *event)
 
 void ring_buffer_put(struct ring_buffer *rb)
 {
-	if (!atomic_dec_and_test(&rb->refcount))
+	if (!refcount_dec_and_test(&rb->refcount))
 		return;
 
 	WARN_ON_ONCE(!list_empty(&rb->event_list));
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 486fd78..b8e6fdf 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -3,13 +3,14 @@
 
 #include <linux/hardirq.h>
 #include <linux/uaccess.h>
+#include <linux/refcount.h>
 
 /* Buffer handling */
 
 #define RING_BUFFER_WRITABLE		0x01
 
 struct ring_buffer {
-	atomic_t			refcount;
+	refcount_t			refcount;
 	struct rcu_head			rcu_head;
 #ifdef CONFIG_PERF_USE_VMALLOC
 	struct work_struct		work;
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index ee97196..3353572 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -284,7 +284,7 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
 	else
 		rb->overwrite = 1;
 
-	atomic_set(&rb->refcount, 1);
+	refcount_set(&rb->refcount, 1);
 
 	INIT_LIST_HEAD(&rb->event_list);
 	spin_lock_init(&rb->event_lock);
-- 
2.7.4

