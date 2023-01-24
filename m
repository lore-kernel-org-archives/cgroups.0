From: Alistair Popple <apopple@nvidia.com>
Subject: [RFC PATCH 09/19] io_uring: convert to use vm_account
Date: Tue, 24 Jan 2023 16:42:38 +1100
Message-ID: <9f63cf4ab74d6e56e434c1c3d7c98352bb282895.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lky1pwA9ndycQb0tInBuvcdP9GKU+97WFqRHP3U1Daw=;
 b=YNhotQ56/PX/D+NqqAgqfCt2w5ovQb1AwXS86LtQCWt9SQ9hJjxOgH5XWHEUcbH7/dPgcUnBeVIbLEF9YEoXvGDpSuu1PCk/CiYR8ecIfAlhoHH8cRyFiIUQm1Lv+VSsoyA2KAcXgtj13O/2M1hpmFroDu4LJF/CKrJLWsmK2c6BRmZ6tyZOCziW6gfXlVX4M/AAXra2IW9Hsi2tqUlp2wTJo7txDnRWAuHpj/G5txbgXSSrFoxaa2TCUmjKHln2HqgabfcxQ6Ef+11/RE0Nzyv3HX4cTCRJVroIYua/xh4z3xLbW05AWEyCshNINEAOqx8Jb/LhO+4TF64JnIKnzA==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, Alistair Popple <apopple@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org

Convert io_uring to use vm_account instead of directly charging pages
against the user/mm. Rather than charge pages to both user->locked_vm
and mm->pinned_vm this will only charge pages to user->locked_vm.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/io_uring_types.h |  3 +--
 io_uring/io_uring.c            | 20 +++---------------
 io_uring/notif.c               |  4 ++--
 io_uring/notif.h               | 10 +++------
 io_uring/rsrc.c                | 38 +++--------------------------------
 io_uring/rsrc.h                |  9 +--------
 6 files changed, 16 insertions(+), 68 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 128a67a..d81aceb 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -343,8 +343,7 @@ struct io_ring_ctx {
 	struct io_wq_hash		*hash_map;
 
 	/* Only used for accounting purposes */
-	struct user_struct		*user;
-	struct mm_struct		*mm_account;
+	struct vm_account               vm_account;
 
 	/* ctx exit and cancelation */
 	struct llist_head		fallback_llist;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0a4efad..912da4f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2744,15 +2744,11 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
-	if (ctx->mm_account) {
-		mmdrop(ctx->mm_account);
-		ctx->mm_account = NULL;
-	}
+	vm_account_release(&ctx->vm_account);
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 
 	percpu_ref_exit(&ctx->refs);
-	free_uid(ctx->user);
 	io_req_caches_free(ctx);
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
@@ -3585,8 +3581,9 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		ctx->syscall_iopoll = 1;
 
 	ctx->compat = in_compat_syscall();
-	if (!capable(CAP_IPC_LOCK))
-		ctx->user = get_uid(current_user());
+	vm_account_init(&ctx->vm_account, current, current_user(),
+			VM_ACCOUNT_USER |
+			(capable(CAP_IPC_LOCK) ? VM_ACCOUNT_BYPASS : 0));
 
 	/*
 	 * For SQPOLL, we just need a wakeup, always. For !SQPOLL, if
@@ -3619,15 +3616,6 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 	}
 
-	/*
-	 * This is just grabbed for accounting purposes. When a process exits,
-	 * the mm is exited and dropped before the files, hence we need to hang
-	 * on to this mm purely for the purposes of being able to unaccount
-	 * memory (locked/pinned vm). It's not used for anything else.
-	 */
-	mmgrab(current->mm);
-	ctx->mm_account = current->mm;
-
 	ret = io_allocate_scq_urings(ctx, p);
 	if (ret)
 		goto err;
diff --git a/io_uring/notif.c b/io_uring/notif.c
index c4bb793..0f589fa 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -17,8 +17,8 @@ static void io_notif_complete_tw_ext(struct io_kiocb *notif, bool *locked)
 	if (nd->zc_report && (nd->zc_copied || !nd->zc_used))
 		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
 
-	if (nd->account_pages && ctx->user) {
-		__io_unaccount_mem(ctx->user, nd->account_pages);
+	if (nd->account_pages) {
+		vm_unaccount_pinned(&ctx->vm_account, nd->account_pages);
 		nd->account_pages = 0;
 	}
 	io_req_task_complete(notif, locked);
diff --git a/io_uring/notif.h b/io_uring/notif.h
index c88c800..e2cb44a 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -43,11 +43,9 @@ static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
 	unsigned nr_pages = (len >> PAGE_SHIFT) + 2;
 	int ret;
 
-	if (ctx->user) {
-		ret = __io_account_mem(ctx->user, nr_pages);
-		if (ret)
-			return ret;
-		nd->account_pages += nr_pages;
-	}
+	ret = __io_account_mem(&ctx->vm_account, nr_pages);
+	if (ret)
+		return ret;
+	nd->account_pages += nr_pages;
 	return 0;
 }
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 18de10c..aa44528 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -42,49 +42,19 @@ void io_rsrc_refs_drop(struct io_ring_ctx *ctx)
 	}
 }
 
-int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
+int __io_account_mem(struct vm_account *vm_account, unsigned long nr_pages)
 {
-	unsigned long page_limit, cur_pages, new_pages;
-
-	if (!nr_pages)
-		return 0;
-
-	/* Don't allow more pages than we can safely lock */
-	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	cur_pages = atomic_long_read(&user->locked_vm);
-	do {
-		new_pages = cur_pages + nr_pages;
-		if (new_pages > page_limit)
-			return -ENOMEM;
-	} while (!atomic_long_try_cmpxchg(&user->locked_vm,
-					  &cur_pages, new_pages));
-	return 0;
+	return vm_account_pinned(vm_account, nr_pages);
 }
 
 static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
-	if (ctx->user)
-		__io_unaccount_mem(ctx->user, nr_pages);
-
-	if (ctx->mm_account)
-		atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
+	vm_unaccount_pinned(&ctx->vm_account, nr_pages);
 }
 
 static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
-	int ret;
-
-	if (ctx->user) {
-		ret = __io_account_mem(ctx->user, nr_pages);
-		if (ret)
-			return ret;
-	}
-
-	if (ctx->mm_account)
-		atomic64_add(nr_pages, &ctx->mm_account->pinned_vm);
-
-	return 0;
+	return vm_account_pinned(&ctx->vm_account, nr_pages);
 }
 
 static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 2b87436..d8833d0 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -167,12 +167,5 @@ static inline u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
 int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
-int __io_account_mem(struct user_struct *user, unsigned long nr_pages);
-
-static inline void __io_unaccount_mem(struct user_struct *user,
-				      unsigned long nr_pages)
-{
-	atomic_long_sub(nr_pages, &user->locked_vm);
-}
-
+int __io_account_mem(struct vm_account *vm_account, unsigned long nr_pages);
 #endif
-- 
git-series 0.9.1
