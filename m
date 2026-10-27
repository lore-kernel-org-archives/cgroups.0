Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793113460;
	b=p7hhv7dRXWcehV+JuXZcfpijkTCktfPxRTUNCZU3OpB+06AkVquZcIJxmXLsN2gZV9+C
	 1CICru1VS6MV10CEVu6EuaSfoxITPwpRVHyFnFHhEGmwjokhiICW0ftotdKCcv/OYZNrx
	 pOwE2NdtI3HaEQzCf6ZtmCRgKJdwsuu/FPqIlaKmPqNmcUBwB7n0dgSyAIsx19fdzWJZg
	 xQEamfG+PNYpe4zK9eBLJVTO6wL3jHbtQ3sNg2YOInQNWOMFm80PNcFtbTCP5j8MI7Y7n
	 QK/UhCSrw2lt3+GkCbIZIyewbj4L6PsT31zV4iVpQJkJoHNT/jRhGuUqyuuN8/+wmjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113460;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=JZwtBKyLr4ECZCd2+9PuMt18JWTZrHrnrnE9ZLE/4aY=;
	b=lH/LiNxvou1tlHMlGo4Dn7IejhfcVE0RRHVdWWXkz0+e8t/bQJaO0N3j4dDIY53QNqjE
	 4H7WrQBImVOaAFSTbboP1+fGDKlF87T12GCL9VX4wuLZQlYSPr+pVpMBgxK9K3z4g1oN+
	 5SrYjdhY2henpVavhlLDhEGQcT/nwZn8UK1L6UK9b7dokM7BSBHDNOiwC/3e6eL1E2npe
	 yWEjXxWKqW8MMBj9ALo5MWqCWiBpXauqg7j4KSyeKD8xz/vC10qPz/Nq0uviQSUjmMMMS
	 oXx8C0s0kVsro+VhJa4hDdpHAzIPrZuHvwZbai/9NunTUHlJrt70vu/BIZrKM9av+ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CsXijtBw;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3A160A381D
	for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 15:04:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D3A160A381D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CsXijtBw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793113458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JZwtBKyLr4ECZCd2+9PuMt18JWTZrHrnrnE9ZLE/4aY=;
	b=CsXijtBw+g3l22fBe2+sHuKHeCuIGecyedzzsuTAA8BHow7pZ8mazRTpDvSmPKVPceaulN
	TnvR5LNRIZ3wnCKVUFAnBtsNniVMqPnpfOItLfdOVv6zXjn09hRjeaCVXcnbwOYG46YG6s
	JNzbrd9H7GmcxJ0rxlc0Gq+DDoev7oQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-132-hLPSKboKPoOB-L7yoR33-Q-1; Tue,
 27 Oct 2026 11:04:14 -0400
X-MC-Unique: hLPSKboKPoOB-L7yoR33-Q-1
X-Mimecast-MFC-AGG-ID: hLPSKboKPoOB-L7yoR33-Q_1793113450
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 162D11954B27;
	Tue, 27 Oct 2026 15:04:10 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D637518005AD;
	Tue, 27 Oct 2026 15:04:01 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 27 Oct 2026 16:02:50 +0100
Subject: [PATCH v3 7/8] dma-buf: transfer memcg charges via
 DMA_BUF_IOCTL_XFER_CHARGE
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
Message-Id: <20261027-v2_20230123_tjmercier_google_com-v3-7-78d2c4cb8647@redhat.com>
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
In-Reply-To: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
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
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, 
 echanude@redhat.com, mripard@kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793113379; l=9583;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=cZq5zxMcqsNYq3BSPJThsSnboQO3aHIPBDuwDi0uFtM=;
 b=JVhctY4fK1m+deaHVT4FIW3gyy5y1916+fPDCwSsLl/jYaKgw36hLAXAqq0IgVDweBIKo7ghG
 wTu9bi0vxX8ClLrUD4zYklFn0sbrGUvGGrrhk1KxQMb8VexSt6/wFc7
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

