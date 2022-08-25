From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v4 08/10] sched/psi: consolidate cgroup_psi()
Date: Fri, 26 Aug 2022 00:41:09 +0800
Message-ID: <20220825164111.29534-9-zhouchengming@bytedance.com>
References: <20220825164111.29534-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=3dDUh515nbOqGsG/LfVzQC677KwPKHwRqNRxhOWX6cc=;
        b=NU1aKrdzuN6/Kk7ZJlXzbBU3CIdEo1joWwClSvj5lEoxy27kjb88T8rqu2WLk1jegG
         HeYyNmvy/HkWbpCbLqEJEhQ4Ulh2IOjxVmXE0LqKAMafjP/pRuMmt7lNJYCLnJlBhnZo
         qEr/fATAqaJWQUhApGNU1zlux5L7PC5U06ZvoqHBFBo4Eof4lx4s0c1uPeLoMil3tkC8
         nn1YXFB5EvF8jGhnWuKmDqn5LQxB7YgBMHSA9CNtLiNdoIefNFxH8zCpmSEO/yDFC1S+
         hhZvMxIeFMA8vOUHQvVTeUPqL6jSMPUVhOixmiibNU0IHdeMdFeOE/AxWARGilpi0ygW
         JNZw==
In-Reply-To: <20220825164111.29534-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

cgroup_psi() can't return psi_group for root cgroup, so we have many
open code "psi = cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi".

This patch move cgroup_psi() definition to <linux/psi.h>, in which
we can return psi_system for root cgroup, so can handle all cgroups.

Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/cgroup.h |  5 -----
 include/linux/psi.h    |  6 ++++++
 kernel/cgroup/cgroup.c | 10 +++++-----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7ed1fa7a6fc8..3c48753f2949 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -682,11 +682,6 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 	pr_cont_kernfs_path(cgrp->kn);
 }
 
-static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
-{
-	return cgrp->psi;
-}
-
 bool cgroup_psi_enabled(void);
 
 static inline void cgroup_init_kthreadd(void)
diff --git a/include/linux/psi.h b/include/linux/psi.h
index fffd229fbf19..362a74ca1d3b 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/poll.h>
 #include <linux/cgroup-defs.h>
+#include <linux/cgroup.h>
 
 struct seq_file;
 struct css_set;
@@ -30,6 +31,11 @@ __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 			poll_table *wait);
 
 #ifdef CONFIG_CGROUPS
+static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
+{
+	return cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
+}
+
 int psi_cgroup_alloc(struct cgroup *cgrp);
 void psi_cgroup_free(struct cgroup *cgrp);
 void cgroup_move_task(struct task_struct *p, struct css_set *to);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 371131a8b6f8..1d392c91ef95 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3657,21 +3657,21 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
 static int cgroup_io_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
+	struct psi_group *psi = cgroup_psi(cgrp);
 
 	return psi_show(seq, psi, PSI_IO);
 }
 static int cgroup_memory_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
+	struct psi_group *psi = cgroup_psi(cgrp);
 
 	return psi_show(seq, psi, PSI_MEM);
 }
 static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
+	struct psi_group *psi = cgroup_psi(cgrp);
 
 	return psi_show(seq, psi, PSI_CPU);
 }
@@ -3697,7 +3697,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 		return -EBUSY;
 	}
 
-	psi = cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
+	psi = cgroup_psi(cgrp);
 	new = psi_trigger_create(psi, buf, res);
 	if (IS_ERR(new)) {
 		cgroup_put(cgrp);
@@ -3735,7 +3735,7 @@ static ssize_t cgroup_cpu_pressure_write(struct kernfs_open_file *of,
 static int cgroup_irq_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
+	struct psi_group *psi = cgroup_psi(cgrp);
 
 	return psi_show(seq, psi, PSI_IRQ);
 }
-- 
2.37.2

