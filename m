From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 10/19] net: skb: Switch to using vm_account
Date: Tue, 24 Jan 2023 16:42:39 +1100
Message-ID: <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXKmUiAwwip0H/gynwy5RsgsJUC5caFZfjG6m6383VY=;
 b=EyOJEsMdC9Pm2dVyZu8t7V04q7ar/Fng5FR0rXTfQdglnp59DaTP9cs40qJld9Gm1OjXSNecHDL3L2mWGVnKtEz0Y6zx+nMEhgvJFDI5j2J0R5piA2LNtMyLmR7dMAE6/qFxCq1JPagJCvMLOtc+t3iBnnJmKH3jZXZ/Sr5YQ8vuY28QyoHFsJK8y6xxzrl49r1MQMX2wPjeqpbKp7Y2rwX4lCd2/mi2e9KlnlUgvhErN8QPJEaPo2En3y9Hj/vTHUmH1bYEeCKOOZ5lovaVKTB4uHvGrwdKvA96iqPfaJHPSs1KhCRM9T55ZTIpA4k2u26EOn0aM2FRVcR0rUq73g==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org

Switch to using vm_account to charge pinned pages. This will allow a
future change to charge the pinned pages to a cgroup to limit the
overall number of pinned pages in the system.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
---
 include/linux/skbuff.h |  6 ++---
 include/net/sock.h     |  2 ++-
 net/core/skbuff.c      | 47 +++++++++++++++----------------------------
 net/rds/message.c      |  9 +++++---
 4 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c84924..c956405 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -554,7 +554,6 @@ struct ubuf_info_msgzc {
 	};
 
 	struct mmpin {
-		struct user_struct *user;
 		unsigned int num_pg;
 	} mmp;
 };
@@ -563,8 +562,9 @@ struct ubuf_info_msgzc {
 #define uarg_to_msgzc(ubuf_ptr)	container_of((ubuf_ptr), struct ubuf_info_msgzc, \
 					     ubuf)
 
-int mm_account_pinned_pages(struct mmpin *mmp, size_t size);
-void mm_unaccount_pinned_pages(struct mmpin *mmp);
+int mm_account_pinned_pages(struct vm_account *vm_account, struct mmpin *mmp,
+			size_t size);
+void mm_unaccount_pinned_pages(struct vm_account *vm_account, struct mmpin *mmp);
 
 /* This data is invariant across clones and lives at
  * the end of the header data, ie. at skb->end.
diff --git a/include/net/sock.h b/include/net/sock.h
index dcd72e6..bc3a868 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -334,6 +334,7 @@ struct sk_filter;
   *	@sk_security: used by security modules
   *	@sk_mark: generic packet mark
   *	@sk_cgrp_data: cgroup data for this cgroup
+  *	@sk_vm_account: data for pinned memory accounting
   *	@sk_memcg: this socket's memory cgroup association
   *	@sk_write_pending: a write to stream socket waits to start
   *	@sk_state_change: callback to indicate change in the state of the sock
@@ -523,6 +524,7 @@ struct sock {
 	void			*sk_security;
 #endif
 	struct sock_cgroup_data	sk_cgrp_data;
+	struct vm_account       sk_vm_account;
 	struct mem_cgroup	*sk_memcg;
 	void			(*sk_state_change)(struct sock *sk);
 	void			(*sk_data_ready)(struct sock *sk);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4a0eb55..bed3fc9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1309,42 +1309,25 @@ struct sk_buff *skb_morph(struct sk_buff *dst, struct sk_buff *src)
 }
 EXPORT_SYMBOL_GPL(skb_morph);
 
-int mm_account_pinned_pages(struct mmpin *mmp, size_t size)
+int mm_account_pinned_pages(struct vm_account *vm_account, struct mmpin *mmp,
+			    size_t size)
 {
-	unsigned long max_pg, num_pg, new_pg, old_pg;
-	struct user_struct *user;
-
-	if (capable(CAP_IPC_LOCK) || !size)
-		return 0;
+	unsigned int num_pg;
 
 	num_pg = (size >> PAGE_SHIFT) + 2;	/* worst case */
-	max_pg = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	user = mmp->user ? : current_user();
+	if (vm_account_pinned(vm_account, num_pg))
+		return -ENOBUFS;
 
