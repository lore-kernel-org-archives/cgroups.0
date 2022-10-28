From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH RESEND cgroup/for-6.1-fixes] cgroup: Implement
 DEBUG_CGROUP_REF
Date: Fri, 28 Oct 2022 11:15:40 -1000
Message-ID: <Y1xGfJGIDIMKrMa7@slm.duckdns.org>
References: <Y1w9EKH/CZhNGLJj@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=so5KjIAi+UDspG5gHdkovGWg4PfI5tqTcbEYdk2iMM4=;
        b=LTx560iGkIhRcFQUJREcKDJSLR6oNZGviD0v7JewFvV8SM/4liM3fs1HQI4LaPBIXi
         MVtyOUEowfyJiIEX+El7dFUkqSPUxCA/vKR0ZIVzhhQX8zqmDw8nqR79wT9XP4ppCd61
         91Xuv5C/by7BlIk7/PD+qoP1TsCaFYwOOaYy1VinUgRsEvmD7glqilIZ76xiquWyFzTt
         yjf9epFTBsADYbKNCv2ObmK8yJFuDa0cv46h2m2X7j4bsKkg/Eic6pJel3k48v+z2my3
         bWQmHiHPDtAx6SF6pAhDfthEzkDV6Jg+bzcvzHSUQwoqb1ZXCirw1NqwbNMp2I0C8/yt
         +72w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y1w9EKH/CZhNGLJj-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: kernel-team-M8Ki61LpUEw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From 6ab428604f724cf217a47b7d3f3353aab815b40e Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Fri, 28 Oct 2022 10:45:44 -1000
Subject: [PATCH] cgroup: Implement DEBUG_CGROUP_REF

It's really difficult to debug when cgroup or css refs leak. Let's add a
debug option to force the refcnt function to not be inlined so that they can
be kprobed for debugging.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Oops, forgot the cgroups ML. Resending. Patch is applied to
cgroup/for-6.1-fixes.

Thanks.

 include/linux/cgroup.h        | 97 +++++------------------------------
 include/linux/cgroup_refcnt.h | 90 ++++++++++++++++++++++++++++++++
 kernel/cgroup/cgroup.c        |  5 ++
 lib/Kconfig.debug             | 10 ++++
 4 files changed, 117 insertions(+), 85 deletions(-)
 create mode 100644 include/linux/cgroup_refcnt.h

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a88de5bdeaa9..5c9c07a44706 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -309,71 +309,23 @@ void css_task_iter_end(struct css_task_iter *it);
  * Inline functions.
  */
 
+#ifdef CONFIG_DEBUG_CGROUP_REF
+void css_get(struct cgroup_subsys_state *css);
+void css_get_many(struct cgroup_subsys_state *css, unsigned int n);
+bool css_tryget(struct cgroup_subsys_state *css);
+bool css_tryget_online(struct cgroup_subsys_state *css);
+void css_put(struct cgroup_subsys_state *css);
+void css_put_many(struct cgroup_subsys_state *css, unsigned int n);
+#else
+#define CGROUP_REF_FN_ATTRS	static inline
+#include <linux/cgroup_refcnt.h>
+#endif
+
 static inline u64 cgroup_id(const struct cgroup *cgrp)
 {
 	return cgrp->kn->id;
 }
 
