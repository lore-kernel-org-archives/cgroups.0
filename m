From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 1/3] misc_cgroup: add support for nofile limit
Date: Thu, 22 Jul 2021 23:20:17 +0800
Message-ID: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dcmUigRFaKaUGLQ8hPJNePWalGpdmF9/PmKs/DMnFfs=;
        b=AvId1PeFmONSOPW86UAvvUln0l2s3+ibt9wUhp3/0CAzqmHEppIRVnUjPGhTvTS5bB
         ksubKtFnhPrJgaSFMOYoJfRP0BLxxz+u9XomRSiOtIG1qyAeB1ItJmGZ+qBNxlpBb7Zo
         kM+qN+GliyXzrSwqfctZznjlNVT/y0uscX1DWG0ePfsp9JS/JAUsJlrKsWIYRjf4UUbT
         8OKuzDUUtxkyS9tT13HrPcjTv2JoPyL3qYNXzjlYvCq5fSrjPjFsg/dxAyR6HJTK9Qx/
         QU7UGYhKi71GRa2VkRCQ0IFXsP3plfzp5uJL0VpvtYMyEoV/Fqpq+xLW7neo8wqN1njD
         v2yQ==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Since the global open files are limited, in order to avoid the
abnormal behavior of some containers from generating too many
files, causing other containers to be unavailable, we need to
limit the open files of some containers.

v2: fix compile error while CONFIG_CGROUP_MISC not set.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 fs/file_table.c             | 28 ++++++++++++++++++++++++++--
 include/linux/fs.h          |  4 +++-
 include/linux/misc_cgroup.h |  1 +
 kernel/cgroup/misc.c        |  1 +
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 45437f8e1003..5957b2de9701 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -29,6 +29,7 @@
 #include <linux/swap.h>
 
 #include <linux/atomic.h>
+#include <linux/misc_cgroup.h>
 
 #include "internal.h"
 
@@ -53,8 +54,16 @@ static void file_free_rcu(struct rcu_head *head)
 static inline void file_free(struct file *f)
 {
 	security_file_free(f);
-	if (!(f->f_mode & FMODE_NOACCOUNT))
+	if (!(f->f_mode & FMODE_NOACCOUNT)) {
+#ifdef CONFIG_CGROUP_MISC
+		struct misc_cg *misc_cg = css_misc(f->f_css);
+
+		misc_cg_uncharge(MISC_CG_RES_NOFILE, misc_cg, 1);
+		put_misc_cg(misc_cg);
+#endif
+
 		percpu_counter_dec(&nr_files);
+	}
 	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
 }
 
@@ -148,8 +157,22 @@ struct file *alloc_empty_file(int flags, const struct cred *cred)
 	}
 
 	f = __alloc_file(flags, cred);
-	if (!IS_ERR(f))
+	if (!IS_ERR(f)) {
+#ifdef CONFIG_CGROUP_MISC
+		struct misc_cg *misc_cg = get_current_misc_cg();
+		int ret;
+
+		ret = misc_cg_try_charge(MISC_CG_RES_NOFILE, misc_cg, 1);
+		if (ret < 0) {
+			file_free(f);
+			put_misc_cg(misc_cg);
+			return ERR_PTR(-ENFILE);
+		}
+		f->f_css = &misc_cg->css;
+#endif
+
 		percpu_counter_inc(&nr_files);
+	}
 
 	return f;
 
@@ -397,4 +420,5 @@ void __init files_maxfiles_init(void)
 	n = ((nr_pages - memreserve) * (PAGE_SIZE / 1024)) / 10;
 
 	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
+	misc_cg_set_capacity(MISC_CG_RES_NOFILE, files_stat.max_files);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fad6663cd1b0..9ef3dd579ed6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -947,7 +947,9 @@ struct file {
 #endif
 	/* needed for tty driver, and maybe others */
 	void			*private_data;
-
+#ifdef CONFIG_CGROUP_MISC
+	struct cgroup_subsys_state *f_css;
+#endif
 #ifdef CONFIG_EPOLL
 	/* Used by fs/eventpoll.c to link all the hooks to this file */
 	struct hlist_head	*f_ep;
diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index da2367e2ac1e..8450a5e66de0 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -18,6 +18,7 @@ enum misc_res_type {
 	/* AMD SEV-ES ASIDs resource */
 	MISC_CG_RES_SEV_ES,
 #endif
+	MISC_CG_RES_NOFILE,
 	MISC_CG_RES_TYPES
 };
 
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index ec02d963cad1..5d51b8eeece6 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -24,6 +24,7 @@ static const char *const misc_res_name[] = {
 	/* AMD SEV-ES ASIDs resource */
 	"sev_es",
 #endif
+	"nofile"
 };
 
 /* Root misc cgroup */
-- 
2.30.0

