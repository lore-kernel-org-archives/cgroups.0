From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 11/19] xdp: convert to use vm_account
Date: Tue, 24 Jan 2023 16:42:40 +1100
Message-ID: <a046a01293b0aa31592fb6dea1839009f037a49d.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0W0p5nkXQyU1aX2kot2Ea5g7JV+lHiVX0c1iGBFb/bs=;
 b=RjSfZx+dfCzyTOWStKMBo05C3rq/ufLUyctmeYXAYJItlL2INf+LVq9u6BKViV5Q3L6REIxgjzJczv8zHROXTFliHUucL1VYy9lXD8V7A3cZwr3xjyhETc+bpnfPZt9dqD+NtE3sYCijNGZ3XwQlckkcjObSr0E3MXvYVBSnfw+iATTAlNpIX427NYo764b9230nPCtuXSN/xx+4vP2i2RDvRZnQzkh6Tq3o/IWibw7jrKzAca07SqadlRMfegDPNx4ijtPbh9EzUdwUUMsLgFsJGdFfqloCfkSs5t/nR/hEkTXlgR0vxjGQUTeil6EJJb2ayQKhAX6x+uPAo6supw==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Magnus Karlsson <magnus.karlsson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Maciej Fijalkowski <maciej.fijalkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Lemon <jonathan.lemon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Jesper Dangaard Brouer <hawk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Switch to using the new vm_account struct to charge pinned pages and
enforce the rlimit. This will allow a future change to also charge a
cgroup for limiting the number of pinned pages.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Björn Töpel" <bjorn-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Magnus Karlsson <magnus.karlsson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jonathan Lemon <jonathan.lemon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
Cc: Jesper Dangaard Brouer <hawk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/net/xdp_sock.h |  2 +-
 net/xdp/xdp_umem.c     | 38 +++++++++++++-------------------------
 2 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 3057e1a..b0d3c16 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -25,7 +25,7 @@ struct xdp_umem {
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
