From: "T.J. Mercier" <tjmercier@google.com>
Subject: [RFC v3 3/8] dmabuf: Use the GPU cgroup charge/uncharge APIs
Date: Wed,  9 Mar 2022 16:52:13 +0000
Message-ID: <20220309165222.2843651-4-tjmercier@google.com>
References: <20220309165222.2843651-1-tjmercier@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=iI4tUDTwn0xfO1TZ7KSGGMNGPVBXGkFL9ZZA2HGZghg=;
        b=X9nwYEkE+WqweWRkaCswHljXOOyceq5HLfdQ2h5VCa5BOpSfIMw+CfpAA66J3vFCf2
         DnzE9UQtPeSlxG8o9pCfRDINTOEaiKErWwiNx6nfsrU8fAK+ceVUAS2JHMQD+AbI1jw8
         DKHKfrO6gE3o4AH5kcy/Xl/EwVhaZ69JUDtMIle7+RpS6ZagXNItEvUcdhXBvlHBpDzH
         l3fyRMp2q68ITY/BLJ3Wo+w0+hl26SwqRm77pi7ScO/UoZYTYj89rffHavcoKPlf9R6l
         UekpqNxes8w71bhq9KSVr3VQ8aymhFsdmRvHHLK69SFOrSb8FaW4zH7Z8JHbBxJrrLrt
         fypw==
In-Reply-To: <20220309165222.2843651-1-tjmercier@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>
Cc: kaleshsingh@google.com, Kenny.Ho@amd.com, "T.J. Mercier" <tjmercier@google.com>, dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org

This patch uses the GPU cgroup charge/uncharge APIs to charge buffers
allocated by any DMA-BUF exporter that exports a buffer with a GPU cgroup
device association.

By doing so, it becomes possible to track who allocated/exported a
DMA-BUF even after the allocating process drops all references to a
buffer.

Originally-by: Hridya Valsaraju <hridya@google.com>
Signed-off-by: T.J. Mercier <tjmercier@google.com>

---
v3 changes
Use more common dual author commit message format per John Stultz.

v2 changes
Move dma-buf cgroup charging/uncharging from a dma_buf_op defined by
every heap to a single dma-buf function for all heaps per Daniel Vetter and
Christian K=C3=B6nig.
---
 drivers/dma-buf/dma-buf.c | 52 +++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h   | 20 +++++++++++++--
 2 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 602b12d7470d..83d0d1b91547 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -56,6 +56,50 @@ static char *dmabuffs_dname(struct dentry *dentry, char =
*buffer, int buflen)
 			     dentry->d_name.name, ret > 0 ? name : "");
 }
=20
+#ifdef CONFIG_CGROUP_GPU
+static inline struct gpucg_device *
+exp_info_gpucg_dev(const struct dma_buf_export_info *exp_info)
+{
+	return exp_info->gpucg_dev;
+}
+
+static bool dmabuf_try_charge(struct dma_buf *dmabuf,
+			      struct gpucg_device *gpucg_dev)
+{
+	dmabuf->gpucg =3D gpucg_get(current);
+	dmabuf->gpucg_dev =3D gpucg_dev;
+	if (gpucg_try_charge(dmabuf->gpucg, dmabuf->gpucg_dev, dmabuf->size)) {
+		gpucg_put(dmabuf->gpucg);
+		dmabuf->gpucg =3D NULL;
+		dmabuf->gpucg_dev =3D NULL;
+		return false;
+	}
+	return true;
+}
+
+static void dmabuf_uncharge(struct dma_buf *dmabuf)
+{
+	if (dmabuf->gpucg && dmabuf->gpucg_dev) {
+		gpucg_uncharge(dmabuf->gpucg, dmabuf->gpucg_dev, dmabuf->size);
+		gpucg_put(dmabuf->gpucg);
+	}
+}
+#else /* CONFIG_CGROUP_GPU */
+static inline struct gpucg_device *exp_info_gpucg_dev(
+const struct dma_buf_export_info *exp_info)
+{
+	return NULL;
+}
+
+static inline bool dmabuf_try_charge(struct dma_buf *dmabuf,
+				     struct gpucg_device *gpucg_dev))
+{
+	return false;
+}
+
+static inline void dmabuf_uncharge(struct dma_buf *dmabuf) {}
+#endif /* CONFIG_CGROUP_GPU */
+
 static void dma_buf_release(struct dentry *dentry)
 {
 	struct dma_buf *dmabuf;
@@ -79,6 +123,8 @@ static void dma_buf_release(struct dentry *dentry)
 	if (dmabuf->resv =3D=3D (struct dma_resv *)&dmabuf[1])
 		dma_resv_fini(dmabuf->resv);
=20
+	dmabuf_uncharge(dmabuf);
+
 	WARN_ON(!list_empty(&dmabuf->attachments));
 	module_put(dmabuf->owner);
 	kfree(dmabuf->name);
@@ -484,6 +530,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_exp=
ort_info *exp_info)
 {
 	struct dma_buf *dmabuf;
 	struct dma_resv *resv =3D exp_info->resv;
+	struct gpucg_device *gpucg_dev =3D exp_info_gpucg_dev(exp_info);
 	struct file *file;
 	size_t alloc_size =3D sizeof(struct dma_buf);
 	int ret;
@@ -534,6 +581,9 @@ struct dma_buf *dma_buf_export(const struct dma_buf_exp=
ort_info *exp_info)
 	}
 	dmabuf->resv =3D resv;
