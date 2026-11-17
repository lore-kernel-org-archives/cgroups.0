Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904807;
	b=pnNeNMl7yTFa93eFVdCAIwCM/MKCezc2jMrXXyNRXUb5LT8h2O0kMaz4umUP0+IQzGtr
	 5KJlHOfuevZRk9NV2+ieOy7V7W7K2IBEPphtPrpZ3LX5JJNPaz6oaFzQKdj6fnRky5402
	 UnCL5gRA+mpc9prXPZZoX+KK5AUyWG8H6r/GVwIXroN3te27xdEbBUcz0MgLJdoVz1UGA
	 MJzJLahlUBmVBcWnGQYOztGbcAdEPzlMW0zkMhyYMNwgi162LL4CoA4GH3eqLrzqCwE15
	 I76Bo6p6gEyka3abQfaG4TjKVai/iHMBpsOzVGjQXef/YO2/kXQCPYwqSoQIV1ZW27Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904807;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=H54NJImT9TlWN8O112UdcqrtZ3qlOEey7IxNjig/DIw=;
	b=49A4qMnhEKjf9IrFpmV42vqLo0EmjRyO3TQ3IcHZPIBRjbu0bYutbmySfbZK3lCbwNtT
	 z7TvVkptya8vYXGpdZh3Iln+BOTnVk6qfru/D8pAgY68HV3sbkSa9Fqs6joGyYSwHP8qI
	 o1QCjlKoxP/JUpz0tOHba121AZzqAvTCenpid3OLjly//ws24wMKxoOZ9SbZkt6nFI3Gp
	 UCfGTEzK6lkDrbgknYtQoKt5aZRceHzcoQcBg38H10uucllEraa4iNSJK0y5N61mLHdQ2
	 q/o8zoNprmZeWSikQaz6iLSV/yPmoY3mzxKzWxrF/R+AWDuixZjDqNwWw7sRF+kEOtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YKPfwe8I;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197C0606A880
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 08:40:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 197C0606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YKPfwe8I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794904807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H54NJImT9TlWN8O112UdcqrtZ3qlOEey7IxNjig/DIw=;
	b=YKPfwe8Ij3qtHHzTv4ab0Hw8mIHdf/noyhCfRixLCREGcv8gJtET+8xlXklDoBSYM3AoUW
	5lhk2uHKsIaN8N+FfTA48QllnZq6Qg2xpHpJGKjMVnJxzBtLfCEu2ZNfETTLqdL3d6izF2
	iw8bFUej56ClnRHU602737tcfwcmuxE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-84agdXxLMTGedNeaCyzaLg-1; Tue,
 17 Nov 2026 03:40:04 -0500
X-MC-Unique: 84agdXxLMTGedNeaCyzaLg-1
X-Mimecast-MFC-AGG-ID: 84agdXxLMTGedNeaCyzaLg_1794904800
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 280621956051;
	Tue, 17 Nov 2026 08:39:59 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D422B1956049;
	Tue, 17 Nov 2026 08:39:50 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 17 Nov 2026 09:39:18 +0100
Subject: [PATCH v5 3/8] dma-buf: transfer objcg charges via
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
Content-Transfer-Encoding: 8bit
Message-Id: <20261117-v2_20230123_tjmercier_google_com-v5-3-1ce975f2a9ad@redhat.com>
References: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
In-Reply-To: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
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
 Philipp Stanner <phasta@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: airlied@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, 
 echanude@redhat.com, mripard@kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794904759; l=9901;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=FdxUV/2gdJrGbEwQk3L2/HjwhfU02edgwK0RV+mcEAo=;
 b=fy0kKG65oDwyCQURFXe0FnJ2an9oBZWTiKFnkWjwL6+lzWaJ4aX9phAhjJGJVhdhE52JQViSN
 8kar6otOcHoC7Hr5a23VC+PZ8kGtXZekv3r/na2/OGjX8y9CrhRK+yp
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

dma-heap already supports charging a specific cgroup at allocation
time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
originate from any exporter (DRM, V4L2, etc.), and the allocator may
not know the final owner at allocation time.

Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's objcg charge
to a different cgroup after allocation. The target is identified by
charge_fd, which may be a cgroupfd or a pidfd.

The transfer charges the new cgroup before uncharging the old one,
preserving the original charge on failure. Concurrent transfers are
serialized by the dma-buf reservation lock, so lockdep covers the
locking order of the charge path early. The transfer implementation
is generic (obj_cgroup_transfer_charge) and not dma-buf specific, so
it can be reused by other subsystems.

Not all dma-buf exporters back their buffers with reclaimable system
memory. Some represent device registers, VRAM, or carved-out pools
where size is not a meaningful memory cost. The xfer ioctl returns
-EOPNOTSUPP for buffers whose objcg is not set. Exporters opt in by
passing a objcg through dma_buf_export_info at export time. Currently
only the system heap sets it, other exporters can opt in as needed.

Usage example:
  int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);

  struct dma_buf_transfer_charge xfer = {
      .charge_fd = cg_fd,
  };
  ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
  /* charge now on app1's cgroup */
  close(cg_fd);

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  2 +-
 drivers/dma-buf/dma-buf.c               | 39 ++++++++++++++++++++++
 include/linux/dma-buf.h                 |  3 +-
 include/linux/memcontrol.h              | 13 ++++++++
 include/uapi/linux/dma-buf.h            | 26 +++++++++++++++
 mm/memcontrol.c                         | 58 +++++++++++++++++++++++++++++++++
 6 files changed, 139 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index c6bf2e435d74..8d10ff7ac745 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1670,7 +1670,7 @@ The following nested keys are defined.
 		Amount of memory used for exported DMA buffers allocated by or on
 		behalf of the cgroup, this currently includes system heap
 		allocations. Stays with the cgroup regardless of how the buffer
