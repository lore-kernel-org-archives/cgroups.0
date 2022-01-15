From: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC 4/6] dma-buf: Add DMA-BUF exporter op to charge a DMA-BUF to a cgroup.
Date: Fri, 14 Jan 2022 17:06:02 -0800
Message-ID: <20220115010622.3185921-5-hridya__43129.1486996756$1642208914$gmane$org@google.com>
References: <20220115010622.3185921-1-hridya@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sWrCFDJqqXXVSbGVP8s44HP9fGoTeRrZv/20U3l5a9g=;
        b=HsuhTKzXI1C0Bg5qlXVEUKgy0Y59ylb/5klYriv4XRxp76HIR6zzyRrTkNqoZeAa/+
         b49JcXDqX9e/xJ/SUE/3bVyoaZ0lg1xpEMerwoqfVEOSdzj9xLfLi1s1GhQ+IDW9v6/g
         5GED0tKyYGSjJ2/1/kebwAkX3iCP3oywer4GN/EkL+RsKPE2U2Hk2kgIljMzFb8dnS5Y
         FqX9cDLP+EMxfP4f35RPYTdaQONdRKxIF2yg0spELgieeV12+CV7Uxpttxe+nF4d6tb3
         BSX5dX+1OeDTvZq4IqC6x7NYZPz51nGacX/FtiiRJ2MyzFoQX3zRra2Gfbo1QjE20yf4
         5vjw==
In-Reply-To: <20220115010622.3185921-1-hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <Brian.Sta>
Cc: Kenny.Ho-5C7GfCeVMHo@public.gmane.org, daniels-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

The optional exporter op provides a way for processes to transfer
charge of a buffer to a different process. This is essential for the
cases where a central allocator process does allocations for various
subsystems, hands over the fd to the client who
requested the memory and drops all references to the allocated memory.

Signed-off-by: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/dma-buf.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 7ab50076e7a6..d5e52f81cc6f 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -13,6 +13,7 @@
 #ifndef __DMA_BUF_H__
 #define __DMA_BUF_H__
 
+#include <linux/cgroup_gpu.h>
 #include <linux/dma-buf-map.h>
 #include <linux/file.h>
 #include <linux/err.h>
@@ -285,6 +286,23 @@ struct dma_buf_ops {
 
 	int (*vmap)(struct dma_buf *dmabuf, struct dma_buf_map *map);
 	void (*vunmap)(struct dma_buf *dmabuf, struct dma_buf_map *map);
+
+	/**
+	 * @charge_to_cgroup:
+	 *
+	 * This is called by an exporter to charge a buffer to the specified
+	 * cgroup. The caller must hold a reference to @gpucg obtained via
+	 * gpucg_get(). The DMA-BUF will be uncharged from the cgroup it is
+	 * currently charged to before being charged to @gpucg. The caller must
+	 * belong to the cgroup the buffer is currently charged to.
+	 *
+	 * This callback is optional.
+	 *
+	 * Returns:
+	 *
+	 * 0 on success or negative error code on failure.
+	 */
+	int (*charge_to_cgroup)(struct dma_buf *dmabuf, struct gpucg *gpucg);
 };
 
 /**
-- 
2.34.1.703.g22d0c6ccf7-goog

