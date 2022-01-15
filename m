From: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC 6/6] android: binder: Add a buffer flag to relinquish ownership
 of fds
Date: Fri, 14 Jan 2022 17:06:04 -0800
Message-ID: <20220115010622.3185921-7-hridya__10502.2349905752$1642208956$gmane$org@google.com>
References: <20220115010622.3185921-1-hridya@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kkjQvBHUpUsPJOcuRnb4FbpqpDLYZFNC/PGNH3Zg5WU=;
        b=B7HrMalKbOrQ0jLo+t2k5LKQyXsYTrKPSnoCQbJTFt3xXAdNgf+Y3bG0OwuuV3conm
         9YDTffSi81yddsv2BoH3Yepu0Qf4t9Yufib51okExGf5c00BzhktLBE/1fgctRjU17A0
         FE5Q2yG/2zZsbcQO5KIgRMuIdtuJb3ntKNdMvUrJDIlln1wNgH3uN1Xs3Tq4HUuo2nQw
         vX/4a2fLq5zN8JuJ/ROXboM4iqrNUfkxyQzzeG4K6rLmd0dL8lZlsn2U8cU340A6r7rt
         CrzHH2yHQihIsNpJ9nYxK0RZUUVox7TiNHvKS/20HXPEnTeOhUMt/SoHjy/YrqoHfDGB
         975A==
In-Reply-To: <20220115010622.3185921-1-hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <Brian.Starkey@arm>
Cc: Kenny.Ho-5C7GfCeVMHo@public.gmane.org, daniels-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

This patch introduces a buffer flag BINDER_BUFFER_FLAG_SENDER_NO_NEED
that a process sending an fd array to another process over binder IPC
can set to relinquish ownership of the fds being sent for memory
accounting purposes. If the flag is found to be set during the fd array
translation and the fd is for a DMA-BUF, the buffer is uncharged from
the sender's cgroup and charged to the receiving process's cgroup
instead.

It is upto the sending process to ensure that it closes the fds
regardless of whether the transfer failed or succeeded.

Most graphics shared memory allocations in Android are done by the
graphics allocator HAL process. On requests from clients, the HAL process
allocates memory and sends the fds to the clients over binder IPC.
The graphics allocator HAL will not retain any references to the
buffers. When the HAL sets the BINDER_BUFFER_FLAG_SENDER_NO_NEED for fd
arrays holding DMA-BUF fds, the gpu cgroup controller will be able to
correctly charge the buffers to the client processes instead of the
graphics allocator HAL.

Signed-off-by: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/android/binder.c            | 32 +++++++++++++++++++++++++++++
 include/uapi/linux/android/binder.h |  1 +
 2 files changed, 33 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 5497797ab258..83082fd1ab6a 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -42,6 +42,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/dma-buf.h>
 #include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/freezer.h>
@@ -2482,8 +2483,11 @@ static int binder_translate_fd_array(struct list_head *pf_head,
 {
 	binder_size_t fdi, fd_buf_size;
 	binder_size_t fda_offset;
+	bool transfer_gpu_charge = false;
 	const void __user *sender_ufda_base;
 	struct binder_proc *proc = thread->proc;
+	struct binder_proc *target_proc = t->to_proc;
+
 	int ret;
 
 	fd_buf_size = sizeof(u32) * fda->num_fds;
@@ -2520,8 +2524,15 @@ static int binder_translate_fd_array(struct list_head *pf_head,
 	if (ret)
 		return ret;
 
+	if (IS_ENABLED(CONFIG_CGROUP_GPU) &&
+	    parent->flags & BINDER_BUFFER_FLAG_SENDER_NO_NEED)
+		transfer_gpu_charge = true;
+
 	for (fdi = 0; fdi < fda->num_fds; fdi++) {
 		u32 fd;
+		struct dma_buf *dmabuf;
+		struct gpucg *gpucg;
+
 		binder_size_t offset = fda_offset + fdi * sizeof(fd);
 		binder_size_t sender_uoffset = fdi * sizeof(fd);
 
@@ -2531,6 +2542,27 @@ static int binder_translate_fd_array(struct list_head *pf_head,
 						  in_reply_to);
 		if (ret)
 			return ret > 0 ? -EINVAL : ret;
+
+		if (!transfer_gpu_charge)
+			continue;
+
+		dmabuf = dma_buf_get(fd);
+		if (IS_ERR(dmabuf))
+			continue;
+
+		if (dmabuf->ops->charge_to_cgroup) {
+			gpucg = gpucg_get(target_proc->tsk);
+			ret = dmabuf->ops->charge_to_cgroup(dmabuf, gpucg);
+			if (ret) {
+				pr_warn("%d:%d Unable to transfer DMA-BUF fd charge to %d",
+					proc->pid, thread->pid, target_proc->pid);
+				gpucg_put(gpucg);
+			}
+		} else {
+			pr_warn("%d:%d DMA-BUF exporter %s is not configured correctly for GPU cgroup memory accounting",
+				proc->pid, thread->pid, dmabuf->exp_name);
+		}
+		dma_buf_put(dmabuf);
 	}
 	return 0;
 }
diff --git a/include/uapi/linux/android/binder.h b/include/uapi/linux/android/binder.h
index ad619623571e..c85f0014c341 100644
--- a/include/uapi/linux/android/binder.h
+++ b/include/uapi/linux/android/binder.h
@@ -137,6 +137,7 @@ struct binder_buffer_object {
 
 enum {
 	BINDER_BUFFER_FLAG_HAS_PARENT = 0x01,
+	BINDER_BUFFER_FLAG_SENDER_NO_NEED = 0x02,
 };
 
 /* struct binder_fd_array_object - object describing an array of fds in a buffer
-- 
2.34.1.703.g22d0c6ccf7-goog

