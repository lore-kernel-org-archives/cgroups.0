From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 08/19] kernel: convert ring_buffer.aux_refcount from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:18:57 +0200
Message-ID: <1487585948-6401-9-git-send-email-elena.reshetova@intel.com>
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
 kernel/events/core.c        | 2 +-
 kernel/events/internal.h    | 2 +-
 kernel/events/ring_buffer.c | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e1c337d..32add6c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5114,7 +5114,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 
 		/* this has to be the last one */
 		rb_free_aux(rb);
-		WARN_ON_ONCE(atomic_read(&rb->aux_refcount));
+		WARN_ON_ONCE(refcount_read(&rb->aux_refcount));
 
 		mutex_unlock(&event->mmap_mutex);
 	}
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index b8e6fdf..fb55716 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -48,7 +48,7 @@ struct ring_buffer {
 	atomic_t			aux_mmap_count;
 	unsigned long			aux_mmap_locked;
 	void				(*free_aux)(void *);
-	atomic_t			aux_refcount;
+	refcount_t			aux_refcount;
 	void				**aux_pages;
 	void				*aux_priv;
 
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 8de1664..c501d4e 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -344,7 +344,7 @@ void *perf_aux_output_begin(struct perf_output_handle *handle,
 	if (!atomic_read(&rb->aux_mmap_count))
 		goto err;
 
-	if (!atomic_inc_not_zero(&rb->aux_refcount))
+	if (!refcount_inc_not_zero(&rb->aux_refcount))
 		goto err;
 
 	/*
@@ -636,7 +636,7 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 	 * we keep a refcount here to make sure either of the two can
 	 * reference them safely.
 	 */
-	atomic_set(&rb->aux_refcount, 1);
+	refcount_set(&rb->aux_refcount, 1);
 
 	rb->aux_overwrite = overwrite;
 	rb->aux_watermark = watermark;
@@ -655,7 +655,7 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 
 void rb_free_aux(struct ring_buffer *rb)
 {
-	if (atomic_dec_and_test(&rb->aux_refcount))
+	if (refcount_dec_and_test(&rb->aux_refcount))
 		__rb_free_aux(rb);
 }
 
-- 
2.7.4

