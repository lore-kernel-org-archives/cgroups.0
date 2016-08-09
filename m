From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] kernfs: make kernfs_path*() behave in the style of strlcpy()
Date: Tue,  9 Aug 2016 01:23:22 -0400
Message-ID: <1470720204-4605-3-git-send-email-tj@kernel.org>
References: <1470720204-4605-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hd8YhoDsKwLIfYL23sCs+jTa+8cF3Y/g5Ws9CaMSmsA=;
        b=QZfzBNeaoYO3/JqR2M1Yg5es/9F0XLHqrTN1SQwZGAUX29dScok1rHsKaj36c/6HEt
         wDc9rr6aqhQJKwXoJcb/ubjmIF1RKbFGK1JxjSaj5U6KhF+iTzMNfCrwPWYScAgQn3YI
         15xLJs8NBxIwFrPkvceQ0H/CryP3aYnsiazChOaqmUH2ROTxlURzmOglT/pO1GSuYdrE
         vvzTavqC88FGHeW+tRPReQv1gOGZsTLqGwt5i2zccJqXryllRuYLAiQmbKILJdmSVcsY
         TlVhe2KnvotT578fZHleQtYhzJUjYKKQzzl/tGUlUJZc1KlQ1WdYAeBDmIFSSd96Fnbr
         KOKQ==
In-Reply-To: <1470720204-4605-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org, serge.hallyn@ubuntu.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, Tejun Heo <tj@kernel.org>

kernfs_path*() functions always return the length of the full path but
the path content is undefined if the length is larger than the
provided buffer.  This makes its behavior different from strlcpy() and
requires error handling in all its users even when they don't care
about truncation.  In addition, the implementation can actully be
simplified by making it behave properly in strlcpy() style.

* Update kernfs_path_from_node_locked() to always fill up the buffer
  with path.  If the buffer is not large enough, the output is
  truncated and terminated.

* kernfs_path() no longer needs error handling.  Make it a simple
  inline wrapper around kernfs_path_from_node().

* sysfs_warn_dup()'s use of kernfs_path() doesn't need error handling.
  Updated accordingly.

