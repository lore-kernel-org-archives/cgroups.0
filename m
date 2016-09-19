From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: [PATCH v1] cgroup,bpf: Add access check for cgroup_get_from_fd()
Date: Tue, 20 Sep 2016 00:49:13 +0200
Message-ID: <20160919224913.24808-1-mic@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Add security access check for cgroup backed FD. The "cgroup.procs" file
of the corresponding cgroup should be readable to identify the cgroup,
and writable to prove that the current process can manage this cgroup
(e.g. through delegation). This is similar to the check done by
cgroup_procs_write_permission().

Fixes: 4ed8ec521ed5 ("cgroup: bpf: Add BPF_MAP_TYPE_CGROUP_ARRAY")
Signed-off-by: Mickaël Salaün <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Cc: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h |  2 +-
 kernel/bpf/arraymap.c  |  2 +-
 kernel/bpf/syscall.c   |  1 +
 kernel/cgroup.c        | 34 +++++++++++++++++++++++++++-------
 4 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c4688742ddc4..5767d471e292 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -87,7 +87,7 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 						       struct cgroup_subsys *ss);
 
 struct cgroup *cgroup_get_from_path(const char *path);
-struct cgroup *cgroup_get_from_fd(int fd);
+struct cgroup *cgroup_get_from_fd(int fd, int access_mask);
 
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index a2ac051c342f..3d97c70134a0 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -543,7 +543,7 @@ static void *cgroup_fd_array_get_ptr(struct bpf_map *map,
 				     struct file *map_file /* not used */,
 				     int fd)
 {
-	return cgroup_get_from_fd(fd);
+	return cgroup_get_from_fd(fd, MAY_READ);
 }
 
 static void cgroup_fd_array_put_ptr(void *ptr)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 228f962447a5..cc7270eadcf7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -17,6 +17,7 @@
 #include <linux/license.h>
 #include <linux/filter.h>
 #include <linux/version.h>
+#include <linux/fs.h>
 
 DEFINE_PER_CPU(int, bpf_prog_active);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b0d727d26fc7..e02e0a531be9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -6236,34 +6236,54 @@ EXPORT_SYMBOL_GPL(cgroup_get_from_path);
 /**
  * cgroup_get_from_fd - get a cgroup pointer from a fd
  * @fd: fd obtained by open(cgroup2_dir)
+ * @access_mask: contains the permission mask
  *
  * Find the cgroup from a fd which should be obtained
  * by opening a cgroup directory.  Returns a pointer to the
  * cgroup on success. ERR_PTR is returned if the cgroup
- * cannot be found.
+ * cannot be found or its access is denied.
  */
-struct cgroup *cgroup_get_from_fd(int fd)
+struct cgroup *cgroup_get_from_fd(int fd, int access_mask)
 {
 	struct cgroup_subsys_state *css;
 	struct cgroup *cgrp;
 	struct file *f;
+	struct inode *inode;
+	int ret;
 
 	f = fget_raw(fd);
 	if (!f)
 		return ERR_PTR(-EBADF);
 
 	css = css_tryget_online_from_dir(f->f_path.dentry, NULL);
-	fput(f);
-	if (IS_ERR(css))
-		return ERR_CAST(css);
+	if (IS_ERR(css)) {
+		ret = PTR_ERR(css);
+		goto put_f;
+	}
 
 	cgrp = css->cgroup;
 	if (!cgroup_on_dfl(cgrp)) {
-		cgroup_put(cgrp);
-		return ERR_PTR(-EBADF);
+		ret = -EBADF;
+		goto put_cgrp;
+	}
+
+	ret = -ENOMEM;
+	inode = kernfs_get_inode(f->f_path.dentry->d_sb, cgrp->procs_file.kn);
+	if (inode) {
+		ret = inode_permission(inode, access_mask);
+		iput(inode);
 	}
+	if (ret)
+		goto put_cgrp;
 
+	fput(f);
 	return cgrp;
+
+put_cgrp:
+	cgroup_put(cgrp);
+put_f:
+	fput(f);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_fd);
 
-- 
2.9.3
