From: Chen Zhou <chenzhou10@huawei.com>
Subject: [PATCH] cgroup: fix function name in comment
Date: Fri, 10 Jan 2020 15:23:20 +0800
Message-ID: <20200110072320.85605-1-chenzhou10@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, chenzhou10@huawei.com

Function name cgroup_rstat_cpu_pop_upated() in comment should be
cgroup_rstat_cpu_pop_updated().

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 kernel/cgroup/rstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index b48b22d..6f87352 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -33,7 +33,7 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 		return;
 
 	/*
-	 * Paired with the one in cgroup_rstat_cpu_pop_upated().  Either we
+	 * Paired with the one in cgroup_rstat_cpu_pop_updated().  Either we
 	 * see NULL updated_next or they see our updated stat.
 	 */
 	smp_mb();
-- 
2.7.4

