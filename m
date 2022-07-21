From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 8/9] sched/psi: add kernel cmdline parameter psi_inner_cgroup
Date: Thu, 21 Jul 2022 12:04:38 +0800
Message-ID: <20220721040439.2651-9-zhouchengming@bytedance.com>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=chxgxgcpZm63zsd7qnwFUE6j0UUhwVxho98X19IjMdE=;
        b=MEqNBgP7agly9aS2Azra3w7VOxdjKrzITB65iYsv3NXbBBWm7HIegWxDU49K4BpbH1
         upu756UW+/g2v32lOG9VTubX3HCXZh4vdPmCLXyUcqTpp7LbUW3NBWRJB6sZ1dEz+9ax
         jLNPgIjfXX6x9qBkQEK+58do+zhoAlNUgAX7FEaaWcVrKLvW/1xA/CB4mwIZAR9wDsMm
         afAYO+RCU73xoMk/QP/DkmQSf3RstJQzsQzDCn07vnpAKmP8Y9Jyd9PXnblNfbBeLgiE
         ZFyMRwUN+WkXIe4M195SuIyrHTNTA04IEImzh2fl5Myw1YCVj/LGvPfEEQsF2ARkZEwa
         hbYA==
In-Reply-To: <20220721040439.2651-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

PSI accounts stalls for each cgroup separately and aggregates it
at each level of the hierarchy. This may case non-negligible overhead
for some workloads when under deep level of the hierarchy.

commit 3958e2d0c34e ("cgroup: make per-cgroup pressure stall tracking configurable")
make PSI to skip per-cgroup stall accounting, only account system-wide
to avoid this each level overhead.

For our use case, we also want leaf cgroup PSI accounted for userspace
adjustment on that cgroup, apart from only system-wide management.

So this patch add kernel cmdline parameter "psi_inner_cgroup" to control
whether or not to account for inner cgroups, which is default to true
for compatibility.

Performance test on Intel Xeon Platinum with 3 levels of cgroup:

1. default (psi_inner_cgroup=true)

$ perf bench sched all
 # Running sched/messaging benchmark...
 # 20 sender and receiver processes per group
 # 10 groups == 400 processes run

     Total time: 0.032 [sec]

 # Running sched/pipe benchmark...
 # Executed 1000000 pipe operations between two processes

     Total time: 7.758 [sec]

       7.758354 usecs/op
         128893 ops/sec

2. psi_inner_cgroup=false

$ perf bench sched all
 # Running sched/messaging benchmark...
 # 20 sender and receiver processes per group
 # 10 groups == 400 processes run

     Total time: 0.032 [sec]

 # Running sched/pipe benchmark...
 # Executed 1000000 pipe operations between two processes

     Total time: 7.309 [sec]

       7.309436 usecs/op
         136809 ops/sec

Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  6 ++++++
 kernel/sched/psi.c                              | 11 ++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 8090130b544b..6beef5b8bc36 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4419,6 +4419,12 @@
 			tracking.
 			Format: <bool>
 
+	psi_inner_cgroup=
+			[KNL] Enable or disable pressure stall information
+			tracking for the inner cgroups.
+			Format: <bool>
+			default: enabled
+
 	psmouse.proto=	[HW,MOUSE] Highest PS2 mouse protocol extension to
 			probe for; one of (bare|imps|exps|lifebook|any).
 	psmouse.rate=	[HW,MOUSE] Set desired mouse report rate, in reports
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 2228cbf3bdd3..8d76920f47b3 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -147,12 +147,21 @@ static bool psi_enable;
 #else
 static bool psi_enable = true;
 #endif
+
+static bool psi_inner_cgroup __read_mostly = true;
+
 static int __init setup_psi(char *str)
 {
 	return kstrtobool(str, &psi_enable) == 0;
 }
 __setup("psi=", setup_psi);
 
+static int __init setup_psi_inner_cgroup(char *str)
+{
+	return kstrtobool(str, &psi_inner_cgroup) == 0;
+}
+__setup("psi_inner_cgroup=", setup_psi_inner_cgroup);
+
 /* Running averages - we need to be higher-res than loadavg */
 #define PSI_FREQ	(2*HZ+1)	/* 2 sec intervals */
 #define EXP_10s		1677		/* 1/exp(2s/10s) as fixed-point */
@@ -958,7 +967,7 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
 	group_init(&cgroup->psi);
 
 	parent = cgroup_parent(cgroup);
-	if (parent && cgroup_parent(parent))
+	if (parent && cgroup_parent(parent) && psi_inner_cgroup)
 		cgroup->psi.parent = cgroup_psi(parent);
 	else
 		cgroup->psi.parent = &psi_system;
-- 
2.36.1

