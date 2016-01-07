From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] cgroup: convert cgroup_subsys flag fields to bool bitfields
Date: Thu,  7 Jan 2016 17:29:46 -0500
Message-ID: <1452205790-21331-3-git-send-email-tj@kernel.org>
References: <1452205790-21331-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J+mbftF1TXSygIgVdUnXEndZfRbD+1J1PbvvH13OAvM=;
        b=nosGNhpDzyLKpKc2uGHu0zXCXm1urxOjjMzzZy9iPglg/vcrq2t6jt4ZIvnRnYIgZL
         NNTTAjObIua5/csugxWYy9QlNctQcF1x0NXOHmQqHgnp8zoAEPNkJEkI37RYKDrU32Ly
         lrZZk1F4jlnEKVx3gaUJroIBlFt7HUJ/vEk6wa/IfPXSwzGMSMrPFjlbemWsOyhujo32
         l/49+N//bU9nTgeyXAyEm778jREOb4ifTSFwEUa+EkNfc9wHVDgEa3AGuPprI+Fn052i
         7pUWS5qitsmySJoXOuACpPi4UsiDt6scZPn3gd2XuDD3vqWYG7lfy8EKWF+w0mCQDF1n
         2+Dw==
In-Reply-To: <1452205790-21331-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, a.p.zijlstra@chello.nl, mingo@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/cgroup-defs.h | 6 +++---
 kernel/cpuset.c             | 2 +-
 kernel/sched/core.c         | 2 +-
 kernel/sched/cpuacct.c      | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 7f334c2..dc6f0ce 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -440,7 +440,7 @@ struct cgroup_subsys {
 	void (*free)(struct task_struct *task);
 	void (*bind)(struct cgroup_subsys_state *root_css);
 
-	int early_init;
+	bool early_init:1;
 
 	/*
 	 * If %false, this subsystem is properly hierarchical -
@@ -454,8 +454,8 @@ struct cgroup_subsys {
 	 * cases.  Eventually, all subsystems will be made properly
 	 * hierarchical and this will go away.
 	 */
-	bool broken_hierarchy;
-	bool warned_broken_hierarchy;
+	bool broken_hierarchy:1;
+	bool warned_broken_hierarchy:1;
 
 	/* the following two fields are initialized automtically during boot */
 	int id;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3e945fc..0cf412b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2065,7 +2065,7 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 	.attach		= cpuset_attach,
 	.bind		= cpuset_bind,
 	.legacy_cftypes	= files,
-	.early_init	= 1,
+	.early_init	= true,
 };
 
 /**
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7d2271..9a5b368 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8576,7 +8576,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
 	.legacy_cftypes	= cpu_files,
-	.early_init	= 1,
+	.early_init	= true,
 };
 
 #endif	/* CONFIG_CGROUP_SCHED */
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index dd7cbb5..2ddaebf 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -279,5 +279,5 @@ struct cgroup_subsys cpuacct_cgrp_subsys = {
 	.css_alloc	= cpuacct_css_alloc,
 	.css_free	= cpuacct_css_free,
 	.legacy_cftypes	= files,
-	.early_init	= 1,
+	.early_init	= true,
 };
-- 
2.5.0

