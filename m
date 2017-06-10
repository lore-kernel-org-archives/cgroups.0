From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 10/10] sched: Make cpu/cpuacct threaded controllers
Date: Sat, 10 Jun 2017 10:03:51 -0400
Message-ID: <20170610140351.10703-11-tj@kernel.org>
References: <20170610140351.10703-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4wgk2IvDMI6yahhtFO556YSl73IstdMRe0XVfZNYamQ=;
        b=KUg03yEfCLNxzXPs8OlINmsf697j8AEouRdjHh5KLCd1q2NxES7lhErMrU70reTxLl
         v1r16MukTOJGRWsmfz1taSWTvs8fIMvrfQq3oZki/wb2RjksNxAMxyjcpMGhqsjJXxG6
         n8yxvisUQYEBD7MXkTkkKP4KK6FdevR4tbjkny0EenWcwCyTtPBnuYcrzFkbPhlw/y5b
         gfHLeBB6+kK0LtHSKQ83VJK4EEmROZfOnqiBCdw8xtdU1yGLhPcPX5xXxoVWajW848kS
         R3VcPorDef2xjRGL8daGSMidBFtJMRRW0mWq29mDUTa3sEZyt9lliLUoNa2LFUrRB556
         l8Jg==
In-Reply-To: <20170610140351.10703-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Make cpu and cpuacct cgroup controllers usable within a threaded cgroup.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/core.c    | 1 +
 kernel/sched/cpuacct.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c86ab2c4ed3b..85e5358da560 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7469,6 +7469,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.legacy_cftypes	= cpu_legacy_files,
 	.dfl_cftypes	= cpu_files,
 	.early_init	= true,
+	.threaded	= true,
 #ifdef CONFIG_CGROUP_CPUACCT
 	/*
 	 * cpuacct is enabled together with cpu on the unified hierarchy
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 07ed36cc2600..ee4976a5dde0 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -412,4 +412,5 @@ struct cgroup_subsys cpuacct_cgrp_subsys = {
 	.css_free	= cpuacct_css_free,
 	.legacy_cftypes	= files,
 	.early_init	= true,
+	.threaded	= true,
 };
-- 
2.13.0
