Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792597397;
	b=R/LcwhDmpdMiBvHyPbFB28Iga8rxakqrbO31/2WTKwOyS6GgT3DyED3jMD59H+zx0EIU
	 2xZhrIgrWRq3ImjZ70Z33rg34UDw3sTvIiyNmUp5+X7osqtHXpR1+yM7RPQa2bk6vBOcL
	 lJy8/b5iK4NBKvP5llgYVSsfLixtkosE/udWO8DWb4920TlqWGI+jYJSI0xDT5lCCFFMq
	 Pqtseupbh+iAWniJtPlK7YD/fF+ezur1VG+ADgW57YgicTOxjM90qu0aI9hA/bSZhPgdj
	 iF8AHlRzIyskT9c0Z5olYJa8iK4zQV0luyQRMIpFVlf7Z/PQjE1Fo9YlnDYTyL/Shtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792597397;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=PGvKxLtVkj8aET1gCZB9vB9TUPm0s+OVrj/WLz6eC1s=;
	b=QAKIx06k1PRTd3s3bwrzUNcymbZDigIKCV7zfrJiM2E6b0jefcZHDwIqQRijVp8lUx4M
	 Ssvyq/H+qpWmnsaMtsx4KzChkwABTRgSjL6H76cIZ1oAfFWvzURFfGRfNqlH9995HjIPQ
	 hSPbO+q1nlofngQwRUoLFTx/LEEIQ5P4/8ad68sK0KhkqunuUJ74e2Y7W10Xz0oVH2Jl7
	 6wBSyaSGIaqBhrmQ+/wr5oSLHlglaRvTpTd3Lb7bC2uFoQTNYYyEJJKjXBNJzpGYdYANc
	 63j9rr3/bn00dQPpYHpIlnquxoOjzbY8pFzdQI4DrEKL5ohlpb+oh7Cwvt72YHBh8kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TY+b+1w1;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0288660A2611
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 15:43:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0288660A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TY+b+1w1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792597396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PGvKxLtVkj8aET1gCZB9vB9TUPm0s+OVrj/WLz6eC1s=;
	b=TY+b+1w15AxwsHLOt6fkOA7Pzx+l5n4ysSCVimHBVfRVlNiwXVpO2JaIYSTTRPcow62/1T
	swP4VvXHeAsfOEAr46LLbweCuALEf6+uj5Ow1j9zQPJx+93bmuAU29kqvvG7M1AAazIBx+
	eN7XuieOMmSBn16503f0xT5XvOJzWdw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-385-bQW6sU6oM1ecRjRIWtI3tQ-1; Wed,
 21 Oct 2026 15:43:11 +0000
X-MC-Unique: bQW6sU6oM1ecRjRIWtI3tQ-1
X-Mimecast-MFC-AGG-ID: bQW6sU6oM1ecRjRIWtI3tQ_1792597387
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B1F11955F6F;
	Wed, 21 Oct 2026 15:43:06 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8DFF18002B1;
	Wed, 21 Oct 2026 15:42:58 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 21 Oct 2026 17:42:23 +0200
Subject: [PATCH RFC v2 2/8] dma-heap: charge dma-buf memory via explicit
 memcg
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-v2_20230123_tjmercier_google_com-v2-2-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Albert Esteve <aesteve@redhat.com>, mripard@kernel.org, echanude@redhat.com
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597359; l=7192;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=pji/4sq7BscjELUksmBSA71bWOhvozaMRbSph78T9cQ=;
 b=Isdo/bRMmwngdlwtW8H3L+1rYgtwEY7gCEZPRlMy/eV+nPd/KFWzKnKRx2Oor82bt0qG6Ijpg
 l/zwH9kDfobCRGZtlStUwCFYOit2gLeFZK57CEEvUUod+4QEjeq+xXW
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On embedded platforms a central process often allocates dma-buf
memory on behalf of client applications. Without a way to
attribute the charge to the requesting client's cgroup, the
cost lands on the allocator, making per-cgroup memory limits
ineffective for the actual consumers.

Add charge_fd to struct dma_heap_allocation_data. When set to
a valid pidfd or cgroupfd, DMA_HEAP_IOCTL_ALLOC resolves the target
task's or cgroup's memcg and charges the buffer there via
mem_cgroup_charge_dmabuf() inside dma_heap_ioctl_allocate().
Without charge_fd, and with the mem_accounting module parameter enabled,
the buffer is charged to the allocator's own cgroup.

Usage examples:

  1. Central allocator charging to a client at allocation time.
     The allocator knows the client's PID (e.g., from binder's
     sender_pid) and uses pidfd to attribute the charge:

       pid_t client_pid = txn->sender_pid;
       int pidfd = pidfd_open(client_pid, 0);

       struct dma_heap_allocation_data alloc = {
           .len         = buffer_size,
           .fd_flags    = O_RDWR | O_CLOEXEC,
           .charge_fd   = pidfd,
       };
       ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
       close(pidfd);
       /* alloc.fd is now charged to client's cgroup */

  2. Default allocation (no pidfd, mem_accounting=1).
     When charge_fd is not set and the mem_accounting module
     parameter is enabled, the buffer is charged to the allocator's
     own cgroup:

       struct dma_heap_allocation_data alloc = {
           .len      = buffer_size,
           .fd_flags = O_RDWR | O_CLOEXEC,
       };
       ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
       /* charged to current process's cgroup */

