From: shisiyuan <shisiyuan19870131@gmail.com>
Subject: [PATCH] cgroup: Return if dst_cgrp equals to src_cgrp
Date: Sat, 21 May 2022 01:02:00 +0800
Message-ID: <1653066120-21262-1-git-send-email-shisiyuan@xiaomi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=o1byCpdVQiUFM7RT5J0ZZS8QAIMgCRWQMbEspomVBfk=;
        b=nWUHNztiOOoUrsK+bcjZbH1T/aOSc5WBrgXM3LFXHuiNEWY/GAAuPkB8kcHQihNJZp
         o342F+m3+6/+5yGNwbS/DDkAQZ1Owt/aUdH4RGMbMgVR4uW2VrLv8X/+zeltewpsD1YS
         Y96YZEMWY7nqrZ/HCSenS/ploHDKuDPUIL9L9M0B3FCRe643CGAk2bc1bGRMZ+mWJ97U
         +amIFLkc/XaEbb/O9DHmfsKe5wJeV3yyG2ZrjffZKbo8P/yxIhzpH0OxsGQFuVrqE50K
         VdjHqHijuIonv7Fy0C/rKErW42y2hE3ul7mzN7qEcfIHRgInZVg/gRQ2IAiH88yUcjYQ
         fj/g==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: shisiyuan <shisiyuan@xiaomi.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

In function cgroup_migrate_add_src(), if dst_cgrp
equals to src_cgroup which the tasks link, dont
go on migrating tasks to another css_set.
This can save the cost of unnecessary migration.

Signed-off-by: shisiyuan <shisiyuan@xiaomi.com>
---
 kernel/cgroup/cgroup.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6139460..97d7f68 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2634,6 +2634,9 @@ void cgroup_migrate_add_src(struct css_set *src_cset,
 
 	src_cgrp = cset_cgroup_from_root(src_cset, dst_cgrp->root);
 
+	if (src_cgrp == dst_cgrp)
+		return;
+
 	if (!list_empty(&src_cset->mg_preload_node))
 		return;
 
@@ -2780,6 +2783,9 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 	rcu_read_unlock();
 	spin_unlock_irq(&css_set_lock);
 
+	if (list_empty(&mgctx.preloaded_src_csets))
+		return ret;
+
 	/* prepare dst csets and commit */
 	ret = cgroup_migrate_prepare_dst(&mgctx);
 	if (!ret)
@@ -2927,7 +2933,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	struct cgroup_subsys_state *d_css;
 	struct cgroup *dsct;
 	struct css_set *src_cset;
-	int ret;
+	int ret = 0;
 
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -2943,6 +2949,9 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	}
 	spin_unlock_irq(&css_set_lock);
 
+	if (list_empty(&mgctx.preloaded_src_csets))
+		goto out_finish;
+
 	/* NULL dst indicates self on default hierarchy */
 	ret = cgroup_migrate_prepare_dst(&mgctx);
 	if (ret)
-- 
2.7.4

