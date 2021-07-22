From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 2/3] misc_cgroup: add failcnt counter
Date: Thu, 22 Jul 2021 17:38:39 +0800
Message-ID: <cba4e118c342f55097c1fa5c255b26bfb2609590.1626946231.git.brookxu@tencent.com>
References: <4775e8d187920399403b296f8bb11bd687688671.1626946231.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=nKxDmYGABfohxuLPargQrpGLtl0A5Dtlbr1nooTegnQ=;
        b=g9utncxrFENx5WtS0n5EfMZODNjhHJhohBuVEnt+qGOu0OyE3OqQcowfdM8xyUql8G
         llqpdWyG0BXOPhxfGJDuJZ1eCXqDwb2OO9I9KTOsIFId161sb/uzzHeZahCJdFXo6D9X
         ERCrepOY8r5oa6/vxNTsH9DA5xwh0Bwjagj6/1sNtTcAOPRaUKP/krpydLlangx0uGx1
         by++XA7z9chJkgk8dx1TK2VQvvS+ulelKEFc/bIUsHQkmZQKFf4GPr6pvDzvEb4x3Jaf
         DWgfxO+DjaQ11C6rp076IG1WiHPyh4rSxwK5gdsUm9u1c5b9ITNiFjlsQCHYdYCioAYc
         wRXg==
In-Reply-To: <4775e8d187920399403b296f8bb11bd687688671.1626946231.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <4775e8d187920399403b296f8bb11bd687688671.1626946231.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <4775e8d187920399403b296f8bb11bd687688671.1626946231.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Instead of printing logs, we should probably track failures through
a failcnt counter, similar to mem_cgroup.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/misc_cgroup.h |  1 +
 kernel/cgroup/misc.c        | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 8450a5e66de0..dd1a786f39b8 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -37,6 +37,7 @@ struct misc_cg;
 struct misc_res {
 	unsigned long max;
 	atomic_long_t usage;
+	atomic_long_t failcnt;
 	bool failed;
 };
 
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 5d51b8eeece6..7c568b619f82 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -165,6 +165,7 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
 				pr_cont("\n");
 				res->failed = true;
 			}
+			atomic_long_inc(&res->failcnt);
 			ret = -EBUSY;
 			goto err_charge;
 		}
@@ -312,6 +313,29 @@ static int misc_cg_current_show(struct seq_file *sf, void *v)
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
+		failcnt = atomic_long_read(&cg->res[i].failcnt);
+		if (READ_ONCE(misc_res_capacity[i]) || failcnt)
+			seq_printf(sf, "%s %lu\n", misc_res_name[i], failcnt);
+	}
+
+	return 0;
+}
+
 /**
  * misc_cg_capacity_show() - Show the total capacity of misc res on the host.
  * @sf: Interface file
@@ -349,6 +373,11 @@ static struct cftype misc_cg_files[] = {
 		.seq_show = misc_cg_current_show,
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
+	{
+		.name = "failcnt",
+		.seq_show = misc_cg_failcnt_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{
 		.name = "capacity",
 		.seq_show = misc_cg_capacity_show,
@@ -383,6 +412,7 @@ misc_cg_alloc(struct cgroup_subsys_state *parent_css)
 	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
 		WRITE_ONCE(cg->res[i].max, MAX_NUM);
 		atomic_long_set(&cg->res[i].usage, 0);
+		atomic_long_set(&cg->res[i].failcnt, 0);
 	}
 
 	return &cg->css;
-- 
2.30.0

