From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] percpu-ref: introduce percpu_ref_alive()
Date: Thu, 12 Jun 2014 14:31:47 +0800
Message-ID: <53994953.4060703@huawei.com>
References: <53994943.60703@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53994943.60703-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

This is used to check if the percpu_ref has been killed.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/percpu-refcount.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index dba35c4..1d5f2b3 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -96,6 +96,17 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
 #define REF_STATUS(count)	(((unsigned long) count) & PCPU_STATUS_MASK)
 
 /**
+ * percpu_ref_alive - check if the ref has been killed
+ * @ref: percpu_ref to check
+ *
+ * Return true if percpu_ref_kill() has been called to drop the initial ref.
+ */
+static inline bool percpu_ref_alive(struct percpu_ref *ref)
+{
+	return !(REF_STATUS(ref->pcpu_count) == PCPU_REF_DEAD);
+}
+
+/**
  * percpu_ref_get - increment a percpu refcount
  * @ref: percpu_ref to get
  *
-- 
1.8.0.2