-/**
- * css_get - obtain a reference on the specified css
- * @css: target css
- *
- * The caller must already have a reference.
- */
-static inline void css_get(struct cgroup_subsys_state *css)
-{
-	if (!(css->flags & CSS_NO_REF))
-		percpu_ref_get(&css->refcnt);
-}
-
-/**
- * css_get_many - obtain references on the specified css
- * @css: target css
- * @n: number of references to get
- *
- * The caller must already have a reference.
- */
-static inline void css_get_many(struct cgroup_subsys_state *css, unsigned int n)
-{
-	if (!(css->flags & CSS_NO_REF))
-		percpu_ref_get_many(&css->refcnt, n);
-}
-
-/**
- * css_tryget - try to obtain a reference on the specified css
- * @css: target css
- *
- * Obtain a reference on @css unless it already has reached zero and is
- * being released.  This function doesn't care whether @css is on or
- * offline.  The caller naturally needs to ensure that @css is accessible
- * but doesn't have to be holding a reference on it - IOW, RCU protected
- * access is good enough for this function.  Returns %true if a reference
- * count was successfully obtained; %false otherwise.
- */
-static inline bool css_tryget(struct cgroup_subsys_state *css)
-{
-	if (!(css->flags & CSS_NO_REF))
-		return percpu_ref_tryget(&css->refcnt);
-	return true;
-}
-
-/**
- * css_tryget_online - try to obtain a reference on the specified css if online
- * @css: target css
- *
- * Obtain a reference on @css if it's online.  The caller naturally needs
- * to ensure that @css is accessible but doesn't have to be holding a
- * reference on it - IOW, RCU protected access is good enough for this
- * function.  Returns %true if a reference count was successfully obtained;
- * %false otherwise.
- */
-static inline bool css_tryget_online(struct cgroup_subsys_state *css)
-{
-	if (!(css->flags & CSS_NO_REF))
-		return percpu_ref_tryget_live(&css->refcnt);
-	return true;
-}
-
 /**
  * css_is_dying - test whether the specified css is dying
  * @css: target css
@@ -394,31 +346,6 @@ static inline bool css_is_dying(struct cgroup_subsys_state *css)
 	return !(css->flags & CSS_NO_REF) && percpu_ref_is_dying(&css->refcnt);
 }
 
-/**
- * css_put - put a css reference
- * @css: target css
- *
- * Put a reference obtained via css_get() and css_tryget_online().
- */
-static inline void css_put(struct cgroup_subsys_state *css)
-{
-	if (!(css->flags & CSS_NO_REF))
-		percpu_ref_put(&css->refcnt);
-}
-
-/**
- * css_put_many - put css references
- * @css: target css
- * @n: number of references to put
- *
- * Put references obtained via css_get() and css_tryget_online().
- */
-static inline void css_put_many(struct cgroup_subsys_state *css, unsigned int n)
-{
-	if (!(css->flags & CSS_NO_REF))
-		percpu_ref_put_many(&css->refcnt, n);
-}
-
 static inline void cgroup_get(struct cgroup *cgrp)
 {
 	css_get(&cgrp->self);
diff --git a/include/linux/cgroup_refcnt.h b/include/linux/cgroup_refcnt.h
new file mode 100644
index 000000000000..1aa89295dac0
--- /dev/null
+++ b/include/linux/cgroup_refcnt.h
@@ -0,0 +1,90 @@
+/**
+ * css_get - obtain a reference on the specified css
+ * @css: target css
+ *
+ * The caller must already have a reference.
+ */
+CGROUP_REF_FN_ATTRS
+void css_get(struct cgroup_subsys_state *css)
+{
+	if (!(css->flags & CSS_NO_REF))
+		percpu_ref_get(&css->refcnt);
+}
+
+/**
+ * css_get_many - obtain references on the specified css
+ * @css: target css
+ * @n: number of references to get
+ *
+ * The caller must already have a reference.
+ */
+CGROUP_REF_FN_ATTRS
+void css_get_many(struct cgroup_subsys_state *css, unsigned int n)
+{
+	if (!(css->flags & CSS_NO_REF))
+		percpu_ref_get_many(&css->refcnt, n);
+}
+
+/**
+ * css_tryget - try to obtain a reference on the specified css
+ * @css: target css
+ *
+ * Obtain a reference on @css unless it already has reached zero and is
+ * being released.  This function doesn't care whether @css is on or
+ * offline.  The caller naturally needs to ensure that @css is accessible
+ * but doesn't have to be holding a reference on it - IOW, RCU protected
+ * access is good enough for this function.  Returns %true if a reference
+ * count was successfully obtained; %false otherwise.
+ */
+CGROUP_REF_FN_ATTRS
+bool css_tryget(struct cgroup_subsys_state *css)
+{
+	if (!(css->flags & CSS_NO_REF))
+		return percpu_ref_tryget(&css->refcnt);
+	return true;
+}
+
+/**
+ * css_tryget_online - try to obtain a reference on the specified css if online
+ * @css: target css
+ *
+ * Obtain a reference on @css if it's online.  The caller naturally needs
+ * to ensure that @css is accessible but doesn't have to be holding a
+ * reference on it - IOW, RCU protected access is good enough for this
+ * function.  Returns %true if a reference count was successfully obtained;
+ * %false otherwise.
+ */
+CGROUP_REF_FN_ATTRS
+bool css_tryget_online(struct cgroup_subsys_state *css)
+{
+	if (!(css->flags & CSS_NO_REF))
+		return percpu_ref_tryget_live(&css->refcnt);
+	return true;
+}
+
+/**
+ * css_put - put a css reference
+ * @css: target css
+ *
+ * Put a reference obtained via css_get() and css_tryget_online().
+ */
+CGROUP_REF_FN_ATTRS
+void css_put(struct cgroup_subsys_state *css)
+{
+	if (!(css->flags & CSS_NO_REF))
+		percpu_ref_put(&css->refcnt);
+}
+
+/**
+ * css_put_many - put css references
+ * @css: target css
+ * @n: number of references to put
+ *
+ * Put references obtained via css_get() and css_tryget_online().
+ */
+CGROUP_REF_FN_ATTRS
+void css_put_many(struct cgroup_subsys_state *css, unsigned int n)
+{
+	if (!(css->flags & CSS_NO_REF))
+		percpu_ref_put_many(&css->refcnt, n);
+}
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d922773fa90b..f786c4c973a0 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -248,6 +248,11 @@ static int cgroup_addrm_files(struct cgroup_subsys_state *css,
 			      struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
 
+#ifdef CONFIG_DEBUG_CGROUP_REF
+#define CGROUP_REF_FN_ATTRS	noinline
+#include <linux/cgroup_refcnt.h>
+#endif
+
 /**
  * cgroup_ssid_enabled - cgroup subsys enabled test by subsys ID
  * @ssid: subsys ID of interest
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3761118d1879..b620a340d7df 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1701,6 +1701,16 @@ config LATENCYTOP
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
 
+config DEBUG_CGROUP_REF
+	bool "Disable inlining of cgroup css reference count functions"
+	depends on DEBUG_KERNEL
+	depends on CGROUPS
+	depends on KPROBES
+	default n
+	help
+	  Force cgroup css reference count functions to not be inlined so
+	  that they can be kprobed for debugging.
+
 source "kernel/trace/Kconfig"
 
 config PROVIDE_OHCI1394_DMA_INIT
-- 
2.38.0

