From: Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 11/19] xdp: convert to use vm_account
Date: Mon,  6 Feb 2023 18:47:48 +1100
Message-ID: <f3b11743f170f4750efa58eba61843563a4b7926.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekaPX/00S+h70lFxojvYEzzxngZqMCIdq9dGbDFXgv0=;
 b=dNyGq21XS2lvzTJSJQWV2Dx2hCd50LZlN6ntem5wh+6FJ/wf25TDeGen5qzV/Ru+sSrrRfFfbT2vX0LXlq9OCiuFpBI7KMGEUOyWR6fOXlmu1oVxm+MKYfKxOSs17oG9LlGjoGhF9kxJWb4vSXo/L+2bzdrveRZ7QGe/9BJ6D1ZOXD71dpYeFa9kyJfAUNPBXvBBiuKAoTkCB9TNSundH10vtOke9XV5FGVFHq9TfBBSkuNyXy595aiL5Go9zAK6DAFviaAhBZGTVTWhHUbjkI3iI5WmEX/SU1onOp1pJvG/7mW5f5AdV9KcXE4gbAW5baCMauVktp/tKI5dQecLUQ==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Daniel P . Berrange" <berrange@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Alistair Popple <apopple@nvidia.com>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>, Magnus Karlsson <magnus.karlsson@intel.com>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, bpf@vger.kernel.org

Switch to using the new vm_account struct to charge pinned pages and
enforce the rlimit. This will allow a future change to also charge a
cgroup for limiting the number of pinned pages.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: "Björn Töpel" <bjorn@kernel.org>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/net/xdp_sock.h |  3 ++-
 net/xdp/xdp_umem.c     | 38 +++++++++++++-------------------------
 2 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 3057e1a..9a21054 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -12,6 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
+#include <linux/vm_account.h>
 #include <net/sock.h>
 
 struct net_device;
@@ -25,7 +26,7 @@ struct xdp_umem {
 	u32 chunk_size;
 	u32 chunks;
 	u32 npgs;
-	struct user_struct *user;
+	struct vm_account vm_account;
 	refcount_t users;
 	u8 flags;
 	bool zc;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 4681e8e..4b5fb2f 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -29,12 +29,10 @@ static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 	umem->pgs = NULL;
 }
 
-static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
+static void xdp_umem_unaccount_pages(struct xdp_umem *umem, u32 npgs)
 {
-	if (umem->user) {
-		atomic_long_sub(umem->npgs, &umem->user->locked_vm);
-		free_uid(umem->user);
-	}
+	vm_unaccount_pinned(&umem->vm_account, npgs);
+	vm_account_release(&umem->vm_account);
 }
 
 static void xdp_umem_addr_unmap(struct xdp_umem *umem)
@@ -54,13 +52,15 @@ static int xdp_umem_addr_map(struct xdp_umem *umem, struct page **pages,
 
 static void xdp_umem_release(struct xdp_umem *umem)
 {
+	u32 npgs = umem->npgs;
+
 	umem->zc = false;
 	ida_free(&umem_ida, umem->id);
 
 	xdp_umem_addr_unmap(umem);
 	xdp_umem_unpin_pages(umem);
 
-	xdp_umem_unaccount_pages(umem);
+	xdp_umem_unaccount_pages(umem, npgs);
 	kfree(umem);
 }
 
@@ -127,24 +127,13 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 
 static int xdp_umem_account_pages(struct xdp_umem *umem)
 {
-	unsigned long lock_limit, new_npgs, old_npgs;
-
-	if (capable(CAP_IPC_LOCK))
-		return 0;
-
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	umem->user = get_uid(current_user());
+	vm_account_init(&umem->vm_account, current,
+			current_user(), VM_ACCOUNT_USER);
+	if (vm_account_pinned(&umem->vm_account, umem->npgs)) {
+		vm_account_release(&umem->vm_account);
+		return -ENOBUFS;
+	}
 
-	do {
-		old_npgs = atomic_long_read(&umem->user->locked_vm);
-		new_npgs = old_npgs + umem->npgs;
-		if (new_npgs > lock_limit) {
-			free_uid(umem->user);
-			umem->user = NULL;
-			return -ENOBUFS;
-		}
-	} while (atomic_long_cmpxchg(&umem->user->locked_vm, old_npgs,
-				     new_npgs) != old_npgs);
 	return 0;
 }
 
@@ -204,7 +193,6 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->chunks = chunks;
 	umem->npgs = (u32)npgs;
 	umem->pgs = NULL;
-	umem->user = NULL;
 	umem->flags = mr->flags;
 
 	INIT_LIST_HEAD(&umem->xsk_dma_list);
@@ -227,7 +215,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 out_unpin:
 	xdp_umem_unpin_pages(umem);
 out_account:
-	xdp_umem_unaccount_pages(umem);
+	xdp_umem_unaccount_pages(umem, npgs);
 	return err;
 }
 
-- 
git-series 0.9.1
