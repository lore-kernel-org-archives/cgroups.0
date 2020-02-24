From: Qian Cai <cai@lca.pw>
Subject: [PATCH] cgroup: fix psi_show() crash on 32bit ino archs
Date: Sun, 23 Feb 2020 22:00:07 -0500
Message-ID: <20200224030007.3990-1-cai@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=axj+zYhKgui/GRpLokmGt4hkOovhk9D4qksINrRJ1Ak=;
        b=f419reAEsjTeJdGXZaoZyZpTiWQNTrZvDjlFHYNYo6hws9F1baASusMDFHpIAblfCn
         MDrLtDYdBa37g4PRqNh/MPFrxz5Z85DqSVa6Dzdzins0kWeNGM++kzZ0/peBTuhv9UYm
         aqGxFrqA+fqrkOxvGd/d+j1ZSxUtdy6ueQ5HDJ85/8FME2IJ4a9dzvWa2g8Srhpt9dSf
         561JzE6H7EI7d1vJtVqCtT6ZWFOhOjkAtZhzDP0P1Qvn7+S9o3evgs8TcB+UVGHp4XcP
         ATkJnrGXsGL3fYd3Qd07QCnJZ7a7tiJwhOXEUedVP4rxKZTn6s6ROrRoHLSPBHZS/RnR
         e2mA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>

Similar to the commit d7495343228f ("cgroup: fix incorrect
WARN_ON_ONCE() in cgroup_setup_root()"), cgroup_id(root_cgrp) does not
equal to 1 on 32bit ino archs which triggers all sorts of issues with
psi_show() on s390x. For example,

 BUG: KASAN: slab-out-of-bounds in collect_percpu_times+0x2d0/
 Read of size 4 at addr 000000001e0ce000 by task read_all/3667
 collect_percpu_times+0x2d0/0x798
 psi_show+0x7c/0x2a8
 seq_read+0x2ac/0x830
 vfs_read+0x92/0x150
 ksys_read+0xe2/0x188
 system_call+0xd8/0x2b4

Fix it by using cgroup_ino().

Fixes: 743210386c03 ("cgroup: use cgrp->kn->id as the cgroup ID")
Signed-off-by: Qian Cai <cai@lca.pw>
---
 kernel/cgroup/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 75f687301bbf..cd5f41289f7d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3542,21 +3542,21 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
 static int cgroup_io_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_id(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
 
 	return psi_show(seq, psi, PSI_IO);
 }
 static int cgroup_memory_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_id(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
 
 	return psi_show(seq, psi, PSI_MEM);
 }
 static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_id(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
 
 	return psi_show(seq, psi, PSI_CPU);
 }
-- 
2.21.0 (Apple Git-122.2)

