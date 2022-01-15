From: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC 3/6] dmabuf: heaps: Use the GPU cgroup charge/uncharge APIs
Date: Fri, 14 Jan 2022 17:06:01 -0800
Message-ID: <20220115010622.3185921-4-hridya__28837.5804246002$1642208895$gmane$org@google.com>
References: <20220115010622.3185921-1-hridya@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LfOWpUXhBkdNMBSdLOLDySgcwCzbXXwP1iBJEDhZFv8=;
        b=J5mPbGLt7ug0i6rUOlPQB0SbUQWFJSgsvFcHqlpnRStYUmz1v8nAst5BH8KdUKH+E5
         Y+y+ri5cPm3Uc/11fNmg6U++8GpkzZIL7XzsjexToSq8fHDkgii6o4uCbMapylVz/zEG
         3m9pF8AyP4tGEI6jLNHgoo9nrfidCLz5OBW+Y7Zf+hWlmtr7PKpPe6JO8A2jObfel0K5
         vtHp9sm9kp4trwusYDUnrCA+WhVBojy0HqwJMYa1rlb4GwpGlQwdtwLnm2rfqYKTjW20
         BG0Wzk29UTQ44uAuhbMgF+LJ2TfXg8DiW2p23TbKNWUdiFe4hDC7YPdZpGFY11QQM6RU
         Gpkg==
In-Reply-To: <20220115010622.3185921-1-hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <Brian.Sta>
Cc: Kenny.Ho-5C7GfCeVMHo@public.gmane.org, daniels-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

This patch uses the GPU cgroup charge/uncharge APIs to charge buffers
allocated by the DMA-BUF system heap to the processes who allocated them.

By doing so, it becomes possible to track who allocated/exported a
DMA-BUF even after the allocating process drops all references to a
buffer.

Signed-off-by: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/dma-buf/dma-heap.c          | 27 +++++++++++++++++++++++++++
 drivers/dma-buf/heaps/system_heap.c | 25 +++++++++++++++++++++++++
 include/linux/dma-heap.h            | 11 +++++++++++
 3 files changed, 63 insertions(+)

diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index 56bf5ad01ad5..6e74690f4b83 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2019 Linaro Ltd.
  */
 
+#include <linux/cgroup_gpu.h>
 #include <linux/cdev.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
@@ -30,6 +31,7 @@
  * @heap_devt		heap device node
  * @list		list head connecting to list of heaps
  * @heap_cdev		heap char device
+ * @gpucg_dev           gpu cg device for memory accounting
  *
  * Represents a heap of memory from which buffers can be made.
  */
@@ -40,6 +42,9 @@ struct dma_heap {
 	dev_t heap_devt;
 	struct list_head list;
 	struct cdev heap_cdev;
+#ifdef CONFIG_CGROUP_GPU
+	struct gpucg_device gpucg_dev;
+#endif
 };
 
 static LIST_HEAD(heap_list);
@@ -214,6 +219,26 @@ const char *dma_heap_get_name(struct dma_heap *heap)
 	return heap->name;
 }
 
+#ifdef CONFIG_CGROUP_GPU
+/**
+ * dma_heap_get_gpucg_dev() - get struct gpucg_device for the heap.
+ * @heap: DMA-Heap to get the gpucg_device struct for.
+ *
+ * Returns:
+ * The gpucg_device struct for the heap. NULL if the GPU cgroup controller is
+ * not enabled.
+ */
+struct gpucg_device *dma_heap_get_gpucg_dev(struct dma_heap *heap)
+{
+	return &heap->gpucg_dev;
+}
+#else
+struct gpucg_device *dma_heap_get_gpucg_dev(struct dma_heap *heap)
+{
+	return NULL;
+}
+#endif
+
 struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
 {
 	struct dma_heap *heap, *h, *err_ret;
@@ -286,6 +311,8 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
 	list_add(&heap->list, &heap_list);
 	mutex_unlock(&heap_list_lock);
 
+	gpucg_register_device(dma_heap_get_gpucg_dev(heap), exp_info->name);
+
 	return heap;
 
 err2:
diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index ab7fd896d2c4..adfdc8c576f2 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -31,6 +31,7 @@ struct system_heap_buffer {
 	struct sg_table sg_table;
 	int vmap_cnt;
 	void *vaddr;
+	struct gpucg *gpucg;
 };
 
 struct dma_heap_attachment {
@@ -296,6 +297,13 @@ static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
 		__free_pages(page, compound_order(page));
 	}
 	sg_free_table(table);
+
+	gpucg_uncharge(buffer->gpucg,
+		       dma_heap_get_gpucg_dev(buffer->heap),
+		       buffer->len);
+
+	gpucg_put(buffer->gpucg);
+
 	kfree(buffer);
 }
 
@@ -356,6 +364,16 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	mutex_init(&buffer->lock);
 	buffer->heap = heap;
 	buffer->len = len;
+	buffer->gpucg = gpucg_get(current);
+
+	ret = gpucg_try_charge(buffer->gpucg,
+			       dma_heap_get_gpucg_dev(buffer->heap),
+			       len);
+	if (ret) {
+		gpucg_put(buffer->gpucg);
+		kfree(buffer);
+		return ERR_PTR(ret);
+	}
 
 	INIT_LIST_HEAD(&pages);
 	i = 0;
@@ -413,6 +431,13 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 free_buffer:
 	list_for_each_entry_safe(page, tmp_page, &pages, lru)
 		__free_pages(page, compound_order(page));
+
+	gpucg_uncharge(buffer->gpucg,
+		       dma_heap_get_gpucg_dev(buffer->heap),
+		       buffer->len);
+
+	gpucg_put(buffer->gpucg);
+
 	kfree(buffer);
 
 	return ERR_PTR(ret);
diff --git a/include/linux/dma-heap.h b/include/linux/dma-heap.h
index 0c05561cad6e..e447a61d054e 100644
--- a/include/linux/dma-heap.h
+++ b/include/linux/dma-heap.h
@@ -10,6 +10,7 @@
 #define _DMA_HEAPS_H
 
 #include <linux/cdev.h>
+#include <linux/cgroup_gpu.h>
 #include <linux/types.h>
 
 struct dma_heap;
@@ -59,6 +60,16 @@ void *dma_heap_get_drvdata(struct dma_heap *heap);
  */
 const char *dma_heap_get_name(struct dma_heap *heap);
 
+/**
+ * dma_heap_get_gpucg_dev() - get a pointer to the struct gpucg_device for the
+ * heap.
+ * @heap: DMA-Heap to retrieve gpucg_device for.
+ *
+ * Returns:
+ * The gpucg_device struct for the heap.
+ */
+struct gpucg_device *dma_heap_get_gpucg_dev(struct dma_heap *heap);
+
 /**
  * dma_heap_add - adds a heap to dmabuf heaps
  * @exp_info:		information needed to register this heap
-- 
2.34.1.703.g22d0c6ccf7-goog

