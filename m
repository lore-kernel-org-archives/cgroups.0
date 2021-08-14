From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] misc_cgroup: use a counter to count the number of failures
Date: Sat, 14 Aug 2021 08:15:16 +0800
Message-ID: <a09f381462b1ce9c506a22713b998e21b459f7e9.1628899295.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Xt4LhTfmIYJLNZv3Sql9WLAUI0QXOS6TD45Qib/plF0=;
        b=ULyQNxlRZbk30c63JGFG/iifhh8sARTJ8DYHaOoSdNw2OeOTtETxedxvne9rsjblxq
         fj0PylvbXCqT3p78s4MP/QxC5qMIerNDPcKU1B5wcdgl8iaf4QPvG7N3JDpuuRWlHv+X
         ZsFvhB+NM4/cNcFSSKLd9T077hHwf4CdsYAF1Ge9oO+LNerug25AYR/WXp+b740DXX9T
         ybdPuC62p8+hJinbaN5lhSS7p3bnN1Aa9Auuu19xOhvlWQLGhA8pPvG1Dvv89WbD5BFL
         rXMrlLkvQOK+1llQsgpaF3NurZ2G7JrdHF0A+dZEAdOkdBH8yCJyB1HJjOi/rxo/BdY9
         Xvhw==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

For a container, we only print an error log when the resource
charge fails. There may be some problems here:

1. If a large number of containers are created and deleted,
   there will be a lot of error logs.
2. According to an error log, we cannot better understand
   the actual pressure of resources.

Therefore, perhaps we should use a failcnt counter to count
the number of failures, so that we can easily understand the
actual pressure of resources and avoid too many error log..

v2: rename failcnt to nr_fails.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/misc_cgroup.h |  4 ++--
 kernel/cgroup/misc.c        | 37 ++++++++++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index da2367e..59706b2 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -31,12 +31,12 @@ enum misc_res_type {
  * struct misc_res: Per cgroup per misc type resource
  * @max: Maximum limit on the resource.
  * @usage: Current usage of the resource.
- * @failed: True if charged failed for the resource in a cgroup.
+ * @nr_fails: Failure count of the resource
  */
 struct misc_res {
 	unsigned long max;
 	atomic_long_t usage;
-	bool failed;
+	atomic_long_t nr_fails;
 };
 
 /**
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index ec02d96..c35477e 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -157,13 +157,7 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
 		new_usage = atomic_long_add_return(amount, &res->usage);
 		if (new_usage > READ_ONCE(res->max) ||
 		    new_usage > READ_ONCE(misc_res_capacity[type])) {
-			if (!res->failed) {
-				pr_info("cgroup: charge rejected by the misc controller for %s resource in ",
-					misc_res_name[type]);
-				pr_cont_cgroup_path(i->css.cgroup);
-				pr_cont("\n");
-				res->failed = true;
-			}
+			atomic_long_inc(&res->nr_fails);
 			ret = -EBUSY;
 			goto err_charge;
 		}
@@ -312,6 +306,29 @@ static int misc_cg_current_show(struct seq_file *sf, void *v)
 }
 
 /**
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
+	unsigned long nr_fails;
+	struct misc_cg *cg = css_misc(seq_css(sf));
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
+		nr_fails = atomic_long_read(&cg->res[i].nr_fails);
+		if (READ_ONCE(misc_res_capacity[i]) || nr_fails)
+			seq_printf(sf, "%s %lu\n", misc_res_name[i], nr_fails);
+	}
+
+	return 0;
+}
+
+/**
  * misc_cg_capacity_show() - Show the total capacity of misc res on the host.
  * @sf: Interface file
  * @v: Arguments passed
@@ -349,6 +366,11 @@ static int misc_cg_capacity_show(struct seq_file *sf, void *v)
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
 	{
+		.name = "failcnt",
+		.seq_show = misc_cg_failcnt_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
 		.name = "capacity",
 		.seq_show = misc_cg_capacity_show,
 		.flags = CFTYPE_ONLY_ON_ROOT,
@@ -382,6 +404,7 @@ static int misc_cg_capacity_show(struct seq_file *sf, void *v)
 	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
 		WRITE_ONCE(cg->res[i].max, MAX_NUM);
 		atomic_long_set(&cg->res[i].usage, 0);
+		atomic_long_set(&cg->res[i].nr_fails, 0);
 	}
 
 	return &cg->css;
-- 
1.8.3.1

