From: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] cgroup/rstat: record the cumulative per-cpu time of cgroup and its descendants
Date: Mon, 17 Jul 2023 17:36:12 +0800
Message-ID: <20230717093612.40846-1-jiahao.os@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689586656; x=1692178656;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qt43AGwP78WC80RAn41rmisnWae//0xO36ekfLuw42c=;
        b=jC7fae8lFjyqrJWA2LzQPl6FbH1OzsT5Gc9737HZWMKXRD8pS+FDesVLzG0MQUqivh
         kl0w0WfhfNnUmT2cbdRlls0wJchGwg894mxP/5U0yarwfQgprEiVOnnwfmnHohS1jZSW
         j87ESoEDgVl+b4VDIsU5ca1jtHsLvptabPi+ZnzFRa3j6DfGYqKs/18Zme/MQdY6nH/O
         LbhS023WhlvCRp50+HcW6ViDqX6PaIOYyw0PGCdNGbKwtmrs29t8xq7FwNPsgOT6Z0tG
         XR6uUb3PxyTKPdpOIoiLAzWTe7TZZhXf8qC5Jq99z9ah1ypSPMuES/nvhj5TOAPtn5wl
         IZ6A==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Now the member variable bstat of the structure cgroup_rstat_cpu
records the per-cpu time of the cgroup itself, but does not
include the per-cpu time of its descendants. The per-cpu time
including descendants is very useful for calculating the
per-cpu usage of cgroups.

Although we can indirectly obtain the total per-cpu time
of the cgroup and its descendants by accumulating the per-cpu
bstat of each descendant of the cgroup. But after a child cgroup
is removed, we will lose its bstat information. This will cause
the cumulative value to be non-monotonic, thus affecting
the accuracy of cgroup per-cpu usage.

So we add the cumul_bstat variable to record the total
per-cpu time of this cgroup and its descendants, which is
similar to "cpuacct.usage*" in cgroup v1. And this is
also helpful for the migration from cgroup v1 to cgroup v2.
After adding this variable, we can obtain the per-cpu time of
cgroup and its descendants in user mode through eBPF, etc.

Signed-off-by: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/cgroup-defs.h | 3 +++
 kernel/cgroup/rstat.c       | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8a0d5466c7be..25114d62089e 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -341,6 +341,9 @@ struct cgroup_rstat_cpu {
 	 */
 	struct cgroup_base_stat last_bstat;
 
+	/* Record the cumulative per-cpu time of cgroup and its descendants */
+	struct cgroup_base_stat cumul_bstat;
+
 	/*
 	 * Child cgroups with stat updates on this cpu since the last read
 	 * are linked on the parent's ->updated_children through
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 2542c21b6b6d..7c0ddd2e90d7 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -361,11 +361,15 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
 	cgroup_base_stat_sub(&delta, &rstatc->last_bstat);
 	cgroup_base_stat_add(&cgrp->bstat, &delta);
 	cgroup_base_stat_add(&rstatc->last_bstat, &delta);
+	cgroup_base_stat_add(&rstatc->cumul_bstat, &delta);
 
 	/* propagate global delta to parent (unless that's root) */
 	if (cgroup_parent(parent)) {
 		delta = cgrp->bstat;
+		rstatc = cgroup_rstat_cpu(parent, cpu);
+
 		cgroup_base_stat_sub(&delta, &cgrp->last_bstat);
+		cgroup_base_stat_add(&rstatc->cumul_bstat, &delta);
 		cgroup_base_stat_add(&parent->bstat, &delta);
 		cgroup_base_stat_add(&cgrp->last_bstat, &delta);
 	}
-- 
2.37.0

