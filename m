From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 2/3] cgroup: add cgroup_all_get_from_[fd/file]()
Date: Mon, 10 Oct 2022 23:58:44 +0000
Message-ID: <20221010235845.3379019-3-yosryahmed@google.com>
References: <20221010235845.3379019-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PtNrUd9EMj0I502bSB6YBXD5TgTiX1+1yTi9Pa6f94M=;
        b=OOeBo8F1N0lTKOQnJQ6gjRzmWKqHpT7+Pw3vXDR73IrU1E4xpR1RXW0AyAeAg98DF2
         0VRGJGzEExjWy4Eg3AmeCRoU3WPGIEEXBA0X7oh2O/sJbrOpwxwlzWb5LuTekNFwBvIG
         agxHCGqzT5FvWIUf5V5ApkseZkzZBxDzx9jXXKTyJYIqwOdRA4tN8+jfet9kWaF4NfCX
         FLMYscR4F9y/dAqOnhNfzFJWY/dHzkzWWoWcvxMjpnLX7GuAKSt3YHkJcQumbIWwOiY7
         eBd79d0IbBy9hPp0PiaMdgnTCOUqu7e/v+fyukJ3ulE+P7KGO7pFFXtwydwkWvfJ+gZQ
         +baQ==
In-Reply-To: <20221010235845.3379019-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add cgroup_all_get_from_fd() and cgroup_all_get_from_file() that
support both cgroup1 and cgroup2.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup/cgroup.c | 50 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 398f0bce7c21..cd847f4f47ed 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -106,6 +106,7 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 
 struct cgroup *cgroup_get_from_path(const char *path);
 struct cgroup *cgroup_get_from_fd(int fd);
+struct cgroup *cgroup_all_get_from_fd(int fd);
 
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 72e97422e9d9..c3bd6f17246a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6208,16 +6208,36 @@ void cgroup_fork(struct task_struct *child)
 	INIT_LIST_HEAD(&child->cg_list);
 }
 
-static struct cgroup *cgroup_get_from_file(struct file *f)
+/**
+ * cgroup_all_get_from_file - get a cgroup pointer from a file pointer
+ * @f: file corresponding to cgroup_dir
+ *
+ * Find the cgroup from a file pointer associated with a cgroup directory.
+ * Returns a pointer to the cgroup on success. ERR_PTR is returned if the
+ * cgroup cannot be found.
+ */
+static struct cgroup *cgroup_all_get_from_file(struct file *f)
 {
 	struct cgroup_subsys_state *css;
-	struct cgroup *cgrp;
 
 	css = css_tryget_online_from_dir(f->f_path.dentry, NULL);
 	if (IS_ERR(css))
 		return ERR_CAST(css);
 
-	cgrp = css->cgroup;
+	return css->cgroup;
+}
+
+/**
+ * cgroup_get_from_file - same as cgroup_all_get_from_file, but only supports
+ * cgroup2.
+ */
+static struct cgroup *cgroup_get_from_file(struct file *f)
+{
+	struct cgroup *cgrp = cgroup_all_get_from_file(f);
+
+	if (IS_ERR(cgrp))
+		return ERR_CAST(cgrp);
+
 	if (!cgroup_on_dfl(cgrp)) {
 		cgroup_put(cgrp);
 		return ERR_PTR(-EBADF);
@@ -6720,14 +6740,14 @@ EXPORT_SYMBOL_GPL(cgroup_get_from_path);
 
 /**
  * cgroup_get_from_fd - get a cgroup pointer from a fd
- * @fd: fd obtained by open(cgroup2_dir)
+ * @fd: fd obtained by open(cgroup_dir)
  *
  * Find the cgroup from a fd which should be obtained
  * by opening a cgroup directory.  Returns a pointer to the
  * cgroup on success. ERR_PTR is returned if the cgroup
  * cannot be found.
  */
-struct cgroup *cgroup_get_from_fd(int fd)
+struct cgroup *cgroup_all_get_from_fd(int fd)
 {
 	struct cgroup *cgrp;
 	struct file *f;
@@ -6736,10 +6756,28 @@ struct cgroup *cgroup_get_from_fd(int fd)
 	if (!f)
 		return ERR_PTR(-EBADF);
 
-	cgrp = cgroup_get_from_file(f);
+	cgrp = cgroup_all_get_from_file(f);
 	fput(f);
 	return cgrp;
 }
+
+/**
+ * cgroup_get_from_fd - same as cgroup_all_get_from_fd, but only supports
+ * cgroup2.
+ */
+struct cgroup *cgroup_get_from_fd(int fd)
+{
+	struct cgroup *cgrp = cgroup_all_get_from_fd(fd);
+
+	if (IS_ERR(cgrp))
+		return ERR_CAST(cgrp);
+
+	if (!cgroup_on_dfl(cgrp)) {
+		cgroup_put(cgrp);
+		return ERR_PTR(-EBADF);
+	}
+	return cgrp;
+}
 EXPORT_SYMBOL_GPL(cgroup_get_from_fd);
 
 static u64 power_of_ten(int power)
-- 
2.38.0.rc1.362.ged0d419d3c-goog

