From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] misc_cgroup: use a counter to count the number of failures
Date: Fri, 13 Aug 2021 13:26:11 +0800
Message-ID: <1628832371-16382-1-git-send-email-brookxu.cn@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ifU4YaTP5glt6FA8YFBttr5ZK1KwGCdKH8AhfhzRPlY=;
        b=Yn9awT7NRJ0161QHid3jaXK6q4gbEX6V//YQ/PkbW8Ua7/JagfD/kOtV31f7tiJsT+
         4N/PNCwMchIlP+oFMTVYBTJrY52Ay75KnmizoW7k+IO7GWMK9tgdAFo8Sr73bFXIncA5
         Rwf5sTzNGLB6m0V/63Vs4GIexfWMjqMyLZ6+8h9jhRcCdGjFRutvVyyQqahd+dBDofla
         ghEPhaya+Oi/KLsPAlwqHyZ7jt1svIi3Zw4jFj9MGZtxpcrV+g96L4isPY952XBRMEAi
         IKo8Lzqw0i+VWbG1+Xim1/U4nVadwEg1/vprQJTdpoANFoG70cPSU5zgmJUhMLZVKJ4D
         gfGA==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

This is a partial patch of the previous serial, which may
be useful, so I resend it.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/misc_cgroup.h |  4 ++--
 kernel/cgroup/misc.c        | 37 ++++++++++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 8450a5e..32f6fc0 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -32,12 +32,12 @@ enum misc_res_type {
  * struct misc_res: Per cgroup per misc type resource
  * @max: Maximum limit on the resource.
  * @usage: Current usage of the resource.
- * @failed: True if charged failed for the resource in a cgroup.
+ * @failcnt: Failure count of the resource
  */
 struct misc_res {
 	unsigned long max;
 	atomic_long_t usage;
-	bool failed;
+	atomic_long_t failcnt;
 };
 
 /**
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 5d51b8e..1057901 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -158,13 +158,7 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
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
+			atomic_long_inc(&res->failcnt);
 			ret = -EBUSY;
 			goto err_charge;
 		}
@@ -313,6 +307,29 @@ static int misc_cg_current_show(struct seq_file *sf, void *v)
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
+/**
  * misc_cg_capacity_show() - Show the total capacity of misc res on the host.
  * @sf: Interface file
  * @v: Arguments passed
@@ -350,6 +367,11 @@ static int misc_cg_capacity_show(struct seq_file *sf, void *v)
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
@@ -383,6 +405,7 @@ static int misc_cg_capacity_show(struct seq_file *sf, void *v)
 	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
 		WRITE_ONCE(cg->res[i].max, MAX_NUM);
 		atomic_long_set(&cg->res[i].usage, 0);
+		atomic_long_set(&cg->res[i].failcnt, 0);
 	}
 
 	return &cg->css;
-- 
1.8.3.1