Current limitations:

 - Single-owner model: a dma-buf carries one memcg charge regardless of
   how many processes share it. Means only the first owner (and exporter)
   of the shared buffer bears the charge.
 - Only memcg accounting supported. While this makes sense for system
   heap buffers, other heaps (e.g., CMA heaps) will require selectively
   charging also for the dmem controller.
 - Charging CMA-backed heaps to memcg charges unreclaimable memory:
   when a cgroup hits its limit, try_charge_memcg() may trigger a
   reclaim pass that cannot free CMA pages. This is consistent with
   other unreclaimable memcg charges. A refinement for the next version
   could move charging into per-heap callbacks and skip the futile
   reclaim.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  5 +--
 drivers/dma-buf/dma-heap.c              | 54 +++++++++++++++++++++++++++++++--
 include/uapi/linux/dma-heap.h           |  7 +++++
 3 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index a3265a4a953e..66ddba678784 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1663,8 +1663,9 @@ The following nested keys are defined.
 		structures.
 
 	  dmabuf (npn)
-		Amount of memory used for exported DMA buffers allocated by the cgroup.
-		Stays with the allocating cgroup regardless of how the buffer is shared.
+		Amount of memory used for exported DMA buffers allocated by or on
+		behalf of the cgroup. Stays with the allocating cgroup regardless
+		of how the buffer is shared.
 
 	  workingset_refault_anon
 		Number of refaults of previously evicted anonymous pages.
diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index 8a6c2b6e0cc6..be77a4c168ab 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -7,14 +7,18 @@
  */
 
 #include <linux/cdev.h>
+#include <linux/cgroup.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-heap.h>
+#include <linux/memcontrol.h>
+#include <linux/sched/mm.h>
 #include <linux/err.h>
 #include <linux/export.h>
 #include <linux/list.h>
 #include <linux/minmax.h>
 #include <linux/nospec.h>
+#include <linux/pidfd.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <linux/xarray.h>
@@ -75,9 +79,14 @@ static int dma_heap_open(struct inode *inode, struct file *file)
 
 static struct dma_buf *dma_heap_ioctl_allocate(struct file *file, void *data)
 {
+	struct cgroup *cgrp;
+	struct cgroup_subsys_state *css;
 	struct dma_heap_allocation_data *heap_allocation = data;
 	struct dma_heap *heap = file->private_data;
 	struct dma_buf *dmabuf;
+	struct mem_cgroup *memcg = NULL;
+	struct task_struct *task;
+	unsigned int pidfd_flags;
 	int fd;
 	size_t len;
 
@@ -90,15 +99,56 @@ static struct dma_buf *dma_heap_ioctl_allocate(struct file *file, void *data)
 	if (heap_allocation->heap_flags & ~DMA_HEAP_VALID_HEAP_FLAGS)
 		return ERR_PTR(-EINVAL);
 
+	if (heap_allocation->charge_fd) {
+		cgrp = cgroup_get_from_fd(heap_allocation->charge_fd);
+		if (!IS_ERR(cgrp)) {
+			/* charge_fd is a cgroupfd */
+			rcu_read_lock();
+			css = cgroup_css(cgrp, &memory_cgrp_subsys);
+			if (!css || !css_tryget_online(css)) {
+				rcu_read_unlock();
+				cgroup_put(cgrp);
+				return ERR_PTR(-ENOENT);
+			}
+
+			memcg = mem_cgroup_from_css(css);
+			rcu_read_unlock();
+			cgroup_put(cgrp);
+		} else {
+			/* charge_fd is a pidfd  */
+			task = pidfd_get_task(heap_allocation->charge_fd, &pidfd_flags);
+			if (IS_ERR(task))
+				return ERR_CAST(task);
+
+			memcg = get_mem_cgroup_from_mm(task->mm);
+			put_task_struct(task);
+		}
+	}
+
 	len = PAGE_ALIGN(heap_allocation->len);
-	if (!len)
+	if (!len) {
+		mem_cgroup_put(memcg);
 		return ERR_PTR(-EINVAL);
+	}
 
 	dmabuf = heap->ops->allocate(heap, len, heap_allocation->fd_flags,
 				     heap_allocation->heap_flags);
 
-	if (IS_ERR(dmabuf))
+	if (IS_ERR(dmabuf)) {
+		mem_cgroup_put(memcg);
 		return dmabuf;
+	}
+
+	if (!memcg && mem_accounting)
+		memcg = get_mem_cgroup_from_mm(current->mm);
+
+	if (memcg) {
+		if (!mem_cgroup_charge_dmabuf(dmabuf, memcg, GFP_KERNEL)) {
+			mem_cgroup_put(memcg);
+			dma_buf_put(dmabuf);
+			return ERR_PTR(-ENOMEM);
+		}
+	}
 
 	fd = get_unused_fd_flags(heap_allocation->fd_flags);
 	if (fd < 0) {
diff --git a/include/uapi/linux/dma-heap.h b/include/uapi/linux/dma-heap.h
index a4cf716a49fa..bfcd1c25bc7e 100644
--- a/include/uapi/linux/dma-heap.h
+++ b/include/uapi/linux/dma-heap.h
@@ -29,6 +29,11 @@
  *			handle to the allocated dma-buf
  * @fd_flags:		file descriptor flags used when allocating
  * @heap_flags:		flags passed to heap
+ * @charge_fd:		optional pidfd or cgroupfd whose cgroup should be
+ *			charged for this allocation; 0 means charge the calling
+ *			process's cgroup when the mem_accounting module parameter
+ *			is enabled, or skip charging otherwise
+ * @__padding:		reserved, must be zero
  *
  * Provided by userspace as an argument to the ioctl
  */
@@ -37,6 +42,8 @@ struct dma_heap_allocation_data {
 	__u32 fd;
 	__u32 fd_flags;
 	__u64 heap_flags;
+	__u32 charge_fd;
+	__u32 __padding;
 };
 
 #define DMA_HEAP_IOC_MAGIC		'H'

-- 
2.55.0