-		is shared.
+		is shared, unless moved with DMA_BUF_IOCTL_XFER_CHARGE.
 
 	  workingset_refault_anon
 		Number of refaults of previously evicted anonymous pages.
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 88e0802fa05f..5d4b55b67e99 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -540,6 +540,42 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
 }
 #endif
 
+/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
+static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
+				const void __user *user_data)
+{
+	struct dma_buf_transfer_charge arg;
+	struct obj_cgroup *objcg;
+	unsigned int nr_pages;
+	int ret = 0;
+
+	if (copy_from_user(&arg, user_data, sizeof(arg)))
+		return -EFAULT;
+
+	if (arg.flags != 0)
+		return -EINVAL;
+
+	objcg = get_obj_cgroup_from_fd(arg.charge_fd);
+	if (IS_ERR(objcg))
+		return PTR_ERR(objcg);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	if (!dmabuf->objcg) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
+	if (!obj_cgroup_transfer_charge(&dmabuf->objcg, objcg, MEMCG_DMABUF, nr_pages))
+		ret = -ENOMEM;
+
+out:
+	dma_resv_unlock(dmabuf->resv);
+	obj_cgroup_put(objcg);
+	return ret;
+}
+
 static long dma_buf_ioctl(struct file *file,
 			  unsigned int cmd, unsigned long arg)
 {
@@ -590,6 +626,9 @@ static long dma_buf_ioctl(struct file *file,
 		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
 #endif
 
+	case DMA_BUF_IOCTL_XFER_CHARGE:
+		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index ff4678d00d8c..916d73ae6a51 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -508,7 +508,8 @@ struct dma_buf_attachment {
  * @objcg:	object cgroup to charge for this buffer's memory. Set only for
  *		buffers backed by system memory, not accounted elsewhere, where
  *		@size reflects the actual allocation in bytes. The buffer takes
- *		over the caller's reference.
+ *		over the caller's reference. Enables charge transfer via
+ *		DMA_BUF_IOCTL_XFER_CHARGE.
  *
  * This structure holds the information required to export the buffer. Used
  * with dma_buf_export() only.
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8e016d9b91bc..37c81be349b8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1827,6 +1827,11 @@ static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
 
+bool obj_cgroup_transfer_charge(struct obj_cgroup **ptr_objcg,
+				struct obj_cgroup *new_objcg,
+				enum memcg_stat_item item,
+				unsigned int nr_pages);
+
 extern struct static_key_false memcg_bpf_enabled_key;
 static inline bool memcg_bpf_enabled(void)
 {
@@ -1930,6 +1935,14 @@ static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 	return NULL;
 }
 
+static inline bool obj_cgroup_transfer_charge(struct obj_cgroup **ptr_objcg,
+					      struct obj_cgroup *new_objcg,
+					      enum memcg_stat_item item,
+					      unsigned int nr_pages)
+{
+	return true;
+}
+
 static inline bool memcg_bpf_enabled(void)
 {
 	return false;
diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
index e827c9d20c5d..0aaf2e7d593b 100644
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
+ * preserved.  If the buffer has no existing memcg charge, the
+ * ioctl returns -EOPNOTSUPP.
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
index adc0abcf80fa..03cd90d5e623 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3251,6 +3251,64 @@ struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
 	return objcg;
 }
 
+/**
+ * obj_cgroup_transfer_charge - move a charge between object cgroups
+ * @ptr_objcg: pointer to the object cgroup to transfer from
+ * @new_objcg: target object cgroup; caller must hold a reference
+ * @item: memcg stat counter to adjust; must not be a node stat
+ * @nr_pages: number of pages to transfer
+ *
+ * Transfers @nr_pages of charge from *@ptr_objcg to @new_objcg and, on
+ * success, stores @new_objcg in *@ptr_objcg. Does nothing if both resolve
+ * to the same memcg; *@ptr_objcg is left untouched in that case.
+ *
+ * Updates to *@ptr_objcg must be serialized by the caller.
+ * Returns %true on success, %false if the charge against @new_objcg
+ * failed.
+ */
+bool obj_cgroup_transfer_charge(struct obj_cgroup **ptr_objcg,
+				struct obj_cgroup *new_objcg,
+				enum memcg_stat_item item,
+				unsigned int nr_pages)
+{
+	struct obj_cgroup *old_objcg = *ptr_objcg;
+	struct mem_cgroup *old_memcg = NULL, *new_memcg;
+	bool ret = true;
+
+	if (!new_objcg || mem_cgroup_disabled())
+		return true;
+
+	new_memcg = get_mem_cgroup_from_objcg(new_objcg);
+	if (old_objcg)
+		old_memcg = get_mem_cgroup_from_objcg(old_objcg);
+
+	if (old_memcg == new_memcg)
+		goto out;
+
+	if (try_charge(new_memcg, GFP_KERNEL, nr_pages)) {
+		ret = false;
+		goto out;
+	}
+
+	mod_memcg_state(new_memcg, item, nr_pages);
+
+	if (old_objcg) {
+		/* Uncharge old cgroup */
+		mod_memcg_state(old_memcg, item, -nr_pages);
+		if (!mem_cgroup_is_root(old_memcg))
+			refill_stock(old_memcg, nr_pages);
+	}
+
+	obj_cgroup_get(new_objcg);
+	*ptr_objcg = new_objcg;
+	obj_cgroup_put(old_objcg);
+
+out:
+	mem_cgroup_put(new_memcg);
+	mem_cgroup_put(old_memcg);
+	return ret;
+}
+
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 static inline void account_kmem_nmi_safe(struct mem_cgroup *memcg, int val)
 {

-- 
2.55.0

