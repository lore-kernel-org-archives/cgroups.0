Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792597436;
	b=nzaF+AknaMQvpBDhFUF1C/L/FxOGNRRudSuQkOrcs9RW87UoVqO0oLqPFQ/6/VmGzwr4
	 pUS7FcZAq9K7LpEjaEifCibkQAba6Oth/pYJllJnLPVZF4VXA38IhweBfONC7i5GOy77q
	 jbCrm3bByaAaOUxR3PdYarZOIjRUK3gHkS6+R0UikXbjNslIR1kirB1sRrsAUsbbwSSBg
	 YVuyv2EBU7wJ4XDLMotwGsBDRqB1eK+hHf/AsQtD/sOlWunSrJ38WeLqNV8mZfTiZUoWD
	 2v8GeIaE57dMDnOIm05L9NKlBxn1g8wkjorcunA/76tubiA8r98j+pPUpFl563hNt5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792597436;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=yivnWKlz59x6cs0+Psl8GkA/e2tPRya8pm53pLnt02s=;
	b=0Fbe0PrIzlqT5I7VRzaU7XXkdDCNhlN6qG9FCM4q1wYNiPwCkQ7vBhR8cmobjIT05lYl
	 LYkBzN0Cs5kQw2Brbnfwh5DMy8odrmsiuz6wi9K69uOXv0P2rjnvRDuyTY1DUnxgiK042
	 DdB7s3d1Xymx9DvrM1vUw4VZSrMjn/bvpp81dlWNAZDxaQ7Yt3+2zOXa7rYbKqlDvPcY+
	 qY+aOH7/kOeoIR6q1Es8ZTHnGDcSbRmMkTBXOanSQH3KCYMhU3ir8oVQQlea0mW2KQ13I
	 np9P9aUpUUKrS3YjIh1SOISZ50MuqGwcWynNz8YF/1reeFj12xpWROZIxSBVfPY5GUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="YEZX/mNK";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8E1606C076
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 15:43:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E8E1606C076
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YEZX/mNK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792597434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yivnWKlz59x6cs0+Psl8GkA/e2tPRya8pm53pLnt02s=;
	b=YEZX/mNKSXPsGNta53DSfuv7Lyloe1DmndwbjsWXeGo3Tdsb+YMtSGcxacWmYFPHH8S3vt
	tEzASiPlzu3IXxyXKhymn9RyPS35PZkxeLP8K75AG77D53gofuOFvNmiAhBQVFVksbpChL
	ZwNqmwrGRwoPGalo8Rm97hU+U37/pvQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-278-kFgZa8WqNu6UlFh5OXytVA-1; Wed,
 21 Oct 2026 15:43:49 +0000
X-MC-Unique: kFgZa8WqNu6UlFh5OXytVA-1
X-Mimecast-MFC-AGG-ID: kFgZa8WqNu6UlFh5OXytVA_1792597425
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4A6D18007EA;
	Wed, 21 Oct 2026 15:43:45 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CD0F1800480;
	Wed, 21 Oct 2026 15:43:38 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 21 Oct 2026 17:42:28 +0200
Subject: [PATCH RFC v2 7/8] dma-buf: transfer memcg charges via
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
Message-Id: <20261021-v2_20230123_tjmercier_google_com-v2-7-ef6ee2dd8c5c@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597359; l=7983;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=6CVz6Ypa61I1rY340Fklr//PmqMfRi7+C2jjYxF6gY4=;
 b=5jqGdMgXXWqMcs84v94MWLjq/VK0w+y7HvI2vV7AByEIyiHBgGR61ui54Jcdd6u2wNeats76b
 zslGecqIybaAJNM8Xuzx48/EdDpTKdieuKEF5K10zuBd3tPe/bjDXB7
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
 drivers/dma-buf/dma-buf.c    | 77 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/memcontrol.h   |  9 ++++++
 include/uapi/linux/dma-buf.h | 26 +++++++++++++++
 mm/memcontrol.c              | 40 +++++++++++++++++++++++
 4 files changed, 152 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index f31f49ebd0af..7fa607d9bf65 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -540,6 +540,80 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
 }
 #endif
 