dma-heap already supports charging a specific cgroup at allocation
time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
originate from any exporter (DRM, V4L2, etc.), and the allocator may
not know the final owner at allocation time.

Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
to a different cgroup after allocation. The target is identified by
charge_fd, which may be a cgroupfd or a pidfd.

The transfer charges the new cgroup before uncharging the old one,
preserving the original charge on failure. An atomic cmpxchg on
dmabuf->memcg prevents races with concurrent transfers.

Not all dma-buf exporters back their buffers with reclaimable system
memory. Some represent device registers, VRAM, or carved-out pools
where size is not a meaningful memory cost. Add a memcg_account flag
to dma_buf_export_info that exporters set when their buffers should
participate in memcg accounting. The xfer ioctl returns -EOPNOTSUPP
for buffers that do not set the flag. Currently only the system heap
sets it, other exporters can opt in as needed.

Usage example:
  int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);

  struct dma_buf_transfer_charge xfer = {
      .charge_fd = cg_fd,
  };
  ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
  /* charge now on app1's cgroup */
  close(cg_fd);

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 drivers/dma-buf/dma-buf.c           | 43 +++++++++++++++++++++++++++++++++++++
 drivers/dma-buf/heaps/system_heap.c |  1 +
 include/linux/dma-buf.h             |  5 +++++
 include/linux/memcontrol.h          |  9 ++++++++
 include/uapi/linux/dma-buf.h        | 26 ++++++++++++++++++++++
 mm/memcontrol.c                     | 41 +++++++++++++++++++++++++++++++++++
 6 files changed, 125 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index f31f49ebd0af..07513ecedc10 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
 }
 #endif
 
