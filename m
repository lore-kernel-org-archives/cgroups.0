From: Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH net-next v2 1/4] cgroup: Add cgroup_get_from_fd
Date: Wed, 22 Jun 2016 14:17:29 -0700
Message-ID: <1466630252-3822277-2-git-send-email-kafai@fb.com>
References: <1466630252-3822277-1-git-send-email-kafai@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=from : to : cc : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=xynnN6X4WHxNsSs6H8eXqbxilK10rA2s1IkB0s+2kds=;
 b=o+TwO8CDU9aeS+Y2SrLdAYlSp1aFfYorqfRVQi6znl4y6XlTyZqGX159RPFzbFGGvk+6
 177FAuY8dHHeOiOBbfQDAtZNIREK9wuUyolDsw5pya/q2Cf2LlALJiTzDAjnFWO0g3ke
 IwriRzN+UrDbSgtqtd0+VSwsAfW1Si4BLO4= 
In-Reply-To: <1466630252-3822277-1-git-send-email-kafai@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Alexei Starovoitov <ast@fb.com>, Daniel Borkmann <daniel@iogearbox.net>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

Add a helper function to get a cgroup2 from a fd.  It will be
stored in a bpf array (BPF_MAP_TYPE_CGROUP_ARRAY) which will
be introduced in the later patch.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Cc: Alexei Starovoitov <ast@fb.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a20320c..984f73b 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -87,6 +87,7 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 						       struct cgroup_subsys *ss);
 
 struct cgroup *cgroup_get_from_path(const char *path);
+struct cgroup *cgroup_get_from_fd(int fd);
 
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 86cb5c6..14617968 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -62,6 +62,7 @@
 #include <linux/proc_ns.h>
 #include <linux/nsproxy.h>
 #include <linux/proc_ns.h>
+#include <linux/file.h>
 #include <net/sock.h>
 
 /*
@@ -6205,6 +6206,40 @@ struct cgroup *cgroup_get_from_path(const char *path)
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_path);
 
+/**
+ * cgroup_get_from_fd - get a cgroup pointer from a fd
+ * @fd: fd obtained by open(cgroup2_dir)
+ *
+ * Find the cgroup from a fd which should be obtained
+ * by opening a cgroup directory.  Returns a pointer to the
+ * cgroup on success. ERR_PTR is returned if the cgroup
+ * cannot be found.
+ */
+struct cgroup *cgroup_get_from_fd(int fd)
+{
+	struct cgroup_subsys_state *css;
+	struct cgroup *cgrp;
+	struct file *f;
+
+	f = fget_raw(fd);
+	if (!f)
+		return ERR_PTR(-EBADF);
+
+	css = css_tryget_online_from_dir(f->f_path.dentry, NULL);
+	fput(f);
+	if (IS_ERR(css))
+		return ERR_CAST(css);
+
+	cgrp = css->cgroup;
+	if (!cgroup_on_dfl(cgrp)) {
+		cgroup_put(cgrp);
+		return ERR_PTR(-EBADF);
+	}
+
+	return cgrp;
+}
+EXPORT_SYMBOL_GPL(cgroup_get_from_fd);
+
 /*
  * sock->sk_cgrp_data handling.  For more info, see sock_cgroup_data
  * definition in cgroup-defs.h.
-- 
2.5.1

