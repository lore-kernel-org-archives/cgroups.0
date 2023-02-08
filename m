From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] sched/psi: simplify cgroup psi retrieving
Date: Thu,  9 Feb 2023 00:16:53 +0800
Message-ID: <20230208161654.99556-2-ryncsn@gmail.com>
References: <20230208161654.99556-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CLR2LM9bOa8i4/I3y14C5vPCowOG7PM+DN198h0+VAs=;
        b=n87yh6bfvYPCTO66tuyXJeAxOYVtR5er8Gk+eHejQ2btZam1yZWJTqT47teGvikGq3
         phDI1MRYT59/UiaAWI2BUi+1Q4j2oVxq2XK3Ke0b25NlcjfyH1ieBcd5CkQ0WEvDGV+h
         vADCrHGRBuuIf+qtxatJPOUIB0SG13dfhTFR45h8JE/oJDeaTp08BAIcVxxJyQ8FmMI2
         4ZJDP/ie/FD8+Aq9LP0zmJrEW1D3ByYmyWYsj+f4RYb8Pidapbovhyko7B6avejII/Pw
         lqDBkiZyH32dIDkG+lGBV/qDRoa1L2jKFIsHQS71X8mq/n07nyo+77OHdYAd/MxQTufX
         0Y0g==
In-Reply-To: <20230208161654.99556-1-ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Since the only case where cgroup_psi should return psi_system instead of
the cgroup's psi_group is the root cgroup, just set root cgroup's psi to
point to psi_system to remove the if branch.

Signed-off-by: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/psi.h    | 2 +-
 kernel/cgroup/cgroup.c | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/psi.h b/include/linux/psi.h
index b029a847def1..9c3a1638b618 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -33,7 +33,7 @@ __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 #ifdef CONFIG_CGROUPS
 static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
 {
-	return cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
+	return cgrp->psi;
 }
 
 int psi_cgroup_alloc(struct cgroup *cgrp);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c099cf3fa02d..1491d63b06b6 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -163,7 +163,12 @@ static struct static_key_true *cgroup_subsys_on_dfl_key[] = {
 static DEFINE_PER_CPU(struct cgroup_rstat_cpu, cgrp_dfl_root_rstat_cpu);
 
 /* the default hierarchy */
-struct cgroup_root cgrp_dfl_root = { .cgrp.rstat_cpu = &cgrp_dfl_root_rstat_cpu };
+struct cgroup_root cgrp_dfl_root = {
+	.cgrp.rstat_cpu = &cgrp_dfl_root_rstat_cpu,
+#ifdef CONFIG_PSI
+	.cgrp.psi = &psi_system
+#endif
+};
 EXPORT_SYMBOL_GPL(cgrp_dfl_root);
 
 /*
-- 
2.39.1