+/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
+static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
+				const void __user *user_data)
+{
+	struct dma_buf_transfer_charge arg;
+	struct mem_cgroup *memcg;
+	int ret = 0;
+
+	if (copy_from_user(&arg, user_data, sizeof(arg)))
+		return -EFAULT;
+
+	if (!IS_ENABLED(CONFIG_MEMCG))
+		return 0;
+
+	if (arg.flags != 0)
+		return -EINVAL;
+
+	if (!dmabuf->memcg_account)
+		return -EOPNOTSUPP;
+
+	memcg = mem_cgroup_get_from_fd(arg.charge_fd);
+	if (IS_ERR(memcg))
+		return PTR_ERR(memcg);
+
+	if (dmabuf->memcg == memcg)
+		goto skip_transfer;
+
+	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
+		ret = -ENOMEM;
+		goto skip_transfer;
+	}
+
+	return 0;
+
+skip_transfer:
+	mem_cgroup_put(memcg);
+	return ret;
+}
+
 static long dma_buf_ioctl(struct file *file,
 			  unsigned int cmd, unsigned long arg)
 {
@@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
 		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
 #endif
 
+	case DMA_BUF_IOCTL_XFER_CHARGE:
+		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -750,6 +792,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	dmabuf->size = exp_info->size;
 	dmabuf->exp_name = exp_info->exp_name;
 	dmabuf->owner = exp_info->owner;
+	dmabuf->memcg_account = exp_info->memcg_account;
 	spin_lock_init(&dmabuf->name_lock);
 	init_waitqueue_head(&dmabuf->poll);
 	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index adeea8cd328b..a764167167ba 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -479,6 +479,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	exp_info.size = buffer->len;
 	exp_info.flags = fd_flags;
 	exp_info.priv = buffer;
+	exp_info.memcg_account = true;
 	dmabuf = dma_buf_export(&exp_info);
 	if (IS_ERR(dmabuf)) {
 		ret = PTR_ERR(dmabuf);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 23ec0ff23fba..ac0ec88cab93 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -433,6 +433,9 @@ struct dma_buf {
 
 	/** @memcg: the cgroup to which this buffer is currently attributed */
 	struct mem_cgroup *memcg;
+
+	/** @memcg_account: account buffer memory to cgroup */
+	bool memcg_account;
 };
 
 /**
@@ -505,6 +508,7 @@ struct dma_buf_attachment {
  * @flags:	mode flags for the file
  * @resv:	reservation-object, NULL to allocate default one
  * @priv:	Attach private data of allocator to this buffer
+ * @memcg_account:	account buffer memory to cgroup
  *
  * This structure holds the information required to export the buffer. Used
  * with dma_buf_export() only.
@@ -517,6 +521,7 @@ struct dma_buf_export_info {
 	int flags;
 	struct dma_resv *resv;
 	void *priv;
+	bool memcg_account;
 };
 
 /**
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6b30baa79fa9..36fddafbef4e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -679,6 +679,9 @@ bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
 void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
 			      unsigned int nr_pages);
 
+bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
+				       struct mem_cgroup *new_memcg);
+
 void __mem_cgroup_uncharge(struct folio *folio);
 
 /**
@@ -1206,6 +1209,12 @@ static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
 {
 }
 
+static inline bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
+						     struct mem_cgroup *new_memcg)
+{
+	return true;
+}
+
 static inline void mem_cgroup_uncharge(struct folio *folio)
 {
 }
diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
index e827c9d20c5d..ea957f4b1d38 100644
--- a/include/uapi/linux/dma-buf.h
+++ b/include/uapi/linux/dma-buf.h
@@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
 	__s32 fd;
 };
 
+/**
+ * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
+ *
+ * Any holder of a dma-buf file descriptor can perform a
+ * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
+ * cost to a specific cgroup, or move it from one cgroup to
+ * another.  The ioctl charges the new cgroup before uncharging
+ * the old one atomically.  On failure the original charge is
+ * preserved.  If the buffer has no existing charge, a new
+ * charge is established.
+ */
+struct dma_buf_transfer_charge {
+	/** @flags: Reserved, must be zero */
+	__u32 flags; /* unused for now */
+	/**
+	 * @charge_fd: File descriptor identifying the target cgroup.
+	 *
+	 * May be either a pidfd, in which case the charge moves to the
+	 * memory cgroup of the referenced process, or a cgroupfd obtained
+	 * by opening a cgroup v2 directory, in which case the charge moves
+	 * directly to that cgroup's memory controller.
+	 */
+	__u32 charge_fd;
+};
+
 #define DMA_BUF_BASE		'b'
 #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
 
@@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
 #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
 #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
 #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
+#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
 
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7b841b905759..3adc84fe6668 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5786,6 +5786,47 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
 		refill_stock(memcg, nr_pages);
 }
 
+/**
+ * mem_cgroup_transfer_dmabuf_charge - move a dma-buf charge
+ * @dmabuf: buffer to transfer charge
+ * @new_memcg: target memcg; caller must hold a reference
+ *
+ * Transfers the charge for @dmabuf to @new_memcg and, on
+ * success, stores @new_memcg in @dmabuf->memcg.
+ * Returns %true on success, %false if the charge against @new_memcg
+ * failed or a concurrent transfer raced on @dmabuf->memcg.
+ * On failure the caller retains its reference to @new_memcg.
+ */
+bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
+				       struct mem_cgroup *new_memcg)
+{
+	struct mem_cgroup *old_memcg = READ_ONCE(dmabuf->memcg);
+	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
+
+	if (mem_cgroup_disabled())
+		return true;
+
+	if (!mem_cgroup_reserve_dmabuf(new_memcg, GFP_KERNEL, nr_pages))
+		return false;
+
+	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
+
+	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) != old_memcg) {
+		mod_memcg_state(new_memcg, MEMCG_DMABUF, -nr_pages);
+		mem_cgroup_cancel_dmabuf(new_memcg, nr_pages);
+		return false;
+	}
+
+	if (old_memcg) {
+		/* Uncharge old cgroup */
+		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
+		mem_cgroup_cancel_dmabuf(old_memcg, nr_pages);
+		mem_cgroup_put(old_memcg);
+	}
+
+	return true;
+}
+
 /**
  * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
  * @dmabuf: buffer to uncharge

-- 
2.55.0

