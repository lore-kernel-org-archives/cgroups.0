From: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC 5/6] dmabuf: system_heap: implement dma-buf op for GPU cgroup
 charge transfer
Date: Fri, 14 Jan 2022 17:06:03 -0800
Message-ID: <20220115010622.3185921-6-hridya@google.com>
References: <20220115010622.3185921-1-hridya@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ti5KO9A8vk9sjDtc4QE21jT0NFR0GaV/WLBKcRARKgI=;
        b=S7eWa/B0tO4XbPv0OdCk5n8qWLZPt/5gRI1DTJwTi5GhQHBW/2q4S1Goa6HVJ53kOV
         C4SDzmhRcejlHxG15TPB2RCHg/RE9n0Klhhmd91JlvLbggw+Zomcqm6xLZmX5+VZmd5v
         6z2PEUpw/n9msL7glrfIs7RCavPk8+6AWV+iux/DG1QvtvTlcz7OoEHlREsv93KpGfY7
         7PequsOl0jKjwIIwYcy3wUNuWKC7exUsRjvXFMuBU8C8z0cNytD8ojAHfXP8uaBhODyO
         ecTIbTrob/3fDmTXsmgbfls5PaDFeVT7ZAhbWGu7Ln8w+tk/R5tS0MQPM33+aFxrGILz
         73Tg==
In-Reply-To: <20220115010622.3185921-1-hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <Brian.Sta>
Cc: Kenny.Ho-5C7GfCeVMHo@public.gmane.org, daniels-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

The DMA-BUF op can be invoked when a process that allocated a buffer
relinquishes its ownership and passes it over to another process.

Signed-off-by: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/dma-buf/heaps/system_heap.c | 43 +++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index adfdc8c576f2..70f5b98f1157 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -307,6 +307,48 @@ static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
 	kfree(buffer);
 }
 
+#ifdef CONFIG_CGROUP_GPU
+static int system_heap_dma_buf_charge(struct dma_buf *dmabuf, struct gpucg *gpucg)
+{
+	struct gpucg *current_gpucg;
+	struct gpucg_device *gpucg_dev;
+	struct system_heap_buffer *buffer = dmabuf->priv;
+	size_t len = buffer->len;
+	int ret = 0;
+
+	/*
+	 * Check that the process requesting the transfer is the same as the one
+	 * to whom the buffer is currently charged to.
+	 */
+	current_gpucg = gpucg_get(current);
+	if (current_gpucg != buffer->gpucg)
+		ret = -EPERM;
+
+	gpucg_put(current_gpucg);
+	if (ret)
+		return ret;
+
+	gpucg_dev = dma_heap_get_gpucg_dev(buffer->heap);
+
+	ret = gpucg_try_charge(gpucg, gpucg_dev, len);
+	if (ret)
+		return ret;
+
+	/* uncharge the buffer from the cgroup its currently charged to. */
+	gpucg_uncharge(buffer->gpucg, gpucg_dev, buffer->len);
+	gpucg_put(buffer->gpucg);
+
+	buffer->gpucg = gpucg;
+
+	return 0;
+}
+#else
+static int system_heap_dma_buf_charge(struct dma_buf *dmabuf, struct gpucg *gpucg)
+{
+	return 0;
+}
+#endif
+
 static const struct dma_buf_ops system_heap_buf_ops = {
 	.attach = system_heap_attach,
 	.detach = system_heap_detach,
@@ -318,6 +360,7 @@ static const struct dma_buf_ops system_heap_buf_ops = {
 	.vmap = system_heap_vmap,
 	.vunmap = system_heap_vunmap,
 	.release = system_heap_dma_buf_release,
+	.charge_to_cgroup = system_heap_dma_buf_charge,
 };
 
 static struct page *alloc_largest_available(unsigned long size,
-- 
2.34.1.703.g22d0c6ccf7-goog