+static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
+				const void __user *user_data)
+{
+	struct cgroup *cgrp;
+	struct cgroup_subsys_state *css;
+	struct dma_buf_transfer_charge arg;
+	struct mem_cgroup *memcg;
+	struct task_struct *task;
+	const struct cred *tcred;
+	unsigned int pidfd_flags;
+	int ret = 0;
+
+	if (copy_from_user(&arg, user_data, sizeof(arg)))
+		return -EFAULT;
+
+	if (!IS_ENABLED(CONFIG_MEMCG))
+		return 0;
+
+	if (arg.__padding != 0)
+		return -EINVAL;
+
+	cgrp = cgroup_get_from_fd(arg.charge_fd);
+	if (!IS_ERR(cgrp)) {
+		/* charge_fd is a cgroupfd */
+		rcu_read_lock();
+		css = cgroup_css(cgrp, &memory_cgrp_subsys);
+		if (!css || !css_tryget_online(css)) {
+			rcu_read_unlock();
+			cgroup_put(cgrp);
+			return -ENOENT;
+		}
+
+		memcg = mem_cgroup_from_css(css);
+		rcu_read_unlock();
+
+		ret = security_dma_buf_charge_cgroup(current_cred(), cgrp);
+		cgroup_put(cgrp);
+		if (ret) {
+			mem_cgroup_put(memcg);
+			return ret;
+		}
+	} else {
+		/* charge_fd is a pidfd  */
+		task = pidfd_get_task(arg.charge_fd, &pidfd_flags);
+		if (IS_ERR(task))
+			return PTR_ERR(task);
+
+		tcred = get_task_cred(task);
+		ret = security_dma_buf_charge_task(current_cred(), tcred);
+		put_cred(tcred);
+		if (ret) {
+			put_task_struct(task);
+			return ret;
+		}
+
+		memcg = get_mem_cgroup_from_mm(task->mm);
+		put_task_struct(task);
+	}
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
@@ -590,6 +664,9 @@ static long dma_buf_ioctl(struct file *file,
 		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
 #endif
 
+	case DMA_BUF_IOCTL_XFER_CHARGE:
+		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index aa08fbb0c26c..3a6acfda1423 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -674,6 +674,9 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
 			      gfp_t gfp_mask);
 
+bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
+				       struct mem_cgroup *new_memcg);
+
 void __mem_cgroup_uncharge(struct folio *folio);
 
 /**
@@ -1183,6 +1186,12 @@ static inline bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf,
 	return true;
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
index e827c9d20c5d..4970a7b8e08e 100644
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
+	/**
+	 * @charge_fd: File descriptor identifying the target cgroup.
+	 *
+	 * May be either a pidfd, in which case the charge moves to the
+	 * memory cgroup of the referenced process, or a cgroupfd obtained
+	 * by opening a cgroup v2 directory, in which case the charge moves
+	 * directly to that cgroup's memory controller.
+	 */
+	__u32 charge_fd;
+	/** @__padding: Reserved, must be zero */
+	__u32 __padding;
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
index e94222237d31..d994a4b2d35e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5688,6 +5688,46 @@ bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
 	return true;
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
+	if (!mem_cgroup_disabled() && try_charge(new_memcg, GFP_KERNEL, nr_pages))
+		return false;
+
+	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) != old_memcg) {
+		if (!mem_cgroup_is_root(new_memcg))
+			refill_stock(new_memcg, nr_pages);
+		return false;
+	}
+
+	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
+
+	if (old_memcg) {
+		/* Uncharge old cgroup */
+		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
+		if (!mem_cgroup_is_root(old_memcg))
+			refill_stock(old_memcg, nr_pages);
+		/* unref from buffer - buffer keeps new ref to new_memcg */
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