-	old_pg = atomic_long_read(&user->locked_vm);
-	do {
-		new_pg = old_pg + num_pg;
-		if (new_pg > max_pg)
-			return -ENOBUFS;
-	} while (!atomic_long_try_cmpxchg(&user->locked_vm, &old_pg, new_pg));
-
-	if (!mmp->user) {
-		mmp->user = get_uid(user);
-		mmp->num_pg = num_pg;
-	} else {
-		mmp->num_pg += num_pg;
-	}
+	mmp->num_pg += num_pg;
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mm_account_pinned_pages);
 
-void mm_unaccount_pinned_pages(struct mmpin *mmp)
+void mm_unaccount_pinned_pages(struct vm_account *vm_account, struct mmpin *mmp)
 {
-	if (mmp->user) {
-		atomic_long_sub(mmp->num_pg, &mmp->user->locked_vm);
-		free_uid(mmp->user);
-	}
+	vm_unaccount_pinned(vm_account, mmp->num_pg);
+	vm_account_release(vm_account);
 }
 EXPORT_SYMBOL_GPL(mm_unaccount_pinned_pages);
 
@@ -1361,9 +1344,12 @@ static struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 
 	BUILD_BUG_ON(sizeof(*uarg) > sizeof(skb->cb));
 	uarg = (void *)skb->cb;
-	uarg->mmp.user = NULL;
+	uarg->mmp.num_pg = 0;
+	vm_account_init(&sk->sk_vm_account, current,
+			current_user(), VM_ACCOUNT_USER);
 
-	if (mm_account_pinned_pages(&uarg->mmp, size)) {
+	if (mm_account_pinned_pages(&sk->sk_vm_account, &uarg->mmp, size)) {
+		vm_account_release(&sk->sk_vm_account);
 		kfree_skb(skb);
 		return NULL;
 	}
@@ -1416,7 +1402,8 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 
 		next = (u32)atomic_read(&sk->sk_zckey);
 		if ((u32)(uarg_zc->id + uarg_zc->len) == next) {
-			if (mm_account_pinned_pages(&uarg_zc->mmp, size))
+			if (mm_account_pinned_pages(&sk->sk_vm_account,
+						    &uarg_zc->mmp, size))
 				return NULL;
 			uarg_zc->len++;
 			uarg_zc->bytelen = bytelen;
@@ -1466,7 +1453,7 @@ static void __msg_zerocopy_callback(struct ubuf_info_msgzc *uarg)
 	u32 lo, hi;
 	u16 len;
 
-	mm_unaccount_pinned_pages(&uarg->mmp);
+	mm_unaccount_pinned_pages(&sk->sk_vm_account, &uarg->mmp);
 
 	/* if !len, there was only 1 call, and it was aborted
 	 * so do not queue a completion notification
diff --git a/net/rds/message.c b/net/rds/message.c
index b47e4f0..2138a70 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -99,7 +99,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
 	struct list_head *head;
 	unsigned long flags;
 
-	mm_unaccount_pinned_pages(&znotif->z_mmp);
+	mm_unaccount_pinned_pages(&rs->rs_sk.sk_vm_account, &znotif->z_mmp);
 	q = &rs->rs_zcookie_queue;
 	spin_lock_irqsave(&q->lock, flags);
 	head = &q->zcookie_head;
@@ -367,6 +367,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 	int ret = 0;
 	int length = iov_iter_count(from);
 	struct rds_msg_zcopy_info *info;
+	struct vm_account *vm_account = &rm->m_rs->rs_sk.sk_vm_account;
 
 	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
 
@@ -380,7 +381,9 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 		return -ENOMEM;
 	INIT_LIST_HEAD(&info->rs_zcookie_next);
 	rm->data.op_mmp_znotifier = &info->znotif;
-	if (mm_account_pinned_pages(&rm->data.op_mmp_znotifier->z_mmp,
+	vm_account_init(vm_account, current, current_user(), VM_ACCOUNT_USER);
+	if (mm_account_pinned_pages(vm_account,
+				    &rm->data.op_mmp_znotifier->z_mmp,
 				    length)) {
 		ret = -ENOMEM;
 		goto err;
@@ -399,7 +402,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 			for (i = 0; i < rm->data.op_nents; i++)
 				put_page(sg_page(&rm->data.op_sg[i]));
 			mmp = &rm->data.op_mmp_znotifier->z_mmp;
-			mm_unaccount_pinned_pages(mmp);
+			mm_unaccount_pinned_pages(vm_account, mmp);
 			ret = -EFAULT;
 			goto err;
 		}
-- 
git-series 0.9.1
