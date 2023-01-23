From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/4] dmabuf: Add cgroup charge transfer function
Date: Mon, 23 Jan 2023 19:17:24 +0000
Message-ID: <20230123191728.2928839-3-tjmercier@google.com>
References: <20230123191728.2928839-1-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9WOZzSEfhu/PT9TWBWMQDCCNsrofWV34oFDU/0sj1mQ=;
        b=CLJ2JxK/Tm4oa2T67r1/7AoCewa4cPoaCpXx/gVHbZ1m+FYlbdBISpcie92wke9qiT
         ywnZGTRRWgUyvtV2GeIN6CSF1A1BpACoPsOvCJSqkdka36IG7lwA9jHJB0/1Y37BiDn6
         UZyz4QR44eh7OHGKOjLnRuXG7qELlMRlfRNYaxnDlTMYAnQZZAKF7GLGFraikV5q7pPa
         PqEGE55YfXGgQoOaL42PCJmSLM5OLIrr2pXTamoSK+ZBJQZ3xablgI1e6ZxykShX+C1V
         OGCeujU9/+VSQurUIb0N4LKyFw0PX0Xvt3l2bOlWDy6qNiZqzVXsJcA5m/zeCrF4rUUR
         ohNg==
In-Reply-To: <20230123191728.2928839-1-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, daniel.vetter-/w4YWyX8dFk@public.gmane.org, android-mm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jeffv-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The dma_buf_transfer_charge function provides a way for processes to
transfer charge of a buffer to a different cgroup. This is essential
for the cases where a central allocator process does allocations for
various subsystems, hands over the fd to the client who requested the
memory, and drops all references to the allocated memory.

Signed-off-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/dma-buf/dma-buf.c  | 56 ++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h    |  1 +
 include/linux/memcontrol.h |  5 ++++
 3 files changed, 62 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index a6a8cb5cb32d..ac3d02a7ecf8 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -11,6 +11,7 @@
  * refining of this idea.
  */
 
+#include <linux/atomic.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
@@ -1626,6 +1627,61 @@ void dma_buf_vunmap_unlocked(struct dma_buf *dmabuf, struct iosys_map *map)
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_vunmap_unlocked, DMA_BUF);
 
+/**
+ * dma_buf_transfer_charge - Change the cgroup to which the provided dma_buf is charged.
+ * @dmabuf_file:	[in]	file for buffer whose charge will be migrated to a different cgroup
+ * @target:		[in]	the task_struct of the destination process for the cgroup charge
+ *
+ * Only tasks that belong to the same cgroup the buffer is currently charged to
+ * may call this function, otherwise it will return -EPERM.
+ *
+ * Returns 0 on success, or a negative errno code otherwise.
+ */
+int dma_buf_transfer_charge(struct file *dmabuf_file, struct task_struct *target)
+{
+	struct mem_cgroup *current_cg, *target_cg;
+	struct dma_buf *dmabuf;
+	unsigned int nr_pages;
+	int ret = 0;
+
+	if (!IS_ENABLED(CONFIG_MEMCG))
+		return 0;
+
+	if (WARN_ON(!dmabuf_file) || WARN_ON(!target))
+		return -EINVAL;
+
+	if (!is_dma_buf_file(dmabuf_file))
+		return -EBADF;
+	dmabuf = dmabuf_file->private_data;
+
+	nr_pages = PAGE_ALIGN(dmabuf->size) / PAGE_SIZE;
+	current_cg = mem_cgroup_from_task(current);
+	target_cg = get_mem_cgroup_from_mm(target->mm);
+
+	if (current_cg == target_cg)
+		goto skip_transfer;
+
+	if (!mem_cgroup_charge_dmabuf(target_cg, nr_pages, GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto skip_transfer;
+	}
+
+	if (cmpxchg(&dmabuf->memcg, current_cg, target_cg) != current_cg) {
+		/* Only the current owner can transfer the charge */
+		ret = -EPERM;
+		mem_cgroup_uncharge_dmabuf(target_cg, nr_pages);
+		goto skip_transfer;
+	}
+
+	mem_cgroup_uncharge_dmabuf(current_cg, nr_pages);
+	mem_cgroup_put(current_cg); /* unref from buffer - buffer keeps new ref to target_cg */
+	return 0;
+
+skip_transfer:
+	mem_cgroup_put(target_cg);
+	return ret;
+}
+
 #ifdef CONFIG_DEBUG_FS
 static int dma_buf_debug_show(struct seq_file *s, void *unused)
 {
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 1f0ffb8e4bf5..f25eb8e60fb2 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -634,4 +634,5 @@ int dma_buf_vmap(struct dma_buf *dmabuf, struct iosys_map *map);
 void dma_buf_vunmap(struct dma_buf *dmabuf, struct iosys_map *map);
 int dma_buf_vmap_unlocked(struct dma_buf *dmabuf, struct iosys_map *map);
 void dma_buf_vunmap_unlocked(struct dma_buf *dmabuf, struct iosys_map *map);
+int dma_buf_transfer_charge(struct file *dmabuf_file, struct task_struct *target);
 #endif /* __DMA_BUF_H__ */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c10b8565fdbf..009298a446fe 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1335,6 +1335,11 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css)
 	return NULL;
 }
 
+static inline struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
+{
+	return NULL;
+}
+
 static inline void obj_cgroup_put(struct obj_cgroup *objcg)
 {
 }
-- 
2.39.0.246.g2a6d74b583-goog