* cgroup_path()'s use of kernfs_path() updated to retain the old
  behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/dir.c        | 61 ++++++++++++++------------------------------------
 fs/sysfs/dir.c         |  6 ++---
 include/linux/cgroup.h |  7 +++++-
 include/linux/kernfs.h | 21 ++++++++++++-----
 4 files changed, 42 insertions(+), 53 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index e57174d..09242aa 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -110,8 +110,9 @@ static struct kernfs_node *kernfs_common_ancestor(struct kernfs_node *a,
  * kn_to:   /n1/n2/n3         [depth=3]
  * result:  /../..
  *
- * return value: length of the string.  If greater than buflen,
- * then contents of buf are undefined.  On error, -1 is returned.
+ * Returns the length of the full path.  If the full length is equal to or
+ * greater than @buflen, @buf contains the truncated path with the trailing
+ * '\0'.  On error, -errno is returned.
  */
 static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 					struct kernfs_node *kn_from,
@@ -119,9 +120,8 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 {
 	struct kernfs_node *kn, *common;
 	const char parent_str[] = "/..";
-	size_t depth_from, depth_to, len = 0, nlen = 0;
-	char *p;
-	int i;
+	size_t depth_from, depth_to, len = 0;
+	int i, j;
 
 	if (!kn_from)
 		kn_from = kernfs_root(kn_to)->kn;
@@ -131,7 +131,7 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 
 	common = kernfs_common_ancestor(kn_from, kn_to);
 	if (WARN_ON(!common))
-		return -1;
+		return -EINVAL;
 
 	depth_to = kernfs_depth(common, kn_to);
 	depth_from = kernfs_depth(common, kn_from);
@@ -144,22 +144,16 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 			       len < buflen ? buflen - len : 0);
 
 	/* Calculate how many bytes we need for the rest */
-	for (kn = kn_to; kn != common; kn = kn->parent)
-		nlen += strlen(kn->name) + 1;
-
-	if (len + nlen >= buflen)
-		return len + nlen;
-
-	p = buf + len + nlen;
-	*p = '\0';
-	for (kn = kn_to; kn != common; kn = kn->parent) {
-		size_t tmp = strlen(kn->name);
-		p -= tmp;
-		memcpy(p, kn->name, tmp);
-		*(--p) = '/';
+	for (i = depth_to - 1; i >= 0; i--) {
+		for (kn = kn_to, j = 0; j < i; j++)
+			kn = kn->parent;
+		len += strlcpy(buf + len, "/",
+			       len < buflen ? buflen - len : 0);
+		len += strlcpy(buf + len, kn->name,
+			       len < buflen ? buflen - len : 0);
 	}
 
-	return len + nlen;
+	return len;
 }
 
 /**
@@ -220,8 +214,9 @@ size_t kernfs_path_len(struct kernfs_node *kn)
  * path (which includes '..'s) as needed to reach from @from to @to is
  * returned.
  *
- * If @buf isn't long enough, the return value will be greater than @buflen
- * and @buf contents are undefined.
+ * Returns the length of the full path.  If the full length is equal to or
+ * greater than @buflen, @buf contains the truncated path with the trailing
+ * '\0'.  On error, -errno is returned.
  */
 int kernfs_path_from_node(struct kernfs_node *to, struct kernfs_node *from,
 			  char *buf, size_t buflen)
@@ -237,28 +232,6 @@ int kernfs_path_from_node(struct kernfs_node *to, struct kernfs_node *from,
 EXPORT_SYMBOL_GPL(kernfs_path_from_node);
 
 /**
- * kernfs_path - build full path of a given node
- * @kn: kernfs_node of interest
- * @buf: buffer to copy @kn's name into
- * @buflen: size of @buf
- *
- * Builds and returns the full path of @kn in @buf of @buflen bytes.  The
- * path is built from the end of @buf so the returned pointer usually
- * doesn't match @buf.  If @buf isn't long enough, @buf is nul terminated
- * and %NULL is returned.
- */
-char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
-{
-	int ret;
-
-	ret = kernfs_path_from_node(kn, NULL, buf, buflen);
-	if (ret < 0 || ret >= buflen)
-		return NULL;
-	return buf;
-}
-EXPORT_SYMBOL_GPL(kernfs_path);
-
-/**
  * pr_cont_kernfs_name - pr_cont name of a kernfs_node
  * @kn: kernfs_node of interest
  *
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 94374e4..2b67bda 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -21,14 +21,14 @@ DEFINE_SPINLOCK(sysfs_symlink_target_lock);
 
 void sysfs_warn_dup(struct kernfs_node *parent, const char *name)
 {
-	char *buf, *path = NULL;
+	char *buf;
 
 	buf = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (buf)
-		path = kernfs_path(parent, buf, PATH_MAX);
+		kernfs_path(parent, buf, PATH_MAX);
 
 	WARN(1, KERN_WARNING "sysfs: cannot create duplicate filename '%s/%s'\n",
-	     path, name);
+	     buf, name);
 
 	kfree(buf);
 }
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 984f73b..5a9abde 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -541,7 +541,12 @@ static inline int cgroup_name(struct cgroup *cgrp, char *buf, size_t buflen)
 static inline char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
 					      size_t buflen)
 {
-	return kernfs_path(cgrp->kn, buf, buflen);
+	int ret;
+
+	ret = kernfs_path(cgrp->kn, buf, buflen);
+	if (ret < 0 || ret >= buflen)
+		return NULL;
+	return buf;
 }
 
 static inline void pr_cont_cgroup_name(struct cgroup *cgrp)
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 325954f..64358d2 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -272,7 +272,6 @@ int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen);
 size_t kernfs_path_len(struct kernfs_node *kn);
 int kernfs_path_from_node(struct kernfs_node *root_kn, struct kernfs_node *kn,
 			  char *buf, size_t buflen);
-char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen);
 void pr_cont_kernfs_name(struct kernfs_node *kn);
 void pr_cont_kernfs_path(struct kernfs_node *kn);
 struct kernfs_node *kernfs_get_parent(struct kernfs_node *kn);
@@ -349,10 +348,6 @@ static inline int kernfs_path_from_node(struct kernfs_node *root_kn,
 					char *buf, size_t buflen);
 { return -ENOSYS; }
 
-static inline char *kernfs_path(struct kernfs_node *kn, char *buf,
-				size_t buflen)
-{ return NULL; }
-
 static inline void pr_cont_kernfs_name(struct kernfs_node *kn) { }
 static inline void pr_cont_kernfs_path(struct kernfs_node *kn) { }
 
@@ -441,6 +436,22 @@ static inline void kernfs_init(void) { }
 
 #endif	/* CONFIG_KERNFS */
 
+/**
+ * kernfs_path - build full path of a given node
+ * @kn: kernfs_node of interest
+ * @buf: buffer to copy @kn's name into
+ * @buflen: size of @buf
+ *
+ * Builds and returns the full path of @kn in @buf of @buflen bytes.  The
+ * path is built from the end of @buf so the returned pointer usually
+ * doesn't match @buf.  If @buf isn't long enough, @buf is nul terminated
+ * and %NULL is returned.
+ */
+static inline int kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
+{
+	return kernfs_path_from_node(kn, NULL, buf, buflen);
+}
+
 static inline struct kernfs_node *
 kernfs_find_and_get(struct kernfs_node *kn, const char *name)
 {
-- 
2.7.4

