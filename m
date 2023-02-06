From: Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 10/19] net: skb: Switch to using vm_account
Date: Mon,  6 Feb 2023 18:47:47 +1100
Message-ID: <60a51160809d14e3e4a1c681cd71e37ab303adb8.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYW4u4ayE2LZHX01iQfnpEcejDU0yOEhVudNlOUAn3Q=;
 b=LCGOkAUcbw0vOxMEIqkDhbrUyi+Q/QrFLfm8WDWZwttEqb6SGC6ytVojDYGQ3W8mMwzlLiMgJMgSnx7+zNvr2LQEVYWRea3af/eSAGZaYBm8XzYgewKMCKiq4zxplUG3zXxw671Q60xeqaEtCiKb8tpwKOhM5UdGv6OXJ9hczT+M3xm4a21xSkGcU8nGENwG9zuRr0h/SAFp2kCyXV9veXiWao7bXHNqUZXFR9Wzh29VahK6lyIG+GmV2adHPhQQ+mei1crxC3ZXczm/kChnd/igJYJxz3yWKrpKcjzz4EPYAw9JvWxNelIov5X8e2T6DgBJVaiRUgFG7UANPuk7dw==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Daniel P . Berrange" <berrange@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Alistair Popple <apopple@nvidia.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com

Switch to using vm_account to charge pinned pages. This will allow a
future change to charge the pinned pages to a cgroup to limit the
overall number of pinned pages in the system.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com
---
 include/linux/skbuff.h |  7 +++---
 include/net/sock.h     |  3 +++-
 net/core/skbuff.c      | 47 +++++++++++++++----------------------------
 net/rds/message.c      | 10 ++++++---
 4 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c84924..14f29a0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -37,6 +37,7 @@
 #include <linux/in6.h>
 #include <linux/if_packet.h>
 #include <linux/llist.h>
+#include <linux/vm_account.h>
 #include <net/flow.h>
 #include <net/page_pool.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -554,7 +555,6 @@ struct ubuf_info_msgzc {
 	};
 
 	struct mmpin {
-		struct user_struct *user;
 		unsigned int num_pg;
 	} mmp;
 };
@@ -563,8 +563,9 @@ struct ubuf_info_msgzc {
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
index dcd72e6..0e756d3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -63,6 +63,7 @@
 #include <linux/atomic.h>
 #include <linux/refcount.h>
 #include <linux/llist.h>
+#include <linux/vm_account.h>
 #include <net/dst.h>
 #include <net/checksum.h>
 #include <net/tcp_states.h>
@@ -334,6 +335,7 @@ struct sk_filter;
   *	@sk_security: used by security modules
   *	@sk_mark: generic packet mark
   *	@sk_cgrp_data: cgroup data for this cgroup
+  *	@sk_vm_account: data for pinned memory accounting
   *	@sk_memcg: this socket's memory cgroup association
   *	@sk_write_pending: a write to stream socket waits to start
   *	@sk_state_change: callback to indicate change in the state of the sock
@@ -523,6 +525,7 @@ struct sock {
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
index b47e4f0..4595540 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -35,6 +35,7 @@
 #include <linux/export.h>
 #include <linux/skbuff.h>
 #include <linux/list.h>
+#include <linux/vm_account.h>
 #include <linux/errqueue.h>
 
 #include "rds.h"
@@ -99,7 +100,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
 	struct list_head *head;
 	unsigned long flags;
 
-	mm_unaccount_pinned_pages(&znotif->z_mmp);
+	mm_unaccount_pinned_pages(&rs->rs_sk.sk_vm_account, &znotif->z_mmp);
 	q = &rs->rs_zcookie_queue;
 	spin_lock_irqsave(&q->lock, flags);
 	head = &q->zcookie_head;
@@ -367,6 +368,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 	int ret = 0;
 	int length = iov_iter_count(from);
 	struct rds_msg_zcopy_info *info;
+	struct vm_account *vm_account = &rm->m_rs->rs_sk.sk_vm_account;
 
 	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
 
@@ -380,7 +382,9 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
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
@@ -399,7 +403,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
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
