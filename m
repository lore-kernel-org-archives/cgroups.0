From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 2/3] misc_cgroup: introduce misc.failcnt for V1
Date: Wed,  8 Sep 2021 13:24:35 +0800
Message-ID: <c4e091c8c0208554b97f751ae80a093f55f19883.1631077837.git.brookxu@tencent.com>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=chwGnJXtYzYfFAb2xocoJoG9ap7jKymOQv0bE0NKq/4=;
        b=UT+9Jq5isRNyTNrE6lq+yYmAhDNeRDmV3DjYgMAyjHhcD3OiHLVBbkNi5UcgN2KDv/
         H11zy3fg5q1Ci9yYB8MwLodUHv+K8CJdSI6trnshnNKTThp8Eo4X5y0S3DvRPtn/vjBd
         bpjnmRCmy/caQFiuIYhWSwKuVfuD2shR5nvKWPy8/DDx3HjdUUa7wk5SXrtvfJsDJUcY
         fumLL5lVzx6JAWfbh+sjGLBkQk8wzTEutStNBSBXDohk4rfwShhyaiTtM8+NYlV4kSHb
         4S/oSyRSV/+5P9oOkkp2wE0sEGktS4Bc1RfM9GT/KRZ9jSXUuWcoTrv7gwxkV/80xTSO
         q+Dg==
In-Reply-To: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

introduce misc.failcnt for cgroup v1 to make it easier for us to
understand the pressure of resources.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/misc_cgroup.h |  3 +++
 kernel/cgroup/misc.c        | 54 +++++++++++++++++++++++++++++++++++--
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index d29f1743fae9..4d630cd3e4bd 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -55,6 +55,9 @@ struct misc_cg {
 	atomic_long_t events_local[MISC_CG_RES_TYPES];
 	struct cgroup_file events_local_file;
 
+	/* misc.failcnt for v1 only */
+	atomic_long_t nr_failed[MISC_CG_RES_TYPES];
+
 	struct misc_res res[MISC_CG_RES_TYPES];
 };
 
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 2a3d14be21e5..d8f99fd58981 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -179,7 +179,8 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
 			atomic_long_inc(&k->events[type]);
 			cgroup_file_notify(&k->events_file);
 		}
-	}
+	} else
+		atomic_long_inc(&i->nr_failed[type]);
 
 	for (j = cg; j != i; j = parent_misc(j))
 		misc_cg_cancel_charge(type, j, amount);
@@ -371,6 +372,29 @@ static int misc_events_local_show(struct seq_file *sf, void *v)
 	return 0;
 }
 
+/**
+ * misc_cg_failcnt_show() - Show the fail count of the misc cgroup.
+ * @sf: Interface file
+ * @v: Arguments passed
+ *
+ * Context: Any context.
+ * Return: 0 to denote successful print.
+ */
+static int misc_cg_failcnt_show(struct seq_file *sf, void *v)
+{
+	int i;
+	unsigned long failcnt;
+	struct misc_cg *cg = css_misc(seq_css(sf));
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
+		failcnt = atomic_long_read(&cg->nr_failed[i]);
+		if (READ_ONCE(misc_res_capacity[i]) || failcnt)
+			seq_printf(sf, "%s %lu\n", misc_res_name[i], failcnt);
+	}
+
+	return 0;
+}
+
 /* Misc cgroup interface files */
 static struct cftype misc_cg_files[] = {
 	{
@@ -404,6 +428,32 @@ static struct cftype misc_cg_files[] = {
 	{}
 };
 
+/* Misc cgroup interface files for v1*/
+static struct cftype misc_cg_legacy_files[] = {
+	{
+		.name = "max",
+		.write = misc_cg_max_write,
+		.seq_show = misc_cg_max_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "current",
+		.seq_show = misc_cg_current_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "capacity",
+		.seq_show = misc_cg_capacity_show,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+	},
+	{
+		.name = "failcnt",
+		.seq_show = misc_cg_failcnt_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{}
+};
+
 /**
  * misc_cg_alloc() - Allocate misc cgroup.
  * @parent_css: Parent cgroup.
@@ -450,6 +500,6 @@ static void misc_cg_free(struct cgroup_subsys_state *css)
 struct cgroup_subsys misc_cgrp_subsys = {
 	.css_alloc = misc_cg_alloc,
 	.css_free = misc_cg_free,
-	.legacy_cftypes = misc_cg_files,
+	.legacy_cftypes = misc_cg_legacy_files,
 	.dfl_cftypes = misc_cg_files,
 };
-- 
2.30.0