=20
+	if (gpucg_dev && !dmabuf_try_charge(dmabuf, gpucg_dev))
+		goto err_charge;
+
 	file =3D dma_buf_getfile(dmabuf, exp_info->flags);
 	if (IS_ERR(file)) {
 		ret =3D PTR_ERR(file);
@@ -565,6 +615,8 @@ struct dma_buf *dma_buf_export(const struct dma_buf_exp=
ort_info *exp_info)
 	file->f_path.dentry->d_fsdata =3D NULL;
 	fput(file);
 err_dmabuf:
+	dmabuf_uncharge(dmabuf);
+err_charge:
 	kfree(dmabuf);
 err_module:
 	module_put(exp_info->owner);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 7ab50076e7a6..742f29c3daaf 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -13,6 +13,7 @@
 #ifndef __DMA_BUF_H__
 #define __DMA_BUF_H__
=20
+#include <linux/cgroup_gpu.h>
 #include <linux/dma-buf-map.h>
 #include <linux/file.h>
 #include <linux/err.h>
@@ -303,7 +304,7 @@ struct dma_buf {
 	/**
 	 * @size:
 	 *
-	 * Size of the buffer; invariant over the lifetime of the buffer.
+	 * Size of the buffer in bytes; invariant over the lifetime of the buffer=
.
 	 */
 	size_t size;
=20
@@ -453,6 +454,17 @@ struct dma_buf {
 		struct dma_buf *dmabuf;
 	} *sysfs_entry;
 #endif
+
+#ifdef CONFIG_CGROUP_GPU
+	/** @gpucg: Pointer to the cgroup this buffer currently belongs to. */
+	struct gpucg *gpucg;
+
+	/** @gpucg_dev:
+	 *
+	 * Pointer to the cgroup GPU device whence this buffer originates.
+	 */
+	struct gpucg_device *gpucg_dev;
+#endif
 };
=20
 /**
@@ -529,9 +541,10 @@ struct dma_buf_attachment {
  * @exp_name:	name of the exporter - useful for debugging.
  * @owner:	pointer to exporter module - used for refcounting kernel module
  * @ops:	Attach allocator-defined dma buf ops to the new buffer
- * @size:	Size of the buffer - invariant over the lifetime of the buffer
+ * @size:	Size of the buffer in bytes - invariant over the lifetime of the=
 buffer
  * @flags:	mode flags for the file
  * @resv:	reservation-object, NULL to allocate default one
+ * @gpucg_dev:	pointer to the gpu cgroup device this buffer belongs to
  * @priv:	Attach private data of allocator to this buffer
  *
  * This structure holds the information required to export the buffer. Use=
d
@@ -544,6 +557,9 @@ struct dma_buf_export_info {
 	size_t size;
 	int flags;
 	struct dma_resv *resv;
+#ifdef CONFIG_CGROUP_GPU
+	struct gpucg_device *gpucg_dev;
+#endif
 	void *priv;
 };
=20
--=20
2.35.1.616.g0bdcbb4464-goog

